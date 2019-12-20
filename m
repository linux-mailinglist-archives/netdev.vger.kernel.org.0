Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADF0127792
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 09:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfLTIzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 03:55:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:34862 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbfLTIzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 03:55:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 00:55:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,335,1571727600"; 
   d="scan'208";a="218434381"
Received: from unknown (HELO localhost.localdomain) ([10.190.210.212])
  by orsmga006.jf.intel.com with ESMTP; 20 Dec 2019 00:55:12 -0800
Received: from localhost.localdomain (localhost [127.0.0.1])
        by localhost.localdomain (8.15.2/8.15.2/Debian-10) with ESMTPS id xBK8tYRi005044
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 20 Dec 2019 14:25:34 +0530
Received: (from root@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id xBK8tYir005043;
        Fri, 20 Dec 2019 14:25:34 +0530
From:   Jay Jayatheerthan <jay.jayatheerthan@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org,
        Jay Jayatheerthan <jay.jayatheerthan@intel.com>
Subject: [PATCH bpf-next 3/6] samples/bpf: xdpsock: Add option to specify batch size
Date:   Fri, 20 Dec 2019 14:25:27 +0530
Message-Id: <20191220085530.4980-4-jay.jayatheerthan@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
References: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New option to specify batch size for tx, rx and l2fwd has been added. This
allows fine tuning to maximize performance. It is specified using '-b' or
'--batch_size' options. When not specified default is 64.

Signed-off-by: Jay Jayatheerthan <jay.jayatheerthan@intel.com>
---
 samples/bpf/xdpsock_user.c | 52 +++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 7febc3d519a1..1ba3e7142f39 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -45,7 +45,6 @@
 #endif
 
 #define NUM_FRAMES (4 * 1024)
-#define BATCH_SIZE 64
 
 #define DEBUG_HEXDUMP 0
 
@@ -68,6 +67,7 @@ static int opt_queue;
 static unsigned long opt_duration;
 static unsigned long start_time;
 static bool benchmark_done;
+static u32 opt_batch_size = 64;
 static int opt_poll;
 static int opt_interval = 1;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
@@ -237,7 +237,6 @@ static void __exit_with_error(int error, const char *file, const char *func,
 
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, \
 						 __LINE__)
-
 static const char pkt_data[] =
 	"\x3c\xfd\xfe\x9e\x7f\x71\xec\xb1\xd7\x98\x3a\xc0\x08\x00\x45\x00"
 	"\x00\x2e\x00\x00\x00\x00\x40\x11\x88\x97\x05\x08\x07\x08\xc8\x14"
@@ -291,11 +290,10 @@ static void hex_dump(void *pkt, size_t length, u64 addr)
 	printf("\n");
 }
 
-static size_t gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
+static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
 {
 	memcpy(xsk_umem__get_data(umem->buffer, addr), pkt_data,
 	       sizeof(pkt_data) - 1);
-	return sizeof(pkt_data) - 1;
 }
 
 static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
@@ -393,6 +391,7 @@ static struct option long_options[] = {
 	{"shared-umem", no_argument, 0, 'M'},
 	{"force", no_argument, 0, 'F'},
 	{"duration", required_argument, 0, 'd'},
+	{"batch-size", required_argument, 0, 'b'},
 	{0, 0, 0, 0}
 };
 
@@ -419,8 +418,11 @@ static void usage(const char *prog)
 		"  -F, --force		Force loading the XDP prog\n"
 		"  -d, --duration=n	Duration in secs to run command.\n"
 		"			Default: forever.\n"
+		"  -b, --batch-size=n	Batch size for sending or receiving\n"
+		"			packets. Default: %d\n"
 		"\n";
-	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE);
+	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
+		opt_batch_size);
 	exit(EXIT_FAILURE);
 }
 
@@ -431,7 +433,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:psSNn:czf:muMd:",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -493,6 +495,9 @@ static void parse_command_line(int argc, char **argv)
 			opt_duration = atoi(optarg);
 			opt_duration *= 1000000000;
 			break;
+		case 'b':
+			opt_batch_size = atoi(optarg);
+			break;
 		default:
 			usage(basename(argv[0]));
 		}
@@ -540,7 +545,7 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 	if (!opt_need_wakeup || xsk_ring_prod__needs_wakeup(&xsk->tx))
 		kick_tx(xsk);
 
-	ndescs = (xsk->outstanding_tx > BATCH_SIZE) ? BATCH_SIZE :
+	ndescs = (xsk->outstanding_tx > opt_batch_size) ? opt_batch_size :
 		xsk->outstanding_tx;
 
 	/* re-add completed Tx buffers */
@@ -580,7 +585,7 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk)
 	if (!opt_need_wakeup || xsk_ring_prod__needs_wakeup(&xsk->tx))
 		kick_tx(xsk);
 
-	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, BATCH_SIZE, &idx);
+	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, opt_batch_size, &idx);
 	if (rcvd > 0) {
 		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
 		xsk->outstanding_tx -= rcvd;
@@ -594,7 +599,7 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 	u32 idx_rx = 0, idx_fq = 0;
 	int ret;
 
-	rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
+	rcvd = xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
 	if (!rcvd) {
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
 			ret = poll(fds, num_socks, opt_timeout);
@@ -655,23 +660,24 @@ static void rx_drop_all(void)
 static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb)
 {
 	u32 idx;
+	unsigned int i;
 
-	if (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) == BATCH_SIZE) {
-		unsigned int i;
-
-		for (i = 0; i < BATCH_SIZE; i++) {
-			xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->addr	=
-				(frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
-			xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->len =
-				sizeof(pkt_data) - 1;
-		}
+	while (xsk_ring_prod__reserve(&xsk->tx, opt_batch_size, &idx) <
+				      opt_batch_size) {
+		complete_tx_only(xsk);
+	}
 
-		xsk_ring_prod__submit(&xsk->tx, BATCH_SIZE);
-		xsk->outstanding_tx += BATCH_SIZE;
-		frame_nb += BATCH_SIZE;
-		frame_nb %= NUM_FRAMES;
+	for (i = 0; i < opt_batch_size; i++) {
+		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx,
+								  idx + i);
+		tx_desc->addr = (frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
+		tx_desc->len = sizeof(pkt_data) - 1;
 	}
 
+	xsk_ring_prod__submit(&xsk->tx, opt_batch_size);
+	xsk->outstanding_tx += opt_batch_size;
+	frame_nb += opt_batch_size;
+	frame_nb %= NUM_FRAMES;
 	complete_tx_only(xsk);
 }
 
@@ -712,7 +718,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 
 	complete_tx_l2fwd(xsk, fds);
 
-	rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
+	rcvd = xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
 	if (!rcvd) {
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
 			ret = poll(fds, num_socks, opt_timeout);
-- 
2.17.1

