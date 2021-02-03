Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D5B30D4C1
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 09:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhBCIND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 03:13:03 -0500
Received: from mga12.intel.com ([192.55.52.136]:59621 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232591AbhBCIM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 03:12:27 -0500
IronPort-SDR: KOlOIN00P7PlgQjQZFQX6Iws2j5slGmaPLsVsmHCVbkSfaLSINW0veaMDH2uG1cZE7LkUk5o4b
 xzgHnWMhfiRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="160170063"
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="160170063"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 00:11:35 -0800
IronPort-SDR: vPcL4vTIm8S/YIxge0BvP8T7aES9OcBEcoWdGGsPGjLf7a8i/27viRGxpc2UPY5pKaDD15ZEZD
 zS/ra253uQuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="413932472"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga002.fm.intel.com with ESMTP; 03 Feb 2021 00:11:33 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     daniel@iogearbox.net, Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v4 4/6] selftests/bpf: XSK_TRACE_DROP_PKT_TOO_BIG test
Date:   Wed,  3 Feb 2021 07:41:25 +0000
Message-Id: <20210203074127.8616-5-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210203074127.8616-1-ciara.loftus@intel.com>
References: <20210203074127.8616-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test increases the UMEM headroom to a size that will
cause packets to be dropped. Traces which report these
drops are expected which look like so:

xsk_packet_drop: netdev: ve3213 qid 0 reason: packet too big: \
  len 60 max 1 not_used 0

The test validates that these traces were successfully generated.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh  |  25 ++++++
 tools/testing/selftests/bpf/xdpxceiver.c | 102 ++++++++++++++++++++---
 tools/testing/selftests/bpf/xdpxceiver.h |   6 ++
 3 files changed, 123 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 2b4a4f42b220..5b4e42ac8c20 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -83,6 +83,7 @@ done
 
 TEST_NAME="PREREQUISITES"
 DEFAULTPKTS=10000
+TRACEPKTS=64
 
 URANDOM=/dev/urandom
 [ ! -e "${URANDOM}" ] && { echo "${URANDOM} not found. Skipping tests."; test_exit 1 1; }
@@ -246,6 +247,30 @@ retval=$?
 test_status $retval "${TEST_NAME}"
 statusList+=($retval)
 
+### TEST 10
+TEST_NAME="SKB TRACE DROP PKT_TOO_BIG"
+
+vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
+
+params=("-S" "-t" "0" "-C" "${TRACEPKTS}")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
+### TEST 11
+TEST_NAME="DRV TRACE DROP PKT_TOO_BIG"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N" "-t" "0" "-C" "${TRACEPKTS}")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
 ## END TESTS
 
 cleanup_exit ${VETH0} ${VETH1} ${NS1}
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index e6e0d42d8074..dda965c3d9ec 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -33,6 +33,8 @@
  *       Configure sockets as bi-directional tx/rx sockets, sets up fill and
  *       completion rings on each socket, tx/rx in both directions. Only nopoll
  *       mode is used
+ *    e. Tracing - XSK_TRACE_DROP_PKT_TOO_BIG
+ *       Increase the headroom size and send packets. Validate traces.
  *
  * 2. AF_XDP DRV/Native mode
  *    Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
@@ -44,8 +46,9 @@
  *    d. Bi-directional sockets
  *    - Only copy mode is supported because veth does not currently support
  *      zero-copy mode
+ *    e. Tracing - XSK_TRACE_DROP_PKT_TOO_BIG
  *
- * Total tests: 8
+ * Total tests: 10
  *
  * Flow:
  * -----
@@ -272,13 +275,23 @@ static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
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
 
@@ -363,7 +376,7 @@ static void usage(const char *prog)
 	    "  -B, --bidi           Bi-directional sockets test\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n"
-	    "  -t, --trace-enable   Enable trace\n";
+	    "  -t, --trace-enable=n Enable trace and execute test 'n'\n";
 	ksft_print_msg(str, prog);
 }
 
@@ -450,7 +463,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcTBDC:t", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcTBDC:t:", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -503,6 +516,7 @@ static void parse_command_line(int argc, char **argv)
 			break;
 		case 't':
 			opt_trace_enable = 1;
+			opt_trace_code = atoi(optarg);
 			break;
 		default:
 			usage(basename(argv[0]));
@@ -730,6 +744,28 @@ static void worker_pkt_dump(void)
 	}
 }
 
+static void worker_trace_validate(FILE *fp, char *ifname)
+{
+	char trace_str[128];
+	char *line = NULL;
+	size_t len = 0;
+	int ret = 0;
+
+	snprintf(trace_str, sizeof(trace_str), "netdev: %s qid 0 reason: %s",
+		 ifname, reason_str);
+
+	while (trace_counter != expected_traces) {
+		while ((ret = getline(&line, &len, fp)) == EOF)
+			continue;
+		if (strstr(line, trace_str) != NULL)
+			trace_counter++;
+	}
+
+	sigvar = 1;
+
+	fclose(fp);
+}
+
 static void worker_pkt_validate(void)
 {
 	u32 payloadseqnum = -2;
@@ -851,6 +887,25 @@ static int enable_disable_trace(bool enable)
 	return ret;
 }
 
