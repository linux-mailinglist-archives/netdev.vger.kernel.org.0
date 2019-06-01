Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3163195A
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfFADgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbfFADgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:36:23 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45E23270E3;
        Sat,  1 Jun 2019 03:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559360182;
        bh=3gdhLkHIHbdvGJ19+x/gg0t8MI8v/p67JlVaxFyG05I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmEiIxb+yPuSSNkd0pdtNJjei05iNMgOzgg4u1i+Gh4VW1PJ73ttX3ONBGbUcTjhu
         PdFJBS77z6dyf4t647fk2ABdfUOaKxZFn+dZhDauX0UKt5bM8OV2xY9mbIJRWh2JT7
         R18uSLkinM2AZeLY4v/G5/hB3sxkIvXvB80Xe9e0=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next 12/27] ipv6: Handle all fib6_nh in a nexthop in rt6_nlmsg_size
Date:   Fri, 31 May 2019 20:36:03 -0700
Message-Id: <20190601033618.27702-13-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601033618.27702-1-dsahern@kernel.org>
References: <20190601033618.27702-1-dsahern@kernel.org>
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
index cf5e2ec9fb84..0c9ba144b8d0 100644
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
@@ -4947,20 +4947,46 @@ static int inet6_rtm_newroute(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -4976,7 +5002,6 @@ static size_t rt6_nlmsg_size(struct fib6_info *rt)
 	       + nla_total_size(sizeof(struct rta_cacheinfo))
 	       + nla_total_size(TCP_CA_NAME_MAX) /* RTAX_CC_ALGO */
 	       + nla_total_size(1) /* RTA_PREF */
-	       + lwtunnel_get_encap_size(rt->fib6_nh->fib_nh_lws)
 	       + nexthop_len;
 }
 
-- 
2.11.0

