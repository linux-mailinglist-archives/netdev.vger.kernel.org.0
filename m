Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94BD0C0347
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfI0KPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:15:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:56996 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbfI0KPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:15:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DAC37AFD0;
        Fri, 27 Sep 2019 10:15:01 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Subject: [PATCH v2 04/17] staging: qlge: Deduplicate lbq_buf_size
Date:   Fri, 27 Sep 2019 19:11:58 +0900
Message-Id: <20190927101210.23856-5-bpoirier@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927101210.23856-1-bpoirier@suse.com>
References: <20190927101210.23856-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lbq_buf_size is duplicated to every rx_ring structure whereas lbq_buf_order
is present once in the ql_adapter structure. All rings use the same buf
size, keep only one copy of it. Also factor out the calculation of
lbq_buf_size instead of having two copies.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 drivers/staging/qlge/qlge.h      |  2 +-
 drivers/staging/qlge/qlge_dbg.c  |  2 +-
 drivers/staging/qlge/qlge_main.c | 61 ++++++++++++++------------------
 3 files changed, 28 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 0a156a95e981..ba61b4559dd6 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -1433,7 +1433,6 @@ struct rx_ring {
 	/* Large buffer queue elements. */
 	u32 lbq_len;		/* entry count */
 	u32 lbq_size;		/* size in bytes of queue */
-	u32 lbq_buf_size;
 	void *lbq_base;
 	dma_addr_t lbq_base_dma;
 	void *lbq_base_indirect;
@@ -2108,6 +2107,7 @@ struct ql_adapter {
 	struct rx_ring rx_ring[MAX_RX_RINGS];
 	struct tx_ring tx_ring[MAX_TX_RINGS];
 	unsigned int lbq_buf_order;
+	u32 lbq_buf_size;
 
 	int rx_csum;
 	u32 default_rx_queue;
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 31389ab8bdf7..46599d74c6fb 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1630,6 +1630,7 @@ void ql_dump_qdev(struct ql_adapter *qdev)
 	DUMP_QDEV_FIELD(qdev, "0x%08x", xg_sem_mask);
 	DUMP_QDEV_FIELD(qdev, "0x%08x", port_link_up);
 	DUMP_QDEV_FIELD(qdev, "0x%08x", port_init);
+	DUMP_QDEV_FIELD(qdev, "%u", lbq_buf_size);
 }
 #endif
 
@@ -1774,7 +1775,6 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	pr_err("rx_ring->lbq_curr_idx = %d\n", rx_ring->lbq_curr_idx);
 	pr_err("rx_ring->lbq_clean_idx = %d\n", rx_ring->lbq_clean_idx);
 	pr_err("rx_ring->lbq_free_cnt = %d\n", rx_ring->lbq_free_cnt);
-	pr_err("rx_ring->lbq_buf_size = %d\n", rx_ring->lbq_buf_size);
 
 	pr_err("rx_ring->sbq_base = %p\n", rx_ring->sbq_base);
 	pr_err("rx_ring->sbq_base_dma = %llx\n",
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index a82920776e6b..2b1cc4b29bed 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -995,15 +995,14 @@ static struct bq_desc *ql_get_curr_lchunk(struct ql_adapter *qdev,
 	struct bq_desc *lbq_desc = ql_get_curr_lbuf(rx_ring);
 
 	pci_dma_sync_single_for_cpu(qdev->pdev,
-					dma_unmap_addr(lbq_desc, mapaddr),
-				    rx_ring->lbq_buf_size,
-					PCI_DMA_FROMDEVICE);
+				    dma_unmap_addr(lbq_desc, mapaddr),
+				    qdev->lbq_buf_size, PCI_DMA_FROMDEVICE);
 
 	/* If it's the last chunk of our master page then
 	 * we unmap it.
 	 */
-	if ((lbq_desc->p.pg_chunk.offset + rx_ring->lbq_buf_size)
-					== ql_lbq_block_size(qdev))
+	if (lbq_desc->p.pg_chunk.offset + qdev->lbq_buf_size ==
+	    ql_lbq_block_size(qdev))
 		pci_unmap_page(qdev->pdev,
 				lbq_desc->p.pg_chunk.map,
 				ql_lbq_block_size(qdev),
@@ -1074,11 +1073,11 @@ static int ql_get_next_chunk(struct ql_adapter *qdev, struct rx_ring *rx_ring,
 	/* Adjust the master page chunk for next
 	 * buffer get.
 	 */
-	rx_ring->pg_chunk.offset += rx_ring->lbq_buf_size;
+	rx_ring->pg_chunk.offset += qdev->lbq_buf_size;
 	if (rx_ring->pg_chunk.offset == ql_lbq_block_size(qdev)) {
 		rx_ring->pg_chunk.page = NULL;
 	} else {
-		rx_ring->pg_chunk.va += rx_ring->lbq_buf_size;
+		rx_ring->pg_chunk.va += qdev->lbq_buf_size;
 		get_page(rx_ring->pg_chunk.page);
 	}
 	return 0;
@@ -1110,12 +1109,12 @@ static void ql_update_lbq(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 				lbq_desc->p.pg_chunk.offset;
 			dma_unmap_addr_set(lbq_desc, mapaddr, map);
 			dma_unmap_len_set(lbq_desc, maplen,
-					rx_ring->lbq_buf_size);
+					  qdev->lbq_buf_size);
 			*lbq_desc->addr = cpu_to_le64(map);
 
 			pci_dma_sync_single_for_device(qdev->pdev, map,
-						rx_ring->lbq_buf_size,
-						PCI_DMA_FROMDEVICE);
+						       qdev->lbq_buf_size,
+						       PCI_DMA_FROMDEVICE);
 			clean_idx++;
 			if (clean_idx == rx_ring->lbq_len)
 				clean_idx = 0;
@@ -1880,8 +1879,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 		}
 		do {
 			lbq_desc = ql_get_curr_lchunk(qdev, rx_ring);
-			size = (length < rx_ring->lbq_buf_size) ? length :
-				rx_ring->lbq_buf_size;
+			size = min(length, qdev->lbq_buf_size);
 
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 				     "Adding page %d to skb for %d bytes.\n",
@@ -2776,12 +2774,12 @@ static int ql_alloc_tx_resources(struct ql_adapter *qdev,
 
 static void ql_free_lbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 {
-	unsigned int last_offset = ql_lbq_block_size(qdev) -
-		rx_ring->lbq_buf_size;
+	unsigned int last_offset;
 	struct bq_desc *lbq_desc;
 
 	uint32_t  curr_idx, clean_idx;
 
+	last_offset = ql_lbq_block_size(qdev) - qdev->lbq_buf_size;
 	curr_idx = rx_ring->lbq_curr_idx;
 	clean_idx = rx_ring->lbq_clean_idx;
 	while (curr_idx != clean_idx) {
@@ -3149,8 +3147,8 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 		} while (page_entries < MAX_DB_PAGES_PER_BQ(rx_ring->lbq_len));
 		cqicb->lbq_addr =
 		    cpu_to_le64(rx_ring->lbq_base_indirect_dma);
-		bq_len = (rx_ring->lbq_buf_size == 65536) ? 0 :
-			(u16) rx_ring->lbq_buf_size;
+		bq_len = (qdev->lbq_buf_size == 65536) ? 0 :
+			(u16)qdev->lbq_buf_size;
 		cqicb->lbq_buf_size = cpu_to_le16(bq_len);
 		bq_len = (rx_ring->lbq_len == 65536) ? 0 :
 			(u16) rx_ring->lbq_len;
@@ -4059,16 +4057,21 @@ static int qlge_close(struct net_device *ndev)
 	return 0;
 }
 
+static void qlge_set_lb_size(struct ql_adapter *qdev)
+{
+	if (qdev->ndev->mtu <= 1500)
+		qdev->lbq_buf_size = LARGE_BUFFER_MIN_SIZE;
+	else
+		qdev->lbq_buf_size = LARGE_BUFFER_MAX_SIZE;
+	qdev->lbq_buf_order = get_order(qdev->lbq_buf_size);
+}
+
 static int ql_configure_rings(struct ql_adapter *qdev)
 {
 	int i;
 	struct rx_ring *rx_ring;
 	struct tx_ring *tx_ring;
 	int cpu_cnt = min(MAX_CPUS, (int)num_online_cpus());
-	unsigned int lbq_buf_len = (qdev->ndev->mtu > 1500) ?
-		LARGE_BUFFER_MAX_SIZE : LARGE_BUFFER_MIN_SIZE;
-
-	qdev->lbq_buf_order = get_order(lbq_buf_len);
 
 	/* In a perfect world we have one RSS ring for each CPU
 	 * and each has it's own vector.  To do that we ask for
@@ -4116,7 +4119,6 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 			rx_ring->lbq_len = NUM_LARGE_BUFFERS;
 			rx_ring->lbq_size =
 			    rx_ring->lbq_len * sizeof(__le64);
-			rx_ring->lbq_buf_size = (u16)lbq_buf_len;
 			rx_ring->sbq_len = NUM_SMALL_BUFFERS;
 			rx_ring->sbq_size =
 			    rx_ring->sbq_len * sizeof(__le64);
@@ -4132,7 +4134,6 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 			    rx_ring->cq_len * sizeof(struct ql_net_rsp_iocb);
 			rx_ring->lbq_len = 0;
 			rx_ring->lbq_size = 0;
-			rx_ring->lbq_buf_size = 0;
 			rx_ring->sbq_len = 0;
 			rx_ring->sbq_size = 0;
 			rx_ring->sbq_buf_size = 0;
@@ -4151,6 +4152,7 @@ static int qlge_open(struct net_device *ndev)
 	if (err)
 		return err;
 
+	qlge_set_lb_size(qdev);
 	err = ql_configure_rings(qdev);
 	if (err)
 		return err;
@@ -4172,9 +4174,7 @@ static int qlge_open(struct net_device *ndev)
 
 static int ql_change_rx_buffers(struct ql_adapter *qdev)
 {
-	struct rx_ring *rx_ring;
-	int i, status;
-	u32 lbq_buf_len;
+	int status;
 
 	/* Wait for an outstanding reset to complete. */
 	if (!test_bit(QL_ADAPTER_UP, &qdev->flags)) {
@@ -4197,16 +4197,7 @@ static int ql_change_rx_buffers(struct ql_adapter *qdev)
 	if (status)
 		goto error;
 
-	/* Get the new rx buffer size. */
-	lbq_buf_len = (qdev->ndev->mtu > 1500) ?
-		LARGE_BUFFER_MAX_SIZE : LARGE_BUFFER_MIN_SIZE;
-	qdev->lbq_buf_order = get_order(lbq_buf_len);
-
-	for (i = 0; i < qdev->rss_ring_count; i++) {
-		rx_ring = &qdev->rx_ring[i];
-		/* Set the new size. */
-		rx_ring->lbq_buf_size = lbq_buf_len;
-	}
+	qlge_set_lb_size(qdev);
 
 	status = ql_adapter_up(qdev);
 	if (status)
-- 
2.23.0

