Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1AF7E541
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 00:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfHAWQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 18:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfHAWQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 18:16:33 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BC17206A2;
        Thu,  1 Aug 2019 22:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564697792;
        bh=fqqayFyC33lEJLzY7Ft0cfEwaGcQuKnROYxC/WGom8U=;
        h=From:To:Cc:Subject:Date:From;
        b=MFTwdmt5A3GILzjnOVACTeJRxyLb6yUHwHtnt+9ht9cL5W35221BxAK6cFYTzB+ME
         /8DO3vNDzDIVQgAECGGIi7yaXT7oc9XyLKhT6PE561W1JsT9dYXX+OE3UAC3pkybP3
         X1nNZBsSwTQsXRScDcRvlW5ZvRU1medDtGMEMUtc=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] ipv6: have a single rcu unlock point in __ip6_rt_update_pmtu
Date:   Thu,  1 Aug 2019 15:18:08 -0700
Message-Id: <20190801221808.18321-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Simplify the unlock path in __ip6_rt_update_pmtu by using a
single point where rcu_read_unlock is called.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e49fec767a10..3c5c331b50f1 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2725,10 +2725,9 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 
 		rcu_read_lock();
 		res.f6i = rcu_dereference(rt6->from);
-		if (!res.f6i) {
-			rcu_read_unlock();
-			return;
-		}
+		if (!res.f6i)
+			goto out_unlock;
+
 		res.fib6_flags = res.f6i->fib6_flags;
 		res.fib6_type = res.f6i->fib6_type;
 
@@ -2744,10 +2743,8 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 			/* fib6_info uses a nexthop that does not have fib6_nh
 			 * using the dst->dev + gw. Should be impossible.
 			 */
-			if (!arg.match) {
-				rcu_read_unlock();
-				return;
-			}
+			if (!arg.match)
+				goto out_unlock;
 
 			res.nh = arg.match;
 		} else {
@@ -2760,6 +2757,7 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 			if (rt6_insert_exception(nrt6, &res))
 				dst_release_immediate(&nrt6->dst);
 		}
+out_unlock:
 		rcu_read_unlock();
 	}
 }
-- 
2.11.0

