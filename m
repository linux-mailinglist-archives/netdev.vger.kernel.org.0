Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4F221231B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgGBMTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:19:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:6897 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729001AbgGBMTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 08:19:33 -0400
IronPort-SDR: xc0jTu/HYBKdWgp6S3J3cN5T+7Zwr7wK7rAPYTpwUN8YI164Q7MSFmRUF/Chg9ECUyJRjll7pG
 b+mYH8t+bycw==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126486070"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126486070"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 05:19:32 -0700
IronPort-SDR: mvpHQD814TPHli5Z6wQ7JZKqaKPmcaGDPxfaGJdTDtzua1W7h2MTWyzMQtRfYgmBpb5FHt/XzC
 HpQ6sfoOYkTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="425933279"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.39.242])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2020 05:19:27 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next 02/14] xsk: i40e: ice: ixgbe: mlx5: rename xsk zero-copy driver interfaces
Date:   Thu,  2 Jul 2020 14:19:01 +0200
Message-Id: <1593692353-15102-3-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the AF_XDP zero-copy driver interface functions to better
reflect what they do after the replacement of umems with buffer
pools in the previous commit. Mostly it is about replacing the
umem name from the function names with xsk_buff and also have
them take the a buffer pool pointer instead of a umem. The
various ring functions have also been renamed in the process so
that they have the same naming convention as the internal
functions in xsk_queue.h. This so that it will be clearer what
they do and also for consistency.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  34 +++---
 drivers/net/ethernet/intel/ice/ice_base.c          |   6 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  34 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  32 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c  |  12 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   4 +-
 include/net/xdp_sock.h                             |   1 +
 include/net/xdp_sock_drv.h                         | 114 +++++++++++----------
 net/ethtool/channels.c                             |   2 +-
 net/ethtool/ioctl.c                                |   2 +-
 net/xdp/xdp_umem.c                                 |  24 ++---
 net/xdp/xsk.c                                      |  45 ++++----
 19 files changed, 182 insertions(+), 170 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3df725e..73dded7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3119,7 +3119,7 @@ static struct xsk_buff_pool *i40e_xsk_pool(struct i40e_ring *ring)
 	if (!xdp_on || !test_bit(qid, ring->vsi->af_xdp_zc_qps))
 		return NULL;
 
