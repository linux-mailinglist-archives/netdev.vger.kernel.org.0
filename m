Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81CC22A1DE
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733261AbgGVWMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:12:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20406 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733226AbgGVWMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:12:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MM6g1Z019807;
        Wed, 22 Jul 2020 15:11:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=oSzLwsref012AkzpvzgFjlOhikclbMl+wXgWBDBRSgo=;
 b=xoxR3ZqII+0S6TcGtqDB7U2nAFbDJCWA3d07R3178IOIPsF6dQisuCotOt6BLncOA3Yo
 GQOIbOlw7o6A7SHSohfxTz49FhgHIiid5OihGqw3Qpd2dwRYcD/nzVL0KUhq1sjb9EZ7
 t+Eg49oc2+OH5Spj6k9A94b4fJC3c6TR0tbLRDXEw6+36Z11QYk7tCZ9mrNMFnsgon73
 w7V0VruHj8IF/f8bKY6aPiNOC5KJ8I1frfaDl1SE/IDD6DB9fHwjeMRTzGhFob0P6bco
 nwviJDz0XItmBqnu/rzfKruCZ+Ii6pZ+VIIusx8Koq5asnexY5QGW1R76JkYokYp4wp+ sA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkt0m2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 15:11:43 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 15:11:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 15:11:39 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 63B853F7040;
        Wed, 22 Jul 2020 15:11:33 -0700 (PDT)
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
Subject: [PATCH v2 net-next 05/15] qed: sanitize PBL chains allocation
Date:   Thu, 23 Jul 2020 01:10:35 +0300
Message-ID: <20200722221045.5436-6-alobakin@marvell.com>
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

PBL chain elements are actually DMA addresses stored in __le64, but
currently their size is hardcoded to 8, and DMA addresses are assigned
via cast to variable-sized dma_addr_t without any bitwise conversions.
Change the type of pbl_virt array to match the actual one, add a new
field to store the size of allocated DMA memory and sanitize elements
assignment.

Misc: give more logic names to the members of qed_chain::pbl_sp embedded
struct.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_chain.c   | 21 +++++++++----------
 .../net/ethernet/qlogic/qed/qed_sp_commands.c |  4 ++--
 include/linux/qed/qed_chain.h                 | 16 +++++++-------
 3 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_chain.c b/drivers/net/ethernet/qlogic/qed/qed_chain.c
index 917b783433f7..a9ff15b9d8c0 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_chain.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_chain.c
@@ -49,7 +49,7 @@ static void qed_chain_free_pbl(struct qed_dev *cdev, struct qed_chain *chain)
 {
 	struct device *dev = &cdev->pdev->dev;
 	struct addr_tbl_entry *entry;
-	u32 pbl_size, i;
+	u32 i;
 
 	if (!chain->pbl.pp_addr_tbl)
 		return;
@@ -63,11 +63,10 @@ static void qed_chain_free_pbl(struct qed_dev *cdev, struct qed_chain *chain)
 				  entry->dma_map);
 	}
 
-	pbl_size = chain->page_cnt * QED_CHAIN_PBL_ENTRY_SIZE;
-
 	if (!chain->b_external_pbl)
-		dma_free_coherent(dev, pbl_size, chain->pbl_sp.p_virt_table,
-				  chain->pbl_sp.p_phys_table);
+		dma_free_coherent(dev, chain->pbl_sp.table_size,
+				  chain->pbl_sp.table_virt,
+				  chain->pbl_sp.table_phys);
 
 	vfree(chain->pbl.pp_addr_tbl);
 	chain->pbl.pp_addr_tbl = NULL;
@@ -190,7 +189,7 @@ static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain,
 	struct device *dev = &cdev->pdev->dev;
 	struct addr_tbl_entry *addr_tbl;
 	dma_addr_t phys, pbl_phys;
-	void *pbl_virt;
+	__le64 *pbl_virt;
 	u32 page_cnt, i;
 	size_t size;
 	void *virt;
