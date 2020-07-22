Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BD3229C05
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732954AbgGVPzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:55:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44756 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbgGVPzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:55:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MFso7x009312;
        Wed, 22 Jul 2020 08:54:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=lWXIye26Au3I4NIvtt5Pa544Gt2mL3P7wy8gQxSbphY=;
 b=HbT36BxZjvYD0uzLmgXgNhnrJTU5E1IyG2/ExbGMfm867R4/Y135e0e5Evi7P6E/LPIk
 NMZRTlq485Cdc5wEltNqPWGlKg0ZKICFuK7MZS2V5Vz376CHvBKj+amWOjbMtQuB/XIg
 gNjdEi/tZdgGk3P14WouFI2splkze4SOA4YAMuZGLW/q6GbwlTMf/Qn8Q/qzGE37BkvQ
 Yv5woWLV0zPJoIH8UdRS/WJB5rEZS890rpv1598/2+vxJK5s1k8b5o+NcFM8pzymBRPP
 JvV25YOZxBi5tGwcsm+9peD/pKaTaE9b3wOcQTan5OfMVzEs7MUU6tygc+c43U2RUnUF tA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkrkkx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 08:54:50 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 08:54:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 08:54:49 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 98FC13F7040;
        Wed, 22 Jul 2020 08:54:43 -0700 (PDT)
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
Subject: [PATCH net-next 03/15] qed: move chain methods to a separate file
Date:   Wed, 22 Jul 2020 18:53:37 +0300
Message-ID: <20200722155349.747-4-alobakin@marvell.com>
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

Move chain allocation/freeing functions to a new file to not mix it with
hardware-related code.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/Makefile    |   1 +
 drivers/net/ethernet/qlogic/qed/qed_chain.c | 300 ++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_dev.c   | 273 ------------------
 3 files changed, 301 insertions(+), 273 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_chain.c

diff --git a/drivers/net/ethernet/qlogic/qed/Makefile b/drivers/net/ethernet/qlogic/qed/Makefile
index 3c75e4fa9b02..f947b105cf14 100644
--- a/drivers/net/ethernet/qlogic/qed/Makefile
+++ b/drivers/net/ethernet/qlogic/qed/Makefile
@@ -4,6 +4,7 @@
 obj-$(CONFIG_QED) := qed.o
 
 qed-y :=			\
+	qed_chain.o		\
 	qed_cxt.o		\
 	qed_dcbx.o		\
 	qed_debug.o		\