-	return xdp_get_xsk_pool_from_qid(ring->vsi->netdev, qid);
+	return xsk_get_pool_from_qid(ring->vsi->netdev, qid);
 }
 
 /**
@@ -3267,7 +3267,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 		if (ret)
 			return ret;
 		ring->rx_buf_len =
-		  xsk_umem_get_rx_frame_size(ring->xsk_pool->umem);
+		  xsk_pool_get_rx_frame_size(ring->xsk_pool);
 		/* For AF_XDP ZC, we disallow packets to span on
 		 * multiple buffers, thus letting us skip that
 		 * handling in the fast-path.
@@ -3351,7 +3351,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	writel(0, ring->tail);
 
 	if (ring->xsk_pool) {
-		xsk_buff_set_rxq_info(ring->xsk_pool->umem, &ring->xdp_rxq);
+		xsk_pool_set_rxq_info(ring->xsk_pool, &ring->xdp_rxq);
 		ok = i40e_alloc_rx_buffers_zc(ring, I40E_DESC_UNUSED(ring));
 	} else {
 		ok = !i40e_alloc_rx_buffers(ring, I40E_DESC_UNUSED(ring));
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index d7ebdf6..ebaf0bd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -55,8 +55,7 @@ static int i40e_xsk_pool_enable(struct i40e_vsi *vsi,
 	    qid >= netdev->real_num_tx_queues)
 		return -EINVAL;
 
-	err = xsk_buff_dma_map(pool->umem, &vsi->back->pdev->dev,
-			       I40E_RX_DMA_ATTR);
+	err = xsk_pool_dma_map(pool, &vsi->back->pdev->dev, I40E_RX_DMA_ATTR);
 	if (err)
 		return err;
 
@@ -97,7 +96,7 @@ static int i40e_xsk_pool_disable(struct i40e_vsi *vsi, u16 qid)
 	bool if_running;
 	int err;
 
-	pool = xdp_get_xsk_pool_from_qid(netdev, qid);
+	pool = xsk_get_pool_from_qid(netdev, qid);
 	if (!pool)
 		return -EINVAL;
 
@@ -110,7 +109,7 @@ static int i40e_xsk_pool_disable(struct i40e_vsi *vsi, u16 qid)
 	}
 
 	clear_bit(qid, vsi->af_xdp_zc_qps);
-	xsk_buff_dma_unmap(pool->umem, I40E_RX_DMA_ATTR);
+	xsk_pool_dma_unmap(pool, I40E_RX_DMA_ATTR);
 
 	if (if_running) {
 		err = i40e_queue_pair_enable(vsi, qid);
@@ -196,7 +195,7 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 	rx_desc = I40E_RX_DESC(rx_ring, ntu);
 	bi = i40e_rx_bi(rx_ring, ntu);
 	do {
-		xdp = xsk_buff_alloc(rx_ring->xsk_pool->umem);
+		xdp = xsk_buff_alloc(rx_ring->xsk_pool);
 		if (!xdp) {
 			ok = false;
 			goto no_buffers;
@@ -363,11 +362,11 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
-	if (xsk_umem_uses_need_wakeup(rx_ring->xsk_pool->umem)) {
+	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
 		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
-			xsk_set_rx_need_wakeup(rx_ring->xsk_pool->umem);
+			xsk_set_rx_need_wakeup(rx_ring->xsk_pool);
 		else
-			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool->umem);
+			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool);
 
 		return (int)total_rx_packets;
 	}
@@ -396,12 +395,11 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 			break;
 		}
 
-		if (!xsk_umem_consume_tx(xdp_ring->xsk_pool->umem, &desc))
+		if (!xsk_tx_peek_desc(xdp_ring->xsk_pool, &desc))
 			break;
 
-		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool->umem,
-					   desc.addr);
-		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool->umem, dma,
+		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc.addr);
+		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma,
 						 desc.len);
 
 		tx_bi = &xdp_ring->tx_bi[xdp_ring->next_to_use];
@@ -425,7 +423,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 						 I40E_TXD_QW1_CMD_SHIFT);
 		i40e_xdp_ring_update_tail(xdp_ring);
 
-		xsk_umem_consume_tx_done(xdp_ring->xsk_pool->umem);
+		xsk_tx_release(xdp_ring->xsk_pool);
 	}
 
 	return !!budget && work_done;
@@ -498,14 +496,14 @@ bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi,
 		tx_ring->next_to_clean -= tx_ring->count;
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(bp->umem, xsk_frames);
+		xsk_tx_completed(bp, xsk_frames);
 
 	i40e_arm_wb(tx_ring, vsi, budget);
 	i40e_update_tx_stats(tx_ring, completed_frames, total_bytes);
 
 out_xmit:
-	if (xsk_umem_uses_need_wakeup(tx_ring->xsk_pool->umem))
-		xsk_set_tx_need_wakeup(tx_ring->xsk_pool->umem);
+	if (xsk_uses_need_wakeup(tx_ring->xsk_pool))
+		xsk_set_tx_need_wakeup(tx_ring->xsk_pool);
 
 	xmit_done = i40e_xmit_zc(tx_ring, budget);
 
@@ -598,7 +596,7 @@ void i40e_xsk_clean_tx_ring(struct i40e_ring *tx_ring)
 	}
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(bp->umem, xsk_frames);
+		xsk_tx_completed(bp, xsk_frames);
 }
 
 /**
@@ -614,7 +612,7 @@ bool i40e_xsk_any_rx_ring_enabled(struct i40e_vsi *vsi)
 	int i;
 
 	for (i = 0; i < vsi->num_queue_pairs; i++) {
-		if (xdp_get_xsk_pool_from_qid(netdev, i))
+		if (xsk_get_pool_from_qid(netdev, i))
 			return true;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 94dbf89..16fbc79 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -313,7 +313,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 			xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
 
 			ring->rx_buf_len =
-				xsk_umem_get_rx_frame_size(ring->xsk_pool->umem);
+				xsk_pool_get_rx_frame_size(ring->xsk_pool);
 			/* For AF_XDP ZC, we disallow packets to span on
 			 * multiple buffers, thus letting us skip that
 			 * handling in the fast-path.
@@ -324,7 +324,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 							 NULL);
 			if (err)
 				return err;
-			xsk_buff_set_rxq_info(ring->xsk_pool->umem, &ring->xdp_rxq);
+			xsk_pool_set_rxq_info(ring->xsk_pool, &ring->xdp_rxq);
 
 			dev_info(dev, "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
 				 ring->q_index);
@@ -418,7 +418,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	writel(0, ring->tail);
 
 	if (ring->xsk_pool) {
-		if (!xsk_buff_can_alloc(ring->xsk_pool->umem, num_bufs)) {
+		if (!xsk_buff_can_alloc(ring->xsk_pool, num_bufs)) {
 			dev_warn(dev, "XSK buffer pool does not provide enough addresses to fill %d buffers on Rx ring %d\n",
 				 num_bufs, ring->q_index);
 			dev_warn(dev, "Change Rx ring/fill queue size to avoid performance issues\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index f0ce669..6430df2 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -310,7 +310,7 @@ static int ice_xsk_pool_disable(struct ice_vsi *vsi, u16 qid)
 	    !vsi->xsk_pools[qid])
 		return -EINVAL;
 
-	xsk_buff_dma_unmap(vsi->xsk_pools[qid]->umem, ICE_RX_DMA_ATTR);
+	xsk_pool_dma_unmap(vsi->xsk_pools[qid], ICE_RX_DMA_ATTR);
 	ice_xsk_remove_pool(vsi, qid);
 
 	return 0;
@@ -347,7 +347,7 @@ ice_xsk_pool_enable(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	vsi->xsk_pools[qid] = pool;
 	vsi->num_xsk_pools_used++;
 
-	err = xsk_buff_dma_map(vsi->xsk_pools[qid]->umem, ice_pf_to_dev(vsi->back),
+	err = xsk_pool_dma_map(vsi->xsk_pools[qid], ice_pf_to_dev(vsi->back),
 			       ICE_RX_DMA_ATTR);
 	if (err)
 		return err;
@@ -424,7 +424,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 	rx_buf = &rx_ring->rx_buf[ntu];
 
 	do {
-		rx_buf->xdp = xsk_buff_alloc(rx_ring->xsk_pool->umem);
+		rx_buf->xdp = xsk_buff_alloc(rx_ring->xsk_pool);
 		if (!rx_buf->xdp) {
 			ret = true;
 			break;
@@ -645,11 +645,11 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 	ice_finalize_xdp_rx(rx_ring, xdp_xmit);
 	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
 
-	if (xsk_umem_uses_need_wakeup(rx_ring->xsk_pool->umem)) {
+	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
 		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
-			xsk_set_rx_need_wakeup(rx_ring->xsk_pool->umem);
+			xsk_set_rx_need_wakeup(rx_ring->xsk_pool);
 		else
-			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool->umem);
+			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool);
 
 		return (int)total_rx_packets;
 	}
@@ -682,11 +682,11 @@ static bool ice_xmit_zc(struct ice_ring *xdp_ring, int budget)
 
 		tx_buf = &xdp_ring->tx_buf[xdp_ring->next_to_use];
 
-		if (!xsk_umem_consume_tx(xdp_ring->xsk_pool->umem, &desc))
+		if (!xsk_tx_peek_desc(xdp_ring->xsk_pool, &desc))
 			break;
 
-		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool->umem, desc.addr);
-		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool->umem, dma,
+		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc.addr);
+		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma,
 						 desc.len);
 
 		tx_buf->bytecount = desc.len;
@@ -703,9 +703,9 @@ static bool ice_xmit_zc(struct ice_ring *xdp_ring, int budget)
 
 	if (tx_desc) {
 		ice_xdp_ring_update_tail(xdp_ring);
-		xsk_umem_consume_tx_done(xdp_ring->xsk_pool->umem);
-		if (xsk_umem_uses_need_wakeup(xdp_ring->xsk_pool->umem))
-			xsk_clear_tx_need_wakeup(xdp_ring->xsk_pool->umem);
+		xsk_tx_release(xdp_ring->xsk_pool);
+		if (xsk_uses_need_wakeup(xdp_ring->xsk_pool))
+			xsk_clear_tx_need_wakeup(xdp_ring->xsk_pool);
 	}
 
 	return budget > 0 && work_done;
@@ -779,13 +779,13 @@ bool ice_clean_tx_irq_zc(struct ice_ring *xdp_ring, int budget)
 	xdp_ring->next_to_clean = ntc;
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(xdp_ring->xsk_pool->umem, xsk_frames);
+		xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
 
-	if (xsk_umem_uses_need_wakeup(xdp_ring->xsk_pool->umem)) {
+	if (xsk_uses_need_wakeup(xdp_ring->xsk_pool)) {
 		if (xdp_ring->next_to_clean == xdp_ring->next_to_use)
-			xsk_set_tx_need_wakeup(xdp_ring->xsk_pool->umem);
+			xsk_set_tx_need_wakeup(xdp_ring->xsk_pool);
 		else
-			xsk_clear_tx_need_wakeup(xdp_ring->xsk_pool->umem);
+			xsk_clear_tx_need_wakeup(xdp_ring->xsk_pool);
 	}
 
 	ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
@@ -902,5 +902,5 @@ void ice_xsk_clean_xdp_ring(struct ice_ring *xdp_ring)
 	}
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(xdp_ring->xsk_pool->umem, xsk_frames);
+		xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
 }
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 3217000..5d1c786 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -3716,7 +3716,7 @@ static void ixgbe_configure_srrctl(struct ixgbe_adapter *adapter,
 
 	/* configure the packet buffer length */
 	if (rx_ring->xsk_pool) {
-		u32 xsk_buf_len = xsk_umem_get_rx_frame_size(rx_ring->xsk_pool->umem);
+		u32 xsk_buf_len = xsk_pool_get_rx_frame_size(rx_ring->xsk_pool);
 
 		/* If the MAC support setting RXDCTL.RLPML, the
 		 * SRRCTL[n].BSIZEPKT is set to PAGE_SIZE and
@@ -4066,7 +4066,7 @@ void ixgbe_configure_rx_ring(struct ixgbe_adapter *adapter,
 		WARN_ON(xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 						   MEM_TYPE_XSK_BUFF_POOL,
 						   NULL));
-		xsk_buff_set_rxq_info(ring->xsk_pool->umem, &ring->xdp_rxq);
+		xsk_pool_set_rxq_info(ring->xsk_pool, &ring->xdp_rxq);
 	} else {
 		WARN_ON(xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 						   MEM_TYPE_PAGE_SHARED, NULL));
@@ -4122,7 +4122,7 @@ void ixgbe_configure_rx_ring(struct ixgbe_adapter *adapter,
 	}
 
 	if (ring->xsk_pool && hw->mac.type != ixgbe_mac_82599EB) {
-		u32 xsk_buf_len = xsk_umem_get_rx_frame_size(ring->xsk_pool->umem);
+		u32 xsk_buf_len = xsk_pool_get_rx_frame_size(ring->xsk_pool);
 
 		rxdctl &= ~(IXGBE_RXDCTL_RLPMLMASK |
 			    IXGBE_RXDCTL_RLPML_EN);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 9f503d6..f07cd41 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -17,7 +17,7 @@ struct xsk_buff_pool *ixgbe_xsk_pool(struct ixgbe_adapter *adapter,
 	if (!xdp_on || !test_bit(qid, adapter->af_xdp_zc_qps))
 		return NULL;
 
-	return xdp_get_xsk_pool_from_qid(adapter->netdev, qid);
+	return xsk_get_pool_from_qid(adapter->netdev, qid);
 }
 
 static int ixgbe_xsk_pool_enable(struct ixgbe_adapter *adapter,
@@ -35,7 +35,7 @@ static int ixgbe_xsk_pool_enable(struct ixgbe_adapter *adapter,
 	    qid >= netdev->real_num_tx_queues)
 		return -EINVAL;
 
-	err = xsk_buff_dma_map(pool->umem, &adapter->pdev->dev, IXGBE_RX_DMA_ATTR);
+	err = xsk_pool_dma_map(pool, &adapter->pdev->dev, IXGBE_RX_DMA_ATTR);
 	if (err)
 		return err;
 
@@ -64,7 +64,7 @@ static int ixgbe_xsk_pool_disable(struct ixgbe_adapter *adapter, u16 qid)
 	struct xsk_buff_pool *pool;
 	bool if_running;
 
-	pool = xdp_get_xsk_pool_from_qid(adapter->netdev, qid);
+	pool = xsk_get_pool_from_qid(adapter->netdev, qid);
 	if (!pool)
 		return -EINVAL;
 
@@ -75,7 +75,7 @@ static int ixgbe_xsk_pool_disable(struct ixgbe_adapter *adapter, u16 qid)
 		ixgbe_txrx_ring_disable(adapter, qid);
 
 	clear_bit(qid, adapter->af_xdp_zc_qps);
-	xsk_buff_dma_unmap(pool->umem, IXGBE_RX_DMA_ATTR);
+	xsk_pool_dma_unmap(pool, IXGBE_RX_DMA_ATTR);
 
 	if (if_running)
 		ixgbe_txrx_ring_enable(adapter, qid);
@@ -150,7 +150,7 @@ bool ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 count)
 	i -= rx_ring->count;
 
 	do {
-		bi->xdp = xsk_buff_alloc(rx_ring->xsk_pool->umem);
+		bi->xdp = xsk_buff_alloc(rx_ring->xsk_pool);
 		if (!bi->xdp) {
 			ok = false;
 			break;
@@ -345,11 +345,11 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 	q_vector->rx.total_packets += total_rx_packets;
 	q_vector->rx.total_bytes += total_rx_bytes;
 
-	if (xsk_umem_uses_need_wakeup(rx_ring->xsk_pool->umem)) {
+	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
 		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
-			xsk_set_rx_need_wakeup(rx_ring->xsk_pool->umem);
+			xsk_set_rx_need_wakeup(rx_ring->xsk_pool);
 		else
-			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool->umem);
+			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool);
 
 		return (int)total_rx_packets;
 	}
@@ -389,11 +389,11 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 			break;
 		}
 
-		if (!xsk_umem_consume_tx(pool->umem, &desc))
+		if (!xsk_tx_peek_desc(pool, &desc))
 			break;
 
-		dma = xsk_buff_raw_get_dma(pool->umem, desc.addr);
-		xsk_buff_raw_dma_sync_for_device(pool->umem, dma, desc.len);
+		dma = xsk_buff_raw_get_dma(pool, desc.addr);
+		xsk_buff_raw_dma_sync_for_device(pool, dma, desc.len);
 
 		tx_bi = &xdp_ring->tx_buffer_info[xdp_ring->next_to_use];
 		tx_bi->bytecount = desc.len;
@@ -419,7 +419,7 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 
 	if (tx_desc) {
 		ixgbe_xdp_ring_update_tail(xdp_ring);
-		xsk_umem_consume_tx_done(pool->umem);
+		xsk_tx_release(pool);
 	}
 
 	return !!budget && work_done;
@@ -485,10 +485,10 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 	q_vector->tx.total_packets += total_packets;
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(pool->umem, xsk_frames);
+		xsk_tx_completed(pool, xsk_frames);
 
-	if (xsk_umem_uses_need_wakeup(pool->umem))
-		xsk_set_tx_need_wakeup(pool->umem);
+	if (xsk_uses_need_wakeup(pool))
+		xsk_set_tx_need_wakeup(pool);
 
 	return ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
 }
@@ -547,5 +547,5 @@ void ixgbe_xsk_clean_tx_ring(struct ixgbe_ring *tx_ring)
 	}
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(pool->umem, xsk_frames);
+		xsk_tx_completed(pool, xsk_frames);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 0a5a873..d6c7596 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -446,7 +446,7 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(sq->pool->umem, xsk_frames);
+		xsk_tx_completed(sq->pool, xsk_frames);
 
 	sq->stats->cqes += i;
 
@@ -476,7 +476,7 @@ void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq)
 	}
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(sq->pool->umem, xsk_frames);
+		xsk_tx_completed(sq->pool, xsk_frames);
 }
 
 int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index 3dd056a..7f88ccf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -22,7 +22,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
 					    struct mlx5e_dma_info *dma_info)
 {
-	dma_info->xsk = xsk_buff_alloc(rq->xsk_pool->umem);
+	dma_info->xsk = xsk_buff_alloc(rq->xsk_pool);
 	if (!dma_info->xsk)
 		return -ENOMEM;
 
@@ -38,13 +38,13 @@ static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
 
 static inline bool mlx5e_xsk_update_rx_wakeup(struct mlx5e_rq *rq, bool alloc_err)
 {
-	if (!xsk_umem_uses_need_wakeup(rq->xsk_pool->umem))
+	if (!xsk_uses_need_wakeup(rq->xsk_pool))
 		return alloc_err;
 
 	if (unlikely(alloc_err))
-		xsk_set_rx_need_wakeup(rq->xsk_pool->umem);
+		xsk_set_rx_need_wakeup(rq->xsk_pool);
 	else
-		xsk_clear_rx_need_wakeup(rq->xsk_pool->umem);
+		xsk_clear_rx_need_wakeup(rq->xsk_pool);
 
 	return false;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index abe4639..debcc70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -83,7 +83,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			break;
 		}
 
-		if (!xsk_umem_consume_tx(pool->umem, &desc)) {
+		if (!xsk_tx_peek_desc(pool, &desc)) {
 			/* TX will get stuck until something wakes it up by
 			 * triggering NAPI. Currently it's expected that the
 			 * application calls sendto() if there are consumed, but
@@ -92,11 +92,11 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			break;
 		}
 
-		xdptxd.dma_addr = xsk_buff_raw_get_dma(pool->umem, desc.addr);
-		xdptxd.data = xsk_buff_raw_get_data(pool->umem, desc.addr);
+		xdptxd.dma_addr = xsk_buff_raw_get_dma(pool, desc.addr);
+		xdptxd.data = xsk_buff_raw_get_data(pool, desc.addr);
 		xdptxd.len = desc.len;
 
-		xsk_buff_raw_dma_sync_for_device(pool->umem, xdptxd.dma_addr, xdptxd.len);
+		xsk_buff_raw_dma_sync_for_device(pool, xdptxd.dma_addr, xdptxd.len);
 
 		if (unlikely(!sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, check_result))) {
 			if (sq->mpwqe.wqe)
@@ -113,7 +113,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			mlx5e_xdp_mpwqe_complete(sq);
 		mlx5e_xmit_xdp_doorbell(sq);
 
-		xsk_umem_consume_tx_done(pool->umem);
+		xsk_tx_release(pool);
 	}
 
 	return !(budget && work_done);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
index 610a084..5821e88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
@@ -15,13 +15,13 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget);
 
 static inline void mlx5e_xsk_update_tx_wakeup(struct mlx5e_xdpsq *sq)
 {
-	if (!xsk_umem_uses_need_wakeup(sq->pool->umem))
+	if (!xsk_uses_need_wakeup(sq->pool))
 		return;
 
 	if (sq->pc != sq->cc)
-		xsk_clear_tx_need_wakeup(sq->pool->umem);
+		xsk_clear_tx_need_wakeup(sq->pool);
 	else
-		xsk_set_tx_need_wakeup(sq->pool->umem);
+		xsk_set_tx_need_wakeup(sq->pool);
 }
 
 #endif /* __MLX5_EN_XSK_TX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
index 947abf1..cb70870 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
@@ -11,13 +11,13 @@ static int mlx5e_xsk_map_pool(struct mlx5e_priv *priv,
 {
 	struct device *dev = priv->mdev->device;
 
-	return xsk_buff_dma_map(pool->umem, dev, 0);
+	return xsk_pool_dma_map(pool, dev, 0);
 }
 
 static void mlx5e_xsk_unmap_pool(struct mlx5e_priv *priv,
 				 struct xsk_buff_pool *pool)
 {
-	return xsk_buff_dma_unmap(pool->umem, 0);
+	return xsk_pool_dma_unmap(pool, 0);
 }
 
 static int mlx5e_xsk_get_pools(struct mlx5e_xsk *xsk)
@@ -64,14 +64,14 @@ static void mlx5e_xsk_remove_pool(struct mlx5e_xsk *xsk, u16 ix)
 
 static bool mlx5e_xsk_is_pool_sane(struct xsk_buff_pool *pool)
 {
-	return xsk_umem_get_headroom(pool->umem) <= 0xffff &&
-		xsk_umem_get_chunk_size(pool->umem) <= 0xffff;
+	return xsk_pool_get_headroom(pool) <= 0xffff &&
+		xsk_pool_get_chunk_size(pool) <= 0xffff;
 }
 
 void mlx5e_build_xsk_param(struct xsk_buff_pool *pool, struct mlx5e_xsk_param *xsk)
 {
-	xsk->headroom = xsk_umem_get_headroom(pool->umem);
-	xsk->chunk_size = xsk_umem_get_chunk_size(pool->umem);
+	xsk->headroom = xsk_pool_get_headroom(pool);
+	xsk->chunk_size = xsk_pool_get_chunk_size(pool);
 }
 
 static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2b4a3e3..695b993 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -518,7 +518,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	if (xsk) {
 		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
 						 MEM_TYPE_XSK_BUFF_POOL, NULL);
-		xsk_buff_set_rxq_info(rq->xsk_pool->umem, &rq->xdp_rxq);
+		xsk_pool_set_rxq_info(rq->xsk_pool, &rq->xdp_rxq);
 	} else {
 		/* Create a page_pool and register it with rxq */
 		pp_params.order     = 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1dcf77d..030f6d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -390,7 +390,7 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 		 * allocating one-by-one, failing and moving frames to the
 		 * Reuse Ring.
 		 */
-		if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool->umem, pages_desired)))
+		if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool, pages_desired)))
 			return -ENOMEM;
 	}
 
