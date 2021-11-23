Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B21F45A90F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239616AbhKWQqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:46:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:56554 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236653AbhKWQp2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:45:28 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="235006799"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="235006799"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:42:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="606869347"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 23 Nov 2021 08:41:55 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Ww016784;
        Tue, 23 Nov 2021 16:41:52 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 net-next 20/26] i40e: add XDP and XSK generic per-channel statistics
Date:   Tue, 23 Nov 2021 17:39:49 +0100
Message-Id: <20211123163955.154512-21-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make i40e driver collect and provide all generic XDP/XSK counters.
Unfortunately, XDP rings have a lifetime of an XDP prog, and all
ring stats structures get wiped on xsk_pool attach/detach, so
store them in a separate array with a lifetime of a VSI.
Reuse all previously introduced helpers and
xdp_get_drv_stats_generic(). Performance wavering from incrementing
a bunch of counters on hotpath is around stddev at [64 ... 1532]
frame sizes.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c | 38 +++++++++++++++++++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 40 +++++++++++++++++----
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 33 +++++++++++++----
 5 files changed, 99 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 4d939af0a626..2e2a3936332f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -942,6 +942,7 @@ struct i40e_vsi {
 	irqreturn_t (*irq_handler)(int irq, void *data);

 	unsigned long *af_xdp_zc_qps; /* tracks AF_XDP ZC enabled qps */
+	struct xdp_drv_stats *xdp_stats; /* XDP/XSK stats array */
 } ____cacheline_internodealigned_in_smp;

 struct i40e_netdev_priv {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index e118cf9265c7..e3619fc13630 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11087,7 +11087,7 @@ static int i40e_set_num_rings_in_vsi(struct i40e_vsi *vsi)
 static int i40e_vsi_alloc_arrays(struct i40e_vsi *vsi, bool alloc_qvectors)
 {
 	struct i40e_ring **next_rings;
-	int size;
+	int size, i;
 	int ret = 0;

 	/* allocate memory for both Tx, XDP Tx and Rx ring pointers */
@@ -11103,6 +11103,15 @@ static int i40e_vsi_alloc_arrays(struct i40e_vsi *vsi, bool alloc_qvectors)
 	}
 	vsi->rx_rings = next_rings;

+	vsi->xdp_stats = kcalloc(vsi->alloc_queue_pairs,
+				 sizeof(*vsi->xdp_stats),
+				 GFP_KERNEL);
+	if (!vsi->xdp_stats)
+		goto err_xdp_stats;
+
+	for (i = 0; i < vsi->alloc_queue_pairs; i++)
+		xdp_init_drv_stats(vsi->xdp_stats + i);
+
 	if (alloc_qvectors) {
 		/* allocate memory for q_vector pointers */
 		size = sizeof(struct i40e_q_vector *) * vsi->num_q_vectors;
@@ -11115,6 +11124,10 @@ static int i40e_vsi_alloc_arrays(struct i40e_vsi *vsi, bool alloc_qvectors)
 	return ret;

 err_vectors:
+	kfree(vsi->xdp_stats);
+	vsi->xdp_stats = NULL;
+
+err_xdp_stats:
 	kfree(vsi->tx_rings);
 	return ret;
 }
@@ -11225,6 +11238,10 @@ static void i40e_vsi_free_arrays(struct i40e_vsi *vsi, bool free_qvectors)
 		kfree(vsi->q_vectors);
 		vsi->q_vectors = NULL;
 	}
+
+	kfree(vsi->xdp_stats);
+	vsi->xdp_stats = NULL;
+
 	kfree(vsi->tx_rings);
 	vsi->tx_rings = NULL;
 	vsi->rx_rings = NULL;
@@ -11347,6 +11364,7 @@ static int i40e_alloc_rings(struct i40e_vsi *vsi)
 		if (vsi->back->hw_features & I40E_HW_WB_ON_ITR_CAPABLE)
 			ring->flags = I40E_TXR_FLAGS_WB_ON_ITR;
 		ring->itr_setting = pf->tx_itr_default;
+		ring->xdp_stats = vsi->xdp_stats + i;
 		WRITE_ONCE(vsi->tx_rings[i], ring++);

 		if (!i40e_enabled_xdp_vsi(vsi))
@@ -11365,6 +11383,7 @@ static int i40e_alloc_rings(struct i40e_vsi *vsi)
 			ring->flags = I40E_TXR_FLAGS_WB_ON_ITR;
 		set_ring_xdp(ring);
 		ring->itr_setting = pf->tx_itr_default;
+		ring->xdp_stats = vsi->xdp_stats + i;
 		WRITE_ONCE(vsi->xdp_rings[i], ring++);

 setup_rx:
@@ -11378,6 +11397,7 @@ static int i40e_alloc_rings(struct i40e_vsi *vsi)
 		ring->size = 0;
 		ring->dcb_tc = 0;
 		ring->itr_setting = pf->rx_itr_default;
+		ring->xdp_stats = vsi->xdp_stats + i;
 		WRITE_ONCE(vsi->rx_rings[i], ring);
 	}

@@ -13308,6 +13328,19 @@ static int i40e_xdp(struct net_device *dev,
 	}
 }

+static int i40e_get_xdp_stats_nch(const struct net_device *dev, u32 attr_id)
+{
+	const struct i40e_netdev_priv *np = netdev_priv(dev);
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+	case IFLA_XDP_XSTATS_TYPE_XSK:
+		return np->vsi->alloc_queue_pairs;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_open		= i40e_open,
 	.ndo_stop		= i40e_close,
@@ -13343,6 +13376,8 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_bpf		= i40e_xdp,
 	.ndo_xdp_xmit		= i40e_xdp_xmit,
 	.ndo_xsk_wakeup	        = i40e_xsk_wakeup,
+	.ndo_get_xdp_stats_nch	= i40e_get_xdp_stats_nch,
+	.ndo_get_xdp_stats	= xdp_get_drv_stats_generic,
 	.ndo_dfwd_add_station	= i40e_fwd_add,
 	.ndo_dfwd_del_station	= i40e_fwd_del,
 };
@@ -13487,6 +13522,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	netdev->netdev_ops = &i40e_netdev_ops;
 	netdev->watchdog_timeo = 5 * HZ;
 	i40e_set_ethtool_ops(netdev);
+	netdev->xstats = vsi->xdp_stats;

 	/* MTU range: 68 - 9706 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 10a83e5385c7..8854004fbec3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1027,8 +1027,11 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
 	i40e_update_tx_stats(tx_ring, total_packets, total_bytes);
 	i40e_arm_wb(tx_ring, vsi, budget);

-	if (ring_is_xdp(tx_ring))
+	if (ring_is_xdp(tx_ring)) {
+		xdp_update_tx_drv_stats(&tx_ring->xdp_stats->xdp_tx,
+					total_packets, total_bytes);
 		return !!budget;
+	}

 	/* notify netdev of completed buffers */
 	netdev_tx_completed_queue(txring_txq(tx_ring),
@@ -2290,8 +2293,10 @@ int i40e_xmit_xdp_tx_ring(struct xdp_buff *xdp, struct i40e_ring *xdp_ring)
  * i40e_run_xdp - run an XDP program
  * @rx_ring: Rx ring being processed
  * @xdp: XDP buffer containing the frame
+ * @lrstats: onstack Rx XDP stats
  **/
-static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
+static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp,
+			struct xdp_rx_drv_stats_local *lrstats)
 {
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
@@ -2303,33 +2308,48 @@ static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 	if (!xdp_prog)
 		goto xdp_out;

+	lrstats->bytes += xdp->data_end - xdp->data;
+	lrstats->packets++;
+
 	prefetchw(xdp->data_hard_start); /* xdp_frame write */

 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
+		lrstats->pass++;
 		break;
 	case XDP_TX:
 		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
 		result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
-		if (result == I40E_XDP_CONSUMED)
+		if (result == I40E_XDP_CONSUMED) {
+			lrstats->tx_errors++;
 			goto out_failure;
+		}
+		lrstats->tx++;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		if (err)
+		if (err) {
+			lrstats->redirect_errors++;
 			goto out_failure;
+		}
 		result = I40E_XDP_REDIR;
+		lrstats->redirect++;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		fallthrough;
+		lrstats->invalid++;
+		goto out_failure;
 	case XDP_ABORTED:
+		lrstats->aborted++;
 out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		fallthrough; /* handle aborts by dropping packet */
+		/* handle aborts by dropping packet */
+		result = I40E_XDP_CONSUMED;
+		break;
 	case XDP_DROP:
 		result = I40E_XDP_CONSUMED;
+		lrstats->drop++;
 		break;
 	}
 xdp_out:
@@ -2441,6 +2461,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0, frame_sz = 0;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
+	struct xdp_rx_drv_stats_local lrstats = { };
 	unsigned int offset = rx_ring->rx_offset;
 	struct sk_buff *skb = rx_ring->skb;
 	unsigned int xdp_xmit = 0;
@@ -2512,7 +2533,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, size);
 #endif
