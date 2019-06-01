Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38EF53195B
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfFADgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbfFADgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:36:23 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F729270E7;
        Sat,  1 Jun 2019 03:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559360183;
        bh=XZg2Ssa5PNsTL4QRLkK6vYmNy4MnMShJOmWTQ4OWp4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XswaKa+YNP+R/PQ8lOZRA0yT7Y2F7gQXOPP5HHnOqK5qycNxQBe4hWRykeqbJeqvx
         ggEeD/C5aoq8kw6PLbQ+NcnGCfEIvJg7fUwjrGiLuSmPshedY4j+TDDSR3ltRgL40z
         lq7V1E2sSU2yrl8OQmp+4PV128cwbRG//KcOqb6M=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next 17/27] ipv6: Handle all fib6_nh in a nexthop in mtu updates
Date:   Fri, 31 May 2019 20:36:08 -0700
Message-Id: <20190601033618.27702-18-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601033618.27702-1-dsahern@kernel.org>
References: <20190601033618.27702-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Use nexthop_for_each_fib6_nh to call fib6_nh_mtu_change for each
fib6_nh in a nexthop for rt6_mtu_change_route. For __ip6_rt_update_pmtu,
we need to find the nexthop that correlates to the device and gateway
in the rt6_info.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index bf682ab05044..d967753bc75a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2690,10 +2690,31 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 			rcu_read_unlock();
 			return;
 		}
-		res.nh = res.f6i->fib6_nh;
 		res.fib6_flags = res.f6i->fib6_flags;
 		res.fib6_type = res.f6i->fib6_type;
 
+		if (res.f6i->nh) {
+			struct fib6_nh_match_arg arg = {
+				.dev = dst->dev,
+				.gw = &rt6->rt6i_gateway,
+			};
+
+			nexthop_for_each_fib6_nh(res.f6i->nh,
+						 fib6_nh_find_match, &arg);
+
+			/* fib6_info uses a nexthop that does not have fib6_nh
+			 * using the dst->dev + gw. Should be impossible.
+			 */
+			if (!arg.match) {
+				rcu_read_unlock();
+				return;
+			}
+
+			res.nh = arg.match;
+		} else {
+			res.nh = res.f6i->fib6_nh;
+		}
+
 		nrt6 = ip6_rt_cache_alloc(&res, daddr, saddr);
 		if (nrt6) {
 			rt6_do_update_pmtu(nrt6, mtu);
@@ -4660,6 +4681,12 @@ static int rt6_mtu_change_route(struct fib6_info *f6i, void *p_arg)
 		return 0;
 
 	arg->f6i = f6i;
+	if (f6i->nh) {
+		/* fib6_nh_mtu_change only returns 0, so this is safe */
+		return nexthop_for_each_fib6_nh(f6i->nh, fib6_nh_mtu_change,
+						arg);
+	}
+
 	return fib6_nh_mtu_change(f6i->fib6_nh, arg);
 }
 
-- 
2.11.0

