Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD55274CA
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 05:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbfEWD2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 23:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbfEWD2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 23:28:04 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37ED421019;
        Thu, 23 May 2019 03:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558582083;
        bh=VNdZ6tORtPPFSpYCNbTK0qTRaThwzd1DPiqHnBmMoqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ad13DOOX+TiLJKJSkT8YlYNDWPh+PJmYBga8VOm4Hzr/ECWqHFle9y2TMUh+CsYl5
         XCu/hcHssx2Fw6zgYO1QBUHvwmzaNoTpArtl8C2oN8Figcu0Z/vpXw6TjQBK7POJzO
         aBTZ7BScIwCyo1dyOPb80v7kt+67pkGe8227z3qQ=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, idosch@mellanox.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 1/7] ipv6: Move pcpu cached routes to fib6_nh
Date:   Wed, 22 May 2019 20:27:55 -0700
Message-Id: <20190523032801.11122-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523032801.11122-1-dsahern@kernel.org>
References: <20190523032801.11122-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

rt6_info are specific instances of a fib entry and are tied to a
device and gateway - ie., a nexthop. Before nexthop objects, IPv6 fib
entries have separate fib6_info for each nexthop in a multipath route,
so the location of the pcpu cache in the fib6_info struct worked.
However, with nexthop objects a fib6_info can point to a set of nexthops
(yet another alignment of ipv6 with ipv4). Accordingly, the pcpu
cache needs to be moved to the fib6_nh struct so the cached entries
are local to the nexthop specification used to create the rt6_info.

Initialization and free of the pcpu entries moved to fib6_nh_init and
fib6_nh_release.

