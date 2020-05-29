Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3802A1E7A9E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgE2Ka3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:30:29 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37564 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgE2KaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 06:30:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0868B205CF;
        Fri, 29 May 2020 12:30:20 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FH_bzva6frxF; Fri, 29 May 2020 12:30:18 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D3CF2201E5;
        Fri, 29 May 2020 12:30:18 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 12:30:18 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 12:30:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 0142131802B2;
 Fri, 29 May 2020 12:30:17 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 04/11] xfrm: avoid extract_output indirection for ipv4
Date:   Fri, 29 May 2020 12:30:04 +0200
Message-ID: <20200529103011.30127-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529103011.30127-1-steffen.klassert@secunet.com>
References: <20200529103011.30127-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We can use a direct call for ipv4, so move the needed functions
to net/xfrm/xfrm_output.c and call them directly.

For ipv6 the indirection can be avoided as well but it will need
a bit more work -- to ease review it will be done in another patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h      |  1 -
 net/ipv4/xfrm4_output.c | 40 -----------------------------------
 net/ipv4/xfrm4_state.c  |  1 -
 net/xfrm/xfrm_output.c  | 46 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 2577666c34c8..397007324abd 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1580,7 +1580,6 @@ static inline int xfrm4_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi)
 	return xfrm_input(skb, nexthdr, spi, 0);
 }
 
-int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb);
 int xfrm4_output_finish(struct sock *sk, struct sk_buff *skb);
 int xfrm4_protocol_register(struct xfrm4_protocol *handler, unsigned char protocol);
diff --git a/net/ipv4/xfrm4_output.c b/net/ipv4/xfrm4_output.c
index 89ba7c87de5d..21c8fa0a31ed 100644
--- a/net/ipv4/xfrm4_output.c
+++ b/net/ipv4/xfrm4_output.c
@@ -14,46 +14,6 @@
 #include <net/xfrm.h>
 #include <net/icmp.h>
 
-static int xfrm4_tunnel_check_size(struct sk_buff *skb)
-{
-	int mtu, ret = 0;
-
-	if (IPCB(skb)->flags & IPSKB_XFRM_TUNNEL_SIZE)
-		goto out;
-
-	if (!(ip_hdr(skb)->frag_off & htons(IP_DF)) || skb->ignore_df)
-		goto out;
-
-	mtu = dst_mtu(skb_dst(skb));
-	if ((!skb_is_gso(skb) && skb->len > mtu) ||
-	    (skb_is_gso(skb) &&
-	     !skb_gso_validate_network_len(skb, ip_skb_dst_mtu(skb->sk, skb)))) {
-		skb->protocol = htons(ETH_P_IP);
-
-		if (skb->sk)
-			xfrm_local_error(skb, mtu);
-		else
-			icmp_send(skb, ICMP_DEST_UNREACH,
-				  ICMP_FRAG_NEEDED, htonl(mtu));
-		ret = -EMSGSIZE;
-	}
-out:
-	return ret;
-}
-
-int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb)
-{
-	int err;
-
-	err = xfrm4_tunnel_check_size(skb);
-	if (err)
-		return err;
-
-	XFRM_MODE_SKB_CB(skb)->protocol = ip_hdr(skb)->protocol;
-
-	return xfrm4_extract_header(skb);
-}
-
 int xfrm4_output_finish(struct sock *sk, struct sk_buff *skb)
 {
 	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
diff --git a/net/ipv4/xfrm4_state.c b/net/ipv4/xfrm4_state.c
index f8ed3c3bb928..d7c200779e4f 100644
--- a/net/ipv4/xfrm4_state.c
+++ b/net/ipv4/xfrm4_state.c
@@ -37,7 +37,6 @@ static struct xfrm_state_afinfo xfrm4_state_afinfo = {
 	.output			= xfrm4_output,
 	.output_finish		= xfrm4_output_finish,
 	.extract_input		= xfrm4_extract_input,
-	.extract_output		= xfrm4_extract_output,
 	.transport_finish	= xfrm4_transport_finish,
 	.local_error		= xfrm4_local_error,
 };
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 2fd3d990d992..a7b3af7f7a1e 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <net/dst.h>
+#include <net/icmp.h>
 #include <net/inet_ecn.h>
 #include <net/xfrm.h>
 
@@ -609,6 +610,47 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(xfrm_output);
 
+static int xfrm4_tunnel_check_size(struct sk_buff *skb)
+{
+	int mtu, ret = 0;
+
+	if (IPCB(skb)->flags & IPSKB_XFRM_TUNNEL_SIZE)
+		goto out;
+
+	if (!(ip_hdr(skb)->frag_off & htons(IP_DF)) || skb->ignore_df)
+		goto out;
+
+	mtu = dst_mtu(skb_dst(skb));
+	if ((!skb_is_gso(skb) && skb->len > mtu) ||
+	    (skb_is_gso(skb) &&
+	     !skb_gso_validate_network_len(skb, ip_skb_dst_mtu(skb->sk, skb)))) {
+		skb->protocol = htons(ETH_P_IP);
+
+		if (skb->sk)
+			xfrm_local_error(skb, mtu);
+		else
+			icmp_send(skb, ICMP_DEST_UNREACH,
+				  ICMP_FRAG_NEEDED, htonl(mtu));
+		ret = -EMSGSIZE;
+	}
+out:
+	return ret;
+}
+
+static int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb)
+{
+	int err;
+
+	err = xfrm4_tunnel_check_size(skb);
+	if (err)
+		return err;
+
+	XFRM_MODE_SKB_CB(skb)->protocol = ip_hdr(skb)->protocol;
+
+	xfrm4_extract_header(skb);
+	return 0;
+}
+
 static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 	const struct xfrm_state_afinfo *afinfo;
@@ -624,6 +666,10 @@ static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 	if (inner_mode == NULL)
 		return -EAFNOSUPPORT;
 
+	switch (inner_mode->family) {
+	case AF_INET:
+		return xfrm4_extract_output(x, skb);
+	}
 	rcu_read_lock();
 	afinfo = xfrm_state_afinfo_get_rcu(inner_mode->family);
 	if (likely(afinfo))
-- 
2.17.1

