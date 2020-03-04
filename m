Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD5031799AD
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgCDUYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:24:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:33084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbgCDUYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:24:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3621CAE99;
        Wed,  4 Mar 2020 20:24:38 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id F1B6BE037F; Wed,  4 Mar 2020 21:24:35 +0100 (CET)
Message-Id: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 00/25] initial netlink interface implementation for
 5.6 release
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:24:35 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds initial support for ethtool netlink interface provided by
kernel since 5.6-rc1. The traditional ioctl interface is still supported
for compatibility with older kernels. The netlink interface and message
formats are documented in Documentation/networking/ethtool-netlink.rst file
in kernel source tree.

Netlink interface is preferred but ethtool falls back to ioctl if netlink
interface is not available (i.e. the "ethtool" genetlink family is not
registered). It also falls back if a particular command is not implemented
in netlink (kernel returns -EOPNOTSUPP). This allows new ethtool versions
to work with older kernel versions while support for ethool commands is
added in steps.

The series aims to touch existing ioctl code as little as possible in the
first phase to minimize the risk of introducing regressions. It is also
possible to build ethtool without netlink support if --disable-netlink is
passed to configure script. The most visible changes to existing code are

  - UAPI header copies are moved to uapi/ under original names
  - some variables and functions which are going to be shared with netlink
    code are moved from ethtool.c to common.c and common.h
  - args[] array in ethtool.c was rewritten to use named initializers

Except for changes to main(), all netlink specific code is in a separate
directory netlink/ and is divided into multiple files.

Changes in v2:
- add support for permanent hardware addres ("ethtool -P", patch 20)
- add support for pretty printing of netlink messages (patches 21-25)
- make output of "ethtool <dev>" closer to ioctl implementation
- two more kernel uapi header copies (patch 5)
- support for rtnetlink socket and requests (needed for "ethtool -P")
- some kerneldoc style comments

Michal Kubecek (25):
  move UAPI header copies to a separate directory
  update UAPI header copies
  add --debug option to control debugging messages
  use named initializers in command line option list
  netlink: add netlink related UAPI header files
  netlink: introduce the netlink interface
  netlink: message buffer and composition helpers
  netlink: netlink socket wrapper and helpers
  netlink: initialize ethtool netlink socket
  netlink: add support for string sets
  netlink: add notification monitor
  move shared code into a common file
  netlink: add bitset helpers
  netlink: partial netlink handler for gset (no option)
  netlink: support getting wake-on-lan and debugging settings
  netlink: add basic command line parsing helpers
  netlink: add bitset command line parser handlers
  netlink: add netlink handler for sset (-s)
  netlink: support tests with netlink enabled
  netlink: add handler for permaddr (-P)
  netlink: support for pretty printing netlink messages
  netlink: message format description for ethtool netlink
  netlink: message format descriptions for genetlink control
  netlink: message format descriptions for rtnetlink
  netlink: use pretty printing for ethtool netlink messages

 Makefile.am                                  |   31 +-
 common.c                                     |  145 +++
 common.h                                     |   26 +
 configure.ac                                 |   14 +-
 ethtool.8.in                                 |   48 +-
 ethtool.c                                    |  819 ++++++++------
 internal.h                                   |   31 +-
 netlink/bitset.c                             |  218 ++++
 netlink/bitset.h                             |   26 +
 netlink/desc-ethtool.c                       |  139 +++
 netlink/desc-genlctrl.c                      |   56 +
 netlink/desc-rtnl.c                          |   96 ++
 netlink/extapi.h                             |   46 +
 netlink/monitor.c                            |  229 ++++
 netlink/msgbuff.c                            |  255 +++++
 netlink/msgbuff.h                            |  117 ++
 netlink/netlink.c                            |  216 ++++
 netlink/netlink.h                            |   87 ++
 netlink/nlsock.c                             |  405 +++++++
 netlink/nlsock.h                             |   45 +
 netlink/parser.c                             | 1058 ++++++++++++++++++
 netlink/parser.h                             |  144 +++
 netlink/permaddr.c                           |  114 ++
 netlink/prettymsg.c                          |  237 ++++
 netlink/prettymsg.h                          |  118 ++
 netlink/settings.c                           |  955 ++++++++++++++++
 netlink/strset.c                             |  297 +++++
 netlink/strset.h                             |   25 +
 test-cmdline.c                               |   29 +-
 test-features.c                              |   11 +
 ethtool-copy.h => uapi/linux/ethtool.h       |   17 +
 uapi/linux/ethtool_netlink.h                 |  237 ++++
 uapi/linux/genetlink.h                       |   89 ++
 uapi/linux/if_link.h                         | 1051 +++++++++++++++++
 net_tstamp-copy.h => uapi/linux/net_tstamp.h |   27 +
 uapi/linux/netlink.h                         |  248 ++++
 uapi/linux/rtnetlink.h                       |  777 +++++++++++++
 37 files changed, 8102 insertions(+), 381 deletions(-)
 create mode 100644 common.c
 create mode 100644 common.h
 create mode 100644 netlink/bitset.c
 create mode 100644 netlink/bitset.h
 create mode 100644 netlink/desc-ethtool.c
 create mode 100644 netlink/desc-genlctrl.c
 create mode 100644 netlink/desc-rtnl.c
 create mode 100644 netlink/extapi.h
 create mode 100644 netlink/monitor.c
 create mode 100644 netlink/msgbuff.c
 create mode 100644 netlink/msgbuff.h
 create mode 100644 netlink/netlink.c
 create mode 100644 netlink/netlink.h
 create mode 100644 netlink/nlsock.c
 create mode 100644 netlink/nlsock.h
 create mode 100644 netlink/parser.c
 create mode 100644 netlink/parser.h
 create mode 100644 netlink/permaddr.c
 create mode 100644 netlink/prettymsg.c
 create mode 100644 netlink/prettymsg.h
 create mode 100644 netlink/settings.c
 create mode 100644 netlink/strset.c
 create mode 100644 netlink/strset.h
 rename ethtool-copy.h => uapi/linux/ethtool.h (99%)
 create mode 100644 uapi/linux/ethtool_netlink.h
 create mode 100644 uapi/linux/genetlink.h
 create mode 100644 uapi/linux/if_link.h
 rename net_tstamp-copy.h => uapi/linux/net_tstamp.h (84%)
 create mode 100644 uapi/linux/netlink.h
 create mode 100644 uapi/linux/rtnetlink.h

-- 
2.25.1

