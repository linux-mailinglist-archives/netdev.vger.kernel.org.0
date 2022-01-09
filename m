Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D97E488D2D
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237413AbiAIXRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:17:17 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42124 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237389AbiAIXRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:17:03 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E448064291;
        Mon, 10 Jan 2022 00:14:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 20/32] netfilter: nft_last: move stateful fields out of expression data
Date:   Mon, 10 Jan 2022 00:16:28 +0100
Message-Id: <20220109231640.104123-21-pablo@netfilter.org>
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
 net/netfilter/nft_last.c | 69 +++++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 304e33cbed9b..5ee33d0ccd4e 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -8,9 +8,13 @@
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
 
+struct nft_last {
+	unsigned long	jiffies;
+	unsigned int	set;
+};
+
 struct nft_last_priv {
-	unsigned long	last_jiffies;
-	unsigned int	last_set;
+	struct nft_last	*last;
 };
 
 static const struct nla_policy nft_last_policy[NFTA_LAST_MAX + 1] = {
@@ -22,47 +26,55 @@ static int nft_last_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			 const struct nlattr * const tb[])
 {
 	struct nft_last_priv *priv = nft_expr_priv(expr);
+	struct nft_last *last;
 	u64 last_jiffies;
-	u32 last_set = 0;
 	int err;
 
-	if (tb[NFTA_LAST_SET]) {
-		last_set = ntohl(nla_get_be32(tb[NFTA_LAST_SET]));
-		if (last_set == 1)
-			priv->last_set = 1;
-	}
+	last = kzalloc(sizeof(*last), GFP_KERNEL);
+	if (!last)
+		return -ENOMEM;
+
+	if (tb[NFTA_LAST_SET])
+		last->set = ntohl(nla_get_be32(tb[NFTA_LAST_SET]));
 
-	if (last_set && tb[NFTA_LAST_MSECS]) {
+	if (last->set && tb[NFTA_LAST_MSECS]) {
 		err = nf_msecs_to_jiffies64(tb[NFTA_LAST_MSECS], &last_jiffies);
 		if (err < 0)
-			return err;
+			goto err;
 
-		priv->last_jiffies = jiffies - (unsigned long)last_jiffies;
+		last->jiffies = jiffies - (unsigned long)last_jiffies;
 	}
+	priv->last = last;
 
 	return 0;
+err:
+	kfree(last);
+
+	return err;
 }
 
 static void nft_last_eval(const struct nft_expr *expr,
 			  struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
 	struct nft_last_priv *priv = nft_expr_priv(expr);
+	struct nft_last *last = priv->last;
 
-	if (READ_ONCE(priv->last_jiffies) != jiffies)
-		WRITE_ONCE(priv->last_jiffies, jiffies);
-	if (READ_ONCE(priv->last_set) == 0)
-		WRITE_ONCE(priv->last_set, 1);
+	if (READ_ONCE(last->jiffies) != jiffies)
+		WRITE_ONCE(last->jiffies, jiffies);
+	if (READ_ONCE(last->set) == 0)
+		WRITE_ONCE(last->set, 1);
 }
 
 static int nft_last_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	struct nft_last_priv *priv = nft_expr_priv(expr);
-	unsigned long last_jiffies = READ_ONCE(priv->last_jiffies);
-	u32 last_set = READ_ONCE(priv->last_set);
+	struct nft_last *last = priv->last;
+	unsigned long last_jiffies = READ_ONCE(last->jiffies);
+	u32 last_set = READ_ONCE(last->set);
 	__be64 msecs;
 
 	if (time_before(jiffies, last_jiffies)) {
-		WRITE_ONCE(priv->last_set, 0);
+		WRITE_ONCE(last->set, 0);
 		last_set = 0;
 	}
 
@@ -81,11 +93,32 @@ static int nft_last_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static void nft_last_destroy(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr)
+{
+	struct nft_last_priv *priv = nft_expr_priv(expr);
+
+	kfree(priv->last);
+}
+
+static int nft_last_clone(struct nft_expr *dst, const struct nft_expr *src)
+{
+	struct nft_last_priv *priv_dst = nft_expr_priv(dst);
+
+	priv_dst->last = kzalloc(sizeof(*priv_dst->last), GFP_ATOMIC);
+	if (priv_dst->last)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_last_ops = {
 	.type		= &nft_last_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_last_priv)),
 	.eval		= nft_last_eval,
 	.init		= nft_last_init,
+	.destroy	= nft_last_destroy,
+	.clone		= nft_last_clone,
 	.dump		= nft_last_dump,
 };
 
-- 
2.30.2

