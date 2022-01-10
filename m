Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D40D488D48
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbiAIXSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:18:39 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42240 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237437AbiAIXRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:17:05 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id BE7136468F;
        Mon, 10 Jan 2022 00:14:13 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 23/32] netfilter: nft_limit: rename stateful structure
Date:   Mon, 10 Jan 2022 00:16:31 +0100
Message-Id: <20220109231640.104123-24-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From struct nft_limit to nft_limit_priv.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_limit.c | 104 +++++++++++++++++++-------------------
 1 file changed, 52 insertions(+), 52 deletions(-)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 82ec27bdf941..d6e0226b7603 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -14,7 +14,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 
-struct nft_limit {
+struct nft_limit_priv {
 	spinlock_t	lock;
 	u64		last;
 	u64		tokens;
@@ -25,33 +25,33 @@ struct nft_limit {
 	bool		invert;
 };
 
-static inline bool nft_limit_eval(struct nft_limit *limit, u64 cost)
+static inline bool nft_limit_eval(struct nft_limit_priv *priv, u64 cost)
 {
 	u64 now, tokens;
 	s64 delta;
 
-	spin_lock_bh(&limit->lock);
+	spin_lock_bh(&priv->lock);
 	now = ktime_get_ns();
-	tokens = limit->tokens + now - limit->last;
-	if (tokens > limit->tokens_max)
-		tokens = limit->tokens_max;
+	tokens = priv->tokens + now - priv->last;
+	if (tokens > priv->tokens_max)
+		tokens = priv->tokens_max;
 
-	limit->last = now;
+	priv->last = now;
 	delta = tokens - cost;
 	if (delta >= 0) {
-		limit->tokens = delta;
-		spin_unlock_bh(&limit->lock);
-		return limit->invert;
+		priv->tokens = delta;
+		spin_unlock_bh(&priv->lock);
+		return priv->invert;
 	}
-	limit->tokens = tokens;
-	spin_unlock_bh(&limit->lock);
-	return !limit->invert;
+	priv->tokens = tokens;
+	spin_unlock_bh(&priv->lock);
+	return !priv->invert;
 }
 
 /* Use same default as in iptables. */
 #define NFT_LIMIT_PKT_BURST_DEFAULT	5
 
-static int nft_limit_init(struct nft_limit *limit,
+static int nft_limit_init(struct nft_limit_priv *priv,
 			  const struct nlattr * const tb[], bool pkts)
 {
 	u64 unit, tokens;
@@ -60,58 +60,58 @@ static int nft_limit_init(struct nft_limit *limit,
 	    tb[NFTA_LIMIT_UNIT] == NULL)
 		return -EINVAL;
 
-	limit->rate = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_RATE]));
+	priv->rate = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_RATE]));
 	unit = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_UNIT]));
-	limit->nsecs = unit * NSEC_PER_SEC;
-	if (limit->rate == 0 || limit->nsecs < unit)
+	priv->nsecs = unit * NSEC_PER_SEC;
+	if (priv->rate == 0 || priv->nsecs < unit)
 		return -EOVERFLOW;
 
 	if (tb[NFTA_LIMIT_BURST])
-		limit->burst = ntohl(nla_get_be32(tb[NFTA_LIMIT_BURST]));
+		priv->burst = ntohl(nla_get_be32(tb[NFTA_LIMIT_BURST]));
 
-	if (pkts && limit->burst == 0)
-		limit->burst = NFT_LIMIT_PKT_BURST_DEFAULT;
+	if (pkts && priv->burst == 0)
+		priv->burst = NFT_LIMIT_PKT_BURST_DEFAULT;
 
-	if (limit->rate + limit->burst < limit->rate)
+	if (priv->rate + priv->burst < priv->rate)
 		return -EOVERFLOW;
 
 	if (pkts) {
-		tokens = div64_u64(limit->nsecs, limit->rate) * limit->burst;
+		tokens = div64_u64(priv->nsecs, priv->rate) * priv->burst;
 	} else {
 		/* The token bucket size limits the number of tokens can be
 		 * accumulated. tokens_max specifies the bucket size.
 		 * tokens_max = unit * (rate + burst) / rate.
 		 */
-		tokens = div64_u64(limit->nsecs * (limit->rate + limit->burst),
-				 limit->rate);
+		tokens = div64_u64(priv->nsecs * (priv->rate + priv->burst),
+				 priv->rate);
 	}
 
