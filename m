Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC454C3A6
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 00:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbfFSWcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 18:32:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43833 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730182AbfFSWcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 18:32:18 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so426688pgv.10
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 15:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UfXiWrDNVd1YNRVEVnBNuKA+zj+k+vrtb3sOAGihE6M=;
        b=LIE4Dg9wIC2wrdqfWS6+XJhikgClvIFQtkqHr7SLOVGp/Z/UDxW/EY1gGz7fv7GpNJ
         PQx5Y+n4N1L46wXTnmBpWQpsBTk0SqKkbIXAaVvmNLEfRQCYAZJSHcpbnd05hwtPCKKf
         sUpxf/4IP6Gc0VpU6joyLyhLyvb2CsyUHR9Jgqrq10F4iJJdl59R4VSRq2scQ1KseR2c
         9fkVgbkvHc/XtbOZJpEJwv8w/PSfPRR174Huh0iKuhZeVdu0p762HxYYYiUmMX2AU0Py
         t/3zXu4gywpjQLvcvuArTmH4VUkYQxE/azb7amOZLDZTi6As005m9rTWpJTHe42dWVN7
         INFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UfXiWrDNVd1YNRVEVnBNuKA+zj+k+vrtb3sOAGihE6M=;
        b=G718F0TY3kfiuUiHTQVdnznS1Ggbz4qKdtCUiq/h4d7DXGWzTUId9g67IM3G6GNLAu
         gmSNPJqkAGINVJW9kzYs0lMNUkmojSSkASgtiIk2gAqxFNXtdqcOhgOOUZ9shktL9+i2
         04L17Yd1v8JW6l5X3Dx5nZcxW0rqkck8DI8FCTKKDp9E8BHAMpFRFi3qmtqh44CSa93N
         wkiRJ4DE0HZxzsrU/vNKnGqtR9P4RWEvxfwpKnJQQVevlIE3TQLCTjKosUBbzEp7rLIF
         F1Bku/Sm18aLu/cVG8/ylM2WXlk4iBOamUdRRkV1Ue6mZ7GcJ5UAqsE/QLXB+82GqCks
         KB6A==
X-Gm-Message-State: APjAAAVG/HNan6uZgBFpmOd/lFgiZiSg8kamJUp51F/+8WJo+W0ZNPJ0
        OO1gGa04mNQ1n5gXfzFbg+4=
X-Google-Smtp-Source: APXvYqzngSsrBQQBOa8Qw2e3D8L+EfLEmwpOQH+fc2fEbuNLGab/lKnjgXQs6eD4NNl+jIGYQ067RA==
X-Received: by 2002:a17:90a:a601:: with SMTP id c1mr13074061pjq.24.1560983537075;
        Wed, 19 Jun 2019 15:32:17 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id g8sm20037687pgd.29.2019.06.19.15.32.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 15:32:16 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH v2 net-next 5/5] ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF
Date:   Wed, 19 Jun 2019 15:31:58 -0700
Message-Id: <20190619223158.35829-6-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190619223158.35829-1-tracywwnj@gmail.com>
References: <20190619223158.35829-1-tracywwnj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>

For tx path, in most cases, we still have to take refcnt on the dst
cause the caller is caching the dst somewhere. But it still is
beneficial to make use of RT6_LOOKUP_F_DST_NOREF flag while doing the
route lookup. It is cause this flag prevents manipulating refcnt on
net->ipv6.ip6_null_entry when doing fib6_rule_lookup() to traverse each
routing table. The null_entry is a shared object and constant updates on
it cause false sharing.

We converted the current major lookup function ip6_route_output_flags()
to make use of RT6_LOOKUP_F_DST_NOREF.

Together with the change in the rx path, we see noticable performance
boost:
I ran synflood tests between 2 hosts under the same switch. Both hosts
have 20G mlx NIC, and 8 tx/rx queues.
Sender sends pure SYN flood with random src IPs and ports using trafgen.
Receiver has a simple TCP listener on the target port.
Both hosts have multiple custom rules:
- For incoming packets, only local table is traversed.
- For outgoing packets, 3 tables are traversed to find the route.
The packet processing rate on the receiver is as follows:
- Before the fix: 3.78Mpps
- After the fix:  5.50Mpps

