Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CBA30C828
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbhBBRnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:43:00 -0500
Received: from mga06.intel.com ([134.134.136.31]:52438 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233888AbhBBOKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 09:10:50 -0500
IronPort-SDR: IDWl711BTClgY+xJ0rEc2Sr4pRu2umNXNlzaTRJIwO/upU4ZqDZulo2zZsoMRwAFHFPZMl9bOI
 5V6q60KM1eLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="242371373"
X-IronPort-AV: E=Sophos;i="5.79,395,1602572400"; 
   d="scan'208";a="242371373"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 06:06:47 -0800
IronPort-SDR: N/2pL8NCBtZPVw0GjkkeWDsRYBz7Et4EO+lVqAP4bXaHwaVFUPOZnf3wJ0rXOu1f+fIG64OlJy
 tKyxc89YORSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,395,1602572400"; 
   d="scan'208";a="479774779"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga001.fm.intel.com with ESMTP; 02 Feb 2021 06:06:45 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     daniel@iogearbox.net, Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v3 3/6] selftests/bpf: add framework for xsk selftests
Date:   Tue,  2 Feb 2021 13:36:39 +0000
Message-Id: <20210202133642.8562-4-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202133642.8562-1-ciara.loftus@intel.com>
References: <20210202133642.8562-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces framework to the xsk selftests for
testing the xsk_packet_drop traces. The '-t' or '--trace-enable'
args enable the trace, and disable it on exit unless it was
already enabled before the test.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 65 ++++++++++++++++++++++--
 tools/testing/selftests/bpf/xdpxceiver.h |  3 ++
 2 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 99ea6cf069e6..e6e0d42d8074 100644
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
 
@@ -446,7 +450,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcTBDC:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcTBDC:t", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -497,6 +501,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'C':
 			opt_pkt_count = atoi(optarg);
 			break;
+		case 't':
+			opt_trace_enable = 1;
+			break;
 		default:
 			usage(basename(argv[0]));
 			ksft_exit_xfail();
@@ -803,6 +810,48 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs, pthread_mut
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
@@ -1041,6 +1090,13 @@ int main(int argc, char **argv)
 
 	init_iface_config(ifaceconfig);
 
+	if (opt_trace_enable) {
+		if (enable_disable_trace(1)) {
+			ksft_test_result_fail("ERROR: failed to enable tracing for trace test\n");
+			ksft_exit_xfail();
+		}
+	}
+
 	pthread_init_mutex();
 
 	ksft_set_plan(1);
@@ -1057,6 +1113,9 @@ int main(int argc, char **argv)
 	for (int i = 0; i < MAX_INTERFACES; i++)
 		free(ifdict[i]);
 
+	if (reset_trace)
+		enable_disable_trace(0);
+
 	pthread_destroy_mutex();
 
 	ksft_exit_pass();
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 0e9f9b7e61c2..5308b501eecc 100644
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

