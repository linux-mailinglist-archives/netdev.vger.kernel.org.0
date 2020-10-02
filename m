Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F742281497
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbgJBOCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:02:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:44226 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBOCK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:02:10 -0400
IronPort-SDR: Wh1DK2+jDAT6bPrcPsxqQbxW2xBIBKnDN12IUnaiL1omwwd3DKrS9B+QQBX31IhIRTI2Bl7UY9
 rfo3222cGVDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="181119403"
X-IronPort-AV: E=Sophos;i="5.77,327,1596524400"; 
   d="scan'208";a="181119403"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 07:02:00 -0700
IronPort-SDR: PpnjfiwxKg74JDMuUvcKfJpzg4pJtPgp5iD2/+SAqQlu3ieQItUspxeMIAm/UuVE1laSdSQSku
 ACqqWOledDfA==
X-IronPort-AV: E=Sophos;i="5.77,327,1596524400"; 
   d="scan'208";a="508762706"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 07:01:59 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next 3/3] samples: bpf: driver interrupt statistics in xdpsock
Date:   Fri,  2 Oct 2020 13:36:12 +0000
Message-Id: <20201002133612.31536-3-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002133612.31536-1-ciara.loftus@intel.com>
References: <20201002133612.31536-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an option to count the number of interrupts generated per second and
total number of interrupts during the lifetime of the application for a
given interface. This information is extracted from /proc/interrupts. Since
there is no naming convention across drivers, the user must provide the
string which is specific to their interface in the /proc/interrupts file on
the command line.

Usage:

./xdpsock ... -I <irq_str>

eg. for queue 0 of i40e device eth0:

./xdpsock ... -I i40e-eth0-TxRx-0

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 samples/bpf/xdpsock_user.c | 120 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 119 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index ff119ede4ab1..1149e94ca32f 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -11,6 +11,7 @@
 #include <linux/if_xdp.h>
 #include <linux/if_ether.h>
 #include <linux/ip.h>
+#include <linux/limits.h>
 #include <linux/udp.h>
 #include <arpa/inet.h>
 #include <locale.h>
@@ -80,6 +81,9 @@ static u32 opt_pkt_fill_pattern = 0x12345678;
 static bool opt_extra_stats;
 static bool opt_quiet;
 static bool opt_app_stats;
+static const char *opt_irq_str = "";
+static u32 irq_no;
+static int irqs_at_init = -1;
 static int opt_poll;
 static int opt_interval = 1;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
@@ -111,6 +115,11 @@ struct xsk_ring_stats {
 	unsigned long prev_tx_empty_npkts;
 };
 
+struct xsk_driver_stats {
+	unsigned long intrs;
+	unsigned long prev_intrs;
+};
+
 struct xsk_app_stats {
 	unsigned long rx_empty_polls;
 	unsigned long fill_fail_polls;
@@ -138,6 +147,7 @@ struct xsk_socket_info {
 	struct xsk_socket *xsk;
 	struct xsk_ring_stats ring_stats;
 	struct xsk_app_stats app_stats;
+	struct xsk_driver_stats drv_stats;
 	u32 outstanding_tx;
 };
 
@@ -243,6 +253,100 @@ static void dump_app_stats(long dt)
 	}
 }
 
