Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3377A8888
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbfIDOMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:12:44 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46040 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730512AbfIDOMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 10:12:44 -0400
Received: by mail-qk1-f194.google.com with SMTP id z67so6799245qkb.12
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 07:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HCVSrh5CaGil4CrIRSDHr5+/6MHsCwlC6eXaPOqUITw=;
        b=Bg/S2zev4qsdoQ1psLQw2i8d0+r2gbuW1qAdrKmo94xEa3Moya5hsKK3af2/rXb885
         d/VIR77sCNXN5FTN4uLqDUBTax+/V7nKGciGPR1e651IK/X9vEuj9qMUY5G14JDxL6g/
         K6qMPznpDhvo2JQpk7Xsrm2XgkDqzSPcG1ziA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HCVSrh5CaGil4CrIRSDHr5+/6MHsCwlC6eXaPOqUITw=;
        b=MIXb/SpQTUekdVjWwYU2hlzf5IAgdjNSsj/woFeX3vACce3ol6aj+SeGyYi2NJVuOU
         C9HtQLTX371jBJdqWr2pCg5JjqMEP//Nyls6XQqD6bxgcxFJ4UKlnAR1X+USsbg6AWom
         BX6bHkl2CTEC3rBSoo8ZBMAIhMAkpLh8rW2+yRvl0C5WY3tcnpC/Yz0M2VSTiJMSH4eQ
         6Mdd3Evki/rIc2QAsosD4W9dXeEczibFAMGPcDJcE6DMx543MJPLcXtln+d/qMmLH3Lo
         q0CFkX1XqREoeZr6rvDU4n0KlMTwf5AoFiuZP7ZRkXqvsxTJtZMYxW+QQqRJWAzWLnZy
         uYQA==
X-Gm-Message-State: APjAAAXZA5AhrifSi2r52hQ0v5epwY9Vd8gfpBKa/W5EXNWWVf0QeVzf
        OGKeG0iddQH6j0rn5kpZB8yRaTKayek=
X-Google-Smtp-Source: APXvYqzzlovMvVFMTaEOFOP5sL8K5sEo/U7oVeEJ113UNfhsxr8lfkVX5A1hGv/udCwYU4vLVBTidw==
X-Received: by 2002:a37:7347:: with SMTP id o68mr37740310qkc.145.1567606361998;
        Wed, 04 Sep 2019 07:12:41 -0700 (PDT)
Received: from robot.nc.rr.com (cpe-2606-A000-111D-8179-B743-207D-F4F9-B992.dyn6.twc.com. [2606:a000:111d:8179:b743:207d:f4f9:b992])
        by smtp.googlemail.com with ESMTPSA id u28sm12117311qtu.22.2019.09.04.07.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 07:12:41 -0700 (PDT)
From:   Donald Sharp <sharpd@cumulusnetworks.com>
To:     netdev@vger.kernel.org, dsahern@kernel.org,
        sworley@cumulusnetworks.com
Subject: [PATCH v3 net] net: Properly update v4 routes with v6 nexthop
Date:   Wed,  4 Sep 2019 10:11:58 -0400
Message-Id: <20190904141158.17021-1-sharpd@cumulusnetworks.com>
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

v2, v3: Addresses code review comments from David Ahern

Fixes: dcb1ecb50edf (“ipv4: Prepare for fib6_nh from a nexthop object”)
Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
---
 include/net/ip_fib.h     |  4 ++--
 include/net/nexthop.h    |  5 +++--
 net/ipv4/fib_semantics.c | 15 ++++++++-------
 net/ipv6/route.c         | 11 ++++++-----
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 4c81846ccce8..ab1ca9e238d2 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -513,7 +513,7 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 			  struct netlink_callback *cb);
 
 int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nh,
-		     unsigned char *flags, bool skip_oif);
+		     u8 rt_family, unsigned char *flags, bool skip_oif);
 int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nh,
