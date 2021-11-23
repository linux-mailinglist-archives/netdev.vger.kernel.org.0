Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D09345A91B
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238718AbhKWQqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:46:42 -0500
Received: from mga06.intel.com ([134.134.136.31]:10197 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239452AbhKWQpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:45:44 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="295864860"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="295864860"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:42:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="509073841"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 23 Nov 2021 08:42:05 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4X2016784;
        Tue, 23 Nov 2021 16:42:02 GMT
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
Subject: [PATCH v2 net-next 24/26] igc: add XDP and XSK generic per-channel statistics
Date:   Tue, 23 Nov 2021 17:39:53 +0100
Message-Id: <20211123163955.154512-25-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make igc driver collect and provide all generic XDP/XSK counters.
Unfortunately, igc has an unified ice_ring structure for both Rx
and Tx, so embedding xdp_drv_stats would bloat it for no good.
Store them in a separate array with a lifetime of an igc_adapter.
IGC_MAX_QUEUES is introduced purely for convenience to not hardcode
max(RX, TX) all the time.
Reuse all previously introduced helpers and
xdp_get_drv_stats_generic(). Performance wavering from incrementing
a bunch of counters on hotpath is around stddev at [64 ... 1532]
frame sizes.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |  3 +
 drivers/net/ethernet/intel/igc/igc_main.c | 88 +++++++++++++++++++----
 2 files changed, 77 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 3e386c38d016..ec46134227ee 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -21,6 +21,8 @@ void igc_ethtool_set_ops(struct net_device *);
 /* Transmit and receive queues */
 #define IGC_MAX_RX_QUEUES		4
 #define IGC_MAX_TX_QUEUES		4
+#define IGC_MAX_QUEUES			max(IGC_MAX_RX_QUEUES, \
+					    IGC_MAX_TX_QUEUES)

 #define MAX_Q_VECTORS			8
 #define MAX_STD_JUMBO_FRAME_SIZE	9216
@@ -125,6 +127,7 @@ struct igc_ring {
 			struct sk_buff *skb;
 		};
 	};
