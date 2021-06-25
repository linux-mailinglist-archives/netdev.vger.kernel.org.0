Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085753B4714
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 17:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhFYP7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 11:59:31 -0400
Received: from novek.ru ([213.148.174.62]:60902 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhFYP7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 11:59:30 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id B2FB75006F4;
        Fri, 25 Jun 2021 18:55:09 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru B2FB75006F4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1624636511; bh=75Z60FocwF69fjhOQ0WGZ7jBHW8Lg1PNeto72CS6tcs=;
        h=From:To:Cc:Subject:Date:From;
        b=pxKmAXQOa2eY4cFuXDuT5ZWG5yKvr96tQnVRcfsqQ2QCLpiDxQpM72GPcbuDsFtoo
         wDIN8FkYWuHyWEK0ZvDPgqrqVnxRqXvgmUdld7RgY5Vx8VnHm1TPiao0wTZNqbSn5B
         tdXXJK0ZfmREer4zNumbIZAMF+5vP6nn+miMcySs=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net] net: lwtunnel: handle MTU calculation in forwading
Date:   Fri, 25 Jun 2021 18:57:00 +0300
Message-Id: <20210625155700.4276-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 14972cbd34ff ("net: lwtunnel: Handle fragmentation") moved
fragmentation logic away from lwtunnel by carry encap headroom and
use it in output MTU calculation. But the forwarding part was not
covered and created difference in MTU for output and forwarding and
further to silent drops on ipv4 forwarding path. Fix it by taking
into account lwtunnel encap headroom.

The same commit also introduced difference in how to treat RTAX_MTU
in IPv4 and IPv6 where latter explicitly removes lwtunnel encap
headroom from route MTU. Make IPv4 version do the same.

Fixes: 14972cbd34ff ("net: lwtunnel: Handle fragmentation")
Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 include/net/ip.h        | 10 ++++++----
 include/net/ip6_route.h | 16 ++++++++++++----
 net/ipv4/route.c        |  3 ++-
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index e20874059f82..5f0f6b8b0e8e 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -31,6 +31,7 @@
 #include <net/flow.h>
 #include <net/flow_dissector.h>
 #include <net/netns/hash.h>
+#include <net/lwtunnel.h>
 
 #define IPV4_MAX_PMTU		65535U		/* RFC 2675, Section 5.1 */
 #define IPV4_MIN_MTU		68			/* RFC 791 */
@@ -445,10 +446,10 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 
 	/* 'forwarding = true' case should always honour route mtu */
 	mtu = dst_metric_raw(dst, RTAX_MTU);
-	if (mtu)
-		return mtu;
+	if (!mtu)
+		mtu = min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
 
-	return min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
+	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
 static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
@@ -460,7 +461,8 @@ static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
 		return ip_dst_mtu_maybe_forward(skb_dst(skb), forwarding);
 	}
 
-	return min(READ_ONCE(skb_dst(skb)->dev->mtu), IP_MAX_MTU);
+	mtu = min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
+	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
 struct dst_metrics *ip_fib_metrics_init(struct net *net, struct nlattr *fc_mx,
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index f51a118bfce8..58fdcceb9a4b 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -265,11 +265,18 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 static inline int ip6_skb_dst_mtu(struct sk_buff *skb)
 {
+	int mtu;
+
 	struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
 				inet6_sk(skb->sk) : NULL;
 
-	return (np && np->pmtudisc >= IPV6_PMTUDISC_PROBE) ?
-	       skb_dst(skb)->dev->mtu : dst_mtu(skb_dst(skb));
+	if (np && np->pmtudisc >= IPV6_PMTUDISC_PROBE) {
+		mtu = READ_ONCE(skb_dst(skb)->dev->mtu);
+		mtu -= lwtunnel_headroom(dst->lwtstate, mtu);
+	} else
+		mtu = dst_mtu(skb_dst(skb));
+
+	return mtu;
 }
 
 static inline bool ip6_sk_accept_pmtu(const struct sock *sk)
@@ -317,7 +324,7 @@ static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
 	if (dst_metric_locked(dst, RTAX_MTU)) {
 		mtu = dst_metric_raw(dst, RTAX_MTU);
 		if (mtu)
-			return mtu;
+			goto out;
 	}
 
 	mtu = IPV6_MIN_MTU;
@@ -327,7 +334,8 @@ static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
 		mtu = idev->cnf.mtu6;
 	rcu_read_unlock();
 
-	return mtu;
+out:
+	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
 u32 ip6_mtu_from_fib6(const struct fib6_result *res,
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6a36ac98476f..78d1e5afc452 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1306,7 +1306,7 @@ INDIRECT_CALLABLE_SCOPE unsigned int ipv4_mtu(const struct dst_entry *dst)
 		mtu = dst_metric_raw(dst, RTAX_MTU);
 
 	if (mtu)
-		return mtu;
+		goto out;
 
 	mtu = READ_ONCE(dst->dev->mtu);
 
@@ -1315,6 +1315,7 @@ INDIRECT_CALLABLE_SCOPE unsigned int ipv4_mtu(const struct dst_entry *dst)
 			mtu = 576;
 	}
 
+out:
 	mtu = min_t(unsigned int, mtu, IP_MAX_MTU);
 
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
-- 
2.18.4

