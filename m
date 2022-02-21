Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40EE4BDEC1
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380070AbiBUQSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:18:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380074AbiBUQSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:18:32 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0FCC2714D;
        Mon, 21 Feb 2022 08:18:08 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8F270642E5;
        Mon, 21 Feb 2022 17:17:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf 2/5] netfilter: nf_tables_offload: incorrect flow offload action array size
Date:   Mon, 21 Feb 2022 17:17:54 +0100
Message-Id: <20220221161757.250801-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220221161757.250801-1-pablo@netfilter.org>
References: <20220221161757.250801-1-pablo@netfilter.org>
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

immediate verdict expression needs to allocate one slot in the flow offload
action array, however, immediate data expression does not need to do so.

fwd and dup expression need to allocate one slot, this is missing.

Add a new offload_action interface to report if this expression needs to
allocate one slot in the flow offload action array.

Fixes: be2861dc36d7 ("netfilter: nft_{fwd,dup}_netdev: add offload support")
Reported-and-tested-by: Nick Gregory <Nick.Gregory@Sophos.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h         |  2 +-
 include/net/netfilter/nf_tables_offload.h |  2 --
 net/netfilter/nf_tables_offload.c         |  3 ++-
 net/netfilter/nft_dup_netdev.c            |  6 ++++++
 net/netfilter/nft_fwd_netdev.c            |  6 ++++++
 net/netfilter/nft_immediate.c             | 12 +++++++++++-
 6 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index eaf55da9a205..c4c0861deac1 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -905,9 +905,9 @@ struct nft_expr_ops {
 	int				(*offload)(struct nft_offload_ctx *ctx,
 						   struct nft_flow_rule *flow,
 						   const struct nft_expr *expr);
+	bool				(*offload_action)(const struct nft_expr *expr);
 	void				(*offload_stats)(struct nft_expr *expr,
 							 const struct flow_stats *stats);
-	u32				offload_flags;
 	const struct nft_expr_type	*type;
 	void				*data;
 };
diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index f9d95ff82df8..797147843958 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -67,8 +67,6 @@ struct nft_flow_rule {
 	struct flow_rule	*rule;
 };
 
-#define NFT_OFFLOAD_F_ACTION	(1 << 0)
-
 void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
 				 enum flow_dissector_key_id addr_type);
 
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 9656c1646222..2d36952b1392 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -94,7 +94,8 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 
 	expr = nft_expr_first(rule);
 	while (nft_expr_more(rule, expr)) {
-		if (expr->ops->offload_flags & NFT_OFFLOAD_F_ACTION)
+		if (expr->ops->offload_action &&
+		    expr->ops->offload_action(expr))
 			num_actions++;
 
 		expr = nft_expr_next(expr);
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index bbf3fcba3df4..5b5c607fbf83 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -67,6 +67,11 @@ static int nft_dup_netdev_offload(struct nft_offload_ctx *ctx,
 	return nft_fwd_dup_netdev_offload(ctx, flow, FLOW_ACTION_MIRRED, oif);
 }
 
+static bool nft_dup_netdev_offload_action(const struct nft_expr *expr)
+{
+	return true;
+}
+
 static struct nft_expr_type nft_dup_netdev_type;
 static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.type		= &nft_dup_netdev_type,
@@ -75,6 +80,7 @@ static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.init		= nft_dup_netdev_init,
 	.dump		= nft_dup_netdev_dump,
 	.offload	= nft_dup_netdev_offload,
+	.offload_action	= nft_dup_netdev_offload_action,
 };
 
 static struct nft_expr_type nft_dup_netdev_type __read_mostly = {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index fa9301ca6033..619e394a91de 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -79,6 +79,11 @@ static int nft_fwd_netdev_offload(struct nft_offload_ctx *ctx,
 	return nft_fwd_dup_netdev_offload(ctx, flow, FLOW_ACTION_REDIRECT, oif);
 }
 
+static bool nft_fwd_netdev_offload_action(const struct nft_expr *expr)
+{
+	return true;
+}
+
 struct nft_fwd_neigh {
 	u8			sreg_dev;
 	u8			sreg_addr;
@@ -222,6 +227,7 @@ static const struct nft_expr_ops nft_fwd_netdev_ops = {
 	.dump		= nft_fwd_netdev_dump,
 	.validate	= nft_fwd_validate,
 	.offload	= nft_fwd_netdev_offload,
+	.offload_action	= nft_fwd_netdev_offload_action,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 90c64d27ae53..d0f67d325bdf 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -213,6 +213,16 @@ static int nft_immediate_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
+static bool nft_immediate_offload_action(const struct nft_expr *expr)
+{
+	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+
+	if (priv->dreg == NFT_REG_VERDICT)
+		return true;
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_imm_ops = {
 	.type		= &nft_imm_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
@@ -224,7 +234,7 @@ static const struct nft_expr_ops nft_imm_ops = {
 	.dump		= nft_immediate_dump,
 	.validate	= nft_immediate_validate,
 	.offload	= nft_immediate_offload,
-	.offload_flags	= NFT_OFFLOAD_F_ACTION,
+	.offload_action	= nft_immediate_offload_action,
 };
 
 struct nft_expr_type nft_imm_type __read_mostly = {
-- 
2.30.2

