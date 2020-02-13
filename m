Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE1915B6A7
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 02:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgBMBY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 20:24:57 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:60443 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729369AbgBMBY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 20:24:56 -0500
X-Greylist: delayed 742 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 20:24:39 EST
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 01D1BMpW030202;
        Thu, 13 Feb 2020 02:11:27 +0100
Received: from utente-Aspire-V3-572G.campusx-relay3.uniroma2.it (wireless-71-132.net.uniroma2.it [160.80.132.71])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 62E54120755;
        Thu, 13 Feb 2020 02:11:18 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1581556278; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Qr0dqfbmrmOhuW2gOdecbNl+46pxTsElNpKXxHd4pJk=;
        b=K5GTNOplh3w4t0jRUno2UK9XudhypfhO4aSMNVtToJY0pU/4ICFCcsyQEEMw//MwUJY+ON
        GPUDnZJ9DHnzXABA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1581556278; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Qr0dqfbmrmOhuW2gOdecbNl+46pxTsElNpKXxHd4pJk=;
        b=Zm8vBlqDjlIsp0zQR0ke9iVq/meV7POuppPwQyCDar0s8lyHYNgzcZR3n172jEleyW5bc1
        ewE+QLEhja7Gb4ps6wn0MissXKO0uOLj97TjdGmSm8QODTT+eG6cKFyMH9p7XitvTfvo5Z
        SXQyI/QDNg+jm76+yB12zpD11o5OFdt0vkUQU+9CWRug3zchQW+buvz5mYxltaowYVi6fN
        gwc3FJsZHaJCKWGwZdomm/3nA82D9gtg/NAR4CwcZUJXQus86CqDN8adzPWtqSnDFKvReK
        YVQLjXLR/f9315LZAJkDXBSAM0hjDb/l/g3agOevctjtZjJrmnWXzzFc6qXpIQ==
From:   Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahmed.abdelsalam@gssi.it, david.lebrun@uclouvain.be,
        dav.lebrun@gmail.com, andrea.mayer@uniroma2.it,
        paolo.lungaroni@cnit.it,
        Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
Subject: [net-next 1/2] Perform IPv4 FIB lookup in a predefined FIB table
Date:   Thu, 13 Feb 2020 02:09:31 +0100
Message-Id: <20200213010932.11817-2-carmine.scarpitta@uniroma2.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
References: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
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
 net/ipv4/route.c    | 22 ++++++++++++++--------
 2 files changed, 15 insertions(+), 9 deletions(-)

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
index d5c57b3f77d5..39cec9883d6f 100644
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
@@ -2109,8 +2109,6 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	if (ipv4_is_multicast(saddr) || ipv4_is_lbcast(saddr))
 		goto martian_source;
 
-	res->fi = NULL;
-	res->table = NULL;
 	if (ipv4_is_lbcast(daddr) || (saddr == 0 && daddr == 0))
 		goto brd_input;
 
@@ -2155,7 +2153,14 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 		fl4.fl4_dport = 0;
 	}
 
-	err = fib_lookup(net, &fl4, res, 0);
+	if (!tbl_known) {
+		res->fi = NULL;
+		res->table = NULL;
+		err = fib_lookup(net, &fl4, res, 0);
+	} else {
+		err = fib_table_lookup(res->table, &fl4, res, FIB_LOOKUP_NOREF);
+	}
+
 	if (err != 0) {
 		if (!IN_DEV_FORWARD(in_dev))
 			err = -EHOSTUNREACH;
@@ -2292,7 +2297,7 @@ int ip_route_input_noref(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 
 	tos &= IPTOS_RT_MASK;
 	rcu_read_lock();
-	err = ip_route_input_rcu(skb, daddr, saddr, tos, dev, &res);
+	err = ip_route_input_rcu(skb, daddr, saddr, tos, dev, &res, false);
 	rcu_read_unlock();
 
 	return err;
@@ -2301,7 +2306,8 @@ EXPORT_SYMBOL(ip_route_input_noref);
 
 /* called with rcu_read_lock held */
 int ip_route_input_rcu(struct sk_buff *skb, __be32 daddr, __be32 saddr,
-		       u8 tos, struct net_device *dev, struct fib_result *res)
+		       u8 tos, struct net_device *dev, struct fib_result *res,
+		       bool tbl_known)
 {
 	/* Multicast recognition logic is moved from route cache to here.
 	   The problem was that too many Ethernet cards have broken/missing
@@ -2347,7 +2353,7 @@ int ip_route_input_rcu(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 		return err;
 	}
 
-	return ip_route_input_slow(skb, daddr, saddr, tos, dev, res);
+	return ip_route_input_slow(skb, daddr, saddr, tos, dev, res, tbl_known);
 }
 
 /* called with rcu_read_lock() */
@@ -3192,7 +3198,7 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		skb->dev	= dev;
 		skb->mark	= mark;
 		err = ip_route_input_rcu(skb, dst, src, rtm->rtm_tos,
-					 dev, &res);
+					 dev, &res, false);
 
 		rt = skb_rtable(skb);
 		if (err == 0 && rt->dst.error)
-- 
2.17.1

