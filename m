Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE1130473E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 19:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389885AbhAZRHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:07:32 -0500
Received: from mga04.intel.com ([192.55.52.120]:61804 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389844AbhAZI26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 03:28:58 -0500
IronPort-SDR: c/oUV9WrXBtopzhLZZk586mtofw1KfCnVABZUf8uHdTmSNGP482DN/nEbMIlKBh3p/V36djWwd
 lVwRLSoeZv2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="177298559"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="177298559"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 00:22:42 -0800
IronPort-SDR: ZVamXvb4GAa9vt3hDURDumQQtFCWZbRDOEZOkW+9BdTpbXkkfGR0Wg/gIWGGdhyt0m91ooVGJM
 YtfMFpGtJ3vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="361901164"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jan 2021 00:22:34 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v2 6/6] selftests/bpf: XSK_TRACE_DROP_FQ_EMPTY test
Date:   Tue, 26 Jan 2021 07:52:39 +0000
Message-Id: <20210126075239.25378-7-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210126075239.25378-1-ciara.loftus@intel.com>
References: <20210126075239.25378-1-ciara.loftus@intel.com>
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
 tools/testing/selftests/bpf/xdpxceiver.c | 13 +++++++++++--
 2 files changed, 35 insertions(+), 2 deletions(-)

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
index bee10bb686fc..49c2d42b5882 100644
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
@@ -981,7 +984,9 @@ static void *worker_testapp_validate(void *arg)
 			thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_rx);
 
 		ksft_print_msg("Interface [%s] vector [Rx]\n", ifobject->ifname);
-		xsk_populate_fill_ring(ifobject->umem);
+		if (opt_trace_code != XSK_TRACE_DROP_FQ_EMPTY)
+			xsk_populate_fill_ring(ifobject->umem);
+
 
 		TAILQ_INIT(&head);
 		if (debug_pkt_dump) {
@@ -1188,6 +1193,10 @@ int main(int argc, char **argv)
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

