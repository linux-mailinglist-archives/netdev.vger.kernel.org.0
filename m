Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F0135538D
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343946AbhDFMVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:21:51 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34378 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343924AbhDFMVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:21:50 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A946C63E34;
        Tue,  6 Apr 2021 14:21:22 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/28] Netfilter updates for net-next
Date:   Tue,  6 Apr 2021 14:21:05 +0200
Message-Id: <20210406122133.1644-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following batch contains Netfilter/IPVS updates for your net-next tree:

1) Simplify log infrastructure modularity: Merge ipv4, ipv6, bridge,
   netdev and ARP families to nf_log_syslog.c. Add module softdeps.
   This fixes a rare deadlock condition that might occur when log
   module autoload is required. From Florian Westphal.

2) Moves part of netfilter related pernet data from struct net to
   net_generic() infrastructure. All of these users can be modules,
   so if they are not loaded there is no need to waste space. Size
   reduction is 7 cachelines on x86_64, also from Florian.

2) Update nftables audit support to report events once per table,
   to get it aligned with iptables. From Richard Guy Briggs.

3) Check for stale routes from the flowtable garbage collector path.
   This is fixing IPv6 which breaks due missing check for the dst_cookie.

4) Add a nfnl_fill_hdr() function to simplify netlink + nfnetlink
   headers setup.

5) Remove documentation on several statified functions.

6) Remove printk on netns creation for the FTP IPVS tracker,
   from Florian Westphal.

7) Remove unnecessary nf_tables_destroy_list_lock spinlock
   initialization, from Yang Yingliang.

