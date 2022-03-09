Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309924D39F9
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiCITSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238356AbiCITS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:18:28 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E94A4F44B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646853434; x=1678389434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ajK5bRLhHHbL4UzQgd59ZHaax2mF04qTR9Ewj/5sXE0=;
  b=gSIawOaxtMlFOgp1JUpokT1F55BNiAQVsu2RIEoG4xBmjMfmvHnEtRRq
   f4cnqKkxFj0j8p0pt7IyaDFnmZRYbHerxjQLJyiBasJfh/SK2HTp+E+fU
   KiZMjB6iG5JVVoQDpykH1gr1b9UzBFAe8n6DEmSo7uqcfTM33hphX5x7c
   zYMjWfQzOXsJYUXiRUVTMRvsW+QR58ejFD5D6bo6J8zvblqWv3RVvA+en
   Y6ASGWQK+vTA/COiJEwnuOO47C/f+R7LKk4vZ26bdyBBZ/qhl2Enlebb2
   1Mw5PsBL73W6wCWD3prdrfS5lg1vYCBVJrFJlga7RJ4n2EYR7StFq+uth
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="237235268"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="237235268"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:46 -0800
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="495957058"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.194.198])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:46 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 05/10] selftests: mptcp: join: alt. to exec specific tests
Date:   Wed,  9 Mar 2022 11:16:31 -0800
Message-Id: <20220309191636.258232-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309191636.258232-1-mathew.j.martineau@linux.intel.com>
References: <20220309191636.258232-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

Running a specific test by giving the ID is often what we want: the CI
reports an issue with the Nth test, it is reproducible with:

  ./mptcp_join.sh N

But this might not work when there is a need to find which commit has
introduced a regression making a test unstable: failing from time to
time. Indeed, a specific test is not attached to one ID: the ID is in
fact a counter. It means the same test can have a different ID if other
tests have been added/removed before this unstable one.

Remembering the current test can also help listing failed tests at the
end.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 446 +++++++++---------
 1 file changed, 232 insertions(+), 214 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index a3f6c790765b..64261c3ca320 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -20,8 +20,10 @@ validate_checksum=0
 init=0
 
 declare -A all_tests
-declare -a only_tests
+declare -a only_tests_ids
+declare -a only_tests_names
 TEST_COUNT=0
+TEST_NAME=""
 nr_blank=40
 
 export FAILING_LINKS=""
@@ -152,22 +154,30 @@ cleanup()
 
 skip_test()
 {
-	if [ "${#only_tests[@]}" -eq 0 ]; then
+	if [ "${#only_tests_ids[@]}" -eq 0 ] && [ "${#only_tests_names[@]}" -eq 0 ]; then
 		return 1
 	fi
 
 	local i
-	for i in "${only_tests[@]}"; do
+	for i in "${only_tests_ids[@]}"; do
 		if [ "${TEST_COUNT}" -eq "${i}" ]; then
 			return 1
 		fi
 	done
+	for i in "${only_tests_names[@]}"; do
+		if [ "${TEST_NAME}" = "${i}" ]; then
+			return 1
+		fi
+	done
 
 	return 0
 }
 
+# $1: test name
 reset()
 {
+	TEST_NAME="${1}"
+
 	TEST_COUNT=$((TEST_COUNT+1))
 
 	if skip_test; then
@@ -185,27 +195,29 @@ reset()
 	return 0
 }
 
+# $1: test name
 reset_with_cookies()
 {
-	reset || return 1
+	reset "${1}" || return 1
 
 	for netns in "$ns1" "$ns2";do
 		ip netns exec $netns sysctl -q net.ipv4.tcp_syncookies=2
 	done
 }
 
+# $1: test name
 reset_with_add_addr_timeout()
 {
-	local ip="${1:-4}"
+	local ip="${2:-4}"
 	local tables
 
+	reset "${1}" || return 1
+
 	tables="iptables"
 	if [ $ip -eq 6 ]; then
 		tables="ip6tables"
 	fi
 
-	reset || return 1
-
 	ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
 	ip netns exec $ns2 $tables -A OUTPUT -p tcp \
 		-m tcp --tcp-option 30 \
@@ -214,12 +226,13 @@ reset_with_add_addr_timeout()
 		-j DROP
 }
 
