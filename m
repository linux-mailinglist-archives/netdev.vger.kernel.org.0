Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3992A136DFE
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgAJN1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:27:14 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:53424 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727771AbgAJN1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:27:14 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0ADBCA40069;
        Fri, 10 Jan 2020 13:27:12 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 10 Jan 2020 13:27:06 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 3/9] sfc: move more rx code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Message-ID: <dfe9189c-1056-2417-e380-10baa6744887@solarflare.com>
Date:   Fri, 10 Jan 2020 13:27:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25158.003
X-TM-AS-Result: No-3.708500-8.000000-10
X-TMASE-MatchedRID: xWhQHXIsDwRhNdhmbyNY5RxF6n3xHm7hDmTV5r5yWnocI/pZs+xxL3h0
        psEsz2/KSgJB0j15cgZTvVffeIwvQwUcfW/oedmqR/j040fRFpI/pOSL72dTfwdkFovAReUoaUX
        s6FguVy2Wkqk2IvguWjAbdH82TYhSuiOMIvdjBlgyIyttzvQ996Iik2/euMx1R2YNIFh+clFrcD
        qFw27ycMbjakaCx8WcVq0eIZOG7nwwO9k8xu9MPtFzvmKugqoCFIeclKGfcn9U+MFxNUN/rflgF
        +Kg8U8RvnpwiLdJZm4eaRtZT6z4fCz1TSogmVFTfjUCBXbhed8T2Nkj90poANSVUkz9BPXelrzz
        m0tT2GOWvOTQuU/VmdCZWGpnJQr87O9PFKJckb/j8JN4zg062TVfUuzvrtymI0YrtQLsSUzCaBA
        5v6nrh9+IxWILlTFKYDyEeaLy7fT1073qLZMocvSG/+sPtZVkqb3/o5s+OcMNHQYaK/yrk4jTav
        eC8xA/WS9fn8WHyQerN2iu1SqTjn7cyNXthByNcgDoZhYtavZXbGxk5t82J2YC5Atx1DUQ+vo5Q
        3ytDQUYu4GyXk+sYwg+H8Ap/g5lqF4dEohoxMx2hM5Lw8u+sDmKihe1K2IemXw0RNbqkoJWZu+L
        mJooClYS+ib4bps3jJBZomd1S37MPzXfw9h+jrBUinxjyKa1Qt4kQKXEUAr9MbU3VPgLffkLK24
        MBUL1/g6AILyZ/tCRk6XtYogiam+YnOq0coePC24oEZ6SpSkgbhiVsIMQKx7KERNgzExGyXMyuu
        ItqeOcEJEpIFjauE5UlwmIwyw6VcVUxjfvltFNevoL37CJ4fb3xcOVFbyOcIC/yPIDYeIlXsJDr
        XupIl3HE9DRZDhjWswIoFcXV3ojZU2CAxYkI/guCCuaxGC9PA0H4ETs+eV+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.708500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25158.003
X-MDID: 1578662833-t3Uz4VMPy3_g
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Page recycling code and GRO packet receipt code were moved.

One function contains code extracted from another.

Code style fixes included.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.h       |   3 -
 drivers/net/ethernet/sfc/rx.c        | 188 ------------------------
 drivers/net/ethernet/sfc/rx_common.c | 212 ++++++++++++++++++++++++---
 drivers/net/ethernet/sfc/rx_common.h |  29 ++++
 4 files changed, 224 insertions(+), 208 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 3920f29b2fed..2b417e779e82 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -37,9 +37,6 @@ static inline void efx_rx_flush_packet(struct efx_channel *channel)
 		__efx_rx_packet(channel);
 }
 
-void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue);
-struct page *efx_reuse_page(struct efx_rx_queue *rx_queue);
-
 #define EFX_MAX_DMAQ_SIZE 4096UL
 #define EFX_DEFAULT_DMAQ_SIZE 1024UL
 #define EFX_MIN_DMAQ_SIZE 512UL
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 0e04ed7f6382..18001195410f 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -33,13 +33,6 @@
 /* Maximum rx prefix used by any architecture. */
 #define EFX_MAX_RX_PREFIX_SIZE 16
 
