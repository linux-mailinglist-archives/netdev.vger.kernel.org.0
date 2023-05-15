Return-Path: <netdev+bounces-2495-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1FAA7023F1
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D2AE1C20A53
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 690E01FDF;
	Mon, 15 May 2023 05:57:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566454400
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:57:26 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F704219;
	Sun, 14 May 2023 22:57:00 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34F3tV38004523;
	Sun, 14 May 2023 22:56:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=jKlPPYbha90VeWdRnIRvwBf7Nr9nZa+M0EjhzVx1DLs=;
 b=Ocd2qpgxI91FZM5/NlSFdg3+fKKB4sOzbcr3CpewDgjpYV7JylDb7uj5rM3fDNwD34Iw
 RpxZU2i2DtaAsE5wvi7x9Qr8sK8xWfJ1iTLixgQV+URmNw3i7IlYcAbETslpDGenCuV8
 73EyywvtNdibzqMSdwB0nB4UYitJTI/7Orjguv3ovQxk+iKRPciKjVAUgUrGIlklHqTc
 XDg0z7PMzhm9PuCQE1yLvUhYoLmpRSWFBUpKnxcM3G3VzZnfYb6zfCLq9WyvDvuVfgoo
 Z0V5p3hlOHJVT0SeHtzJMNJebv4g4SJA/JoZrv0R+TOqXF2qNxZK2tpRtWH1hFIO6CxI 4w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3qja2jm6ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Sun, 14 May 2023 22:56:18 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 14 May
 2023 22:56:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 14 May 2023 22:56:15 -0700
Received: from localhost.localdomain (unknown [10.28.36.165])
	by maili.marvell.com (Postfix) with ESMTP id 85C533F705B;
	Sun, 14 May 2023 22:56:13 -0700 (PDT)
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <sgoutham@marvell.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth
	<rkannoth@marvell.com>
Subject: [PATCH net-next] octeontx2-pf: Add support for page pool
Date: Mon, 15 May 2023 11:26:07 +0530
Message-ID: <20230515055607.651799-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: FXa9QLBJ2AJ5m8sPvSLccJrdW83IUM88
X-Proofpoint-ORIG-GUID: FXa9QLBJ2AJ5m8sPvSLccJrdW83IUM88
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-15_03,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Page pool for each rx queue enhance rx side performance
by reclaiming buffers back to each queue specific pool. DMA
mapping is done only for first allocation of buffers.
As subsequent buffers allocation avoid DMA mapping,
it results in performance improvement.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../marvell/octeontx2/nic/otx2_common.c       | 72 +++++++++++++++++--
 .../marvell/octeontx2/nic/otx2_common.h       |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 11 ++-
 .../marvell/octeontx2/nic/otx2_txrx.c         | 23 ++++--
 .../marvell/octeontx2/nic/otx2_txrx.h         |  1 +
 5 files changed, 96 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 8a41ad8ca04f..561b00ed8846 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -513,11 +513,38 @@ void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
 		     (pfvf->hw.cq_ecount_wait - 1));
 }
 
