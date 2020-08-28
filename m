Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5482B255663
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 10:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgH1I1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 04:27:22 -0400
Received: from mga03.intel.com ([134.134.136.65]:23538 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbgH1I0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 04:26:52 -0400
IronPort-SDR: 1VO0cBSDby3F/Mr+OQjunefaCe24a0/t+/FGlgyDmHLZUckgt9AlgRXrJbMki7d+EVcDy2fkcK
 vZ8J0J4+8wQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="156633920"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="156633920"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:26:42 -0700
IronPort-SDR: jY/wPhVinfCZLcnRKs0yrLCHwdRg8LVnlBicO1qMoB9v58jZEryV4EUtTEkUbxXgXZYefrzYod
 pMtyEBZQXlEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="444762442"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.36.33])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2020 01:26:36 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v5 01/15] xsk: i40e: ice: ixgbe: mlx5: pass buffer pool to driver instead of umem
Date:   Fri, 28 Aug 2020 10:26:15 +0200
Message-Id: <1598603189-32145-2-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
References: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the explicit umem reference passed to the driver in AF_XDP
zero-copy mode with the buffer pool instead. This in preparation for
extending the functionality of the zero-copy mode so that umems can be
shared between queues on the same netdev and also between netdevs. In
this commit, only an umem reference has been added to the buffer pool
struct. But later commits will add other entities to it. These are
going to be entities that are different between different queue ids
and netdevs even though the umem is shared between them.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  29 +--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  81 ++++----
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |   4 +-
 drivers/net/ethernet/intel/ice/ice.h               |  18 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |  16 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   8 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           | 136 ++++++-------
 drivers/net/ethernet/intel/ice/ice_xsk.h           |   7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  34 ++--
 .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |   7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  61 +++---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  | 217 +++++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.h  |  27 +++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.h |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c  | 217 ---------------------
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h  |  29 ---
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  49 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  16 +-
 include/linux/netdevice.h                          |  10 +-
 include/net/xdp_sock_drv.h                         |   7 +-
 include/net/xsk_buff_pool.h                        |   4 +-
 net/ethtool/channels.c                             |   2 +-
 net/ethtool/ioctl.c                                |   2 +-
 net/xdp/xdp_umem.c                                 |  45 ++---
 net/xdp/xsk_buff_pool.c                            |   5 +-
 41 files changed, 575 insertions(+), 560 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 825c104..dc15771 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1967,7 +1967,7 @@ static int i40e_set_ringparam(struct net_device *netdev,
 	    (new_rx_count == vsi->rx_rings[0]->count))
 		return 0;
 
-	/* If there is a AF_XDP UMEM attached to any of Rx rings,
+	/* If there is a AF_XDP page pool attached to any of Rx rings,
 	 * disallow changing the number of descriptors -- regardless
 	 * if the netdev is running or not.
 	 */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2e433fd..cbf2a44 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3122,12 +3122,12 @@ static void i40e_config_xps_tx_ring(struct i40e_ring *ring)
 }
 
 /**
- * i40e_xsk_umem - Retrieve the AF_XDP ZC if XDP and ZC is enabled
+ * i40e_xsk_pool - Retrieve the AF_XDP buffer pool if XDP and ZC is enabled
  * @ring: The Tx or Rx ring
  *
- * Returns the UMEM or NULL.
+ * Returns the AF_XDP buffer pool or NULL.
  **/
