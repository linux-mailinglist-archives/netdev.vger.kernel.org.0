Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C294306AEC
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhA1CKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:10:15 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:33564 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229494AbhA1CKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 21:10:11 -0500
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 27 Jan 2021 18:08:14 -0800
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.3])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id BEBC820726;
        Wed, 27 Jan 2021 18:08:17 -0800 (PST)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id B8908A9FBB; Wed, 27 Jan 2021 18:08:17 -0800 (PST)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>, Petr Vandrovec <petr@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 net-next] From: Petr Vandrovec <petr@vmware.com>
Date:   Wed, 27 Jan 2021 18:08:16 -0800
Message-ID: <20210128020816.31318-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

buf_info structures in RX & TX queues are private driver data that
do not need to be visible to the device.  Although there is physical
address and length in the queue descriptor that points to these
structures, their layout is not standardized, and device never looks
at them.

So lets allocate these structures in non-DMA-able memory, and fill
physical address as all-ones and length as zero in the queue
descriptor.

That should alleviate worries brought by Martin Radev in
https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210104/022829.html
that malicious vmxnet3 device could subvert SVM/TDX guarantees.

Signed-off-by: Petr Vandrovec <petr@vmware.com>
Signed-off-by: Ronak Doshi <doshir@vmware.com>
---
Changes in v2:
 - Use kcalloc_node()
 - Remove log for memory allocation failure
Changes in v3:
 - Do not pass __GFP_ZERO to kcalloc
Changes in v4:
 - Modified description to not have subject line
Changes in v5:
 - Remove unnecessary ifs
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 46 +++++++++++++--------------------------
 drivers/net/vmxnet3/vmxnet3_int.h |  2 --
 2 files changed, 15 insertions(+), 33 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 336504b7531d..6e87f1fc4874 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -451,12 +451,8 @@ vmxnet3_tq_destroy(struct vmxnet3_tx_queue *tq,
 				  tq->comp_ring.base, tq->comp_ring.basePA);
 		tq->comp_ring.base = NULL;
 	}
-	if (tq->buf_info) {
-		dma_free_coherent(&adapter->pdev->dev,
-				  tq->tx_ring.size * sizeof(tq->buf_info[0]),
-				  tq->buf_info, tq->buf_info_pa);
-		tq->buf_info = NULL;
-	}
+	kfree(tq->buf_info);
+	tq->buf_info = NULL;
 }
 
 
@@ -505,8 +501,6 @@ static int
 vmxnet3_tq_create(struct vmxnet3_tx_queue *tq,
 		  struct vmxnet3_adapter *adapter)
 {
-	size_t sz;
-
 	BUG_ON(tq->tx_ring.base || tq->data_ring.base ||
 	       tq->comp_ring.base || tq->buf_info);
 
@@ -534,9 +528,9 @@ vmxnet3_tq_create(struct vmxnet3_tx_queue *tq,
 		goto err;
 	}
 
-	sz = tq->tx_ring.size * sizeof(tq->buf_info[0]);
-	tq->buf_info = dma_alloc_coherent(&adapter->pdev->dev, sz,
-					  &tq->buf_info_pa, GFP_KERNEL);
+	tq->buf_info = kcalloc_node(tq->tx_ring.size, sizeof(tq->buf_info[0]),
+				    GFP_KERNEL,
+				    dev_to_node(&adapter->pdev->dev));
 	if (!tq->buf_info)
 		goto err;
 
@@ -1737,13 +1731,9 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
 		rq->comp_ring.base = NULL;
 	}
 
-	if (rq->buf_info[0]) {
-		size_t sz = sizeof(struct vmxnet3_rx_buf_info) *
-			(rq->rx_ring[0].size + rq->rx_ring[1].size);
-		dma_free_coherent(&adapter->pdev->dev, sz, rq->buf_info[0],
-				  rq->buf_info_pa);
-		rq->buf_info[0] = rq->buf_info[1] = NULL;
-	}
+	kfree(rq->buf_info[0]);
+	rq->buf_info[0] = NULL;
+	rq->buf_info[1] = NULL;
 }
 
 static void