-		    int nh_weight);
+		    int nh_weight, u8 rt_family);
 #endif  /* _NET_FIB_H */
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 95f766c31c90..331ebbc94fe7 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -161,7 +161,8 @@ struct nexthop *nexthop_mpath_select(const struct nexthop *nh, int nhsel)
 }
 
 static inline
-int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh)
+int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh,
+			    u8 rt_family)
 {
 	struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
 	int i;
@@ -172,7 +173,7 @@ int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh)
 		struct fib_nh_common *nhc = &nhi->fib_nhc;
 		int weight = nhg->nh_entries[i].weight;
 
-		if (fib_add_nexthop(skb, nhc, weight) < 0)
+		if (fib_add_nexthop(skb, nhc, weight, rt_family) < 0)
 			return -EMSGSIZE;
 	}
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 2db089e10ba0..0913a090b2bf 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1582,7 +1582,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 }
 
 int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nhc,
-		     unsigned char *flags, bool skip_oif)
+		     u8 rt_family, unsigned char *flags, bool skip_oif)
 {
 	if (nhc->nhc_flags & RTNH_F_DEAD)
 		*flags |= RTNH_F_DEAD;
@@ -1613,7 +1613,7 @@ int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nhc,
 		/* if gateway family does not match nexthop family
 		 * gateway is encoded as RTA_VIA
 		 */
-		if (nhc->nhc_gw_family != nhc->nhc_family) {
+		if (rt_family != nhc->nhc_gw_family) {
 			int alen = sizeof(struct in6_addr);
 			struct nlattr *nla;
 			struct rtvia *via;
@@ -1654,7 +1654,7 @@ EXPORT_SYMBOL_GPL(fib_nexthop_info);
 
 #if IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) || IS_ENABLED(CONFIG_IPV6)
 int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
-		    int nh_weight)
+		    int nh_weight, u8 rt_family)
 {
 	const struct net_device *dev = nhc->nhc_dev;
 	struct rtnexthop *rtnh;
@@ -1667,7 +1667,7 @@ int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
 	rtnh->rtnh_hops = nh_weight - 1;
 	rtnh->rtnh_ifindex = dev ? dev->ifindex : 0;
 
-	if (fib_nexthop_info(skb, nhc, &flags, true) < 0)
+	if (fib_nexthop_info(skb, nhc, rt_family, &flags, true) < 0)
 		goto nla_put_failure;
 
 	rtnh->rtnh_flags = flags;
@@ -1693,13 +1693,14 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 		goto nla_put_failure;
 
 	if (unlikely(fi->nh)) {
-		if (nexthop_mpath_fill_node(skb, fi->nh) < 0)
+		if (nexthop_mpath_fill_node(skb, fi->nh, AF_INET) < 0)
 			goto nla_put_failure;
 		goto mp_end;
 	}
 
 	for_nexthops(fi) {
-		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight) < 0)
+		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight,
+				    AF_INET) < 0)
 			goto nla_put_failure;
 #ifdef CONFIG_IP_ROUTE_CLASSID
 		if (nh->nh_tclassid &&
@@ -1775,7 +1776,7 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 		const struct fib_nh_common *nhc = fib_info_nhc(fi, 0);
 		unsigned char flags = 0;
 
-		if (fib_nexthop_info(skb, nhc, &flags, false) < 0)
+		if (fib_nexthop_info(skb, nhc, AF_INET, &flags, false) < 0)
 			goto nla_put_failure;
 
 		rtm->rtm_flags = flags;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index fd059e08785a..cfb969e68d45 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5329,7 +5329,7 @@ static int rt6_fill_node_nexthop(struct sk_buff *skb, struct nexthop *nh,
 		if (!mp)
 			goto nla_put_failure;
 
-		if (nexthop_mpath_fill_node(skb, nh))
+		if (nexthop_mpath_fill_node(skb, nh, AF_INET6))
 			goto nla_put_failure;
 
 		nla_nest_end(skb, mp);
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

