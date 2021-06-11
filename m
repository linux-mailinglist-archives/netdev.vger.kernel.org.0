Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D143A406C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhFKKwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhFKKwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:52:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2ECC061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 03:50:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lrekI-0007iq-VJ; Fri, 11 Jun 2021 12:50:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 4/5] xfrm: remove hdr_offset indirection
Date:   Fri, 11 Jun 2021 12:50:13 +0200
Message-Id: <20210611105014.4675-5-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105014.4675-1-fw@strlen.de>
References: <20210611105014.4675-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After previous patches all remaining users set the function pointer to
the same function: xfrm6_find_1stfragopt.

So remove this function pointer and call ip6_find_1stfragopt directly.

Reduces size of xfrm_type to 64 bytes on 64bit platforms.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.31.1

