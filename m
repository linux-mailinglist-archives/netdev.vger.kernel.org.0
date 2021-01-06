Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5752EB6E9
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbhAFAbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:31:33 -0500
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:32635 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726877AbhAFAbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:31:33 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2021 19:31:32 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1609893092; x=1641429092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=rvvKcwCjSOHvJCdzN51G/rCqNa7qN72iHA25qn/07MY=;
  b=MnZ15a7Ne7NPZjRfFBiWB4DqwxDyOcE7R08FXh+5E01HSiW/NgI+/P9c
   jUjaf6N1V1wcx1sGkynuGAawmCrsWYUiFyIkS7vv5EHKn654X+44dx6DI
   LkkLg2yKrlvUgrPO5ZIbPH6zGEcuTnTC/BYjaKrANdITDV6T0OnxRkY2x
   w=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 05 Jan 2021 16:23:28 -0800
X-QCInternal: smtphost
Received: from stranche-lnx.qualcomm.com ([129.46.14.77])
  by ironmsg01-sd.qualcomm.com with ESMTP; 05 Jan 2021 16:23:29 -0800
Received: by stranche-lnx.qualcomm.com (Postfix, from userid 383980)
        id DF0A3353A; Tue,  5 Jan 2021 16:23:27 -0800 (PST)
From:   Sean Tranchetti <stranche@quicinc.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     subashab@codearurora.org, Sean Tranchetti <stranche@codeaurora.org>
Subject: [net PATCH 2/2] tools: selftests: add test for changing routes with PTMU exceptions
Date:   Tue,  5 Jan 2021 16:22:26 -0800
Message-Id: <1609892546-11389-2-git-send-email-stranche@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609892546-11389-1-git-send-email-stranche@quicinc.com>
References: <1609892546-11389-1-git-send-email-stranche@quicinc.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Tranchetti <stranche@codeaurora.org>

Adds new 2 new tests to the PTMU script: pmtu_ipv4/6_route_change.

These tests explicitly test for a recently discovered problem in the
IPv6 routing framework where PMTU exceptions were not properly released
when replacing a route via "ip route change ...".

After creating PMTU exceptions, the route from the device A to R1 will be
replaced with a new route, then device A will be deleted. If the PMTU
exceptions were properly cleaned up by the kernel, this device deletion
will succeed. Otherwise, the unregistration of the device will stall, and
messages such as the following will be logged in dmesg:

unregister_netdevice: waiting for veth_A-R1 to become free. Usage count = 4

Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
---
 tools/testing/selftests/net/pmtu.sh | 71 +++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 464e31e..64cd2e2 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -162,7 +162,15 @@
 # - list_flush_ipv6_exception
 #	Using the same topology as in pmtu_ipv6, create exceptions, and check
 #	they are shown when listing exception caches, gone after flushing them
-
+#
+# - pmtu_ipv4_route_change
+#	Use the same topology as in pmtu_ipv4, but issue a route replacement
+#	command and delete the corresponding device afterward. This tests for
+#	proper cleanup of the PMTU exceptions by the route replacement path.
+#	Device unregistration should complete successfully
+#
+# - pmtu_ipv6_route_change
+#	Same as above but with IPv6
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
@@ -224,7 +232,9 @@ tests="
 	cleanup_ipv4_exception		ipv4: cleanup of cached exceptions	1
 	cleanup_ipv6_exception		ipv6: cleanup of cached exceptions	1
 	list_flush_ipv4_exception	ipv4: list and flush cached exceptions	1
-	list_flush_ipv6_exception	ipv6: list and flush cached exceptions	1"
+	list_flush_ipv6_exception	ipv6: list and flush cached exceptions	1
+	pmtu_ipv4_route_change		ipv4: PMTU exception w/route replace	1
+	pmtu_ipv6_route_change		ipv6: PMTU exception w/route replace	1"
 
 NS_A="ns-A"
 NS_B="ns-B"
@@ -1782,6 +1792,63 @@ test_list_flush_ipv6_exception() {
 	return ${fail}
 }
 
+test_pmtu_ipvX_route_change() {
+	family=${1}
+
+	setup namespaces routing || return 2
+	trace "${ns_a}"  veth_A-R1    "${ns_r1}" veth_R1-A \
+	      "${ns_r1}" veth_R1-B    "${ns_b}"  veth_B-R1 \
+	      "${ns_a}"  veth_A-R2    "${ns_r2}" veth_R2-A \
+	      "${ns_r2}" veth_R2-B    "${ns_b}"  veth_B-R2
+
+	if [ ${family} -eq 4 ]; then
+		ping=ping
+		dst1="${prefix4}.${b_r1}.1"
+		dst2="${prefix4}.${b_r2}.1"
+		gw="${prefix4}.${a_r1}.2"
+	else
+		ping=${ping6}
+		dst1="${prefix6}:${b_r1}::1"
+		dst2="${prefix6}:${b_r2}::1"
+		gw="${prefix6}:${a_r1}::2"
+	fi
+
+	# Set up initial MTU values
+	mtu "${ns_a}"  veth_A-R1 2000
+	mtu "${ns_r1}" veth_R1-A 2000
+	mtu "${ns_r1}" veth_R1-B 1400
+	mtu "${ns_b}"  veth_B-R1 1400
+
+	mtu "${ns_a}"  veth_A-R2 2000
+	mtu "${ns_r2}" veth_R2-A 2000
+	mtu "${ns_r2}" veth_R2-B 1500
+	mtu "${ns_b}"  veth_B-R2 1500
+
+	# Create route exceptions
+	run_cmd ${ns_a} ${ping} -q -M want -i 0.1 -w 1 -s 1800 ${dst1}
+	run_cmd ${ns_a} ${ping} -q -M want -i 0.1 -w 1 -s 1800 ${dst2}
+
+	# Check that exceptions have been created with the correct PMTU
+	pmtu_1="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst1})"
+	check_pmtu_value "1400" "${pmtu_1}" "exceeding MTU" || return 1
+	pmtu_2="$(route_get_dst_pmtu_from_exception "${ns_a}" ${dst2})"
+	check_pmtu_value "1500" "${pmtu_2}" "exceeding MTU" || return 1
+
+	# Replace the route from A to R1
+	run_cmd ${ns_a} ip route change default via ${gw}
+
+	# Delete the device in A
+	run_cmd ${ns_a} ip link del "veth_A-R1"
+}
+
+test_pmtu_ipv4_route_change() {
+	test_pmtu_ipvX_route_change 4
+}
+
+test_pmtu_ipv6_route_change() {
+	test_pmtu_ipvX_route_change 6
+}
+
 usage() {
 	echo
 	echo "$0 [OPTIONS] [TEST]..."
-- 
2.7.4

