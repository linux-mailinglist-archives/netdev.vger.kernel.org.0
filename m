Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0180512904F
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 00:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfLVXpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 18:45:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:55136 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfLVXpV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Dec 2019 18:45:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DF99FABEA;
        Sun, 22 Dec 2019 23:45:17 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 0BD5DE03A8; Mon, 23 Dec 2019 00:45:14 +0100 (CET)
Message-Id: <cover.1577052887.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v8 00/14] ethtool netlink interface, part 1
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Dec 2019 00:45:14 +0100 (CET)
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
interface is in Documentation/networking/ethtool-netlink.rst file. The
netlink interface is optional, it is built when CONFIG_ETHTOOL_NETLINK
(bool) option is enabled.

There are three types of request messages distinguished by suffix "_GET"
(query for information), "_SET" (modify parameters) and "_ACT" (perform an
action). Kernel reply messages have name with additional suffix "_REPLY"
(e.g. ETHTOOL_MSG_SETTINGS_GET_REPLY). Most "_SET" and "_ACT" message types
do not have matching reply type as only some of them need additional reply
data beyond numeric error code and extack. Kernel also broadcasts
notification messages ("_NTF" suffix) on changes.

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
  handler in NIC driver but it is only in kernel and under RTNL lock
- reduce the number of name lists that need to be kept in sync between
  kernel and userspace (e.g. recognized link modes)
- where feasible, allow dump requests to query specific information for all
  network devices
- as parsing and generating netlink messages is more complicated than
  simply copying data structures between userspace API and ethtool_ops
  handlers (which most ioctl commands do), split the code into multiple
  files in net/ethtool directory; move net/core/ethtool.c also to this
  directory and rename it to ioctl.c

Main changes between v7 and v8:

- preliminary patches sent as a separate series (already in net-next)
- split notification related changes out of _SET patches
- drop request specific flags from common header
- use FLAG/flag rather than GFLAG/gflag for global flags (as there are
  only global flags now)
- allow device names up to ALTIFNAMSIZ characters
- rename ETHTOOL_A_BITSET_LIST to ETHTOOL_A_BITSET_NOMASK
- rename ETHTOOL_A_BIT{,S}_* to ETHTOOL_A_BITSET_BIT{,S}_*
- use standard bitset helpers for link modes (rather than in-place
  conversion)
- use "default" rather than "standard" for unified _GET handlers
- fixed 64-bit big endian bitset code

Main changes between v6 and v7:

- split complex messages into small single purpose ones (drop info and
  request masks and one level of nesting)
- separate request information and reply data into two structures
- refactor bitset handling (no simultaneous u32/ulong handling but avoid
  kmalloc() except for long bitmaps on 64-bit big endian architectures)
- use only fixed size strings internally (will be replaced by char *
  eventually but that will require rewriting also existing ioctl code)
- rework ethnl_update_* helpers to return error code
- rename request flag constants (to ETHTOOL_[GR]FLAG_ prefix)
- convert documentation to rst

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


Michal Kubecek (14):
  ethtool: introduce ethtool netlink interface
  ethtool: helper functions for netlink interface
  ethtool: netlink bitset handling
  ethtool: support for netlink notifications
  ethtool: default handlers for GET requests
  ethtool: provide string sets with STRSET_GET request
  ethtool: provide link settings with LINKINFO_GET request
  ethtool: set link settings with LINKINFO_SET request
  ethtool: add default notification handler
  ethtool: add LINKINFO_NTF notification
  ethtool: provide link mode information with LINKMODES_GET request
  ethtool: set link modes related data with LINKMODES_SET request
  ethtool: add LINKMODES_NTF notification
  ethtool: provide link state with LINKSTATE_GET request

 Documentation/networking/ethtool-netlink.rst | 510 +++++++++++++
 include/linux/ethtool_netlink.h              |  17 +
 include/linux/netdevice.h                    |   9 +
 include/uapi/linux/ethtool.h                 |   3 +
 include/uapi/linux/ethtool_netlink.h         | 204 +++++
 net/Kconfig                                  |   8 +
 net/ethtool/Makefile                         |   7 +-
 net/ethtool/bitset.c                         | 735 +++++++++++++++++++
 net/ethtool/bitset.h                         |  28 +
 net/ethtool/common.c                         |  56 ++
 net/ethtool/common.h                         |   7 +
 net/ethtool/ioctl.c                          |  72 +-
 net/ethtool/linkinfo.c                       | 167 +++++
 net/ethtool/linkmodes.c                      | 377 ++++++++++
 net/ethtool/linkstate.c                      |  74 ++
 net/ethtool/netlink.c                        | 687 +++++++++++++++++
 net/ethtool/netlink.h                        | 341 +++++++++
 net/ethtool/strset.c                         | 425 +++++++++++
 18 files changed, 3672 insertions(+), 55 deletions(-)
 create mode 100644 Documentation/networking/ethtool-netlink.rst
 create mode 100644 include/linux/ethtool_netlink.h
 create mode 100644 include/uapi/linux/ethtool_netlink.h
 create mode 100644 net/ethtool/bitset.c
 create mode 100644 net/ethtool/bitset.h
 create mode 100644 net/ethtool/linkinfo.c
 create mode 100644 net/ethtool/linkmodes.c
 create mode 100644 net/ethtool/linkstate.c
 create mode 100644 net/ethtool/netlink.c
 create mode 100644 net/ethtool/netlink.h
 create mode 100644 net/ethtool/strset.c

-- 
2.24.1

