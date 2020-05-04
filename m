Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84C91C3407
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgEDIGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728098AbgEDIGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:06:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AABC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:06:43 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jVW7d-00067V-Aq; Mon, 04 May 2020 10:06:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 7/7] xfrm: remove output_finish indirection from xfrm_state_afinfo
Date:   Mon,  4 May 2020 10:06:09 +0200
Message-Id: <20200504080609.14648-8-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504080609.14648-1-fw@strlen.de>
References: <20200504080609.14648-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are only two implementaions, one for ipv4 and one for ipv6.

Both are almost identical, they clear skb->cb[], set the TRANSFORMED flag
in IP(6)CB and then call the common xfrm_output() function.

By placing the IPCB handling into the common function, we avoid the need
for the output_finish indirection as the output functions can simply
use xfrm_output().

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.26.2