@@ -489,7 +489,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	 * one-by-one, failing and moving frames to the Reuse Ring.
 	 */
 	if (rq->xsk_pool &&
-	    unlikely(!xsk_buff_can_alloc(rq->xsk_pool->umem, MLX5_MPWRQ_PAGES_PER_WQE))) {
+	    unlikely(!xsk_buff_can_alloc(rq->xsk_pool, MLX5_MPWRQ_PAGES_PER_WQE))) {
 		err = -ENOMEM;
 		goto err;
 	}
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 96bfc5f..6eb9628 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -52,6 +52,7 @@ struct xdp_sock {
 	struct net_device *dev;
 	struct xdp_umem *umem;
 	struct list_head flush_node;
+	struct xsk_buff_pool *pool;
 	u16 queue_id;
 	bool zc;
 	enum {
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 5dc8d3c..a7c7d2e 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -11,48 +11,50 @@
 
 #ifdef CONFIG_XDP_SOCKETS
 
-void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries);
-bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc);
-void xsk_umem_consume_tx_done(struct xdp_umem *umem);
-struct xsk_buff_pool *xdp_get_xsk_pool_from_qid(struct net_device *dev,
-						u16 queue_id);
-void xsk_set_rx_need_wakeup(struct xdp_umem *umem);
-void xsk_set_tx_need_wakeup(struct xdp_umem *umem);
-void xsk_clear_rx_need_wakeup(struct xdp_umem *umem);
-void xsk_clear_tx_need_wakeup(struct xdp_umem *umem);
-bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem);
+void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
+bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc);
+void xsk_tx_release(struct xsk_buff_pool *pool);
+struct xsk_buff_pool *xsk_get_pool_from_qid(struct net_device *dev,
+					    u16 queue_id);
+void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool);
+void xsk_set_tx_need_wakeup(struct xsk_buff_pool *pool);
+void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool);
+void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool);
+bool xsk_uses_need_wakeup(struct xsk_buff_pool *pool);
 
