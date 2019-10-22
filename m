Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B757E0794
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732479AbfJVPjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:39:02 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59336 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730305AbfJVPjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:39:02 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 39DB1B40079;
        Tue, 22 Oct 2019 15:39:00 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 22 Oct 2019 16:38:55 +0100
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next 4/6] sfc: allocate channels for XDP tx queues.
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
Message-ID: <762e01f5-a98e-e373-af71-4b9c520c345d@solarflare.com>
Date:   Tue, 22 Oct 2019 16:38:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24994.003
X-TM-AS-Result: No-2.767800-8.000000-10
X-TMASE-MatchedRID: hilUqTVUMKLLs8X/TuXj8jIjK23O9D33Xs5nqGvDCfOrsUj+lMq6Vdt+
        chY6PyflADXE8V3mpEX17VvBPLZDM8WQQYzUTeGcqJSK+HSPY+/pVMb1xnESMnAal2A1DQms849
        Fr+w36gZ8bO6hWfRWzo9CL1e45ag4cj8zE1EjtSS4u3nS+3EEDgqiBO2qhCIGJnrjDUkDicayyQ
        InvLPk/J9BiYiHprlSnfeC95QQABzX5c2ICVaRixMXUu1hb2VrSkWlzdsmIx4lfe31Kb3l/+eyW
        MLRVf2LR39tYegAepJBAdlfZB1JAUsKIxV/FggwogGd8wIUGII6rtY7v1CJp1SOymiJfTYX4Tf2
        mqZbfNh71POrVC8uzA0+N8q2MiERLJEoELHgoqHobINHZkH5xgRryDXHx6oXu6qThyrnanMlBvB
        GAWy5v1DhVv6fJMKid6UKBhltqOPQ4xmA2+JP36o2fOuRT7aaeFyzQYzPQ+QaV9cxC+J6t3MtJ3
        K2p51KLzVAjzMFFsdqkzBBu2KQ+Z7OKJfwqtGqzG0LtXz4gg9Mli8I1FShbqlTFDGZMPhCi38wO
        ddlOpsmbPou3p5z1NI76d96IIOVEbZg2oCkmJjxWp8B+pjaLN1eFEoaE12nKx7rXg4Kr2yCO7OX
        +FrbzRTQNXhJLoauuUcxOd0jl09sXGGtKV3eWxz2MDiYujy5XNY8BwboMUCMUViaYYbK3IxspL0
        xHi6RPdJs51vPe8nU1g4lO1dF7ezP+TfLFFG7ltBnppfPmLr+IchFbM0ooxj9DPxfFdyoa3A6hc
        Nu8nCRddU4B87Xt5soi2XrUn/JyeMtMD9QOgAYvR9ppOlv1vcUt5lc1lLgNedi3nDhxyN0OMmXL
        ayvsvddlKHnTwLDDzUmt/Yo2Y9kS/gyfQOx+9GqIYCrtbamBrE16lVDLOkl9+qH39Hs+tN6Lk+4
        6E0plsPanVcLCNSDr9jtrlmtp3zm6hivSaZZop2lf3StGhISt1bcvKF7ZKbNmFZyaXzY
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.767800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24994.003
X-MDID: 1571758741-RCLb1TQsCdNW
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each CPU needs access to its own queue to allow uncontested
transmission of XDP_TX packets. This means we need to allocate (up
front) enough channels ("xdp transmit channels") to provide at least
one extra tx queue per CPU. These tx queues should not do TSO.

Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c       |  10 +-
 drivers/net/ethernet/sfc/efx.c        | 162 +++++++++++++++++++++++---
 drivers/net/ethernet/sfc/net_driver.h |  34 +++++-
 drivers/net/ethernet/sfc/tx.c         |   2 +
 4 files changed, 184 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 0ec13f520e90..abe138f82723 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1296,8 +1296,9 @@ static int efx_ef10_dimension_resources(struct efx_nic *efx)
 	int rc;
 
 	channel_vis = max(efx->n_channels,
-			  (efx->n_tx_channels + efx->n_extra_tx_channels) *
-			  EFX_TXQ_TYPES);
+			  ((efx->n_tx_channels + efx->n_extra_tx_channels) *
+			   EFX_TXQ_TYPES) +
+			   efx->n_xdp_channels * efx->xdp_tx_per_channel);
 
 #ifdef EFX_USE_PIO
 	/* Try to allocate PIO buffers if wanted and if the full
@@ -2434,11 +2435,12 @@ static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 	/* TSOv2 is a limited resource that can only be configured on a limited
 	 * number of queues. TSO without checksum offload is not really a thing,
 	 * so we only enable it for those queues.
-	 * TSOv2 cannot be used with Hardware timestamping.
+	 * TSOv2 cannot be used with Hardware timestamping, and is never needed
+	 * for XDP tx.
 	 */
 	if (csum_offload && (nic_data->datapath_caps2 &
 			(1 << MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V2_LBN)) &&
-	    !tx_queue->timestamping) {
+	    !tx_queue->timestamping && !tx_queue->xdp_tx) {
 		tso_v2 = true;
 		netif_dbg(efx, hw, efx->net_dev, "Using TSOv2 for channel %u\n",
 				channel->channel);
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index e382129617f9..186c055cd024 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -583,9 +583,13 @@ efx_get_channel_name(struct efx_channel *channel, char *buf, size_t len)
 	int number;
 
 	number = channel->channel;
-	if (efx->tx_channel_offset == 0) {
+
+	if (efx->xdp_channel_offset && number >= efx->xdp_channel_offset) {
+		type = "-xdp";
+		number -= efx->xdp_channel_offset;
+	} else if (efx->tx_channel_offset == 0) {
 		type = "";
-	} else if (channel->channel < efx->tx_channel_offset) {
+	} else if (number < efx->tx_channel_offset) {
 		type = "-rx";
 	} else {
 		type = "-tx";
@@ -802,6 +806,8 @@ static void efx_remove_channels(struct efx_nic *efx)
 
 	efx_for_each_channel(channel, efx)
 		efx_remove_channel(channel);
+
+	kfree(efx->xdp_tx_queues);
 }
 
 int
@@ -1439,6 +1445,99 @@ static unsigned int efx_wanted_parallelism(struct efx_nic *efx)
 	return count;
 }
 
+static int efx_allocate_msix_channels(struct efx_nic *efx,
+				      unsigned int max_channels,
+				      unsigned int extra_channels,
+				      unsigned int parallelism)
+{
+	unsigned int n_channels = parallelism;
+	int vec_count;
+	int n_xdp_tx;
+	int n_xdp_ev;
+
+	if (efx_separate_tx_channels)
+		n_channels *= 2;
+	n_channels += extra_channels;
+
+	/* To allow XDP transmit to happen from arbitrary NAPI contexts
+	 * we allocate a TX queue per CPU. We share event queues across
+	 * multiple tx queues, assuming tx and ev queues are both
+	 * maximum size.
+	 */
+
+	n_xdp_tx = num_possible_cpus();
+	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_TXQ_TYPES);
+
+	/* Check resources.
+	 * We need a channel per event queue, plus a VI per tx queue.
+	 * This may be more pessimistic than it needs to be.
+	 */
+	if (n_channels + n_xdp_ev > max_channels) {
+		netif_err(efx, drv, efx->net_dev,
+			  "Insufficient resources for %d XDP event queues (%d other channels, max %d)\n",
+			  n_xdp_ev, n_channels, max_channels);
+		efx->n_xdp_channels = 0;
+		efx->xdp_tx_per_channel = 0;
+		efx->xdp_tx_queue_count = 0;
+	} else {
+		efx->n_xdp_channels = n_xdp_ev;
+		efx->xdp_tx_per_channel = EFX_TXQ_TYPES;
+		efx->xdp_tx_queue_count = n_xdp_tx;
+		n_channels += n_xdp_ev;
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Allocating %d TX and %d event queues for XDP\n",
+			  n_xdp_tx, n_xdp_ev);
+	}
+
+	n_channels = min(n_channels, max_channels);
+
+	vec_count = pci_msix_vec_count(efx->pci_dev);
+	if (vec_count < 0)
+		return vec_count;
+	if (vec_count < n_channels) {
+		netif_err(efx, drv, efx->net_dev,
+			  "WARNING: Insufficient MSI-X vectors available (%d < %u).\n",
+			  vec_count, n_channels);
+		netif_err(efx, drv, efx->net_dev,
+			  "WARNING: Performance may be reduced.\n");
+		n_channels = vec_count;
+	}
+
+	efx->n_channels = n_channels;
+
+	/* Do not create the PTP TX queue(s) if PTP uses the MC directly. */
+	if (extra_channels && !efx_ptp_use_mac_tx_timestamps(efx))
+		n_channels--;
+
+	/* Ignore XDP tx channels when creating rx channels. */
+	n_channels -= efx->n_xdp_channels;
+
+	if (efx_separate_tx_channels) {
+		efx->n_tx_channels =
+			min(max(n_channels / 2, 1U),
+			    efx->max_tx_channels);
+		efx->tx_channel_offset =
+			n_channels - efx->n_tx_channels;
+		efx->n_rx_channels =
+			max(n_channels -
+			    efx->n_tx_channels, 1U);
+	} else {
+		efx->n_tx_channels = min(n_channels, efx->max_tx_channels);
+		efx->tx_channel_offset = 0;
+		efx->n_rx_channels = n_channels;
+	}
+
+	if (efx->n_xdp_channels)
+		efx->xdp_channel_offset = efx->tx_channel_offset +
+					  efx->n_tx_channels;
+
+	netif_dbg(efx, drv, efx->net_dev,
+		  "Allocating %u RX channels\n",
+		  efx->n_rx_channels);
+
+	return efx->n_channels;
+}
+
 /* Probe the number and type of interrupts we are able to obtain, and
  * the resulting numbers of channels and RX queues.
  */
