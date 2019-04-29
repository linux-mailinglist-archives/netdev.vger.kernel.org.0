Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8642DE76B
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbfD2QPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728677AbfD2QPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 12:15:18 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00BC42087B;
        Mon, 29 Apr 2019 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556554517;
        bh=eHehctyL9QhIbEtVxUxRl1ROqphylp76EVRg7zovaXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTPAMLWiGatYlJYfYKFtJWv2D9LN+Ng558kjgSY4R0gxMY48sV8UTxQHnnaMVRz79
         KhK09YB0fqBamLwRKn9rfkom70K3DnBbD+c/kWTBdby2mFwsZweZQzmcp6oOOGY5QA
         66fgi94zXNz+3JRAaIn4tTQPBtoWSGapGXzAKqr0=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 net-next 1/3] ipv4: Move cached routes to fib_nh_common
Date:   Mon, 29 Apr 2019 09:16:17 -0700
Message-Id: <20190429161619.23671-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190429161619.23671-1-dsahern@kernel.org>
References: <20190429161619.23671-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

While the cached routes, nh_pcpu_rth_output and nh_rth_input, are IPv4
specific, a later patch wants to make them accessible for IPv6 nexthops
with IPv4 routes using a fib6_nh. Move the cached routes from fib_nh to
fib_nh_common and update references.

Initialization of the cached entries is moved to fib_nh_common_init,
and free is moved to fib_nh_common_release.

Change in location only, from fib_nh up to fib_nh_common; no functional
change intended:

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip_fib.h     |  6 ++++--
 net/ipv4/fib_semantics.c | 33 +++++++++++++++++----------------
 net/ipv4/route.c         | 18 +++++++++---------
 3 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 772a9e61bd84..659c5081c40b 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -96,6 +96,10 @@ struct fib_nh_common {
 
 	int			nhc_weight;
 	atomic_t		nhc_upper_bound;
+
+	/* v4 specific, but allows fib6_nh with v4 routes */
+	struct rtable __rcu * __percpu *nhc_pcpu_rth_output;
+	struct rtable __rcu     *nhc_rth_input;
 };
 
 struct fib_nh {
@@ -107,8 +111,6 @@ struct fib_nh {
 #endif
 	__be32			nh_saddr;
 	int			nh_saddr_genid;
-	struct rtable __rcu * __percpu *nh_pcpu_rth_output;
-	struct rtable __rcu	*nh_rth_input;
 	struct fnhe_hash_bucket	__rcu *nh_exceptions;
 #define fib_nh_family		nh_common.nhc_family
 #define fib_nh_dev		nh_common.nhc_dev
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 71c2165a2ce3..2046ec0d6bad 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -212,6 +212,8 @@ void fib_nh_common_release(struct fib_nh_common *nhc)
 		dev_put(nhc->nhc_dev);
 
 	lwtstate_put(nhc->nhc_lwtstate);
+	rt_fibinfo_free_cpus(nhc->nhc_pcpu_rth_output);
+	rt_fibinfo_free(&nhc->nhc_rth_input);
 }
 EXPORT_SYMBOL_GPL(fib_nh_common_release);
 
@@ -223,8 +225,6 @@ void fib_nh_release(struct net *net, struct fib_nh *fib_nh)
 #endif
 	fib_nh_common_release(&fib_nh->nh_common);
 	free_nh_exceptions(fib_nh);
-	rt_fibinfo_free_cpus(fib_nh->nh_pcpu_rth_output);
-	rt_fibinfo_free(&fib_nh->nh_rth_input);
 }
 
 /* Release a nexthop info record */