diff --git a/drivers/net/ethernet/qlogic/qed/qed_chain.c b/drivers/net/ethernet/qlogic/qed/qed_chain.c
new file mode 100644
index 000000000000..40cc26f7f20b
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qed/qed_chain.c
@@ -0,0 +1,300 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+/* Copyright (c) 2020 Marvell International Ltd. */
+
+#include <linux/qed/qed_chain.h>
+
+#include "qed_dev_api.h"
+
+static void qed_chain_free_next_ptr(struct qed_dev *cdev,
+				    struct qed_chain *chain)
+{
+	struct device *dev = &cdev->pdev->dev;
+	struct qed_chain_next *next;
+	dma_addr_t phys, phys_next;
+	void *virt, *virt_next;
+	u32 size, i;
+
+	size = chain->elem_size * chain->usable_per_page;
+	virt = chain->p_virt_addr;
+	phys = chain->p_phys_addr;
+
+	for (i = 0; i < chain->page_cnt; i++) {
+		if (!virt)
+			break;
+
+		next = virt + size;
+		virt_next = next->next_virt;
+		phys_next = HILO_DMA_REGPAIR(next->next_phys);
+
+		dma_free_coherent(dev, QED_CHAIN_PAGE_SIZE, virt, phys);
+
+		virt = virt_next;
+		phys = phys_next;
+	}
+}
+
+static void qed_chain_free_single(struct qed_dev *cdev,
+				  struct qed_chain *chain)
+{
+	if (!chain->p_virt_addr)
+		return;
+
+	dma_free_coherent(&cdev->pdev->dev, QED_CHAIN_PAGE_SIZE,
+			  chain->p_virt_addr, chain->p_phys_addr);
+}
+
+static void qed_chain_free_pbl(struct qed_dev *cdev, struct qed_chain *chain)
+{
+	struct device *dev = &cdev->pdev->dev;
+	struct addr_tbl_entry *entry;
+	u32 pbl_size, i;
+
+	if (!chain->pbl.pp_addr_tbl)
+		return;
+
+	for (i = 0; i < chain->page_cnt; i++) {
+		entry = chain->pbl.pp_addr_tbl + i;
+		if (!entry->virt_addr)
+			break;
+
+		dma_free_coherent(dev, QED_CHAIN_PAGE_SIZE, entry->virt_addr,
+				  entry->dma_map);
+	}
+
+	pbl_size = chain->page_cnt * QED_CHAIN_PBL_ENTRY_SIZE;
+
+	if (!chain->b_external_pbl)
+		dma_free_coherent(dev, pbl_size, chain->pbl_sp.p_virt_table,
+				  chain->pbl_sp.p_phys_table);
+
+	vfree(chain->pbl.pp_addr_tbl);
+	chain->pbl.pp_addr_tbl = NULL;
+}
+
+/**
+ * qed_chain_free() - Free chain DMA memory.
+ *
+ * @cdev: Main device structure.
+ * @chain: Chain to free.
+ */
+void qed_chain_free(struct qed_dev *cdev, struct qed_chain *chain)
+{
+	switch (chain->mode) {
+	case QED_CHAIN_MODE_NEXT_PTR:
+		qed_chain_free_next_ptr(cdev, chain);
+		break;
+	case QED_CHAIN_MODE_SINGLE:
+		qed_chain_free_single(cdev, chain);
+		break;
+	case QED_CHAIN_MODE_PBL:
+		qed_chain_free_pbl(cdev, chain);
+		break;
+	default:
+		break;
+	}
+}
+
+static int
+qed_chain_alloc_sanity_check(struct qed_dev *cdev,
+			     enum qed_chain_cnt_type cnt_type,
+			     size_t elem_size, u32 page_cnt)
+{
+	u64 chain_size = ELEMS_PER_PAGE(elem_size) * page_cnt;
+
+	/* The actual chain size can be larger than the maximal possible value
+	 * after rounding up the requested elements number to pages, and after
+	 * taking into account the unusuable elements (next-ptr elements).
+	 * The size of a "u16" chain can be (U16_MAX + 1) since the chain
+	 * size/capacity fields are of u32 type.
+	 */
+	switch (cnt_type) {
+	case QED_CHAIN_CNT_TYPE_U16:
+		if (chain_size > U16_MAX + 1)
+			break;
+
+		return 0;
+	case QED_CHAIN_CNT_TYPE_U32:
+		if (chain_size > U32_MAX)
+			break;
+
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	DP_NOTICE(cdev,
+		  "The actual chain size (0x%llx) is larger than the maximal possible value\n",
+		  chain_size);
+
+	return -EINVAL;
+}
+
+static int qed_chain_alloc_next_ptr(struct qed_dev *cdev,
+				    struct qed_chain *chain)
+{
+	struct device *dev = &cdev->pdev->dev;
+	void *virt, *virt_prev = NULL;
+	dma_addr_t phys;
+	u32 i;
+
+	for (i = 0; i < chain->page_cnt; i++) {
+		virt = dma_alloc_coherent(dev, QED_CHAIN_PAGE_SIZE, &phys,
+					  GFP_KERNEL);
+		if (!virt)
+			return -ENOMEM;
+
+		if (i == 0) {
+			qed_chain_init_mem(chain, virt, phys);
+			qed_chain_reset(chain);
+		} else {
+			qed_chain_init_next_ptr_elem(chain, virt_prev, virt,
+						     phys);
+		}
+
+		virt_prev = virt;
+	}
+
+	/* Last page's next element should point to the beginning of the
+	 * chain.
+	 */
+	qed_chain_init_next_ptr_elem(chain, virt_prev, chain->p_virt_addr,
+				     chain->p_phys_addr);
+
+	return 0;
+}
+
+static int qed_chain_alloc_single(struct qed_dev *cdev,
+				  struct qed_chain *chain)
+{
+	dma_addr_t phys;
+	void *virt;
+
+	virt = dma_alloc_coherent(&cdev->pdev->dev, QED_CHAIN_PAGE_SIZE,
+				  &phys, GFP_KERNEL);
+	if (!virt)
+		return -ENOMEM;
+
+	qed_chain_init_mem(chain, virt, phys);
+	qed_chain_reset(chain);
+
+	return 0;
+}
+
+static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain,
+			       struct qed_chain_ext_pbl *ext_pbl)
+{
+	struct device *dev = &cdev->pdev->dev;
+	struct addr_tbl_entry *addr_tbl;
+	dma_addr_t phys, pbl_phys;
+	void *pbl_virt;
+	u32 page_cnt, i;
+	size_t size;
+	void *virt;
+
+	page_cnt = chain->page_cnt;
+
+	size = array_size(page_cnt, sizeof(*addr_tbl));
+	if (unlikely(size == SIZE_MAX))
+		return -EOVERFLOW;
+
+	addr_tbl = vzalloc(size);
+	if (!addr_tbl)
+		return -ENOMEM;
+
+	chain->pbl.pp_addr_tbl = addr_tbl;
+
+	if (ext_pbl) {
+		size = 0;
+		pbl_virt = ext_pbl->p_pbl_virt;
+		pbl_phys = ext_pbl->p_pbl_phys;
+
+		chain->b_external_pbl = true;
+	} else {
+		size = array_size(page_cnt, QED_CHAIN_PBL_ENTRY_SIZE);
+		if (unlikely(size == SIZE_MAX))
+			return -EOVERFLOW;
+
+		pbl_virt = dma_alloc_coherent(dev, size, &pbl_phys,
+					      GFP_KERNEL);
+	}
+
+	if (!pbl_virt)
+		return -ENOMEM;
+
+	chain->pbl_sp.p_virt_table = pbl_virt;
+	chain->pbl_sp.p_phys_table = pbl_phys;
+
+	for (i = 0; i < page_cnt; i++) {
+		virt = dma_alloc_coherent(dev, QED_CHAIN_PAGE_SIZE, &phys,
+					  GFP_KERNEL);
+		if (!virt)
+			return -ENOMEM;
+
+		if (i == 0) {
+			qed_chain_init_mem(chain, virt, phys);
+			qed_chain_reset(chain);
+		}
+
+		/* Fill the PBL table with the physical address of the page */
+		*(dma_addr_t *)pbl_virt = phys;
+		pbl_virt += QED_CHAIN_PBL_ENTRY_SIZE;
+
+		/* Keep the virtual address of the page */
+		addr_tbl[i].virt_addr = virt;
+		addr_tbl[i].dma_map = phys;
+	}
+
+	return 0;
+}
+
+int qed_chain_alloc(struct qed_dev *cdev,
+		    enum qed_chain_use_mode intended_use,
+		    enum qed_chain_mode mode,
+		    enum qed_chain_cnt_type cnt_type,
+		    u32 num_elems,
+		    size_t elem_size,
+		    struct qed_chain *chain,
+		    struct qed_chain_ext_pbl *ext_pbl)
+{
+	u32 page_cnt;
+	int rc;
+
+	if (mode == QED_CHAIN_MODE_SINGLE)
+		page_cnt = 1;
+	else
+		page_cnt = QED_CHAIN_PAGE_CNT(num_elems, elem_size, mode);
+
+	rc = qed_chain_alloc_sanity_check(cdev, cnt_type, elem_size, page_cnt);
+	if (rc) {
+		DP_NOTICE(cdev,
+			  "Cannot allocate a chain with the given arguments:\n");
+		DP_NOTICE(cdev,
+			  "[use_mode %d, mode %d, cnt_type %d, num_elems %d, elem_size %zu]\n",
+			  intended_use, mode, cnt_type, num_elems, elem_size);
+		return rc;
+	}
+
+	qed_chain_init_params(chain, page_cnt, elem_size, intended_use, mode,
+			      cnt_type);
+
+	switch (mode) {
+	case QED_CHAIN_MODE_NEXT_PTR:
+		rc = qed_chain_alloc_next_ptr(cdev, chain);
+		break;
+	case QED_CHAIN_MODE_SINGLE:
+		rc = qed_chain_alloc_single(cdev, chain);
+		break;
+	case QED_CHAIN_MODE_PBL:
+		rc = qed_chain_alloc_pbl(cdev, chain, ext_pbl);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!rc)
+		return 0;
+
+	qed_chain_free(cdev, chain);
+
+	return rc;
+}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 6516a1f921da..d9c7a1a6be94 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4716,279 +4716,6 @@ void qed_hw_remove(struct qed_dev *cdev)
 	qed_mcp_nvm_info_free(p_hwfn);
 }
 