-static inline u32 xsk_umem_get_headroom(struct xdp_umem *umem)
+static inline u32 xsk_pool_get_headroom(struct xsk_buff_pool *pool)
 {
-	return XDP_PACKET_HEADROOM + umem->headroom;
+	return XDP_PACKET_HEADROOM + pool->headroom;
 }
 
-static inline u32 xsk_umem_get_chunk_size(struct xdp_umem *umem)
+static inline u32 xsk_pool_get_chunk_size(struct xsk_buff_pool *pool)
 {
-	return umem->chunk_size;
+	return pool->chunk_size;
 }
 
-static inline u32 xsk_umem_get_rx_frame_size(struct xdp_umem *umem)
+static inline u32 xsk_pool_get_rx_frame_size(struct xsk_buff_pool *pool)
 {
-	return xsk_umem_get_chunk_size(umem) - xsk_umem_get_headroom(umem);
+	return xsk_pool_get_chunk_size(pool) - xsk_pool_get_headroom(pool);
 }
 
-static inline void xsk_buff_set_rxq_info(struct xdp_umem *umem,
+static inline void xsk_pool_set_rxq_info(struct xsk_buff_pool *pool,
 					 struct xdp_rxq_info *rxq)
 {
-	xp_set_rxq_info(umem->pool, rxq);
+	xp_set_rxq_info(pool, rxq);
 }
 
-static inline void xsk_buff_dma_unmap(struct xdp_umem *umem,
+static inline void xsk_pool_dma_unmap(struct xsk_buff_pool *pool,
 				      unsigned long attrs)
 {
-	xp_dma_unmap(umem->pool, attrs);
+	xp_dma_unmap(pool, attrs);
 }
 
-static inline int xsk_buff_dma_map(struct xdp_umem *umem, struct device *dev,
-				   unsigned long attrs)
+static inline int xsk_pool_dma_map(struct xsk_buff_pool *pool,
+				   struct device *dev, unsigned long attrs)
 {
-	return xp_dma_map(umem->pool, dev, attrs, umem->pgs, umem->npgs);
+	struct xdp_umem *umem = pool->umem;
+
+	return xp_dma_map(pool, dev, attrs, umem->pgs, umem->npgs);
 }
 
 static inline dma_addr_t xsk_buff_xdp_get_dma(struct xdp_buff *xdp)
@@ -69,14 +71,14 @@ static inline dma_addr_t xsk_buff_xdp_get_frame_dma(struct xdp_buff *xdp)
 	return xp_get_frame_dma(xskb);
 }
 
-static inline struct xdp_buff *xsk_buff_alloc(struct xdp_umem *umem)
+static inline struct xdp_buff *xsk_buff_alloc(struct xsk_buff_pool *pool)
 {
-	return xp_alloc(umem->pool);
+	return xp_alloc(pool);
 }
 
-static inline bool xsk_buff_can_alloc(struct xdp_umem *umem, u32 count)
+static inline bool xsk_buff_can_alloc(struct xsk_buff_pool *pool, u32 count)
 {
-	return xp_can_alloc(umem->pool, count);
+	return xp_can_alloc(pool, count);
 }
 
 static inline void xsk_buff_free(struct xdp_buff *xdp)
@@ -86,14 +88,15 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 	xp_free(xskb);
 }
 
