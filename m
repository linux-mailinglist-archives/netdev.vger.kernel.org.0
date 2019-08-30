Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147F7A3D88
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 20:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfH3SOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 14:14:52 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38170 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728117AbfH3SOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 14:14:52 -0400
Received: by mail-qk1-f195.google.com with SMTP id u190so6970986qkh.5
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 11:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M10m+am+/gcuozCEQL5VhzDXSOTNMSb278vLxNoenCM=;
        b=D8p5r0mrL8NQ2/HKRohHrDjWbyIKjuBr+M4TDALFcSzhrYiv4oQj8Yja4YGeVu7P/J
         FqSJO4QiAuatNiVDkAcx8FN2sgCkeoC1g4R7BEvuuqA9AhyMicoevHNcxtslpx2W+olV
         asEU7jyF+dAH4h6h4+BXvFrfLXGFFm0uG7oLI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M10m+am+/gcuozCEQL5VhzDXSOTNMSb278vLxNoenCM=;
        b=pehK5hcm79DNEDmlckc5XZk3/PDlGwgzlFqN1qQezJQDARxyI27+n0LMUrwUimMc3w
         132lRkfXuW6kF5xhu9k2Pvp9pC4QWVVFeEOjMHOiC8sOMShb8lxLRPxwIGF5aTr88dbg
         LU7RMOqSOThzvgJk7lthjpcut+khie3auRYmQJzDe0DfrKZGnzSU/r7JhSjSuytoD8Oz
         37d+6aFmj5NRlj7uim9keYyZqRnUpwAb45NojC4DPCNFlBx5LjUMRC8nhdzbnkEa/ydQ
         cG+/RCLtr4jlxToOjvv2Dsmnt176V/5wkD4WkpbDzCWWOsm4YFT9K1cnsnIzaQOuabRm
         TRtw==
X-Gm-Message-State: APjAAAUmtFoJJ5z6aL/BHUHJKeNC3iYgyOO6Z+mZRXTWlJlkU+z3CBY5
        K0RWo6HlYGjiXaVEjtFgyNjA8BnFKV4=
X-Google-Smtp-Source: APXvYqwLgcrQKrQpnO5Dfgtz2jMLJW/kXvxg8qPi1Ol5LYEZ42M6UWlXUEbt9y1Ow7IZJ3mMMI08fQ==
X-Received: by 2002:a37:7404:: with SMTP id p4mr16714030qkc.476.1567188891397;
        Fri, 30 Aug 2019 11:14:51 -0700 (PDT)
Received: from robot.nc.rr.com (cpe-2606-A000-111D-8179-B743-207D-F4F9-B992.dyn6.twc.com. [2606:a000:111d:8179:b743:207d:f4f9:b992])
        by smtp.googlemail.com with ESMTPSA id q5sm172353qte.38.2019.08.30.11.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 11:14:50 -0700 (PDT)
From:   Donald Sharp <sharpd@cumulusnetworks.com>
To:     netdev@vger.kernel.org, dsahern@kernel.org,
        sworley@cumulusnetworks.com
Subject: [PATCH net] net: Properly update v4 routes with v6 nexthop
Date:   Fri, 30 Aug 2019 14:14:46 -0400
Message-Id: <20190830181446.25262-1-sharpd@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating a v4 route that uses a v6 nexthop from a nexthop group.
Allow the kernel to properly send the nexthop as v6 via the RTA_VIA
attribute.

Broken behavior:

$ ip nexthop add via fe80::9 dev eth0
$ ip nexthop show
id 1 via fe80::9 dev eth0 scope link
$ ip route add 4.5.6.7/32 nhid 1
$ ip route show
default via 10.0.2.2 dev eth0
4.5.6.7 nhid 1 via 254.128.0.0 dev eth0
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
$

Fixed behavior:

$ ip nexthop add via fe80::9 dev eth0
$ ip nexthop show
id 1 via fe80::9 dev eth0 scope link
$ ip route add 4.5.6.7/32 nhid 1
$ ip route show
default via 10.0.2.2 dev eth0
4.5.6.7 nhid 1 via inet6 fe80::9 dev eth0
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
$

Fixes: dcb1ecb50edf (“ipv4: Prepare for fib6_nh from a nexthop object”)
Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
---
 include/net/ip_fib.h     |  4 ++--
 include/net/nexthop.h    |  2 +-
 net/ipv4/fib_semantics.c | 21 ++++++++++++---------
 net/ipv6/route.c         |  9 +++++----
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 4c81846ccce8..c7e94edae482 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -513,7 +513,7 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 			  struct netlink_callback *cb);
 
 int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nh,
-		     unsigned char *flags, bool skip_oif);
+		     u8 family, unsigned char *flags, bool skip_oif);
 int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nh,
-		    int nh_weight);
+		    int nh_weight, u8 family);
 #endif  /* _NET_FIB_H */
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 95f766c31c90..f13c61806abf 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -172,7 +172,7 @@ int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh)
 		struct fib_nh_common *nhc = &nhi->fib_nhc;
 		int weight = nhg->nh_entries[i].weight;
 