-static void qed_chain_free_next_ptr(struct qed_dev *cdev,
-				    struct qed_chain *p_chain)
-{
-	void *p_virt = p_chain->p_virt_addr, *p_virt_next = NULL;
-	dma_addr_t p_phys = p_chain->p_phys_addr, p_phys_next = 0;
-	struct qed_chain_next *p_next;
-	u32 size, i;
-
-	if (!p_virt)
-		return;
-
-	size = p_chain->elem_size * p_chain->usable_per_page;
-
-	for (i = 0; i < p_chain->page_cnt; i++) {
-		if (!p_virt)
-			break;
-
-		p_next = (struct qed_chain_next *)((u8 *)p_virt + size);
-		p_virt_next = p_next->next_virt;
-		p_phys_next = HILO_DMA_REGPAIR(p_next->next_phys);
-
-		dma_free_coherent(&cdev->pdev->dev,
-				  QED_CHAIN_PAGE_SIZE, p_virt, p_phys);
-
-		p_virt = p_virt_next;
-		p_phys = p_phys_next;
-	}
-}
-
-static void qed_chain_free_single(struct qed_dev *cdev,
-				  struct qed_chain *p_chain)
-{
-	if (!p_chain->p_virt_addr)
-		return;
-
-	dma_free_coherent(&cdev->pdev->dev,
-			  QED_CHAIN_PAGE_SIZE,
-			  p_chain->p_virt_addr, p_chain->p_phys_addr);
-}
-
-static void qed_chain_free_pbl(struct qed_dev *cdev, struct qed_chain *p_chain)
-{
-	struct addr_tbl_entry *pp_addr_tbl = p_chain->pbl.pp_addr_tbl;
-	u32 page_cnt = p_chain->page_cnt, i, pbl_size;
-
-	if (!pp_addr_tbl)
-		return;
-
-	for (i = 0; i < page_cnt; i++) {
-		if (!pp_addr_tbl[i].virt_addr || !pp_addr_tbl[i].dma_map)
-			break;
-
-		dma_free_coherent(&cdev->pdev->dev,
-				  QED_CHAIN_PAGE_SIZE,
-				  pp_addr_tbl[i].virt_addr,
-				  pp_addr_tbl[i].dma_map);
-	}
-
-	pbl_size = page_cnt * QED_CHAIN_PBL_ENTRY_SIZE;
-
-	if (!p_chain->b_external_pbl)
-		dma_free_coherent(&cdev->pdev->dev,
-				  pbl_size,
-				  p_chain->pbl_sp.p_virt_table,
-				  p_chain->pbl_sp.p_phys_table);
-
-	vfree(p_chain->pbl.pp_addr_tbl);
-	p_chain->pbl.pp_addr_tbl = NULL;
-}
-
-void qed_chain_free(struct qed_dev *cdev, struct qed_chain *p_chain)
-{
-	switch (p_chain->mode) {
-	case QED_CHAIN_MODE_NEXT_PTR:
-		qed_chain_free_next_ptr(cdev, p_chain);
-		break;
-	case QED_CHAIN_MODE_SINGLE:
-		qed_chain_free_single(cdev, p_chain);
-		break;
-	case QED_CHAIN_MODE_PBL:
-		qed_chain_free_pbl(cdev, p_chain);
-		break;
-	}
-}
-
-static int
-qed_chain_alloc_sanity_check(struct qed_dev *cdev,
-			     enum qed_chain_cnt_type cnt_type,
-			     size_t elem_size, u32 page_cnt)
-{
-	u64 chain_size = ELEMS_PER_PAGE(elem_size) * page_cnt;
-
-	/* The actual chain size can be larger than the maximal possible value
-	 * after rounding up the requested elements number to pages, and after
-	 * taking into acount the unusuable elements (next-ptr elements).
-	 * The size of a "u16" chain can be (U16_MAX + 1) since the chain
-	 * size/capacity fields are of a u32 type.
-	 */
-	if ((cnt_type == QED_CHAIN_CNT_TYPE_U16 &&
-	     chain_size > ((u32)U16_MAX + 1)) ||
-	    (cnt_type == QED_CHAIN_CNT_TYPE_U32 && chain_size > U32_MAX)) {
-		DP_NOTICE(cdev,
-			  "The actual chain size (0x%llx) is larger than the maximal possible value\n",
-			  chain_size);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int
-qed_chain_alloc_next_ptr(struct qed_dev *cdev, struct qed_chain *p_chain)
-{
-	void *p_virt = NULL, *p_virt_prev = NULL;
-	dma_addr_t p_phys = 0;
-	u32 i;
-
-	for (i = 0; i < p_chain->page_cnt; i++) {
-		p_virt = dma_alloc_coherent(&cdev->pdev->dev,
-					    QED_CHAIN_PAGE_SIZE,
-					    &p_phys, GFP_KERNEL);
-		if (!p_virt)
-			return -ENOMEM;
-
-		if (i == 0) {
-			qed_chain_init_mem(p_chain, p_virt, p_phys);
-			qed_chain_reset(p_chain);
-		} else {
-			qed_chain_init_next_ptr_elem(p_chain, p_virt_prev,
-						     p_virt, p_phys);
-		}
-
-		p_virt_prev = p_virt;
-	}
-	/* Last page's next element should point to the beginning of the
-	 * chain.
-	 */
-	qed_chain_init_next_ptr_elem(p_chain, p_virt_prev,
-				     p_chain->p_virt_addr,
-				     p_chain->p_phys_addr);
-
-	return 0;
-}
-
-static int
-qed_chain_alloc_single(struct qed_dev *cdev, struct qed_chain *p_chain)
-{
-	dma_addr_t p_phys = 0;
-	void *p_virt = NULL;
-
-	p_virt = dma_alloc_coherent(&cdev->pdev->dev,
-				    QED_CHAIN_PAGE_SIZE, &p_phys, GFP_KERNEL);
-	if (!p_virt)
-		return -ENOMEM;
-
-	qed_chain_init_mem(p_chain, p_virt, p_phys);
-	qed_chain_reset(p_chain);
-
-	return 0;
-}
-
-static int
-qed_chain_alloc_pbl(struct qed_dev *cdev,
-		    struct qed_chain *p_chain,
-		    struct qed_chain_ext_pbl *ext_pbl)
-{
-	u32 page_cnt = p_chain->page_cnt, size, i;
-	dma_addr_t p_phys = 0, p_pbl_phys = 0;
-	struct addr_tbl_entry *pp_addr_tbl;
-	u8 *p_pbl_virt = NULL;
-	void *p_virt = NULL;
-
-	size = page_cnt * sizeof(*pp_addr_tbl);
-	pp_addr_tbl =  vzalloc(size);
-	if (!pp_addr_tbl)
-		return -ENOMEM;
-
-	/* The allocation of the PBL table is done with its full size, since it
-	 * is expected to be successive.
-	 * qed_chain_init_pbl_mem() is called even in a case of an allocation
-	 * failure, since tbl was previously allocated, and it
-	 * should be saved to allow its freeing during the error flow.
-	 */
-	size = page_cnt * QED_CHAIN_PBL_ENTRY_SIZE;
-
-	if (!ext_pbl) {
-		p_pbl_virt = dma_alloc_coherent(&cdev->pdev->dev,
-						size, &p_pbl_phys, GFP_KERNEL);
-	} else {
-		p_pbl_virt = ext_pbl->p_pbl_virt;
-		p_pbl_phys = ext_pbl->p_pbl_phys;
-		p_chain->b_external_pbl = true;
-	}
-
-	qed_chain_init_pbl_mem(p_chain, p_pbl_virt, p_pbl_phys, pp_addr_tbl);
-	if (!p_pbl_virt)
-		return -ENOMEM;
-
-	for (i = 0; i < page_cnt; i++) {
-		p_virt = dma_alloc_coherent(&cdev->pdev->dev,
-					    QED_CHAIN_PAGE_SIZE,
-					    &p_phys, GFP_KERNEL);
-		if (!p_virt)
-			return -ENOMEM;
-
-		if (i == 0) {
-			qed_chain_init_mem(p_chain, p_virt, p_phys);
-			qed_chain_reset(p_chain);
-		}
-
-		/* Fill the PBL table with the physical address of the page */
-		*(dma_addr_t *)p_pbl_virt = p_phys;
-		/* Keep the virtual address of the page */
-		p_chain->pbl.pp_addr_tbl[i].virt_addr = p_virt;
-		p_chain->pbl.pp_addr_tbl[i].dma_map = p_phys;
-
-		p_pbl_virt += QED_CHAIN_PBL_ENTRY_SIZE;
-	}
-
-	return 0;
-}
-
-int qed_chain_alloc(struct qed_dev *cdev,
-		    enum qed_chain_use_mode intended_use,
-		    enum qed_chain_mode mode,
-		    enum qed_chain_cnt_type cnt_type,
-		    u32 num_elems,
-		    size_t elem_size,
-		    struct qed_chain *p_chain,
-		    struct qed_chain_ext_pbl *ext_pbl)
-{
-	u32 page_cnt;
-	int rc = 0;
-
-	if (mode == QED_CHAIN_MODE_SINGLE)
-		page_cnt = 1;
-	else
-		page_cnt = QED_CHAIN_PAGE_CNT(num_elems, elem_size, mode);
-
-	rc = qed_chain_alloc_sanity_check(cdev, cnt_type, elem_size, page_cnt);
-	if (rc) {
-		DP_NOTICE(cdev,
-			  "Cannot allocate a chain with the given arguments:\n");
-		DP_NOTICE(cdev,
-			  "[use_mode %d, mode %d, cnt_type %d, num_elems %d, elem_size %zu]\n",
-			  intended_use, mode, cnt_type, num_elems, elem_size);
-		return rc;
-	}
-
-	qed_chain_init_params(p_chain, page_cnt, (u8) elem_size, intended_use,
-			      mode, cnt_type);
-
-	switch (mode) {
-	case QED_CHAIN_MODE_NEXT_PTR:
-		rc = qed_chain_alloc_next_ptr(cdev, p_chain);
-		break;
-	case QED_CHAIN_MODE_SINGLE:
-		rc = qed_chain_alloc_single(cdev, p_chain);
-		break;
-	case QED_CHAIN_MODE_PBL:
-		rc = qed_chain_alloc_pbl(cdev, p_chain, ext_pbl);
-		break;
-	}
-	if (rc)
-		goto nomem;
-
-	return 0;
-
-nomem:
-	qed_chain_free(cdev, p_chain);
-	return rc;
-}
-
 int qed_fw_l2_queue(struct qed_hwfn *p_hwfn, u16 src_id, u16 *dst_id)
 {
 	if (src_id >= RESC_NUM(p_hwfn, QED_L2_QUEUE)) {
-- 
2.25.1

