Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851B956C21
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbfFZOgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59859 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727516AbfFZOgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:19 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:16 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGY3027430;
        Wed, 26 Jun 2019 17:36:16 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH bpf-next V6 05/16] xsk: Change the default frame size to 4096 and allow controlling it
Date:   Wed, 26 Jun 2019 17:35:27 +0300
Message-Id: <1561559738-4213-6-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

The typical XDP memory scheme is one packet per page. Change the AF_XDP
frame size in libbpf to 4096, which is the page size on x86, to allow
libbpf to be used with the drivers with the packet-per-page scheme.

Add a command line option -f to xdpsock to allow to specify a custom
frame size.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
 samples/bpf/xdpsock_user.c | 44 ++++++++++++++++++++++++++++----------------
 tools/lib/bpf/xsk.h        |  2 +-
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 0f5eb0d7f2df..93eaaf7239b2 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -68,6 +68,7 @@ enum benchmark_type {
 static int opt_poll;
 static int opt_interval = 1;
 static u32 opt_xdp_bind_flags;
+static int opt_xsk_frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
 static __u32 prog_id;
 
 struct xsk_umem_info {
@@ -276,6 +277,12 @@ static size_t gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
 static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
 {
 	struct xsk_umem_info *umem;
+	struct xsk_umem_config cfg = {
+		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
+		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
+		.frame_size = opt_xsk_frame_size,
+		.frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM,
+	};
 	int ret;
 
 	umem = calloc(1, sizeof(*umem));
@@ -283,7 +290,7 @@ static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
 		exit_with_error(errno);
 
 	ret = xsk_umem__create(&umem->umem, buffer, size, &umem->fq, &umem->cq,
-			       NULL);
+			       &cfg);
 	if (ret)
 		exit_with_error(-ret);
 
@@ -323,11 +330,9 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
 				     &idx);
 	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
 		exit_with_error(-ret);
-	for (i = 0;
-	     i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
-		     XSK_UMEM__DEFAULT_FRAME_SIZE;
-	     i += XSK_UMEM__DEFAULT_FRAME_SIZE)
-		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx++) = i;
+	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
+		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx++) =
+			i * opt_xsk_frame_size;
 	xsk_ring_prod__submit(&xsk->umem->fq,
 			      XSK_RING_PROD__DEFAULT_NUM_DESCS);
 
@@ -346,6 +351,7 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
 	{"interval", required_argument, 0, 'n'},
 	{"zero-copy", no_argument, 0, 'z'},
 	{"copy", no_argument, 0, 'c'},
+	{"frame-size", required_argument, 0, 'f'},
 	{0, 0, 0, 0}
 };
 
@@ -365,8 +371,9 @@ static void usage(const char *prog)
 		"  -n, --interval=n	Specify statistics update interval (default 1 sec).\n"
 		"  -z, --zero-copy      Force zero-copy mode.\n"
 		"  -c, --copy           Force copy mode.\n"
+		"  -f, --frame-size=n   Set the frame size (must be a power of two, default is %d).\n"
 		"\n";
-	fprintf(stderr, str, prog);
+	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE);
 	exit(EXIT_FAILURE);
 }
 
@@ -377,7 +384,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:psSNn:cz", long_options,
+		c = getopt_long(argc, argv, "Frtli:q:psSNn:czf:", long_options,
 				&option_index);
 		if (c == -1)
 			break;
@@ -420,6 +427,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'F':
 			opt_xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
+		case 'f':
+			opt_xsk_frame_size = atoi(optarg);
+			break;
 		default:
 			usage(basename(argv[0]));
 		}
@@ -432,6 +442,11 @@ static void parse_command_line(int argc, char **argv)
 		usage(basename(argv[0]));
 	}
 
+	if (opt_xsk_frame_size & (opt_xsk_frame_size - 1)) {
+		fprintf(stderr, "--frame-size=%d is not a power of two\n",
+			opt_xsk_frame_size);
+		usage(basename(argv[0]));
+	}
 }
 
 static void kick_tx(struct xsk_socket_info *xsk)
@@ -583,8 +598,7 @@ static void tx_only(struct xsk_socket_info *xsk)
 
 			for (i = 0; i < BATCH_SIZE; i++) {
 				xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->addr
-					= (frame_nb + i) <<
-					XSK_UMEM__DEFAULT_FRAME_SHIFT;
+					= (frame_nb + i) * opt_xsk_frame_size;
 				xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->len =
 					sizeof(pkt_data) - 1;
 			}
@@ -661,21 +675,19 @@ int main(int argc, char **argv)
 	}
 
 	ret = posix_memalign(&bufs, getpagesize(), /* PAGE_SIZE aligned */
-			     NUM_FRAMES * XSK_UMEM__DEFAULT_FRAME_SIZE);
+			     NUM_FRAMES * opt_xsk_frame_size);
 	if (ret)
 		exit_with_error(ret);
 
        /* Create sockets... */
-	umem = xsk_configure_umem(bufs,
-				  NUM_FRAMES * XSK_UMEM__DEFAULT_FRAME_SIZE);
+	umem = xsk_configure_umem(bufs, NUM_FRAMES * opt_xsk_frame_size);
 	xsks[num_socks++] = xsk_configure_socket(umem);
 
 	if (opt_bench == BENCH_TXONLY) {
 		int i;
 
-		for (i = 0; i < NUM_FRAMES * XSK_UMEM__DEFAULT_FRAME_SIZE;
-		     i += XSK_UMEM__DEFAULT_FRAME_SIZE)
-			(void)gen_eth_frame(umem, i);
+		for (i = 0; i < NUM_FRAMES; i++)
+			(void)gen_eth_frame(umem, i * opt_xsk_frame_size);
 	}
 
 	signal(SIGINT, int_exit);
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 82ea71a0f3ec..833a6e60d065 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -167,7 +167,7 @@ static inline void *xsk_umem__get_data(void *umem_area, __u64 addr)
 
 #define XSK_RING_CONS__DEFAULT_NUM_DESCS      2048
 #define XSK_RING_PROD__DEFAULT_NUM_DESCS      2048
-#define XSK_UMEM__DEFAULT_FRAME_SHIFT    11 /* 2048 bytes */
+#define XSK_UMEM__DEFAULT_FRAME_SHIFT    12 /* 4096 bytes */
 #define XSK_UMEM__DEFAULT_FRAME_SIZE     (1 << XSK_UMEM__DEFAULT_FRAME_SHIFT)
 #define XSK_UMEM__DEFAULT_FRAME_HEADROOM 0
 
-- 
1.8.3.1

