Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CBD229C1D
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733087AbgGVPzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:55:47 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26662 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733070AbgGVPzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:55:45 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MFso83009312;
        Wed, 22 Jul 2020 08:55:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=69PsfN4p0vTKepSjvuzGYGgge8QqiBqlxd2EbWivBVU=;
 b=XL0kyENQ/ojPYk6EB7dFwyBaXh98q12fbOckXbNQUdrfFI4dlTL4KvUeazAu9X2yxHsc
 9MhzDAcjUzGjnWOKG8WgHygkCzo3W2akMVrQx0dvG0zJhESKKMSC7s2m2MqApQtA/YEB
 eoegZHxCJvAZs/E7HAKqUqQM0Sd2iFVbEEBYKGTfaIA/T3qKvhUp30E/2Fh6wtYfabv+
 VNNlAlmkNTwPbNzMl04dE1/OFehuuWSKoTLlO9tXarIdVJB9olYC8AsPoeSBLMawb8lX
 LhkuJP2QOHAr/cMLfPDw2B4B4ogYUI9WIaTrk1VZRj+TR+CncR8glD76VjbR0cyTdLu7 Gw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkrkp3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 08:55:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 08:55:27 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 08:55:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 08:55:26 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 0AE153F703F;
        Wed, 22 Jul 2020 08:55:20 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Doug Ledford" <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 09/15] qed: add support for different page sizes for chains
