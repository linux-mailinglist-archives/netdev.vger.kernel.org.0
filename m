Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602436A5AE2
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 15:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjB1Odx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 09:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjB1Odd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 09:33:33 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36E8113D9;
        Tue, 28 Feb 2023 06:33:30 -0800 (PST)
Message-ID: <20230228132911.046172182@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677594809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=HGNvsoL6Q4NxlQt+etEpqzj5yMMCQjctFVp6Cmxqw4Q=;
        b=A5HQuOrCA64Jyt2999M+Un5ClaXxgbihM/79xI4HlkFbmS4lXVn2kaGYtLTbcJ1HI+97zn
        ElHDns5uF7TBF2HJVJglDp6wZe2zPNQSABK9NoxmLjy6HS8g7luho7EGGt1GATirZA6HuC
        gHFbBlybtPAkh9AISNSBGEPxy8KLUjy08STZzWccs7TU2F3r34V2xdKPaRMEAfcjpb5tpd
        FaizvtIT0ntYQ44P1QccIO9fGMY7aS2NrLEOuiCyUeR5FcLNBohv473ppDDDkvh8kJcs/1
        unPw1cARZtl6Rcp1W56r58Wohl5wTaOXTOZQtcIxlwqD0QVgOFgZ0nnWnQcsCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677594809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=HGNvsoL6Q4NxlQt+etEpqzj5yMMCQjctFVp6Cmxqw4Q=;
        b=ptNUqv77KIPk6fbubhRQmFES5ppJAOP+kIbA/q5bT6wxKEZGZ0tAnproDxrh4JtmcHfDW9
        GY63g26sS+97RVDA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [patch 3/3] net: dst: Switch to rcuref_t reference counting
References: <20230228132118.978145284@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 28 Feb 2023 15:33:29 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under high contention dst_entry::__refcnt becomes a significant bottleneck.

atomic_inc_not_zero() is implemented with a cmpxchg() loop, which goes into
high retry rates on contention.

Switch the reference count to rcuref_t which results in a significant
performance gain.

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
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
---
 include/net/dst.h               |    9 +++++----
 include/net/sock.h              |    2 +-
 net/bridge/br_nf_core.c         |    2 +-
 net/core/dst.c                  |   26 +++++---------------------
 net/core/rtnetlink.c            |    2 +-
 net/ipv6/route.c                |    6 +++---
 net/netfilter/ipvs/ip_vs_xmit.c |    4 ++--
 7 files changed, 18 insertions(+), 33 deletions(-)

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
@@ -65,7 +66,7 @@ struct dst_entry {
 	 * input/output/ops or performance tanks badly
 	 */
 #ifdef CONFIG_64BIT
-	atomic_t		__refcnt;	/* 64-bit offset 64 */
+	rcuref_t		__refcnt;	/* 64-bit offset 64 */
 #endif
 	int			__use;
 	unsigned long		lastuse;
@@ -75,7 +76,7 @@ struct dst_entry {
 	__u32			tclassid;
 #ifndef CONFIG_64BIT
 	struct lwtunnel_state   *lwtstate;
-	atomic_t		__refcnt;	/* 32-bit offset 64 */
+	rcuref_t		__refcnt;	/* 32-bit offset 64 */
 #endif
 	netdevice_tracker	dev_tracker;
 #ifdef CONFIG_64BIT
@@ -238,7 +239,7 @@ static inline void dst_hold(struct dst_e
 	 * the placement of __refcnt in struct dst_entry
 	 */
 	BUILD_BUG_ON(offsetof(struct dst_entry, __refcnt) & 63);
-	WARN_ON(atomic_inc_not_zero(&dst->__refcnt) == 0);
+	WARN_ON(!rcuref_get(&dst->__refcnt));
 }
 
 static inline void dst_use_noref(struct dst_entry *dst, unsigned long time)
@@ -302,7 +303,7 @@ static inline void skb_dst_copy(struct s
  */
 static inline bool dst_hold_safe(struct dst_entry *dst)
 {
-	return atomic_inc_not_zero(&dst->__refcnt);
+	return rcuref_get(&dst->__refcnt);
 }
 
 /**
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2131,7 +2131,7 @@ sk_dst_get(struct sock *sk)
 
 	rcu_read_lock();
 	dst = rcu_dereference(sk->sk_dst_cache);
-	if (dst && !atomic_inc_not_zero(&dst->__refcnt))
+	if (dst && !rcuref_get(&dst->__refcnt))
 		dst = NULL;
 	rcu_read_unlock();
 	return dst;
--- a/net/bridge/br_nf_core.c
+++ b/net/bridge/br_nf_core.c
@@ -73,7 +73,7 @@ void br_netfilter_rtable_init(struct net
 {
 	struct rtable *rt = &br->fake_rtable;
 
-	atomic_set(&rt->dst.__refcnt, 1);
+	rcuref_init(&rt->dst.__refcnt, 1);
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
+	rcuref_init(&dst->__refcnt, initial_ref);
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
+	if (dst && rcuref_put(&dst->__refcnt))
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
+	if (dst && rcuref_put(&dst->__refcnt))
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
+		ci.rta_clntref = rcuref_read(&dst->__refcnt);
 	}
 	if (expires) {
 		unsigned long clock;
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -293,7 +293,7 @@ static const struct fib6_info fib6_null_
 
 static const struct rt6_info ip6_null_entry_template = {
 	.dst = {
-		.__refcnt	= ATOMIC_INIT(1),
+		.__refcnt	= RCUREF_INIT(1),
 		.__use		= 1,
 		.obsolete	= DST_OBSOLETE_FORCE_CHK,
 		.error		= -ENETUNREACH,
@@ -307,7 +307,7 @@ static const struct rt6_info ip6_null_en
 
 static const struct rt6_info ip6_prohibit_entry_template = {
 	.dst = {
-		.__refcnt	= ATOMIC_INIT(1),
+		.__refcnt	= RCUREF_INIT(1),
 		.__use		= 1,
 		.obsolete	= DST_OBSOLETE_FORCE_CHK,
 		.error		= -EACCES,
@@ -319,7 +319,7 @@ static const struct rt6_info ip6_prohibi
 
 static const struct rt6_info ip6_blk_hole_entry_template = {
 	.dst = {
-		.__refcnt	= ATOMIC_INIT(1),
+		.__refcnt	= RCUREF_INIT(1),
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
+				  rcuref_read(&rt->dst.__refcnt));
 		}
 		if (ret_saddr)
 			*ret_saddr = dest_dst->dst_saddr.ip;
@@ -507,7 +507,7 @@ static int
 			spin_unlock_bh(&dest->dst_lock);
 			IP_VS_DBG(10, "new dst %pI6, src %pI6, refcnt=%d\n",
 				  &dest->addr.in6, &dest_dst->dst_saddr.in6,
-				  atomic_read(&rt->dst.__refcnt));
+				  rcuref_read(&rt->dst.__refcnt));
 		}
 		if (ret_saddr)
 			*ret_saddr = dest_dst->dst_saddr.in6;