@@ -1453,19 +1552,19 @@ static int efx_probe_interrupts(struct efx_nic *efx)
 			++extra_channels;
 
 	if (efx->interrupt_mode == EFX_INT_MODE_MSIX) {
+		unsigned int parallelism = efx_wanted_parallelism(efx);
 		struct msix_entry xentries[EFX_MAX_CHANNELS];
 		unsigned int n_channels;
 
-		n_channels = efx_wanted_parallelism(efx);
-		if (efx_separate_tx_channels)
-			n_channels *= 2;
-		n_channels += extra_channels;
-		n_channels = min(n_channels, efx->max_channels);
-
-		for (i = 0; i < n_channels; i++)
-			xentries[i].entry = i;
-		rc = pci_enable_msix_range(efx->pci_dev,
-					   xentries, 1, n_channels);
+		rc = efx_allocate_msix_channels(efx, efx->max_channels,
+						extra_channels, parallelism);
+		if (rc >= 0) {
+			n_channels = rc;
+			for (i = 0; i < n_channels; i++)
+				xentries[i].entry = i;
+			rc = pci_enable_msix_range(efx->pci_dev, xentries, 1,
+						   n_channels);
+		}
 		if (rc < 0) {
 			/* Fall back to single channel MSI */
 			netif_err(efx, drv, efx->net_dev,
@@ -1510,6 +1609,8 @@ static int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1;
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->n_xdp_channels = 0;
+		efx->xdp_channel_offset = 0;
 		rc = pci_enable_msi(efx->pci_dev);
 		if (rc == 0) {
 			efx_get_channel(efx, 0)->irq = efx->pci_dev->irq;
@@ -1528,12 +1629,14 @@ static int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->n_xdp_channels = 0;
+		efx->xdp_channel_offset = 0;
 		efx->legacy_irq = efx->pci_dev->irq;
 	}
 
-	/* Assign extra channels if possible */
+	/* Assign extra channels if possible, before XDP channels */
 	efx->n_extra_tx_channels = 0;
-	j = efx->n_channels;
+	j = efx->xdp_channel_offset ? efx->xdp_channel_offset : efx->n_channels;
 	for (i = 0; i < EFX_MAX_EXTRA_CHANNELS; i++) {
 		if (!efx->extra_channel_type[i])
 			continue;
@@ -1728,29 +1831,50 @@ static void efx_remove_interrupts(struct efx_nic *efx)
 	efx->legacy_irq = 0;
 }
 
-static void efx_set_channels(struct efx_nic *efx)
+static int efx_set_channels(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 	struct efx_tx_queue *tx_queue;
+	int xdp_queue_number;
 
 	efx->tx_channel_offset =
 		efx_separate_tx_channels ?
 		efx->n_channels - efx->n_tx_channels : 0;
 
+	if (efx->xdp_tx_queue_count) {
+		EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
+
+		/* Allocate array for XDP TX queue lookup. */
+		efx->xdp_tx_queues = kcalloc(efx->xdp_tx_queue_count,
+					     sizeof(*efx->xdp_tx_queues),
+					     GFP_KERNEL);
+		if (!efx->xdp_tx_queues)
+			return -ENOMEM;
+	}
+
 	/* We need to mark which channels really have RX and TX
 	 * queues, and adjust the TX queue numbers if we have separate
 	 * RX-only and TX-only channels.
 	 */
+	xdp_queue_number = 0;
 	efx_for_each_channel(channel, efx) {
 		if (channel->channel < efx->n_rx_channels)
 			channel->rx_queue.core_index = channel->channel;
 		else
 			channel->rx_queue.core_index = -1;
 
-		efx_for_each_channel_tx_queue(tx_queue, channel)
+		efx_for_each_channel_tx_queue(tx_queue, channel) {
 			tx_queue->queue -= (efx->tx_channel_offset *
 					    EFX_TXQ_TYPES);
+
+			if (efx_channel_is_xdp_tx(channel)) {
+				EFX_WARN_ON_PARANOID(xdp_queue_number < efx->xdp_tx_queue_count);
+				efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
+				xdp_queue_number++;
+			}
+		}
 	}
+	return 0;
 }
 
 static int efx_probe_nic(struct efx_nic *efx)
@@ -1780,7 +1904,9 @@ static int efx_probe_nic(struct efx_nic *efx)
 		if (rc)
 			goto fail1;
 
-		efx_set_channels(efx);
+		rc = efx_set_channels(efx);
+		if (rc)
+			goto fail1;
 
 		/* dimension_resources can fail with EAGAIN */
 		rc = efx->type->dimension_resources(efx);
@@ -2090,6 +2216,8 @@ int efx_init_irq_moderation(struct efx_nic *efx, unsigned int tx_usecs,
 			channel->irq_moderation_us = rx_usecs;
 		else if (efx_channel_has_tx_queues(channel))
 			channel->irq_moderation_us = tx_usecs;
+		else if (efx_channel_is_xdp_tx(channel))
+			channel->irq_moderation_us = tx_usecs;
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index f920d4924626..4a38f1fdf8a0 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -195,6 +195,7 @@ struct efx_tx_buffer {
  * @piobuf_offset: Buffer offset to be specified in PIO descriptors
  * @initialised: Has hardware queue been initialised?
  * @timestamping: Is timestamping enabled for this channel?
+ * @xdp_tx: Is this an XDP tx queue?
  * @handle_tso: TSO xmit preparation handler.  Sets up the TSO metadata and
  *	may also map tx data, depending on the nature of the TSO implementation.
  * @read_count: Current read pointer.
@@ -256,6 +257,7 @@ struct efx_tx_queue {
 	unsigned int piobuf_offset;
 	bool initialised;
 	bool timestamping;
+	bool xdp_tx;
 
 	/* Function pointers used in the fast path. */
 	int (*handle_tso)(struct efx_tx_queue*, struct sk_buff*, bool *);
@@ -826,6 +828,8 @@ struct efx_async_filter_insertion {
  * @msi_context: Context for each MSI
  * @extra_channel_types: Types of extra (non-traffic) channels that
  *	should be allocated for this NIC
+ * @xdp_tx_queue_count: Number of entries in %xdp_tx_queues.
+ * @xdp_tx_queues: Array of pointers to tx queues used for XDP transmit.
  * @rxq_entries: Size of receive queues requested by user.
  * @txq_entries: Size of transmit queues requested by user.
  * @txq_stop_thresh: TX queue fill level at or above which we stop it.
@@ -838,6 +842,9 @@ struct efx_async_filter_insertion {
  * @n_rx_channels: Number of channels used for RX (= number of RX queues)
  * @n_tx_channels: Number of channels used for TX
  * @n_extra_tx_channels: Number of extra channels with TX queues
+ * @n_xdp_channels: Number of channels used for XDP TX
+ * @xdp_channel_offset: Offset of zeroth channel used for XPD TX.
+ * @xdp_tx_per_channel: Max number of TX queues on an XDP TX channel.
  * @rx_ip_align: RX DMA address offset to have IP header aligned in
  *	in accordance with NET_IP_ALIGN
  * @rx_dma_len: Current maximum RX DMA length
@@ -975,6 +982,9 @@ struct efx_nic {
 	const struct efx_channel_type *
 	extra_channel_type[EFX_MAX_EXTRA_CHANNELS];
 
+	unsigned int xdp_tx_queue_count;
+	struct efx_tx_queue **xdp_tx_queues;
+
 	unsigned rxq_entries;
 	unsigned txq_entries;
 	unsigned int txq_stop_thresh;
@@ -993,6 +1003,9 @@ struct efx_nic {
 	unsigned tx_channel_offset;
 	unsigned n_tx_channels;
 	unsigned n_extra_tx_channels;
+	unsigned int n_xdp_channels;
+	unsigned int xdp_channel_offset;
+	unsigned int xdp_tx_per_channel;
 	unsigned int rx_ip_align;
 	unsigned int rx_dma_len;
 	unsigned int rx_buffer_order;
@@ -1486,10 +1499,24 @@ efx_get_tx_queue(struct efx_nic *efx, unsigned index, unsigned type)
 	return &efx->channel[efx->tx_channel_offset + index]->tx_queue[type];
 }
 
+static inline struct efx_channel *
+efx_get_xdp_channel(struct efx_nic *efx, unsigned int index)
+{
+	EFX_WARN_ON_ONCE_PARANOID(index >= efx->n_xdp_channels);
+	return efx->channel[efx->xdp_channel_offset + index];
+}
+
+static inline bool efx_channel_is_xdp_tx(struct efx_channel *channel)
+{
+	return channel->channel - channel->efx->xdp_channel_offset <
+	       channel->efx->n_xdp_channels;
+}
+
 static inline bool efx_channel_has_tx_queues(struct efx_channel *channel)
 {
-	return channel->type && channel->type->want_txqs &&
-				channel->type->want_txqs(channel);
+	return efx_channel_is_xdp_tx(channel) ||
+	       (channel->type && channel->type->want_txqs &&
+		channel->type->want_txqs(channel));
 }
 
 static inline struct efx_tx_queue *
@@ -1513,7 +1540,8 @@ static inline bool efx_tx_queue_used(struct efx_tx_queue *tx_queue)
 	else								\
 		for (_tx_queue = (_channel)->tx_queue;			\
 		     _tx_queue < (_channel)->tx_queue + EFX_TXQ_TYPES && \
-			     efx_tx_queue_used(_tx_queue);		\
+			     (efx_tx_queue_used(_tx_queue) ||            \
+			      efx_channel_is_xdp_tx(_channel));		\
 		     _tx_queue++)
 
 /* Iterate over all possible TX queues belonging to a channel */
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 9905e8952a45..7602d5506d4b 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -859,6 +859,8 @@ void efx_init_tx_queue(struct efx_tx_queue *tx_queue)
 	tx_queue->completed_timestamp_major = 0;
 	tx_queue->completed_timestamp_minor = 0;
 
+	tx_queue->xdp_tx = efx_channel_is_xdp_tx(tx_queue->channel);
+
 	/* Set up default function pointers. These may get replaced by
 	 * efx_nic_init_tx() based off NIC/queue capabilities.
 	 */
