Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4211196EF4
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 19:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgC2Rjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 13:39:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26952 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728041AbgC2Rjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 13:39:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02THaIjj017462;
        Sun, 29 Mar 2020 10:39:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=BSs/SoBLGQ5oZ/kdv5i3xriV49acTMDu2GHBYsGF2Cw=;
 b=pDMr4GbejjPTp3DI/79Aj9loT5dKRfRUseKm6GbuaWu+XKjZ0ydSovuQ5nd6l93ooVEC
 NBquLnUU5uYBOaoZ05LG53VnqPnrcD4BZeQIPfa7uaoVS2E/Q0iuiIPB7fhozxpTqmKT
 i9w6EcYxbxPEjEYWnvjbFxURc5/iTHS4Rk9E+6Z4+T+oq5k7BMX/yDNPQNLszIWhiZIo
 98BHnvc0Q6wYC+OGvJE3rbkV76DRr8xOyfvGtmdVDIkjB6ev43pU8mCPue5516pJzkbC
 ObLOEoTqlegNYGu6Dk/2vGxiZ4+Kvxj2aupewUDUpnAyNlKgisIaiebGRnK+7JsSgUz6 TQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3023xnuv2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 29 Mar 2020 10:39:49 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Mar
 2020 10:39:48 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 29 Mar 2020 10:39:48 -0700
Received: from lb-tlvb-ybason.il.qlogic.org (unknown [10.5.221.176])
        by maili.marvell.com (Postfix) with ESMTP id 7F8CE3F703F;
        Sun, 29 Mar 2020 10:39:47 -0700 (PDT)
From:   Yuval Basson <ybason@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Michal Kalderon <mkalderon@marvell.com>,
        "Yuval Bason" <ybason@marvell.com>
Subject: [PATCH net-next] qed: Fix use after free in qed_chain_free
Date:   Sun, 29 Mar 2020 20:32:49 +0300
Message-ID: <20200329173249.16399-1-ybason@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-29_07:2020-03-27,2020-03-29 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qed_chain data structure was modified in
commit 1a4a69751f4d ("qed: Chain support for external PBL") to support
receiving an external pbl (due to iWARP FW requirements).
The pages pointed to by the pbl are allocated in qed_chain_alloc
and their virtual address are stored in an virtual addresses array to
enable accessing and freeing the data. The physical addresses however
weren't stored and were accessed directly from the external-pbl
during free.

Destroy-qp flow, leads to freeing the external pbl before the chain is
freed, when the chain is freed it tries accessing the already freed
external pbl, leading to a use-after-free. Therefore we need to store
the physical addresses in additional to the virtual addresses in a
new data structure.

Fixes: 1a4a69751f4d ("qed: Chain support for external PBL")
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Yuval Bason <ybason@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 38 +++++++++++++------------------
 include/linux/qed/qed_chain.h             | 24 +++++++++++--------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 03bdd2e..38a65b9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4691,26 +4691,20 @@ static void qed_chain_free_single(struct qed_dev *cdev,
 
 static void qed_chain_free_pbl(struct qed_dev *cdev, struct qed_chain *p_chain)
 {
-	void **pp_virt_addr_tbl = p_chain->pbl.pp_virt_addr_tbl;
+	struct addr_tbl_entry *pp_addr_tbl = p_chain->pbl.pp_addr_tbl;
 	u32 page_cnt = p_chain->page_cnt, i, pbl_size;
-	u8 *p_pbl_virt = p_chain->pbl_sp.p_virt_table;
 
-	if (!pp_virt_addr_tbl)
+	if (!pp_addr_tbl)
 		return;
 
-	if (!p_pbl_virt)
-		goto out;
-
 	for (i = 0; i < page_cnt; i++) {
-		if (!pp_virt_addr_tbl[i])
+		if (!pp_addr_tbl[i].virt_addr || !pp_addr_tbl[i].dma_map)
 			break;
 
 		dma_free_coherent(&cdev->pdev->dev,
 				  QED_CHAIN_PAGE_SIZE,
-				  pp_virt_addr_tbl[i],
-				  *(dma_addr_t *)p_pbl_virt);
-
-		p_pbl_virt += QED_CHAIN_PBL_ENTRY_SIZE;
+				  pp_addr_tbl[i].virt_addr,
+				  pp_addr_tbl[i].dma_map);
 	}
 
 	pbl_size = page_cnt * QED_CHAIN_PBL_ENTRY_SIZE;
@@ -4720,9 +4714,9 @@ static void qed_chain_free_pbl(struct qed_dev *cdev, struct qed_chain *p_chain)
 				  pbl_size,
 				  p_chain->pbl_sp.p_virt_table,
 				  p_chain->pbl_sp.p_phys_table);
-out:
-	vfree(p_chain->pbl.pp_virt_addr_tbl);
-	p_chain->pbl.pp_virt_addr_tbl = NULL;
+
+	vfree(p_chain->pbl.pp_addr_tbl);
+	p_chain->pbl.pp_addr_tbl = NULL;
 }
 
 void qed_chain_free(struct qed_dev *cdev, struct qed_chain *p_chain)
