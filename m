Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC0E302B10
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 20:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731462AbhAYTE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 14:04:26 -0500
Received: from mga05.intel.com ([192.55.52.43]:23761 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731474AbhAYTDb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 14:03:31 -0500
IronPort-SDR: bGC9/PdAsvtihFD6eMErOhiSmYhtRdE+ccRPy9WWj7HRTCoeesN6+wybzpaWDFYqOxzhxX2g5N
 PVozCA4ciu2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="264604210"
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="264604210"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 10:59:27 -0800
IronPort-SDR: +rrohAqSpJMPRD4Wl0dK7N8pQP6h89vUAdKlQRyjmtohOx0g3FmpaQEUDBQsV8+KE3BhJEm4mC
 nMk+9QiVdVxA==
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="361637476"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.126.22])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 10:59:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/5] selftests: mptcp: add IPv4-mapped IPv6 testcases
Date:   Mon, 25 Jan 2021 10:59:03 -0800
Message-Id: <20210125185904.6997-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
References: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

Here, we make sure we support IPv4-mapped in IPv6 addresses in different
contexts:

- a v4-mapped address is received by the PM and can be used as v4.
- a v4 address is received by the PM and can be used even with a v4
  mapped socket.

We also make sure we don't try to establish subflows between v4 and v6
addresses, e.g. if a real v6 address ends with a valid v4 address.

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index f74cd993b168..be34b9ccbd20 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -790,6 +790,81 @@ chk_join_nr "remove subflow and signal IPv6" 2 2 2
 chk_add_nr 1 1
 chk_rm_nr 1 1
 
+# subflow IPv4-mapped to IPv4-mapped
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add "::ffff:10.0.3.2" flags subflow
+run_tests $ns1 $ns2 "::ffff:10.0.1.1"
+chk_join_nr "single subflow IPv4-mapped" 1 1 1
+
+# signal address IPv4-mapped with IPv4-mapped sk
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+ip netns exec $ns1 ./pm_nl_ctl add "::ffff:10.0.2.1" flags signal
+run_tests $ns1 $ns2 "::ffff:10.0.1.1"
+chk_join_nr "signal address IPv4-mapped" 1 1 1
+chk_add_nr 1 1
+
+# subflow v4-map-v6
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_tests $ns1 $ns2 "::ffff:10.0.1.1"
+chk_join_nr "single subflow v4-map-v6" 1 1 1
+
+# signal address v4-map-v6
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+run_tests $ns1 $ns2 "::ffff:10.0.1.1"
+chk_join_nr "signal address v4-map-v6" 1 1 1
+chk_add_nr 1 1
+
+# subflow v6-map-v4
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add "::ffff:10.0.3.2" flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "single subflow v6-map-v4" 1 1 1
+
+# signal address v6-map-v4
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+ip netns exec $ns1 ./pm_nl_ctl add "::ffff:10.0.2.1" flags signal
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "signal address v6-map-v4" 1 1 1
+chk_add_nr 1 1
+
+# no subflow IPv6 to v4 address
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add dead:beef:2::2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "no JOIN with diff families v4-v6" 0 0 0
+
+# no subflow IPv6 to v4 address even if v6 has a valid v4 at the end
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add dead:beef:2::10.0.3.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "no JOIN with diff families v4-v6-2" 0 0 0
+
+# no subflow IPv4 to v6 address, no need to slow down too then
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_tests $ns1 $ns2 dead:beef:1::1
+chk_join_nr "no JOIN with diff families v6-v4" 0 0 0
+
 # single subflow, backup
 reset
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-- 
2.30.0

