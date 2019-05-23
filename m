Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70AEC274CB
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 05:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbfEWD2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 23:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbfEWD2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 23:28:05 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 065F9217D7;
        Thu, 23 May 2019 03:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558582084;
        bh=Z/bFN0VpsqirIMZT73C+rS4cjkoRsCF8bADjsnHxQWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m71dxqg8x7kHD+9m8vrSv0NUCGkZuka3QVg6SOUEPqqnjHvMNb/7AYFEz9G+RfkSM
         rGcb+GEmEGC56R7HF4SpjHACRwusOfLhxDr9hOkrLuuUpoxutULc2L/YNp3uuLiSjY
         Y65/zfHYGpwuh3V+QuJOrGy6Kg8gCE0Ziw6OjMFE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, idosch@mellanox.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 4/7] ipv6: Move exception bucket to fib6_nh
Date:   Wed, 22 May 2019 20:27:58 -0700
Message-Id: <20190523032801.11122-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523032801.11122-1-dsahern@kernel.org>
References: <20190523032801.11122-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Similar to the pcpu routes exceptions are really per nexthop, so move
rt6i_exception_bucket from fib6_info to fib6_nh.

To avoid additional increases to the size of fib6_nh for a 1-bit flag,
use the lowest bit in the allocated memory pointer for the flushed flag.
Add helpers for retrieving the bucket pointer to mask off the flag.

The cleanup of the exception bucket is moved to fib6_nh_release.

fib6_nh_flush_exceptions can now be called from 2 contexts:
1. deleting a fib entry
2. deleting a fib6_nh

For 1., fib6_nh_flush_exceptions is called for a specific fib6_info that
is getting deleted. All exceptions in the cache using the entry are
deleted. For 2, the fib6_nh itself is getting destroyed so
fib6_nh_flush_exceptions is called for a NULL fib6_info which means
flush all entries.