+static FILE *get_eof_trace(void)
+{
+	FILE *ret_fp;
+	char *line = NULL;
+	size_t len = 0;
+	int ret = 0;
+
+	ret_fp = fopen(TRACE_FILE, "r");
+	if (ret_fp == NULL) {
+		ksft_print_msg("Error opening %s\n", TRACE_FILE);
+		return NULL;
+	}
+
+	/* Go to end of file and record the file pointer */
+	while ((ret = getline(&line, &len, ret_fp)) != EOF)
+		;
+
+	return ret_fp;
+}
 
 static void *worker_testapp_validate(void *arg)
 {
@@ -900,12 +955,22 @@ static void *worker_testapp_validate(void *arg)
 		}
 
 		ksft_print_msg("Sending %d packets on interface %s\n",
-			       (opt_pkt_count - 1), ifobject->ifname);
+			       (opt_trace_enable ? opt_pkt_count : opt_pkt_count - 1),
+			       ifobject->ifname);
 		tx_only_all(ifobject);
 	} else if (ifobject->fv.vector == rx) {
 		struct pollfd fds[MAX_SOCKS] = { };
+		FILE *tr_fp = NULL;
 		int ret;
 
+		if (opt_trace_enable) {
+			tr_fp = get_eof_trace();
+			if (tr_fp == NULL) {
+				ksft_print_msg("Error getting EOF of trace\n");
+				exit_with_error(-1);
+			}
+		}
+
 		if (!bidi_pass)
 			thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_rx);
 
@@ -932,15 +997,22 @@ static void *worker_testapp_validate(void *arg)
 				if (ret <= 0)
 					continue;
 			}
-			rx_pkt(ifobject->xsk, fds);
-			worker_pkt_validate();
+
+			if (!opt_trace_enable) {
+				rx_pkt(ifobject->xsk, fds);
+				worker_pkt_validate();
+			} else {
+				worker_trace_validate(tr_fp, ifobject->ifname);
+			}
 
 			if (sigvar)
 				break;
 		}
 
-		ksft_print_msg("Received %d packets on interface %s\n",
-			       pkt_counter, ifobject->ifname);
+		ksft_print_msg("%s %d packets on interface %s\n",
+			       opt_trace_enable ? "Traced" : "Received",
+			       opt_trace_enable ? trace_counter : pkt_counter,
+			       ifobject->ifname);
 
 		if (opt_teardown)
 			ksft_print_msg("Destroying socket\n");
@@ -1086,15 +1158,25 @@ int main(int argc, char **argv)
 
 	parse_command_line(argc, argv);
 
-	num_frames = ++opt_pkt_count;
+	num_frames = opt_trace_enable ? opt_pkt_count : ++opt_pkt_count;
 
 	init_iface_config(ifaceconfig);
 
 	if (opt_trace_enable) {
+		expected_traces = opt_pkt_count;
 		if (enable_disable_trace(1)) {
 			ksft_test_result_fail("ERROR: failed to enable tracing for trace test\n");
 			ksft_exit_xfail();
 		}
+		switch (opt_trace_code) {
+		case XSK_TRACE_DROP_PKT_TOO_BIG:
+			reason_str = "packet too big";
+			break;
+		default:
+			ksft_test_result_fail("ERROR: unsupported trace %i\n",
+						opt_trace_code);
+			ksft_exit_xfail();
+		}
 	}
 
 	pthread_init_mutex();
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 5308b501eecc..4cdb8fe81837 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -42,6 +42,8 @@
 #define POLL_TMOUT 1000
 #define NEED_WAKEUP true
 #define TRACE_ENABLE_FILE "/sys/kernel/debug/tracing/events/xsk/xsk_packet_drop/enable"
+#define TRACE_FILE "/sys/kernel/debug/tracing/trace"
+#define TRACE_MAX_PKTS 100 /* limit size to avoid filling trace buffer */
 
 typedef __u32 u32;
 typedef __u16 u16;
@@ -66,11 +68,15 @@ static int opt_teardown;
 static int opt_bidi;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
 static int opt_trace_enable;
+static int opt_trace_code = -1;
 static int reset_trace;
 static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
+static u32 trace_counter;
 static u32 prev_pkt = -1;
 static int sigvar;
+static int expected_traces;
+static const char *reason_str;
 
 struct xsk_umem_info {
 	struct xsk_ring_prod fq;
-- 
2.17.1

