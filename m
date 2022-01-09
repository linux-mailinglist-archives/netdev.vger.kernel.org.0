Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF46488D46
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbiAIXSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:18:37 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42250 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237447AbiAIXRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:17:06 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 63DF5607C1;
        Mon, 10 Jan 2022 00:14:14 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 24/32] netfilter: nft_limit: move stateful fields out of expression data
Date:   Mon, 10 Jan 2022 00:16:32 +0100
Message-Id: <20220109231640.104123-25-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the rule blob representation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_limit.c | 94 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 82 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index d6e0226b7603..f04be5be73a0 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -14,10 +14,14 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 
-struct nft_limit_priv {
+struct nft_limit {
 	spinlock_t	lock;
 	u64		last;
 	u64		tokens;
+};
+
+struct nft_limit_priv {
+	struct nft_limit *limit;
 	u64		tokens_max;
 	u64		rate;
 	u64		nsecs;
@@ -30,21 +34,21 @@ static inline bool nft_limit_eval(struct nft_limit_priv *priv, u64 cost)
 	u64 now, tokens;
 	s64 delta;
 
-	spin_lock_bh(&priv->lock);
+	spin_lock_bh(&priv->limit->lock);
 	now = ktime_get_ns();
-	tokens = priv->tokens + now - priv->last;
+	tokens = priv->limit->tokens + now - priv->limit->last;
 	if (tokens > priv->tokens_max)
 		tokens = priv->tokens_max;
 
-	priv->last = now;
+	priv->limit->last = now;
 	delta = tokens - cost;
 	if (delta >= 0) {
-		priv->tokens = delta;
-		spin_unlock_bh(&priv->lock);
+		priv->limit->tokens = delta;
+		spin_unlock_bh(&priv->limit->lock);
 		return priv->invert;
 	}
-	priv->tokens = tokens;
-	spin_unlock_bh(&priv->lock);
+	priv->limit->tokens = tokens;
+	spin_unlock_bh(&priv->limit->lock);
 	return !priv->invert;
 }
 
@@ -86,8 +90,12 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 				 priv->rate);
 	}
 
-	priv->tokens = tokens;
-	priv->tokens_max = priv->tokens;
+	priv->limit = kmalloc(sizeof(*priv->limit), GFP_KERNEL);
+	if (!priv->limit)
+		return -ENOMEM;
+
+	priv->limit->tokens = tokens;
+	priv->tokens_max = priv->limit->tokens;
 
 	if (tb[NFTA_LIMIT_FLAGS]) {
 		u32 flags = ntohl(nla_get_be32(tb[NFTA_LIMIT_FLAGS]));
@@ -95,8 +103,8 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 		if (flags & NFT_LIMIT_F_INV)
 			priv->invert = true;
 	}
-	priv->last = ktime_get_ns();
-	spin_lock_init(&priv->lock);
+	priv->limit->last = ktime_get_ns();
+	spin_lock_init(&priv->limit->lock);
 
 	return 0;
 }
@@ -121,6 +129,32 @@ static int nft_limit_dump(struct sk_buff *skb, const struct nft_limit_priv *priv
 	return -1;
 }
 
+static void nft_limit_destroy(const struct nft_ctx *ctx,
+			      const struct nft_limit_priv *priv)
+{
+	kfree(priv->limit);
+}
+
+static int nft_limit_clone(struct nft_limit_priv *priv_dst,
+			   const struct nft_limit_priv *priv_src)
+{
+	priv_dst->tokens_max = priv_src->tokens_max;
+	priv_dst->rate = priv_src->rate;
+	priv_dst->nsecs = priv_src->nsecs;
+	priv_dst->burst = priv_src->burst;
+	priv_dst->invert = priv_src->invert;
+
+	priv_dst->limit = kmalloc(sizeof(*priv_dst->limit), GFP_ATOMIC);
+	if (priv_dst->limit)
+		return -ENOMEM;
+
+	spin_lock_init(&priv_dst->limit->lock);
+	priv_dst->limit->tokens = priv_src->tokens_max;
+	priv_dst->limit->last = ktime_get_ns();
+
+	return 0;
+}
+
 struct nft_limit_priv_pkts {
 	struct nft_limit_priv	limit;
 	u64			cost;
@@ -166,12 +200,30 @@ static int nft_limit_pkts_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return nft_limit_dump(skb, &priv->limit, NFT_LIMIT_PKTS);
 }
 
+static void nft_limit_pkts_destroy(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	const struct nft_limit_priv_pkts *priv = nft_expr_priv(expr);
+
+	nft_limit_destroy(ctx, &priv->limit);
+}
+
+static int nft_limit_pkts_clone(struct nft_expr *dst, const struct nft_expr *src)
+{
+	struct nft_limit_priv_pkts *priv_dst = nft_expr_priv(dst);
+	struct nft_limit_priv_pkts *priv_src = nft_expr_priv(src);
+
+	return nft_limit_clone(&priv_dst->limit, &priv_src->limit);
+}
+
 static struct nft_expr_type nft_limit_type;
 static const struct nft_expr_ops nft_limit_pkts_ops = {
 	.type		= &nft_limit_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv_pkts)),
 	.eval		= nft_limit_pkts_eval,
 	.init		= nft_limit_pkts_init,
+	.destroy	= nft_limit_pkts_destroy,
+	.clone		= nft_limit_pkts_clone,
 	.dump		= nft_limit_pkts_dump,
 };
 
@@ -203,12 +255,30 @@ static int nft_limit_bytes_dump(struct sk_buff *skb,
 	return nft_limit_dump(skb, priv, NFT_LIMIT_PKT_BYTES);
 }
 
+static void nft_limit_bytes_destroy(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr)
+{
+	const struct nft_limit_priv *priv = nft_expr_priv(expr);
+
+	nft_limit_destroy(ctx, priv);
+}
+
+static int nft_limit_bytes_clone(struct nft_expr *dst, const struct nft_expr *src)
+{
+	struct nft_limit_priv *priv_dst = nft_expr_priv(dst);
+	struct nft_limit_priv *priv_src = nft_expr_priv(src);
+
+	return nft_limit_clone(priv_dst, priv_src);
+}
+
 static const struct nft_expr_ops nft_limit_bytes_ops = {
 	.type		= &nft_limit_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv)),
 	.eval		= nft_limit_bytes_eval,
 	.init		= nft_limit_bytes_init,
 	.dump		= nft_limit_bytes_dump,
+	.clone		= nft_limit_bytes_clone,
+	.destroy	= nft_limit_bytes_destroy,
 };
 
 static const struct nft_expr_ops *
-- 
2.30.2

