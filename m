Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133DB1F4BE9
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgFJDuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgFJDuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 23:50:00 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7E012081A;
        Wed, 10 Jun 2020 03:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591760999;
        bh=MKYGTL2C/vD/hKO8uSqCvwU9lfaCSDRbgwweeX+WrAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00nXjnNi/i5BwD0VnkKhCY4w7yxDavYsV8d6bL4uHJauEEYftakudh855TL49Z5n7
         ibdE4P8NFKiM4qz42LRfo/MlGVEniY4fyygh1jaZrMO5nM8ZdUA3zADRJXAlp3c5LL
         hZFhbfBl4OF/aWdTYrhyijq7AAVR8gVdRaSkTtCI=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, assogba.emery@gmail.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH RFC net-next 6/8] nexthop: Add primary_only argument to nexthop_for_each_fib6_nh
Date:   Tue,  9 Jun 2020 21:49:51 -0600
Message-Id: <20200610034953.28861-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200610034953.28861-1-dsahern@kernel.org>
References: <20200610034953.28861-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow on patch adds support for active-backup nexthops. Control
planes needs to always analyze all legs of the nexthops, but
datapath only wants to consider the primary.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 include/net/nexthop.h |  2 +-
 net/ipv4/nexthop.c    |  6 +++---
 net/ipv6/ip6_fib.c    |  4 ++--
 net/ipv6/route.c      | 37 ++++++++++++++++++++-----------------
 4 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 271d2cb92954..8cedadb902b6 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -346,7 +346,7 @@ static inline void nexthop_path_fib6_result(struct fib6_result *res, int hash)
 	}
 }
 