@@ -1883,10 +1873,9 @@ vmxnet3_rq_create(struct vmxnet3_rx_queue *rq, struct vmxnet3_adapter *adapter)
 		goto err;
 	}
 
-	sz = sizeof(struct vmxnet3_rx_buf_info) * (rq->rx_ring[0].size +
-						   rq->rx_ring[1].size);
-	bi = dma_alloc_coherent(&adapter->pdev->dev, sz, &rq->buf_info_pa,
-				GFP_KERNEL);
+	bi = kcalloc_node(rq->rx_ring[0].size + rq->rx_ring[1].size,
+			  sizeof(rq->buf_info[0][0]), GFP_KERNEL,
+			  dev_to_node(&adapter->pdev->dev));
 	if (!bi)
 		goto err;
 
@@ -2522,14 +2511,12 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 		tqc->txRingBasePA   = cpu_to_le64(tq->tx_ring.basePA);
 		tqc->dataRingBasePA = cpu_to_le64(tq->data_ring.basePA);
 		tqc->compRingBasePA = cpu_to_le64(tq->comp_ring.basePA);
-		tqc->ddPA           = cpu_to_le64(tq->buf_info_pa);
+		tqc->ddPA           = cpu_to_le64(~0ULL);
 		tqc->txRingSize     = cpu_to_le32(tq->tx_ring.size);
 		tqc->dataRingSize   = cpu_to_le32(tq->data_ring.size);
 		tqc->txDataRingDescSize = cpu_to_le32(tq->txdata_desc_size);
 		tqc->compRingSize   = cpu_to_le32(tq->comp_ring.size);
-		tqc->ddLen          = cpu_to_le32(
-					sizeof(struct vmxnet3_tx_buf_info) *
-					tqc->txRingSize);
+		tqc->ddLen          = cpu_to_le32(0);
 		tqc->intrIdx        = tq->comp_ring.intr_idx;
 	}
 
@@ -2541,14 +2528,11 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 		rqc->rxRingBasePA[0] = cpu_to_le64(rq->rx_ring[0].basePA);
 		rqc->rxRingBasePA[1] = cpu_to_le64(rq->rx_ring[1].basePA);
 		rqc->compRingBasePA  = cpu_to_le64(rq->comp_ring.basePA);
-		rqc->ddPA            = cpu_to_le64(rq->buf_info_pa);
+		rqc->ddPA            = cpu_to_le64(~0ULL);
 		rqc->rxRingSize[0]   = cpu_to_le32(rq->rx_ring[0].size);
 		rqc->rxRingSize[1]   = cpu_to_le32(rq->rx_ring[1].size);
 		rqc->compRingSize    = cpu_to_le32(rq->comp_ring.size);
-		rqc->ddLen           = cpu_to_le32(
-					sizeof(struct vmxnet3_rx_buf_info) *
-					(rqc->rxRingSize[0] +
-					 rqc->rxRingSize[1]));
+		rqc->ddLen           = cpu_to_le32(0);
 		rqc->intrIdx         = rq->comp_ring.intr_idx;
 		if (VMXNET3_VERSION_GE_3(adapter)) {
 			rqc->rxDataRingBasePA =
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index d958b92c9429..e910596b79cf 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -240,7 +240,6 @@ struct vmxnet3_tx_queue {
 	spinlock_t                      tx_lock;
 	struct vmxnet3_cmd_ring         tx_ring;
 	struct vmxnet3_tx_buf_info      *buf_info;
-	dma_addr_t                       buf_info_pa;
 	struct vmxnet3_tx_data_ring     data_ring;
 	struct vmxnet3_comp_ring        comp_ring;
 	struct Vmxnet3_TxQueueCtrl      *shared;
@@ -298,7 +297,6 @@ struct vmxnet3_rx_queue {
 	u32 qid2;           /* rqID in RCD for buffer from 2nd ring */
 	u32 dataRingQid;    /* rqID in RCD for buffer from data ring */
 	struct vmxnet3_rx_buf_info     *buf_info[2];
-	dma_addr_t                      buf_info_pa;
 	struct Vmxnet3_RxQueueCtrl            *shared;
 	struct vmxnet3_rq_driver_stats  stats;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
-- 
2.11.0

