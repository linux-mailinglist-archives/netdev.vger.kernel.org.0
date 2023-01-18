Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0924B671D18
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjARNJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjARNI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:08:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1598D3A842;
        Wed, 18 Jan 2023 04:32:39 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pI7cA-00073r-5f; Wed, 18 Jan 2023 13:32:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 0/9] Netfilter updates for net-next
Date:   Wed, 18 Jan 2023 13:31:59 +0100
Message-Id: <20230118123208.17167-1-fw@strlen.de>
X-Mailer: git-send-email 2.38.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

following patch set includes netfilter updates for your *net-next* tree.

1. Replace pr_debug use with nf_log infra for debugging in sctp
   conntrack.
2. Remove pr_debug calls, they are either useless or we have better
   options in place.
3. Avoid repeated load of ct->status in some spots.
   Some bit-flags cannot change during the lifeetime of
   a connection, so no need to re-fetch those.
4. Avoid uneeded nesting of rcu_read_lock during tuple lookup.
5. Remove the CLUSTERIP target.  Marked as obsolete for years,
   and we still have WARN splats wrt. races of the out-of-band
   /proc interface installed by this target.
6. Add static key to nf_tables to avoid the retpoline mitigation
   if/else if cascade provided the cpu doesn't need the retpoline thunk.
7. add nf_tables objref calls to the retpoline mitigation workaround.
8. Split parts of nft_ct.c that do not need symbols exported by
   the conntrack modules and place them in nf_tables directly.
   This allows to avoid indirect call for 'ct status' checks.
9. Add 'destroy' commands to nf_tables.  They are identical
   to the existing 'delete' commands, but do not indicate
   an error if the referenced object (set, chain, rule...)
   did not exist, from Fernando.

The following changes since commit c4791b3196bf46367bcf6cc56a09b32e037c4f49:

  Merge branch 'net-mdio-continue-separating-c22-and-c45' (2023-01-17 19:34:10 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

for you to fetch changes up to f80a612dd77c4585171e44a06b490466bdeec1ae:

  netfilter: nf_tables: add support to destroy operation (2023-01-18 13:09:00 +0100)

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nf_tables: add support to destroy operation

Florian Westphal (8):
      netfilter: conntrack: sctp: use nf log infrastructure for invalid packets
      netfilter: conntrack: remove pr_debug calls
      netfilter: conntrack: avoid reload of ct->status
      netfilter: conntrack: move rcu read lock to nf_conntrack_find_get
      netfilter: ip_tables: remove clusterip target
      netfilter: nf_tables: add static key to skip retpoline workarounds
      netfilter: nf_tables: avoid retpoline overhead for objref calls
      netfilter: nf_tables: avoid retpoline overhead for some ct expression calls

 include/net/netfilter/nf_tables_core.h   |  16 +
 include/uapi/linux/netfilter/nf_tables.h |  14 +
 net/ipv4/netfilter/Kconfig               |  14 -
 net/ipv4/netfilter/Makefile              |   1 -
 net/ipv4/netfilter/ipt_CLUSTERIP.c       | 929 -------------------------------
 net/netfilter/Makefile                   |   6 +
 net/netfilter/nf_conntrack_core.c        |  46 +-
 net/netfilter/nf_conntrack_proto.c       |  20 +-
 net/netfilter/nf_conntrack_proto_sctp.c  |  46 +-
 net/netfilter/nf_conntrack_proto_tcp.c   |   9 -
 net/netfilter/nf_conntrack_proto_udp.c   |  10 +-
 net/netfilter/nf_tables_api.c            | 111 +++-
 net/netfilter/nf_tables_core.c           |  35 +-
 net/netfilter/nft_ct.c                   |  39 +-
 net/netfilter/nft_ct_fast.c              |  56 ++
 net/netfilter/nft_objref.c               |  12 +-
 16 files changed, 302 insertions(+), 1062 deletions(-)
 delete mode 100644 net/ipv4/netfilter/ipt_CLUSTERIP.c
 create mode 100644 net/netfilter/nft_ct_fast.c
-- 
2.38.2

