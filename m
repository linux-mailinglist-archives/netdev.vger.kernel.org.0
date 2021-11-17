Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2A2454613
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 13:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbhKQMFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 07:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhKQMFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 07:05:48 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A33C061746;
        Wed, 17 Nov 2021 04:02:49 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1637150567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sylWkYuumGpx/o95w1HfoTWXOYpU1oA4v54KTqim028=;
        b=vJ3/meiCbaJ4q7W6WWrbVLi38bQXZxopJJYF51aRV4U7ff72k1eTmvfS4vcopF9IgXHkN/
        LtlIv1N6MpnJvCJCkVABUT/yACblhf6BiSjbJCoLDoWMIo6dCXAjw8zpCd722cayQyknGt
        pEtfVKbySuUr5s39y3wdbFRvLbcz1qo=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] neigh: introduce __neigh_confirm() for __ipv{4, 6}_confirm_neigh
Date:   Wed, 17 Nov 2021 20:02:15 +0800
Message-Id: <20211117120215.30209-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Those __ipv4_confirm_neigh(), __ipv6_confirm_neigh() and __ipv6_confirm_neigh_stub()
functions have similar code. introduce __neigh_confirm() for it.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/net/arp.h        | 21 ++++++---------------
 include/net/ndisc.h      | 26 ++------------------------
 include/net/neighbour.h  | 19 +++++++++++++++++++
 include/net/route.h      |  2 +-
 net/core/filter.c        |  3 +--
 net/core/neighbour.c     |  4 +---
 net/ipv4/fib_semantics.c |  2 +-
 net/ipv4/nexthop.c       |  3 +--
 8 files changed, 32 insertions(+), 48 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index 4950191f6b2b..4772510851d7 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -19,8 +19,10 @@ static inline u32 arp_hashfn(const void *pkey, const struct net_device *dev, u32
 }
 
 #ifdef CONFIG_INET