+	struct xdp_drv_stats *xdp_stats;

 	struct xdp_rxq_info xdp_rxq;
 	struct xsk_buff_pool *xsk_pool;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 7d0c540d6b76..2ffe4b2bfde7 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2148,8 +2148,10 @@ static int igc_xdp_init_tx_descriptor(struct igc_ring *ring,
 	u32 cmd_type, olinfo_status;
 	int err;

-	if (!igc_desc_unused(ring))
+	if (!igc_desc_unused(ring)) {
+		xdp_update_tx_drv_full(&ring->xdp_stats->xdp_tx);
 		return -EBUSY;
+	}

 	buffer = &ring->tx_buffer_info[ring->next_to_use];
 	err = igc_xdp_init_tx_buffer(buffer, xdpf, ring);
@@ -2214,36 +2216,51 @@ static int igc_xdp_xmit_back(struct igc_adapter *adapter, struct xdp_buff *xdp)
 /* This function assumes rcu_read_lock() is held by the caller. */
 static int __igc_xdp_run_prog(struct igc_adapter *adapter,
 			      struct bpf_prog *prog,
-			      struct xdp_buff *xdp)
+			      struct xdp_buff *xdp,
+			      struct xdp_rx_drv_stats_local *lrstats)
 {
-	u32 act = bpf_prog_run_xdp(prog, xdp);
+	u32 act;
+
+	lrstats->bytes += xdp->data_end - xdp->data;
+	lrstats->packets++;

+	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
 	case XDP_PASS:
+		lrstats->pass++;
 		return IGC_XDP_PASS;
 	case XDP_TX:
-		if (igc_xdp_xmit_back(adapter, xdp) < 0)
+		if (igc_xdp_xmit_back(adapter, xdp) < 0) {
+			lrstats->tx_errors++;
 			goto out_failure;
+		}
+		lrstats->tx++;
 		return IGC_XDP_TX;
 	case XDP_REDIRECT:
-		if (xdp_do_redirect(adapter->netdev, xdp, prog) < 0)
+		if (xdp_do_redirect(adapter->netdev, xdp, prog) < 0) {
+			lrstats->redirect_errors++;
 			goto out_failure;
+		}
+		lrstats->redirect++;
 		return IGC_XDP_REDIRECT;
-		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		fallthrough;
+		lrstats->invalid++;
+		goto out_failure;
 	case XDP_ABORTED:
+		lrstats->aborted++;
 out_failure:
 		trace_xdp_exception(adapter->netdev, prog, act);
-		fallthrough;
+		return IGC_XDP_CONSUMED;
 	case XDP_DROP:
+		lrstats->drop++;
 		return IGC_XDP_CONSUMED;
 	}
 }

 static struct sk_buff *igc_xdp_run_prog(struct igc_adapter *adapter,
-					struct xdp_buff *xdp)
+					struct xdp_buff *xdp,
+					struct xdp_rx_drv_stats_local *lrstats)
 {
 	struct bpf_prog *prog;
 	int res;
@@ -2254,7 +2271,7 @@ static struct sk_buff *igc_xdp_run_prog(struct igc_adapter *adapter,
 		goto out;
 	}

-	res = __igc_xdp_run_prog(adapter, prog, xdp);
+	res = __igc_xdp_run_prog(adapter, prog, xdp, lrstats);

 out:
 	return ERR_PTR(-res);
@@ -2309,6 +2326,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 	unsigned int total_bytes = 0, total_packets = 0;
 	struct igc_adapter *adapter = q_vector->adapter;
 	struct igc_ring *rx_ring = q_vector->rx.ring;
+	struct xdp_rx_drv_stats_local lrstats = { };
 	struct sk_buff *skb = rx_ring->skb;
 	u16 cleaned_count = igc_desc_unused(rx_ring);
 	int xdp_status = 0, rx_buffer_pgcnt;
@@ -2356,7 +2374,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 			xdp_prepare_buff(&xdp, pktbuf - igc_rx_offset(rx_ring),
 					 igc_rx_offset(rx_ring) + pkt_offset, size, false);

-			skb = igc_xdp_run_prog(adapter, &xdp);
+			skb = igc_xdp_run_prog(adapter, &xdp, &lrstats);
 		}

 		if (IS_ERR(skb)) {
@@ -2425,6 +2443,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 	rx_ring->skb = skb;

 	igc_update_rx_stats(q_vector, total_packets, total_bytes);
+	xdp_update_rx_drv_stats(&rx_ring->xdp_stats->xdp_rx, &lrstats);

 	if (cleaned_count)
 		igc_alloc_rx_buffers(rx_ring, cleaned_count);
@@ -2481,6 +2500,7 @@ static void igc_dispatch_skb_zc(struct igc_q_vector *q_vector,
 static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int budget)
 {
 	struct igc_adapter *adapter = q_vector->adapter;
+	struct xdp_rx_drv_stats_local lrstats = { };
 	struct igc_ring *ring = q_vector->rx.ring;
 	u16 cleaned_count = igc_desc_unused(ring);
 	int total_bytes = 0, total_packets = 0;
@@ -2529,7 +2549,7 @@ static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int budget)
 		bi->xdp->data_end = bi->xdp->data + size;
 		xsk_buff_dma_sync_for_cpu(bi->xdp, ring->xsk_pool);

-		res = __igc_xdp_run_prog(adapter, prog, bi->xdp);
+		res = __igc_xdp_run_prog(adapter, prog, bi->xdp, &lrstats);
 		switch (res) {
 		case IGC_XDP_PASS:
 			igc_dispatch_skb_zc(q_vector, desc, bi->xdp, timestamp);
@@ -2562,6 +2582,7 @@ static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int budget)
 		igc_finalize_xdp(adapter, xdp_status);

 	igc_update_rx_stats(q_vector, total_packets, total_bytes);
+	xdp_update_rx_drv_stats(&ring->xdp_stats->xsk_rx, &lrstats);

 	if (xsk_uses_need_wakeup(ring->xsk_pool)) {
 		if (failure || ring->next_to_clean == ring->next_to_use)
@@ -2604,8 +2625,10 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 	__netif_tx_lock(nq, cpu);

 	budget = igc_desc_unused(ring);
-	if (unlikely(!budget))
+	if (unlikely(!budget)) {
+		xdp_update_tx_drv_full(&ring->xdp_stats->xsk_tx);
 		goto out_unlock;
+	}

 	while (xsk_tx_peek_desc(pool, &xdp_desc) && budget--) {
 		u32 cmd_type, olinfo_status;
@@ -2664,9 +2687,10 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)
 	unsigned int budget = q_vector->tx.work_limit;
 	struct igc_ring *tx_ring = q_vector->tx.ring;
 	unsigned int i = tx_ring->next_to_clean;
+	u32 xdp_frames = 0, xdp_bytes = 0;
+	u32 xsk_frames = 0, xsk_bytes = 0;
 	struct igc_tx_buffer *tx_buffer;
 	union igc_adv_tx_desc *tx_desc;
-	u32 xsk_frames = 0;

 	if (test_bit(__IGC_DOWN, &adapter->state))
 		return true;
@@ -2698,11 +2722,14 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)

 		switch (tx_buffer->type) {
 		case IGC_TX_BUFFER_TYPE_XSK:
+			xsk_bytes += tx_buffer->bytecount;
 			xsk_frames++;
 			break;
 		case IGC_TX_BUFFER_TYPE_XDP:
 			xdp_return_frame(tx_buffer->xdpf);
 			igc_unmap_tx_buffer(tx_ring->dev, tx_buffer);
+			xdp_bytes += tx_buffer->bytecount;
+			xdp_frames++;
 			break;
 		case IGC_TX_BUFFER_TYPE_SKB:
 			napi_consume_skb(tx_buffer->skb, napi_budget);
@@ -2753,6 +2780,10 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)
 	tx_ring->next_to_clean = i;

 	igc_update_tx_stats(q_vector, total_packets, total_bytes);
+	xdp_update_tx_drv_stats(&tx_ring->xdp_stats->xdp_tx, xdp_frames,
+				xdp_bytes);
+	xdp_update_tx_drv_stats(&tx_ring->xdp_stats->xsk_tx, xsk_frames,
+				xsk_bytes);

 	if (tx_ring->xsk_pool) {
 		if (xsk_frames)
@@ -4385,6 +4416,8 @@ static int igc_alloc_q_vector(struct igc_adapter *adapter,
 		ring->count = adapter->tx_ring_count;
 		ring->queue_index = txr_idx;

+		ring->xdp_stats = adapter->netdev->xstats + txr_idx;
+
 		/* assign ring to adapter */
 		adapter->tx_ring[txr_idx] = ring;

@@ -4407,6 +4440,8 @@ static int igc_alloc_q_vector(struct igc_adapter *adapter,
 		ring->count = adapter->rx_ring_count;
 		ring->queue_index = rxr_idx;

+		ring->xdp_stats = adapter->netdev->xstats + rxr_idx;
+
 		/* assign ring to adapter */
 		adapter->rx_ring[rxr_idx] = ring;
 	}
@@ -4515,6 +4550,7 @@ static int igc_sw_init(struct igc_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 	struct pci_dev *pdev = adapter->pdev;
 	struct igc_hw *hw = &adapter->hw;
+	u32 i;

 	pci_read_config_word(pdev, PCI_COMMAND, &hw->bus.pci_cmd_word);

@@ -4544,6 +4580,14 @@ static int igc_sw_init(struct igc_adapter *adapter)

 	igc_init_queue_configuration(adapter);

+	netdev->xstats = kcalloc(IGC_MAX_QUEUES, sizeof(*netdev->xstats),
+				 GFP_KERNEL);
+	if (!netdev->xstats)
+		return -ENOMEM;
+
+	for (i = 0; i < IGC_MAX_QUEUES; i++)
+		xdp_init_drv_stats(netdev->xstats + i);
+
 	/* This call may decrease the number of queues */
 	if (igc_init_interrupt_scheme(adapter, true)) {
 		netdev_err(netdev, "Unable to allocate memory for queues\n");
@@ -6046,11 +6090,25 @@ static int igc_xdp_xmit(struct net_device *dev, int num_frames,
 	if (flags & XDP_XMIT_FLUSH)
 		igc_flush_tx_descriptors(ring);

+	if (unlikely(drops))
+		xdp_update_tx_drv_err(&ring->xdp_stats->xdp_tx, drops);
+
 	__netif_tx_unlock(nq);

 	return num_frames - drops;
 }

+static int igc_get_xdp_stats_nch(const struct net_device *dev, u32 attr_id)
+{
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+	case IFLA_XDP_XSTATS_TYPE_XSK:
+		return IGC_MAX_QUEUES;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static void igc_trigger_rxtxq_interrupt(struct igc_adapter *adapter,
 					struct igc_q_vector *q_vector)
 {
@@ -6096,6 +6154,8 @@ static const struct net_device_ops igc_netdev_ops = {
 	.ndo_set_mac_address	= igc_set_mac,
 	.ndo_change_mtu		= igc_change_mtu,
 	.ndo_get_stats64	= igc_get_stats64,
+	.ndo_get_xdp_stats_nch	= igc_get_xdp_stats_nch,
+	.ndo_get_xdp_stats	= xdp_get_drv_stats_generic,
 	.ndo_fix_features	= igc_fix_features,
 	.ndo_set_features	= igc_set_features,
 	.ndo_features_check	= igc_features_check,
--
2.33.1

