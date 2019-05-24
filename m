Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C352A08E
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404321AbfEXVnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404295AbfEXVnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 17:43:16 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA29D217D7;
        Fri, 24 May 2019 21:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558734194;
        bh=S2Q2KU8Ol+1UONDdZ6BHzDF3pqmN3wYHENdAVDbsvAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1f4Xy5jULegNjvtBZ6W2xYg9jwyn/OZKETn2PFMp7aiybeQpjaT9fZ+YM6Tx8RMGv
         Vsp6nYjBdpPAE9xW0ieY3j2l57M18Z9ozR0hGo7AOVal1QcbEihao8DvSVktfvXVde
         UT3ewcXHIR6a9HSvchTs2c38AR22Ynwm1VbsUhCs=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     sharpd@cumulusnetworks.com, sworley@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 4/6] nexthop: Add support for IPv6 gateways
Date:   Fri, 24 May 2019 14:43:06 -0700
Message-Id: <20190524214308.18615-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190524214308.18615-1-dsahern@kernel.org>
References: <20190524214308.18615-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Handle IPv6 gateway in a nexthop spec. If nh_family is set to AF_INET6,
NHA_GATEWAY is expected to be an IPv6 address. Add ipv6 option to gw in
nh_config to hold the address, add fib6_nh to nh_info to leverage the
ipv6 initialization and cleanup code. Update nh_fill_node to dump the v6
address.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/nexthop.h |  3 +++
 net/ipv4/nexthop.c    | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index c0e4b0d92c39..d188f16c0c4f 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -12,6 +12,7 @@
 #include <linux/netdevice.h>
 #include <linux/types.h>
 #include <net/ip_fib.h>
+#include <net/ip6_fib.h>
 #include <net/netlink.h>
 
 #define NEXTHOP_VALID_USER_FLAGS RTNH_F_ONLINK
@@ -31,6 +32,7 @@ struct nh_config {
 
 	union {
 		__be32		ipv4;
+		struct in6_addr	ipv6;
 	} gw;
 
 	u32		nlflags;
@@ -47,6 +49,7 @@ struct nh_info {
 	union {
 		struct fib_nh_common	fib_nhc;
 		struct fib_nh		fib_nh;
+		struct fib6_nh		fib6_nh;
 	};
 };
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 79c7b3461e19..f2b237a6735c 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -8,6 +8,7 @@
 #include <linux/nexthop.h>
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
+#include <net/ipv6_stubs.h>
 #include <net/nexthop.h>
 #include <net/route.h>
 #include <net/sock.h>
@@ -61,6 +62,9 @@ void nexthop_free_rcu(struct rcu_head *head)
 	case AF_INET:
 		fib_nh_release(nh->net, &nhi->fib_nh);
 		break;
+	case AF_INET6:
+		ipv6_stub->fib6_nh_release(&nhi->fib6_nh);
+		break;
 	}
 	kfree(nhi);
 
@@ -127,6 +131,7 @@ static u32 nh_find_unused_id(struct net *net)
 static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 			int event, u32 portid, u32 seq, unsigned int nlflags)
 {
+	struct fib6_nh *fib6_nh;
 	struct fib_nh *fib_nh;
 	struct nlmsghdr *nlh;
 	struct nh_info *nhi;
@@ -168,6 +173,13 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 		    nla_put_u32(skb, NHA_GATEWAY, fib_nh->fib_nh_gw4))
 			goto nla_put_failure;
 		break;
+
+	case AF_INET6:
+		fib6_nh = &nhi->fib6_nh;
+		if (fib6_nh->fib_nh_gw_family &&
+		    nla_put_in6_addr(skb, NHA_GATEWAY, &fib6_nh->fib_nh_gw6))
+			goto nla_put_failure;
+		break;
 	}
 
 out:
@@ -193,6 +205,12 @@ static size_t nh_nlmsg_size(struct nexthop *nh)
 		if (nhi->fib_nh.fib_nh_gw_family)
 			sz += nla_total_size(4);  /* NHA_GATEWAY */
 		break;
+
+	case AF_INET6:
+		/* NHA_GATEWAY */
+		if (nhi->fib6_nh.fib_nh_gw_family)
+			sz += nla_total_size(sizeof(const struct in6_addr));
+		break;
 	}
 
 	return sz;
@@ -374,6 +392,33 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 	return err;
 }
 
+static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
+			  struct nh_info *nhi, struct nh_config *cfg,
+			  struct netlink_ext_ack *extack)
+{
+	struct fib6_nh *fib6_nh = &nhi->fib6_nh;
+	struct fib6_config fib6_cfg = {
+		.fc_table = l3mdev_fib_table(cfg->dev),
+		.fc_ifindex = cfg->nh_ifindex,
+		.fc_gateway = cfg->gw.ipv6,
+		.fc_flags = cfg->nh_flags,
+	};
+	int err = -EINVAL;
+
+	if (!ipv6_addr_any(&cfg->gw.ipv6))
+		fib6_cfg.fc_flags |= RTF_GATEWAY;
+
+	/* sets nh_dev if successful */
+	err = ipv6_stub->fib6_nh_init(net, fib6_nh, &fib6_cfg, GFP_KERNEL,
+				      extack);
+	if (err)
+		ipv6_stub->fib6_nh_release(fib6_nh);
+	else
+		nh->nh_flags = fib6_nh->fib_nh_flags;
+
+	return err;
+}
+
 static struct nexthop *nexthop_create(struct net *net, struct nh_config *cfg,
 				      struct netlink_ext_ack *extack)
 {
@@ -407,6 +452,9 @@ static struct nexthop *nexthop_create(struct net *net, struct nh_config *cfg,
 	case AF_INET:
 		err = nh_create_ipv4(net, nh, nhi, cfg, extack);
 		break;
+	case AF_INET6:
+		err = nh_create_ipv6(net, nh, nhi, cfg, extack);
+		break;
 	}
 
 	if (err) {
@@ -487,6 +535,7 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 
 	switch (nhm->nh_family) {
 	case AF_INET:
+	case AF_INET6:
 		break;
 	default:
 		NL_SET_ERR_MSG(extack, "Invalid address family");
@@ -556,6 +605,13 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 			}
 			cfg->gw.ipv4 = nla_get_be32(gwa);
 			break;
+		case AF_INET6:
+			if (nla_len(gwa) != sizeof(struct in6_addr)) {
+				NL_SET_ERR_MSG(extack, "Invalid gateway");
+				goto out;
+			}
+			cfg->gw.ipv6 = nla_get_in6_addr(gwa);
+			break;
 		default:
 			NL_SET_ERR_MSG(extack,
 				       "Unknown address family for gateway");
-- 
2.11.0

