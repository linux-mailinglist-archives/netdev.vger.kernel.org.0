Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD5F20E7F
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 20:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfEPSQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 14:16:45 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40497 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfEPSQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 14:16:45 -0400
Received: by mail-pf1-f193.google.com with SMTP id u17so2260178pfn.7
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 11:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WmuiJ5HlLOGgycFpK0UbJBh1e2IYHLjHX3EqeXsVJNE=;
        b=i0rxd7oM69QuahjeHRNLwK+IY2cRwsDrEsmj0NB4F3GFYdkXLORxYQnlLcCIGXQpTY
         pYzbm5aGK5Kxdy8/NXXSWKcZGEFwCkbxD1Z7dfu43uubws9/ADMYu7e9oYjIQiDojfuw
         rOzQlOMEZP0oW7dDacy9Y5CMxSQpy9/EnWjOQAruStHtbt3VMonC6j/qvH+wA9Mr6As4
         WxE6eY+iaNyE1x89gx195RrHt13II6gvmi1IxXrT3AcwlFoMv60bS2EQPDeQf5LKXR14
         3S8zX3EU3wdEEMYh8E+EIZBtriijK1bLynV42Ionubd47yYNCV3zVILT1/tekmzubZt6
         oCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WmuiJ5HlLOGgycFpK0UbJBh1e2IYHLjHX3EqeXsVJNE=;
        b=ej6i1VrgW+9DPLvD8ETDcXXFLPhbqjtAwrGtyP8LSKsxjdtOALCaI6Nviu+NuFmesu
         3GJWxxPqM3pT4j9MEMBsEnUZZP1vtszEXTxnF6Uu9KrmvFm7w7Yv6qg2fJ1TxJYE6v9B
         iTy02aT7okowuvLbxllKNaqaneUxo8/fwKk10YgfbbypjDhdqqQydKNwdfH7Ue3bgvc/
         uUeuanE+3bP5zr0NwEp8L64DrpAXvEVU7wqRBCXkTvb5cBCMAE2m+FOyx/4AftuVodgY
         hM5QZf1ur7GJQeEQf9kVJU7BF33+XxITWUPl7vFoWG0/B96yLcCuqsx7rks3RDDPufbF
         ug/A==
X-Gm-Message-State: APjAAAVjaG2Yy5Yq5jXAShHfy4vacuZNxb7798wa5or3MhlEkCYhfpb7
        xAFbSnCChfcmZKtfiDVP/xg=
X-Google-Smtp-Source: APXvYqza9fHQMxbtaFWHNK6n+N/X579tfOFGKSZr3VzzfLfYe0nFVePEA/hvE7Qm+ZIxuTJqPbG1NQ==
X-Received: by 2002:a63:1e4d:: with SMTP id p13mr51815819pgm.125.1558030604108;
        Thu, 16 May 2019 11:16:44 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id b18sm12495114pfp.32.2019.05.16.11.16.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 11:16:43 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wei Wang <weiwan@google.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        David Ahern <dsahern@gmail.com>, Martin Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH v2 net] ipv6: fix src addr routing with the exception table
Date:   Thu, 16 May 2019 11:16:20 -0700
Message-Id: <20190516181620.126962-1-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>

When inserting route cache into the exception table, the key is
generated with both src_addr and dest_addr with src addr routing.
However, current logic always assumes the src_addr used to generate the
key is a /128 host address. This is not true in the following scenarios:
1. When the route is a gateway route or does not have next hop.
   (rt6_is_gw_or_nonexthop() == false)
2. When calling ip6_rt_cache_alloc(), saddr is passed in as NULL.
This means, when looking for a route cache in the exception table, we
have to do the lookup twice: first time with the passed in /128 host
address, second time with the src_addr stored in fib6_info.

This solves the pmtu discovery issue reported by Mikael Magnusson where
a route cache with a lower mtu info is created for a gateway route with
src addr. However, the lookup code is not able to find this route cache.

Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
Reported-by: Mikael Magnusson <mikael.kernel@lists.m7n.se>
Bisected-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Cc: Martin Lau <kafai@fb.com>
Cc: Eric Dumazet <edumazet@google.com>
---
Changes from v1:
- restructure the code to only include the new logic in
  rt6_find_cached_rt()
