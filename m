Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088924D39E4
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236868AbiCITSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbiCITS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:18:26 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C1B3CFF6
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646853421; x=1678389421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KZH5smlqiyTE4+T22z3tAtrbKHeDMrss7Z34CaTXZZs=;
  b=PI15/a7Y8qCD6YyX2Z2gtH6JKrpSDatQxYSJjfdYPXnyUkDCmcm6Z7gJ
   mRT+U4ybwgrBwBDEpqy2Hn2RXzVXXeyGVm0fhNH8FoFquqdpEPwQr3uZP
   uO1PbVa0BslPFAWdqhP/Cp47oYwW6+KDgAn0S059c0eZ4pqU1U5i/Kwxt
   x+8iBFH5zIfRyxwBKz0YNtp0iwnqhoakFeTMcF/DOJ2kqfGZiFnILCTz7
   YY75ozE0Izv5NMxMlO4CLEtm4UFRCf69cyXsysNm4dKlfc/0NItDPPIsZ
   vpwBYPDVbS7FkD2BiQ2aRZURWWv1KiK/W+Y+zhRwKjvJTM2Dw0mUh6Wtu
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="237235267"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="237235267"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:46 -0800
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="495957057"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.194.198])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:46 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 04/10] selftests: mptcp: join: option to execute specific tests
Date:   Wed,  9 Mar 2022 11:16:30 -0800
Message-Id: <20220309191636.258232-5-mathew.j.martineau@linux.intel.com>
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

Often, it is needed to run one specific test.

There are options to run subgroups of tests but when only one fails, no
need to run all the subgroup. So far, the solution was to edit the
script to comment the tests that are not needed but that's not ideal.

Now, it is possible to run one specific test by giving the ID of the
tests that are going to be validated, e.g.

  ./mptcp_join.sh 36 37

This is cleaner and saves time.

Technically, the reset* functions now return 0 if the test can be
executed. This naturally creates sections per test in the code which is
also helpful to understand what a test is exactly doing.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 1629 +++++++++--------
 1 file changed, 877 insertions(+), 752 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 65590f965e4d..a3f6c790765b 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -20,6 +20,7 @@ validate_checksum=0
 init=0
 
 declare -A all_tests
+declare -a only_tests
 TEST_COUNT=0
 nr_blank=40
 
@@ -149,8 +150,30 @@ cleanup()
 	cleanup_partial
 }
 
