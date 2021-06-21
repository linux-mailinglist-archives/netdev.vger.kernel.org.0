Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EAF3AF8DA
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhFUW5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:57:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:11257 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232350AbhFUW5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 18:57:03 -0400
IronPort-SDR: jLe/N0mBfA7IiCKz1C5/8KSj93VbLMgn71bPIfW9zswjvJGNl9enp98N5PyciMlXU5qBTDolJ/
 L4znAVFZYwkA==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="206768522"
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="206768522"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:43 -0700
IronPort-SDR: +petn45s7pg9jt+ljh7bRvmDKQgGq5/eGwZf97Tl49SwN2T94ia1+S98kXfxZDoRvhqVGKp659
 O90AffoXb7ng==
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="486673974"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.74.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 15:54:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/6] selftests: mptcp: display proper reason to abort tests
Date:   Mon, 21 Jun 2021 15:54:38 -0700
Message-Id: <20210621225438.10777-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
References: <20210621225438.10777-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

Without this modification, we were often displaying this error messages:

  FAIL: Could not even run loopback test

But $ret could have been set to a non 0 value in many different cases:

- net.mptcp.enabled=0 is not working as expected
- setsockopt(..., TCP_ULP, "mptcp", ...) is allowed
- ping between each netns are failing
- tests between ns1 as a receiver and ns>1 are failing
- other tests not involving ns1 as a receiver are failing

So not only for the loopback test.

Now a clearer message, including the time it took to run all tests, is
displayed.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 52 +++++++++++++------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 2484fb6a9a8d..559173a8e387 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -680,6 +680,25 @@ run_tests_peekmode()
 	run_tests_lo "$ns1" "$ns1" dead:beef:1::1 1 "-P ${peekmode}"
 }
 
+display_time()
+{
+	time_end=$(date +%s)
+	time_run=$((time_end-time_start))
+
+	echo "Time: ${time_run} seconds"
+}
+
+stop_if_error()
+{
+	local msg="$1"
+
+	if [ ${ret} -ne 0 ]; then
+		echo "FAIL: ${msg}" 1>&2
+		display_time
+		exit ${ret}
+	fi
+}
+
 make_file "$cin" "client"
 make_file "$sin" "server"
 
@@ -687,6 +706,8 @@ check_mptcp_disabled
 
 check_mptcp_ulp_setsockopt
 
+stop_if_error "The kernel configuration is not valid for MPTCP"
+
 echo "INFO: validating network environment with pings"
 for sender in "$ns1" "$ns2" "$ns3" "$ns4";do
 	do_ping "$ns1" $sender 10.0.1.1
@@ -706,6 +727,8 @@ for sender in "$ns1" "$ns2" "$ns3" "$ns4";do
 	do_ping "$ns4" $sender dead:beef:3::1
 done
 
+stop_if_error "Could not even run ping tests"
+
 [ -n "$tc_loss" ] && tc -net "$ns2" qdisc add dev ns2eth3 root netem loss random $tc_loss delay ${tc_delay}ms
 echo -n "INFO: Using loss of $tc_loss "
 test "$tc_delay" -gt 0 && echo -n "delay $tc_delay ms "
@@ -733,18 +756,13 @@ echo "on ns3eth4"
 
 tc -net "$ns3" qdisc add dev ns3eth4 root netem delay ${reorder_delay}ms $tc_reorder
 
-for sender in $ns1 $ns2 $ns3 $ns4;do
-	run_tests_lo "$ns1" "$sender" 10.0.1.1 1
-	if [ $ret -ne 0 ] ;then
-		echo "FAIL: Could not even run loopback test" 1>&2
-		exit $ret
-	fi
-	run_tests_lo "$ns1" $sender dead:beef:1::1 1
-	if [ $ret -ne 0 ] ;then
-		echo "FAIL: Could not even run loopback v6 test" 2>&1
-		exit $ret
-	fi
+run_tests_lo "$ns1" "$ns1" 10.0.1.1 1
+stop_if_error "Could not even run loopback test"
+
+run_tests_lo "$ns1" "$ns1" dead:beef:1::1 1
+stop_if_error "Could not even run loopback v6 test"
 
+for sender in $ns1 $ns2 $ns3 $ns4;do
 	# ns1<->ns2 is not subject to reordering/tc delays. Use it to test
 	# mptcp syncookie support.
 	if [ $sender = $ns1 ]; then
@@ -753,6 +771,9 @@ for sender in $ns1 $ns2 $ns3 $ns4;do
 		ip netns exec "$ns2" sysctl -q net.ipv4.tcp_syncookies=1
 	fi
 
+	run_tests "$ns1" $sender 10.0.1.1
+	run_tests "$ns1" $sender dead:beef:1::1
+
 	run_tests "$ns2" $sender 10.0.1.2
 	run_tests "$ns2" $sender dead:beef:1::2
 	run_tests "$ns2" $sender 10.0.2.1
@@ -765,14 +786,13 @@ for sender in $ns1 $ns2 $ns3 $ns4;do
 
 	run_tests "$ns4" $sender 10.0.3.1
 	run_tests "$ns4" $sender dead:beef:3::1
+
+	stop_if_error "Tests with $sender as a sender have failed"
 done
 
 run_tests_peekmode "saveWithPeek"
 run_tests_peekmode "saveAfterPeek"
+stop_if_error "Tests with peek mode have failed"
 
-time_end=$(date +%s)
-time_run=$((time_end-time_start))
-
-echo "Time: ${time_run} seconds"
-
+display_time
 exit $ret
-- 
2.32.0

