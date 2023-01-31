Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0B16829FA
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjAaKKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbjAaKJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:09:53 -0500
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8AD2005F
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:09:41 -0800 (PST)
X-QQ-mid: bizesmtp69t1675159582tcijcchl
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 31 Jan 2023 18:06:21 +0800 (CST)
X-QQ-SSF: 01400000000000M0O000000A0000000
X-QQ-FEAT: JaBgqeDEvbVgNj1FsdzxgEXPlt82cet10+95I0V9bKLCzE163RYbs4lEmkXiw
        /OAZeg3pohtW7eOvIln/VcuCAGohqi6QIqSjxvof4YzKLZYUVeBzZLRPRpDE1A8NVpaQ2nI
        kRJTL6cQzzIJ56iw/ShDz8nNP3Du/XBJJFPzTJbXp7CRERr9elWlBEWJHX5nH4jrLhJCptL
        gQYQu04AB7Wj1lMphcf2AdDsJcNfRSBVHtekoVmnsTjMhVFRlns+11f/ytsbULqkRTYcpdX
        xmatJjQ+2SFZihJc+EhcoX640M2xSKcqtcJAyqd/vIy8xd+ofi2431D2uJa8ikUDQ2CigMe
        zt2/CeRtqb+6ytGxgkuBzgpemXk81R9jHTXfuL057fdmURR/VDl02h/zW4ihqKXqK25pV7U
        5mfnTaW7s2neLvLl529aqQ==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v2 07/10] net: libwx: Support to receive packets in NAPI
Date:   Tue, 31 Jan 2023 18:05:38 +0800
Message-Id: <20230131100541.73757-8-mengyuanlou@net-swift.com>
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

Clean all queues associated with a q_vector, to simple receive packets
without hardware features.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c   |  11 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  | 655 ++++++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_lib.h  |   7 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h |  34 +
 4 files changed, 706 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index a9a6bfff58ef..2d8b5b9323d7 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -8,6 +8,7 @@
 #include <linux/pci.h>
 
 #include "wx_type.h"
+#include "wx_lib.h"
 #include "wx_hw.h"
 
 static void wx_intr_disable(struct wx *wx, u64 qmask)