@@ -491,9 +491,15 @@ int fib_nh_common_init(struct fib_nh_common *nhc, struct nlattr *encap,
 		       u16 encap_type, void *cfg, gfp_t gfp_flags,
 		       struct netlink_ext_ack *extack)
 {
+	int err;
+
+	nhc->nhc_pcpu_rth_output = alloc_percpu_gfp(struct rtable __rcu *,
+						    gfp_flags);
+	if (!nhc->nhc_pcpu_rth_output)
+		return -ENOMEM;
+
 	if (encap) {
 		struct lwtunnel_state *lwtstate;
-		int err;
 
 		if (encap_type == LWTUNNEL_ENCAP_NONE) {
 			NL_SET_ERR_MSG(extack, "LWT encap type not specified");
@@ -502,12 +508,17 @@ int fib_nh_common_init(struct fib_nh_common *nhc, struct nlattr *encap,
 		err = lwtunnel_build_state(encap_type, encap, nhc->nhc_family,
 					   cfg, &lwtstate, extack);
 		if (err)
-			return err;
+			goto lwt_failure;
 
 		nhc->nhc_lwtstate = lwtstate_get(lwtstate);
 	}
 
 	return 0;
+
+lwt_failure:
+	rt_fibinfo_free_cpus(nhc->nhc_pcpu_rth_output);
+	nhc->nhc_pcpu_rth_output = NULL;
+	return err;
 }
 EXPORT_SYMBOL_GPL(fib_nh_common_init);
 
@@ -515,18 +526,14 @@ int fib_nh_init(struct net *net, struct fib_nh *nh,
 		struct fib_config *cfg, int nh_weight,
 		struct netlink_ext_ack *extack)
 {
-	int err = -ENOMEM;
+	int err;
 
 	nh->fib_nh_family = AF_INET;
 
-	nh->nh_pcpu_rth_output = alloc_percpu(struct rtable __rcu *);
-	if (!nh->nh_pcpu_rth_output)
-		goto err_out;
-
 	err = fib_nh_common_init(&nh->nh_common, cfg->fc_encap,
 				 cfg->fc_encap_type, cfg, GFP_KERNEL, extack);
 	if (err)
-		goto init_failure;
+		return err;
 
 	nh->fib_nh_oif = cfg->fc_oif;
 	nh->fib_nh_gw_family = cfg->fc_gw_family;
@@ -546,12 +553,6 @@ int fib_nh_init(struct net *net, struct fib_nh *nh,
 	nh->fib_nh_weight = nh_weight;
 #endif
 	return 0;
-
-init_failure:
-	rt_fibinfo_free_cpus(nh->nh_pcpu_rth_output);
-	nh->nh_pcpu_rth_output = NULL;
-err_out:
-	return err;
 }
 
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 795aed6e4720..662ac9bd956e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -646,6 +646,7 @@ static void fill_route_from_fnhe(struct rtable *rt, struct fib_nh_exception *fnh
 static void update_or_create_fnhe(struct fib_nh *nh, __be32 daddr, __be32 gw,
 				  u32 pmtu, bool lock, unsigned long expires)
 {
+	struct fib_nh_common *nhc = &nh->nh_common;
 	struct fnhe_hash_bucket *hash;
 	struct fib_nh_exception *fnhe;
 	struct rtable *rt;
@@ -715,13 +716,13 @@ static void update_or_create_fnhe(struct fib_nh *nh, __be32 daddr, __be32 gw,
 		 * stale, so anyone caching it rechecks if this exception
 		 * applies to them.
 		 */
-		rt = rcu_dereference(nh->nh_rth_input);
+		rt = rcu_dereference(nhc->nhc_rth_input);
 		if (rt)
 			rt->dst.obsolete = DST_OBSOLETE_KILL;
 
 		for_each_possible_cpu(i) {
 			struct rtable __rcu **prt;
-			prt = per_cpu_ptr(nh->nh_pcpu_rth_output, i);
+			prt = per_cpu_ptr(nhc->nhc_pcpu_rth_output, i);
 			rt = rcu_dereference(*prt);
 			if (rt)
 				rt->dst.obsolete = DST_OBSOLETE_KILL;
@@ -1471,13 +1472,14 @@ static bool rt_bind_exception(struct rtable *rt, struct fib_nh_exception *fnhe,
 
 static bool rt_cache_route(struct fib_nh *nh, struct rtable *rt)
 {
+	struct fib_nh_common *nhc = &nh->nh_common;
 	struct rtable *orig, *prev, **p;
 	bool ret = true;
 
 	if (rt_is_input_route(rt)) {
-		p = (struct rtable **)&nh->nh_rth_input;
+		p = (struct rtable **)&nhc->nhc_rth_input;
 	} else {
-		p = (struct rtable **)raw_cpu_ptr(nh->nh_pcpu_rth_output);
+		p = (struct rtable **)raw_cpu_ptr(nhc->nhc_pcpu_rth_output);
 	}
 	orig = *p;
 
@@ -1810,7 +1812,7 @@ static int __mkroute_input(struct sk_buff *skb,
 		if (fnhe)
 			rth = rcu_dereference(fnhe->fnhe_rth_input);
 		else
-			rth = rcu_dereference(nh->nh_rth_input);
+			rth = rcu_dereference(nhc->nhc_rth_input);
 		if (rt_cache_valid(rth)) {
 			skb_dst_set_noref(skb, &rth->dst);
 			goto out;
@@ -2105,10 +2107,8 @@ out:	return err;
 	if (res->fi) {
 		if (!itag) {
 			struct fib_nh_common *nhc = FIB_RES_NHC(*res);
-			struct fib_nh *nh;
 
-			nh = container_of(nhc, struct fib_nh, nh_common);
-			rth = rcu_dereference(nh->nh_rth_input);
+			rth = rcu_dereference(nhc->nhc_rth_input);
 			if (rt_cache_valid(rth)) {
 				skb_dst_set_noref(skb, &rth->dst);
 				err = 0;
@@ -2337,7 +2337,7 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 				do_cache = false;
 				goto add;
 			}
-			prth = raw_cpu_ptr(nh->nh_pcpu_rth_output);
+			prth = raw_cpu_ptr(nhc->nhc_pcpu_rth_output);
 		}
 		rth = rcu_dereference(*prth);
 		if (rt_cache_valid(rth) && dst_hold_safe(&rth->dst))
-- 
2.11.0

