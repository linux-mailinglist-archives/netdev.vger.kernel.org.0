Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED991C3405
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgEDIGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728098AbgEDIGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:06:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6E3C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:06:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jVW7V-00066o-Mc; Mon, 04 May 2020 10:06:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 5/7] xfrm: place xfrm6_local_dontfrag in xfrm.h
Date:   Mon,  4 May 2020 10:06:07 +0200
Message-Id: <20200504080609.14648-6-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504080609.14648-1-fw@strlen.de>
References: <20200504080609.14648-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

so next patch can re-use it from net/xfrm/xfrm_output.c without
causing a linker error when IPV6 is a module.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h      | 16 ++++++++++++++++
 net/ipv6/xfrm6_output.c | 21 ++-------------------
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 10295ab4cdfb..8f7fb033d557 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1993,4 +1993,20 @@ static inline int xfrm_tunnel_check(struct sk_buff *skb, struct xfrm_state *x,
 
 	return 0;
 }
+
+#if IS_ENABLED(CONFIG_IPV6)
+static inline bool xfrm6_local_dontfrag(const struct sock *sk)
+{
+	int proto;
+
+	if (!sk || sk->sk_family != AF_INET6)
+		return false;
+
+	proto = sk->sk_protocol;
+	if (proto == IPPROTO_UDP || proto == IPPROTO_RAW)
+		return inet6_sk(sk)->dontfrag;
+
+	return false;
+}
+#endif
 #endif	/* _NET_XFRM_H */
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index 23e2b52cfba6..be64f280510c 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -23,23 +23,6 @@ int xfrm6_find_1stfragopt(struct xfrm_state *x, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(xfrm6_find_1stfragopt);
 
-static int xfrm6_local_dontfrag(struct sk_buff *skb)
-{
-	int proto;
-	struct sock *sk = skb->sk;
-
-	if (sk) {
-		if (sk->sk_family != AF_INET6)
-			return 0;
-
-		proto = sk->sk_protocol;
-		if (proto == IPPROTO_UDP || proto == IPPROTO_RAW)
-			return inet6_sk(sk)->dontfrag;
-	}
-
-	return 0;
-}
-
 void xfrm6_local_rxpmtu(struct sk_buff *skb, u32 mtu)
 {
 	struct flowi6 fl6;
@@ -82,7 +65,7 @@ static int xfrm6_tunnel_check_size(struct sk_buff *skb)
 		skb->dev = dst->dev;
 		skb->protocol = htons(ETH_P_IPV6);
 
-		if (xfrm6_local_dontfrag(skb))
+		if (xfrm6_local_dontfrag(skb->sk))
 			xfrm6_local_rxpmtu(skb, mtu);
 		else if (skb->sk)
 			xfrm_local_error(skb, mtu);
@@ -181,7 +164,7 @@ static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 	toobig = skb->len > mtu && !skb_is_gso(skb);
 
-	if (toobig && xfrm6_local_dontfrag(skb)) {
+	if (toobig && xfrm6_local_dontfrag(skb->sk)) {
 		xfrm6_local_rxpmtu(skb, mtu);
 		kfree_skb(skb);
 		return -EMSGSIZE;
-- 
2.26.2