-/* Number of RX buffers to recycle pages for.  When creating the RX page recycle
- * ring, this number is divided by the number of buffers per page to calculate
- * the number of pages to store in the RX page recycle ring.
- */
-#define EFX_RECYCLE_RING_SIZE_IOMMU 4096
-#define EFX_RECYCLE_RING_SIZE_NOIOMMU (2 * EFX_RX_PREFERRED_BATCH)
-
 /* Size of buffer allocated for skb header area. */
 #define EFX_SKB_HEADERS  128u
 
@@ -47,24 +40,6 @@
 #define EFX_RX_MAX_FRAGS DIV_ROUND_UP(EFX_MAX_FRAME_LEN(EFX_MAX_MTU), \
 				      EFX_RX_USR_BUF_SIZE)
 
-static inline u8 *efx_rx_buf_va(struct efx_rx_buffer *buf)
-{
-	return page_address(buf->page) + buf->page_offset;
-}
-
-static inline u32 efx_rx_buf_hash(struct efx_nic *efx, const u8 *eh)
-{
-#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-	return __le32_to_cpup((const __le32 *)(eh + efx->rx_packet_hash_offset));
-#else
-	const u8 *data = eh + efx->rx_packet_hash_offset;
-	return (u32)data[0]	  |
-	       (u32)data[1] << 8  |
-	       (u32)data[2] << 16 |
-	       (u32)data[3] << 24;
-#endif
-}
-
 static inline void efx_sync_rx_buffer(struct efx_nic *efx,
 				      struct efx_rx_buffer *rx_buf,
 				      unsigned int len)
@@ -73,100 +48,6 @@ static inline void efx_sync_rx_buffer(struct efx_nic *efx,
 				DMA_FROM_DEVICE);
 }
 
-/* Check the RX page recycle ring for a page that can be reused. */
-struct page *efx_reuse_page(struct efx_rx_queue *rx_queue)
-{
-	struct efx_nic *efx = rx_queue->efx;
-	struct page *page;
-	struct efx_rx_page_state *state;
-	unsigned index;
-
-	index = rx_queue->page_remove & rx_queue->page_ptr_mask;
-	page = rx_queue->page_ring[index];
-	if (page == NULL)
-		return NULL;
-
-	rx_queue->page_ring[index] = NULL;
-	/* page_remove cannot exceed page_add. */
-	if (rx_queue->page_remove != rx_queue->page_add)
-		++rx_queue->page_remove;
-
-	/* If page_count is 1 then we hold the only reference to this page. */
-	if (page_count(page) == 1) {
-		++rx_queue->page_recycle_count;
-		return page;
-	} else {
-		state = page_address(page);
-		dma_unmap_page(&efx->pci_dev->dev, state->dma_addr,
-			       PAGE_SIZE << efx->rx_buffer_order,
-			       DMA_FROM_DEVICE);
-		put_page(page);
-		++rx_queue->page_recycle_failed;
-	}
-
-	return NULL;
-}
-
-/* Attempt to recycle the page if there is an RX recycle ring; the page can
- * only be added if this is the final RX buffer, to prevent pages being used in
- * the descriptor ring and appearing in the recycle ring simultaneously.
- */
-static void efx_recycle_rx_page(struct efx_channel *channel,
-				struct efx_rx_buffer *rx_buf)
-{
-	struct page *page = rx_buf->page;
-	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
-	struct efx_nic *efx = rx_queue->efx;
-	unsigned index;
-
-	/* Only recycle the page after processing the final buffer. */
-	if (!(rx_buf->flags & EFX_RX_BUF_LAST_IN_PAGE))
-		return;
-
-	index = rx_queue->page_add & rx_queue->page_ptr_mask;
-	if (rx_queue->page_ring[index] == NULL) {
-		unsigned read_index = rx_queue->page_remove &
-			rx_queue->page_ptr_mask;
-
-		/* The next slot in the recycle ring is available, but
-		 * increment page_remove if the read pointer currently
-		 * points here.
-		 */
-		if (read_index == index)
-			++rx_queue->page_remove;
-		rx_queue->page_ring[index] = page;
-		++rx_queue->page_add;
-		return;
-	}
-	++rx_queue->page_recycle_full;
-	efx_unmap_rx_buffer(efx, rx_buf);
-	put_page(rx_buf->page);
-}
-
-/* Recycle the pages that are used by buffers that have just been received. */
-static void efx_recycle_rx_pages(struct efx_channel *channel,
-				 struct efx_rx_buffer *rx_buf,
-				 unsigned int n_frags)
-{
-	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
-
-	do {
-		efx_recycle_rx_page(channel, rx_buf);
-		rx_buf = efx_rx_buf_next(rx_queue, rx_buf);
-	} while (--n_frags);
-}
-
-static void efx_discard_rx_packet(struct efx_channel *channel,
-				  struct efx_rx_buffer *rx_buf,
-				  unsigned int n_frags)
-{
-	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
-
-	efx_recycle_rx_pages(channel, rx_buf, n_frags);
-
-	efx_free_rx_buffers(rx_queue, rx_buf, n_frags);
-}
-
 static void efx_rx_packet__check_len(struct efx_rx_queue *rx_queue,
 				     struct efx_rx_buffer *rx_buf,
 				     int len)