Signed-off-by: Wei Wang <weiwan@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
---
 drivers/net/vrf.c       | 11 ++++++-----
 include/net/ip6_route.h | 25 +++++++++++++++++++++++--
 include/net/l3mdev.h    | 11 +++++++----
 net/ipv6/route.c        | 10 ++++++----
 net/l3mdev/l3mdev.c     | 22 +++++++++++-----------
 5 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 11b9525dff27..1d1ac78b167e 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1072,12 +1072,14 @@ static struct sk_buff *vrf_l3_rcv(struct net_device *vrf_dev,
 #if IS_ENABLED(CONFIG_IPV6)
 /* send to link-local or multicast address via interface enslaved to
  * VRF device. Force lookup to VRF table without changing flow struct
+ * No refcnt is taken on the dst.
  */
-static struct dst_entry *vrf_link_scope_lookup(const struct net_device *dev,
-					      struct flowi6 *fl6)
+static struct dst_entry *vrf_link_scope_lookup_noref(
+					    const struct net_device *dev,
+					    struct flowi6 *fl6)
 {
 	struct net *net = dev_net(dev);
-	int flags = RT6_LOOKUP_F_IFACE;
+	int flags = RT6_LOOKUP_F_IFACE | RT6_LOOKUP_F_DST_NOREF;
 	struct dst_entry *dst = NULL;
 	struct rt6_info *rt;
 
@@ -1087,7 +1089,6 @@ static struct dst_entry *vrf_link_scope_lookup(const struct net_device *dev,
 	 */
 	if (fl6->flowi6_oif == dev->ifindex) {
 		dst = &net->ipv6.ip6_null_entry->dst;
-		dst_hold(dst);
 		return dst;
 	}
 
@@ -1107,7 +1108,7 @@ static const struct l3mdev_ops vrf_l3mdev_ops = {
 	.l3mdev_l3_rcv		= vrf_l3_rcv,
 	.l3mdev_l3_out		= vrf_l3_out,
 #if IS_ENABLED(CONFIG_IPV6)
-	.l3mdev_link_scope_lookup = vrf_link_scope_lookup,
+	.l3mdev_link_scope_lookup_noref = vrf_link_scope_lookup_noref,
 #endif
 };
 
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 0709835c01ad..66802ecd81e5 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -84,8 +84,29 @@ struct dst_entry *ip6_route_input_lookup(struct net *net,
 					 struct flowi6 *fl6,
 					 const struct sk_buff *skb, int flags);
 
-struct dst_entry *ip6_route_output_flags(struct net *net, const struct sock *sk,
-					 struct flowi6 *fl6, int flags);
+struct dst_entry *ip6_route_output_flags_noref(struct net *net,
+					       const struct sock *sk,
+					       struct flowi6 *fl6, int flags);
+
+static inline struct dst_entry *ip6_route_output_flags(struct net *net,
+						       const struct sock *sk,
+						       struct flowi6 *fl6,
+						       int flags) {
+	struct dst_entry *dst;
+	struct rt6_info *rt6;
+
+	rcu_read_lock();
+	dst = ip6_route_output_flags_noref(net, sk, fl6, flags);
+	rt6 = (struct rt6_info *)dst;
+	/* For dst cached in uncached_list, refcnt is already taken. */
+	if (list_empty(&rt6->rt6i_uncached) && !dst_hold_safe(dst)) {
+		dst = &net->ipv6.ip6_null_entry->dst;
+		dst_hold(dst);
+	}
+	rcu_read_unlock();
+
+	return dst;
+}
 
 static inline struct dst_entry *ip6_route_output(struct net *net,
 						 const struct sock *sk,
diff --git a/include/net/l3mdev.h b/include/net/l3mdev.h
index e942372b077b..d8c37317bb86 100644
--- a/include/net/l3mdev.h
+++ b/include/net/l3mdev.h
@@ -31,8 +31,9 @@ struct l3mdev_ops {
 					  u16 proto);
 
 	/* IPv6 ops */
-	struct dst_entry * (*l3mdev_link_scope_lookup)(const struct net_device *dev,
-						 struct flowi6 *fl6);
+	struct dst_entry * (*l3mdev_link_scope_lookup_noref)(
+					    const struct net_device *dev,
+					    struct flowi6 *fl6);
 };
 
 #ifdef CONFIG_NET_L3_MASTER_DEV
@@ -140,7 +141,8 @@ static inline bool netif_index_is_l3_master(struct net *net, int ifindex)
 	return rc;
 }
 
-struct dst_entry *l3mdev_link_scope_lookup(struct net *net, struct flowi6 *fl6);
+struct dst_entry *l3mdev_link_scope_lookup_noref(struct net *net,
+						 struct flowi6 *fl6);
 
 static inline
 struct sk_buff *l3mdev_l3_rcv(struct sk_buff *skb, u16 proto)
@@ -251,7 +253,8 @@ static inline bool netif_index_is_l3_master(struct net *net, int ifindex)
 }
 
 static inline
-struct dst_entry *l3mdev_link_scope_lookup(struct net *net, struct flowi6 *fl6)
+struct dst_entry *l3mdev_link_scope_lookup_noref(struct net *net,
+						 struct flowi6 *fl6)
 {
 	return NULL;
 }
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index d2b287635aab..602d00794b30 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2415,8 +2415,9 @@ static struct rt6_info *ip6_pol_route_output(struct net *net,
 	return ip6_pol_route(net, table, fl6->flowi6_oif, fl6, skb, flags);
 }
 
-struct dst_entry *ip6_route_output_flags(struct net *net, const struct sock *sk,
-					 struct flowi6 *fl6, int flags)
+struct dst_entry *ip6_route_output_flags_noref(struct net *net,
+					       const struct sock *sk,
+					       struct flowi6 *fl6, int flags)
 {
 	bool any_src;
 
@@ -2424,13 +2425,14 @@ struct dst_entry *ip6_route_output_flags(struct net *net, const struct sock *sk,
 	    (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL)) {
 		struct dst_entry *dst;
 
-		dst = l3mdev_link_scope_lookup(net, fl6);
+		dst = l3mdev_link_scope_lookup_noref(net, fl6);
 		if (dst)
 			return dst;
 	}
 
 	fl6->flowi6_iif = LOOPBACK_IFINDEX;
 
+	flags |= RT6_LOOKUP_F_DST_NOREF;
 	any_src = ipv6_addr_any(&fl6->saddr);
 	if ((sk && sk->sk_bound_dev_if) || rt6_need_strict(&fl6->daddr) ||
 	    (fl6->flowi6_oif && any_src))
@@ -2443,7 +2445,7 @@ struct dst_entry *ip6_route_output_flags(struct net *net, const struct sock *sk,
 
 	return fib6_rule_lookup(net, fl6, NULL, flags, ip6_pol_route_output);
 }
-EXPORT_SYMBOL_GPL(ip6_route_output_flags);
+EXPORT_SYMBOL_GPL(ip6_route_output_flags_noref);
 
 struct dst_entry *ip6_blackhole_route(struct net *net, struct dst_entry *dst_orig)
 {
diff --git a/net/l3mdev/l3mdev.c b/net/l3mdev/l3mdev.c
index cfc9fcb97465..06133426549b 100644
--- a/net/l3mdev/l3mdev.c
+++ b/net/l3mdev/l3mdev.c
@@ -114,35 +114,35 @@ u32 l3mdev_fib_table_by_index(struct net *net, int ifindex)
 EXPORT_SYMBOL_GPL(l3mdev_fib_table_by_index);
 
 /**
- *	l3mdev_link_scope_lookup - IPv6 route lookup based on flow for link
- *			     local and multicast addresses
+ *	l3mdev_link_scope_lookup_noref - IPv6 route lookup based on flow
+ *			     for link local and multicast addresses
  *	@net: network namespace for device index lookup
  *	@fl6: IPv6 flow struct for lookup
+ *	This function does not hold refcnt on the returned dst.
+ *	Caller must hold rcu_read_lock().
  */
 
-struct dst_entry *l3mdev_link_scope_lookup(struct net *net,
-					   struct flowi6 *fl6)
+struct dst_entry *l3mdev_link_scope_lookup_noref(struct net *net,
+						 struct flowi6 *fl6)
 {
 	struct dst_entry *dst = NULL;
 	struct net_device *dev;
 
+	WARN_ON_ONCE(!rcu_read_lock_held());
 	if (fl6->flowi6_oif) {
-		rcu_read_lock();
-
 		dev = dev_get_by_index_rcu(net, fl6->flowi6_oif);
 		if (dev && netif_is_l3_slave(dev))
 			dev = netdev_master_upper_dev_get_rcu(dev);
 
 		if (dev && netif_is_l3_master(dev) &&
-		    dev->l3mdev_ops->l3mdev_link_scope_lookup)
-			dst = dev->l3mdev_ops->l3mdev_link_scope_lookup(dev, fl6);
-
-		rcu_read_unlock();
+		    dev->l3mdev_ops->l3mdev_link_scope_lookup_noref)
+			dst = dev->l3mdev_ops->
+				l3mdev_link_scope_lookup_noref(dev, fl6);
 	}
 
 	return dst;
 }
-EXPORT_SYMBOL_GPL(l3mdev_link_scope_lookup);
+EXPORT_SYMBOL_GPL(l3mdev_link_scope_lookup_noref);
 
 /**
  *	l3mdev_fib_rule_match - Determine if flowi references an
-- 
2.22.0.410.gd8fdbe21b5-goog

