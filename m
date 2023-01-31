Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBE26829F5
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjAaKIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjAaKID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:08:03 -0500
X-Greylist: delayed 85 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 Jan 2023 02:07:41 PST
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C7A4C0C4
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:07:41 -0800 (PST)
X-QQ-mid: bizesmtp69t1675159586t89a8qrm
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 31 Jan 2023 18:06:24 +0800 (CST)
X-QQ-SSF: 01400000000000M0O000000A0000000
X-QQ-FEAT: tPF3p9zbRDLTrIxvXkYUkM03TuOVT6kt4zOrxEhK1T7BMoneCbC5vA+k4Bjwq
        Op234Sb9Xhs8K0otEb8fR06omC/LKsrcXz/KVxbGD/GXJ8rqvMnCkwcWTYrqPWyYPl2trU1
        XDlUw4vLEvnHRAL+XmBW7/XlCkw/kwLt3XmaBOdVyFG19kPBA4OhyTDYU/pZlRlGRuudwQU
        bsr7WLqfkv5Q0krnZM9iL43aGh1FAtpJtCVrh71BBfpxlvfOCqLIeD/k17rpar+Y9OeNynM
        AprT7pwXIxALkk9N/CLSm3/QoVqPqldkAHJOZBeJGurBkn9bNCwu0i4xCankXDQCOyOmXbB
        o5Fh6WUi+k8fkHEP/ZELOC9uh7MYLANRYPti2hLjH+6/C/Ae4bkfbRTXC7qrTtsAhgl6l5p
        Y/3xfG2Toi+QsNTmJ05Qmw==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v2 08/10] net: libwx: Add tx path to process packets