@@ -190,53 +71,6 @@ static void efx_rx_packet__check_len(struct efx_rx_queue *rx_queue,
 	efx_rx_queue_channel(rx_queue)->n_rx_overlength++;
 }
 
-/* Pass a received packet up through GRO.  GRO can handle pages
- * regardless of checksum state and skbs with a good checksum.
- */
-static void
-efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
-		  unsigned int n_frags, u8 *eh)
-{
-	struct napi_struct *napi = &channel->napi_str;
-	struct efx_nic *efx = channel->efx;
-	struct sk_buff *skb;
-
-	skb = napi_get_frags(napi);
-	if (unlikely(!skb)) {
-		struct efx_rx_queue *rx_queue;
-
-		rx_queue = efx_channel_get_rx_queue(channel);
-		efx_free_rx_buffers(rx_queue, rx_buf, n_frags);
-		return;
-	}
-
-	if (efx->net_dev->features & NETIF_F_RXHASH)
-		skb_set_hash(skb, efx_rx_buf_hash(efx, eh),
-			     PKT_HASH_TYPE_L3);
-	skb->ip_summed = ((rx_buf->flags & EFX_RX_PKT_CSUMMED) ?
-			  CHECKSUM_UNNECESSARY : CHECKSUM_NONE);
-	skb->csum_level = !!(rx_buf->flags & EFX_RX_PKT_CSUM_LEVEL);
-
-	for (;;) {
-		skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags,
-				   rx_buf->page, rx_buf->page_offset,
-				   rx_buf->len);
-		rx_buf->page = NULL;
-		skb->len += rx_buf->len;
-		if (skb_shinfo(skb)->nr_frags == n_frags)
-			break;
-
-		rx_buf = efx_rx_buf_next(&channel->rx_queue, rx_buf);
-	}
-
-	skb->data_len = skb->len;
-	skb->truesize += n_frags * efx->rx_buffer_truesize;
-
-	skb_record_rx_queue(skb, channel->rx_queue.core_index);
-
-	napi_gro_frags(napi);
-}
-
 /* Allocate and construct an SKB around page fragments */
 static struct sk_buff *efx_rx_mk_skb(struct efx_channel *channel,
 				     struct efx_rx_buffer *rx_buf,
@@ -583,28 +417,6 @@ void __efx_rx_packet(struct efx_channel *channel)
 	channel->rx_pkt_n_frags = 0;
 }
 