-int nexthop_for_each_fib6_nh(struct nexthop *nh,
+int nexthop_for_each_fib6_nh(struct nexthop *nh, bool primary_only,
 			     int (*cb)(struct fib6_nh *nh, void *arg),
 			     void *arg);
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 0020ea2ecc9f..8984e1e4058b 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -684,7 +684,7 @@ static int nexthop_fib6_nh_cb(struct nexthop *nh,
 	return cb(&nhi->fib6_nh, arg);
 }
 
-static int nexthop_fib6_nhg_cb(struct nh_group *nhg,
+static int nexthop_fib6_nhg_cb(struct nh_group *nhg, bool primary_only,
 			       int (*cb)(struct fib6_nh *nh, void *arg),
 			       void *arg)
 {
@@ -703,7 +703,7 @@ static int nexthop_fib6_nhg_cb(struct nh_group *nhg,
 	return 0;
 }
 
-int nexthop_for_each_fib6_nh(struct nexthop *nh,
+int nexthop_for_each_fib6_nh(struct nexthop *nh, bool primary_only,
 			     int (*cb)(struct fib6_nh *nh, void *arg),
 			     void *arg)
 {
@@ -713,7 +713,7 @@ int nexthop_for_each_fib6_nh(struct nexthop *nh,
 		struct nh_group *nhg;
 
 		nhg = rcu_dereference_rtnl(nh->nh_grp);
-		err = nexthop_fib6_nhg_cb(nhg, cb, arg);
+		err = nexthop_fib6_nhg_cb(nhg, primary_only, cb, arg);
 	} else {
 		err = nexthop_fib6_nh_cb(nh, cb, arg);
 	}
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 49ee89bbcba0..7e593f9d519d 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1009,8 +1009,8 @@ static void fib6_drop_pcpu_from(struct fib6_info *f6i,
 			.table = table
 		};
 
-		nexthop_for_each_fib6_nh(f6i->nh, fib6_nh_drop_pcpu_from,
-					 &arg);
+		nexthop_for_each_fib6_nh(f6i->nh, false,
+					 fib6_nh_drop_pcpu_from, &arg);
 	} else {
 		struct fib6_nh *fib6_nh;
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 82cbb46a2a4f..e2bd3dc7194d 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -526,7 +526,7 @@ static struct fib6_nh *rt6_nh_dev_match(struct net *net, struct nexthop *nh,
 	if (nexthop_is_blackhole(nh))
 		return NULL;
 
-	if (nexthop_for_each_fib6_nh(nh, __rt6_nh_dev_match, &arg))
+	if (nexthop_for_each_fib6_nh(nh, true, __rt6_nh_dev_match, &arg))
 		return arg.nh;
 
 	return NULL;
@@ -827,7 +827,8 @@ static void __find_rr_leaf(struct fib6_info *f6i_start,
 				res->nh = nexthop_fib6_nh(f6i->nh);
 				return;
 			}
-			if (nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_find_match,
+			if (nexthop_for_each_fib6_nh(f6i->nh, true,
+						     rt6_nh_find_match,
 						     &arg)) {
 				matched = true;
 				nh = arg.nh;
@@ -1774,8 +1775,8 @@ static int rt6_nh_flush_exceptions(struct fib6_nh *nh, void *arg)
 void rt6_flush_exceptions(struct fib6_info *f6i)
 {
 	if (f6i->nh)
-		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_flush_exceptions,
-					 f6i);
+		nexthop_for_each_fib6_nh(f6i->nh, false,
+					 rt6_nh_flush_exceptions, f6i);
 	else
 		fib6_nh_flush_exceptions(f6i->fib6_nh, f6i);
 }
@@ -1897,7 +1898,7 @@ static int rt6_remove_exception_rt(struct rt6_info *rt)
 		int rc;
 
 		/* rc = 1 means an entry was found */
-		rc = nexthop_for_each_fib6_nh(from->nh,
+		rc = nexthop_for_each_fib6_nh(from->nh, false,
 					      rt6_nh_remove_exception_rt,
 					      &arg);
 		return rc ? 0 : -ENOENT;
@@ -1973,7 +1974,8 @@ static void rt6_update_exception_stamp_rt(struct rt6_info *rt)
 			.gw = &rt->rt6i_gateway,
 		};
 
-		nexthop_for_each_fib6_nh(from->nh, fib6_nh_find_match, &arg);
+		nexthop_for_each_fib6_nh(from->nh, false, fib6_nh_find_match,
+					 &arg);
 
 		if (!arg.match)
 			goto unlock;
@@ -2166,8 +2168,8 @@ void rt6_age_exceptions(struct fib6_info *f6i,
 			.now = now
 		};
 
-		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_age_exceptions,
-					 &arg);
+		nexthop_for_each_fib6_nh(f6i->nh, false,
+					 rt6_nh_age_exceptions, &arg);
 	} else {
 		fib6_nh_age_exceptions(f6i->fib6_nh, gc_args, now);
 	}
@@ -2768,7 +2770,7 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 				.gw = &rt6->rt6i_gateway,
 			};
 
-			nexthop_for_each_fib6_nh(res.f6i->nh,
+			nexthop_for_each_fib6_nh(res.f6i->nh, true,
 						 fib6_nh_find_match, &arg);
 
 			/* fib6_info uses a nexthop that does not have fib6_nh
@@ -2959,7 +2961,7 @@ static struct rt6_info *__ip6_route_redirect(struct net *net,
 			if (nexthop_is_blackhole(rt->nh))
 				continue;
 			/* on match, res->nh is filled in and potentially ret */
-			if (nexthop_for_each_fib6_nh(rt->nh,
+			if (nexthop_for_each_fib6_nh(rt->nh, true,
 						     fib6_nh_redirect_match,
 						     &arg))
 				goto out;
@@ -3906,7 +3908,8 @@ static int ip6_del_cached_rt_nh(struct fib6_config *cfg, struct fib6_info *f6i)
 		.f6i = f6i
 	};
 
-	return nexthop_for_each_fib6_nh(f6i->nh, fib6_nh_del_cached_rt, &arg);
+	return nexthop_for_each_fib6_nh(f6i->nh, false,
+					fib6_nh_del_cached_rt, &arg);
 }
 
 static int ip6_route_del(struct fib6_config *cfg,
@@ -4096,7 +4099,7 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
 			.gw = &rt->rt6i_gateway,
 		};
 
-		nexthop_for_each_fib6_nh(res.f6i->nh,
+		nexthop_for_each_fib6_nh(res.f6i->nh, true,
 					 fib6_nh_find_match, &arg);
 
 		/* fib6_info uses a nexthop that does not have fib6_nh
@@ -4835,8 +4838,8 @@ static int rt6_mtu_change_route(struct fib6_info *f6i, void *p_arg)
 	arg->f6i = f6i;
 	if (f6i->nh) {
 		/* fib6_nh_mtu_change only returns 0, so this is safe */
-		return nexthop_for_each_fib6_nh(f6i->nh, fib6_nh_mtu_change,
-						arg);
+		return nexthop_for_each_fib6_nh(f6i->nh, false,
+						fib6_nh_mtu_change, arg);
 	}
 
 	return fib6_nh_mtu_change(f6i->fib6_nh, arg);
@@ -5381,7 +5384,7 @@ static size_t rt6_nlmsg_size(struct fib6_info *f6i)
 
 	if (f6i->nh) {
 		nexthop_len = nla_total_size(4); /* RTA_NH_ID */
-		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_nlmsg_size,
+		nexthop_for_each_fib6_nh(f6i->nh, false, rt6_nh_nlmsg_size,
 					 &nexthop_len);
 	} else {
 		struct fib6_nh *nh = f6i->fib6_nh;
@@ -5636,7 +5639,7 @@ static bool fib6_info_uses_dev(const struct fib6_info *f6i,
 	if (f6i->nh) {
 		struct net_device *_dev = (struct net_device *)dev;
 
-		return !!nexthop_for_each_fib6_nh(f6i->nh,
+		return !!nexthop_for_each_fib6_nh(f6i->nh, true,
 						  fib6_info_nh_uses_dev,
 						  _dev);
 	}
@@ -5769,7 +5772,7 @@ int rt6_dump_route(struct fib6_info *rt, void *p_arg, unsigned int skip)
 
 		rcu_read_lock();
 		if (rt->nh) {
-			err = nexthop_for_each_fib6_nh(rt->nh,
+			err = nexthop_for_each_fib6_nh(rt->nh, false,
 						       rt6_nh_dump_exceptions,
 						       &w);
 		} else {
-- 
2.21.1 (Apple Git-122.3)

