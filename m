Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8088FBCB
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 16:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfD3Oov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 10:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfD3Ooq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 10:44:46 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 294E42173E;
        Tue, 30 Apr 2019 14:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556635485;
        bh=Przz0TCb3oTFwDq3tqz3WkypOndxzVyUGbuLohYRxwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSUUoXoEB9U+LPzPIaZ8jtbdxbRbNw4+Azt/qGaiI0RxGGoo9C3z29ofUq6eEcnA6
         rsM6YSaxXxAsSLEk4HIU9USk/d3uZwY/sOfHcH9KT80Eygfr3PCdLatK7X83SVcVxr
         O/hIAcEz9vrJL/CE95KGR4e7I1dSf8mJh9HtMtk0=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 3/3] ipv4: Move exception bucket to nh_common
Date:   Tue, 30 Apr 2019 07:45:50 -0700
Message-Id: <20190430144550.15033-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190430144550.15033-1-dsahern@kernel.org>
References: <20190430144550.15033-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Similar to the cached routes, make IPv4 exceptions accessible when
using an IPv6 nexthop struct with IPv4 routes. Simplify the exception
functions by passing in fib_nh_common since that is all it needs,
and then cleanup the call sites that have extraneous fib_nh conversions.

As with the cached routes this is a change in location only, from fib_nh
up to fib_nh_common; no functional change intended.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/ip_fib.h     |  2 +-
 net/ipv4/fib_semantics.c | 12 ++++++------
 net/ipv4/route.c         | 41 +++++++++++++++++------------------------
 3 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 659c5081c40b..d0e28f4ab099 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -100,6 +100,7 @@ struct fib_nh_common {
 	/* v4 specific, but allows fib6_nh with v4 routes */
 	struct rtable __rcu * __percpu *nhc_pcpu_rth_output;
 	struct rtable __rcu     *nhc_rth_input;
+	struct fnhe_hash_bucket	__rcu *nhc_exceptions;
 };
 
 struct fib_nh {
@@ -111,7 +112,6 @@ struct fib_nh {
 #endif
 	__be32			nh_saddr;
 	int			nh_saddr_genid;
-	struct fnhe_hash_bucket	__rcu *nh_exceptions;
 #define fib_nh_family		nh_common.nhc_family
 #define fib_nh_dev		nh_common.nhc_dev
 #define fib_nh_oif		nh_common.nhc_oif
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 4402ec6dc426..d3da6a10f86f 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -159,12 +159,12 @@ static void rt_fibinfo_free(struct rtable __rcu **rtp)
 	dst_release_immediate(&rt->dst);
 }
 
-static void free_nh_exceptions(struct fib_nh *nh)
+static void free_nh_exceptions(struct fib_nh_common *nhc)
 {
 	struct fnhe_hash_bucket *hash;
 	int i;
 
-	hash = rcu_dereference_protected(nh->nh_exceptions, 1);
+	hash = rcu_dereference_protected(nhc->nhc_exceptions, 1);
 	if (!hash)
 		return;
 	for (i = 0; i < FNHE_HASH_SIZE; i++) {
@@ -214,6 +214,7 @@ void fib_nh_common_release(struct fib_nh_common *nhc)
 	lwtstate_put(nhc->nhc_lwtstate);
 	rt_fibinfo_free_cpus(nhc->nhc_pcpu_rth_output);
 	rt_fibinfo_free(&nhc->nhc_rth_input);
+	free_nh_exceptions(nhc);
 }
 EXPORT_SYMBOL_GPL(fib_nh_common_release);
 
@@ -224,7 +225,6 @@ void fib_nh_release(struct net *net, struct fib_nh *fib_nh)
 		net->ipv4.fib_num_tclassid_users--;
 #endif
 	fib_nh_common_release(&fib_nh->nh_common);
-	free_nh_exceptions(fib_nh);
 }
 
 /* Release a nexthop info record */
@@ -1713,12 +1713,12 @@ static int call_fib_nh_notifiers(struct fib_nh *nh,
  * - if the new MTU is greater than the PMTU, don't make any change
  * - otherwise, unlock and set PMTU
  */
-static void nh_update_mtu(struct fib_nh *nh, u32 new, u32 orig)
+static void nh_update_mtu(struct fib_nh_common *nhc, u32 new, u32 orig)
 {
 	struct fnhe_hash_bucket *bucket;
 	int i;
 
-	bucket = rcu_dereference_protected(nh->nh_exceptions, 1);
+	bucket = rcu_dereference_protected(nhc->nhc_exceptions, 1);
 	if (!bucket)
 		return;
 
@@ -1749,7 +1749,7 @@ void fib_sync_mtu(struct net_device *dev, u32 orig_mtu)
 
 	hlist_for_each_entry(nh, head, nh_hash) {
 		if (nh->fib_nh_dev == dev)
-			nh_update_mtu(nh, dev->mtu, orig_mtu);
+			nh_update_mtu(&nh->nh_common, dev->mtu, orig_mtu);
 	}
 }
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 9b50d0440940..11ddc276776e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -643,10 +643,10 @@ static void fill_route_from_fnhe(struct rtable *rt, struct fib_nh_exception *fnh
 	}
 }
 
-static void update_or_create_fnhe(struct fib_nh *nh, __be32 daddr, __be32 gw,
-				  u32 pmtu, bool lock, unsigned long expires)
+static void update_or_create_fnhe(struct fib_nh_common *nhc, __be32 daddr,
+				  __be32 gw, u32 pmtu, bool lock,
+				  unsigned long expires)
 {
-	struct fib_nh_common *nhc = &nh->nh_common;
 	struct fnhe_hash_bucket *hash;
 	struct fib_nh_exception *fnhe;
 	struct rtable *rt;
@@ -654,17 +654,17 @@ static void update_or_create_fnhe(struct fib_nh *nh, __be32 daddr, __be32 gw,
 	unsigned int i;
 	int depth;
 
-	genid = fnhe_genid(dev_net(nh->fib_nh_dev));
+	genid = fnhe_genid(dev_net(nhc->nhc_dev));
 	hval = fnhe_hashfun(daddr);
 
 	spin_lock_bh(&fnhe_lock);
 
-	hash = rcu_dereference(nh->nh_exceptions);
+	hash = rcu_dereference(nhc->nhc_exceptions);
 	if (!hash) {
 		hash = kcalloc(FNHE_HASH_SIZE, sizeof(*hash), GFP_ATOMIC);
 		if (!hash)
 			goto out_unlock;
-		rcu_assign_pointer(nh->nh_exceptions, hash);
+		rcu_assign_pointer(nhc->nhc_exceptions, hash);
 	}
 
 	hash += hval;
@@ -789,10 +789,8 @@ static void __ip_do_redirect(struct rtable *rt, struct sk_buff *skb, struct flow
 		} else {
 			if (fib_lookup(net, fl4, &res, 0) == 0) {
 				struct fib_nh_common *nhc = FIB_RES_NHC(res);
-				struct fib_nh *nh;
 
-				nh = container_of(nhc, struct fib_nh, nh_common);
-				update_or_create_fnhe(nh, fl4->daddr, new_gw,
+				update_or_create_fnhe(nhc, fl4->daddr, new_gw,
 						0, false,
 						jiffies + ip_rt_gc_timeout);
 			}
@@ -1040,10 +1038,8 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 	rcu_read_lock();
 	if (fib_lookup(dev_net(dst->dev), fl4, &res, 0) == 0) {
 		struct fib_nh_common *nhc = FIB_RES_NHC(res);
-		struct fib_nh *nh;
 
-		nh = container_of(nhc, struct fib_nh, nh_common);
-		update_or_create_fnhe(nh, fl4->daddr, 0, mtu, lock,
+		update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
 				      jiffies + ip_rt_mtu_expires);
 	}
 	rcu_read_unlock();
@@ -1329,7 +1325,7 @@ static unsigned int ipv4_mtu(const struct dst_entry *dst)
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
-static void ip_del_fnhe(struct fib_nh *nh, __be32 daddr)
+static void ip_del_fnhe(struct fib_nh_common *nhc, __be32 daddr)
 {
 	struct fnhe_hash_bucket *hash;
 	struct fib_nh_exception *fnhe, __rcu **fnhe_p;
@@ -1337,7 +1333,7 @@ static void ip_del_fnhe(struct fib_nh *nh, __be32 daddr)
 
 	spin_lock_bh(&fnhe_lock);
 
-	hash = rcu_dereference_protected(nh->nh_exceptions,
+	hash = rcu_dereference_protected(nhc->nhc_exceptions,
 					 lockdep_is_held(&fnhe_lock));
 	hash += hval;
 
@@ -1363,9 +1359,10 @@ static void ip_del_fnhe(struct fib_nh *nh, __be32 daddr)
 	spin_unlock_bh(&fnhe_lock);
 }
 
-static struct fib_nh_exception *find_exception(struct fib_nh *nh, __be32 daddr)
+static struct fib_nh_exception *find_exception(struct fib_nh_common *nhc,
+					       __be32 daddr)
 {
-	struct fnhe_hash_bucket *hash = rcu_dereference(nh->nh_exceptions);
+	struct fnhe_hash_bucket *hash = rcu_dereference(nhc->nhc_exceptions);
 	struct fib_nh_exception *fnhe;
 	u32 hval;
 
@@ -1379,7 +1376,7 @@ static struct fib_nh_exception *find_exception(struct fib_nh *nh, __be32 daddr)
 		if (fnhe->fnhe_daddr == daddr) {
 			if (fnhe->fnhe_expires &&
 			    time_after(jiffies, fnhe->fnhe_expires)) {
-				ip_del_fnhe(nh, daddr);
+				ip_del_fnhe(nhc, daddr);
 				break;
 			}
 			return fnhe;
@@ -1406,10 +1403,9 @@ u32 ip_mtu_from_fib_result(struct fib_result *res, __be32 daddr)
 		mtu = fi->fib_mtu;
 
 	if (likely(!mtu)) {
-		struct fib_nh *nh = container_of(nhc, struct fib_nh, nh_common);
 		struct fib_nh_exception *fnhe;
 
-		fnhe = find_exception(nh, daddr);
+		fnhe = find_exception(nhc, daddr);
 		if (fnhe && !time_after_eq(jiffies, fnhe->fnhe_expires))
 			mtu = fnhe->fnhe_pmtu;
 	}
@@ -1760,7 +1756,6 @@ static int __mkroute_input(struct sk_buff *skb,
 	struct net_device *dev = nhc->nhc_dev;
 	struct fib_nh_exception *fnhe;
 	struct rtable *rth;
-	struct fib_nh *nh;
 	int err;
 	struct in_device *out_dev;
 	bool do_cache;
@@ -1808,8 +1803,7 @@ static int __mkroute_input(struct sk_buff *skb,
 		}
 	}
 
-	nh = container_of(nhc, struct fib_nh, nh_common);
-	fnhe = find_exception(nh, daddr);
+	fnhe = find_exception(nhc, daddr);
 	if (do_cache) {
 		if (fnhe)
 			rth = rcu_dereference(fnhe->fnhe_rth_input);
@@ -2321,10 +2315,9 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 	do_cache &= fi != NULL;
 	if (fi) {
 		struct fib_nh_common *nhc = FIB_RES_NHC(*res);
-		struct fib_nh *nh = container_of(nhc, struct fib_nh, nh_common);
 		struct rtable __rcu **prth;
 
-		fnhe = find_exception(nh, fl4->daddr);
+		fnhe = find_exception(nhc, fl4->daddr);
 		if (!do_cache)
 			goto add;
 		if (fnhe) {
-- 
2.11.0

