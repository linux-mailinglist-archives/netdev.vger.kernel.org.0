Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAE5304AEF
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbhAZEyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:54:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:41207 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbhAYJkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 04:40:22 -0500
IronPort-SDR: D6YdMc6sbnH4y23GF+Z3dbteyagkVvUaqa+zYhA6cqJMw3By7APJdzpTPbjX4b1Z/hDqVrXive
 TCpJ/nbpIaVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="179844629"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="179844629"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:37:28 -0800
IronPort-SDR: YLs1zBo9KRVZACUneHuaagAzVwE1XjmT7jvlz6kr9uIAI2cGwBkn4F/LkjMei95Z1px/SRMPVk
 qKVWWd+uEi2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="577321028"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga005.fm.intel.com with ESMTP; 25 Jan 2021 01:37:27 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next 5/6] selftests/bpf: XSK_TRACE_DROP_PKT_TOO_BIG test
Date:   Mon, 25 Jan 2021 09:07:38 +0000
Message-Id: <20210125090739.1045-6-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210125090739.1045-1-ciara.loftus@intel.com>
References: <20210125090739.1045-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test increases the UMEM headroom to a size that
will cause packets to be dropped. Traces which report
these drops are expected. The test validates that these
traces were successfully generated.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh  | 24 ++++++++++++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.c | 21 +++++++++++++++++++--
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index a085ef0602a7..95ceee151de1 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -271,6 +271,30 @@ retval=$?
 test_status $retval "${TEST_NAME}"
 statusList+=($retval)
 
+### TEST 12
+TEST_NAME="SKB TRACE DROP PKT_TOO_BIG"
+
+vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
+
+params=("-S" "-t" "1" "-C" "${TRACEPKTS}")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
+### TEST 13
+TEST_NAME="DRV TRACE DROP PKT_TOO_BIG"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N" "-t" "1" "-C" "${TRACEPKTS}")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
 ## END TESTS
 
 cleanup_exit ${VETH0} ${VETH1} ${NS1}
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 321b8013c709..71d684639ccb 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -35,6 +35,8 @@
  *       mode is used
  *    e. Tracing - XSK_TRACE_DROP_RXQ_FULL
  *       Reduce the RXQ size and do not read from it. Validate traces.
+ *    f. Tracing - XSK_TRACE_DROP_PKT_TOO_BIG
+ *       Increase the headroom size and send packets. Validate traces.
  *
  * 2. AF_XDP DRV/Native mode
  *    Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
@@ -47,8 +49,9 @@
  *    - Only copy mode is supported because veth does not currently support
  *      zero-copy mode
  *    e. Tracing - XSK_TRACE_DROP_RXQ_FULL
+ *    f. Tracing - XSK_TRACE_DROP_PKT_TOO_BIG
  *
- * Total tests: 10
+ * Total tests: 12
  *
  * Flow:
  * -----
@@ -275,13 +278,23 @@ static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
 static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size)
 {
 	int ret;
+	struct xsk_umem_config cfg = {
+		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
+		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
+		.frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE,
+		.frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM,
+		.flags = XSK_UMEM__DEFAULT_FLAGS
+	};
+
+	if (opt_trace_code == XSK_TRACE_DROP_PKT_TOO_BIG)
+		cfg.frame_headroom = XSK_UMEM__DEFAULT_FRAME_SIZE - XDP_PACKET_HEADROOM - 1;
 
 	data->umem = calloc(1, sizeof(struct xsk_umem_info));
 	if (!data->umem)
 		exit_with_error(errno);
 
 	ret = xsk_umem__create(&data->umem->umem, buffer, size,
-			       &data->umem->fq, &data->umem->cq, NULL);
+			       &data->umem->fq, &data->umem->cq, &cfg);
 	if (ret)
 		exit_with_error(ret);
 
@@ -1179,6 +1192,10 @@ int main(int argc, char **argv)
 			expected_traces = opt_pkt_count - TRACE_RXQ_FULL_RXQ_SIZE;
 			reason_str = "rxq full";
 			break;
+		case XSK_TRACE_DROP_PKT_TOO_BIG:
+			expected_traces = opt_pkt_count;
+			reason_str = "packet too big";
+			break;
 		default:
 			ksft_test_result_fail("ERROR: unsupported trace %i\n",
 						opt_trace_code);
-- 
2.17.1