@@ -214,7 +213,7 @@ static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain,
 
 		chain->b_external_pbl = true;
 	} else {
-		size = array_size(page_cnt, QED_CHAIN_PBL_ENTRY_SIZE);
+		size = array_size(page_cnt, sizeof(*pbl_virt));
 		if (unlikely(size == SIZE_MAX))
 			return -EOVERFLOW;
 
@@ -225,8 +224,9 @@ static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain,
 	if (!pbl_virt)
 		return -ENOMEM;
 
-	chain->pbl_sp.p_virt_table = pbl_virt;
-	chain->pbl_sp.p_phys_table = pbl_phys;
+	chain->pbl_sp.table_virt = pbl_virt;
+	chain->pbl_sp.table_phys = pbl_phys;
+	chain->pbl_sp.table_size = size;
 
 	for (i = 0; i < page_cnt; i++) {
 		virt = dma_alloc_coherent(dev, QED_CHAIN_PAGE_SIZE, &phys,
@@ -240,8 +240,7 @@ static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain,
 		}
 
 		/* Fill the PBL table with the physical address of the page */
-		*(dma_addr_t *)pbl_virt = phys;
-		pbl_virt += QED_CHAIN_PBL_ENTRY_SIZE;
+		pbl_virt[i] = cpu_to_le64(phys);
 
 		/* Keep the virtual address of the page */
 		addr_tbl[i].virt_addr = virt;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
index 8142f5669b26..aa71adcf31ee 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
@@ -366,11 +366,11 @@ int qed_sp_pf_start(struct qed_hwfn *p_hwfn,
 
 	/* Place EQ address in RAMROD */
 	DMA_REGPAIR_LE(p_ramrod->event_ring_pbl_addr,
-		       p_hwfn->p_eq->chain.pbl_sp.p_phys_table);
+		       qed_chain_get_pbl_phys(&p_hwfn->p_eq->chain));
 	page_cnt = (u8)qed_chain_get_page_cnt(&p_hwfn->p_eq->chain);
 	p_ramrod->event_ring_num_pages = page_cnt;
 	DMA_REGPAIR_LE(p_ramrod->consolid_q_pbl_addr,
-		       p_hwfn->p_consq->chain.pbl_sp.p_phys_table);
+		       qed_chain_get_pbl_phys(&p_hwfn->p_consq->chain));
 
 	qed_tunn_set_pf_start_params(p_hwfn, p_tunn, &p_ramrod->tunnel_config);
 
diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index 087073517c09..265e0b671a5c 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -127,8 +127,9 @@ struct qed_chain {
 
 	/* Base address of a pre-allocated buffer for pbl */
 	struct {
-		dma_addr_t				p_phys_table;
-		void					*p_virt_table;
+		__le64					*table_virt;
+		dma_addr_t				table_phys;
+		size_t					table_size;
 	}						pbl_sp;
 
 	/* Address of first page of the chain - the address is required
@@ -146,7 +147,6 @@ struct qed_chain {
 	bool						b_external_pbl;
 };
 
-#define QED_CHAIN_PBL_ENTRY_SIZE			8
 #define QED_CHAIN_PAGE_SIZE				0x1000
 
 #define ELEMS_PER_PAGE(elem_size)					     \
@@ -236,7 +236,7 @@ static inline u32 qed_chain_get_page_cnt(struct qed_chain *p_chain)
 
 static inline dma_addr_t qed_chain_get_pbl_phys(struct qed_chain *p_chain)
 {
-	return p_chain->pbl_sp.p_phys_table;
+	return p_chain->pbl_sp.table_phys;
 }
 
 /**
@@ -527,8 +527,8 @@ static inline void qed_chain_init_params(struct qed_chain *p_chain,
 	p_chain->capacity = p_chain->usable_per_page * page_cnt;
 	p_chain->size = p_chain->elem_per_page * page_cnt;
 
-	p_chain->pbl_sp.p_phys_table = 0;
-	p_chain->pbl_sp.p_virt_table = NULL;
+	p_chain->pbl_sp.table_phys = 0;
+	p_chain->pbl_sp.table_virt = NULL;
 	p_chain->pbl.pp_addr_tbl = NULL;
 }
 
@@ -569,8 +569,8 @@ static inline void qed_chain_init_pbl_mem(struct qed_chain *p_chain,
 					  dma_addr_t p_phys_pbl,
 					  struct addr_tbl_entry *pp_addr_tbl)
 {
-	p_chain->pbl_sp.p_phys_table = p_phys_pbl;
-	p_chain->pbl_sp.p_virt_table = p_virt_pbl;
+	p_chain->pbl_sp.table_phys = p_phys_pbl;
+	p_chain->pbl_sp.table_virt = p_virt_pbl;
 	p_chain->pbl.pp_addr_tbl = pp_addr_tbl;
 }
 
-- 
2.25.1

