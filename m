Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D8EC0339
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfI0KPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:15:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:57738 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727640AbfI0KPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:15:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2C77BAFD0;
        Fri, 27 Sep 2019 10:15:38 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 15/17] staging: qlge: Update buffer queue prod index despite oom
Date:   Fri, 27 Sep 2019 19:12:09 +0900
Message-Id: <20190927101210.23856-16-bpoirier@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927101210.23856-1-bpoirier@suse.com>
References: <20190927101210.23856-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, if we repeatedly fail to allocate all of the buffers from the
desired batching budget, we will never update the prod_idx register.
Restructure code to always update prod_idx if new buffers could be
allocated. This eliminates the current two stage process (clean_idx ->
prod_idx) and some associated bookkeeping variables.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/staging/qlge/qlge.h      |   8 +--
 drivers/staging/qlge/qlge_dbg.c  |  10 ++-
 drivers/staging/qlge/qlge_main.c | 105 +++++++++++++++----------------
 3 files changed, 60 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 5e773af50397..7c48e333d29b 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -1424,10 +1424,10 @@ struct qlge_bq {
 	dma_addr_t base_indirect_dma;
 	struct qlge_bq_desc *queue;
 	void __iomem *prod_idx_db_reg;
-	u32 prod_idx;			/* current sw prod idx */
-	u32 curr_idx;			/* next entry we expect */
-	u32 clean_idx;			/* beginning of new descs */
-	u32 free_cnt;			/* free buffer desc cnt */
+	/* next index where sw should refill a buffer for hw */
+	u16 next_to_use;
+	/* next index where sw expects to find a buffer filled by hw */
+	u16 next_to_clean;
 	enum {
 		QLGE_SB,		/* small buffer */
 		QLGE_LB,		/* large buffer */
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index c21d1b228bd2..08d9223956c2 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1777,8 +1777,8 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	pr_err("rx_ring->lbq = %p\n", rx_ring->lbq.queue);
 	pr_err("rx_ring->lbq.prod_idx_db_reg = %p\n",
 	       rx_ring->lbq.prod_idx_db_reg);
-	pr_err("rx_ring->lbq.prod_idx = %d\n", rx_ring->lbq.prod_idx);
-	pr_err("rx_ring->lbq.curr_idx = %d\n", rx_ring->lbq.curr_idx);
+	pr_err("rx_ring->lbq.next_to_use = %d\n", rx_ring->lbq.next_to_use);
+	pr_err("rx_ring->lbq.next_to_clean = %d\n", rx_ring->lbq.next_to_clean);
 	pr_err("rx_ring->lbq_clean_idx = %d\n", rx_ring->lbq_clean_idx);
 	pr_err("rx_ring->lbq_free_cnt = %d\n", rx_ring->lbq_free_cnt);
 
@@ -1792,10 +1792,8 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	pr_err("rx_ring->sbq = %p\n", rx_ring->sbq.queue);
 	pr_err("rx_ring->sbq.prod_idx_db_reg addr = %p\n",
 	       rx_ring->sbq.prod_idx_db_reg);
-	pr_err("rx_ring->sbq.prod_idx = %d\n", rx_ring->sbq.prod_idx);
-	pr_err("rx_ring->sbq.curr_idx = %d\n", rx_ring->sbq.curr_idx);
-	pr_err("rx_ring->sbq.clean_idx = %d\n", rx_ring->sbq.clean_idx);
-	pr_err("rx_ring->sbq.free_cnt = %d\n", rx_ring->sbq.free_cnt);
+	pr_err("rx_ring->sbq.next_to_use = %d\n", rx_ring->sbq.next_to_use);
+	pr_err("rx_ring->sbq.next_to_clean = %d\n", rx_ring->sbq.next_to_clean);
 	pr_err("rx_ring->cq_id = %d\n", rx_ring->cq_id);
 	pr_err("rx_ring->irq = %d\n", rx_ring->irq);
 	pr_err("rx_ring->cpu = %d\n", rx_ring->cpu);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 009934bcb515..83e75005688a 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -982,9 +982,8 @@ static struct qlge_bq_desc *qlge_get_curr_buf(struct qlge_bq *bq)
 {
 	struct qlge_bq_desc *bq_desc;
 
-	bq_desc = &bq->queue[bq->curr_idx];
-	bq->curr_idx = QLGE_BQ_WRAP(bq->curr_idx + 1);
-	bq->free_cnt++;
+	bq_desc = &bq->queue[bq->next_to_clean];
+	bq->next_to_clean = QLGE_BQ_WRAP(bq->next_to_clean + 1);
 
 	return bq_desc;
 }
@@ -1114,9 +1113,9 @@ static void qlge_refill_bq(struct qlge_bq *bq)
 {
 	struct rx_ring *rx_ring = QLGE_BQ_CONTAINER(bq);
 	struct ql_adapter *qdev = rx_ring->qdev;
-	u32 clean_idx = bq->clean_idx;
+	struct qlge_bq_desc *bq_desc;
+	int free_count, refill_count;
 	unsigned int reserved_count;
-	u32 start_idx = clean_idx;
 	int i;
 
 	if (bq->type == QLGE_SB)
@@ -1124,44 +1123,52 @@ static void qlge_refill_bq(struct qlge_bq *bq)
 	else
 		reserved_count = 32;
 
-	while (bq->free_cnt > reserved_count) {
-		for (i = (bq->clean_idx % 16); i < 16; i++) {
-			struct qlge_bq_desc *bq_desc = &bq->queue[clean_idx];
-			int retval;
+	free_count = bq->next_to_clean - bq->next_to_use;
+	if (free_count <= 0)
+		free_count += QLGE_BQ_LEN;
 
-			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
-				     "ring %u %s: try cleaning clean_idx = %d.\n",
-				     rx_ring->cq_id, bq_type_name[bq->type],
-				     clean_idx);
-
-			if (bq->type == QLGE_SB)
-				retval = qlge_refill_sb(rx_ring, bq_desc);
-			else
-				retval = qlge_refill_lb(rx_ring, bq_desc);
-			if (retval < 0) {
-				bq->clean_idx = clean_idx;
-				netif_err(qdev, ifup, qdev->ndev,
-					  "ring %u %s: Could not get a page chunk, i=%d, clean_idx =%d .\n",
-					  rx_ring->cq_id,
-					  bq_type_name[bq->type], i,
-					  clean_idx);
-				return;
-			}
+	refill_count = free_count - reserved_count;
+	/* refill batch size */
+	if (refill_count < 16)
+		return;
+
+	i = bq->next_to_use;
+	bq_desc = &bq->queue[i];
+	i -= QLGE_BQ_LEN;
+	do {
+		int retval;
+
+		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
+			     "ring %u %s: try cleaning idx %d\n",
+			     rx_ring->cq_id, bq_type_name[bq->type], i);
 
-			clean_idx = QLGE_BQ_WRAP(clean_idx + 1);
+		if (bq->type == QLGE_SB)
+			retval = qlge_refill_sb(rx_ring, bq_desc);
+		else
+			retval = qlge_refill_lb(rx_ring, bq_desc);
+		if (retval < 0) {
+			netif_err(qdev, ifup, qdev->ndev,
+				  "ring %u %s: Could not get a page chunk, idx %d\n",
+				  rx_ring->cq_id, bq_type_name[bq->type], i);
+			break;
 		}
 
-		bq->clean_idx = clean_idx;
-		bq->prod_idx = QLGE_BQ_WRAP(bq->prod_idx + 16);
-		bq->free_cnt -= 16;
-	}
+		bq_desc++;
+		i++;
+		if (unlikely(!i)) {
+			bq_desc = &bq->queue[0];
+			i -= QLGE_BQ_LEN;
+		}
+		refill_count--;
+	} while (refill_count);
+	i += QLGE_BQ_LEN;
 
-	if (start_idx != clean_idx) {
+	if (bq->next_to_use != i) {
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 			     "ring %u %s: updating prod idx = %d.\n",
-			     rx_ring->cq_id, bq_type_name[bq->type],
-			     bq->prod_idx);
-		ql_write_db_reg(bq->prod_idx, bq->prod_idx_db_reg);
+			     rx_ring->cq_id, bq_type_name[bq->type], i);
+		bq->next_to_use = i;
+		ql_write_db_reg(bq->next_to_use, bq->prod_idx_db_reg);
 	}
 }
 
