Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6936E4D08B9
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241187AbiCGUps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239292AbiCGUpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:45:41 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2826811A9
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646685886; x=1678221886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R4tIQUAOTRz1Si2gcqBM3+CXn/RCAkFxYB6IZ5aqlfw=;
  b=lk8wPmpyKUmIluNBQKE6Tp3zW76YnXUj1u6+Nl1lS68pBPefh+gsGZDj
   XocqWcPt9LcqKWAHlZpB/4CB1TxxlIOyE0gWmSQ/2/vTxdvd4KI5j5zWn
   I7PT+KQ4G9dgHlSp2Nj8cngjPIIHcU1Tpy36nEehoisHABa4f/kMWbtiI
   Cszp7riMU3PE5QBf7WBKfW1gQQ6F//8RpGYxkeGRoZh+pH4JugnHCcEqJ
   Kv0ysE3GoJ4hIBUuKrOb5hdKDFSS2C5fgPazaqlNks031nU/2QlRloCFm
   BziLwzf8CEf4Yi33xEAzEw0cTUc5yXsra6l4fQ5fCZq7N64bpusCOejV2
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254440160"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254440160"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:45 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="553320484"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.192.43])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:44 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/9] selftests: mptcp: join: allow running -cCi
Date:   Mon,  7 Mar 2022 12:44:33 -0800
Message-Id: <20220307204439.65164-4-mathew.j.martineau@linux.intel.com>
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

Without this patch, no tests would be ran when launching:

  mptcp_join.sh -cCi

In any order or a combination with 2 of these letters.

The recommended way with getopt is first parse all options and then act.

This allows to do some actions in priority, e.g. display the help menu
and stop.

But also some global variables changing the behaviour of this selftests
 -- like the ones behind -cCi options -- can be set before running the
different tests. By doing that, we can also avoid long and unreadable
regex.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 67 ++++++++-----------
 1 file changed, 28 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 45c6e5f06916..309d06781ae7 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -16,7 +16,6 @@ capture=0
 checksum=0
 ip_mptcp=0
 check_invert=0
-do_all_tests=1
 init=0
 
 TEST_COUNT=0
@@ -2293,84 +2292,66 @@ usage()
 	exit ${ret}
 }
 
-for arg in "$@"; do
-	# check for "capture/checksum" args before launching tests
-	if [[ "${arg}" =~ ^"-"[0-9a-zA-Z]*"c"[0-9a-zA-Z]*$ ]]; then
-		capture=1
-	fi
-	if [[ "${arg}" =~ ^"-"[0-9a-zA-Z]*"C"[0-9a-zA-Z]*$ ]]; then
-		checksum=1
-	fi
-	if [[ "${arg}" =~ ^"-"[0-9a-zA-Z]*"i"[0-9a-zA-Z]*$ ]]; then
-		ip_mptcp=1
-	fi
-
-	# exception for the capture/checksum/ip_mptcp options, the rest means: a part of the tests
-	if [ "${arg}" != "-c" ] && [ "${arg}" != "-C" ] && [ "${arg}" != "-i" ]; then
-		do_all_tests=0
-	fi
-done
-
-if [ $do_all_tests -eq 1 ]; then
-	all_tests
-	exit $ret
-fi
 
+tests=()
 while getopts 'fesltra64bpkdmchzCSi' opt; do
 	case $opt in
 		f)
-			subflows_tests
+			tests+=(subflows_tests)
 			;;
 		e)
-			subflows_error_tests
+			tests+=(subflows_error_tests)
 			;;
 		s)
-			signal_address_tests
+			tests+=(signal_address_tests)
 			;;
 		l)
-			link_failure_tests
+			tests+=(link_failure_tests)
 			;;
 		t)
-			add_addr_timeout_tests
+			tests+=(add_addr_timeout_tests)
 			;;
 		r)
-			remove_tests
+			tests+=(remove_tests)
 			;;
 		a)
-			add_tests
+			tests+=(add_tests)
 			;;
 		6)
-			ipv6_tests
+			tests+=(ipv6_tests)
 			;;
 		4)
-			v4mapped_tests
+			tests+=(v4mapped_tests)
 			;;
 		b)
-			backup_tests
+			tests+=(backup_tests)
 			;;
 		p)
-			add_addr_ports_tests
+			tests+=(add_addr_ports_tests)
 			;;
 		k)
-			syncookies_tests
+			tests+=(syncookies_tests)
 			;;
 		S)
-			checksum_tests
+			tests+=(checksum_tests)
 			;;
 		d)
-			deny_join_id0_tests
+			tests+=(deny_join_id0_tests)
 			;;
 		m)
-			fullmesh_tests
+			tests+=(fullmesh_tests)
 			;;
 		z)
-			fastclose_tests
+			tests+=(fastclose_tests)
 			;;
 		c)
+			capture=1
 			;;
 		C)
+			checksum=1
 			;;
 		i)
+			ip_mptcp=1
 			;;
 		h)
 			usage
@@ -2381,4 +2362,12 @@ while getopts 'fesltra64bpkdmchzCSi' opt; do
 	esac
 done
 
+if [ ${#tests[@]} -eq 0 ]; then
+	all_tests
+else
+	for subtests in "${tests[@]}"; do
+		"${subtests}"
+	done
+fi
+
 exit $ret
-- 
2.35.1

