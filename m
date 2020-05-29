Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB3E1E7AB1
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgE2Kfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:35:45 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37928 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE2Kfo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 06:35:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 035B5205B2;
        Fri, 29 May 2020 12:35:41 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MqgqTWF2RJVA; Fri, 29 May 2020 12:35:40 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 131FC205AA;
        Fri, 29 May 2020 12:35:40 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 29 May 2020 12:35:39 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 12:35:39 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 19C6031806E8; Fri, 29 May 2020 12:30:18 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 10/11] xfrm: remove output_finish indirection from xfrm_state_afinfo
Date:   Fri, 29 May 2020 12:30:10 +0200
Message-ID: <20200529103011.30127-11-steffen.klassert@secunet.com>
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

There are only two implementaions, one for ipv4 and one for ipv6.

Both are almost identical, they clear skb->cb[], set the TRANSFORMED flag
in IP(6)CB and then call the common xfrm_output() function.

By placing the IPCB handling into the common function, we avoid the need
for the output_finish indirection as the output functions can simply
use xfrm_output().

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h      |  1 -
 net/ipv4/xfrm4_output.c | 23 +----------------------
 net/ipv4/xfrm4_state.c  |  1 -
 net/ipv6/xfrm6_output.c | 34 ++--------------------------------
 net/ipv6/xfrm6_state.c  |  1 -
 net/xfrm/xfrm_output.c  | 16 ++++++++++++++++
 6 files changed, 19 insertions(+), 57 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index db814a7e042f..094fe682f5d7 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -361,7 +361,6 @@ struct xfrm_state_afinfo {
 	const struct xfrm_type		*type_dstopts;
 
 	int			(*output)(struct net *net, struct sock *sk, struct sk_buff *skb);
-	int			(*output_finish)(struct sock *sk, struct sk_buff *skb);
 	int			(*transport_finish)(struct sk_buff *skb,
 						    int async);
 	void			(*local_error)(struct sk_buff *skb, u32 mtu);
diff --git a/net/ipv4/xfrm4_output.c b/net/ipv4/xfrm4_output.c
index 21c8fa0a31ed..502eb189d852 100644
--- a/net/ipv4/xfrm4_output.c
+++ b/net/ipv4/xfrm4_output.c
@@ -14,22 +14,9 @@
 #include <net/xfrm.h>
 #include <net/icmp.h>
 
-int xfrm4_output_finish(struct sock *sk, struct sk_buff *skb)
-{
-	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
-
-#ifdef CONFIG_NETFILTER
-	IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
-#endif
-
-	return xfrm_output(sk, skb);
-}
-
 static int __xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct xfrm_state *x = skb_dst(skb)->xfrm;
-	const struct xfrm_state_afinfo *afinfo;
-	int ret = -EAFNOSUPPORT;
 
 #ifdef CONFIG_NETFILTER
 	if (!x) {
@@ -38,15 +25,7 @@ static int __xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	}
 #endif
 
-	rcu_read_lock();
-	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode.family);
-	if (likely(afinfo))
-		ret = afinfo->output_finish(sk, skb);
-	else
-		kfree_skb(skb);
-	rcu_read_unlock();
-
-	return ret;
+	return xfrm_output(sk, skb);
 }
 
 int xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
diff --git a/net/ipv4/xfrm4_state.c b/net/ipv4/xfrm4_state.c
index b23a1711297b..87d4db591488 100644
--- a/net/ipv4/xfrm4_state.c
+++ b/net/ipv4/xfrm4_state.c
@@ -14,7 +14,6 @@ static struct xfrm_state_afinfo xfrm4_state_afinfo = {
 	.family			= AF_INET,
 	.proto			= IPPROTO_IPIP,
 	.output			= xfrm4_output,
-	.output_finish		= xfrm4_output_finish,
 	.transport_finish	= xfrm4_transport_finish,
 	.local_error		= xfrm4_local_error,
 };
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index b7d65b344679..8b84d534b19d 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -47,39 +47,9 @@ void xfrm6_local_error(struct sk_buff *skb, u32 mtu)
 	ipv6_local_error(sk, EMSGSIZE, &fl6, mtu);
 }
 
-int xfrm6_output_finish(struct sock *sk, struct sk_buff *skb)
-{
-	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
-
-#ifdef CONFIG_NETFILTER
-	IP6CB(skb)->flags |= IP6SKB_XFRM_TRANSFORMED;
-#endif
-
-	return xfrm_output(sk, skb);
-}
-
-static int __xfrm6_output_state_finish(struct xfrm_state *x, struct sock *sk,
-				       struct sk_buff *skb)
-{
-	const struct xfrm_state_afinfo *afinfo;
-	int ret = -EAFNOSUPPORT;
-
-	rcu_read_lock();
-	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode.family);
-	if (likely(afinfo))
-		ret = afinfo->output_finish(sk, skb);
-	else
-		kfree_skb(skb);
-	rcu_read_unlock();
-
-	return ret;
-}
-
 static int __xfrm6_output_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct xfrm_state *x = skb_dst(skb)->xfrm;
-
-	return __xfrm6_output_state_finish(x, sk, skb);
+	return xfrm_output(sk, skb);
 }
 
 static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
@@ -121,7 +91,7 @@ static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 				    __xfrm6_output_finish);
 
 skip_frag:
-	return __xfrm6_output_state_finish(x, sk, skb);
+	return xfrm_output(sk, skb);
 }
 
 int xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
index 15247f2f78e1..6610b2198fa9 100644
--- a/net/ipv6/xfrm6_state.c
+++ b/net/ipv6/xfrm6_state.c
@@ -18,7 +18,6 @@ static struct xfrm_state_afinfo xfrm6_state_afinfo = {
 	.family			= AF_INET6,
 	.proto			= IPPROTO_IPV6,
 	.output			= xfrm6_output,
-	.output_finish		= xfrm6_output_finish,
 	.transport_finish	= xfrm6_transport_finish,
 	.local_error		= xfrm6_local_error,
 };
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 3a646df1318d..9c43b8dd80fb 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -571,6 +571,22 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 	struct xfrm_state *x = skb_dst(skb)->xfrm;
 	int err;
 
+	switch (x->outer_mode.family) {
+	case AF_INET:
+		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
+#ifdef CONFIG_NETFILTER
+		IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
+#endif
+		break;
+	case AF_INET6:
+		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+
+#ifdef CONFIG_NETFILTER
+		IP6CB(skb)->flags |= IP6SKB_XFRM_TRANSFORMED;
+#endif
+		break;
+	}
+
 	secpath_reset(skb);
 
 	if (xfrm_dev_offload_ok(skb, x)) {
-- 
2.17.1