-static inline dma_addr_t xsk_buff_raw_get_dma(struct xdp_umem *umem, u64 addr)
+static inline dma_addr_t xsk_buff_raw_get_dma(struct xsk_buff_pool *pool,
+					      u64 addr)
 {
-	return xp_raw_get_dma(umem->pool, addr);
+	return xp_raw_get_dma(pool, addr);
 }
 
-static inline void *xsk_buff_raw_get_data(struct xdp_umem *umem, u64 addr)
+static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
 {
-	return xp_raw_get_data(umem->pool, addr);
+	return xp_raw_get_data(pool, addr);
 }
 
 static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp)
@@ -103,83 +106,83 @@ static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp)
 	xp_dma_sync_for_cpu(xskb);
 }
 
-static inline void xsk_buff_raw_dma_sync_for_device(struct xdp_umem *umem,
+static inline void xsk_buff_raw_dma_sync_for_device(struct xsk_buff_pool *pool,
 						    dma_addr_t dma,
 						    size_t size)
 {
-	xp_dma_sync_for_device(umem->pool, dma, size);
+	xp_dma_sync_for_device(pool, dma, size);
 }
 
 #else
 
-static inline void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries)
+static inline void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries)
 {
 }
 
-static inline bool xsk_umem_consume_tx(struct xdp_umem *umem,
-				       struct xdp_desc *desc)
+static inline bool xsk_tx_peek_desc(struct xsk_buff_pool *pool,
+				    struct xdp_desc *desc)
 {
 	return false;
 }
 