-void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
-{
-	unsigned int bufs_in_recycle_ring, page_ring_size;
-	struct efx_nic *efx = rx_queue->efx;
-
-	/* Set the RX recycle ring size */
-#ifdef CONFIG_PPC64
-	bufs_in_recycle_ring = EFX_RECYCLE_RING_SIZE_IOMMU;
-#else
-	if (iommu_present(&pci_bus_type))
-		bufs_in_recycle_ring = EFX_RECYCLE_RING_SIZE_IOMMU;
-	else
-		bufs_in_recycle_ring = EFX_RECYCLE_RING_SIZE_NOIOMMU;
-#endif /* CONFIG_PPC64 */
-
-	page_ring_size = roundup_pow_of_two(bufs_in_recycle_ring /
-					    efx->rx_bufs_per_page);
-	rx_queue->page_ring = kcalloc(page_ring_size,
-				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
-	rx_queue->page_ptr_mask = page_ring_size - 1;
-}
-
 #ifdef CONFIG_RFS_ACCEL
 
 static void efx_filter_rfs_work(struct work_struct *data)
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index f4b5c3d828f6..9c545d873d91 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -10,6 +10,7 @@
 
 #include "net_driver.h"
 #include <linux/module.h>
+#include <linux/iommu.h>
 #include "efx.h"
 #include "nic.h"
 #include "rx_common.h"
@@ -22,6 +23,13 @@ module_param(rx_refill_threshold, uint, 0444);
 MODULE_PARM_DESC(rx_refill_threshold,
 		 "RX descriptor ring refill threshold (%)");
 
+/* Number of RX buffers to recycle pages for.  When creating the RX page recycle
+ * ring, this number is divided by the number of buffers per page to calculate
+ * the number of pages to store in the RX page recycle ring.
+ */
+#define EFX_RECYCLE_RING_SIZE_IOMMU 4096
+#define EFX_RECYCLE_RING_SIZE_NOIOMMU (2 * EFX_RX_PREFERRED_BATCH)
+
 /* RX maximum head room required.
  *
  * This must be at least 1 to prevent overflow, plus one packet-worth
@@ -29,6 +37,145 @@ MODULE_PARM_DESC(rx_refill_threshold,
  */
 #define EFX_RXD_HEAD_ROOM (1 + EFX_RX_MAX_FRAGS)
 
+/* Check the RX page recycle ring for a page that can be reused. */
+static struct page *efx_reuse_page(struct efx_rx_queue *rx_queue)
+{
+	struct efx_nic *efx = rx_queue->efx;
+	struct efx_rx_page_state *state;
+	unsigned int index;
+	struct page *page;
+
+	index = rx_queue->page_remove & rx_queue->page_ptr_mask;
+	page = rx_queue->page_ring[index];
+	if (page == NULL)
+		return NULL;
+
+	rx_queue->page_ring[index] = NULL;
+	/* page_remove cannot exceed page_add. */
+	if (rx_queue->page_remove != rx_queue->page_add)
+		++rx_queue->page_remove;
+
+	/* If page_count is 1 then we hold the only reference to this page. */
+	if (page_count(page) == 1) {
+		++rx_queue->page_recycle_count;
+		return page;
+	} else {
+		state = page_address(page);
+		dma_unmap_page(&efx->pci_dev->dev, state->dma_addr,
+			       PAGE_SIZE << efx->rx_buffer_order,
+			       DMA_FROM_DEVICE);
+		put_page(page);
+		++rx_queue->page_recycle_failed;
+	}
+
+	return NULL;
+}
+
+/* Attempt to recycle the page if there is an RX recycle ring; the page can
+ * only be added if this is the final RX buffer, to prevent pages being used in
+ * the descriptor ring and appearing in the recycle ring simultaneously.
+ */
+static void efx_recycle_rx_page(struct efx_channel *channel,
+				struct efx_rx_buffer *rx_buf)
+{
+	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
+	struct efx_nic *efx = rx_queue->efx;
+	struct page *page = rx_buf->page;
+	unsigned int index;
+
+	/* Only recycle the page after processing the final buffer. */
+	if (!(rx_buf->flags & EFX_RX_BUF_LAST_IN_PAGE))
+		return;
+
+	index = rx_queue->page_add & rx_queue->page_ptr_mask;
+	if (rx_queue->page_ring[index] == NULL) {
+		unsigned int read_index = rx_queue->page_remove &
+			rx_queue->page_ptr_mask;
+
+		/* The next slot in the recycle ring is available, but
+		 * increment page_remove if the read pointer currently
+		 * points here.
+		 */
+		if (read_index == index)
+			++rx_queue->page_remove;
+		rx_queue->page_ring[index] = page;
+		++rx_queue->page_add;
+		return;
+	}
+	++rx_queue->page_recycle_full;
+	efx_unmap_rx_buffer(efx, rx_buf);
+	put_page(rx_buf->page);
+}
+
+/* Recycle the pages that are used by buffers that have just been received. */
+void efx_recycle_rx_pages(struct efx_channel *channel,
+			  struct efx_rx_buffer *rx_buf,
+			  unsigned int n_frags)
+{
+	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
+
+	do {
+		efx_recycle_rx_page(channel, rx_buf);
+		rx_buf = efx_rx_buf_next(rx_queue, rx_buf);
+	} while (--n_frags);
+}
+
+void efx_discard_rx_packet(struct efx_channel *channel,
+			   struct efx_rx_buffer *rx_buf,
+			   unsigned int n_frags)
+{
+	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
+
+	efx_recycle_rx_pages(channel, rx_buf, n_frags);
+
+	efx_free_rx_buffers(rx_queue, rx_buf, n_frags);
+}
+
+static void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
+{
+	unsigned int bufs_in_recycle_ring, page_ring_size;
+	struct efx_nic *efx = rx_queue->efx;
+
+	/* Set the RX recycle ring size */
+#ifdef CONFIG_PPC64
+	bufs_in_recycle_ring = EFX_RECYCLE_RING_SIZE_IOMMU;
+#else
+	if (iommu_present(&pci_bus_type))
+		bufs_in_recycle_ring = EFX_RECYCLE_RING_SIZE_IOMMU;
+	else
+		bufs_in_recycle_ring = EFX_RECYCLE_RING_SIZE_NOIOMMU;
+#endif /* CONFIG_PPC64 */
+
+	page_ring_size = roundup_pow_of_two(bufs_in_recycle_ring /
+					    efx->rx_bufs_per_page);
+	rx_queue->page_ring = kcalloc(page_ring_size,
+				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
+	rx_queue->page_ptr_mask = page_ring_size - 1;
+}
+
+static void efx_fini_rx_recycle_ring(struct efx_rx_queue *rx_queue)
+{
+	struct efx_nic *efx = rx_queue->efx;
+	int i;
+
+	/* Unmap and release the pages in the recycle ring. Remove the ring. */
+	for (i = 0; i <= rx_queue->page_ptr_mask; i++) {
+		struct page *page = rx_queue->page_ring[i];
+		struct efx_rx_page_state *state;
+
+		if (page == NULL)
+			continue;
+
+		state = page_address(page);
+		dma_unmap_page(&efx->pci_dev->dev, state->dma_addr,
+			       PAGE_SIZE << efx->rx_buffer_order,
+			       DMA_FROM_DEVICE);
+		put_page(page);
+	}
+	kfree(rx_queue->page_ring);
+	rx_queue->page_ring = NULL;
+}
+
 static void efx_fini_rx_buffer(struct efx_rx_queue *rx_queue,
 			       struct efx_rx_buffer *rx_buf)
 {
@@ -132,7 +279,6 @@ void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
 
 void efx_fini_rx_queue(struct efx_rx_queue *rx_queue)
 {
-	struct efx_nic *efx = rx_queue->efx;
 	struct efx_rx_buffer *rx_buf;
 	int i;
 
@@ -152,22 +298,7 @@ void efx_fini_rx_queue(struct efx_rx_queue *rx_queue)
 		}
 	}
 
-	/* Unmap and release the pages in the recycle ring. Remove the ring. */
-	for (i = 0; i <= rx_queue->page_ptr_mask; i++) {
-		struct page *page = rx_queue->page_ring[i];
-		struct efx_rx_page_state *state;
-
-		if (page == NULL)
-			continue;
-
-		state = page_address(page);
-		dma_unmap_page(&efx->pci_dev->dev, state->dma_addr,
-			       PAGE_SIZE << efx->rx_buffer_order,
-			       DMA_FROM_DEVICE);
-		put_page(page);
-	}
-	kfree(rx_queue->page_ring);
-	rx_queue->page_ring = NULL;
+	efx_fini_rx_recycle_ring(rx_queue);
 
 	if (rx_queue->xdp_rxq_info_valid)
 		xdp_rxq_info_unreg(&rx_queue->xdp_rxq_info);
@@ -373,3 +504,50 @@ void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic)
 	if (rx_queue->notified_count != rx_queue->added_count)
 		efx_nic_notify_rx_desc(rx_queue);
 }
