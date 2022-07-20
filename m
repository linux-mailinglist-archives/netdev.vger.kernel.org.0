Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E853857C07D
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiGTXIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiGTXIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:08:00 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E753140C9;
        Wed, 20 Jul 2022 16:07:58 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 00/18] Netfilter/IPVS updates for net-next
Date:   Thu, 21 Jul 2022 01:07:36 +0200
Message-Id: <20220720230754.209053-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS updates for net-next:

1) Simplify nf_ct_get_tuple(), from Jackie Liu.

2) Add format to request_module() call, from Bill Wendling.

3) Add /proc/net/stats/nf_flowtable to monitor in-flight pending
   hardware offload objects to be processed, from Vlad Buslov.

4) Missing rcu annotation and accessors in the netfilter tree,
   from Florian Westphal.

5) Merge h323 conntrack helper nat hooks into single object,
   also from Florian.

6) A batch of update to fix sparse warnings treewide,
   from Florian Westphal.

7) Move nft_cmp_fast_mask() where it used, from Florian.

8) Missing const in nf_nat_initialized(), from James Yonan.

9) Use bitmap API for Maglev IPVS scheduler, from Christophe Jaillet.

10) Use refcount_inc instead of _inc_not_zero in flowtable,
    from Florian Westphal.

11) Remove pr_debug in xt_TPROXY, from Nathan Cancellor.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit edb2c3476db9898a63fb5d0011ecaa43ebf46c9b:

  fddi/skfp: fix repeated words in comments (2022-07-11 14:12:54 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git HEAD

for you to fetch changes up to aa8c7cdbae58b695ed79a0129b6b8c887b25969f:

  netfilter: xt_TPROXY: remove pr_debug invocations (2022-07-21 00:56:00 +0200)

----------------------------------------------------------------
Bill Wendling (1):
      netfilter: conntrack: use correct format characters

Christophe JAILLET (1):
      netfilter: ipvs: Use the bitmap API to allocate bitmaps

Florian Westphal (10):
      netfilter: nf_conntrack: add missing __rcu annotations
      netfilter: nf_conntrack: use rcu accessors where needed
      netfilter: h323: merge nat hook pointers into one
      netfilter: nfnetlink: add missing __be16 cast
      netfilter: x_tables: use correct integer types
      netfilter: nf_tables: use the correct get/put helpers
      netfilter: nf_tables: add and use BE register load-store helpers
      netfilter: nf_tables: use correct integer types
      netfilter: nf_tables: move nft_cmp_fast_mask to where its used
      netfilter: flowtable: prefer refcount_inc

Jackie Liu (1):
      netfilter: conntrack: use fallthrough to cleanup

James Yonan (1):
      netfilter: nf_nat: in nf_nat_initialized(), use const struct nf_conn *

Justin Stitt (1):
      netfilter: xt_TPROXY: remove pr_debug invocations

Vlad Buslov (2):
      net/sched: act_ct: set 'net' pointer when creating new nf_flow_table
      netfilter: nf_flow_table: count pending offload workqueue tasks

Zhang Jiaming (1):
      netfilter: nft_set_bitmap: Fix spelling mistake

 include/linux/netfilter/nf_conntrack_h323.h  | 109 +++++------
 include/linux/netfilter/nf_conntrack_sip.h   |   2 +-
 include/net/net_namespace.h                  |   6 +
 include/net/netfilter/nf_conntrack_timeout.h |   2 +-
 include/net/netfilter/nf_flow_table.h        |  21 +++
 include/net/netfilter/nf_nat.h               |   2 +-
 include/net/netfilter/nf_tables.h            |  15 ++
 include/net/netfilter/nf_tables_core.h       |  10 --
 include/net/netns/flow_table.h               |  14 ++
 net/bridge/netfilter/nft_meta_bridge.c       |   2 +-
 net/ipv4/netfilter/nf_nat_h323.c             |  42 ++---
 net/netfilter/Kconfig                        |   9 +
 net/netfilter/Makefile                       |   1 +
 net/netfilter/ipvs/ip_vs_mh.c                |   5 +-
 net/netfilter/nf_conntrack_broadcast.c       |   6 +-
 net/netfilter/nf_conntrack_core.c            |   8 +-
 net/netfilter/nf_conntrack_h323_main.c       | 260 ++++++++++-----------------
 net/netfilter/nf_conntrack_helper.c          |   4 +-
 net/netfilter/nf_conntrack_netlink.c         |   9 +-
 net/netfilter/nf_conntrack_pptp.c            |   2 +-
 net/netfilter/nf_conntrack_sip.c             |   9 +-
 net/netfilter/nf_conntrack_timeout.c         |  18 +-
 net/netfilter/nf_flow_table_core.c           |  73 +++++++-
 net/netfilter/nf_flow_table_offload.c        |  17 +-
 net/netfilter/nf_flow_table_procfs.c         |  80 +++++++++
 net/netfilter/nfnetlink.c                    |   2 +-
 net/netfilter/nfnetlink_cthelper.c           |  10 +-
 net/netfilter/nft_byteorder.c                |   3 +-
 net/netfilter/nft_cmp.c                      |  18 +-
 net/netfilter/nft_ct.c                       |   4 +-
 net/netfilter/nft_exthdr.c                   |  10 +-
 net/netfilter/nft_osf.c                      |   2 +-
 net/netfilter/nft_set_bitmap.c               |   4 +-
 net/netfilter/nft_socket.c                   |   8 +-
 net/netfilter/nft_tproxy.c                   |   6 +-
 net/netfilter/nft_tunnel.c                   |   3 +-
 net/netfilter/nft_xfrm.c                     |   8 +-
 net/netfilter/xt_CT.c                        |  23 ++-
 net/netfilter/xt_DSCP.c                      |   8 +-
 net/netfilter/xt_TCPMSS.c                    |   4 +-
 net/netfilter/xt_TPROXY.c                    |  25 +--
 net/netfilter/xt_connlimit.c                 |   6 +-
 net/sched/act_ct.c                           |   5 +-
 43 files changed, 518 insertions(+), 357 deletions(-)
 create mode 100644 include/net/netns/flow_table.h
 create mode 100644 net/netfilter/nf_flow_table_procfs.c