@@ -4823,19 +4817,19 @@ void qed_chain_free(struct qed_dev *cdev, struct qed_chain *p_chain)
 {
 	u32 page_cnt = p_chain->page_cnt, size, i;
 	dma_addr_t p_phys = 0, p_pbl_phys = 0;
-	void **pp_virt_addr_tbl = NULL;
+	struct addr_tbl_entry *pp_addr_tbl;
 	u8 *p_pbl_virt = NULL;
 	void *p_virt = NULL;
 
-	size = page_cnt * sizeof(*pp_virt_addr_tbl);
-	pp_virt_addr_tbl = vzalloc(size);
-	if (!pp_virt_addr_tbl)
+	size = page_cnt * sizeof(*pp_addr_tbl);
+	pp_addr_tbl =  vzalloc(size);
+	if (!pp_addr_tbl)
 		return -ENOMEM;
 
 	/* The allocation of the PBL table is done with its full size, since it
 	 * is expected to be successive.
 	 * qed_chain_init_pbl_mem() is called even in a case of an allocation
-	 * failure, since pp_virt_addr_tbl was previously allocated, and it
+	 * failure, since tbl was previously allocated, and it
 	 * should be saved to allow its freeing during the error flow.
 	 */
 	size = page_cnt * QED_CHAIN_PBL_ENTRY_SIZE;
@@ -4849,8 +4843,7 @@ void qed_chain_free(struct qed_dev *cdev, struct qed_chain *p_chain)
 		p_chain->b_external_pbl = true;
 	}
 
-	qed_chain_init_pbl_mem(p_chain, p_pbl_virt, p_pbl_phys,
-			       pp_virt_addr_tbl);
+	qed_chain_init_pbl_mem(p_chain, p_pbl_virt, p_pbl_phys, pp_addr_tbl);
 	if (!p_pbl_virt)
 		return -ENOMEM;
 
@@ -4869,7 +4862,8 @@ void qed_chain_free(struct qed_dev *cdev, struct qed_chain *p_chain)
 		/* Fill the PBL table with the physical address of the page */
 		*(dma_addr_t *)p_pbl_virt = p_phys;
 		/* Keep the virtual address of the page */
-		p_chain->pbl.pp_virt_addr_tbl[i] = p_virt;
+		p_chain->pbl.pp_addr_tbl[i].virt_addr = p_virt;
+		p_chain->pbl.pp_addr_tbl[i].dma_map = p_phys;
 
 		p_pbl_virt += QED_CHAIN_PBL_ENTRY_SIZE;
 	}
diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index 2dd0a9e..733fad7 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -97,6 +97,11 @@ struct qed_chain_u32 {
 	u32 cons_idx;
 };
 
+struct addr_tbl_entry {
+	void *virt_addr;
+	dma_addr_t dma_map;
+};
+
 struct qed_chain {
 	/* fastpath portion of the chain - required for commands such
 	 * as produce / consume.
@@ -107,10 +112,11 @@ struct qed_chain {
 
 	/* Fastpath portions of the PBL [if exists] */
 	struct {
-		/* Table for keeping the virtual addresses of the chain pages,
-		 * respectively to the physical addresses in the pbl table.
+		/* Table for keeping the virtual and physical addresses of the
+		 * chain pages, respectively to the physical addresses
+		 * in the pbl table.
 		 */
-		void **pp_virt_addr_tbl;
+		struct addr_tbl_entry *pp_addr_tbl;
 
 		union {
 			struct qed_chain_pbl_u16 u16;
@@ -287,7 +293,7 @@ static inline dma_addr_t qed_chain_get_pbl_phys(struct qed_chain *p_chain)
 				*(u32 *)page_to_inc = 0;
 			page_index = *(u32 *)page_to_inc;
 		}
-		*p_next_elem = p_chain->pbl.pp_virt_addr_tbl[page_index];
+		*p_next_elem = p_chain->pbl.pp_addr_tbl[page_index].virt_addr;
 	}
 }
 
@@ -537,7 +543,7 @@ static inline void qed_chain_init_params(struct qed_chain *p_chain,
 
 	p_chain->pbl_sp.p_phys_table = 0;
 	p_chain->pbl_sp.p_virt_table = NULL;
-	p_chain->pbl.pp_virt_addr_tbl = NULL;
+	p_chain->pbl.pp_addr_tbl = NULL;
 }
 
 /**
@@ -575,11 +581,11 @@ static inline void qed_chain_init_mem(struct qed_chain *p_chain,
 static inline void qed_chain_init_pbl_mem(struct qed_chain *p_chain,
 					  void *p_virt_pbl,
 					  dma_addr_t p_phys_pbl,
-					  void **pp_virt_addr_tbl)
+					  struct addr_tbl_entry *pp_addr_tbl)
 {
 	p_chain->pbl_sp.p_phys_table = p_phys_pbl;
 	p_chain->pbl_sp.p_virt_table = p_virt_pbl;
-	p_chain->pbl.pp_virt_addr_tbl = pp_virt_addr_tbl;
+	p_chain->pbl.pp_addr_tbl = pp_addr_tbl;
 }
 
 /**
@@ -644,7 +650,7 @@ static inline void *qed_chain_get_last_elem(struct qed_chain *p_chain)
 		break;
 	case QED_CHAIN_MODE_PBL:
 		last_page_idx = p_chain->page_cnt - 1;
-		p_virt_addr = p_chain->pbl.pp_virt_addr_tbl[last_page_idx];
+		p_virt_addr = p_chain->pbl.pp_addr_tbl[last_page_idx].virt_addr;
 		break;
 	}
 	/* p_virt_addr points at this stage to the last page of the chain */
@@ -716,7 +722,7 @@ static inline void qed_chain_pbl_zero_mem(struct qed_chain *p_chain)
 	page_cnt = qed_chain_get_page_cnt(p_chain);
 
 	for (i = 0; i < page_cnt; i++)
-		memset(p_chain->pbl.pp_virt_addr_tbl[i], 0,
+		memset(p_chain->pbl.pp_addr_tbl[i].virt_addr, 0,
 		       QED_CHAIN_PAGE_SIZE);
 }
 
-- 
1.8.3.1

