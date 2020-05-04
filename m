Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293CF1C3401
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgEDIG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726750AbgEDIGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:06:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8B9C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:06:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jVW7M-00065d-0j; Mon, 04 May 2020 10:06:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 1/7] xfrm: avoid extract_output indirection for ipv4
Date:   Mon,  4 May 2020 10:06:03 +0200
Message-Id: <20200504080609.14648-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504080609.14648-1-fw@strlen.de>
References: <20200504080609.14648-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can use a direct call for ipv4, so move the needed functions
to net/xfrm/xfrm_output.c and call them directly.

For ipv6 the indirection can be avoided as well but it will need
a bit more work -- to ease review it will be done in another patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.26.2