+
+/* Pass a received packet up through GRO.  GRO can handle pages
+ * regardless of checksum state and skbs with a good checksum.
+ */
+void
+efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
+		  unsigned int n_frags, u8 *eh)
+{
+	struct napi_struct *napi = &channel->napi_str;
+	struct efx_nic *efx = channel->efx;
+	struct sk_buff *skb;
+
+	skb = napi_get_frags(napi);
+	if (unlikely(!skb)) {
+		struct efx_rx_queue *rx_queue;
+
+		rx_queue = efx_channel_get_rx_queue(channel);
+		efx_free_rx_buffers(rx_queue, rx_buf, n_frags);
+		return;
+	}
+
+	if (efx->net_dev->features & NETIF_F_RXHASH)
+		skb_set_hash(skb, efx_rx_buf_hash(efx, eh),
+			     PKT_HASH_TYPE_L3);
+	skb->ip_summed = ((rx_buf->flags & EFX_RX_PKT_CSUMMED) ?
+			  CHECKSUM_UNNECESSARY : CHECKSUM_NONE);
+	skb->csum_level = !!(rx_buf->flags & EFX_RX_PKT_CSUM_LEVEL);
+
+	for (;;) {
+		skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags,
+				   rx_buf->page, rx_buf->page_offset,
+				   rx_buf->len);
+		rx_buf->page = NULL;
+		skb->len += rx_buf->len;
+		if (skb_shinfo(skb)->nr_frags == n_frags)
+			break;
+
+		rx_buf = efx_rx_buf_next(&channel->rx_queue, rx_buf);
+	}
+
+	skb->data_len = skb->len;
+	skb->truesize += n_frags * efx->rx_buffer_truesize;
+
+	skb_record_rx_queue(skb, channel->rx_queue.core_index);
+
+	napi_gro_frags(napi);
+}
diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/rx_common.h
index 8b23a7accea1..aa6aeafbc439 100644
--- a/drivers/net/ethernet/sfc/rx_common.h
+++ b/drivers/net/ethernet/sfc/rx_common.h
@@ -18,8 +18,34 @@
 #define EFX_RX_MAX_FRAGS DIV_ROUND_UP(EFX_MAX_FRAME_LEN(EFX_MAX_MTU), \
 				      EFX_RX_USR_BUF_SIZE)
 
