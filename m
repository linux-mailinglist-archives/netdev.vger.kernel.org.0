Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A835274CF
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 05:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbfEWD2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 23:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729057AbfEWD2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 23:28:05 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6F1A217D4;
        Thu, 23 May 2019 03:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558582083;
        bh=SgI1deST/7klAwWIBIRUbK6pdxElIy9eBMlTt2RSaXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G78Mll9tLj9OYsTcWo1UQG4E9dfRjF4c2muxsm+3/8RQgUA5eiHKfJYFU8ywK4NDt
         qCaafHe0cxkfYnv+Jbn6I/jiOUpBgOcN5uKYDbsHipXzLZ+ifc9kFCEhQbaqvNhdKV
         DEsnt91VP0is57qHvqiaUulddanw1LaMI47Dcy9E=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, idosch@mellanox.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 3/7] ipv6: Refactor exception functions
Date:   Wed, 22 May 2019 20:27:57 -0700
Message-Id: <20190523032801.11122-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523032801.11122-1-dsahern@kernel.org>
References: <20190523032801.11122-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Before moving exception bucket from fib6_info to fib6_nh, refactor
rt6_flush_exceptions, rt6_remove_exception_rt, rt6_mtu_change_route,
and rt6_update_exception_stamp_rt. In all 3 cases, move the primary
logic into a new helper that starts with fib6_nh_. The latter 3
functions still take a fib6_info; this will be changed to fib6_nh
in the next patch.

In the case of rt6_mtu_change_route, move the fib6_metric_locked
out as a standalone check - no need to call the new function if
the fib entry has the mtu locked. Also, add fib6_info to
rt6_mtu_change_arg as a way of passing the fib entry to the new
helper.

No functional change intended. The goal here is to make the next
patch easier to review by moving existing lookup logic for each to
new helpers.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 134 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 86 insertions(+), 48 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e404813c9844..8bfaa7349e10 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1542,7 +1542,7 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	return err;
 }
 