The pmtu.sh selftest exercises the affected code paths - from creating
exceptions to cleaning them up on device delete. All tests pass without
any rcu locking or memleak warnings.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip6_fib.h |   8 +--
 net/ipv6/ip6_fib.c    |   6 --
 net/ipv6/route.c      | 185 +++++++++++++++++++++++++++++++++-----------------
 3 files changed, 126 insertions(+), 73 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 38e87ef81b7e..6b4852cf2fc2 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -133,6 +133,7 @@ struct fib6_nh {
 #endif
 
 	struct rt6_info * __percpu *rt6i_pcpu;
+	struct rt6_exception_bucket __rcu *rt6i_exception_bucket;
 };
 
 struct fib6_info {
@@ -158,18 +159,15 @@ struct fib6_info {
 	struct rt6key			fib6_src;
 	struct rt6key			fib6_prefsrc;
 
-	struct rt6_exception_bucket __rcu *rt6i_exception_bucket;
-
 	u32				fib6_metric;
 	u8				fib6_protocol;
 	u8				fib6_type;
-	u8				exception_bucket_flushed:1,
-					should_flush:1,
+	u8				should_flush:1,
 					dst_nocount:1,
 					dst_nopolicy:1,
 					dst_host:1,
 					fib6_destroying:1,
-					unused:2;
+					unused:3;
 
 	struct fib6_nh			fib6_nh;
 	struct rcu_head			rcu;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 178a9c2d2d34..87ac82f850d2 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -164,17 +164,11 @@ struct fib6_info *fib6_info_alloc(gfp_t gfp_flags)
 void fib6_info_destroy_rcu(struct rcu_head *head)
 {
 	struct fib6_info *f6i = container_of(head, struct fib6_info, rcu);
-	struct rt6_exception_bucket *bucket;
 
 	WARN_ON(f6i->fib6_node);
 
-	bucket = rcu_dereference_protected(f6i->rt6i_exception_bucket, 1);
-	kfree(bucket);
-
 	fib6_nh_release(&f6i->fib6_nh);
-
 	ip_fib_metrics_put(f6i->fib6_metrics);
-
 	kfree(f6i);
 }
 EXPORT_SYMBOL_GPL(fib6_info_destroy_rcu);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 8bfaa7349e10..b01118a3c42e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1461,25 +1461,74 @@ static unsigned int fib6_mtu(const struct fib6_result *res)
 	return mtu - lwtunnel_headroom(nh->fib_nh_lws, mtu);
 }
 
+#define FIB6_EXCEPTION_BUCKET_FLUSHED  0x1UL
+
+/* used when the flushed bit is not relevant, only access to the bucket
+ * (ie., all bucket users except rt6_insert_exception);
+ *
+ * called under rcu lock; sometimes called with rt6_exception_lock held
+ */
+static
+struct rt6_exception_bucket *fib6_nh_get_excptn_bucket(const struct fib6_nh *nh,
+						       spinlock_t *lock)
+{
+	struct rt6_exception_bucket *bucket;
+
+	if (lock)
+		bucket = rcu_dereference_protected(nh->rt6i_exception_bucket,
+						   lockdep_is_held(lock));
+	else
+		bucket = rcu_dereference(nh->rt6i_exception_bucket);
+
+	/* remove bucket flushed bit if set */
+	if (bucket) {
+		unsigned long p = (unsigned long)bucket;
+
+		p &= ~FIB6_EXCEPTION_BUCKET_FLUSHED;
+		bucket = (struct rt6_exception_bucket *)p;
+	}
+
+	return bucket;
+}
+
+static bool fib6_nh_excptn_bucket_flushed(struct rt6_exception_bucket *bucket)
+{
+	unsigned long p = (unsigned long)bucket;
+
+	return !!(p & FIB6_EXCEPTION_BUCKET_FLUSHED);
+}
+
+/* called with rt6_exception_lock held */
+static void fib6_nh_excptn_bucket_set_flushed(struct fib6_nh *nh,
+					      spinlock_t *lock)
+{
+	struct rt6_exception_bucket *bucket;
+	unsigned long p;
+
+	bucket = rcu_dereference_protected(nh->rt6i_exception_bucket,
+					   lockdep_is_held(lock));
+
+	p = (unsigned long)bucket;
+	p |= FIB6_EXCEPTION_BUCKET_FLUSHED;
+	bucket = (struct rt6_exception_bucket *)p;
+	rcu_assign_pointer(nh->rt6i_exception_bucket, bucket);
+}
+
 static int rt6_insert_exception(struct rt6_info *nrt,
 				const struct fib6_result *res)
 {
 	struct net *net = dev_net(nrt->dst.dev);
 	struct rt6_exception_bucket *bucket;
+	struct fib6_info *f6i = res->f6i;
 	struct in6_addr *src_key = NULL;
 	struct rt6_exception *rt6_ex;
-	struct fib6_info *f6i = res->f6i;
+	struct fib6_nh *nh = res->nh;
 	int err = 0;
 
 	spin_lock_bh(&rt6_exception_lock);
 
-	if (f6i->exception_bucket_flushed) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	bucket = rcu_dereference_protected(f6i->rt6i_exception_bucket,
-					lockdep_is_held(&rt6_exception_lock));
+	bucket = rcu_dereference_protected(nh->rt6i_exception_bucket,
+					  lockdep_is_held(&rt6_exception_lock));
 	if (!bucket) {
 		bucket = kcalloc(FIB6_EXCEPTION_BUCKET_SIZE, sizeof(*bucket),
 				 GFP_ATOMIC);
@@ -1487,7 +1536,10 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 			err = -ENOMEM;
 			goto out;
 		}
-		rcu_assign_pointer(f6i->rt6i_exception_bucket, bucket);
+		rcu_assign_pointer(nh->rt6i_exception_bucket, bucket);
+	} else if (fib6_nh_excptn_bucket_flushed(bucket)) {
+		err = -EINVAL;
+		goto out;
 	}
 
 #ifdef CONFIG_IPV6_SUBTREES
@@ -1550,21 +1602,24 @@ static void fib6_nh_flush_exceptions(struct fib6_nh *nh, struct fib6_info *from)
 	int i;
 
 	spin_lock_bh(&rt6_exception_lock);
-	/* Prevent rt6_insert_exception() to recreate the bucket list */
-	from->exception_bucket_flushed = 1;
 
-	bucket = rcu_dereference_protected(from->rt6i_exception_bucket,
-				    lockdep_is_held(&rt6_exception_lock));
+	bucket = fib6_nh_get_excptn_bucket(nh, &rt6_exception_lock);
 	if (!bucket)
 		goto out;
 
+	/* Prevent rt6_insert_exception() to recreate the bucket list */
+	if (!from)
+		fib6_nh_excptn_bucket_set_flushed(nh, &rt6_exception_lock);
+
 	for (i = 0; i < FIB6_EXCEPTION_BUCKET_SIZE; i++) {
-		hlist_for_each_entry_safe(rt6_ex, tmp, &bucket->chain, hlist)
-			rt6_remove_exception(bucket, rt6_ex);
-		WARN_ON_ONCE(bucket->depth);
+		hlist_for_each_entry_safe(rt6_ex, tmp, &bucket->chain, hlist) {
+			if (!from ||
+			    rcu_access_pointer(rt6_ex->rt6i->from) == from)
+				rt6_remove_exception(bucket, rt6_ex);
+		}
+		WARN_ON_ONCE(!from && bucket->depth);
 		bucket++;
 	}
-
 out:
 	spin_unlock_bh(&rt6_exception_lock);
 }
