Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88E23B4757
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 18:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbhFYQYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 12:24:10 -0400
Received: from novek.ru ([213.148.174.62]:32928 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229741AbhFYQYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 12:24:08 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 580D15006F4;
        Fri, 25 Jun 2021 19:19:47 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 580D15006F4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1624637988; bh=IIdYOt76pPp/xsK07p9lzAwrjDJKt3ZZ9LkXwfIritw=;
        h=From:To:Cc:Subject:Date:From;
        b=xPi0h6Ny9zColP9i+FVncH3Qsbxl2Pzyin6C6fo2R/SDg2OC0drfcC/ufopPyaF+8
         O4eGkLMywGnGy4n0/tM2yXzPh1SNh08LGTWWLEXk99oOSQtc/5nNOwB6fgG3n5nY7G
         byoYwUoOZZEJArdPvcNcUIx7PMuD+YP0SIcYxq+E=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net v2] net: lwtunnel: handle MTU calculation in forwading
Date:   Fri, 25 Jun 2021 19:21:39 +0300
Message-Id: <20210625162139.9067-1-vfedorenko@novek.ru>
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
 include/net/ip.h        | 12 ++++++++----
 include/net/ip6_route.h | 16 ++++++++++++----
 net/ipv4/route.c        |  3 ++-
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index e20874059f82..d9683bef8684 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -31,6 +31,7 @@
 #include <net/flow.h>
 #include <net/flow_dissector.h>
 #include <net/netns/hash.h>
+#include <net/lwtunnel.h>
 
 #define IPV4_MAX_PMTU		65535U		/* RFC 2675, Section 5.1 */
 #define IPV4_MIN_MTU		68			/* RFC 791 */
@@ -445,22 +446,25 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 
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
 					  const struct sk_buff *skb)
 {
+	unsigned int mtu;
+
 	if (!sk || !sk_fullsock(sk) || ip_sk_use_pmtu(sk)) {
 		bool forwarding = IPCB(skb)->flags & IPSKB_FORWARDED;
 
 		return ip_dst_mtu_maybe_forward(skb_dst(skb), forwarding);
 	}
 
-	return min(READ_ONCE(skb_dst(skb)->dev->mtu), IP_MAX_MTU);
+	mtu = min(READ_ONCE(skb_dst(skb)->dev->mtu), IP_MAX_MTU);
+	return mtu - lwtunnel_headroom(skb_dst(skb)->lwtstate, mtu);
 }
 
 struct dst_metrics *ip_fib_metrics_init(struct net *net, struct nlattr *fc_mx,
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index f51a118bfce8..f14149df5a65 100644
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
+		mtu -= lwtunnel_headroom(skb_dst(skb)->lwtstate, mtu);
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

