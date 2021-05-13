Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A5237F25F
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 06:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhEMEji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 00:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbhEMEjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 00:39:36 -0400
Received: from frotz.zork.net (frotz.zork.net [IPv6:2600:3c00:e000:35f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA1BC061574
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 21:38:26 -0700 (PDT)
Received: by frotz.zork.net (Postfix, from userid 1008)
        id 00F5E119A9; Thu, 13 May 2021 04:38:25 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 frotz.zork.net 00F5E119A9
Date:   Wed, 12 May 2021 21:38:25 -0700
From:   Seth David Schoen <schoen@loyalty.org>
To:     netdev@vger.kernel.org
Cc:     John Gilmore <gnu@toad.com>, Dave Taht <dave.taht@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [RESEND PATCH net-next 2/2] selftests: Lowest IPv4 address in a
 subnet is valid
Message-ID: <20210513043825.GN1047389@frotz.zork.net>
Mail-Followup-To: Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, John Gilmore <gnu@toad.com>,
        Dave Taht <dave.taht@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
References: <20210513043625.GL1047389@frotz.zork.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513043625.GL1047389@frotz.zork.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expect the lowest IPv4 address in a subnet to be assignable
and addressable as a unicast (non-broadcast) address on a
local network segment.

Signed-off-by: Seth David Schoen <schoen@loyalty.org>
Suggested-by: John Gilmore <gnu@toad.com>
Acked-by: Dave Taht <dave.taht@gmail.com>
---
 .../testing/selftests/net/unicast_extensions.sh | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/unicast_extensions.sh b/tools/testing/selftests/net/unicast_extensions.sh
index dbf0421986df..66354cdd5ce4 100755
--- a/tools/testing/selftests/net/unicast_extensions.sh
+++ b/tools/testing/selftests/net/unicast_extensions.sh
@@ -189,6 +189,15 @@ segmenttest 255.255.255.1 255.255.255.254 24 "assign and ping inside 255.255.255
 route_test 240.5.6.7 240.5.6.1  255.1.2.1    255.1.2.3      24 "route between 240.5.6/24 and 255.1.2/24 (is allowed)"
 route_test 0.200.6.7 0.200.38.1 245.99.101.1 245.99.200.111 16 "route between 0.200/16 and 245.99/16 (is allowed)"
 #
+# Test support for lowest address ending in .0
+segmenttest 5.10.15.20 5.10.15.0 24 "assign and ping lowest address (/24)"
+#
+# Test support for lowest address not ending in .0
+segmenttest 192.168.101.192 192.168.101.193 26 "assign and ping lowest address (/26)"
+#
+# Routing using lowest address as a gateway/endpoint
+route_test 192.168.42.1 192.168.42.0 9.8.7.6 9.8.7.0 24 "routing using lowest address"
+#
 # ==============================================
 # ==== TESTS THAT CURRENTLY EXPECT FAILURE =====
 # ==============================================
@@ -202,14 +211,6 @@ segmenttest 255.255.255.1 255.255.255.255 16 "assigning 255.255.255.255 (is forb
 # Currently Linux does not allow this, so this should fail too
 segmenttest 127.99.4.5 127.99.4.6 16 "assign and ping inside 127/8 (is forbidden)"
 #
-# Test support for lowest address
-# Currently Linux does not allow this, so this should fail too
-segmenttest 5.10.15.20 5.10.15.0 24 "assign and ping lowest address (is forbidden)"
-#
-# Routing using lowest address as a gateway/endpoint
-# Currently Linux does not allow this, so this should fail too
-route_test 192.168.42.1 192.168.42.0 9.8.7.6 9.8.7.0 24 "routing using lowest address (is forbidden)"
-#
 # Test support for unicast use of class D
 # Currently Linux does not allow this, so this should fail too
 segmenttest 225.1.2.3 225.1.2.200 24 "assign and ping class D address (is forbidden)"
-- 
2.25.1

