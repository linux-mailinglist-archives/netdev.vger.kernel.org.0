Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E0147B9D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 09:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfFQHuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 03:50:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:40084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726121AbfFQHuB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 03:50:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 849E5AFE3;
        Mon, 17 Jun 2019 07:49:59 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next 05/16] qlge: Remove rx_ring.sbq_buf_size
Date:   Mon, 17 Jun 2019 16:48:47 +0900
Message-Id: <20190617074858.32467-5-bpoirier@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617074858.32467-1-bpoirier@suse.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tx rings have sbq_buf_size = 0 but there's no case where the code actually
tests on that value. We can remove sbq_buf_size and use a constant instead.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/net/ethernet/qlogic/qlge/qlge.h      |  1 -
 drivers/net/ethernet/qlogic/qlge/qlge_dbg.c  |  1 -
 drivers/net/ethernet/qlogic/qlge/qlge_main.c | 24 ++++++++------------
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h b/drivers/net/ethernet/qlogic/qlge/qlge.h
index f32da8c7679f..a3a52bbc2821 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge.h
+++ b/drivers/net/ethernet/qlogic/qlge/qlge.h
@@ -1447,7 +1447,6 @@ struct rx_ring {
 	/* Small buffer queue elements. */
 	u32 sbq_len;		/* entry count */
 	u32 sbq_size;		/* size in bytes of queue */
-	u32 sbq_buf_size;
 	void *sbq_base;
 	dma_addr_t sbq_base_dma;
 	void *sbq_base_indirect;
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c b/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
index 46599d74c6fb..cff1603d121c 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_dbg.c
@@ -1792,7 +1792,6 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	pr_err("rx_ring->sbq_curr_idx = %d\n", rx_ring->sbq_curr_idx);
 	pr_err("rx_ring->sbq_clean_idx = %d\n", rx_ring->sbq_clean_idx);
 	pr_err("rx_ring->sbq_free_cnt = %d\n", rx_ring->sbq_free_cnt);
-	pr_err("rx_ring->sbq_buf_size = %d\n", rx_ring->sbq_buf_size);
 	pr_err("rx_ring->cq_id = %d\n", rx_ring->cq_id);
 	pr_err("rx_ring->irq = %d\n", rx_ring->irq);
 	pr_err("rx_ring->cpu = %d\n", rx_ring->cpu);
diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
index 25dbaa9cc55d..6b932bb6ce8f 100644
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
+++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -1164,7 +1164,7 @@ static void ql_update_sbq(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 				skb_reserve(sbq_desc->p.skb, QLGE_SB_PAD);
 				map = pci_map_single(qdev->pdev,
 						     sbq_desc->p.skb->data,
-						     rx_ring->sbq_buf_size,
+						     SMALL_BUF_MAP_SIZE,
 						     PCI_DMA_FROMDEVICE);
 				if (pci_dma_mapping_error(qdev->pdev, map)) {
 					netif_err(qdev, ifup, qdev->ndev,
@@ -1594,14 +1594,13 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 
 	pci_dma_sync_single_for_cpu(qdev->pdev,
 				    dma_unmap_addr(sbq_desc, mapaddr),
-				    rx_ring->sbq_buf_size,
-				    PCI_DMA_FROMDEVICE);
+				    SMALL_BUF_MAP_SIZE, PCI_DMA_FROMDEVICE);
 
 	skb_put_data(new_skb, skb->data, length);
 
 	pci_dma_sync_single_for_device(qdev->pdev,
 				       dma_unmap_addr(sbq_desc, mapaddr),
-				       rx_ring->sbq_buf_size,
+				       SMALL_BUF_MAP_SIZE,
 				       PCI_DMA_FROMDEVICE);
 	skb = new_skb;
 
@@ -1723,7 +1722,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 		sbq_desc = ql_get_curr_sbuf(rx_ring);
 		pci_unmap_single(qdev->pdev,
 				dma_unmap_addr(sbq_desc, mapaddr),
-				rx_ring->sbq_buf_size, PCI_DMA_FROMDEVICE);
+				SMALL_BUF_MAP_SIZE, PCI_DMA_FROMDEVICE);
 		skb = sbq_desc->p.skb;
 		ql_realign_skb(skb, hdr_len);
 		skb_put(skb, hdr_len);
@@ -1755,13 +1754,13 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 			pci_dma_sync_single_for_cpu(qdev->pdev,
 						    dma_unmap_addr(sbq_desc,
 								   mapaddr),
-						    rx_ring->sbq_buf_size,
+						    SMALL_BUF_MAP_SIZE,
 						    PCI_DMA_FROMDEVICE);
 			skb_put_data(skb, sbq_desc->p.skb->data, length);
 			pci_dma_sync_single_for_device(qdev->pdev,
 						       dma_unmap_addr(sbq_desc,
 								      mapaddr),
-						       rx_ring->sbq_buf_size,
+						       SMALL_BUF_MAP_SIZE,
 						       PCI_DMA_FROMDEVICE);
 		} else {
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
@@ -1773,7 +1772,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 			skb_put(skb, length);
 			pci_unmap_single(qdev->pdev,
 					 dma_unmap_addr(sbq_desc, mapaddr),
-					 rx_ring->sbq_buf_size,
+					 SMALL_BUF_MAP_SIZE,
 					 PCI_DMA_FROMDEVICE);
 			sbq_desc->p.skb = NULL;
 		}
@@ -1846,7 +1845,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 		sbq_desc = ql_get_curr_sbuf(rx_ring);
 		pci_unmap_single(qdev->pdev,
 				 dma_unmap_addr(sbq_desc, mapaddr),
-				 rx_ring->sbq_buf_size, PCI_DMA_FROMDEVICE);
+				 SMALL_BUF_MAP_SIZE, PCI_DMA_FROMDEVICE);
 		if (!(ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS)) {
 			/*
 			 * This is an non TCP/UDP IP frame, so
@@ -2807,7 +2806,7 @@ static void ql_free_sbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring
 		if (sbq_desc->p.skb) {
 			pci_unmap_single(qdev->pdev,
 					 dma_unmap_addr(sbq_desc, mapaddr),
-					 rx_ring->sbq_buf_size,
+					 SMALL_BUF_MAP_SIZE,
 					 PCI_DMA_FROMDEVICE);
 			dev_kfree_skb(sbq_desc->p.skb);
 			sbq_desc->p.skb = NULL;
@@ -3158,8 +3157,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 		} while (page_entries < MAX_DB_PAGES_PER_BQ(rx_ring->sbq_len));
 		cqicb->sbq_addr =
 		    cpu_to_le64(rx_ring->sbq_base_indirect_dma);
-		cqicb->sbq_buf_size =
-		    cpu_to_le16((u16)(rx_ring->sbq_buf_size));
+		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUF_MAP_SIZE);
 		bq_len = (rx_ring->sbq_len == 65536) ? 0 :
 			(u16) rx_ring->sbq_len;
 		cqicb->sbq_len = cpu_to_le16(bq_len);
@@ -4098,7 +4096,6 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 			rx_ring->sbq_len = NUM_SMALL_BUFFERS;
 			rx_ring->sbq_size =
 			    rx_ring->sbq_len * sizeof(__le64);
-			rx_ring->sbq_buf_size = SMALL_BUF_MAP_SIZE;
 			rx_ring->type = RX_Q;
 		} else {
 			/*
@@ -4112,7 +4109,6 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 			rx_ring->lbq_size = 0;
 			rx_ring->sbq_len = 0;
 			rx_ring->sbq_size = 0;
-			rx_ring->sbq_buf_size = 0;
 			rx_ring->type = TX_Q;
 		}
 	}
-- 
2.21.0

