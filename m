Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1481E5CEBC
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfGBLts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:49:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:38244 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbfGBLtp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:49:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B982AFC3;
        Tue,  2 Jul 2019 11:49:42 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 14187E0159; Tue,  2 Jul 2019 13:49:39 +0200 (CEST)
Message-Id: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 00/15] ethtool netlink interface, part 1
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:49:39 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is first part of netlink based alternative userspace interface for
ethtool. It aims to address some long known issues with the ioctl
interface, mainly lack of extensibility, raciness, limited error reporting
and absence of notifications. The goal is to allow userspace ethtool
utility to provide all features it currently does but without using the
ioctl interface. However, some features provided by ethtool ioctl API will
be available through other netlink interfaces (rtnetlink, devlink) if it's
more appropriate.

The interface uses generic netlink family "ethtool" and provides multicast
group "monitor" which is used for notifications. Documentation for the
interface is in Documentation/networking/ethtool-netlink.txt file. The
netlink interface is optional, it is built when CONFIG_ETHTOOL_NETLINK
(bool) option is enabled.

There are three types of request messages distinguished by suffix "_GET"
(query for information), "_SET" (modify parameters) and "_ACT" (perform an
action). Kernel reply messages have name with additional suffix "_REPLY"
(e.g. ETHTOOL_MSG_SETTINGS_GET_REPLY). Most "_SET" and "_ACT" message types
do not have matching reply type as only some of them need additional reply
data beyond numeric error code and extack.

Basic concepts:

- make extensions easier not only by allowing new attributes but also by
  imposing as few artificial limits as possible, e.g. by using arbitrary
  size bit sets for most bitmap attributes or by not using fixed size
  strings
- use extack for error reporting and warnings
- send netlink notifications on changes (even if they were done using the
  ioctl interface) and actions
- avoid the racy read/modify/write cycle between kernel and userspace by
  sending only attributes which userspace wants to change; there is still
  a read/modify/write cycle between generic kernel code and ethtool_ops
  handler in NIC driver but it is only in kernel and under a lock
- reduce the number of name lists that need to be kept in sync between
  kernel and userspace (e.g. recognized link modes)
- where feasible, allow dump requests to query specific information for all
  network devices
- as the lack of extensibility of the ioctl interface led to having too
  many commands, group some of them together to one netlink message but
  allow querying only part(s) of the information (using "info mask" bitmap)
  and modifying only some of the parameters (by providing only some
  attributes)
- as parsing and generating netlink messages is more complicated than
  simply copying data structures between userspace API and ethtool_ops
  handlers (which most ioctl commands do), split the code into multiple
  files in net/ethtool directory; move net/core/ethtool.c also to this
  directory and rename it to ioctl.c

The full (work in progress) series, together with the (userspace) ethtool
counterpart can be found at https://github.com/mkubecek/ethnl

Main changes between v5 and v6:

- use ETHTOOL_MSG_ prefix for message types
- replace ETHA_ prefix for netlink attributes by ETHTOOL_A_
- replace ETH_x_IM_y for infomask bits by ETHTOOL_IM_x_y
- split GET reply types from SET requests and notifications
- split kernel and userspace message types into different enums
- remove INFO_GET requests from submitted part
- drop EVENT notifications (use rtnetlink and on-demand string set load)
- reorganize patches to reduce the number of intermitent warnings
- unify request/reply header and its processing
- another nest around strings in a string set for consistency
- more consistent identifier naming
- coding style cleanup
- get rid of some of the helpers
- set bad attribute in extack where applicable
- various bug fixes
- improve documentation and code comments, more kerneldoc comments
- more verbose commit messages

Changes between v4 and v5:

- do not panic on failed initialization, only WARN()

Main changes between RFC v3 and v4:

- use more kerneldoc style comments
- strict attribute policy checking
- use macros for tables of link mode names and parameters
- provide permanent hardware address in rtnetlink
- coding style cleanup
- split too long patches, reorder
- wrap more ETHA_SETTINGS_* attributes in nests
- add also some SET_* implementation into submitted part

Main changes between RFC v2 and RFC v3:

- do not allow building as a module (no netdev notifiers needed)
- drop some obsolete fields
- add permanent hw address, timestamping and private flags support
- rework bitset handling to get rid of variable length arrays
- notify monitor on device renames
- restructure GET_SETTINGS/SET_SETTINGS messages
- split too long patches and submit only first part of the series

Main changes between RFC v1 and RFC v2:

- support dumps for all "get" requests
- provide notifications for changes related to supported request types
- support getting string sets (both global and per device)
- support getting/setting device features
- get rid of family specific header, everything passed as attributes
- split netlink code into multiple files in net/ethtool/ directory


Michal Kubecek (15):
  rtnetlink: provide permanent hardware address in RTM_NEWLINK
  netlink: rename nl80211_validate_nested() to nla_validate_nested()
  ethtool: move to its own directory
  ethtool: introduce ethtool netlink interface
  ethtool: helper functions for netlink interface
  ethtool: netlink bitset handling
  ethtool: support for netlink notifications
  ethtool: move string arrays into common file
  ethtool: generic handlers for GET requests
  ethtool: provide string sets with STRSET_GET request
  ethtool: provide link mode names as a string set
  ethtool: provide link settings and link modes in SETTINGS_GET request
  ethtool: add standard notification handler
  ethtool: set link settings and link modes with SETTINGS_SET request
  ethtool: provide link state in SETTINGS_GET request

 Documentation/networking/ethtool-netlink.txt | 399 ++++++++++
 include/linux/ethtool.h                      |   4 +
 include/linux/ethtool_netlink.h              |  17 +
 include/linux/netdevice.h                    |  12 +
 include/net/netlink.h                        |   8 +-
 include/uapi/linux/ethtool.h                 |   4 +
 include/uapi/linux/ethtool_netlink.h         | 219 ++++++
 include/uapi/linux/if_link.h                 |   1 +
 net/Kconfig                                  |   8 +
 net/Makefile                                 |   2 +-
 net/core/Makefile                            |   2 +-
 net/core/rtnetlink.c                         |   5 +
 net/ethtool/Makefile                         |   7 +
 net/ethtool/bitset.c                         | 606 +++++++++++++++
 net/ethtool/bitset.h                         |  40 +
 net/ethtool/common.c                         | 140 ++++
 net/ethtool/common.h                         |  24 +
 net/{core/ethtool.c => ethtool/ioctl.c}      | 157 +---
 net/ethtool/netlink.c                        | 762 +++++++++++++++++++
 net/ethtool/netlink.h                        | 302 ++++++++
 net/ethtool/settings.c                       | 628 +++++++++++++++
 net/ethtool/strset.c                         | 459 +++++++++++
 net/wireless/nl80211.c                       |   3 +-
 23 files changed, 3666 insertions(+), 143 deletions(-)
 create mode 100644 Documentation/networking/ethtool-netlink.txt
 create mode 100644 include/linux/ethtool_netlink.h
 create mode 100644 include/uapi/linux/ethtool_netlink.h
 create mode 100644 net/ethtool/Makefile
 create mode 100644 net/ethtool/bitset.c
 create mode 100644 net/ethtool/bitset.h
 create mode 100644 net/ethtool/common.c
 create mode 100644 net/ethtool/common.h
 rename net/{core/ethtool.c => ethtool/ioctl.c} (93%)
 create mode 100644 net/ethtool/netlink.c
 create mode 100644 net/ethtool/netlink.h
 create mode 100644 net/ethtool/settings.c
 create mode 100644 net/ethtool/strset.c

-- 
2.22.0

