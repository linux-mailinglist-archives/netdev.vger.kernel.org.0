Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E2DA76D3
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfICWT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfICWT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 18:19:26 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1787E22DBF;
        Tue,  3 Sep 2019 22:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567549165;
        bh=os5DoJQjeP1IjdfFGsNUMfF3F51+E+sA6Ts9E8OiqNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJJr/ewkoS9c43cs9GkL++64OU1aUYBUo/bCRPD4MZSAjWlQq8y2M4mFIn2Z7t141
         E/WPT3XxRKulVmgQ1D/K8bSy4WfjA2ul0J+g4jI7uQHDf9D0gP4GmEvnLV0m7hFGG6
         gc35pO5bhpfaebrFRBXF/ZmUwzNcKizAPvQI9QuM=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 2/2] selftest: A few cleanups for fib_nexthops.sh
Date:   Tue,  3 Sep 2019 15:22:13 -0700
Message-Id: <20190903222213.7029-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190903222213.7029-1-dsahern@kernel.org>
References: <20190903222213.7029-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Cleanups of the tests in fib_nexthops.sh
1. Several tests noted unexpected route output, but the
   discrepancy was not showing in the summary output and
   overlooked in the verbose output. Add a WARNING message
   to the summary output to make it clear a test is not showing
   expected output.

2. Several check_* calls are missing extra data like scope and metric
   causing mismatches when the nexthops or routes are correct - some of
   them are a side effect of the evolving iproute2 command. Update the
   data to the expected output.

3. Several check_routes are checking for the wrong nexthop data,
   most likely a copy-paste-update error.

4. A couple of tests were re-using a nexthop id that already existed.
   Fix those to use a new id.

Fixes: 6345266a9989 ("selftests: Add test cases for nexthop objects")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index c5c93d5fb3ad..f9ebeac1e6f2 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -212,6 +212,8 @@ check_output()
 			printf "        ${out}\n"
 			printf "    Expected:\n"
 			printf "        ${expected}\n\n"
+		else
+			echo "      WARNING: Unexpected route entry"
 		fi
 	fi
 
@@ -274,7 +276,7 @@ ipv6_fcnal()
 
 	run_cmd "$IP nexthop get id 52"
 	log_test $? 0 "Get nexthop by id"
-	check_nexthop "id 52" "id 52 via 2001:db8:91::2 dev veth1"
+	check_nexthop "id 52" "id 52 via 2001:db8:91::2 dev veth1 scope link"
 
 	run_cmd "$IP nexthop del id 52"
 	log_test $? 0 "Delete nexthop by id"
@@ -479,12 +481,12 @@ ipv6_fcnal_runtime()
 	run_cmd "$IP -6 nexthop add id 85 dev veth1"
 	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 85"
 	log_test $? 0 "IPv6 route with device only nexthop"
-	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 85 dev veth1"
+	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 85 dev veth1 metric 1024 pref medium"
 
 	run_cmd "$IP nexthop add id 123 group 81/85"
 	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 123"
 	log_test $? 0 "IPv6 multipath route with nexthop mix - dev only + gw"
-	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 85 nexthop via 2001:db8:91::2 dev veth1 nexthop dev veth1"
+	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 123 metric 1024 nexthop via 2001:db8:91::2 dev veth1 weight 1 nexthop dev veth1 weight 1 pref medium"
 
 	#
 	# IPv6 route with v4 nexthop - not allowed
@@ -538,7 +540,7 @@ ipv4_fcnal()
 
 	run_cmd "$IP nexthop get id 12"
 	log_test $? 0 "Get nexthop by id"
-	check_nexthop "id 12" "id 12 via 172.16.1.2 src 172.16.1.1 dev veth1 scope link"
+	check_nexthop "id 12" "id 12 via 172.16.1.2 dev veth1 scope link"
 
 	run_cmd "$IP nexthop del id 12"
 	log_test $? 0 "Delete nexthop by id"
@@ -685,7 +687,7 @@ ipv4_withv6_fcnal()
 	set +e
 	run_cmd "$IP ro add 172.16.101.1/32 nhid 11"
 	log_test $? 0 "IPv6 nexthop with IPv4 route"
-	check_route "172.16.101.1" "172.16.101.1 nhid 11 via ${lladdr} dev veth1"
+	check_route "172.16.101.1" "172.16.101.1 nhid 11 via inet6 ${lladdr} dev veth1"
 
 	set -e
 	run_cmd "$IP nexthop add id 12 via 172.16.1.2 dev veth1"
@@ -694,11 +696,11 @@ ipv4_withv6_fcnal()
 	run_cmd "$IP ro replace 172.16.101.1/32 nhid 101"
 	log_test $? 0 "IPv6 nexthop with IPv4 route"
 
-	check_route "172.16.101.1" "172.16.101.1 nhid 101 nexthop via ${lladdr} dev veth1 weight 1 nexthop via 172.16.1.2 dev veth1 weight 1"
+	check_route "172.16.101.1" "172.16.101.1 nhid 101 nexthop via inet6 ${lladdr} dev veth1 weight 1 nexthop via 172.16.1.2 dev veth1 weight 1"
 
 	run_cmd "$IP ro replace 172.16.101.1/32 via inet6 ${lladdr} dev veth1"
 	log_test $? 0 "IPv4 route with IPv6 gateway"
-	check_route "172.16.101.1" "172.16.101.1 via ${lladdr} dev veth1"
+	check_route "172.16.101.1" "172.16.101.1 via inet6 ${lladdr} dev veth1"
 
 	run_cmd "$IP ro replace 172.16.101.1/32 via inet6 2001:db8:50::1 dev veth1"
 	log_test $? 2 "IPv4 route with invalid IPv6 gateway"
@@ -785,10 +787,10 @@ ipv4_fcnal_runtime()
 	log_test $? 0 "IPv4 route with device only nexthop"
 	check_route "172.16.101.1" "172.16.101.1 nhid 85 dev veth1"
 
-	run_cmd "$IP nexthop add id 122 group 21/85"
-	run_cmd "$IP ro replace 172.16.101.1/32 nhid 122"
+	run_cmd "$IP nexthop add id 123 group 21/85"
+	run_cmd "$IP ro replace 172.16.101.1/32 nhid 123"
 	log_test $? 0 "IPv4 multipath route with nexthop mix - dev only + gw"
-	check_route "172.16.101.1" "172.16.101.1 nhid 85 nexthop via 172.16.1.2 dev veth1 nexthop dev veth1"
+	check_route "172.16.101.1" "172.16.101.1 nhid 123 nexthop via 172.16.1.2 dev veth1 weight 1 nexthop dev veth1 weight 1"
 
 	#
 	# IPv4 with IPv6
@@ -820,7 +822,7 @@ ipv4_fcnal_runtime()
 	run_cmd "$IP ro replace 172.16.101.1/32 nhid 101"
 	log_test $? 0 "IPv4 route with mixed v4-v6 multipath route"
 
-	check_route "172.16.101.1" "172.16.101.1 nhid 101 nexthop via ${lladdr} dev veth1 weight 1 nexthop via 172.16.1.2 dev veth1 weight 1"
+	check_route "172.16.101.1" "172.16.101.1 nhid 101 nexthop via inet6 ${lladdr} dev veth1 weight 1 nexthop via 172.16.1.2 dev veth1 weight 1"
 
 	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
 	log_test $? 0 "IPv6 nexthop with IPv4 route"
-- 
2.11.0

