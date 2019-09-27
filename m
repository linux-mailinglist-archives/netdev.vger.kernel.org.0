Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 818C6C0332
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfI0KPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:15:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:57524 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727455AbfI0KPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:15:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 35281AF92;
        Fri, 27 Sep 2019 10:15:28 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/17] staging: qlge: Remove qlge_bq.len & size
Date:   Fri, 27 Sep 2019 19:12:06 +0900
Message-Id: <20190927101210.23856-13-bpoirier@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927101210.23856-1-bpoirier@suse.com>
References: <20190927101210.23856-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given the way the driver currently works, these values are always known
at compile time.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/staging/qlge/qlge.h      | 17 +++++---
 drivers/staging/qlge/qlge_dbg.c  |  4 --
 drivers/staging/qlge/qlge_main.c | 75 ++++++++++++--------------------
 3 files changed, 39 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 24af938da7a4..5e773af50397 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -34,8 +34,13 @@
 #define NUM_TX_RING_ENTRIES	256
 #define NUM_RX_RING_ENTRIES	256
 
-#define NUM_SMALL_BUFFERS   512
-#define NUM_LARGE_BUFFERS   512
+/* Use the same len for sbq and lbq. Note that it seems like the device might
+ * support different sizes.
+ */
+#define QLGE_BQ_SHIFT 9
+#define QLGE_BQ_LEN BIT(QLGE_BQ_SHIFT)
+#define QLGE_BQ_SIZE (QLGE_BQ_LEN * sizeof(__le64))
+
 #define DB_PAGE_SIZE 4096
 
 /* Calculate the number of (4k) pages required to
@@ -46,8 +51,8 @@
 		(((x * sizeof(u64)) % DB_PAGE_SIZE) ? 1 : 0))
 
 #define RX_RING_SHADOW_SPACE	(sizeof(u64) + \
-		MAX_DB_PAGES_PER_BQ(NUM_SMALL_BUFFERS) * sizeof(u64) + \
-		MAX_DB_PAGES_PER_BQ(NUM_LARGE_BUFFERS) * sizeof(u64))
+		MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN) * sizeof(u64) + \
+		MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN) * sizeof(u64))
 #define LARGE_BUFFER_MAX_SIZE 8192
 #define LARGE_BUFFER_MIN_SIZE 2048
 
@@ -1419,8 +1424,6 @@ struct qlge_bq {
 	dma_addr_t base_indirect_dma;
 	struct qlge_bq_desc *queue;
 	void __iomem *prod_idx_db_reg;
-	u32 len;			/* entry count */
-	u32 size;			/* size in bytes of hw ring */
 	u32 prod_idx;			/* current sw prod idx */
 	u32 curr_idx;			/* next entry we expect */
 	u32 clean_idx;			/* beginning of new descs */
@@ -1439,6 +1442,8 @@ struct qlge_bq {
 					  offsetof(struct rx_ring, lbq))); \
 })
 
+#define QLGE_BQ_WRAP(index) ((index) & (QLGE_BQ_LEN - 1))
+
 struct rx_ring {
 	struct cqicb cqicb;	/* The chip's completion queue init control block. */
 
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index a177302073db..c21d1b228bd2 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1775,8 +1775,6 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	pr_err("rx_ring->lbq.base_indirect_dma = %llx\n",
 	       (unsigned long long)rx_ring->lbq.base_indirect_dma);
 	pr_err("rx_ring->lbq = %p\n", rx_ring->lbq.queue);
-	pr_err("rx_ring->lbq.len = %d\n", rx_ring->lbq.len);
-	pr_err("rx_ring->lbq.size = %d\n", rx_ring->lbq.size);
 	pr_err("rx_ring->lbq.prod_idx_db_reg = %p\n",
 	       rx_ring->lbq.prod_idx_db_reg);
 	pr_err("rx_ring->lbq.prod_idx = %d\n", rx_ring->lbq.prod_idx);
@@ -1792,8 +1790,6 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	pr_err("rx_ring->sbq.base_indirect_dma = %llx\n",
 	       (unsigned long long)rx_ring->sbq.base_indirect_dma);
 	pr_err("rx_ring->sbq = %p\n", rx_ring->sbq.queue);
-	pr_err("rx_ring->sbq.len = %d\n", rx_ring->sbq.len);
-	pr_err("rx_ring->sbq.size = %d\n", rx_ring->sbq.size);
 	pr_err("rx_ring->sbq.prod_idx_db_reg addr = %p\n",
 	       rx_ring->sbq.prod_idx_db_reg);
 	pr_err("rx_ring->sbq.prod_idx = %d\n", rx_ring->sbq.prod_idx);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index e1099bd29672..ef33db118aa1 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -982,9 +982,8 @@ static struct qlge_bq_desc *qlge_get_curr_buf(struct qlge_bq *bq)
 {
 	struct qlge_bq_desc *bq_desc;
 
-	bq_desc = &bq->queue[bq->curr_idx++];
-	if (bq->curr_idx == bq->len)
-		bq->curr_idx = 0;
+	bq_desc = &bq->queue[bq->curr_idx];
+	bq->curr_idx = QLGE_BQ_WRAP(bq->curr_idx + 1);
 	bq->free_cnt++;
 
 	return bq_desc;
@@ -1149,15 +1148,11 @@ static void qlge_refill_bq(struct qlge_bq *bq)
 				return;
 			}
 
-			clean_idx++;
-			if (clean_idx == bq->len)
-				clean_idx = 0;
+			clean_idx = QLGE_BQ_WRAP(clean_idx + 1);
 		}
 
 		bq->clean_idx = clean_idx;
