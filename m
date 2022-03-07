Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53164D08BA
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241336AbiCGUpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiCGUpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:45:43 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B37582D15
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646685888; x=1678221888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y70bUn1hKmrA0uVOeYcMBCmyn9LGK/Kr0ab27W7G4mE=;
  b=FxOJ5tQxjJqAxRjO0sjGDfjSCNZk/2ze3yVVaz3DtPrYLHS8CLB7K6/A
   /v+FJvDU7nAOVoGyfyetp/1TcOTtqYNxZuVBiBKtC2+W2+1HG+cugMiBk
   GQNDorCp58YNfk4BMJlMyIar4zZaHDC1wwhXYm/8lKSsP/ls9IIemaM8z
   Wz0cnQ4L0QECr7igQHD4rccQ9nZwBSJusP8tI/G3LMasDpBgu8VnB+eIT
   A8onVpN2WDRgSL5lwpT6W1yPtrx2Je2+llSkILK+ooaVye44G9CavSlJd
   Sx2bHakvvreuZxvsw5sCz4XTtGh/yTtZdzcTjduqeHoQu0hk/OE2J25/z
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254440171"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254440171"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:45 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="553320493"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.192.43])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:45 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 8/9] selftests: mptcp: add implicit endpoint test case
Date:   Mon,  7 Mar 2022 12:44:38 -0800
Message-Id: <20220307204439.65164-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307204439.65164-1-mathew.j.martineau@linux.intel.com>
References: <20220307204439.65164-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Ensure implicit endpoint are created when expected and
that the user-space can update them

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 120 +++++++++++++++++-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c |   7 +
 2 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 1e2e8dd9f0d6..ee435948d130 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -310,6 +310,21 @@ wait_rm_addr()
 	done
 }
 
+wait_mpj()
+{
+	local ns="${1}"
+	local cnt old_cnt
+
+	old_cnt=$(ip netns exec ${ns} nstat -as | grep MPJoinAckRx | awk '{print $2}')
+
+	local i
+	for i in $(seq 10); do
+		cnt=$(ip netns exec ${ns} nstat -as | grep MPJoinAckRx | awk '{print $2}')
+		[ "$cnt" = "${old_cnt}" ] || break
+		sleep 0.1
+	done
+}
+
 pm_nl_set_limits()
 {
 	local ns=$1
@@ -410,6 +425,80 @@ pm_nl_change_endpoint()
 	fi
 }
 
+pm_nl_check_endpoint()
+{
+	local line expected_line
+	local title="$1"
+	local msg="$2"
+	local ns=$3
+	local addr=$4
+	local _flags=""
+	local flags
+	local _port
+	local port
+	local dev
+	local _id
+	local id
+
+	if [ -n "${title}" ]; then
+		printf "%03u %-36s %s" "${TEST_COUNT}" "${title}" "${msg}"
+	else
+		printf "%-${nr_blank}s %s" " " "${msg}"
+	fi
+
+	shift 4
+	while [ -n "$1" ]; do
+		if [ $1 = "flags" ]; then
+			_flags=$2
+			[ ! -z $_flags ]; flags="flags $_flags"
+			shift
+		elif [ $1 = "dev" ]; then
+			[ ! -z $2 ]; dev="dev $1"
+			shift
+		elif [ $1 = "id" ]; then
+			_id=$2
+			[ ! -z $_id ]; id="id $_id"
+			shift
+		elif [ $1 = "port" ]; then
+			_port=$2
+			[ ! -z $_port ]; port=" port $_port"
+			shift
+		fi
+
+		shift
+	done
+
+	if [ -z "$id" ]; then
+		echo "[skip] bad test - missing endpoint id"
+		return
+	fi
+
+	if [ $ip_mptcp -eq 1 ]; then
+		line=$(ip -n $ns mptcp endpoint show $id)
+		# the dump order is: address id flags port dev
+		expected_line="$addr"
+		[ -n "$addr" ] && expected_line="$expected_line $addr"
+		expected_line="$expected_line $id"
+		[ -n "$_flags" ] && expected_line="$expected_line ${_flags//","/" "}"
+		[ -n "$dev" ] && expected_line="$expected_line $dev"
+		[ -n "$port" ] && expected_line="$expected_line $port"
+	else
+		line=$(ip netns exec $ns ./pm_nl_ctl get $_id)
+		# the dump order is: id flags dev address port
+		expected_line="$id"
+		[ -n "$flags" ] && expected_line="$expected_line $flags"
+		[ -n "$dev" ] && expected_line="$expected_line $dev"
+		[ -n "$addr" ] && expected_line="$expected_line $addr"
+		[ -n "$_port" ] && expected_line="$expected_line $_port"
+	fi
+	if [ "$line" = "$expected_line" ]; then
+		echo "[ ok ]"
+	else
+		echo "[fail] expected '$expected_line' found '$line'"
+		ret=1
+	fi
+}
+
 do_transfer()
 {
 	listener_ns="$1"
@@ -2269,6 +2358,30 @@ fastclose_tests()
 	chk_rst_nr 1 1 invert
 }
 
+implicit_tests()
+{
+	# userspace pm type prevents add_addr
+	reset
+	pm_nl_set_limits $ns1 2 2
+	pm_nl_set_limits $ns2 2 2
+	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow &
+
+	wait_mpj $ns1
+	TEST_COUNT=$((TEST_COUNT + 1))
+	pm_nl_check_endpoint "implicit EP" "creation" \
+		$ns2 10.0.2.2 id 1 flags implicit
+
+	pm_nl_add_endpoint $ns2 10.0.2.2 id 33
+	pm_nl_check_endpoint "" "ID change is prevented" \
+		$ns2 10.0.2.2 id 1 flags implicit
+
+	pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
+	pm_nl_check_endpoint "" "modif is allowed" \
+		$ns2 10.0.2.2 id 1 flags signal
+	wait
+}
+
 all_tests()
 {
 	subflows_tests
@@ -2287,6 +2400,7 @@ all_tests()
 	deny_join_id0_tests
 	fullmesh_tests
 	fastclose_tests
+	implicit_tests
 }
 
 # [$1: error message]
@@ -2314,6 +2428,7 @@ usage()
 	echo "  -d deny_join_id0_tests"
 	echo "  -m fullmesh_tests"
 	echo "  -z fastclose_tests"
+	echo "  -I implicit_tests"
 	echo "  -c capture pcap files"
 	echo "  -C enable data checksum"
 	echo "  -i use ip mptcp"
@@ -2324,7 +2439,7 @@ usage()
 
 
 tests=()
-while getopts 'fesltra64bpkdmchzCSi' opt; do
+while getopts 'fesltra64bpkdmchzICSi' opt; do
 	case $opt in
 		f)
 			tests+=(subflows_tests)
@@ -2374,6 +2489,9 @@ while getopts 'fesltra64bpkdmchzCSi' opt; do
 		z)
 			tests+=(fastclose_tests)
 			;;
+		I)
+			tests+=(implicit_tests)
+			;;
 		c)
 			capture=1
 			;;
diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index 22a5ec1e128e..a75a68ad652e 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -436,6 +436,13 @@ static void print_addr(struct rtattr *attrs, int len)
 					printf(",");
 			}
 
+			if (flags & MPTCP_PM_ADDR_FLAG_IMPLICIT) {
+				printf("implicit");
+				flags &= ~MPTCP_PM_ADDR_FLAG_IMPLICIT;
+				if (flags)
+					printf(",");
+			}
+
 			/* bump unknown flags, if any */
 			if (flags)
 				printf("0x%x", flags);
-- 
2.35.1

