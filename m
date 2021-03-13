Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC517339AC5
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhCMBQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:16:32 -0500
Received: from mga17.intel.com ([192.55.52.151]:1169 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232445AbhCMBQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:16:28 -0500
IronPort-SDR: UCK0udJQxTGW3nLvZB4E7Q83BRt6KwuoOpDaEifrgI2E4fvQ33ikqVuh3dqQ79DEb4kJ9q71iq
 7U2jcWOaTNFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168828251"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="168828251"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:27 -0800
IronPort-SDR: G39NVtptd1+BgyWvYKQHZPvvsdfzIRZpkVkQ/sDRq/sBZ9he89+xp1esdHhS5KsgOvA80JVbq3
 m6MDgyjVcAgA==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="411197380"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:27 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 11/11] selftests: mptcp: add testcases for removing addrs
Date:   Fri, 12 Mar 2021 17:16:21 -0800
Message-Id: <20210313011621.211661-12-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
References: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added the testcases for removing a list of addresses. Used
the netlink to flush the addresses in the testcases.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 6782a891b3e7..191303b652a6 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -890,6 +890,29 @@ remove_tests()
 	chk_join_nr "flush subflows and signal" 3 3 3
 	chk_add_nr 1 1
 	chk_rm_nr 2 2
+
+	# subflows flush
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
+	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow id 150
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
+	chk_join_nr "flush subflows" 3 3 3
+	chk_rm_nr 3 3
+
+	# addresses flush
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal id 250
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
+	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
+	chk_join_nr "flush addresses" 3 3 3
+	chk_add_nr 3 3
+	chk_rm_nr 3 3 invert
 }
 
 add_tests()
-- 
2.30.2

