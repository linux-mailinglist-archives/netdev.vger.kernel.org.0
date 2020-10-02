Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A00281495
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388014AbgJBOCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:02:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:44226 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgJBOCK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:02:10 -0400
IronPort-SDR: +xo4B/e8m8ufLrPbPgqf1ba8dH/rh/Y9PU9KQrTKGQKir47TinnUUDixsFwxi3lZIZANVsM5As
 /CtnPKZZFcyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="181119396"
X-IronPort-AV: E=Sophos;i="5.77,327,1596524400"; 
   d="scan'208";a="181119396"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 07:01:59 -0700
IronPort-SDR: JZDJNqwMS39FcTCvGZBBVrS/e194UQkAkYsK6SPzKuSRbKPcCQOISpr1xG5DC/5r06rcMQMJw/
 x/bAgZG+D6PQ==
X-IronPort-AV: E=Sophos;i="5.77,327,1596524400"; 
   d="scan'208";a="508762613"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 07:01:57 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next 2/3] samples: bpf: count syscalls in xdpsock
Date:   Fri,  2 Oct 2020 13:36:11 +0000
Message-Id: <20201002133612.31536-2-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002133612.31536-1-ciara.loftus@intel.com>
References: <20201002133612.31536-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Categorise and record syscalls issued in the xdpsock sample app. The
categories recorded are:

  rx_empty_polls:    polls when the rx ring is empty
  fill_fail_polls:   polls when failed to get addr from fill ring
  copy_tx_sendtos:   sendtos issued for tx when copy mode enabled
  tx_wakeup_sendtos: sendtos issued when tx ring needs waking up
  opt_polls:         polls issued since the '-p' flag is set

Print the stats using '-a' on the xdpsock command line.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 samples/bpf/xdpsock_user.c | 113 +++++++++++++++++++++++++++++++++----
 1 file changed, 103 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 4c5022e6479e..ff119ede4ab1 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -79,6 +79,7 @@ static u16 opt_pkt_size = MIN_PKT_SIZE;
 static u32 opt_pkt_fill_pattern = 0x12345678;
 static bool opt_extra_stats;
 static bool opt_quiet;
+static bool opt_app_stats;
 static int opt_poll;
 static int opt_interval = 1;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
@@ -110,6 +111,19 @@ struct xsk_ring_stats {
 	unsigned long prev_tx_empty_npkts;
 };
 
+struct xsk_app_stats {
+	unsigned long rx_empty_polls;
+	unsigned long fill_fail_polls;
+	unsigned long copy_tx_sendtos;
+	unsigned long tx_wakeup_sendtos;
+	unsigned long opt_polls;
+	unsigned long prev_rx_empty_polls;
+	unsigned long prev_fill_fail_polls;
+	unsigned long prev_copy_tx_sendtos;
+	unsigned long prev_tx_wakeup_sendtos;
+	unsigned long prev_opt_polls;
+};
+
 struct xsk_umem_info {
 	struct xsk_ring_prod fq;
 	struct xsk_ring_cons cq;
@@ -123,6 +137,7 @@ struct xsk_socket_info {
 	struct xsk_umem_info *umem;
 	struct xsk_socket *xsk;
 	struct xsk_ring_stats ring_stats;
+	struct xsk_app_stats app_stats;
 	u32 outstanding_tx;
 };
 
@@ -189,6 +204,45 @@ static int xsk_get_xdp_stats(int fd, struct xsk_socket_info *xsk)
 	return -EINVAL;
 }
 
