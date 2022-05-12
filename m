Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB0752583C
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359454AbiELX05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359452AbiELX0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:26:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CEC31907
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652398011; x=1683934011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y8Kff7elEMZUNQ5A0JvdNuSLQhIb8zXMDvwIJO0oxHs=;
  b=GkZjmt2SeJ1/tUAkwq6Z6ONIqieFhkujgQVVXfoM8qzCt7g11nrwK9l2
   F5w6fNs+Qkp7R+iuYNSm6XOqyk2vsBSBF/ZoxDJf01WO6y+MQCNV7iQ6u
   BZ9i5ZpCROk4BDX0lU6Xnw2yPiWR1PPgiQs3rJ7j5KJucKdjKtF0ZM9C0
   GKNVnLygaQeykUTdM7dT5fsP8jZrk63zdCVpyGjLDTN4h3umA4OJCZyDF
   6y+W7TliijvD85wwczXZ6csUD0eGDknDwGPdl9gAFmPqUaEd5rW72+Bl+
   3+l6glbas8T23eASahLiruBbxHOIWA4FSPslIbBOdujDlofidcl0++Fkm
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="270097025"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="270097025"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 16:26:48 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="739919555"
Received: from cmokhtar-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.36.250])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 16:26:47 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/2] selftests: mptcp: add subflow limits test-cases
Date:   Thu, 12 May 2022 16:26:42 -0700
Message-Id: <20220512232642.541301-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512232642.541301-1-mathew.j.martineau@linux.intel.com>
References: <20220512232642.541301-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Add and delete a bunch of endpoints and verify the
respect of configured limits.

This covers the codepath introduced by the previous patch.

Fixes: 69c6ce7b6eca ("selftests: mptcp: add implicit endpoint test case")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 48 ++++++++++++++++++-
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 7314257d248a..48ef112f42c2 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1444,6 +1444,33 @@ chk_prio_nr()
 	[ "${dump_stats}" = 1 ] && dump_stats
 }
 
+chk_subflow_nr()
+{
+	local need_title="$1"
+	local msg="$2"
+	local subflow_nr=$3
+	local cnt1
+	local cnt2
+
+	if [ -n "${need_title}" ]; then
+		printf "%03u %-36s %s" "${TEST_COUNT}" "${TEST_NAME}" "${msg}"
+	else
+		printf "%-${nr_blank}s %s" " " "${msg}"
+	fi
+
+	cnt1=$(ss -N $ns1 -tOni | grep -c token)
+	cnt2=$(ss -N $ns2 -tOni | grep -c token)
+	if [ "$cnt1" != "$subflow_nr" -o "$cnt2" != "$subflow_nr" ]; then
+		echo "[fail] got $cnt1:$cnt2 subflows expected $subflow_nr"
+		fail_test
+		dump_stats=1
+	else
+		echo "[ ok ]"
+	fi
+
+	[ "${dump_stats}" = 1 ] && ( ss -N $ns1 -tOni ; ss -N $ns1 -tOni | grep token; ip -n $ns1 mptcp endpoint )
+}
+
 chk_link_usage()
 {
 	local ns=$1
@@ -2556,7 +2583,7 @@ fastclose_tests()
 	fi
 }
 
-implicit_tests()
+endpoint_tests()
 {
 	# userspace pm type prevents add_addr
 	if reset "implicit EP"; then
@@ -2578,6 +2605,23 @@ implicit_tests()
 			$ns2 10.0.2.2 id 1 flags signal
 		wait
 	fi
+
+	if reset "delete and re-add"; then
+		pm_nl_set_limits $ns1 1 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 4 0 0 slow &
+
+		wait_mpj $ns2
+		pm_nl_del_endpoint $ns2 2 10.0.2.2
+		sleep 0.5
+		chk_subflow_nr needtitle "after delete" 1
+
+		pm_nl_add_endpoint $ns2 10.0.2.2 dev ns2eth2 flags subflow
+		wait_mpj $ns2
+		chk_subflow_nr "" "after re-add" 2
+		wait
+	fi
 }
 
 # [$1: error message]
@@ -2624,7 +2668,7 @@ all_tests_sorted=(
 	d@deny_join_id0_tests
 	m@fullmesh_tests
 	z@fastclose_tests
-	I@implicit_tests
+	I@endpoint_tests
 )
 
 all_tests_args=""
-- 
2.36.1

