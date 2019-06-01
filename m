Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6240031958
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfFADgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfFADgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:36:23 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36F12270E8;
        Sat,  1 Jun 2019 03:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559360183;
        bh=vK4qSXdVzl6OFiPqMR/nzyBB1G1nEb8BxFbjt0bjVa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoEnWP39V6ThFY64mh4hxt/fnwkuGz0aRqWY8YSF1IVKgMp/juxSd2yuxXD0dbFA+
         qbmTEhPs/l8o52w9Eg2/uGX8Ba/eaojA5USZltVpdJ9gpeRZY2wfy9dqk6VW6/v79r
         s0cCyDZVpIgvnJE/qqFZPfkYyfTtTCSxzfxyryi0=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next 16/27] ipv6: Handle all fib6_nh in a nexthop in rt6_do_redirect
Date:   Fri, 31 May 2019 20:36:07 -0700
Message-Id: <20190601033618.27702-17-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601033618.27702-1-dsahern@kernel.org>
References: <20190601033618.27702-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Use nexthop_for_each_fib6_nh and fib6_nh_find_match to find the
fib6_nh in a nexthop that correlates to the device and gateway
in the rt6_info.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index fbbceca19e50..bf682ab05044 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3909,7 +3909,25 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
 	if (!res.f6i)
 		goto out;
 
-	res.nh = res.f6i->fib6_nh;
+	if (res.f6i->nh) {
+		struct fib6_nh_match_arg arg = {
+			.dev = dst->dev,
+			.gw = &rt->rt6i_gateway,
+		};
+
+		nexthop_for_each_fib6_nh(res.f6i->nh,
+					 fib6_nh_find_match, &arg);
+
+		/* fib6_info uses a nexthop that does not have fib6_nh
+		 * using the dst->dev. Should be impossible
+		 */
+		if (!arg.match)
+			return;
+		res.nh = arg.match;
+	} else {
+		res.nh = res.f6i->fib6_nh;
+	}
+
 	res.fib6_flags = res.f6i->fib6_flags;
 	res.fib6_type = res.f6i->fib6_type;
 	nrt = ip6_rt_cache_alloc(&res, &msg->dest, NULL);
-- 
2.11.0

