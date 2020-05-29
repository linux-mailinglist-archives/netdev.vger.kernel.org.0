Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD4A1E7AA2
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgE2Kaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:30:46 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37616 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbgE2KaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 06:30:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4514B205B2;
        Fri, 29 May 2020 12:30:23 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id y7MiY2epKkXh; Fri, 29 May 2020 12:30:22 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 809BF205AE;
        Fri, 29 May 2020 12:30:20 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 12:30:20 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 12:30:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 160743180607;
 Fri, 29 May 2020 12:30:18 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 09/11] xfrm: remove extract_output indirection from xfrm_state_afinfo
Date:   Fri, 29 May 2020 12:30:09 +0200
Message-ID: <20200529103011.30127-10-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529103011.30127-1-steffen.klassert@secunet.com>
References: <20200529103011.30127-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Move this to xfrm_output.c.  This avoids the state->extract_output
indirection.

This patch also removes the duplicated __xfrm6_extract_header helper
added in an earlier patch, we can now use the one from xfrm_inout.h .

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h      |  3 --
 net/ipv6/xfrm6_output.c | 58 -----------------------------------
 net/ipv6/xfrm6_state.c  |  1 -
 net/xfrm/xfrm_output.c  | 67 ++++++++++++++++++++++++++++++++++++-----
 4 files changed, 59 insertions(+), 70 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 8f7fb033d557..db814a7e042f 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -362,8 +362,6 @@ struct xfrm_state_afinfo {
 
 	int			(*output)(struct net *net, struct sock *sk, struct sk_buff *skb);
 	int			(*output_finish)(struct sock *sk, struct sk_buff *skb);
-	int			(*extract_output)(struct xfrm_state *x,
-						  struct sk_buff *skb);
 	int			(*transport_finish)(struct sk_buff *skb,
 						    int async);
 	void			(*local_error)(struct sk_buff *skb, u32 mtu);
@@ -1601,7 +1599,6 @@ int xfrm6_tunnel_register(struct xfrm6_tunnel *handler, unsigned short family);
 int xfrm6_tunnel_deregister(struct xfrm6_tunnel *handler, unsigned short family);
 __be32 xfrm6_tunnel_alloc_spi(struct net *net, xfrm_address_t *saddr);
 __be32 xfrm6_tunnel_spi_lookup(struct net *net, const xfrm_address_t *saddr);
-int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb);
 int xfrm6_output_finish(struct sock *sk, struct sk_buff *skb);
 int xfrm6_find_1stfragopt(struct xfrm_state *x, struct sk_buff *skb,
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index be64f280510c..b7d65b344679 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -47,64 +47,6 @@ void xfrm6_local_error(struct sk_buff *skb, u32 mtu)
 	ipv6_local_error(sk, EMSGSIZE, &fl6, mtu);
 }
 