7) Remove a duplicated forward declaration in ipset,
   from Wan Jiabing.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit cda1893e9f7c1d78e391dbb6ef1798cd32354113:

  net: mhi: remove pointless conditional before kfree_skb() (2021-03-30 13:47:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to db3685b4046f8b629bbf73caa33751ce567ea8ff:

  net: remove obsolete members from struct net (2021-04-06 00:34:53 +0200)

----------------------------------------------------------------
Dan Carpenter (1):
      netfilter: nftables: fix a warning message in nf_tables_commit_audit_collect()

Florian Westphal (20):
      netfilter: nf_log_ipv4: rename to nf_log_syslog
      netfilter: nf_log_arp: merge with nf_log_syslog
      netfilter: nf_log_ipv6: merge with nf_log_syslog
      netfilter: nf_log_netdev: merge with nf_log_syslog
      netfilter: nf_log_bridge: merge with nf_log_syslog
      netfilter: nf_log_common: merge with nf_log_syslog
      netfilter: nf_log: add module softdeps
      netfilter: nft_log: perform module load from nf_tables
      netfilter: ipvs: do not printk on netns creation
      netfilter: nfnetlink: add and use nfnetlink_broadcast
      netfilter: nfnetlink: use net_generic infra
      netfilter: cttimeout: use net_generic infra
      netfilter: nf_defrag_ipv6: use net_generic infra
      netfilter: nf_defrag_ipv4: use net_generic infra
      netfilter: ebtables: use net_generic infra
      netfilter: nf_tables: use net_generic infra for transaction data
      netfilter: x_tables: move known table lists to net_generic infra
      netfilter: conntrack: move sysctl pointer to net_generic infra
      netfilter: conntrack: move ecache dwork to net_generic infra
      net: remove obsolete members from struct net

Pablo Neira Ayuso (4):
      netfilter: flowtable: dst_check() from garbage collector path
      netfilter: nftables: add helper function to set the base sequence number
      netfilter: add helper function to set up the nfnetlink header and use it
      netfilter: nftables: remove documentation on static functions

Richard Guy Briggs (1):
      audit: log nftables configuration change events once per table

Wan Jiabing (1):
      netfilter: ipset: Remove duplicate declaration

Yang Yingliang (1):
      netfilter: nftables: remove unnecessary spin_lock_init()

 include/linux/netfilter/ipset/ip_set.h      |    2 -
 include/linux/netfilter/nfnetlink.h         |   29 +
 include/net/net_namespace.h                 |    9 -
 include/net/netfilter/ipv6/nf_defrag_ipv6.h |    6 +
 include/net/netfilter/nf_conntrack.h        |    7 +
 include/net/netfilter/nf_conntrack_ecache.h |   33 +-
 include/net/netfilter/nf_flow_table.h       |    5 +-
 include/net/netfilter/nf_log.h              |   25 -
 include/net/netfilter/nf_tables.h           |   16 +
 include/net/netns/conntrack.h               |    4 -
 include/net/netns/netfilter.h               |    6 -
 include/net/netns/nftables.h                |    7 -
 include/net/netns/x_tables.h                |    1 -
 net/bridge/netfilter/Kconfig                |    4 -
 net/bridge/netfilter/Makefile               |    3 -
 net/bridge/netfilter/ebtables.c             |   39 +-
 net/bridge/netfilter/nf_log_bridge.c        |   79 --
 net/ipv4/netfilter/Kconfig                  |   10 +-
 net/ipv4/netfilter/Makefile                 |    4 -
 net/ipv4/netfilter/nf_defrag_ipv4.c         |   20 +-
 net/ipv4/netfilter/nf_log_arp.c             |  172 -----
 net/ipv4/netfilter/nf_log_ipv4.c            |  395 ----------
 net/ipv6/netfilter/Kconfig                  |    5 +-
 net/ipv6/netfilter/Makefile                 |    3 -
 net/ipv6/netfilter/nf_conntrack_reasm.c     |   68 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   |   15 +-
 net/ipv6/netfilter/nf_log_ipv6.c            |  427 -----------
 net/netfilter/Kconfig                       |   20 +-
 net/netfilter/Makefile                      |    6 +-
 net/netfilter/ipset/ip_set_core.c           |   17 +-
 net/netfilter/ipvs/ip_vs_ftp.c              |    2 -
 net/netfilter/nf_conntrack_core.c           |    7 +-
 net/netfilter/nf_conntrack_ecache.c         |   31 +-
 net/netfilter/nf_conntrack_netlink.c        |   77 +-
 net/netfilter/nf_conntrack_standalone.c     |   10 +-
 net/netfilter/nf_flow_table_core.c          |   37 +-
 net/netfilter/nf_flow_table_ip.c            |   22 +-
 net/netfilter/nf_log.c                      |   10 -
 net/netfilter/nf_log_common.c               |  224 ------
 net/netfilter/nf_log_netdev.c               |   78 --
 net/netfilter/nf_log_syslog.c               | 1089 +++++++++++++++++++++++++++
 net/netfilter/nf_tables_api.c               |  632 ++++++++--------
 net/netfilter/nf_tables_offload.c           |   30 +-
 net/netfilter/nf_tables_trace.c             |    9 +-
 net/netfilter/nfnetlink.c                   |   67 +-
 net/netfilter/nfnetlink_acct.c              |   14 +-
 net/netfilter/nfnetlink_cthelper.c          |   11 +-
 net/netfilter/nfnetlink_cttimeout.c         |   63 +-
 net/netfilter/nfnetlink_log.c               |   11 +-
 net/netfilter/nfnetlink_queue.c             |   12 +-
 net/netfilter/nft_chain_filter.c            |   11 +-
 net/netfilter/nft_compat.c                  |   11 +-
 net/netfilter/nft_dynset.c                  |    6 +-
 net/netfilter/nft_log.c                     |   20 +-
 net/netfilter/x_tables.c                    |   46 +-
 net/netfilter/xt_LOG.c                      |    1 +
 net/netfilter/xt_NFLOG.c                    |    1 +
 net/netfilter/xt_TRACE.c                    |    1 +
 58 files changed, 1910 insertions(+), 2060 deletions(-)
 delete mode 100644 net/bridge/netfilter/nf_log_bridge.c
 delete mode 100644 net/ipv4/netfilter/nf_log_arp.c
 delete mode 100644 net/ipv4/netfilter/nf_log_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nf_log_ipv6.c
 delete mode 100644 net/netfilter/nf_log_common.c
 delete mode 100644 net/netfilter/nf_log_netdev.c
 create mode 100644 net/netfilter/nf_log_syslog.c
