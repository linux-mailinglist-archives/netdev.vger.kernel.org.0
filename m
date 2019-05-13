Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98561B35A
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 11:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfEMJ4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 05:56:41 -0400
Received: from mail.us.es ([193.147.175.20]:34118 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727458AbfEMJ4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 05:56:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DEDD94DE725
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:56:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CAAEBDA79D
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:56:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BD267DA7A0; Mon, 13 May 2019 11:56:38 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55320DA708;
        Mon, 13 May 2019 11:56:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 11:56:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 270994265A32;
        Mon, 13 May 2019 11:56:36 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/13] netfilter: nf_tables: delay chain policy update until transaction is complete
Date:   Mon, 13 May 2019 11:56:18 +0200
Message-Id: <20190513095630.32443-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190513095630.32443-1-pablo@netfilter.org>
References: <20190513095630.32443-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When we process a long ruleset of the form

chain input {
   type filter hook input priority filter; policy drop;
   ...
}

Then the base chain gets registered early on, we then continue to
process/validate the next messages coming in the same transaction.

Problem is that if the base chain policy is 'drop', it will take effect
immediately, which causes all traffic to get blocked until the
transaction completes or is aborted.

Fix this by deferring the policy until the transaction has been
processed and all of the rules have been flagged as active.

Reported-by: Jann Haber <jann.haber@selfnet.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 50 +++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1606eaa5ae0d..f2e12ae50544 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -214,33 +214,33 @@ static int nft_deltable(struct nft_ctx *ctx)
 	return err;
 }
 
-static int nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
+static struct nft_trans *nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
 {
 	struct nft_trans *trans;
 
 	trans = nft_trans_alloc(ctx, msg_type, sizeof(struct nft_trans_chain));
 	if (trans == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	if (msg_type == NFT_MSG_NEWCHAIN)
 		nft_activate_next(ctx->net, ctx->chain);
 
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
-	return 0;
+	return trans;
 }
 
 static int nft_delchain(struct nft_ctx *ctx)
 {
-	int err;
+	struct nft_trans *trans;
 
-	err = nft_trans_chain_add(ctx, NFT_MSG_DELCHAIN);
-	if (err < 0)
-		return err;
+	trans = nft_trans_chain_add(ctx, NFT_MSG_DELCHAIN);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	ctx->table->use--;
 	nft_deactivate_next(ctx->net, ctx->chain);
 
-	return err;
+	return 0;
 }
 
 static void nft_rule_expr_activate(const struct nft_ctx *ctx,
@@ -1615,6 +1615,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	struct nft_base_chain *basechain;
 	struct nft_stats __percpu *stats;
 	struct net *net = ctx->net;
+	struct nft_trans *trans;
 	struct nft_chain *chain;
 	struct nft_rule **rules;
 	int err;
@@ -1662,7 +1663,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		ops->dev	= hook.dev;
 
 		chain->flags |= NFT_BASE_CHAIN;
-		basechain->policy = policy;
+		basechain->policy = NF_ACCEPT;
 	} else {
 		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
 		if (chain == NULL)
@@ -1698,13 +1699,18 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	if (err)
 		goto err2;
 
-	err = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
-	if (err < 0) {
+	trans = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
 		rhltable_remove(&table->chains_ht, &chain->rhlhead,
 				nft_chain_ht_params);
 		goto err2;
 	}
 
+	nft_trans_chain_policy(trans) = -1;
+	if (nft_is_base_chain(chain))
+		nft_trans_chain_policy(trans) = policy;
+
 	table->use++;
 	list_add_tail_rcu(&chain->list, &table->chains);
 
@@ -6311,6 +6317,27 @@ static int nf_tables_validate(struct net *net)
 	return 0;
 }
 
+/* a drop policy has to be deferred until all rules have been activated,
+ * otherwise a large ruleset that contains a drop-policy base chain will
+ * cause all packets to get dropped until the full transaction has been
+ * processed.
+ *
+ * We defer the drop policy until the transaction has been finalized.
+ */
+static void nft_chain_commit_drop_policy(struct nft_trans *trans)
+{
+	struct nft_base_chain *basechain;
+
+	if (nft_trans_chain_policy(trans) != NF_DROP)
+		return;
+
+	if (!nft_is_base_chain(trans->ctx.chain))
+		return;
+
+	basechain = nft_base_chain(trans->ctx.chain);
+	basechain->policy = NF_DROP;
+}
+
 static void nft_chain_commit_update(struct nft_trans *trans)
 {
 	struct nft_base_chain *basechain;
@@ -6632,6 +6659,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN);
 				/* trans destroyed after rcu grace period */
 			} else {
+				nft_chain_commit_drop_policy(trans);
 				nft_clear(net, trans->ctx.chain);
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN);
 				nft_trans_destroy(trans);
-- 
2.11.0

