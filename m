Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B141E65F
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 02:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfEOAqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 20:46:40 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39329 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfEOAqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 20:46:39 -0400
Received: by mail-pl1-f193.google.com with SMTP id g9so424258plm.6
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 17:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i7y6/ejK2urGPctAL/H113eH1s8qU67tOf4447QHG8M=;
        b=GGhJ80LAk/9ThTyci2GoeY9xikP8xqinRKiQ+FU6Ey2jaANDtnBYYDpen4uhGJEg0q
         PTzlK3SBJ1gZoK6qkv/n3rrJpvU+O5qummejkRZYpOSr4IfxlFD39FdRaJBRkTjeiDOt
         lWnrV0NvukT2HbfaBJh8ftH31I5VeXf1IF7w+3De1Jbtt67EDt2+av+hYD3Z4LoW6A9x
         qMxVyVIAt9f1vWeht9xSAim/WVPydl/u8IVuOmo1GandC9byRdlrJYm5sHO3i9w2bS//
         W4ZA0mM3LBCW0a48NDh+dAdKgKjaEPl6Ma4LBPwjxQoShZAzFDRo5ACLZXAcEdklSwh0
         9r3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i7y6/ejK2urGPctAL/H113eH1s8qU67tOf4447QHG8M=;
        b=Abz+XUucHkxt+aDRnjnjATymqvhDd+AeZf2BccOMQeVmCQ2quL15URPpPR6XnUMIa+
         +8xUtUw7gph25Q6bSBmWIumIbSdWYreIYJS+siY0mL1AZdgzwzCGbwmLTzTmo1Yi/Dse
         hFBxomsvAMvVw3t1WrvGMzxZrA1/jvC2RkPNe69Ijl86x9qSVclgMaa0bchTGYo2y7MB
         npona7ZlqT1pL7O/3dPN9Nr099ODrv5MV7pZmsJ4wHaJAOtJlq8yi1ncNolge/2DO3KG
         I2g2FemUM4iOq0WzGhpo+2WtfX7TZLnaAYYVxvhtZOmYj0Y+NGm7BL3YnEkPIiwVhhHi
         3Y/w==
X-Gm-Message-State: APjAAAVWbqJhglc7mZIHiQjZbEDu5WmkXcgR+q9FORjWpRTHC4JSE4L9
        BdVzNMjvXLUTDUzlWnYdiU0=
X-Google-Smtp-Source: APXvYqzhOlnWmwOFKWo/grS8J+u+jYwjDK8OkZvpdghm40DTgPHIVv/AybnZazwloGSCXvTZhwcFgA==
X-Received: by 2002:a17:902:2a28:: with SMTP id i37mr38958752plb.47.1557881198708;
        Tue, 14 May 2019 17:46:38 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id q10sm271486pgh.93.2019.05.14.17.46.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 17:46:37 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] ipv6: fix src addr routing with the exception table
Date:   Tue, 14 May 2019 17:46:10 -0700
Message-Id: <20190515004610.102519-1-tracywwnj@gmail.com>
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
Acked-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/route.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 23a20d62daac..c36900a07a78 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1574,23 +1574,36 @@ static struct rt6_info *rt6_find_cached_rt(const struct fib6_result *res,
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
 
@@ -2683,12 +2696,22 @@ u32 ip6_mtu_from_fib6(const struct fib6_result *res,
 #ifdef CONFIG_IPV6_SUBTREES
 	if (f6i->fib6_src.plen)
 		src_key = saddr;
+find_ex:
 #endif
-
 	bucket = rcu_dereference(f6i->rt6i_exception_bucket);
 	rt6_ex = __rt6_find_exception_rcu(&bucket, daddr, src_key);
 	if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
 		mtu = dst_metric_raw(&rt6_ex->rt6i->dst, RTAX_MTU);
+#ifdef CONFIG_IPV6_SUBTREES
+	/* Similar logic as in rt6_find_cached_rt().
+	 * We need to use f6i->fib6_src to redo lookup in exception
+	 * table if saddr did not yield any result.
+	 */
+	else if (src_key == saddr) {
+		src_key = &f6i->fib6_src.addr;
+		goto find_ex;
+	}
+#endif
 
 	if (likely(!mtu)) {
 		struct net_device *dev = nh->fib_nh_dev;
-- 
2.21.0.1020.gf2820cf01a-goog

