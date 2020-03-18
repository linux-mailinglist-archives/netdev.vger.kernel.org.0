Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D3318A918
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgCRXS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:18:27 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:46381 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRXS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 19:18:26 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 02INHLWk003537;
        Thu, 19 Mar 2020 00:17:26 +0100
Received: from utente-Aspire-V3-572G.campusx-relay3.uniroma2.it (wireless-125-133.net.uniroma2.it [160.80.133.125])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 8DA6712289B;
        Thu, 19 Mar 2020 00:17:16 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1584573436; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=iSGAk4HwiZ16/zSHFrsdM03PvsoTUmgS3EJd8tzffTw=;
        b=PRDNOM25c6HycmnlJCVzvXCt9QnAOBcEw8uQH2ufLjviDA27iYBBma129QEjBX0rdTJGdP
        ApAoyDl1uP9YzNCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1584573436; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=iSGAk4HwiZ16/zSHFrsdM03PvsoTUmgS3EJd8tzffTw=;
        b=X/qZSsNAKqOUsivu/rpsVhFRSyrIv+d3OUQPrPrp1uDDkralLBW+C2gmu20iunncXNsKQL
        4+E1QpjzJcw1HjdLxl6a3Jx5jMQ/v+onRAcH+/EbKk/mRHmmjcEmjRZspF35EttyRt7PCQ
        mO+Nel2KCuW6VJKz8KQgsjN38kMjFQe+ETtgsilKlfsZa7VzA+0kDqa6eVtPyLA98exk3G
        MevWI0jfFCB4vGUCx9nTk3T7TZv8wN0aHla3UVRXRlsaorKp72SMh0+kkROPC99W2FqLcX
        E0txf8qIzu1govCLl/b/UGg790gzx5nc1vX64P0LkQD1oq140RQ/vq3PwOG9CQ==
From:   Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahmed.abdelsalam@gssi.it, david.lebrun@uclouvain.be,
        dav.lebrun@gmail.com, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, paolo.lungaroni@cnit.it,
        hiroki.shirokura@linecorp.com,
        Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
Subject: [v2,net-next 1/2] Perform IPv4 FIB lookup in a predefined FIB table
Date:   Thu, 19 Mar 2020 00:16:34 +0100
Message-Id: <20200318231635.15116-2-carmine.scarpitta@uniroma2.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318231635.15116-1-carmine.scarpitta@uniroma2.it>
References: <20200318231635.15116-1-carmine.scarpitta@uniroma2.it>
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In IPv4, the routing subsystem is invoked by calling ip_route_input_rcu()
which performs the recognition logic and calls ip_route_input_slow().

ip_route_input_slow() initialises both "fi" and "table" members
of the fib_result structure to null before calling fib_lookup().

fib_lookup() performs fib lookup in the routing table configured
by the policy routing rules.

In this patch, we allow invoking the ip4 routing subsystem
with known routing table. This is useful for use-cases implementing
a separate routing table per tenant.

The patch introduces a new flag named "tbl_known" to the definition of
ip_route_input_rcu() and ip_route_input_slow().

When the flag is set, ip_route_input_slow() will call fib_table_lookup()
using the defined table instead of using fib_lookup().

Signed-off-by: Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
Acked-by: Ahmed Abdelsalam <ahmed.abdelsalam@gssi.it>
Acked-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Acked-by: Paolo Lungaroni <paolo.lungaroni@cnit.it>
---
 include/net/route.h |  2 +-
 net/ipv4/route.c    | 23 +++++++++++++++++------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index a9c60fc68e36..4ff977bd7029 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -183,7 +183,7 @@ int ip_route_input_noref(struct sk_buff *skb, __be32 dst, __be32 src,
 			 u8 tos, struct net_device *devin);
 int ip_route_input_rcu(struct sk_buff *skb, __be32 dst, __be32 src,
 		       u8 tos, struct net_device *devin,
-		       struct fib_result *res);
+		       struct fib_result *res, bool tbl_known);
 
 int ip_route_use_hint(struct sk_buff *skb, __be32 dst, __be32 src,
 		      u8 tos, struct net_device *devin,
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d5c57b3f77d5..e1eca68eede2 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2077,7 +2077,7 @@ int ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 
 static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 			       u8 tos, struct net_device *dev,
-			       struct fib_result *res)
+			       struct fib_result *res, bool tbl_known)
 {
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
 	struct flow_keys *flkeys = NULL, _flkeys;
@@ -2110,7 +2110,6 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 		goto martian_source;
 
 	res->fi = NULL;
-	res->table = NULL;
 	if (ipv4_is_lbcast(daddr) || (saddr == 0 && daddr == 0))
 		goto brd_input;
 
@@ -2155,7 +2154,18 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 		fl4.fl4_dport = 0;
 	}
 
+#ifdef CONFIG_IP_MULTIPLE_TABLES
+	if (!tbl_known) {
+		res->table = NULL;
+		err = fib_lookup(net, &fl4, res, 0);
+	} else {
+		err = fib_table_lookup(res->table, &fl4, res, FIB_LOOKUP_NOREF);
+	}
+#else
+	res->table = NULL;
 	err = fib_lookup(net, &fl4, res, 0);
+#endif
+
 	if (err != 0) {
 		if (!IN_DEV_FORWARD(in_dev))
 			err = -EHOSTUNREACH;
@@ -2292,7 +2302,7 @@ int ip_route_input_noref(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 
 	tos &= IPTOS_RT_MASK;
 	rcu_read_lock();
-	err = ip_route_input_rcu(skb, daddr, saddr, tos, dev, &res);
+	err = ip_route_input_rcu(skb, daddr, saddr, tos, dev, &res, false);
 	rcu_read_unlock();
 
 	return err;
@@ -2301,7 +2311,8 @@ EXPORT_SYMBOL(ip_route_input_noref);
 
 /* called with rcu_read_lock held */
 int ip_route_input_rcu(struct sk_buff *skb, __be32 daddr, __be32 saddr,
-		       u8 tos, struct net_device *dev, struct fib_result *res)
+		       u8 tos, struct net_device *dev, struct fib_result *res,
+		       bool tbl_known)
 {
 	/* Multicast recognition logic is moved from route cache to here.
 	   The problem was that too many Ethernet cards have broken/missing
@@ -2347,7 +2358,7 @@ int ip_route_input_rcu(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 		return err;
 	}
 
-	return ip_route_input_slow(skb, daddr, saddr, tos, dev, res);
+	return ip_route_input_slow(skb, daddr, saddr, tos, dev, res, tbl_known);
 }
 
 /* called with rcu_read_lock() */
@@ -3192,7 +3203,7 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		skb->dev	= dev;
 		skb->mark	= mark;
 		err = ip_route_input_rcu(skb, dst, src, rtm->rtm_tos,
-					 dev, &res);
+					 dev, &res, false);
 
 		rt = skb_rtable(skb);
 		if (err == 0 && rt->dst.error)
-- 
2.17.1

