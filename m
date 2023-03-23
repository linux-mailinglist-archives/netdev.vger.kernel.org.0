Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC586C71F4
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjCWUzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjCWUzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:55:36 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C3C22018;
        Thu, 23 Mar 2023 13:55:34 -0700 (PDT)
Message-ID: <20230323102800.215027837@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1679604933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=zemSn9bwMuohAbZIJdZqdqifWHmv1X857M8xMLEwTMk=;
        b=bU8on7hNzZNid/j31YZIKpZYzS/UzQOUW612ucQTcm/QAfMfGSmeXHVSV1ZzoXS/kP1Nn+
        IGOU+VQfJtRmvzngJLL9J9/TS0ZogndMFY0t3MvXa2EQxrX8dqK/9vBjCa4HbNBdgg85dN
        EnWJ9Ol2cTVVimt9SmCCqHhc/jTgD0YPj19zBNtqfnl75S9Dz3u/hWwTuVtE+DRIdNQxO8
        5xdYK1Thm6eNZ4vWG9L2AqBSm/P4bOrbF2O7FIoPlNpZDy2N942sMV/egrfN/9aN/frt/c
        gK4rgdApKiKUNuFbAMD/cMWlimRJfEPKL4tVqDVNYVCkHs+n0bWCCgirnP5bpQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1679604933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=zemSn9bwMuohAbZIJdZqdqifWHmv1X857M8xMLEwTMk=;
        b=6aWbqEmg5KPHPKXvit+0OB62ebkKDg8DRby2KaNiUEBJJLn5GSCiSv4Hx2bwZwh6QgFDs4
        Jg8zCT9QcsOp6hCA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>
Subject: [patch V3 4/4] net: dst: Switch to rcuref_t reference counting
References: <20230323102649.764958589@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 23 Mar 2023 21:55:32 +0100 (CET)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Under high contention dst_entry::__refcnt becomes a significant bottleneck.

atomic_inc_not_zero() is implemented with a cmpxchg() loop, which goes into
high retry rates on contention.

Switch the reference count to rcuref_t which results in a significant
performance gain. Rename the reference count member to __rcuref to reflect
the change.

The gain depends on the micro-architecture and the number of concurrent
operations and has been measured in the range of +25% to +130% with a
localhost memtier/memcached benchmark which amplifies the problem
massively.

Running the memtier/memcached benchmark over a real (1Gb) network
connection the conversion on top of the false sharing fix for struct
dst_entry::__refcnt results in a total gain in the 2%-5% range over the
upstream baseline.

