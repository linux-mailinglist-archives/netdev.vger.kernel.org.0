Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE7C215D65
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 19:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbgGFRpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 13:45:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729550AbgGFRpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 13:45:10 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF788208D5;
        Mon,  6 Jul 2020 17:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594057509;
        bh=KknJPOB/p48fDu4wmZ5eaPAJdL9VYIP2U/8CNi8iAHY=;
        h=From:To:Cc:Subject:Date:From;
        b=mJOgAX9s8hLBuiS/URQlWqArbHNGQfp946mTDxoeuaqOIWgJV0Dkfd+PkWShu5sgc
         mX5f9tdHJKTPUDZhuzpbm5AV+YpLmbtFwKKRkU8hz5Vy/fSdO6SaSZ2JDFnc8azlrA
         uGLd0Ycz6kymHaCBZsHkjJd35Geq+2V8wNT7I81o=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     brak@choopa.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH v2 net] ipv6: fib6_select_path can not use out path for nexthop objects
Date:   Mon,  6 Jul 2020 11:45:07 -0600
Message-Id: <20200706174507.18556-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian reported a crash in IPv6 code when using rpfilter with a setup
running FRR and external nexthop objects. The root cause of the crash
is fib6_select_path setting fib6_nh in the result to NULL because of
an improper check for nexthop objects.

More specifically, rpfilter invokes ip6_route_lookup with flowi6_oif
set causing fib6_select_path to be called with have_oif_match set.
fib6_select_path has early check on have_oif_match and jumps to the
out label which presumes a builtin fib6_nh. This path is invalid for
nexthop objects; for external nexthops fib6_select_path needs to just
return if the fib6_nh has already been set in the result otherwise it
returns after the call to nexthop_path_fib6_result. Update the check
on have_oif_match to not bail on external nexthops.

Update selftests for this problem.

Fixes: f88d8ea67fbd ("ipv6: Plumb support for nexthop object in a fib6_info")
Reported-by: Brian Rak <brak@choopa.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
v2
- for multipath nexthops path may already be set; do not want to
  overwrite that selection based on hash

 net/ipv6/route.c                            |  5 ++++-
 tools/testing/selftests/net/fib_nexthops.sh | 13 +++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 82cbb46a2a4f..ea0be7cf3d93 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -431,9 +431,12 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 	struct fib6_info *sibling, *next_sibling;
 	struct fib6_info *match = res->f6i;
 
-	if ((!match->fib6_nsiblings && !match->nh) || have_oif_match)
+	if (!match->nh && (!match->fib6_nsiblings || have_oif_match))
 		goto out;
 
+	if (match->nh && have_oif_match && res->nh)
+		return;
+
 	/* We might have already computed the hash for ICMPv6 errors. In such
 	 * case it will always be non-zero. Otherwise now is the time to do it.
 	 */
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index dee567f7576a..22dc2f3d428b 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -747,6 +747,19 @@ ipv6_fcnal_runtime()
 	run_cmd "$IP nexthop add id 86 via 2001:db8:91::2 dev veth1"
 	run_cmd "$IP ro add 2001:db8:101::1/128 nhid 81"
 
+	# rpfilter and default route
+	$IP nexthop flush >/dev/null 2>&1
+	run_cmd "ip netns exec me ip6tables -t mangle -I PREROUTING 1 -m rpfilter --invert -j DROP"
+	run_cmd "$IP nexthop add id 91 via 2001:db8:91::2 dev veth1"
+	run_cmd "$IP nexthop add id 92 via 2001:db8:92::2 dev veth3"
+	run_cmd "$IP nexthop add id 93 group 91/92"
+	run_cmd "$IP -6 ro add default nhid 91"
+	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	log_test $? 0 "Nexthop with default route and rpfilter"
+	run_cmd "$IP -6 ro replace default nhid 93"
+	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	log_test $? 0 "Nexthop with multipath default route and rpfilter"
+
 	# TO-DO:
 	# existing route with old nexthop; append route with new nexthop
 	# existing route with old nexthop; replace route with new
-- 
2.17.1

