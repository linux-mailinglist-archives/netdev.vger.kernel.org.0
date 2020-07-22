Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FAD22A21F
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387539AbgGVWNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:13:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10958 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733139AbgGVWMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:12:25 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MM6fej019797;
        Wed, 22 Jul 2020 15:12:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=a0EnwJpf0ran+8HT6cV44IEXjlCvfbNa2spUiSU7yFo=;
 b=TKGDLSJbOCjuQya1xz6Th0kGqj8EijAGlD/CenPlcp4vgqwifyl8Qn+k0GsxXlPiUCVf
 MSaRIMvUdm+G3ZehMsjKAH6asjUaUG6OQQOkXFwxGqIeT45zX72WqAfHPiMXFlz8kgAp
 Ejs0o4qmgGq+Anz+Ch/xvkOr6dTgMoVWYZLtLYRSk+AXhwl7zWz1t3+BhC/INTAQRkbJ
 iK1GJ3CzyMl0zoDrPhUwDnavdd5IK5Qa5whBho5FZMkvBOpdXC0bQyrBPY7JQZTShvm/
 6srnkXccv2FGKrG+dRO66A0rgyE2gtGUIvEtOXZvS4C9qlY3NrHuwEmxnJ0n9lu1x6cb oQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkt0n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 15:12:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 15:12:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 15:12:00 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id D54323F703F;
        Wed, 22 Jul 2020 15:11:53 -0700 (PDT)
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
Subject: [PATCH v2 net-next 08/15] qed: simplify chain allocation with init params struct
Date:   Thu, 23 Jul 2020 01:10:38 +0300
Message-ID: <20200722221045.5436-9-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200722221045.5436-1-alobakin@marvell.com>
References: <20200722221045.5436-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_16:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To simplify qed_chain_alloc() prototype and call sites, introduce struct
qed_chain_init_params to specify chain params, and pass a pointer to
filled struct to the actual qed_chain_alloc() instead of a long list
of separate arguments.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/main.c             | 20 ++--
 drivers/infiniband/hw/qedr/verbs.c            | 95 +++++++++----------
 drivers/net/ethernet/qlogic/qed/qed_chain.c   | 80 +++++++++-------
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h | 32 +------
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c   | 39 ++++----
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     | 44 +++++----
 drivers/net/ethernet/qlogic/qed/qed_spq.c     | 90 +++++++++++-------
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 45 ++++-----
 include/linux/qed/qed_chain.h                 | 21 ++--
 include/linux/qed/qed_if.h                    |  9 +-
 10 files changed, 242 insertions(+), 233 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index ccaedfd53e49..b1de8d608e4d 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -346,9 +346,14 @@ static void qedr_free_resources(struct qedr_dev *dev)
 
 static int qedr_alloc_resources(struct qedr_dev *dev)
 {
+	struct qed_chain_init_params params = {
+		.mode		= QED_CHAIN_MODE_PBL,
+		.intended_use	= QED_CHAIN_USE_TO_CONSUME,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U16,
+		.elem_size	= sizeof(struct regpair *),
+	};
 	struct qedr_cnq *cnq;
 	__le16 *cons_pi;
-	u16 n_entries;
 	int i, rc;
 
 	dev->sgid_tbl = kcalloc(QEDR_MAX_SGID, sizeof(union ib_gid),
@@ -382,7 +387,9 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 	dev->sb_start = dev->ops->rdma_get_start_sb(dev->cdev);
 
 	/* Allocate CNQ PBLs */
-	n_entries = min_t(u32, QED_RDMA_MAX_CNQ_SIZE, QEDR_ROCE_MAX_CNQ_SIZE);
+	params.num_elems = min_t(u32, QED_RDMA_MAX_CNQ_SIZE,
+				 QEDR_ROCE_MAX_CNQ_SIZE);
+
 	for (i = 0; i < dev->num_cnq; i++) {
 		cnq = &dev->cnq_array[i];
 
@@ -391,13 +398,8 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 		if (rc)
 			goto err3;
 
-		rc = dev->ops->common->chain_alloc(dev->cdev,
-						   QED_CHAIN_USE_TO_CONSUME,
-						   QED_CHAIN_MODE_PBL,
-						   QED_CHAIN_CNT_TYPE_U16,
-						   n_entries,
-						   sizeof(struct regpair *),
-						   &cnq->pbl, NULL);
+		rc = dev->ops->common->chain_alloc(dev->cdev, &cnq->pbl,
+						   &params);
 		if (rc)
 			goto err4;
 
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 9b9e80266367..6737895a0d68 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -891,6 +891,12 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		udata, struct qedr_ucontext, ibucontext);
 	struct qed_rdma_destroy_cq_out_params destroy_oparams;
 	struct qed_rdma_destroy_cq_in_params destroy_iparams;
+	struct qed_chain_init_params chain_params = {
+		.mode		= QED_CHAIN_MODE_PBL,
+		.intended_use	= QED_CHAIN_USE_TO_CONSUME,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U32,
+		.elem_size	= sizeof(union rdma_cqe),
+	};
 	struct qedr_dev *dev = get_qedr_dev(ibdev);
 	struct qed_rdma_create_cq_in_params params;
 	struct qedr_create_cq_ureq ureq = {};
@@ -917,6 +923,7 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 
 	chain_entries = qedr_align_cq_entries(entries);
 	chain_entries = min_t(int, chain_entries, QEDR_MAX_CQES);
+	chain_params.num_elems = chain_entries;
 
 	/* calc db offset. user will add DPI base, kernel will add db addr */
 	db_offset = DB_ADDR_SHIFT(DQ_PWM_OFFSET_UCM_RDMA_CQ_CONS_32BIT);
@@ -951,13 +958,8 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	} else {
 		cq->cq_type = QEDR_CQ_TYPE_KERNEL;
 
-		rc = dev->ops->common->chain_alloc(dev->cdev,
-						   QED_CHAIN_USE_TO_CONSUME,
-						   QED_CHAIN_MODE_PBL,
-						   QED_CHAIN_CNT_TYPE_U32,
-						   chain_entries,
-						   sizeof(union rdma_cqe),
-						   &cq->pbl, NULL);
+		rc = dev->ops->common->chain_alloc(dev->cdev, &cq->pbl,
+						   &chain_params);
 		if (rc)
 			goto err0;
 
@@ -1446,6 +1448,12 @@ static int qedr_alloc_srq_kernel_params(struct qedr_srq *srq,
 					struct ib_srq_init_attr *init_attr)
 {
 	struct qedr_srq_hwq_info *hw_srq = &srq->hw_srq;
+	struct qed_chain_init_params params = {
+		.mode		= QED_CHAIN_MODE_PBL,
+		.intended_use	= QED_CHAIN_USE_TO_CONSUME_PRODUCE,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U32,
+		.elem_size	= QEDR_SRQ_WQE_ELEM_SIZE,
+	};
 	dma_addr_t phy_prod_pair_addr;
 	u32 num_elems;
 	void *va;
@@ -1464,13 +1472,9 @@ static int qedr_alloc_srq_kernel_params(struct qedr_srq *srq,
 	hw_srq->virt_prod_pair_addr = va;
 
 	num_elems = init_attr->attr.max_wr * RDMA_MAX_SRQ_WQE_SIZE;
-	rc = dev->ops->common->chain_alloc(dev->cdev,
-					   QED_CHAIN_USE_TO_CONSUME_PRODUCE,
-					   QED_CHAIN_MODE_PBL,
-					   QED_CHAIN_CNT_TYPE_U32,
-					   num_elems,
-					   QEDR_SRQ_WQE_ELEM_SIZE,
-					   &hw_srq->pbl, NULL);
+	params.num_elems = num_elems;
+
+	rc = dev->ops->common->chain_alloc(dev->cdev, &hw_srq->pbl, &params);
 	if (rc)
 		goto err0;
 
@@ -1901,29 +1905,28 @@ qedr_roce_create_kernel_qp(struct qedr_dev *dev,
 			   u32 n_sq_elems, u32 n_rq_elems)
 {
 	struct qed_rdma_create_qp_out_params out_params;
+	struct qed_chain_init_params params = {
+		.mode		= QED_CHAIN_MODE_PBL,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U32,
+	};
 	int rc;
 
-	rc = dev->ops->common->chain_alloc(dev->cdev,
-					   QED_CHAIN_USE_TO_PRODUCE,
-					   QED_CHAIN_MODE_PBL,
-					   QED_CHAIN_CNT_TYPE_U32,
-					   n_sq_elems,
-					   QEDR_SQE_ELEMENT_SIZE,
-					   &qp->sq.pbl, NULL);
+	params.intended_use = QED_CHAIN_USE_TO_PRODUCE;
+	params.num_elems = n_sq_elems;
+	params.elem_size = QEDR_SQE_ELEMENT_SIZE;
 
+	rc = dev->ops->common->chain_alloc(dev->cdev, &qp->sq.pbl, &params);
 	if (rc)
 		return rc;
 
 	in_params->sq_num_pages = qed_chain_get_page_cnt(&qp->sq.pbl);
 	in_params->sq_pbl_ptr = qed_chain_get_pbl_phys(&qp->sq.pbl);
 
-	rc = dev->ops->common->chain_alloc(dev->cdev,
-					   QED_CHAIN_USE_TO_CONSUME_PRODUCE,
-					   QED_CHAIN_MODE_PBL,
-					   QED_CHAIN_CNT_TYPE_U32,
-					   n_rq_elems,
-					   QEDR_RQE_ELEMENT_SIZE,
-					   &qp->rq.pbl, NULL);
+	params.intended_use = QED_CHAIN_USE_TO_CONSUME_PRODUCE;
+	params.elem_size = n_rq_elems;
+	params.elem_size = QEDR_RQE_ELEMENT_SIZE;
+
+	rc = dev->ops->common->chain_alloc(dev->cdev, &qp->rq.pbl, &params);
 	if (rc)
 		return rc;
 
@@ -1949,7 +1952,10 @@ qedr_iwarp_create_kernel_qp(struct qedr_dev *dev,
 			    u32 n_sq_elems, u32 n_rq_elems)
 {
 	struct qed_rdma_create_qp_out_params out_params;
-	struct qed_chain_ext_pbl ext_pbl;
+	struct qed_chain_init_params params = {
+		.mode		= QED_CHAIN_MODE_PBL,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U32,
+	};
 	int rc;
 
 	in_params->sq_num_pages = QED_CHAIN_PAGE_CNT(n_sq_elems,
@@ -1966,31 +1972,24 @@ qedr_iwarp_create_kernel_qp(struct qedr_dev *dev,
 		return -EINVAL;
 
 	/* Now we allocate the chain */
-	ext_pbl.p_pbl_virt = out_params.sq_pbl_virt;
-	ext_pbl.p_pbl_phys = out_params.sq_pbl_phys;
 
-	rc = dev->ops->common->chain_alloc(dev->cdev,
-					   QED_CHAIN_USE_TO_PRODUCE,
-					   QED_CHAIN_MODE_PBL,
-					   QED_CHAIN_CNT_TYPE_U32,
-					   n_sq_elems,
-					   QEDR_SQE_ELEMENT_SIZE,
-					   &qp->sq.pbl, &ext_pbl);
+	params.intended_use = QED_CHAIN_USE_TO_PRODUCE;
+	params.num_elems = n_sq_elems;
+	params.elem_size = QEDR_SQE_ELEMENT_SIZE;
+	params.ext_pbl_virt = out_params.sq_pbl_virt;
+	params.ext_pbl_phys = out_params.sq_pbl_phys;
 
+	rc = dev->ops->common->chain_alloc(dev->cdev, &qp->sq.pbl, &params);
 	if (rc)
 		goto err;
 
-	ext_pbl.p_pbl_virt = out_params.rq_pbl_virt;
-	ext_pbl.p_pbl_phys = out_params.rq_pbl_phys;
-
-	rc = dev->ops->common->chain_alloc(dev->cdev,
-					   QED_CHAIN_USE_TO_CONSUME_PRODUCE,
-					   QED_CHAIN_MODE_PBL,
-					   QED_CHAIN_CNT_TYPE_U32,
-					   n_rq_elems,
-					   QEDR_RQE_ELEMENT_SIZE,
-					   &qp->rq.pbl, &ext_pbl);
+	params.intended_use = QED_CHAIN_USE_TO_CONSUME_PRODUCE;
+	params.num_elems = n_rq_elems;
+	params.elem_size = QEDR_RQE_ELEMENT_SIZE;
+	params.ext_pbl_virt = out_params.rq_pbl_virt;
+	params.ext_pbl_phys = out_params.rq_pbl_phys;
 
+	rc = dev->ops->common->chain_alloc(dev->cdev, &qp->rq.pbl, &params);
 	if (rc)
 		goto err;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_chain.c b/drivers/net/ethernet/qlogic/qed/qed_chain.c
index 6effee3b50f4..a68ee4b3dbbc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_chain.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_chain.c
@@ -7,23 +7,22 @@
 
 #include "qed_dev_api.h"
 
-static void qed_chain_init_params(struct qed_chain *chain,
-				  u32 page_cnt, u8 elem_size,
-				  enum qed_chain_use_mode intended_use,
-				  enum qed_chain_mode mode,
-				  enum qed_chain_cnt_type cnt_type,
-				  const struct qed_chain_ext_pbl *ext_pbl)
+static void qed_chain_init(struct qed_chain *chain,
+			   const struct qed_chain_init_params *params,
+			   u32 page_cnt)
 {
 	memset(chain, 0, sizeof(*chain));
 
-	chain->elem_size = elem_size;
-	chain->intended_use = intended_use;
-	chain->mode = mode;
-	chain->cnt_type = cnt_type;
+	chain->elem_size = params->elem_size;
+	chain->intended_use = params->intended_use;
+	chain->mode = params->mode;
+	chain->cnt_type = params->cnt_type;
 
-	chain->elem_per_page = ELEMS_PER_PAGE(elem_size);
-	chain->usable_per_page = USABLE_ELEMS_PER_PAGE(elem_size, mode);
-	chain->elem_unusable = UNUSABLE_ELEMS_PER_PAGE(elem_size, mode);
+	chain->elem_per_page = ELEMS_PER_PAGE(params->elem_size);
+	chain->usable_per_page = USABLE_ELEMS_PER_PAGE(params->elem_size,
+						       params->mode);
+	chain->elem_unusable = UNUSABLE_ELEMS_PER_PAGE(params->elem_size,
+						       params->mode);
 
 	chain->elem_per_page_mask = chain->elem_per_page - 1;
 	chain->next_page_mask = chain->usable_per_page &
@@ -33,9 +32,9 @@ static void qed_chain_init_params(struct qed_chain *chain,
 	chain->capacity = chain->usable_per_page * page_cnt;
 	chain->size = chain->elem_per_page * page_cnt;
 
-	if (ext_pbl && ext_pbl->p_pbl_virt) {
-		chain->pbl_sp.table_virt = ext_pbl->p_pbl_virt;
-		chain->pbl_sp.table_phys = ext_pbl->p_pbl_phys;
+	if (params->ext_pbl_virt) {
+		chain->pbl_sp.table_virt = params->ext_pbl_virt;
+		chain->pbl_sp.table_phys = params->ext_pbl_phys;
 
 		chain->b_external_pbl = true;
 	}
@@ -154,10 +153,16 @@ void qed_chain_free(struct qed_dev *cdev, struct qed_chain *chain)
 
 static int
 qed_chain_alloc_sanity_check(struct qed_dev *cdev,
-			     enum qed_chain_cnt_type cnt_type,
-			     size_t elem_size, u32 page_cnt)
+			     const struct qed_chain_init_params *params,
+			     u32 page_cnt)
 {
-	u64 chain_size = ELEMS_PER_PAGE(elem_size) * page_cnt;
+	u64 chain_size;
+
+	chain_size = ELEMS_PER_PAGE(params->elem_size);
+	chain_size *= page_cnt;
+
+	if (!chain_size)
+		return -EINVAL;
 
 	/* The actual chain size can be larger than the maximal possible value
 	 * after rounding up the requested elements number to pages, and after
@@ -165,7 +170,7 @@ qed_chain_alloc_sanity_check(struct qed_dev *cdev,
 	 * The size of a "u16" chain can be (U16_MAX + 1) since the chain
 	 * size/capacity fields are of u32 type.
 	 */
-	switch (cnt_type) {
+	switch (params->cnt_type) {
 	case QED_CHAIN_CNT_TYPE_U16:
 		if (chain_size > U16_MAX + 1)
 			break;
@@ -298,37 +303,42 @@ static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain)
 	return 0;
 }
 
-int qed_chain_alloc(struct qed_dev *cdev,
-		    enum qed_chain_use_mode intended_use,
-		    enum qed_chain_mode mode,
-		    enum qed_chain_cnt_type cnt_type,
-		    u32 num_elems,
-		    size_t elem_size,
-		    struct qed_chain *chain,
-		    struct qed_chain_ext_pbl *ext_pbl)
+/**
+ * qed_chain_alloc() - Allocate and initialize a chain.
+ *
+ * @cdev: Main device structure.
+ * @chain: Chain to be processed.
+ * @params: Chain initialization parameters.
+ *
+ * Return: 0 on success, negative errno otherwise.
+ */
+int qed_chain_alloc(struct qed_dev *cdev, struct qed_chain *chain,
+		    struct qed_chain_init_params *params)
 {
 	u32 page_cnt;
 	int rc;
 
-	if (mode == QED_CHAIN_MODE_SINGLE)
+	if (params->mode == QED_CHAIN_MODE_SINGLE)
 		page_cnt = 1;
 	else
-		page_cnt = QED_CHAIN_PAGE_CNT(num_elems, elem_size, mode);
+		page_cnt = QED_CHAIN_PAGE_CNT(params->num_elems,
+					      params->elem_size,
+					      params->mode);
 
-	rc = qed_chain_alloc_sanity_check(cdev, cnt_type, elem_size, page_cnt);
+	rc = qed_chain_alloc_sanity_check(cdev, params, page_cnt);
 	if (rc) {
 		DP_NOTICE(cdev,
 			  "Cannot allocate a chain with the given arguments:\n");
 		DP_NOTICE(cdev,
 			  "[use_mode %d, mode %d, cnt_type %d, num_elems %d, elem_size %zu]\n",
-			  intended_use, mode, cnt_type, num_elems, elem_size);
+			  params->intended_use, params->mode, params->cnt_type,
+			  params->num_elems, params->elem_size);
 		return rc;
 	}
 
-	qed_chain_init_params(chain, page_cnt, elem_size, intended_use, mode,
-			      cnt_type, ext_pbl);
+	qed_chain_init(chain, params, page_cnt);
 
-	switch (mode) {
+	switch (params->mode) {
 	case QED_CHAIN_MODE_NEXT_PTR:
 		rc = qed_chain_alloc_next_ptr(cdev, chain);
 		break;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
index 395d4932c262..d3c1f3879be8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
@@ -254,35 +254,9 @@ int qed_dmae_host2host(struct qed_hwfn *p_hwfn,
 		       dma_addr_t dest_addr,
 		       u32 size_in_dwords, struct qed_dmae_params *p_params);
 
-/**
- * @brief qed_chain_alloc - Allocate and initialize a chain
- *
- * @param p_hwfn
- * @param intended_use
- * @param mode
- * @param num_elems
- * @param elem_size
- * @param p_chain
- * @param ext_pbl - a possible external PBL
- *
- * @return int
- */
-int
-qed_chain_alloc(struct qed_dev *cdev,
-		enum qed_chain_use_mode intended_use,
-		enum qed_chain_mode mode,
-		enum qed_chain_cnt_type cnt_type,
-		u32 num_elems,
-		size_t elem_size,
-		struct qed_chain *p_chain, struct qed_chain_ext_pbl *ext_pbl);
-
-/**
- * @brief qed_chain_free - Free chain DMA memory
- *
- * @param p_hwfn
- * @param p_chain
- */
-void qed_chain_free(struct qed_dev *cdev, struct qed_chain *p_chain);
+int qed_chain_alloc(struct qed_dev *cdev, struct qed_chain *chain,
+		    struct qed_chain_init_params *params);
+void qed_chain_free(struct qed_dev *cdev, struct qed_chain *chain);
 
 /**
  * @@brief qed_fw_l2_queue - Get absolute L2 queue ID
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
index 25d2c882d7ac..4eae4ee3538f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
@@ -684,9 +684,13 @@ static int qed_iscsi_setup_connection(struct qed_iscsi_conn *p_conn)
 static int qed_iscsi_allocate_connection(struct qed_hwfn *p_hwfn,
 					 struct qed_iscsi_conn **p_out_conn)
 {
-	u16 uhq_num_elements = 0, xhq_num_elements = 0, r2tq_num_elements = 0;
 	struct scsi_terminate_extra_params *p_q_cnts = NULL;
 	struct qed_iscsi_pf_params *p_params = NULL;
+	struct qed_chain_init_params params = {
+		.mode		= QED_CHAIN_MODE_PBL,
+		.intended_use	= QED_CHAIN_USE_TO_CONSUME_PRODUCE,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U16,
+	};
 	struct tcp_upload_params *p_tcp = NULL;
 	struct qed_iscsi_conn *p_conn = NULL;
 	int rc = 0;
@@ -727,34 +731,25 @@ static int qed_iscsi_allocate_connection(struct qed_hwfn *p_hwfn,
 		goto nomem_upload_param;
 	p_conn->tcp_upload_params_virt_addr = p_tcp;
 
-	r2tq_num_elements = p_params->num_r2tq_pages_in_ring *
-			    QED_CHAIN_PAGE_SIZE / 0x80;
-	rc = qed_chain_alloc(p_hwfn->cdev,
-			     QED_CHAIN_USE_TO_CONSUME_PRODUCE,
-			     QED_CHAIN_MODE_PBL,
-			     QED_CHAIN_CNT_TYPE_U16,
-			     r2tq_num_elements, 0x80, &p_conn->r2tq, NULL);
+	params.num_elems = p_params->num_r2tq_pages_in_ring *
+			   QED_CHAIN_PAGE_SIZE / sizeof(struct iscsi_wqe);
+	params.elem_size = sizeof(struct iscsi_wqe);
+
+	rc = qed_chain_alloc(p_hwfn->cdev, &p_conn->r2tq, &params);
 	if (rc)
 		goto nomem_r2tq;
 
-	uhq_num_elements = p_params->num_uhq_pages_in_ring *
+	params.num_elems = p_params->num_uhq_pages_in_ring *
 			   QED_CHAIN_PAGE_SIZE / sizeof(struct iscsi_uhqe);
-	rc = qed_chain_alloc(p_hwfn->cdev,
-			     QED_CHAIN_USE_TO_CONSUME_PRODUCE,
-			     QED_CHAIN_MODE_PBL,
-			     QED_CHAIN_CNT_TYPE_U16,
-			     uhq_num_elements,
-			     sizeof(struct iscsi_uhqe), &p_conn->uhq, NULL);
+	params.elem_size = sizeof(struct iscsi_uhqe);
+
+	rc = qed_chain_alloc(p_hwfn->cdev, &p_conn->uhq, &params);
 	if (rc)
 		goto nomem_uhq;
 
-	xhq_num_elements = uhq_num_elements;
-	rc = qed_chain_alloc(p_hwfn->cdev,
-			     QED_CHAIN_USE_TO_CONSUME_PRODUCE,
-			     QED_CHAIN_MODE_PBL,
-			     QED_CHAIN_CNT_TYPE_U16,
-			     xhq_num_elements,
-			     sizeof(struct iscsi_xhqe), &p_conn->xhq, NULL);
+	params.elem_size = sizeof(struct iscsi_xhqe);
+
+	rc = qed_chain_alloc(p_hwfn->cdev, &p_conn->xhq, &params);
 	if (rc)
 		goto nomem;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 6f4aec339cd4..0452b728c527 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -1125,6 +1125,12 @@ static int
 qed_ll2_acquire_connection_rx(struct qed_hwfn *p_hwfn,
 			      struct qed_ll2_info *p_ll2_info)
 {
+	struct qed_chain_init_params params = {
+		.intended_use	= QED_CHAIN_USE_TO_CONSUME_PRODUCE,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U16,
+		.num_elems	= p_ll2_info->input.rx_num_desc,
+	};
+	struct qed_dev *cdev = p_hwfn->cdev;
 	struct qed_ll2_rx_packet *p_descq;
 	u32 capacity;
 	int rc = 0;
@@ -1132,13 +1138,10 @@ qed_ll2_acquire_connection_rx(struct qed_hwfn *p_hwfn,
 	if (!p_ll2_info->input.rx_num_desc)
 		goto out;
 
-	rc = qed_chain_alloc(p_hwfn->cdev,
-			     QED_CHAIN_USE_TO_CONSUME_PRODUCE,
-			     QED_CHAIN_MODE_NEXT_PTR,
-			     QED_CHAIN_CNT_TYPE_U16,
-			     p_ll2_info->input.rx_num_desc,
-			     sizeof(struct core_rx_bd),
-			     &p_ll2_info->rx_queue.rxq_chain, NULL);
+	params.mode = QED_CHAIN_MODE_NEXT_PTR;
+	params.elem_size = sizeof(struct core_rx_bd);
+
+	rc = qed_chain_alloc(cdev, &p_ll2_info->rx_queue.rxq_chain, &params);
 	if (rc) {
 		DP_NOTICE(p_hwfn, "Failed to allocate ll2 rxq chain\n");
 		goto out;
@@ -1154,13 +1157,10 @@ qed_ll2_acquire_connection_rx(struct qed_hwfn *p_hwfn,
 	}
 	p_ll2_info->rx_queue.descq_array = p_descq;
 
-	rc = qed_chain_alloc(p_hwfn->cdev,
-			     QED_CHAIN_USE_TO_CONSUME_PRODUCE,
-			     QED_CHAIN_MODE_PBL,
-			     QED_CHAIN_CNT_TYPE_U16,
-			     p_ll2_info->input.rx_num_desc,
-			     sizeof(struct core_rx_fast_path_cqe),
-			     &p_ll2_info->rx_queue.rcq_chain, NULL);
+	params.mode = QED_CHAIN_MODE_PBL;
+	params.elem_size = sizeof(struct core_rx_fast_path_cqe);
+
+	rc = qed_chain_alloc(cdev, &p_ll2_info->rx_queue.rcq_chain, &params);
 	if (rc) {
 		DP_NOTICE(p_hwfn, "Failed to allocate ll2 rcq chain\n");
 		goto out;
@@ -1177,6 +1177,13 @@ qed_ll2_acquire_connection_rx(struct qed_hwfn *p_hwfn,
 static int qed_ll2_acquire_connection_tx(struct qed_hwfn *p_hwfn,
 					 struct qed_ll2_info *p_ll2_info)
 {
+	struct qed_chain_init_params params = {
+		.mode		= QED_CHAIN_MODE_PBL,
+		.intended_use	= QED_CHAIN_USE_TO_CONSUME_PRODUCE,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U16,
+		.num_elems	= p_ll2_info->input.tx_num_desc,
+		.elem_size	= sizeof(struct core_tx_bd),
+	};
 	struct qed_ll2_tx_packet *p_descq;
 	u32 desc_size;
 	u32 capacity;
@@ -1185,13 +1192,8 @@ static int qed_ll2_acquire_connection_tx(struct qed_hwfn *p_hwfn,
 	if (!p_ll2_info->input.tx_num_desc)
 		goto out;
 
-	rc = qed_chain_alloc(p_hwfn->cdev,
-			     QED_CHAIN_USE_TO_CONSUME_PRODUCE,
-			     QED_CHAIN_MODE_PBL,
-			     QED_CHAIN_CNT_TYPE_U16,
-			     p_ll2_info->input.tx_num_desc,
-			     sizeof(struct core_tx_bd),
-			     &p_ll2_info->tx_queue.txq_chain, NULL);
+	rc = qed_chain_alloc(p_hwfn->cdev, &p_ll2_info->tx_queue.txq_chain,
+			     &params);
 	if (rc)
 		goto out;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_spq.c b/drivers/net/ethernet/qlogic/qed/qed_spq.c
index 92ab029789e5..0bc1a0aeb56e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_spq.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_spq.c
@@ -382,22 +382,26 @@ int qed_eq_completion(struct qed_hwfn *p_hwfn, void *cookie)
 
 int qed_eq_alloc(struct qed_hwfn *p_hwfn, u16 num_elem)
 {
+	struct qed_chain_init_params params = {
+		.mode		= QED_CHAIN_MODE_PBL,
+		.intended_use	= QED_CHAIN_USE_TO_PRODUCE,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U16,
+		.num_elems	= num_elem,
+		.elem_size	= sizeof(union event_ring_element),
+	};
 	struct qed_eq *p_eq;
+	int ret;
 
 	/* Allocate EQ struct */
 	p_eq = kzalloc(sizeof(*p_eq), GFP_KERNEL);
 	if (!p_eq)
 		return -ENOMEM;
 
-	/* Allocate and initialize EQ chain*/
-	if (qed_chain_alloc(p_hwfn->cdev,
-			    QED_CHAIN_USE_TO_PRODUCE,
-			    QED_CHAIN_MODE_PBL,
-			    QED_CHAIN_CNT_TYPE_U16,
-			    num_elem,
-			    sizeof(union event_ring_element),
-			    &p_eq->chain, NULL))
+	ret = qed_chain_alloc(p_hwfn->cdev, &p_eq->chain, &params);
+	if (ret) {
+		DP_NOTICE(p_hwfn, "Failed to allocate EQ chain\n");
 		goto eq_allocate_fail;
+	}
 
 	/* register EQ completion on the SP SB */
 	qed_int_register_cb(p_hwfn, qed_eq_completion,
@@ -408,7 +412,8 @@ int qed_eq_alloc(struct qed_hwfn *p_hwfn, u16 num_elem)
 
 eq_allocate_fail:
 	kfree(p_eq);
-	return -ENOMEM;
+
+	return ret;
 }
 
 void qed_eq_setup(struct qed_hwfn *p_hwfn)
@@ -529,33 +534,40 @@ void qed_spq_setup(struct qed_hwfn *p_hwfn)
 
 int qed_spq_alloc(struct qed_hwfn *p_hwfn)
 {
+	struct qed_chain_init_params params = {
+		.mode		= QED_CHAIN_MODE_SINGLE,
+		.intended_use	= QED_CHAIN_USE_TO_PRODUCE,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U16,
+		.elem_size	= sizeof(struct slow_path_element),
+	};
+	struct qed_dev *cdev = p_hwfn->cdev;
 	struct qed_spq_entry *p_virt = NULL;
 	struct qed_spq *p_spq = NULL;
 	dma_addr_t p_phys = 0;
 	u32 capacity;
+	int ret;
 
 	/* SPQ struct */
 	p_spq = kzalloc(sizeof(struct qed_spq), GFP_KERNEL);
 	if (!p_spq)
 		return -ENOMEM;
 
-	/* SPQ ring  */
-	if (qed_chain_alloc(p_hwfn->cdev,
-			    QED_CHAIN_USE_TO_PRODUCE,
-			    QED_CHAIN_MODE_SINGLE,
-			    QED_CHAIN_CNT_TYPE_U16,
-			    0,   /* N/A when the mode is SINGLE */
-			    sizeof(struct slow_path_element),
-			    &p_spq->chain, NULL))
-		goto spq_allocate_fail;
+	/* SPQ ring */
+	ret = qed_chain_alloc(cdev, &p_spq->chain, &params);
+	if (ret) {
+		DP_NOTICE(p_hwfn, "Failed to allocate SPQ chain\n");
+		goto spq_chain_alloc_fail;
+	}
 
 	/* allocate and fill the SPQ elements (incl. ramrod data list) */
 	capacity = qed_chain_get_capacity(&p_spq->chain);
-	p_virt = dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
+	ret = -ENOMEM;
+
+	p_virt = dma_alloc_coherent(&cdev->pdev->dev,
 				    capacity * sizeof(struct qed_spq_entry),
 				    &p_phys, GFP_KERNEL);
 	if (!p_virt)
-		goto spq_allocate_fail;
+		goto spq_alloc_fail;
 
 	p_spq->p_virt = p_virt;
 	p_spq->p_phys = p_phys;
@@ -563,10 +575,12 @@ int qed_spq_alloc(struct qed_hwfn *p_hwfn)
 
 	return 0;
 
-spq_allocate_fail:
-	qed_chain_free(p_hwfn->cdev, &p_spq->chain);
+spq_alloc_fail:
+	qed_chain_free(cdev, &p_spq->chain);
+spq_chain_alloc_fail:
 	kfree(p_spq);
-	return -ENOMEM;
+
+	return ret;
 }
 
 void qed_spq_free(struct qed_hwfn *p_hwfn)
@@ -967,30 +981,40 @@ int qed_spq_completion(struct qed_hwfn *p_hwfn,
 	return 0;
 }
 
+#define QED_SPQ_CONSQ_ELEM_SIZE		0x80
+
 int qed_consq_alloc(struct qed_hwfn *p_hwfn)
 {
+	struct qed_chain_init_params params = {
+		.mode		= QED_CHAIN_MODE_PBL,
+		.intended_use	= QED_CHAIN_USE_TO_PRODUCE,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U16,
+		.num_elems	= QED_CHAIN_PAGE_SIZE / QED_SPQ_CONSQ_ELEM_SIZE,
+		.elem_size	= QED_SPQ_CONSQ_ELEM_SIZE,
+	};
 	struct qed_consq *p_consq;
+	int ret;
 
 	/* Allocate ConsQ struct */
 	p_consq = kzalloc(sizeof(*p_consq), GFP_KERNEL);
 	if (!p_consq)
 		return -ENOMEM;
 
-	/* Allocate and initialize EQ chain*/
-	if (qed_chain_alloc(p_hwfn->cdev,
-			    QED_CHAIN_USE_TO_PRODUCE,
-			    QED_CHAIN_MODE_PBL,
-			    QED_CHAIN_CNT_TYPE_U16,
-			    QED_CHAIN_PAGE_SIZE / 0x80,
-			    0x80, &p_consq->chain, NULL))
-		goto consq_allocate_fail;
+	/* Allocate and initialize ConsQ chain */
+	ret = qed_chain_alloc(p_hwfn->cdev, &p_consq->chain, &params);
+	if (ret) {
+		DP_NOTICE(p_hwfn, "Failed to allocate ConsQ chain");
+		goto consq_alloc_fail;
+	}
 
 	p_hwfn->p_consq = p_consq;
+
 	return 0;
 
-consq_allocate_fail:
+consq_alloc_fail:
 	kfree(p_consq);
-	return -ENOMEM;
+
+	return ret;
 }
 
 void qed_consq_setup(struct qed_hwfn *p_hwfn)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 6f2171dc0dea..b5a95f165520 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1442,6 +1442,11 @@ static void qede_set_tpa_param(struct qede_rx_queue *rxq)
 /* This function allocates all memory needed per Rx queue */
 static int qede_alloc_mem_rxq(struct qede_dev *edev, struct qede_rx_queue *rxq)
 {
+	struct qed_chain_init_params params = {
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U16,
+		.num_elems	= RX_RING_SIZE,
+	};
+	struct qed_dev *cdev = edev->cdev;
 	int i, rc, size;
 
 	rxq->num_rx_buffers = edev->q_num_rx_buffers;
@@ -1477,24 +1482,20 @@ static int qede_alloc_mem_rxq(struct qede_dev *edev, struct qede_rx_queue *rxq)
 	}
 
 	/* Allocate FW Rx ring  */
-	rc = edev->ops->common->chain_alloc(edev->cdev,
-					    QED_CHAIN_USE_TO_CONSUME_PRODUCE,
-					    QED_CHAIN_MODE_NEXT_PTR,
-					    QED_CHAIN_CNT_TYPE_U16,
-					    RX_RING_SIZE,
-					    sizeof(struct eth_rx_bd),
-					    &rxq->rx_bd_ring, NULL);
+	params.mode = QED_CHAIN_MODE_NEXT_PTR;
+	params.intended_use = QED_CHAIN_USE_TO_CONSUME_PRODUCE;
+	params.elem_size = sizeof(struct eth_rx_bd);
+
+	rc = edev->ops->common->chain_alloc(cdev, &rxq->rx_bd_ring, &params);
 	if (rc)
 		goto err;
 
 	/* Allocate FW completion ring */
-	rc = edev->ops->common->chain_alloc(edev->cdev,
-					    QED_CHAIN_USE_TO_CONSUME,
-					    QED_CHAIN_MODE_PBL,
-					    QED_CHAIN_CNT_TYPE_U16,
-					    RX_RING_SIZE,
-					    sizeof(union eth_rx_cqe),
-					    &rxq->rx_comp_ring, NULL);
+	params.mode = QED_CHAIN_MODE_PBL;
+	params.intended_use = QED_CHAIN_USE_TO_CONSUME;
+	params.elem_size = sizeof(union eth_rx_cqe);
+
+	rc = edev->ops->common->chain_alloc(cdev, &rxq->rx_comp_ring, &params);
 	if (rc)
 		goto err;
 
@@ -1531,7 +1532,13 @@ static void qede_free_mem_txq(struct qede_dev *edev, struct qede_tx_queue *txq)
 /* This function allocates all memory needed per Tx queue */
 static int qede_alloc_mem_txq(struct qede_dev *edev, struct qede_tx_queue *txq)
 {
-	union eth_tx_bd_types *p_virt;
+	struct qed_chain_init_params params = {
+		.mode		= QED_CHAIN_MODE_PBL,
+		.intended_use	= QED_CHAIN_USE_TO_CONSUME_PRODUCE,
+		.cnt_type	= QED_CHAIN_CNT_TYPE_U16,
+		.num_elems	= edev->q_num_tx_buffers,
+		.elem_size	= sizeof(union eth_tx_bd_types),
+	};
 	int size, rc;
 
 	txq->num_tx_buffers = edev->q_num_tx_buffers;
@@ -1549,13 +1556,7 @@ static int qede_alloc_mem_txq(struct qede_dev *edev, struct qede_tx_queue *txq)
 			goto err;
 	}
 
-	rc = edev->ops->common->chain_alloc(edev->cdev,
-					    QED_CHAIN_USE_TO_CONSUME_PRODUCE,
-					    QED_CHAIN_MODE_PBL,
-					    QED_CHAIN_CNT_TYPE_U16,
-					    txq->num_tx_buffers,
-					    sizeof(*p_virt),
-					    &txq->tx_pbl, NULL);
+	rc = edev->ops->common->chain_alloc(edev->cdev, &txq->tx_pbl, &params);
 	if (rc)
 		goto err;
 
diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index a0d83095dc73..f5cfee0934e5 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -54,11 +54,6 @@ struct qed_chain_pbl_u32 {
 	u32						cons_page_idx;
 };
 
-struct qed_chain_ext_pbl {
-	dma_addr_t					p_pbl_phys;
-	void						*p_pbl_virt;
-};
-
 struct qed_chain_u16 {
 	/* Cyclic index of next element to produce/consme */
 	u16						prod_idx;
@@ -119,7 +114,7 @@ struct qed_chain {
 	u16						usable_per_page;
 	u8						elem_unusable;
 
-	u8						cnt_type;
+	enum qed_chain_cnt_type				cnt_type;
 
 	/* Slowpath of the chain - required for initialization and destruction,
 	 * but isn't involved in regular functionality.
@@ -142,11 +137,23 @@ struct qed_chain {
 	/* Total number of elements [for entire chain] */
 	u32						size;
 
-	u8						intended_use;
+	enum qed_chain_use_mode				intended_use;
 
 	bool						b_external_pbl;
 };
 
+struct qed_chain_init_params {
+	enum qed_chain_mode				mode;
+	enum qed_chain_use_mode				intended_use;
+	enum qed_chain_cnt_type				cnt_type;
+
+	u32						num_elems;
+	size_t						elem_size;
+
+	void						*ext_pbl_virt;
+	dma_addr_t					ext_pbl_phys;
+};
+
 #define QED_CHAIN_PAGE_SIZE				0x1000
 
 #define ELEMS_PER_PAGE(elem_size)					     \
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index a5c6854343e6..cd6a5c7e56eb 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -948,13 +948,8 @@ struct qed_common_ops {
 					 u8 dp_level);
 
 	int		(*chain_alloc)(struct qed_dev *cdev,
-				       enum qed_chain_use_mode intended_use,
-				       enum qed_chain_mode mode,
-				       enum qed_chain_cnt_type cnt_type,
-				       u32 num_elems,
-				       size_t elem_size,
-				       struct qed_chain *p_chain,
-				       struct qed_chain_ext_pbl *ext_pbl);
+				       struct qed_chain *chain,
+				       struct qed_chain_init_params *params);
 
 	void		(*chain_free)(struct qed_dev *cdev,
 				      struct qed_chain *p_chain);
-- 
2.25.1

