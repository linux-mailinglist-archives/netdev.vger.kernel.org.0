Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7EE3A250
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 00:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbfFHWWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 18:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727818AbfFHWWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 18:22:24 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EB9521783;
        Sat,  8 Jun 2019 21:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560030826;
        bh=+qGLCndv5aJFQDsxNUND0TgI3YG3L01CbBkPzQOb5TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1gFdR6O8AcDWvEKs7dY6qDqJssmTr3TLT4vSZxmJk4yBiNOOJlWhHhOi7dLuFt5k
         KrI67xLVDXy4ZzlPQs7zzirm7g5ZnFPx5JPElGhmFi2ysQneAQaq155CkRua0A9nki
         eSUD6gfuwXc2K1ApIz4rHBpsD8eJw5W1ZvjJesCo=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 10/20] ipv6: Handle all fib6_nh in a nexthop in mtu updates
Date:   Sat,  8 Jun 2019 14:53:31 -0700
Message-Id: <20190608215341.26592-11-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190608215341.26592-1-dsahern@kernel.org>
References: <20190608215341.26592-1-dsahern@kernel.org>
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
index 715356e00f58..f287375fd0b2 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2679,10 +2679,31 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
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
@@ -4650,6 +4671,12 @@ static int rt6_mtu_change_route(struct fib6_info *f6i, void *p_arg)
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

