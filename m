Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2939A374BE2
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 01:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhEEX3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 19:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhEEX3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 19:29:11 -0400
Received: from frotz.zork.net (frotz.zork.net [IPv6:2600:3c00:e000:35f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A523FC061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 16:28:14 -0700 (PDT)
Received: by frotz.zork.net (Postfix, from userid 1008)
        id 2B1D11199F; Wed,  5 May 2021 23:28:12 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 frotz.zork.net 2B1D11199F
Date:   Wed, 5 May 2021 16:28:12 -0700
From:   Seth David Schoen <schoen@loyalty.org>
To:     netdev@vger.kernel.org
Cc:     gnu@toad.com, dave.taht@gmail.com
Subject: [RESEND PATCH net-next 1/2] ip: Treat IPv4 segment's lowest address
 as unicast
Message-ID: <20210505232812.GQ2734@frotz.zork.net>
Mail-Followup-To: Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, gnu@toad.com, dave.taht@gmail.com
References: <20210505232508.GA1040923@frotz.zork.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505232508.GA1040923@frotz.zork.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Treat only the highest, not the lowest, IPv4 address within a local
subnet as a broadcast address.

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

