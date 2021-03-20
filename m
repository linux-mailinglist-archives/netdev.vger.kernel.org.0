Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73F234295D
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 01:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCTALx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 20:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhCTALf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 20:11:35 -0400
Received: from frotz.zork.net (frotz.zork.net [IPv6:2600:3c00:e000:35f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B775C061762
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 17:11:35 -0700 (PDT)
Received: by frotz.zork.net (Postfix, from userid 1008)
        id E238A119A8; Sat, 20 Mar 2021 00:02:21 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 frotz.zork.net E238A119A8
Date:   Fri, 19 Mar 2021 17:02:21 -0700
From:   Seth David Schoen <schoen@loyalty.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, gnu@toad.com,
        dave.taht@gmail.com
Subject: [PATCH net-next 1/2] ip: Treat IPv4 segment's lowest address as
 unicast
Message-ID: <20210320000221.GA10062@frotz.zork.net>
Mail-Followup-To: Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        gnu@toad.com, dave.taht@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Treat the lowest-numbered address in each IPv4 network
segment as unicast, not broadcast.

Signed-off-by: Seth David Schoen <schoen@loyalty.org>
Suggested-by: John Gilmore <gnu@toad.com>
Acked-by: Dave Taht <dave.taht@gmail.com>
---
 net/ipv4/fib_frontend.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 84bb707bd88d..bfb345c88271 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1122,10 +1122,8 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
 				  prefix, ifa->ifa_prefixlen, prim,
 				  ifa->ifa_rt_priority);
 
-		/* Add network specific broadcasts, when it takes a sense */
+		/* Add the network broadcast address, when it makes sense */
 		if (ifa->ifa_prefixlen < 31) {
-			fib_magic(RTM_NEWROUTE, RTN_BROADCAST, prefix, 32,
-				  prim, 0);
 			fib_magic(RTM_NEWROUTE, RTN_BROADCAST, prefix | ~mask,
 				  32, prim, 0);
 		}
-- 
2.25.1