Date:   Tue, 31 Jan 2023 18:05:39 +0800
Message-Id: <20230131100541.73757-9-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131100541.73757-1-mengyuanlou@net-swift.com>
References: <20230131100541.73757-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support to transmit packets without hardware features.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c   |   4 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  | 439 +++++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_lib.h  |   3 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h |  19 +
 4 files changed, 465 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 2d8b5b9323d7..c68dcec218d3 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -1355,6 +1355,10 @@ static void wx_configure_tx_ring(struct wx *wx,
 		txdctl |= ring->count / 128 << WX_PX_TR_CFG_TR_SIZE_SHIFT;
 	txdctl |= 0x20 << WX_PX_TR_CFG_WTHRESH_SHIFT;
 
+	/* reinitialize tx_buffer_info */
+	memset(ring->tx_buffer_info, 0,
+	       sizeof(struct wx_tx_buffer) * ring->count);
+
 	/* enable queue */
 	wr32(wx, WX_PX_TR_CFG(reg_idx), txdctl);
 
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index fc72b0222327..4f9102e6f725 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -504,6 +504,134 @@ static int wx_clean_rx_irq(struct wx_q_vector *q_vector,
 	return total_rx_packets;
 }
 
+static struct netdev_queue *wx_txring_txq(const struct wx_ring *ring)
+{
+	return netdev_get_tx_queue(ring->netdev, ring->queue_index);
+}
+
+/**
+ * wx_clean_tx_irq - Reclaim resources after transmit completes
+ * @q_vector: structure containing interrupt and ring information
+ * @tx_ring: tx ring to clean
+ * @napi_budget: Used to determine if we are in netpoll
+ **/
+static bool wx_clean_tx_irq(struct wx_q_vector *q_vector,
+			    struct wx_ring *tx_ring, int napi_budget)
+{
+	unsigned int total_bytes = 0, total_packets = 0;
+	unsigned int budget = q_vector->tx.work_limit;
+	unsigned int i = tx_ring->next_to_clean;
+	struct wx_tx_buffer *tx_buffer;
+	union wx_tx_desc *tx_desc;
+
+	if (!netif_carrier_ok(tx_ring->netdev))
+		return true;
+
+	tx_buffer = &tx_ring->tx_buffer_info[i];
+	tx_desc = WX_TX_DESC(tx_ring, i);
+	i -= tx_ring->count;
+
+	do {
+		union wx_tx_desc *eop_desc = tx_buffer->next_to_watch;
+
+		/* if next_to_watch is not set then there is no work pending */
+		if (!eop_desc)
+			break;
+
+		/* prevent any other reads prior to eop_desc */
+		smp_rmb();
+
+		/* if DD is not set pending work has not been completed */
+		if (!(eop_desc->wb.status & cpu_to_le32(WX_TXD_STAT_DD)))
+			break;
+
+		/* clear next_to_watch to prevent false hangs */
+		tx_buffer->next_to_watch = NULL;
+
+		/* update the statistics for this packet */
+		total_bytes += tx_buffer->bytecount;
+		total_packets += tx_buffer->gso_segs;
+
+		/* free the skb */
+		napi_consume_skb(tx_buffer->skb, napi_budget);
+
+		/* unmap skb header data */
+		dma_unmap_single(tx_ring->dev,
+				 dma_unmap_addr(tx_buffer, dma),
+				 dma_unmap_len(tx_buffer, len),
+				 DMA_TO_DEVICE);
+
+		/* clear tx_buffer data */
+		dma_unmap_len_set(tx_buffer, len, 0);
+
+		/* unmap remaining buffers */
+		while (tx_desc != eop_desc) {
+			tx_buffer++;
+			tx_desc++;
+			i++;
+			if (unlikely(!i)) {
+				i -= tx_ring->count;
+				tx_buffer = tx_ring->tx_buffer_info;
+				tx_desc = WX_TX_DESC(tx_ring, 0);
+			}
+
+			/* unmap any remaining paged data */
+			if (dma_unmap_len(tx_buffer, len)) {
+				dma_unmap_page(tx_ring->dev,
+					       dma_unmap_addr(tx_buffer, dma),
+					       dma_unmap_len(tx_buffer, len),
+					       DMA_TO_DEVICE);
+				dma_unmap_len_set(tx_buffer, len, 0);
+			}
+		}
+
+		/* move us one more past the eop_desc for start of next pkt */
+		tx_buffer++;
+		tx_desc++;
+		i++;
+		if (unlikely(!i)) {
+			i -= tx_ring->count;
+			tx_buffer = tx_ring->tx_buffer_info;
+			tx_desc = WX_TX_DESC(tx_ring, 0);
+		}
+
+		/* issue prefetch for next Tx descriptor */
+		prefetch(tx_desc);
+
+		/* update budget accounting */
+		budget--;
+	} while (likely(budget));
+
+	i += tx_ring->count;
+	tx_ring->next_to_clean = i;
+	u64_stats_update_begin(&tx_ring->syncp);
+	tx_ring->stats.bytes += total_bytes;
+	tx_ring->stats.packets += total_packets;
+	u64_stats_update_end(&tx_ring->syncp);
+	q_vector->tx.total_bytes += total_bytes;
+	q_vector->tx.total_packets += total_packets;
+
+	netdev_tx_completed_queue(wx_txring_txq(tx_ring),
+				  total_packets, total_bytes);
+
+#define TX_WAKE_THRESHOLD (DESC_NEEDED * 2)
+	if (unlikely(total_packets && netif_carrier_ok(tx_ring->netdev) &&
+		     (wx_desc_unused(tx_ring) >= TX_WAKE_THRESHOLD))) {
+		/* Make sure that anybody stopping the queue after this
+		 * sees the new next_to_clean.
+		 */
+		smp_mb();
+
+		if (__netif_subqueue_stopped(tx_ring->netdev,
+					     tx_ring->queue_index) &&
+		    netif_running(tx_ring->netdev))
+			netif_wake_subqueue(tx_ring->netdev,
+					    tx_ring->queue_index);
+	}
+
+	return !!budget;
+}
+
 /**
  * wx_poll - NAPI polling RX/TX cleanup routine
  * @napi: napi struct with our devices info in it
@@ -519,6 +647,11 @@ static int wx_poll(struct napi_struct *napi, int budget)
 	bool clean_complete = true;
 	struct wx_ring *ring;
 
+	wx_for_each_ring(ring, q_vector->tx) {
+		if (!wx_clean_tx_irq(q_vector, ring, budget))
+			clean_complete = false;
+	}
+
 	/* Exit if we are called by netpoll */
 	if (budget <= 0)
 		return budget;
@@ -552,6 +685,216 @@ static int wx_poll(struct napi_struct *napi, int budget)
 	return min(work_done, budget - 1);
 }
 