+static bool get_interrupt_number(void)
+{
+	FILE *f_int_proc;
+	char line[4096];
+	bool found = false;
+
+	f_int_proc = fopen("/proc/interrupts", "r");
+	if (f_int_proc == NULL) {
+		printf("Failed to open /proc/interrupts.\n");
+		return found;
+	}
+
+	while (!feof(f_int_proc) && !found) {
+		/* Make sure to read a full line at a time */
+		if (fgets(line, sizeof(line), f_int_proc) == NULL ||
+				line[strlen(line) - 1] != '\n') {
+			printf("Error reading from interrupts file\n");
+			break;
+		}
+
+		/* Extract interrupt number from line */
+		if (strstr(line, opt_irq_str) != NULL) {
+			irq_no = atoi(line);
+			found = true;
+			break;
+		}
+	}
+
+	fclose(f_int_proc);
+
+	return found;
+}
+
+static int get_irqs(void)
+{
+	char count_path[PATH_MAX];
+	int total_intrs = -1;
+	FILE *f_count_proc;
+	char line[4096];
+
+	snprintf(count_path, sizeof(count_path),
+		"/sys/kernel/irq/%i/per_cpu_count", irq_no);
+	f_count_proc = fopen(count_path, "r");
+	if (f_count_proc == NULL) {
+		printf("Failed to open %s\n", count_path);
+		return total_intrs;
+	}
+
+	if (fgets(line, sizeof(line), f_count_proc) == NULL ||
+			line[strlen(line) - 1] != '\n') {
+		printf("Error reading from %s\n", count_path);
+	} else {
+		static const char com[2] = ",";
+		char *token;
+
+		total_intrs = 0;
+		token = strtok(line, com);
+		while (token != NULL) {
+			/* sum up interrupts across all cores */
+			total_intrs += atoi(token);
+			token = strtok(NULL, com);
+		}
+	}
+
+	fclose(f_count_proc);
+
+	return total_intrs;
+}
+
+static void dump_driver_stats(long dt)
+{
+	int i;
+
+	for (i = 0; i < num_socks && xsks[i]; i++) {
+		char *fmt = "%-18s %'-14.0f %'-14lu\n";
+		double intrs_ps;
+		int n_ints = get_irqs();
+
+		if (n_ints < 0) {
+			printf("error getting intr info for intr %i\n", irq_no);
+			return;
+		}
+		xsks[i]->drv_stats.intrs = n_ints - irqs_at_init;
+
+		intrs_ps = (xsks[i]->drv_stats.intrs - xsks[i]->drv_stats.prev_intrs) *
+			 1000000000. / dt;
+
+		printf("\n%-18s %-14s %-14s\n", "", "intrs/s", "count");
+		printf(fmt, "irqs", intrs_ps, xsks[i]->drv_stats.intrs);
+
+		xsks[i]->drv_stats.prev_intrs = xsks[i]->drv_stats.intrs;
+	}
+}
+
 static void dump_stats(void)
 {
 	unsigned long now = get_nsecs();
@@ -327,6 +431,8 @@ static void dump_stats(void)
 
 	if (opt_app_stats)
 		dump_app_stats(dt);
+	if (irq_no)
+		dump_driver_stats(dt);
 }
 
 static bool is_benchmark_done(void)
@@ -804,6 +910,7 @@ static struct option long_options[] = {
 	{"extra-stats", no_argument, 0, 'x'},
 	{"quiet", no_argument, 0, 'Q'},
 	{"app-stats", no_argument, 0, 'a'},
+	{"irq-string", no_argument, 0, 'I'},
 	{0, 0, 0, 0}
 };
 
@@ -841,6 +948,7 @@ static void usage(const char *prog)
 		"  -x, --extra-stats	Display extra statistics.\n"
 		"  -Q, --quiet          Do not display any stats.\n"
 		"  -a, --app-stats	Display application (syscall) statistics.\n"
+		"  -I, --irq-string	Display driver interrupt statistics for interface associated with irq-string.\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
 		opt_batch_size, MIN_PKT_SIZE, MIN_PKT_SIZE,
@@ -856,7 +964,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:xQa",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:xQaI:",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -945,6 +1053,16 @@ static void parse_command_line(int argc, char **argv)
 			break;
 		case 'a':
 			opt_app_stats = 1;
+			break;
+		case 'I':
+			opt_irq_str = optarg;
+			if (get_interrupt_number())
+				irqs_at_init = get_irqs();
+			if (irqs_at_init < 0) {
+				fprintf(stderr, "ERROR: Failed to get irqs for %s\n", opt_irq_str);
+				usage(basename(argv[0]));
+			}
+
 			break;
 		default:
 			usage(basename(argv[0]));
-- 
2.17.1