-static inline void xsk_umem_consume_tx_done(struct xdp_umem *umem)
+static inline void xsk_tx_release(struct xsk_buff_pool *pool)
 {
 }
 
 static inline struct xsk_buff_pool *
-xdp_get_xsk_pool_from_qid(struct net_device *dev, u16 queue_id)
+xsk_get_pool_from_qid(struct net_device *dev, u16 queue_id)
 {
 	return NULL;
 }
 
-static inline void xsk_set_rx_need_wakeup(struct xdp_umem *umem)
+static inline void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
 {
 }
 
-static inline void xsk_set_tx_need_wakeup(struct xdp_umem *umem)
+static inline void xsk_set_tx_need_wakeup(struct xsk_buff_pool *pool)
 {
 }
 
-static inline void xsk_clear_rx_need_wakeup(struct xdp_umem *umem)
+static inline void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool)
 {
 }
 
-static inline void xsk_clear_tx_need_wakeup(struct xdp_umem *umem)
+static inline void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool)
 {
 }
 
-static inline bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem)
+static inline bool xsk_uses_need_wakeup(struct xsk_buff_pool *pool)
 {
 	return false;
 }
 
-static inline u32 xsk_umem_get_headroom(struct xdp_umem *umem)
+static inline u32 xsk_pool_get_headroom(struct xsk_buff_pool *pool)
 {
 	return 0;
 }
 
-static inline u32 xsk_umem_get_chunk_size(struct xdp_umem *umem)
+static inline u32 xsk_pool_get_chunk_size(struct xsk_buff_pool *pool)
 {
 	return 0;
 }
 
-static inline u32 xsk_umem_get_rx_frame_size(struct xdp_umem *umem)
+static inline u32 xsk_pool_get_rx_frame_size(struct xsk_buff_pool *pool)
 {
 	return 0;
 }
 
