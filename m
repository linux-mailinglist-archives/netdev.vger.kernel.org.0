Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420C54D39FC
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbiCITSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238240AbiCITSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:18:25 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65C7144F5A
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646853420; x=1678389420;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e1t+Jz+5OGZSeGtd0kR9Wcxg+MZK1NVvBjKN3QGmv2w=;
  b=CCPQNNaI04GvTuGUU/nZKhEV0ebTl8wN1jV1sCgZCeswO+Bl5IW3jDdm
   lvYK5pDVHI80E6DV1XyAlHPJWu/BKArHeZcyrk7C09ze4yRg/8S5na1E1
   PPHjSetlmsxMwS/16HzBQo7WIlzDcPVK9VRfN/wQbSwSSIOd+e2Dhvhuu
   VZjtfditichKH8YnbPxNx2U1rQLoSIudsByIvb1sorCLw6+QAMf3MN7pI
   blakSvuhJOm6NgbCO2tlXc/T5NqYsEWlNIra+7ffr+k5qRGKPpuRhgQ9V
   JyPNp7GvSQFP61PboDXbW4w46Ve73kTfB3MnFhmatZ8YTxzQ9qvByiOp5
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="237235265"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="237235265"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:46 -0800
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="495957053"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.194.198])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:46 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 02/10] selftests: mptcp: join: define tests groups once
Date:   Wed,  9 Mar 2022 11:16:28 -0800
Message-Id: <20220309191636.258232-3-mathew.j.martineau@linux.intel.com>
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

When adding a new tests group, it has to be defined in multiple places:

- in the all_tests() function
- in the 'usage()' function
- in the getopts: short option + what to do when the option is used

Because it is easy to forget one of them, it is useful to have to define
them only once.

Note: only using an associative array would simplify the code but the
entries are stored in a hashtable and iterating over the different items
doesn't give the same order as the one used in the declaration of this
array. Because we want to run these tests in the same order as before, a
"simple" array is used first.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 141 ++++++------------
 1 file changed, 47 insertions(+), 94 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 194c4420220e..8dc50b480152 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -19,6 +19,7 @@ check_invert=0
 validate_checksum=0
 init=0
 
+declare -A all_tests
 TEST_COUNT=0
 nr_blank=40
 
@@ -2380,27 +2381,6 @@ implicit_tests()
 	wait
 }
 
-all_tests()
-{
-	subflows_tests
-	subflows_error_tests
-	signal_address_tests
-	link_failure_tests
-	add_addr_timeout_tests
-	remove_tests
-	add_tests
-	ipv6_tests
-	v4mapped_tests
-	backup_tests
-	add_addr_ports_tests
-	syncookies_tests
-	checksum_tests
-	deny_join_id0_tests
-	fullmesh_tests
-	fastclose_tests
-	implicit_tests
-}
-
 # [$1: error message]
 usage()
 {
@@ -2410,23 +2390,12 @@ usage()
 	fi
 
 	echo "mptcp_join usage:"
-	echo "  -f subflows_tests"
-	echo "  -e subflows_error_tests"
-	echo "  -s signal_address_tests"
-	echo "  -l link_failure_tests"
-	echo "  -t add_addr_timeout_tests"
-	echo "  -r remove_tests"
-	echo "  -a add_tests"
-	echo "  -6 ipv6_tests"
-	echo "  -4 v4mapped_tests"
-	echo "  -b backup_tests"
-	echo "  -p add_addr_ports_tests"
-	echo "  -k syncookies_tests"
-	echo "  -S checksum_tests"
-	echo "  -d deny_join_id0_tests"
-	echo "  -m fullmesh_tests"
-	echo "  -z fastclose_tests"
-	echo "  -I implicit_tests"
+
+	local key
+	for key in "${!all_tests[@]}"; do
+		echo "  -${key} ${all_tests[${key}]}"
+	done
+
 	echo "  -c capture pcap files"
 	echo "  -C enable data checksum"
 	echo "  -i use ip mptcp"
@@ -2436,59 +2405,43 @@ usage()
 }
 
 
+# Use a "simple" array to force an specific order we cannot have with an associative one
+all_tests_sorted=(
+	f@subflows_tests
+	e@subflows_error_tests
+	s@signal_address_tests
+	l@link_failure_tests
+	t@add_addr_timeout_tests
+	r@remove_tests
+	a@add_tests
+	6@ipv6_tests
+	4@v4mapped_tests
+	b@backup_tests
+	p@add_addr_ports_tests
+	k@syncookies_tests
+	S@checksum_tests
+	d@deny_join_id0_tests
+	m@fullmesh_tests
+	z@fastclose_tests
+	I@implicit_tests
+)
+
+all_tests_args=""
+all_tests_names=()
+for subtests in "${all_tests_sorted[@]}"; do
+	key="${subtests%@*}"
+	value="${subtests#*@}"
+
+	all_tests_args+="${key}"
+	all_tests_names+=("${value}")
+	all_tests[${key}]="${value}"
+done
+
 tests=()
-while getopts 'fesltra64bpkdmchzICSi' opt; do
+while getopts "${all_tests_args}cCih" opt; do
 	case $opt in
-		f)
-			tests+=(subflows_tests)
-			;;
-		e)
-			tests+=(subflows_error_tests)
-			;;
-		s)
-			tests+=(signal_address_tests)
-			;;
-		l)
-			tests+=(link_failure_tests)
-			;;
-		t)
-			tests+=(add_addr_timeout_tests)
-			;;
-		r)
-			tests+=(remove_tests)
-			;;
-		a)
-			tests+=(add_tests)
-			;;
-		6)
-			tests+=(ipv6_tests)
-			;;
-		4)
-			tests+=(v4mapped_tests)
-			;;
-		b)
-			tests+=(backup_tests)
-			;;
-		p)
-			tests+=(add_addr_ports_tests)
-			;;
-		k)
-			tests+=(syncookies_tests)
-			;;
-		S)
-			tests+=(checksum_tests)
-			;;
-		d)
-			tests+=(deny_join_id0_tests)
-			;;
-		m)
-			tests+=(fullmesh_tests)
-			;;
-		z)
-			tests+=(fastclose_tests)
-			;;
-		I)
-			tests+=(implicit_tests)
+		["${all_tests_args}"])
+			tests+=("${all_tests[${opt}]}")
 			;;
 		c)
 			capture=1
@@ -2509,11 +2462,11 @@ while getopts 'fesltra64bpkdmchzICSi' opt; do
 done
 
 if [ ${#tests[@]} -eq 0 ]; then
-	all_tests
-else
-	for subtests in "${tests[@]}"; do
-		"${subtests}"
-	done
+	tests=("${all_tests_names[@]}")
 fi
 
+for subtests in "${tests[@]}"; do
+	"${subtests}"
+done
+
 exit $ret
-- 
2.35.1

