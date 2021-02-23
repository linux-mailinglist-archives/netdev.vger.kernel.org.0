Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4ED4322F31
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 17:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbhBWQ5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 11:57:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:62263 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233652AbhBWQ5Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 11:57:25 -0500
IronPort-SDR: /7epWHz9s1teRqlGz5KkmQIIqWD4V0beqsq/WnEX/xI6+I3SGlepfj/nbhWPTq1TgsY6nQC7zz
 TqbiemhFuCLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9904"; a="184924339"
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="184924339"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 08:56:43 -0800
IronPort-SDR: ybH+PKlQuAdUi04e1RwRn5H3iG2lY4qejtY1zJQOlhU1lwvsuw4JChD23MddqfbWyyj/xbOA3b
 8PzeHFw0/s6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="441792894"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga001.jf.intel.com with ESMTP; 23 Feb 2021 08:56:05 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com, maciej.fijalkowski@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v3 4/4] selftests/bpf: introduce xsk statistics tests
Date:   Tue, 23 Feb 2021 16:23:04 +0000
Message-Id: <20210223162304.7450-5-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210223162304.7450-1-ciara.loftus@intel.com>
References: <20210223162304.7450-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces a range of tests to the xsk testsuite
for validating xsk statistics.

A new test type called 'stats' is added. Within it there are
four sub-tests. Each test configures a scenario which should
trigger the given error statistic. The test passes if the statistic
is successfully incremented.

The four statistics for which tests have been created are:
1. rx dropped
Increase the UMEM frame headroom to a value which results in
insufficient space in the rx buffer for both the packet and the headroom.
2. tx invalid
Set the 'len' field of tx descriptors to an invalid value (umem frame
size + 1).
3. rx ring full
Reduce the size of the RX ring to a fraction of the fill ring size.
4. fill queue empty
Do not populate the fill queue and then try to receive pkts.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 137 ++++++++++++++++++++---
 tools/testing/selftests/bpf/xdpxceiver.h |  13 +++
 2 files changed, 136 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index e7913444518d..8b0f7fdd9003 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -28,8 +28,21 @@
  *       Configure sockets as bi-directional tx/rx sockets, sets up fill and
  *       completion rings on each socket, tx/rx in both directions. Only nopoll
  *       mode is used
+ *    e. Statistics
+ *       Trigger some error conditions and ensure that the appropriate statistics
+ *       are incremented. Within this test, the following statistics are tested:
+ *       i.   rx dropped
+ *            Increase the UMEM frame headroom to a value which results in
+ *            insufficient space in the rx buffer for both the packet and the headroom.
+ *       ii.  tx invalid
+ *            Set the 'len' field of tx descriptors to an invalid value (umem frame
+ *            size + 1).
+ *       iii. rx ring full
+ *            Reduce the size of the RX ring to a fraction of the fill ring size.
+ *       iv.  fill queue empty
+ *            Do not populate the fill queue and then try to receive pkts.
  *
- * Total tests: 8
+ * Total tests: 10
  *
  * Flow:
  * -----
@@ -95,10 +108,11 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s %s%s\n", configured_mode ? "DRV" : "SKB",\
+	(ksft_test_result_pass("PASS: %s %s %s%s%s\n", configured_mode ? "DRV" : "SKB",\
 			       test_type == TEST_TYPE_POLL ? "POLL" : "NOPOLL",\
 			       test_type == TEST_TYPE_TEARDOWN ? "Socket Teardown" : "",\
-			       test_type == TEST_TYPE_BIDI ? "Bi-directional Sockets" : ""))
+			       test_type == TEST_TYPE_BIDI ? "Bi-directional Sockets" : "",\
+			       test_type == TEST_TYPE_STATS ? "Stats" : ""))
 
 static void pthread_init_mutex(void)
 {
@@ -260,13 +274,20 @@ static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
 static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size)
 {
 	int ret;
+	struct xsk_umem_config cfg = {
+		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
+		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
+		.frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE,
+		.frame_headroom = frame_headroom,
+		.flags = XSK_UMEM__DEFAULT_FLAGS
+	};
 
 	data->umem = calloc(1, sizeof(struct xsk_umem_info));
 	if (!data->umem)
 		exit_with_error(errno);
 
 	ret = xsk_umem__create(&data->umem->umem, buffer, size,
-			       &data->umem->fq, &data->umem->cq, NULL);
+			       &data->umem->fq, &data->umem->cq, &cfg);
 	if (ret)
 		exit_with_error(ret);
 
