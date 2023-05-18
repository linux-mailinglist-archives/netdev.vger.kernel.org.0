Return-Path: <netdev+bounces-3509-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7A027079E0
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:51:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2376E1C21039
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 05:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1C95138E;
	Thu, 18 May 2023 05:51:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D7C137D
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 05:51:47 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C671FE49;
	Wed, 17 May 2023 22:51:45 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HMFhCh013340;
	Wed, 17 May 2023 22:51:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=h5TMO00ETrLOVoBuYc6APgA6+967xXROx72pRVl/BCw=;
 b=ft+wGllask5CelhJOQnES51gHxWPsB6OCtrUohTiNU68utqWlix96I08NBmWnF3p/65m
 syyR3IE/TYKjhZSPxbUR/MiKKYAVLFRssDmygaXTUzOHoZVJsCaNlJ6Eko0w1dX53LaS
 NMS+t/BjEnokG/O0eMwsnUgcS6vGCqJrGKK1MG4P5c9Ts0BMg3lae/w56KZ0IFEzW2MR
 M/yklt6LA5NOu9UQ9P9RKZHbKml6ncZPmTS9JENjWworfXpZc/ywovauQJJCEvjxMoWa
 UhvvspINp91EN1XxRdPSxwymvK2+smMjWT80IYsVa7OsPpoqEhMSNHLLs2vHe7MgLFLl cg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qn7jb9a0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Wed, 17 May 2023 22:51:39 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 17 May
 2023 22:51:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 17 May 2023 22:51:37 -0700
Received: from localhost.localdomain (unknown [10.28.36.165])
	by maili.marvell.com (Postfix) with ESMTP id 74C793F7062;
	Wed, 17 May 2023 22:51:34 -0700 (PDT)
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <sgoutham@marvell.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sbhatta@marvell.com>,
        <gakula@marvell.com>, <schalla@marvell.com>, <hkelam@marvell.com>,
        "Ratheesh
 Kannoth" <rkannoth@marvell.com>
Subject: [PATCH net-next v2] octeontx2-pf: Add support for page pool
Date: Thu, 18 May 2023 11:21:29 +0530
Message-ID: <20230518055129.3129897-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Kwynbs7gz7UZrJDaItNOCnhPctI0n_Uj
X-Proofpoint-ORIG-GUID: Kwynbs7gz7UZrJDaItNOCnhPctI0n_Uj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_03,2023-05-17_02,2023-02-09_01
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

Image        |  Performance with Linux kernel Packet Generator
------------ | -----------------------------------------------
Vannila      |   3Mpps
             |
with this    |   42Mpps
change	     |
-------------------------------------------------------------

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---

ChangeLog
v1 -> v2:
 * Removed GFP_DMA flag
 * Returned correct err value

v0 -> v1:
 * Removed CONFIG_PAGE_POOL #ifdefs in code
 * Used compound page APIs
 * Replaced page_pool_put_page API with page_pool_put_full_page API
---
 .../net/ethernet/marvell/octeontx2/Kconfig    |  1 +
 .../marvell/octeontx2/nic/otx2_common.c       | 75 ++++++++++++++++---
 .../marvell/octeontx2/nic/otx2_common.h       |  6 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 11 ++-
 .../marvell/octeontx2/nic/otx2_txrx.c         | 19 +++--
 .../marvell/octeontx2/nic/otx2_txrx.h         |  1 +
 .../ethernet/marvell/octeontx2/nic/qos_sq.c   |  2 +-
 7 files changed, 93 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
index 993ac180a5db..a32d85d6f599 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -32,6 +32,7 @@ config OCTEONTX2_PF
 	tristate "Marvell OcteonTX2 NIC Physical Function driver"
 	select OCTEONTX2_MBOX
 	select NET_DEVLINK
+	select PAGE_POOL
 	depends on (64BIT && COMPILE_TEST) || ARM64
 	select DIMLIB
 	depends on PCI
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index f9286648e45c..60476fd413e7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -518,11 +518,32 @@ void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
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
+	page = page_pool_alloc_frag(pool->page_pool, &offset, sz, GFP_ATOMIC);
+	if (unlikely(!page))
+		return -ENOMEM;
+
+	*dma = page_pool_get_dma_addr(page) + offset;
+	return 0;
+}
+
 static int __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 			     dma_addr_t *dma)
 {
 	u8 *buf;
 
+	if (pool->page_pool)
+		return otx2_alloc_pool_buf(pfvf, pool, dma);
+
 	buf = napi_alloc_frag_align(pool->rbsize, OTX2_ALIGN);
 	if (unlikely(!buf))
 		return -ENOMEM;
@@ -1205,10 +1226,28 @@ void otx2_sq_free_sqbs(struct otx2_nic *pfvf)
 	}
 }
 
