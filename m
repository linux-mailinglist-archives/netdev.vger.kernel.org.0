Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D0A50BAFC
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448719AbiDVPD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449101AbiDVPC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:02:28 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E878E5C871
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:59:31 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id D8A6E320133;
        Fri, 22 Apr 2022 15:59:29 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhukq-0007AI-P1; Fri, 22 Apr 2022 15:59:28 +0100
Subject: [PATCH net-next 11/28] sfc/siena: Rename functions in tx_common.h
 to avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 15:59:28 +0100
Message-ID: <165063956828.27138.4319663390402064592.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Habets <martinh@xilinx.com>

For siena use efx_siena_ as the function prefix.
Several functions are not used in Siena, so they are removed.
Use a Siena specific variable name for module parameter
efx_separate_tx_channels.
Move efx_fini_tx_queue() to avoid a forward declaration of
efx_dequeue_buffer().

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c          |    5 +-
 drivers/net/ethernet/sfc/siena/efx.h          |    2 -
 drivers/net/ethernet/sfc/siena/efx_channels.c |   16 ++---
 drivers/net/ethernet/sfc/siena/efx_common.c   |    2 -
 drivers/net/ethernet/sfc/siena/tx.c           |    8 +-
 drivers/net/ethernet/sfc/siena/tx_common.c    |   83 +++++++++++++------------
 drivers/net/ethernet/sfc/siena/tx_common.h    |   32 ++++------
 7 files changed, 72 insertions(+), 76 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index f1a46a28b934..70da9d7afbc5 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -58,8 +58,9 @@ MODULE_PARM_DESC(rss_cpus, "Number of CPUs to use for Receive-Side Scaling");
  *
  * This is only used in MSI-X interrupt mode
  */
-bool efx_separate_tx_channels;
-module_param(efx_separate_tx_channels, bool, 0444);
+bool efx_siena_separate_tx_channels;
+module_param_named(efx_separate_tx_channels, efx_siena_separate_tx_channels,
+		   bool, 0444);
 MODULE_PARM_DESC(efx_separate_tx_channels,
 		 "Use separate channels for TX and RX");
 
diff --git a/drivers/net/ethernet/sfc/siena/efx.h b/drivers/net/ethernet/sfc/siena/efx.h
index 18099bb21f61..f91f3c94a275 100644
--- a/drivers/net/ethernet/sfc/siena/efx.h
+++ b/drivers/net/ethernet/sfc/siena/efx.h
@@ -44,7 +44,7 @@ static inline void efx_rx_flush_packet(struct efx_channel *channel)
  * TSO skbs.
  */
 #define EFX_RXQ_MIN_ENT		128U
-#define EFX_TXQ_MIN_ENT(efx)	(2 * efx_tx_max_skb_descs(efx))
+#define EFX_TXQ_MIN_ENT(efx)	(2 * efx_siena_tx_max_skb_descs(efx))
 
 /* All EF10 architecture NICs steal one bit of the DMAQ size for various
  * other purposes when counting TxQ entries, so we halve the queue size.
diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index bc17d8e7c6bc..9fc299d7a048 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -138,7 +138,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 	int n_xdp_tx;
 	int n_xdp_ev;
 
-	if (efx_separate_tx_channels)
+	if (efx_siena_separate_tx_channels)
 		n_channels *= 2;
 	n_channels += extra_channels;
 
@@ -220,7 +220,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 	/* Ignore XDP tx channels when creating rx channels. */
 	n_channels -= efx->n_xdp_channels;
 