@@ -298,7 +319,7 @@ static int xsk_configure_socket(struct ifobject *ifobject)
 		exit_with_error(errno);
 
 	ifobject->xsk->umem = ifobject->umem;
-	cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
+	cfg.rx_size = rxqsize;
 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
 	cfg.libbpf_flags = 0;
 	cfg.xdp_flags = xdp_flags;
@@ -565,6 +586,8 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
 {
 	u32 idx;
 	unsigned int i;
+	bool tx_invalid_test = stat_test_type == STAT_TEST_TX_INVALID;
+	u32 len = tx_invalid_test ? XSK_UMEM__DEFAULT_FRAME_SIZE + 1 : PKT_SIZE;
 
 	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) < batch_size)
 		complete_tx_only(xsk, batch_size);
@@ -573,11 +596,16 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
 
 		tx_desc->addr = (*frameptr + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
-		tx_desc->len = PKT_SIZE;
+		tx_desc->len = len;
 	}
 
 	xsk_ring_prod__submit(&xsk->tx, batch_size);
-	xsk->outstanding_tx += batch_size;
+	if (!tx_invalid_test) {
+		xsk->outstanding_tx += batch_size;
+	} else {
+		if (!NEED_WAKEUP || xsk_ring_prod__needs_wakeup(&xsk->tx))
+			kick_tx(xsk);
+	}
 	*frameptr += batch_size;
 	*frameptr %= num_frames;
 	complete_tx_only(xsk, batch_size);
@@ -689,6 +717,48 @@ static void worker_pkt_dump(void)
 	}
 }
 
+static void worker_stats_validate(struct ifobject *ifobject)
+{
+	struct xdp_statistics stats;
+	socklen_t optlen;
+	int err;
+	struct xsk_socket *xsk = stat_test_type == STAT_TEST_TX_INVALID ?
+							ifdict[!ifobject->ifdict_index]->xsk->xsk :
+							ifobject->xsk->xsk;
+	int fd = xsk_socket__fd(xsk);
+	unsigned long xsk_stat = 0, expected_stat = opt_pkt_count;
+
+	sigvar = 0;
+
+	optlen = sizeof(stats);
+	err = getsockopt(fd, SOL_XDP, XDP_STATISTICS, &stats, &optlen);
+	if (err)
+		return;
+
+	if (optlen == sizeof(struct xdp_statistics)) {
+		switch (stat_test_type) {
+		case STAT_TEST_RX_DROPPED:
+			xsk_stat = stats.rx_dropped;
+			break;
+		case STAT_TEST_TX_INVALID:
+			xsk_stat = stats.tx_invalid_descs;
+			break;
+		case STAT_TEST_RX_FULL:
+			xsk_stat = stats.rx_ring_full;
+			expected_stat -= RX_FULL_RXQSIZE;
+			break;
+		case STAT_TEST_RX_FILL_EMPTY:
+			xsk_stat = stats.rx_fill_ring_empty_descs;
+			break;
+		default:
+			break;
+		}
+
+		if (xsk_stat == expected_stat)
+			sigvar = 1;
+	}
+}
+
 static void worker_pkt_validate(void)
 {
 	u32 payloadseqnum = -2;
@@ -827,7 +897,8 @@ static void *worker_testapp_validate(void *arg)
 			thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_rx);
 
 		print_verbose("Interface [%s] vector [Rx]\n", ifobject->ifname);
-		xsk_populate_fill_ring(ifobject->umem);
+		if (stat_test_type != STAT_TEST_RX_FILL_EMPTY)
+			xsk_populate_fill_ring(ifobject->umem);
 
 		TAILQ_INIT(&head);
 		if (debug_pkt_dump) {
@@ -849,15 +920,21 @@ static void *worker_testapp_validate(void *arg)
 				if (ret <= 0)
 					continue;
 			}
