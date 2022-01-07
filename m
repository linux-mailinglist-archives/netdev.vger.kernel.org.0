Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A52486EA1
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344026AbiAGAUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:40 -0500
Received: from mga17.intel.com ([192.55.52.151]:2398 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344047AbiAGAUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514837; x=1673050837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UwyHRhqCE9vfS2IPGZKp6JoedrSmWlD+chvKutXd8no=;
  b=dpyFNXcfwVHO5okTgG3lO5PKLv6I85J37o96+wCVOhVE2TBW2UHvfbw9
   i9SNmzOU02170BgXUwxUn6hairIwcXl0rqg6YccbNEcSpBA+Adf+e7htr
   lB0XbOkaFymP83fSl8jCsQG2lJ32Fl4/4rBFOWG+RsTXTIFPZVgTJBLkz
   +97IJh9g8WoDOYUTPB+xOU+aGO6W8eBIflgS40D3IRbEGZxiI1qg7jAbz
   xn3k4/5wgpF8E1KS87rMkOo1h90iz30aBHNyW89yhyvoMqvrkRUqlaPo6
   6dRX/0pAxhBkRZImSrOAKU6Q51T7VTTfl08kC540xcDhvOdiIvjBKHB1g
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="223463271"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="223463271"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508518"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 11/13] selftests: mptcp: add tests for subflow creation failure
Date:   Thu,  6 Jan 2022 16:20:24 -0800
Message-Id: <20220107002026.375427-12-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Verify that, when multiple endpoints are available, subflows
creation proceed even when the first additional subflow creation
fails - due to packet drop on the relevant link

Co-developed-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/config      |  1 +
 .../testing/selftests/net/mptcp/mptcp_join.sh | 78 ++++++++++++++++++-
 2 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
index d548bc139b5d..d36b7da5082a 100644
--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -17,4 +17,5 @@ CONFIG_NFT_TPROXY=m
 CONFIG_NFT_SOCKET=m
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_MULTIPLE_TABLES=y
+CONFIG_IP_NF_TARGET_REJECT=m
 CONFIG_IPV6_MULTIPLE_TABLES=y
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index bbafa4cf5453..3165bd1a43cc 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -937,6 +937,22 @@ chk_link_usage()
 	fi
 }
 
+wait_for_tw()
+{
+	local timeout_ms=$((timeout_poll * 1000))
+	local time=0
+	local ns=$1
+
+	while [ $time -lt $timeout_ms ]; do
+		local cnt=$(ip netns exec $ns ss -t state time-wait |wc -l)
+
+		[ "$cnt" = 1 ] && return 1
+		time=$((time + 100))
+		sleep 0.1
+	done
+	return 1
+}
+
 subflows_tests()
 {
 	reset
@@ -994,6 +1010,61 @@ subflows_tests()
 	chk_join_nr "single subflow, dev" 1 1 1
 }
 
+subflows_error_tests()
+{
+	# If a single subflow is configured, and matches the MPC src
+	# address, no additional subflow should be created
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.1.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+	chk_join_nr "no MPC reuse with single endpoint" 0 0 0
+
+	# multiple subflows, with subflow creation error
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j REJECT
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+	chk_join_nr "multi subflows, with failing subflow" 1 1 1
+
+	# multiple subflows, with subflow timeout on MPJ
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j DROP
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+	chk_join_nr "multi subflows, with subflow timeout" 1 1 1
+
+	# multiple subflows, check that the endpoint corresponding to
+	# closed subflow (due to reset) is not reused if additional
+	# subflows are added later
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j REJECT
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow &
+
+	# updates in the child shell do not have any effect here, we
+	# need to bump the test counter for the above case
+	TEST_COUNT=$((TEST_COUNT+1))
+
+	# mpj subflow will be in TW after the reset
+	wait_for_tw $ns2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	wait
+
+	# additional subflow could be created only if the PM select
+	# the later endpoint, skipping the already used one
+	chk_join_nr "multi subflows, fair usage on close" 1 1 1
+}
+
 signal_address_tests()
 {
 	# add_address, unused
@@ -1805,6 +1876,7 @@ fullmesh_tests()
 all_tests()
 {
 	subflows_tests
+	subflows_error_tests
 	signal_address_tests
 	link_failure_tests
 	add_addr_timeout_tests
@@ -1824,6 +1896,7 @@ usage()
 {
 	echo "mptcp_join usage:"
 	echo "  -f subflows_tests"
+	echo "  -e subflows_error_tests"
 	echo "  -s signal_address_tests"
 	echo "  -l link_failure_tests"
 	echo "  -t add_addr_timeout_tests"
@@ -1872,11 +1945,14 @@ if [ $do_all_tests -eq 1 ]; then
 	exit $ret
 fi
 
-while getopts 'fsltra64bpkdmchCS' opt; do
+while getopts 'fesltra64bpkdmchCS' opt; do
 	case $opt in
 		f)
 			subflows_tests
 			;;
+		e)
+			subflows_error_tests
+			;;
 		s)
 			signal_address_tests
 			;;
-- 
2.34.1

