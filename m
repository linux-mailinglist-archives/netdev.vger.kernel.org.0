Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EF4304AFD
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbhAZExK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:53:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:41202 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbhAYJjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 04:39:52 -0500
IronPort-SDR: 2Bugw0SFI0BTT9JQ28XZ7Q4jsgEUbMc0r46JPqaZR/Bz+eIptSfLELzU/MlHFQ1EP7ZvjqwgaB
 xD5LVAB7GxRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="179844624"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="179844624"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:37:23 -0800
IronPort-SDR: 5x2uVhr1n31HY3UXEuEC+C9AJ6EKcXeczXQugNk9chjFmDX/n1YAQYJ0KfHyIFnDKiu1IaHYtV
 R9zVWyIfrLuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="577321015"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga005.fm.intel.com with ESMTP; 25 Jan 2021 01:37:21 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next 3/6] selftests/bpf: add framework for xsk selftests
Date:   Mon, 25 Jan 2021 09:07:36 +0000
Message-Id: <20210125090739.1045-4-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210125090739.1045-1-ciara.loftus@intel.com>
References: <20210125090739.1045-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces framework to the xsk selftests
for testing the xsk_packet_drop traces. The '-t' or
'--trace-enable' args enable the trace, and disable
it on exit unless it was already enabled before the
test.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 65 ++++++++++++++++++++++--
 tools/testing/selftests/bpf/xdpxceiver.h |  3 ++
 2 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 1e722ee76b1f..95e5cddc3f78 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -72,6 +72,7 @@
 typedef __u16 __sum16;
 #include <linux/if_link.h>
 #include <linux/if_ether.h>
+#include <linux/if_xdp.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
 #include <arpa/inet.h>
@@ -108,7 +109,8 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define print_ksft_result(void)\
 	(ksft_test_result_pass("PASS: %s %s %s%s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" :\
 			       "NOPOLL", opt_teardown ? "Socket Teardown" : "",\
-			       opt_bidi ? "Bi-directional Sockets" : ""))
+			       opt_bidi ? "Bi-directional Sockets" : "",\
+			       opt_trace_enable ? "Trace enabled" : ""))
 
 static void pthread_init_mutex(void)
 {
@@ -342,6 +344,7 @@ static struct option long_options[] = {
 	{"bidi", optional_argument, 0, 'B'},
 	{"debug", optional_argument, 0, 'D'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
+	{"trace-enable", optional_argument, 0, 't'},
 	{0, 0, 0, 0}
 };
 
@@ -359,7 +362,8 @@ static void usage(const char *prog)
 	    "  -T, --tear-down      Tear down sockets by repeatedly recreating them\n"
 	    "  -B, --bidi           Bi-directional sockets test\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
-	    "  -C, --tx-pkt-count=n Number of packets to send\n";
+	    "  -C, --tx-pkt-count=n Number of packets to send\n"
+	    "  -t, --trace-enable   Enable trace\n";
 	ksft_print_msg(str, prog);
 }
 
@@ -448,7 +452,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcTBDC:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcTBDC:t", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -499,6 +503,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'C':
 			opt_pkt_count = atoi(optarg);
 			break;
+		case 't':
+			opt_trace_enable = 1;
+			break;
 		default:
 			usage(basename(argv[0]));
 			ksft_exit_xfail();
@@ -811,6 +818,48 @@ static void thread_common_ops(void *arg, void *bufs, pthread_mutex_t *mutexptr,
 		exit_with_error(ret);
 }
 
+static int enable_disable_trace(bool enable)
+{
+	FILE *en_fp;
+	int val;
+	int read, ret = 0;
+
+	en_fp = fopen(TRACE_ENABLE_FILE, "r+");
+	if (en_fp == NULL) {
+		ksft_print_msg("Error opening %s\n", TRACE_ENABLE_FILE);
+		return -1;
+	}
+
+	/* Read current value */
+	read = fscanf(en_fp, "%i", &val);
+	if (read != 1) {
+		ksft_print_msg("Error reading from %s\n", TRACE_ENABLE_FILE);
+		ret = -1;
+		goto out_close;
+	}
+
+	if (val != enable) {
+		char w[2];
+
+		snprintf(w, 2, "%d", enable);
+		if (fputs(w, en_fp) == EOF) {
+			ksft_print_msg("Error writing to %s\n", TRACE_ENABLE_FILE);
+			ret = -1;
+		} else {
+			ksft_print_msg("Trace %s\n", enable == 1 ? "enabled" : "disabled");
+		}
+	}
+
+	/* If we are enabling the trace, flag to restore it to its original state (off) on exit */
+	reset_trace = enable;
+
+out_close:
+	fclose(en_fp);
+
+	return ret;
+}
+
+
 static void *worker_testapp_validate(void *arg)
 {
 	struct udphdr *udp_hdr =
@@ -1050,6 +1099,13 @@ int main(int argc, char **argv)
 
 	init_iface_config((void *)ifaceconfig);
 
+	if (opt_trace_enable) {
+		if (enable_disable_trace(1)) {
+			ksft_test_result_fail("ERROR: failed to enable tracing for trace test\n");
+			ksft_exit_xfail();
+		}
+	}
+
 	pthread_init_mutex();
 
 	ksft_set_plan(1);
@@ -1066,6 +1122,9 @@ int main(int argc, char **argv)
 	for (int i = 0; i < MAX_INTERFACES; i++)
 		free(ifdict[i]);
 
+	if (reset_trace)
+		enable_disable_trace(0);
+
 	pthread_destroy_mutex();
 
 	ksft_exit_pass();
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 61f595b6f200..d6542fe42324 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -41,6 +41,7 @@
 #define BATCH_SIZE 64
 #define POLL_TMOUT 1000
 #define NEED_WAKEUP true
+#define TRACE_ENABLE_FILE "/sys/kernel/debug/tracing/events/xsk/xsk_packet_drop/enable"
 
 typedef __u32 u32;
 typedef __u16 u16;
@@ -64,6 +65,8 @@ static int opt_poll;
 static int opt_teardown;
 static int opt_bidi;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
+static int opt_trace_enable;
+static int reset_trace;
 static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
 static u32 prev_pkt = -1;
-- 
2.17.1

