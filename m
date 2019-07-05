Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69E66028E
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfGEIqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:46:19 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37490 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbfGEIqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:46:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CC6AD20254;
        Fri,  5 Jul 2019 10:46:16 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4zgBRV76moaM; Fri,  5 Jul 2019 10:46:16 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 06EAB20256;
        Fri,  5 Jul 2019 10:46:15 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:46:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 63D9331809CB;
 Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 9/9] xfrm: remove get_mtu indirection from xfrm_type
Date:   Fri, 5 Jul 2019 10:46:10 +0200
Message-ID: <20190705084610.3646-10-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705084610.3646-1-steffen.klassert@secunet.com>
References: <20190705084610.3646-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

esp4_get_mtu and esp6_get_mtu are exactly the same, the only difference
is a single sizeof() (ipv4 vs. ipv6 header).

Merge both into xfrm_state_mtu() and remove the indirection.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |  4 +---
 net/ipv4/esp4.c        | 27 +--------------------------
 net/ipv6/esp6.c        | 20 +-------------------
 net/xfrm/xfrm_device.c |  5 ++---
 net/xfrm/xfrm_state.c  | 34 +++++++++++++++++++++++++++++-----
 5 files changed, 34 insertions(+), 56 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 56b31676e330..b22db30c3d88 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -404,8 +404,6 @@ struct xfrm_type {
 	int			(*reject)(struct xfrm_state *, struct sk_buff *,
 					  const struct flowi *);
 	int			(*hdr_offset)(struct xfrm_state *, struct sk_buff *, u8 **);
-	/* Estimate maximal size of result of transformation of a dgram */
-	u32			(*get_mtu)(struct xfrm_state *, int size);
 };
 
 int xfrm_register_type(const struct xfrm_type *type, unsigned short family);
@@ -1546,7 +1544,7 @@ void xfrm_sad_getinfo(struct net *net, struct xfrmk_sadinfo *si);
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
 int xfrm_init_replay(struct xfrm_state *x);