@@ -2709,25 +2716,21 @@ static int ql_alloc_tx_resources(struct ql_adapter *qdev,
 
 static void ql_free_lbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 {
+	struct qlge_bq *lbq = &rx_ring->lbq;
 	unsigned int last_offset;
 
-	uint32_t  curr_idx, clean_idx;
-
 	last_offset = ql_lbq_block_size(qdev) - qdev->lbq_buf_size;
-	curr_idx = rx_ring->lbq.curr_idx;
-	clean_idx = rx_ring->lbq.clean_idx;
-	while (curr_idx != clean_idx) {
-		struct qlge_bq_desc *lbq_desc = &rx_ring->lbq.queue[curr_idx];
+	while (lbq->next_to_clean != lbq->next_to_use) {
+		struct qlge_bq_desc *lbq_desc =
+			&lbq->queue[lbq->next_to_clean];
 
 		if (lbq_desc->p.pg_chunk.offset == last_offset)
 			pci_unmap_page(qdev->pdev, lbq_desc->dma_addr,
 				       ql_lbq_block_size(qdev),
 				       PCI_DMA_FROMDEVICE);
-
 		put_page(lbq_desc->p.pg_chunk.page);
-		lbq_desc->p.pg_chunk.page = NULL;
 
-		curr_idx = QLGE_BQ_WRAP(curr_idx + 1);
+		lbq->next_to_clean = QLGE_BQ_WRAP(lbq->next_to_clean + 1);
 	}
 
 	if (rx_ring->master_chunk.page) {
@@ -3024,10 +3027,8 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 		cqicb->lbq_buf_size =
 			cpu_to_le16(QLGE_FIT16(qdev->lbq_buf_size));
 		cqicb->lbq_len = cpu_to_le16(QLGE_FIT16(QLGE_BQ_LEN));
-		rx_ring->lbq.prod_idx = 0;
-		rx_ring->lbq.curr_idx = 0;
-		rx_ring->lbq.clean_idx = 0;
-		rx_ring->lbq.free_cnt = QLGE_BQ_LEN;
+		rx_ring->lbq.next_to_use = 0;
+		rx_ring->lbq.next_to_clean = 0;
 
 		cqicb->flags |= FLAGS_LS;	/* Load sbq values */
 		tmp = (u64)rx_ring->sbq.base_dma;
@@ -3043,10 +3044,8 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 		    cpu_to_le64(rx_ring->sbq.base_indirect_dma);
 		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
 		cqicb->sbq_len = cpu_to_le16(QLGE_FIT16(QLGE_BQ_LEN));
-		rx_ring->sbq.prod_idx = 0;
-		rx_ring->sbq.curr_idx = 0;
-		rx_ring->sbq.clean_idx = 0;
-		rx_ring->sbq.free_cnt = QLGE_BQ_LEN;
+		rx_ring->sbq.next_to_use = 0;
+		rx_ring->sbq.next_to_clean = 0;
 	}
 	if (rx_ring->cq_id < qdev->rss_ring_count) {
 		/* Inbound completion handling rx_rings run in
-- 
2.23.0