@@ -1368,6 +1369,7 @@ static void wx_configure_rx_ring(struct wx *wx,
 				 struct wx_ring *ring)
 {
 	u16 reg_idx = ring->reg_idx;
+	union wx_rx_desc *rx_desc;
 	u64 rdba = ring->dma;
 	u32 rxdctl;
 
@@ -1393,11 +1395,20 @@ static void wx_configure_rx_ring(struct wx *wx,
 
 	wx_configure_srrctl(wx, ring);
 
+	/* initialize rx_buffer_info */
+	memset(ring->rx_buffer_info, 0,
+	       sizeof(struct wx_rx_buffer) * ring->count);
+
+	/* initialize Rx descriptor 0 */
+	rx_desc = WX_RX_DESC(ring, 0);
+	rx_desc->wb.upper.length = 0;
+
 	/* enable receive descriptor ring */
 	wr32m(wx, WX_PX_RR_CFG(reg_idx),
 	      WX_PX_RR_CFG_RR_EN, WX_PX_RR_CFG_RR_EN);
 
 	wx_enable_rx_queue(wx, ring);
+	wx_alloc_rx_buffers(ring, wx_desc_unused(ring));
 }
 
 /**
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index e4d1feaa1c95..fc72b0222327 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -8,6 +8,501 @@
 
 #include "wx_type.h"
 #include "wx_lib.h"
+#include "wx_hw.h"
+
+/* wx_test_staterr - tests bits in Rx descriptor status and error fields */
+static __le32 wx_test_staterr(union wx_rx_desc *rx_desc,
+			      const u32 stat_err_bits)
+{
+	return rx_desc->wb.upper.status_error & cpu_to_le32(stat_err_bits);
+}
+
+static bool wx_can_reuse_rx_page(struct wx_rx_buffer *rx_buffer,
+				 int rx_buffer_pgcnt)
+{
+	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
+	struct page *page = rx_buffer->page;
+
+	/* avoid re-using remote and pfmemalloc pages */
+	if (!dev_page_is_reusable(page))
+		return false;
+
+#if (PAGE_SIZE < 8192)
+	/* if we are only owner of page we can reuse it */
+	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1))
+		return false;
+#endif
+
+	/* If we have drained the page fragment pool we need to update
+	 * the pagecnt_bias and page count so that we fully restock the
+	 * number of references the driver holds.
+	 */
+	if (unlikely(pagecnt_bias == 1)) {
+		page_ref_add(page, USHRT_MAX - 1);
+		rx_buffer->pagecnt_bias = USHRT_MAX;
+	}
+
+	return true;
+}
+
+/**
+ * wx_reuse_rx_page - page flip buffer and store it back on the ring
+ * @rx_ring: rx descriptor ring to store buffers on
+ * @old_buff: donor buffer to have page reused
+ *
+ * Synchronizes page for reuse by the adapter
+ **/
+static void wx_reuse_rx_page(struct wx_ring *rx_ring,
+			     struct wx_rx_buffer *old_buff)
+{
+	u16 nta = rx_ring->next_to_alloc;
+	struct wx_rx_buffer *new_buff;
+
+	new_buff = &rx_ring->rx_buffer_info[nta];
+
+	/* update, and store next to alloc */
+	nta++;
+	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
+
+	/* transfer page from old buffer to new buffer */
+	new_buff->page = old_buff->page;
+	new_buff->page_dma = old_buff->page_dma;
+	new_buff->page_offset = old_buff->page_offset;
+	new_buff->pagecnt_bias	= old_buff->pagecnt_bias;
+}
+
+static void wx_dma_sync_frag(struct wx_ring *rx_ring,
+			     struct wx_rx_buffer *rx_buffer)
+{
+	struct sk_buff *skb = rx_buffer->skb;
+	skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
+
+	dma_sync_single_range_for_cpu(rx_ring->dev,
+				      WX_CB(skb)->dma,
+				      skb_frag_off(frag),
+				      skb_frag_size(frag),
+				      DMA_FROM_DEVICE);
+
+	/* If the page was released, just unmap it. */
+	if (unlikely(WX_CB(skb)->page_released))
+		page_pool_put_full_page(rx_ring->page_pool, rx_buffer->page, false);
+}
+
+static struct wx_rx_buffer *wx_get_rx_buffer(struct wx_ring *rx_ring,
+					     union wx_rx_desc *rx_desc,
+					     struct sk_buff **skb,
+					     int *rx_buffer_pgcnt)
+{
+	struct wx_rx_buffer *rx_buffer;
+	unsigned int size;
+
+	rx_buffer = &rx_ring->rx_buffer_info[rx_ring->next_to_clean];
+	size = le16_to_cpu(rx_desc->wb.upper.length);
+
+#if (PAGE_SIZE < 8192)
+	*rx_buffer_pgcnt = page_count(rx_buffer->page);
+#else
+	*rx_buffer_pgcnt = 0;
+#endif
+
+	prefetchw(rx_buffer->page);
+	*skb = rx_buffer->skb;
+
+	/* Delay unmapping of the first packet. It carries the header
+	 * information, HW may still access the header after the writeback.
+	 * Only unmap it when EOP is reached
+	 */
+	if (!wx_test_staterr(rx_desc, WX_RXD_STAT_EOP)) {
+		if (!*skb)
+			goto skip_sync;
+	} else {
+		if (*skb)
+			wx_dma_sync_frag(rx_ring, rx_buffer);
+	}
+
+	/* we are reusing so sync this buffer for CPU use */
+	dma_sync_single_range_for_cpu(rx_ring->dev,
+				      rx_buffer->dma,
+				      rx_buffer->page_offset,
+				      size,
+				      DMA_FROM_DEVICE);
+skip_sync:
+	rx_buffer->pagecnt_bias--;
+
+	return rx_buffer;
+}
+
+static void wx_put_rx_buffer(struct wx_ring *rx_ring,
+			     struct wx_rx_buffer *rx_buffer,
+			     struct sk_buff *skb,
+			     int rx_buffer_pgcnt)
+{
+	if (wx_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
+		/* hand second half of page back to the ring */
+		wx_reuse_rx_page(rx_ring, rx_buffer);
+	} else {
+		if (!IS_ERR(skb) && WX_CB(skb)->dma == rx_buffer->dma)
+			/* the page has been released from the ring */
+			WX_CB(skb)->page_released = true;
+		else
+			page_pool_put_full_page(rx_ring->page_pool, rx_buffer->page, false);
+
+		__page_frag_cache_drain(rx_buffer->page,
+					rx_buffer->pagecnt_bias);
+	}
+
+	/* clear contents of rx_buffer */
+	rx_buffer->page = NULL;
+	rx_buffer->skb = NULL;
+}
+
+static struct sk_buff *wx_build_skb(struct wx_ring *rx_ring,
+				    struct wx_rx_buffer *rx_buffer,
+				    union wx_rx_desc *rx_desc)
+{
+	unsigned int size = le16_to_cpu(rx_desc->wb.upper.length);
+#if (PAGE_SIZE < 8192)
+	unsigned int truesize = WX_RX_BUFSZ;
+#else
+	unsigned int truesize = ALIGN(size, L1_CACHE_BYTES);
+#endif
+	struct sk_buff *skb = rx_buffer->skb;
+
+	if (!skb) {
+		void *page_addr = page_address(rx_buffer->page) +
+				  rx_buffer->page_offset;
+
+		/* prefetch first cache line of first page */
+		prefetch(page_addr);
+#if L1_CACHE_BYTES < 128
+		prefetch(page_addr + L1_CACHE_BYTES);
+#endif
+
+		/* allocate a skb to store the frags */
+		skb = napi_alloc_skb(&rx_ring->q_vector->napi, WX_RXBUFFER_256);
+		if (unlikely(!skb))
+			return NULL;
+
+		/* we will be copying header into skb->data in
+		 * pskb_may_pull so it is in our interest to prefetch
+		 * it now to avoid a possible cache miss
+		 */
+		prefetchw(skb->data);
+
+		if (size <= WX_RXBUFFER_256) {
+			memcpy(__skb_put(skb, size), page_addr,
+			       ALIGN(size, sizeof(long)));
+			rx_buffer->pagecnt_bias++;
+
+			return skb;
+		}
+
+		if (!wx_test_staterr(rx_desc, WX_RXD_STAT_EOP))
+			WX_CB(skb)->dma = rx_buffer->dma;
+
+		skb_add_rx_frag(skb, 0, rx_buffer->page,
+				rx_buffer->page_offset,
+				size, truesize);
+		goto out;
+
+	} else {
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buffer->page,
+				rx_buffer->page_offset, size, truesize);
+	}
+
+out:
+#if (PAGE_SIZE < 8192)
+	/* flip page offset to other buffer */
+	rx_buffer->page_offset ^= truesize;
+#else
+	/* move offset up to the next cache line */
+	rx_buffer->page_offset += truesize;
+#endif
+
+	return skb;
+}
+
+static bool wx_alloc_mapped_page(struct wx_ring *rx_ring,
+				 struct wx_rx_buffer *bi)
+{
+	struct page *page = bi->page;
+	dma_addr_t dma;
+
+	/* since we are recycling buffers we should seldom need to alloc */
+	if (likely(page))
+		return true;
+
+	page = page_pool_dev_alloc_pages(rx_ring->page_pool);
+	WARN_ON(!page);
+	dma = page_pool_get_dma_addr(page);
+
+	bi->page_dma = dma;
+	bi->page = page;
+	bi->page_offset = 0;
+	page_ref_add(page, USHRT_MAX - 1);
+	bi->pagecnt_bias = USHRT_MAX;
+
+	return true;
+}
+
+/**
+ * wx_alloc_rx_buffers - Replace used receive buffers
+ * @rx_ring: ring to place buffers on
+ * @cleaned_count: number of buffers to replace
+ **/
+void wx_alloc_rx_buffers(struct wx_ring *rx_ring, u16 cleaned_count)
+{
+	u16 i = rx_ring->next_to_use;
+	union wx_rx_desc *rx_desc;
+	struct wx_rx_buffer *bi;
+
+	/* nothing to do */
+	if (!cleaned_count)
+		return;
+
+	rx_desc = WX_RX_DESC(rx_ring, i);
+	bi = &rx_ring->rx_buffer_info[i];
+	i -= rx_ring->count;
+
+	do {
+		if (!wx_alloc_mapped_page(rx_ring, bi))
+			break;
+
+		/* sync the buffer for use by the device */
+		dma_sync_single_range_for_device(rx_ring->dev, bi->dma,
+						 bi->page_offset,
+						 WX_RX_BUFSZ,
+						 DMA_FROM_DEVICE);
+
+		rx_desc->read.pkt_addr =
+			cpu_to_le64(bi->page_dma + bi->page_offset);
+
+		rx_desc++;
+		bi++;
+		i++;
+		if (unlikely(!i)) {
+			rx_desc = WX_RX_DESC(rx_ring, 0);
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
+u16 wx_desc_unused(struct wx_ring *ring)
+{
+	u16 ntc = ring->next_to_clean;
+	u16 ntu = ring->next_to_use;
+
+	return ((ntc > ntu) ? 0 : ring->count) + ntc - ntu - 1;
+}
+
+/**
+ * wx_is_non_eop - process handling of non-EOP buffers
+ * @rx_ring: Rx ring being processed
+ * @rx_desc: Rx descriptor for current buffer
+ * @skb: Current socket buffer containing buffer in progress
+ *
+ * This function updates next to clean. If the buffer is an EOP buffer
+ * this function exits returning false, otherwise it will place the
+ * sk_buff in the next buffer to be chained and return true indicating
+ * that this is in fact a non-EOP buffer.
+ **/
+static bool wx_is_non_eop(struct wx_ring *rx_ring,
+			  union wx_rx_desc *rx_desc,
+			  struct sk_buff *skb)
+{
+	u32 ntc = rx_ring->next_to_clean + 1;
+
+	/* fetch, update, and store next to clean */
+	ntc = (ntc < rx_ring->count) ? ntc : 0;
+	rx_ring->next_to_clean = ntc;
+
+	prefetch(WX_RX_DESC(rx_ring, ntc));
+
+	/* if we are the last buffer then there is nothing else to do */
+	if (likely(wx_test_staterr(rx_desc, WX_RXD_STAT_EOP)))
+		return false;
+
+	rx_ring->rx_buffer_info[ntc].skb = skb;
+
+	return true;
+}
+
+static void wx_pull_tail(struct sk_buff *skb)
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
+	pull_len = eth_get_headlen(skb->dev, va, WX_RXBUFFER_256);
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
+ * wx_cleanup_headers - Correct corrupted or empty headers
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
+static bool wx_cleanup_headers(struct wx_ring *rx_ring,
+			       union wx_rx_desc *rx_desc,
+			       struct sk_buff *skb)
+{
+	struct net_device *netdev = rx_ring->netdev;
+
+	/* verify that the packet does not have any known errors */
+	if (!netdev ||
+	    unlikely(wx_test_staterr(rx_desc, WX_RXD_ERR_RXE) &&
+		     !(netdev->features & NETIF_F_RXALL))) {
+		dev_kfree_skb_any(skb);
+		return true;
+	}
+
+	/* place header in linear portion of buffer */
+	if (!skb_headlen(skb))
+		wx_pull_tail(skb);
+
+	/* if eth_skb_pad returns an error the skb was freed */
+	if (eth_skb_pad(skb))
+		return true;
+
+	return false;
+}
+
+/**
+ * wx_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
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
+static int wx_clean_rx_irq(struct wx_q_vector *q_vector,
+			   struct wx_ring *rx_ring,
+			   int budget)
+{
+	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
+	u16 cleaned_count = wx_desc_unused(rx_ring);
+
+	do {
+		struct wx_rx_buffer *rx_buffer;
+		union wx_rx_desc *rx_desc;
+		struct sk_buff *skb;
+		int rx_buffer_pgcnt;
+
+		/* return some buffers to hardware, one at a time is too slow */
+		if (cleaned_count >= WX_RX_BUFFER_WRITE) {
+			wx_alloc_rx_buffers(rx_ring, cleaned_count);
+			cleaned_count = 0;
+		}
+
+		rx_desc = WX_RX_DESC(rx_ring, rx_ring->next_to_clean);
+		if (!wx_test_staterr(rx_desc, WX_RXD_STAT_DD))
+			break;
+
+		/* This memory barrier is needed to keep us from reading
+		 * any other fields out of the rx_desc until we know the
+		 * descriptor has been written back
+		 */
+		dma_rmb();
+
+		rx_buffer = wx_get_rx_buffer(rx_ring, rx_desc, &skb, &rx_buffer_pgcnt);
+
+		/* retrieve a buffer from the ring */
+		skb = wx_build_skb(rx_ring, rx_buffer, rx_desc);
+
+		/* exit if we failed to retrieve a buffer */
+		if (!skb) {
+			rx_buffer->pagecnt_bias++;
+			break;
+		}
+
+		wx_put_rx_buffer(rx_ring, rx_buffer, skb, rx_buffer_pgcnt);
+		cleaned_count++;
+
+		/* place incomplete frames back on ring for completion */
+		if (wx_is_non_eop(rx_ring, rx_desc, skb))
+			continue;
+
+		/* verify the packet layout is correct */
+		if (wx_cleanup_headers(rx_ring, rx_desc, skb))
+			continue;
+
+		/* probably a little skewed due to removing CRC */
+		total_rx_bytes += skb->len;
+
+		skb_record_rx_queue(skb, rx_ring->queue_index);
+		skb->protocol = eth_type_trans(skb, rx_ring->netdev);
+		napi_gro_receive(&q_vector->napi, skb);
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
 
 /**
  * wx_poll - NAPI polling RX/TX cleanup routine
@@ -18,8 +513,68 @@
  **/
 static int wx_poll(struct napi_struct *napi, int budget)
 {
-	return 0;
+	struct wx_q_vector *q_vector = container_of(napi, struct wx_q_vector, napi);
+	int per_ring_budget, work_done = 0;
+	struct wx *wx = q_vector->wx;
+	bool clean_complete = true;
+	struct wx_ring *ring;
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
+	wx_for_each_ring(ring, q_vector->rx) {
+		int cleaned = wx_clean_rx_irq(q_vector, ring, per_ring_budget);
+
+		work_done += cleaned;
+		if (cleaned >= per_ring_budget)
+			clean_complete = false;
+	}
+
+	/* If all work not completed, return budget and keep polling */
+	if (!clean_complete)
+		return budget;
+
+	/* all work done, exit the polling mode */
+	if (likely(napi_complete_done(napi, work_done))) {
+		if (netif_running(wx->netdev))
+			wx_intr_enable(wx, WX_INTR_Q(q_vector->v_idx));
+	};
+
+	return min(work_done, budget - 1);
+}
+
+void wx_napi_enable_all(struct wx *wx)
+{
+	struct wx_q_vector *q_vector;
+	int q_idx;
+
+	for (q_idx = 0; q_idx < wx->num_q_vectors; q_idx++) {
+		q_vector = wx->q_vector[q_idx];
+		napi_enable(&q_vector->napi);
+	}
+}
+EXPORT_SYMBOL(wx_napi_enable_all);
+
+void wx_napi_disable_all(struct wx *wx)
+{
+	struct wx_q_vector *q_vector;
+	int q_idx;
+
+	for (q_idx = 0; q_idx < wx->num_q_vectors; q_idx++) {
+		q_vector = wx->q_vector[q_idx];
+		napi_disable(&q_vector->napi);
+	}
 }
+EXPORT_SYMBOL(wx_napi_disable_all);
 
 /**
  * wx_set_rss_queues: Allocate queues for RSS
@@ -614,6 +1169,68 @@ void wx_configure_vectors(struct wx *wx)
 }
 EXPORT_SYMBOL(wx_configure_vectors);
 
+/**
+ * wx_clean_rx_ring - Free Rx Buffers per Queue
+ * @rx_ring: ring to free buffers from
+ **/
+static void wx_clean_rx_ring(struct wx_ring *rx_ring)
+{
+	struct wx_rx_buffer *rx_buffer;
+	u16 i = rx_ring->next_to_clean;
+
+	rx_buffer = &rx_ring->rx_buffer_info[i];
+
+	/* Free all the Rx ring sk_buffs */
+	while (i != rx_ring->next_to_alloc) {
+		if (rx_buffer->skb) {
+			struct sk_buff *skb = rx_buffer->skb;
+
+			if (WX_CB(skb)->page_released)
+				page_pool_put_full_page(rx_ring->page_pool, rx_buffer->page, false);
+
+			dev_kfree_skb(skb);
+		}
+
+		/* Invalidate cache lines that may have been written to by
+		 * device so that we avoid corrupting memory.
+		 */
+		dma_sync_single_range_for_cpu(rx_ring->dev,
+					      rx_buffer->dma,
+					      rx_buffer->page_offset,
+					      WX_RX_BUFSZ,
+					      DMA_FROM_DEVICE);
+
+		/* free resources associated with mapping */
+		page_pool_put_full_page(rx_ring->page_pool, rx_buffer->page, false);
+		__page_frag_cache_drain(rx_buffer->page,
+					rx_buffer->pagecnt_bias);
+
+		i++;
+		rx_buffer++;
+		if (i == rx_ring->count) {
+			i = 0;
+			rx_buffer = rx_ring->rx_buffer_info;
+		}
+	}
+
+	rx_ring->next_to_alloc = 0;
+	rx_ring->next_to_clean = 0;
+	rx_ring->next_to_use = 0;
+}
+
+/**
+ * wx_clean_all_rx_rings - Free Rx Buffers for all queues
+ * @wx: board private structure
+ **/
+void wx_clean_all_rx_rings(struct wx *wx)
+{
+	int i;
+
+	for (i = 0; i < wx->num_rx_queues; i++)
+		wx_clean_rx_ring(wx->rx_ring[i]);
+}
+EXPORT_SYMBOL(wx_clean_all_rx_rings);
+
 /**
  * wx_free_rx_resources - Free Rx Resources
  * @rx_ring: ring to clean the resources from
@@ -622,6 +1239,7 @@ EXPORT_SYMBOL(wx_configure_vectors);
  **/
 static void wx_free_rx_resources(struct wx_ring *rx_ring)
 {
+	wx_clean_rx_ring(rx_ring);
 	kvfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
 
@@ -760,6 +1378,9 @@ static int wx_setup_rx_resources(struct wx_ring *rx_ring)
 	if (!rx_ring->desc)
 		goto err;
 
+	rx_ring->next_to_clean = 0;
+	rx_ring->next_to_use = 0;
+
 	ret = wx_alloc_page_pool(rx_ring);
 	if (ret < 0) {
 		dev_err(rx_ring->dev, "Page pool creation failed: %d\n", ret);
@@ -914,4 +1535,36 @@ int wx_setup_resources(struct wx *wx)
 }
 EXPORT_SYMBOL(wx_setup_resources);
 
+/**
+ * wx_get_stats64 - Get System Network Statistics
+ * @netdev: network interface device structure
+ * @stats: storage space for 64bit statistics
+ */
+void wx_get_stats64(struct net_device *netdev,
+		    struct rtnl_link_stats64 *stats)
+{
+	struct wx *wx = netdev_priv(netdev);
+	int i;
+
+	rcu_read_lock();
+	for (i = 0; i < wx->num_rx_queues; i++) {
+		struct wx_ring *ring = READ_ONCE(wx->rx_ring[i]);
+		u64 bytes, packets;
+		unsigned int start;
+
+		if (ring) {
+			do {
+				start = u64_stats_fetch_begin(&ring->syncp);
+				packets = ring->stats.packets;
+				bytes   = ring->stats.bytes;
+			} while (u64_stats_fetch_retry(&ring->syncp, start));
+			stats->rx_packets += packets;
+			stats->rx_bytes   += bytes;
+		}
+	}
+
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(wx_get_stats64);
+
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.h b/drivers/net/ethernet/wangxun/libwx/wx_lib.h
index 6fa95752fc42..8fc7f6f3d40e 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.h
@@ -7,6 +7,10 @@
 #ifndef _WX_LIB_H_
 #define _WX_LIB_H_
 
+void wx_alloc_rx_buffers(struct wx_ring *rx_ring, u16 cleaned_count);
+u16 wx_desc_unused(struct wx_ring *ring);
+void wx_napi_enable_all(struct wx *wx);
+void wx_napi_disable_all(struct wx *wx);
 void wx_reset_interrupt_capability(struct wx *wx);
 void wx_clear_interrupt_scheme(struct wx *wx);
 int wx_init_interrupt_scheme(struct wx *wx);
@@ -16,7 +20,10 @@ int wx_setup_isb_resources(struct wx *wx);
 void wx_free_isb_resources(struct wx *wx);
 u32 wx_misc_isb(struct wx *wx, enum wx_isb_idx idx);
 void wx_configure_vectors(struct wx *wx);
+void wx_clean_all_rx_rings(struct wx *wx);
 void wx_free_resources(struct wx *wx);
 int wx_setup_resources(struct wx *wx);
+void wx_get_stats64(struct net_device *netdev,
+		    struct rtnl_link_stats64 *stats);
 
 #endif /* _NGBE_LIB_H_ */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 7b247af0ff17..fd05c0597d94 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -311,8 +311,15 @@
 #define WX_RX_BUFSZ      WX_RXBUFFER_2K
 #endif
 
+#define WX_RX_BUFFER_WRITE   16      /* Must be power of 2 */
 #define WX_CFG_PORT_ST               0x14404
 
+/******************* Receive Descriptor bit definitions **********************/
+#define WX_RXD_STAT_DD               BIT(0) /* Done */
+#define WX_RXD_STAT_EOP              BIT(1) /* End of Packet */
+
+#define WX_RXD_ERR_RXE               BIT(29) /* Any MAC Error */
+
 /* Host Interface Command Structures */
 struct wx_hic_hdr {
 	u8 cmd;
@@ -433,6 +440,15 @@ enum wx_reset_type {
 	WX_GLOBAL_RESET
 };
 
+struct wx_cb {
+	dma_addr_t dma;
+	u16     append_cnt;      /* number of skb's appended */
+	bool    page_released;
+	bool    dma_released;
+};
+
+#define WX_CB(skb) ((struct wx_cb *)(skb)->cb)
+
 /* Transmit Descriptor */
 union wx_tx_desc {
 	struct {
@@ -478,6 +494,9 @@ union wx_rx_desc {
 	} wb;  /* writeback */
 };
 
+#define WX_RX_DESC(R, i)     \
+	(&(((union wx_rx_desc *)((R)->desc))[i]))
+
 /* wrapper around a pointer to a socket buffer,
  * so a DMA handle can be stored along with the buffer
  */
@@ -496,6 +515,12 @@ struct wx_rx_buffer {
 	dma_addr_t page_dma;
 	struct page *page;
 	unsigned int page_offset;
+	u16 pagecnt_bias;
+};
+
+struct wx_queue_stats {
+	u64 packets;
+	u64 bytes;
 };
 
 /* iterator for handling rings in ring container */
@@ -505,6 +530,8 @@ struct wx_rx_buffer {
 struct wx_ring_container {
 	struct wx_ring *ring;           /* pointer to linked list of rings */
 	u16 work_limit;                 /* total work allowed per interrupt */
+	unsigned int total_bytes;       /* total bytes processed this int */
+	unsigned int total_packets;     /* total packets processed this int */
 	u8 count;                       /* total number of rings in vector */
 	u8 itr;                         /* current ITR setting for ring */
 };
@@ -532,6 +559,12 @@ struct wx_ring {
 					 * associated with this ring, which is
 					 * different for DCB and RSS modes
 					 */
+	u16 next_to_use;
+	u16 next_to_clean;
+	u16 next_to_alloc;
+
+	struct wx_queue_stats stats;
+	struct u64_stats_sync syncp;
 } ____cacheline_internodealigned_in_smp;
 
 struct wx_q_vector {
@@ -633,6 +666,7 @@ struct wx {
 };
 
 #define WX_INTR_ALL (~0ULL)
+#define WX_INTR_Q(i) BIT(i)
 
 /* register operations */
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
-- 
2.39.1

