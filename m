Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1454D9F5
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfFTTFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfFTTFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:05:33 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E87D8206BA;
        Thu, 20 Jun 2019 19:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561057532;
        bh=vbQF7E5G/vbCAF3u7DRHI6QgbDz43KOGuXGk0Wsw8Xo=;
        h=From:To:Cc:Subject:Date:From;
        b=FX9T45hWrcwF4Xhg3RGSKt/4tVjGaaIGKJTSfG3N/DcoiH9jXferZrdvaDqlE0VfD
         nEqBxTMaXMooG7NBwPZKcZ+uW9AP2DU774SEpyxAiUscSQT/SjCqWMblLVIx5yw5cR
         QbikWb7YFS+ozXOXOQ+HRFtQsKnYNDtXhah1wGvc=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kafai@fb.com, weiwan@google.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] ipv6: Convert gateway validation to use fib6_info
Date:   Thu, 20 Jun 2019 12:05:36 -0700
Message-Id: <20190620190536.3157-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Gateway validation does not need a dst_entry, it only needs the fib
entry to validate the gateway resolution and egress device. So,
convert ip6_nh_lookup_table from ip6_pol_route to fib6_table_lookup
and ip6_route_check_nh to use fib6_lookup over rt6_lookup.

ip6_pol_route is a call to fib6_table_lookup and if successful a call
to fib6_select_path. From there the exception cache is searched for an
entry or a dst_entry is created to return to the caller. The exception
entry is not relevant for gateway validation, so what matters are the
calls to fib6_table_lookup and then fib6_select_path.

Similarly, rt6_lookup can be replaced with a call to fib6_lookup with
RT6_LOOKUP_F_IFACE set in flags (saddr is not set for gateway validation,
so RT6_LOOKUP_F_HAS_SADDR is not relevant). From there ip6_pol_route_lookup
lookup function is flipped to fib6_table_lookup for the per-table search.
Again, the exception cache search is not relevant, only the lookup with
path selection.

Adjust the users, ip6_route_check_nh_onlink and ip6_route_check_nh to
handle a fib6_info vs a rt6_info when performing validation checks.

Existing selftests fib-onlink-tests.sh and fib_tests.sh used to verify
the changes.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 119 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 57 insertions(+), 62 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index c4d285fe0adc..4937084610b5 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3131,10 +3131,9 @@ static int ip6_dst_gc(struct dst_ops *ops)
 	return entries > rt_max_size;
 }
 
