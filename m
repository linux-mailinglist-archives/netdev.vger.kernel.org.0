Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF492FBC9
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 16:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfD3Ooq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 10:44:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727004AbfD3Oop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 10:44:45 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7AD421734;
        Tue, 30 Apr 2019 14:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556635485;
        bh=+oz9UNLBX2CspJoyrnCD9bAcLA21638rBFspp6oVFME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8mlAMsXtH3aqzjaZjp/C0X3IkzhcYNJpHUKba+31VplYO3WApdpHb1w41qkij+kQ
         cy7efJ3syUPPDtDZdKfCxKxECsehGMXscC36Tlcu3DXvYSixHLkBOGd9KYIcqDk5km
         C7OExBowkxIXFwb9PbkUWRwcUneKl0C04efshefo=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 2/3] ipv4: Pass fib_nh_common to rt_cache_route
Date:   Tue, 30 Apr 2019 07:45:49 -0700
Message-Id: <20190430144550.15033-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190430144550.15033-1-dsahern@kernel.org>
References: <20190430144550.15033-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Now that the cached routes are in fib_nh_common, pass it to
rt_cache_route and simplify its callers. For rt_set_nexthop,
the tclassid becomes the last user of fib_nh so move the
container_of under the #ifdef CONFIG_IP_ROUTE_CLASSID.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/route.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 662ac9bd956e..9b50d0440940 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1470,9 +1470,8 @@ static bool rt_bind_exception(struct rtable *rt, struct fib_nh_exception *fnhe,
 	return ret;
 }
 
-static bool rt_cache_route(struct fib_nh *nh, struct rtable *rt)
+static bool rt_cache_route(struct fib_nh_common *nhc, struct rtable *rt)
 {
-	struct fib_nh_common *nhc = &nh->nh_common;
 	struct rtable *orig, *prev, **p;
 	bool ret = true;
 
@@ -1576,7 +1575,6 @@ static void rt_set_nexthop(struct rtable *rt, __be32 daddr,
 
 	if (fi) {
 		struct fib_nh_common *nhc = FIB_RES_NHC(*res);
-		struct fib_nh *nh;
 
 		if (nhc->nhc_gw_family && nhc->nhc_scope == RT_SCOPE_LINK) {
 			rt->rt_gw_family = nhc->nhc_gw_family;
@@ -1589,15 +1587,19 @@ static void rt_set_nexthop(struct rtable *rt, __be32 daddr,
 
 		ip_dst_init_metrics(&rt->dst, fi->fib_metrics);
 
-		nh = container_of(nhc, struct fib_nh, nh_common);
 #ifdef CONFIG_IP_ROUTE_CLASSID
-		rt->dst.tclassid = nh->nh_tclassid;
+		{
+			struct fib_nh *nh;
+
+			nh = container_of(nhc, struct fib_nh, nh_common);
+			rt->dst.tclassid = nh->nh_tclassid;
+		}
 #endif
-		rt->dst.lwtstate = lwtstate_get(nh->fib_nh_lws);
+		rt->dst.lwtstate = lwtstate_get(nhc->nhc_lwtstate);
 		if (unlikely(fnhe))
 			cached = rt_bind_exception(rt, fnhe, daddr, do_cache);
 		else if (do_cache)
-			cached = rt_cache_route(nh, rt);
+			cached = rt_cache_route(nhc, rt);
 		if (unlikely(!cached)) {
 			/* Routes we intend to cache in nexthop exception or
 			 * FIB nexthop have the DST_NOCACHE bit clear.
@@ -2139,7 +2141,6 @@ out:	return err;
 
 	if (do_cache) {
 		struct fib_nh_common *nhc = FIB_RES_NHC(*res);
-		struct fib_nh *nh;
 
 		rth->dst.lwtstate = lwtstate_get(nhc->nhc_lwtstate);
 		if (lwtunnel_input_redirect(rth->dst.lwtstate)) {
@@ -2148,8 +2149,7 @@ out:	return err;
 			rth->dst.input = lwtunnel_input;
 		}
 
-		nh = container_of(nhc, struct fib_nh, nh_common);
-		if (unlikely(!rt_cache_route(nh, rth)))
+		if (unlikely(!rt_cache_route(nhc, rth)))
 			rt_add_uncached_list(rth);
 	}
 	skb_dst_set(skb, &rth->dst);
-- 
2.11.0

