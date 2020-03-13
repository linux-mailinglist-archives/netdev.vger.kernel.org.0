Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2CE184F4A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 20:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgCMTaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 15:30:17 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48732 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgCMTaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 15:30:17 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1jCq0a-00045I-2o; Fri, 13 Mar 2020 15:30:12 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id 02DJK2h8003624;
        Fri, 13 Mar 2020 15:20:02 -0400
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id 02DJK09F003623;
        Fri, 13 Mar 2020 15:20:00 -0400
Date:   Fri, 13 Mar 2020 15:20:00 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH ethtool v3 00/25] initial netlink interface
 implementation for 5.6 release
Message-ID: <20200313192000.GA1230@tuxdriver.com>
References: <cover.1583513281.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 06, 2020 at 06:03:59PM +0100, Michal Kubecek wrote:
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
> Changes in v3:
> - fix build in a separate directory
> - drop unnecessary changes to Makefile.am
> 
> Changes in v2:
> - add support for permanent hardware addres ("ethtool -P", patch 20)
> - add support for pretty printing of netlink messages (patches 21-25)
> - make output of "ethtool <dev>" closer to ioctl implementation
> - load ETH_SS_MSG_CLASSES string set only if needed (patch 15)
> - two more kernel uapi header copies (patch 5)
> - support for rtnetlink socket and requests (needed for "ethtool -P")
> - some kerneldoc style comments

Sorry for the delays -- LGTM...thanks! Queued for next release...

John
 
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
>  Makefile.am                                  |   22 +-
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
>  37 files changed, 8096 insertions(+), 378 deletions(-)
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
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
