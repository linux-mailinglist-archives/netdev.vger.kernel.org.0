Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BAD45A90E
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238943AbhKWQqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:46:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:56550 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237376AbhKWQp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:45:26 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="235006788"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="235006788"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:42:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="740079192"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 23 Nov 2021 08:42:07 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4X3016784;
        Tue, 23 Nov 2021 16:42:04 GMT
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
Subject: [PATCH v2 net-next 25/26] ixgbe: add XDP and XSK generic per-channel statistics
Date:   Tue, 23 Nov 2021 17:39:54 +0100
Message-Id: <20211123163955.154512-26-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make ixgbe driver collect and provide all generic XDP/XSK counters.
Unfortunately, XDP rings have a lifetime of an XDP prog, and all
ring stats structures get wiped on xsk_pool attach/detach, so
store them in a separate array with a lifetime of a netdev.
Reuse all previously introduced helpers and
xdp_get_drv_stats_generic(). Performance wavering from incrementing
a bunch of counters on hotpath is around stddev at [64 ... 1532]
frame sizes.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |  3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 69 ++++++++++++++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 56 +++++++++++----
 4 files changed, 106 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 4a69823e6abd..d60794636925 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -349,6 +349,7 @@ struct ixgbe_ring {
 		struct ixgbe_tx_queue_stats tx_stats;
 		struct ixgbe_rx_queue_stats rx_stats;
 	};
+	struct xdp_drv_stats *xdp_stats;
 	u16 rx_offset;
 	struct xdp_rxq_info xdp_rxq;
 	spinlock_t tx_lock;	/* used in XDP mode */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index 86b11164655e..c146963adbd5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -951,6 +951,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 		ring->queue_index = xdp_idx;
 		set_ring_xdp(ring);
 		spin_lock_init(&ring->tx_lock);
+		ring->xdp_stats = adapter->netdev->xstats + xdp_idx;

 		/* assign ring to adapter */
 		WRITE_ONCE(adapter->xdp_ring[xdp_idx], ring);
@@ -994,6 +995,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 		/* apply Rx specific ring traits */
 		ring->count = adapter->rx_ring_count;
 		ring->queue_index = rxr_idx;
+		ring->xdp_stats = adapter->netdev->xstats + rxr_idx;

 		/* assign ring to adapter */
 		WRITE_ONCE(adapter->rx_ring[rxr_idx], ring);
@@ -1303,4 +1305,3 @@ void ixgbe_tx_ctxtdesc(struct ixgbe_ring *tx_ring, u32 vlan_macip_lens,
 	context_desc->type_tucmd_mlhl	= cpu_to_le32(type_tucmd);
 	context_desc->mss_l4len_idx	= cpu_to_le32(mss_l4len_idx);
 }
-
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 0f9f022260d7..d1cfd7d6a72b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1246,8 +1246,11 @@ static bool ixgbe_clean_tx_irq(struct ixgbe_q_vector *q_vector,
 		return true;
 	}

-	if (ring_is_xdp(tx_ring))
+	if (ring_is_xdp(tx_ring)) {
+		xdp_update_tx_drv_stats(&tx_ring->xdp_stats->xdp_tx,
+					total_packets, total_bytes);
 		return !!budget;
+	}

 	netdev_tx_completed_queue(txring_txq(tx_ring),
 				  total_packets, total_bytes);
@@ -2196,7 +2199,8 @@ static struct sk_buff *ixgbe_build_skb(struct ixgbe_ring *rx_ring,

 static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 				     struct ixgbe_ring *rx_ring,
-				     struct xdp_buff *xdp)
+				     struct xdp_buff *xdp,
+				     struct xdp_rx_drv_stats_local *lrstats)
 {
 	int err, result = IXGBE_XDP_PASS;
 	struct bpf_prog *xdp_prog;
@@ -2209,40 +2213,57 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
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
 		xdpf = xdp_convert_buff_to_frame(xdp);
-		if (unlikely(!xdpf))
+		if (unlikely(!xdpf)) {
+			lrstats->tx_errors++;
 			goto out_failure;
+		}
 		ring = ixgbe_determine_xdp_ring(adapter);
 		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
 			spin_lock(&ring->tx_lock);
 		result = ixgbe_xmit_xdp_ring(ring, xdpf);
 		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
 			spin_unlock(&ring->tx_lock);
-		if (result == IXGBE_XDP_CONSUMED)
+		if (result == IXGBE_XDP_CONSUMED) {
+			lrstats->tx_errors++;
 			goto out_failure;
+		}
+		lrstats->tx++;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(adapter->netdev, xdp, xdp_prog);
-		if (err)
+		if (err) {
+			lrstats->redirect_errors++;
 			goto out_failure;
+		}
 		result = IXGBE_XDP_REDIR;
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
+		result = IXGBE_XDP_CONSUMED;
+		break;
 	case XDP_DROP:
 		result = IXGBE_XDP_CONSUMED;
+		lrstats->drop++;
 		break;
 	}
 xdp_out:
