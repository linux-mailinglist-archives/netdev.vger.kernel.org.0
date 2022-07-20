Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BD557C097
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiGTXIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiGTXII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:08:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F2DE61D5A;
        Wed, 20 Jul 2022 16:08:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 11/18] netfilter: nf_tables: use the correct get/put helpers
Date:   Thu, 21 Jul 2022 01:07:47 +0200
Message-Id: <20220720230754.209053-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720230754.209053-1-pablo@netfilter.org>
References: <20220720230754.209053-1-pablo@netfilter.org>
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

Switch to be16/32 and u16/32 respectively.  No code changes here,
the functions do the same thing, this is just for sparse checkers' sake.

objdiff shows no changes.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_byteorder.c | 3 ++-
 net/netfilter/nft_osf.c       | 2 +-
 net/netfilter/nft_socket.c    | 8 ++++----
 net/netfilter/nft_xfrm.c      | 8 ++++----
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index d77609144b26..f952a80275a8 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -44,7 +44,8 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = nft_reg_load64(&src[i]);
-				nft_reg_store64(&dst[i], be64_to_cpu(src64));
+				nft_reg_store64(&dst[i],
+						be64_to_cpu((__force __be64)src64));
 			}
 			break;
 		case NFT_BYTEORDER_HTON:
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 5eed18f90b02..0053a697c931 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -99,7 +99,7 @@ static int nft_osf_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (nla_put_u8(skb, NFTA_OSF_TTL, priv->ttl))
 		goto nla_put_failure;
 
-	if (nla_put_be32(skb, NFTA_OSF_FLAGS, ntohl(priv->flags)))
+	if (nla_put_u32(skb, NFTA_OSF_FLAGS, ntohl((__force __be32)priv->flags)))
 		goto nla_put_failure;
 
 	if (nft_dump_register(skb, NFTA_OSF_DREG, priv->dreg))
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 05ae5a338b6f..a7de29137618 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -163,7 +163,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	priv->key = ntohl(nla_get_u32(tb[NFTA_SOCKET_KEY]));
+	priv->key = ntohl(nla_get_be32(tb[NFTA_SOCKET_KEY]));
 	switch(priv->key) {
 	case NFT_SOCKET_TRANSPARENT:
 	case NFT_SOCKET_WILDCARD:
@@ -179,7 +179,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 		if (!tb[NFTA_SOCKET_LEVEL])
 			return -EINVAL;
 
-		level = ntohl(nla_get_u32(tb[NFTA_SOCKET_LEVEL]));
+		level = ntohl(nla_get_be32(tb[NFTA_SOCKET_LEVEL]));
 		if (level > 255)
 			return -EOPNOTSUPP;
 
@@ -202,12 +202,12 @@ static int nft_socket_dump(struct sk_buff *skb,
 {
 	const struct nft_socket *priv = nft_expr_priv(expr);
 
-	if (nla_put_u32(skb, NFTA_SOCKET_KEY, htonl(priv->key)))
+	if (nla_put_be32(skb, NFTA_SOCKET_KEY, htonl(priv->key)))
 		return -1;
 	if (nft_dump_register(skb, NFTA_SOCKET_DREG, priv->dreg))
 		return -1;
 	if (priv->key == NFT_SOCKET_CGROUPV2 &&
-	    nla_put_u32(skb, NFTA_SOCKET_LEVEL, htonl(priv->level)))
+	    nla_put_be32(skb, NFTA_SOCKET_LEVEL, htonl(priv->level)))
 		return -1;
 	return 0;
 }
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index becb88fa4e9b..1c5343c936a8 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -51,7 +51,7 @@ static int nft_xfrm_get_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	priv->key = ntohl(nla_get_u32(tb[NFTA_XFRM_KEY]));
+	priv->key = ntohl(nla_get_be32(tb[NFTA_XFRM_KEY]));
 	switch (priv->key) {
 	case NFT_XFRM_KEY_REQID:
 	case NFT_XFRM_KEY_SPI:
@@ -134,13 +134,13 @@ static void nft_xfrm_state_get_key(const struct nft_xfrm *priv,
 		WARN_ON_ONCE(1);
 		break;
 	case NFT_XFRM_KEY_DADDR_IP4:
-		*dest = state->id.daddr.a4;
+		*dest = (__force __u32)state->id.daddr.a4;
 		return;
 	case NFT_XFRM_KEY_DADDR_IP6:
 		memcpy(dest, &state->id.daddr.in6, sizeof(struct in6_addr));
 		return;
 	case NFT_XFRM_KEY_SADDR_IP4:
-		*dest = state->props.saddr.a4;
+		*dest = (__force __u32)state->props.saddr.a4;
 		return;
 	case NFT_XFRM_KEY_SADDR_IP6:
 		memcpy(dest, &state->props.saddr.in6, sizeof(struct in6_addr));
@@ -149,7 +149,7 @@ static void nft_xfrm_state_get_key(const struct nft_xfrm *priv,
 		*dest = state->props.reqid;
 		return;
 	case NFT_XFRM_KEY_SPI:
-		*dest = state->id.spi;
+		*dest = (__force __u32)state->id.spi;
 		return;
 	}
 
-- 
2.30.2