+static int otx2_alloc_pool_buf(struct otx2_nic *pfvf, struct otx2_pool *pool,
+			       dma_addr_t *dma)
+{
+	unsigned int offset = 0;
+	struct page *page;
+	size_t sz;
+
+	sz = SKB_DATA_ALIGN(pool->rbsize);
+	sz = ALIGN(sz, OTX2_ALIGN);
+
+	page = page_pool_alloc_frag(pool->page_pool, &offset, sz,
+				    (in_interrupt() ? GFP_ATOMIC : GFP_KERNEL) |
+				    GFP_DMA);
+	if (unlikely(!page)) {
+		netdev_err(pfvf->netdev, "Allocation of page pool failed\n");
+		return -ENOMEM;
+	}
+
+	*dma = page_pool_get_dma_addr(page) + offset;
+	return 0;
+}
+
 int __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 		      dma_addr_t *dma)
 {
 	u8 *buf;
 
+#ifdef CONFIG_PAGE_POOL
+	if (pool->page_pool)
+		return otx2_alloc_pool_buf(pfvf, pool, dma);
+#endif
+
 	buf = napi_alloc_frag_align(pool->rbsize, OTX2_ALIGN);
 	if (unlikely(!buf))
 		return -ENOMEM;
@@ -1154,6 +1181,8 @@ void otx2_sq_free_sqbs(struct otx2_nic *pfvf)
 void otx2_free_aura_ptr(struct otx2_nic *pfvf, int type)
 {
 	int pool_id, pool_start = 0, pool_end = 0, size = 0;
+	struct otx2_pool *pool;
+	struct page *page;
 	u64 iova, pa;
 
 	if (type == AURA_NIX_SQ) {
@@ -1170,15 +1199,24 @@ void otx2_free_aura_ptr(struct otx2_nic *pfvf, int type)
 	/* Free SQB and RQB pointers from the aura pool */
 	for (pool_id = pool_start; pool_id < pool_end; pool_id++) {
 		iova = otx2_aura_allocptr(pfvf, pool_id);
+		pool = &pfvf->qset.pool[pool_id];
 		while (iova) {
 			if (type == AURA_NIX_RQ)
 				iova -= OTX2_HEAD_ROOM;
 
 			pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
-			dma_unmap_page_attrs(pfvf->dev, iova, size,
-					     DMA_FROM_DEVICE,
-					     DMA_ATTR_SKIP_CPU_SYNC);
-			put_page(virt_to_page(phys_to_virt(pa)));
+			page = virt_to_page(phys_to_virt(pa));
+
+			if (pool->page_pool) {
+				page_pool_put_page(pool->page_pool, page, size, true);
+			} else {
+				dma_unmap_page_attrs(pfvf->dev, iova, size,
+						     DMA_FROM_DEVICE,
+						     DMA_ATTR_SKIP_CPU_SYNC);
+
+				put_page(page);
+			}
+
 			iova = otx2_aura_allocptr(pfvf, pool_id);
 		}
 	}
@@ -1196,6 +1234,8 @@ void otx2_aura_pool_free(struct otx2_nic *pfvf)
 		pool = &pfvf->qset.pool[pool_id];
 		qmem_free(pfvf->dev, pool->stack);
 		qmem_free(pfvf->dev, pool->fc_addr);
+		page_pool_destroy(pool->page_pool);
+		pool->page_pool = NULL;
 	}
 	devm_kfree(pfvf->dev, pfvf->qset.pool);
 	pfvf->qset.pool = NULL;
@@ -1279,8 +1319,10 @@ static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 }
 
 static int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
-			  int stack_pages, int numptrs, int buf_size)
+			  int stack_pages, int numptrs, int buf_size,
+			  int type)
 {
+	struct page_pool_params pp_params = { 0 };
 	struct npa_aq_enq_req *aq;
 	struct otx2_pool *pool;
 	int err;
@@ -1324,6 +1366,22 @@ static int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
 	aq->ctype = NPA_AQ_CTYPE_POOL;
 	aq->op = NPA_AQ_INSTOP_INIT;
 
+	if (type != AURA_NIX_RQ) {
+		pool->page_pool = NULL;
+		return 0;
+	}
+
+	pp_params.flags = PP_FLAG_PAGE_FRAG | PP_FLAG_DMA_MAP;
+	pp_params.pool_size = numptrs;
+	pp_params.nid = NUMA_NO_NODE;
+	pp_params.dev = pfvf->dev;
+	pp_params.dma_dir = DMA_FROM_DEVICE;
+	pool->page_pool = page_pool_create(&pp_params);
+	if (!pool->page_pool) {
+		netdev_err(pfvf->netdev, "Creation of page pool failed\n");
+		return -EFAULT;
+	}
+
 	return 0;
 }
 
@@ -1358,7 +1416,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 
 		/* Initialize pool context */
 		err = otx2_pool_init(pfvf, pool_id, stack_pages,
-				     num_sqbs, hw->sqb_size);
+				     num_sqbs, hw->sqb_size, AURA_NIX_SQ);
 		if (err)
 			goto fail;
 	}
@@ -1421,7 +1479,7 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 	}
 	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
 		err = otx2_pool_init(pfvf, pool_id, stack_pages,
-				     num_ptrs, pfvf->rbsize);
+				     num_ptrs, pfvf->rbsize, AURA_NIX_RQ);
 		if (err)
 			goto fail;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 3d22cc6a2804..7ed7c9426dc3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -927,7 +927,7 @@ int __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 int otx2_rxtx_enable(struct otx2_nic *pfvf, bool enable);
 void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
 int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable);
