Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB7C17AEF9
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 20:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgCETaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 14:30:30 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56176 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgCETaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 14:30:30 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1j9wCK-0001rr-Vx; Thu, 05 Mar 2020 14:30:21 -0500
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id 025JOM0O004604;
        Thu, 5 Mar 2020 14:24:23 -0500
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id 025JOGV1004603;
        Thu, 5 Mar 2020 14:24:16 -0500
Date:   Thu, 5 Mar 2020 14:24:16 -0500
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH ethtool v2 00/25] initial netlink interface
 implementation for 5.6 release
Message-ID: <20200305192416.GA23804@tuxdriver.com>
References: <cover.1583347351.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 04, 2020 at 09:24:35PM +0100, Michal Kubecek wrote:
> This series adds initial support for ethtool netlink interface provided by
> kernel since 5.6-rc1. The traditional ioctl interface is still supported
> for compatibility with older kernels. The netlink interface and message
> formats are documented in Documentation/networking/ethtool-netlink.rst file
> in kernel source tree.
> 
> Netlink interface is preferred but ethtool falls back to ioctl if netlink
> interface is not available (i.e. the "ethtool" genetlink family is not
> registered). It also falls back if a particular command is not implemented
> in netlink (kernel returns -EOPNOTSUPP). This allows new ethtool versions
> to work with older kernel versions while support for ethool commands is
> added in steps.
> 
> The series aims to touch existing ioctl code as little as possible in the
> first phase to minimize the risk of introducing regressions. It is also
> possible to build ethtool without netlink support if --disable-netlink is
> passed to configure script. The most visible changes to existing code are
> 
>   - UAPI header copies are moved to uapi/ under original names
>   - some variables and functions which are going to be shared with netlink
>     code are moved from ethtool.c to common.c and common.h
>   - args[] array in ethtool.c was rewritten to use named initializers
> 
> Except for changes to main(), all netlink specific code is in a separate
> directory netlink/ and is divided into multiple files.
> 
> Changes in v2:
> - add support for permanent hardware addres ("ethtool -P", patch 20)
> - add support for pretty printing of netlink messages (patches 21-25)
> - make output of "ethtool <dev>" closer to ioctl implementation
> - two more kernel uapi header copies (patch 5)
> - support for rtnetlink socket and requests (needed for "ethtool -P")
> - some kerneldoc style comments
> 
> Michal Kubecek (25):
>   move UAPI header copies to a separate directory
>   update UAPI header copies
>   add --debug option to control debugging messages
>   use named initializers in command line option list
>   netlink: add netlink related UAPI header files
>   netlink: introduce the netlink interface
>   netlink: message buffer and composition helpers
>   netlink: netlink socket wrapper and helpers
>   netlink: initialize ethtool netlink socket
>   netlink: add support for string sets
>   netlink: add notification monitor
>   move shared code into a common file
>   netlink: add bitset helpers
>   netlink: partial netlink handler for gset (no option)
>   netlink: support getting wake-on-lan and debugging settings
>   netlink: add basic command line parsing helpers
>   netlink: add bitset command line parser handlers
>   netlink: add netlink handler for sset (-s)
>   netlink: support tests with netlink enabled
>   netlink: add handler for permaddr (-P)
>   netlink: support for pretty printing netlink messages
>   netlink: message format description for ethtool netlink
>   netlink: message format descriptions for genetlink control
>   netlink: message format descriptions for rtnetlink
>   netlink: use pretty printing for ethtool netlink messages
> 
>  Makefile.am                                  |   31 +-
>  common.c                                     |  145 +++
>  common.h                                     |   26 +
>  configure.ac                                 |   14 +-
>  ethtool.8.in                                 |   48 +-
>  ethtool.c                                    |  819 ++++++++------
>  internal.h                                   |   31 +-
>  netlink/bitset.c                             |  218 ++++
>  netlink/bitset.h                             |   26 +
>  netlink/desc-ethtool.c                       |  139 +++
>  netlink/desc-genlctrl.c                      |   56 +
>  netlink/desc-rtnl.c                          |   96 ++
>  netlink/extapi.h                             |   46 +
>  netlink/monitor.c                            |  229 ++++
>  netlink/msgbuff.c                            |  255 +++++
>  netlink/msgbuff.h                            |  117 ++
>  netlink/netlink.c                            |  216 ++++
>  netlink/netlink.h                            |   87 ++
>  netlink/nlsock.c                             |  405 +++++++
>  netlink/nlsock.h                             |   45 +
>  netlink/parser.c                             | 1058 ++++++++++++++++++
>  netlink/parser.h                             |  144 +++
>  netlink/permaddr.c                           |  114 ++
>  netlink/prettymsg.c                          |  237 ++++
>  netlink/prettymsg.h                          |  118 ++
>  netlink/settings.c                           |  955 ++++++++++++++++
>  netlink/strset.c                             |  297 +++++
>  netlink/strset.h                             |   25 +
>  test-cmdline.c                               |   29 +-
>  test-features.c                              |   11 +
>  ethtool-copy.h => uapi/linux/ethtool.h       |   17 +
>  uapi/linux/ethtool_netlink.h                 |  237 ++++
>  uapi/linux/genetlink.h                       |   89 ++
>  uapi/linux/if_link.h                         | 1051 +++++++++++++++++
>  net_tstamp-copy.h => uapi/linux/net_tstamp.h |   27 +
>  uapi/linux/netlink.h                         |  248 ++++
>  uapi/linux/rtnetlink.h                       |  777 +++++++++++++
>  37 files changed, 8102 insertions(+), 381 deletions(-)
>  create mode 100644 common.c
>  create mode 100644 common.h
>  create mode 100644 netlink/bitset.c
>  create mode 100644 netlink/bitset.h
>  create mode 100644 netlink/desc-ethtool.c
>  create mode 100644 netlink/desc-genlctrl.c
>  create mode 100644 netlink/desc-rtnl.c
>  create mode 100644 netlink/extapi.h
>  create mode 100644 netlink/monitor.c
>  create mode 100644 netlink/msgbuff.c
>  create mode 100644 netlink/msgbuff.h
>  create mode 100644 netlink/netlink.c
>  create mode 100644 netlink/netlink.h
>  create mode 100644 netlink/nlsock.c
>  create mode 100644 netlink/nlsock.h
>  create mode 100644 netlink/parser.c
>  create mode 100644 netlink/parser.h
>  create mode 100644 netlink/permaddr.c
>  create mode 100644 netlink/prettymsg.c
>  create mode 100644 netlink/prettymsg.h
>  create mode 100644 netlink/settings.c
>  create mode 100644 netlink/strset.c
>  create mode 100644 netlink/strset.h
>  rename ethtool-copy.h => uapi/linux/ethtool.h (99%)
>  create mode 100644 uapi/linux/ethtool_netlink.h
>  create mode 100644 uapi/linux/genetlink.h
>  create mode 100644 uapi/linux/if_link.h
>  rename net_tstamp-copy.h => uapi/linux/net_tstamp.h (84%)
>  create mode 100644 uapi/linux/netlink.h
>  create mode 100644 uapi/linux/rtnetlink.h
> 
> -- 
> 2.25.1

