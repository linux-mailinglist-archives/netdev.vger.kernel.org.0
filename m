Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51DC4A7D2D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237577AbiBCBD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:03:57 -0500
Received: from mga06.intel.com ([134.134.136.31]:6290 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233773AbiBCBDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 20:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643850230; x=1675386230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dTssO73r57l66jd0hPRkCO1bthWlqOWmAdYmrq+iykY=;
  b=ZEOSA6LuJIHeLPHbAz4onSybvt4CAEn/cK84xLnwM+oo5xDBjtVP8wjW
   dNIkbyGjq1Rbm9G4StOWQMgn+jKvS8nbhSGNJD91wDBIuh3w9tv6vnJ5+
   +p4/JGu3BTyQ2jDRriVHkaAnR4nfcAW58swTKKs653tgfyGQ6M3x4ni0Y
   XPEeu9RNGGud5wC2qnAM8/F4oACaoroUMCIBI8sUMxyvlCNFncpE6629r
   OrQACaGtgwfsuO1xNp6xczxRLYYqAt+6jXdHKvju7cl9JfohEMuZWYFnr
   o0ypygmanfdip3Vw4tSIL5jXC2srRart3nJrliYDwsR7lEXM6HBFP5QWU
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="308782835"
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="308782835"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="483070835"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.1.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:49 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 7/7] selftests: mptcp: add fullmesh setting tests
Date:   Wed,  2 Feb 2022 17:03:43 -0800
Message-Id: <20220203010343.113421-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
References: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch added the fullmesh setting and clearing selftests in
mptcp_join.sh.

Now we can set both backup and fullmesh flags, so avoid using the
words 'backup' and 'bkup'.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 49 ++++++++++++++++---
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index b8bdbec0cf69..bd106c7ec232 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -289,7 +289,7 @@ do_transfer()
 	addr_nr_ns1="$7"
 	addr_nr_ns2="$8"
 	speed="$9"
-	bkup="${10}"
+	sflags="${10}"
 
 	port=$((10000+$TEST_COUNT))
 	TEST_COUNT=$((TEST_COUNT+1))
@@ -461,14 +461,13 @@ do_transfer()
 		fi
 	fi
 
-	if [ ! -z $bkup ]; then
+	if [ ! -z $sflags ]; then
 		sleep 1
 		for netns in "$ns1" "$ns2"; do
 			dump=(`ip netns exec $netns ./pm_nl_ctl dump`)
 			if [ ${#dump[@]} -gt 0 ]; then
 				addr=${dump[${#dump[@]} - 1]}
-				backup="ip netns exec $netns ./pm_nl_ctl set $addr flags $bkup"
-				$backup
+				ip netns exec $netns ./pm_nl_ctl set $addr flags $sflags
 			fi
 		done
 	fi
@@ -545,7 +544,7 @@ run_tests()
 	addr_nr_ns1="${5:-0}"
 	addr_nr_ns2="${6:-0}"
 	speed="${7:-fast}"
-	bkup="${8:-""}"
+	sflags="${8:-""}"
 	lret=0
 	oldin=""
 
@@ -574,7 +573,7 @@ run_tests()
 	fi
 
 	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} \
-		${test_linkfail} ${addr_nr_ns1} ${addr_nr_ns2} ${speed} ${bkup}
+		${test_linkfail} ${addr_nr_ns1} ${addr_nr_ns2} ${speed} ${sflags}
 	lret=$?
 }
 
@@ -1888,6 +1887,44 @@ fullmesh_tests()
 	run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_2 slow
 	chk_join_nr "fullmesh test 1x2, limited" 4 4 4
 	chk_add_nr 1 1
+
+	# set fullmesh flag
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 4 4
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl limits 4 4
+	run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow fullmesh
+	chk_join_nr "set fullmesh flag test" 2 2 2
+	chk_rm_nr 0 1
+
+	# set nofullmesh flag
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 4 4
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags subflow,fullmesh
+	ip netns exec $ns2 ./pm_nl_ctl limits 4 4
+	run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_1 slow nofullmesh
+	chk_join_nr "set nofullmesh flag test" 2 2 2
+	chk_rm_nr 0 1
+
+	# set backup,fullmesh flags
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 4 4
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl limits 4 4
+	run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow backup,fullmesh
+	chk_join_nr "set backup,fullmesh flags test" 2 2 2
+	chk_prio_nr 0 1
+	chk_rm_nr 0 1
+
+	# set nobackup,nofullmesh flags
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 4 4
+	ip netns exec $ns2 ./pm_nl_ctl limits 4 4
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow,backup,fullmesh
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup,nofullmesh
+	chk_join_nr "set nobackup,nofullmesh flags test" 2 2 2
+	chk_prio_nr 0 1
+	chk_rm_nr 0 1
 }
 
 all_tests()
-- 
2.35.1