-		bq->prod_idx += 16;
-		if (bq->prod_idx == bq->len)
-			bq->prod_idx = 0;
+		bq->prod_idx = QLGE_BQ_WRAP(bq->prod_idx + 16);
 		bq->free_cnt -= 16;
 	}
 
@@ -2732,8 +2727,7 @@ static void ql_free_lbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring
 		put_page(lbq_desc->p.pg_chunk.page);
 		lbq_desc->p.pg_chunk.page = NULL;
 
-		if (++curr_idx == rx_ring->lbq.len)
-			curr_idx = 0;
+		curr_idx = QLGE_BQ_WRAP(curr_idx + 1);
 	}
 
 	if (rx_ring->master_chunk.page) {
@@ -2748,7 +2742,7 @@ static void ql_free_sbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring
 {
 	int i;
 
-	for (i = 0; i < rx_ring->sbq.len; i++) {
+	for (i = 0; i < QLGE_BQ_LEN; i++) {
 		struct qlge_bq_desc *sbq_desc = &rx_ring->sbq.queue[i];
 
 		if (sbq_desc == NULL) {
@@ -2799,7 +2793,8 @@ static int qlge_init_bq(struct qlge_bq *bq)
 	__le64 *buf_ptr;
 	int i;
 
-	bq->base = pci_alloc_consistent(qdev->pdev, bq->size, &bq->base_dma);
+	bq->base = pci_alloc_consistent(qdev->pdev, QLGE_BQ_SIZE,
+					&bq->base_dma);
 	if (!bq->base) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "ring %u %s allocation failed.\n", rx_ring->cq_id,
@@ -2807,16 +2802,16 @@ static int qlge_init_bq(struct qlge_bq *bq)
 		return -ENOMEM;
 	}
 
-	bq->queue = kmalloc_array(bq->len, sizeof(struct qlge_bq_desc),
+	bq->queue = kmalloc_array(QLGE_BQ_LEN, sizeof(struct qlge_bq_desc),
 				  GFP_KERNEL);
 	if (!bq->queue)
 		return -ENOMEM;
 
-	memset(bq->queue, 0, bq->len * sizeof(struct qlge_bq_desc));
+	memset(bq->queue, 0, QLGE_BQ_LEN * sizeof(struct qlge_bq_desc));
 
 	buf_ptr = bq->base;
 	bq_desc = &bq->queue[0];
-	for (i = 0; i < bq->len; i++, buf_ptr++, bq_desc++) {
+	for (i = 0; i < QLGE_BQ_LEN; i++, buf_ptr++, bq_desc++) {
 		memset(bq_desc, 0, sizeof(*bq_desc));
 		bq_desc->index = i;
 		bq_desc->buf_ptr = buf_ptr;
@@ -2830,8 +2825,7 @@ static void ql_free_rx_resources(struct ql_adapter *qdev,
 {
 	/* Free the small buffer queue. */
 	if (rx_ring->sbq.base) {
-		pci_free_consistent(qdev->pdev,
-				    rx_ring->sbq.size,
+		pci_free_consistent(qdev->pdev, QLGE_BQ_SIZE,
 				    rx_ring->sbq.base, rx_ring->sbq.base_dma);
 		rx_ring->sbq.base = NULL;
 	}
@@ -2842,8 +2836,7 @@ static void ql_free_rx_resources(struct ql_adapter *qdev,
 
 	/* Free the large buffer queue. */
 	if (rx_ring->lbq.base) {
-		pci_free_consistent(qdev->pdev,
-				    rx_ring->lbq.size,
+		pci_free_consistent(qdev->pdev, QLGE_BQ_SIZE,
 				    rx_ring->lbq.base, rx_ring->lbq.base_dma);
 		rx_ring->lbq.base = NULL;
 	}
@@ -2879,16 +2872,13 @@ static int ql_alloc_rx_resources(struct ql_adapter *qdev,
 		return -ENOMEM;
 	}
 
-	if (rx_ring->sbq.len && qlge_init_bq(&rx_ring->sbq))
-		goto err_mem;
-	if (rx_ring->lbq.len && qlge_init_bq(&rx_ring->lbq))
-		goto err_mem;
+	if (rx_ring->cq_id < qdev->rss_ring_count &&
+	    (qlge_init_bq(&rx_ring->sbq) || qlge_init_bq(&rx_ring->lbq))) {
+		ql_free_rx_resources(qdev, rx_ring);
+		return -ENOMEM;
+	}
 
 	return 0;
-
-err_mem:
-	ql_free_rx_resources(qdev, rx_ring);
-	return -ENOMEM;
 }
 
 static void ql_tx_ring_clean(struct ql_adapter *qdev)
@@ -2986,8 +2976,8 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	shadow_reg_dma += sizeof(u64);
 	rx_ring->lbq.base_indirect = shadow_reg;
 	rx_ring->lbq.base_indirect_dma = shadow_reg_dma;
-	shadow_reg += (sizeof(u64) * MAX_DB_PAGES_PER_BQ(rx_ring->lbq.len));
-	shadow_reg_dma += (sizeof(u64) * MAX_DB_PAGES_PER_BQ(rx_ring->lbq.len));
+	shadow_reg += (sizeof(u64) * MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
+	shadow_reg_dma += (sizeof(u64) * MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
 	rx_ring->sbq.base_indirect = shadow_reg;
 	rx_ring->sbq.base_indirect_dma = shadow_reg_dma;
 
@@ -3021,7 +3011,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	cqicb->flags = FLAGS_LC |	/* Load queue base address */
 	    FLAGS_LV |		/* Load MSI-X vector */
 	    FLAGS_LI;		/* Load irq delay values */
-	if (rx_ring->lbq.len) {
+	if (rx_ring->cq_id < qdev->rss_ring_count) {
 		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
 		tmp = (u64)rx_ring->lbq.base_dma;
 		base_indirect_ptr = rx_ring->lbq.base_indirect;
@@ -3031,17 +3021,16 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 			tmp += DB_PAGE_SIZE;
 			base_indirect_ptr++;
 			page_entries++;
-		} while (page_entries < MAX_DB_PAGES_PER_BQ(rx_ring->lbq.len));
+		} while (page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
 		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
 		cqicb->lbq_buf_size =
 			cpu_to_le16(QLGE_FIT16(qdev->lbq_buf_size));
-		cqicb->lbq_len = cpu_to_le16(QLGE_FIT16(rx_ring->lbq.len));
+		cqicb->lbq_len = cpu_to_le16(QLGE_FIT16(QLGE_BQ_LEN));
 		rx_ring->lbq.prod_idx = 0;
 		rx_ring->lbq.curr_idx = 0;
 		rx_ring->lbq.clean_idx = 0;
-		rx_ring->lbq.free_cnt = rx_ring->lbq.len;
-	}
-	if (rx_ring->sbq.len) {
+		rx_ring->lbq.free_cnt = QLGE_BQ_LEN;
+
 		cqicb->flags |= FLAGS_LS;	/* Load sbq values */
 		tmp = (u64)rx_ring->sbq.base_dma;
 		base_indirect_ptr = rx_ring->sbq.base_indirect;
@@ -3051,15 +3040,15 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 			tmp += DB_PAGE_SIZE;
 			base_indirect_ptr++;
 			page_entries++;
-		} while (page_entries < MAX_DB_PAGES_PER_BQ(rx_ring->sbq.len));
+		} while (page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
 		cqicb->sbq_addr =
 		    cpu_to_le64(rx_ring->sbq.base_indirect_dma);
 		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
-		cqicb->sbq_len = cpu_to_le16(QLGE_FIT16(rx_ring->sbq.len));
+		cqicb->sbq_len = cpu_to_le16(QLGE_FIT16(QLGE_BQ_LEN));
 		rx_ring->sbq.prod_idx = 0;
 		rx_ring->sbq.curr_idx = 0;
 		rx_ring->sbq.clean_idx = 0;
-		rx_ring->sbq.free_cnt = rx_ring->sbq.len;
+		rx_ring->sbq.free_cnt = QLGE_BQ_LEN;
 	}
 	if (rx_ring->cq_id < qdev->rss_ring_count) {
 		/* Inbound completion handling rx_rings run in
@@ -3986,11 +3975,7 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 			rx_ring->cq_size =
 			    rx_ring->cq_len * sizeof(struct ql_net_rsp_iocb);
 			rx_ring->lbq.type = QLGE_LB;
-			rx_ring->lbq.len = NUM_LARGE_BUFFERS;
-			rx_ring->lbq.size = rx_ring->lbq.len * sizeof(__le64);
 			rx_ring->sbq.type = QLGE_SB;
-			rx_ring->sbq.len = NUM_SMALL_BUFFERS;
-			rx_ring->sbq.size = rx_ring->sbq.len * sizeof(__le64);
 		} else {
 			/*
 			 * Outbound queue handles outbound completions only.
@@ -3999,10 +3984,6 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 			rx_ring->cq_len = qdev->tx_ring_size;
 			rx_ring->cq_size =
 			    rx_ring->cq_len * sizeof(struct ql_net_rsp_iocb);
-			rx_ring->lbq.len = 0;
-			rx_ring->lbq.size = 0;
-			rx_ring->sbq.len = 0;
-			rx_ring->sbq.size = 0;
 		}
 	}
 	return 0;
-- 
2.23.0