-static struct rt6_info *ip6_nh_lookup_table(struct net *net,
-					    struct fib6_config *cfg,
-					    const struct in6_addr *gw_addr,
-					    u32 tbid, int flags)
+static int ip6_nh_lookup_table(struct net *net, struct fib6_config *cfg,
+			       const struct in6_addr *gw_addr, u32 tbid,
+			       int flags, struct fib6_result *res)
 {
 	struct flowi6 fl6 = {
 		.flowi6_oif = cfg->fc_ifindex,
@@ -3142,25 +3141,23 @@ static struct rt6_info *ip6_nh_lookup_table(struct net *net,
 		.saddr = cfg->fc_prefsrc,
 	};
 	struct fib6_table *table;
-	struct rt6_info *rt;
+	int err;
 
 	table = fib6_get_table(net, tbid);
 	if (!table)
-		return NULL;
+		return -EINVAL;
 
 	if (!ipv6_addr_any(&cfg->fc_prefsrc))
 		flags |= RT6_LOOKUP_F_HAS_SADDR;
 
 	flags |= RT6_LOOKUP_F_IGNORE_LINKSTATE;
-	rt = ip6_pol_route(net, table, cfg->fc_ifindex, &fl6, NULL, flags);
 
-	/* if table lookup failed, fall back to full lookup */
-	if (rt == net->ipv6.ip6_null_entry) {
-		ip6_rt_put(rt);
-		rt = NULL;
-	}
+	err = fib6_table_lookup(net, table, cfg->fc_ifindex, &fl6, res, flags);
+	if (!err && res->f6i != net->ipv6.fib6_null_entry)
+		fib6_select_path(net, res, &fl6, cfg->fc_ifindex,
+				 cfg->fc_ifindex != 0, NULL, flags);
 
-	return rt;
+	return err;
 }
 
 static int ip6_route_check_nh_onlink(struct net *net,
@@ -3168,29 +3165,19 @@ static int ip6_route_check_nh_onlink(struct net *net,
 				     const struct net_device *dev,
 				     struct netlink_ext_ack *extack)
 {
-	u32 tbid = l3mdev_fib_table(dev) ? : RT_TABLE_MAIN;
+	u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
 	const struct in6_addr *gw_addr = &cfg->fc_gateway;
-	u32 flags = RTF_LOCAL | RTF_ANYCAST | RTF_REJECT;
-	struct fib6_info *from;
-	struct rt6_info *grt;
+	struct fib6_result res = {};
 	int err;
 
-	err = 0;
-	grt = ip6_nh_lookup_table(net, cfg, gw_addr, tbid, 0);
-	if (grt) {
-		rcu_read_lock();
-		from = rcu_dereference(grt->from);
-		if (!grt->dst.error &&
-		    /* ignore match if it is the default route */
-		    from && !ipv6_addr_any(&from->fib6_dst.addr) &&
-		    (grt->rt6i_flags & flags || dev != grt->dst.dev)) {
-			NL_SET_ERR_MSG(extack,
-				       "Nexthop has invalid gateway or device mismatch");
-			err = -EINVAL;
-		}
-		rcu_read_unlock();
-
-		ip6_rt_put(grt);
+	err = ip6_nh_lookup_table(net, cfg, gw_addr, tbid, 0, &res);
+	if (!err && !(res.fib6_flags & RTF_REJECT) &&
+	    /* ignore match if it is the default route */
+	    !ipv6_addr_any(&res.f6i->fib6_dst.addr) &&
+	    (res.fib6_type != RTN_UNICAST || dev != res.nh->fib_nh_dev)) {
+		NL_SET_ERR_MSG(extack,
+			       "Nexthop has invalid gateway or device mismatch");
+		err = -EINVAL;
 	}
 
 	return err;
@@ -3203,47 +3190,51 @@ static int ip6_route_check_nh(struct net *net,
 {
 	const struct in6_addr *gw_addr = &cfg->fc_gateway;
 	struct net_device *dev = _dev ? *_dev : NULL;
-	struct rt6_info *grt = NULL;
+	int flags = RT6_LOOKUP_F_IFACE;
+	struct fib6_result res = {};
 	int err = -EHOSTUNREACH;
 
 	if (cfg->fc_table) {
-		int flags = RT6_LOOKUP_F_IFACE;
-
-		grt = ip6_nh_lookup_table(net, cfg, gw_addr,
-					  cfg->fc_table, flags);
-		if (grt) {
-			if (grt->rt6i_flags & RTF_GATEWAY ||
-			    (dev && dev != grt->dst.dev)) {
-				ip6_rt_put(grt);
-				grt = NULL;
-			}
-		}
+		err = ip6_nh_lookup_table(net, cfg, gw_addr,
+					  cfg->fc_table, flags, &res);
+		/* gw_addr can not require a gateway or resolve to a reject
+		 * route. If a device is given, it must match the result.
+		 */
+		if (err || res.fib6_flags & RTF_REJECT ||
+		    res.nh->fib_nh_gw_family ||
+		    (dev && dev != res.nh->fib_nh_dev))
+			err = -EHOSTUNREACH;
 	}
 
-	if (!grt)
-		grt = rt6_lookup(net, gw_addr, NULL, cfg->fc_ifindex, NULL, 1);
+	if (err < 0) {
+		struct flowi6 fl6 = {
+			.flowi6_oif = cfg->fc_ifindex,
+			.daddr = *gw_addr,
+		};
 
-	if (!grt)
-		goto out;
+		err = fib6_lookup(net, cfg->fc_ifindex, &fl6, &res, flags);
+		if (err || res.fib6_flags & RTF_REJECT ||
+		    res.nh->fib_nh_gw_family)
+			err = -EHOSTUNREACH;
+
+		if (err)
+			return err;
+
+		fib6_select_path(net, &res, &fl6, cfg->fc_ifindex,
+				 cfg->fc_ifindex != 0, NULL, flags);
+	}
 
+	err = 0;
 	if (dev) {
-		if (dev != grt->dst.dev) {
-			ip6_rt_put(grt);
-			goto out;
-		}
+		if (dev != res.nh->fib_nh_dev)
+			err = -EHOSTUNREACH;
 	} else {
-		*_dev = dev = grt->dst.dev;
-		*idev = grt->rt6i_idev;
+		*_dev = dev = res.nh->fib_nh_dev;
+		*idev = __in6_dev_get(dev);
 		dev_hold(dev);
-		in6_dev_hold(grt->rt6i_idev);
+		in6_dev_hold(*idev);
 	}
 
-	if (!(grt->rt6i_flags & RTF_GATEWAY))
-		err = 0;
-
-	ip6_rt_put(grt);
-
-out:
 	return err;
 }
 
@@ -3284,11 +3275,15 @@ static int ip6_validate_gw(struct net *net, struct fib6_config *cfg,
 			goto out;
 		}
 
+		rcu_read_lock();
+
 		if (cfg->fc_flags & RTNH_F_ONLINK)
 			err = ip6_route_check_nh_onlink(net, cfg, dev, extack);
 		else
 			err = ip6_route_check_nh(net, cfg, _dev, idev);
 
+		rcu_read_unlock();
+
 		if (err)
 			goto out;
 	}
-- 
2.11.0