+skip_test()
+{
+	if [ "${#only_tests[@]}" -eq 0 ]; then
+		return 1
+	fi
+
+	local i
+	for i in "${only_tests[@]}"; do
+		if [ "${TEST_COUNT}" -eq "${i}" ]; then
+			return 1
+		fi
+	done
+
+	return 0
+}
+
 reset()
 {
+	TEST_COUNT=$((TEST_COUNT+1))
+
+	if skip_test; then
+		return 1
+	fi
+
 	if [ "${init}" != "1" ]; then
 		init
 	else
@@ -158,11 +181,13 @@ reset()
 	fi
 
 	init_partial
+
+	return 0
 }
 
 reset_with_cookies()
 {
-	reset
+	reset || return 1
 
 	for netns in "$ns1" "$ns2";do
 		ip netns exec $netns sysctl -q net.ipv4.tcp_syncookies=2
@@ -179,7 +204,7 @@ reset_with_add_addr_timeout()
 		tables="ip6tables"
 	fi
 
-	reset
+	reset || return 1
 
 	ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
 	ip netns exec $ns2 $tables -A OUTPUT -p tcp \
@@ -194,7 +219,7 @@ reset_with_checksum()
 	local ns1_enable=$1
 	local ns2_enable=$2
 
-	reset
+	reset || return 1
 
 	ip netns exec $ns1 sysctl -q net.mptcp.checksum_enabled=$ns1_enable
 	ip netns exec $ns2 sysctl -q net.mptcp.checksum_enabled=$ns2_enable
@@ -207,7 +232,7 @@ reset_with_allow_join_id0()
 	local ns1_enable=$1
 	local ns2_enable=$2
 
-	reset
+	reset || return 1
 
 	ip netns exec $ns1 sysctl -q net.mptcp.allow_join_initial_addr_port=$ns1_enable
 	ip netns exec $ns2 sysctl -q net.mptcp.allow_join_initial_addr_port=$ns2_enable
@@ -520,8 +545,7 @@ do_transfer()
 	speed="$9"
 	sflags="${10}"
 
-	port=$((10000+$TEST_COUNT))
-	TEST_COUNT=$((TEST_COUNT+1))
+	port=$((10000+$TEST_COUNT-1))
 
 	:> "$cout"
 	:> "$sout"
@@ -1381,888 +1405,968 @@ wait_attempt_fail()
 
 subflows_tests()
 {
-	reset
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "no JOIN" "0" "0" "0"
+	if reset; then
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "no JOIN" 0 0 0
+	fi
 
 	# subflow limited by client
-	reset
-	pm_nl_set_limits $ns1 0 0
-	pm_nl_set_limits $ns2 0 0
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "single subflow, limited by client" 0 0 0
+	if reset; then
+		pm_nl_set_limits $ns1 0 0
+		pm_nl_set_limits $ns2 0 0
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "single subflow, limited by client" 0 0 0
+	fi
 
 	# subflow limited by server
-	reset
-	pm_nl_set_limits $ns1 0 0
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "single subflow, limited by server" 1 1 0
+	if reset; then
+		pm_nl_set_limits $ns1 0 0
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "single subflow, limited by server" 1 1 0
+	fi
 
 	# subflow
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "single subflow" 1 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "single subflow" 1 1 1
+	fi
 
 	# multiple subflows
-	reset
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_set_limits $ns2 0 2
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "multiple subflows" 2 2 2
+	if reset; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 0 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "multiple subflows" 2 2 2
+	fi
 
 	# multiple subflows limited by server
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 2
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "multiple subflows, limited by server" 2 2 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "multiple subflows, limited by server" 2 2 1
+	fi
 
 	# single subflow, dev
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow dev ns2eth3
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "single subflow, dev" 1 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow dev ns2eth3
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "single subflow, dev" 1 1 1
+	fi
 }
 
 subflows_error_tests()
 {
 	# If a single subflow is configured, and matches the MPC src
 	# address, no additional subflow should be created
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-	chk_join_nr "no MPC reuse with single endpoint" 0 0 0
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+		chk_join_nr "no MPC reuse with single endpoint" 0 0 0
+	fi
 
 	# multiple subflows, with subflow creation error
-	reset
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_set_limits $ns2 0 2
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
-	ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j REJECT
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-	chk_join_nr "multi subflows, with failing subflow" 1 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 0 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
+		ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j REJECT
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+		chk_join_nr "multi subflows, with failing subflow" 1 1 1
+	fi
 
 	# multiple subflows, with subflow timeout on MPJ
-	reset
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_set_limits $ns2 0 2
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
-	ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j DROP
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-	chk_join_nr "multi subflows, with subflow timeout" 1 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 0 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
+		ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j DROP
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+		chk_join_nr "multi subflows, with subflow timeout" 1 1 1
+	fi
 
 	# multiple subflows, check that the endpoint corresponding to
 	# closed subflow (due to reset) is not reused if additional
 	# subflows are added later
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j REJECT
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow &
-
-	# updates in the child shell do not have any effect here, we
-	# need to bump the test counter for the above case
-	TEST_COUNT=$((TEST_COUNT+1))
-
-	# mpj subflow will be in TW after the reset
-	wait_attempt_fail $ns2
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
-	wait
-
-	# additional subflow could be created only if the PM select
-	# the later endpoint, skipping the already used one
-	chk_join_nr "multi subflows, fair usage on close" 1 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		ip netns exec $ns1 iptables -A INPUT -s 10.0.3.2 -p tcp -j REJECT
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow &
+
+		# mpj subflow will be in TW after the reset
+		wait_attempt_fail $ns2
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
+		wait
+
+		# additional subflow could be created only if the PM select
+		# the later endpoint, skipping the already used one
+		chk_join_nr "multi subflows, fair usage on close" 1 1 1
+	fi
 }
 
 signal_address_tests()
 {
 	# add_address, unused
-	reset
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "unused signal address" 0 0 0
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "unused signal address" 0 0 0
+		chk_add_nr 1 1
+	fi
 
 	# accept and use add_addr
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 1 1
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "signal address" 1 1 1
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "signal address" 1 1 1
+		chk_add_nr 1 1
+	fi
 
 	# accept and use add_addr with an additional subflow
 	# note: signal address in server ns and local addresses in client ns must
 	# belong to different subnets or one of the listed local address could be
 	# used for 'add_addr' subflow
-	reset
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_set_limits $ns2 1 2
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "subflow and signal" 2 2 2
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 1 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "subflow and signal" 2 2 2
+		chk_add_nr 1 1
+	fi
 
 	# accept and use add_addr with additional subflows
-	reset
-	pm_nl_set_limits $ns1 0 3
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_set_limits $ns2 1 3
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "multiple subflows and signal" 3 3 3
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 3
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_set_limits $ns2 1 3
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "multiple subflows and signal" 3 3 3
+		chk_add_nr 1 1
+	fi
 
 	# signal addresses
-	reset
-	pm_nl_set_limits $ns1 3 3
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
-	pm_nl_set_limits $ns2 3 3
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "signal addresses" 3 3 3
-	chk_add_nr 3 3
+	if reset; then
+		pm_nl_set_limits $ns1 3 3
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
+		pm_nl_set_limits $ns2 3 3
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "signal addresses" 3 3 3
+		chk_add_nr 3 3
+	fi
 
 	# signal invalid addresses
-	reset
-	pm_nl_set_limits $ns1 3 3
-	pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
-	pm_nl_set_limits $ns2 3 3
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "signal invalid addresses" 1 1 1
-	chk_add_nr 3 3
+	if reset; then
+		pm_nl_set_limits $ns1 3 3
+		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
+		pm_nl_set_limits $ns2 3 3
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "signal invalid addresses" 1 1 1
+		chk_add_nr 3 3
+	fi
 
 	# signal addresses race test
-	reset
-	pm_nl_set_limits $ns1 4 4
-	pm_nl_set_limits $ns2 4 4
-	pm_nl_add_endpoint $ns1 10.0.1.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
-	pm_nl_add_endpoint $ns2 10.0.1.2 flags signal
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags signal
-	pm_nl_add_endpoint $ns2 10.0.4.2 flags signal
-
-	# the peer could possibly miss some addr notification, allow retransmission
-	ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-	chk_join_nr "signal addresses race test" 3 3 3
-
-	# the server will not signal the address terminating
-	# the MPC subflow
-	chk_add_nr 3 3
+	if reset; then
+		pm_nl_set_limits $ns1 4 4
+		pm_nl_set_limits $ns2 4 4
+		pm_nl_add_endpoint $ns1 10.0.1.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
+		pm_nl_add_endpoint $ns2 10.0.1.2 flags signal
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags signal
+		pm_nl_add_endpoint $ns2 10.0.4.2 flags signal
+
+		# the peer could possibly miss some addr notification, allow retransmission
+		ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+		chk_join_nr "signal addresses race test" 3 3 3
+
+		# the server will not signal the address terminating
+		# the MPC subflow
+		chk_add_nr 3 3
+	fi
 }
 
 link_failure_tests()
 {
 	# accept and use add_addr with additional subflows and link loss
-	reset
-
-	# without any b/w limit each veth could spool the packets and get
-	# them acked at xmit time, so that the corresponding subflow will
-	# have almost always no outstanding pkts, the scheduler will pick
-	# always the first subflow and we will have hard time testing
-	# active backup and link switch-over.
-	# Let's set some arbitrary (low) virtual link limits.
-	init_shapers
-	pm_nl_set_limits $ns1 0 3
-	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
-	pm_nl_set_limits $ns2 1 3
-	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.4.2 dev ns2eth4 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1 1
-	chk_join_nr "multiple flows, signal, link failure" 3 3 3
-	chk_add_nr 1 1
-	chk_stale_nr $ns2 1 5 1
+	if reset; then
+		# without any b/w limit each veth could spool the packets and get
+		# them acked at xmit time, so that the corresponding subflow will
+		# have almost always no outstanding pkts, the scheduler will pick
+		# always the first subflow and we will have hard time testing
+		# active backup and link switch-over.
+		# Let's set some arbitrary (low) virtual link limits.
+		init_shapers
+		pm_nl_set_limits $ns1 0 3
+		pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
+		pm_nl_set_limits $ns2 1 3
+		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.4.2 dev ns2eth4 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 1
+		chk_join_nr "multiple flows, signal, link failure" 3 3 3
+		chk_add_nr 1 1
+		chk_stale_nr $ns2 1 5 1
+	fi
 
 	# accept and use add_addr with additional subflows and link loss
 	# for bidirectional transfer
-	reset
-	init_shapers
-	pm_nl_set_limits $ns1 0 3
-	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
-	pm_nl_set_limits $ns2 1 3
-	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.4.2 dev ns2eth4 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1 2
-	chk_join_nr "multi flows, signal, bidi, link fail" 3 3 3
-	chk_add_nr 1 1
-	chk_stale_nr $ns2 1 -1 1
+	if reset; then
+		init_shapers
+		pm_nl_set_limits $ns1 0 3
+		pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
+		pm_nl_set_limits $ns2 1 3
+		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.4.2 dev ns2eth4 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 2
+		chk_join_nr "multi flows, signal, bidi, link fail" 3 3 3
+		chk_add_nr 1 1
+		chk_stale_nr $ns2 1 -1 1
+	fi
 
 	# 2 subflows plus 1 backup subflow with a lossy link, backup
 	# will never be used
-	reset
-	init_shapers
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
-	pm_nl_set_limits $ns2 1 2
-	FAILING_LINKS="1"
-	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
-	run_tests $ns1 $ns2 10.0.1.1 1
-	chk_join_nr "backup subflow unused, link failure" 2 2 2
-	chk_add_nr 1 1
-	chk_link_usage $ns2 ns2eth3 $cinsent 0
+	if reset; then
+		init_shapers
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
+		pm_nl_set_limits $ns2 1 2
+		FAILING_LINKS="1"
+		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
+		run_tests $ns1 $ns2 10.0.1.1 1
+		chk_join_nr "backup subflow unused, link failure" 2 2 2
+		chk_add_nr 1 1
+		chk_link_usage $ns2 ns2eth3 $cinsent 0
+	fi
 
 	# 2 lossy links after half transfer, backup will get half of
 	# the traffic
-	reset
-	init_shapers
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
-	pm_nl_set_limits $ns2 1 2
-	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
-	FAILING_LINKS="1 2"
-	run_tests $ns1 $ns2 10.0.1.1 1
-	chk_join_nr "backup flow used, multi links fail" 2 2 2
-	chk_add_nr 1 1
-	chk_stale_nr $ns2 2 4 2
-	chk_link_usage $ns2 ns2eth3 $cinsent 50
+	if reset; then
+		init_shapers
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
+		pm_nl_set_limits $ns2 1 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
+		FAILING_LINKS="1 2"
+		run_tests $ns1 $ns2 10.0.1.1 1
+		chk_join_nr "backup flow used, multi links fail" 2 2 2
+		chk_add_nr 1 1
+		chk_stale_nr $ns2 2 4 2
+		chk_link_usage $ns2 ns2eth3 $cinsent 50
+	fi
 
 	# use a backup subflow with the first subflow on a lossy link
 	# for bidirectional transfer
-	reset
-	init_shapers
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
-	pm_nl_set_limits $ns2 1 3
-	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
-	FAILING_LINKS="1 2"
-	run_tests $ns1 $ns2 10.0.1.1 2
-	chk_join_nr "backup flow used, bidi, link failure" 2 2 2
-	chk_add_nr 1 1
-	chk_stale_nr $ns2 1 -1 2
-	chk_link_usage $ns2 ns2eth3 $cinsent 50
+	if reset; then
+		init_shapers
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
+		pm_nl_set_limits $ns2 1 3
+		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
+		FAILING_LINKS="1 2"
+		run_tests $ns1 $ns2 10.0.1.1 2
+		chk_join_nr "backup flow used, bidi, link failure" 2 2 2
+		chk_add_nr 1 1
+		chk_stale_nr $ns2 1 -1 2
+		chk_link_usage $ns2 ns2eth3 $cinsent 50
+	fi
 }
 
 add_addr_timeout_tests()
 {
 	# add_addr timeout
-	reset_with_add_addr_timeout
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 1 1
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-	chk_join_nr "signal address, ADD_ADDR timeout" 1 1 1
-	chk_add_nr 4 0
+	if reset_with_add_addr_timeout; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+		chk_join_nr "signal address, ADD_ADDR timeout" 1 1 1
+		chk_add_nr 4 0
+	fi
 
 	# add_addr timeout IPv6
-	reset_with_add_addr_timeout 6
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 1 1
-	pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
-	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
-	chk_join_nr "signal address, ADD_ADDR6 timeout" 1 1 1
-	chk_add_nr 4 0
+	if reset_with_add_addr_timeout 6; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
+		run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+		chk_join_nr "signal address, ADD_ADDR6 timeout" 1 1 1
+		chk_add_nr 4 0
+	fi
 
 	# signal addresses timeout
-	reset_with_add_addr_timeout
-	pm_nl_set_limits $ns1 2 2
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-	pm_nl_set_limits $ns2 2 2
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 speed_10
-	chk_join_nr "signal addresses, ADD_ADDR timeout" 2 2 2
-	chk_add_nr 8 0
+	if reset_with_add_addr_timeout; then
+		pm_nl_set_limits $ns1 2 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+		pm_nl_set_limits $ns2 2 2
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 speed_10
+		chk_join_nr "signal addresses, ADD_ADDR timeout" 2 2 2
+		chk_add_nr 8 0
+	fi
 
 	# signal invalid addresses timeout
-	reset_with_add_addr_timeout
-	pm_nl_set_limits $ns1 2 2
-	pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-	pm_nl_set_limits $ns2 2 2
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 speed_10
-	chk_join_nr "invalid address, ADD_ADDR timeout" 1 1 1
-	chk_add_nr 8 0
+	if reset_with_add_addr_timeout; then
+		pm_nl_set_limits $ns1 2 2
+		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+		pm_nl_set_limits $ns2 2 2
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 speed_10
+		chk_join_nr "invalid address, ADD_ADDR timeout" 1 1 1
+		chk_add_nr 8 0
+	fi
 }
 
 remove_tests()
 {
 	# single subflow, remove
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1 0 0 -1 slow
-	chk_join_nr "remove single subflow" 1 1 1
-	chk_rm_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 0 0 -1 slow
+		chk_join_nr "remove single subflow" 1 1 1
+		chk_rm_nr 1 1
+	fi
 
 	# multiple subflows, remove
-	reset
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_set_limits $ns2 0 2
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1 0 0 -2 slow
-	chk_join_nr "remove multiple subflows" 2 2 2
-	chk_rm_nr 2 2
+	if reset; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 0 2
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 0 0 -2 slow
+		chk_join_nr "remove multiple subflows" 2 2 2
+		chk_rm_nr 2 2
+	fi
 
 	# single address, remove
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_set_limits $ns2 1 1
-	run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
-	chk_join_nr "remove single address" 1 1 1
-	chk_add_nr 1 1
-	chk_rm_nr 1 1 invert
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_set_limits $ns2 1 1
+		run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
+		chk_join_nr "remove single address" 1 1 1
+		chk_add_nr 1 1
+		chk_rm_nr 1 1 invert
+	fi
 
 	# subflow and signal, remove
-	reset
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_set_limits $ns2 1 2
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
-	chk_join_nr "remove subflow and signal" 2 2 2
-	chk_add_nr 1 1
-	chk_rm_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_set_limits $ns2 1 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
+		chk_join_nr "remove subflow and signal" 2 2 2
+		chk_add_nr 1 1
+		chk_rm_nr 1 1
+	fi
 
 	# subflows and signal, remove
-	reset
-	pm_nl_set_limits $ns1 0 3
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_set_limits $ns2 1 3
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 slow
-	chk_join_nr "remove subflows and signal" 3 3 3
-	chk_add_nr 1 1
-	chk_rm_nr 2 2
+	if reset; then
+		pm_nl_set_limits $ns1 0 3
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_set_limits $ns2 1 3
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 slow
+		chk_join_nr "remove subflows and signal" 3 3 3
+		chk_add_nr 1 1
+		chk_rm_nr 2 2
+	fi
 
 	# addresses remove
-	reset
-	pm_nl_set_limits $ns1 3 3
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal id 250
-	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
-	pm_nl_set_limits $ns2 3 3
-	run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
-	chk_join_nr "remove addresses" 3 3 3
-	chk_add_nr 3 3
-	chk_rm_nr 3 3 invert
+	if reset; then
+		pm_nl_set_limits $ns1 3 3
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal id 250
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
+		pm_nl_set_limits $ns2 3 3
+		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
+		chk_join_nr "remove addresses" 3 3 3
+		chk_add_nr 3 3
+		chk_rm_nr 3 3 invert
+	fi
 
 	# invalid addresses remove
-	reset
-	pm_nl_set_limits $ns1 3 3
-	pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
-	pm_nl_set_limits $ns2 3 3
-	run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
-	chk_join_nr "remove invalid addresses" 1 1 1
-	chk_add_nr 3 3
-	chk_rm_nr 3 1 invert
+	if reset; then
+		pm_nl_set_limits $ns1 3 3
+		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
+		pm_nl_set_limits $ns2 3 3
+		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
+		chk_join_nr "remove invalid addresses" 1 1 1
+		chk_add_nr 3 3
+		chk_rm_nr 3 1 invert
+	fi
 
 	# subflows and signal, flush
-	reset
-	pm_nl_set_limits $ns1 0 3
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_set_limits $ns2 1 3
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
-	chk_join_nr "flush subflows and signal" 3 3 3
-	chk_add_nr 1 1
-	chk_rm_nr 1 3 invert simult
+	if reset; then
+		pm_nl_set_limits $ns1 0 3
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_set_limits $ns2 1 3
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
+		chk_join_nr "flush subflows and signal" 3 3 3
+		chk_add_nr 1 1
+		chk_rm_nr 1 3 invert simult
+	fi
 
 	# subflows flush
-	reset
-	pm_nl_set_limits $ns1 3 3
-	pm_nl_set_limits $ns2 3 3
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow id 150
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
-	chk_join_nr "flush subflows" 3 3 3
-	chk_rm_nr 0 3 simult
+	if reset; then
+		pm_nl_set_limits $ns1 3 3
+		pm_nl_set_limits $ns2 3 3
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow id 150
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
+		chk_join_nr "flush subflows" 3 3 3
+		chk_rm_nr 0 3 simult
+	fi
 
 	# addresses flush
-	reset
-	pm_nl_set_limits $ns1 3 3
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal id 250
-	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
-	pm_nl_set_limits $ns2 3 3
-	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
-	chk_join_nr "flush addresses" 3 3 3
-	chk_add_nr 3 3
-	chk_rm_nr 3 3 invert simult
+	if reset; then
+		pm_nl_set_limits $ns1 3 3
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal id 250
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
+		pm_nl_set_limits $ns2 3 3
+		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
+		chk_join_nr "flush addresses" 3 3 3
+		chk_add_nr 3 3
+		chk_rm_nr 3 3 invert simult
+	fi
 
 	# invalid addresses flush
-	reset
-	pm_nl_set_limits $ns1 3 3
-	pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-	pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
-	pm_nl_set_limits $ns2 3 3
-	run_tests $ns1 $ns2 10.0.1.1 0 -8 0 slow
-	chk_join_nr "flush invalid addresses" 1 1 1
-	chk_add_nr 3 3
-	chk_rm_nr 3 1 invert
+	if reset; then
+		pm_nl_set_limits $ns1 3 3
+		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
+		pm_nl_set_limits $ns2 3 3
+		run_tests $ns1 $ns2 10.0.1.1 0 -8 0 slow
+		chk_join_nr "flush invalid addresses" 1 1 1
+		chk_add_nr 3 3
+		chk_rm_nr 3 1 invert
+	fi
 
 	# remove id 0 subflow
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1 0 0 -9 slow
-	chk_join_nr "remove id 0 subflow" 1 1 1
-	chk_rm_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 0 0 -9 slow
+		chk_join_nr "remove id 0 subflow" 1 1 1
+		chk_rm_nr 1 1
+	fi
 
 	# remove id 0 address
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_set_limits $ns2 1 1
-	run_tests $ns1 $ns2 10.0.1.1 0 -9 0 slow
-	chk_join_nr "remove id 0 address" 1 1 1
-	chk_add_nr 1 1
-	chk_rm_nr 1 1 invert
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_set_limits $ns2 1 1
+		run_tests $ns1 $ns2 10.0.1.1 0 -9 0 slow
+		chk_join_nr "remove id 0 address" 1 1 1
+		chk_add_nr 1 1
+		chk_rm_nr 1 1 invert
+	fi
 }
 
 add_tests()
 {
 	# add single subflow
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow
-	chk_join_nr "add single subflow" 1 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow
+		chk_join_nr "add single subflow" 1 1 1
+	fi
 
 	# add signal address
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 1 1
-	run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
-	chk_join_nr "add signal address" 1 1 1
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 1 1
+		run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
+		chk_join_nr "add signal address" 1 1 1
+		chk_add_nr 1 1
+	fi
 
 	# add multiple subflows
-	reset
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_set_limits $ns2 0 2
-	run_tests $ns1 $ns2 10.0.1.1 0 0 2 slow
-	chk_join_nr "add multiple subflows" 2 2 2
+	if reset; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 0 2
+		run_tests $ns1 $ns2 10.0.1.1 0 0 2 slow
+		chk_join_nr "add multiple subflows" 2 2 2
+	fi
 
 	# add multiple subflows IPv6
-	reset
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_set_limits $ns2 0 2
-	run_tests $ns1 $ns2 dead:beef:1::1 0 0 2 slow
-	chk_join_nr "add multiple subflows IPv6" 2 2 2
+	if reset; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 0 2
+		run_tests $ns1 $ns2 dead:beef:1::1 0 0 2 slow
+		chk_join_nr "add multiple subflows IPv6" 2 2 2
+	fi
 
 	# add multiple addresses IPv6
-	reset
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_set_limits $ns2 2 2
-	run_tests $ns1 $ns2 dead:beef:1::1 0 2 0 slow
-	chk_join_nr "add multiple addresses IPv6" 2 2 2
-	chk_add_nr 2 2
+	if reset; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 2 2
+		run_tests $ns1 $ns2 dead:beef:1::1 0 2 0 slow
+		chk_join_nr "add multiple addresses IPv6" 2 2 2
+		chk_add_nr 2 2
+	fi
 }
 
 ipv6_tests()
 {
 	# subflow IPv6
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 dead:beef:3::2 dev ns2eth3 flags subflow
-	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
-	chk_join_nr "single subflow IPv6" 1 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 dead:beef:3::2 dev ns2eth3 flags subflow
+		run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+		chk_join_nr "single subflow IPv6" 1 1 1
+	fi
 
 	# add_address, unused IPv6
-	reset
-	pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
-	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
-	chk_join_nr "unused signal address IPv6" 0 0 0
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
+		run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+		chk_join_nr "unused signal address IPv6" 0 0 0
+		chk_add_nr 1 1
+	fi
 
 	# signal address IPv6
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
-	pm_nl_set_limits $ns2 1 1
-	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
-	chk_join_nr "single address IPv6" 1 1 1
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
+		pm_nl_set_limits $ns2 1 1
+		run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+		chk_join_nr "single address IPv6" 1 1 1
+		chk_add_nr 1 1
+	fi
 
 	# single address IPv6, remove
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
-	pm_nl_set_limits $ns2 1 1
-	run_tests $ns1 $ns2 dead:beef:1::1 0 -1 0 slow
-	chk_join_nr "remove single address IPv6" 1 1 1
-	chk_add_nr 1 1
-	chk_rm_nr 1 1 invert
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
+		pm_nl_set_limits $ns2 1 1
+		run_tests $ns1 $ns2 dead:beef:1::1 0 -1 0 slow
+		chk_join_nr "remove single address IPv6" 1 1 1
+		chk_add_nr 1 1
+		chk_rm_nr 1 1 invert
+	fi
 
 	# subflow and signal IPv6, remove
-	reset
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
-	pm_nl_set_limits $ns2 1 2
-	pm_nl_add_endpoint $ns2 dead:beef:3::2 dev ns2eth3 flags subflow
-	run_tests $ns1 $ns2 dead:beef:1::1 0 -1 -1 slow
-	chk_join_nr "remove subflow and signal IPv6" 2 2 2
-	chk_add_nr 1 1
-	chk_rm_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_add_endpoint $ns1 dead:beef:2::1 flags signal
+		pm_nl_set_limits $ns2 1 2
+		pm_nl_add_endpoint $ns2 dead:beef:3::2 dev ns2eth3 flags subflow
+		run_tests $ns1 $ns2 dead:beef:1::1 0 -1 -1 slow
+		chk_join_nr "remove subflow and signal IPv6" 2 2 2
+		chk_add_nr 1 1
+		chk_rm_nr 1 1
+	fi
 }
 
 v4mapped_tests()
 {
 	# subflow IPv4-mapped to IPv4-mapped
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 "::ffff:10.0.3.2" flags subflow
-	run_tests $ns1 $ns2 "::ffff:10.0.1.1"
-	chk_join_nr "single subflow IPv4-mapped" 1 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 "::ffff:10.0.3.2" flags subflow
+		run_tests $ns1 $ns2 "::ffff:10.0.1.1"
+		chk_join_nr "single subflow IPv4-mapped" 1 1 1
+	fi
 
 	# signal address IPv4-mapped with IPv4-mapped sk
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 1 1
-	pm_nl_add_endpoint $ns1 "::ffff:10.0.2.1" flags signal
-	run_tests $ns1 $ns2 "::ffff:10.0.1.1"
-	chk_join_nr "signal address IPv4-mapped" 1 1 1
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 "::ffff:10.0.2.1" flags signal
+		run_tests $ns1 $ns2 "::ffff:10.0.1.1"
+		chk_join_nr "signal address IPv4-mapped" 1 1 1
+		chk_add_nr 1 1
+	fi
 
 	# subflow v4-map-v6
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 "::ffff:10.0.1.1"
-	chk_join_nr "single subflow v4-map-v6" 1 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 "::ffff:10.0.1.1"
+		chk_join_nr "single subflow v4-map-v6" 1 1 1
+	fi
 
 	# signal address v4-map-v6
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 1 1
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	run_tests $ns1 $ns2 "::ffff:10.0.1.1"
-	chk_join_nr "signal address v4-map-v6" 1 1 1
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		run_tests $ns1 $ns2 "::ffff:10.0.1.1"
+		chk_join_nr "signal address v4-map-v6" 1 1 1
+		chk_add_nr 1 1
+	fi
 
 	# subflow v6-map-v4
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 "::ffff:10.0.3.2" flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "single subflow v6-map-v4" 1 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 "::ffff:10.0.3.2" flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "single subflow v6-map-v4" 1 1 1
+	fi
 
 	# signal address v6-map-v4
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 1 1
-	pm_nl_add_endpoint $ns1 "::ffff:10.0.2.1" flags signal
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "signal address v6-map-v4" 1 1 1
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 "::ffff:10.0.2.1" flags signal
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "signal address v6-map-v4" 1 1 1
+		chk_add_nr 1 1
+	fi
 
 	# no subflow IPv6 to v4 address
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 dead:beef:2::2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "no JOIN with diff families v4-v6" 0 0 0
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 dead:beef:2::2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "no JOIN with diff families v4-v6" 0 0 0
+	fi
 
 	# no subflow IPv6 to v4 address even if v6 has a valid v4 at the end
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 dead:beef:2::10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "no JOIN with diff families v4-v6-2" 0 0 0
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 dead:beef:2::10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "no JOIN with diff families v4-v6-2" 0 0 0
+	fi
 
 	# no subflow IPv4 to v6 address, no need to slow down too then
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 dead:beef:1::1
-	chk_join_nr "no JOIN with diff families v6-v4" 0 0 0
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 dead:beef:1::1
+		chk_join_nr "no JOIN with diff families v6-v4" 0 0 0
+	fi
 }
 
 backup_tests()
 {
 	# single subflow, backup
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup
-	chk_join_nr "single subflow, backup" 1 1 1
-	chk_prio_nr 0 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup
+		chk_join_nr "single subflow, backup" 1 1 1
+		chk_prio_nr 0 1
+	fi
 
 	# single address, backup
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_set_limits $ns2 1 1
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
-	chk_join_nr "single address, backup" 1 1 1
-	chk_add_nr 1 1
-	chk_prio_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_set_limits $ns2 1 1
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
+		chk_join_nr "single address, backup" 1 1 1
+		chk_add_nr 1 1
+		chk_prio_nr 1 1
+	fi
 
 	# single address with port, backup
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
-	pm_nl_set_limits $ns2 1 1
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
-	chk_join_nr "single address with port, backup" 1 1 1
-	chk_add_nr 1 1
-	chk_prio_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+		pm_nl_set_limits $ns2 1 1
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
+		chk_join_nr "single address with port, backup" 1 1 1
+		chk_add_nr 1 1
+		chk_prio_nr 1 1
+	fi
 }
 
 add_addr_ports_tests()
 {
 	# signal address with port
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 1 1
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "signal address with port" 1 1 1
-	chk_add_nr 1 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "signal address with port" 1 1 1
+		chk_add_nr 1 1 1
+	fi
 
 	# subflow and signal with port
-	reset
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_set_limits $ns2 1 2
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "subflow and signal with port" 2 2 2
-	chk_add_nr 1 1 1
+	if reset; then
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 1 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "subflow and signal with port" 2 2 2
+		chk_add_nr 1 1 1
+	fi
 
 	# single address with port, remove
-	reset
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
-	pm_nl_set_limits $ns2 1 1
-	run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
-	chk_join_nr "remove single address with port" 1 1 1
-	chk_add_nr 1 1 1
-	chk_rm_nr 1 1 invert
+	if reset; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+		pm_nl_set_limits $ns2 1 1
+		run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
+		chk_join_nr "remove single address with port" 1 1 1
+		chk_add_nr 1 1 1
+		chk_rm_nr 1 1 invert
+	fi
 
 	# subflow and signal with port, remove
-	reset
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
-	pm_nl_set_limits $ns2 1 2
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
-	chk_join_nr "remove subflow and signal with port" 2 2 2
-	chk_add_nr 1 1 1
-	chk_rm_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+		pm_nl_set_limits $ns2 1 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
+		chk_join_nr "remove subflow and signal with port" 2 2 2
+		chk_add_nr 1 1 1
+		chk_rm_nr 1 1
+	fi
 
 	# subflows and signal with port, flush
-	reset
-	pm_nl_set_limits $ns1 0 3
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
-	pm_nl_set_limits $ns2 1 3
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1 0 -8 -2 slow
-	chk_join_nr "flush subflows and signal with port" 3 3 3
-	chk_add_nr 1 1
-	chk_rm_nr 1 3 invert simult
+	if reset; then
+		pm_nl_set_limits $ns1 0 3
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+		pm_nl_set_limits $ns2 1 3
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 0 -8 -2 slow
+		chk_join_nr "flush subflows and signal with port" 3 3 3
+		chk_add_nr 1 1
+		chk_rm_nr 1 3 invert simult
+	fi
 
 	# multiple addresses with port
-	reset
-	pm_nl_set_limits $ns1 2 2
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
-	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal port 10100
-	pm_nl_set_limits $ns2 2 2
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "multiple addresses with port" 2 2 2
-	chk_add_nr 2 2 2
+	if reset; then
+		pm_nl_set_limits $ns1 2 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal port 10100
+		pm_nl_set_limits $ns2 2 2
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "multiple addresses with port" 2 2 2
+		chk_add_nr 2 2 2
+	fi
 
 	# multiple addresses with ports
-	reset
-	pm_nl_set_limits $ns1 2 2
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
-	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal port 10101
-	pm_nl_set_limits $ns2 2 2
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "multiple addresses with ports" 2 2 2
-	chk_add_nr 2 2 2
+	if reset; then
+		pm_nl_set_limits $ns1 2 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal port 10101
+		pm_nl_set_limits $ns2 2 2
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "multiple addresses with ports" 2 2 2
+		chk_add_nr 2 2 2
+	fi
 }
 
 syncookies_tests()
 {
 	# single subflow, syncookies
-	reset_with_cookies
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "single subflow with syn cookies" 1 1 1
+	if reset_with_cookies; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "single subflow with syn cookies" 1 1 1
+	fi
 
 	# multiple subflows with syn cookies
-	reset_with_cookies
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_set_limits $ns2 0 2
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "multiple subflows with syn cookies" 2 2 2
+	if reset_with_cookies; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 0 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "multiple subflows with syn cookies" 2 2 2
+	fi
 
 	# multiple subflows limited by server
-	reset_with_cookies
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 2
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "subflows limited by server w cookies" 2 1 1
+	if reset_with_cookies; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "subflows limited by server w cookies" 2 1 1
+	fi
 
 	# test signal address with cookies
-	reset_with_cookies
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 1 1
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "signal address with syn cookies" 1 1 1
-	chk_add_nr 1 1
+	if reset_with_cookies; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "signal address with syn cookies" 1 1 1
+		chk_add_nr 1 1
+	fi
 
 	# test cookie with subflow and signal
-	reset_with_cookies
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_set_limits $ns1 0 2
-	pm_nl_set_limits $ns2 1 2
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "subflow and signal w cookies" 2 2 2
-	chk_add_nr 1 1
+	if reset_with_cookies; then
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 1 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "subflow and signal w cookies" 2 2 2
+		chk_add_nr 1 1
+	fi
 
 	# accept and use add_addr with additional subflows
-	reset_with_cookies
-	pm_nl_set_limits $ns1 0 3
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_set_limits $ns2 1 3
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "subflows and signal w. cookies" 3 3 3
-	chk_add_nr 1 1
+	if reset_with_cookies; then
+		pm_nl_set_limits $ns1 0 3
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_set_limits $ns2 1 3
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "subflows and signal w. cookies" 3 3 3
+		chk_add_nr 1 1
+	fi
 }
 
 checksum_tests()
 {
 	# checksum test 0 0
-	reset_with_checksum 0 0
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "checksum test 0 0" 0 0 0
+	if reset_with_checksum 0 0; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "checksum test 0 0" 0 0 0
+	fi
 
 	# checksum test 1 1
-	reset_with_checksum 1 1
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "checksum test 1 1" 0 0 0
+	if reset_with_checksum 1 1; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "checksum test 1 1" 0 0 0
+	fi
 
 	# checksum test 0 1
-	reset_with_checksum 0 1
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "checksum test 0 1" 0 0 0
+	if reset_with_checksum 0 1; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "checksum test 0 1" 0 0 0
+	fi
 
 	# checksum test 1 0
-	reset_with_checksum 1 0
-	pm_nl_set_limits $ns1 0 1
-	pm_nl_set_limits $ns2 0 1
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "checksum test 1 0" 0 0 0
+	if reset_with_checksum 1 0; then
+		pm_nl_set_limits $ns1 0 1
+		pm_nl_set_limits $ns2 0 1
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "checksum test 1 0" 0 0 0
+	fi
 }
 
 deny_join_id0_tests()
 {
 	# subflow allow join id0 ns1
-	reset_with_allow_join_id0 1 0
-	pm_nl_set_limits $ns1 1 1
-	pm_nl_set_limits $ns2 1 1
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "single subflow allow join id0 ns1" 1 1 1
+	if reset_with_allow_join_id0 1 0; then
+		pm_nl_set_limits $ns1 1 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "single subflow allow join id0 ns1" 1 1 1
+	fi
 
 	# subflow allow join id0 ns2
-	reset_with_allow_join_id0 0 1
-	pm_nl_set_limits $ns1 1 1
-	pm_nl_set_limits $ns2 1 1
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "single subflow allow join id0 ns2" 0 0 0
+	if reset_with_allow_join_id0 0 1; then
+		pm_nl_set_limits $ns1 1 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "single subflow allow join id0 ns2" 0 0 0
+	fi
 
 	# signal address allow join id0 ns1
 	# ADD_ADDRs are not affected by allow_join_id0 value.
-	reset_with_allow_join_id0 1 0
-	pm_nl_set_limits $ns1 1 1
-	pm_nl_set_limits $ns2 1 1
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "signal address allow join id0 ns1" 1 1 1
-	chk_add_nr 1 1
+	if reset_with_allow_join_id0 1 0; then
+		pm_nl_set_limits $ns1 1 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "signal address allow join id0 ns1" 1 1 1
+		chk_add_nr 1 1
+	fi
 
 	# signal address allow join id0 ns2
 	# ADD_ADDRs are not affected by allow_join_id0 value.
-	reset_with_allow_join_id0 0 1
-	pm_nl_set_limits $ns1 1 1
-	pm_nl_set_limits $ns2 1 1
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "signal address allow join id0 ns2" 1 1 1
-	chk_add_nr 1 1
+	if reset_with_allow_join_id0 0 1; then
+		pm_nl_set_limits $ns1 1 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "signal address allow join id0 ns2" 1 1 1
+		chk_add_nr 1 1
+	fi
 
 	# subflow and address allow join id0 ns1
-	reset_with_allow_join_id0 1 0
-	pm_nl_set_limits $ns1 2 2
-	pm_nl_set_limits $ns2 2 2
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "subflow and address allow join id0 1" 2 2 2
+	if reset_with_allow_join_id0 1 0; then
+		pm_nl_set_limits $ns1 2 2
+		pm_nl_set_limits $ns2 2 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "subflow and address allow join id0 1" 2 2 2
+	fi
 
 	# subflow and address allow join id0 ns2
-	reset_with_allow_join_id0 0 1
-	pm_nl_set_limits $ns1 2 2
-	pm_nl_set_limits $ns2 2 2
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-	run_tests $ns1 $ns2 10.0.1.1
-	chk_join_nr "subflow and address allow join id0 2" 1 1 1
+	if reset_with_allow_join_id0 0 1; then
+		pm_nl_set_limits $ns1 2 2
+		pm_nl_set_limits $ns2 2 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr "subflow and address allow join id0 2" 1 1 1
+	fi
 }
 
 fullmesh_tests()
@@ -2270,119 +2374,128 @@ fullmesh_tests()
 	# fullmesh 1
 	# 2 fullmesh addrs in ns2, added before the connection,
 	# 1 non-fullmesh addr in ns1, added during the connection.
-	reset
-	pm_nl_set_limits $ns1 0 4
-	pm_nl_set_limits $ns2 1 4
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,fullmesh
-	pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,fullmesh
-	run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
-	chk_join_nr "fullmesh test 2x1" 4 4 4
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 0 4
+		pm_nl_set_limits $ns2 1 4
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,fullmesh
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,fullmesh
+		run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
+		chk_join_nr "fullmesh test 2x1" 4 4 4
+		chk_add_nr 1 1
+	fi
 
 	# fullmesh 2
 	# 1 non-fullmesh addr in ns1, added before the connection,
 	# 1 fullmesh addr in ns2, added during the connection.
-	reset
-	pm_nl_set_limits $ns1 1 3
-	pm_nl_set_limits $ns2 1 3
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_1 slow
-	chk_join_nr "fullmesh test 1x1" 3 3 3
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 1 3
+		pm_nl_set_limits $ns2 1 3
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_1 slow
+		chk_join_nr "fullmesh test 1x1" 3 3 3
+		chk_add_nr 1 1
+	fi
 
 	# fullmesh 3
 	# 1 non-fullmesh addr in ns1, added before the connection,
 	# 2 fullmesh addrs in ns2, added during the connection.
-	reset
-	pm_nl_set_limits $ns1 2 5
-	pm_nl_set_limits $ns2 1 5
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_2 slow
-	chk_join_nr "fullmesh test 1x2" 5 5 5
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 2 5
+		pm_nl_set_limits $ns2 1 5
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_2 slow
+		chk_join_nr "fullmesh test 1x2" 5 5 5
+		chk_add_nr 1 1
+	fi
 
 	# fullmesh 4
 	# 1 non-fullmesh addr in ns1, added before the connection,
 	# 2 fullmesh addrs in ns2, added during the connection,
 	# limit max_subflows to 4.
-	reset
-	pm_nl_set_limits $ns1 2 4
-	pm_nl_set_limits $ns2 1 4
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_2 slow
-	chk_join_nr "fullmesh test 1x2, limited" 4 4 4
-	chk_add_nr 1 1
+	if reset; then
+		pm_nl_set_limits $ns1 2 4
+		pm_nl_set_limits $ns2 1 4
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_2 slow
+		chk_join_nr "fullmesh test 1x2, limited" 4 4 4
+		chk_add_nr 1 1
+	fi
 
 	# set fullmesh flag
-	reset
-	pm_nl_set_limits $ns1 4 4
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow
-	pm_nl_set_limits $ns2 4 4
-	run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow fullmesh
-	chk_join_nr "set fullmesh flag test" 2 2 2
-	chk_rm_nr 0 1
+	if reset; then
+		pm_nl_set_limits $ns1 4 4
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow
+		pm_nl_set_limits $ns2 4 4
+		run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow fullmesh
+		chk_join_nr "set fullmesh flag test" 2 2 2
+		chk_rm_nr 0 1
+	fi
 
 	# set nofullmesh flag
-	reset
-	pm_nl_set_limits $ns1 4 4
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow,fullmesh
-	pm_nl_set_limits $ns2 4 4
-	run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_1 slow nofullmesh
-	chk_join_nr "set nofullmesh flag test" 2 2 2
-	chk_rm_nr 0 1
+	if reset; then
+		pm_nl_set_limits $ns1 4 4
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow,fullmesh
+		pm_nl_set_limits $ns2 4 4
+		run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_1 slow nofullmesh
+		chk_join_nr "set nofullmesh flag test" 2 2 2
+		chk_rm_nr 0 1
+	fi
 
 	# set backup,fullmesh flags
-	reset
-	pm_nl_set_limits $ns1 4 4
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow
-	pm_nl_set_limits $ns2 4 4
-	run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow backup,fullmesh
-	chk_join_nr "set backup,fullmesh flags test" 2 2 2
-	chk_prio_nr 0 1
-	chk_rm_nr 0 1
+	if reset; then
+		pm_nl_set_limits $ns1 4 4
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow
+		pm_nl_set_limits $ns2 4 4
+		run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow backup,fullmesh
+		chk_join_nr "set backup,fullmesh flags test" 2 2 2
+		chk_prio_nr 0 1
+		chk_rm_nr 0 1
+	fi
 
 	# set nobackup,nofullmesh flags
-	reset
-	pm_nl_set_limits $ns1 4 4
-	pm_nl_set_limits $ns2 4 4
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,backup,fullmesh
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup,nofullmesh
-	chk_join_nr "set nobackup,nofullmesh flags test" 2 2 2
-	chk_prio_nr 0 1
-	chk_rm_nr 0 1
+	if reset; then
+		pm_nl_set_limits $ns1 4 4
+		pm_nl_set_limits $ns2 4 4
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,backup,fullmesh
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup,nofullmesh
+		chk_join_nr "set nobackup,nofullmesh flags test" 2 2 2
+		chk_prio_nr 0 1
+		chk_rm_nr 0 1
+	fi
 }
 
 fastclose_tests()
 {
-	reset
-	run_tests $ns1 $ns2 10.0.1.1 1024 0 fastclose_2
-	chk_join_nr "fastclose test" 0 0 0
-	chk_fclose_nr 1 1
-	chk_rst_nr 1 1 invert
+	if reset; then
+		run_tests $ns1 $ns2 10.0.1.1 1024 0 fastclose_2
+		chk_join_nr "fastclose test" 0 0 0
+		chk_fclose_nr 1 1
+		chk_rst_nr 1 1 invert
+	fi
 }
 
 implicit_tests()
 {
 	# userspace pm type prevents add_addr
-	reset
-	pm_nl_set_limits $ns1 2 2
-	pm_nl_set_limits $ns2 2 2
-	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow &
-
-	wait_mpj $ns1
-	TEST_COUNT=$((TEST_COUNT + 1))
-	pm_nl_check_endpoint "implicit EP" "creation" \
-		$ns2 10.0.2.2 id 1 flags implicit
-
-	pm_nl_add_endpoint $ns2 10.0.2.2 id 33
-	pm_nl_check_endpoint "" "ID change is prevented" \
-		$ns2 10.0.2.2 id 1 flags implicit
-
-	pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
-	pm_nl_check_endpoint "" "modif is allowed" \
-		$ns2 10.0.2.2 id 1 flags signal
-	wait
+	if reset; then
+		pm_nl_set_limits $ns1 2 2
+		pm_nl_set_limits $ns2 2 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow &
+
+		wait_mpj $ns1
+		pm_nl_check_endpoint "implicit EP" "creation" \
+			$ns2 10.0.2.2 id 1 flags implicit
+
+		pm_nl_add_endpoint $ns2 10.0.2.2 id 33
+		pm_nl_check_endpoint "" "ID change is prevented" \
+			$ns2 10.0.2.2 id 1 flags implicit
+
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
+		pm_nl_check_endpoint "" "modif is allowed" \
+			$ns2 10.0.2.2 id 1 flags signal
+		wait
+	fi
 }
 
 # [$1: error message]
@@ -2405,6 +2518,8 @@ usage()
 	echo "  -i use ip mptcp"
 	echo "  -h help"
 
+	echo "[test ids]"
+
 	exit ${ret}
 }
 
@@ -2465,6 +2580,16 @@ while getopts "${all_tests_args}cCih" opt; do
 	esac
 done
 
+shift $((OPTIND - 1))
+
+for arg in "${@}"; do
+	if [[ "${arg}" =~ ^[0-9]+$ ]]; then
+		only_tests+=("${arg}")
+	else
+		usage "Unknown argument: ${arg}"
+	fi
+done
+
 if [ ${#tests[@]} -eq 0 ]; then
 	tests=("${all_tests_names[@]}")
 fi
-- 
2.35.1