+void otx2_free_bufs(struct otx2_nic *pfvf, struct otx2_pool *pool,
+		    u64 iova, int size)
+{
+	u64 pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
+	struct page *page = virt_to_head_page(phys_to_virt(pa));
+
+	if (pool->page_pool) {
+		page_pool_put_full_page(pool->page_pool, page, true);
+	} else {
+		dma_unmap_page_attrs(pfvf->dev, iova, size,
+				     DMA_FROM_DEVICE,
+				     DMA_ATTR_SKIP_CPU_SYNC);
+
+		put_page(page);
+	}
+}
+
 void otx2_free_aura_ptr(struct otx2_nic *pfvf, int type)
 {
 	int pool_id, pool_start = 0, pool_end = 0, size = 0;
-	u64 iova, pa;
+	struct otx2_pool *pool;
+	u64 iova;
 
 	if (type == AURA_NIX_SQ) {
 		pool_start = otx2_get_pool_idx(pfvf, type, 0);
@@ -1224,15 +1263,13 @@ void otx2_free_aura_ptr(struct otx2_nic *pfvf, int type)
 	/* Free SQB and RQB pointers from the aura pool */
 	for (pool_id = pool_start; pool_id < pool_end; pool_id++) {
 		iova = otx2_aura_allocptr(pfvf, pool_id);
+		pool = &pfvf->qset.pool[pool_id];
 		while (iova) {
 			if (type == AURA_NIX_RQ)
 				iova -= OTX2_HEAD_ROOM;
 
-			pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
-			dma_unmap_page_attrs(pfvf->dev, iova, size,
-					     DMA_FROM_DEVICE,
-					     DMA_ATTR_SKIP_CPU_SYNC);
-			put_page(virt_to_page(phys_to_virt(pa)));
+			otx2_free_bufs(pfvf, pool, iova, size);
+
 			iova = otx2_aura_allocptr(pfvf, pool_id);
 		}
 	}
@@ -1250,6 +1287,8 @@ void otx2_aura_pool_free(struct otx2_nic *pfvf)
 		pool = &pfvf->qset.pool[pool_id];
 		qmem_free(pfvf->dev, pool->stack);
 		qmem_free(pfvf->dev, pool->fc_addr);
+		page_pool_destroy(pool->page_pool);
+		pool->page_pool = NULL;
 	}
 	devm_kfree(pfvf->dev, pfvf->qset.pool);
 	pfvf->qset.pool = NULL;
@@ -1333,8 +1372,9 @@ int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 }
 
 int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
-		   int stack_pages, int numptrs, int buf_size)
+		   int stack_pages, int numptrs, int buf_size, int type)
 {
+	struct page_pool_params pp_params = { 0 };
 	struct npa_aq_enq_req *aq;
 	struct otx2_pool *pool;
 	int err;
@@ -1378,6 +1418,22 @@ int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
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
+	if (IS_ERR(pool->page_pool)) {
+		netdev_err(pfvf->netdev, "Creation of page pool failed\n");
+		return PTR_ERR(pool->page_pool);
+	}
+
 	return 0;
 }
 
@@ -1412,7 +1468,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 
 		/* Initialize pool context */
 		err = otx2_pool_init(pfvf, pool_id, stack_pages,
-				     num_sqbs, hw->sqb_size);
+				     num_sqbs, hw->sqb_size, AURA_NIX_SQ);
 		if (err)
 			goto fail;
 	}
@@ -1475,7 +1531,7 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 	}
 	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
 		err = otx2_pool_init(pfvf, pool_id, stack_pages,
-				     num_ptrs, pfvf->rbsize);
+				     num_ptrs, pfvf->rbsize, AURA_NIX_RQ);
 		if (err)
 			goto fail;
 	}
@@ -1659,7 +1715,6 @@ int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable)
 	req->bpid_per_chan = 0;
 #endif
 
-
 	return otx2_sync_mbox_msg(&pfvf->mbox);
 }
 EXPORT_SYMBOL(otx2_nix_config_bp);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index b2267c8bec37..a9ed15d1793a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -976,7 +976,7 @@ int otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 int otx2_rxtx_enable(struct otx2_nic *pfvf, bool enable);
 void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
 int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable);
-void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
+void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq, int qidx);
 void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura);
 int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
