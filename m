Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DD25A5C8A
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiH3HHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiH3HHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:07:20 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EF072855
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:07:00 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843153tr61pruk
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:05:52 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: khYyH2quB8zd9Kuk3PGC6luGRh05rHBGhR2JzVpN9MnuK0z1FphivxkLdnI2B
        DWaOeYzOm6IHahnNo80Y9a7pRZTrN5zweXQ3HdweAxzVqr1fpd88y1XagGACZyKl5lNU6II
        T4dr/AoqUobMDmzlvlka2EWXSycWHKX+wQtHszUQ6eDhGErgHbvcYOpVlc/TjAMPtjC6MuB
        i7YucjTX4mbLs9M/DnNKaYa5owZERc4yJWgvUovv2OtA79g4Skn/4T3O5x1zKuc6nZDBgo7
        EUupiQ160Q3GdAZBhQ3ZkVMOYOdzOPvpptvEqt/IJ767TFl/YF0vq+wPEApmpCvHrS02cVP
        4pqgw/YyKDBA95+k4IfXW4+JUzf/pkfIAxkqAgNudamlcFVeLKo0Zb39uRzZJSmWFQQb0A4
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 12/16] net: txgbe: Add Rx and Tx cleanup routine
Date:   Tue, 30 Aug 2022 15:04:50 +0800
Message-Id: <20220830070454.146211-13-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220830070454.146211-1-jiawenwu@trustnetic.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support to clean all queues associated with a q_vector, in NAPI polling.
Add to simple receive packets, without hardware features.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  62 ++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 824 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  13 +
 3 files changed, 899 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index a6640bedd3d2..075ca4f6bc07 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -43,12 +43,26 @@
  */
 #define TXGBE_RX_HDR_SIZE       TXGBE_RXBUFFER_256
 
