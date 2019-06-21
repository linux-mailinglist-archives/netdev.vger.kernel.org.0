Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D452E4DE1E
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfFUAhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:37:10 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36351 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfFUAhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:37:07 -0400
Received: by mail-pg1-f196.google.com with SMTP id f21so2462016pgi.3
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kBeD9LqGyzx+wXCjbl4pe1W43NLnQOcIn5AmcDCmEmY=;
        b=UXvfkZnozH15k31HcBHA2Qx+RPTFbvT7Gmrh7tfYpGiz/ODcph/QOtfA0m8Ay9RiPP
         Q1Dwa/tnHZ/hqkJLsuj1R+//6vgSwfobgwrI7suGIuUVEdcuXvwozw5gn5FCkJKm6mIn
         YjPOXtjb33F8NtdMIEXNDTOmGOs7FqPn4NQ49IC7UQez95T3Vp+iKmJnnA14xFqp5LCu
         vEx0EWlqSkxfjBrWV1E+OPow5l5AvRcyHdJ5G24RRvCGzXIiJQUb3nu5KirEughUikyS
         fal/r+8h0KL4arvZrm/6yrjxj0RiPrikxWGB8ABTyQ9JtJ1qEDXHj022O0BZ0lYfAtFR
         TtUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kBeD9LqGyzx+wXCjbl4pe1W43NLnQOcIn5AmcDCmEmY=;
        b=O4Ky3pgU3aHEZemosHlrUA8VYiQDZHHWslhmINXVrGh/+GgQxF3fe31lsiv3QxeDTX
         2VExJjSAPQ8LMMoZNHwldtS41DIMaMQvu4AKwE0KvHL/Q4amGGZGXuPFkn6LvTg/lsig
         k6XIsQNEQDRuP3GLTE34H1Yqd+5yRmhNNxbrEEii8t4CICZwEP8gMiOucZb57dTaZS2X
         HP7FONefS2RzBdkMjMIM2XPu/k3wvviRtUkCWHSKhqQvK2+PMpUvh3XaKYtuV3U7sLFi
         vEChfYi4HkC6+R1WhAFI0Ux+cRAgCcdjR2pStPzpJ5hYHjX6AIoDYNYgMCdxBoPQzFJz
         dL1w==
X-Gm-Message-State: APjAAAWK8FYN5JCnT53AwQ3WHSiGw9Tfow6v2mpisbrudDL95VhWacFm
        O4rlw4UDXVRZaEmWvp49Cs8=
X-Google-Smtp-Source: APXvYqw7UAY5nT2UBTuOq8EPzfjgTy1bf9AbSEhLqXHcHAXdC3x6/A8/yWqr/VhQPFVFCc8nlEHDqg==
X-Received: by 2002:a63:7749:: with SMTP id s70mr2858867pgc.242.1561077427025;
        Thu, 20 Jun 2019 17:37:07 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id 2sm588206pff.174.2019.06.20.17.37.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 17:37:06 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Wei Wang <weiwan@google.com>
