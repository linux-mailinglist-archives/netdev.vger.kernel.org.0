Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADDB4E266E
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347395AbiCUMca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347377AbiCUMc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:32:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4795B84EE2;
        Mon, 21 Mar 2022 05:30:59 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E916763032;
        Mon, 21 Mar 2022 13:28:16 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/19] netfilter: nf_tables: cancel tracking for clobbered destination registers
Date:   Mon, 21 Mar 2022 13:30:37 +0100
Message-Id: <20220321123052.70553-5-pablo@netfilter.org>
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

Output of expressions might be larger than one single register, this might
clobber existing data. Reset tracking for all destination registers that
required to store the expression output.

This patch adds three new helper functions:

- nft_reg_track_update: cancel previous register tracking and update it.
- nft_reg_track_cancel: cancel any previous register tracking info.
- __nft_reg_track_cancel: cancel only one single register tracking info.

Partial register clobbering detection is also supported by checking the
.num_reg field which describes the number of register that are used.

This patch updates the following expressions:

- meta_bridge
- bitwise
- byteorder
- meta
- payload

to use these helper functions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      | 14 +++++++
 include/net/netfilter/nft_meta.h       |  1 +
 net/bridge/netfilter/nft_meta_bridge.c |  4 +-
 net/netfilter/nf_tables_api.c          | 52 ++++++++++++++++++++++++++
 net/netfilter/nft_bitwise.c            | 23 ++++++++----
 net/netfilter/nft_byteorder.c          |  3 +-
 net/netfilter/nft_meta.c               | 14 +++----
 net/netfilter/nft_payload.c            | 12 ++----
 8 files changed, 95 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index edabfb9e97ce..20af9d3557b9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -126,6 +126,7 @@ struct nft_regs_track {
 	struct {
 		const struct nft_expr		*selector;
 		const struct nft_expr		*bitwise;
+		u8				num_reg;
 	} regs[NFT_REG32_NUM];
 
 	const struct nft_expr			*cur;
@@ -1641,4 +1642,17 @@ static inline bool nft_reduce_is_readonly(const struct nft_expr *expr)
 	return expr->ops->reduce == NFT_REDUCE_READONLY;
 }
 
+void nft_reg_track_update(struct nft_regs_track *track,
+			  const struct nft_expr *expr, u8 dreg, u8 len);
+void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, u8 len);
+void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg);
+
+static inline bool nft_reg_track_cmp(struct nft_regs_track *track,
+				     const struct nft_expr *expr, u8 dreg)
+{
+	return track->regs[dreg].selector &&
+	       track->regs[dreg].selector->ops == expr->ops &&
+	       track->regs[dreg].num_reg == 0;
+}
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index 2dce55c736f4..246fd023dcf4 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -6,6 +6,7 @@
 
 struct nft_meta {
 	enum nft_meta_keys	key:8;
+	u8			len;
 	union {
 		u8		dreg;
 		u8		sreg;
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index c1ef9cc89b78..380a31ebf840 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -87,6 +87,7 @@ static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
 		return nft_meta_get_init(ctx, expr, tb);
 	}
 
+	priv->len = len;
 	return nft_parse_register_store(ctx, tb[NFTA_META_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, len);
 }
@@ -112,8 +113,7 @@ static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
 		if (track->regs[i].selector->ops != &nft_meta_bridge_get_ops)
 			continue;
 
-		track->regs[i].selector = NULL;
-		track->regs[i].bitwise = NULL;
+		__nft_reg_track_cancel(track, i);
 	}
 
 	return false;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6a10042243eb..a97e112fe406 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -550,6 +550,58 @@ static int nft_delflowtable(struct nft_ctx *ctx,
 	return err;
 }
 
+static void __nft_reg_track_clobber(struct nft_regs_track *track, u8 dreg)
+{
+	int i;
+
+	for (i = track->regs[dreg].num_reg; i > 0; i--)
+		__nft_reg_track_cancel(track, dreg - i);
+}
+
+static void __nft_reg_track_update(struct nft_regs_track *track,
+				   const struct nft_expr *expr,
+				   u8 dreg, u8 num_reg)
+{
+	track->regs[dreg].selector = expr;
+	track->regs[dreg].bitwise = NULL;
+	track->regs[dreg].num_reg = num_reg;
+}
+
+void nft_reg_track_update(struct nft_regs_track *track,
+			  const struct nft_expr *expr, u8 dreg, u8 len)
+{
+	unsigned int regcount;
+	int i;
+
+	__nft_reg_track_clobber(track, dreg);
+
+	regcount = DIV_ROUND_UP(len, NFT_REG32_SIZE);
+	for (i = 0; i < regcount; i++, dreg++)
+		__nft_reg_track_update(track, expr, dreg, i);
+}
+EXPORT_SYMBOL_GPL(nft_reg_track_update);
+
+void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, u8 len)
+{
+	unsigned int regcount;
+	int i;
+
+	__nft_reg_track_clobber(track, dreg);
+
+	regcount = DIV_ROUND_UP(len, NFT_REG32_SIZE);
+	for (i = 0; i < regcount; i++, dreg++)
+		__nft_reg_track_cancel(track, dreg);
+}
+EXPORT_SYMBOL_GPL(nft_reg_track_cancel);
+
+void __nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg)
+{
+	track->regs[dreg].selector = NULL;
+	track->regs[dreg].bitwise = NULL;
+	track->regs[dreg].num_reg = 0;
+}
+EXPORT_SYMBOL_GPL(__nft_reg_track_cancel);
+
 /*
  * Tables
  */
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 7b727d3ebf9d..dffda6612369 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -283,12 +283,16 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	const struct nft_bitwise *bitwise;
+	unsigned int regcount;
+	u8 dreg;
+	int i;
 
 	if (!track->regs[priv->sreg].selector)
 		return false;
 
 	bitwise = nft_expr_priv(expr);
 	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