-	if (efx_separate_tx_channels) {
+	if (efx_siena_separate_tx_channels) {
 		efx->n_tx_channels =
 			min(max(n_channels / 2, 1U),
 			    efx->max_tx_channels);
@@ -321,7 +321,7 @@ int efx_siena_probe_interrupts(struct efx_nic *efx)
 
 	/* Assume legacy interrupts */
 	if (efx->interrupt_mode == EFX_INT_MODE_LEGACY) {
-		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
+		efx->n_channels = 1 + (efx_siena_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
 		efx->n_xdp_channels = 0;
@@ -658,7 +658,7 @@ static int efx_probe_channel(struct efx_channel *channel)
 		goto fail;
 
 	efx_for_each_channel_tx_queue(tx_queue, channel) {
-		rc = efx_probe_tx_queue(tx_queue);
+		rc = efx_siena_probe_tx_queue(tx_queue);
 		if (rc)
 			goto fail;
 	}
@@ -754,7 +754,7 @@ void efx_siena_remove_channel(struct efx_channel *channel)
 	efx_for_each_channel_rx_queue(rx_queue, channel)
 		efx_siena_remove_rx_queue(rx_queue);
 	efx_for_each_channel_tx_queue(tx_queue, channel)
-		efx_remove_tx_queue(tx_queue);
+		efx_siena_remove_tx_queue(tx_queue);
 	efx_remove_eventq(channel);
 	channel->type->post_remove(channel);
 }
@@ -901,7 +901,7 @@ int efx_siena_set_channels(struct efx_nic *efx)
 	int rc;
 
 	efx->tx_channel_offset =
-		efx_separate_tx_channels ?
+		efx_siena_separate_tx_channels ?
 		efx->n_channels - efx->n_tx_channels : 0;
 
 	if (efx->xdp_tx_queue_count) {
@@ -1115,7 +1115,7 @@ void efx_siena_start_channels(struct efx_nic *efx)
 
 	efx_for_each_channel(channel, efx) {
 		efx_for_each_channel_tx_queue(tx_queue, channel) {
-			efx_init_tx_queue(tx_queue);
+			efx_siena_init_tx_queue(tx_queue);
 			atomic_inc(&efx->active_queues);
 		}
 
@@ -1171,7 +1171,7 @@ void efx_siena_stop_channels(struct efx_nic *efx)
 		efx_for_each_channel_rx_queue(rx_queue, channel)
 			efx_siena_fini_rx_queue(rx_queue);
 		efx_for_each_channel_tx_queue(tx_queue, channel)
-			efx_fini_tx_queue(tx_queue);
+			efx_siena_fini_tx_queue(tx_queue);
 	}
 }
 
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index e12083d28a47..f245d03c4caa 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -428,7 +428,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 	 * the ring completely.  We wake it when half way back to
 	 * empty.
 	 */
-	efx->txq_stop_thresh = efx->txq_entries - efx_tx_max_skb_descs(efx);
+	efx->txq_stop_thresh = efx->txq_entries - efx_siena_tx_max_skb_descs(efx);
 	efx->txq_wake_thresh = efx->txq_stop_thresh / 2;
 
 	/* Initialise the channels */
diff --git a/drivers/net/ethernet/sfc/siena/tx.c b/drivers/net/ethernet/sfc/siena/tx.c
index bfc15c018e66..2e9b0f172b4a 100644
--- a/drivers/net/ethernet/sfc/siena/tx.c
+++ b/drivers/net/ethernet/sfc/siena/tx.c
@@ -156,7 +156,7 @@ netdev_tx_t __efx_siena_enqueue_skb(struct efx_tx_queue *tx_queue,
 	 * size limit.
 	 */
 	if (segments) {
-		rc = efx_tx_tso_fallback(tx_queue, skb);
+		rc = efx_siena_tx_tso_fallback(tx_queue, skb);
 		tx_queue->tso_fallbacks++;
 		if (rc == 0)
 			return 0;
@@ -170,7 +170,7 @@ netdev_tx_t __efx_siena_enqueue_skb(struct efx_tx_queue *tx_queue,
 	}
 
 	/* Map for DMA and create descriptors if we haven't done so already. */
-	if (!data_mapped && (efx_tx_map_data(tx_queue, skb, segments)))
+	if (!data_mapped && (efx_siena_tx_map_data(tx_queue, skb, segments)))
 		goto err;
 
 	efx_tx_maybe_stop_queue(tx_queue);
@@ -193,7 +193,7 @@ netdev_tx_t __efx_siena_enqueue_skb(struct efx_tx_queue *tx_queue,
 
 
 err:
-	efx_enqueue_unwind(tx_queue, old_insert_count);
+	efx_siena_enqueue_unwind(tx_queue, old_insert_count);
 	dev_kfree_skb_any(skb);
 
 	/* If we're not expecting another transmit and we had something to push
@@ -274,7 +274,7 @@ int efx_siena_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpf
 			break;
 
 		/*  Create descriptor and set up for unmapping DMA. */
-		tx_buffer = efx_tx_map_chunk(tx_queue, dma_addr, len);
+		tx_buffer = efx_siena_tx_map_chunk(tx_queue, dma_addr, len);
 		tx_buffer->xdpf = xdpf;
 		tx_buffer->flags = EFX_TX_BUF_XDP |
 				   EFX_TX_BUF_MAP_SINGLE;
diff --git a/drivers/net/ethernet/sfc/siena/tx_common.c b/drivers/net/ethernet/sfc/siena/tx_common.c
index 298eb198f23d..66adc8525a3a 100644
--- a/drivers/net/ethernet/sfc/siena/tx_common.c
+++ b/drivers/net/ethernet/sfc/siena/tx_common.c
@@ -19,7 +19,7 @@ static unsigned int efx_tx_cb_page_count(struct efx_tx_queue *tx_queue)
 			    PAGE_SIZE >> EFX_TX_CB_ORDER);
 }
 
-int efx_probe_tx_queue(struct efx_tx_queue *tx_queue)
+int efx_siena_probe_tx_queue(struct efx_tx_queue *tx_queue)
 {
 	struct efx_nic *efx = tx_queue->efx;
 	unsigned int entries;
@@ -64,7 +64,7 @@ int efx_probe_tx_queue(struct efx_tx_queue *tx_queue)
 	return rc;
 }
 
-void efx_init_tx_queue(struct efx_tx_queue *tx_queue)
+void efx_siena_init_tx_queue(struct efx_tx_queue *tx_queue)
 {
 	struct efx_nic *efx = tx_queue->efx;
 
@@ -94,30 +94,7 @@ void efx_init_tx_queue(struct efx_tx_queue *tx_queue)
 	tx_queue->initialised = true;
 }
 
-void efx_fini_tx_queue(struct efx_tx_queue *tx_queue)
-{
-	struct efx_tx_buffer *buffer;
-
-	netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
-		  "shutting down TX queue %d\n", tx_queue->queue);
-
-	if (!tx_queue->buffer)
-		return;
-
-	/* Free any buffers left in the ring */
-	while (tx_queue->read_count != tx_queue->write_count) {
-		unsigned int pkts_compl = 0, bytes_compl = 0;
-
-		buffer = &tx_queue->buffer[tx_queue->read_count & tx_queue->ptr_mask];
-		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
-
-		++tx_queue->read_count;
-	}
-	tx_queue->xmit_pending = false;
-	netdev_tx_reset_queue(tx_queue->core_txq);
-}
-
-void efx_remove_tx_queue(struct efx_tx_queue *tx_queue)
+void efx_siena_remove_tx_queue(struct efx_tx_queue *tx_queue)
 {
 	int i;
 
@@ -141,10 +118,10 @@ void efx_remove_tx_queue(struct efx_tx_queue *tx_queue)
 	tx_queue->channel->tx_queue_by_type[tx_queue->type] = NULL;
 }
 
-void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
-			struct efx_tx_buffer *buffer,
-			unsigned int *pkts_compl,
-			unsigned int *bytes_compl)
+static void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
+			       struct efx_tx_buffer *buffer,
+			       unsigned int *pkts_compl,
+			       unsigned int *bytes_compl)
 {
 	if (buffer->unmap_len) {
 		struct device *dma_dev = &tx_queue->efx->pci_dev->dev;
@@ -189,6 +166,29 @@ void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
 	buffer->flags = 0;
 }
 
+void efx_siena_fini_tx_queue(struct efx_tx_queue *tx_queue)
+{
+	struct efx_tx_buffer *buffer;
+
+	netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
+		  "shutting down TX queue %d\n", tx_queue->queue);
+
+	if (!tx_queue->buffer)
+		return;
+
+	/* Free any buffers left in the ring */
+	while (tx_queue->read_count != tx_queue->write_count) {
+		unsigned int pkts_compl = 0, bytes_compl = 0;
+
+		buffer = &tx_queue->buffer[tx_queue->read_count & tx_queue->ptr_mask];
+		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
+
+		++tx_queue->read_count;
+	}
+	tx_queue->xmit_pending = false;
+	netdev_tx_reset_queue(tx_queue->core_txq);
+}
+
 /* Remove packets from the TX queue
  *
  * This removes packets from the TX queue, up to and including the
@@ -269,8 +269,8 @@ void efx_siena_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
 /* Remove buffers put into a tx_queue for the current packet.
  * None of the buffers must have an skb attached.
  */
-void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
-			unsigned int insert_count)
+void efx_siena_enqueue_unwind(struct efx_tx_queue *tx_queue,
+			      unsigned int insert_count)
 {
 	struct efx_tx_buffer *buffer;
 	unsigned int bytes_compl = 0;
@@ -284,8 +284,8 @@ void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
 	}
 }
 
-struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
-				       dma_addr_t dma_addr, size_t len)
+struct efx_tx_buffer *efx_siena_tx_map_chunk(struct efx_tx_queue *tx_queue,
+					     dma_addr_t dma_addr, size_t len)
 {
 	const struct efx_nic_type *nic_type = tx_queue->efx->type;
 	struct efx_tx_buffer *buffer;
@@ -311,7 +311,7 @@ struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
 	return buffer;
 }
 
-int efx_tx_tso_header_length(struct sk_buff *skb)
+static int efx_tx_tso_header_length(struct sk_buff *skb)
 {
 	size_t header_len;
 
@@ -326,8 +326,8 @@ int efx_tx_tso_header_length(struct sk_buff *skb)
 }
 
 /* Map all data from an SKB for DMA and create descriptors on the queue. */
-int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
-		    unsigned int segment_count)
+int efx_siena_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+			  unsigned int segment_count)
 {
 	struct efx_nic *efx = tx_queue->efx;
 	struct device *dma_dev = &efx->pci_dev->dev;
@@ -357,7 +357,7 @@ int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 
 		if (header_len != len) {
 			tx_queue->tso_long_headers++;
-			efx_tx_map_chunk(tx_queue, dma_addr, header_len);
+			efx_siena_tx_map_chunk(tx_queue, dma_addr, header_len);
 			len -= header_len;
 			dma_addr += header_len;
 		}
@@ -368,7 +368,7 @@ int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 		struct efx_tx_buffer *buffer;
 		skb_frag_t *fragment;
 
-		buffer = efx_tx_map_chunk(tx_queue, dma_addr, len);
+		buffer = efx_siena_tx_map_chunk(tx_queue, dma_addr, len);
 
 		/* The final descriptor for a fragment is responsible for
 		 * unmapping the whole fragment.
@@ -400,7 +400,7 @@ int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 	} while (1);
 }
 
-unsigned int efx_tx_max_skb_descs(struct efx_nic *efx)
+unsigned int efx_siena_tx_max_skb_descs(struct efx_nic *efx)
 {
 	/* Header and payload descriptor for each output segment, plus
 	 * one for every input fragment boundary within a segment
@@ -428,7 +428,8 @@ unsigned int efx_tx_max_skb_descs(struct efx_nic *efx)
  *
  * Returns 0 on success, error code otherwise.
  */
-int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
+int efx_siena_tx_tso_fallback(struct efx_tx_queue *tx_queue,
+			      struct sk_buff *skb)
 {
 	struct sk_buff *segments, *next;
 
diff --git a/drivers/net/ethernet/sfc/siena/tx_common.h b/drivers/net/ethernet/sfc/siena/tx_common.h
index 602f5a052918..31ca52a25015 100644
--- a/drivers/net/ethernet/sfc/siena/tx_common.h
+++ b/drivers/net/ethernet/sfc/siena/tx_common.h
@@ -11,15 +11,10 @@
 #ifndef EFX_TX_COMMON_H
 #define EFX_TX_COMMON_H
 
-int efx_probe_tx_queue(struct efx_tx_queue *tx_queue);
-void efx_init_tx_queue(struct efx_tx_queue *tx_queue);
-void efx_fini_tx_queue(struct efx_tx_queue *tx_queue);
-void efx_remove_tx_queue(struct efx_tx_queue *tx_queue);
-
-void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
-			struct efx_tx_buffer *buffer,
-			unsigned int *pkts_compl,
-			unsigned int *bytes_compl);
+int efx_siena_probe_tx_queue(struct efx_tx_queue *tx_queue);
+void efx_siena_init_tx_queue(struct efx_tx_queue *tx_queue);
+void efx_siena_fini_tx_queue(struct efx_tx_queue *tx_queue);
+void efx_siena_remove_tx_queue(struct efx_tx_queue *tx_queue);
 
 static inline bool efx_tx_buffer_in_use(struct efx_tx_buffer *buffer)
 {
@@ -29,17 +24,16 @@ static inline bool efx_tx_buffer_in_use(struct efx_tx_buffer *buffer)
 void efx_siena_xmit_done_check_empty(struct efx_tx_queue *tx_queue);
 void efx_siena_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
 
-void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
-			unsigned int insert_count);
+void efx_siena_enqueue_unwind(struct efx_tx_queue *tx_queue,
+			      unsigned int insert_count);
 
-struct efx_tx_buffer *efx_tx_map_chunk(struct efx_tx_queue *tx_queue,
-				       dma_addr_t dma_addr, size_t len);
-int efx_tx_tso_header_length(struct sk_buff *skb);
-int efx_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
-		    unsigned int segment_count);
+struct efx_tx_buffer *efx_siena_tx_map_chunk(struct efx_tx_queue *tx_queue,
+					     dma_addr_t dma_addr, size_t len);
+int efx_siena_tx_map_data(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+			  unsigned int segment_count);
 
-unsigned int efx_tx_max_skb_descs(struct efx_nic *efx);
-int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
+unsigned int efx_siena_tx_max_skb_descs(struct efx_nic *efx);
+int efx_siena_tx_tso_fallback(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
 
-extern bool efx_separate_tx_channels;
+extern bool efx_siena_separate_tx_channels;
 #endif