+static void dump_app_stats(long dt)
+{
+	int i;
+
+	for (i = 0; i < num_socks && xsks[i]; i++) {
+		char *fmt = "%-18s %'-14.0f %'-14lu\n";
+		double rx_empty_polls_ps, fill_fail_polls_ps, copy_tx_sendtos_ps,
+				tx_wakeup_sendtos_ps, opt_polls_ps;
+
+		rx_empty_polls_ps = (xsks[i]->app_stats.rx_empty_polls -
+					xsks[i]->app_stats.prev_rx_empty_polls) * 1000000000. / dt;
+		fill_fail_polls_ps = (xsks[i]->app_stats.fill_fail_polls -
+					xsks[i]->app_stats.prev_fill_fail_polls) * 1000000000. / dt;
+		copy_tx_sendtos_ps = (xsks[i]->app_stats.copy_tx_sendtos -
+					xsks[i]->app_stats.prev_copy_tx_sendtos) * 1000000000. / dt;
+		tx_wakeup_sendtos_ps = (xsks[i]->app_stats.tx_wakeup_sendtos -
+					xsks[i]->app_stats.prev_tx_wakeup_sendtos)
+										* 1000000000. / dt;
+		opt_polls_ps = (xsks[i]->app_stats.opt_polls -
+					xsks[i]->app_stats.prev_opt_polls) * 1000000000. / dt;
+
+		printf("\n%-18s %-14s %-14s\n", "", "calls/s", "count");
+		printf(fmt, "rx empty polls", rx_empty_polls_ps, xsks[i]->app_stats.rx_empty_polls);
+		printf(fmt, "fill fail polls", fill_fail_polls_ps,
+							xsks[i]->app_stats.fill_fail_polls);
+		printf(fmt, "copy tx sendtos", copy_tx_sendtos_ps,
+							xsks[i]->app_stats.copy_tx_sendtos);
+		printf(fmt, "tx wakeup sendtos", tx_wakeup_sendtos_ps,
+							xsks[i]->app_stats.tx_wakeup_sendtos);
+		printf(fmt, "opt polls", opt_polls_ps, xsks[i]->app_stats.opt_polls);
+
+		xsks[i]->app_stats.prev_rx_empty_polls = xsks[i]->app_stats.rx_empty_polls;
+		xsks[i]->app_stats.prev_fill_fail_polls = xsks[i]->app_stats.fill_fail_polls;
+		xsks[i]->app_stats.prev_copy_tx_sendtos = xsks[i]->app_stats.copy_tx_sendtos;
+		xsks[i]->app_stats.prev_tx_wakeup_sendtos = xsks[i]->app_stats.tx_wakeup_sendtos;
+		xsks[i]->app_stats.prev_opt_polls = xsks[i]->app_stats.opt_polls;
+	}
+}
+
 static void dump_stats(void)
 {
 	unsigned long now = get_nsecs();
@@ -198,7 +252,7 @@ static void dump_stats(void)
 	prev_time = now;
 
 	for (i = 0; i < num_socks && xsks[i]; i++) {
-		char *fmt = "%-15s %'-11.0f %'-11lu\n";
+		char *fmt = "%-18s %'-14.0f %'-14lu\n";
 		double rx_pps, tx_pps, dropped_pps, rx_invalid_pps, full_pps, fill_empty_pps,
 			tx_invalid_pps, tx_empty_pps;
 
@@ -211,7 +265,7 @@ static void dump_stats(void)
 		print_benchmark(false);
 		printf("\n");
 
-		printf("%-15s %-11s %-11s %-11.2f\n", "", "pps", "pkts",
+		printf("%-18s %-14s %-14s %-14.2f\n", "", "pps", "pkts",
 		       dt / 1000000000.);
 		printf(fmt, "rx", rx_pps, xsks[i]->ring_stats.rx_npkts);
 		printf(fmt, "tx", tx_pps, xsks[i]->ring_stats.tx_npkts);
@@ -270,6 +324,9 @@ static void dump_stats(void)
 			}
 		}
 	}
+
+	if (opt_app_stats)
+		dump_app_stats(dt);
 }
 
 static bool is_benchmark_done(void)
@@ -708,6 +765,17 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem,
 	if (ret)
 		exit_with_error(-ret);
 
+	xsk->app_stats.rx_empty_polls = 0;
+	xsk->app_stats.fill_fail_polls = 0;
+	xsk->app_stats.copy_tx_sendtos = 0;
+	xsk->app_stats.tx_wakeup_sendtos = 0;
+	xsk->app_stats.opt_polls = 0;
+	xsk->app_stats.prev_rx_empty_polls = 0;
+	xsk->app_stats.prev_fill_fail_polls = 0;
+	xsk->app_stats.prev_copy_tx_sendtos = 0;
+	xsk->app_stats.prev_tx_wakeup_sendtos = 0;
+	xsk->app_stats.prev_opt_polls = 0;
+
 	return xsk;
 }
 
@@ -735,6 +803,7 @@ static struct option long_options[] = {
 	{"tx-pkt-pattern", required_argument, 0, 'P'},
 	{"extra-stats", no_argument, 0, 'x'},
 	{"quiet", no_argument, 0, 'Q'},
+	{"app-stats", no_argument, 0, 'a'},
 	{0, 0, 0, 0}
 };
 