-static int xfrm6_tunnel_check_size(struct sk_buff *skb)
-{
-	int mtu, ret = 0;
-	struct dst_entry *dst = skb_dst(skb);
-
-	if (skb->ignore_df)
-		goto out;
-
-	mtu = dst_mtu(dst);
-	if (mtu < IPV6_MIN_MTU)
-		mtu = IPV6_MIN_MTU;
-
-	if ((!skb_is_gso(skb) && skb->len > mtu) ||
-	    (skb_is_gso(skb) &&
-	     !skb_gso_validate_network_len(skb, ip6_skb_dst_mtu(skb)))) {
-		skb->dev = dst->dev;
-		skb->protocol = htons(ETH_P_IPV6);
-
-		if (xfrm6_local_dontfrag(skb->sk))
-			xfrm6_local_rxpmtu(skb, mtu);
-		else if (skb->sk)
-			xfrm_local_error(skb, mtu);
-		else
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
-		ret = -EMSGSIZE;
-	}
-out:
-	return ret;
-}
-
-static void __xfrm6_extract_header(struct sk_buff *skb)
-{
-	struct ipv6hdr *iph = ipv6_hdr(skb);
-
-	XFRM_MODE_SKB_CB(skb)->ihl = sizeof(*iph);
-	XFRM_MODE_SKB_CB(skb)->id = 0;
-	XFRM_MODE_SKB_CB(skb)->frag_off = htons(IP_DF);
-	XFRM_MODE_SKB_CB(skb)->tos = ipv6_get_dsfield(iph);
-	XFRM_MODE_SKB_CB(skb)->ttl = iph->hop_limit;
-	XFRM_MODE_SKB_CB(skb)->optlen = 0;
-	memcpy(XFRM_MODE_SKB_CB(skb)->flow_lbl, iph->flow_lbl,
-	       sizeof(XFRM_MODE_SKB_CB(skb)->flow_lbl));
-}
-
-int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
-{
-	int err;
-
-	err = xfrm6_tunnel_check_size(skb);
-	if (err)
-		return err;
-
-	XFRM_MODE_SKB_CB(skb)->protocol = ipv6_hdr(skb)->nexthdr;
-
-	__xfrm6_extract_header(skb);
-	return 0;
-}
-
 int xfrm6_output_finish(struct sock *sk, struct sk_buff *skb)
 {
 	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
index 8fbf5a68ee6e..15247f2f78e1 100644
--- a/net/ipv6/xfrm6_state.c
+++ b/net/ipv6/xfrm6_state.c
@@ -19,7 +19,6 @@ static struct xfrm_state_afinfo xfrm6_state_afinfo = {
 	.proto			= IPPROTO_IPV6,
 	.output			= xfrm6_output,
 	.output_finish		= xfrm6_output_finish,
-	.extract_output		= xfrm6_extract_output,
 	.transport_finish	= xfrm6_transport_finish,
 	.local_error		= xfrm6_local_error,
 };
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index a7b3af7f7a1e..3a646df1318d 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -17,6 +17,11 @@
 #include <net/inet_ecn.h>
 #include <net/xfrm.h>
 
+#if IS_ENABLED(CONFIG_IPV6)
+#include <net/ip6_route.h>
+#include <net/ipv6_stubs.h>
+#endif
+
 #include "xfrm_inout.h"
 
 static int xfrm_output2(struct net *net, struct sock *sk, struct sk_buff *skb);
@@ -651,11 +656,60 @@ static int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static int xfrm6_tunnel_check_size(struct sk_buff *skb)
+{
+	int mtu, ret = 0;
+	struct dst_entry *dst = skb_dst(skb);
+
+	if (skb->ignore_df)
+		goto out;
+
+	mtu = dst_mtu(dst);
+	if (mtu < IPV6_MIN_MTU)
+		mtu = IPV6_MIN_MTU;
+
+	if ((!skb_is_gso(skb) && skb->len > mtu) ||
+	    (skb_is_gso(skb) &&
+	     !skb_gso_validate_network_len(skb, ip6_skb_dst_mtu(skb)))) {
+		skb->dev = dst->dev;
+		skb->protocol = htons(ETH_P_IPV6);
+
+		if (xfrm6_local_dontfrag(skb->sk))
+			ipv6_stub->xfrm6_local_rxpmtu(skb, mtu);
+		else if (skb->sk)
+			xfrm_local_error(skb, mtu);
+		else
+			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+		ret = -EMSGSIZE;
+	}
+out:
+	return ret;
+}
+#endif
+
+static int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	int err;
+
+	err = xfrm6_tunnel_check_size(skb);
+	if (err)
+		return err;
+
+	XFRM_MODE_SKB_CB(skb)->protocol = ipv6_hdr(skb)->nexthdr;
+
+	xfrm6_extract_header(skb);
+	return 0;
+#else
+	WARN_ON_ONCE(1);
+	return -EAFNOSUPPORT;
+#endif
+}
+
 static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
-	const struct xfrm_state_afinfo *afinfo;
 	const struct xfrm_mode *inner_mode;
-	int err = -EAFNOSUPPORT;
 
 	if (x->sel.family == AF_UNSPEC)
 		inner_mode = xfrm_ip2inner_mode(x,
@@ -669,14 +723,11 @@ static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 	switch (inner_mode->family) {
 	case AF_INET:
 		return xfrm4_extract_output(x, skb);
+	case AF_INET6:
+		return xfrm6_extract_output(x, skb);
 	}
-	rcu_read_lock();
-	afinfo = xfrm_state_afinfo_get_rcu(inner_mode->family);
-	if (likely(afinfo))
-		err = afinfo->extract_output(x, skb);
-	rcu_read_unlock();
 
-	return err;
+	return -EAFNOSUPPORT;
 }
 
 void xfrm_local_error(struct sk_buff *skb, int mtu)
-- 
2.17.1

