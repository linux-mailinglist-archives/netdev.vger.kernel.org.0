Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5DA4E268D
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347394AbiCUMc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347374AbiCUMc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:32:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DCDC383037;
        Mon, 21 Mar 2022 05:30:59 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8826663033;
        Mon, 21 Mar 2022 13:28:17 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/19] netfilter: nft_ct: track register operations
Date:   Mon, 21 Mar 2022 13:30:38 +0100
Message-Id: <20220321123052.70553-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321123052.70553-1-pablo@netfilter.org>
References: <20220321123052.70553-1-pablo@netfilter.org>
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

Check if the destination register already contains the data that this ct
expression performs. This allows to skip this redundant operation. If
the destination contains a different selector, update the register
tracking information.

Export nft_expr_reduce_bitwise as a symbol since nft_ct might be
compiled as a module.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c |  1 +
 net/netfilter/nft_ct.c      | 47 +++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index dffda6612369..38caa66632b4 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -529,3 +529,4 @@ bool nft_expr_reduce_bitwise(struct nft_regs_track *track,
 
 	return false;
 }
+EXPORT_SYMBOL_GPL(nft_expr_reduce_bitwise);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 1ec9a7e96e59..d8e1614918a1 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -26,6 +26,7 @@
 struct nft_ct {
 	enum nft_ct_keys	key:8;
 	enum ip_conntrack_dir	dir:8;
+	u8			len;
 	union {
 		u8		dreg;
 		u8		sreg;
@@ -500,6 +501,7 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		}
 	}
 
+	priv->len = len;
 	err = nft_parse_register_store(ctx, tb[NFTA_CT_DREG], &priv->dreg, NULL,
 				       NFT_DATA_VALUE, len);
 	if (err < 0)
@@ -608,6 +610,7 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 		}
 	}
 
+	priv->len = len;
 	err = nft_parse_register_load(tb[NFTA_CT_SREG], &priv->sreg, len);
 	if (err < 0)
 		goto err1;
@@ -677,6 +680,29 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static bool nft_ct_get_reduce(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_ct *priv = nft_expr_priv(expr);
+	const struct nft_ct *ct;
+
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	ct = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->key != ct->key) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return nft_expr_reduce_bitwise(track, expr);
+}
+
 static int nft_ct_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
@@ -710,8 +736,27 @@ static const struct nft_expr_ops nft_ct_get_ops = {
 	.init		= nft_ct_get_init,
 	.destroy	= nft_ct_get_destroy,
 	.dump		= nft_ct_get_dump,
+	.reduce		= nft_ct_get_reduce,
 };
 
+static bool nft_ct_set_reduce(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	int i;
+
+	for (i = 0; i < NFT_REG32_NUM; i++) {
+		if (!track->regs[i].selector)
+			continue;
+
+		if (track->regs[i].selector->ops != &nft_ct_get_ops)
+			continue;
+
+		__nft_reg_track_cancel(track, i);
+	}
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_ct_set_ops = {
 	.type		= &nft_ct_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
@@ -719,6 +764,7 @@ static const struct nft_expr_ops nft_ct_set_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
+	.reduce		= nft_ct_set_reduce,
 };
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
@@ -729,6 +775,7 @@ static const struct nft_expr_ops nft_ct_set_zone_ops = {
 	.init		= nft_ct_set_init,
 	.destroy	= nft_ct_set_destroy,
 	.dump		= nft_ct_set_dump,
+	.reduce		= nft_ct_set_reduce,
 };
 #endif
 
-- 
2.30.2