-static inline void xsk_buff_set_rxq_info(struct xdp_umem *umem,
+static inline void xsk_pool_set_rxq_info(struct xsk_buff_pool *pool,
 					 struct xdp_rxq_info *rxq)
 {
 }
 
-static inline void xsk_buff_dma_unmap(struct xdp_umem *umem,
+static inline void xsk_pool_dma_unmap(struct xsk_buff_pool *pool,
 				      unsigned long attrs)
 {
 }
 
-static inline int xsk_buff_dma_map(struct xdp_umem *umem, struct device *dev,
-				   unsigned long attrs)
+static inline int xsk_pool_dma_map(struct xsk_buff_pool *pool,
+				   struct device *dev, unsigned long attrs)
 {
 	return 0;
 }
@@ -194,12 +197,12 @@ static inline dma_addr_t xsk_buff_xdp_get_frame_dma(struct xdp_buff *xdp)
 	return 0;
 }
 
-static inline struct xdp_buff *xsk_buff_alloc(struct xdp_umem *umem)
+static inline struct xdp_buff *xsk_buff_alloc(struct xsk_buff_pool *pool)
 {
 	return NULL;
 }
 
-static inline bool xsk_buff_can_alloc(struct xdp_umem *umem, u32 count)
+static inline bool xsk_buff_can_alloc(struct xsk_buff_pool *pool, u32 count)
 {
 	return false;
 }
@@ -208,12 +211,13 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 {
 }
 
-static inline dma_addr_t xsk_buff_raw_get_dma(struct xdp_umem *umem, u64 addr)
+static inline dma_addr_t xsk_buff_raw_get_dma(struct xsk_buff_pool *pool,
+					      u64 addr)
 {
 	return 0;
 }
 
-static inline void *xsk_buff_raw_get_data(struct xdp_umem *umem, u64 addr)
+static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
 {
 	return NULL;
 }
@@ -222,7 +226,7 @@ static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp)
 {
 }
 
-static inline void xsk_buff_raw_dma_sync_for_device(struct xdp_umem *umem,
+static inline void xsk_buff_raw_dma_sync_for_device(struct xsk_buff_pool *pool,
 						    dma_addr_t dma,
 						    size_t size)
 {
diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 78d990b..9ecda09 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -223,7 +223,7 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	from_channel = channels.combined_count +
 		       min(channels.rx_count, channels.tx_count);
 	for (i = from_channel; i < old_total; i++)
-		if (xdp_get_xsk_pool_from_qid(dev, i)) {
+		if (xsk_get_pool_from_qid(dev, i)) {
 			GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing zerocopy AF_XDP sockets");
 			return -EINVAL;
 		}
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 91de16d..2d94306 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1702,7 +1702,7 @@ static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
 		min(channels.rx_count, channels.tx_count);
 	to_channel = curr.combined_count + max(curr.rx_count, curr.tx_count);
 	for (i = from_channel; i < to_channel; i++)
-		if (xdp_get_xsk_pool_from_qid(dev, i))
+		if (xsk_get_pool_from_qid(dev, i))
 			return -EINVAL;
 
 	ret = dev->ethtool_ops->set_channels(dev, &channels);
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 0b5f3b0..adde4d5 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -51,9 +51,9 @@ void xdp_del_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
  * not know if the device has more tx queues than rx, or the opposite.
  * This might also change during run time.
  */
-static int xdp_reg_xsk_pool_at_qid(struct net_device *dev,
-				   struct xsk_buff_pool *pool,
-				   u16 queue_id)
+static int xsk_reg_pool_at_qid(struct net_device *dev,
+			       struct xsk_buff_pool *pool,
+			       u16 queue_id)
 {
 	if (queue_id >= max_t(unsigned int,
 			      dev->real_num_rx_queues,
@@ -68,8 +68,8 @@ static int xdp_reg_xsk_pool_at_qid(struct net_device *dev,
 	return 0;
 }
 
-struct xsk_buff_pool *xdp_get_xsk_pool_from_qid(struct net_device *dev,
-						u16 queue_id)
+struct xsk_buff_pool *xsk_get_pool_from_qid(struct net_device *dev,
+					    u16 queue_id)
 {
 	if (queue_id < dev->real_num_rx_queues)
 		return dev->_rx[queue_id].pool;
@@ -78,9 +78,9 @@ struct xsk_buff_pool *xdp_get_xsk_pool_from_qid(struct net_device *dev,
 
 	return NULL;
 }
-EXPORT_SYMBOL(xdp_get_xsk_pool_from_qid);
+EXPORT_SYMBOL(xsk_get_pool_from_qid);
 
-static void xdp_clear_xsk_pool_at_qid(struct net_device *dev, u16 queue_id)
+static void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id)
 {
 	if (queue_id < dev->real_num_rx_queues)
 		dev->_rx[queue_id].pool = NULL;
@@ -103,10 +103,10 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 	if (force_zc && force_copy)
 		return -EINVAL;
 
-	if (xdp_get_xsk_pool_from_qid(dev, queue_id))
+	if (xsk_get_pool_from_qid(dev, queue_id))
 		return -EBUSY;
 
-	err = xdp_reg_xsk_pool_at_qid(dev, umem->pool, queue_id);
+	err = xsk_reg_pool_at_qid(dev, umem->pool, queue_id);
 	if (err)
 		return err;
 
@@ -119,7 +119,7 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 		 * Also for supporting drivers that do not implement this
 		 * feature. They will always have to call sendto().
 		 */
-		xsk_set_tx_need_wakeup(umem);
+		xsk_set_tx_need_wakeup(umem->pool);
 	}
 
 	dev_hold(dev);
@@ -148,7 +148,7 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 	if (!force_zc)
 		err = 0; /* fallback to copy mode */
 	if (err)
-		xdp_clear_xsk_pool_at_qid(dev, queue_id);
+		xsk_clear_pool_at_qid(dev, queue_id);
 	return err;
 }
 
@@ -173,7 +173,7 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
 			WARN(1, "failed to disable umem!\n");
 	}
 
-	xdp_clear_xsk_pool_at_qid(umem->dev, umem->queue_id);
+	xsk_clear_pool_at_qid(umem->dev, umem->queue_id);
 
 	dev_put(umem->dev);
 	umem->dev = NULL;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 3700266..7551f5b 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -39,8 +39,10 @@ bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
 		READ_ONCE(xs->umem->fq);
 }
 
-void xsk_set_rx_need_wakeup(struct xdp_umem *umem)
+void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
 {
+	struct xdp_umem *umem = pool->umem;
+
 	if (umem->need_wakeup & XDP_WAKEUP_RX)
 		return;
 
@@ -49,8 +51,9 @@ void xsk_set_rx_need_wakeup(struct xdp_umem *umem)
 }
 EXPORT_SYMBOL(xsk_set_rx_need_wakeup);
 
-void xsk_set_tx_need_wakeup(struct xdp_umem *umem)
+void xsk_set_tx_need_wakeup(struct xsk_buff_pool *pool)
 {
+	struct xdp_umem *umem = pool->umem;
 	struct xdp_sock *xs;
 
 	if (umem->need_wakeup & XDP_WAKEUP_TX)
@@ -66,8 +69,10 @@ void xsk_set_tx_need_wakeup(struct xdp_umem *umem)
 }
 EXPORT_SYMBOL(xsk_set_tx_need_wakeup);
 
-void xsk_clear_rx_need_wakeup(struct xdp_umem *umem)
+void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool)
 {
+	struct xdp_umem *umem = pool->umem;
+
 	if (!(umem->need_wakeup & XDP_WAKEUP_RX))
 		return;
 
@@ -76,8 +81,9 @@ void xsk_clear_rx_need_wakeup(struct xdp_umem *umem)
 }
 EXPORT_SYMBOL(xsk_clear_rx_need_wakeup);
 
-void xsk_clear_tx_need_wakeup(struct xdp_umem *umem)
+void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool)
 {
+	struct xdp_umem *umem = pool->umem;
 	struct xdp_sock *xs;
 
 	if (!(umem->need_wakeup & XDP_WAKEUP_TX))
@@ -93,11 +99,11 @@ void xsk_clear_tx_need_wakeup(struct xdp_umem *umem)
 }
 EXPORT_SYMBOL(xsk_clear_tx_need_wakeup);
 
-bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem)
+bool xsk_uses_need_wakeup(struct xsk_buff_pool *pool)
 {
-	return umem->flags & XDP_UMEM_USES_NEED_WAKEUP;
+	return pool->umem->flags & XDP_UMEM_USES_NEED_WAKEUP;
 }