+static int wx_maybe_stop_tx(struct wx_ring *tx_ring, u16 size)
+{
+	if (likely(wx_desc_unused(tx_ring) >= size))
+		return 0;
+
+	netif_stop_subqueue(tx_ring->netdev, tx_ring->queue_index);
+
+	/* For the next check */
+	smp_mb();
+
+	/* We need to check again in a case another CPU has just
+	 * made room available.
+	 */
+	if (likely(wx_desc_unused(tx_ring) < size))
+		return -EBUSY;
+
+	/* A reprieve! - use start_queue because it doesn't call schedule */
+	netif_start_subqueue(tx_ring->netdev, tx_ring->queue_index);
+
+	return 0;
+}
+
+static void wx_tx_map(struct wx_ring *tx_ring,
+		      struct wx_tx_buffer *first)
+{
+	struct sk_buff *skb = first->skb;
+	struct wx_tx_buffer *tx_buffer;
+	u16 i = tx_ring->next_to_use;
+	unsigned int data_len, size;
+	union wx_tx_desc *tx_desc;
+	skb_frag_t *frag;
+	dma_addr_t dma;
+	u32 cmd_type;
+
+	cmd_type = WX_TXD_DTYP_DATA | WX_TXD_IFCS;
+	tx_desc = WX_TX_DESC(tx_ring, i);
+
+	tx_desc->read.olinfo_status = cpu_to_le32(skb->len << WX_TXD_PAYLEN_SHIFT);
+
+	size = skb_headlen(skb);
+	data_len = skb->data_len;
+	dma = dma_map_single(tx_ring->dev, skb->data, size, DMA_TO_DEVICE);
+
+	tx_buffer = first;
+
+	for (frag = &skb_shinfo(skb)->frags[0];; frag++) {
+		if (dma_mapping_error(tx_ring->dev, dma))
+			goto dma_error;
+
+		/* record length, and DMA address */
+		dma_unmap_len_set(tx_buffer, len, size);
+		dma_unmap_addr_set(tx_buffer, dma, dma);
+
+		tx_desc->read.buffer_addr = cpu_to_le64(dma);
+
+		while (unlikely(size > WX_MAX_DATA_PER_TXD)) {
+			tx_desc->read.cmd_type_len =
+				cpu_to_le32(cmd_type ^ WX_MAX_DATA_PER_TXD);
+
+			i++;
+			tx_desc++;
+			if (i == tx_ring->count) {
+				tx_desc = WX_TX_DESC(tx_ring, 0);
+				i = 0;
+			}
+			tx_desc->read.olinfo_status = 0;
+
+			dma += WX_MAX_DATA_PER_TXD;
+			size -= WX_MAX_DATA_PER_TXD;
+
+			tx_desc->read.buffer_addr = cpu_to_le64(dma);
+		}
+
+		if (likely(!data_len))
+			break;
+
+		tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type ^ size);
+
+		i++;
+		tx_desc++;
+		if (i == tx_ring->count) {
+			tx_desc = WX_TX_DESC(tx_ring, 0);
+			i = 0;
+		}
+		tx_desc->read.olinfo_status = 0;
+
+		size = skb_frag_size(frag);
+
+		data_len -= size;
+
+		dma = skb_frag_dma_map(tx_ring->dev, frag, 0, size,
+				       DMA_TO_DEVICE);
+
+		tx_buffer = &tx_ring->tx_buffer_info[i];
+	}
+
+	/* write last descriptor with RS and EOP bits */
+	cmd_type |= size | WX_TXD_EOP | WX_TXD_RS;
+	tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
+
+	netdev_tx_sent_queue(wx_txring_txq(tx_ring), first->bytecount);
+
+	skb_tx_timestamp(skb);
+
+	/* Force memory writes to complete before letting h/w know there
+	 * are new descriptors to fetch.  (Only applicable for weak-ordered
+	 * memory model archs, such as IA-64).
+	 *
+	 * We also need this memory barrier to make certain all of the
+	 * status bits have been updated before next_to_watch is written.
+	 */
+	wmb();
+
+	/* set next_to_watch value indicating a packet is present */
+	first->next_to_watch = tx_desc;
+
+	i++;
+	if (i == tx_ring->count)
+		i = 0;
+
+	tx_ring->next_to_use = i;
+
+	wx_maybe_stop_tx(tx_ring, DESC_NEEDED);
+
+	if (netif_xmit_stopped(wx_txring_txq(tx_ring)) || !netdev_xmit_more())
+		writel(i, tx_ring->tail);
+
+	return;
+dma_error:
+	dev_err(tx_ring->dev, "TX DMA map failed\n");
+
+	/* clear dma mappings for failed tx_buffer_info map */
+	for (;;) {
+		tx_buffer = &tx_ring->tx_buffer_info[i];
+		if (dma_unmap_len(tx_buffer, len))
+			dma_unmap_page(tx_ring->dev,
+				       dma_unmap_addr(tx_buffer, dma),
+				       dma_unmap_len(tx_buffer, len),
+				       DMA_TO_DEVICE);
+		dma_unmap_len_set(tx_buffer, len, 0);
+		if (tx_buffer == first)
+			break;
+		if (i == 0)
+			i += tx_ring->count;
+		i--;
+	}
+
+	dev_kfree_skb_any(first->skb);
+	first->skb = NULL;
+
+	tx_ring->next_to_use = i;
+}
+
+static netdev_tx_t wx_xmit_frame_ring(struct sk_buff *skb,
+				      struct wx_ring *tx_ring)
+{
+	u16 count = TXD_USE_COUNT(skb_headlen(skb));
+	struct wx_tx_buffer *first;
+	unsigned short f;
+
+	/* need: 1 descriptor per page * PAGE_SIZE/WX_MAX_DATA_PER_TXD,
+	 *       + 1 desc for skb_headlen/WX_MAX_DATA_PER_TXD,
+	 *       + 2 desc gap to keep tail from touching head,
+	 *       + 1 desc for context descriptor,
+	 * otherwise try next time
+	 */
+	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
+		count += TXD_USE_COUNT(skb_frag_size(&skb_shinfo(skb)->
+						     frags[f]));
+
+	if (wx_maybe_stop_tx(tx_ring, count + 3))
+		return NETDEV_TX_BUSY;
+
+	/* record the location of the first descriptor for this packet */
+	first = &tx_ring->tx_buffer_info[tx_ring->next_to_use];
+	first->skb = skb;
+	first->bytecount = skb->len;
+	first->gso_segs = 1;
+
+	wx_tx_map(tx_ring, first);
+
+	return NETDEV_TX_OK;
+}
+
+netdev_tx_t wx_xmit_frame(struct sk_buff *skb,
+			  struct net_device *netdev)
+{
+	unsigned int r_idx = skb->queue_mapping;
+	struct wx *wx = netdev_priv(netdev);
+	struct wx_ring *tx_ring;
+
+	if (!netif_carrier_ok(netdev)) {
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+
+	/* The minimum packet size for olinfo paylen is 17 so pad the skb
+	 * in order to meet this minimum size requirement.
+	 */
+	if (skb_put_padto(skb, 17))
+		return NETDEV_TX_OK;
+
+	if (r_idx >= wx->num_tx_queues)
+		r_idx = r_idx % wx->num_tx_queues;
+	tx_ring = wx->tx_ring[r_idx];
+
+	return wx_xmit_frame_ring(skb, tx_ring);
+}
+EXPORT_SYMBOL(wx_xmit_frame);
+
 void wx_napi_enable_all(struct wx *wx)
 {
 	struct wx_q_vector *q_vector;
@@ -1272,6 +1615,81 @@ static void wx_free_all_rx_resources(struct wx *wx)
 		wx_free_rx_resources(wx->rx_ring[i]);
 }
 
+/**
+ * wx_clean_tx_ring - Free Tx Buffers
+ * @tx_ring: ring to be cleaned
+ **/
+static void wx_clean_tx_ring(struct wx_ring *tx_ring)
+{
+	struct wx_tx_buffer *tx_buffer;
+	u16 i = tx_ring->next_to_clean;
+
+	tx_buffer = &tx_ring->tx_buffer_info[i];
+
+	while (i != tx_ring->next_to_use) {
+		union wx_tx_desc *eop_desc, *tx_desc;
+
+		/* Free all the Tx ring sk_buffs */
+		dev_kfree_skb_any(tx_buffer->skb);
+
+		/* unmap skb header data */
+		dma_unmap_single(tx_ring->dev,
+				 dma_unmap_addr(tx_buffer, dma),
+				 dma_unmap_len(tx_buffer, len),
+				 DMA_TO_DEVICE);
+
+		/* check for eop_desc to determine the end of the packet */
+		eop_desc = tx_buffer->next_to_watch;
+		tx_desc = WX_TX_DESC(tx_ring, i);
+
+		/* unmap remaining buffers */
+		while (tx_desc != eop_desc) {
+			tx_buffer++;
+			tx_desc++;
+			i++;
+			if (unlikely(i == tx_ring->count)) {
+				i = 0;
+				tx_buffer = tx_ring->tx_buffer_info;
+				tx_desc = WX_TX_DESC(tx_ring, 0);
+			}
+
+			/* unmap any remaining paged data */
+			if (dma_unmap_len(tx_buffer, len))
+				dma_unmap_page(tx_ring->dev,
+					       dma_unmap_addr(tx_buffer, dma),
+					       dma_unmap_len(tx_buffer, len),
+					       DMA_TO_DEVICE);
+		}
+
+		/* move us one more past the eop_desc for start of next pkt */
+		tx_buffer++;
+		i++;
+		if (unlikely(i == tx_ring->count)) {
+			i = 0;
+			tx_buffer = tx_ring->tx_buffer_info;
+		}
+	}
+
+	netdev_tx_reset_queue(wx_txring_txq(tx_ring));
+
+	/* reset next_to_use and next_to_clean */
+	tx_ring->next_to_use = 0;
+	tx_ring->next_to_clean = 0;
+}
+
+/**
+ * wx_clean_all_tx_rings - Free Tx Buffers for all queues
+ * @wx: board private structure
+ **/
+void wx_clean_all_tx_rings(struct wx *wx)
+{
+	int i;
+
+	for (i = 0; i < wx->num_tx_queues; i++)
+		wx_clean_tx_ring(wx->tx_ring[i]);
+}
+EXPORT_SYMBOL(wx_clean_all_tx_rings);
+
 /**
  * wx_free_tx_resources - Free Tx Resources per Queue
  * @tx_ring: Tx descriptor ring for a specific queue
@@ -1280,6 +1698,7 @@ static void wx_free_all_rx_resources(struct wx *wx)
  **/
 static void wx_free_tx_resources(struct wx_ring *tx_ring)
 {
+	wx_clean_tx_ring(tx_ring);
 	kvfree(tx_ring->tx_buffer_info);
 	tx_ring->tx_buffer_info = NULL;
 
@@ -1466,6 +1885,9 @@ static int wx_setup_tx_resources(struct wx_ring *tx_ring)
 	if (!tx_ring->desc)
 		goto err;
 
+	tx_ring->next_to_use = 0;
+	tx_ring->next_to_clean = 0;
+
 	return 0;
 
 err:
@@ -1563,6 +1985,23 @@ void wx_get_stats64(struct net_device *netdev,
 		}
 	}
 
+	for (i = 0; i < wx->num_tx_queues; i++) {
+		struct wx_ring *ring = READ_ONCE(wx->tx_ring[i]);
+		u64 bytes, packets;
+		unsigned int start;
+
+		if (ring) {
+			do {
+				start = u64_stats_fetch_begin(&ring->syncp);
+				packets = ring->stats.packets;
+				bytes   = ring->stats.bytes;
+			} while (u64_stats_fetch_retry(&ring->syncp,
+							   start));
+			stats->tx_packets += packets;
+			stats->tx_bytes   += bytes;
+		}
+	}
+
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(wx_get_stats64);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.h b/drivers/net/ethernet/wangxun/libwx/wx_lib.h
index 8fc7f6f3d40e..50ee41f1fa10 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.h
@@ -9,6 +9,8 @@
 
 void wx_alloc_rx_buffers(struct wx_ring *rx_ring, u16 cleaned_count);
 u16 wx_desc_unused(struct wx_ring *ring);
+netdev_tx_t wx_xmit_frame(struct sk_buff *skb,
+			  struct net_device *netdev);
 void wx_napi_enable_all(struct wx *wx);
 void wx_napi_disable_all(struct wx *wx);
 void wx_reset_interrupt_capability(struct wx *wx);
@@ -21,6 +23,7 @@ void wx_free_isb_resources(struct wx *wx);
 u32 wx_misc_isb(struct wx *wx, enum wx_isb_idx idx);
 void wx_configure_vectors(struct wx *wx);
 void wx_clean_all_rx_rings(struct wx *wx);
+void wx_clean_all_tx_rings(struct wx *wx);
 void wx_free_resources(struct wx *wx);
 int wx_setup_resources(struct wx *wx);
 void wx_get_stats64(struct net_device *netdev,
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index fd05c0597d94..4e988896ad97 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -312,6 +312,15 @@
 #endif
 
 #define WX_RX_BUFFER_WRITE   16      /* Must be power of 2 */
+
+#define WX_MAX_DATA_PER_TXD  BIT(14)
+/* Tx Descriptors needed, worst case */
+#define TXD_USE_COUNT(S)     DIV_ROUND_UP((S), WX_MAX_DATA_PER_TXD)
+#define DESC_NEEDED          (MAX_SKB_FRAGS + 4)
+
+/* Ether Types */
+#define WX_ETH_P_CNM                 0x22E7
+
 #define WX_CFG_PORT_ST               0x14404
 
 /******************* Receive Descriptor bit definitions **********************/
@@ -320,6 +329,14 @@
 
 #define WX_RXD_ERR_RXE               BIT(29) /* Any MAC Error */
 
+/*********************** Transmit Descriptor Config Masks ****************/
+#define WX_TXD_STAT_DD               BIT(0)  /* Descriptor Done */
+#define WX_TXD_DTYP_DATA             0       /* Adv Data Descriptor */
+#define WX_TXD_PAYLEN_SHIFT          13      /* Desc PAYLEN shift */
+#define WX_TXD_EOP                   BIT(24) /* End of Packet */
+#define WX_TXD_IFCS                  BIT(25) /* Insert FCS */
+#define WX_TXD_RS                    BIT(27) /* Report Status */
+
 /* Host Interface Command Structures */
 struct wx_hic_hdr {
 	u8 cmd;
@@ -496,6 +513,8 @@ union wx_rx_desc {
 
 #define WX_RX_DESC(R, i)     \
 	(&(((union wx_rx_desc *)((R)->desc))[i]))
+#define WX_TX_DESC(R, i)     \
+	(&(((union wx_tx_desc *)((R)->desc))[i]))
 
 /* wrapper around a pointer to a socket buffer,
  * so a DMA handle can be stored along with the buffer
-- 
2.39.1