Date:   Wed, 22 Jul 2020 18:53:43 +0300
Message-ID: <20200722155349.747-10-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200722155349.747-1-alobakin@marvell.com>
References: <20200722155349.747-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_09:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend current infrastructure to store chain page size in a struct
and use it in all functions instead of fixed QED_CHAIN_PAGE_SIZE.
Its value remains the default one, but can be overridden in
qed_chain_init_params before chain allocation.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/verbs.c          |  2 ++
 drivers/net/ethernet/qlogic/qed/qed_chain.c | 28 +++++++++++++--------
 include/linux/qed/qed_chain.h               | 21 ++++++++++------
 3 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 6737895a0d68..49b8a43e3fa2 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1960,9 +1960,11 @@ qedr_iwarp_create_kernel_qp(struct qedr_dev *dev,
 
 	in_params->sq_num_pages = QED_CHAIN_PAGE_CNT(n_sq_elems,
 						     QEDR_SQE_ELEMENT_SIZE,
+						     QED_CHAIN_PAGE_SIZE,
 						     QED_CHAIN_MODE_PBL);
 	in_params->rq_num_pages = QED_CHAIN_PAGE_CNT(n_rq_elems,
 						     QEDR_RQE_ELEMENT_SIZE,
+						     QED_CHAIN_PAGE_SIZE,
 						     QED_CHAIN_MODE_PBL);
 
 	qp->qed_qp = dev->ops->rdma_create_qp(dev->rdma_ctx,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_chain.c b/drivers/net/ethernet/qlogic/qed/qed_chain.c
index 6e8dc6cefa5d..ce13ee8af4f8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_chain.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_chain.c
@@ -16,8 +16,10 @@ static void qed_chain_init(struct qed_chain *chain,
 	chain->mode = params->mode;
 	chain->cnt_type = params->cnt_type;
 
-	chain->elem_per_page = ELEMS_PER_PAGE(params->elem_size);
+	chain->elem_per_page = ELEMS_PER_PAGE(params->elem_size,
+					      params->page_size);
 	chain->usable_per_page = USABLE_ELEMS_PER_PAGE(params->elem_size,
+						       params->page_size,
 						       params->mode);
 	chain->elem_unusable = UNUSABLE_ELEMS_PER_PAGE(params->elem_size,
 						       params->mode);
@@ -26,6 +28,7 @@ static void qed_chain_init(struct qed_chain *chain,
 	chain->next_page_mask = chain->usable_per_page &
 				chain->elem_per_page_mask;
 
+	chain->page_size = params->page_size;
 	chain->page_cnt = page_cnt;
 	chain->capacity = chain->usable_per_page * page_cnt;
 	chain->size = chain->elem_per_page * page_cnt;
@@ -80,7 +83,7 @@ static void qed_chain_free_next_ptr(struct qed_dev *cdev,
 		virt_next = next->next_virt;
 		phys_next = HILO_DMA_REGPAIR(next->next_phys);
 
-		dma_free_coherent(dev, QED_CHAIN_PAGE_SIZE, virt, phys);
+		dma_free_coherent(dev, chain->page_size, virt, phys);
 
 		virt = virt_next;
 		phys = phys_next;
@@ -93,7 +96,7 @@ static void qed_chain_free_single(struct qed_dev *cdev,
 	if (!chain->p_virt_addr)
 		return;
 
-	dma_free_coherent(&cdev->pdev->dev, QED_CHAIN_PAGE_SIZE,
+	dma_free_coherent(&cdev->pdev->dev, chain->page_size,
 			  chain->p_virt_addr, chain->p_phys_addr);
 }
 
@@ -111,7 +114,7 @@ static void qed_chain_free_pbl(struct qed_dev *cdev, struct qed_chain *chain)
 		if (!entry->virt_addr)
 			break;
 
-		dma_free_coherent(dev, QED_CHAIN_PAGE_SIZE, entry->virt_addr,
+		dma_free_coherent(dev, chain->page_size, entry->virt_addr,
 				  entry->dma_map);
 	}
 
@@ -156,7 +159,7 @@ qed_chain_alloc_sanity_check(struct qed_dev *cdev,
 {
 	u64 chain_size;
 
-	chain_size = ELEMS_PER_PAGE(params->elem_size);
+	chain_size = ELEMS_PER_PAGE(params->elem_size, params->page_size);
 	chain_size *= page_cnt;
 
 	if (!chain_size)
@@ -199,7 +202,7 @@ static int qed_chain_alloc_next_ptr(struct qed_dev *cdev,
 	u32 i;
 
 	for (i = 0; i < chain->page_cnt; i++) {
-		virt = dma_alloc_coherent(dev, QED_CHAIN_PAGE_SIZE, &phys,
+		virt = dma_alloc_coherent(dev, chain->page_size, &phys,
 					  GFP_KERNEL);
 		if (!virt)
 			return -ENOMEM;
@@ -230,7 +233,7 @@ static int qed_chain_alloc_single(struct qed_dev *cdev,
 	dma_addr_t phys;
 	void *virt;
 
-	virt = dma_alloc_coherent(&cdev->pdev->dev, QED_CHAIN_PAGE_SIZE,
+	virt = dma_alloc_coherent(&cdev->pdev->dev, chain->page_size,
 				  &phys, GFP_KERNEL);
 	if (!virt)
 		return -ENOMEM;
@@ -280,7 +283,7 @@ static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain)
 
 alloc_pages:
 	for (i = 0; i < page_cnt; i++) {
-		virt = dma_alloc_coherent(dev, QED_CHAIN_PAGE_SIZE, &phys,
+		virt = dma_alloc_coherent(dev, chain->page_size, &phys,
 					  GFP_KERNEL);
 		if (!virt)
 			return -ENOMEM;
@@ -316,11 +319,15 @@ int qed_chain_alloc(struct qed_dev *cdev, struct qed_chain *chain,
 	u32 page_cnt;
 	int rc;
 
+	if (!params->page_size)
+		params->page_size = QED_CHAIN_PAGE_SIZE;
+
 	if (params->mode == QED_CHAIN_MODE_SINGLE)
 		page_cnt = 1;
 	else
 		page_cnt = QED_CHAIN_PAGE_CNT(params->num_elems,
 					      params->elem_size,
+					      params->page_size,
 					      params->mode);
 
 	rc = qed_chain_alloc_sanity_check(cdev, params, page_cnt);
@@ -328,9 +335,10 @@ int qed_chain_alloc(struct qed_dev *cdev, struct qed_chain *chain,
 		DP_NOTICE(cdev,
 			  "Cannot allocate a chain with the given arguments:\n");
 		DP_NOTICE(cdev,
-			  "[use_mode %d, mode %d, cnt_type %d, num_elems %d, elem_size %zu]\n",
+			  "[use_mode %d, mode %d, cnt_type %d, num_elems %d, elem_size %zu, page_size %u]\n",
 			  params->intended_use, params->mode, params->cnt_type,
-			  params->num_elems, params->elem_size);
+			  params->num_elems, params->elem_size,
+			  params->page_size);
 		return rc;
 	}
 
diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index f5cfee0934e5..8a96c361cc19 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -11,6 +11,7 @@
 #include <asm/byteorder.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/qed/common_hsi.h>
 
@@ -120,6 +121,8 @@ struct qed_chain {
 	 * but isn't involved in regular functionality.
 	 */
 
+	u32						page_size;
+
 	/* Base address of a pre-allocated buffer for pbl */
 	struct {
 		__le64					*table_virt;
@@ -147,6 +150,7 @@ struct qed_chain_init_params {
 	enum qed_chain_use_mode				intended_use;
 	enum qed_chain_cnt_type				cnt_type;
 
+	u32						page_size;
 	u32						num_elems;
 	size_t						elem_size;
 
@@ -154,22 +158,23 @@ struct qed_chain_init_params {
 	dma_addr_t					ext_pbl_phys;
 };
 
-#define QED_CHAIN_PAGE_SIZE				0x1000
+#define QED_CHAIN_PAGE_SIZE				SZ_4K
 
-#define ELEMS_PER_PAGE(elem_size)					     \
-	(QED_CHAIN_PAGE_SIZE / (elem_size))
+#define ELEMS_PER_PAGE(elem_size, page_size)				     \
+	((page_size) / (elem_size))
 
 #define UNUSABLE_ELEMS_PER_PAGE(elem_size, mode)			     \
 	(((mode) == QED_CHAIN_MODE_NEXT_PTR) ?				     \
 	 (u8)(1 + ((sizeof(struct qed_chain_next) - 1) / (elem_size))) :     \
 	 0)
 
-#define USABLE_ELEMS_PER_PAGE(elem_size, mode)				     \
-	((u32)(ELEMS_PER_PAGE(elem_size) -				     \
+#define USABLE_ELEMS_PER_PAGE(elem_size, page_size, mode)		     \
+	((u32)(ELEMS_PER_PAGE((elem_size), (page_size)) -		     \
 	       UNUSABLE_ELEMS_PER_PAGE((elem_size), (mode))))
 
-#define QED_CHAIN_PAGE_CNT(elem_cnt, elem_size, mode)			     \
-	DIV_ROUND_UP((elem_cnt), USABLE_ELEMS_PER_PAGE((elem_size), (mode)))
+#define QED_CHAIN_PAGE_CNT(elem_cnt, elem_size, page_size, mode)	     \
+	DIV_ROUND_UP((elem_cnt),					     \
+		     USABLE_ELEMS_PER_PAGE((elem_size), (page_size), (mode)))
 
 #define is_chain_u16(p)							     \
 	((p)->cnt_type == QED_CHAIN_CNT_TYPE_U16)
@@ -604,7 +609,7 @@ static inline void qed_chain_pbl_zero_mem(struct qed_chain *p_chain)
 
 	for (i = 0; i < page_cnt; i++)
 		memset(p_chain->pbl.pp_addr_tbl[i].virt_addr, 0,
-		       QED_CHAIN_PAGE_SIZE);
+		       p_chain->page_size);
 }
 
 #endif
-- 
2.25.1