@@ -1602,7 +1657,7 @@ static struct rt6_info *rt6_find_cached_rt(const struct fib6_result *res,
 		src_key = saddr;
 find_ex:
 #endif
-	bucket = rcu_dereference(res->f6i->rt6i_exception_bucket);
+	bucket = fib6_nh_get_excptn_bucket(res->nh, NULL);
 	rt6_ex = __rt6_find_exception_rcu(&bucket, daddr, src_key);
 
 	if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
@@ -1620,7 +1675,7 @@ static struct rt6_info *rt6_find_cached_rt(const struct fib6_result *res,
 }
 
 /* Remove the passed in cached rt from the hash table that contains it */
-static int fib6_nh_remove_exception(const struct fib6_info *from, int plen,
+static int fib6_nh_remove_exception(const struct fib6_nh *nh, int plen,
 				    const struct rt6_info *rt)
 {
 	const struct in6_addr *src_key = NULL;
@@ -1628,15 +1683,16 @@ static int fib6_nh_remove_exception(const struct fib6_info *from, int plen,
 	struct rt6_exception *rt6_ex;
 	int err;
 
-	if (!rcu_access_pointer(from->rt6i_exception_bucket))
+	if (!rcu_access_pointer(nh->rt6i_exception_bucket))
 		return -ENOENT;
 
 	spin_lock_bh(&rt6_exception_lock);
-	bucket = rcu_dereference_protected(from->rt6i_exception_bucket,
-				    lockdep_is_held(&rt6_exception_lock));
+	bucket = fib6_nh_get_excptn_bucket(nh, &rt6_exception_lock);
+
 #ifdef CONFIG_IPV6_SUBTREES
-	/* plen != 0 indicates 'from' is in subtree and exception
-	 * table is indexed by a hash of both rt6i_dst and rt6i_src.
+	/* rt6i_src.plen != 0 indicates 'from' is in subtree
+	 * and exception table is indexed by a hash of
+	 * both rt6i_dst and rt6i_src.
 	 * Otherwise, the exception table is indexed by
 	 * a hash of only rt6i_dst.
 	 */
@@ -1662,37 +1718,35 @@ static int rt6_remove_exception_rt(struct rt6_info *rt)
 	struct fib6_info *from;
 
 	from = rcu_dereference(rt->from);
-	if (!from ||
-	    !(rt->rt6i_flags & RTF_CACHE))
+	if (!from || !(rt->rt6i_flags & RTF_CACHE))
 		return -EINVAL;
 
-	return fib6_nh_remove_exception(from, from->fib6_src.plen, rt);
+	return fib6_nh_remove_exception(&from->fib6_nh,
+					from->fib6_src.plen, rt);
 }
 
 /* Find rt6_ex which contains the passed in rt cache and
  * refresh its stamp
  */
-static void fib6_nh_update_exception(const struct fib6_info *from, int plen,
+static void fib6_nh_update_exception(const struct fib6_nh *nh, int plen,
 				     const struct rt6_info *rt)
 {
 	const struct in6_addr *src_key = NULL;
 	struct rt6_exception_bucket *bucket;
 	struct rt6_exception *rt6_ex;
 
-	bucket = rcu_dereference(from->rt6i_exception_bucket);
-
+	bucket = fib6_nh_get_excptn_bucket(nh, NULL);
 #ifdef CONFIG_IPV6_SUBTREES
-	/* plen != 0 indicates 'from' is in subtree and exception
-	 * table is indexed by a hash of both rt6i_dst and rt6i_src.
+	/* rt6i_src.plen != 0 indicates 'from' is in subtree
+	 * and exception table is indexed by a hash of
+	 * both rt6i_dst and rt6i_src.
 	 * Otherwise, the exception table is indexed by
 	 * a hash of only rt6i_dst.
 	 */
 	if (plen)
 		src_key = &rt->rt6i_src.addr;
 #endif
-	rt6_ex = __rt6_find_exception_rcu(&bucket,
-					  &rt->rt6i_dst.addr,
-					  src_key);
+	rt6_ex = __rt6_find_exception_rcu(&bucket, &rt->rt6i_dst.addr, src_key);
 	if (rt6_ex)
 		rt6_ex->stamp = jiffies;
 }
@@ -1707,7 +1761,7 @@ static void rt6_update_exception_stamp_rt(struct rt6_info *rt)
 	if (!from || !(rt->rt6i_flags & RTF_CACHE))
 		goto unlock;
 
-	fib6_nh_update_exception(from, from->fib6_src.plen, rt);
+	fib6_nh_update_exception(&from->fib6_nh, from->fib6_src.plen, rt);
 unlock:
 	rcu_read_unlock();
 }
@@ -1735,15 +1789,13 @@ static bool rt6_mtu_change_route_allowed(struct inet6_dev *idev,
 }
 
 static void rt6_exceptions_update_pmtu(struct inet6_dev *idev,
-				       struct fib6_info *rt, int mtu)
+				       const struct fib6_nh *nh, int mtu)
 {
 	struct rt6_exception_bucket *bucket;
 	struct rt6_exception *rt6_ex;
 	int i;
 
-	bucket = rcu_dereference_protected(rt->rt6i_exception_bucket,
-					lockdep_is_held(&rt6_exception_lock));
-
+	bucket = fib6_nh_get_excptn_bucket(nh, &rt6_exception_lock);
 	if (!bucket)
 		return;
 
@@ -1765,21 +1817,19 @@ static void rt6_exceptions_update_pmtu(struct inet6_dev *idev,
 
 #define RTF_CACHE_GATEWAY	(RTF_GATEWAY | RTF_CACHE)
 
-static void rt6_exceptions_clean_tohost(struct fib6_info *rt,
-					struct in6_addr *gateway)
+static void fib6_nh_exceptions_clean_tohost(const struct fib6_nh *nh,
+					    const struct in6_addr *gateway)
 {
 	struct rt6_exception_bucket *bucket;
 	struct rt6_exception *rt6_ex;
 	struct hlist_node *tmp;
 	int i;
 
-	if (!rcu_access_pointer(rt->rt6i_exception_bucket))
+	if (!rcu_access_pointer(nh->rt6i_exception_bucket))
 		return;
 
 	spin_lock_bh(&rt6_exception_lock);
-	bucket = rcu_dereference_protected(rt->rt6i_exception_bucket,
-				     lockdep_is_held(&rt6_exception_lock));
-
+	bucket = fib6_nh_get_excptn_bucket(nh, &rt6_exception_lock);
 	if (bucket) {
 		for (i = 0; i < FIB6_EXCEPTION_BUCKET_SIZE; i++) {
 			hlist_for_each_entry_safe(rt6_ex, tmp,
@@ -1844,7 +1894,7 @@ static void rt6_age_examine_exception(struct rt6_exception_bucket *bucket,
 	gc_args->more++;
 }
 
-static void fib6_nh_age_exceptions(struct fib6_info *rt,
+static void fib6_nh_age_exceptions(const struct fib6_nh *nh,
 				   struct fib6_gc_args *gc_args,
 				   unsigned long now)
 {
@@ -1853,14 +1903,12 @@ static void fib6_nh_age_exceptions(struct fib6_info *rt,
 	struct hlist_node *tmp;
 	int i;
 
-	if (!rcu_access_pointer(rt->rt6i_exception_bucket))
+	if (!rcu_access_pointer(nh->rt6i_exception_bucket))
 		return;
 
 	rcu_read_lock_bh();
 	spin_lock(&rt6_exception_lock);
-	bucket = rcu_dereference_protected(rt->rt6i_exception_bucket,
-				    lockdep_is_held(&rt6_exception_lock));
-
+	bucket = fib6_nh_get_excptn_bucket(nh, &rt6_exception_lock);
 	if (bucket) {
 		for (i = 0; i < FIB6_EXCEPTION_BUCKET_SIZE; i++) {
 			hlist_for_each_entry_safe(rt6_ex, tmp,
@@ -1875,11 +1923,11 @@ static void fib6_nh_age_exceptions(struct fib6_info *rt,
 	rcu_read_unlock_bh();
 }
 
-void rt6_age_exceptions(struct fib6_info *rt,
+void rt6_age_exceptions(struct fib6_info *f6i,
 			struct fib6_gc_args *gc_args,
 			unsigned long now)
 {
-	fib6_nh_age_exceptions(rt, gc_args, now);
+	fib6_nh_age_exceptions(&f6i->fib6_nh, gc_args, now);
 }
 
 /* must be called with rcu lock held */
@@ -3122,6 +3170,19 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 
 void fib6_nh_release(struct fib6_nh *fib6_nh)
 {
+	struct rt6_exception_bucket *bucket;
+
+	rcu_read_lock();
+
+	fib6_nh_flush_exceptions(fib6_nh, NULL);
+	bucket = fib6_nh_get_excptn_bucket(fib6_nh, NULL);
+	if (bucket) {
+		rcu_assign_pointer(fib6_nh->rt6i_exception_bucket, NULL);
+		kfree(bucket);
+	}
+
+	rcu_read_unlock();
+
 	if (fib6_nh->rt6i_pcpu) {
 		int cpu;
 
@@ -3411,9 +3472,11 @@ static int ip6_route_del(struct fib6_config *cfg,
 		for_each_fib6_node_rt_rcu(fn) {
 			struct fib6_nh *nh;
 
+			nh = &rt->fib6_nh;
 			if (cfg->fc_flags & RTF_CACHE) {
 				struct fib6_result res = {
 					.f6i = rt,
+					.nh = nh,
 				};
 				int rc;
 
@@ -3430,7 +3493,6 @@ static int ip6_route_del(struct fib6_config *cfg,
 				continue;
 			}
 
-			nh = &rt->fib6_nh;
 			if (cfg->fc_ifindex &&
 			    (!nh->fib_nh_dev ||
 			     nh->fib_nh_dev->ifindex != cfg->fc_ifindex))
@@ -3947,18 +4009,17 @@ void rt6_remove_prefsrc(struct inet6_ifaddr *ifp)
 static int fib6_clean_tohost(struct fib6_info *rt, void *arg)
 {
 	struct in6_addr *gateway = (struct in6_addr *)arg;
+	struct fib6_nh *nh = &rt->fib6_nh;
 
 	if (((rt->fib6_flags & RTF_RA_ROUTER) == RTF_RA_ROUTER) &&
-	    rt->fib6_nh.fib_nh_gw_family &&
-	    ipv6_addr_equal(gateway, &rt->fib6_nh.fib_nh_gw6)) {
+	    nh->fib_nh_gw_family && ipv6_addr_equal(gateway, &nh->fib_nh_gw6))
 		return -1;
-	}
 
 	/* Further clean up cached routes in exception table.
 	 * This is needed because cached route may have a different
 	 * gateway than its 'parent' in the case of an ip redirect.
 	 */
-	rt6_exceptions_clean_tohost(rt, gateway);
+	fib6_nh_exceptions_clean_tohost(nh, gateway);
 
 	return 0;
 }
@@ -4225,10 +4286,10 @@ struct rt6_mtu_change_arg {
 	struct fib6_info *f6i;
 };
 
-static int fib6_nh_mtu_change(struct fib6_info *f6i, void *_arg)
+static int fib6_nh_mtu_change(struct fib6_nh *nh, void *_arg)
 {
 	struct rt6_mtu_change_arg *arg = (struct rt6_mtu_change_arg *)_arg;
-	struct fib6_nh *nh = &f6i->fib6_nh;
+	struct fib6_info *f6i = arg->f6i;
 
 	/* For administrative MTU increase, there is no way to discover
 	 * IPv6 PMTU increase, so PMTU increase should be updated here.
@@ -4244,7 +4305,7 @@ static int fib6_nh_mtu_change(struct fib6_info *f6i, void *_arg)
 			fib6_metric_set(f6i, RTAX_MTU, arg->mtu);
 
 		spin_lock_bh(&rt6_exception_lock);
-		rt6_exceptions_update_pmtu(idev, f6i, arg->mtu);
+		rt6_exceptions_update_pmtu(idev, nh, arg->mtu);
 		spin_unlock_bh(&rt6_exception_lock);
 	}
 
@@ -4270,7 +4331,7 @@ static int rt6_mtu_change_route(struct fib6_info *f6i, void *p_arg)
 		return 0;
 
 	arg->f6i = f6i;
-	return fib6_nh_mtu_change(f6i, arg);
+	return fib6_nh_mtu_change(&f6i->fib6_nh, arg);
 }
 
 void rt6_mtu_change(struct net_device *dev, unsigned int mtu)
-- 
2.11.0

