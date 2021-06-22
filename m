Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FA73B0DA1
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhFVT1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:27:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:32268 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232653AbhFVT1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 15:27:48 -0400
IronPort-SDR: jSvDajLuchHm3gPzJvdaSOX2VfYCWy5bQE5jWz6Dcil1639VB7TebswRLLae2HpFSLXqUXygm9
 +OgvuQgd4SpQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="186818203"
X-IronPort-AV: E=Sophos;i="5.83,292,1616482800"; 
   d="scan'208";a="186818203"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 12:25:30 -0700
IronPort-SDR: jmVlM6lVgIJFdaIeQu61Q5gN0R1hW1S2+CXsZmpLv+I2kf3PcR8JG2b2a7CHDJlYnT+SVw/p53
 l/6CuNwdxf/A==
X-IronPort-AV: E=Sophos;i="5.83,292,1616482800"; 
   d="scan'208";a="480909725"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.237.182])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 12:25:29 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/6] selftests: mptcp: add deny_join_id0 testcases
Date:   Tue, 22 Jun 2021 12:25:21 -0700
Message-Id: <20210622192523.90117-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210622192523.90117-1-mathew.j.martineau@linux.intel.com>
References: <20210622192523.90117-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new argument '-d' for mptcp_join.sh script, to invoke
the testcases for the MP_CAPABLE 'C' flag.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 75 ++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 523c7797f30a..9a191c1a5de8 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -139,6 +139,17 @@ reset_with_checksum()
 	ip netns exec $ns2 sysctl -q net.mptcp.checksum_enabled=$ns2_enable
 }
 
+reset_with_allow_join_id0()
+{
+	local ns1_enable=$1
+	local ns2_enable=$2
+
+	reset
+
+	ip netns exec $ns1 sysctl -q net.mptcp.allow_join_initial_addr_port=$ns1_enable
+	ip netns exec $ns2 sysctl -q net.mptcp.allow_join_initial_addr_port=$ns2_enable
+}
+
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
 	echo "SKIP: Could not run test without ip tool"
@@ -1462,6 +1473,63 @@ checksum_tests()
 	chk_csum_nr "checksum test 1 0"
 }
 
+deny_join_id0_tests()
+{
+	# subflow allow join id0 ns1
+	reset_with_allow_join_id0 1 0
+	ip netns exec $ns1 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "single subflow allow join id0 ns1" 1 1 1
+
+	# subflow allow join id0 ns2
+	reset_with_allow_join_id0 0 1
+	ip netns exec $ns1 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "single subflow allow join id0 ns2" 0 0 0
+
+	# signal address allow join id0 ns1
+	# ADD_ADDRs are not affected by allow_join_id0 value.
+	reset_with_allow_join_id0 1 0
+	ip netns exec $ns1 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "signal address allow join id0 ns1" 1 1 1
+	chk_add_nr 1 1
+
+	# signal address allow join id0 ns2
+	# ADD_ADDRs are not affected by allow_join_id0 value.
+	reset_with_allow_join_id0 0 1
+	ip netns exec $ns1 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "signal address allow join id0 ns2" 1 1 1
+	chk_add_nr 1 1
+
+	# subflow and address allow join id0 ns1
+	reset_with_allow_join_id0 1 0
+	ip netns exec $ns1 ./pm_nl_ctl limits 2 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "subflow and address allow join id0 1" 2 2 2
+
+	# subflow and address allow join id0 ns2
+	reset_with_allow_join_id0 0 1
+	ip netns exec $ns1 ./pm_nl_ctl limits 2 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "subflow and address allow join id0 2" 1 1 1
+}
+
 all_tests()
 {
 	subflows_tests
@@ -1476,6 +1544,7 @@ all_tests()
 	add_addr_ports_tests
 	syncookies_tests
 	checksum_tests
+	deny_join_id0_tests
 }
 
 usage()
@@ -1493,6 +1562,7 @@ usage()
 	echo "  -p add_addr_ports_tests"
 	echo "  -k syncookies_tests"
 	echo "  -S checksum_tests"
+	echo "  -d deny_join_id0_tests"
 	echo "  -c capture pcap files"
 	echo "  -C enable data checksum"
 	echo "  -h help"
@@ -1528,7 +1598,7 @@ if [ $do_all_tests -eq 1 ]; then
 	exit $ret
 fi
 
-while getopts 'fsltra64bpkchCS' opt; do
+while getopts 'fsltra64bpkdchCS' opt; do
 	case $opt in
 		f)
 			subflows_tests
@@ -1566,6 +1636,9 @@ while getopts 'fsltra64bpkchCS' opt; do
 		S)
 			checksum_tests
 			;;
+		d)
+			deny_join_id0_tests
+			;;
 		c)
 			;;
 		C)
-- 
2.32.0