@@ -771,6 +840,7 @@ static void usage(const char *prog)
 		"  -P, --tx-pkt-pattern=nPacket fill pattern. Default: 0x%x\n"
 		"  -x, --extra-stats	Display extra statistics.\n"
 		"  -Q, --quiet          Do not display any stats.\n"
+		"  -a, --app-stats	Display application (syscall) statistics.\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
 		opt_batch_size, MIN_PKT_SIZE, MIN_PKT_SIZE,
@@ -786,7 +856,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:xQ",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:xQa",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -873,6 +943,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'Q':
 			opt_quiet = 1;
 			break;
+		case 'a':
+			opt_app_stats = 1;
+			break;
 		default:
 			usage(basename(argv[0]));
 		}
@@ -923,8 +996,10 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 	 * is driven by the NAPI loop. So as an optimization, we do not have to call
 	 * sendto() all the time in zero-copy mode for l2fwd.
 	 */
-	if (opt_xdp_bind_flags & XDP_COPY)
+	if (opt_xdp_bind_flags & XDP_COPY) {
+		xsk->app_stats.copy_tx_sendtos++;
 		kick_tx(xsk);
+	}
 
 	ndescs = (xsk->outstanding_tx > opt_batch_size) ? opt_batch_size :
 		xsk->outstanding_tx;
@@ -939,8 +1014,10 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 		while (ret != rcvd) {
 			if (ret < 0)
 				exit_with_error(-ret);
-			if (xsk_ring_prod__needs_wakeup(&umem->fq))
+			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
+				xsk->app_stats.fill_fail_polls++;
 				ret = poll(fds, num_socks, opt_timeout);
+			}
 			ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 		}
 
@@ -964,8 +1041,10 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk,
 	if (!xsk->outstanding_tx)
 		return;
 
-	if (!opt_need_wakeup || xsk_ring_prod__needs_wakeup(&xsk->tx))
+	if (!opt_need_wakeup || xsk_ring_prod__needs_wakeup(&xsk->tx)) {
+		xsk->app_stats.tx_wakeup_sendtos++;
 		kick_tx(xsk);
+	}
 
 	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, batch_size, &idx);
 	if (rcvd > 0) {
@@ -983,8 +1062,10 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 
 	rcvd = xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
 	if (!rcvd) {
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
+		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+			xsk->app_stats.rx_empty_polls++;
 			ret = poll(fds, num_socks, opt_timeout);
+		}
 		return;
 	}
 
@@ -992,8 +1073,10 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
+		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+			xsk->app_stats.fill_fail_polls++;
 			ret = poll(fds, num_socks, opt_timeout);
+		}
 		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
 	}
 
@@ -1026,6 +1109,8 @@ static void rx_drop_all(void)
 
 	for (;;) {
 		if (opt_poll) {
+			for (i = 0; i < num_socks; i++)
+				xsks[i]->app_stats.opt_polls++;
 			ret = poll(fds, num_socks, opt_timeout);
 			if (ret <= 0)
 				continue;
@@ -1106,6 +1191,8 @@ static void tx_only_all(void)
 		int batch_size = get_batch_size(pkt_cnt);
 
 		if (opt_poll) {
+			for (i = 0; i < num_socks; i++)
+				xsks[i]->app_stats.opt_polls++;
 			ret = poll(fds, num_socks, opt_timeout);
 			if (ret <= 0)
 				continue;
@@ -1137,8 +1224,10 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 
 	rcvd = xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
 	if (!rcvd) {
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
+		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+			xsk->app_stats.rx_empty_polls++;
 			ret = poll(fds, num_socks, opt_timeout);
+		}
 		return;
 	}
 
@@ -1147,8 +1236,10 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 		if (ret < 0)
 			exit_with_error(-ret);
 		complete_tx_l2fwd(xsk, fds);
-		if (xsk_ring_prod__needs_wakeup(&xsk->tx))
+		if (xsk_ring_prod__needs_wakeup(&xsk->tx)) {
+			xsk->app_stats.tx_wakeup_sendtos++;
 			kick_tx(xsk);
+		}
 		ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
 	}
 
@@ -1186,6 +1277,8 @@ static void l2fwd_all(void)
 
 	for (;;) {
 		if (opt_poll) {
+			for (i = 0; i < num_socks; i++)
+				xsks[i]->app_stats.opt_polls++;
 			ret = poll(fds, num_socks, opt_timeout);
 			if (ret <= 0)
 				continue;
-- 
2.17.1

