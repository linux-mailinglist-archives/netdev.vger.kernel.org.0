Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962156C587F
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 22:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjCVVI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 17:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjCVVIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 17:08:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D46AD27;
        Wed, 22 Mar 2023 14:08:18 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pf5gs-000421-Cp; Wed, 22 Mar 2023 22:08:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH net-next 2/5] netfilter: nft_masq: deduplicate eval call-backs
Date:   Wed, 22 Mar 2023 22:07:59 +0100
Message-Id: <20230322210802.6743-3-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322210802.6743-1-fw@strlen.de>
References: <20230322210802.6743-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

nft_masq has separate ipv4 and ipv6 call-backs which share much of their
code, and an inet one switch containing a switch that calls one of the
others based on the family of the packet.  Merge the ipv4 and ipv6 ones
into the inet one in order to get rid of the duplicate code.

Const-qualify the `priv` pointer since we don't need to write through it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_masq.c | 75 ++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 46 deletions(-)

diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 9544c2f16998..b115d77fbbc7 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -96,23 +96,39 @@ static int nft_masq_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static void nft_masq_ipv4_eval(const struct nft_expr *expr,
-			       struct nft_regs *regs,
-			       const struct nft_pktinfo *pkt)
+static void nft_masq_eval(const struct nft_expr *expr,
+			  struct nft_regs *regs,
+			  const struct nft_pktinfo *pkt)
 {
-	struct nft_masq *priv = nft_expr_priv(expr);
+	const struct nft_masq *priv = nft_expr_priv(expr);
 	struct nf_nat_range2 range;
 
 	memset(&range, 0, sizeof(range));
 	range.flags = priv->flags;
 	if (priv->sreg_proto_min) {
-		range.min_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_min]);
-		range.max_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_max]);
+		range.min_proto.all = (__force __be16)
+			nft_reg_load16(&regs->data[priv->sreg_proto_min]);
+		range.max_proto.all = (__force __be16)
+			nft_reg_load16(&regs->data[priv->sreg_proto_max]);
+	}
+
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		regs->verdict.code = nf_nat_masquerade_ipv4(pkt->skb,
+							    nft_hook(pkt),
+							    &range,
+							    nft_out(pkt));
+		break;
+#ifdef CONFIG_NF_TABLES_IPV6
+	case NFPROTO_IPV6:
+		regs->verdict.code = nf_nat_masquerade_ipv6(pkt->skb, &range,
+							    nft_out(pkt));
+		break;
+#endif
+	default:
+		WARN_ON_ONCE(1);
+		break;
 	}
-	regs->verdict.code = nf_nat_masquerade_ipv4(pkt->skb, nft_hook(pkt),
-						    &range, nft_out(pkt));
 }
 
 static void
@@ -125,7 +141,7 @@ static struct nft_expr_type nft_masq_ipv4_type;
 static const struct nft_expr_ops nft_masq_ipv4_ops = {
 	.type		= &nft_masq_ipv4_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
-	.eval		= nft_masq_ipv4_eval,
+	.eval		= nft_masq_eval,
 	.init		= nft_masq_init,
 	.destroy	= nft_masq_ipv4_destroy,
 	.dump		= nft_masq_dump,
@@ -143,25 +159,6 @@ static struct nft_expr_type nft_masq_ipv4_type __read_mostly = {
 };
 
 #ifdef CONFIG_NF_TABLES_IPV6
-static void nft_masq_ipv6_eval(const struct nft_expr *expr,
-			       struct nft_regs *regs,
-			       const struct nft_pktinfo *pkt)
-{
-	struct nft_masq *priv = nft_expr_priv(expr);
-	struct nf_nat_range2 range;
-
-	memset(&range, 0, sizeof(range));
-	range.flags = priv->flags;
-	if (priv->sreg_proto_min) {
-		range.min_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_min]);
-		range.max_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_max]);
-	}
-	regs->verdict.code = nf_nat_masquerade_ipv6(pkt->skb, &range,
-						    nft_out(pkt));
-}
-
 static void
 nft_masq_ipv6_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
@@ -172,7 +169,7 @@ static struct nft_expr_type nft_masq_ipv6_type;
 static const struct nft_expr_ops nft_masq_ipv6_ops = {
 	.type		= &nft_masq_ipv6_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
-	.eval		= nft_masq_ipv6_eval,
+	.eval		= nft_masq_eval,
 	.init		= nft_masq_init,
 	.destroy	= nft_masq_ipv6_destroy,
 	.dump		= nft_masq_dump,
@@ -204,20 +201,6 @@ static inline void nft_masq_module_exit_ipv6(void) {}
 #endif
 
 #ifdef CONFIG_NF_TABLES_INET
-static void nft_masq_inet_eval(const struct nft_expr *expr,
-			       struct nft_regs *regs,
-			       const struct nft_pktinfo *pkt)
-{
-	switch (nft_pf(pkt)) {
-	case NFPROTO_IPV4:
-		return nft_masq_ipv4_eval(expr, regs, pkt);
-	case NFPROTO_IPV6:
-		return nft_masq_ipv6_eval(expr, regs, pkt);
-	}
-
-	WARN_ON_ONCE(1);
-}
-
 static void
 nft_masq_inet_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
@@ -228,7 +211,7 @@ static struct nft_expr_type nft_masq_inet_type;
 static const struct nft_expr_ops nft_masq_inet_ops = {
 	.type		= &nft_masq_inet_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
-	.eval		= nft_masq_inet_eval,
+	.eval		= nft_masq_eval,
 	.init		= nft_masq_init,
 	.destroy	= nft_masq_inet_destroy,
 	.dump		= nft_masq_dump,
-- 
2.39.2

