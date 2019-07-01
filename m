Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A766347B9F
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 09:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfFQHuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 03:50:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:40156 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbfFQHuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 03:50:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2DF49AFE9;
        Mon, 17 Jun 2019 07:50:04 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next 07/16] qlge: Deduplicate rx buffer queue management
Date:   Mon, 17 Jun 2019 16:48:49 +0900
Message-Id: <20190617074858.32467-7-bpoirier@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617074858.32467-1-bpoirier@suse.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qlge driver (and device) uses two kinds of buffers for reception,
so-called "small buffers" and "large buffers". The two are arranged in
rings, the sbq and lbq. These two share similar data structures and code.

Factor out data structures into a common struct qlge_bq, make required
adjustments to code and dedup the most obvious cases of copy/paste.

This patch should not introduce any functional change other than to some of
the printk format strings.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge.h      |  96 ++--
 drivers/net/ethernet/qlogic/qlge/qlge_dbg.c  |  60 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c | 570 ++++++++-----------
 3 files changed, 333 insertions(+), 393 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h b/drivers/net/ethernet/qlogic/qlge/qlge.h
index a3a52bbc2821..a84aa264dfa8 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge.h
+++ b/drivers/net/ethernet/qlogic/qlge/qlge.h
@@ -1358,23 +1358,6 @@ struct tx_ring_desc {
 	struct tx_ring_desc *next;
 };
 