+	    track->regs[priv->sreg].num_reg == 0 &&
 	    track->regs[priv->dreg].bitwise &&
 	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
 	    priv->sreg == bitwise->sreg &&
@@ -302,17 +306,21 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 		return true;
 	}
 
-	if (track->regs[priv->sreg].bitwise) {
-		track->regs[priv->dreg].selector = NULL;
-		track->regs[priv->dreg].bitwise = NULL;
+	if (track->regs[priv->sreg].bitwise ||
+	    track->regs[priv->sreg].num_reg != 0) {
+		nft_reg_track_cancel(track, priv->dreg, priv->len);
 		return false;
 	}
 
 	if (priv->sreg != priv->dreg) {
-		track->regs[priv->dreg].selector =
-			track->regs[priv->sreg].selector;
+		nft_reg_track_update(track, track->regs[priv->sreg].selector,
+				     priv->dreg, priv->len);
 	}
-	track->regs[priv->dreg].bitwise = expr;
+
+	dreg = priv->dreg;
+	regcount = DIV_ROUND_UP(priv->len, NFT_REG32_SIZE);
+	for (i = 0; i < regcount; i++, dreg++)
+		track->regs[priv->dreg].bitwise = expr;
 
 	return false;
 }
@@ -447,8 +455,7 @@ static bool nft_bitwise_fast_reduce(struct nft_regs_track *track,
 	}
 
 	if (track->regs[priv->sreg].bitwise) {
-		track->regs[priv->dreg].selector = NULL;
-		track->regs[priv->dreg].bitwise = NULL;
+		nft_reg_track_cancel(track, priv->dreg, NFT_REG32_SIZE);
 		return false;
 	}
 
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index e646e9ee4a98..d77609144b26 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -172,8 +172,7 @@ static bool nft_byteorder_reduce(struct nft_regs_track *track,
 {
 	struct nft_byteorder *priv = nft_expr_priv(expr);
 
-	track->regs[priv->dreg].selector = NULL;
-	track->regs[priv->dreg].bitwise = NULL;
+	nft_reg_track_cancel(track, priv->dreg, priv->len);
 
 	return false;
 }
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 5ab4df56c945..482eed7c7bbf 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -539,6 +539,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
+	priv->len = len;
 	return nft_parse_register_store(ctx, tb[NFTA_META_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, len);
 }
@@ -664,6 +665,7 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
+	priv->len = len;
 	err = nft_parse_register_load(tb[NFTA_META_SREG], &priv->sreg, len);
 	if (err < 0)
 		return err;
@@ -756,18 +758,15 @@ static bool nft_meta_get_reduce(struct nft_regs_track *track,
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct nft_meta *meta;
 
-	if (!track->regs[priv->dreg].selector ||
-	    track->regs[priv->dreg].selector->ops != expr->ops) {
-		track->regs[priv->dreg].selector = expr;
-		track->regs[priv->dreg].bitwise = NULL;
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
 
 	meta = nft_expr_priv(track->regs[priv->dreg].selector);
 	if (priv->key != meta->key ||
 	    priv->dreg != meta->dreg) {
-		track->regs[priv->dreg].selector = expr;
-		track->regs[priv->dreg].bitwise = NULL;
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
 
@@ -800,8 +799,7 @@ static bool nft_meta_set_reduce(struct nft_regs_track *track,
 		if (track->regs[i].selector->ops != &nft_meta_get_ops)
 			continue;
 
-		track->regs[i].selector = NULL;
-		track->regs[i].bitwise = NULL;
+		__nft_reg_track_cancel(track, i);
 	}
 
 	return false;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 5cc06aef4345..2e7ac007cb30 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -216,10 +216,8 @@ static bool nft_payload_reduce(struct nft_regs_track *track,
 	const struct nft_payload *priv = nft_expr_priv(expr);
 	const struct nft_payload *payload;
 
-	if (!track->regs[priv->dreg].selector ||
-	    track->regs[priv->dreg].selector->ops != expr->ops) {
-		track->regs[priv->dreg].selector = expr;
-		track->regs[priv->dreg].bitwise = NULL;
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
 
@@ -227,8 +225,7 @@ static bool nft_payload_reduce(struct nft_regs_track *track,
 	if (priv->base != payload->base ||
 	    priv->offset != payload->offset ||
 	    priv->len != payload->len) {
-		track->regs[priv->dreg].selector = expr;
-		track->regs[priv->dreg].bitwise = NULL;
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
 		return false;
 	}
 
@@ -815,8 +812,7 @@ static bool nft_payload_set_reduce(struct nft_regs_track *track,
 		    track->regs[i].selector->ops != &nft_payload_fast_ops)
 			continue;
 
-		track->regs[i].selector = NULL;
-		track->regs[i].bitwise = NULL;
+		__nft_reg_track_cancel(track, i);
 	}
 
 	return false;
-- 
2.30.2

