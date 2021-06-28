Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526F23B58CB
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhF1F52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:57:28 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:35584 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhF1F5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:57:24 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 03FA8800051;
        Mon, 28 Jun 2021 07:54:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 07:54:57 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 07:54:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 901C93180427; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 09/17] xfrm: remove hdr_offset indirection
Date:   Mon, 28 Jun 2021 07:45:14 +0200
Message-ID: <20210628054522.1718786-10-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628054522.1718786-1-steffen.klassert@secunet.com>
References: <20210628054522.1718786-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

After previous patches all remaining users set the function pointer to
the same function: xfrm6_find_1stfragopt.

So remove this function pointer and call ip6_find_1stfragopt directly.

Reduces size of xfrm_type to 64 bytes on 64bit platforms.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h      | 3 ---
 net/ipv6/ah6.c          | 1 -
 net/ipv6/esp6.c         | 1 -
 net/ipv6/ipcomp6.c      | 1 -
 net/ipv6/xfrm6_output.c | 7 -------
 net/xfrm/xfrm_output.c  | 2 +-
 6 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 1aad78c5f2d5..c8890da00b8a 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -402,7 +402,6 @@ struct xfrm_type {
 	int			(*output)(struct xfrm_state *, struct sk_buff *pskb);
 	int			(*reject)(struct xfrm_state *, struct sk_buff *,
 					  const struct flowi *);
-	int			(*hdr_offset)(struct xfrm_state *, struct sk_buff *, u8 **);
 };
 
 int xfrm_register_type(const struct xfrm_type *type, unsigned short family);
@@ -1605,8 +1604,6 @@ __be32 xfrm6_tunnel_alloc_spi(struct net *net, xfrm_address_t *saddr);
 __be32 xfrm6_tunnel_spi_lookup(struct net *net, const xfrm_address_t *saddr);
 int xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb);
 int xfrm6_output_finish(struct sock *sk, struct sk_buff *skb);
-int xfrm6_find_1stfragopt(struct xfrm_state *x, struct sk_buff *skb,
-			  u8 **prevhdr);
 
 #ifdef CONFIG_XFRM
 void xfrm6_local_rxpmtu(struct sk_buff *skb, u32 mtu);
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index e9705c256068..828e62514260 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -762,7 +762,6 @@ static const struct xfrm_type ah6_type = {
 	.destructor	= ah6_destroy,
 	.input		= ah6_input,
 	.output		= ah6_output,
-	.hdr_offset	= xfrm6_find_1stfragopt,
 };
 
 static struct xfrm6_protocol ah6_protocol = {
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index be2c0ac76eaa..37c4b1726c5e 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -1250,7 +1250,6 @@ static const struct xfrm_type esp6_type = {
 	.destructor	= esp6_destroy,
 	.input		= esp6_input,
 	.output		= esp6_output,
-	.hdr_offset	= xfrm6_find_1stfragopt,
 };
 
 static struct xfrm6_protocol esp6_protocol = {
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 491aba66b7ae..15f984be3570 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -178,7 +178,6 @@ static const struct xfrm_type ipcomp6_type = {
 	.destructor	= ipcomp_destroy,
 	.input		= ipcomp_input,
 	.output		= ipcomp_output,
-	.hdr_offset	= xfrm6_find_1stfragopt,
 };
 
 static struct xfrm6_protocol ipcomp6_protocol = {
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index 8b84d534b19d..57fa27c1cdf9 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -16,13 +16,6 @@
 #include <net/ip6_route.h>
 #include <net/xfrm.h>
 
-int xfrm6_find_1stfragopt(struct xfrm_state *x, struct sk_buff *skb,
-			  u8 **prevhdr)
-{
-	return ip6_find_1stfragopt(skb, prevhdr);
-}
-EXPORT_SYMBOL(xfrm6_find_1stfragopt);
-
 void xfrm6_local_rxpmtu(struct sk_buff *skb, u32 mtu)
 {
 	struct flowi6 fl6;
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 1734339b6dd0..10842d5cf6e1 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -185,7 +185,7 @@ static int xfrm6_hdr_offset(struct xfrm_state *x, struct sk_buff *skb, u8 **prev
 		break;
 	}
 
-	return x->type->hdr_offset(x, skb, prevhdr);
+	return ip6_find_1stfragopt(skb, prevhdr);
 }
 
 /* Add encapsulation header.
-- 
2.25.1