-	limit->tokens = tokens;
-	limit->tokens_max = limit->tokens;
+	priv->tokens = tokens;
+	priv->tokens_max = priv->tokens;
 
 	if (tb[NFTA_LIMIT_FLAGS]) {
 		u32 flags = ntohl(nla_get_be32(tb[NFTA_LIMIT_FLAGS]));
 
 		if (flags & NFT_LIMIT_F_INV)
-			limit->invert = true;
+			priv->invert = true;
 	}
-	limit->last = ktime_get_ns();
-	spin_lock_init(&limit->lock);
+	priv->last = ktime_get_ns();
+	spin_lock_init(&priv->lock);
 
 	return 0;
 }
 
-static int nft_limit_dump(struct sk_buff *skb, const struct nft_limit *limit,
+static int nft_limit_dump(struct sk_buff *skb, const struct nft_limit_priv *priv,
 			  enum nft_limit_type type)
 {
-	u32 flags = limit->invert ? NFT_LIMIT_F_INV : 0;
-	u64 secs = div_u64(limit->nsecs, NSEC_PER_SEC);
+	u32 flags = priv->invert ? NFT_LIMIT_F_INV : 0;
+	u64 secs = div_u64(priv->nsecs, NSEC_PER_SEC);
 
-	if (nla_put_be64(skb, NFTA_LIMIT_RATE, cpu_to_be64(limit->rate),
+	if (nla_put_be64(skb, NFTA_LIMIT_RATE, cpu_to_be64(priv->rate),
 			 NFTA_LIMIT_PAD) ||
 	    nla_put_be64(skb, NFTA_LIMIT_UNIT, cpu_to_be64(secs),
 			 NFTA_LIMIT_PAD) ||
-	    nla_put_be32(skb, NFTA_LIMIT_BURST, htonl(limit->burst)) ||
+	    nla_put_be32(skb, NFTA_LIMIT_BURST, htonl(priv->burst)) ||
 	    nla_put_be32(skb, NFTA_LIMIT_TYPE, htonl(type)) ||
 	    nla_put_be32(skb, NFTA_LIMIT_FLAGS, htonl(flags)))
 		goto nla_put_failure;
@@ -121,8 +121,8 @@ static int nft_limit_dump(struct sk_buff *skb, const struct nft_limit *limit,
 	return -1;
 }
 
-struct nft_limit_pkts {
-	struct nft_limit	limit;
+struct nft_limit_priv_pkts {
+	struct nft_limit_priv	limit;
 	u64			cost;
 };
 
@@ -130,7 +130,7 @@ static void nft_limit_pkts_eval(const struct nft_expr *expr,
 				struct nft_regs *regs,
 				const struct nft_pktinfo *pkt)
 {
-	struct nft_limit_pkts *priv = nft_expr_priv(expr);
+	struct nft_limit_priv_pkts *priv = nft_expr_priv(expr);
 
 	if (nft_limit_eval(&priv->limit, priv->cost))
 		regs->verdict.code = NFT_BREAK;
@@ -148,7 +148,7 @@ static int nft_limit_pkts_init(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr,
 			       const struct nlattr * const tb[])
 {
-	struct nft_limit_pkts *priv = nft_expr_priv(expr);
+	struct nft_limit_priv_pkts *priv = nft_expr_priv(expr);
 	int err;
 
 	err = nft_limit_init(&priv->limit, tb, true);
@@ -161,7 +161,7 @@ static int nft_limit_pkts_init(const struct nft_ctx *ctx,
 
 static int nft_limit_pkts_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
-	const struct nft_limit_pkts *priv = nft_expr_priv(expr);
+	const struct nft_limit_priv_pkts *priv = nft_expr_priv(expr);
 
 	return nft_limit_dump(skb, &priv->limit, NFT_LIMIT_PKTS);
 }
@@ -169,7 +169,7 @@ static int nft_limit_pkts_dump(struct sk_buff *skb, const struct nft_expr *expr)
 static struct nft_expr_type nft_limit_type;
 static const struct nft_expr_ops nft_limit_pkts_ops = {
 	.type		= &nft_limit_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_pkts)),
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv_pkts)),
 	.eval		= nft_limit_pkts_eval,
 	.init		= nft_limit_pkts_init,
 	.dump		= nft_limit_pkts_dump,
@@ -179,7 +179,7 @@ static void nft_limit_bytes_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
 {
-	struct nft_limit *priv = nft_expr_priv(expr);
+	struct nft_limit_priv *priv = nft_expr_priv(expr);
 	u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);
 
 	if (nft_limit_eval(priv, cost))
@@ -190,7 +190,7 @@ static int nft_limit_bytes_init(const struct nft_ctx *ctx,
 				const struct nft_expr *expr,
 				const struct nlattr * const tb[])
 {
-	struct nft_limit *priv = nft_expr_priv(expr);
+	struct nft_limit_priv *priv = nft_expr_priv(expr);
 
 	return nft_limit_init(priv, tb, false);
 }
@@ -198,14 +198,14 @@ static int nft_limit_bytes_init(const struct nft_ctx *ctx,
 static int nft_limit_bytes_dump(struct sk_buff *skb,
 				const struct nft_expr *expr)
 {
-	const struct nft_limit *priv = nft_expr_priv(expr);
+	const struct nft_limit_priv *priv = nft_expr_priv(expr);
 
 	return nft_limit_dump(skb, priv, NFT_LIMIT_PKT_BYTES);
 }
 
 static const struct nft_expr_ops nft_limit_bytes_ops = {
 	.type		= &nft_limit_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit)),
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv)),
 	.eval		= nft_limit_bytes_eval,
 	.init		= nft_limit_bytes_init,
 	.dump		= nft_limit_bytes_dump,
@@ -240,7 +240,7 @@ static void nft_limit_obj_pkts_eval(struct nft_object *obj,
 				    struct nft_regs *regs,
 				    const struct nft_pktinfo *pkt)
 {
-	struct nft_limit_pkts *priv = nft_obj_data(obj);
+	struct nft_limit_priv_pkts *priv = nft_obj_data(obj);
 
 	if (nft_limit_eval(&priv->limit, priv->cost))
 		regs->verdict.code = NFT_BREAK;
@@ -250,7 +250,7 @@ static int nft_limit_obj_pkts_init(const struct nft_ctx *ctx,
 				   const struct nlattr * const tb[],
 				   struct nft_object *obj)
 {
-	struct nft_limit_pkts *priv = nft_obj_data(obj);
+	struct nft_limit_priv_pkts *priv = nft_obj_data(obj);
 	int err;
 
 	err = nft_limit_init(&priv->limit, tb, true);
@@ -265,7 +265,7 @@ static int nft_limit_obj_pkts_dump(struct sk_buff *skb,
 				   struct nft_object *obj,
 				   bool reset)
 {
-	const struct nft_limit_pkts *priv = nft_obj_data(obj);
+	const struct nft_limit_priv_pkts *priv = nft_obj_data(obj);
 
 	return nft_limit_dump(skb, &priv->limit, NFT_LIMIT_PKTS);
 }
@@ -273,7 +273,7 @@ static int nft_limit_obj_pkts_dump(struct sk_buff *skb,
 static struct nft_object_type nft_limit_obj_type;
 static const struct nft_object_ops nft_limit_obj_pkts_ops = {
 	.type		= &nft_limit_obj_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_pkts)),
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv_pkts)),
 	.init		= nft_limit_obj_pkts_init,
 	.eval		= nft_limit_obj_pkts_eval,
 	.dump		= nft_limit_obj_pkts_dump,
@@ -283,7 +283,7 @@ static void nft_limit_obj_bytes_eval(struct nft_object *obj,
 				     struct nft_regs *regs,
 				     const struct nft_pktinfo *pkt)
 {
-	struct nft_limit *priv = nft_obj_data(obj);
+	struct nft_limit_priv *priv = nft_obj_data(obj);
 	u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);
 
 	if (nft_limit_eval(priv, cost))
@@ -294,7 +294,7 @@ static int nft_limit_obj_bytes_init(const struct nft_ctx *ctx,
 				    const struct nlattr * const tb[],
 				    struct nft_object *obj)
 {
-	struct nft_limit *priv = nft_obj_data(obj);
+	struct nft_limit_priv *priv = nft_obj_data(obj);
 
 	return nft_limit_init(priv, tb, false);
 }
@@ -303,7 +303,7 @@ static int nft_limit_obj_bytes_dump(struct sk_buff *skb,
 				    struct nft_object *obj,
 				    bool reset)
 {
-	const struct nft_limit *priv = nft_obj_data(obj);
+	const struct nft_limit_priv *priv = nft_obj_data(obj);
 
 	return nft_limit_dump(skb, priv, NFT_LIMIT_PKT_BYTES);
 }
@@ -311,7 +311,7 @@ static int nft_limit_obj_bytes_dump(struct sk_buff *skb,
 static struct nft_object_type nft_limit_obj_type;
 static const struct nft_object_ops nft_limit_obj_bytes_ops = {
 	.type		= &nft_limit_obj_type,
-	.size		= sizeof(struct nft_limit),
+	.size		= sizeof(struct nft_limit_priv),
 	.init		= nft_limit_obj_bytes_init,
 	.eval		= nft_limit_obj_bytes_eval,
 	.dump		= nft_limit_obj_bytes_dump,
-- 
2.30.2

