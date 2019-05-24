Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0782A1A9
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 01:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfEXXhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 19:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbfEXXhK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 19:37:10 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D5F62175B;
        Fri, 24 May 2019 23:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558741029;
        bh=pynZHg2Sz5BpA6wQ2ec1WYCdQfE0op6qWafg0Hi7Dkw=;
        h=From:To:Cc:Subject:Date:From;
        b=xaeoFQ5UKgFTiOrRGDxN1gjyRRfyEgM6acI9ws0d4s7VSFt73TyghzK2B75A4hJhE
         pEEqizanjU/jP1CIyl6c1yPJet2sPkdTmaClm4zdoM5g1pNklyeFNJ/Ij9L5z7RjcZ
         opk2uxd2yngfszuiSMKu/7zy5e6TDMaBiQ88G1vc=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] selftest: Fixes for icmp_redirect test
Date:   Fri, 24 May 2019 16:37:07 -0700
Message-Id: <20190524233707.19509-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

I was really surprised that the IPv6 mtu exception followed by redirect
test was passing as nothing about the code suggests it should. The problem
is actually with the logic in the test script.

Fix the test cases as follows:
1. add debug function to dump the initial and redirect gateway addresses
   for ipv6. This is shown only in verbose mode. It helps verify the
   output of 'route get'.

2. fix the check_exception logic for the reset case to make sure that
   for IPv4 neither mtu nor redirect appears in the 'route get' output.
   For IPv6, make sure mtu is not present and the gateway is the initial
   R1 lladdr.

3. fix the reset logic by using a function to delete the routes added by
   initial_route_*. This format works better for the nexthop version of
   the tests.

While improving the test cases, go ahead and ensure that forwarding is
disabled since IPv6 redirect requires it.

Also, runs with kernel debugging enabled sometimes show a failure with
one of the ipv4 tests, so spread the pings over longer time interval.

The end result is that 2 tests now show failures:

TEST: IPv6: mtu exception plus redirect                    [FAIL]

and the VRF version.

This is a bug in the IPv6 logic that will need to be fixed
separately. Redirect followed by MTU works because __ip6_rt_update_pmtu
hits the 'if (!rt6_cache_allowed_for_pmtu(rt6))' path and updates the
mtu on the exception rt6_info.

MTU followed by redirect does not have this logic. rt6_do_redirect
creates a new exception and then rt6_insert_exception removes the old
one which has the MTU exception.

Fixes: ec8105352869 ("selftests: Add redirect tests")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/icmp_redirect.sh | 46 +++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/icmp_redirect.sh b/tools/testing/selftests/net/icmp_redirect.sh
index e8d8496f5b16..76a7c4472dc3 100755
--- a/tools/testing/selftests/net/icmp_redirect.sh
+++ b/tools/testing/selftests/net/icmp_redirect.sh
@@ -80,6 +80,13 @@ log_test()
 	fi
 }
 
+log_debug()
+{
+	if [ "$VERBOSE" = "1" ]; then
+		echo "$*"
+	fi
+}
+
 run_cmd()
 {
 	local cmd="$*"
@@ -167,6 +174,7 @@ setup()
 
 		case "${ns}" in
 		h[12]) ip netns exec $ns sysctl -q -w net.ipv4.conf.all.accept_redirects=1
+		       ip netns exec $ns sysctl -q -w net.ipv6.conf.all.forwarding=0
 		       ip netns exec $ns sysctl -q -w net.ipv6.conf.all.accept_redirects=1
 		       ip netns exec $ns sysctl -q -w net.ipv6.conf.all.keep_addr_on_down=1
 			;;
@@ -250,12 +258,14 @@ setup()
 		echo "Error: Failed to get link-local address of r1's eth0"
 		exit 1
 	fi
+	log_debug "initial gateway is R1's lladdr = ${R1_LLADDR}"
 
 	R2_LLADDR=$(get_linklocal r2 eth0)
 	if [ $? -ne 0 ]; then
 		echo "Error: Failed to get link-local address of r2's eth0"
 		exit 1
 	fi
+	log_debug "initial gateway is R2's lladdr = ${R2_LLADDR}"
 }
 
 change_h2_mtu()
@@ -289,15 +299,26 @@ check_exception()
 		ip -netns h1 ro get ${H1_VRF_ARG} ${H2_N2_IP} | \
 		grep -q "cache expires [0-9]*sec${mtu}"
 	else
+		# want to verify that neither mtu nor redirected appears in
+		# the route get output. The -v will wipe out the cache line
+		# if either are set so the last grep -q will not find a match
 		ip -netns h1 ro get ${H1_VRF_ARG} ${H2_N2_IP} | \
-		grep -q "cache"
+		grep -E -v 'mtu|redirected' | grep -q "cache"
 	fi
 	log_test $? 0 "IPv4: ${desc}"
 
 	if [ "$with_redirect" = "yes" ]; then
-		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | grep -q "${H2_N2_IP6} from :: via ${R2_LLADDR} dev br0.*${mtu}"
+		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
+		grep -q "${H2_N2_IP6} from :: via ${R2_LLADDR} dev br0.*${mtu}"
+	elif [ -n "${mtu}" ]; then
+		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
+		grep -q "${mtu}"
 	else
-		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | grep -q "${mtu}"
+		# IPv6 is a bit harder. First strip out the match if it
+		# contains an mtu exception and then look for the first
+		# gateway - R1's lladdr
+		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
+		grep -v "mtu" | grep -q "${R1_LLADDR}"
 	fi
 	log_test $? 0 "IPv6: ${desc}"
 }
@@ -306,8 +327,8 @@ run_ping()
 {
 	local sz=$1
 
-	run_cmd ip netns exec h1 ping -q -M want -i 0.2 -c 10 -w 2 -s ${sz} ${H1_PING_ARG} ${H2_N2_IP}
-	run_cmd ip netns exec h1 ${ping6} -q -M want -i 0.2 -c 10 -w 2 -s ${sz} ${H1_PING_ARG} ${H2_N2_IP6}
+	run_cmd ip netns exec h1 ping -q -M want -i 0.5 -c 10 -w 2 -s ${sz} ${H1_PING_ARG} ${H2_N2_IP}
+	run_cmd ip netns exec h1 ${ping6} -q -M want -i 0.5 -c 10 -w 2 -s ${sz} ${H1_PING_ARG} ${H2_N2_IP6}
 }
 
 replace_route_legacy()
@@ -317,6 +338,17 @@ replace_route_legacy()
 	run_cmd ip -netns r1 -6 ro replace ${H2_N2_6} via ${R2_LLADDR} dev eth0
 }
 
+reset_route_legacy()
+{
+	run_cmd ip -netns r1    ro del ${H2_N2}
+	run_cmd ip -netns r1 -6 ro del ${H2_N2_6}
+
+	run_cmd ip -netns h1    ro del ${H1_VRF_ARG} ${H2_N2}
+	run_cmd ip -netns h1 -6 ro del ${H1_VRF_ARG} ${H2_N2_6}
+
+	initial_route_legacy
+}
+
 initial_route_legacy()
 {
 	# r1 to h2 via r2 and eth1
@@ -373,9 +405,7 @@ do_test()
 
 	# remove exceptions and restore routing
 	change_h2_mtu 1500
-	ip -netns h1 li set br0 down
-	ip -netns h1 li set br0 up
-	eval initial_route_${ttype}
+	eval reset_route_${ttype}
 
 	check_connectivity
 	if [ $? -ne 0 ]; then
-- 
2.11.0

