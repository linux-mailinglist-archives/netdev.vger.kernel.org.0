Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5A14E266C
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344882AbiCUMcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239071AbiCUMcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:32:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D456984EE2;
        Mon, 21 Mar 2022 05:30:56 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 21F896019B;
        Mon, 21 Mar 2022 13:28:14 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/19] Netfilter updates for net-next
Date:   Mon, 21 Mar 2022 13:30:33 +0100
Message-Id: <20220321123052.70553-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next.
This patchset contains updates for the nf_tables register tracking
infrastructure, disable bogus warning when attaching ct helpers,
one namespace pollution fix and few cleanups for the flowtable.

1) Revisit conntrack gc routine to reduce chances of overruning
   the netlink buffer from the event path. From Florian Westphal.

2) Disable warning on explicit ct helper assignment, from Phil Sutter.

3) Read-only expressions do not update registers, mark them as
   NFT_REDUCE_READONLY. Add helper functions to update the register
   tracking information. This patch re-enables the register tracking
   infrastructure.

4) Cancel register tracking in case an expression fully/partially
   clobbers existing data.

5) Add register tracking support for remaining expressions: ct,
   lookup, meta, numgen, osf, hash, immediate, socket, xfrm, tunnel,
   fib, exthdr.

6) Rename init and exit functions for the conntrack h323 helper,
   from Randy Dunlap.

7) Remove redundant field in struct flow_offload_work.

8) Update nf_flow_table_iterate() to pass flowtable to callback.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 092d992b76ed9d06389af0bc5efd5279d7b1ed9f:

  Merge tag 'mlx5-updates-2022-03-18' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2022-03-19 14:50:19 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git HEAD

for you to fetch changes up to 217cff36e885627c41a14e803fc44f9cbc945767:

  netfilter: flowtable: pass flowtable to nf_flow_table_iterate() (2022-03-20 00:29:48 +0100)

----------------------------------------------------------------
Florian Westphal (5):
      netfilter: conntrack: revisit gc autotuning
      netfilter: nft_lookup: only cancel tracking for clobbered dregs
      netfilter: nft_meta: extend reduce support to bridge family
      netfilter: nft_fib: add reduce support
      netfilter: nft_exthdr: add reduce support

Pablo Neira Ayuso (12):
      netfilter: nf_tables: do not reduce read-only expressions
      netfilter: nf_tables: cancel tracking for clobbered destination registers
      netfilter: nft_ct: track register operations
      netfilter: nft_numgen: cancel register tracking
      netfilter: nft_osf: track register operations
      netfilter: nft_hash: track register operations
      netfilter: nft_immediate: cancel register tracking for data destination register
      netfilter: nft_socket: track register operations
      netfilter: nft_xfrm: track register operations
      netfilter: nft_tunnel: track register operations
      netfilter: flowtable: remove redundant field in flow_offload_work struct
      netfilter: flowtable: pass flowtable to nf_flow_table_iterate()

Phil Sutter (1):
      netfilter: conntrack: Add and use nf_ct_set_auto_assign_helper_warned()

Randy Dunlap (1):
      netfilter: nf_nat_h323: eliminate anonymous module_init & module_exit

 include/net/netfilter/nf_conntrack_helper.h |  1 +
 include/net/netfilter/nf_tables.h           | 22 ++++++++
 include/net/netfilter/nft_fib.h             |  3 +
 include/net/netfilter/nft_meta.h            |  3 +
 net/bridge/netfilter/nft_meta_bridge.c      |  5 +-
 net/bridge/netfilter/nft_reject_bridge.c    |  1 +
 net/ipv4/netfilter/nf_nat_h323.c            |  8 +--
 net/ipv4/netfilter/nft_dup_ipv4.c           |  1 +
 net/ipv4/netfilter/nft_fib_ipv4.c           |  2 +
 net/ipv4/netfilter/nft_reject_ipv4.c        |  1 +
 net/ipv6/netfilter/nft_dup_ipv6.c           |  1 +
 net/ipv6/netfilter/nft_fib_ipv6.c           |  2 +
 net/ipv6/netfilter/nft_reject_ipv6.c        |  1 +
 net/netfilter/nf_conntrack_core.c           | 85 +++++++++++++++++++++++------
 net/netfilter/nf_conntrack_helper.c         |  6 ++
 net/netfilter/nf_flow_table_core.c          | 20 +++----
 net/netfilter/nf_flow_table_offload.c       | 11 ++--
 net/netfilter/nf_tables_api.c               | 63 ++++++++++++++++++++-
 net/netfilter/nft_bitwise.c                 | 24 +++++---
 net/netfilter/nft_byteorder.c               |  3 +-
 net/netfilter/nft_cmp.c                     |  3 +
 net/netfilter/nft_compat.c                  |  1 +
 net/netfilter/nft_connlimit.c               |  1 +
 net/netfilter/nft_counter.c                 |  1 +
 net/netfilter/nft_ct.c                      | 51 +++++++++++++++++
 net/netfilter/nft_dup_netdev.c              |  1 +
 net/netfilter/nft_dynset.c                  |  1 +
 net/netfilter/nft_exthdr.c                  | 33 +++++++++++
 net/netfilter/nft_fib.c                     | 42 ++++++++++++++
 net/netfilter/nft_fib_inet.c                |  1 +
 net/netfilter/nft_fib_netdev.c              |  1 +
 net/netfilter/nft_flow_offload.c            |  1 +
 net/netfilter/nft_fwd_netdev.c              |  2 +
 net/netfilter/nft_hash.c                    | 36 ++++++++++++
 net/netfilter/nft_immediate.c               | 12 ++++
 net/netfilter/nft_last.c                    |  1 +
 net/netfilter/nft_limit.c                   |  2 +
 net/netfilter/nft_log.c                     |  1 +
 net/netfilter/nft_lookup.c                  | 12 ++++
 net/netfilter/nft_masq.c                    |  3 +
 net/netfilter/nft_meta.c                    | 19 +++----
 net/netfilter/nft_nat.c                     |  2 +
 net/netfilter/nft_numgen.c                  | 22 ++++++++
 net/netfilter/nft_objref.c                  |  2 +
 net/netfilter/nft_osf.c                     | 25 +++++++++
 net/netfilter/nft_payload.c                 | 12 ++--
 net/netfilter/nft_queue.c                   |  2 +
 net/netfilter/nft_quota.c                   |  1 +
 net/netfilter/nft_range.c                   |  1 +
 net/netfilter/nft_redir.c                   |  3 +
 net/netfilter/nft_reject_inet.c             |  1 +
 net/netfilter/nft_reject_netdev.c           |  1 +
 net/netfilter/nft_rt.c                      |  1 +
 net/netfilter/nft_socket.c                  | 28 ++++++++++
 net/netfilter/nft_synproxy.c                |  1 +
 net/netfilter/nft_tproxy.c                  |  1 +
 net/netfilter/nft_tunnel.c                  | 28 ++++++++++
 net/netfilter/nft_xfrm.c                    | 28 ++++++++++
 58 files changed, 580 insertions(+), 67 deletions(-)