+/* How many Rx Buffers do we bundle into one write to the hardware ? */
+#define TXGBE_RX_BUFFER_WRITE   16      /* Must be power of 2 */
+#define TXGBE_RX_DMA_ATTR \
+	(DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
+
+#ifndef MAX_SKB_FRAGS
+#define DESC_NEEDED     4
+#elif (MAX_SKB_FRAGS < 16)
+#define DESC_NEEDED     ((MAX_SKB_FRAGS * TXD_USE_COUNT(PAGE_SIZE)) + 4)
+#else
+#define DESC_NEEDED     (MAX_SKB_FRAGS + 4)
+#endif
+
 /* wrapper around a pointer to a socket buffer,
  * so a DMA handle can be stored along with the buffer
  */
 struct txgbe_tx_buffer {
 	union txgbe_tx_desc *next_to_watch;
 	struct sk_buff *skb;
+	unsigned int bytecount;
 	DEFINE_DMA_UNMAP_ADDR(dma);
 	DEFINE_DMA_UNMAP_LEN(len);
 };
@@ -58,6 +72,22 @@ struct txgbe_rx_buffer {
 	dma_addr_t dma;
 	dma_addr_t page_dma;
 	struct page *page;
+	unsigned int page_offset;
+};
+
+struct txgbe_queue_stats {
+	u64 packets;
+	u64 bytes;
+};
+
+struct txgbe_tx_queue_stats {
+	u64 restart_queue;
+};
+
+struct txgbe_rx_queue_stats {
+	u64 non_eop_descs;
+	u64 alloc_rx_page_failed;
+	u64 alloc_rx_buff_failed;
 };
 
 struct txgbe_ring {
@@ -82,6 +112,13 @@ struct txgbe_ring {
 	u16 next_to_clean;
 	u16 rx_buf_len;
 	u16 next_to_alloc;
+	struct txgbe_queue_stats stats;
+	struct u64_stats_sync syncp;
+
+	union {
+		struct txgbe_tx_queue_stats tx_stats;
+		struct txgbe_rx_queue_stats rx_stats;
+	};
 } ____cacheline_internodealigned_in_smp;
 
 #define TXGBE_MAX_FDIR_INDICES          63
@@ -109,8 +146,11 @@ static inline unsigned int txgbe_rx_pg_order(struct txgbe_ring __maybe_unused *r
 
 struct txgbe_ring_container {
 	struct txgbe_ring *ring;        /* pointer to linked list of rings */
+	unsigned int total_bytes;       /* total bytes processed this int */
+	unsigned int total_packets;     /* total packets processed this int */
 	u16 work_limit;                 /* total work allowed per interrupt */
 	u8 count;                       /* total number of rings in vector */
+	u8 itr;                         /* current ITR setting for ring */
 };
 
 /* iterator for handling rings in ring container */
@@ -148,6 +188,27 @@ struct txgbe_q_vector {
 #define TXGBE_16K_ITR           248
 #define TXGBE_12K_ITR           336
 
+/* txgbe_test_staterr - tests bits in Rx descriptor status and error fields */
+static inline __le32 txgbe_test_staterr(union txgbe_rx_desc *rx_desc,
+					const u32 stat_err_bits)
+{
+	return rx_desc->wb.upper.status_error & cpu_to_le32(stat_err_bits);
+}
+
+/* txgbe_desc_unused - calculate if we have unused descriptors */
+static inline u16 txgbe_desc_unused(struct txgbe_ring *ring)
+{
+	u16 ntc = ring->next_to_clean;
+	u16 ntu = ring->next_to_use;
+
+	return ((ntc > ntu) ? 0 : ring->count) + ntc - ntu - 1;
+}
+
+#define TXGBE_RX_DESC(R, i)     \
+	(&(((union txgbe_rx_desc *)((R)->desc))[i]))
+#define TXGBE_TX_DESC(R, i)     \
+	(&(((union txgbe_tx_desc *)((R)->desc))[i]))
+
 #define TXGBE_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */
 
 #define TCP_TIMER_VECTOR        0
@@ -325,6 +386,7 @@ void txgbe_set_interrupt_capability(struct txgbe_adapter *adapter);
 void txgbe_clear_interrupt_scheme(struct txgbe_adapter *adapter);
 void txgbe_unmap_and_free_tx_resource(struct txgbe_ring *ring,
 				      struct txgbe_tx_buffer *tx_buffer);
+void txgbe_alloc_rx_buffers(struct txgbe_ring *rx_ring, u16 cleaned_count);
 void txgbe_configure_port(struct txgbe_adapter *adapter);
 void txgbe_set_rx_mode(struct net_device *netdev);
 int txgbe_write_mc_addr_list(struct net_device *netdev);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 7680a7e2cb8f..2e72a3d6313a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -171,6 +171,654 @@ void txgbe_unmap_and_free_tx_resource(struct txgbe_ring *ring,
 	/* tx_buffer must be completely set up in the transmit path */
 }
 
+/**
+ * txgbe_clean_tx_irq - Reclaim resources after transmit completes
+ * @q_vector: structure containing interrupt and ring information
+ * @tx_ring: tx ring to clean
+ **/
+static bool txgbe_clean_tx_irq(struct txgbe_q_vector *q_vector,
+			       struct txgbe_ring *tx_ring)
+{
+	struct txgbe_adapter *adapter = q_vector->adapter;
+	unsigned int total_bytes = 0, total_packets = 0;
+	unsigned int budget = q_vector->tx.work_limit;
+	unsigned int i = tx_ring->next_to_clean;
+	struct txgbe_tx_buffer *tx_buffer;
+	union txgbe_tx_desc *tx_desc;
+
+	if (test_bit(__TXGBE_DOWN, &adapter->state))
+		return true;
+
+	tx_buffer = &tx_ring->tx_buffer_info[i];
+	tx_desc = TXGBE_TX_DESC(tx_ring, i);
+	i -= tx_ring->count;
+
+	do {
+		union txgbe_tx_desc *eop_desc = tx_buffer->next_to_watch;
+
+		/* if next_to_watch is not set then there is no work pending */
+		if (!eop_desc)
+			break;
+
+		/* prevent any other reads prior to eop_desc */
+		smp_rmb();
+
+		/* if DD is not set pending work has not been completed */
+		if (!(eop_desc->wb.status & cpu_to_le32(TXGBE_TXD_STAT_DD)))
+			break;
+
+		/* clear next_to_watch to prevent false hangs */
+		tx_buffer->next_to_watch = NULL;
+
+		/* update the statistics for this packet */
+		total_bytes += tx_buffer->bytecount;
+
+		/* free the skb */
+		dev_consume_skb_any(tx_buffer->skb);
+
+		/* unmap skb header data */
+		dma_unmap_single(tx_ring->dev,
+				 dma_unmap_addr(tx_buffer, dma),
+				 dma_unmap_len(tx_buffer, len),
+				 DMA_TO_DEVICE);
+
+		/* clear tx_buffer data */
+		tx_buffer->skb = NULL;
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
+				tx_desc = TXGBE_TX_DESC(tx_ring, 0);
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
+			tx_desc = TXGBE_TX_DESC(tx_ring, 0);
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
+	netdev_tx_completed_queue(txring_txq(tx_ring),
+				  total_packets, total_bytes);
+
+#define TX_WAKE_THRESHOLD (DESC_NEEDED * 2)
+	if (unlikely(total_packets && netif_carrier_ok(tx_ring->netdev) &&
+		     (txgbe_desc_unused(tx_ring) >= TX_WAKE_THRESHOLD))) {
+		/* Make sure that anybody stopping the queue after this
+		 * sees the new next_to_clean.
+		 */
+		smp_mb();
+
+		if (__netif_subqueue_stopped(tx_ring->netdev,
+					     tx_ring->queue_index) &&
+		    !test_bit(__TXGBE_DOWN, &adapter->state)) {
+			netif_wake_subqueue(tx_ring->netdev,
+					    tx_ring->queue_index);
+			++tx_ring->tx_stats.restart_queue;
+		}
+	}
+
+	return !!budget;
+}
+
+static bool txgbe_alloc_mapped_page(struct txgbe_ring *rx_ring,
+				    struct txgbe_rx_buffer *bi)
+{
+	struct page *page = bi->page;
+	dma_addr_t dma;
+
+	/* since we are recycling buffers we should seldom need to alloc */
+	if (likely(page))
+		return true;
+
+	/* alloc new page for storage */
+	page = dev_alloc_pages(txgbe_rx_pg_order(rx_ring));
+	if (unlikely(!page)) {
+		rx_ring->rx_stats.alloc_rx_page_failed++;
+		return false;
+	}
+
+	/* map page for use */
+	dma = dma_map_page(rx_ring->dev, page, 0,
+			   txgbe_rx_pg_size(rx_ring), DMA_FROM_DEVICE);
+
+	/* if mapping failed free memory back to system since
+	 * there isn't much point in holding memory we can't use
+	 */
+	if (dma_mapping_error(rx_ring->dev, dma)) {
+		__free_pages(page, txgbe_rx_pg_order(rx_ring));
+
+		rx_ring->rx_stats.alloc_rx_page_failed++;
+		return false;
+	}
+
+	bi->page_dma = dma;
+	bi->page = page;
+	bi->page_offset = 0;
+
+	return true;
+}
+
+/**
+ * txgbe_alloc_rx_buffers - Replace used receive buffers
+ * @rx_ring: ring to place buffers on
+ * @cleaned_count: number of buffers to replace
+ **/
+void txgbe_alloc_rx_buffers(struct txgbe_ring *rx_ring, u16 cleaned_count)
+{
+	union txgbe_rx_desc *rx_desc;
+	u16 i = rx_ring->next_to_use;
+	struct txgbe_rx_buffer *bi;
+
+	/* nothing to do */
+	if (!cleaned_count)
+		return;
+
+	rx_desc = TXGBE_RX_DESC(rx_ring, i);
+	bi = &rx_ring->rx_buffer_info[i];
+	i -= rx_ring->count;
+
+	do {
+		if (!txgbe_alloc_mapped_page(rx_ring, bi))
+			break;
+		rx_desc->read.pkt_addr =
+			cpu_to_le64(bi->page_dma + bi->page_offset);
+
+		rx_desc++;
+		bi++;
+		i++;
+		if (unlikely(!i)) {
+			rx_desc = TXGBE_RX_DESC(rx_ring, 0);
+			bi = rx_ring->rx_buffer_info;
+			i -= rx_ring->count;
+		}
+
+		/* clear the status bits for the next_to_use descriptor */
+		rx_desc->wb.upper.status_error = 0;
+
+		cleaned_count--;
+	} while (cleaned_count);
+
+	i += rx_ring->count;
+
+	if (rx_ring->next_to_use != i) {
+		rx_ring->next_to_use = i;
+		/* update next to alloc since we have filled the ring */
+		rx_ring->next_to_alloc = i;
+
+		/* Force memory writes to complete before letting h/w
+		 * know there are new descriptors to fetch.  (Only
+		 * applicable for weak-ordered memory model archs,
+		 * such as IA-64).
+		 */
+		wmb();
+		writel(i, rx_ring->tail);
+	}
+}
+
+/**
+ * txgbe_process_skb_fields - Populate skb header fields from Rx descriptor
+ * @rx_ring: rx descriptor ring packet is being transacted on
+ * @rx_desc: pointer to the EOP Rx descriptor
+ * @skb: pointer to current skb being populated
+ *
+ * This function checks the ring, descriptor, and packet information in
+ * order to populate the hash, checksum, VLAN, timestamp, protocol, and
+ * other fields within the skb.
+ **/
+static void txgbe_process_skb_fields(struct txgbe_ring *rx_ring,
+				     union txgbe_rx_desc *rx_desc,
+				     struct sk_buff *skb)
+{
+	skb_record_rx_queue(skb, rx_ring->queue_index);
+
+	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
+}
+
+static void txgbe_rx_skb(struct txgbe_q_vector *q_vector,
+			 struct sk_buff *skb)
+{
+	napi_gro_receive(&q_vector->napi, skb);
+}
+
+/**
+ * txgbe_is_non_eop - process handling of non-EOP buffers
+ * @rx_ring: Rx ring being processed
+ * @rx_desc: Rx descriptor for current buffer
+ * @skb: Current socket buffer containing buffer in progress
+ *
+ * This function updates next to clean. If the buffer is an EOP buffer
+ * this function exits returning false, otherwise it will place the
+ * sk_buff in the next buffer to be chained and return true indicating
+ * that this is in fact a non-EOP buffer.
+ **/
+static bool txgbe_is_non_eop(struct txgbe_ring *rx_ring,
+			     union txgbe_rx_desc *rx_desc,
+			     struct sk_buff *skb)
+{
+	u32 ntc = rx_ring->next_to_clean + 1;
+
+	/* fetch, update, and store next to clean */
+	ntc = (ntc < rx_ring->count) ? ntc : 0;
+	rx_ring->next_to_clean = ntc;
+
+	prefetch(TXGBE_RX_DESC(rx_ring, ntc));
+
+	/* if we are the last buffer then there is nothing else to do */
+	if (likely(txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_EOP)))
+		return false;
+
+	rx_ring->rx_buffer_info[ntc].skb = skb;
+	rx_ring->rx_stats.non_eop_descs++;
+
+	return true;
+}
+
+static void txgbe_pull_tail(struct sk_buff *skb)
+{
+	skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
+	unsigned int pull_len;
+	unsigned char *va;
+
+	/* it is valid to use page_address instead of kmap since we are
+	 * working with pages allocated out of the lomem pool per
+	 * alloc_page(GFP_ATOMIC)
+	 */
+	va = skb_frag_address(frag);
+
+	/* we need the header to contain the greater of either ETH_HLEN or
+	 * 60 bytes if the skb->len is less than 60 for skb_pad.
+	 */
+	pull_len = eth_get_headlen(skb->dev, va, TXGBE_RX_HDR_SIZE);
+
+	/* align pull length to size of long to optimize memcpy performance */
+	skb_copy_to_linear_data(skb, va, ALIGN(pull_len, sizeof(long)));
+
+	/* update all of the pointers */
+	skb_frag_size_sub(frag, pull_len);
+	skb_frag_off_add(frag, pull_len);
+	skb->data_len -= pull_len;
+	skb->tail += pull_len;
+}
+
+/**
+ * txgbe_dma_sync_frag - perform DMA sync for first frag of SKB
+ * @rx_ring: rx descriptor ring packet is being transacted on
+ * @skb: pointer to current skb being updated
+ *
+ * This function provides a basic DMA sync up for the first fragment of an
+ * skb.  The reason for doing this is that the first fragment cannot be
+ * unmapped until we have reached the end of packet descriptor for a buffer
+ * chain.
+ */
+static void txgbe_dma_sync_frag(struct txgbe_ring *rx_ring,
+				struct sk_buff *skb)
+{
+	skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
+
+	dma_sync_single_range_for_cpu(rx_ring->dev,
+				      TXGBE_CB(skb)->dma,
+				      skb_frag_off(frag),
+				      skb_frag_size(frag),
+				      DMA_FROM_DEVICE);
+
+	/* If the page was released, just unmap it. */
+	if (unlikely(TXGBE_CB(skb)->page_released)) {
+		dma_unmap_page_attrs(rx_ring->dev, TXGBE_CB(skb)->dma,
+				     txgbe_rx_pg_size(rx_ring),
+				     DMA_FROM_DEVICE,
+				     TXGBE_RX_DMA_ATTR);
+	}
+}
+
+/**
+ * txgbe_cleanup_headers - Correct corrupted or empty headers
+ * @rx_ring: rx descriptor ring packet is being transacted on
+ * @rx_desc: pointer to the EOP Rx descriptor
+ * @skb: pointer to current skb being fixed
+ *
+ * Check for corrupted packet headers caused by senders on the local L2
+ * embedded NIC switch not setting up their Tx Descriptors right.  These
+ * should be very rare.
+ *
+ * Also address the case where we are pulling data in on pages only
+ * and as such no data is present in the skb header.
+ *
+ * In addition if skb is not at least 60 bytes we need to pad it so that
+ * it is large enough to qualify as a valid Ethernet frame.
+ *
+ * Returns true if an error was encountered and skb was freed.
+ **/
+static bool txgbe_cleanup_headers(struct txgbe_ring *rx_ring,
+				  union txgbe_rx_desc *rx_desc,
+				  struct sk_buff *skb)
+{
+	struct net_device *netdev = rx_ring->netdev;
+
+	/* verify that the packet does not have any known errors */
+	if (unlikely(txgbe_test_staterr(rx_desc,
+					TXGBE_RXD_ERR_FRAME_ERR_MASK) &&
+		     !(netdev->features & NETIF_F_RXALL))) {
+		dev_kfree_skb_any(skb);
+		return true;
+	}
+
+	/* place header in linear portion of buffer */
+	if (skb_is_nonlinear(skb)  && !skb_headlen(skb))
+		txgbe_pull_tail(skb);
+
+	/* if eth_skb_pad returns an error the skb was freed */
+	if (eth_skb_pad(skb))
+		return true;
+
+	return false;
+}
+
+/**
+ * txgbe_reuse_rx_page - page flip buffer and store it back on the ring
+ * @rx_ring: rx descriptor ring to store buffers on
+ * @old_buff: donor buffer to have page reused
+ *
+ * Synchronizes page for reuse by the adapter
+ **/
+static void txgbe_reuse_rx_page(struct txgbe_ring *rx_ring,
+				struct txgbe_rx_buffer *old_buff)
+{
+	struct txgbe_rx_buffer *new_buff;
+	u16 nta = rx_ring->next_to_alloc;
+
+	new_buff = &rx_ring->rx_buffer_info[nta];
+
+	/* update, and store next to alloc */
+	nta++;
+	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
+
+	/* transfer page from old buffer to new buffer */
+	new_buff->page_dma = old_buff->page_dma;
+	new_buff->page = old_buff->page;
+	new_buff->page_offset = old_buff->page_offset;
+
+	/* sync the buffer for use by the device */
+	dma_sync_single_range_for_device(rx_ring->dev, new_buff->page_dma,
+					 new_buff->page_offset,
+					 txgbe_rx_bufsz(rx_ring),
+					 DMA_FROM_DEVICE);
+}
+
+static inline bool txgbe_page_is_reserved(struct page *page)
+{
+	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
+}
+
+/**
+ * txgbe_add_rx_frag - Add contents of Rx buffer to sk_buff
+ * @rx_ring: rx descriptor ring to transact packets on
+ * @rx_buffer: buffer containing page to add
+ * @rx_desc: descriptor containing length of buffer written by hardware
+ * @skb: sk_buff to place the data into
+ *
+ * This function will add the data contained in rx_buffer->page to the skb.
+ * This is done either through a direct copy if the data in the buffer is
+ * less than the skb header size, otherwise it will just attach the page as
+ * a frag to the skb.
+ *
+ * The function will then update the page offset if necessary and return
+ * true if the buffer can be reused by the adapter.
+ **/
+static bool txgbe_add_rx_frag(struct txgbe_ring *rx_ring,
+			      struct txgbe_rx_buffer *rx_buffer,
+			      union txgbe_rx_desc *rx_desc,
+			      struct sk_buff *skb)
+{
+	unsigned int size = le16_to_cpu(rx_desc->wb.upper.length);
+#if (PAGE_SIZE < 8192)
+	unsigned int truesize = txgbe_rx_bufsz(rx_ring);
+#else
+	unsigned int truesize = ALIGN(size, L1_CACHE_BYTES);
+	unsigned int last_offset = txgbe_rx_pg_size(rx_ring) -
+				   txgbe_rx_bufsz(rx_ring);
+#endif
+	struct page *page = rx_buffer->page;
+
+	if (size <= TXGBE_RX_HDR_SIZE && !skb_is_nonlinear(skb)) {
+		unsigned char *va = page_address(page) + rx_buffer->page_offset;
+
+		memcpy(__skb_put(skb, size), va, ALIGN(size, sizeof(long)));
+
+		/* page is not reserved, we can reuse buffer as-is */
+		if (likely(!txgbe_page_is_reserved(page)))
+			return true;
+
+		/* this page cannot be reused so discard it */
+		__free_pages(page, txgbe_rx_pg_order(rx_ring));
+		return false;
+	}
+
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
+			rx_buffer->page_offset, size, truesize);
+
+	/* avoid re-using remote pages */
+	if (unlikely(txgbe_page_is_reserved(page)))
+		return false;
+
+#if (PAGE_SIZE < 8192)
+	/* if we are only owner of page we can reuse it */
+	if (unlikely(page_count(page) != 1))
+		return false;
+
+	/* flip page offset to other buffer */
+	rx_buffer->page_offset ^= truesize;
+#else
+	/* move offset up to the next cache line */
+	rx_buffer->page_offset += truesize;
+
+	if (rx_buffer->page_offset > last_offset)
+		return false;
+#endif
+
+	/* Even if we own the page, we are not allowed to use atomic_set()
+	 * This would break get_page_unless_zero() users.
+	 */
+	page_ref_inc(page);
+
+	return true;
+}
+
+static struct sk_buff *txgbe_fetch_rx_buffer(struct txgbe_ring *rx_ring,
+					     union txgbe_rx_desc *rx_desc)
+{
+	struct txgbe_rx_buffer *rx_buffer;
+	struct sk_buff *skb;
+	struct page *page;
+
+	rx_buffer = &rx_ring->rx_buffer_info[rx_ring->next_to_clean];
+	page = rx_buffer->page;
+	prefetchw(page);
+
+	skb = rx_buffer->skb;
+
+	if (likely(!skb)) {
+		void *page_addr = page_address(page) +
+				  rx_buffer->page_offset;
+
+		/* prefetch first cache line of first page */
+		prefetch(page_addr);
+#if L1_CACHE_BYTES < 128
+		prefetch(page_addr + L1_CACHE_BYTES);
+#endif
+
+		/* allocate a skb to store the frags */
+		skb = netdev_alloc_skb_ip_align(rx_ring->netdev,
+						TXGBE_RX_HDR_SIZE);
+		if (unlikely(!skb)) {
+			rx_ring->rx_stats.alloc_rx_buff_failed++;
+			return NULL;
+		}
+
+		/* we will be copying header into skb->data in
+		 * pskb_may_pull so it is in our interest to prefetch
+		 * it now to avoid a possible cache miss
+		 */
+		prefetchw(skb->data);
+
+		/* Delay unmapping of the first packet. It carries the
+		 * header information, HW may still access the header
+		 * after the writeback.  Only unmap it when EOP is
+		 * reached
+		 */
+		if (likely(txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_EOP)))
+			goto dma_sync;
+
+		TXGBE_CB(skb)->dma = rx_buffer->page_dma;
+	} else {
+		if (txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_EOP))
+			txgbe_dma_sync_frag(rx_ring, skb);
+
+dma_sync:
+		/* we are reusing so sync this buffer for CPU use */
+		dma_sync_single_range_for_cpu(rx_ring->dev,
+					      rx_buffer->page_dma,
+					      rx_buffer->page_offset,
+					      txgbe_rx_bufsz(rx_ring),
+					      DMA_FROM_DEVICE);
+
+		rx_buffer->skb = NULL;
+	}
+
+	/* pull page into skb */
+	if (txgbe_add_rx_frag(rx_ring, rx_buffer, rx_desc, skb)) {
+		/* hand second half of page back to the ring */
+		txgbe_reuse_rx_page(rx_ring, rx_buffer);
+	} else if (TXGBE_CB(skb)->dma == rx_buffer->page_dma) {
+		/* the page has been released from the ring */
+		TXGBE_CB(skb)->page_released = true;
+	} else {
+		/* we are not reusing the buffer so unmap it */
+		dma_unmap_page(rx_ring->dev, rx_buffer->page_dma,
+			       txgbe_rx_pg_size(rx_ring),
+			       DMA_FROM_DEVICE);
+	}
+
+	/* clear contents of buffer_info */
+	rx_buffer->page = NULL;
+
+	return skb;
+}
+
+/**
+ * txgbe_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
+ * @q_vector: structure containing interrupt and ring information
+ * @rx_ring: rx descriptor ring to transact packets on
+ * @budget: Total limit on number of packets to process
+ *
+ * This function provides a "bounce buffer" approach to Rx interrupt
+ * processing.  The advantage to this is that on systems that have
+ * expensive overhead for IOMMU access this provides a means of avoiding
+ * it by maintaining the mapping of the page to the system.
+ *
+ * Returns amount of work completed.
+ **/
+static int txgbe_clean_rx_irq(struct txgbe_q_vector *q_vector,
+			      struct txgbe_ring *rx_ring,
+			      int budget)
+{
+	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
+	u16 cleaned_count = txgbe_desc_unused(rx_ring);
+
+	do {
+		union txgbe_rx_desc *rx_desc;
+		struct sk_buff *skb;
+
+		/* return some buffers to hardware, one at a time is too slow */
+		if (cleaned_count >= TXGBE_RX_BUFFER_WRITE) {
+			txgbe_alloc_rx_buffers(rx_ring, cleaned_count);
+			cleaned_count = 0;
+		}
+
+		rx_desc = TXGBE_RX_DESC(rx_ring, rx_ring->next_to_clean);
+
+		if (!txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_DD))
+			break;
+
+		/* This memory barrier is needed to keep us from reading
+		 * any other fields out of the rx_desc until we know the
+		 * descriptor has been written back
+		 */
+		dma_rmb();
+
+		/* retrieve a buffer from the ring */
+		skb = txgbe_fetch_rx_buffer(rx_ring, rx_desc);
+
+		/* exit if we failed to retrieve a buffer */
+		if (!skb)
+			break;
+
+		cleaned_count++;
+
+		/* place incomplete frames back on ring for completion */
+		if (txgbe_is_non_eop(rx_ring, rx_desc, skb))
+			continue;
+
+		/* verify the packet layout is correct */
+		if (txgbe_cleanup_headers(rx_ring, rx_desc, skb))
+			continue;
+
+		/* probably a little skewed due to removing CRC */
+		total_rx_bytes += skb->len;
+
+		txgbe_process_skb_fields(rx_ring, rx_desc, skb);
+
+		txgbe_rx_skb(q_vector, skb);
+
+		/* update budget accounting */
+		total_rx_packets++;
+	} while (likely(total_rx_packets < budget));
+
+	u64_stats_update_begin(&rx_ring->syncp);
+	rx_ring->stats.packets += total_rx_packets;
+	rx_ring->stats.bytes += total_rx_bytes;
+	u64_stats_update_end(&rx_ring->syncp);
+	q_vector->rx.total_packets += total_rx_packets;
+	q_vector->rx.total_bytes += total_rx_bytes;
+
+	return total_rx_packets;
+}
+
 /**
  * txgbe_configure_msix - Configure MSI-X hardware
  * @adapter: board private structure
@@ -205,6 +853,74 @@ static void txgbe_configure_msix(struct txgbe_adapter *adapter)
 	wr32(&adapter->hw, TXGBE_PX_ITR(v_idx), 1950);
 }
 
+enum latency_range {
+	lowest_latency = 0,
+	low_latency = 1,
+	bulk_latency = 2,
+	latency_invalid = 255
+};
+
+/**
+ * txgbe_update_itr - update the dynamic ITR value based on statistics
+ * @q_vector: structure containing interrupt and ring information
+ * @ring_container: structure containing ring performance data
+ *
+ * Stores a new ITR value based on packets and byte
+ * counts during the last interrupt.  The advantage of per interrupt
+ * computation is faster updates and more accurate ITR for the current
+ * traffic pattern.  Constants in this function were computed
+ * based on theoretical maximum wire speed and thresholds were set based
+ * on testing data as well as attempting to minimize response time
+ * while increasing bulk throughput.
+ **/
+static void txgbe_update_itr(struct txgbe_q_vector *q_vector,
+			     struct txgbe_ring_container *ring_container)
+{
+	int packets = ring_container->total_packets;
+	int bytes = ring_container->total_bytes;
+	u8 itr_setting = ring_container->itr;
+	u32 timepassed_us;
+	u64 bytes_perint;
+
+	if (packets == 0)
+		return;
+
+	/* simple throttlerate management
+	 *   0-10MB/s   lowest (100000 ints/s)
+	 *  10-20MB/s   low    (20000 ints/s)
+	 *  20-1249MB/s bulk   (12000 ints/s)
+	 */
+	/* what was last interrupt timeslice? */
+	timepassed_us = q_vector->itr >> 2;
+	if (timepassed_us == 0)
+		return;
+	bytes_perint = bytes / timepassed_us; /* bytes/usec */
+
+	switch (itr_setting) {
+	case lowest_latency:
+		if (bytes_perint > 10)
+			itr_setting = low_latency;
+		break;
+	case low_latency:
+		if (bytes_perint > 20)
+			itr_setting = bulk_latency;
+		else if (bytes_perint <= 10)
+			itr_setting = lowest_latency;
+		break;
+	case bulk_latency:
+		if (bytes_perint <= 20)
+			itr_setting = low_latency;
+		break;
+	}
+
+	/* clear work counters since we have the values we need */
+	ring_container->total_bytes = 0;
+	ring_container->total_packets = 0;
+
+	/* write updated itr to ring container */
+	ring_container->itr = itr_setting;
+}
+
 /**
  * txgbe_write_eitr - write ITR register in hardware specific way
  * @q_vector: structure containing interrupt and ring information
@@ -225,6 +941,43 @@ void txgbe_write_eitr(struct txgbe_q_vector *q_vector)
 	wr32(hw, TXGBE_PX_ITR(v_idx), itr_reg);
 }
 
+static void txgbe_set_itr(struct txgbe_q_vector *q_vector)
+{
+	u16 new_itr = q_vector->itr;
+	u8 current_itr;
+
+	txgbe_update_itr(q_vector, &q_vector->tx);
+	txgbe_update_itr(q_vector, &q_vector->rx);
+
+	current_itr = max(q_vector->rx.itr, q_vector->tx.itr);
+
+	switch (current_itr) {
+	/* counts and packets in update_itr are dependent on these numbers */
+	case lowest_latency:
+		new_itr = TXGBE_100K_ITR;
+		break;
+	case low_latency:
+		new_itr = TXGBE_20K_ITR;
+		break;
+	case bulk_latency:
+		new_itr = TXGBE_12K_ITR;
+		break;
+	default:
+		break;
+	}
+
+	if (new_itr != q_vector->itr) {
+		/* do an exponential smoothing */
+		new_itr = (10 * new_itr * q_vector->itr) /
+			  ((9 * new_itr) + q_vector->itr);
+
+		/* save the algorithm value here */
+		q_vector->itr = new_itr;
+
+		txgbe_write_eitr(q_vector);
+	}
+}
+
 /**
  * txgbe_check_overtemp_subtask - check for over temperature
  * @adapter: pointer to adapter
@@ -431,6 +1184,50 @@ static irqreturn_t txgbe_msix_clean_rings(int __always_unused irq, void *data)
  **/
 int txgbe_poll(struct napi_struct *napi, int budget)
 {
+	struct txgbe_q_vector *q_vector =
+			       container_of(napi, struct txgbe_q_vector, napi);
+	struct txgbe_adapter *adapter = q_vector->adapter;
+	bool clean_complete = true;
+	struct txgbe_ring *ring;
+	int per_ring_budget;
+
+	txgbe_for_each_ring(ring, q_vector->tx) {
+		if (!txgbe_clean_tx_irq(q_vector, ring))
+			clean_complete = false;
+	}
+
+	/* Exit if we are called by netpoll */
+	if (budget <= 0)
+		return budget;
+
+	/* attempt to distribute budget to each queue fairly, but don't allow
+	 * the budget to go below 1 because we'll exit polling
+	 */
+	if (q_vector->rx.count > 1)
+		per_ring_budget = max(budget / q_vector->rx.count, 1);
+	else
+		per_ring_budget = budget;
+
+	txgbe_for_each_ring(ring, q_vector->rx) {
+		int cleaned = txgbe_clean_rx_irq(q_vector, ring,
+						 per_ring_budget);
+
+		if (cleaned >= per_ring_budget)
+			clean_complete = false;
+	}
+
+	/* If all work not completed, return budget and keep polling */
+	if (!clean_complete)
+		return budget;
+
+	/* all work done, exit the polling mode */
+	napi_complete(napi);
+	if (adapter->rx_itr_setting == 1)
+		txgbe_set_itr(q_vector);
+	if (!test_bit(__TXGBE_DOWN, &adapter->state))
+		txgbe_intr_enable(&adapter->hw,
+				  TXGBE_INTR_Q(q_vector->v_idx));
+
 	return 0;
 }
 
