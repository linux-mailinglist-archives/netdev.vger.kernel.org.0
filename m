Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A991E304AFB
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbhAZExz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:53:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:41204 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726945AbhAYJjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 04:39:52 -0500
IronPort-SDR: omxEZ6P+Ga6Gk0CzAI1rfqSSn8O79FdCavnqYUrbpeMndw0f05j2F30Q/eo/3StC1pRHL0Maxe
 cau9Oyq6G+vA==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="179844627"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="179844627"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:37:26 -0800
IronPort-SDR: ko7Uo4WJw9itTzOFDTka1rJkYNFeWmAKNi04eUwFJNcJ9BijN/oxsq+95s0rjkq0kyhz1TKket
 Nor2d42br3IQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="577321022"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga005.fm.intel.com with ESMTP; 25 Jan 2021 01:37:24 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next 4/6] selftests/bpf: XSK_TRACE_DROP_RXQ_FULL test
Date:   Mon, 25 Jan 2021 09:07:37 +0000
Message-Id: <20210125090739.1045-5-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210125090739.1045-1-ciara.loftus@intel.com>
References: <20210125090739.1045-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test limits the size of the RXQ and does not read
from it. Packets are transmitted. Traces are expected
which report packet drops for packets which could not
fit in the limited size rxq. The test validates that
these traces were successfully generated.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh  | 25 ++++++
 tools/testing/selftests/bpf/xdpxceiver.c | 96 ++++++++++++++++++++++--
 tools/testing/selftests/bpf/xdpxceiver.h |  7 ++
 3 files changed, 120 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 2b4a4f42b220..a085ef0602a7 100755
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
+TEST_NAME="SKB TRACE DROP RXQ_FULL"
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
+TEST_NAME="DRV TRACE DROP RXQ_FULL"
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
index 95e5cddc3f78..321b8013c709 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -33,6 +33,8 @@
  *       Configure sockets as bi-directional tx/rx sockets, sets up fill and
  *       completion rings on each socket, tx/rx in both directions. Only nopoll
  *       mode is used
+ *    e. Tracing - XSK_TRACE_DROP_RXQ_FULL
+ *       Reduce the RXQ size and do not read from it. Validate traces.
  *
  * 2. AF_XDP DRV/Native mode
  *    Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
@@ -44,8 +46,9 @@
  *    d. Bi-directional sockets
  *    - Only copy mode is supported because veth does not currently support
  *      zero-copy mode
+ *    e. Tracing - XSK_TRACE_DROP_RXQ_FULL
  *
- * Total tests: 8
+ * Total tests: 10
  *
  * Flow:
  * -----
@@ -310,7 +313,9 @@ static int xsk_configure_socket(struct ifobject *ifobject)
 		exit_with_error(errno);
 
 	ifobject->xsk->umem = ifobject->umem;
-	cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
+	cfg.rx_size = opt_trace_enable && (opt_trace_code == XSK_TRACE_DROP_RXQ_FULL) ?
+						TRACE_RXQ_FULL_RXQ_SIZE :
+						XSK_RING_CONS__DEFAULT_NUM_DESCS;
 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
 	cfg.libbpf_flags = 0;
 	cfg.xdp_flags = opt_xdp_flags;
@@ -363,7 +368,7 @@ static void usage(const char *prog)
 	    "  -B, --bidi           Bi-directional sockets test\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n"
-	    "  -t, --trace-enable   Enable trace\n";
+	    "  -t, --trace-enable=n Enable trace and execute test 'n'\n";
 	ksft_print_msg(str, prog);
 }
 
@@ -452,7 +457,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcTBDC:t", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcTBDC:t:", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -505,6 +510,7 @@ static void parse_command_line(int argc, char **argv)
 			break;
 		case 't':
 			opt_trace_enable = 1;
+			opt_trace_code = atoi(optarg);
 			break;
 		default:
 			usage(basename(argv[0]));
@@ -731,6 +737,29 @@ static void worker_pkt_dump(void)
 	}
 }
 
+static void worker_trace_validate(FILE *fp, char *ifname)
+{
+	char trace_str[128];
+	char *line = NULL;
+	size_t len = 0;
+	int ret = 0;
+
+	snprintf(trace_str, sizeof(trace_str),
+		"xsk_packet_drop: netdev: %s qid 0 reason: %s",
+		ifname, reason_str);
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
@@ -859,6 +888,25 @@ static int enable_disable_trace(bool enable)
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
@@ -913,8 +961,17 @@ static void *worker_testapp_validate(void *arg)
 		tx_only_all(arg);
 	} else if (((struct ifobject *)arg)->fv.vector == rx) {
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
 			thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_rx);
 
@@ -941,15 +998,22 @@ static void *worker_testapp_validate(void *arg)
 				if (ret <= 0)
 					continue;
 			}
-			rx_pkt(((struct ifobject *)arg)->xsk, fds);
-			worker_pkt_validate();
+
+			if (!opt_trace_enable) {
+				rx_pkt(((struct ifobject *)arg)->xsk, fds);
+				worker_pkt_validate();
+			} else {
+				worker_trace_validate(tr_fp, ((struct ifobject *)arg)->ifname);
+			}
 
 			if (sigvar)
 				break;
 		}
 
-		ksft_print_msg("Received %d packets on interface %s\n",
-			       pkt_counter, ((struct ifobject *)arg)->ifname);
+		ksft_print_msg("%s %d packets on interface %s\n",
+			       opt_trace_enable ? "Traced" : "Received",
+			       opt_trace_enable ? trace_counter : pkt_counter,
+			       ((struct ifobject *)arg)->ifname);
 
 		if (opt_teardown)
 			ksft_print_msg("Destroying socket\n");
@@ -1104,6 +1168,22 @@ int main(int argc, char **argv)
 			ksft_test_result_fail("ERROR: failed to enable tracing for trace test\n");
 			ksft_exit_xfail();
 		}
+		switch (opt_trace_code) {
+		case XSK_TRACE_DROP_RXQ_FULL:
+			if (opt_pkt_count <= TRACE_RXQ_FULL_RXQ_SIZE ||
+				(opt_pkt_count > TRACE_MAX_PKTS)) {
+				ksft_test_result_fail("ERROR: invalid packet count %i\n",
+						      opt_pkt_count);
+				ksft_exit_xfail();
+			}
+			expected_traces = opt_pkt_count - TRACE_RXQ_FULL_RXQ_SIZE;
+			reason_str = "rxq full";
+			break;
+		default:
+			ksft_test_result_fail("ERROR: unsupported trace %i\n",
+						opt_trace_code);
+			ksft_exit_xfail();
+		}
 	}
 
 	pthread_init_mutex();
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index d6542fe42324..432c2c20abeb 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -42,6 +42,9 @@
 #define POLL_TMOUT 1000
 #define NEED_WAKEUP true
 #define TRACE_ENABLE_FILE "/sys/kernel/debug/tracing/events/xsk/xsk_packet_drop/enable"
+#define TRACE_FILE "/sys/kernel/debug/tracing/trace"
+#define TRACE_RXQ_FULL_RXQ_SIZE 32 /* must be smaller than fq */
+#define TRACE_MAX_PKTS 100 /* limit size to avoid filling trace buffer */
 
 typedef __u32 u32;
 typedef __u16 u16;
@@ -66,11 +69,15 @@ static int opt_teardown;
 static int opt_bidi;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
 static int opt_trace_enable;
+static int opt_trace_code;
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