Just a quick check -- executing "./autogen.sh ; ./configure ; make
distcheck" fails with the attached log output.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="make-distcheck.log"
Content-Transfer-Encoding: 8bit

make  dist-gzip am__post_remove_distdir='@:'
make[1]: Entering directory '/home/linville/git/ethtool'
make  distdir-am
make[2]: Entering directory '/home/linville/git/ethtool'
if test -d "ethtool-5.4"; then find "ethtool-5.4" -type d ! -perm -200 -exec chmod u+w {} ';' && rm -rf "ethtool-5.4" || { sleep 5 && rm -rf "ethtool-5.4"; }; else :; fi
test -d "ethtool-5.4" || mkdir "ethtool-5.4"
make  \
  top_distdir="ethtool-5.4" distdir="ethtool-5.4" \
  dist-hook
make[3]: Entering directory '/home/linville/git/ethtool'
cp ./ethtool.spec ethtool-5.4
make[3]: Leaving directory '/home/linville/git/ethtool'
test -n "" \
|| find "ethtool-5.4" -type d ! -perm -755 \
	-exec chmod u+rwx,go+rx {} \; -o \
  ! -type d ! -perm -444 -links 1 -exec chmod a+r {} \; -o \
  ! -type d ! -perm -400 -exec chmod a+r {} \; -o \
  ! -type d ! -perm -444 -exec /bin/sh /home/linville/git/ethtool/install-sh -c -m a+r {} {} \; \
