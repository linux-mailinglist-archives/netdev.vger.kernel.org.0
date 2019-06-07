Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F8D3995C
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 01:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731658AbfFGXGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 19:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730926AbfFGXGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 19:06:14 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10CE02147A;
        Fri,  7 Jun 2019 23:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559948774;
        bh=pl7mNVGh7bdfSjJ5JhPOOQpdMgth4k01xj+KQnv9Sxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozR5ejRfgNL04wvpzXxACtFgRqjo2WXupVMllsXkql1NBCvd55TeaRg0aDgZZbDxI
         jmlyK+KZa7nrucf1bnfSJpcxoYb6SXg6v0SGa23aWnC7gM28sFGwdZ3IHiJELocFV9
         KS0AUBR9YA2vgfgovhlySLrKNH/bjoVfo3Fg1vrw=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 net-next 09/20] ipv6: Handle all fib6_nh in a nexthop in rt6_do_redirect
Date:   Fri,  7 Jun 2019 16:05:59 -0700
Message-Id: <20190607230610.10349-10-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607230610.10349-1-dsahern@kernel.org>
References: <20190607230610.10349-1-dsahern@kernel.org>
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
index 2eb6754c6d11..1c6cff699a76 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3903,7 +3903,25 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
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

