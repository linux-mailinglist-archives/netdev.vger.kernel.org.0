Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C0E367C2
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfFEXP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbfFEXP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 19:15:27 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53A37208E3;
        Wed,  5 Jun 2019 23:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559776527;
        bh=HdMEuwWCSGpZw1Np1C3jFhEpvYX/ms2rteLAmy353PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AeCsxiij8m0TS81Y2XUOSi3pJoL16/YCorGjj9Q3lPsqVaCanAWK1iuYRgLsQEYjg
         qA1RLlpGj/4eMZWASk2bv32Q0Da2SopmlANzxvLKbPg7tfpUGXIGdC1cB57pYVtiC9
         sb2Y5zZJHlkA/Brei/5tkTlWrhYIHt7zvMWUW3vk=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 09/19] ipv6: Handle all fib6_nh in a nexthop in rt6_do_redirect
Date:   Wed,  5 Jun 2019 16:15:13 -0700
Message-Id: <20190605231523.18424-10-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190605231523.18424-1-dsahern@kernel.org>
References: <20190605231523.18424-1-dsahern@kernel.org>
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
index 15d9dad7e070..5e922b79a9bf 100644
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

