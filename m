Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87958100E49
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfKRVtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:49:40 -0500
Received: from correo.us.es ([193.147.175.20]:45790 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727295AbfKRVtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9AF45EBAF5
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C839D2B1E
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6E52F202AE; Mon, 18 Nov 2019 22:49:35 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3D2CA8271;
        Mon, 18 Nov 2019 22:49:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 766E042EE38F;
        Mon, 18 Nov 2019 22:49:30 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 16/18] netfilter: nf_tables_offload: undo updates if transaction fails
Date:   Mon, 18 Nov 2019 22:49:12 +0100
Message-Id: <20191118214914.142794-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nft_flow_rule_offload_commit() function might fail after several
successful commands, thus, leaving the hardware filtering policy in
inconsistent state.

This patch adds nft_flow_rule_offload_abort() function which undoes the
updates that have been already processed if one command in this
transaction fails. Hence, the hardware ruleset is left as it was before
this aborted transaction.

The deletion path needs to create the flow_rule object too, in case that
an existing rule needs to be re-added from the abort path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c     | 11 ++++++++
 net/netfilter/nf_tables_offload.c | 54 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2dc636faa322..4f0d880a8496 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -361,6 +361,7 @@ static struct nft_trans *nft_trans_rule_add(struct nft_ctx *ctx, int msg_type,
 
 static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 {
+	struct nft_flow_rule *flow;
 	struct nft_trans *trans;
 	int err;
 
@@ -368,6 +369,16 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 	if (trans == NULL)
 		return -ENOMEM;
 
+	if (ctx->chain->flags & NFT_CHAIN_HW_OFFLOAD) {
+		flow = nft_flow_rule_create(ctx->net, rule);
+		if (IS_ERR(flow)) {
+			nft_trans_destroy(trans);
+			return PTR_ERR(flow);
+		}
+
+		nft_trans_flow_rule(trans) = flow;
+	}
+
 	err = nf_tables_delrule_deactivate(ctx, rule);
 	if (err < 0) {
 		nft_trans_destroy(trans);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 6d5f3cd7f1b7..68f17a6921d8 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -389,6 +389,55 @@ static int nft_flow_offload_chain(struct nft_chain *chain, u8 *ppolicy,
 	return nft_flow_block_chain(basechain, NULL, cmd);
 }
 
+static void nft_flow_rule_offload_abort(struct net *net,
+					struct nft_trans *trans)
+{
+	int err = 0;
+
+	list_for_each_entry_continue_reverse(trans, &net->nft.commit_list, list) {
+		if (trans->ctx.family != NFPROTO_NETDEV)
+			continue;
+
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWCHAIN:
+			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD) ||
+			    nft_trans_chain_update(trans))
+				continue;
+
+			err = nft_flow_offload_chain(trans->ctx.chain, NULL,
+						     FLOW_BLOCK_UNBIND);
+			break;
+		case NFT_MSG_DELCHAIN:
+			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+				continue;
+
+			err = nft_flow_offload_chain(trans->ctx.chain, NULL,
+						     FLOW_BLOCK_BIND);
+			break;
+		case NFT_MSG_NEWRULE:
+			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+				continue;
+
+			err = nft_flow_offload_rule(trans->ctx.chain,
+						    nft_trans_rule(trans),
+						    NULL, FLOW_CLS_DESTROY);
+			break;
+		case NFT_MSG_DELRULE:
+			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+				continue;
+
+			err = nft_flow_offload_rule(trans->ctx.chain,
+						    nft_trans_rule(trans),
+						    nft_trans_flow_rule(trans),
+						    FLOW_CLS_REPLACE);
+			break;
+		}
+
+		if (WARN_ON_ONCE(err))
+			break;
+	}
+}
+
 int nft_flow_rule_offload_commit(struct net *net)
 {
 	struct nft_trans *trans;
@@ -441,8 +490,10 @@ int nft_flow_rule_offload_commit(struct net *net)
 			break;
 		}
 
-		if (err)
+		if (err) {
+			nft_flow_rule_offload_abort(net, trans);
 			break;
+		}
 	}
 
 	list_for_each_entry(trans, &net->nft.commit_list, list) {
@@ -451,6 +502,7 @@ int nft_flow_rule_offload_commit(struct net *net)
 
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWRULE:
+		case NFT_MSG_DELRULE:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
 				continue;
 
-- 
2.11.0

