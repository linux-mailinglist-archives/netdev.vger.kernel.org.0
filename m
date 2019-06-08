Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14453A252
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 00:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbfFHWWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 18:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbfFHWWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 18:22:24 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACE6A21744;
        Sat,  8 Jun 2019 21:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560030825;
        bh=cfr6gRJzXFUeK9XD4j/EyhUWlNtlnqvoMBY7p8phJjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgFbLMTqiLczWPmp2BFqxupG9Fi3ZnoBiEBMBd3ht7ft1CvbrleHmm3U2A8Frqehc
         RBqM9qVS2slgbUOZWL8l2lyR1d6Jsx7i+ZVRPaR2ESQl9u4FrpfUgq5r6D1erA+sKC
         EiXEJDv5h9sUBav5rReAohgkFDY/8qUoIbt7NjGQ=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 08/20] ipv6: Handle all fib6_nh in a nexthop in __ip6_route_redirect
Date:   Sat,  8 Jun 2019 14:53:29 -0700
Message-Id: <20190608215341.26592-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190608215341.26592-1-dsahern@kernel.org>
References: <20190608215341.26592-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add a hook in __ip6_route_redirect to handle a nexthop struct in a
fib6_info. Use nexthop_for_each_fib6_nh and fib6_nh_redirect_match
to call ip6_redirect_nh_match for each fib6_nh looking for a match.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index dadb160956c0..06498f6fa606 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2789,6 +2789,21 @@ static bool ip6_redirect_nh_match(const struct fib6_result *res,
 	return true;
 }
 
+struct fib6_nh_rd_arg {
+	struct fib6_result	*res;
+	struct flowi6		*fl6;
+	const struct in6_addr	*gw;
+	struct rt6_info		**ret;
+};
+
+static int fib6_nh_redirect_match(struct fib6_nh *nh, void *_arg)
+{
+	struct fib6_nh_rd_arg *arg = _arg;
+
+	arg->res->nh = nh;
+	return ip6_redirect_nh_match(arg->res, arg->fl6, arg->gw, arg->ret);
+}
+
 /* Handle redirects */
 struct ip6rd_flowi {
 	struct flowi6 fl6;
@@ -2804,6 +2819,12 @@ static struct rt6_info *__ip6_route_redirect(struct net *net,
 	struct ip6rd_flowi *rdfl = (struct ip6rd_flowi *)fl6;
 	struct rt6_info *ret = NULL;
 	struct fib6_result res = {};
+	struct fib6_nh_rd_arg arg = {
+		.res = &res,
+		.fl6 = fl6,
+		.gw  = &rdfl->gateway,
+		.ret = &ret
+	};
 	struct fib6_info *rt;
 	struct fib6_node *fn;
 
@@ -2828,14 +2849,24 @@ static struct rt6_info *__ip6_route_redirect(struct net *net,
 restart:
 	for_each_fib6_node_rt_rcu(fn) {
 		res.f6i = rt;
-		res.nh = rt->fib6_nh;
-
 		if (fib6_check_expired(rt))
 			continue;
 		if (rt->fib6_flags & RTF_REJECT)
 			break;
-		if (ip6_redirect_nh_match(&res, fl6, &rdfl->gateway, &ret))
-			goto out;
+		if (unlikely(rt->nh)) {
+			if (nexthop_is_blackhole(rt->nh))
+				continue;
+			/* on match, res->nh is filled in and potentially ret */
+			if (nexthop_for_each_fib6_nh(rt->nh,
+						     fib6_nh_redirect_match,
+						     &arg))
+				goto out;
+		} else {
+			res.nh = rt->fib6_nh;
+			if (ip6_redirect_nh_match(&res, fl6, &rdfl->gateway,
+						  &ret))
+				goto out;
+		}
 	}
 
 	if (!rt)
-- 
2.11.0

