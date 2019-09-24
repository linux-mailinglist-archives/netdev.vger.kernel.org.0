Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D35D7BC9A0
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405753AbfIXOBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 10:01:36 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:54159 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfIXOBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 10:01:36 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 631b8b0a;
        Tue, 24 Sep 2019 13:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=Ni0hMWlCiFMnaQshc8kXJTh4/
        bA=; b=H7wz64VDaOrxEUv3s1Ld0Cxy5fxjQ7KDf3qDpuwvJWYtNDFt3ZOoJrMbC
        +VqSW6VXZG/sGw36U8i5a1LZBEVod3YhBIIuKOT7fuWAbe+YoF0Ii/mkuyUXPpLb
        bKeiyEWoUlR4gxE5yTTcO2TNE4bjON9h/pVWs+ax0xr7Z+3pSEffUBsmRtm7zZ5k
        5tnqb0NDzl44j7+o1E3TBKCgCNUi8x9QVr45dtJAcagJnUkPDsR5GsA1RxW2dhu4
        Rz2TkKCiQCYihPKYSNCFbY788kGurMsV9BXZ1trgo6IZkm2xMDPzgPTUar8MQ4t8
        CfZQsAJPoOoJGIJSgO/oyZvKmlizA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 44093bc1 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 24 Sep 2019 13:15:56 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, weiwan@google.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH v2] ipv6: do not free rt if FIB_LOOKUP_NOREF is set on suppress rule
Date:   Tue, 24 Sep 2019 16:01:28 +0200
Message-Id: <20190924140128.19394-1-Jason@zx2c4.com>
In-Reply-To: <20190924.145257.2013712373872209531.davem@davemloft.net>
References: <20190924.145257.2013712373872209531.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7d9e5f422150 removed references from certain dsts, but accounting
for this never translated down into the fib6 suppression code. This bug
was triggered by WireGuard users who use wg-quick(8), which uses the
"suppress-prefix" directive to ip-rule(8) for routing all of their
internet traffic without routing loops. The test case added here
causes the reference underflow by causing packets to evaluate a suppress
rule.

Cc: stable@vger.kernel.org
Fixes: 7d9e5f422150 ("ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/ipv6/fib6_rules.c                    |  3 ++-
 tools/testing/selftests/net/fib_tests.sh | 17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index d22b6c140f23..f9e8fe3ff0c5 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -287,7 +287,8 @@ static bool fib6_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg
 	return false;
 
 suppress_route:
-	ip6_rt_put(rt);
+	if (!(arg->flags & FIB_LOOKUP_NOREF))
+		ip6_rt_put(rt);
 	return true;
 }
 
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 4465fc2dae14..c2c5f2bf0f95 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -9,7 +9,7 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-TESTS="unregister down carrier nexthop ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter"
+TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter"
 
 VERBOSE=0
 PAUSE_ON_FAIL=no
@@ -614,6 +614,20 @@ fib_nexthop_test()
 	cleanup
 }
 
+fib_suppress_test()
+{
+	$IP link add dummy1 type dummy
+	$IP link set dummy1 up
+	$IP -6 route add default dev dummy1
+	$IP -6 rule add table main suppress_prefixlength 0
+	ping -f -c 1000 -W 1 1234::1 || true
+	$IP -6 rule del table main suppress_prefixlength 0
+	$IP link del dummy1
+
+	# If we got here without crashing, we're good.
+	return 0
+}
+
 ################################################################################
 # Tests on route add and replace
 
@@ -1591,6 +1605,7 @@ do
 	fib_carrier_test|carrier)	fib_carrier_test;;
 	fib_rp_filter_test|rp_filter)	fib_rp_filter_test;;
 	fib_nexthop_test|nexthop)	fib_nexthop_test;;
+	fib_suppress_test|suppress)	fib_suppress_test;;
 	ipv6_route_test|ipv6_rt)	ipv6_route_test;;
 	ipv4_route_test|ipv4_rt)	ipv4_route_test;;
 	ipv6_addr_metric)		ipv6_addr_metric_test;;
-- 
2.21.0

