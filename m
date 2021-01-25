Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E75C304AE3
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbhAZEyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:54:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:41204 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbhAYJkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 04:40:55 -0500
IronPort-SDR: votsNA7tKCncXzdb3jiqgGnZ0VQO2S+jAJozL55mtvyMnkwQ5QLNvlkovdKMwmPKpCWc4IGzph
 pDnT3uXAPjLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="179844634"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="179844634"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:37:31 -0800
IronPort-SDR: s3AFhwzo1DOo3sDesamo0CQgokAeNo3MwI1paZdl8QcAXNhp5lc8mdAPGHqMv1QH44nn1xWSHF
 duQm/lLrKiIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="577321035"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga005.fm.intel.com with ESMTP; 25 Jan 2021 01:37:29 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next 6/6] selftests/bpf: XSK_TRACE_DROP_FQ_EMPTY test
Date:   Mon, 25 Jan 2021 09:07:39 +0000
Message-Id: <20210125090739.1045-7-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210125090739.1045-1-ciara.loftus@intel.com>
References: <20210125090739.1045-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test skips the populating of the fill queue which
causes packet drops and traces reporting the drop. The
test validates that these traces were successfully
generated.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh  | 24 ++++++++++++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.c | 12 ++++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 95ceee151de1..997ba0aa79db 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -295,6 +295,30 @@ retval=$?
 test_status $retval "${TEST_NAME}"
 statusList+=($retval)
 
+### TEST 14
+TEST_NAME="SKB TRACE DROP FQ_EMPTY"
+
+vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
+
+params=("-S" "-t" "2" "-C" "${TRACEPKTS}")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
+### TEST 15
+TEST_NAME="DRV TRACE DROP FQ_EMPTY"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N" "-t" "2" "-C" "${TRACEPKTS}")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
 ## END TESTS
 
 cleanup_exit ${VETH0} ${VETH1} ${NS1}
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 71d684639ccb..acdb934b4ff4 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -37,6 +37,8 @@
  *       Reduce the RXQ size and do not read from it. Validate traces.
  *    f. Tracing - XSK_TRACE_DROP_PKT_TOO_BIG
  *       Increase the headroom size and send packets. Validate traces.
+ *    g. Tracing - XSK_TRACE_DROP_FQ_EMPTY
+ *       Do not populate the fill queue and send packets. Validate traces.
  *
  * 2. AF_XDP DRV/Native mode
  *    Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
@@ -50,8 +52,9 @@
  *      zero-copy mode
  *    e. Tracing - XSK_TRACE_DROP_RXQ_FULL
  *    f. Tracing - XSK_TRACE_DROP_PKT_TOO_BIG
+ *    g. Tracing - XSK_TRACE_DROP_FQ_EMPTY
  *
- * Total tests: 12
+ * Total tests: 14
  *
  * Flow:
  * -----
@@ -989,7 +992,8 @@ static void *worker_testapp_validate(void *arg)
 			thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_rx);
 
 		ksft_print_msg("Interface [%s] vector [Rx]\n", ((struct ifobject *)arg)->ifname);
-		xsk_populate_fill_ring(((struct ifobject *)arg)->umem);
+		if (opt_trace_code != XSK_TRACE_DROP_FQ_EMPTY)
+			xsk_populate_fill_ring(((struct ifobject *)arg)->umem);
 
 		TAILQ_INIT(&head);
 		if (debug_pkt_dump) {
@@ -1196,6 +1200,10 @@ int main(int argc, char **argv)
 			expected_traces = opt_pkt_count;
 			reason_str = "packet too big";
 			break;
+		case XSK_TRACE_DROP_FQ_EMPTY:
+			expected_traces = opt_pkt_count;
+			reason_str = "fq empty";
+			break;
 		default:
 			ksft_test_result_fail("ERROR: unsupported trace %i\n",
 						opt_trace_code);
-- 
2.17.1