Subject: [PATCH v3 net-next 5/5] ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF
Date:   Thu, 20 Jun 2019 17:36:41 -0700
Message-Id: <20190621003641.168591-6-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190621003641.168591-1-tracywwnj@gmail.com>
References: <20190621003641.168591-1-tracywwnj@gmail.com>
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
---
 drivers/net/vrf.c       |  5 +++--
 include/net/ip6_route.h |  4 ++++
 net/ipv6/route.c        | 29 +++++++++++++++++++++++++++--
 net/l3mdev/l3mdev.c     |  7 +++----
 4 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 11b9525dff27..69ef9cce5858 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1072,12 +1072,14 @@ static struct sk_buff *vrf_l3_rcv(struct net_device *vrf_dev,
 #if IS_ENABLED(CONFIG_IPV6)
 /* send to link-local or multicast address via interface enslaved to
  * VRF device. Force lookup to VRF table without changing flow struct
+ * Note: Caller to this function must hold rcu_read_lock() and no refcnt
+ * is taken on the dst by this function.
  */
 static struct dst_entry *vrf_link_scope_lookup(const struct net_device *dev,
 					      struct flowi6 *fl6)
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
 
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 0709835c01ad..89ad7917b98d 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -84,6 +84,10 @@ struct dst_entry *ip6_route_input_lookup(struct net *net,
 					 struct flowi6 *fl6,
 					 const struct sk_buff *skb, int flags);
 
+struct dst_entry *ip6_route_output_flags_noref(struct net *net,
+					       const struct sock *sk,
+					       struct flowi6 *fl6, int flags);
+
 struct dst_entry *ip6_route_output_flags(struct net *net, const struct sock *sk,
 					 struct flowi6 *fl6, int flags);
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index d2b287635aab..8a746001f813 100644
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
 
@@ -2424,6 +2425,7 @@ struct dst_entry *ip6_route_output_flags(struct net *net, const struct sock *sk,
 	    (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL)) {
 		struct dst_entry *dst;
 
+		/* This function does not take refcnt on the dst */
 		dst = l3mdev_link_scope_lookup(net, fl6);
 		if (dst)
 			return dst;
@@ -2431,6 +2433,7 @@ struct dst_entry *ip6_route_output_flags(struct net *net, const struct sock *sk,
 
 	fl6->flowi6_iif = LOOPBACK_IFINDEX;
 
+	flags |= RT6_LOOKUP_F_DST_NOREF;
 	any_src = ipv6_addr_any(&fl6->saddr);
 	if ((sk && sk->sk_bound_dev_if) || rt6_need_strict(&fl6->daddr) ||
 	    (fl6->flowi6_oif && any_src))
@@ -2443,6 +2446,28 @@ struct dst_entry *ip6_route_output_flags(struct net *net, const struct sock *sk,
 
 	return fib6_rule_lookup(net, fl6, NULL, flags, ip6_pol_route_output);
 }
+EXPORT_SYMBOL_GPL(ip6_route_output_flags_noref);
+
+struct dst_entry *ip6_route_output_flags(struct net *net,
+					 const struct sock *sk,
+					 struct flowi6 *fl6,
+					 int flags)
+{
+        struct dst_entry *dst;
+        struct rt6_info *rt6;
+
+        rcu_read_lock();
+        dst = ip6_route_output_flags_noref(net, sk, fl6, flags);
+        rt6 = (struct rt6_info *)dst;
+        /* For dst cached in uncached_list, refcnt is already taken. */
+        if (list_empty(&rt6->rt6i_uncached) && !dst_hold_safe(dst)) {
+                dst = &net->ipv6.ip6_null_entry->dst;
+                dst_hold(dst);
+        }
+        rcu_read_unlock();
+
+        return dst;
+}
 EXPORT_SYMBOL_GPL(ip6_route_output_flags);
 
 struct dst_entry *ip6_blackhole_route(struct net *net, struct dst_entry *dst_orig)
diff --git a/net/l3mdev/l3mdev.c b/net/l3mdev/l3mdev.c
index cfc9fcb97465..f35899d45a9a 100644
--- a/net/l3mdev/l3mdev.c
+++ b/net/l3mdev/l3mdev.c
@@ -118,6 +118,8 @@ EXPORT_SYMBOL_GPL(l3mdev_fib_table_by_index);
  *			     local and multicast addresses
  *	@net: network namespace for device index lookup
  *	@fl6: IPv6 flow struct for lookup
+ *	This function does not hold refcnt on the returned dst.
+ *	Caller must hold rcu_read_lock().
  */
 
 struct dst_entry *l3mdev_link_scope_lookup(struct net *net,
@@ -126,9 +128,8 @@ struct dst_entry *l3mdev_link_scope_lookup(struct net *net,
 	struct dst_entry *dst = NULL;
 	struct net_device *dev;
 
+	WARN_ON_ONCE(!rcu_read_lock_held());
 	if (fl6->flowi6_oif) {
-		rcu_read_lock();
-
 		dev = dev_get_by_index_rcu(net, fl6->flowi6_oif);
 		if (dev && netif_is_l3_slave(dev))
 			dev = netdev_master_upper_dev_get_rcu(dev);
@@ -136,8 +137,6 @@ struct dst_entry *l3mdev_link_scope_lookup(struct net *net,
 		if (dev && netif_is_l3_master(dev) &&
 		    dev->l3mdev_ops->l3mdev_link_scope_lookup)
 			dst = dev->l3mdev_ops->l3mdev_link_scope_lookup(dev, fl6);
-
-		rcu_read_unlock();
 	}
 
 	return dst;
-- 
2.22.0.410.gd8fdbe21b5-goog