|| chmod -R a+r "ethtool-5.4"
make[2]: Leaving directory '/home/linville/git/ethtool'
tardir=ethtool-5.4 && ${TAR-tar} chof - "$tardir" | eval GZIP= gzip --best -c >ethtool-5.4.tar.gz
make[1]: Leaving directory '/home/linville/git/ethtool'
if test -d "ethtool-5.4"; then find "ethtool-5.4" -type d ! -perm -200 -exec chmod u+w {} ';' && rm -rf "ethtool-5.4" || { sleep 5 && rm -rf "ethtool-5.4"; }; else :; fi
case 'ethtool-5.4.tar.gz' in \
*.tar.gz*) \
  eval GZIP= gzip --best -dc ethtool-5.4.tar.gz | ${TAR-tar} xf - ;;\
*.tar.bz2*) \
  bzip2 -dc ethtool-5.4.tar.bz2 | ${TAR-tar} xf - ;;\
*.tar.lz*) \
  lzip -dc ethtool-5.4.tar.lz | ${TAR-tar} xf - ;;\
*.tar.xz*) \
  xz -dc ethtool-5.4.tar.xz | ${TAR-tar} xf - ;;\
*.tar.Z*) \
  uncompress -c ethtool-5.4.tar.Z | ${TAR-tar} xf - ;;\
*.shar.gz*) \
  eval GZIP= gzip --best -dc ethtool-5.4.shar.gz | unshar ;;\
*.zip*) \
  unzip ethtool-5.4.zip ;;\
esac
chmod -R a-w ethtool-5.4
chmod u+w ethtool-5.4
mkdir ethtool-5.4/_build ethtool-5.4/_build/sub ethtool-5.4/_inst
chmod a-w ethtool-5.4
test -d ethtool-5.4/_build || exit 0; \
dc_install_base=`CDPATH="${ZSH_VERSION+.}:" && cd ethtool-5.4/_inst && pwd | sed -e 's,^[^:\\/]:[\\/],/,'` \
  && dc_destdir="${TMPDIR-/tmp}/am-dc-$$/" \
  && am__cwd=`pwd` \
  && CDPATH="${ZSH_VERSION+.}:" && cd ethtool-5.4/_build/sub \
  && ../../configure \
     \
     \
    --srcdir=../.. --prefix="$dc_install_base" \
  && make  \
  && make  dvi \
  && make  check \
  && make  install \
  && make  installcheck \
  && make  uninstall \
  && make  distuninstallcheck_dir="$dc_install_base" \
        distuninstallcheck \
  && chmod -R a-w "$dc_install_base" \
  && ({ \
       (cd ../.. && umask 077 && mkdir "$dc_destdir") \
       && make  DESTDIR="$dc_destdir" install \
       && make  DESTDIR="$dc_destdir" uninstall \
       && make  DESTDIR="$dc_destdir" \
            distuninstallcheck_dir="$dc_destdir" distuninstallcheck; \
      } || { rm -rf "$dc_destdir"; exit 1; }) \
  && rm -rf "$dc_destdir" \
  && make  dist \
  && rm -rf ethtool-5.4.tar.gz \
  && make  distcleancheck \
  && cd "$am__cwd" \
  || exit 1
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /usr/bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether make supports nested variables... yes
checking whether to enable maintainer-specific portions of Makefiles... no
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables... 
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking whether gcc understands -c and -o together... yes
checking whether make supports the include directive... yes (GNU style)
checking dependency style of gcc... gcc3
checking how to run the C preprocessor... gcc -E
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking whether gcc needs -traditional... no
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking whether <linux/types.h> defines big-endian types... yes
checking for ANSI C header files... yes
checking for socket... yes
checking for strtol... yes
checking for bash-completion directory... ${prefix}/share/bash-completion/completions
checking for pkg-config... (cached) /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for MNL... yes
checking that generated files are newer than configure... done
configure: creating ./config.status
config.status: creating Makefile
config.status: creating ethtool.spec
config.status: creating ethtool.8
config.status: creating ethtool-config.h
config.status: executing depfiles commands
make[1]: Entering directory '/home/linville/git/ethtool/ethtool-5.4/_build/sub'
make  all-am
make[2]: Entering directory '/home/linville/git/ethtool/ethtool-5.4/_build/sub'
gcc -DHAVE_CONFIG_H -I. -I../..    -I./uapi -Wall  -g -O2 -MT ethtool-ethtool.o -MD -MP -MF .deps/ethtool-ethtool.Tpo -c -o ethtool-ethtool.o `test -f 'ethtool.c' || echo '../../'`ethtool.c
../../ethtool.c: In function ‘do_get_phy_tunable’:
../../ethtool.c:4773:16: error: ‘ETHTOOL_PHY_EDPD’ undeclared (first use in this function); did you mean ‘ETHTOOL_PHYS_ID’?
 4773 |   cont.ds.id = ETHTOOL_PHY_EDPD;
      |                ^~~~~~~~~~~~~~~~
      |                ETHTOOL_PHYS_ID
