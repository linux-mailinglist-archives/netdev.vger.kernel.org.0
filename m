Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0B55136BC
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348267AbiD1OYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348261AbiD1OYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:24:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64C7AAFB22;
        Thu, 28 Apr 2022 07:21:16 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/3] netfilter: nft_socket: only do sk lookups when indev is available
Date:   Thu, 28 Apr 2022 16:21:09 +0200
Message-Id: <20220428142109.38726-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220428142109.38726-1-pablo@netfilter.org>
References: <20220428142109.38726-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Check if the incoming interface is available and NFT_BREAK
in case neither skb->sk nor input device are set.

Because nf_sk_lookup_slow*() assume packet headers are in the
'in' direction, use in postrouting is not going to yield a meaningful
result.  Same is true for the forward chain, so restrict the use
to prerouting, input and output.

Use in output work if a socket is already attached to the skb.

Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
Reported-and-tested-by: Topi Miettinen <toiwoton@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 52 ++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 6d9e8e0a3a7d..05ae5a338b6f 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -54,6 +54,32 @@ nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo
 }
 #endif
 
+static struct sock *nft_socket_do_lookup(const struct nft_pktinfo *pkt)
+{
+	const struct net_device *indev = nft_in(pkt);
+	const struct sk_buff *skb = pkt->skb;
+	struct sock *sk = NULL;
+
+	if (!indev)
+		return NULL;
+
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		sk = nf_sk_lookup_slow_v4(nft_net(pkt), skb, indev);
+		break;
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+	case NFPROTO_IPV6:
+		sk = nf_sk_lookup_slow_v6(nft_net(pkt), skb, indev);
+		break;
+#endif
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	return sk;
+}
+
 static void nft_socket_eval(const struct nft_expr *expr,
 			    struct nft_regs *regs,
 			    const struct nft_pktinfo *pkt)
@@ -67,20 +93,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		sk = NULL;
 
 	if (!sk)
-		switch(nft_pf(pkt)) {
-		case NFPROTO_IPV4:
-			sk = nf_sk_lookup_slow_v4(nft_net(pkt), skb, nft_in(pkt));
-			break;
-#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
-		case NFPROTO_IPV6:
-			sk = nf_sk_lookup_slow_v6(nft_net(pkt), skb, nft_in(pkt));
-			break;
-#endif
-		default:
-			WARN_ON_ONCE(1);
-			regs->verdict.code = NFT_BREAK;
-			return;
-		}
+		sk = nft_socket_do_lookup(pkt);
 
 	if (!sk) {
 		regs->verdict.code = NFT_BREAK;
@@ -224,6 +237,16 @@ static bool nft_socket_reduce(struct nft_regs_track *track,
 	return nft_expr_reduce_bitwise(track, expr);
 }
 
+static int nft_socket_validate(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain,
+					(1 << NF_INET_PRE_ROUTING) |
+					(1 << NF_INET_LOCAL_IN) |
+					(1 << NF_INET_LOCAL_OUT));
+}
+
 static struct nft_expr_type nft_socket_type;
 static const struct nft_expr_ops nft_socket_ops = {
 	.type		= &nft_socket_type,
@@ -231,6 +254,7 @@ static const struct nft_expr_ops nft_socket_ops = {
 	.eval		= nft_socket_eval,
 	.init		= nft_socket_init,
 	.dump		= nft_socket_dump,
+	.validate	= nft_socket_validate,
 	.reduce		= nft_socket_reduce,
 };
 
-- 
2.30.2

