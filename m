Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBE71175AA
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfLIT0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:26:49 -0500
Received: from correo.us.es ([193.147.175.20]:58444 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbfLIT0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 14:26:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AA54F120847
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B158DA70D
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 90467DA70A; Mon,  9 Dec 2019 20:26:45 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6435ADA702;
        Mon,  9 Dec 2019 20:26:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 20:26:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 341364265A5A;
        Mon,  9 Dec 2019 20:26:43 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 00/17] Netfilter fixes for net
Date:   Mon,  9 Dec 2019 20:26:21 +0100
Message-Id: <20191209192638.71184-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Wait for rcu grace period after releasing netns in ctnetlink,
   from Florian Westphal.

2) Incorrect command type in flowtable offload ndo invocation,
   from wenxu.

3) Incorrect callback type in flowtable offload flow tuple
   updates, also from wenxu.

4) Fix compile warning on flowtable offload infrastructure due to
   possible reference to uninitialized variable, from Nathan Chancellor.

5) Do not inline nf_ct_resolve_clash(), this is called from slow
   path / stress situations. From Florian Westphal.

6) Missing IPv6 flow selector description in flowtable offload.

7) Missing check for NETDEV_UNREGISTER in nf_tables offload
   infrastructure, from wenxu.

8) Update NAT selftest to use randomized netns names, from
   Florian Westphal.

9) Restore nfqueue bridge support, from Marco Oliverio.

10) Compilation warning in SCTP_CHUNKMAP_*() on xt_sctp header.
    From Phil Sutter.

11) Fix bogus lookup/get match for non-anonymous rbtree sets.

12) Missing netlink validation for NFT_SET_ELEM_INTERVAL_END
    elements.

13) Missing netlink validation for NFT_DATA_VALUE after
    nft_data_init().

14) If rule specifies no actions, offload infrastructure returns
    EOPNOTSUPP.

15) Module refcount leak in object updates.

16) Missing sanitization for ARP traffic from br_netfilter, from
    Eric Dumazet.

17) Compilation breakage on big-endian due to incorrect memcpy()
    size in the flowtable offload infrastructure.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 61183b056b49e2937ff92a1424291ba36a6f6d05:

  net: macb: add missed tasklet_kill (2019-11-28 23:05:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 7acd9378dc65296b2531758aa62ee9bcf55b371c:

  netfilter: nf_flow_table_offload: Correct memcpy size for flow_overload_mangle() (2019-12-09 20:07:59 +0100)

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: bridge: make sure to pull arp header in br_nf_forward_arp()

Florian Westphal (3):
      netfilter: ctnetlink: netns exit must wait for callbacks
      netfilter: conntrack: tell compiler to not inline nf_ct_resolve_clash
      selftests: netfilter: use randomized netns names

Marco Oliverio (1):
      netfilter: nf_queue: enqueue skbs with NULL dst

Nathan Chancellor (1):
      netfilter: nf_flow_table_offload: Don't use offset uninitialized in flow_offload_port_{d,s}nat

Pablo Neira Ayuso (7):
      netfilter: nf_flow_table_offload: add IPv6 match description
      netfilter: nft_set_rbtree: bogus lookup/get on consecutive elements in named sets
      netfilter: nf_tables: validate NFT_SET_ELEM_INTERVAL_END
      netfilter: nf_tables: validate NFT_DATA_VALUE after nft_data_init()
      netfilter: nf_tables: skip module reference count bump on object updates
      netfilter: nf_tables_offload: return EOPNOTSUPP if rule specifies no actions
      netfilter: nf_flow_table_offload: Correct memcpy size for flow_overload_mangle()

Phil Sutter (1):
      netfilter: uapi: Avoid undefined left-shift in xt_sctp.h

wenxu (3):
      netfilter: nf_flow_table_offload: Fix block setup as TC_SETUP_FT cmd
      netfilter: nf_flow_table_offload: Fix block_cb tc_setup_type as TC_SETUP_CLSFLOWER
      netfilter: nf_tables_offload: Check for the NETDEV_UNREGISTER event

 include/uapi/linux/netfilter/xt_sctp.h       |   6 +-
 net/bridge/br_netfilter_hooks.c              |   3 +
 net/netfilter/nf_conntrack_core.c            |   7 +-
 net/netfilter/nf_conntrack_netlink.c         |   3 +
 net/netfilter/nf_flow_table_offload.c        |  83 ++++---
 net/netfilter/nf_queue.c                     |   2 +-
 net/netfilter/nf_tables_api.c                |  18 +-
 net/netfilter/nf_tables_offload.c            |   6 +
 net/netfilter/nft_bitwise.c                  |   4 +-
 net/netfilter/nft_cmp.c                      |   6 +
 net/netfilter/nft_range.c                    |  10 +
 net/netfilter/nft_set_rbtree.c               |  21 +-
 tools/testing/selftests/netfilter/nft_nat.sh | 332 ++++++++++++++-------------
 13 files changed, 288 insertions(+), 213 deletions(-)