@@ -881,6 +1678,7 @@ void txgbe_configure_rx_ring(struct txgbe_adapter *adapter,
 	      TXGBE_PX_RR_CFG_RR_EN, TXGBE_PX_RR_CFG_RR_EN);
 
 	txgbe_rx_desc_queue_enable(adapter, ring);
+	txgbe_alloc_rx_buffers(ring, txgbe_desc_unused(ring));
 }
 
 static void txgbe_setup_psrtype(struct txgbe_adapter *adapter)
@@ -2686,7 +3484,9 @@ static int txgbe_probe(struct pci_dev *pdev,
 	u16 eeprom_cfg_blkh = 0, eeprom_cfg_blkl = 0;
 	u16 build = 0, major = 0, patch = 0;
 	u8 part_str[TXGBE_PBANUM_LENGTH];
+	char *info_string, *i_s_var;
 	u32 etrack_id = 0;
+	u16 ctl = 0;
 
 	err = pci_enable_device_mem(pdev);
 	if (err)
@@ -2711,6 +3511,13 @@ static int txgbe_probe(struct pci_dev *pdev,
 	pci_enable_pcie_error_reporting(pdev);
 	pci_set_master(pdev);
 
+	pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &ctl);
+	if (((ctl & PCI_EXP_DEVCTL_READRQ) != PCI_EXP_DEVCTL_READRQ_128B) &&
+	    ((ctl & PCI_EXP_DEVCTL_READRQ) != PCI_EXP_DEVCTL_READRQ_256B))
+		pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
+						   PCI_EXP_DEVCTL_READRQ,
+						   PCI_EXP_DEVCTL_READRQ_256B);
+
 	netdev = devm_alloc_etherdev_mqs(&pdev->dev,
 					 sizeof(struct txgbe_adapter),
 					 TXGBE_MAX_TX_QUEUES,
@@ -2908,6 +3715,23 @@ static int txgbe_probe(struct pci_dev *pdev,
 		   netdev->dev_addr[2], netdev->dev_addr[3],
 		   netdev->dev_addr[4], netdev->dev_addr[5]);
 
+#define INFO_STRING_LEN 255
+	info_string = kzalloc(INFO_STRING_LEN, GFP_KERNEL);
+	if (!info_string) {
+		netif_err(adapter, probe, netdev,
+			  "allocation for info string failed\n");
+		goto no_info_string;
+	}
+	i_s_var = info_string;
+	i_s_var += sprintf(info_string, "Enabled Features: ");
+	i_s_var += sprintf(i_s_var, "RxQ: %d TxQ: %d ",
+			   adapter->num_rx_queues, adapter->num_tx_queues);
+
+	WARN_ON(i_s_var > (info_string + INFO_STRING_LEN));
+	/* end features printing */
+	netif_info(adapter, probe, netdev, "%s\n", info_string);
+	kfree(info_string);
+no_info_string:
 	/* firmware requires blank driver version */
 	hw->mac.ops.set_fw_drv_ver(hw, 0xFF, 0xFF, 0xFF, 0xFF);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 03fcb1441394..ead97e228164 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -912,6 +912,19 @@ enum {
 #define TXGBE_ALT_SAN_MAC_ADDR_CAPS_SANMAC      0x0 /* Alt SAN MAC exists */
 #define TXGBE_ALT_SAN_MAC_ADDR_CAPS_ALTWWN      0x1 /* Alt WWN base exists */
 
+/******************* Receive Descriptor bit definitions **********************/
+#define TXGBE_RXD_STAT_DD               0x00000001U /* Done */
+#define TXGBE_RXD_STAT_EOP              0x00000002U /* End of Packet */
+
+#define TXGBE_RXD_ERR_MASK              0xfff00000U /* RDESC.ERRORS mask */
+#define TXGBE_RXD_ERR_RXE               0x20000000U /* Any MAC Error */
+
+/* Masks to determine if packets should be dropped due to frame errors */
+#define TXGBE_RXD_ERR_FRAME_ERR_MASK    TXGBE_RXD_ERR_RXE
+
+/*********************** Transmit Descriptor Config Masks ****************/
+#define TXGBE_TXD_STAT_DD               0x00000001U /* Descriptor Done */
+
 /* Transmit Descriptor */
 union txgbe_tx_desc {
 	struct {
-- 
2.27.0