../../ethtool.c:4773:16: note: each undeclared identifier is reported only once for each function it appears in
../../ethtool.c:4781:21: error: ‘ETHTOOL_PHY_EDPD_DISABLE’ undeclared (first use in this function); did you mean ‘ETHTOOL_PHY_STUNABLE’?
 4781 |   if (cont.msecs == ETHTOOL_PHY_EDPD_DISABLE)
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~
      |                     ETHTOOL_PHY_STUNABLE
../../ethtool.c:4783:26: error: ‘ETHTOOL_PHY_EDPD_NO_TX’ undeclared (first use in this function)
 4783 |   else if (cont.msecs == ETHTOOL_PHY_EDPD_NO_TX)
      |                          ^~~~~~~~~~~~~~~~~~~~~~
../../ethtool.c: In function ‘do_set_phy_tunable’:
../../ethtool.c:4962:25: error: ‘ETHTOOL_PHY_EDPD_DFLT_TX_MSECS’ undeclared (first use in this function)
 4962 |  u16 edpd_tx_interval = ETHTOOL_PHY_EDPD_DFLT_TX_MSECS;
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../../ethtool.c:5003:23: error: ‘ETHTOOL_PHY_EDPD_DISABLE’ undeclared (first use in this function); did you mean ‘ETHTOOL_PHY_STUNABLE’?
 5003 |    edpd_tx_interval = ETHTOOL_PHY_EDPD_DISABLE;
      |                       ^~~~~~~~~~~~~~~~~~~~~~~~
      |                       ETHTOOL_PHY_STUNABLE
../../ethtool.c:5005:23: error: ‘ETHTOOL_PHY_EDPD_NO_TX’ undeclared (first use in this function)
 5005 |    edpd_tx_interval = ETHTOOL_PHY_EDPD_NO_TX;
      |                       ^~~~~~~~~~~~~~~~~~~~~~
../../ethtool.c:5053:17: error: ‘ETHTOOL_PHY_EDPD’ undeclared (first use in this function); did you mean ‘ETHTOOL_PHYS_ID’?
 5053 |   cont.fld.id = ETHTOOL_PHY_EDPD;
      |                 ^~~~~~~~~~~~~~~~
      |                 ETHTOOL_PHYS_ID
make[2]: *** [Makefile:1255: ethtool-ethtool.o] Error 1
make[2]: Leaving directory '/home/linville/git/ethtool/ethtool-5.4/_build/sub'
make[1]: *** [Makefile:881: all] Error 2
make[1]: Leaving directory '/home/linville/git/ethtool/ethtool-5.4/_build/sub'
make: *** [Makefile:3670: distcheck] Error 1

--uAKRQypu60I7Lcqm--