@@ -984,7 +984,7 @@ int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
 int otx2_alloc_buffer(struct otx2_nic *pfvf, struct otx2_cq_queue *cq,
 		      dma_addr_t *dma);
 int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
-		   int stack_pages, int numptrs, int buf_size);
+		   int stack_pages, int numptrs, int buf_size, int type);
 int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 		   int pool_id, int numptrs);
 
@@ -1054,6 +1054,8 @@ u16 otx2_get_max_mtu(struct otx2_nic *pfvf);
 int otx2_handle_ntuple_tc_features(struct net_device *netdev,
 				   netdev_features_t features);
 int otx2_smq_flush(struct otx2_nic *pfvf, int smq);
+void otx2_free_bufs(struct otx2_nic *pfvf, struct otx2_pool *pool,
+		    u64 iova, int size);
 
 /* tc support */
 int otx2_init_tc(struct otx2_nic *nic);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index e1883c3edda3..db3fcab1c8cd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1555,7 +1555,9 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	struct nix_lf_free_req *free_req;
 	struct mbox *mbox = &pf->mbox;
 	struct otx2_cq_queue *cq;
+	struct otx2_pool *pool;
 	struct msg_req *req;
+	int pool_id;
 	int qidx;
 
 	/* Ensure all SQE are processed */
@@ -1584,7 +1586,7 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	for (qidx = 0; qidx < qset->cq_cnt; qidx++) {
 		cq = &qset->cq[qidx];
 		if (cq->cq_type == CQ_RX)
-			otx2_cleanup_rx_cqes(pf, cq);
+			otx2_cleanup_rx_cqes(pf, cq, qidx);
 		else
 			otx2_cleanup_tx_cqes(pf, cq);
 	}
@@ -1594,6 +1596,13 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
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
index e288f46b23a8..37d4e4b73816 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -217,9 +217,6 @@ static bool otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
 				va - page_address(page) + off,
 				len - off, pfvf->rbsize);
-
-		otx2_dma_unmap_page(pfvf, iova - OTX2_HEAD_ROOM,
-				    pfvf->rbsize, DMA_FROM_DEVICE);
 		return true;
 	}
 
@@ -382,6 +379,8 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
 	if (pfvf->netdev->features & NETIF_F_RXCSUM)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
+	skb_mark_for_recycle(skb);
+
 	napi_gro_frags(napi);
 }
 
@@ -1186,11 +1185,13 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 }
 EXPORT_SYMBOL(otx2_sq_append_skb);
 
-void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
+void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq, int qidx)
 {
 	struct nix_cqe_rx_s *cqe;
 	int processed_cqe = 0;
-	u64 iova, pa;
+	struct otx2_pool *pool;
+	u16 pool_id;
+	u64 iova;
 
 	if (pfvf->xdp_prog)
 		xdp_rxq_info_unreg(&cq->xdp_rxq);
@@ -1198,6 +1199,9 @@ void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
 		return;
 
+	pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_RQ, qidx);
+	pool = &pfvf->qset.pool[pool_id];
+
 	while (cq->pend_cqe) {
 		cqe = (struct nix_cqe_rx_s *)otx2_get_next_cqe(cq);
 		processed_cqe++;
@@ -1210,9 +1214,8 @@ void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 			continue;
 		}
 		iova = cqe->sg.seg_addr - OTX2_HEAD_ROOM;
-		pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
-		otx2_dma_unmap_page(pfvf, iova, pfvf->rbsize, DMA_FROM_DEVICE);
-		put_page(virt_to_page(phys_to_virt(pa)));
+
+		otx2_free_bufs(pfvf, pool, iova, pfvf->rbsize);
 	}
 
 	/* Free CQEs to HW */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 7ab6db9a986f..b5d689eeff80 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -118,6 +118,7 @@ struct otx2_cq_poll {
 struct otx2_pool {
 	struct qmem		*stack;
 	struct qmem		*fc_addr;
+	struct page_pool	*page_pool;
 	u16			rbsize;
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
index d96ed29c1567..9d887bfc3108 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
@@ -63,7 +63,7 @@ static int otx2_qos_sq_aura_pool_init(struct otx2_nic *pfvf, int qidx)
 
 	/* Initialize pool context */
 	err = otx2_pool_init(pfvf, pool_id, stack_pages,
-			     num_sqbs, hw->sqb_size);
+			     num_sqbs, hw->sqb_size, AURA_NIX_SQ);
 	if (err)
 		goto aura_free;
 
-- 
2.25.1