Change in location only, from fib6_info down to fib6_nh; no other
functional change intended.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip6_fib.h |  3 ++-
 net/ipv6/addrconf.c   |  6 +++---
 net/ipv6/ip6_fib.c    | 34 ++++++----------------------------
 net/ipv6/route.c      | 29 +++++++++++++++++++++++++++--
 4 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 0d0d06b1cd26..38e87ef81b7e 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -131,6 +131,8 @@ struct fib6_nh {
 #ifdef CONFIG_IPV6_ROUTER_PREF
 	unsigned long		last_probe;
 #endif
+
+	struct rt6_info * __percpu *rt6i_pcpu;
 };
 
 struct fib6_info {
@@ -156,7 +158,6 @@ struct fib6_info {
 	struct rt6key			fib6_src;
 	struct rt6key			fib6_prefsrc;
 
-	struct rt6_info * __percpu	*rt6i_pcpu;
 	struct rt6_exception_bucket __rcu *rt6i_exception_bucket;
 
 	u32				fib6_metric;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f96d1de79509..4bc35dd02b56 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6341,16 +6341,16 @@ void addrconf_disable_policy_idev(struct inet6_dev *idev, int val)
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
 		spin_lock(&ifa->lock);
 		if (ifa->rt) {
-			struct fib6_info *rt = ifa->rt;
+			struct fib6_nh *nh = &ifa->rt->fib6_nh;
 			int cpu;
 
 			rcu_read_lock();
 			ifa->rt->dst_nopolicy = val ? true : false;
-			if (rt->rt6i_pcpu) {
+			if (nh->rt6i_pcpu) {
 				for_each_possible_cpu(cpu) {
 					struct rt6_info **rtp;
 
-					rtp = per_cpu_ptr(rt->rt6i_pcpu, cpu);
+					rtp = per_cpu_ptr(nh->rt6i_pcpu, cpu);
 					addrconf_set_nopolicy(*rtp, val);
 				}
 			}
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 7958cf91895a..274f1243866f 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -155,12 +155,6 @@ struct fib6_info *fib6_info_alloc(gfp_t gfp_flags)
 	if (!f6i)
 		return NULL;
 
-	f6i->rt6i_pcpu = alloc_percpu_gfp(struct rt6_info *, gfp_flags);
-	if (!f6i->rt6i_pcpu) {
-		kfree(f6i);
-		return NULL;
-	}
-
 	INIT_LIST_HEAD(&f6i->fib6_siblings);
 	refcount_set(&f6i->fib6_ref, 1);
 
@@ -177,25 +171,6 @@ void fib6_info_destroy_rcu(struct rcu_head *head)
 	bucket = rcu_dereference_protected(f6i->rt6i_exception_bucket, 1);
 	kfree(bucket);
 
-	if (f6i->rt6i_pcpu) {
-		int cpu;
-
-		for_each_possible_cpu(cpu) {
-			struct rt6_info **ppcpu_rt;
-			struct rt6_info *pcpu_rt;
-
-			ppcpu_rt = per_cpu_ptr(f6i->rt6i_pcpu, cpu);
-			pcpu_rt = *ppcpu_rt;
-			if (pcpu_rt) {
-				dst_dev_put(&pcpu_rt->dst);
-				dst_release(&pcpu_rt->dst);
-				*ppcpu_rt = NULL;
-			}
-		}
-
-		free_percpu(f6i->rt6i_pcpu);
-	}
-
 	fib6_nh_release(&f6i->fib6_nh);
 
 	ip_fib_metrics_put(f6i->fib6_metrics);
@@ -902,8 +877,12 @@ static struct fib6_node *fib6_add_1(struct net *net,
 static void fib6_drop_pcpu_from(struct fib6_info *f6i,
 				const struct fib6_table *table)
 {
+	struct fib6_nh *fib6_nh = &f6i->fib6_nh;
 	int cpu;
 
+	if (!fib6_nh->rt6i_pcpu)
+		return;
+
 	/* Make sure rt6_make_pcpu_route() wont add other percpu routes
 	 * while we are cleaning them here.
 	 */
@@ -917,7 +896,7 @@ static void fib6_drop_pcpu_from(struct fib6_info *f6i,
 		struct rt6_info **ppcpu_rt;
 		struct rt6_info *pcpu_rt;
 
-		ppcpu_rt = per_cpu_ptr(f6i->rt6i_pcpu, cpu);
+		ppcpu_rt = per_cpu_ptr(fib6_nh->rt6i_pcpu, cpu);
 		pcpu_rt = *ppcpu_rt;
 		if (pcpu_rt) {
 			struct fib6_info *from;
@@ -933,8 +912,7 @@ static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
 {
 	struct fib6_table *table = rt->fib6_table;
 
-	if (rt->rt6i_pcpu)
-		fib6_drop_pcpu_from(rt, table);
+	fib6_drop_pcpu_from(rt, table);
 
 	if (refcount_read(&rt->fib6_ref) != 1) {
 		/* This route is used as dummy address holder in some split
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 5f0661c18624..e404813c9844 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1270,7 +1270,7 @@ static struct rt6_info *rt6_get_pcpu_route(const struct fib6_result *res)
 {
 	struct rt6_info *pcpu_rt, **p;
 
-	p = this_cpu_ptr(res->f6i->rt6i_pcpu);
+	p = this_cpu_ptr(res->nh->rt6i_pcpu);
 	pcpu_rt = *p;
 
 	if (pcpu_rt)
@@ -1291,7 +1291,7 @@ static struct rt6_info *rt6_make_pcpu_route(struct net *net,
 	}
 
 	dst_hold(&pcpu_rt->dst);
-	p = this_cpu_ptr(res->f6i->rt6i_pcpu);
+	p = this_cpu_ptr(res->nh->rt6i_pcpu);
 	prev = cmpxchg(p, NULL, pcpu_rt);
 	BUG_ON(prev);
 
@@ -3068,6 +3068,12 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	    !netif_carrier_ok(dev))
 		fib6_nh->fib_nh_flags |= RTNH_F_LINKDOWN;
 
+	fib6_nh->rt6i_pcpu = alloc_percpu_gfp(struct rt6_info *, gfp_flags);
+	if (!fib6_nh->rt6i_pcpu) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	err = fib_nh_common_init(&fib6_nh->nh_common, cfg->fc_encap,
 				 cfg->fc_encap_type, cfg, gfp_flags, extack);
 	if (err)
@@ -3092,6 +3098,25 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 
 void fib6_nh_release(struct fib6_nh *fib6_nh)
 {
+	if (fib6_nh->rt6i_pcpu) {
+		int cpu;
+
+		for_each_possible_cpu(cpu) {
+			struct rt6_info **ppcpu_rt;
+			struct rt6_info *pcpu_rt;
+
+			ppcpu_rt = per_cpu_ptr(fib6_nh->rt6i_pcpu, cpu);
+			pcpu_rt = *ppcpu_rt;
+			if (pcpu_rt) {
+				dst_dev_put(&pcpu_rt->dst);
+				dst_release(&pcpu_rt->dst);
+				*ppcpu_rt = NULL;
+			}
+		}
+
+		free_percpu(fib6_nh->rt6i_pcpu);
+	}
+
 	fib_nh_common_release(&fib6_nh->nh_common);
 }
 
-- 
2.11.0

