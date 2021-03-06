require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Cybele #:nodoc:#

  # Public: This allows you to override entire operations, like the creation of the
  # Gemfile_new, README, or JavaScript files, without needing to know exactly
  # what those operations do so you can create another template action.
  class AppGenerator < Rails::Generators::AppGenerator

    # Internal: Default use postgresql
    class_option :database, :type => :string, :aliases => '-d', :default => 'postgresql',
                 :desc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    # Internal: Default skip Test::Unit
    class_option :skip_test_unit, :type => :boolean, :aliases => '-T', :default => true,
                 :desc => 'Skip Test::Unit files'

    # Internal: Finish template
    def finish_template
      invoke :customization
      super
    end

    # Internal: Customization template
    def customization
      invoke :customize_gemfile
      invoke :remove_files_we_dont_need
      invoke :replace_files
    end

    # Internal: Customize gemfile
    def customize_gemfile
      build :replace_gemfile
      bundle_command 'install --binstubs=bin/stubs'
    end

    # Internal: Remove files don't need
    def remove_files_we_dont_need
      say 'Remove files we don\'t need'
      build :remove_public_index
      build :remove_readme_rdoc
      build :remove_rails_logo_image
    end

    # Internal: Replace files
    def replace_files
      say 'Replace files'
      build :replace_erb_with_haml
    end

    # Internal: Let's not: We'll bundle manually at the right spot.
    def run_bundle
    end

    protected

    # Internal: We need get_builder class
    def get_builder_class
      Cybele::AppBuilder
    end
  end
end