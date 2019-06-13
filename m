Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412EE4443C
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731776AbfFMQfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:35:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:23443 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730708AbfFMHiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 03:38:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 00:38:10 -0700
X-ExtLoop1: 1
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO VM.ger.corp.intel.com) ([10.103.211.41])
  by orsmga004.jf.intel.com with ESMTP; 13 Jun 2019 00:38:05 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, kiran.patil@intel.com,
        axboe@kernel.dk, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 6/6] samples/bpf: add use of need_sleep flag in xdpsock
Date:   Thu, 13 Jun 2019 09:37:30 +0200
Message-Id: <1560411450-29121-7-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560411450-29121-1-git-send-email-magnus.karlsson@intel.com>
References: <1560411450-29121-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds using the need_sleep flag to the xdpsock sample
application. It is turned on by default as we think it is a feature
that seems to always produce a performance benefit, if the application
has been written taking advantage of it. It can be turned off in the
sample app by using the '-m' command line option.

The txpush and l2fwd sub applications have also been updated to
support poll() with multiple sockets.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 samples/bpf/xdpsock_user.c | 191 ++++++++++++++++++++++++++++-----------------
 1 file changed, 119 insertions(+), 72 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index d08ee1a..4b760b8 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -67,7 +67,9 @@ static int opt_ifindex;
 static int opt_queue;
 static int opt_poll;
 static int opt_interval = 1;
-static u32 opt_xdp_bind_flags;
+static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
+static int opt_timeout = 1000;
+static bool opt_might_sleep = true;
 static __u32 prog_id;
 
 struct xsk_umem_info {
@@ -346,6 +348,7 @@ static struct option long_options[] = {
 	{"interval", required_argument, 0, 'n'},
 	{"zero-copy", no_argument, 0, 'z'},
 	{"copy", no_argument, 0, 'c'},
+	{"no-might-sleep", no_argument, 0, 'm'},
 	{0, 0, 0, 0}
 };
 
@@ -365,6 +368,7 @@ static void usage(const char *prog)
 		"  -n, --interval=n	Specify statistics update interval (default 1 sec).\n"
 		"  -z, --zero-copy      Force zero-copy mode.\n"
 		"  -c, --copy           Force copy mode.\n"
+		"  -m, --no-might-sleep Turn off use of driver might sleep flag.\n"
 		"\n";
 	fprintf(stderr, str, prog);
 	exit(EXIT_FAILURE);
@@ -377,7 +381,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:psSNn:cz", long_options,
+		c = getopt_long(argc, argv, "Frtli:q:psSNn:czm", long_options,
 				&option_index);
 		if (c == -1)
 			break;
@@ -420,6 +424,10 @@ static void parse_command_line(int argc, char **argv)
 		case 'F':
 			opt_xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
+		case 'm':
+			opt_might_sleep = false;
+			opt_xdp_bind_flags &= ~XDP_USE_NEED_WAKEUP;
+			break;
 		default:
 			usage(basename(argv[0]));
 		}
@@ -444,7 +452,8 @@ static void kick_tx(struct xsk_socket_info *xsk)
 	exit_with_error(errno);
 }
 
-static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
+static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
+				     struct pollfd *fds)
 {
 	u32 idx_cq = 0, idx_fq = 0;
 	unsigned int rcvd;
@@ -453,7 +462,9 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
 	if (!xsk->outstanding_tx)
 		return;
 
-	kick_tx(xsk);
+	if (!opt_might_sleep || xsk_ring_prod__needs_wakeup(&xsk->tx))
+		kick_tx(xsk);
+
 	ndescs = (xsk->outstanding_tx > BATCH_SIZE) ? BATCH_SIZE :
 		xsk->outstanding_tx;
 
@@ -467,6 +478,8 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
 		while (ret != rcvd) {
 			if (ret < 0)
 				exit_with_error(-ret);
+			if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
+				ret = poll(fds, num_socks, opt_timeout);
 			ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
 						     &idx_fq);
 		}