-			xdp_res = i40e_run_xdp(rx_ring, &xdp);
+			xdp_res = i40e_run_xdp(rx_ring, &xdp, &lrstats);
 		}

 		if (xdp_res) {
@@ -2569,6 +2590,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	rx_ring->skb = skb;

 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
+	xdp_update_rx_drv_stats(&rx_ring->xdp_stats->xdp_rx, &lrstats);

 	/* guarantee a trip back through this routine if there was a failure */
 	return failure ? budget : (int)total_rx_packets;
@@ -3696,6 +3718,7 @@ static int i40e_xmit_xdp_ring(struct xdp_frame *xdpf,
 	dma_addr_t dma;

 	if (!unlikely(I40E_DESC_UNUSED(xdp_ring))) {
+		xdp_update_tx_drv_full(&xdp_ring->xdp_stats->xdp_tx);
 		xdp_ring->tx_stats.tx_busy++;
 		return I40E_XDP_CONSUMED;
 	}
@@ -3923,5 +3946,8 @@ int i40e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	if (unlikely(flags & XDP_XMIT_FLUSH))
 		i40e_xdp_ring_update_tail(xdp_ring);

+	if (unlikely(nxmit < n))
+		xdp_update_tx_drv_err(&xdp_ring->xdp_stats->xdp_tx, n - nxmit);
+
 	return nxmit;
 }
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index bfc2845c99d1..dcfcf20e2ea9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -368,6 +368,7 @@ struct i40e_ring {
 		struct i40e_tx_queue_stats tx_stats;
 		struct i40e_rx_queue_stats rx_stats;
 	};
+	struct xdp_drv_stats *xdp_stats;

 	unsigned int size;		/* length of descriptor ring in bytes */
 	dma_addr_t dma;			/* physical address of ring */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index ea06e957393e..54c5b8abbb53 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -143,16 +143,21 @@ int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
  * i40e_run_xdp_zc - Executes an XDP program on an xdp_buff
  * @rx_ring: Rx ring
  * @xdp: xdp_buff used as input to the XDP program
+ * @lrstats: onstack Rx XDP stats structure
  *
  * Returns any of I40E_XDP_{PASS, CONSUMED, TX, REDIR}
  **/
-static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
+static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp,
+			   struct xdp_rx_drv_stats_local *lrstats)
 {
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
 	struct bpf_prog *xdp_prog;
 	u32 act;

+	lrstats->bytes += xdp->data_end - xdp->data;
+	lrstats->packets++;
+
 	/* NB! xdp_prog will always be !NULL, due to the fact that
 	 * this path is enabled by setting an XDP program.
 	 */
@@ -161,29 +166,41 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)

 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		if (err)
+		if (err) {
+			lrstats->redirect_errors++;
 			goto out_failure;
+		}
+		lrstats->redirect++;
 		return I40E_XDP_REDIR;
 	}

 	switch (act) {
 	case XDP_PASS:
+		lrstats->pass++;
 		break;
 	case XDP_TX:
 		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
 		result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
-		if (result == I40E_XDP_CONSUMED)
+		if (result == I40E_XDP_CONSUMED) {
+			lrstats->tx_errors++;
 			goto out_failure;
+		}
+		lrstats->tx++;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		fallthrough;
+		lrstats->invalid++;
+		goto out_failure;
 	case XDP_ABORTED:
+		lrstats->aborted++;
 out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		fallthrough; /* handle aborts by dropping packet */
+		/* handle aborts by dropping packet */
+		result = I40E_XDP_CONSUMED;
+		break;
 	case XDP_DROP:
 		result = I40E_XDP_CONSUMED;
+		lrstats->drop++;
 		break;
 	}
 	return result;
@@ -325,6 +342,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
+	struct xdp_rx_drv_stats_local lrstats = { };
 	u16 next_to_clean = rx_ring->next_to_clean;
 	u16 count_mask = rx_ring->count - 1;
 	unsigned int xdp_res, xdp_xmit = 0;
@@ -366,7 +384,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		xsk_buff_set_size(bi, size);
 		xsk_buff_dma_sync_for_cpu(bi, rx_ring->xsk_pool);

-		xdp_res = i40e_run_xdp_zc(rx_ring, bi);
+		xdp_res = i40e_run_xdp_zc(rx_ring, bi, &lrstats);
 		i40e_handle_xdp_result_zc(rx_ring, bi, rx_desc, &rx_packets,
 					  &rx_bytes, size, xdp_res);
 		total_rx_packets += rx_packets;
@@ -383,6 +401,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)

 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
+	xdp_update_rx_drv_stats(&rx_ring->xdp_stats->xsk_rx, &lrstats);

 	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
 		if (failure || next_to_clean == rx_ring->next_to_use)
@@ -489,6 +508,8 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 	i40e_xdp_ring_update_tail(xdp_ring);

 	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
+	xdp_update_tx_drv_stats(&xdp_ring->xdp_stats->xsk_tx, nb_pkts,
+				total_bytes);

 	return nb_pkts < budget;
 }
--
2.33.1