-EXPORT_SYMBOL(xsk_umem_uses_need_wakeup);
+EXPORT_SYMBOL(xsk_uses_need_wakeup);
 
 void xp_release(struct xdp_buff_xsk *xskb)
 {
@@ -155,12 +161,12 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
 	struct xdp_buff *xsk_xdp;
 	int err;
 
-	if (len > xsk_umem_get_rx_frame_size(xs->umem)) {
+	if (len > xsk_pool_get_rx_frame_size(xs->pool)) {
 		xs->rx_dropped++;
 		return -ENOSPC;
 	}
 
-	xsk_xdp = xsk_buff_alloc(xs->umem);
+	xsk_xdp = xsk_buff_alloc(xs->pool);
 	if (!xsk_xdp) {
 		xs->rx_dropped++;
 		return -ENOSPC;
@@ -249,27 +255,28 @@ void __xsk_map_flush(void)
 	}
 }
 
-void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries)
+void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries)
 {
-	xskq_prod_submit_n(umem->cq, nb_entries);
+	xskq_prod_submit_n(pool->umem->cq, nb_entries);
 }
-EXPORT_SYMBOL(xsk_umem_complete_tx);
+EXPORT_SYMBOL(xsk_tx_completed);
 
-void xsk_umem_consume_tx_done(struct xdp_umem *umem)
+void xsk_tx_release(struct xsk_buff_pool *pool)
 {
 	struct xdp_sock *xs;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
+	list_for_each_entry_rcu(xs, &pool->umem->xsk_tx_list, list) {
 		__xskq_cons_release(xs->tx);
 		xs->sk.sk_write_space(&xs->sk);
 	}
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(xsk_umem_consume_tx_done);
+EXPORT_SYMBOL(xsk_tx_release);
 
-bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
+bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 {
+	struct xdp_umem *umem = pool->umem;
 	struct xdp_sock *xs;
 
 	rcu_read_lock();
@@ -294,7 +301,7 @@ bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
 	rcu_read_unlock();
 	return false;
 }
-EXPORT_SYMBOL(xsk_umem_consume_tx);
+EXPORT_SYMBOL(xsk_tx_peek_desc);
 
 static int xsk_wakeup(struct xdp_sock *xs, u8 flags)
 {
@@ -357,7 +364,7 @@ static int xsk_generic_xmit(struct sock *sk)
 
 		skb_put(skb, len);
 		addr = desc.addr;
-		buffer = xsk_buff_raw_get_data(xs->umem, addr);
+		buffer = xsk_buff_raw_get_data(xs->pool, addr);
 		err = skb_store_bits(skb, 0, buffer, len);
 		/* This is the backpressure mechanism for the Tx path.
 		 * Reserve space in the completion queue and only proceed
@@ -758,6 +765,8 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			return PTR_ERR(umem);
 		}
 
+		xs->pool = umem->pool;
+
 		/* Make sure umem is ready before it can be seen by others */
 		smp_wmb();
 		WRITE_ONCE(xs->umem, umem);
-- 
2.7.4

