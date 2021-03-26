Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606FB34AE95
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCZS2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:28:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:55919 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhCZS1i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 14:27:38 -0400
IronPort-SDR: B5WKSjXP2bcUgdp1c3wCoPOG4mYl+6fSTmJwSQrWflzRpiaEdWZSDYhU0rR1I4PH2TNV/f1MgH
 KMDjH9BSuomQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="190642777"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="190642777"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:37 -0700
IronPort-SDR: 4Q3Zh7p9Q0wf+CrOSBkNmztcUVoO+QtPAxUspI5FP0yFf396rb2KxFQw+3EU0CN96rscVOyF6n
 s+pFNSKgh5Fg==
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="443456578"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.24.139])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:27:37 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 13/13] selftests: mptcp: signal addresses testcases
Date:   Fri, 26 Mar 2021 11:26:42 -0700
Message-Id: <20210326182642.136419-13-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326182642.136419-1-mathew.j.martineau@linux.intel.com>
References: <20210326182307.136256-1-mathew.j.martineau@linux.intel.com>
 <20210326182642.136419-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch adds testcases for signalling multi valid and invalid
addresses for both signal_address_tests and remove_tests.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 32379efa2276..679de3abaf34 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -785,6 +785,28 @@ signal_address_tests()
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "multiple subflows and signal" 3 3 3
 	chk_add_nr 1 1
+
+	# signal addresses
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "signal addresses" 3 3 3
+	chk_add_nr 3 3
+
+	# signal invalid addresses
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.12.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.14.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "signal invalid addresses" 1 1 1
+	chk_add_nr 3 3
 }
 
 link_failure_tests()
@@ -896,6 +918,30 @@ remove_tests()
 	chk_add_nr 1 1
 	chk_rm_nr 2 2
 
+	# addresses remove
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal id 250
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
+	chk_join_nr "remove addresses" 3 3 3
+	chk_add_nr 3 3
+	chk_rm_nr 3 3 invert
+
+	# invalid addresses remove
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.12.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.14.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
+	chk_join_nr "remove invalid addresses" 1 1 1
+	chk_add_nr 3 3
+	chk_rm_nr 3 1 invert
+
 	# subflows and signal, flush
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
@@ -930,6 +976,18 @@ remove_tests()
 	chk_join_nr "flush addresses" 3 3 3
 	chk_add_nr 3 3
 	chk_rm_nr 3 3 invert
+
+	# invalid addresses flush
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.12.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.14.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	run_tests $ns1 $ns2 10.0.1.1 0 -8 0 slow
+	chk_join_nr "flush invalid addresses" 1 1 1
+	chk_add_nr 3 3
+	chk_rm_nr 3 1 invert
 }
 
 add_tests()
-- 
2.31.0