-struct page_chunk {
-	struct page *page;	/* master page */
-	char *va;		/* virt addr for this chunk */
-	u64 map;		/* mapping for master */
-	unsigned int offset;	/* offset for this chunk */
-};
-
-struct bq_desc {
-	union {
-		struct page_chunk pg_chunk;
-		struct sk_buff *skb;
-	} p;
-	__le64 *addr;
-	u32 index;
-	DEFINE_DMA_UNMAP_ADDR(mapaddr);
-};
-
 #define QL_TXQ_IDX(qdev, skb) (smp_processor_id()%(qdev->tx_ring_count))
 
 struct tx_ring {
@@ -1413,6 +1396,56 @@ enum {
 	RX_Q = 4,		/* Handles inbound completions. */
 };
 
+struct qlge_page_chunk {
+	struct page *page;
+	void *va; /* virt addr including offset */
+	unsigned int offset;
+};
+
+struct qlge_bq_desc {
+	union {
+		/* for large buffers */
+		struct qlge_page_chunk pg_chunk;
+		/* for small buffers */
+		struct sk_buff *skb;
+	} p;
+	dma_addr_t dma_addr;
+	/* address in ring where the buffer address (dma_addr) is written for
+	 * the device
+	 */
+	__le64 *buf_ptr;
+	u32 index;
+	DEFINE_DMA_UNMAP_ADDR(mapaddr);
+};
+
+/* buffer queue */
+struct qlge_bq {
+	__le64 *base;
+	dma_addr_t base_dma;
+	__le64 *base_indirect;
+	dma_addr_t base_indirect_dma;
+	struct qlge_bq_desc *queue;
+	void __iomem *prod_idx_db_reg;
+	u32 len;			/* entry count */
+	u32 size;			/* size in bytes of hw ring */
+	u32 prod_idx;			/* current sw prod idx */
+	u32 curr_idx;			/* next entry we expect */
+	u32 clean_idx;			/* beginning of new descs */
+	u32 free_cnt;			/* free buffer desc cnt */
+	enum {
+		QLGE_SB,		/* small buffer */
+		QLGE_LB,		/* large buffer */
+	} type;
+};
+
+#define QLGE_BQ_CONTAINER(bq) \
+({ \
+	typeof(bq) _bq = bq; \
+	(struct rx_ring *)((char *)_bq - (_bq->type == QLGE_SB ? \
+					  offsetof(struct rx_ring, sbq) : \
+					  offsetof(struct rx_ring, lbq))); \
+})
+
 struct rx_ring {
 	struct cqicb cqicb;	/* The chip's completion queue init control block. */
 
@@ -1430,33 +1463,12 @@ struct rx_ring {
 	void __iomem *valid_db_reg;	/* PCI doorbell mem area + 0x04 */
 
 	/* Large buffer queue elements. */
-	u32 lbq_len;		/* entry count */
-	u32 lbq_size;		/* size in bytes of queue */
-	void *lbq_base;
-	dma_addr_t lbq_base_dma;
-	void *lbq_base_indirect;
-	dma_addr_t lbq_base_indirect_dma;
-	struct page_chunk pg_chunk; /* current page for chunks */
-	struct bq_desc *lbq;	/* array of control blocks */
-	void __iomem *lbq_prod_idx_db_reg;	/* PCI doorbell mem area + 0x18 */
-	u32 lbq_prod_idx;	/* current sw prod idx */
-	u32 lbq_curr_idx;	/* next entry we expect */
-	u32 lbq_clean_idx;	/* beginning of new descs */
-	u32 lbq_free_cnt;	/* free buffer desc cnt */
+	struct qlge_bq lbq;
+	struct qlge_page_chunk master_chunk;
+	dma_addr_t chunk_dma_addr;
 
 	/* Small buffer queue elements. */
-	u32 sbq_len;		/* entry count */
-	u32 sbq_size;		/* size in bytes of queue */
-	void *sbq_base;
-	dma_addr_t sbq_base_dma;
-	void *sbq_base_indirect;
-	dma_addr_t sbq_base_indirect_dma;
-	struct bq_desc *sbq;	/* array of control blocks */
-	void __iomem *sbq_prod_idx_db_reg; /* PCI doorbell mem area + 0x1c */
-	u32 sbq_prod_idx;	/* current sw prod idx */
-	u32 sbq_curr_idx;	/* next entry we expect */
-	u32 sbq_clean_idx;	/* beginning of new descs */
-	u32 sbq_free_cnt;	/* free buffer desc cnt */
+	struct qlge_bq sbq;
 
 	/* Misc. handler elements. */
 	u32 type;		/* Type of queue, tx, rx. */
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c b/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
index cff1603d121c..35af06dd21dd 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
@@ -1759,39 +1759,39 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	pr_err("rx_ring->curr_entry = %p\n", rx_ring->curr_entry);
 	pr_err("rx_ring->valid_db_reg = %p\n", rx_ring->valid_db_reg);
 
-	pr_err("rx_ring->lbq_base = %p\n", rx_ring->lbq_base);
-	pr_err("rx_ring->lbq_base_dma = %llx\n",
-	       (unsigned long long) rx_ring->lbq_base_dma);
-	pr_err("rx_ring->lbq_base_indirect = %p\n",
-	       rx_ring->lbq_base_indirect);
-	pr_err("rx_ring->lbq_base_indirect_dma = %llx\n",
-	       (unsigned long long) rx_ring->lbq_base_indirect_dma);
-	pr_err("rx_ring->lbq = %p\n", rx_ring->lbq);
-	pr_err("rx_ring->lbq_len = %d\n", rx_ring->lbq_len);
-	pr_err("rx_ring->lbq_size = %d\n", rx_ring->lbq_size);
-	pr_err("rx_ring->lbq_prod_idx_db_reg = %p\n",
-	       rx_ring->lbq_prod_idx_db_reg);
-	pr_err("rx_ring->lbq_prod_idx = %d\n", rx_ring->lbq_prod_idx);
-	pr_err("rx_ring->lbq_curr_idx = %d\n", rx_ring->lbq_curr_idx);
+	pr_err("rx_ring->lbq.base = %p\n", rx_ring->lbq.base);
+	pr_err("rx_ring->lbq.base_dma = %llx\n",
+	       (unsigned long long)rx_ring->lbq.base_dma);
+	pr_err("rx_ring->lbq.base_indirect = %p\n",
+	       rx_ring->lbq.base_indirect);
+	pr_err("rx_ring->lbq.base_indirect_dma = %llx\n",
+	       (unsigned long long)rx_ring->lbq.base_indirect_dma);
+	pr_err("rx_ring->lbq = %p\n", rx_ring->lbq.queue);
+	pr_err("rx_ring->lbq.len = %d\n", rx_ring->lbq.len);
+	pr_err("rx_ring->lbq.size = %d\n", rx_ring->lbq.size);
+	pr_err("rx_ring->lbq.prod_idx_db_reg = %p\n",
+	       rx_ring->lbq.prod_idx_db_reg);
+	pr_err("rx_ring->lbq.prod_idx = %d\n", rx_ring->lbq.prod_idx);
+	pr_err("rx_ring->lbq.curr_idx = %d\n", rx_ring->lbq.curr_idx);
 	pr_err("rx_ring->lbq_clean_idx = %d\n", rx_ring->lbq_clean_idx);
 	pr_err("rx_ring->lbq_free_cnt = %d\n", rx_ring->lbq_free_cnt);
 
-	pr_err("rx_ring->sbq_base = %p\n", rx_ring->sbq_base);
-	pr_err("rx_ring->sbq_base_dma = %llx\n",
-	       (unsigned long long) rx_ring->sbq_base_dma);
-	pr_err("rx_ring->sbq_base_indirect = %p\n",
-	       rx_ring->sbq_base_indirect);
-	pr_err("rx_ring->sbq_base_indirect_dma = %llx\n",
-	       (unsigned long long) rx_ring->sbq_base_indirect_dma);
-	pr_err("rx_ring->sbq = %p\n", rx_ring->sbq);
-	pr_err("rx_ring->sbq_len = %d\n", rx_ring->sbq_len);
-	pr_err("rx_ring->sbq_size = %d\n", rx_ring->sbq_size);
-	pr_err("rx_ring->sbq_prod_idx_db_reg addr = %p\n",
-	       rx_ring->sbq_prod_idx_db_reg);
-	pr_err("rx_ring->sbq_prod_idx = %d\n", rx_ring->sbq_prod_idx);
-	pr_err("rx_ring->sbq_curr_idx = %d\n", rx_ring->sbq_curr_idx);
-	pr_err("rx_ring->sbq_clean_idx = %d\n", rx_ring->sbq_clean_idx);
-	pr_err("rx_ring->sbq_free_cnt = %d\n", rx_ring->sbq_free_cnt);
+	pr_err("rx_ring->sbq.base = %p\n", rx_ring->sbq.base);
+	pr_err("rx_ring->sbq.base_dma = %llx\n",
+	       (unsigned long long)rx_ring->sbq.base_dma);
+	pr_err("rx_ring->sbq.base_indirect = %p\n",
+	       rx_ring->sbq.base_indirect);
+	pr_err("rx_ring->sbq.base_indirect_dma = %llx\n",
+	       (unsigned long long)rx_ring->sbq.base_indirect_dma);
+	pr_err("rx_ring->sbq = %p\n", rx_ring->sbq.queue);
+	pr_err("rx_ring->sbq.len = %d\n", rx_ring->sbq.len);
+	pr_err("rx_ring->sbq.size = %d\n", rx_ring->sbq.size);
+	pr_err("rx_ring->sbq.prod_idx_db_reg addr = %p\n",
+	       rx_ring->sbq.prod_idx_db_reg);
+	pr_err("rx_ring->sbq.prod_idx = %d\n", rx_ring->sbq.prod_idx);
+	pr_err("rx_ring->sbq.curr_idx = %d\n", rx_ring->sbq.curr_idx);
+	pr_err("rx_ring->sbq.clean_idx = %d\n", rx_ring->sbq.clean_idx);
+	pr_err("rx_ring->sbq.free_cnt = %d\n", rx_ring->sbq.free_cnt);
 	pr_err("rx_ring->cq_id = %d\n", rx_ring->cq_id);
 	pr_err("rx_ring->irq = %d\n", rx_ring->irq);
 	pr_err("rx_ring->cpu = %d\n", rx_ring->cpu);
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index 70a284857488..e661ee2730e5 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -978,47 +978,35 @@ static inline unsigned int ql_lbq_block_size(struct ql_adapter *qdev)
 	return PAGE_SIZE << qdev->lbq_buf_order;
 }
 
-/* Get the next large buffer. */
-static struct bq_desc *ql_get_curr_lbuf(struct rx_ring *rx_ring)
-{
-	struct bq_desc *lbq_desc = &rx_ring->lbq[rx_ring->lbq_curr_idx];
-	rx_ring->lbq_curr_idx++;
-	if (rx_ring->lbq_curr_idx == rx_ring->lbq_len)
-		rx_ring->lbq_curr_idx = 0;
-	rx_ring->lbq_free_cnt++;
-	return lbq_desc;
+static struct qlge_bq_desc *qlge_get_curr_buf(struct qlge_bq *bq)
+{
+	struct qlge_bq_desc *bq_desc;
+
+	bq_desc = &bq->queue[bq->curr_idx++];
+	if (bq->curr_idx == bq->len)
+		bq->curr_idx = 0;
+	bq->free_cnt++;
+
+	return bq_desc;
 }
 
-static struct bq_desc *ql_get_curr_lchunk(struct ql_adapter *qdev,
-		struct rx_ring *rx_ring)
+static struct qlge_bq_desc *ql_get_curr_lchunk(struct ql_adapter *qdev,
+					       struct rx_ring *rx_ring)
 {
-	struct bq_desc *lbq_desc = ql_get_curr_lbuf(rx_ring);
+	struct qlge_bq_desc *lbq_desc = qlge_get_curr_buf(&rx_ring->lbq);
 
 	pci_dma_sync_single_for_cpu(qdev->pdev,
 				    dma_unmap_addr(lbq_desc, mapaddr),
 				    qdev->lbq_buf_size, PCI_DMA_FROMDEVICE);
 
-	/* If it's the last chunk of our master page then
-	 * we unmap it.
-	 */
-	if (lbq_desc->p.pg_chunk.offset + qdev->lbq_buf_size ==
-	    ql_lbq_block_size(qdev))
-		pci_unmap_page(qdev->pdev,
-				lbq_desc->p.pg_chunk.map,
-				ql_lbq_block_size(qdev),
-				PCI_DMA_FROMDEVICE);
-	return lbq_desc;
-}
+	if ((lbq_desc->p.pg_chunk.offset + qdev->lbq_buf_size) ==
+	    ql_lbq_block_size(qdev)) {
+		/* last chunk of the master page */
+		pci_unmap_page(qdev->pdev, lbq_desc->dma_addr,
+			       ql_lbq_block_size(qdev), PCI_DMA_FROMDEVICE);
+	}
 
-/* Get the next small buffer. */
-static struct bq_desc *ql_get_curr_sbuf(struct rx_ring *rx_ring)
-{
-	struct bq_desc *sbq_desc = &rx_ring->sbq[rx_ring->sbq_curr_idx];
-	rx_ring->sbq_curr_idx++;
-	if (rx_ring->sbq_curr_idx == rx_ring->sbq_len)
-		rx_ring->sbq_curr_idx = 0;
-	rx_ring->sbq_free_cnt++;
-	return sbq_desc;
+	return lbq_desc;
 }
 
 /* Update an rx ring index. */
@@ -1037,169 +1025,159 @@ static void ql_write_cq_idx(struct rx_ring *rx_ring)
 	ql_write_db_reg(rx_ring->cnsmr_idx, rx_ring->cnsmr_idx_db_reg);
 }
 
-static int ql_get_next_chunk(struct ql_adapter *qdev, struct rx_ring *rx_ring,
-						struct bq_desc *lbq_desc)
+static const char * const bq_type_name[] = {
+	[QLGE_SB] = "sbq",
+	[QLGE_LB] = "lbq",
+};
+
+/* return size of allocated buffer (may be 0) or negative error */
+static int qlge_refill_sb(struct rx_ring *rx_ring,
+			  struct qlge_bq_desc *sbq_desc)
 {
-	if (!rx_ring->pg_chunk.page) {
-		u64 map;
-		rx_ring->pg_chunk.page = alloc_pages(__GFP_COMP | GFP_ATOMIC,
-						qdev->lbq_buf_order);
-		if (unlikely(!rx_ring->pg_chunk.page)) {
-			netif_err(qdev, drv, qdev->ndev,
-				  "page allocation failed.\n");
+	struct ql_adapter *qdev = rx_ring->qdev;
+	struct sk_buff *skb;
+
+	if (sbq_desc->p.skb)
+		return 0;
+
+	netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
+		     "ring %u sbq: getting new skb for index %d.\n",
+		     rx_ring->cq_id, sbq_desc->index);
+
+	skb = netdev_alloc_skb(qdev->ndev, SMALL_BUFFER_SIZE);
+	if (!skb)
+		return -ENOMEM;
+	skb_reserve(skb, QLGE_SB_PAD);
+
+	sbq_desc->dma_addr = pci_map_single(qdev->pdev, skb->data,
+					    SMALL_BUF_MAP_SIZE,
+					    PCI_DMA_FROMDEVICE);
+	if (pci_dma_mapping_error(qdev->pdev, sbq_desc->dma_addr)) {
+		netif_err(qdev, ifup, qdev->ndev, "PCI mapping failed.\n");
+		dev_kfree_skb_any(skb);
+		return -EIO;
+	}
+
+	sbq_desc->p.skb = skb;
+	return SMALL_BUFFER_SIZE;
+}
+
+/* return size of allocated buffer or negative error */
+static int qlge_refill_lb(struct rx_ring *rx_ring,
+			  struct qlge_bq_desc *lbq_desc)
+{
+	struct ql_adapter *qdev = rx_ring->qdev;
+	struct qlge_page_chunk *master_chunk = &rx_ring->master_chunk;
+
+	if (!master_chunk->page) {
+		struct page *page;
+		dma_addr_t dma_addr;
+
+		page = alloc_pages(__GFP_COMP | GFP_ATOMIC,
+				   qdev->lbq_buf_order);
+		if (unlikely(!page))
 			return -ENOMEM;
-		}
-		rx_ring->pg_chunk.offset = 0;
-		map = pci_map_page(qdev->pdev, rx_ring->pg_chunk.page,
-					0, ql_lbq_block_size(qdev),
+		dma_addr = pci_map_page(qdev->pdev, page, 0,
+					ql_lbq_block_size(qdev),
 					PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(qdev->pdev, map)) {
-			__free_pages(rx_ring->pg_chunk.page,
-					qdev->lbq_buf_order);
-			rx_ring->pg_chunk.page = NULL;
+		if (pci_dma_mapping_error(qdev->pdev, dma_addr)) {
+			__free_pages(page, qdev->lbq_buf_order);
 			netif_err(qdev, drv, qdev->ndev,
 				  "PCI mapping failed.\n");
-			return -ENOMEM;
+			return -EIO;
 		}
-		rx_ring->pg_chunk.map = map;
-		rx_ring->pg_chunk.va = page_address(rx_ring->pg_chunk.page);
+		master_chunk->page = page;
+		master_chunk->va = page_address(page);
+		master_chunk->offset = 0;
+		rx_ring->chunk_dma_addr = dma_addr;
 	}
 
-	/* Copy the current master pg_chunk info
-	 * to the current descriptor.
-	 */
-	lbq_desc->p.pg_chunk = rx_ring->pg_chunk;
+	lbq_desc->p.pg_chunk = *master_chunk;
+	lbq_desc->dma_addr = rx_ring->chunk_dma_addr + master_chunk->offset;
 
 	/* Adjust the master page chunk for next
 	 * buffer get.
 	 */
-	rx_ring->pg_chunk.offset += qdev->lbq_buf_size;
-	if (rx_ring->pg_chunk.offset == ql_lbq_block_size(qdev)) {
-		rx_ring->pg_chunk.page = NULL;
+	master_chunk->offset += qdev->lbq_buf_size;
+	if (master_chunk->offset == ql_lbq_block_size(qdev)) {
+		master_chunk->page = NULL;
 	} else {
-		rx_ring->pg_chunk.va += qdev->lbq_buf_size;
-		get_page(rx_ring->pg_chunk.page);
+		master_chunk->va += qdev->lbq_buf_size;
+		get_page(master_chunk->page);
 	}
-	return 0;
+
+	return qdev->lbq_buf_size;
 }
-/* Process (refill) a large buffer queue. */
-static void ql_update_lbq(struct ql_adapter *qdev, struct rx_ring *rx_ring)
+
+static void qlge_refill_bq(struct qlge_bq *bq)
 {
-	u32 clean_idx = rx_ring->lbq_clean_idx;
+	struct rx_ring *rx_ring = QLGE_BQ_CONTAINER(bq);
+	struct ql_adapter *qdev = rx_ring->qdev;
+	u32 clean_idx = bq->clean_idx;
+	unsigned int reserved_count;
 	u32 start_idx = clean_idx;
-	struct bq_desc *lbq_desc;
-	u64 map;
 	int i;
 
-	while (rx_ring->lbq_free_cnt > 32) {
-		for (i = (rx_ring->lbq_clean_idx % 16); i < 16; i++) {
+	if (bq->type == QLGE_SB)
+		reserved_count = 16;
+	else
+		reserved_count = 32;
+
+	while (bq->free_cnt > reserved_count) {
+		for (i = (bq->clean_idx % 16); i < 16; i++) {
+			struct qlge_bq_desc *bq_desc = &bq->queue[clean_idx];
+			int retval;
+
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
-				     "lbq: try cleaning clean_idx = %d.\n",
+				     "ring %u %s: try cleaning clean_idx = %d.\n",
+				     rx_ring->cq_id, bq_type_name[bq->type],
 				     clean_idx);
-			lbq_desc = &rx_ring->lbq[clean_idx];
-			if (ql_get_next_chunk(qdev, rx_ring, lbq_desc)) {
-				rx_ring->lbq_clean_idx = clean_idx;
+
+			if (bq->type == QLGE_SB)
+				retval = qlge_refill_sb(rx_ring, bq_desc);
+			else
+				retval = qlge_refill_lb(rx_ring, bq_desc);
+
+			if (retval > 0) {
+				dma_unmap_addr_set(bq_desc, mapaddr,
+						   bq_desc->dma_addr);
+				*bq_desc->buf_ptr =
+					cpu_to_le64(bq_desc->dma_addr);
+			} else if (retval < 0) {
+				bq->clean_idx = clean_idx;
 				netif_err(qdev, ifup, qdev->ndev,
-						"Could not get a page chunk, i=%d, clean_idx =%d .\n",
-						i, clean_idx);
+					  "ring %u %s: Could not get a page chunk, i=%d, clean_idx =%d .\n",
+					  rx_ring->cq_id,
+					  bq_type_name[bq->type], i,
+					  clean_idx);
 				return;
 			}
 
-			map = lbq_desc->p.pg_chunk.map +
-				lbq_desc->p.pg_chunk.offset;
-			dma_unmap_addr_set(lbq_desc, mapaddr, map);
-			*lbq_desc->addr = cpu_to_le64(map);
-
 			clean_idx++;
-			if (clean_idx == rx_ring->lbq_len)
+			if (clean_idx == bq->len)
 				clean_idx = 0;
 		}
 
-		rx_ring->lbq_clean_idx = clean_idx;
-		rx_ring->lbq_prod_idx += 16;
-		if (rx_ring->lbq_prod_idx == rx_ring->lbq_len)
-			rx_ring->lbq_prod_idx = 0;
-		rx_ring->lbq_free_cnt -= 16;
-	}
-
-	if (start_idx != clean_idx) {
-		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
-			     "lbq: updating prod idx = %d.\n",
-			     rx_ring->lbq_prod_idx);
-		ql_write_db_reg(rx_ring->lbq_prod_idx,
-				rx_ring->lbq_prod_idx_db_reg);
-	}
-}
-
-/* Process (refill) a small buffer queue. */
-static void ql_update_sbq(struct ql_adapter *qdev, struct rx_ring *rx_ring)
-{
-	u32 clean_idx = rx_ring->sbq_clean_idx;
-	u32 start_idx = clean_idx;
-	struct bq_desc *sbq_desc;
-	u64 map;
-	int i;
-
-	while (rx_ring->sbq_free_cnt > 16) {
-		for (i = (rx_ring->sbq_clean_idx % 16); i < 16; i++) {
-			sbq_desc = &rx_ring->sbq[clean_idx];
-			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
-				     "sbq: try cleaning clean_idx = %d.\n",
-				     clean_idx);
-			if (sbq_desc->p.skb == NULL) {
-				netif_printk(qdev, rx_status, KERN_DEBUG,
-					     qdev->ndev,
-					     "sbq: getting new skb for index %d.\n",
-					     sbq_desc->index);
-				sbq_desc->p.skb =
-				    netdev_alloc_skb(qdev->ndev,
-						     SMALL_BUFFER_SIZE);
-				if (sbq_desc->p.skb == NULL) {
-					rx_ring->sbq_clean_idx = clean_idx;
-					return;
-				}
-				skb_reserve(sbq_desc->p.skb, QLGE_SB_PAD);
-				map = pci_map_single(qdev->pdev,
-						     sbq_desc->p.skb->data,
-						     SMALL_BUF_MAP_SIZE,
-						     PCI_DMA_FROMDEVICE);
-				if (pci_dma_mapping_error(qdev->pdev, map)) {
-					netif_err(qdev, ifup, qdev->ndev,
-						  "PCI mapping failed.\n");
-					rx_ring->sbq_clean_idx = clean_idx;
-					dev_kfree_skb_any(sbq_desc->p.skb);
-					sbq_desc->p.skb = NULL;
-					return;
-				}
-				dma_unmap_addr_set(sbq_desc, mapaddr, map);
-				*sbq_desc->addr = cpu_to_le64(map);
-			}
-
-			clean_idx++;
-			if (clean_idx == rx_ring->sbq_len)
-				clean_idx = 0;
-		}
-		rx_ring->sbq_clean_idx = clean_idx;
-		rx_ring->sbq_prod_idx += 16;
-		if (rx_ring->sbq_prod_idx == rx_ring->sbq_len)
-			rx_ring->sbq_prod_idx = 0;
-		rx_ring->sbq_free_cnt -= 16;
+		bq->clean_idx = clean_idx;
+		bq->prod_idx += 16;
+		if (bq->prod_idx == bq->len)
+			bq->prod_idx = 0;
+		bq->free_cnt -= 16;
 	}
 
 	if (start_idx != clean_idx) {
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
-			     "sbq: updating prod idx = %d.\n",
-			     rx_ring->sbq_prod_idx);
-		ql_write_db_reg(rx_ring->sbq_prod_idx,
-				rx_ring->sbq_prod_idx_db_reg);
+			     "ring %u %s: updating prod idx = %d.\n",
+			     rx_ring->cq_id, bq_type_name[bq->type],
+			     bq->prod_idx);
+		ql_write_db_reg(bq->prod_idx, bq->prod_idx_db_reg);
 	}
 }
 
-static void ql_update_buffer_queues(struct ql_adapter *qdev,
-				    struct rx_ring *rx_ring)
+static void ql_update_buffer_queues(struct rx_ring *rx_ring)
 {
-	ql_update_sbq(qdev, rx_ring);
-	ql_update_lbq(qdev, rx_ring);
+	qlge_refill_bq(&rx_ring->sbq);
+	qlge_refill_bq(&rx_ring->lbq);
 }
 
 /* Unmaps tx buffers.  Can be called from send() if a pci mapping
@@ -1436,7 +1414,7 @@ static void ql_process_mac_rx_gro_page(struct ql_adapter *qdev,
 					u16 vlan_id)
 {
 	struct sk_buff *skb;
-	struct bq_desc *lbq_desc = ql_get_curr_lchunk(qdev, rx_ring);
+	struct qlge_bq_desc *lbq_desc = ql_get_curr_lchunk(qdev, rx_ring);
 	struct napi_struct *napi = &rx_ring->napi;
 
 	/* Frame error, so drop the packet. */
@@ -1485,7 +1463,7 @@ static void ql_process_mac_rx_page(struct ql_adapter *qdev,
 	struct net_device *ndev = qdev->ndev;
 	struct sk_buff *skb = NULL;
 	void *addr;
-	struct bq_desc *lbq_desc = ql_get_curr_lchunk(qdev, rx_ring);
+	struct qlge_bq_desc *lbq_desc = ql_get_curr_lchunk(qdev, rx_ring);
 	struct napi_struct *napi = &rx_ring->napi;
 	size_t hlen = ETH_HLEN;
 
@@ -1575,10 +1553,9 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 					u32 length,
 					u16 vlan_id)
 {
+	struct qlge_bq_desc *sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 	struct net_device *ndev = qdev->ndev;
-	struct sk_buff *skb = NULL;
-	struct sk_buff *new_skb = NULL;
-	struct bq_desc *sbq_desc = ql_get_curr_sbuf(rx_ring);
+	struct sk_buff *skb, *new_skb;
 
 	skb = sbq_desc->p.skb;
 	/* Allocate new_skb and copy */
@@ -1695,11 +1672,10 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 				       struct rx_ring *rx_ring,
 				       struct ib_mac_iocb_rsp *ib_mac_rsp)
 {
-	struct bq_desc *lbq_desc;
-	struct bq_desc *sbq_desc;
-	struct sk_buff *skb = NULL;
 	u32 length = le32_to_cpu(ib_mac_rsp->data_len);
 	u32 hdr_len = le32_to_cpu(ib_mac_rsp->hdr_len);
+	struct qlge_bq_desc *lbq_desc, *sbq_desc;
+	struct sk_buff *skb = NULL;
 	size_t hlen = ETH_HLEN;
 
 	/*
@@ -1712,7 +1688,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 		/*
 		 * Headers fit nicely into a small buffer.
 		 */
-		sbq_desc = ql_get_curr_sbuf(rx_ring);
+		sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 		pci_unmap_single(qdev->pdev,
 				dma_unmap_addr(sbq_desc, mapaddr),
 				SMALL_BUF_MAP_SIZE, PCI_DMA_FROMDEVICE);
@@ -1743,7 +1719,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 			 * from the "data" small buffer to the "header" small
 			 * buffer.
 			 */
-			sbq_desc = ql_get_curr_sbuf(rx_ring);
+			sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 			pci_dma_sync_single_for_cpu(qdev->pdev,
 						    dma_unmap_addr(sbq_desc,
 								   mapaddr),
@@ -1754,7 +1730,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 				     "%d bytes in a single small buffer.\n",
 				     length);
-			sbq_desc = ql_get_curr_sbuf(rx_ring);
+			sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 			skb = sbq_desc->p.skb;
 			ql_realign_skb(skb, length);
 			skb_put(skb, length);
@@ -1830,7 +1806,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 		 *          eventually be in trouble.
 		 */
 		int size, i = 0;
-		sbq_desc = ql_get_curr_sbuf(rx_ring);
+		sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 		pci_unmap_single(qdev->pdev,
 				 dma_unmap_addr(sbq_desc, mapaddr),
 				 SMALL_BUF_MAP_SIZE, PCI_DMA_FROMDEVICE);
@@ -2207,7 +2183,7 @@ static int ql_clean_inbound_rx_ring(struct rx_ring *rx_ring, int budget)
 		if (count == budget)
 			break;
 	}
-	ql_update_buffer_queues(qdev, rx_ring);
+	ql_update_buffer_queues(rx_ring);
 	ql_write_cq_idx(rx_ring);
 	return count;
 }
@@ -2749,43 +2725,42 @@ static int ql_alloc_tx_resources(struct ql_adapter *qdev,
 static void ql_free_lbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 {
 	unsigned int last_offset;
-	struct bq_desc *lbq_desc;
 
 	uint32_t  curr_idx, clean_idx;
 
 	last_offset = ql_lbq_block_size(qdev) - qdev->lbq_buf_size;
-	curr_idx = rx_ring->lbq_curr_idx;
-	clean_idx = rx_ring->lbq_clean_idx;
+	curr_idx = rx_ring->lbq.curr_idx;
+	clean_idx = rx_ring->lbq.clean_idx;
 	while (curr_idx != clean_idx) {
-		lbq_desc = &rx_ring->lbq[curr_idx];
+		struct qlge_bq_desc *lbq_desc = &rx_ring->lbq.queue[curr_idx];
 
 		if (lbq_desc->p.pg_chunk.offset == last_offset)
-			pci_unmap_page(qdev->pdev, lbq_desc->p.pg_chunk.map,
+			pci_unmap_page(qdev->pdev, lbq_desc->dma_addr,
 				       ql_lbq_block_size(qdev),
 				       PCI_DMA_FROMDEVICE);
 
 		put_page(lbq_desc->p.pg_chunk.page);
 		lbq_desc->p.pg_chunk.page = NULL;
 
-		if (++curr_idx == rx_ring->lbq_len)
+		if (++curr_idx == rx_ring->lbq.len)
 			curr_idx = 0;
-
 	}
-	if (rx_ring->pg_chunk.page) {
-		pci_unmap_page(qdev->pdev, rx_ring->pg_chunk.map,
-			ql_lbq_block_size(qdev), PCI_DMA_FROMDEVICE);
-		put_page(rx_ring->pg_chunk.page);
-		rx_ring->pg_chunk.page = NULL;
+
+	if (rx_ring->master_chunk.page) {
+		pci_unmap_page(qdev->pdev, rx_ring->chunk_dma_addr,
+			       ql_lbq_block_size(qdev), PCI_DMA_FROMDEVICE);
+		put_page(rx_ring->master_chunk.page);
+		rx_ring->master_chunk.page = NULL;
 	}
 }
 
 static void ql_free_sbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 {
 	int i;
-	struct bq_desc *sbq_desc;
 
-	for (i = 0; i < rx_ring->sbq_len; i++) {
-		sbq_desc = &rx_ring->sbq[i];
+	for (i = 0; i < rx_ring->sbq.len; i++) {
+		struct qlge_bq_desc *sbq_desc = &rx_ring->sbq.queue[i];
+
 		if (sbq_desc == NULL) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "sbq_desc %d is NULL.\n", i);
@@ -2808,13 +2783,13 @@ static void ql_free_sbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring
 static void ql_free_rx_buffers(struct ql_adapter *qdev)
 {
 	int i;
-	struct rx_ring *rx_ring;
 
 	for (i = 0; i < qdev->rx_ring_count; i++) {
-		rx_ring = &qdev->rx_ring[i];
-		if (rx_ring->lbq)
+		struct rx_ring *rx_ring = &qdev->rx_ring[i];
+
+		if (rx_ring->lbq.queue)
 			ql_free_lbq_buffers(qdev, rx_ring);
-		if (rx_ring->sbq)
+		if (rx_ring->sbq.queue)
 			ql_free_sbq_buffers(qdev, rx_ring);
 	}
 }
@@ -2827,70 +2802,70 @@ static void ql_alloc_rx_buffers(struct ql_adapter *qdev)
 	for (i = 0; i < qdev->rx_ring_count; i++) {
 		rx_ring = &qdev->rx_ring[i];
 		if (rx_ring->type != TX_Q)
-			ql_update_buffer_queues(qdev, rx_ring);
+			ql_update_buffer_queues(rx_ring);
 	}
 }
 
-static void ql_init_lbq_ring(struct ql_adapter *qdev,
-				struct rx_ring *rx_ring)
+static int qlge_init_bq(struct qlge_bq *bq)
 {
+	struct rx_ring *rx_ring = QLGE_BQ_CONTAINER(bq);
+	struct ql_adapter *qdev = rx_ring->qdev;
+	struct qlge_bq_desc *bq_desc;
+	__le64 *buf_ptr;
 	int i;
-	struct bq_desc *lbq_desc;
-	__le64 *bq = rx_ring->lbq_base;
 
-	memset(rx_ring->lbq, 0, rx_ring->lbq_len * sizeof(struct bq_desc));
-	for (i = 0; i < rx_ring->lbq_len; i++) {
-		lbq_desc = &rx_ring->lbq[i];
-		memset(lbq_desc, 0, sizeof(*lbq_desc));
-		lbq_desc->index = i;
-		lbq_desc->addr = bq;
-		bq++;
+	bq->base = pci_alloc_consistent(qdev->pdev, bq->size, &bq->base_dma);
+	if (!bq->base) {
+		netif_err(qdev, ifup, qdev->ndev,
+			  "ring %u %s allocation failed.\n", rx_ring->cq_id,
+			  bq_type_name[bq->type]);
+		return -ENOMEM;
 	}
-}
 
-static void ql_init_sbq_ring(struct ql_adapter *qdev,
-				struct rx_ring *rx_ring)
-{
-	int i;
-	struct bq_desc *sbq_desc;
-	__le64 *bq = rx_ring->sbq_base;
+	bq->queue = kmalloc_array(bq->len, sizeof(struct qlge_bq_desc),
+				  GFP_KERNEL);
+	if (!bq->queue)
+		return -ENOMEM;
 
-	memset(rx_ring->sbq, 0, rx_ring->sbq_len * sizeof(struct bq_desc));
-	for (i = 0; i < rx_ring->sbq_len; i++) {
-		sbq_desc = &rx_ring->sbq[i];
-		memset(sbq_desc, 0, sizeof(*sbq_desc));
-		sbq_desc->index = i;
-		sbq_desc->addr = bq;
-		bq++;
+	memset(bq->queue, 0, bq->len * sizeof(struct qlge_bq_desc));
+
+	buf_ptr = bq->base;
+	bq_desc = &bq->queue[0];
+	for (i = 0; i < bq->len; i++, buf_ptr++, bq_desc++) {
+		memset(bq_desc, 0, sizeof(*bq_desc));
+		bq_desc->index = i;
+		bq_desc->buf_ptr = buf_ptr;
 	}
+
+	return 0;
 }
 
 static void ql_free_rx_resources(struct ql_adapter *qdev,
 				 struct rx_ring *rx_ring)
 {
 	/* Free the small buffer queue. */
-	if (rx_ring->sbq_base) {
+	if (rx_ring->sbq.base) {
 		pci_free_consistent(qdev->pdev,
-				    rx_ring->sbq_size,
-				    rx_ring->sbq_base, rx_ring->sbq_base_dma);
-		rx_ring->sbq_base = NULL;
+				    rx_ring->sbq.size,
+				    rx_ring->sbq.base, rx_ring->sbq.base_dma);
+		rx_ring->sbq.base = NULL;
 	}
 
 	/* Free the small buffer queue control blocks. */
-	kfree(rx_ring->sbq);
-	rx_ring->sbq = NULL;
+	kfree(rx_ring->sbq.queue);
+	rx_ring->sbq.queue = NULL;
 
 	/* Free the large buffer queue. */
-	if (rx_ring->lbq_base) {
+	if (rx_ring->lbq.base) {
 		pci_free_consistent(qdev->pdev,
-				    rx_ring->lbq_size,
-				    rx_ring->lbq_base, rx_ring->lbq_base_dma);
-		rx_ring->lbq_base = NULL;
+				    rx_ring->lbq.size,
+				    rx_ring->lbq.base, rx_ring->lbq.base_dma);
+		rx_ring->lbq.base = NULL;
 	}
 
 	/* Free the large buffer queue control blocks. */
-	kfree(rx_ring->lbq);
-	rx_ring->lbq = NULL;
+	kfree(rx_ring->lbq.queue);
+	rx_ring->lbq.queue = NULL;
 
 	/* Free the rx queue. */
 	if (rx_ring->cq_base) {
@@ -2919,56 +2894,10 @@ static int ql_alloc_rx_resources(struct ql_adapter *qdev,
 		return -ENOMEM;
 	}
 
-	if (rx_ring->sbq_len) {
-		/*
-		 * Allocate small buffer queue.
-		 */
-		rx_ring->sbq_base =
-		    pci_alloc_consistent(qdev->pdev, rx_ring->sbq_size,
-					 &rx_ring->sbq_base_dma);
-
-		if (rx_ring->sbq_base == NULL) {
-			netif_err(qdev, ifup, qdev->ndev,
-				  "Small buffer queue allocation failed.\n");
-			goto err_mem;
-		}
-
-		/*
-		 * Allocate small buffer queue control blocks.
-		 */
-		rx_ring->sbq = kmalloc_array(rx_ring->sbq_len,
-					     sizeof(struct bq_desc),
-					     GFP_KERNEL);
-		if (rx_ring->sbq == NULL)
-			goto err_mem;
-
-		ql_init_sbq_ring(qdev, rx_ring);
-	}
-
-	if (rx_ring->lbq_len) {
-		/*
-		 * Allocate large buffer queue.
-		 */
-		rx_ring->lbq_base =
-		    pci_alloc_consistent(qdev->pdev, rx_ring->lbq_size,
-					 &rx_ring->lbq_base_dma);
-
-		if (rx_ring->lbq_base == NULL) {
-			netif_err(qdev, ifup, qdev->ndev,
-				  "Large buffer queue allocation failed.\n");
-			goto err_mem;
-		}
-		/*
-		 * Allocate large buffer queue control blocks.
-		 */
-		rx_ring->lbq = kmalloc_array(rx_ring->lbq_len,
-					     sizeof(struct bq_desc),
-					     GFP_KERNEL);
-		if (rx_ring->lbq == NULL)
-			goto err_mem;
-
-		ql_init_lbq_ring(qdev, rx_ring);
-	}
+	if (rx_ring->sbq.len && qlge_init_bq(&rx_ring->sbq))
+		goto err_mem;
+	if (rx_ring->lbq.len && qlge_init_bq(&rx_ring->lbq))
+		goto err_mem;
 
 	return 0;
 
@@ -3071,12 +3000,12 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	*rx_ring->prod_idx_sh_reg = 0;
 	shadow_reg += sizeof(u64);
 	shadow_reg_dma += sizeof(u64);
-	rx_ring->lbq_base_indirect = shadow_reg;
-	rx_ring->lbq_base_indirect_dma = shadow_reg_dma;
-	shadow_reg += (sizeof(u64) * MAX_DB_PAGES_PER_BQ(rx_ring->lbq_len));
-	shadow_reg_dma += (sizeof(u64) * MAX_DB_PAGES_PER_BQ(rx_ring->lbq_len));
-	rx_ring->sbq_base_indirect = shadow_reg;
-	rx_ring->sbq_base_indirect_dma = shadow_reg_dma;
+	rx_ring->lbq.base_indirect = shadow_reg;
+	rx_ring->lbq.base_indirect_dma = shadow_reg_dma;
+	shadow_reg += (sizeof(u64) * MAX_DB_PAGES_PER_BQ(rx_ring->lbq.len));
+	shadow_reg_dma += (sizeof(u64) * MAX_DB_PAGES_PER_BQ(rx_ring->lbq.len));
+	rx_ring->sbq.base_indirect = shadow_reg;
+	rx_ring->sbq.base_indirect_dma = shadow_reg_dma;
 
 	/* PCI doorbell mem area + 0x00 for consumer index register */
 	rx_ring->cnsmr_idx_db_reg = (u32 __iomem *) doorbell_area;
@@ -3087,10 +3016,10 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	rx_ring->valid_db_reg = doorbell_area + 0x04;
 
 	/* PCI doorbell mem area + 0x18 for large buffer consumer */
-	rx_ring->lbq_prod_idx_db_reg = (u32 __iomem *) (doorbell_area + 0x18);
+	rx_ring->lbq.prod_idx_db_reg = (u32 __iomem *)(doorbell_area + 0x18);
 
 	/* PCI doorbell mem area + 0x1c */
-	rx_ring->sbq_prod_idx_db_reg = (u32 __iomem *) (doorbell_area + 0x1c);
+	rx_ring->sbq.prod_idx_db_reg = (u32 __iomem *)(doorbell_area + 0x1c);
 
 	memset((void *)cqicb, 0, sizeof(struct cqicb));
 	cqicb->msix_vect = rx_ring->irq;
@@ -3108,51 +3037,50 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	cqicb->flags = FLAGS_LC |	/* Load queue base address */
 	    FLAGS_LV |		/* Load MSI-X vector */
 	    FLAGS_LI;		/* Load irq delay values */
-	if (rx_ring->lbq_len) {
+	if (rx_ring->lbq.len) {
 		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
-		tmp = (u64)rx_ring->lbq_base_dma;
-		base_indirect_ptr = rx_ring->lbq_base_indirect;
+		tmp = (u64)rx_ring->lbq.base_dma;
+		base_indirect_ptr = rx_ring->lbq.base_indirect;
 		page_entries = 0;
 		do {
 			*base_indirect_ptr = cpu_to_le64(tmp);
 			tmp += DB_PAGE_SIZE;
 			base_indirect_ptr++;
 			page_entries++;
-		} while (page_entries < MAX_DB_PAGES_PER_BQ(rx_ring->lbq_len));
-		cqicb->lbq_addr =
-		    cpu_to_le64(rx_ring->lbq_base_indirect_dma);
-		bq_len = (qdev->lbq_buf_size == 65536) ? 0 :
+		} while (page_entries < MAX_DB_PAGES_PER_BQ(rx_ring->lbq.len));
+		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
+		bq_len = qdev->lbq_buf_size == 65536 ? 0 :
 			(u16)qdev->lbq_buf_size;
 		cqicb->lbq_buf_size = cpu_to_le16(bq_len);
-		bq_len = (rx_ring->lbq_len == 65536) ? 0 :
-			(u16) rx_ring->lbq_len;
+		bq_len = (rx_ring->lbq.len == 65536) ? 0 :
+			(u16)rx_ring->lbq.len;
 		cqicb->lbq_len = cpu_to_le16(bq_len);
-		rx_ring->lbq_prod_idx = 0;
-		rx_ring->lbq_curr_idx = 0;
-		rx_ring->lbq_clean_idx = 0;
-		rx_ring->lbq_free_cnt = rx_ring->lbq_len;
+		rx_ring->lbq.prod_idx = 0;
+		rx_ring->lbq.curr_idx = 0;
+		rx_ring->lbq.clean_idx = 0;
+		rx_ring->lbq.free_cnt = rx_ring->lbq.len;
 	}
-	if (rx_ring->sbq_len) {
+	if (rx_ring->sbq.len) {
 		cqicb->flags |= FLAGS_LS;	/* Load sbq values */
-		tmp = (u64)rx_ring->sbq_base_dma;
-		base_indirect_ptr = rx_ring->sbq_base_indirect;
+		tmp = (u64)rx_ring->sbq.base_dma;
+		base_indirect_ptr = rx_ring->sbq.base_indirect;
 		page_entries = 0;
 		do {
 			*base_indirect_ptr = cpu_to_le64(tmp);
 			tmp += DB_PAGE_SIZE;
 			base_indirect_ptr++;
 			page_entries++;
-		} while (page_entries < MAX_DB_PAGES_PER_BQ(rx_ring->sbq_len));
+		} while (page_entries < MAX_DB_PAGES_PER_BQ(rx_ring->sbq.len));
 		cqicb->sbq_addr =
-		    cpu_to_le64(rx_ring->sbq_base_indirect_dma);
-		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUF_MAP_SIZE);
-		bq_len = (rx_ring->sbq_len == 65536) ? 0 :
-			(u16) rx_ring->sbq_len;
+		    cpu_to_le64(rx_ring->sbq.base_indirect_dma);
+		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
+		bq_len = (rx_ring->sbq.len == 65536) ? 0 :
+			(u16)rx_ring->sbq.len;
 		cqicb->sbq_len = cpu_to_le16(bq_len);
-		rx_ring->sbq_prod_idx = 0;
-		rx_ring->sbq_curr_idx = 0;
-		rx_ring->sbq_clean_idx = 0;
-		rx_ring->sbq_free_cnt = rx_ring->sbq_len;
+		rx_ring->sbq.prod_idx = 0;
+		rx_ring->sbq.curr_idx = 0;
+		rx_ring->sbq.clean_idx = 0;
+		rx_ring->sbq.free_cnt = rx_ring->sbq.len;
 	}
 	switch (rx_ring->type) {
 	case TX_Q:
@@ -4078,12 +4006,12 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 			rx_ring->cq_len = qdev->rx_ring_size;
 			rx_ring->cq_size =
 			    rx_ring->cq_len * sizeof(struct ql_net_rsp_iocb);
-			rx_ring->lbq_len = NUM_LARGE_BUFFERS;
-			rx_ring->lbq_size =
-			    rx_ring->lbq_len * sizeof(__le64);
-			rx_ring->sbq_len = NUM_SMALL_BUFFERS;
-			rx_ring->sbq_size =
-			    rx_ring->sbq_len * sizeof(__le64);
+			rx_ring->lbq.type = QLGE_LB;
+			rx_ring->lbq.len = NUM_LARGE_BUFFERS;
+			rx_ring->lbq.size = rx_ring->lbq.len * sizeof(__le64);
+			rx_ring->sbq.type = QLGE_SB;
+			rx_ring->sbq.len = NUM_SMALL_BUFFERS;
+			rx_ring->sbq.size = rx_ring->sbq.len * sizeof(__le64);
 			rx_ring->type = RX_Q;
 		} else {
 			/*
@@ -4093,10 +4021,10 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 			rx_ring->cq_len = qdev->tx_ring_size;
 			rx_ring->cq_size =
 			    rx_ring->cq_len * sizeof(struct ql_net_rsp_iocb);
-			rx_ring->lbq_len = 0;
-			rx_ring->lbq_size = 0;
-			rx_ring->sbq_len = 0;
-			rx_ring->sbq_size = 0;
+			rx_ring->lbq.len = 0;
+			rx_ring->lbq.size = 0;
+			rx_ring->sbq.len = 0;
+			rx_ring->sbq.size = 0;
 			rx_ring->type = TX_Q;
 		}
 	}
-- 
2.21.0