-		if (fib_add_nexthop(skb, nhc, weight) < 0)
+		if (fib_add_nexthop(skb, nhc, weight, nhc->nhc_family) < 0)
 			return -EMSGSIZE;
 	}
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 2db089e10ba0..e4417d171863 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1582,7 +1582,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 }
 
 int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nhc,
-		     unsigned char *flags, bool skip_oif)
+		     u8 family, unsigned char *flags, bool skip_oif)
 {
 	if (nhc->nhc_flags & RTNH_F_DEAD)
 		*flags |= RTNH_F_DEAD;
@@ -1613,7 +1613,7 @@ int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nhc,
 		/* if gateway family does not match nexthop family
 		 * gateway is encoded as RTA_VIA
 		 */
-		if (nhc->nhc_gw_family != nhc->nhc_family) {
+		if (family != nhc->nhc_gw_family) {
 			int alen = sizeof(struct in6_addr);
 			struct nlattr *nla;
 			struct rtvia *via;
@@ -1654,7 +1654,7 @@ EXPORT_SYMBOL_GPL(fib_nexthop_info);
 
 #if IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) || IS_ENABLED(CONFIG_IPV6)
 int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
-		    int nh_weight)
+		    int nh_weight, u8 family)
 {
 	const struct net_device *dev = nhc->nhc_dev;
 	struct rtnexthop *rtnh;
@@ -1667,7 +1667,7 @@ int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
 	rtnh->rtnh_hops = nh_weight - 1;
 	rtnh->rtnh_ifindex = dev ? dev->ifindex : 0;
 
-	if (fib_nexthop_info(skb, nhc, &flags, true) < 0)
+	if (fib_nexthop_info(skb, nhc, family, &flags, true) < 0)
 		goto nla_put_failure;
 
 	rtnh->rtnh_flags = flags;
@@ -1684,7 +1684,8 @@ EXPORT_SYMBOL_GPL(fib_add_nexthop);
 #endif
 
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
-static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
+static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi,
+			     u8 family)
 {
 	struct nlattr *mp;
 
@@ -1699,7 +1700,8 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 	}
 
 	for_nexthops(fi) {
-		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight) < 0)
+		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight,
+				    family) < 0)
 			goto nla_put_failure;
 #ifdef CONFIG_IP_ROUTE_CLASSID
 		if (nh->nh_tclassid &&
@@ -1717,7 +1719,8 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 	return -EMSGSIZE;
 }
 #else
-static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
+static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi,
+			     u8 family)
 {
 	return 0;
 }
@@ -1775,7 +1778,7 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 		const struct fib_nh_common *nhc = fib_info_nhc(fi, 0);
 		unsigned char flags = 0;
 
-		if (fib_nexthop_info(skb, nhc, &flags, false) < 0)
+		if (fib_nexthop_info(skb, nhc, AF_INET, &flags, false) < 0)
 			goto nla_put_failure;
 
 		rtm->rtm_flags = flags;
@@ -1790,7 +1793,7 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 		}
 #endif
 	} else {
-		if (fib_add_multipath(skb, fi) < 0)
+		if (fib_add_multipath(skb, fi, AF_INET) < 0)
 			goto nla_put_failure;
 	}
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index fd059e08785a..d91dd8d832cd 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5337,7 +5337,7 @@ static int rt6_fill_node_nexthop(struct sk_buff *skb, struct nexthop *nh,
 		struct fib6_nh *fib6_nh;
 
 		fib6_nh = nexthop_fib6_nh(nh);
-		if (fib_nexthop_info(skb, &fib6_nh->nh_common,
+		if (fib_nexthop_info(skb, &fib6_nh->nh_common, AF_INET6,
 				     flags, false) < 0)
 			goto nla_put_failure;
 	}
@@ -5466,13 +5466,14 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 			goto nla_put_failure;
 
 		if (fib_add_nexthop(skb, &rt->fib6_nh->nh_common,
-				    rt->fib6_nh->fib_nh_weight) < 0)
+				    rt->fib6_nh->fib_nh_weight, AF_INET6) < 0)
 			goto nla_put_failure;
 
 		list_for_each_entry_safe(sibling, next_sibling,
 					 &rt->fib6_siblings, fib6_siblings) {
 			if (fib_add_nexthop(skb, &sibling->fib6_nh->nh_common,
-					    sibling->fib6_nh->fib_nh_weight) < 0)
+					    sibling->fib6_nh->fib_nh_weight,
+					    AF_INET6) < 0)
 				goto nla_put_failure;
 		}
 
@@ -5489,7 +5490,7 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 
 		rtm->rtm_flags |= nh_flags;
 	} else {
-		if (fib_nexthop_info(skb, &rt->fib6_nh->nh_common,
+		if (fib_nexthop_info(skb, &rt->fib6_nh->nh_common, AF_INET6,
 				     &nh_flags, false) < 0)
 			goto nla_put_failure;
 
-- 
2.21.0

