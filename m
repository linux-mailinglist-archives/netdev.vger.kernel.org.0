Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6ECF3617
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389823AbfKGRr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:47:57 -0500
Received: from mga03.intel.com ([134.134.136.65]:33466 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389795AbfKGRrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 12:47:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 09:47:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,278,1569308400"; 
   d="scan'208";a="353858413"
Received: from unknown (HELO VM.jf.intel.com) ([10.78.3.78])
  by orsmga004.jf.intel.com with ESMTP; 07 Nov 2019 09:47:54 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, u9012063@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next 4/5] samples/bpf: use Rx-only and Tx-only sockets in xdpsock
Date:   Thu,  7 Nov 2019 18:47:39 +0100
Message-Id: <1573148860-30254-5-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use Rx-only sockets for the rxdrop sample and Tx-only sockets for the
txpush sample in the xdpsock application. This so that we exercise and
show case these socket types too.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 samples/bpf/xdpsock_user.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index d3dba93..a1f96e5 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -291,8 +291,7 @@ static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
 		.frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM,
 		.flags = opt_umem_flags
 	};
-	int ret, i;
-	u32 idx;
+	int ret;
 
 	umem = calloc(1, sizeof(*umem));
 	if (!umem)
@@ -300,10 +299,18 @@ static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
 
 	ret = xsk_umem__create(&umem->umem, buffer, size, &umem->fq, &umem->cq,
 			       &cfg);
-
 	if (ret)
 		exit_with_error(-ret);
 
+	umem->buffer = buffer;
+	return umem;
+}
+
+static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
+{
+	int ret, i;
+	u32 idx;
+
 	ret = xsk_ring_prod__reserve(&umem->fq,
 				     XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
 	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
@@ -312,15 +319,15 @@ static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
 		*xsk_ring_prod__fill_addr(&umem->fq, idx++) =
 			i * opt_xsk_frame_size;
 	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
-
-	umem->buffer = buffer;
-	return umem;
 }
 
-static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
+static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem,
+						    bool rx, bool tx)
 {
 	struct xsk_socket_config cfg;
 	struct xsk_socket_info *xsk;
+	struct xsk_ring_cons *rxr;
+	struct xsk_ring_prod *txr;
 	int ret;
 
 	xsk = calloc(1, sizeof(*xsk));
@@ -337,8 +344,10 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
 	cfg.xdp_flags = opt_xdp_flags;
 	cfg.bind_flags = opt_xdp_bind_flags;
 
-	ret = xsk_socket__create(&xsk->xsk, opt_if, opt_queue,
-				 umem->umem, &xsk->rx, &xsk->tx, &cfg);
+	rxr = rx ? &xsk->rx : NULL;
+	txr = tx ? &xsk->tx : NULL;
+	ret = xsk_socket__create(&xsk->xsk, opt_if, opt_queue, umem->umem,
+				 rxr, txr, &cfg);
 	if (ret)
 		exit_with_error(-ret);
 
@@ -783,6 +792,7 @@ static void enter_xsks_into_map(struct bpf_object *obj)
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	bool rx = false, tx = false;
 	struct xsk_umem_info *umem;
 	struct bpf_object *obj;
 	pthread_t pt;
@@ -811,11 +821,18 @@ int main(int argc, char **argv)
 
 	/* Create sockets... */
 	umem = xsk_configure_umem(bufs, NUM_FRAMES * opt_xsk_frame_size);
+	if (opt_bench == BENCH_RXDROP || opt_bench == BENCH_L2FWD) {
+		rx = true;
+		xsk_populate_fill_ring(umem);
+	}
+	if (opt_bench == BENCH_L2FWD || opt_bench == BENCH_TXONLY)
+		tx = true;
 	for (i = 0; i < opt_num_xsks; i++)
-		xsks[num_socks++] = xsk_configure_socket(umem);
+		xsks[num_socks++] = xsk_configure_socket(umem, rx, tx);
 
-	for (i = 0; i < NUM_FRAMES; i++)
-		gen_eth_frame(umem, i * opt_xsk_frame_size);
+	if (opt_bench == BENCH_TXONLY)
+		for (i = 0; i < NUM_FRAMES; i++)
+			gen_eth_frame(umem, i * opt_xsk_frame_size);
 
 	if (opt_num_xsks > 1 && opt_bench != BENCH_TXONLY)
 		enter_xsks_into_map(obj);
-- 
2.7.4

