Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43127367C5
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfFEXPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbfFEXP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 19:15:27 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 238102089E;
        Wed,  5 Jun 2019 23:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559776526;
        bh=rmOqXT1vCeK45bjv2OP1IQgR/ZNIyhkyzeyTCu0pRaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJYFey3AR4t5I2O8FRZdWUZylHzxl1yHo50Wrn188Um1QT0CLygW9alhmPizTjn+i
         dOYLHA7YgQyZYVj2VcX7ncuyvPQ1BghAlQJgiiYDMiyUwaYkvRNWd9SV79WC3INvxL
         f2uis/oQXFZyE5ZmOAf5VyrA7w8Ke+94NpO9wDGQ=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 05/19] ipv6: Handle all fib6_nh in a nexthop in rt6_nlmsg_size
Date:   Wed,  5 Jun 2019 16:15:09 -0700
Message-Id: <20190605231523.18424-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190605231523.18424-1-dsahern@kernel.org>
References: <20190605231523.18424-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add a hook in rt6_nlmsg_size to handle nexthop struct in a fib6_info.
rt6_nh_nlmsg_size is used to sum the space needed for all nexthops in
the fib entry.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 49 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f04f2992e097..aaa10e716115 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -104,7 +104,7 @@ static void		rt6_do_redirect(struct dst_entry *dst, struct sock *sk,
 					struct sk_buff *skb);
 static int rt6_score_route(const struct fib6_nh *nh, u32 fib6_flags, int oif,
 			   int strict);
-static size_t rt6_nlmsg_size(struct fib6_info *rt);
+static size_t rt6_nlmsg_size(struct fib6_info *f6i);
 static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 			 struct fib6_info *rt, struct dst_entry *dst,
 			 struct in6_addr *dest, struct in6_addr *src,
@@ -4939,20 +4939,46 @@ static int inet6_rtm_newroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return ip6_route_add(&cfg, GFP_KERNEL, extack);
 }
 
-static size_t rt6_nlmsg_size(struct fib6_info *rt)
+/* add the overhead of this fib6_nh to nexthop_len */
+static int rt6_nh_nlmsg_size(struct fib6_nh *nh, void *arg)
 {
-	int nexthop_len = 0;
+	int *nexthop_len = arg;
 
-	if (rt->nh)
-		nexthop_len += nla_total_size(4); /* RTA_NH_ID */
+	*nexthop_len += nla_total_size(0)	 /* RTA_MULTIPATH */
+		     + NLA_ALIGN(sizeof(struct rtnexthop))
+		     + nla_total_size(16); /* RTA_GATEWAY */
+
+	if (nh->fib_nh_lws) {
+		/* RTA_ENCAP_TYPE */
+		*nexthop_len += lwtunnel_get_encap_size(nh->fib_nh_lws);
+		/* RTA_ENCAP */
+		*nexthop_len += nla_total_size(2);
+	}
 
-	if (rt->fib6_nsiblings) {
-		nexthop_len = nla_total_size(0)	 /* RTA_MULTIPATH */
-			    + NLA_ALIGN(sizeof(struct rtnexthop))
-			    + nla_total_size(16) /* RTA_GATEWAY */
-			    + lwtunnel_get_encap_size(rt->fib6_nh->fib_nh_lws);
+	return 0;
+}
 
-		nexthop_len *= rt->fib6_nsiblings;
+static size_t rt6_nlmsg_size(struct fib6_info *f6i)
+{
+	int nexthop_len;
+
+	if (f6i->nh) {
+		nexthop_len = nla_total_size(4); /* RTA_NH_ID */
+		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_nlmsg_size,
+					 &nexthop_len);
+	} else {
+		struct fib6_nh *nh = f6i->fib6_nh;
+
+		nexthop_len = 0;
+		if (f6i->fib6_nsiblings) {
+			nexthop_len = nla_total_size(0)	 /* RTA_MULTIPATH */
+				    + NLA_ALIGN(sizeof(struct rtnexthop))
+				    + nla_total_size(16) /* RTA_GATEWAY */
+				    + lwtunnel_get_encap_size(nh->fib_nh_lws);
+
+			nexthop_len *= f6i->fib6_nsiblings;
+		}
+		nexthop_len += lwtunnel_get_encap_size(nh->fib_nh_lws);
 	}
 
 	return NLMSG_ALIGN(sizeof(struct rtmsg))
@@ -4968,7 +4994,6 @@ static size_t rt6_nlmsg_size(struct fib6_info *rt)
 	       + nla_total_size(sizeof(struct rta_cacheinfo))
 	       + nla_total_size(TCP_CA_NAME_MAX) /* RTAX_CC_ALGO */
 	       + nla_total_size(1) /* RTA_PREF */
-	       + lwtunnel_get_encap_size(rt->fib6_nh->fib_nh_lws)
 	       + nexthop_len;
 }
 
-- 
2.11.0

