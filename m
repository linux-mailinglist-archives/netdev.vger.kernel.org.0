Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4B4255A94
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 14:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgH1MvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 08:51:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:39885 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbgH1MvN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 08:51:13 -0400
IronPort-SDR: IL9yvp/3CWVuno1QDKoyD6qx0tFykZOf20E7KwO0shw2zpK80Y7XQHd8L5x915QBLU02Jfr62v
 udcObSlG1lcA==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="156660852"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="156660852"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 05:51:12 -0700
IronPort-SDR: qLZfFMxhpAuBZ+bj2afbifOo+/JalzTxbFrgl4AlaZms1EHkEu8oXmB1SdepKwJ3BrIryFr9c3
 UzTNpxHvrnqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="444826649"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.35.66])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2020 05:51:10 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next] samples/bpf: optimize l2fwd performance in xdpsock
Date:   Fri, 28 Aug 2020 14:51:05 +0200
Message-Id: <1598619065-1944-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Optimize the throughput performance of the l2fwd sub-app in the
xdpsock sample application by removing a duplicate syscall and
increasing the size of the fill ring.

The latter needs some further explanation. We recommend that you set
the fill ring size >= HW RX ring size + AF_XDP RX ring size. Make sure
you fill up the fill ring with buffers at regular intervals, and you
will with this setting avoid allocation failures in the driver. These
are usually quite expensive since drivers have not been written to
assume that allocation failures are common. For regular sockets,
kernel allocated memory is used that only runs out in OOM situations
that should be rare.

These two performance optimizations together lead to a 6% percent
improvement for the l2fwd app on my machine.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 samples/bpf/xdpsock_user.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 19c6794..9f54df7 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -613,7 +613,16 @@ static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
 {
 	struct xsk_umem_info *umem;
 	struct xsk_umem_config cfg = {
-		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
+		/* We recommend that you set the fill ring size >= HW RX ring size +
+		 * AF_XDP RX ring size. Make sure you fill up the fill ring
+		 * with buffers at regular intervals, and you will with this setting
+		 * avoid allocation failures in the driver. These are usually quite
+		 * expensive since drivers have not been written to assume that
+		 * allocation failures are common. For regular sockets, kernel
+		 * allocated memory is used that only runs out in OOM situations
+		 * that should be rare.
+		 */
+		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS * 2,
 		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
 		.frame_size = opt_xsk_frame_size,
 		.frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM,
@@ -640,13 +649,13 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
 	u32 idx;
 
 	ret = xsk_ring_prod__reserve(&umem->fq,
-				     XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
-	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
+				     XSK_RING_PROD__DEFAULT_NUM_DESCS * 2, &idx);
+	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS * 2)
 		exit_with_error(-ret);
-	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
+	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS * 2; i++)
 		*xsk_ring_prod__fill_addr(&umem->fq, idx++) =
 			i * opt_xsk_frame_size;
-	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
+	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS * 2);
 }
 
 static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem,
@@ -888,9 +897,6 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 	if (!xsk->outstanding_tx)
 		return;
 
-	if (!opt_need_wakeup || xsk_ring_prod__needs_wakeup(&xsk->tx))
-		kick_tx(xsk);
-
 	ndescs = (xsk->outstanding_tx > opt_batch_size) ? opt_batch_size :
 		xsk->outstanding_tx;
 
-- 
2.7.4