@@ -490,7 +503,8 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk)
 	if (!xsk->outstanding_tx)
 		return;
 
-	kick_tx(xsk);
+	if (!opt_might_sleep || xsk_ring_prod__needs_wakeup(&xsk->tx))
+		kick_tx(xsk);
 
 	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, BATCH_SIZE, &idx);
 	if (rcvd > 0) {
@@ -500,20 +514,25 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk)
 	}
 }
 
-static void rx_drop(struct xsk_socket_info *xsk)
+static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 {
 	unsigned int rcvd, i;
 	u32 idx_rx = 0, idx_fq = 0;
 	int ret;
 
 	rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
-	if (!rcvd)
+	if (!rcvd) {
+		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
+			ret = poll(fds, num_socks, opt_timeout);
 		return;
+	}
 
 	ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
+		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
+			ret = poll(fds, num_socks, opt_timeout);
 		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
 	}
 
@@ -534,42 +553,65 @@ static void rx_drop(struct xsk_socket_info *xsk)
 static void rx_drop_all(void)
 {
 	struct pollfd fds[MAX_SOCKS + 1];
-	int i, ret, timeout, nfds = 1;
+	int i, ret;
 
 	memset(fds, 0, sizeof(fds));
 
 	for (i = 0; i < num_socks; i++) {
 		fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
 		fds[i].events = POLLIN;
-		timeout = 1000; /* 1sn */
 	}
 
 	for (;;) {
 		if (opt_poll) {
-			ret = poll(fds, nfds, timeout);
+			ret = poll(fds, num_socks, opt_timeout);
 			if (ret <= 0)
 				continue;
 		}
 
 		for (i = 0; i < num_socks; i++)
-			rx_drop(xsks[i]);
+			rx_drop(xsks[i], fds);
+	}
+}
+
+static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb)
+{
+	u32 idx;
+
+	if (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) == BATCH_SIZE) {
+		unsigned int i;
+
+		for (i = 0; i < BATCH_SIZE; i++) {
+			xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->addr	=
+				(frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
+			xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->len =
+				sizeof(pkt_data) - 1;
+		}
+
+		xsk_ring_prod__submit(&xsk->tx, BATCH_SIZE);
+		xsk->outstanding_tx += BATCH_SIZE;
+		frame_nb += BATCH_SIZE;
+		frame_nb %= NUM_FRAMES;
 	}
+
+	complete_tx_only(xsk);
 }
 
-static void tx_only(struct xsk_socket_info *xsk)
+static void tx_only_all(void)
 {
-	int timeout, ret, nfds = 1;
-	struct pollfd fds[nfds + 1];
-	u32 idx, frame_nb = 0;
+	struct pollfd fds[MAX_SOCKS];
+	u32 frame_nb[MAX_SOCKS] = {};
+	int i, ret;
 
 	memset(fds, 0, sizeof(fds));
-	fds[0].fd = xsk_socket__fd(xsk->xsk);
-	fds[0].events = POLLOUT;
-	timeout = 1000; /* 1sn */
+	for (i = 0; i < num_socks; i++) {
+		fds[0].fd = xsk_socket__fd(xsks[i]->xsk);
+		fds[0].events = POLLOUT;
+	}
 
 	for (;;) {
 		if (opt_poll) {
-			ret = poll(fds, nfds, timeout);
+			ret = poll(fds, num_socks, opt_timeout);
 			if (ret <= 0)
 				continue;
 
@@ -577,70 +619,75 @@ static void tx_only(struct xsk_socket_info *xsk)
 				continue;
 		}
 
-		if (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) ==
-		    BATCH_SIZE) {
-			unsigned int i;
-
-			for (i = 0; i < BATCH_SIZE; i++) {
-				xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->addr
-					= (frame_nb + i) <<
-					XSK_UMEM__DEFAULT_FRAME_SHIFT;
-				xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->len =
-					sizeof(pkt_data) - 1;
-			}
-
-			xsk_ring_prod__submit(&xsk->tx, BATCH_SIZE);
-			xsk->outstanding_tx += BATCH_SIZE;
-			frame_nb += BATCH_SIZE;
-			frame_nb %= NUM_FRAMES;
-		}
-
-		complete_tx_only(xsk);
+		for (i = 0; i < num_socks; i++)
+			tx_only(xsks[i], frame_nb[i]);
 	}
 }
 