Reported-by: Wangyang Guo <wangyang.guo@intel.com>
Reported-by: Arjan Van De Ven <arjan.van.de.ven@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20230307125538.989175656@linutronix.de
---
V3: Rename the refcount member to __rcuref (Linus)
---
 include/net/dst.h               |   19 ++++++++++---------
 include/net/sock.h              |    2 +-
 net/bridge/br_nf_core.c         |    2 +-
 net/core/dst.c                  |   26 +++++---------------------
 net/core/rtnetlink.c            |    2 +-
 net/ipv6/route.c                |    6 +++---
 net/netfilter/ipvs/ip_vs_xmit.c |    4 ++--
 7 files changed, 23 insertions(+), 38 deletions(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -16,6 +16,7 @@
 #include <linux/bug.h>
 #include <linux/jiffies.h>
 #include <linux/refcount.h>
+#include <linux/rcuref.h>
 #include <net/neighbour.h>
 #include <asm/processor.h>
 #include <linux/indirect_call_wrapper.h>
@@ -61,11 +62,11 @@ struct dst_entry {
 	unsigned short		trailer_len;	/* space to reserve at tail */
 
 	/*
-	 * __refcnt wants to be on a different cache line from
+	 * __rcuref wants to be on a different cache line from
 	 * input/output/ops or performance tanks badly
 	 */
 #ifdef CONFIG_64BIT
-	atomic_t		__refcnt;	/* 64-bit offset 64 */
+	rcuref_t		__rcuref;	/* 64-bit offset 64 */
 #endif
 	int			__use;
 	unsigned long		lastuse;
@@ -75,16 +76,16 @@ struct dst_entry {
 	__u32			tclassid;
 #ifndef CONFIG_64BIT
 	struct lwtunnel_state   *lwtstate;
-	atomic_t		__refcnt;	/* 32-bit offset 64 */
+	rcuref_t		__rcuref;	/* 32-bit offset 64 */
 #endif
 	netdevice_tracker	dev_tracker;
 
 	/*
 	 * Used by rtable and rt6_info. Moves lwtstate into the next cache
 	 * line on 64bit so that lwtstate does not cause false sharing with
-	 * __refcnt under contention of __refcnt. This also puts the
+	 * __rcuref under contention of __rcuref. This also puts the
 	 * frequently accessed members of rtable and rt6_info out of the
-	 * __refcnt cache line.
+	 * __rcuref cache line.
 	 */
 	struct list_head	rt_uncached;
 	struct uncached_list	*rt_uncached_list;
@@ -238,10 +239,10 @@ static inline void dst_hold(struct dst_e
 {
 	/*
 	 * If your kernel compilation stops here, please check
-	 * the placement of __refcnt in struct dst_entry
+	 * the placement of __rcuref in struct dst_entry
 	 */
-	BUILD_BUG_ON(offsetof(struct dst_entry, __refcnt) & 63);
-	WARN_ON(atomic_inc_not_zero(&dst->__refcnt) == 0);
+	BUILD_BUG_ON(offsetof(struct dst_entry, __rcuref) & 63);
+	WARN_ON(!rcuref_get(&dst->__rcuref));
 }
 
 static inline void dst_use_noref(struct dst_entry *dst, unsigned long time)
@@ -305,7 +306,7 @@ static inline void skb_dst_copy(struct s
  */
 static inline bool dst_hold_safe(struct dst_entry *dst)
 {
-	return atomic_inc_not_zero(&dst->__refcnt);
+	return rcuref_get(&dst->__rcuref);
 }
 
 /**
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2131,7 +2131,7 @@ sk_dst_get(struct sock *sk)
 
 	rcu_read_lock();
 	dst = rcu_dereference(sk->sk_dst_cache);
-	if (dst && !atomic_inc_not_zero(&dst->__refcnt))
+	if (dst && !rcuref_get(&dst->__rcuref))
 		dst = NULL;
 	rcu_read_unlock();
 	return dst;
--- a/net/bridge/br_nf_core.c
+++ b/net/bridge/br_nf_core.c
@@ -73,7 +73,7 @@ void br_netfilter_rtable_init(struct net
 {
 	struct rtable *rt = &br->fake_rtable;
 
-	atomic_set(&rt->dst.__refcnt, 1);
+	rcuref_init(&rt->dst.__rcuref, 1);
 	rt->dst.dev = br->dev;
 	dst_init_metrics(&rt->dst, br_dst_default_metrics, true);
 	rt->dst.flags	= DST_NOXFRM | DST_FAKE_RTABLE;
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -66,7 +66,7 @@ void dst_init(struct dst_entry *dst, str
 	dst->tclassid = 0;
 #endif
 	dst->lwtstate = NULL;
-	atomic_set(&dst->__refcnt, initial_ref);
+	rcuref_init(&dst->__rcuref, initial_ref);
 	dst->__use = 0;
 	dst->lastuse = jiffies;
 	dst->flags = flags;
@@ -162,31 +162,15 @@ EXPORT_SYMBOL(dst_dev_put);
 
 void dst_release(struct dst_entry *dst)
 {
-	if (dst) {
-		int newrefcnt;
-
-		newrefcnt = atomic_dec_return(&dst->__refcnt);
-		if (WARN_ONCE(newrefcnt < 0, "dst_release underflow"))
-			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
-					     __func__, dst, newrefcnt);
-		if (!newrefcnt)
-			call_rcu_hurry(&dst->rcu_head, dst_destroy_rcu);
-	}
+	if (dst && rcuref_put(&dst->__rcuref))
+		call_rcu_hurry(&dst->rcu_head, dst_destroy_rcu);
 }
 EXPORT_SYMBOL(dst_release);
 
 void dst_release_immediate(struct dst_entry *dst)
 {
-	if (dst) {
-		int newrefcnt;
-
-		newrefcnt = atomic_dec_return(&dst->__refcnt);
-		if (WARN_ONCE(newrefcnt < 0, "dst_release_immediate underflow"))
-			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
-					     __func__, dst, newrefcnt);
-		if (!newrefcnt)
-			dst_destroy(dst);
-	}
+	if (dst && rcuref_put(&dst->__rcuref))
+		dst_destroy(dst);
 }
 EXPORT_SYMBOL(dst_release_immediate);
 
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -840,7 +840,7 @@ int rtnl_put_cacheinfo(struct sk_buff *s
 	if (dst) {
 		ci.rta_lastuse = jiffies_delta_to_clock_t(jiffies - dst->lastuse);
 		ci.rta_used = dst->__use;
-		ci.rta_clntref = atomic_read(&dst->__refcnt);
+		ci.rta_clntref = rcuref_read(&dst->__rcuref);
 	}
 	if (expires) {
 		unsigned long clock;
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -293,7 +293,7 @@ static const struct fib6_info fib6_null_
 
 static const struct rt6_info ip6_null_entry_template = {
 	.dst = {
-		.__refcnt	= ATOMIC_INIT(1),
+		.__rcuref	= RCUREF_INIT(1),
 		.__use		= 1,
 		.obsolete	= DST_OBSOLETE_FORCE_CHK,
 		.error		= -ENETUNREACH,
@@ -307,7 +307,7 @@ static const struct rt6_info ip6_null_en
 
 static const struct rt6_info ip6_prohibit_entry_template = {
 	.dst = {
-		.__refcnt	= ATOMIC_INIT(1),
+		.__rcuref	= RCUREF_INIT(1),
 		.__use		= 1,
 		.obsolete	= DST_OBSOLETE_FORCE_CHK,
 		.error		= -EACCES,
@@ -319,7 +319,7 @@ static const struct rt6_info ip6_prohibi
 
 static const struct rt6_info ip6_blk_hole_entry_template = {
 	.dst = {
-		.__refcnt	= ATOMIC_INIT(1),
+		.__rcuref	= RCUREF_INIT(1),
 		.__use		= 1,
 		.obsolete	= DST_OBSOLETE_FORCE_CHK,
 		.error		= -EINVAL,
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -339,7 +339,7 @@ static int
 			spin_unlock_bh(&dest->dst_lock);
 			IP_VS_DBG(10, "new dst %pI4, src %pI4, refcnt=%d\n",
 				  &dest->addr.ip, &dest_dst->dst_saddr.ip,
-				  atomic_read(&rt->dst.__refcnt));
+				  rcuref_read(&rt->dst.__rcuref));
 		}
 		if (ret_saddr)
 			*ret_saddr = dest_dst->dst_saddr.ip;
@@ -507,7 +507,7 @@ static int
 			spin_unlock_bh(&dest->dst_lock);
 			IP_VS_DBG(10, "new dst %pI6, src %pI6, refcnt=%d\n",
 				  &dest->addr.in6, &dest_dst->dst_saddr.in6,
-				  atomic_read(&rt->dst.__refcnt));
+				  rcuref_read(&rt->dst.__rcuref));
 		}
 		if (ret_saddr)
 			*ret_saddr = dest_dst->dst_saddr.in6;

