Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9686A758
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 13:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387748AbfGPLWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 07:22:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:34198 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733200AbfGPLWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 07:22:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 04:22:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,498,1557212400"; 
   d="scan'208";a="366631454"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.10])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jul 2019 04:21:57 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH v2 05/10] ixgbe: modify driver for handling offsets
Date:   Tue, 16 Jul 2019 03:06:32 +0000
Message-Id: <20190716030637.5634-6-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190716030637.5634-1-kevin.laatz@intel.com>
References: <20190620090958.2135-1-kevin.laatz@intel.com>
 <20190716030637.5634-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the addition of the unaligned chunks option, we need to make sure we
handle the offsets accordingly based on the mode we are currently running
in. This patch modifies the driver to appropriately mask the address for
each case.

Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 26 ++++++++++++++++----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index bc86057628c8..ac1669b18d13 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -143,7 +143,9 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 			    struct ixgbe_ring *rx_ring,
 			    struct xdp_buff *xdp)
 {
+	struct xdp_umem *umem = rx_ring->xsk_umem;
 	int err, result = IXGBE_XDP_PASS;
+	u64 offset = umem->headroom;
 	struct bpf_prog *xdp_prog;
 	struct xdp_frame *xdpf;
 	u32 act;
@@ -151,7 +153,13 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
-	xdp->handle += xdp->data - xdp->data_hard_start;
+	offset += xdp->data - xdp->data_hard_start;
+
+	if (umem->flags & XDP_UMEM_UNALIGNED_CHUNKS)
+		xdp->handle |= (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
+	else
+		xdp->handle += offset;
+
 	switch (act) {
 	case XDP_PASS:
 		break;
@@ -235,7 +243,10 @@ void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
 	nta++;
 	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
 
-	handle &= mask;
+	if (rx_ring->xsk_umem->flags & XDP_UMEM_UNALIGNED_CHUNKS)
+		handle &= XSK_UNALIGNED_BUF_ADDR_MASK;
+	else
+		handle &= mask;
 
 	bi->dma = xdp_umem_get_dma(rx_ring->xsk_umem, handle);
 	bi->dma += hr;
@@ -269,7 +280,7 @@ static bool ixgbe_alloc_buffer_zc(struct ixgbe_ring *rx_ring,
 	bi->addr = xdp_umem_get_data(umem, handle);
 	bi->addr += hr;
 
-	bi->handle = handle + umem->headroom;
+	bi->handle = handle;
 
 	xsk_umem_discard_addr(umem);
 	return true;
@@ -296,7 +307,7 @@ static bool ixgbe_alloc_buffer_slow_zc(struct ixgbe_ring *rx_ring,
 	bi->addr = xdp_umem_get_data(umem, handle);
 	bi->addr += hr;
 
-	bi->handle = handle + umem->headroom;
+	bi->handle = handle;
 
 	xsk_umem_discard_addr_rq(umem);
 	return true;
@@ -565,6 +576,7 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 	struct ixgbe_tx_buffer *tx_bi;
 	bool work_done = true;
 	struct xdp_desc desc;
+	u64 addr, offset;
 	dma_addr_t dma;
 	u32 cmd_type;
 
@@ -578,7 +590,11 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 		if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &desc))
 			break;
 
-		dma = xdp_umem_get_dma(xdp_ring->xsk_umem, desc.addr);
+		/* for unaligned chunks need to take offset from upper bits */
+		offset = (desc.addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT);
+		addr = (desc.addr & XSK_UNALIGNED_BUF_ADDR_MASK);
+
+		dma = xdp_umem_get_dma(xdp_ring->xsk_umem, addr + offset);
 
 		dma_sync_single_for_device(xdp_ring->dev, dma, desc.len,
 					   DMA_BIDIRECTIONAL);
-- 
2.17.1

