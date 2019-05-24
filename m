Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B713D28F54
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 04:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387566AbfEXC7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 22:59:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:47306 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387408AbfEXC7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 22:59:19 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 19:59:17 -0700
X-ExtLoop1: 1
Received: from yexl-server.sh.intel.com (HELO localhost) ([10.67.110.206])
  by orsmga007.jf.intel.com with ESMTP; 23 May 2019 19:59:14 -0700
Date:   Fri, 24 May 2019 10:51:11 +0800
From:   Ye Xiaolong <xiaolong.ye@intel.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, brouer@redhat.com, bpf@vger.kernel.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        jakub.kicinski@netronome.com, qi.z.zhang@intel.com,
        maximmi@mellanox.com, sridhar.samudrala@intel.com,
        kevin.laatz@intel.com
Subject: Re: [RFC bpf-next 7/7] samples/bpf: add busy-poll support to xdpsock
 sample
Message-ID: <20190524025111.GB6321@intel.com>
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
 <1556786363-28743-8-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556786363-28743-8-git-send-email-magnus.karlsson@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Magnus

On 05/02, Magnus Karlsson wrote:
>This patch adds busy-poll support to the xdpsock sample
>application. It is enabled by the "-b" or the "--busy-poll" command
>line options.
>
>Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>---
> samples/bpf/xdpsock_user.c | 203 ++++++++++++++++++++++++++++-----------------
> 1 file changed, 125 insertions(+), 78 deletions(-)
>
>diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
>index d08ee1a..1272edf 100644
>--- a/samples/bpf/xdpsock_user.c
>+++ b/samples/bpf/xdpsock_user.c
>@@ -66,6 +66,7 @@ static const char *opt_if = "";
> static int opt_ifindex;
> static int opt_queue;
> static int opt_poll;
>+static int opt_busy_poll;
> static int opt_interval = 1;
> static u32 opt_xdp_bind_flags;
> static __u32 prog_id;
>@@ -119,8 +120,11 @@ static void print_benchmark(bool running)
> 	else
> 		printf("	");
> 
>-	if (opt_poll)
>+	if (opt_poll) {
>+		if (opt_busy_poll)
>+			printf("busy-");
> 		printf("poll() ");
>+	}
> 
> 	if (running) {
> 		printf("running...");
>@@ -306,7 +310,7 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
> 	xsk->umem = umem;
> 	cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
> 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
>-	cfg.libbpf_flags = 0;

Any purpose for removing this line, as cfg here is a local variable, cfg.libbpf_flags
can be random and may lead to xdpsock failure as `Invalid no_argument`.

Thanks,
Xiaolong

>+	cfg.busy_poll = (opt_busy_poll ? BATCH_SIZE : 0);
> 	cfg.xdp_flags = opt_xdp_flags;
> 	cfg.bind_flags = opt_xdp_bind_flags;
> 	ret = xsk_socket__create(&xsk->xsk, opt_if, opt_queue, umem->umem,
>@@ -319,17 +323,17 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
> 		exit_with_error(-ret);
> 
> 	ret = xsk_ring_prod__reserve(&xsk->umem->fq,
>-				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
>+				     1024,
> 				     &idx);
>-	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
>+	if (ret != 1024)
> 		exit_with_error(-ret);
> 	for (i = 0;
>-	     i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
>+	     i < 1024 *
> 		     XSK_UMEM__DEFAULT_FRAME_SIZE;
> 	     i += XSK_UMEM__DEFAULT_FRAME_SIZE)
> 		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx++) = i;
> 	xsk_ring_prod__submit(&xsk->umem->fq,
>-			      XSK_RING_PROD__DEFAULT_NUM_DESCS);
>+			      1024);
> 
> 	return xsk;
> }
>@@ -341,6 +345,7 @@ static struct option long_options[] = {
> 	{"interface", required_argument, 0, 'i'},
> 	{"queue", required_argument, 0, 'q'},
> 	{"poll", no_argument, 0, 'p'},
>+	{"busy-poll", no_argument, 0, 'b'},
> 	{"xdp-skb", no_argument, 0, 'S'},
> 	{"xdp-native", no_argument, 0, 'N'},
> 	{"interval", required_argument, 0, 'n'},
>@@ -360,6 +365,7 @@ static void usage(const char *prog)
> 		"  -i, --interface=n	Run on interface n\n"
> 		"  -q, --queue=n	Use queue n (default 0)\n"
> 		"  -p, --poll		Use poll syscall\n"
>+		"  -b, --busy-poll	Use poll syscall with busy poll\n"
> 		"  -S, --xdp-skb=n	Use XDP skb-mod\n"
> 		"  -N, --xdp-native=n	Enfore XDP native mode\n"
> 		"  -n, --interval=n	Specify statistics update interval (default 1 sec).\n"
>@@ -377,7 +383,7 @@ static void parse_command_line(int argc, char **argv)
> 	opterr = 0;
> 
> 	for (;;) {
>-		c = getopt_long(argc, argv, "Frtli:q:psSNn:cz", long_options,
>+		c = getopt_long(argc, argv, "Frtli:q:pbsSNn:cz", long_options,
> 				&option_index);
> 		if (c == -1)
> 			break;
>@@ -401,6 +407,10 @@ static void parse_command_line(int argc, char **argv)
> 		case 'p':
> 			opt_poll = 1;
> 			break;
>+		case 'b':
>+			opt_busy_poll = 1;
>+			opt_poll = 1;
>+			break;
> 		case 'S':
> 			opt_xdp_flags |= XDP_FLAGS_SKB_MODE;
> 			opt_xdp_bind_flags |= XDP_COPY;
>@@ -444,7 +454,8 @@ static void kick_tx(struct xsk_socket_info *xsk)
> 	exit_with_error(errno);
> }
> 
>-static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
>+static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
>+				     struct pollfd *fds)
> {
> 	u32 idx_cq = 0, idx_fq = 0;
> 	unsigned int rcvd;
>@@ -453,7 +464,8 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
> 	if (!xsk->outstanding_tx)
> 		return;
> 
>-	kick_tx(xsk);
>+	if (!opt_poll)
>+		kick_tx(xsk);
> 	ndescs = (xsk->outstanding_tx > BATCH_SIZE) ? BATCH_SIZE :
> 		xsk->outstanding_tx;
> 
>@@ -467,6 +479,8 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
> 		while (ret != rcvd) {
> 			if (ret < 0)
> 				exit_with_error(-ret);
>+			if (opt_busy_poll)
>+				ret = poll(fds, num_socks, 0);
> 			ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
> 						     &idx_fq);
> 		}
>@@ -490,7 +504,8 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk)
> 	if (!xsk->outstanding_tx)
> 		return;
> 
>-	kick_tx(xsk);
>+	if (!opt_busy_poll)
>+		kick_tx(xsk);
> 
> 	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, BATCH_SIZE, &idx);
> 	if (rcvd > 0) {
>@@ -500,10 +515,10 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk)
> 	}
> }
> 
>-static void rx_drop(struct xsk_socket_info *xsk)
>+static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
> {
>-	unsigned int rcvd, i;
> 	u32 idx_rx = 0, idx_fq = 0;
>+	unsigned int rcvd, i;
> 	int ret;
> 
> 	rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
>@@ -514,6 +529,8 @@ static void rx_drop(struct xsk_socket_info *xsk)
> 	while (ret != rcvd) {
> 		if (ret < 0)
> 			exit_with_error(-ret);
>+		if (opt_busy_poll)
>+			ret = poll(fds, num_socks, 0);
> 		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
> 	}
> 
>@@ -533,43 +550,68 @@ static void rx_drop(struct xsk_socket_info *xsk)
> 
> static void rx_drop_all(void)
> {
>-	struct pollfd fds[MAX_SOCKS + 1];
>-	int i, ret, timeout, nfds = 1;
>+	struct pollfd fds[MAX_SOCKS];
>+	int i, ret;
> 
> 	memset(fds, 0, sizeof(fds));
> 
> 	for (i = 0; i < num_socks; i++) {
> 		fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
> 		fds[i].events = POLLIN;
>-		timeout = 1000; /* 1sn */
> 	}
> 
> 	for (;;) {
> 		if (opt_poll) {
>-			ret = poll(fds, nfds, timeout);
>+			ret = poll(fds, num_socks, 0);
> 			if (ret <= 0)
> 				continue;
> 		}
> 
> 		for (i = 0; i < num_socks; i++)
>-			rx_drop(xsks[i]);
>+			rx_drop(xsks[i], fds);
>+	}
>+}
>+
>+static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb)
>+{
>+	u32 idx;
>+
>+	if (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) ==
>+	    BATCH_SIZE) {
>+		unsigned int i;
>+
>+		for (i = 0; i < BATCH_SIZE; i++) {
>+			xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->addr
>+				= (frame_nb + i) <<
>+				XSK_UMEM__DEFAULT_FRAME_SHIFT;
>+			xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->len =
>+				sizeof(pkt_data) - 1;
>+		}
>+
>+		xsk_ring_prod__submit(&xsk->tx, BATCH_SIZE);
>+		xsk->outstanding_tx += BATCH_SIZE;
>+		frame_nb += BATCH_SIZE;
>+		frame_nb %= NUM_FRAMES;
> 	}
>+
>+	complete_tx_only(xsk);
> }
> 
>-static void tx_only(struct xsk_socket_info *xsk)
>+static void tx_only_all(void)
> {
>-	int timeout, ret, nfds = 1;
>-	struct pollfd fds[nfds + 1];
>-	u32 idx, frame_nb = 0;
>+	struct pollfd fds[MAX_SOCKS];
>+	u32 frame_nb[MAX_SOCKS] = {};
>+	int i, ret;
> 
> 	memset(fds, 0, sizeof(fds));
>-	fds[0].fd = xsk_socket__fd(xsk->xsk);
>-	fds[0].events = POLLOUT;
>-	timeout = 1000; /* 1sn */
>+	for (i = 0; i < num_socks; i++) {
>+		fds[0].fd = xsk_socket__fd(xsks[i]->xsk);
>+		fds[0].events = POLLOUT;
>+	}
> 
> 	for (;;) {
> 		if (opt_poll) {
>-			ret = poll(fds, nfds, timeout);
>+			ret = poll(fds, num_socks, 0);
> 			if (ret <= 0)
> 				continue;
> 
>@@ -577,70 +619,75 @@ static void tx_only(struct xsk_socket_info *xsk)
> 				continue;
> 		}
> 
>-		if (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) ==
>-		    BATCH_SIZE) {
>-			unsigned int i;
>-
>-			for (i = 0; i < BATCH_SIZE; i++) {
>-				xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->addr
>-					= (frame_nb + i) <<
>-					XSK_UMEM__DEFAULT_FRAME_SHIFT;
>-				xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->len =
>-					sizeof(pkt_data) - 1;
>-			}
>-
>-			xsk_ring_prod__submit(&xsk->tx, BATCH_SIZE);
>-			xsk->outstanding_tx += BATCH_SIZE;
>-			frame_nb += BATCH_SIZE;
>-			frame_nb %= NUM_FRAMES;
>-		}
>-
>-		complete_tx_only(xsk);
>+		for (i = 0; i < num_socks; i++)
>+			tx_only(xsks[i], frame_nb[i]);
> 	}
> }
> 
>-static void l2fwd(struct xsk_socket_info *xsk)
>+static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
> {
>-	for (;;) {
>-		unsigned int rcvd, i;
>-		u32 idx_rx = 0, idx_tx = 0;
>-		int ret;
>+	unsigned int rcvd, i;
>+	u32 idx_rx = 0, idx_tx = 0;
>+	int ret;
> 
>-		for (;;) {
>-			complete_tx_l2fwd(xsk);
>+	complete_tx_l2fwd(xsk, fds);
> 
>-			rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
>-						   &idx_rx);
>-			if (rcvd > 0)
>-				break;
>-		}
>+	rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
>+				   &idx_rx);
>+	if (!rcvd)
>+		return;
> 
>+	ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
>+	while (ret != rcvd) {
>+		if (ret < 0)
>+			exit_with_error(-ret);
>+		if (opt_busy_poll)
>+			ret = poll(fds, num_socks, 0);
> 		ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
>-		while (ret != rcvd) {
>-			if (ret < 0)
>-				exit_with_error(-ret);
>-			ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
>-		}
>+	}
>+
>+	for (i = 0; i < rcvd; i++) {
>+		u64 addr = xsk_ring_cons__rx_desc(&xsk->rx,
>+						  idx_rx)->addr;
>+		u32 len = xsk_ring_cons__rx_desc(&xsk->rx,
>+						 idx_rx++)->len;
>+		char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
> 
>-		for (i = 0; i < rcvd; i++) {
>-			u64 addr = xsk_ring_cons__rx_desc(&xsk->rx,
>-							  idx_rx)->addr;
>-			u32 len = xsk_ring_cons__rx_desc(&xsk->rx,
>-							 idx_rx++)->len;
>-			char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
>+		swap_mac_addresses(pkt);
> 
>-			swap_mac_addresses(pkt);
>+		hex_dump(pkt, len, addr);
>+		xsk_ring_prod__tx_desc(&xsk->tx, idx_tx)->addr = addr;
>+		xsk_ring_prod__tx_desc(&xsk->tx, idx_tx++)->len = len;
>+	}
> 
>-			hex_dump(pkt, len, addr);
>-			xsk_ring_prod__tx_desc(&xsk->tx, idx_tx)->addr = addr;
>-			xsk_ring_prod__tx_desc(&xsk->tx, idx_tx++)->len = len;
>-		}
>+	xsk_ring_prod__submit(&xsk->tx, rcvd);
>+	xsk_ring_cons__release(&xsk->rx, rcvd);
> 
>-		xsk_ring_prod__submit(&xsk->tx, rcvd);
>-		xsk_ring_cons__release(&xsk->rx, rcvd);
>+	xsk->rx_npkts += rcvd;
>+	xsk->outstanding_tx += rcvd;
>+}
> 
>-		xsk->rx_npkts += rcvd;
>-		xsk->outstanding_tx += rcvd;
>+static void l2fwd_all(void)
>+{
>+	struct pollfd fds[MAX_SOCKS];
>+	int i, ret;
>+
>+	memset(fds, 0, sizeof(fds));
>+
>+	for (i = 0; i < num_socks; i++) {
>+		fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
>+		fds[i].events = POLLOUT | POLLIN;
>+	}
>+
>+	for (;;) {
>+		if (opt_poll) {
>+			ret = poll(fds, num_socks, 0);
>+			if (ret <= 0)
>+				continue;
>+		}
>+
>+		for (i = 0; i < num_socks; i++)
>+			l2fwd(xsks[i], fds);
> 	}
> }
> 
>@@ -693,9 +740,9 @@ int main(int argc, char **argv)
> 	if (opt_bench == BENCH_RXDROP)
> 		rx_drop_all();
> 	else if (opt_bench == BENCH_TXONLY)
>-		tx_only(xsks[0]);
>+		tx_only_all();
> 	else
>-		l2fwd(xsks[0]);
>+		l2fwd_all();
> 
> 	return 0;
> }
>-- 
>2.7.4
>
