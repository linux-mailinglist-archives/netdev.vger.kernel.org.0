Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5520B38E7A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbfFGPJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:09:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729485AbfFGPJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:09:45 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C228F214C6;
        Fri,  7 Jun 2019 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559920184;
        bh=C1+wGeXgNDF+9FLVILtIpbHjcxHE+u2STjEyMpcdQNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZeEvOsFsz8BN3eJ91UwwagA9cBhmJQzD5htibCNcPquunymMYQD/djzJdPawukkw
         yWtFrrqt1yevu6bmH7f2z/f2XflELcBKWWMnBgUTW5mWauJJthm31DbsCsrTTphaSx
         +3NnpHmjUaxuCUwky4Bbr4hw2Yuf4lLW+pFIpIBo=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 09/20] ipv6: Handle all fib6_nh in a nexthop in rt6_do_redirect
Date:   Fri,  7 Jun 2019 08:09:30 -0700
Message-Id: <20190607150941.11371-10-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607150941.11371-1-dsahern@kernel.org>
References: <20190607150941.11371-1-dsahern@kernel.org>
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
index 20bb19d4141e..098d3618ceb9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3901,7 +3901,25 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
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

