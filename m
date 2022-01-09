Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8240A488D39
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbiAIXRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:17:24 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42250 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237476AbiAIXRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:17:09 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id EC1B0646A2;
        Mon, 10 Jan 2022 00:14:17 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 30/32] netfilter: nft_bitwise: track register operations
Date:   Mon, 10 Jan 2022 00:16:38 +0100
Message-Id: <20220109231640.104123-31-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check if the destination register already contains the data that this
bitwise expression performs. This allows to skip this redundant
operation.

If the destination contains a different bitwise operation, cancel the
register tracking information. If the destination contains no bitwise
operation, update the register tracking information.

Update the payload and meta expression to check if this bitwise
operation has been already performed on the register. Hence, both the
payload/meta and the bitwise expressions are reduced.

There is also a special case: If source register != destination register
and source register is not updated by a previous bitwise operation, then
transfer selector from the source register to the destination register.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 +
 net/netfilter/nft_bitwise.c       | 95 +++++++++++++++++++++++++++++++
 net/netfilter/nft_meta.c          |  2 +-
 net/netfilter/nft_payload.c       |  2 +-
 4 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1c37ce61daea..eaf55da9a205 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -358,6 +358,8 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr);
+bool nft_expr_reduce_bitwise(struct nft_regs_track *track,
+			     const struct nft_expr *expr);
 
 struct nft_set_ext;
 
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 47b0dba95054..7b727d3ebf9d 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -278,12 +278,52 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
+static bool nft_bitwise_reduce(struct nft_regs_track *track,
+			       const struct nft_expr *expr)
+{
+	const struct nft_bitwise *priv = nft_expr_priv(expr);
+	const struct nft_bitwise *bitwise;
+
+	if (!track->regs[priv->sreg].selector)
+		return false;
+
+	bitwise = nft_expr_priv(expr);
+	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
+	    track->regs[priv->dreg].bitwise &&
+	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
+	    priv->sreg == bitwise->sreg &&
+	    priv->dreg == bitwise->dreg &&
+	    priv->op == bitwise->op &&
+	    priv->len == bitwise->len &&
+	    !memcmp(&priv->mask, &bitwise->mask, sizeof(priv->mask)) &&
+	    !memcmp(&priv->xor, &bitwise->xor, sizeof(priv->xor)) &&
+	    !memcmp(&priv->data, &bitwise->data, sizeof(priv->data))) {
+		track->cur = expr;
+		return true;
+	}
+
+	if (track->regs[priv->sreg].bitwise) {
+		track->regs[priv->dreg].selector = NULL;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	if (priv->sreg != priv->dreg) {
+		track->regs[priv->dreg].selector =
+			track->regs[priv->sreg].selector;
+	}
+	track->regs[priv->dreg].bitwise = expr;
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_bitwise_ops = {
 	.type		= &nft_bitwise_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_bitwise)),
 	.eval		= nft_bitwise_eval,
 	.init		= nft_bitwise_init,
 	.dump		= nft_bitwise_dump,
+	.reduce		= nft_bitwise_reduce,
 	.offload	= nft_bitwise_offload,
 };
 
@@ -385,12 +425,49 @@ static int nft_bitwise_fast_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
+static bool nft_bitwise_fast_reduce(struct nft_regs_track *track,
+				    const struct nft_expr *expr)
+{
+	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
+	const struct nft_bitwise_fast_expr *bitwise;
+
+	if (!track->regs[priv->sreg].selector)
+		return false;
+
+	bitwise = nft_expr_priv(expr);
+	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
+	    track->regs[priv->dreg].bitwise &&
+	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
+	    priv->sreg == bitwise->sreg &&
+	    priv->dreg == bitwise->dreg &&
+	    priv->mask == bitwise->mask &&
+	    priv->xor == bitwise->xor) {
+		track->cur = expr;
+		return true;
+	}
+
+	if (track->regs[priv->sreg].bitwise) {
+		track->regs[priv->dreg].selector = NULL;
+		track->regs[priv->dreg].bitwise = NULL;
+		return false;
+	}
+
+	if (priv->sreg != priv->dreg) {
+		track->regs[priv->dreg].selector =
+			track->regs[priv->sreg].selector;
+	}
+	track->regs[priv->dreg].bitwise = expr;
+
+	return false;
+}
+
 const struct nft_expr_ops nft_bitwise_fast_ops = {
 	.type		= &nft_bitwise_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_bitwise_fast_expr)),
 	.eval		= NULL, /* inlined */
 	.init		= nft_bitwise_fast_init,
 	.dump		= nft_bitwise_fast_dump,
+	.reduce		= nft_bitwise_fast_reduce,
 	.offload	= nft_bitwise_fast_offload,
 };
 
@@ -427,3 +504,21 @@ struct nft_expr_type nft_bitwise_type __read_mostly = {
 	.maxattr	= NFTA_BITWISE_MAX,
 	.owner		= THIS_MODULE,
 };
+
+bool nft_expr_reduce_bitwise(struct nft_regs_track *track,
+			     const struct nft_expr *expr)
+{
+	const struct nft_expr *last = track->last;
+	const struct nft_expr *next;
+
+	if (expr == last)
+		return false;
+
+	next = nft_expr_next(expr);
+	if (next->ops == &nft_bitwise_ops)
+		return nft_bitwise_reduce(track, next);
+	else if (next->ops == &nft_bitwise_fast_ops)
+		return nft_bitwise_fast_reduce(track, next);
+
+	return false;
+}
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 430f40bc3cb4..40fe48fcf9d0 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -774,7 +774,7 @@ static bool nft_meta_get_reduce(struct nft_regs_track *track,
 	if (!track->regs[priv->dreg].bitwise)
 		return true;
 
-	return false;
+	return nft_expr_reduce_bitwise(track, expr);
 }
 
 static const struct nft_expr_ops nft_meta_get_ops = {
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 7a7c66e9a50e..f518bf634997 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -235,7 +235,7 @@ static bool nft_payload_reduce(struct nft_regs_track *track,
 	if (!track->regs[priv->dreg].bitwise)
 		return true;
 
-	return false;
+	return nft_expr_reduce_bitwise(track, expr);
 }
 
 static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
-- 
2.30.2

