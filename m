Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6DE1E7AA4
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgE2Kau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:30:50 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37632 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgE2Ka2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 06:30:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 749EC201E5;
        Fri, 29 May 2020 12:30:23 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZyPfJRCYE6ad; Fri, 29 May 2020 12:30:22 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 50455205A4;
        Fri, 29 May 2020 12:30:20 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 12:30:20 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 12:30:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 11D3C31804B1;
 Fri, 29 May 2020 12:30:18 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 08/11] xfrm: place xfrm6_local_dontfrag in xfrm.h
Date:   Fri, 29 May 2020 12:30:08 +0200
Message-ID: <20200529103011.30127-9-steffen.klassert@secunet.com>
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

so next patch can re-use it from net/xfrm/xfrm_output.c without
causing a linker error when IPV6 is a module.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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
2.17.1