+# $1: test name
 reset_with_checksum()
 {
 	local ns1_enable=$1
 	local ns2_enable=$2
 
-	reset || return 1
+	reset "checksum test ${1} ${2}" || return 1
 
 	ip netns exec $ns1 sysctl -q net.mptcp.checksum_enabled=$ns1_enable
 	ip netns exec $ns2 sysctl -q net.mptcp.checksum_enabled=$ns2_enable
@@ -229,10 +242,10 @@ reset_with_checksum()
 
 reset_with_allow_join_id0()
 {
-	local ns1_enable=$1
-	local ns2_enable=$2
+	local ns1_enable=$2
+	local ns2_enable=$3
 
-	reset || return 1
+	reset "${1}" || return 1
 
 	ip netns exec $ns1 sysctl -q net.mptcp.allow_join_initial_addr_port=$ns1_enable
 	ip netns exec $ns2 sysctl -q net.mptcp.allow_join_initial_addr_port=$ns2_enable
@@ -461,7 +474,7 @@ pm_nl_change_endpoint()
 pm_nl_check_endpoint()
 {
 	local line expected_line
-	local title="$1"
+	local need_title=$1
 	local msg="$2"
 	local ns=$3
 	local addr=$4
@@ -473,8 +486,8 @@ pm_nl_check_endpoint()
 	local _id
 	local id
 
-	if [ -n "${title}" ]; then
-		printf "%03u %-36s %s" "${TEST_COUNT}" "${title}" "${msg}"
+	if [ "${need_title}" = 1 ]; then
+		printf "%03u %-36s %s" "${TEST_COUNT}" "${TEST_NAME}" "${msg}"
 	else
 		printf "%-${nr_blank}s %s" " " "${msg}"
 	fi
@@ -1036,19 +1049,24 @@ chk_rst_nr()
 
 chk_join_nr()
 {
-	local msg="$1"
-	local syn_nr=$2
-	local syn_ack_nr=$3
-	local ack_nr=$4
-	local csum_ns1=${5:-0}
-	local csum_ns2=${6:-0}
-	local fail_nr=${7:-0}
-	local rst_nr=${8:-0}
+	local syn_nr=$1
+	local syn_ack_nr=$2
+	local ack_nr=$3
+	local csum_ns1=${4:-0}
+	local csum_ns2=${5:-0}
+	local fail_nr=${6:-0}
+	local rst_nr=${7:-0}
+	local corrupted_pkts=${8:-0}
 	local count
 	local dump_stats
 	local with_cookie
+	local title="${TEST_NAME}"
+
+	if [ "${corrupted_pkts}" -gt 0 ]; then
+		title+=": ${corrupted_pkts} corrupted pkts"
+	fi
 
-	printf "%03u %-36s %s" "$TEST_COUNT" "$msg" "syn"
+	printf "%03u %-36s %s" "${TEST_COUNT}" "${title}" "syn"
 	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinSynRx | awk '{print $2}'`
 	[ -z "$count" ] && count=0
 	if [ "$count" != "$syn_nr" ]; then
@@ -1405,65 +1423,65 @@ wait_attempt_fail()
 
 subflows_tests()
 {
-	if reset; then
+	if reset "no JOIN"; then
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "no JOIN" 0 0 0
+		chk_join_nr 0 0 0
 	fi
 
 	# subflow limited by client
-	if reset; then
+	if reset "single subflow, limited by client"; then
 		pm_nl_set_limits $ns1 0 0
 		pm_nl_set_limits $ns2 0 0
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "single subflow, limited by client" 0 0 0
+		chk_join_nr 0 0 0
 	fi
 
 	# subflow limited by server
-	if reset; then
+	if reset "single subflow, limited by server"; then
 		pm_nl_set_limits $ns1 0 0
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "single subflow, limited by server" 1 1 0
+		chk_join_nr 1 1 0
 	fi
 
 	# subflow
-	if reset; then
+	if reset "single subflow"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "single subflow" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 
 	# multiple subflows
-	if reset; then
+	if reset "multiple subflows"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "multiple subflows" 2 2 2
+		chk_join_nr 2 2 2
 	fi
 
 	# multiple subflows limited by server
-	if reset; then
+	if reset "multiple subflows, limited by server"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "multiple subflows, limited by server" 2 2 1
+		chk_join_nr 2 2 1
 	fi
 
 	# single subflow, dev
-	if reset; then
+	if reset "single subflow, dev"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow dev ns2eth3
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "single subflow, dev" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 }
 
@@ -1471,40 +1489,40 @@ subflows_error_tests()
 {
 	# If a single subflow is configured, and matches the MPC src
 	# address, no additional subflow should be created
-	if reset; then
+	if reset "no MPC reuse with single endpoint"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-		chk_join_nr "no MPC reuse with single endpoint" 0 0 0
+		chk_join_nr 0 0 0
 	fi
 
 	# multiple subflows, with subflow creation error
-	if reset; then
+	if reset "multi subflows, with failing subflow"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 		ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j REJECT
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-		chk_join_nr "multi subflows, with failing subflow" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 
 	# multiple subflows, with subflow timeout on MPJ
-	if reset; then
+	if reset "multi subflows, with subflow timeout"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 		ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j DROP
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-		chk_join_nr "multi subflows, with subflow timeout" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 
 	# multiple subflows, check that the endpoint corresponding to
 	# closed subflow (due to reset) is not reused if additional
 	# subflows are added later
-	if reset; then
+	if reset "multi subflows, fair usage on close"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
@@ -1518,27 +1536,27 @@ subflows_error_tests()
 
 		# additional subflow could be created only if the PM select
 		# the later endpoint, skipping the already used one
-		chk_join_nr "multi subflows, fair usage on close" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 }
 
 signal_address_tests()
 {
 	# add_address, unused
-	if reset; then
+	if reset "unused signal address"; then
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "unused signal address" 0 0 0
+		chk_join_nr 0 0 0
 		chk_add_nr 1 1
 	fi
 
 	# accept and use add_addr
-	if reset; then
+	if reset "signal address"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "signal address" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 	fi
 
@@ -1546,54 +1564,54 @@ signal_address_tests()
 	# note: signal address in server ns and local addresses in client ns must
 	# belong to different subnets or one of the listed local address could be
 	# used for 'add_addr' subflow
-	if reset; then
+	if reset "subflow and signal"; then
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 1 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "subflow and signal" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 1 1
 	fi
 
 	# accept and use add_addr with additional subflows
-	if reset; then
+	if reset "multiple subflows and signal"; then
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "multiple subflows and signal" 3 3 3
+		chk_join_nr 3 3 3
 		chk_add_nr 1 1
 	fi
 
 	# signal addresses
-	if reset; then
+	if reset "signal addresses"; then
 		pm_nl_set_limits $ns1 3 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
 		pm_nl_set_limits $ns2 3 3
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "signal addresses" 3 3 3
+		chk_join_nr 3 3 3
 		chk_add_nr 3 3
 	fi
 
 	# signal invalid addresses
-	if reset; then
+	if reset "signal invalid addresses"; then
 		pm_nl_set_limits $ns1 3 3
 		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
 		pm_nl_set_limits $ns2 3 3
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "signal invalid addresses" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 3 3
 	fi
 
 	# signal addresses race test
-	if reset; then
+	if reset "signal addresses race test"; then
 		pm_nl_set_limits $ns1 4 4
 		pm_nl_set_limits $ns2 4 4
 		pm_nl_add_endpoint $ns1 10.0.1.1 flags signal
@@ -1608,7 +1626,7 @@ signal_address_tests()
 		# the peer could possibly miss some addr notification, allow retransmission
 		ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-		chk_join_nr "signal addresses race test" 3 3 3
+		chk_join_nr 3 3 3
 
 		# the server will not signal the address terminating
 		# the MPC subflow
@@ -1619,7 +1637,7 @@ signal_address_tests()
 link_failure_tests()
 {
 	# accept and use add_addr with additional subflows and link loss
-	if reset; then
+	if reset "multiple flows, signal, link failure"; then
 		# without any b/w limit each veth could spool the packets and get
 		# them acked at xmit time, so that the corresponding subflow will
 		# have almost always no outstanding pkts, the scheduler will pick
@@ -1633,14 +1651,14 @@ link_failure_tests()
 		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.4.2 dev ns2eth4 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 1
-		chk_join_nr "multiple flows, signal, link failure" 3 3 3
+		chk_join_nr 3 3 3
 		chk_add_nr 1 1
 		chk_stale_nr $ns2 1 5 1
 	fi
 
 	# accept and use add_addr with additional subflows and link loss
 	# for bidirectional transfer
-	if reset; then
+	if reset "multi flows, signal, bidi, link fail"; then
 		init_shapers
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
@@ -1648,14 +1666,14 @@ link_failure_tests()
 		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.4.2 dev ns2eth4 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 2
-		chk_join_nr "multi flows, signal, bidi, link fail" 3 3 3
+		chk_join_nr 3 3 3
 		chk_add_nr 1 1
 		chk_stale_nr $ns2 1 -1 1
 	fi
 
 	# 2 subflows plus 1 backup subflow with a lossy link, backup
 	# will never be used
-	if reset; then
+	if reset "backup subflow unused, link failure"; then
 		init_shapers
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
@@ -1663,14 +1681,14 @@ link_failure_tests()
 		FAILING_LINKS="1"
 		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
 		run_tests $ns1 $ns2 10.0.1.1 1
-		chk_join_nr "backup subflow unused, link failure" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 1 1
 		chk_link_usage $ns2 ns2eth3 $cinsent 0
 	fi
 
 	# 2 lossy links after half transfer, backup will get half of
 	# the traffic
-	if reset; then
+	if reset "backup flow used, multi links fail"; then
 		init_shapers
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
@@ -1678,7 +1696,7 @@ link_failure_tests()
 		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
 		FAILING_LINKS="1 2"
 		run_tests $ns1 $ns2 10.0.1.1 1
-		chk_join_nr "backup flow used, multi links fail" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 1 1
 		chk_stale_nr $ns2 2 4 2
 		chk_link_usage $ns2 ns2eth3 $cinsent 50
@@ -1686,7 +1704,7 @@ link_failure_tests()
 
 	# use a backup subflow with the first subflow on a lossy link
 	# for bidirectional transfer
-	if reset; then
+	if reset "backup flow used, bidi, link failure"; then
 		init_shapers
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
@@ -1694,7 +1712,7 @@ link_failure_tests()
 		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
 		FAILING_LINKS="1 2"
 		run_tests $ns1 $ns2 10.0.1.1 2
-		chk_join_nr "backup flow used, bidi, link failure" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 1 1
 		chk_stale_nr $ns2 1 -1 2
 		chk_link_usage $ns2 ns2eth3 $cinsent 50
@@ -1704,44 +1722,44 @@ link_failure_tests()
 add_addr_timeout_tests()
 {
 	# add_addr timeout
-	if reset_with_add_addr_timeout; then
+	if reset_with_add_addr_timeout "signal address, ADD_ADDR timeout"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-		chk_join_nr "signal address, ADD_ADDR timeout" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 4 0
 	fi
 
 	# add_addr timeout IPv6
-	if reset_with_add_addr_timeout 6; then
+	if reset_with_add_addr_timeout "signal address, ADD_ADDR6 timeout" 6; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
 		run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
-		chk_join_nr "signal address, ADD_ADDR6 timeout" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 4 0
 	fi
 
 	# signal addresses timeout
-	if reset_with_add_addr_timeout; then
+	if reset_with_add_addr_timeout "signal addresses, ADD_ADDR timeout"; then
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_set_limits $ns2 2 2
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 speed_10
-		chk_join_nr "signal addresses, ADD_ADDR timeout" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 8 0
 	fi
 
 	# signal invalid addresses timeout
-	if reset_with_add_addr_timeout; then
+	if reset_with_add_addr_timeout "invalid address, ADD_ADDR timeout"; then
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_set_limits $ns2 2 2
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 speed_10
-		chk_join_nr "invalid address, ADD_ADDR timeout" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 8 0
 	fi
 }
@@ -1749,156 +1767,156 @@ add_addr_timeout_tests()
 remove_tests()
 {
 	# single subflow, remove
-	if reset; then
+	if reset "remove single subflow"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 0 -1 slow
-		chk_join_nr "remove single subflow" 1 1 1
+		chk_join_nr 1 1 1
 		chk_rm_nr 1 1
 	fi
 
 	# multiple subflows, remove
-	if reset; then
+	if reset "remove multiple subflows"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 0 -2 slow
-		chk_join_nr "remove multiple subflows" 2 2 2
+		chk_join_nr 2 2 2
 		chk_rm_nr 2 2
 	fi
 
 	# single address, remove
-	if reset; then
+	if reset "remove single address"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
-		chk_join_nr "remove single address" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 		chk_rm_nr 1 1 invert
 	fi
 
 	# subflow and signal, remove
-	if reset; then
+	if reset "remove subflow and signal"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_set_limits $ns2 1 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
-		chk_join_nr "remove subflow and signal" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 1 1
 		chk_rm_nr 1 1
 	fi
 
 	# subflows and signal, remove
-	if reset; then
+	if reset "remove subflows and signal"; then
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 slow
-		chk_join_nr "remove subflows and signal" 3 3 3
+		chk_join_nr 3 3 3
 		chk_add_nr 1 1
 		chk_rm_nr 2 2
 	fi
 
 	# addresses remove
-	if reset; then
+	if reset "remove addresses"; then
 		pm_nl_set_limits $ns1 3 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal id 250
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
 		pm_nl_set_limits $ns2 3 3
 		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
-		chk_join_nr "remove addresses" 3 3 3
+		chk_join_nr 3 3 3
 		chk_add_nr 3 3
 		chk_rm_nr 3 3 invert
 	fi
 
 	# invalid addresses remove
-	if reset; then
+	if reset "remove invalid addresses"; then
 		pm_nl_set_limits $ns1 3 3
 		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
 		pm_nl_set_limits $ns2 3 3
 		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
-		chk_join_nr "remove invalid addresses" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 3 3
 		chk_rm_nr 3 1 invert
 	fi
 
 	# subflows and signal, flush
-	if reset; then
+	if reset "flush subflows and signal"; then
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
-		chk_join_nr "flush subflows and signal" 3 3 3
+		chk_join_nr 3 3 3
 		chk_add_nr 1 1
 		chk_rm_nr 1 3 invert simult
 	fi
 
 	# subflows flush
-	if reset; then
+	if reset "flush subflows"; then
 		pm_nl_set_limits $ns1 3 3
 		pm_nl_set_limits $ns2 3 3
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow id 150
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
-		chk_join_nr "flush subflows" 3 3 3
+		chk_join_nr 3 3 3
 		chk_rm_nr 0 3 simult
 	fi
 
 	# addresses flush
-	if reset; then
+	if reset "flush addresses"; then
 		pm_nl_set_limits $ns1 3 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal id 250
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
 		pm_nl_set_limits $ns2 3 3
 		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
-		chk_join_nr "flush addresses" 3 3 3
+		chk_join_nr 3 3 3
 		chk_add_nr 3 3
 		chk_rm_nr 3 3 invert simult
 	fi
 
 	# invalid addresses flush
-	if reset; then
+	if reset "flush invalid addresses"; then
 		pm_nl_set_limits $ns1 3 3
 		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
 		pm_nl_set_limits $ns2 3 3
 		run_tests $ns1 $ns2 10.0.1.1 0 -8 0 slow
-		chk_join_nr "flush invalid addresses" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 3 3
 		chk_rm_nr 3 1 invert
 	fi
 
 	# remove id 0 subflow
-	if reset; then
+	if reset "remove id 0 subflow"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 0 -9 slow
-		chk_join_nr "remove id 0 subflow" 1 1 1
+		chk_join_nr 1 1 1
 		chk_rm_nr 1 1
 	fi
 
 	# remove id 0 address
-	if reset; then
+	if reset "remove id 0 address"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 10.0.1.1 0 -9 0 slow
-		chk_join_nr "remove id 0 address" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 		chk_rm_nr 1 1 invert
 	fi
@@ -1907,44 +1925,44 @@ remove_tests()
 add_tests()
 {
 	# add single subflow
-	if reset; then
+	if reset "add single subflow"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow
-		chk_join_nr "add single subflow" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 
 	# add signal address
-	if reset; then
+	if reset "add signal address"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
-		chk_join_nr "add signal address" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 	fi
 
 	# add multiple subflows
-	if reset; then
+	if reset "add multiple subflows"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
 		run_tests $ns1 $ns2 10.0.1.1 0 0 2 slow
-		chk_join_nr "add multiple subflows" 2 2 2
+		chk_join_nr 2 2 2
 	fi
 
 	# add multiple subflows IPv6
-	if reset; then
+	if reset "add multiple subflows IPv6"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
 		run_tests $ns1 $ns2 dead:beef:1::1 0 0 2 slow
-		chk_join_nr "add multiple subflows IPv6" 2 2 2
+		chk_join_nr 2 2 2
 	fi
 
 	# add multiple addresses IPv6
-	if reset; then
+	if reset "add multiple addresses IPv6"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 2 2
 		run_tests $ns1 $ns2 dead:beef:1::1 0 2 0 slow
-		chk_join_nr "add multiple addresses IPv6" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 2 2
 	fi
 }
@@ -1952,51 +1970,51 @@ add_tests()
 ipv6_tests()
 {
 	# subflow IPv6
-	if reset; then
+	if reset "single subflow IPv6"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 dead:beef:3::2 dev ns2eth3 flags subflow
 		run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
-		chk_join_nr "single subflow IPv6" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 
 	# add_address, unused IPv6
-	if reset; then
+	if reset "unused signal address IPv6"; then
 		pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
 		run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
-		chk_join_nr "unused signal address IPv6" 0 0 0
+		chk_join_nr 0 0 0
 		chk_add_nr 1 1
 	fi
 
 	# signal address IPv6
-	if reset; then
+	if reset "single address IPv6"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
-		chk_join_nr "single address IPv6" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 	fi
 
 	# single address IPv6, remove
-	if reset; then
+	if reset "remove single address IPv6"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 dead:beef:1::1 0 -1 0 slow
-		chk_join_nr "remove single address IPv6" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 		chk_rm_nr 1 1 invert
 	fi
 
 	# subflow and signal IPv6, remove
-	if reset; then
+	if reset "remove subflow and signal IPv6"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
 		pm_nl_set_limits $ns2 1 2
 		pm_nl_add_endpoint $ns2 dead:beef:3::2 dev ns2eth3 flags subflow
 		run_tests $ns1 $ns2 dead:beef:1::1 0 -1 -1 slow
-		chk_join_nr "remove subflow and signal IPv6" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 1 1
 		chk_rm_nr 1 1
 	fi
@@ -2005,120 +2023,120 @@ ipv6_tests()
 v4mapped_tests()
 {
 	# subflow IPv4-mapped to IPv4-mapped
-	if reset; then
+	if reset "single subflow IPv4-mapped"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 "::ffff:10.0.3.2" flags subflow
 		run_tests $ns1 $ns2 "::ffff:10.0.1.1"
-		chk_join_nr "single subflow IPv4-mapped" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 
 	# signal address IPv4-mapped with IPv4-mapped sk
-	if reset; then
+	if reset "signal address IPv4-mapped"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns1 "::ffff:10.0.2.1" flags signal
 		run_tests $ns1 $ns2 "::ffff:10.0.1.1"
-		chk_join_nr "signal address IPv4-mapped" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 	fi
 
 	# subflow v4-map-v6
-	if reset; then
+	if reset "single subflow v4-map-v6"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 "::ffff:10.0.1.1"
-		chk_join_nr "single subflow v4-map-v6" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 
 	# signal address v4-map-v6
-	if reset; then
+	if reset "signal address v4-map-v6"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 "::ffff:10.0.1.1"
-		chk_join_nr "signal address v4-map-v6" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 	fi
 
 	# subflow v6-map-v4
-	if reset; then
+	if reset "single subflow v6-map-v4"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 "::ffff:10.0.3.2" flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "single subflow v6-map-v4" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 
 	# signal address v6-map-v4
-	if reset; then
+	if reset "signal address v6-map-v4"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns1 "::ffff:10.0.2.1" flags signal
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "signal address v6-map-v4" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 	fi
 
 	# no subflow IPv6 to v4 address
-	if reset; then
+	if reset "no JOIN with diff families v4-v6"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 dead:beef:2::2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "no JOIN with diff families v4-v6" 0 0 0
+		chk_join_nr 0 0 0
 	fi
 
 	# no subflow IPv6 to v4 address even if v6 has a valid v4 at the end
-	if reset; then
+	if reset "no JOIN with diff families v4-v6-2"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 dead:beef:2::10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "no JOIN with diff families v4-v6-2" 0 0 0
+		chk_join_nr 0 0 0
 	fi
 
 	# no subflow IPv4 to v6 address, no need to slow down too then
-	if reset; then
+	if reset "no JOIN with diff families v6-v4"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 dead:beef:1::1
-		chk_join_nr "no JOIN with diff families v6-v4" 0 0 0
+		chk_join_nr 0 0 0
 	fi
 }
 
 backup_tests()
 {
 	# single subflow, backup
-	if reset; then
+	if reset "single subflow, backup"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup
-		chk_join_nr "single subflow, backup" 1 1 1
+		chk_join_nr 1 1 1
 		chk_prio_nr 0 1
 	fi
 
 	# single address, backup
-	if reset; then
+	if reset "single address, backup"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
-		chk_join_nr "single address, backup" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 		chk_prio_nr 1 1
 	fi
 
 	# single address with port, backup
-	if reset; then
+	if reset "single address with port, backup"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
-		chk_join_nr "single address with port, backup" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 		chk_prio_nr 1 1
 	fi
@@ -2127,81 +2145,81 @@ backup_tests()
 add_addr_ports_tests()
 {
 	# signal address with port
-	if reset; then
+	if reset "signal address with port"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "signal address with port" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1 1
 	fi
 
 	# subflow and signal with port
-	if reset; then
+	if reset "subflow and signal with port"; then
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 1 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "subflow and signal with port" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 1 1 1
 	fi
 
 	# single address with port, remove
-	if reset; then
+	if reset "remove single address with port"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
-		chk_join_nr "remove single address with port" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1 1
 		chk_rm_nr 1 1 invert
 	fi
 
 	# subflow and signal with port, remove
-	if reset; then
+	if reset "remove subflow and signal with port"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
 		pm_nl_set_limits $ns2 1 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
-		chk_join_nr "remove subflow and signal with port" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 1 1 1
 		chk_rm_nr 1 1
 	fi
 
 	# subflows and signal with port, flush
-	if reset; then
+	if reset "flush subflows and signal with port"; then
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 -8 -2 slow
-		chk_join_nr "flush subflows and signal with port" 3 3 3
+		chk_join_nr 3 3 3
 		chk_add_nr 1 1
 		chk_rm_nr 1 3 invert simult
 	fi
 
 	# multiple addresses with port
-	if reset; then
+	if reset "multiple addresses with port"; then
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal port 10100
 		pm_nl_set_limits $ns2 2 2
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "multiple addresses with port" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 2 2 2
 	fi
 
 	# multiple addresses with ports
-	if reset; then
+	if reset "multiple addresses with ports"; then
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal port 10101
 		pm_nl_set_limits $ns2 2 2
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "multiple addresses with ports" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 2 2 2
 	fi
 }
@@ -2209,64 +2227,64 @@ add_addr_ports_tests()
 syncookies_tests()
 {
 	# single subflow, syncookies
-	if reset_with_cookies; then
+	if reset_with_cookies "single subflow with syn cookies"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "single subflow with syn cookies" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 
 	# multiple subflows with syn cookies
-	if reset_with_cookies; then
+	if reset_with_cookies "multiple subflows with syn cookies"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "multiple subflows with syn cookies" 2 2 2
+		chk_join_nr 2 2 2
 	fi
 
 	# multiple subflows limited by server
-	if reset_with_cookies; then
+	if reset_with_cookies "subflows limited by server w cookies"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "subflows limited by server w cookies" 2 1 1
+		chk_join_nr 2 1 1
 	fi
 
 	# test signal address with cookies
-	if reset_with_cookies; then
+	if reset_with_cookies "signal address with syn cookies"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "signal address with syn cookies" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 	fi
 
 	# test cookie with subflow and signal
-	if reset_with_cookies; then
+	if reset_with_cookies "subflow and signal w cookies"; then
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 1 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "subflow and signal w cookies" 2 2 2
+		chk_join_nr 2 2 2
 		chk_add_nr 1 1
 	fi
 
 	# accept and use add_addr with additional subflows
-	if reset_with_cookies; then
+	if reset_with_cookies "subflows and signal w. cookies"; then
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "subflows and signal w. cookies" 3 3 3
+		chk_join_nr 3 3 3
 		chk_add_nr 1 1
 	fi
 }
@@ -2278,7 +2296,7 @@ checksum_tests()
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "checksum test 0 0" 0 0 0
+		chk_join_nr 0 0 0
 	fi
 
 	# checksum test 1 1
@@ -2286,7 +2304,7 @@ checksum_tests()
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "checksum test 1 1" 0 0 0
+		chk_join_nr 0 0 0
 	fi
 
 	# checksum test 0 1
@@ -2294,7 +2312,7 @@ checksum_tests()
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "checksum test 0 1" 0 0 0
+		chk_join_nr 0 0 0
 	fi
 
 	# checksum test 1 0
@@ -2302,70 +2320,70 @@ checksum_tests()
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "checksum test 1 0" 0 0 0
+		chk_join_nr 0 0 0
 	fi
 }
 
 deny_join_id0_tests()
 {
 	# subflow allow join id0 ns1
-	if reset_with_allow_join_id0 1 0; then
+	if reset_with_allow_join_id0 "single subflow allow join id0 ns1" 1 0; then
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "single subflow allow join id0 ns1" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 
 	# subflow allow join id0 ns2
-	if reset_with_allow_join_id0 0 1; then
+	if reset_with_allow_join_id0 "single subflow allow join id0 ns2" 0 1; then
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "single subflow allow join id0 ns2" 0 0 0
+		chk_join_nr 0 0 0
 	fi
 
 	# signal address allow join id0 ns1
 	# ADD_ADDRs are not affected by allow_join_id0 value.
-	if reset_with_allow_join_id0 1 0; then
+	if reset_with_allow_join_id0 "signal address allow join id0 ns1" 1 0; then
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "signal address allow join id0 ns1" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 	fi
 
 	# signal address allow join id0 ns2
 	# ADD_ADDRs are not affected by allow_join_id0 value.
-	if reset_with_allow_join_id0 0 1; then
+	if reset_with_allow_join_id0 "signal address allow join id0 ns2" 0 1; then
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "signal address allow join id0 ns2" 1 1 1
+		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 	fi
 
 	# subflow and address allow join id0 ns1
-	if reset_with_allow_join_id0 1 0; then
+	if reset_with_allow_join_id0 "subflow and address allow join id0 1" 1 0; then
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "subflow and address allow join id0 1" 2 2 2
+		chk_join_nr 2 2 2
 	fi
 
 	# subflow and address allow join id0 ns2
-	if reset_with_allow_join_id0 0 1; then
+	if reset_with_allow_join_id0 "subflow and address allow join id0 2" 0 1; then
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1
-		chk_join_nr "subflow and address allow join id0 2" 1 1 1
+		chk_join_nr 1 1 1
 	fi
 }
 
@@ -2374,37 +2392,37 @@ fullmesh_tests()
 	# fullmesh 1
 	# 2 fullmesh addrs in ns2, added before the connection,
 	# 1 non-fullmesh addr in ns1, added during the connection.
-	if reset; then
+	if reset "fullmesh test 2x1"; then
 		pm_nl_set_limits $ns1 0 4
 		pm_nl_set_limits $ns2 1 4
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,fullmesh
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,fullmesh
 		run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
-		chk_join_nr "fullmesh test 2x1" 4 4 4
+		chk_join_nr 4 4 4
 		chk_add_nr 1 1
 	fi
 
 	# fullmesh 2
 	# 1 non-fullmesh addr in ns1, added before the connection,
 	# 1 fullmesh addr in ns2, added during the connection.
-	if reset; then
+	if reset "fullmesh test 1x1"; then
 		pm_nl_set_limits $ns1 1 3
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_1 slow
-		chk_join_nr "fullmesh test 1x1" 3 3 3
+		chk_join_nr 3 3 3
 		chk_add_nr 1 1
 	fi
 
 	# fullmesh 3
 	# 1 non-fullmesh addr in ns1, added before the connection,
 	# 2 fullmesh addrs in ns2, added during the connection.
-	if reset; then
+	if reset "fullmesh test 1x2"; then
 		pm_nl_set_limits $ns1 2 5
 		pm_nl_set_limits $ns2 1 5
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_2 slow
-		chk_join_nr "fullmesh test 1x2" 5 5 5
+		chk_join_nr 5 5 5
 		chk_add_nr 1 1
 	fi
 
@@ -2412,53 +2430,53 @@ fullmesh_tests()
 	# 1 non-fullmesh addr in ns1, added before the connection,
 	# 2 fullmesh addrs in ns2, added during the connection,
 	# limit max_subflows to 4.
-	if reset; then
+	if reset "fullmesh test 1x2, limited"; then
 		pm_nl_set_limits $ns1 2 4
 		pm_nl_set_limits $ns2 1 4
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_2 slow
-		chk_join_nr "fullmesh test 1x2, limited" 4 4 4
+		chk_join_nr 4 4 4
 		chk_add_nr 1 1
 	fi
 
 	# set fullmesh flag
-	if reset; then
+	if reset "set fullmesh flag test"; then
 		pm_nl_set_limits $ns1 4 4
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow
 		pm_nl_set_limits $ns2 4 4
 		run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow fullmesh
-		chk_join_nr "set fullmesh flag test" 2 2 2
+		chk_join_nr 2 2 2
 		chk_rm_nr 0 1
 	fi
 
 	# set nofullmesh flag
-	if reset; then
+	if reset "set nofullmesh flag test"; then
 		pm_nl_set_limits $ns1 4 4
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow,fullmesh
 		pm_nl_set_limits $ns2 4 4
 		run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_1 slow nofullmesh
-		chk_join_nr "set nofullmesh flag test" 2 2 2
+		chk_join_nr 2 2 2
 		chk_rm_nr 0 1
 	fi
 
 	# set backup,fullmesh flags
-	if reset; then
+	if reset "set backup,fullmesh flags test"; then
 		pm_nl_set_limits $ns1 4 4
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow
 		pm_nl_set_limits $ns2 4 4
 		run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow backup,fullmesh
-		chk_join_nr "set backup,fullmesh flags test" 2 2 2
+		chk_join_nr 2 2 2
 		chk_prio_nr 0 1
 		chk_rm_nr 0 1
 	fi
 
 	# set nobackup,nofullmesh flags
-	if reset; then
+	if reset "set nobackup,nofullmesh flags test"; then
 		pm_nl_set_limits $ns1 4 4
 		pm_nl_set_limits $ns2 4 4
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,backup,fullmesh
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup,nofullmesh
-		chk_join_nr "set nobackup,nofullmesh flags test" 2 2 2
+		chk_join_nr 2 2 2
 		chk_prio_nr 0 1
 		chk_rm_nr 0 1
 	fi
@@ -2466,9 +2484,9 @@ fullmesh_tests()
 
 fastclose_tests()
 {
-	if reset; then
+	if reset "fastclose test"; then
 		run_tests $ns1 $ns2 10.0.1.1 1024 0 fastclose_2
-		chk_join_nr "fastclose test" 0 0 0
+		chk_join_nr 0 0 0
 		chk_fclose_nr 1 1
 		chk_rst_nr 1 1 invert
 	fi
@@ -2477,22 +2495,22 @@ fastclose_tests()
 implicit_tests()
 {
 	# userspace pm type prevents add_addr
-	if reset; then
+	if reset "implicit EP"; then
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow &
 
 		wait_mpj $ns1
-		pm_nl_check_endpoint "implicit EP" "creation" \
+		pm_nl_check_endpoint 1 "creation" \
 			$ns2 10.0.2.2 id 1 flags implicit
 
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 33
-		pm_nl_check_endpoint "" "ID change is prevented" \
+		pm_nl_check_endpoint 0 "ID change is prevented" \
 			$ns2 10.0.2.2 id 1 flags implicit
 
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
-		pm_nl_check_endpoint "" "modif is allowed" \
+		pm_nl_check_endpoint 0 "modif is allowed" \
 			$ns2 10.0.2.2 id 1 flags signal
 		wait
 	fi
@@ -2518,7 +2536,7 @@ usage()
 	echo "  -i use ip mptcp"
 	echo "  -h help"
 
-	echo "[test ids]"
+	echo "[test ids|names]"
 
 	exit ${ret}
 }
@@ -2584,9 +2602,9 @@ shift $((OPTIND - 1))
 
 for arg in "${@}"; do
 	if [[ "${arg}" =~ ^[0-9]+$ ]]; then
-		only_tests+=("${arg}")
+		only_tests_ids+=("${arg}")
 	else
-		usage "Unknown argument: ${arg}"
+		only_tests_names+=("${arg}")
 	fi
 done
 
-- 
2.35.1