+static inline u8 *efx_rx_buf_va(struct efx_rx_buffer *buf)
+{
+	return page_address(buf->page) + buf->page_offset;
+}
+
+static inline u32 efx_rx_buf_hash(struct efx_nic *efx, const u8 *eh)
+{
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+	return __le32_to_cpup((const __le32 *)(eh + efx->rx_packet_hash_offset));
+#else
+	const u8 *data = eh + efx->rx_packet_hash_offset;
+
+	return (u32)data[0]	  |
+	       (u32)data[1] << 8  |
+	       (u32)data[2] << 16 |
+	       (u32)data[3] << 24;
+#endif
+}
+
 void efx_rx_slow_fill(struct timer_list *t);
 
+void efx_recycle_rx_pages(struct efx_channel *channel,
+			  struct efx_rx_buffer *rx_buf,
+			  unsigned int n_frags);
+void efx_discard_rx_packet(struct efx_channel *channel,
+			   struct efx_rx_buffer *rx_buf,
+			   unsigned int n_frags);
+
 int efx_probe_rx_queue(struct efx_rx_queue *rx_queue);
 void efx_init_rx_queue(struct efx_rx_queue *rx_queue);
 void efx_fini_rx_queue(struct efx_rx_queue *rx_queue);
@@ -39,4 +65,7 @@ void efx_schedule_slow_fill(struct efx_rx_queue *rx_queue);
 void efx_rx_config_page_split(struct efx_nic *efx);
 void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic);
 
+void
+efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
+		  unsigned int n_frags, u8 *eh);
 #endif
-- 
2.20.1