---
 net/ipv6/route.c | 49 +++++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 23a20d62daac..35873b57c7f1 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -111,8 +111,8 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 			 int iif, int type, u32 portid, u32 seq,
 			 unsigned int flags);
 static struct rt6_info *rt6_find_cached_rt(const struct fib6_result *res,
-					   struct in6_addr *daddr,
-					   struct in6_addr *saddr);
+					   const struct in6_addr *daddr,
+					   const struct in6_addr *saddr);
 
 #ifdef CONFIG_IPV6_ROUTE_INFO
 static struct fib6_info *rt6_add_route_info(struct net *net,
@@ -1566,31 +1566,44 @@ void rt6_flush_exceptions(struct fib6_info *rt)
  * Caller has to hold rcu_read_lock()
  */
 static struct rt6_info *rt6_find_cached_rt(const struct fib6_result *res,
-					   struct in6_addr *daddr,
-					   struct in6_addr *saddr)
+					   const struct in6_addr *daddr,
+					   const struct in6_addr *saddr)
 {
 	struct rt6_exception_bucket *bucket;
 	struct in6_addr *src_key = NULL;
 	struct rt6_exception *rt6_ex;
 	struct rt6_info *ret = NULL;
 
-	bucket = rcu_dereference(res->f6i->rt6i_exception_bucket);
-
 #ifdef CONFIG_IPV6_SUBTREES
 	/* fib6i_src.plen != 0 indicates f6i is in subtree
 	 * and exception table is indexed by a hash of
 	 * both fib6_dst and fib6_src.
-	 * Otherwise, the exception table is indexed by
-	 * a hash of only fib6_dst.
+	 * However, the src addr used to create the hash
+	 * might not be exactly the passed in saddr which
+	 * is a /128 addr from the flow.
+	 * So we need to use f6i->fib6_src to redo lookup
+	 * if the passed in saddr does not find anything.
+	 * (See the logic in ip6_rt_cache_alloc() on how
+	 * rt->rt6i_src is updated.)
 	 */
 	if (res->f6i->fib6_src.plen)
 		src_key = saddr;
+find_ex:
 #endif
+	bucket = rcu_dereference(res->f6i->rt6i_exception_bucket);
 	rt6_ex = __rt6_find_exception_rcu(&bucket, daddr, src_key);
 
 	if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
 		ret = rt6_ex->rt6i;
 
+#ifdef CONFIG_IPV6_SUBTREES
+	/* Use fib6_src as src_key and redo lookup */
+	if (!ret && src_key == saddr) {
+		src_key = &res->f6i->fib6_src.addr;
+		goto find_ex;
+	}
+#endif
+
 	return ret;
 }
 
@@ -2665,12 +2678,10 @@ u32 ip6_mtu_from_fib6(const struct fib6_result *res,
 		      const struct in6_addr *daddr,
 		      const struct in6_addr *saddr)
 {
-	struct rt6_exception_bucket *bucket;
 	const struct fib6_nh *nh = res->nh;
 	struct fib6_info *f6i = res->f6i;
-	const struct in6_addr *src_key;
-	struct rt6_exception *rt6_ex;
 	struct inet6_dev *idev;
+	struct rt6_info *rt;
 	u32 mtu = 0;
 
 	if (unlikely(fib6_metric_locked(f6i, RTAX_MTU))) {
@@ -2679,18 +2690,10 @@ u32 ip6_mtu_from_fib6(const struct fib6_result *res,
 			goto out;
 	}
 
-	src_key = NULL;
-#ifdef CONFIG_IPV6_SUBTREES
-	if (f6i->fib6_src.plen)
-		src_key = saddr;
-#endif
-
-	bucket = rcu_dereference(f6i->rt6i_exception_bucket);
-	rt6_ex = __rt6_find_exception_rcu(&bucket, daddr, src_key);
-	if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
-		mtu = dst_metric_raw(&rt6_ex->rt6i->dst, RTAX_MTU);
-
-	if (likely(!mtu)) {
+	rt = rt6_find_cached_rt(res, daddr, saddr);
+	if (unlikely(rt)) {
+		mtu = dst_metric_raw(&rt->dst, RTAX_MTU);
+	} else {
 		struct net_device *dev = nh->fib_nh_dev;
 
 		mtu = IPV6_MIN_MTU;
-- 
2.21.0.1020.gf2820cf01a-goog