-int xfrm_state_mtu(struct xfrm_state *x, int mtu);
+u32 xfrm_state_mtu(struct xfrm_state *x, int mtu);
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload);
 int xfrm_init_state(struct xfrm_state *x);
 int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type);
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index c06562aded11..5c967764041f 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -33,8 +33,6 @@ struct esp_output_extra {
 
 #define ESP_SKB_CB(__skb) ((struct esp_skb_cb *)&((__skb)->cb[0]))
 
-static u32 esp4_get_mtu(struct xfrm_state *x, int mtu);
-
 /*
  * Allocate an AEAD request structure with extra space for SG and IV.
  *
@@ -506,7 +504,7 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, esp4_get_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
@@ -788,28 +786,6 @@ static int esp_input(struct xfrm_state *x, struct sk_buff *skb)
 	return err;
 }
 
-static u32 esp4_get_mtu(struct xfrm_state *x, int mtu)
-{
-	struct crypto_aead *aead = x->data;
-	u32 blksize = ALIGN(crypto_aead_blocksize(aead), 4);
-	unsigned int net_adj;
-
-	switch (x->props.mode) {
-	case XFRM_MODE_TRANSPORT:
-	case XFRM_MODE_BEET:
-		net_adj = sizeof(struct iphdr);
-		break;
-	case XFRM_MODE_TUNNEL:
-		net_adj = 0;
-		break;
-	default:
-		BUG();
-	}
-
-	return ((mtu - x->props.header_len - crypto_aead_authsize(aead) -
-		 net_adj) & ~(blksize - 1)) + net_adj - 2;
-}
-
 static int esp4_err(struct sk_buff *skb, u32 info)
 {
 	struct net *net = dev_net(skb->dev);
@@ -1035,7 +1011,6 @@ static const struct xfrm_type esp_type =
 	.flags		= XFRM_TYPE_REPLAY_PROT,
 	.init_state	= esp_init_state,
 	.destructor	= esp_destroy,
-	.get_mtu	= esp4_get_mtu,
 	.input		= esp_input,
 	.output		= esp_output,
 };
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index b6c6b3e08836..a3b403ba8f8f 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -41,8 +41,6 @@ struct esp_skb_cb {
 
 #define ESP_SKB_CB(__skb) ((struct esp_skb_cb *)&((__skb)->cb[0]))
 
-static u32 esp6_get_mtu(struct xfrm_state *x, int mtu);
-
 /*
  * Allocate an AEAD request structure with extra space for SG and IV.
  *
@@ -447,7 +445,7 @@ static int esp6_output(struct xfrm_state *x, struct sk_buff *skb)
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, esp6_get_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
@@ -687,21 +685,6 @@ static int esp6_input(struct xfrm_state *x, struct sk_buff *skb)
 	return ret;
 }
 
-static u32 esp6_get_mtu(struct xfrm_state *x, int mtu)
-{
-	struct crypto_aead *aead = x->data;
-	u32 blksize = ALIGN(crypto_aead_blocksize(aead), 4);
-	unsigned int net_adj;
-
-	if (x->props.mode != XFRM_MODE_TUNNEL)
-		net_adj = sizeof(struct ipv6hdr);
-	else
-		net_adj = 0;
-
-	return ((mtu - x->props.header_len - crypto_aead_authsize(aead) -
-		 net_adj) & ~(blksize - 1)) + net_adj - 2;
-}
-
 static int esp6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		    u8 type, u8 code, int offset, __be32 info)
 {
@@ -919,7 +902,6 @@ static const struct xfrm_type esp6_type = {
 	.flags		= XFRM_TYPE_REPLAY_PROT,
 	.init_state	= esp6_init_state,
 	.destructor	= esp6_destroy,
-	.get_mtu	= esp6_get_mtu,
 	.input		= esp6_input,
 	.output		= esp6_output,
 	.hdr_offset	= xfrm6_find_1stfragopt,
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index b24cd86a02c3..f10a70388f72 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -275,9 +275,8 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 		return false;
 
 	if ((!dev || (dev == xfrm_dst_path(dst)->dev)) &&
-	    (!xdst->child->xfrm && x->type->get_mtu)) {
-		mtu = x->type->get_mtu(x, xdst->child_mtu_cached);
-
+	    (!xdst->child->xfrm)) {
+		mtu = xfrm_state_mtu(x, xdst->child_mtu_cached);
 		if (skb->len <= mtu)
 			goto ok;
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index fd51737f9f17..c6f3c4a1bd99 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -27,6 +27,8 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 
+#include <crypto/aead.h>
+
 #include "xfrm_hash.h"
 
 #define xfrm_state_deref_prot(table, net) \
@@ -2403,16 +2405,38 @@ void xfrm_state_delete_tunnel(struct xfrm_state *x)
 }
 EXPORT_SYMBOL(xfrm_state_delete_tunnel);
 
-int xfrm_state_mtu(struct xfrm_state *x, int mtu)
+u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 {
 	const struct xfrm_type *type = READ_ONCE(x->type);
+	struct crypto_aead *aead;
+	u32 blksize, net_adj = 0;
+
+	if (x->km.state != XFRM_STATE_VALID ||
+	    !type || type->proto != IPPROTO_ESP)
+		return mtu - x->props.header_len;
+
+	aead = x->data;
+	blksize = ALIGN(crypto_aead_blocksize(aead), 4);
 
-	if (x->km.state == XFRM_STATE_VALID &&
-	    type && type->get_mtu)
-		return type->get_mtu(x, mtu);
+	switch (x->props.mode) {
+	case XFRM_MODE_TRANSPORT:
+	case XFRM_MODE_BEET:
+		if (x->props.family == AF_INET)
+			net_adj = sizeof(struct iphdr);
+		else if (x->props.family == AF_INET6)
+			net_adj = sizeof(struct ipv6hdr);
+		break;
+	case XFRM_MODE_TUNNEL:
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
 
-	return mtu - x->props.header_len;
+	return ((mtu - x->props.header_len - crypto_aead_authsize(aead) -
+		 net_adj) & ~(blksize - 1)) + net_adj - 2;
 }
+EXPORT_SYMBOL_GPL(xfrm_state_mtu);
 
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 {
-- 
2.17.1

