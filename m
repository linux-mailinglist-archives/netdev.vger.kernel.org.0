Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 015D3367BD
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfFEXPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbfFEXP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 19:15:28 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CE06208CB;
        Wed,  5 Jun 2019 23:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559776527;
        bh=y+MmdquF+gp+eAEbi5EhHVgx2S9+c6R9Jjq/hYSn5KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfdKnZCIiHWF6FdSEMiSpegl59mAfgMwTZtGNLVR58yTH/Q3uhzTfn7U/JxOSp62h
         xFM+LBkciFX/iemfQeqtwUmstBSUAk2hR2C9GIkG21JD5939o8IQzx3GKyofzThblI
         xq8DAZ1UiF19ZICxcmCU8ZXZx7MLKhzCqZD8p7e8=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 10/19] ipv6: Handle all fib6_nh in a nexthop in mtu updates
Date:   Wed,  5 Jun 2019 16:15:14 -0700
Message-Id: <20190605231523.18424-11-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190605231523.18424-1-dsahern@kernel.org>
References: <20190605231523.18424-1-dsahern@kernel.org>
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
index 5e922b79a9bf..6f4b5fa6159b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2681,10 +2681,31 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
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
@@ -4652,6 +4673,12 @@ static int rt6_mtu_change_route(struct fib6_info *f6i, void *p_arg)
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

