Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89CC1167C8
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 08:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfLIH5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 02:57:18 -0500
Received: from mga05.intel.com ([192.55.52.43]:35356 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbfLIH5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 02:57:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2019 23:57:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="362846945"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.32.126])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2019 23:57:11 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next 09/12] xsk: ixgbe: i40e: ice: mlx5: xsk_umem_discard_addr to xsk_umem_release_addr
Date:   Mon,  9 Dec 2019 08:56:26 +0100
Message-Id: <1575878189-31860-10-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the name of xsk_umem_discard_addr to xsk_umem_release_addr to
better reflect the new naming of the AF_XDP queue manipulation
functions. As this functions is used by drivers implementing support
for AF_XDP zero-copy, it requires a name change to these drivers. The
function xsk_umem_release_addr_rq has also changed name in the same
fashion.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c          |  4 ++--
 drivers/net/ethernet/intel/ice/ice_xsk.c            |  4 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c        |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c |  2 +-
 include/net/xdp_sock.h                              | 10 +++++-----
 net/xdp/xsk.c                                       |  4 ++--
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index d07e1a8..20d6f11 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -269,7 +269,7 @@ static bool i40e_alloc_buffer_zc(struct i40e_ring *rx_ring,
 
 	bi->handle = xsk_umem_adjust_offset(umem, handle, umem->headroom);
 
-	xsk_umem_discard_addr(umem);
+	xsk_umem_release_addr(umem);
 	return true;
 }
 
@@ -306,7 +306,7 @@ static bool i40e_alloc_buffer_slow_zc(struct i40e_ring *rx_ring,
 
 	bi->handle = xsk_umem_adjust_offset(umem, handle, umem->headroom);
 
-	xsk_umem_discard_addr_rq(umem);
+	xsk_umem_release_addr_rq(umem);
 	return true;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index cf9b8b2..0af1f0b 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -555,7 +555,7 @@ ice_alloc_buf_fast_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 
 	rx_buf->handle = handle + umem->headroom;
 
-	xsk_umem_discard_addr(umem);
+	xsk_umem_release_addr(umem);
 	return true;
 }
 
@@ -591,7 +591,7 @@ ice_alloc_buf_slow_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 
 	rx_buf->handle = handle + umem->headroom;
 
-	xsk_umem_discard_addr_rq(umem);
+	xsk_umem_release_addr_rq(umem);
 	return true;
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index d6feaac..1501d0a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -277,7 +277,7 @@ static bool ixgbe_alloc_buffer_zc(struct ixgbe_ring *rx_ring,
 
 	bi->handle = xsk_umem_adjust_offset(umem, handle, umem->headroom);
 
-	xsk_umem_discard_addr(umem);
+	xsk_umem_release_addr(umem);
 	return true;
 }
 
@@ -304,7 +304,7 @@ static bool ixgbe_alloc_buffer_slow_zc(struct ixgbe_ring *rx_ring,
 
 	bi->handle = xsk_umem_adjust_offset(umem, handle, umem->headroom);
 
-	xsk_umem_discard_addr_rq(umem);
+	xsk_umem_release_addr_rq(umem);
 	return true;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 475b6bd..62fc8a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -35,7 +35,7 @@ int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
 	 */
 	dma_info->addr = xdp_umem_get_dma(umem, handle);
 
-	xsk_umem_discard_addr_rq(umem);
+	xsk_umem_release_addr_rq(umem);
 
 	dma_sync_single_for_device(rq->pdev, dma_info->addr, PAGE_SIZE,
 				   DMA_BIDIRECTIONAL);
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 0742aa9..b23f60d 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -120,7 +120,7 @@ bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs);
 /* Used from netdev driver */
 bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt);
 bool xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr);
-void xsk_umem_discard_addr(struct xdp_umem *umem);
+void xsk_umem_release_addr(struct xdp_umem *umem);
 void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries);
 bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc);
 void xsk_umem_consume_tx_done(struct xdp_umem *umem);
@@ -210,12 +210,12 @@ static inline bool xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
 	return addr;
 }
 
-static inline void xsk_umem_discard_addr_rq(struct xdp_umem *umem)
+static inline void xsk_umem_release_addr_rq(struct xdp_umem *umem)
 {
 	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
 
 	if (!rq->length)
-		xsk_umem_discard_addr(umem);
+		xsk_umem_release_addr(umem);
 	else
 		rq->length--;
 }
@@ -260,7 +260,7 @@ static inline u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
 	return NULL;
 }
 
-static inline void xsk_umem_discard_addr(struct xdp_umem *umem)
+static inline void xsk_umem_release_addr(struct xdp_umem *umem)
 {
 }
 
@@ -334,7 +334,7 @@ static inline u64 *xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
 	return NULL;
 }
 
-static inline void xsk_umem_discard_addr_rq(struct xdp_umem *umem)
+static inline void xsk_umem_release_addr_rq(struct xdp_umem *umem)
 {
 }
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 62e27a4..f0dd740 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -49,11 +49,11 @@ bool xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
 }
 EXPORT_SYMBOL(xsk_umem_peek_addr);
 
-void xsk_umem_discard_addr(struct xdp_umem *umem)
+void xsk_umem_release_addr(struct xdp_umem *umem)
 {
 	xskq_cons_release(umem->fq);
 }
-EXPORT_SYMBOL(xsk_umem_discard_addr);
+EXPORT_SYMBOL(xsk_umem_release_addr);
 
 void xsk_set_rx_need_wakeup(struct xdp_umem *umem)
 {
-- 
2.7.4

