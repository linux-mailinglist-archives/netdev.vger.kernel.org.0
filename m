Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A7420F9D
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 22:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfEPUbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 16:31:21 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41255 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbfEPUbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 16:31:21 -0400
Received: by mail-pf1-f195.google.com with SMTP id q17so2428187pfq.8
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 13:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jitSGam3CnLHvz1G6l5wVlRkNTRj9YI+f+bVjyJcTVU=;
        b=fscj8sq7FjWT1tvyDo7yMIJYRgKpF8pGoVD9iIFTEAlsorWjuJkbZcPgoRuKDFyNQx
         qtJrAAvgdYOSqUibyQE7zSqYcq6m7ABmPLKAmAJZzfgODS5kZMEEGRb47/acuwJIf5mX
         dCoMEO/bqTD/DkL1iTMdDGIxivNm8bhIgahQoowAuknwmuNw7CfInjdFeySP7EzClq3R
         VUoGUqqva9MRDNT2WYQU6UOQzz6cLDGex+8yrLwYL5XvQTVMXkkgJQ3387tpehYi0V6L
         jEoKmcNO8ngbMl/gJNU+Cj2JnidFp+OKjKf+y5szjW4lUwWsABrxuoARelibneIVmrC1
         VzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jitSGam3CnLHvz1G6l5wVlRkNTRj9YI+f+bVjyJcTVU=;
        b=bOUUVyA7xrDEpMkofaOnFYfHpZKTbcfyj38SML2JIPpGRSwea+ZD8kECGT4vP41gMK
         uQj9bwdl7+XQkruRHGQcZ53x7Nw+9G5oh0ZoYjwXpriJVaDQcuz3l2adSywSzpNVC9J+
         2XVq30Z/8X8Tci0VfxxYNtCQ3r2bMAILXnK9JKagsK31Ml7hi9Q72OPOAssKWCScgtAk
         IradN40jCnvojlws+Wd8/cqTn8/TSdFdjYAdqKsYb1h+Is3Jr8zpa7sM9Hb6nNuqTAHZ
         kevdOfvOu+TGESpujpw24Ap/bvZEbzS4Q8kPSEAAn4TREFRZgcs7QCcK7IDiqrt9VQN3
         UoPg==
X-Gm-Message-State: APjAAAWzhottBKU61U48o5CyhdBJwVkSB5kfFOfy8FouWOz7qNObQVWb
        ByfvBTB2rTASYA3VinBssnoIWydNI8I=
X-Google-Smtp-Source: APXvYqyfYvIFQzkhM01zjAt+kfQ01FLzEngOOarhgkmGOP9U5OR5UkJw7dQxfAHwvJPAE99xaytnTQ==
X-Received: by 2002:a65:5682:: with SMTP id v2mr52718998pgs.100.1558038679705;
        Thu, 16 May 2019 13:31:19 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id v66sm14842490pfa.38.2019.05.16.13.31.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 13:31:18 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH v3 net] ipv6: fix src addr routing with the exception table
Date:   Thu, 16 May 2019 13:30:54 -0700
Message-Id: <20190516203054.13066-1-tracywwnj@gmail.com>
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
Changes from v2:
- modified the check in rt6_find_cached_rt() to prevent infinite loop
- add const to src_key to prevent kernel compile warning

Changes from v1:
- restructure the code to only include the new logic in
  rt6_find_cached_rt()
---
 net/ipv6/route.c | 51 +++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 23a20d62daac..0f52d18cb83b 100644
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
+	const struct in6_addr *src_key = NULL;
 	struct rt6_exception_bucket *bucket;
-	struct in6_addr *src_key = NULL;
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
+	if (!ret && src_key && src_key != &res->f6i->fib6_src.addr) {
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