-static struct xdp_umem *i40e_xsk_umem(struct i40e_ring *ring)
+static struct xsk_buff_pool *i40e_xsk_pool(struct i40e_ring *ring)
 {
 	bool xdp_on = i40e_enabled_xdp_vsi(ring->vsi);
 	int qid = ring->queue_index;
@@ -3138,7 +3138,7 @@ static struct xdp_umem *i40e_xsk_umem(struct i40e_ring *ring)
 	if (!xdp_on || !test_bit(qid, ring->vsi->af_xdp_zc_qps))
 		return NULL;
 
-	return xdp_get_umem_from_qid(ring->vsi->netdev, qid);
+	return xdp_get_xsk_pool_from_qid(ring->vsi->netdev, qid);
 }
 
 /**
@@ -3157,7 +3157,7 @@ static int i40e_configure_tx_ring(struct i40e_ring *ring)
 	u32 qtx_ctl = 0;
 
 	if (ring_is_xdp(ring))
-		ring->xsk_umem = i40e_xsk_umem(ring);
+		ring->xsk_pool = i40e_xsk_pool(ring);
 
 	/* some ATR related tx ring init */
 	if (vsi->back->flags & I40E_FLAG_FD_ATR_ENABLED) {
@@ -3280,12 +3280,13 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 		xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
 
 	kfree(ring->rx_bi);
-	ring->xsk_umem = i40e_xsk_umem(ring);
-	if (ring->xsk_umem) {
+	ring->xsk_pool = i40e_xsk_pool(ring);
+	if (ring->xsk_pool) {
 		ret = i40e_alloc_rx_bi_zc(ring);
 		if (ret)
 			return ret;
-		ring->rx_buf_len = xsk_umem_get_rx_frame_size(ring->xsk_umem);
+		ring->rx_buf_len =
+		  xsk_umem_get_rx_frame_size(ring->xsk_pool->umem);
 		/* For AF_XDP ZC, we disallow packets to span on
 		 * multiple buffers, thus letting us skip that
 		 * handling in the fast-path.
@@ -3368,8 +3369,8 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	ring->tail = hw->hw_addr + I40E_QRX_TAIL(pf_q);
 	writel(0, ring->tail);
 
-	if (ring->xsk_umem) {
-		xsk_buff_set_rxq_info(ring->xsk_umem, &ring->xdp_rxq);
+	if (ring->xsk_pool) {
+		xsk_buff_set_rxq_info(ring->xsk_pool->umem, &ring->xdp_rxq);
 		ok = i40e_alloc_rx_buffers_zc(ring, I40E_DESC_UNUSED(ring));
 	} else {
 		ok = !i40e_alloc_rx_buffers(ring, I40E_DESC_UNUSED(ring));
@@ -3380,7 +3381,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 		 */
 		dev_info(&vsi->back->pdev->dev,
 			 "Failed to allocate some buffers on %sRx ring %d (pf_q %d)\n",
-			 ring->xsk_umem ? "UMEM enabled " : "",
+			 ring->xsk_pool ? "AF_XDP ZC enabled " : "",
 			 ring->queue_index, pf_q);
 	}
 
@@ -12644,7 +12645,7 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
 	 */
 	if (need_reset && prog)
 		for (i = 0; i < vsi->num_queue_pairs; i++)
-			if (vsi->xdp_rings[i]->xsk_umem)
+			if (vsi->xdp_rings[i]->xsk_pool)
 				(void)i40e_xsk_wakeup(vsi->netdev, i,
 						      XDP_WAKEUP_RX);
 
@@ -12923,8 +12924,8 @@ static int i40e_xdp(struct net_device *dev,
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return i40e_xdp_setup(vsi, xdp->prog);
-	case XDP_SETUP_XSK_UMEM:
-		return i40e_xsk_umem_setup(vsi, xdp->xsk.umem,
+	case XDP_SETUP_XSK_POOL:
+		return i40e_xsk_pool_setup(vsi, xdp->xsk.pool,
 					   xdp->xsk.queue_id);
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 3e5c566..f14bfc3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -636,7 +636,7 @@ void i40e_clean_tx_ring(struct i40e_ring *tx_ring)
 	unsigned long bi_size;
 	u16 i;
 
-	if (ring_is_xdp(tx_ring) && tx_ring->xsk_umem) {
+	if (ring_is_xdp(tx_ring) && tx_ring->xsk_pool) {
 		i40e_xsk_clean_tx_ring(tx_ring);
 	} else {
 		/* ring already cleared, nothing to do */
@@ -1335,7 +1335,7 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 		rx_ring->skb = NULL;
 	}
 
-	if (rx_ring->xsk_umem) {
+	if (rx_ring->xsk_pool) {
 		i40e_xsk_clean_rx_ring(rx_ring);
 		goto skip_free;
 	}
@@ -1369,7 +1369,7 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 	}
 
 skip_free:
-	if (rx_ring->xsk_umem)
+	if (rx_ring->xsk_pool)
 		i40e_clear_rx_bi_zc(rx_ring);
 	else
 		i40e_clear_rx_bi(rx_ring);
@@ -2579,7 +2579,7 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 	 * budget and be more aggressive about cleaning up the Tx descriptors.
 	 */
 	i40e_for_each_ring(ring, q_vector->tx) {
-		bool wd = ring->xsk_umem ?
+		bool wd = ring->xsk_pool ?
 			  i40e_clean_xdp_tx_irq(vsi, ring) :
 			  i40e_clean_tx_irq(vsi, ring, budget);
 
@@ -2607,7 +2607,7 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 		budget_per_ring = budget;
 
 	i40e_for_each_ring(ring, q_vector->rx) {
-		int cleaned = ring->xsk_umem ?
+		int cleaned = ring->xsk_pool ?
 			      i40e_clean_rx_irq_zc(ring, budget_per_ring) :
 			      i40e_clean_rx_irq(ring, budget_per_ring);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 4036893..703b644 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -388,7 +388,7 @@ struct i40e_ring {
 
 	struct i40e_channel *ch;
 	struct xdp_rxq_info xdp_rxq;
-	struct xdp_umem *xsk_umem;
+	struct xsk_buff_pool *xsk_pool;
 } ____cacheline_internodealigned_in_smp;
 
 static inline bool ring_uses_build_skb(struct i40e_ring *ring)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 8ce57b5..00e9fe6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -29,14 +29,16 @@ static struct xdp_buff **i40e_rx_bi(struct i40e_ring *rx_ring, u32 idx)
 }
 
 /**
- * i40e_xsk_umem_enable - Enable/associate a UMEM to a certain ring/qid
+ * i40e_xsk_pool_enable - Enable/associate an AF_XDP buffer pool to a
+ * certain ring/qid
  * @vsi: Current VSI
- * @umem: UMEM
- * @qid: Rx ring to associate UMEM to
+ * @pool: buffer pool
+ * @qid: Rx ring to associate buffer pool with
  *
  * Returns 0 on success, <0 on failure
  **/
-static int i40e_xsk_umem_enable(struct i40e_vsi *vsi, struct xdp_umem *umem,
+static int i40e_xsk_pool_enable(struct i40e_vsi *vsi,
+				struct xsk_buff_pool *pool,
 				u16 qid)
 {
 	struct net_device *netdev = vsi->netdev;
@@ -53,7 +55,8 @@ static int i40e_xsk_umem_enable(struct i40e_vsi *vsi, struct xdp_umem *umem,
 	    qid >= netdev->real_num_tx_queues)
 		return -EINVAL;
 
-	err = xsk_buff_dma_map(umem, &vsi->back->pdev->dev, I40E_RX_DMA_ATTR);
+	err = xsk_buff_dma_map(pool->umem, &vsi->back->pdev->dev,
+			       I40E_RX_DMA_ATTR);
 	if (err)
 		return err;
 
@@ -80,21 +83,22 @@ static int i40e_xsk_umem_enable(struct i40e_vsi *vsi, struct xdp_umem *umem,
 }
 
 /**
- * i40e_xsk_umem_disable - Disassociate a UMEM from a certain ring/qid
+ * i40e_xsk_pool_disable - Disassociate an AF_XDP buffer pool from a
+ * certain ring/qid
  * @vsi: Current VSI
- * @qid: Rx ring to associate UMEM to
+ * @qid: Rx ring to associate buffer pool with
  *
  * Returns 0 on success, <0 on failure
  **/
-static int i40e_xsk_umem_disable(struct i40e_vsi *vsi, u16 qid)
+static int i40e_xsk_pool_disable(struct i40e_vsi *vsi, u16 qid)
 {
 	struct net_device *netdev = vsi->netdev;
-	struct xdp_umem *umem;
+	struct xsk_buff_pool *pool;
 	bool if_running;
 	int err;
 
-	umem = xdp_get_umem_from_qid(netdev, qid);
-	if (!umem)
+	pool = xdp_get_xsk_pool_from_qid(netdev, qid);
+	if (!pool)
 		return -EINVAL;
 
 	if_running = netif_running(vsi->netdev) && i40e_enabled_xdp_vsi(vsi);
@@ -106,7 +110,7 @@ static int i40e_xsk_umem_disable(struct i40e_vsi *vsi, u16 qid)
 	}
 
 	clear_bit(qid, vsi->af_xdp_zc_qps);
-	xsk_buff_dma_unmap(umem, I40E_RX_DMA_ATTR);
+	xsk_buff_dma_unmap(pool->umem, I40E_RX_DMA_ATTR);
 
 	if (if_running) {
 		err = i40e_queue_pair_enable(vsi, qid);
@@ -118,20 +122,21 @@ static int i40e_xsk_umem_disable(struct i40e_vsi *vsi, u16 qid)
 }
 
 /**
- * i40e_xsk_umem_setup - Enable/disassociate a UMEM to/from a ring/qid
+ * i40e_xsk_pool_setup - Enable/disassociate an AF_XDP buffer pool to/from
+ * a ring/qid
  * @vsi: Current VSI
- * @umem: UMEM to enable/associate to a ring, or NULL to disable
- * @qid: Rx ring to (dis)associate UMEM (from)to
+ * @pool: Buffer pool to enable/associate to a ring, or NULL to disable
+ * @qid: Rx ring to (dis)associate buffer pool (from)to
  *
- * This function enables or disables a UMEM to a certain ring.
+ * This function enables or disables a buffer pool to a certain ring.
  *
  * Returns 0 on success, <0 on failure
  **/
-int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
+int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
 			u16 qid)
 {
-	return umem ? i40e_xsk_umem_enable(vsi, umem, qid) :
-		i40e_xsk_umem_disable(vsi, qid);
+	return pool ? i40e_xsk_pool_enable(vsi, pool, qid) :
+		i40e_xsk_pool_disable(vsi, qid);
 }
 
 /**
@@ -191,7 +196,7 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 	rx_desc = I40E_RX_DESC(rx_ring, ntu);
 	bi = i40e_rx_bi(rx_ring, ntu);
 	do {
-		xdp = xsk_buff_alloc(rx_ring->xsk_umem);
+		xdp = xsk_buff_alloc(rx_ring->xsk_pool->umem);
 		if (!xdp) {
 			ok = false;
 			goto no_buffers;
@@ -358,11 +363,11 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
-	if (xsk_umem_uses_need_wakeup(rx_ring->xsk_umem)) {
+	if (xsk_umem_uses_need_wakeup(rx_ring->xsk_pool->umem)) {
 		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
-			xsk_set_rx_need_wakeup(rx_ring->xsk_umem);
+			xsk_set_rx_need_wakeup(rx_ring->xsk_pool->umem);
 		else
-			xsk_clear_rx_need_wakeup(rx_ring->xsk_umem);
+			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool->umem);
 
 		return (int)total_rx_packets;
 	}
@@ -385,11 +390,12 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 	dma_addr_t dma;
 
 	while (budget-- > 0) {
-		if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &desc))
+		if (!xsk_umem_consume_tx(xdp_ring->xsk_pool->umem, &desc))
 			break;
 
-		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_umem, desc.addr);
-		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_umem, dma,
+		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool->umem,
+					   desc.addr);
+		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool->umem, dma,
 						 desc.len);
 
 		tx_bi = &xdp_ring->tx_bi[xdp_ring->next_to_use];
@@ -416,7 +422,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 						 I40E_TXD_QW1_CMD_SHIFT);
 		i40e_xdp_ring_update_tail(xdp_ring);
 
-		xsk_umem_consume_tx_done(xdp_ring->xsk_umem);
+		xsk_umem_consume_tx_done(xdp_ring->xsk_pool->umem);
 		i40e_update_tx_stats(xdp_ring, sent_frames, total_bytes);
 	}
 
@@ -448,7 +454,7 @@ static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
  **/
 bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
 {
-	struct xdp_umem *umem = tx_ring->xsk_umem;
+	struct xsk_buff_pool *bp = tx_ring->xsk_pool;
 	u32 i, completed_frames, xsk_frames = 0;
 	u32 head_idx = i40e_get_head(tx_ring);
 	struct i40e_tx_buffer *tx_bi;
@@ -488,13 +494,13 @@ bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
 		tx_ring->next_to_clean -= tx_ring->count;
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(umem, xsk_frames);
+		xsk_umem_complete_tx(bp->umem, xsk_frames);
 
 	i40e_arm_wb(tx_ring, vsi, completed_frames);
 
 out_xmit:
-	if (xsk_umem_uses_need_wakeup(tx_ring->xsk_umem))
-		xsk_set_tx_need_wakeup(tx_ring->xsk_umem);
+	if (xsk_umem_uses_need_wakeup(tx_ring->xsk_pool->umem))
+		xsk_set_tx_need_wakeup(tx_ring->xsk_pool->umem);
 
 	return i40e_xmit_zc(tx_ring, I40E_DESC_UNUSED(tx_ring));
 }
@@ -526,7 +532,7 @@ int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 	if (queue_id >= vsi->num_queue_pairs)
 		return -ENXIO;
 
-	if (!vsi->xdp_rings[queue_id]->xsk_umem)
+	if (!vsi->xdp_rings[queue_id]->xsk_pool)
 		return -ENXIO;
 
 	ring = vsi->xdp_rings[queue_id];
@@ -565,7 +571,7 @@ void i40e_xsk_clean_rx_ring(struct i40e_ring *rx_ring)
 void i40e_xsk_clean_tx_ring(struct i40e_ring *tx_ring)
 {
 	u16 ntc = tx_ring->next_to_clean, ntu = tx_ring->next_to_use;
-	struct xdp_umem *umem = tx_ring->xsk_umem;
+	struct xsk_buff_pool *bp = tx_ring->xsk_pool;
 	struct i40e_tx_buffer *tx_bi;
 	u32 xsk_frames = 0;
 
@@ -585,14 +591,15 @@ void i40e_xsk_clean_tx_ring(struct i40e_ring *tx_ring)
 	}
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(umem, xsk_frames);
+		xsk_umem_complete_tx(bp->umem, xsk_frames);
 }
 
 /**
- * i40e_xsk_any_rx_ring_enabled - Checks if Rx rings have AF_XDP UMEM attached
+ * i40e_xsk_any_rx_ring_enabled - Checks if Rx rings have an AF_XDP
+ * buffer pool attached
  * @vsi: vsi
  *
- * Returns true if any of the Rx rings has an AF_XDP UMEM attached
+ * Returns true if any of the Rx rings has an AF_XDP buffer pool attached
  **/
 bool i40e_xsk_any_rx_ring_enabled(struct i40e_vsi *vsi)
 {
@@ -600,7 +607,7 @@ bool i40e_xsk_any_rx_ring_enabled(struct i40e_vsi *vsi)
 	int i;
 
 	for (i = 0; i < vsi->num_queue_pairs; i++) {
-		if (xdp_get_umem_from_qid(netdev, i))
+		if (xdp_get_xsk_pool_from_qid(netdev, i))
 			return true;
 	}
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
index c524c14..7adfd85 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
@@ -5,12 +5,12 @@
 #define _I40E_XSK_H_
 
 struct i40e_vsi;
-struct xdp_umem;
+struct xsk_buff_pool;
 struct zero_copy_allocator;
 
 int i40e_queue_pair_disable(struct i40e_vsi *vsi, int queue_pair);
 int i40e_queue_pair_enable(struct i40e_vsi *vsi, int queue_pair);
-int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
+int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
 			u16 qid);
 bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 cleaned_count);
 int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index fe140ff..65583f0 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -321,9 +321,9 @@ struct ice_vsi {
 	struct ice_ring **xdp_rings;	 /* XDP ring array */
 	u16 num_xdp_txq;		 /* Used XDP queues */
 	u8 xdp_mapping_mode;		 /* ICE_MAP_MODE_[CONTIG|SCATTER] */
-	struct xdp_umem **xsk_umems;
-	u16 num_xsk_umems_used;
-	u16 num_xsk_umems;
+	struct xsk_buff_pool **xsk_pools;
+	u16 num_xsk_pools_used;
+	u16 num_xsk_pools;
 } ____cacheline_internodealigned_in_smp;
 
 /* struct that defines an interrupt vector */
@@ -507,25 +507,25 @@ static inline void ice_set_ring_xdp(struct ice_ring *ring)
 }
 
 /**
- * ice_xsk_umem - get XDP UMEM bound to a ring
+ * ice_xsk_pool - get XSK buffer pool bound to a ring
  * @ring - ring to use
  *
- * Returns a pointer to xdp_umem structure if there is an UMEM present,
+ * Returns a pointer to xdp_umem structure if there is a buffer pool present,
  * NULL otherwise.
  */
-static inline struct xdp_umem *ice_xsk_umem(struct ice_ring *ring)
+static inline struct xsk_buff_pool *ice_xsk_pool(struct ice_ring *ring)
 {
-	struct xdp_umem **umems = ring->vsi->xsk_umems;
+	struct xsk_buff_pool **pools = ring->vsi->xsk_pools;
 	u16 qid = ring->q_index;
 
 	if (ice_ring_is_xdp(ring))
 		qid -= ring->vsi->num_xdp_txq;
 
-	if (qid >= ring->vsi->num_xsk_umems || !umems || !umems[qid] ||
+	if (qid >= ring->vsi->num_xsk_pools || !pools || !pools[qid] ||
 	    !ice_is_xdp_ena_vsi(ring->vsi))
 		return NULL;
 
-	return umems[qid];
+	return pools[qid];
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 8700847..3c92448 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -308,12 +308,12 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 			xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 					 ring->q_index);
 
-		ring->xsk_umem = ice_xsk_umem(ring);
-		if (ring->xsk_umem) {
+		ring->xsk_pool = ice_xsk_pool(ring);
+		if (ring->xsk_pool) {
 			xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
 
 			ring->rx_buf_len =
-				xsk_umem_get_rx_frame_size(ring->xsk_umem);
+				xsk_umem_get_rx_frame_size(ring->xsk_pool->umem);
 			/* For AF_XDP ZC, we disallow packets to span on
 			 * multiple buffers, thus letting us skip that
 			 * handling in the fast-path.
@@ -324,7 +324,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 							 NULL);
 			if (err)
 				return err;
-			xsk_buff_set_rxq_info(ring->xsk_umem, &ring->xdp_rxq);
+			xsk_buff_set_rxq_info(ring->xsk_pool->umem, &ring->xdp_rxq);
 
 			dev_info(dev, "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
 				 ring->q_index);
@@ -417,9 +417,9 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	ring->tail = hw->hw_addr + QRX_TAIL(pf_q);
 	writel(0, ring->tail);
 
-	if (ring->xsk_umem) {
-		if (!xsk_buff_can_alloc(ring->xsk_umem, num_bufs)) {
-			dev_warn(dev, "UMEM does not provide enough addresses to fill %d buffers on Rx ring %d\n",
+	if (ring->xsk_pool) {
+		if (!xsk_buff_can_alloc(ring->xsk_pool->umem, num_bufs)) {
+			dev_warn(dev, "XSK buffer pool does not provide enough addresses to fill %d buffers on Rx ring %d\n",
 				 num_bufs, ring->q_index);
 			dev_warn(dev, "Change Rx ring/fill queue size to avoid performance issues\n");
 
@@ -428,7 +428,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 
 		err = ice_alloc_rx_bufs_zc(ring, num_bufs);
 		if (err)
-			dev_info(dev, "Failed to allocate some buffers on UMEM enabled Rx ring %d (pf_q %d)\n",
+			dev_info(dev, "Failed to allocate some buffers on XSK buffer pool enabled Rx ring %d (pf_q %d)\n",
 				 ring->q_index, pf_q);
 		return 0;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index f268277..feeb5cd 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1743,7 +1743,7 @@ int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi)
 		return ret;
 
 	for (i = 0; i < vsi->num_xdp_txq; i++)
-		vsi->xdp_rings[i]->xsk_umem = ice_xsk_umem(vsi->xdp_rings[i]);
+		vsi->xdp_rings[i]->xsk_pool = ice_xsk_pool(vsi->xdp_rings[i]);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4634b48..2297ee7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2273,7 +2273,7 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 		if (ice_setup_tx_ring(xdp_ring))
 			goto free_xdp_rings;
 		ice_set_ring_xdp(xdp_ring);
-		xdp_ring->xsk_umem = ice_xsk_umem(xdp_ring);
+		xdp_ring->xsk_pool = ice_xsk_pool(xdp_ring);
 	}
 
 	return 0;
@@ -2517,13 +2517,13 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	if (if_running)
 		ret = ice_up(vsi);
 
-	if (!ret && prog && vsi->xsk_umems) {
+	if (!ret && prog && vsi->xsk_pools) {
 		int i;
 
 		ice_for_each_rxq(vsi, i) {
 			struct ice_ring *rx_ring = vsi->rx_rings[i];
 
-			if (rx_ring->xsk_umem)
+			if (rx_ring->xsk_pool)
 				napi_schedule(&rx_ring->q_vector->napi);
 		}
 	}
@@ -2549,8 +2549,8 @@ static int ice_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return ice_xdp_setup_prog(vsi, xdp->prog, xdp->extack);
-	case XDP_SETUP_XSK_UMEM:
-		return ice_xsk_umem_setup(vsi, xdp->xsk.umem,
+	case XDP_SETUP_XSK_POOL:
+		return ice_xsk_pool_setup(vsi, xdp->xsk.pool,
 					  xdp->xsk.queue_id);
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 9d0d6b0..b061dc10 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -145,7 +145,7 @@ void ice_clean_tx_ring(struct ice_ring *tx_ring)
 {
 	u16 i;
 
-	if (ice_ring_is_xdp(tx_ring) && tx_ring->xsk_umem) {
+	if (ice_ring_is_xdp(tx_ring) && tx_ring->xsk_pool) {
 		ice_xsk_clean_xdp_ring(tx_ring);
 		goto tx_skip_free;
 	}
@@ -375,7 +375,7 @@ void ice_clean_rx_ring(struct ice_ring *rx_ring)
 	if (!rx_ring->rx_buf)
 		return;
 
-	if (rx_ring->xsk_umem) {
+	if (rx_ring->xsk_pool) {
 		ice_xsk_clean_rx_ring(rx_ring);
 		goto rx_skip_free;
 	}
@@ -1616,7 +1616,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	 * budget and be more aggressive about cleaning up the Tx descriptors.
 	 */
 	ice_for_each_ring(ring, q_vector->tx) {
-		bool wd = ring->xsk_umem ?
+		bool wd = ring->xsk_pool ?
 			  ice_clean_tx_irq_zc(ring, budget) :
 			  ice_clean_tx_irq(ring, budget);
 
@@ -1646,7 +1646,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 		 * comparison in the irq context instead of many inside the
 		 * ice_clean_rx_irq function and makes the codebase cleaner.
 		 */
-		cleaned = ring->xsk_umem ?
+		cleaned = ring->xsk_pool ?
 			  ice_clean_rx_irq_zc(ring, budget_per_ring) :
 			  ice_clean_rx_irq(ring, budget_per_ring);
 		work_done += cleaned;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 51b4df7..e9f60d5 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -295,7 +295,7 @@ struct ice_ring {
 
 	struct rcu_head rcu;		/* to avoid race on free */
 	struct bpf_prog *xdp_prog;
-	struct xdp_umem *xsk_umem;
+	struct xsk_buff_pool *xsk_pool;
 	/* CL3 - 3rd cacheline starts here */
 	struct xdp_rxq_info xdp_rxq;
 	/* CLX - the below items are only accessed infrequently and should be
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 20ac5fc..8b70e8c 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -236,7 +236,7 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 		if (err)
 			goto free_buf;
 		ice_set_ring_xdp(xdp_ring);
-		xdp_ring->xsk_umem = ice_xsk_umem(xdp_ring);
+		xdp_ring->xsk_pool = ice_xsk_pool(xdp_ring);
 	}
 
 	err = ice_setup_rx_ctx(rx_ring);
@@ -260,21 +260,21 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 }
 
 /**
- * ice_xsk_alloc_umems - allocate a UMEM region for an XDP socket
- * @vsi: VSI to allocate the UMEM on
+ * ice_xsk_alloc_pools - allocate a buffer pool for an XDP socket
+ * @vsi: VSI to allocate the buffer pool on
  *
  * Returns 0 on success, negative on error
  */
-static int ice_xsk_alloc_umems(struct ice_vsi *vsi)
+static int ice_xsk_alloc_pools(struct ice_vsi *vsi)
 {
-	if (vsi->xsk_umems)
+	if (vsi->xsk_pools)
 		return 0;
 
-	vsi->xsk_umems = kcalloc(vsi->num_xsk_umems, sizeof(*vsi->xsk_umems),
+	vsi->xsk_pools = kcalloc(vsi->num_xsk_pools, sizeof(*vsi->xsk_pools),
 				 GFP_KERNEL);
 
-	if (!vsi->xsk_umems) {
-		vsi->num_xsk_umems = 0;
+	if (!vsi->xsk_pools) {
+		vsi->num_xsk_pools = 0;
 		return -ENOMEM;
 	}
 
@@ -282,73 +282,73 @@ static int ice_xsk_alloc_umems(struct ice_vsi *vsi)
 }
 
 /**
- * ice_xsk_remove_umem - Remove an UMEM for a certain ring/qid
+ * ice_xsk_remove_pool - Remove an buffer pool for a certain ring/qid
  * @vsi: VSI from which the VSI will be removed
- * @qid: Ring/qid associated with the UMEM
+ * @qid: Ring/qid associated with the buffer pool
  */
-static void ice_xsk_remove_umem(struct ice_vsi *vsi, u16 qid)
+static void ice_xsk_remove_pool(struct ice_vsi *vsi, u16 qid)
 {
-	vsi->xsk_umems[qid] = NULL;
-	vsi->num_xsk_umems_used--;
+	vsi->xsk_pools[qid] = NULL;
+	vsi->num_xsk_pools_used--;
 
-	if (vsi->num_xsk_umems_used == 0) {
-		kfree(vsi->xsk_umems);
-		vsi->xsk_umems = NULL;
-		vsi->num_xsk_umems = 0;
+	if (vsi->num_xsk_pools_used == 0) {
+		kfree(vsi->xsk_pools);
+		vsi->xsk_pools = NULL;
+		vsi->num_xsk_pools = 0;
 	}
 }
 
 /**
- * ice_xsk_umem_disable - disable a UMEM region
+ * ice_xsk_pool_disable - disable a buffer pool region
  * @vsi: Current VSI
  * @qid: queue ID
  *
  * Returns 0 on success, negative on failure
  */
-static int ice_xsk_umem_disable(struct ice_vsi *vsi, u16 qid)
+static int ice_xsk_pool_disable(struct ice_vsi *vsi, u16 qid)
 {
-	if (!vsi->xsk_umems || qid >= vsi->num_xsk_umems ||
-	    !vsi->xsk_umems[qid])
+	if (!vsi->xsk_pools || qid >= vsi->num_xsk_pools ||
+	    !vsi->xsk_pools[qid])
 		return -EINVAL;
 
-	xsk_buff_dma_unmap(vsi->xsk_umems[qid], ICE_RX_DMA_ATTR);
-	ice_xsk_remove_umem(vsi, qid);
+	xsk_buff_dma_unmap(vsi->xsk_pools[qid]->umem, ICE_RX_DMA_ATTR);
+	ice_xsk_remove_pool(vsi, qid);
 
 	return 0;
 }
 
 /**
- * ice_xsk_umem_enable - enable a UMEM region
+ * ice_xsk_pool_enable - enable a buffer pool region
  * @vsi: Current VSI
- * @umem: pointer to a requested UMEM region
+ * @pool: pointer to a requested buffer pool region
  * @qid: queue ID
  *
  * Returns 0 on success, negative on failure
  */
 static int
-ice_xsk_umem_enable(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
+ice_xsk_pool_enable(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 {
 	int err;
 
 	if (vsi->type != ICE_VSI_PF)
 		return -EINVAL;
 
-	if (!vsi->num_xsk_umems)
-		vsi->num_xsk_umems = min_t(u16, vsi->num_rxq, vsi->num_txq);
-	if (qid >= vsi->num_xsk_umems)
+	if (!vsi->num_xsk_pools)
+		vsi->num_xsk_pools = min_t(u16, vsi->num_rxq, vsi->num_txq);
+	if (qid >= vsi->num_xsk_pools)
 		return -EINVAL;
 
-	err = ice_xsk_alloc_umems(vsi);
+	err = ice_xsk_alloc_pools(vsi);
 	if (err)
 		return err;
 
-	if (vsi->xsk_umems && vsi->xsk_umems[qid])
+	if (vsi->xsk_pools && vsi->xsk_pools[qid])
 		return -EBUSY;
 
-	vsi->xsk_umems[qid] = umem;
-	vsi->num_xsk_umems_used++;
+	vsi->xsk_pools[qid] = pool;
+	vsi->num_xsk_pools_used++;
 
-	err = xsk_buff_dma_map(vsi->xsk_umems[qid], ice_pf_to_dev(vsi->back),
+	err = xsk_buff_dma_map(vsi->xsk_pools[qid]->umem, ice_pf_to_dev(vsi->back),
 			       ICE_RX_DMA_ATTR);
 	if (err)
 		return err;
@@ -357,17 +357,17 @@ ice_xsk_umem_enable(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
 }
 
 /**
- * ice_xsk_umem_setup - enable/disable a UMEM region depending on its state
+ * ice_xsk_pool_setup - enable/disable a buffer pool region depending on its state
  * @vsi: Current VSI
- * @umem: UMEM to enable/associate to a ring, NULL to disable
+ * @pool: buffer pool to enable/associate to a ring, NULL to disable
  * @qid: queue ID
  *
  * Returns 0 on success, negative on failure
  */
-int ice_xsk_umem_setup(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
+int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 {
-	bool if_running, umem_present = !!umem;
-	int ret = 0, umem_failure = 0;
+	bool if_running, pool_present = !!pool;
+	int ret = 0, pool_failure = 0;
 
 	if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
 
@@ -375,26 +375,26 @@ int ice_xsk_umem_setup(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid)
 		ret = ice_qp_dis(vsi, qid);
 		if (ret) {
 			netdev_err(vsi->netdev, "ice_qp_dis error = %d\n", ret);
-			goto xsk_umem_if_up;
+			goto xsk_pool_if_up;
 		}
 	}
 
-	umem_failure = umem_present ? ice_xsk_umem_enable(vsi, umem, qid) :
-				      ice_xsk_umem_disable(vsi, qid);
+	pool_failure = pool_present ? ice_xsk_pool_enable(vsi, pool, qid) :
+				      ice_xsk_pool_disable(vsi, qid);
 
-xsk_umem_if_up:
+xsk_pool_if_up:
 	if (if_running) {
 		ret = ice_qp_ena(vsi, qid);
-		if (!ret && umem_present)
+		if (!ret && pool_present)
 			napi_schedule(&vsi->xdp_rings[qid]->q_vector->napi);
 		else if (ret)
 			netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
 	}
 
-	if (umem_failure) {
-		netdev_err(vsi->netdev, "Could not %sable UMEM, error = %d\n",
-			   umem_present ? "en" : "dis", umem_failure);
-		return umem_failure;
+	if (pool_failure) {
+		netdev_err(vsi->netdev, "Could not %sable buffer pool, error = %d\n",
+			   pool_present ? "en" : "dis", pool_failure);
+		return pool_failure;
 	}
 
 	return ret;
@@ -425,7 +425,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 	rx_buf = &rx_ring->rx_buf[ntu];
 
 	do {
-		rx_buf->xdp = xsk_buff_alloc(rx_ring->xsk_umem);
+		rx_buf->xdp = xsk_buff_alloc(rx_ring->xsk_pool->umem);
 		if (!rx_buf->xdp) {
 			ret = true;
 			break;
@@ -645,11 +645,11 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 	ice_finalize_xdp_rx(rx_ring, xdp_xmit);
 	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
 
-	if (xsk_umem_uses_need_wakeup(rx_ring->xsk_umem)) {
+	if (xsk_umem_uses_need_wakeup(rx_ring->xsk_pool->umem)) {
 		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
-			xsk_set_rx_need_wakeup(rx_ring->xsk_umem);
+			xsk_set_rx_need_wakeup(rx_ring->xsk_pool->umem);
 		else
-			xsk_clear_rx_need_wakeup(rx_ring->xsk_umem);
+			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool->umem);
 
 		return (int)total_rx_packets;
 	}
@@ -682,11 +682,11 @@ static bool ice_xmit_zc(struct ice_ring *xdp_ring, int budget)
 
 		tx_buf = &xdp_ring->tx_buf[xdp_ring->next_to_use];
 
-		if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &desc))
+		if (!xsk_umem_consume_tx(xdp_ring->xsk_pool->umem, &desc))
 			break;
 
-		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_umem, desc.addr);
-		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_umem, dma,
+		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool->umem, desc.addr);
+		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool->umem, dma,
 						 desc.len);
 
 		tx_buf->bytecount = desc.len;
@@ -703,7 +703,7 @@ static bool ice_xmit_zc(struct ice_ring *xdp_ring, int budget)
 
 	if (tx_desc) {
 		ice_xdp_ring_update_tail(xdp_ring);
-		xsk_umem_consume_tx_done(xdp_ring->xsk_umem);
+		xsk_umem_consume_tx_done(xdp_ring->xsk_pool->umem);
 	}
 
 	return budget > 0 && work_done;
@@ -777,10 +777,10 @@ bool ice_clean_tx_irq_zc(struct ice_ring *xdp_ring, int budget)
 	xdp_ring->next_to_clean = ntc;
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(xdp_ring->xsk_umem, xsk_frames);
+		xsk_umem_complete_tx(xdp_ring->xsk_pool->umem, xsk_frames);
 
-	if (xsk_umem_uses_need_wakeup(xdp_ring->xsk_umem))
-		xsk_set_tx_need_wakeup(xdp_ring->xsk_umem);
+	if (xsk_umem_uses_need_wakeup(xdp_ring->xsk_pool->umem))
+		xsk_set_tx_need_wakeup(xdp_ring->xsk_pool->umem);
 
 	ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
 	xmit_done = ice_xmit_zc(xdp_ring, ICE_DFLT_IRQ_WORK);
@@ -814,7 +814,7 @@ ice_xsk_wakeup(struct net_device *netdev, u32 queue_id,
 	if (queue_id >= vsi->num_txq)
 		return -ENXIO;
 
-	if (!vsi->xdp_rings[queue_id]->xsk_umem)
+	if (!vsi->xdp_rings[queue_id]->xsk_pool)
 		return -ENXIO;
 
 	ring = vsi->xdp_rings[queue_id];
@@ -833,20 +833,20 @@ ice_xsk_wakeup(struct net_device *netdev, u32 queue_id,
 }
 
 /**
- * ice_xsk_any_rx_ring_ena - Checks if Rx rings have AF_XDP UMEM attached
+ * ice_xsk_any_rx_ring_ena - Checks if Rx rings have AF_XDP buff pool attached
  * @vsi: VSI to be checked
  *
- * Returns true if any of the Rx rings has an AF_XDP UMEM attached
+ * Returns true if any of the Rx rings has an AF_XDP buff pool attached
  */
 bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi)
 {
 	int i;
 
-	if (!vsi->xsk_umems)
+	if (!vsi->xsk_pools)
 		return false;
 
-	for (i = 0; i < vsi->num_xsk_umems; i++) {
-		if (vsi->xsk_umems[i])
+	for (i = 0; i < vsi->num_xsk_pools; i++) {
+		if (vsi->xsk_pools[i])
 			return true;
 	}
 
@@ -854,7 +854,7 @@ bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi)
 }
 
 /**
- * ice_xsk_clean_rx_ring - clean UMEM queues connected to a given Rx ring
+ * ice_xsk_clean_rx_ring - clean buffer pool queues connected to a given Rx ring
  * @rx_ring: ring to be cleaned
  */
 void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring)
@@ -872,7 +872,7 @@ void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring)
 }
 
 /**
- * ice_xsk_clean_xdp_ring - Clean the XDP Tx ring and its UMEM queues
+ * ice_xsk_clean_xdp_ring - Clean the XDP Tx ring and its buffer pool queues
  * @xdp_ring: XDP_Tx ring
  */
 void ice_xsk_clean_xdp_ring(struct ice_ring *xdp_ring)
@@ -896,5 +896,5 @@ void ice_xsk_clean_xdp_ring(struct ice_ring *xdp_ring)
 	}
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(xdp_ring->xsk_umem, xsk_frames);
+		xsk_umem_complete_tx(xdp_ring->xsk_pool->umem, xsk_frames);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
index fc1a06b..fad7836 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.h
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
@@ -9,7 +9,8 @@
 struct ice_vsi;
 
 #ifdef CONFIG_XDP_SOCKETS
-int ice_xsk_umem_setup(struct ice_vsi *vsi, struct xdp_umem *umem, u16 qid);
+int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool,
+		       u16 qid);
 int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget);
 bool ice_clean_tx_irq_zc(struct ice_ring *xdp_ring, int budget);
 int ice_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
@@ -19,8 +20,8 @@ void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring);
 void ice_xsk_clean_xdp_ring(struct ice_ring *xdp_ring);
 #else
 static inline int
-ice_xsk_umem_setup(struct ice_vsi __always_unused *vsi,
-		   struct xdp_umem __always_unused *umem,
+ice_xsk_pool_setup(struct ice_vsi __always_unused *vsi,
+		   struct xsk_buff_pool __always_unused *pool,
 		   u16 __always_unused qid)
 {
 	return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 1e8a809..de0fc6e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -350,7 +350,7 @@ struct ixgbe_ring {
 		struct ixgbe_rx_queue_stats rx_stats;
 	};
 	struct xdp_rxq_info xdp_rxq;
-	struct xdp_umem *xsk_umem;
+	struct xsk_buff_pool *xsk_pool;
 	u16 ring_idx;		/* {rx,tx,xdp}_ring back reference idx */
 	u16 rx_buf_len;
 } ____cacheline_internodealigned_in_smp;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 2f8a4cf..c498465 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -3156,7 +3156,7 @@ int ixgbe_poll(struct napi_struct *napi, int budget)
 #endif
 
 	ixgbe_for_each_ring(ring, q_vector->tx) {
-		bool wd = ring->xsk_umem ?
+		bool wd = ring->xsk_pool ?
 			  ixgbe_clean_xdp_tx_irq(q_vector, ring, budget) :
 			  ixgbe_clean_tx_irq(q_vector, ring, budget);
 
@@ -3176,7 +3176,7 @@ int ixgbe_poll(struct napi_struct *napi, int budget)
 		per_ring_budget = budget;
 
 	ixgbe_for_each_ring(ring, q_vector->rx) {
-		int cleaned = ring->xsk_umem ?
+		int cleaned = ring->xsk_pool ?
 			      ixgbe_clean_rx_irq_zc(q_vector, ring,
 						    per_ring_budget) :
 			      ixgbe_clean_rx_irq(q_vector, ring,
@@ -3471,9 +3471,9 @@ void ixgbe_configure_tx_ring(struct ixgbe_adapter *adapter,
 	u32 txdctl = IXGBE_TXDCTL_ENABLE;
 	u8 reg_idx = ring->reg_idx;
 
-	ring->xsk_umem = NULL;
+	ring->xsk_pool = NULL;
 	if (ring_is_xdp(ring))
-		ring->xsk_umem = ixgbe_xsk_umem(adapter, ring);
+		ring->xsk_pool = ixgbe_xsk_pool(adapter, ring);
 
 	/* disable queue to avoid issues while updating state */
 	IXGBE_WRITE_REG(hw, IXGBE_TXDCTL(reg_idx), 0);
@@ -3713,8 +3713,8 @@ static void ixgbe_configure_srrctl(struct ixgbe_adapter *adapter,
 	srrctl = IXGBE_RX_HDR_SIZE << IXGBE_SRRCTL_BSIZEHDRSIZE_SHIFT;
 
 	/* configure the packet buffer length */
-	if (rx_ring->xsk_umem) {
-		u32 xsk_buf_len = xsk_umem_get_rx_frame_size(rx_ring->xsk_umem);
+	if (rx_ring->xsk_pool) {
+		u32 xsk_buf_len = xsk_umem_get_rx_frame_size(rx_ring->xsk_pool->umem);
 
 		/* If the MAC support setting RXDCTL.RLPML, the
 		 * SRRCTL[n].BSIZEPKT is set to PAGE_SIZE and
@@ -4059,12 +4059,12 @@ void ixgbe_configure_rx_ring(struct ixgbe_adapter *adapter,
 	u8 reg_idx = ring->reg_idx;
 
 	xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
-	ring->xsk_umem = ixgbe_xsk_umem(adapter, ring);
-	if (ring->xsk_umem) {
+	ring->xsk_pool = ixgbe_xsk_pool(adapter, ring);
+	if (ring->xsk_pool) {
 		WARN_ON(xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 						   MEM_TYPE_XSK_BUFF_POOL,
 						   NULL));
-		xsk_buff_set_rxq_info(ring->xsk_umem, &ring->xdp_rxq);
+		xsk_buff_set_rxq_info(ring->xsk_pool->umem, &ring->xdp_rxq);
 	} else {
 		WARN_ON(xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 						   MEM_TYPE_PAGE_SHARED, NULL));
@@ -4119,8 +4119,8 @@ void ixgbe_configure_rx_ring(struct ixgbe_adapter *adapter,
 #endif
 	}
 
-	if (ring->xsk_umem && hw->mac.type != ixgbe_mac_82599EB) {
-		u32 xsk_buf_len = xsk_umem_get_rx_frame_size(ring->xsk_umem);
+	if (ring->xsk_pool && hw->mac.type != ixgbe_mac_82599EB) {
+		u32 xsk_buf_len = xsk_umem_get_rx_frame_size(ring->xsk_pool->umem);
 
 		rxdctl &= ~(IXGBE_RXDCTL_RLPMLMASK |
 			    IXGBE_RXDCTL_RLPML_EN);
@@ -4142,7 +4142,7 @@ void ixgbe_configure_rx_ring(struct ixgbe_adapter *adapter,
 	IXGBE_WRITE_REG(hw, IXGBE_RXDCTL(reg_idx), rxdctl);
 
 	ixgbe_rx_desc_queue_enable(adapter, ring);
-	if (ring->xsk_umem)
+	if (ring->xsk_pool)
 		ixgbe_alloc_rx_buffers_zc(ring, ixgbe_desc_unused(ring));
 	else
 		ixgbe_alloc_rx_buffers(ring, ixgbe_desc_unused(ring));
@@ -5292,7 +5292,7 @@ static void ixgbe_clean_rx_ring(struct ixgbe_ring *rx_ring)
 	u16 i = rx_ring->next_to_clean;
 	struct ixgbe_rx_buffer *rx_buffer = &rx_ring->rx_buffer_info[i];
 
-	if (rx_ring->xsk_umem) {
+	if (rx_ring->xsk_pool) {
 		ixgbe_xsk_clean_rx_ring(rx_ring);
 		goto skip_free;
 	}
@@ -5984,7 +5984,7 @@ static void ixgbe_clean_tx_ring(struct ixgbe_ring *tx_ring)
 	u16 i = tx_ring->next_to_clean;
 	struct ixgbe_tx_buffer *tx_buffer = &tx_ring->tx_buffer_info[i];
 
-	if (tx_ring->xsk_umem) {
+	if (tx_ring->xsk_pool) {
 		ixgbe_xsk_clean_tx_ring(tx_ring);
 		goto out;
 	}
@@ -10146,7 +10146,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 	 */
 	if (need_reset && prog)
 		for (i = 0; i < adapter->num_rx_queues; i++)
-			if (adapter->xdp_ring[i]->xsk_umem)
+			if (adapter->xdp_ring[i]->xsk_pool)
 				(void)ixgbe_xsk_wakeup(adapter->netdev, i,
 						       XDP_WAKEUP_RX);
 
@@ -10160,8 +10160,8 @@ static int ixgbe_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return ixgbe_xdp_setup(dev, xdp->prog);
-	case XDP_SETUP_XSK_UMEM:
-		return ixgbe_xsk_umem_setup(adapter, xdp->xsk.umem,
+	case XDP_SETUP_XSK_POOL:
+		return ixgbe_xsk_pool_setup(adapter, xdp->xsk.pool,
 					    xdp->xsk.queue_id);
 
 	default:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
index 7887ae4..2aeec78 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
@@ -28,9 +28,10 @@ void ixgbe_irq_rearm_queues(struct ixgbe_adapter *adapter, u64 qmask);
 void ixgbe_txrx_ring_disable(struct ixgbe_adapter *adapter, int ring);
 void ixgbe_txrx_ring_enable(struct ixgbe_adapter *adapter, int ring);
 
-struct xdp_umem *ixgbe_xsk_umem(struct ixgbe_adapter *adapter,
-				struct ixgbe_ring *ring);
-int ixgbe_xsk_umem_setup(struct ixgbe_adapter *adapter, struct xdp_umem *umem,
+struct xsk_buff_pool *ixgbe_xsk_pool(struct ixgbe_adapter *adapter,
+				     struct ixgbe_ring *ring);
+int ixgbe_xsk_pool_setup(struct ixgbe_adapter *adapter,
+			 struct xsk_buff_pool *pool,
 			 u16 qid);
 
 void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long handle);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index ec7121f..8ad954f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -8,8 +8,8 @@
 #include "ixgbe.h"
 #include "ixgbe_txrx_common.h"
 
-struct xdp_umem *ixgbe_xsk_umem(struct ixgbe_adapter *adapter,
-				struct ixgbe_ring *ring)
+struct xsk_buff_pool *ixgbe_xsk_pool(struct ixgbe_adapter *adapter,
+				     struct ixgbe_ring *ring)
 {
 	bool xdp_on = READ_ONCE(adapter->xdp_prog);
 	int qid = ring->ring_idx;
@@ -17,11 +17,11 @@ struct xdp_umem *ixgbe_xsk_umem(struct ixgbe_adapter *adapter,
 	if (!xdp_on || !test_bit(qid, adapter->af_xdp_zc_qps))
 		return NULL;
 
-	return xdp_get_umem_from_qid(adapter->netdev, qid);
+	return xdp_get_xsk_pool_from_qid(adapter->netdev, qid);
 }
 
-static int ixgbe_xsk_umem_enable(struct ixgbe_adapter *adapter,
-				 struct xdp_umem *umem,
+static int ixgbe_xsk_pool_enable(struct ixgbe_adapter *adapter,
+				 struct xsk_buff_pool *pool,
 				 u16 qid)
 {
 	struct net_device *netdev = adapter->netdev;
@@ -35,7 +35,7 @@ static int ixgbe_xsk_umem_enable(struct ixgbe_adapter *adapter,
 	    qid >= netdev->real_num_tx_queues)
 		return -EINVAL;
 
-	err = xsk_buff_dma_map(umem, &adapter->pdev->dev, IXGBE_RX_DMA_ATTR);
+	err = xsk_buff_dma_map(pool->umem, &adapter->pdev->dev, IXGBE_RX_DMA_ATTR);
 	if (err)
 		return err;
 
@@ -59,13 +59,13 @@ static int ixgbe_xsk_umem_enable(struct ixgbe_adapter *adapter,
 	return 0;
 }
 
-static int ixgbe_xsk_umem_disable(struct ixgbe_adapter *adapter, u16 qid)
+static int ixgbe_xsk_pool_disable(struct ixgbe_adapter *adapter, u16 qid)
 {
-	struct xdp_umem *umem;
+	struct xsk_buff_pool *pool;
 	bool if_running;
 
-	umem = xdp_get_umem_from_qid(adapter->netdev, qid);
-	if (!umem)
+	pool = xdp_get_xsk_pool_from_qid(adapter->netdev, qid);
+	if (!pool)
 		return -EINVAL;
 
 	if_running = netif_running(adapter->netdev) &&
@@ -75,7 +75,7 @@ static int ixgbe_xsk_umem_disable(struct ixgbe_adapter *adapter, u16 qid)
 		ixgbe_txrx_ring_disable(adapter, qid);
 
 	clear_bit(qid, adapter->af_xdp_zc_qps);
-	xsk_buff_dma_unmap(umem, IXGBE_RX_DMA_ATTR);
+	xsk_buff_dma_unmap(pool->umem, IXGBE_RX_DMA_ATTR);
 
 	if (if_running)
 		ixgbe_txrx_ring_enable(adapter, qid);
@@ -83,11 +83,12 @@ static int ixgbe_xsk_umem_disable(struct ixgbe_adapter *adapter, u16 qid)
 	return 0;
 }
 
-int ixgbe_xsk_umem_setup(struct ixgbe_adapter *adapter, struct xdp_umem *umem,
+int ixgbe_xsk_pool_setup(struct ixgbe_adapter *adapter,
+			 struct xsk_buff_pool *pool,
 			 u16 qid)
 {
-	return umem ? ixgbe_xsk_umem_enable(adapter, umem, qid) :
-		ixgbe_xsk_umem_disable(adapter, qid);
+	return pool ? ixgbe_xsk_pool_enable(adapter, pool, qid) :
+		ixgbe_xsk_pool_disable(adapter, qid);
 }
 
 static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
@@ -149,7 +150,7 @@ bool ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 count)
 	i -= rx_ring->count;
 
 	do {
-		bi->xdp = xsk_buff_alloc(rx_ring->xsk_umem);
+		bi->xdp = xsk_buff_alloc(rx_ring->xsk_pool->umem);
 		if (!bi->xdp) {
 			ok = false;
 			break;
@@ -344,11 +345,11 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 	q_vector->rx.total_packets += total_rx_packets;
 	q_vector->rx.total_bytes += total_rx_bytes;
 
-	if (xsk_umem_uses_need_wakeup(rx_ring->xsk_umem)) {
+	if (xsk_umem_uses_need_wakeup(rx_ring->xsk_pool->umem)) {
 		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
-			xsk_set_rx_need_wakeup(rx_ring->xsk_umem);
+			xsk_set_rx_need_wakeup(rx_ring->xsk_pool->umem);
 		else
-			xsk_clear_rx_need_wakeup(rx_ring->xsk_umem);
+			xsk_clear_rx_need_wakeup(rx_ring->xsk_pool->umem);
 
 		return (int)total_rx_packets;
 	}
@@ -373,6 +374,7 @@ void ixgbe_xsk_clean_rx_ring(struct ixgbe_ring *rx_ring)
 
 static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 {
+	struct xsk_buff_pool *pool = xdp_ring->xsk_pool;
 	union ixgbe_adv_tx_desc *tx_desc = NULL;
 	struct ixgbe_tx_buffer *tx_bi;
 	bool work_done = true;
@@ -387,12 +389,11 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 			break;
 		}
 
-		if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &desc))
+		if (!xsk_umem_consume_tx(pool->umem, &desc))
 			break;
 
-		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_umem, desc.addr);
-		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_umem, dma,
-						 desc.len);
+		dma = xsk_buff_raw_get_dma(pool->umem, desc.addr);
+		xsk_buff_raw_dma_sync_for_device(pool->umem, dma, desc.len);
 
 		tx_bi = &xdp_ring->tx_buffer_info[xdp_ring->next_to_use];
 		tx_bi->bytecount = desc.len;
@@ -418,7 +419,7 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 
 	if (tx_desc) {
 		ixgbe_xdp_ring_update_tail(xdp_ring);
-		xsk_umem_consume_tx_done(xdp_ring->xsk_umem);
+		xsk_umem_consume_tx_done(pool->umem);
 	}
 
 	return !!budget && work_done;
@@ -439,7 +440,7 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 {
 	u16 ntc = tx_ring->next_to_clean, ntu = tx_ring->next_to_use;
 	unsigned int total_packets = 0, total_bytes = 0;
-	struct xdp_umem *umem = tx_ring->xsk_umem;
+	struct xsk_buff_pool *pool = tx_ring->xsk_pool;
 	union ixgbe_adv_tx_desc *tx_desc;
 	struct ixgbe_tx_buffer *tx_bi;
 	u32 xsk_frames = 0;
@@ -484,10 +485,10 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 	q_vector->tx.total_packets += total_packets;
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(umem, xsk_frames);
+		xsk_umem_complete_tx(pool->umem, xsk_frames);
 
-	if (xsk_umem_uses_need_wakeup(tx_ring->xsk_umem))
-		xsk_set_tx_need_wakeup(tx_ring->xsk_umem);
+	if (xsk_umem_uses_need_wakeup(pool->umem))
+		xsk_set_tx_need_wakeup(pool->umem);
 
 	return ixgbe_xmit_zc(tx_ring, q_vector->tx.work_limit);
 }
@@ -511,7 +512,7 @@ int ixgbe_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 	if (test_bit(__IXGBE_TX_DISABLED, &ring->state))
 		return -ENETDOWN;
 
-	if (!ring->xsk_umem)
+	if (!ring->xsk_pool)
 		return -ENXIO;
 
 	if (!napi_if_scheduled_mark_missed(&ring->q_vector->napi)) {
@@ -526,7 +527,7 @@ int ixgbe_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 void ixgbe_xsk_clean_tx_ring(struct ixgbe_ring *tx_ring)
 {
 	u16 ntc = tx_ring->next_to_clean, ntu = tx_ring->next_to_use;
-	struct xdp_umem *umem = tx_ring->xsk_umem;
+	struct xsk_buff_pool *pool = tx_ring->xsk_pool;
 	struct ixgbe_tx_buffer *tx_bi;
 	u32 xsk_frames = 0;
 
@@ -546,5 +547,5 @@ void ixgbe_xsk_clean_tx_ring(struct ixgbe_ring *tx_ring)
 	}
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(umem, xsk_frames);
+		xsk_umem_complete_tx(pool->umem, xsk_frames);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 10e6886..0b3eaa1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -24,7 +24,7 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
-		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/umem.o \
+		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
 		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o
 
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0cc2080..4f33658 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -442,7 +442,7 @@ struct mlx5e_xdpsq {
 	struct mlx5e_cq            cq;
 
 	/* read only */
-	struct xdp_umem           *umem;
+	struct xsk_buff_pool      *xsk_pool;
 	struct mlx5_wq_cyc         wq;
 	struct mlx5e_xdpsq_stats  *stats;
 	mlx5e_fp_xmit_xdp_frame_check xmit_xdp_frame_check;
@@ -606,7 +606,7 @@ struct mlx5e_rq {
 	struct page_pool      *page_pool;
 
 	/* AF_XDP zero-copy */
-	struct xdp_umem       *umem;
+	struct xsk_buff_pool  *xsk_pool;
 
 	struct work_struct     recover_work;
 
@@ -729,12 +729,13 @@ struct mlx5e_hv_vhca_stats_agent {
 #endif
 
 struct mlx5e_xsk {
-	/* UMEMs are stored separately from channels, because we don't want to
-	 * lose them when channels are recreated. The kernel also stores UMEMs,
-	 * but it doesn't distinguish between zero-copy and non-zero-copy UMEMs,
-	 * so rely on our mechanism.
+	/* XSK buffer pools are stored separately from channels,
+	 * because we don't want to lose them when channels are
+	 * recreated. The kernel also stores buffer pool, but it doesn't
+	 * distinguish between zero-copy and non-zero-copy UMEMs, so
+	 * rely on our mechanism.
 	 */
-	struct xdp_umem **umems;
+	struct xsk_buff_pool **pools;
 	u16 refcnt;
 	bool ever_used;
 };
@@ -893,7 +894,7 @@ struct mlx5e_xsk_param;
 struct mlx5e_rq_param;
 int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
 		  struct mlx5e_rq_param *param, struct mlx5e_xsk_param *xsk,
-		  struct xdp_umem *umem, struct mlx5e_rq *rq);
+		  struct xsk_buff_pool *xsk_pool, struct mlx5e_rq *rq);
 int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_close_rq(struct mlx5e_rq *rq);
@@ -903,7 +904,7 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
 		     struct mlx5e_sq_param *param, struct mlx5e_icosq *sq);
 void mlx5e_close_icosq(struct mlx5e_icosq *sq);
 int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
-		     struct mlx5e_sq_param *param, struct xdp_umem *umem,
+		     struct mlx5e_sq_param *param, struct xsk_buff_pool *xsk_pool,
 		     struct mlx5e_xdpsq *sq, bool is_redirect);
 void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 0e6946f..c9f0d2b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -445,7 +445,7 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(sq->umem, xsk_frames);
+		xsk_umem_complete_tx(sq->xsk_pool->umem, xsk_frames);
 
 	sq->stats->cqes += i;
 
@@ -475,7 +475,7 @@ void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq)
 	}
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(sq->umem, xsk_frames);
+		xsk_umem_complete_tx(sq->xsk_pool->umem, xsk_frames);
 }
 
 int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
@@ -563,4 +563,3 @@ void mlx5e_set_xmit_fp(struct mlx5e_xdpsq *sq, bool is_mpw)
 	sq->xmit_xdp_frame = is_mpw ?
 		mlx5e_xmit_xdp_frame_mpwqe : mlx5e_xmit_xdp_frame;
 }
-
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
new file mode 100644
index 0000000..8ccd920
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019-2020, Mellanox Technologies inc. All rights reserved. */
+
+#include <net/xdp_sock_drv.h>
+#include "pool.h"
+#include "setup.h"
+#include "en/params.h"
+
+static int mlx5e_xsk_map_pool(struct mlx5e_priv *priv,
+			      struct xsk_buff_pool *pool)
+{
+	struct device *dev = priv->mdev->device;
+
+	return xsk_buff_dma_map(pool->umem, dev, 0);
+}
+
+static void mlx5e_xsk_unmap_pool(struct mlx5e_priv *priv,
+				 struct xsk_buff_pool *pool)
+{
+	return xsk_buff_dma_unmap(pool->umem, 0);
+}
+
+static int mlx5e_xsk_get_pools(struct mlx5e_xsk *xsk)
+{
+	if (!xsk->pools) {
+		xsk->pools = kcalloc(MLX5E_MAX_NUM_CHANNELS,
+				     sizeof(*xsk->pools), GFP_KERNEL);
+		if (unlikely(!xsk->pools))
+			return -ENOMEM;
+	}
+
+	xsk->refcnt++;
+	xsk->ever_used = true;
+
+	return 0;
+}
+
+static void mlx5e_xsk_put_pools(struct mlx5e_xsk *xsk)
+{
+	if (!--xsk->refcnt) {
+		kfree(xsk->pools);
+		xsk->pools = NULL;
+	}
+}
+
+static int mlx5e_xsk_add_pool(struct mlx5e_xsk *xsk, struct xsk_buff_pool *pool, u16 ix)
+{
+	int err;
+
+	err = mlx5e_xsk_get_pools(xsk);
+	if (unlikely(err))
+		return err;
+
+	xsk->pools[ix] = pool;
+	return 0;
+}
+
+static void mlx5e_xsk_remove_pool(struct mlx5e_xsk *xsk, u16 ix)
+{
+	xsk->pools[ix] = NULL;
+
+	mlx5e_xsk_put_pools(xsk);
+}
+
+static bool mlx5e_xsk_is_pool_sane(struct xsk_buff_pool *pool)
+{
+	return xsk_umem_get_headroom(pool->umem) <= 0xffff &&
+		xsk_umem_get_chunk_size(pool->umem) <= 0xffff;
+}
+
+void mlx5e_build_xsk_param(struct xsk_buff_pool *pool, struct mlx5e_xsk_param *xsk)
+{
+	xsk->headroom = xsk_umem_get_headroom(pool->umem);
+	xsk->chunk_size = xsk_umem_get_chunk_size(pool->umem);
+}
+
+static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
+				   struct xsk_buff_pool *pool, u16 ix)
+{
+	struct mlx5e_params *params = &priv->channels.params;
+	struct mlx5e_xsk_param xsk;
+	struct mlx5e_channel *c;
+	int err;
+
+	if (unlikely(mlx5e_xsk_get_pool(&priv->channels.params, &priv->xsk, ix)))
+		return -EBUSY;
+
+	if (unlikely(!mlx5e_xsk_is_pool_sane(pool)))
+		return -EINVAL;
+
+	err = mlx5e_xsk_map_pool(priv, pool);
+	if (unlikely(err))
+		return err;
+
+	err = mlx5e_xsk_add_pool(&priv->xsk, pool, ix);
+	if (unlikely(err))
+		goto err_unmap_pool;
+
+	mlx5e_build_xsk_param(pool, &xsk);
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		/* XSK objects will be created on open. */
+		goto validate_closed;
+	}
+
+	if (!params->xdp_prog) {
+		/* XSK objects will be created when an XDP program is set,
+		 * and the channels are reopened.
+		 */
+		goto validate_closed;
+	}
+
+	c = priv->channels.c[ix];
+
+	err = mlx5e_open_xsk(priv, params, &xsk, pool, c);
+	if (unlikely(err))
+		goto err_remove_pool;
+
+	mlx5e_activate_xsk(c);
+
+	/* Don't wait for WQEs, because the newer xdpsock sample doesn't provide
+	 * any Fill Ring entries at the setup stage.
+	 */
+
+	err = mlx5e_xsk_redirect_rqt_to_channel(priv, priv->channels.c[ix]);
+	if (unlikely(err))
+		goto err_deactivate;
+
+	return 0;
+
+err_deactivate:
+	mlx5e_deactivate_xsk(c);
+	mlx5e_close_xsk(c);
+
+err_remove_pool:
+	mlx5e_xsk_remove_pool(&priv->xsk, ix);
+
+err_unmap_pool:
+	mlx5e_xsk_unmap_pool(priv, pool);
+
+	return err;
+
+validate_closed:
+	/* Check the configuration in advance, rather than fail at a later stage
+	 * (in mlx5e_xdp_set or on open) and end up with no channels.
+	 */
+	if (!mlx5e_validate_xsk_param(params, &xsk, priv->mdev)) {
+		err = -EINVAL;
+		goto err_remove_pool;
+	}
+
+	return 0;
+}
+
+static int mlx5e_xsk_disable_locked(struct mlx5e_priv *priv, u16 ix)
+{
+	struct xsk_buff_pool *pool = mlx5e_xsk_get_pool(&priv->channels.params,
+						   &priv->xsk, ix);
+	struct mlx5e_channel *c;
+
+	if (unlikely(!pool))
+		return -EINVAL;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		goto remove_pool;
+
+	/* XSK RQ and SQ are only created if XDP program is set. */
+	if (!priv->channels.params.xdp_prog)
+		goto remove_pool;
+
+	c = priv->channels.c[ix];
+	mlx5e_xsk_redirect_rqt_to_drop(priv, ix);
+	mlx5e_deactivate_xsk(c);
+	mlx5e_close_xsk(c);
+
+remove_pool:
+	mlx5e_xsk_remove_pool(&priv->xsk, ix);
+	mlx5e_xsk_unmap_pool(priv, pool);
+
+	return 0;
+}
+
+static int mlx5e_xsk_enable_pool(struct mlx5e_priv *priv, struct xsk_buff_pool *pool,
+				 u16 ix)
+{
+	int err;
+
+	mutex_lock(&priv->state_lock);
+	err = mlx5e_xsk_enable_locked(priv, pool, ix);
+	mutex_unlock(&priv->state_lock);
+
+	return err;
+}
+
+static int mlx5e_xsk_disable_pool(struct mlx5e_priv *priv, u16 ix)
+{
+	int err;
+
+	mutex_lock(&priv->state_lock);
+	err = mlx5e_xsk_disable_locked(priv, ix);
+	mutex_unlock(&priv->state_lock);
+
+	return err;
+}
+
+int mlx5e_xsk_setup_pool(struct net_device *dev, struct xsk_buff_pool *pool, u16 qid)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5e_params *params = &priv->channels.params;
+	u16 ix;
+
+	if (unlikely(!mlx5e_qid_get_ch_if_in_group(params, qid, MLX5E_RQ_GROUP_XSK, &ix)))
+		return -EINVAL;
+
+	return pool ? mlx5e_xsk_enable_pool(priv, pool, ix) :
+		      mlx5e_xsk_disable_pool(priv, ix);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.h
new file mode 100644
index 0000000..dca0010
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019-2020, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5_EN_XSK_POOL_H__
+#define __MLX5_EN_XSK_POOL_H__
+
+#include "en.h"
+
+static inline struct xsk_buff_pool *mlx5e_xsk_get_pool(struct mlx5e_params *params,
+						       struct mlx5e_xsk *xsk, u16 ix)
+{
+	if (!xsk || !xsk->pools)
+		return NULL;
+
+	if (unlikely(ix >= params->num_channels))
+		return NULL;
+
+	return xsk->pools[ix];
+}
+
+struct mlx5e_xsk_param;
+void mlx5e_build_xsk_param(struct xsk_buff_pool *pool, struct mlx5e_xsk_param *xsk);
+
+/* .ndo_bpf callback. */
+int mlx5e_xsk_setup_pool(struct net_device *dev, struct xsk_buff_pool *pool, u16 qid);
+
+#endif /* __MLX5_EN_XSK_POOL_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index d147b2f..3dd056a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -19,10 +19,10 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5e_wqe_frag_info *wi,
 					      u32 cqe_bcnt);
 
-static inline int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
+static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
 					    struct mlx5e_dma_info *dma_info)
 {
-	dma_info->xsk = xsk_buff_alloc(rq->umem);
+	dma_info->xsk = xsk_buff_alloc(rq->xsk_pool->umem);
 	if (!dma_info->xsk)
 		return -ENOMEM;
 
@@ -38,13 +38,13 @@ static inline int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
 
 static inline bool mlx5e_xsk_update_rx_wakeup(struct mlx5e_rq *rq, bool alloc_err)
 {
-	if (!xsk_umem_uses_need_wakeup(rq->umem))
+	if (!xsk_umem_uses_need_wakeup(rq->xsk_pool->umem))
 		return alloc_err;
 
 	if (unlikely(alloc_err))
-		xsk_set_rx_need_wakeup(rq->umem);
+		xsk_set_rx_need_wakeup(rq->xsk_pool->umem);
 	else
-		xsk_clear_rx_need_wakeup(rq->umem);
+		xsk_clear_rx_need_wakeup(rq->xsk_pool->umem);
 
 	return false;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index dd9df51..662a1da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -45,7 +45,7 @@ static void mlx5e_build_xsk_cparam(struct mlx5e_priv *priv,
 }
 
 int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
-		   struct mlx5e_xsk_param *xsk, struct xdp_umem *umem,
+		   struct mlx5e_xsk_param *xsk, struct xsk_buff_pool *pool,
 		   struct mlx5e_channel *c)
 {
 	struct mlx5e_channel_param *cparam;
@@ -64,7 +64,7 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	if (unlikely(err))
 		goto err_free_cparam;
 
-	err = mlx5e_open_rq(c, params, &cparam->rq, xsk, umem, &c->xskrq);
+	err = mlx5e_open_rq(c, params, &cparam->rq, xsk, pool, &c->xskrq);
 	if (unlikely(err))
 		goto err_close_rx_cq;
 
@@ -72,13 +72,13 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	if (unlikely(err))
 		goto err_close_rq;
 
-	/* Create a separate SQ, so that when the UMEM is disabled, we could
+	/* Create a separate SQ, so that when the buff pool is disabled, we could
 	 * close this SQ safely and stop receiving CQEs. In other case, e.g., if
-	 * the XDPSQ was used instead, we might run into trouble when the UMEM
+	 * the XDPSQ was used instead, we might run into trouble when the buff pool
 	 * is disabled and then reenabled, but the SQ continues receiving CQEs
-	 * from the old UMEM.
+	 * from the old buff pool.
 	 */
-	err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, umem, &c->xsksq, true);
+	err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, pool, &c->xsksq, true);
 	if (unlikely(err))
 		goto err_close_tx_cq;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
index 0dd11b8..ca20f1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
@@ -12,7 +12,7 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 			      struct mlx5e_xsk_param *xsk,
 			      struct mlx5_core_dev *mdev);
 int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
-		   struct mlx5e_xsk_param *xsk, struct xdp_umem *umem,
+		   struct mlx5e_xsk_param *xsk, struct xsk_buff_pool *pool,
 		   struct mlx5e_channel *c);
 void mlx5e_close_xsk(struct mlx5e_channel *c);
 void mlx5e_activate_xsk(struct mlx5e_channel *c);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 4d892f6..5f94702 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -2,7 +2,7 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
 
 #include "tx.h"
-#include "umem.h"
+#include "pool.h"
 #include "en/xdp.h"
 #include "en/params.h"
 #include <net/xdp_sock_drv.h>
@@ -66,7 +66,7 @@ static void mlx5e_xsk_tx_post_err(struct mlx5e_xdpsq *sq,
 
 bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 {
-	struct xdp_umem *umem = sq->umem;
+	struct xsk_buff_pool *pool = sq->xsk_pool;
 	struct mlx5e_xdp_info xdpi;
 	struct mlx5e_xdp_xmit_data xdptxd;
 	bool work_done = true;
@@ -87,7 +87,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			break;
 		}
 
-		if (!xsk_umem_consume_tx(umem, &desc)) {
+		if (!xsk_umem_consume_tx(pool->umem, &desc)) {
 			/* TX will get stuck until something wakes it up by
 			 * triggering NAPI. Currently it's expected that the
 			 * application calls sendto() if there are consumed, but
@@ -96,11 +96,11 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			break;
 		}
 
-		xdptxd.dma_addr = xsk_buff_raw_get_dma(umem, desc.addr);
-		xdptxd.data = xsk_buff_raw_get_data(umem, desc.addr);
+		xdptxd.dma_addr = xsk_buff_raw_get_dma(pool->umem, desc.addr);
+		xdptxd.data = xsk_buff_raw_get_data(pool->umem, desc.addr);
 		xdptxd.len = desc.len;
 
-		xsk_buff_raw_dma_sync_for_device(umem, xdptxd.dma_addr, xdptxd.len);
+		xsk_buff_raw_dma_sync_for_device(pool->umem, xdptxd.dma_addr, xdptxd.len);
 
 		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
 				      mlx5e_xmit_xdp_frame, sq, &xdptxd, &xdpi, check_result);
@@ -119,7 +119,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			mlx5e_xdp_mpwqe_complete(sq);
 		mlx5e_xmit_xdp_doorbell(sq);
 
-		xsk_umem_consume_tx_done(umem);
+		xsk_umem_consume_tx_done(pool->umem);
 	}
 
 	return !(budget && work_done);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
index 39fa0a7..ddb61d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
@@ -15,13 +15,13 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget);
 
 static inline void mlx5e_xsk_update_tx_wakeup(struct mlx5e_xdpsq *sq)
 {
-	if (!xsk_umem_uses_need_wakeup(sq->umem))
+	if (!xsk_umem_uses_need_wakeup(sq->xsk_pool->umem))
 		return;
 
 	if (sq->pc != sq->cc)
-		xsk_clear_tx_need_wakeup(sq->umem);
+		xsk_clear_tx_need_wakeup(sq->xsk_pool->umem);
 	else
-		xsk_set_tx_need_wakeup(sq->umem);
+		xsk_set_tx_need_wakeup(sq->xsk_pool->umem);
 }
 
 #endif /* __MLX5_EN_XSK_TX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
deleted file mode 100644
index 331ca2b..0000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
+++ /dev/null
@@ -1,217 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
-/* Copyright (c) 2019 Mellanox Technologies. */
-
-#include <net/xdp_sock_drv.h>
-#include "umem.h"
-#include "setup.h"
-#include "en/params.h"
-
-static int mlx5e_xsk_map_umem(struct mlx5e_priv *priv,
-			      struct xdp_umem *umem)
-{
-	struct device *dev = priv->mdev->device;
-
-	return xsk_buff_dma_map(umem, dev, 0);
-}
-
-static void mlx5e_xsk_unmap_umem(struct mlx5e_priv *priv,
-				 struct xdp_umem *umem)
-{
-	return xsk_buff_dma_unmap(umem, 0);
-}
-
-static int mlx5e_xsk_get_umems(struct mlx5e_xsk *xsk)
-{
-	if (!xsk->umems) {
-		xsk->umems = kcalloc(MLX5E_MAX_NUM_CHANNELS,
-				     sizeof(*xsk->umems), GFP_KERNEL);
-		if (unlikely(!xsk->umems))
-			return -ENOMEM;
-	}
-
-	xsk->refcnt++;
-	xsk->ever_used = true;
-
-	return 0;
-}
-
-static void mlx5e_xsk_put_umems(struct mlx5e_xsk *xsk)
-{
-	if (!--xsk->refcnt) {
-		kfree(xsk->umems);
-		xsk->umems = NULL;
-	}
-}
-
-static int mlx5e_xsk_add_umem(struct mlx5e_xsk *xsk, struct xdp_umem *umem, u16 ix)
-{
-	int err;
-
-	err = mlx5e_xsk_get_umems(xsk);
-	if (unlikely(err))
-		return err;
-
-	xsk->umems[ix] = umem;
-	return 0;
-}
-
-static void mlx5e_xsk_remove_umem(struct mlx5e_xsk *xsk, u16 ix)
-{
-	xsk->umems[ix] = NULL;
-
-	mlx5e_xsk_put_umems(xsk);
-}
-
-static bool mlx5e_xsk_is_umem_sane(struct xdp_umem *umem)
-{
-	return xsk_umem_get_headroom(umem) <= 0xffff &&
-		xsk_umem_get_chunk_size(umem) <= 0xffff;
-}
-
-void mlx5e_build_xsk_param(struct xdp_umem *umem, struct mlx5e_xsk_param *xsk)
-{
-	xsk->headroom = xsk_umem_get_headroom(umem);
-	xsk->chunk_size = xsk_umem_get_chunk_size(umem);
-}
-
-static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
-				   struct xdp_umem *umem, u16 ix)
-{
-	struct mlx5e_params *params = &priv->channels.params;
-	struct mlx5e_xsk_param xsk;
-	struct mlx5e_channel *c;
-	int err;
-
-	if (unlikely(mlx5e_xsk_get_umem(&priv->channels.params, &priv->xsk, ix)))
-		return -EBUSY;
-
-	if (unlikely(!mlx5e_xsk_is_umem_sane(umem)))
-		return -EINVAL;
-
-	err = mlx5e_xsk_map_umem(priv, umem);
-	if (unlikely(err))
-		return err;
-
-	err = mlx5e_xsk_add_umem(&priv->xsk, umem, ix);
-	if (unlikely(err))
-		goto err_unmap_umem;
-
-	mlx5e_build_xsk_param(umem, &xsk);
-
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		/* XSK objects will be created on open. */
-		goto validate_closed;
-	}
-
-	if (!params->xdp_prog) {
-		/* XSK objects will be created when an XDP program is set,
-		 * and the channels are reopened.
-		 */
-		goto validate_closed;
-	}
-
-	c = priv->channels.c[ix];
-
-	err = mlx5e_open_xsk(priv, params, &xsk, umem, c);
-	if (unlikely(err))
-		goto err_remove_umem;
-
-	mlx5e_activate_xsk(c);
-
-	/* Don't wait for WQEs, because the newer xdpsock sample doesn't provide
-	 * any Fill Ring entries at the setup stage.
-	 */
-
-	err = mlx5e_xsk_redirect_rqt_to_channel(priv, priv->channels.c[ix]);
-	if (unlikely(err))
-		goto err_deactivate;
-
-	return 0;
-
-err_deactivate:
-	mlx5e_deactivate_xsk(c);
-	mlx5e_close_xsk(c);
-
-err_remove_umem:
-	mlx5e_xsk_remove_umem(&priv->xsk, ix);
-
-err_unmap_umem:
-	mlx5e_xsk_unmap_umem(priv, umem);
-
-	return err;
-
-validate_closed:
-	/* Check the configuration in advance, rather than fail at a later stage
-	 * (in mlx5e_xdp_set or on open) and end up with no channels.
-	 */
-	if (!mlx5e_validate_xsk_param(params, &xsk, priv->mdev)) {
-		err = -EINVAL;
-		goto err_remove_umem;
-	}
-
-	return 0;
-}
-
-static int mlx5e_xsk_disable_locked(struct mlx5e_priv *priv, u16 ix)
-{
-	struct xdp_umem *umem = mlx5e_xsk_get_umem(&priv->channels.params,
-						   &priv->xsk, ix);
-	struct mlx5e_channel *c;
-
-	if (unlikely(!umem))
-		return -EINVAL;
-
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
-		goto remove_umem;
-
-	/* XSK RQ and SQ are only created if XDP program is set. */
-	if (!priv->channels.params.xdp_prog)
-		goto remove_umem;
-
-	c = priv->channels.c[ix];
-	mlx5e_xsk_redirect_rqt_to_drop(priv, ix);
-	mlx5e_deactivate_xsk(c);
-	mlx5e_close_xsk(c);
-
-remove_umem:
-	mlx5e_xsk_remove_umem(&priv->xsk, ix);
-	mlx5e_xsk_unmap_umem(priv, umem);
-
-	return 0;
-}
-
-static int mlx5e_xsk_enable_umem(struct mlx5e_priv *priv, struct xdp_umem *umem,
-				 u16 ix)
-{
-	int err;
-
-	mutex_lock(&priv->state_lock);
-	err = mlx5e_xsk_enable_locked(priv, umem, ix);
-	mutex_unlock(&priv->state_lock);
-
-	return err;
-}
-
-static int mlx5e_xsk_disable_umem(struct mlx5e_priv *priv, u16 ix)
-{
-	int err;
-
-	mutex_lock(&priv->state_lock);
-	err = mlx5e_xsk_disable_locked(priv, ix);
-	mutex_unlock(&priv->state_lock);
-
-	return err;
-}
-
-int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-	struct mlx5e_params *params = &priv->channels.params;
-	u16 ix;
-
-	if (unlikely(!mlx5e_qid_get_ch_if_in_group(params, qid, MLX5E_RQ_GROUP_XSK, &ix)))
-		return -EINVAL;
-
-	return umem ? mlx5e_xsk_enable_umem(priv, umem, ix) :
-		      mlx5e_xsk_disable_umem(priv, ix);
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
deleted file mode 100644
index bada949..0000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-/* Copyright (c) 2019 Mellanox Technologies. */
-
-#ifndef __MLX5_EN_XSK_UMEM_H__
-#define __MLX5_EN_XSK_UMEM_H__
-
-#include "en.h"
-
-static inline struct xdp_umem *mlx5e_xsk_get_umem(struct mlx5e_params *params,
-						  struct mlx5e_xsk *xsk, u16 ix)
-{
-	if (!xsk || !xsk->umems)
-		return NULL;
-
-	if (unlikely(ix >= params->num_channels))
-		return NULL;
-
-	return xsk->umems[ix];
-}
-
-struct mlx5e_xsk_param;
-void mlx5e_build_xsk_param(struct xdp_umem *umem, struct mlx5e_xsk_param *xsk);
-
-/* .ndo_bpf callback. */
-int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid);
-
-int mlx5e_xsk_resize_reuseq(struct xdp_umem *umem, u32 nentries);
-
-#endif /* __MLX5_EN_XSK_UMEM_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 0827098..5cb1e48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -32,7 +32,7 @@
 
 #include "en.h"
 #include "en/port.h"
-#include "en/xsk/umem.h"
+#include "en/xsk/pool.h"
 #include "lib/clock.h"
 
 void mlx5e_ethtool_get_drvinfo(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index 83c9b2b..b416a8e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -33,7 +33,7 @@
 #include <linux/mlx5/fs.h>
 #include "en.h"
 #include "en/params.h"
-#include "en/xsk/umem.h"
+#include "en/xsk/pool.h"
 
 struct mlx5e_ethtool_rule {
 	struct list_head             list;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index aebcf73..f598683 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -57,7 +57,7 @@
 #include "en/monitor_stats.h"
 #include "en/health.h"
 #include "en/params.h"
-#include "en/xsk/umem.h"
+#include "en/xsk/pool.h"
 #include "en/xsk/setup.h"
 #include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
@@ -363,7 +363,7 @@ static void mlx5e_rq_err_cqe_work(struct work_struct *recover_work)
 static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
-			  struct xdp_umem *umem,
+			  struct xsk_buff_pool *xsk_pool,
 			  struct mlx5e_rq_param *rqp,
 			  struct mlx5e_rq *rq)
 {
@@ -389,9 +389,9 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	rq->mdev    = mdev;
 	rq->hw_mtu  = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq   = &c->rq_xdpsq;
-	rq->umem    = umem;
+	rq->xsk_pool = xsk_pool;
 
-	if (rq->umem)
+	if (rq->xsk_pool)
 		rq->stats = &c->priv->channel_stats[c->ix].xskrq;
 	else
 		rq->stats = &c->priv->channel_stats[c->ix].rq;
@@ -477,7 +477,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	if (xsk) {
 		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
 						 MEM_TYPE_XSK_BUFF_POOL, NULL);
-		xsk_buff_set_rxq_info(rq->umem, &rq->xdp_rxq);
+		xsk_buff_set_rxq_info(rq->xsk_pool->umem, &rq->xdp_rxq);
 	} else {
 		/* Create a page_pool and register it with rxq */
 		pp_params.order     = 0;
@@ -816,11 +816,11 @@ void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
 
 int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
 		  struct mlx5e_rq_param *param, struct mlx5e_xsk_param *xsk,
-		  struct xdp_umem *umem, struct mlx5e_rq *rq)
+		  struct xsk_buff_pool *xsk_pool, struct mlx5e_rq *rq)
 {
 	int err;
 
-	err = mlx5e_alloc_rq(c, params, xsk, umem, param, rq);
+	err = mlx5e_alloc_rq(c, params, xsk, xsk_pool, param, rq);
 	if (err)
 		return err;
 
@@ -925,7 +925,7 @@ static int mlx5e_alloc_xdpsq_db(struct mlx5e_xdpsq *sq, int numa)
 
 static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 			     struct mlx5e_params *params,
-			     struct xdp_umem *umem,
+			     struct xsk_buff_pool *xsk_pool,
 			     struct mlx5e_sq_param *param,
 			     struct mlx5e_xdpsq *sq,
 			     bool is_redirect)
@@ -941,9 +941,9 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	sq->umem      = umem;
+	sq->xsk_pool  = xsk_pool;
 
-	sq->stats = sq->umem ?
+	sq->stats = sq->xsk_pool ?
 		&c->priv->channel_stats[c->ix].xsksq :
 		is_redirect ?
 			&c->priv->channel_stats[c->ix].xdpsq :
@@ -1408,13 +1408,13 @@ void mlx5e_close_icosq(struct mlx5e_icosq *sq)
 }
 
 int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
-		     struct mlx5e_sq_param *param, struct xdp_umem *umem,
+		     struct mlx5e_sq_param *param, struct xsk_buff_pool *xsk_pool,
 		     struct mlx5e_xdpsq *sq, bool is_redirect)
 {
 	struct mlx5e_create_sq_param csp = {};
 	int err;
 
-	err = mlx5e_alloc_xdpsq(c, params, umem, param, sq, is_redirect);
+	err = mlx5e_alloc_xdpsq(c, params, xsk_pool, param, sq, is_redirect);
 	if (err)
 		return err;
 
@@ -1907,7 +1907,7 @@ static u8 mlx5e_enumerate_lag_port(struct mlx5_core_dev *mdev, int ix)
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
 			      struct mlx5e_channel_param *cparam,
-			      struct xdp_umem *umem,
+			      struct xsk_buff_pool *xsk_pool,
 			      struct mlx5e_channel **cp)
 {
 	int cpu = cpumask_first(mlx5_comp_irq_get_affinity_mask(priv->mdev, ix));
@@ -1946,9 +1946,9 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	if (unlikely(err))
 		goto err_napi_del;
 
-	if (umem) {
-		mlx5e_build_xsk_param(umem, &xsk);
-		err = mlx5e_open_xsk(priv, params, &xsk, umem, c);
+	if (xsk_pool) {
+		mlx5e_build_xsk_param(xsk_pool, &xsk);
+		err = mlx5e_open_xsk(priv, params, &xsk, xsk_pool, c);
 		if (unlikely(err))
 			goto err_close_queues;
 	}
@@ -2309,12 +2309,12 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 
 	mlx5e_build_channel_param(priv, &chs->params, cparam);
 	for (i = 0; i < chs->num; i++) {
-		struct xdp_umem *umem = NULL;
+		struct xsk_buff_pool *xsk_pool = NULL;
 
 		if (chs->params.xdp_prog)
-			umem = mlx5e_xsk_get_umem(&chs->params, chs->params.xsk, i);
+			xsk_pool = mlx5e_xsk_get_pool(&chs->params, chs->params.xsk, i);
 
-		err = mlx5e_open_channel(priv, i, &chs->params, cparam, umem, &chs->c[i]);
+		err = mlx5e_open_channel(priv, i, &chs->params, cparam, xsk_pool, &chs->c[i]);
 		if (err)
 			goto err_close_channels;
 	}
@@ -3892,13 +3892,14 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
 	u16 ix;
 
 	for (ix = 0; ix < chs->params.num_channels; ix++) {
-		struct xdp_umem *umem = mlx5e_xsk_get_umem(&chs->params, chs->params.xsk, ix);
+		struct xsk_buff_pool *xsk_pool =
+			mlx5e_xsk_get_pool(&chs->params, chs->params.xsk, ix);
 		struct mlx5e_xsk_param xsk;
 
-		if (!umem)
+		if (!xsk_pool)
 			continue;
 
-		mlx5e_build_xsk_param(umem, &xsk);
+		mlx5e_build_xsk_param(xsk_pool, &xsk);
 
 		if (!mlx5e_validate_xsk_param(new_params, &xsk, mdev)) {
 			u32 hr = mlx5e_get_linear_rq_headroom(new_params, &xsk);
@@ -4423,8 +4424,8 @@ static int mlx5e_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return mlx5e_xdp_set(dev, xdp->prog);
-	case XDP_SETUP_XSK_UMEM:
-		return mlx5e_xsk_setup_umem(dev, xdp->xsk.umem,
+	case XDP_SETUP_XSK_POOL:
+		return mlx5e_xsk_setup_pool(dev, xdp->xsk.pool,
 					    xdp->xsk.queue_id);
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 65828af..b33f9f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -281,8 +281,8 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq,
 static inline int mlx5e_page_alloc(struct mlx5e_rq *rq,
 				   struct mlx5e_dma_info *dma_info)
 {
-	if (rq->umem)
-		return mlx5e_xsk_page_alloc_umem(rq, dma_info);
+	if (rq->xsk_pool)
+		return mlx5e_xsk_page_alloc_pool(rq, dma_info);
 	else
 		return mlx5e_page_alloc_pool(rq, dma_info);
 }
@@ -313,7 +313,7 @@ static inline void mlx5e_page_release(struct mlx5e_rq *rq,
 				      struct mlx5e_dma_info *dma_info,
 				      bool recycle)
 {
-	if (rq->umem)
+	if (rq->xsk_pool)
 		/* The `recycle` parameter is ignored, and the page is always
 		 * put into the Reuse Ring, because there is no way to return
 		 * the page to the userspace when the interface goes down.
@@ -400,14 +400,14 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 	int err;
 	int i;
 
-	if (rq->umem) {
+	if (rq->xsk_pool) {
 		int pages_desired = wqe_bulk << rq->wqe.info.log_num_frags;
 
 		/* Check in advance that we have enough frames, instead of
 		 * allocating one-by-one, failing and moving frames to the
 		 * Reuse Ring.
 		 */
-		if (unlikely(!xsk_buff_can_alloc(rq->umem, pages_desired)))
+		if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool->umem, pages_desired)))
 			return -ENOMEM;
 	}
 
@@ -505,8 +505,8 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	/* Check in advance that we have enough frames, instead of allocating
 	 * one-by-one, failing and moving frames to the Reuse Ring.
 	 */
-	if (rq->umem &&
-	    unlikely(!xsk_buff_can_alloc(rq->umem, MLX5_MPWRQ_PAGES_PER_WQE))) {
+	if (rq->xsk_pool &&
+	    unlikely(!xsk_buff_can_alloc(rq->xsk_pool->umem, MLX5_MPWRQ_PAGES_PER_WQE))) {
 		err = -ENOMEM;
 		goto err;
 	}
@@ -754,7 +754,7 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 	 * the driver when it refills the Fill Ring.
 	 * 2. Otherwise, busy poll by rescheduling the NAPI poll.
 	 */
-	if (unlikely(alloc_err == -ENOMEM && rq->umem))
+	if (unlikely(alloc_err == -ENOMEM && rq->xsk_pool))
 		return true;
 
 	return false;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b0e303f..d088dd8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -618,7 +618,7 @@ struct netdev_queue {
 	/* Subordinate device that the queue has been assigned to */
 	struct net_device	*sb_dev;
 #ifdef CONFIG_XDP_SOCKETS
-	struct xdp_umem         *umem;
+	struct xsk_buff_pool    *pool;
 #endif
 /*
  * write-mostly part
@@ -751,7 +751,7 @@ struct netdev_rx_queue {
 	struct net_device		*dev;
 	struct xdp_rxq_info		xdp_rxq;
 #ifdef CONFIG_XDP_SOCKETS
-	struct xdp_umem                 *umem;
+	struct xsk_buff_pool            *pool;
 #endif
 } ____cacheline_aligned_in_smp;
 
@@ -879,7 +879,7 @@ enum bpf_netdev_command {
 	/* BPF program for offload callbacks, invoked at program load time. */
 	BPF_OFFLOAD_MAP_ALLOC,
 	BPF_OFFLOAD_MAP_FREE,
-	XDP_SETUP_XSK_UMEM,
+	XDP_SETUP_XSK_POOL,
 };
 
 struct bpf_prog_offload_ops;
@@ -913,9 +913,9 @@ struct netdev_bpf {
 		struct {
 			struct bpf_offloaded_map *offmap;
 		};
-		/* XDP_SETUP_XSK_UMEM */
+		/* XDP_SETUP_XSK_POOL */
 		struct {
-			struct xdp_umem *umem;
+			struct xsk_buff_pool *pool;
 			u16 queue_id;
 		} xsk;
 	};
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index ccf848f..5dc8d3c 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -14,7 +14,8 @@
 void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries);
 bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc);
 void xsk_umem_consume_tx_done(struct xdp_umem *umem);
-struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 queue_id);
+struct xsk_buff_pool *xdp_get_xsk_pool_from_qid(struct net_device *dev,
+						u16 queue_id);
 void xsk_set_rx_need_wakeup(struct xdp_umem *umem);
 void xsk_set_tx_need_wakeup(struct xdp_umem *umem);
 void xsk_clear_rx_need_wakeup(struct xdp_umem *umem);
@@ -125,8 +126,8 @@ static inline void xsk_umem_consume_tx_done(struct xdp_umem *umem)
 {
 }
 
-static inline struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev,
-						     u16 queue_id)
+static inline struct xsk_buff_pool *
+xdp_get_xsk_pool_from_qid(struct net_device *dev, u16 queue_id)
 {
 	return NULL;
 }
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 6842990..f851b0a 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -13,6 +13,7 @@ struct xsk_buff_pool;
 struct xdp_rxq_info;
 struct xsk_queue;
 struct xdp_desc;
+struct xdp_umem;
 struct device;
 struct page;
 
@@ -42,13 +43,14 @@ struct xsk_buff_pool {
 	u32 frame_len;
 	bool dma_need_sync;
 	bool unaligned;
+	struct xdp_umem *umem;
 	void *addrs;
 	struct device *dev;
 	struct xdp_buff_xsk *free_heads[];
 };
 
 /* AF_XDP core. */
-struct xsk_buff_pool *xp_create(struct page **pages, u32 nr_pages, u32 chunks,
+struct xsk_buff_pool *xp_create(struct xdp_umem *umem, u32 chunks,
 				u32 chunk_size, u32 headroom, u64 size,
 				bool unaligned);
 void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq);
diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 9ef54cd..78d990b 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -223,7 +223,7 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	from_channel = channels.combined_count +
 		       min(channels.rx_count, channels.tx_count);
 	for (i = from_channel; i < old_total; i++)
-		if (xdp_get_umem_from_qid(dev, i)) {
+		if (xdp_get_xsk_pool_from_qid(dev, i)) {
 			GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing zerocopy AF_XDP sockets");
 			return -EINVAL;
 		}
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 441794e..2e6a678 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1706,7 +1706,7 @@ static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
 		min(channels.rx_count, channels.tx_count);
 	to_channel = curr.combined_count + max(curr.rx_count, curr.tx_count);
 	for (i = from_channel; i < to_channel; i++)
-		if (xdp_get_umem_from_qid(dev, i))
+		if (xdp_get_xsk_pool_from_qid(dev, i))
 			return -EINVAL;
 
 	ret = dev->ethtool_ops->set_channels(dev, &channels);
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index e97db37..0b5f3b0 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -51,8 +51,9 @@ void xdp_del_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
  * not know if the device has more tx queues than rx, or the opposite.
  * This might also change during run time.
  */
-static int xdp_reg_umem_at_qid(struct net_device *dev, struct xdp_umem *umem,
-			       u16 queue_id)
+static int xdp_reg_xsk_pool_at_qid(struct net_device *dev,
+				   struct xsk_buff_pool *pool,
+				   u16 queue_id)
 {
 	if (queue_id >= max_t(unsigned int,
 			      dev->real_num_rx_queues,
@@ -60,31 +61,31 @@ static int xdp_reg_umem_at_qid(struct net_device *dev, struct xdp_umem *umem,
 		return -EINVAL;
 
 	if (queue_id < dev->real_num_rx_queues)
-		dev->_rx[queue_id].umem = umem;
+		dev->_rx[queue_id].pool = pool;
 	if (queue_id < dev->real_num_tx_queues)
-		dev->_tx[queue_id].umem = umem;
+		dev->_tx[queue_id].pool = pool;
 
 	return 0;
 }
 
-struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev,
-				       u16 queue_id)
+struct xsk_buff_pool *xdp_get_xsk_pool_from_qid(struct net_device *dev,
+						u16 queue_id)
 {
 	if (queue_id < dev->real_num_rx_queues)
-		return dev->_rx[queue_id].umem;
+		return dev->_rx[queue_id].pool;
 	if (queue_id < dev->real_num_tx_queues)
-		return dev->_tx[queue_id].umem;
+		return dev->_tx[queue_id].pool;
 
 	return NULL;
 }
-EXPORT_SYMBOL(xdp_get_umem_from_qid);
+EXPORT_SYMBOL(xdp_get_xsk_pool_from_qid);
 
-static void xdp_clear_umem_at_qid(struct net_device *dev, u16 queue_id)
+static void xdp_clear_xsk_pool_at_qid(struct net_device *dev, u16 queue_id)
 {
 	if (queue_id < dev->real_num_rx_queues)
-		dev->_rx[queue_id].umem = NULL;
+		dev->_rx[queue_id].pool = NULL;
 	if (queue_id < dev->real_num_tx_queues)
-		dev->_tx[queue_id].umem = NULL;
+		dev->_tx[queue_id].pool = NULL;
 }
 
 int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
@@ -102,10 +103,10 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 	if (force_zc && force_copy)
 		return -EINVAL;
 
-	if (xdp_get_umem_from_qid(dev, queue_id))
+	if (xdp_get_xsk_pool_from_qid(dev, queue_id))
 		return -EBUSY;
 
-	err = xdp_reg_umem_at_qid(dev, umem, queue_id);
+	err = xdp_reg_xsk_pool_at_qid(dev, umem->pool, queue_id);
 	if (err)
 		return err;
 
@@ -132,8 +133,8 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 		goto err_unreg_umem;
 	}
 
-	bpf.command = XDP_SETUP_XSK_UMEM;
-	bpf.xsk.umem = umem;
+	bpf.command = XDP_SETUP_XSK_POOL;
+	bpf.xsk.pool = umem->pool;
 	bpf.xsk.queue_id = queue_id;
 
 	err = dev->netdev_ops->ndo_bpf(dev, &bpf);
@@ -147,7 +148,7 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 	if (!force_zc)
 		err = 0; /* fallback to copy mode */
 	if (err)
-		xdp_clear_umem_at_qid(dev, queue_id);
+		xdp_clear_xsk_pool_at_qid(dev, queue_id);
 	return err;
 }
 
@@ -162,8 +163,8 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
 		return;
 
 	if (umem->zc) {
-		bpf.command = XDP_SETUP_XSK_UMEM;
-		bpf.xsk.umem = NULL;
+		bpf.command = XDP_SETUP_XSK_POOL;
+		bpf.xsk.pool = NULL;
 		bpf.xsk.queue_id = umem->queue_id;
 
 		err = umem->dev->netdev_ops->ndo_bpf(umem->dev, &bpf);
@@ -172,7 +173,7 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
 			WARN(1, "failed to disable umem!\n");
 	}
 
-	xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
+	xdp_clear_xsk_pool_at_qid(umem->dev, umem->queue_id);
 
 	dev_put(umem->dev);
 	umem->dev = NULL;
@@ -373,8 +374,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (err)
 		goto out_account;
 
-	umem->pool = xp_create(umem->pgs, umem->npgs, chunks, chunk_size,
-			       headroom, size, unaligned_chunks);
+	umem->pool = xp_create(umem, chunks, chunk_size, headroom, size,
+			       unaligned_chunks);
 	if (!umem->pool) {
 		err = -ENOMEM;
 		goto out_pin;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index a2044c2..f3df3cb 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -29,7 +29,7 @@ void xp_destroy(struct xsk_buff_pool *pool)
 	kvfree(pool);
 }
 
-struct xsk_buff_pool *xp_create(struct page **pages, u32 nr_pages, u32 chunks,
+struct xsk_buff_pool *xp_create(struct xdp_umem *umem, u32 chunks,
 				u32 chunk_size, u32 headroom, u64 size,
 				bool unaligned)
 {
@@ -54,6 +54,7 @@ struct xsk_buff_pool *xp_create(struct page **pages, u32 nr_pages, u32 chunks,
 	pool->chunk_size = chunk_size;
 	pool->unaligned = unaligned;
 	pool->frame_len = chunk_size - headroom - XDP_PACKET_HEADROOM;
+	pool->umem = umem;
 	INIT_LIST_HEAD(&pool->free_list);
 
 	for (i = 0; i < pool->free_heads_cnt; i++) {
@@ -63,7 +64,7 @@ struct xsk_buff_pool *xp_create(struct page **pages, u32 nr_pages, u32 chunks,
 		pool->free_heads[i] = xskb;
 	}
 
-	err = xp_addr_map(pool, pages, nr_pages);
+	err = xp_addr_map(pool, umem->pgs, umem->npgs);
 	if (!err)
 		return pool;
 
-- 
2.7.4

