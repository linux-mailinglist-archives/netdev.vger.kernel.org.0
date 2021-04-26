Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB7236B7A1
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbhDZRLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:11:45 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51454 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235066AbhDZRLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:42 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 88CCB63E81;
        Mon, 26 Apr 2021 19:10:23 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/22] Netfilter updates for net-next
Date:   Mon, 26 Apr 2021 19:10:34 +0200
Message-Id: <20210426171056.345271-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) The various ip(6)table_foo incarnations are updated to expect
   that the table is passed as 'void *priv' argument that netfilter core
   passes to the hook functions. This reduces the struct net size by 2
   cachelines on x86_64. From Florian Westphal.

2) Add cgroupsv2 support for nftables.

3) Fix bridge log family merge into nf_log_syslog: Missing
   unregistration from netns exit path, from Phil Sutter.

4) Add nft_pernet() helper to access nftables pernet area.

5) Add struct nfnl_info to reduce nfnetlink callback footprint and
   to facilite future updates. Consolidate nfnetlink callbacks.

6) Add CONFIG_NETFILTER_XTABLES_COMPAT Kconfig knob, also from Florian.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit b2f0ca00e6b34bd57c9298a869ea133699e8ec39:

  phy: nxp-c45-tja11xx: add interrupt support (2021-04-23 14:13:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 47a6959fa331fe892a4fc3b48ca08e92045c6bda:

  netfilter: allow to turn off xtables compat layer (2021-04-26 18:16:56 +0200)

----------------------------------------------------------------
Florian Westphal (15):
      netfilter: nat: move nf_xfrm_me_harder to where it is used
      netfilter: disable defrag once its no longer needed
      netfilter: ebtables: remove the 3 ebtables pointers from struct net
      netfilter: x_tables: remove ipt_unregister_table
      netfilter: x_tables: add xt_find_table
      netfilter: iptables: unregister the tables by name
      netfilter: ip6tables: unregister the tables by name
      netfilter: arptables: unregister the tables by name
      netfilter: x_tables: remove paranoia tests
      netfilter: xt_nat: pass table to hookfn
      netfilter: ip_tables: pass table pointer via nf_hook_ops
      netfilter: arp_tables: pass table pointer via nf_hook_ops
      netfilter: ip6_tables: pass table pointer via nf_hook_ops
      netfilter: remove all xt_table anchors from struct net
      netfilter: allow to turn off xtables compat layer

Pablo Neira Ayuso (6):
      netfilter: nft_socket: add support for cgroupsv2
      netfilter: nftables: add nft_pernet() helper function
      netfilter: nfnetlink: add struct nfnl_info and pass it to callbacks
      netfilter: nfnetlink: pass struct nfnl_info to rcu callbacks
      netfilter: nfnetlink: pass struct nfnl_info to batch callbacks
      netfilter: nfnetlink: consolidate callback types

Phil Sutter (1):
      netfilter: nf_log_syslog: Unset bridge logger in pernet exit

 include/linux/netfilter/nfnetlink.h         |  33 +-
 include/linux/netfilter/x_tables.h          |  16 +-
 include/linux/netfilter_arp/arp_tables.h    |   8 +-
 include/linux/netfilter_bridge/ebtables.h   |   9 +-
 include/linux/netfilter_ipv4/ip_tables.h    |  11 +-
 include/linux/netfilter_ipv6/ip6_tables.h   |  11 +-
 include/net/netfilter/ipv4/nf_defrag_ipv4.h |   3 +-
 include/net/netfilter/ipv6/nf_defrag_ipv6.h |   3 +-
 include/net/netfilter/nf_nat.h              |   2 -
 include/net/netfilter/nf_tables.h           |   8 +
 include/net/netns/ipv4.h                    |  10 -
 include/net/netns/ipv6.h                    |   9 -
 include/net/netns/x_tables.h                |   8 -
 include/uapi/linux/netfilter/nf_tables.h    |   4 +
 net/bridge/netfilter/ebt_limit.c            |   4 +-
 net/bridge/netfilter/ebt_mark.c             |   4 +-
 net/bridge/netfilter/ebt_mark_m.c           |   4 +-
 net/bridge/netfilter/ebtable_broute.c       |  10 +-
 net/bridge/netfilter/ebtable_filter.c       |  26 +-
 net/bridge/netfilter/ebtable_nat.c          |  27 +-
 net/bridge/netfilter/ebtables.c             |  54 ++-
 net/ipv4/netfilter/arp_tables.c             |  73 +--
 net/ipv4/netfilter/arptable_filter.c        |  17 +-
 net/ipv4/netfilter/ip_tables.c              |  86 ++--
 net/ipv4/netfilter/ipt_CLUSTERIP.c          |   8 +-
 net/ipv4/netfilter/iptable_filter.c         |  17 +-
 net/ipv4/netfilter/iptable_mangle.c         |  23 +-
 net/ipv4/netfilter/iptable_nat.c            |  59 ++-
 net/ipv4/netfilter/iptable_raw.c            |  17 +-
 net/ipv4/netfilter/iptable_security.c       |  17 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c         |  30 +-
 net/ipv6/netfilter/ip6_tables.c             |  84 ++--
 net/ipv6/netfilter/ip6table_filter.c        |  17 +-
 net/ipv6/netfilter/ip6table_mangle.c        |  24 +-
 net/ipv6/netfilter/ip6table_nat.c           |  58 ++-
 net/ipv6/netfilter/ip6table_raw.c           |  17 +-
 net/ipv6/netfilter/ip6table_security.c      |  17 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   |  29 +-
 net/netfilter/Kconfig                       |  10 +
 net/netfilter/ipset/ip_set_core.c           | 165 ++++---
 net/netfilter/nf_conntrack_netlink.c        | 302 +++++++------
 net/netfilter/nf_conntrack_proto.c          |   8 +-
 net/netfilter/nf_log_syslog.c               |   1 +
 net/netfilter/nf_nat_core.c                 |  37 --
 net/netfilter/nf_nat_proto.c                |  38 ++
 net/netfilter/nf_tables_api.c               | 663 ++++++++++++++--------------
 net/netfilter/nf_tables_offload.c           |  10 +-
 net/netfilter/nfnetlink.c                   |  58 ++-
 net/netfilter/nfnetlink_acct.c              |  80 ++--
 net/netfilter/nfnetlink_cthelper.c          |  57 +--
 net/netfilter/nfnetlink_cttimeout.c         | 146 +++---
 net/netfilter/nfnetlink_log.c               |  42 +-
 net/netfilter/nfnetlink_osf.c               |  21 +-
 net/netfilter/nfnetlink_queue.c             |  86 ++--
 net/netfilter/nft_chain_filter.c            |   5 +-
 net/netfilter/nft_compat.c                  |  33 +-
 net/netfilter/nft_dynset.c                  |   5 +-
 net/netfilter/nft_socket.c                  |  48 +-
 net/netfilter/nft_tproxy.c                  |  24 +
 net/netfilter/x_tables.c                    |  34 +-
 net/netfilter/xt_TPROXY.c                   |  13 +
 net/netfilter/xt_limit.c                    |   6 +-
 net/netfilter/xt_socket.c                   |  14 +
 63 files changed, 1499 insertions(+), 1264 deletions(-)