-static void l2fwd(struct xsk_socket_info *xsk)
+static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 {
-	for (;;) {
-		unsigned int rcvd, i;
-		u32 idx_rx = 0, idx_tx = 0;
-		int ret;
+	unsigned int rcvd, i;
+	u32 idx_rx = 0, idx_tx = 0;
+	int ret;
 
-		for (;;) {
-			complete_tx_l2fwd(xsk);
+	complete_tx_l2fwd(xsk, fds);
 
-			rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
-						   &idx_rx);
-			if (rcvd > 0)
-				break;
-		}
+	rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
+	if (!rcvd) {
+		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
+			ret = poll(fds, num_socks, opt_timeout);
+		return;
+	}
 
+	ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
+	while (ret != rcvd) {
+		if (ret < 0)
+			exit_with_error(-ret);
+		if (xsk_ring_prod__needs_wakeup(&xsk->tx))
+			kick_tx(xsk);
 		ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
-		while (ret != rcvd) {
-			if (ret < 0)
-				exit_with_error(-ret);
-			ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
-		}
+	}
+
+	for (i = 0; i < rcvd; i++) {
+		u64 addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
+		u32 len = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++)->len;
+		char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
+
+		swap_mac_addresses(pkt);
 
-		for (i = 0; i < rcvd; i++) {
-			u64 addr = xsk_ring_cons__rx_desc(&xsk->rx,
-							  idx_rx)->addr;
-			u32 len = xsk_ring_cons__rx_desc(&xsk->rx,
-							 idx_rx++)->len;
-			char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
+		hex_dump(pkt, len, addr);
+		xsk_ring_prod__tx_desc(&xsk->tx, idx_tx)->addr = addr;
+		xsk_ring_prod__tx_desc(&xsk->tx, idx_tx++)->len = len;
+	}
 
-			swap_mac_addresses(pkt);
+	xsk_ring_prod__submit(&xsk->tx, rcvd);
+	xsk_ring_cons__release(&xsk->rx, rcvd);
 
-			hex_dump(pkt, len, addr);
-			xsk_ring_prod__tx_desc(&xsk->tx, idx_tx)->addr = addr;
-			xsk_ring_prod__tx_desc(&xsk->tx, idx_tx++)->len = len;
-		}
+	xsk->rx_npkts += rcvd;
+	xsk->outstanding_tx += rcvd;
+}
+
+static void l2fwd_all(void)
+{
+	struct pollfd fds[MAX_SOCKS];
+	int i, ret;
+
+	memset(fds, 0, sizeof(fds));
+
+	for (i = 0; i < num_socks; i++) {
+		fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
+		fds[i].events = POLLOUT | POLLIN;
+	}
 
-		xsk_ring_prod__submit(&xsk->tx, rcvd);
-		xsk_ring_cons__release(&xsk->rx, rcvd);
+	for (;;) {
+		if (opt_poll) {
+			ret = poll(fds, num_socks, opt_timeout);
+			if (ret <= 0)
+				continue;
+		}
 
-		xsk->rx_npkts += rcvd;
-		xsk->outstanding_tx += rcvd;
+		for (i = 0; i < num_socks; i++)
+			l2fwd(xsks[i], fds);
 	}
 }
 
@@ -693,9 +740,9 @@ int main(int argc, char **argv)
 	if (opt_bench == BENCH_RXDROP)
 		rx_drop_all();
 	else if (opt_bench == BENCH_TXONLY)
-		tx_only(xsks[0]);
+		tx_only_all();
 	else
-		l2fwd(xsks[0]);
+		l2fwd_all();
 
 	return 0;
 }
-- 
2.7.4

