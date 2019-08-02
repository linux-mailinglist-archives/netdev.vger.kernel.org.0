Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FFA7F9C6
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 15:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394917AbfHBN3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 09:29:35 -0400
Received: from correo.us.es ([193.147.175.20]:41516 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394735AbfHBN3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 09:29:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 17A09FB459
        for <netdev@vger.kernel.org>; Fri,  2 Aug 2019 15:29:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F239ED190F
        for <netdev@vger.kernel.org>; Fri,  2 Aug 2019 15:29:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E2A55115105; Fri,  2 Aug 2019 15:29:31 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE9661150DA;
        Fri,  2 Aug 2019 15:29:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 02 Aug 2019 15:29:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.181.192])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 78F3A4265A31;
        Fri,  2 Aug 2019 15:29:28 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, saeedm@mellanox.com, wenxu@ucloud.cn,
        gerlitz.or@gmail.com, paulb@mellanox.com
Subject: [PATCH net-next 2/3] netfilter: nf_tables_offload: add offload field to basechain
Date:   Fri,  2 Aug 2019 15:28:45 +0200
Message-Id: <20190802132846.3067-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190802132846.3067-1-pablo@netfilter.org>
References: <20190802132846.3067-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wrap offload objects in struct nft_base_chain around structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: initial patch version.

 include/net/netfilter/nf_tables.h         | 6 ++++--
 include/net/netfilter/nf_tables_offload.h | 5 +++++
 net/netfilter/nf_tables_api.c             | 2 +-
 net/netfilter/nf_tables_offload.c         | 7 ++++---
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9b624566b82d..87dbe62c0f27 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -952,7 +952,7 @@ struct nft_stats {
  *	@stats: per-cpu chain stats
  *	@chain: the chain
  *	@dev_name: device name that this base chain is attached to (if any)
- *	@flow_block: flow block (for hardware offload)
+ *	@offload: hardware offload data
  */
 struct nft_base_chain {
 	struct nf_hook_ops		ops;
@@ -962,7 +962,9 @@ struct nft_base_chain {
 	struct nft_stats __percpu	*stats;
 	struct nft_chain		chain;
 	char 				dev_name[IFNAMSIZ];
-	struct flow_block		flow_block;
+	struct {
+		struct flow_block	flow_block;
+	} offload;
 };
 
 static inline struct nft_base_chain *nft_base_chain(const struct nft_chain *chain)
diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 3196663a10e3..fb3db391ade8 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -73,4 +73,9 @@ int nft_flow_rule_offload_commit(struct net *net);
 	(__reg)->key		= __key;				\
 	memset(&(__reg)->mask, 0xff, (__reg)->len);
 
+static inline void nft_basechain_offload_init(struct nft_base_chain *basechain)
+{
+	flow_block_init(&basechain->offload.flow_block);
+}
+
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 605a7cfe7ca7..a07d764c3555 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1662,7 +1662,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 		chain->flags |= NFT_BASE_CHAIN | flags;
 		basechain->policy = NF_ACCEPT;
-		flow_block_init(&basechain->flow_block);
+		nft_basechain_offload_init(basechain);
 	} else {
 		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
 		if (chain == NULL)
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 64f5fd5f240e..84615381b06f 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -113,10 +113,11 @@ static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
 static int nft_setup_cb_call(struct nft_base_chain *basechain,
 			     enum tc_setup_type type, void *type_data)
 {
+	struct flow_block *flow_block = &basechain->offload.flow_block;
 	struct flow_block_cb *block_cb;
 	int err;
 
-	list_for_each_entry(block_cb, &basechain->flow_block.cb_list, list) {
+	list_for_each_entry(block_cb, &flow_block->cb_list, list) {
 		err = block_cb->cb(type, type_data, block_cb->cb_priv);
 		if (err < 0)
 			return err;
@@ -154,7 +155,7 @@ static int nft_flow_offload_rule(struct nft_trans *trans,
 static int nft_flow_offload_bind(struct flow_block_offload *bo,
 				 struct nft_base_chain *basechain)
 {
-	list_splice(&bo->cb_list, &basechain->flow_block.cb_list);
+	list_splice(&bo->cb_list, &basechain->offload.flow_block.cb_list);
 	return 0;
 }
 
@@ -198,7 +199,7 @@ static int nft_flow_offload_chain(struct nft_trans *trans,
 		return -EOPNOTSUPP;
 
 	bo.command = cmd;
-	bo.block = &basechain->flow_block;
+	bo.block = &basechain->offload.flow_block;
 	bo.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
 	bo.extack = &extack;
 	INIT_LIST_HEAD(&bo.cb_list);
-- 
2.11.0

