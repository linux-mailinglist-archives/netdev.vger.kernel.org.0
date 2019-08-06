Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6809883622
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387550AbfHFQD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:03:29 -0400
Received: from correo.us.es ([193.147.175.20]:44572 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733299AbfHFQD2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:03:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BAC50BA1BD
        for <netdev@vger.kernel.org>; Tue,  6 Aug 2019 18:03:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACA73115101
        for <netdev@vger.kernel.org>; Tue,  6 Aug 2019 18:03:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A1FC21150CB; Tue,  6 Aug 2019 18:03:25 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80D56DA730;
        Tue,  6 Aug 2019 18:03:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 06 Aug 2019 18:03:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6605C4265A31;
        Tue,  6 Aug 2019 18:03:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        marcelo.leitner@gmail.com, jiri@resnulli.us, wenxu@ucloud.cn,
        saeedm@mellanox.com, paulb@mellanox.com, gerlitz.or@gmail.com,
        jakub.kicinski@netronome.com
Subject: [PATCH 2/2 net,v4] netfilter: nf_tables: map basechain priority to hardware priority
Date:   Tue,  6 Aug 2019 18:03:10 +0200
Message-Id: <20190806160310.6663-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190806160310.6663-1-pablo@netfilter.org>
References: <20190806160310.6663-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds initial support for offloading basechains using
the priority range from -32767 to 32767. This is restricting the
netfilter priority range to 16-bit integer since this is what most
drivers assume so far from tc.

The software to hardware priority mapping is not exposed to userspace.
Hence, it should be possible to extend this range of supported priorities
later on once drivers are updated to support for 32-bit integer
priorities.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: no changes wrt. [PATCH net 2/2,v3] netfilter: nf_tables: map basechain
    priority to hardware priority.

 include/net/netfilter/nf_tables_offload.h |  2 ++
 net/netfilter/nf_tables_api.c             |  4 ++++
 net/netfilter/nf_tables_offload.c         | 18 +++++++++++++++---
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 3196663a10e3..3c31e9d55028 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -73,4 +73,6 @@ int nft_flow_rule_offload_commit(struct net *net);
 	(__reg)->key		= __key;				\
 	memset(&(__reg)->mask, 0xff, (__reg)->len);
 
+u32 nft_chain_offload_priority(struct nft_base_chain *basechain);
+
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 605a7cfe7ca7..9cf0fecf5cb9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1662,6 +1662,10 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 		chain->flags |= NFT_BASE_CHAIN | flags;
 		basechain->policy = NF_ACCEPT;
+		if (chain->flags & NFT_CHAIN_HW_OFFLOAD &&
+		    !nft_chain_offload_priority(basechain))
+			return -EOPNOTSUPP;
+
 		flow_block_init(&basechain->flow_block);
 	} else {
 		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 64f5fd5f240e..81d636fac571 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -103,10 +103,11 @@ void nft_offload_update_dependency(struct nft_offload_ctx *ctx,
 }
 
 static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
-					 __be16 proto,
-					struct netlink_ext_ack *extack)
+					 __be16 proto, int priority,
+					 struct netlink_ext_ack *extack)
 {
 	common->protocol = proto;
+	common->prio = priority;
 	common->extack = extack;
 }
 
@@ -124,6 +125,15 @@ static int nft_setup_cb_call(struct nft_base_chain *basechain,
 	return 0;
 }
 
+u32 nft_chain_offload_priority(struct nft_base_chain *basechain)
+{
+	if (basechain->ops.priority < SHRT_MIN ||
+	    basechain->ops.priority > SHRT_MAX)
+		return 0;
+
+	return basechain->ops.priority + abs(SHRT_MIN);
+}
+
 static int nft_flow_offload_rule(struct nft_trans *trans,
 				 enum flow_cls_command command)
 {
@@ -142,7 +152,9 @@ static int nft_flow_offload_rule(struct nft_trans *trans,
 	if (flow)
 		proto = flow->proto;
 
-	nft_flow_offload_common_init(&cls_flow.common, proto, &extack);
+	nft_flow_offload_common_init(&cls_flow.common, proto,
+				     nft_chain_offload_priority(basechain),
+				     &extack);
 	cls_flow.command = command;
 	cls_flow.cookie = (unsigned long) rule;
 	if (flow)
-- 
2.11.0