-void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
+void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq, int qidx);
 void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
 int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 179433d0a54a..3071928ff6bf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1551,8 +1551,10 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	struct nix_lf_free_req *free_req;
 	struct mbox *mbox = &pf->mbox;
 	struct otx2_cq_queue *cq;
+	struct otx2_pool *pool;
 	struct msg_req *req;
 	int qidx, err;
+	int pool_id;
 
 	/* Ensure all SQE are processed */
 	otx2_sqb_flush(pf);
@@ -1580,7 +1582,7 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	for (qidx = 0; qidx < qset->cq_cnt; qidx++) {
 		cq = &qset->cq[qidx];
 		if (cq->cq_type == CQ_RX)
-			otx2_cleanup_rx_cqes(pf, cq);
+			otx2_cleanup_rx_cqes(pf, cq, qidx);
 		else
 			otx2_cleanup_tx_cqes(pf, cq);
 	}
@@ -1590,6 +1592,13 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	/* Free RQ buffer pointers*/
 	otx2_free_aura_ptr(pf, AURA_NIX_RQ);
 
+	for (qidx = 0; qidx < pf->hw.rx_queues; qidx++) {
+		pool_id = otx2_get_pool_idx(pf, AURA_NIX_RQ, qidx);
+		pool = &pf->qset.pool[pool_id];
+		page_pool_destroy(pool->page_pool);
+		pool->page_pool = NULL;
+	}
+
 	otx2_free_cq_res(pf);
 
 	/* Free all ingress bandwidth profiles allocated */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 7045fedfd73a..df5f45aa6980 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -217,9 +217,10 @@ static bool otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
 				va - page_address(page) + off,
 				len - off, pfvf->rbsize);
-
+#ifndef CONFIG_PAGE_POOL
 		otx2_dma_unmap_page(pfvf, iova - OTX2_HEAD_ROOM,
 				    pfvf->rbsize, DMA_FROM_DEVICE);
+#endif
 		return true;
 	}
 
@@ -382,6 +383,8 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	if (pfvf->netdev->features & NETIF_F_RXCSUM)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
+	skb_mark_for_recycle(skb);
+
 	napi_gro_frags(napi);
 }
 
@@ -1180,11 +1183,14 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 }
 EXPORT_SYMBOL(otx2_sq_append_skb);
 
-void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
+void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq, int qidx)
 {
 	struct nix_cqe_rx_s *cqe;
 	int processed_cqe = 0;
+	struct otx2_pool *pool;
+	struct page *page;
 	u64 iova, pa;
+	u16 pool_id;
 
 	if (pfvf->xdp_prog)
 		xdp_rxq_info_unreg(&cq->xdp_rxq);
@@ -1192,6 +1198,9 @@ void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
 		return;
 
+	pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_RQ, qidx);
+	pool = &pfvf->qset.pool[pool_id];
+
 	while (cq->pend_cqe) {
 		cqe = (struct nix_cqe_rx_s *)otx2_get_next_cqe(cq);
 		processed_cqe++;
@@ -1205,8 +1214,14 @@ void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 		}
 		iova = cqe->sg.seg_addr - OTX2_HEAD_ROOM;
 		pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
-		otx2_dma_unmap_page(pfvf, iova, pfvf->rbsize, DMA_FROM_DEVICE);
-		put_page(virt_to_page(phys_to_virt(pa)));
+		page = virt_to_page(phys_to_virt(pa));
+
+		if (pool->page_pool) {
+			page_pool_put_page(pool->page_pool, page, pfvf->rbsize, true);
+		} else {
+			otx2_dma_unmap_page(pfvf, iova, pfvf->rbsize, DMA_FROM_DEVICE);
+			put_page(page);
+		}
 	}
 
 	/* Free CQEs to HW */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 93cac2c2664c..176472ece656 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -117,6 +117,7 @@ struct otx2_cq_poll {
 struct otx2_pool {
 	struct qmem		*stack;
 	struct qmem		*fc_addr;
+	struct page_pool	*page_pool;
 	u16			rbsize;
 };
 
-- 
2.25.1