@@ -2301,6 +2322,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 	unsigned int mss = 0;
 #endif /* IXGBE_FCOE */
 	u16 cleaned_count = ixgbe_desc_unused(rx_ring);
+	struct xdp_rx_drv_stats_local lrstats = { };
 	unsigned int offset = rx_ring->rx_offset;
 	unsigned int xdp_xmit = 0;
 	struct xdp_buff xdp;
@@ -2348,7 +2370,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, size);
 #endif
-			skb = ixgbe_run_xdp(adapter, rx_ring, &xdp);
+			skb = ixgbe_run_xdp(adapter, rx_ring, &xdp, &lrstats);
 		}

 		if (IS_ERR(skb)) {
@@ -2440,6 +2462,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 	rx_ring->stats.packets += total_rx_packets;
 	rx_ring->stats.bytes += total_rx_bytes;
 	u64_stats_update_end(&rx_ring->syncp);
+	xdp_update_rx_drv_stats(&rx_ring->xdp_stats->xdp_rx, &lrstats);
 	q_vector->rx.total_packets += total_rx_packets;
 	q_vector->rx.total_bytes += total_rx_bytes;

@@ -8552,8 +8575,10 @@ int ixgbe_xmit_xdp_ring(struct ixgbe_ring *ring,

 	len = xdpf->len;

-	if (unlikely(!ixgbe_desc_unused(ring)))
+	if (unlikely(!ixgbe_desc_unused(ring))) {
+		xdp_update_tx_drv_full(&ring->xdp_stats->xdp_tx);
 		return IXGBE_XDP_CONSUMED;
+	}

 	dma = dma_map_single(ring->dev, xdpf->data, len, DMA_TO_DEVICE);
 	if (dma_mapping_error(ring->dev, dma))
@@ -10257,12 +10282,26 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
 	if (unlikely(flags & XDP_XMIT_FLUSH))
 		ixgbe_xdp_ring_update_tail(ring);

+	if (unlikely(nxmit < n))
+		xdp_update_tx_drv_err(&ring->xdp_stats->xdp_tx, n - nxmit);
+
 	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
 		spin_unlock(&ring->tx_lock);

 	return nxmit;
 }

+static int ixgbe_get_xdp_stats_nch(const struct net_device *dev, u32 attr_id)
+{
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+	case IFLA_XDP_XSTATS_TYPE_XSK:
+		return IXGBE_MAX_XDP_QS;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops ixgbe_netdev_ops = {
 	.ndo_open		= ixgbe_open,
 	.ndo_stop		= ixgbe_close,
@@ -10306,6 +10345,8 @@ static const struct net_device_ops ixgbe_netdev_ops = {
 	.ndo_bpf		= ixgbe_xdp,
 	.ndo_xdp_xmit		= ixgbe_xdp_xmit,
 	.ndo_xsk_wakeup         = ixgbe_xsk_wakeup,
+	.ndo_get_xdp_stats_nch	= ixgbe_get_xdp_stats_nch,
+	.ndo_get_xdp_stats	= xdp_get_drv_stats_generic,
 };

 static void ixgbe_disable_txr_hw(struct ixgbe_adapter *adapter,
@@ -10712,6 +10753,16 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->watchdog_timeo = 5 * HZ;
 	strlcpy(netdev->name, pci_name(pdev), sizeof(netdev->name));

+	netdev->xstats = devm_kcalloc(&pdev->dev, IXGBE_MAX_XDP_QS,
+				      sizeof(*netdev->xstats), GFP_KERNEL);
+	if (!netdev->xstats) {
+		err = -ENOMEM;
+		goto err_ioremap;
+	}
+
+	for (i = 0; i < IXGBE_MAX_XDP_QS; i++)
+		xdp_init_drv_stats(netdev->xstats + i);
+
 	/* Setup hw api */
 	hw->mac.ops   = *ii->mac_ops;
 	hw->mac.type  = ii->mac;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index db2bc58dfcfd..47c4b4621ab1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -96,7 +96,8 @@ int ixgbe_xsk_pool_setup(struct ixgbe_adapter *adapter,

 static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 			    struct ixgbe_ring *rx_ring,
-			    struct xdp_buff *xdp)
+			    struct xdp_buff *xdp,
+			    struct xdp_rx_drv_stats_local *lrstats)
 {
 	int err, result = IXGBE_XDP_PASS;
 	struct bpf_prog *xdp_prog;
@@ -104,41 +105,58 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 	struct xdp_frame *xdpf;
 	u32 act;

+	lrstats->bytes += xdp->data_end - xdp->data;
+	lrstats->packets++;
+
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);

 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		if (err)
+		if (err) {
+			lrstats->redirect_errors++;
 			goto out_failure;
+		}
+		lrstats->redirect++;
 		return IXGBE_XDP_REDIR;
 	}

 	switch (act) {
 	case XDP_PASS:
+		lrstats->pass++;
 		break;
 	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
-		if (unlikely(!xdpf))
+		if (unlikely(!xdpf)) {
+			lrstats->tx_errors++;
 			goto out_failure;
+		}
 		ring = ixgbe_determine_xdp_ring(adapter);
 		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
 			spin_lock(&ring->tx_lock);
 		result = ixgbe_xmit_xdp_ring(ring, xdpf);
 		if (static_branch_unlikely(&ixgbe_xdp_locking_key))
 			spin_unlock(&ring->tx_lock);
-		if (result == IXGBE_XDP_CONSUMED)
+		if (result == IXGBE_XDP_CONSUMED) {
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
+		result = IXGBE_XDP_CONSUMED;
+		break;
 	case XDP_DROP:
 		result = IXGBE_XDP_CONSUMED;
+		lrstats->drop++;
 		break;
 	}
 	return result;
@@ -246,6 +264,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	struct ixgbe_adapter *adapter = q_vector->adapter;
 	u16 cleaned_count = ixgbe_desc_unused(rx_ring);
+	struct xdp_rx_drv_stats_local lrstats = { };
 	unsigned int xdp_res, xdp_xmit = 0;
 	bool failure = false;
 	struct sk_buff *skb;
@@ -299,7 +318,8 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,

 		bi->xdp->data_end = bi->xdp->data + size;
 		xsk_buff_dma_sync_for_cpu(bi->xdp, rx_ring->xsk_pool);
-		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp);
+		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp,
+					   &lrstats);

 		if (xdp_res) {
 			if (xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR))
@@ -349,6 +369,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 	rx_ring->stats.packets += total_rx_packets;
 	rx_ring->stats.bytes += total_rx_bytes;
 	u64_stats_update_end(&rx_ring->syncp);
+	xdp_update_rx_drv_stats(&rx_ring->xdp_stats->xsk_rx, &lrstats);
 	q_vector->rx.total_packets += total_rx_packets;
 	q_vector->rx.total_bytes += total_rx_bytes;

@@ -392,6 +413,7 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 	while (budget-- > 0) {
 		if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
 		    !netif_carrier_ok(xdp_ring->netdev)) {
+			xdp_update_tx_drv_full(&xdp_ring->xdp_stats->xsk_tx);
 			work_done = false;
 			break;
 		}
@@ -448,9 +470,10 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 	u16 ntc = tx_ring->next_to_clean, ntu = tx_ring->next_to_use;
 	unsigned int total_packets = 0, total_bytes = 0;
 	struct xsk_buff_pool *pool = tx_ring->xsk_pool;
+	u32 xdp_frames = 0, xdp_bytes = 0;
+	u32 xsk_frames = 0, xsk_bytes = 0;
 	union ixgbe_adv_tx_desc *tx_desc;
 	struct ixgbe_tx_buffer *tx_bi;
-	u32 xsk_frames = 0;

 	tx_bi = &tx_ring->tx_buffer_info[ntc];
 	tx_desc = IXGBE_TX_DESC(tx_ring, ntc);
@@ -459,13 +482,14 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 		if (!(tx_desc->wb.status & cpu_to_le32(IXGBE_TXD_STAT_DD)))
 			break;

-		total_bytes += tx_bi->bytecount;
-		total_packets += tx_bi->gso_segs;
-
-		if (tx_bi->xdpf)
+		if (tx_bi->xdpf) {
 			ixgbe_clean_xdp_tx_buffer(tx_ring, tx_bi);
-		else
+			xdp_bytes += tx_bi->bytecount;
+			xdp_frames++;
+		} else {
+			xsk_bytes += tx_bi->bytecount;
 			xsk_frames++;
+		}

 		tx_bi->xdpf = NULL;

@@ -483,11 +507,17 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 	}

 	tx_ring->next_to_clean = ntc;
+	total_bytes = xdp_bytes + xsk_bytes;
+	total_packets = xdp_frames + xsk_frames;

 	u64_stats_update_begin(&tx_ring->syncp);
 	tx_ring->stats.bytes += total_bytes;
 	tx_ring->stats.packets += total_packets;
 	u64_stats_update_end(&tx_ring->syncp);
+	xdp_update_tx_drv_stats(&tx_ring->xdp_stats->xdp_tx, xdp_frames,
+				xdp_bytes);
+	xdp_update_tx_drv_stats(&tx_ring->xdp_stats->xsk_tx, xsk_frames,
+				xsk_bytes);
 	q_vector->tx.total_bytes += total_bytes;
 	q_vector->tx.total_packets += total_packets;

--
2.33.1

