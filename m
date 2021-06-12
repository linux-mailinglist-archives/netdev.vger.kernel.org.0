Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1293A4FC2
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 18:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhFLQeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 12:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhFLQeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 12:34:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFBCF61059;
        Sat, 12 Jun 2021 16:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623515538;
        bh=Q74iQZTmkOnoClKQP9MLOrYAW7U1uFJ5wEQkU3n1CQ8=;
        h=From:To:Cc:Subject:Date:From;
        b=JK8CGX4iDk/0RhYsMenJWpRMvVs38VgYbKvvyqOFlBel+4ccPJfrvJZObk3+l2l8j
         YkSXv2xK0l9nLNWW9Mq27YU6VgWSbWRLgf62H3KtlwUpOxklBN1viQYFVsSTssmnRI
         HPucqFoGR4TATs/ZZ5uXE42Z6VZAeJUGGEHSPeqK3Q7M//OVajrWSEDxH8j2iYlRnz
         2W4qERPBfHwQlTaXobyUzzFUI/baGK/G5oG3yiaJSYxN7pfc+J0MUEloBYQkJROXbY
         IZC/OrVyXXfNSsMyixLfa7sn9yN8zj6NJ/FxLyQ7gdwdMrIAbtYLSaLhtAF2+s+rGL
         pEKwW4oVsE80g==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     David Ahern <dsahern@kernel.org>, Coco Li <lixiaoyan@google.com>
Subject: [PATCH net-next] nexthops: Add selftests for cleanup of known bad route add
Date:   Sat, 12 Jun 2021 10:32:15 -0600
Message-Id: <20210612163215.62110-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test cleanup path for routes usinig nexthop objects before the
reference is taken on the nexthop. Specifically, bad metric for
ipv4 and ipv6 and source routing for ipv6.

Selftests that correspond to the recent bug fix:
    821bbf79fe46 ("ipv6: Fix KASAN: slab-out-of-bounds Read in fib6_nh_flush_exceptions")

Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Coco Li <lixiaoyan@google.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 49774a8a7736..0d293391e9a4 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -925,6 +925,14 @@ ipv6_fcnal_runtime()
 	run_cmd "$IP nexthop add id 86 via 2001:db8:91::2 dev veth1"
 	run_cmd "$IP ro add 2001:db8:101::1/128 nhid 81"
 
+	# route can not use prefsrc with nexthops
+	run_cmd "$IP ro add 2001:db8:101::2/128 nhid 86 from 2001:db8:91::1"
+	log_test $? 2 "IPv6 route can not use src routing with external nexthop"
+
+	# check cleanup path on invalid metric
+	run_cmd "$IP ro add 2001:db8:101::2/128 nhid 86 congctl lock foo"
+	log_test $? 2 "IPv6 route with invalid metric"
+
 	# rpfilter and default route
 	$IP nexthop flush >/dev/null 2>&1
 	run_cmd "ip netns exec me ip6tables -t mangle -I PREROUTING 1 -m rpfilter --invert -j DROP"
@@ -1366,6 +1374,10 @@ ipv4_fcnal_runtime()
 	run_cmd "$IP nexthop replace id 22 via 172.16.2.2 dev veth3"
 	log_test $? 2 "Nexthop replace with invalid scope for existing route"
 
+	# check cleanup path on invalid metric
+	run_cmd "$IP ro add 172.16.101.2/32 nhid 22 congctl lock foo"
+	log_test $? 2 "IPv4 route with invalid metric"
+
 	#
 	# add route with nexthop and check traffic
 	#
-- 
2.27.0