-			rx_pkt(ifobject->xsk, fds);
-			worker_pkt_validate();
+
+			if (test_type != TEST_TYPE_STATS) {
+				rx_pkt(ifobject->xsk, fds);
+				worker_pkt_validate();
+			} else {
+				worker_stats_validate(ifobject);
+			}
 
 			if (sigvar)
 				break;
 		}
 
-		print_verbose("Received %d packets on interface %s\n",
-			       pkt_counter, ifobject->ifname);
+		if (test_type != TEST_TYPE_STATS)
+			print_verbose("Received %d packets on interface %s\n",
+				pkt_counter, ifobject->ifname);
 
 		if (test_type == TEST_TYPE_TEARDOWN)
 			print_verbose("Destroying socket\n");
@@ -931,7 +1008,7 @@ static void testapp_validate(void)
 		free(pkt_buf);
 	}
 
-	if (!(test_type == TEST_TYPE_TEARDOWN) && !bidi)
+	if (!(test_type == TEST_TYPE_TEARDOWN) && !bidi && !(test_type == TEST_TYPE_STATS))
 		print_ksft_result();
 }
 
@@ -950,6 +1027,32 @@ static void testapp_sockets(void)
 	print_ksft_result();
 }
 
+static void testapp_stats(void)
+{
+	for (int i = 0; i < STAT_TEST_TYPE_MAX; i++) {
+		stat_test_type = i;
+
+		/* reset defaults */
+		rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
+		frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM;
+
+		switch (stat_test_type) {
+		case STAT_TEST_RX_DROPPED:
+			frame_headroom = XSK_UMEM__DEFAULT_FRAME_SIZE -
+						XDP_PACKET_HEADROOM - 1;
+			break;
+		case STAT_TEST_RX_FULL:
+			rxqsize = RX_FULL_RXQSIZE;
+			break;
+		default:
+			break;
+		}
+		testapp_validate();
+	}
+
+	print_ksft_result();
+}
+
 static void init_iface_config(struct ifaceconfigobj *ifaceconfig)
 {
 	/*Init interface0 */
@@ -1037,6 +1140,10 @@ static void run_pkt_test(int mode, int type)
 	prev_pkt = -1;
 	ifdict[0]->fv.vector = tx;
 	ifdict[1]->fv.vector = rx;
+	sigvar = 0;
+	stat_test_type = -1;
+	rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
+	frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM;
 
 	switch (mode) {
 	case (TEST_MODE_SKB):
@@ -1055,7 +1162,9 @@ static void run_pkt_test(int mode, int type)
 
 	pthread_init_mutex();
 
-	if ((test_type != TEST_TYPE_TEARDOWN) && (test_type != TEST_TYPE_BIDI))
+	if (test_type == TEST_TYPE_STATS)
+		testapp_stats();
+	else if ((test_type != TEST_TYPE_TEARDOWN) && (test_type != TEST_TYPE_BIDI))
 		testapp_validate();
 	else
 		testapp_sockets();
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index e05703f661f8..30314ef305c2 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -42,6 +42,7 @@
 #define POLL_TMOUT 1000
 #define NEED_WAKEUP true
 #define DEFAULT_PKT_CNT 10000
+#define RX_FULL_RXQSIZE 32
 
 #define print_verbose(x...) do { if (opt_verbose) ksft_print_msg(x); } while (0)
 
@@ -61,9 +62,18 @@ enum TEST_TYPES {
 	TEST_TYPE_POLL,
 	TEST_TYPE_TEARDOWN,
 	TEST_TYPE_BIDI,
+	TEST_TYPE_STATS,
 	TEST_TYPE_MAX
 };
 
+enum STAT_TEST_TYPES {
+	STAT_TEST_RX_DROPPED,
+	STAT_TEST_TX_INVALID,
+	STAT_TEST_RX_FULL,
+	STAT_TEST_RX_FILL_EMPTY,
+	STAT_TEST_TYPE_MAX
+};
+
 static int configured_mode = TEST_MODE_UNCONFIGURED;
 static u8 debug_pkt_dump;
 static u32 num_frames;
@@ -81,6 +91,9 @@ static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
 static long prev_pkt = -1;
 static int sigvar;
+static int stat_test_type;
+static u32 rxqsize;
+static u32 frame_headroom;
 
 struct xsk_umem_info {
 	struct xsk_ring_prod fq;
-- 
2.17.1

