# Copyright 2015 Hewlett-Packard Development Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# == Class: setproxy::git
#
# A class to manage Git proxy settings
class setproxy::git (
  $proxy_status    = 'disabled',
  $git_http_proxy  = undef,
  $git_https_proxy = undef,
  $git_proxy_port  = 8088,
  $gitproxy        = undef,
  $git_compression = 3,
) {

  if $proxy_status == 'enabled' {
    if ! defined(Package['socat']) {
      package { 'socat': ensure => installed, }
    }

    file { '/etc/gitconfig':
      ensure  => file,
      content => template('setproxy/gitconfig.erb'),
      owner   => 'root',
      mode    => '0644',
    }
    file { '/usr/local/bin/gitproxy':
      ensure  => file,
      content => template('setproxy/gitproxy.erb'),
      mode    => '0755',
    }
  } else {
    file { '/etc/profile.d/proxy.sh':
      ensure  => absent,
    }
  }
}

