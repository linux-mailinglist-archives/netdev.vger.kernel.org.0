Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9997C0F9
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 14:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfGaMRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 08:17:08 -0400
Received: from correo.us.es ([193.147.175.20]:40362 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbfGaMRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 08:17:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD6BE6CB67
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 14:17:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACACC1150DE
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 14:17:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A05111150B9; Wed, 31 Jul 2019 14:17:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84D1DDA732;
        Wed, 31 Jul 2019 14:17:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 31 Jul 2019 14:17:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5FACE4265A2F;
        Wed, 31 Jul 2019 14:17:02 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     marcelo.leitner@gmail.com, wenxu@ucloud.cn, jiri@resnulli.us,
        saeedm@mellanox.com, gerlitz.or@gmail.com, paulb@mellanox.com,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com
Subject: [PATCH nf,v2] netfilter: nf_tables: map basechain priority to hardware priority
Date:   Wed, 31 Jul 2019 14:16:56 +0200
Message-Id: <20190731121656.27951-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds initial support for offloading basechains using the
priority range from -8192 to 8191.

The software priority -8192 is mapped to the hardware priority
0xC000 + 1. tcf_auto_prio() uses 0xC000 if the user specifies no
priority, then it subtracts 1 for each new tcf_proto object. This patch
reserves the hardware priority range from 0xC000 to 0xFFFF for
netfilter.

The software to hardware priority mapping is not exposed to userspace,
so it should be possible to update this / extend the range of supported
priorities later on.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix indent in priority assignment - Marcelo Leitner.
    Missing << 16 bitshift.

 include/net/netfilter/nf_tables_offload.h |  2 ++
 net/netfilter/nf_tables_api.c             |  4 ++++
 net/netfilter/nf_tables_offload.c         | 31 ++++++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 3196663a10e3..2d497394021e 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -73,4 +73,6 @@ int nft_flow_rule_offload_commit(struct net *net);
 	(__reg)->key		= __key;				\
 	memset(&(__reg)->mask, 0xff, (__reg)->len);
 
+u16 nft_chain_offload_priority(struct nft_base_chain *basechain);
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
index 64f5fd5f240e..a79efd49c8a8 100644
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
+	common->prio = priority << 16;
 	common->extack = extack;
 }
 
@@ -124,6 +125,28 @@ static int nft_setup_cb_call(struct nft_base_chain *basechain,
 	return 0;
 }
 
+/* Available priorities for hardware offload range: -8192..8191 */
+#define NFT_BASECHAIN_OFFLOAD_PRIO_MAX		(SHRT_MAX / 4)
+#define NFT_BASECHAIN_OFFLOAD_PRIO_MIN		(SHRT_MIN / 4)
+#define NFT_BASECHAIN_OFFLOAD_PRIO_RANGE	(USHRT_MAX / 4)
+/* tcf_auto_prio() uses 0xC000 as base, then subtract one for each new chain. */
+#define NFT_BASECHAIN_OFFLOAD_HW_PRIO_BASE	(0xC000 + 1)
+
+u16 nft_chain_offload_priority(struct nft_base_chain *basechain)
+{
+	u16 prio;
+
+	if (basechain->ops.priority < NFT_BASECHAIN_OFFLOAD_PRIO_MIN ||
+	    basechain->ops.priority > NFT_BASECHAIN_OFFLOAD_PRIO_MAX)
+		return 0;
+
+	/* map netfilter chain priority to hardware priority. */
+	prio = basechain->ops.priority + NFT_BASECHAIN_OFFLOAD_PRIO_MAX +
+		NFT_BASECHAIN_OFFLOAD_HW_PRIO_BASE;
+
+	return prio;
+}
+
 static int nft_flow_offload_rule(struct nft_trans *trans,
 				 enum flow_cls_command command)
 {
@@ -142,7 +165,9 @@ static int nft_flow_offload_rule(struct nft_trans *trans,
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