-static inline struct neighbour *__ipv4_neigh_lookup_noref(struct net_device *dev, u32 key)
+static inline struct neighbour *__ipv4_neigh_lookup_noref(struct net_device *dev, const void *pkey)
 {
+	u32 key = *(const u32 *)pkey;
+
 	if (dev->flags & (IFF_LOOPBACK | IFF_POINTOPOINT))
 		key = INADDR_ANY;
 
@@ -28,7 +30,7 @@ static inline struct neighbour *__ipv4_neigh_lookup_noref(struct net_device *dev
 }
 #else
 static inline
-struct neighbour *__ipv4_neigh_lookup_noref(struct net_device *dev, u32 key)
+struct neighbour *__ipv4_neigh_lookup_noref(struct net_device *dev, const void *pkey)
 {
 	return NULL;
 }
@@ -39,7 +41,7 @@ static inline struct neighbour *__ipv4_neigh_lookup(struct net_device *dev, u32
 	struct neighbour *n;
 
 	rcu_read_lock_bh();
-	n = __ipv4_neigh_lookup_noref(dev, key);
+	n = __ipv4_neigh_lookup_noref(dev, &key);
 	if (n && !refcount_inc_not_zero(&n->refcnt))
 		n = NULL;
 	rcu_read_unlock_bh();
@@ -49,18 +51,7 @@ static inline struct neighbour *__ipv4_neigh_lookup(struct net_device *dev, u32
 
 static inline void __ipv4_confirm_neigh(struct net_device *dev, u32 key)
 {
-	struct neighbour *n;
-
-	rcu_read_lock_bh();
-	n = __ipv4_neigh_lookup_noref(dev, key);
-	if (n) {
-		unsigned long now = jiffies;
-
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
-	}
-	rcu_read_unlock_bh();
+	__neigh_confirm(dev, &key, __ipv4_neigh_lookup_noref);
 }
 
 void arp_init(void);
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 04341d86585d..4ea4dc167a53 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -407,35 +407,13 @@ static inline struct neighbour *__ipv6_neigh_lookup(struct net_device *dev, cons
 static inline void __ipv6_confirm_neigh(struct net_device *dev,
 					const void *pkey)
 {
-	struct neighbour *n;
-
-	rcu_read_lock_bh();
-	n = __ipv6_neigh_lookup_noref(dev, pkey);
-	if (n) {
-		unsigned long now = jiffies;
-
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
-	}
-	rcu_read_unlock_bh();
+	__neigh_confirm(dev, pkey, __ipv6_neigh_lookup_noref);
 }
 
 static inline void __ipv6_confirm_neigh_stub(struct net_device *dev,
 					     const void *pkey)
 {
-	struct neighbour *n;
-
-	rcu_read_lock_bh();
-	n = __ipv6_neigh_lookup_noref_stub(dev, pkey);
-	if (n) {
-		unsigned long now = jiffies;
-
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
-	}
-	rcu_read_unlock_bh();
+	__neigh_confirm(dev, pkey, __ipv6_neigh_lookup_noref_stub);
 }
 
 /* uses ipv6_stub and is meant for use outside of IPv6 core */
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 38a0c1d24570..a8c99a7d4f39 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -335,6 +335,25 @@ static inline struct neighbour *neigh_create(struct neigh_table *tbl,
 {
 	return __neigh_create(tbl, pkey, dev, true);
 }
+
+static inline void __neigh_confirm(struct net_device *dev, const void *pkey,
+				   struct neighbour *(*neigh_lookup_noref)(
+				   struct net_device *, const void *))
+{
+	struct neighbour *n;
+
+	rcu_read_lock_bh();
+	n = neigh_lookup_noref(dev, pkey);
+	if (n) {
+		unsigned long now = jiffies;
+
+		/* avoid dirtying neighbour */
+		if (READ_ONCE(n->confirmed) != now)
+			WRITE_ONCE(n->confirmed, now);
+	}
+	rcu_read_unlock_bh();
+}
+
 void neigh_destroy(struct neighbour *neigh);
 int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb);
 int neigh_update(struct neighbour *neigh, const u8 *lladdr, u8 new, u32 flags,
diff --git a/include/net/route.h b/include/net/route.h
index 2e6c0e153e3a..7188f6e48ae8 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -369,7 +369,7 @@ static inline struct neighbour *ip_neigh_gw4(struct net_device *dev,
 {
 	struct neighbour *neigh;
 
-	neigh = __ipv4_neigh_lookup_noref(dev, daddr);
+	neigh = __ipv4_neigh_lookup_noref(dev, &daddr);
 	if (unlikely(!neigh))
 		neigh = __neigh_create(&arp_tbl, &daddr, dev, false);
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 26e0276aa00d..16a4b7fb281c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5478,8 +5478,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 		if (nhc->nhc_gw_family)
 			params->ipv4_dst = nhc->nhc_gw.ipv4;
 
-		neigh = __ipv4_neigh_lookup_noref(dev,
-						 (__force u32)params->ipv4_dst);
+		neigh = __ipv4_neigh_lookup_noref(dev, &params->ipv4_dst);
 	} else {
 		struct in6_addr *dst = (struct in6_addr *)params->ipv6_dst;
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 47931c8be04b..2f05473bcad0 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3091,9 +3091,7 @@ int neigh_xmit(int index, struct net_device *dev,
 			goto out;
 		rcu_read_lock_bh();
 		if (index == NEIGH_ARP_TABLE) {
-			u32 key = *((u32 *)addr);
-
-			neigh = __ipv4_neigh_lookup_noref(dev, key);
+			neigh = __ipv4_neigh_lookup_noref(dev, addr);
 		} else {
 			neigh = __neigh_lookup_noref(tbl, addr, dev);
 		}
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 3364cb9c67e0..0ea7d243ac5f 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -2161,7 +2161,7 @@ static bool fib_good_nh(const struct fib_nh *nh)
 
 		if (likely(nh->fib_nh_gw_family == AF_INET))
 			n = __ipv4_neigh_lookup_noref(nh->fib_nh_dev,
-						   (__force u32)nh->fib_nh_gw4);
+						      &nh->fib_nh_gw4);
 		else if (nh->fib_nh_gw_family == AF_INET6)
 			n = __ipv6_neigh_lookup_noref_stub(nh->fib_nh_dev,
 							   &nh->fib_nh_gw6);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 9e8100728d46..ce618965896c 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1141,8 +1141,7 @@ static bool ipv4_good_nh(const struct fib_nh *nh)
 
 	rcu_read_lock_bh();
 
-	n = __ipv4_neigh_lookup_noref(nh->fib_nh_dev,
-				      (__force u32)nh->fib_nh_gw4);
+	n = __ipv4_neigh_lookup_noref(nh->fib_nh_dev, &nh->fib_nh_gw4);
 	if (n)
 		state = n->nud_state;
 
-- 
2.32.0

