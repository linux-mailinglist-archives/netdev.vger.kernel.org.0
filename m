Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072E030C109
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhBBOMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:12:40 -0500
Received: from mga06.intel.com ([134.134.136.31]:52468 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233919AbhBBOK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 09:10:58 -0500
IronPort-SDR: +PHnuxBFln5o1dyVt73zeErXMPYIa2+niJ2oJiIr6zx7V+rXJBlYMUvK97F6mkMXXK9jxs0S9v
 wfzYAZFjaMUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="242371383"
X-IronPort-AV: E=Sophos;i="5.79,395,1602572400"; 
   d="scan'208";a="242371383"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 06:06:51 -0800
IronPort-SDR: x0WXxixx7pB8UIOaDk+1N7mzB2xBj958woDYx5x7Py6L5RoPy2Iu3hVskdxGHa8YiqynEianZV
 A2h2XBAr/rww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,395,1602572400"; 
   d="scan'208";a="479774967"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga001.fm.intel.com with ESMTP; 02 Feb 2021 06:06:49 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     daniel@iogearbox.net, Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v3 5/6] selftests/bpf: XSK_TRACE_INVALID_FILLADDR test
Date:   Tue,  2 Feb 2021 13:36:41 +0000
Message-Id: <20210202133642.8562-6-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202133642.8562-1-ciara.loftus@intel.com>
References: <20210202133642.8562-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test supplies invalid addresses to the fill
queue at init. On RX, traces are expected which report
the invalid address which look like so:

xsk_packet_drop: netdev: ve3213 qid 0 reason: invalid fill addr: \
  addr 262144 len 0 options 0

The test validates that these traces were successfully generated.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh  | 24 ++++++++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.c | 29 ++++++++++++++++++------
 2 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 5b4e42ac8c20..bc026da25d54 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -271,6 +271,30 @@ retval=$?
 test_status $retval "${TEST_NAME}"
 statusList+=($retval)
 
+### TEST 12
+TEST_NAME="SKB TRACE INVALID_FILLADDR"
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
+TEST_NAME="DRV TRACE INVALID_FILLADDR"
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
index dda965c3d9ec..e63dc1c228ed 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -35,6 +35,8 @@
  *       mode is used
  *    e. Tracing - XSK_TRACE_DROP_PKT_TOO_BIG
  *       Increase the headroom size and send packets. Validate traces.
+ *    f. Tracing - XSK_TRACE_DROP_INVALID_FILLADDR
+ *       Populate the fill queue with invalid addresses. Validate traces.
  *
  * 2. AF_XDP DRV/Native mode
  *    Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
@@ -47,8 +49,9 @@
  *    - Only copy mode is supported because veth does not currently support
  *      zero-copy mode
  *    e. Tracing - XSK_TRACE_DROP_PKT_TOO_BIG
+ *    f. Tracing - XSK_TRACE_DROP_INVALID_FILLADDR
  *
- * Total tests: 10
+ * Total tests: 12
  *
  * Flow:
  * -----
@@ -276,7 +279,8 @@ static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size)
 {
 	int ret;
 	struct xsk_umem_config cfg = {
-		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
+		.fill_size = opt_trace_code == XSK_TRACE_DROP_INVALID_FILLADDR ? opt_pkt_count :
+						XSK_RING_PROD__DEFAULT_NUM_DESCS,
 		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
 		.frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE,
 		.frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM,
@@ -302,13 +306,21 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
 {
 	int ret, i;
 	u32 idx;
+	u32 num_addrs = XSK_RING_PROD__DEFAULT_NUM_DESCS;
+	u32 invalid = 0;
 
-	ret = xsk_ring_prod__reserve(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
-	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
+	if (opt_trace_code == XSK_TRACE_DROP_INVALID_FILLADDR) {
+		num_addrs = opt_pkt_count;
+		invalid = num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE;
+	}
+
+	ret = xsk_ring_prod__reserve(&umem->fq, num_addrs, &idx);
+	if (ret != num_addrs)
 		exit_with_error(ret);
-	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
-		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = i * XSK_UMEM__DEFAULT_FRAME_SIZE;
-	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
+	for (i = 0; i < num_addrs; i++)
+		*xsk_ring_prod__fill_addr(&umem->fq, idx++) =
+			(i * XSK_UMEM__DEFAULT_FRAME_SIZE) + invalid;
+	xsk_ring_prod__submit(&umem->fq, num_addrs);
 }
 
 static int xsk_configure_socket(struct ifobject *ifobject)
@@ -1172,6 +1184,9 @@ int main(int argc, char **argv)
 		case XSK_TRACE_DROP_PKT_TOO_BIG:
 			reason_str = "packet too big";
 			break;
+		case XSK_TRACE_DROP_INVALID_FILLADDR:
+			reason_str = "invalid fill addr";
+			break;
 		default:
 			ksft_test_result_fail("ERROR: unsupported trace %i\n",
 						opt_trace_code);
-- 
2.17.1

