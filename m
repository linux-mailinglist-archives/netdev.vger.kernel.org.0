Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EACF127796
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 09:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfLTIzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 03:55:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:34861 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbfLTIzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 03:55:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 00:55:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,335,1571727600"; 
   d="scan'208";a="218434385"
Received: from unknown (HELO localhost.localdomain) ([10.190.210.212])
  by orsmga006.jf.intel.com with ESMTP; 20 Dec 2019 00:55:13 -0800
Received: from localhost.localdomain (localhost [127.0.0.1])
        by localhost.localdomain (8.15.2/8.15.2/Debian-10) with ESMTPS id xBK8tYpS005048
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 20 Dec 2019 14:25:34 +0530
Received: (from root@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id xBK8tYdT005047;
        Fri, 20 Dec 2019 14:25:34 +0530
From:   Jay Jayatheerthan <jay.jayatheerthan@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org,
        Jay Jayatheerthan <jay.jayatheerthan@intel.com>
Subject: [PATCH bpf-next 4/6] samples/bpf: xdpsock: Add option to specify number of packets to send
Date:   Fri, 20 Dec 2019 14:25:28 +0530
Message-Id: <20191220085530.4980-5-jay.jayatheerthan@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
References: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use '-C' or '--tx-pkt-count' to specify number of packets to send.
If it is not specified, the application sends packets forever. If packet
count is not a multiple of batch size, last batch sent is less than the
batch size.

Signed-off-by: Jay Jayatheerthan <jay.jayatheerthan@intel.com>
---
 samples/bpf/xdpsock_user.c | 73 ++++++++++++++++++++++++++++++--------
 1 file changed, 59 insertions(+), 14 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 1ba3e7142f39..f96ce3055d46 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -68,6 +68,7 @@ static unsigned long opt_duration;
 static unsigned long start_time;
 static bool benchmark_done;
 static u32 opt_batch_size = 64;
+static int opt_pkt_count;
 static int opt_poll;
 static int opt_interval = 1;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
@@ -392,6 +393,7 @@ static struct option long_options[] = {
 	{"force", no_argument, 0, 'F'},
 	{"duration", required_argument, 0, 'd'},
 	{"batch-size", required_argument, 0, 'b'},
+	{"tx-pkt-count", required_argument, 0, 'C'},
 	{0, 0, 0, 0}
 };
 
@@ -420,6 +422,8 @@ static void usage(const char *prog)
 		"			Default: forever.\n"
 		"  -b, --batch-size=n	Batch size for sending or receiving\n"
 		"			packets. Default: %d\n"
+		"  -C, --tx-pkt-count=n	Number of packets to send.\n"
+		"			Default: Continuous packets.\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
 		opt_batch_size);
@@ -433,7 +437,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -498,6 +502,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'b':
 			opt_batch_size = atoi(optarg);
 			break;
+		case 'C':
+			opt_pkt_count = atoi(optarg);
+			break;
 		default:
 			usage(basename(argv[0]));
 		}
@@ -574,7 +581,8 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 	}
 }
 
-static inline void complete_tx_only(struct xsk_socket_info *xsk)
+static inline void complete_tx_only(struct xsk_socket_info *xsk,
+				    int batch_size)
 {
 	unsigned int rcvd;
 	u32 idx;
@@ -585,7 +593,7 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk)
 	if (!opt_need_wakeup || xsk_ring_prod__needs_wakeup(&xsk->tx))
 		kick_tx(xsk);
 
-	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, opt_batch_size, &idx);
+	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, batch_size, &idx);
 	if (rcvd > 0) {
 		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
 		xsk->outstanding_tx -= rcvd;
@@ -657,34 +665,62 @@ static void rx_drop_all(void)
 	}
 }
 
-static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb)
+static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb, int batch_size)
 {
 	u32 idx;
 	unsigned int i;
 
-	while (xsk_ring_prod__reserve(&xsk->tx, opt_batch_size, &idx) <
-				      opt_batch_size) {
-		complete_tx_only(xsk);
+	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) <
+				      batch_size) {
+		complete_tx_only(xsk, batch_size);
 	}
 
-	for (i = 0; i < opt_batch_size; i++) {
+	for (i = 0; i < batch_size; i++) {
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx,
 								  idx + i);
 		tx_desc->addr = (frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
 		tx_desc->len = sizeof(pkt_data) - 1;
 	}
 
-	xsk_ring_prod__submit(&xsk->tx, opt_batch_size);
-	xsk->outstanding_tx += opt_batch_size;
-	frame_nb += opt_batch_size;
+	xsk_ring_prod__submit(&xsk->tx, batch_size);
+	xsk->outstanding_tx += batch_size;
+	frame_nb += batch_size;
 	frame_nb %= NUM_FRAMES;
-	complete_tx_only(xsk);
+	complete_tx_only(xsk, batch_size);
+}
+
+static inline int get_batch_size(int pkt_cnt)
+{
+	if (!opt_pkt_count)
+		return opt_batch_size;
+
+	if (pkt_cnt + opt_batch_size <= opt_pkt_count)
+		return opt_batch_size;
+
+	return opt_pkt_count - pkt_cnt;
+}
+
+static void complete_tx_only_all(void)
+{
+	bool pending;
+	int i;
+
+	do {
+		pending = false;
+		for (i = 0; i < num_socks; i++) {
+			if (xsks[i]->outstanding_tx) {
+				complete_tx_only(xsks[i], opt_batch_size);
+				pending = !!xsks[i]->outstanding_tx;
+			}
+		}
+	} while (pending);
 }
 
 static void tx_only_all(void)
 {
 	struct pollfd fds[MAX_SOCKS] = {};
 	u32 frame_nb[MAX_SOCKS] = {};
+	int pkt_cnt = 0;
 	int i, ret;
 
 	for (i = 0; i < num_socks; i++) {
@@ -692,7 +728,9 @@ static void tx_only_all(void)
 		fds[0].events = POLLOUT;
 	}
 
-	for (;;) {
+	while ((opt_pkt_count && pkt_cnt < opt_pkt_count) || !opt_pkt_count) {
+		int batch_size = get_batch_size(pkt_cnt);
+
 		if (opt_poll) {
 			ret = poll(fds, num_socks, opt_timeout);
 			if (ret <= 0)
@@ -703,11 +741,16 @@ static void tx_only_all(void)
 		}
 
 		for (i = 0; i < num_socks; i++)
-			tx_only(xsks[i], frame_nb[i]);
+			tx_only(xsks[i], frame_nb[i], batch_size);
+
+		pkt_cnt += batch_size;
 
 		if (benchmark_done)
 			break;
 	}
+
+	if (opt_pkt_count)
+		complete_tx_only_all();
 }
 
 static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
@@ -900,6 +943,8 @@ int main(int argc, char **argv)
 	else
 		l2fwd_all();
 
+	benchmark_done = true;
+
 	pthread_join(pt, NULL);
 
 	xdpsock_cleanup();
-- 
2.17.1