-void rt6_flush_exceptions(struct fib6_info *rt)
+static void fib6_nh_flush_exceptions(struct fib6_nh *nh, struct fib6_info *from)
 {
 	struct rt6_exception_bucket *bucket;
 	struct rt6_exception *rt6_ex;
@@ -1551,9 +1551,9 @@ void rt6_flush_exceptions(struct fib6_info *rt)
 
 	spin_lock_bh(&rt6_exception_lock);
 	/* Prevent rt6_insert_exception() to recreate the bucket list */
-	rt->exception_bucket_flushed = 1;
+	from->exception_bucket_flushed = 1;
 
-	bucket = rcu_dereference_protected(rt->rt6i_exception_bucket,
+	bucket = rcu_dereference_protected(from->rt6i_exception_bucket,
 				    lockdep_is_held(&rt6_exception_lock));
 	if (!bucket)
 		goto out;
@@ -1569,6 +1569,11 @@ void rt6_flush_exceptions(struct fib6_info *rt)
 	spin_unlock_bh(&rt6_exception_lock);
 }
 
+void rt6_flush_exceptions(struct fib6_info *f6i)
+{
+	fib6_nh_flush_exceptions(&f6i->fib6_nh, f6i);
+}
+
 /* Find cached rt in the hash table inside passed in rt
  * Caller has to hold rcu_read_lock()
  */
@@ -1615,19 +1620,14 @@ static struct rt6_info *rt6_find_cached_rt(const struct fib6_result *res,
 }
 
 /* Remove the passed in cached rt from the hash table that contains it */
-static int rt6_remove_exception_rt(struct rt6_info *rt)
+static int fib6_nh_remove_exception(const struct fib6_info *from, int plen,
+				    const struct rt6_info *rt)
 {
+	const struct in6_addr *src_key = NULL;
 	struct rt6_exception_bucket *bucket;
-	struct in6_addr *src_key = NULL;
 	struct rt6_exception *rt6_ex;
-	struct fib6_info *from;
 	int err;
 
-	from = rcu_dereference(rt->from);
-	if (!from ||
-	    !(rt->rt6i_flags & RTF_CACHE))
-		return -EINVAL;
-
 	if (!rcu_access_pointer(from->rt6i_exception_bucket))
 		return -ENOENT;
 
@@ -1635,13 +1635,12 @@ static int rt6_remove_exception_rt(struct rt6_info *rt)
 	bucket = rcu_dereference_protected(from->rt6i_exception_bucket,
 				    lockdep_is_held(&rt6_exception_lock));
 #ifdef CONFIG_IPV6_SUBTREES
-	/* rt6i_src.plen != 0 indicates 'from' is in subtree
-	 * and exception table is indexed by a hash of
-	 * both rt6i_dst and rt6i_src.
+	/* plen != 0 indicates 'from' is in subtree and exception
+	 * table is indexed by a hash of both rt6i_dst and rt6i_src.
 	 * Otherwise, the exception table is indexed by
 	 * a hash of only rt6i_dst.
 	 */
-	if (from->fib6_src.plen)
+	if (plen)
 		src_key = &rt->rt6i_src.addr;
 #endif
 	rt6_ex = __rt6_find_exception_spinlock(&bucket,
@@ -1658,31 +1657,37 @@ static int rt6_remove_exception_rt(struct rt6_info *rt)
 	return err;
 }
 
+static int rt6_remove_exception_rt(struct rt6_info *rt)
+{
+	struct fib6_info *from;
+
+	from = rcu_dereference(rt->from);
+	if (!from ||
+	    !(rt->rt6i_flags & RTF_CACHE))
+		return -EINVAL;
+
+	return fib6_nh_remove_exception(from, from->fib6_src.plen, rt);
+}
+
 /* Find rt6_ex which contains the passed in rt cache and
  * refresh its stamp
  */
-static void rt6_update_exception_stamp_rt(struct rt6_info *rt)
+static void fib6_nh_update_exception(const struct fib6_info *from, int plen,
+				     const struct rt6_info *rt)
 {
+	const struct in6_addr *src_key = NULL;
 	struct rt6_exception_bucket *bucket;
-	struct in6_addr *src_key = NULL;
 	struct rt6_exception *rt6_ex;
-	struct fib6_info *from;
-
-	rcu_read_lock();
-	from = rcu_dereference(rt->from);
-	if (!from || !(rt->rt6i_flags & RTF_CACHE))
-		goto unlock;
 
 	bucket = rcu_dereference(from->rt6i_exception_bucket);
 
 #ifdef CONFIG_IPV6_SUBTREES
-	/* rt6i_src.plen != 0 indicates 'from' is in subtree
-	 * and exception table is indexed by a hash of
-	 * both rt6i_dst and rt6i_src.
+	/* plen != 0 indicates 'from' is in subtree and exception
+	 * table is indexed by a hash of both rt6i_dst and rt6i_src.
 	 * Otherwise, the exception table is indexed by
 	 * a hash of only rt6i_dst.
 	 */
-	if (from->fib6_src.plen)
+	if (plen)
 		src_key = &rt->rt6i_src.addr;
 #endif
 	rt6_ex = __rt6_find_exception_rcu(&bucket,
@@ -1690,7 +1695,19 @@ static void rt6_update_exception_stamp_rt(struct rt6_info *rt)
 					  src_key);
 	if (rt6_ex)
 		rt6_ex->stamp = jiffies;
+}
+
+static void rt6_update_exception_stamp_rt(struct rt6_info *rt)
+{
+	struct fib6_info *from;
 
+	rcu_read_lock();
+
+	from = rcu_dereference(rt->from);
+	if (!from || !(rt->rt6i_flags & RTF_CACHE))
+		goto unlock;
+
+	fib6_nh_update_exception(from, from->fib6_src.plen, rt);
 unlock:
 	rcu_read_unlock();
 }
@@ -1827,9 +1844,9 @@ static void rt6_age_examine_exception(struct rt6_exception_bucket *bucket,
 	gc_args->more++;
 }
 
-void rt6_age_exceptions(struct fib6_info *rt,
-			struct fib6_gc_args *gc_args,
-			unsigned long now)
+static void fib6_nh_age_exceptions(struct fib6_info *rt,
+				   struct fib6_gc_args *gc_args,
+				   unsigned long now)
 {
 	struct rt6_exception_bucket *bucket;
 	struct rt6_exception *rt6_ex;
@@ -1858,6 +1875,13 @@ void rt6_age_exceptions(struct fib6_info *rt,
 	rcu_read_unlock_bh();
 }
 
+void rt6_age_exceptions(struct fib6_info *rt,
+			struct fib6_gc_args *gc_args,
+			unsigned long now)
+{
+	fib6_nh_age_exceptions(rt, gc_args, now);
+}
+
 /* must be called with rcu lock held */
 int fib6_table_lookup(struct net *net, struct fib6_table *table, int oif,
 		      struct flowi6 *fl6, struct fib6_result *res, int strict)
@@ -4198,9 +4222,36 @@ void rt6_disable_ip(struct net_device *dev, unsigned long event)
 struct rt6_mtu_change_arg {
 	struct net_device *dev;
 	unsigned int mtu;
+	struct fib6_info *f6i;
 };
 
-static int rt6_mtu_change_route(struct fib6_info *rt, void *p_arg)
+static int fib6_nh_mtu_change(struct fib6_info *f6i, void *_arg)
+{
+	struct rt6_mtu_change_arg *arg = (struct rt6_mtu_change_arg *)_arg;
+	struct fib6_nh *nh = &f6i->fib6_nh;
+
+	/* For administrative MTU increase, there is no way to discover
+	 * IPv6 PMTU increase, so PMTU increase should be updated here.
+	 * Since RFC 1981 doesn't include administrative MTU increase
+	 * update PMTU increase is a MUST. (i.e. jumbo frame)
+	 */
+	if (nh->fib_nh_dev == arg->dev) {
+		struct inet6_dev *idev = __in6_dev_get(arg->dev);
+		u32 mtu = f6i->fib6_pmtu;
+
+		if (mtu >= arg->mtu ||
+		    (mtu < arg->mtu && mtu == idev->cnf.mtu6))
+			fib6_metric_set(f6i, RTAX_MTU, arg->mtu);
+
+		spin_lock_bh(&rt6_exception_lock);
+		rt6_exceptions_update_pmtu(idev, f6i, arg->mtu);
+		spin_unlock_bh(&rt6_exception_lock);
+	}
+
+	return 0;
+}
+
+static int rt6_mtu_change_route(struct fib6_info *f6i, void *p_arg)
 {
 	struct rt6_mtu_change_arg *arg = (struct rt6_mtu_change_arg *) p_arg;
 	struct inet6_dev *idev;
@@ -4215,24 +4266,11 @@ static int rt6_mtu_change_route(struct fib6_info *rt, void *p_arg)
 	if (!idev)
 		return 0;
 
-	/* For administrative MTU increase, there is no way to discover
-	   IPv6 PMTU increase, so PMTU increase should be updated here.
-	   Since RFC 1981 doesn't include administrative MTU increase
-	   update PMTU increase is a MUST. (i.e. jumbo frame)
-	 */
-	if (rt->fib6_nh.fib_nh_dev == arg->dev &&
-	    !fib6_metric_locked(rt, RTAX_MTU)) {
-		u32 mtu = rt->fib6_pmtu;
-
-		if (mtu >= arg->mtu ||
-		    (mtu < arg->mtu && mtu == idev->cnf.mtu6))
-			fib6_metric_set(rt, RTAX_MTU, arg->mtu);
+	if (fib6_metric_locked(f6i, RTAX_MTU))
+		return 0;
 
-		spin_lock_bh(&rt6_exception_lock);
-		rt6_exceptions_update_pmtu(idev, rt, arg->mtu);
-		spin_unlock_bh(&rt6_exception_lock);
-	}
-	return 0;
+	arg->f6i = f6i;
+	return fib6_nh_mtu_change(f6i, arg);
 }
 
 void rt6_mtu_change(struct net_device *dev, unsigned int mtu)
-- 
2.11.0

