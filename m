Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD58488D00
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbiAIXQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:16:49 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42096 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237368AbiAIXQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:16:48 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2CAC0607C1;
        Mon, 10 Jan 2022 00:13:58 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/32] Netfilter updates for net-next
Date:   Mon, 10 Jan 2022 00:16:08 +0100
Message-Id: <20220109231640.104123-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next. This
includes one patch to update ovs and act_ct to use nf_ct_put() instead
of nf_conntrack_put().

1) Add netns_tracker to nfnetlink_log and masquerade, from Eric Dumazet.

2) Remove redundant rcu read-size lock in nf_tables packet path.

3) Replace BUG() by WARN_ON_ONCE() in nft_payload.

4) Consolidate rule verdict tracing.

5) Replace WARN_ON() by WARN_ON_ONCE() in nf_tables core.

6) Make counter support built-in in nf_tables.

7) Add new field to conntrack object to identify locally generated
   traffic, from Florian Westphal.

8) Prevent NAT from shadowing well-known ports, from Florian Westphal.

9) Merge nf_flow_table_{ipv4,ipv6} into nf_flow_table_inet, also from
   Florian.

10) Remove redundant pointer in nft_pipapo AVX2 support, from Colin Ian King.

11) Replace opencoded max() in conntrack, from Jiapeng Chong.

12) Update conntrack to use refcount_t API, from Florian Westphal.

13) Move ip_ct_attach indirection into the nf_ct_hook structure.

14) Constify several pointer object in the netfilter codebase,
    from Florian Westphal.

15) Tree-wide replacement of nf_conntrack_put() by nf_ct_put(), also
    from Florian.

16) Fix egress splat due to incorrect rcu notation, from Florian.

17) Move stateful fields of connlimit, last, quota, numgen and limit
    out of the expression data area.

18) Build a blob to represent the ruleset in nf_tables, this is a
    requirement of the new register tracking infrastructure.

19) Add NFT_REG32_NUM to define the maximum number of 32-bit registers.

20) Add register tracking infrastructure to skip redundant
    store-to-register operations, this includes support for payload,
    meta and bitwise expresssions.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 604ba230902d23c6e85c7dba9cfcb6a37661cb12:

  net: prestera: flower template support (2021-12-16 10:52:53 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 4a80e026981b791da3937470ace84796490c7796:

  netfilter: nft_meta: cancel register tracking after meta update (2022-01-09 23:35:17 +0100)

----------------------------------------------------------------
Colin Ian King (1):
      netfilter: nft_set_pipapo_avx2: remove redundant pointer lt

Eric Dumazet (2):
      netfilter: nfnetlink: add netns refcount tracker to struct nfulnl_instance
      netfilter: nf_nat_masquerade: add netns refcount tracker to masq_dev_work

Florian Westphal (9):
      netfilter: conntrack: tag conntracks picked up in local out hook
      netfilter: nat: force port remap to prevent shadowing well-known ports
      netfilter: flowtable: remove ipv4/ipv6 modules
      netfilter: conntrack: convert to refcount_t api
      netfilter: core: move ip_ct_attach indirection to struct nf_ct_hook
      netfilter: make function op structures const
      netfilter: conntrack: avoid useless indirection during conntrack destruction
      net: prefer nf_ct_put instead of nf_conntrack_put
      netfilter: egress: avoid a lockdep splat

Jiapeng Chong (1):
      netfilter: conntrack: Use max() instead of doing it manually

Pablo Neira Ayuso (19):
      netfilter: nf_tables: remove rcu read-size lock
      netfilter: nft_payload: WARN_ON_ONCE instead of BUG
      netfilter: nf_tables: consolidate rule verdict trace call
      netfilter: nf_tables: replace WARN_ON by WARN_ON_ONCE for unknown verdicts
      netfilter: nf_tables: make counter support built-in
      netfilter: nft_connlimit: move stateful fields out of expression data
      netfilter: nft_last: move stateful fields out of expression data
      netfilter: nft_quota: move stateful fields out of expression data
      netfilter: nft_numgen: move stateful fields out of expression data
      netfilter: nft_limit: rename stateful structure
      netfilter: nft_limit: move stateful fields out of expression data
      netfilter: nf_tables: add rule blob layout
      netfilter: nf_tables: add NFT_REG32_NUM
      netfilter: nf_tables: add register tracking infrastructure
      netfilter: nft_payload: track register operations
      netfilter: nft_meta: track register operations
      netfilter: nft_bitwise: track register operations
      netfilter: nft_payload: cancel register tracking after payload update
      netfilter: nft_meta: cancel register tracking after meta update

 include/linux/netfilter.h                     |  10 +-
 include/linux/netfilter/nf_conntrack_common.h |  10 +-
 include/linux/netfilter_netdev.h              |   2 +-
 include/net/netfilter/nf_conntrack.h          |  11 +-
 include/net/netfilter/nf_tables.h             |  40 +++++-
 include/net/netfilter/nf_tables_core.h        |   6 +
 net/bridge/netfilter/nft_meta_bridge.c        |  20 +++
 net/ipv4/netfilter/Kconfig                    |   8 +-
 net/ipv4/netfilter/Makefile                   |   3 -
 net/ipv4/netfilter/nf_flow_table_ipv4.c       |  37 ------
 net/ipv6/netfilter/Kconfig                    |   8 +-
 net/ipv6/netfilter/nf_flow_table_ipv6.c       |  38 ------
 net/netfilter/Kconfig                         |   6 -
 net/netfilter/Makefile                        |   3 +-
 net/netfilter/core.c                          |  29 ++---
 net/netfilter/nf_conntrack_core.c             |  53 ++++----
 net/netfilter/nf_conntrack_expect.c           |   4 +-
 net/netfilter/nf_conntrack_netlink.c          |  10 +-
 net/netfilter/nf_conntrack_standalone.c       |   4 +-
 net/netfilter/nf_flow_table_core.c            |   2 +-
 net/netfilter/nf_flow_table_inet.c            |  26 ++++
 net/netfilter/nf_nat_core.c                   |  45 ++++++-
 net/netfilter/nf_nat_masquerade.c             |   4 +-
 net/netfilter/nf_synproxy_core.c              |   1 -
 net/netfilter/nf_tables_api.c                 | 160 +++++++++++++++++-------
 net/netfilter/nf_tables_core.c                |  87 +++++++++----
 net/netfilter/nf_tables_trace.c               |   2 +-
 net/netfilter/nfnetlink_log.c                 |   5 +-
 net/netfilter/nfnetlink_queue.c               |   8 +-
 net/netfilter/nft_bitwise.c                   |  95 ++++++++++++++
 net/netfilter/nft_connlimit.c                 |  26 ++--
 net/netfilter/nft_counter.c                   |  58 +++------
 net/netfilter/nft_ct.c                        |   4 +-
 net/netfilter/nft_last.c                      |  69 ++++++++---
 net/netfilter/nft_limit.c                     | 172 ++++++++++++++++++--------
 net/netfilter/nft_meta.c                      |  48 +++++++
 net/netfilter/nft_numgen.c                    |  34 ++++-
 net/netfilter/nft_payload.c                   |  57 ++++++++-
 net/netfilter/nft_quota.c                     |  52 +++++++-
 net/netfilter/nft_set_pipapo_avx2.c           |   4 +-
 net/netfilter/xt_CT.c                         |   3 +-
 net/openvswitch/conntrack.c                   |  15 ++-
 net/sched/act_ct.c                            |   7 +-
 tools/testing/selftests/netfilter/nft_nat.sh  |   5 +-
 44 files changed, 887 insertions(+), 404 deletions(-)
