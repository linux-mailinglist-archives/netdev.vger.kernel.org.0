Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9170E229C10
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733019AbgGVPzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:55:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26920 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbgGVPz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:55:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MFsX21008864;
        Wed, 22 Jul 2020 08:55:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=r1IL7Mc4UCRNx/O9zTgQltzHrYRsbknuZ0cq1jTpN8w=;
 b=QUdwAzem+5iIUKmOV0bjemv6EU7RJ2kBqQjIvtXz2uSdS0/rTDOYR4cqXXkAA3gwe53D
 z/HNpuwPt58OwCcG1p+zKkHSbDIdKzYJCNkUT5UL2dcYDk7QiH9oXWZsUVHf2TQWlhAM
 rPHGA1ESw4kb3mubsCM7lEVZNFGTdV9aUlePWP+gWGUofJCmHYLidKNiVNkSHH8V4mvY
 npeEFOSy4TSY30yUPqomnI+f93Y2CQRFKey9xliK/3lkxZSoS6dlYX17DpdW1gyN0F9h
 RRQUEqRMLJgm0OvUi5FN7hXQBIr9zbQ6RzNgI6oqTVBHyTVgF+qt8qkVKgiHUBXvX+Et mQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkrkn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 08:55:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 08:55:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 08:55:08 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 4923A3F7050;
        Wed, 22 Jul 2020 08:55:02 -0700 (PDT)
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
Subject: [PATCH net-next 06/15] qed: move chain initialization inlines next to allocation functions
Date:   Wed, 22 Jul 2020 18:53:40 +0300
Message-ID: <20200722155349.747-7-alobakin@marvell.com>
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

qed_chain_init*() are used in one file/place on "cold" path only, so they
can be uninlined and moved next to the call sites.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_chain.c |  47 ++++++++
 include/linux/qed/qed_chain.h               | 112 --------------------
 2 files changed, 47 insertions(+), 112 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_chain.c b/drivers/net/ethernet/qlogic/qed/qed_chain.c
index b1a3fe4d35b6..e2c5741ed160 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_chain.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_chain.c
@@ -5,6 +5,53 @@
 
 #include "qed_dev_api.h"
 
+static void qed_chain_init_params(struct qed_chain *chain,
+				  u32 page_cnt, u8 elem_size,
+				  enum qed_chain_use_mode intended_use,
+				  enum qed_chain_mode mode,
+				  enum qed_chain_cnt_type cnt_type)
+{
+	memset(chain, 0, sizeof(*chain));
+
+	chain->elem_size = elem_size;
+	chain->intended_use = intended_use;
+	chain->mode = mode;
+	chain->cnt_type = cnt_type;
+
+	chain->elem_per_page = ELEMS_PER_PAGE(elem_size);
+	chain->usable_per_page = USABLE_ELEMS_PER_PAGE(elem_size, mode);
+	chain->elem_unusable = UNUSABLE_ELEMS_PER_PAGE(elem_size, mode);
+
+	chain->elem_per_page_mask = chain->elem_per_page - 1;
+	chain->next_page_mask = chain->usable_per_page &
+				chain->elem_per_page_mask;
+
+	chain->page_cnt = page_cnt;
+	chain->capacity = chain->usable_per_page * page_cnt;
+	chain->size = chain->elem_per_page * page_cnt;
+}
+
+static void qed_chain_init_next_ptr_elem(const struct qed_chain *chain,
+					 void *virt_curr, void *virt_next,
+					 dma_addr_t phys_next)
+{
+	struct qed_chain_next *next;
+	u32 size;
+
+	size = chain->elem_size * chain->usable_per_page;
+	next = virt_curr + size;
+
+	DMA_REGPAIR_LE(next->next_phys, phys_next);
+	next->next_virt = virt_next;
+}
+
+static void qed_chain_init_mem(struct qed_chain *chain, void *virt_addr,
+			       dma_addr_t phys_addr)
+{
+	chain->p_virt_addr = virt_addr;
+	chain->p_phys_addr = phys_addr;
+}
+
 static void qed_chain_free_next_ptr(struct qed_dev *cdev,
 				    struct qed_chain *chain)
 {
diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index 265e0b671a5c..a0d83095dc73 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -490,118 +490,6 @@ static inline void qed_chain_reset(struct qed_chain *p_chain)
 	}
 }
 
-/**
- * @brief qed_chain_init - Initalizes a basic chain struct
- *
- * @param p_chain
- * @param p_virt_addr
- * @param p_phys_addr	physical address of allocated buffer's beginning
- * @param page_cnt	number of pages in the allocated buffer
- * @param elem_size	size of each element in the chain
- * @param intended_use
- * @param mode
- */
-static inline void qed_chain_init_params(struct qed_chain *p_chain,
-					 u32 page_cnt,
-					 u8 elem_size,
-					 enum qed_chain_use_mode intended_use,
-					 enum qed_chain_mode mode,
-					 enum qed_chain_cnt_type cnt_type)
-{
-	/* chain fixed parameters */
-	p_chain->p_virt_addr = NULL;
-	p_chain->p_phys_addr = 0;
-	p_chain->elem_size	= elem_size;
-	p_chain->intended_use = (u8)intended_use;
-	p_chain->mode		= mode;
-	p_chain->cnt_type = (u8)cnt_type;
-
-	p_chain->elem_per_page = ELEMS_PER_PAGE(elem_size);
-	p_chain->usable_per_page = USABLE_ELEMS_PER_PAGE(elem_size, mode);
-	p_chain->elem_per_page_mask = p_chain->elem_per_page - 1;
-	p_chain->elem_unusable = UNUSABLE_ELEMS_PER_PAGE(elem_size, mode);
-	p_chain->next_page_mask = (p_chain->usable_per_page &
-				   p_chain->elem_per_page_mask);
-
-	p_chain->page_cnt = page_cnt;
-	p_chain->capacity = p_chain->usable_per_page * page_cnt;
-	p_chain->size = p_chain->elem_per_page * page_cnt;
-
-	p_chain->pbl_sp.table_phys = 0;
-	p_chain->pbl_sp.table_virt = NULL;
-	p_chain->pbl.pp_addr_tbl = NULL;
-}
-
-/**
- * @brief qed_chain_init_mem -
- *
- * Initalizes a basic chain struct with its chain buffers
- *
- * @param p_chain
- * @param p_virt_addr	virtual address of allocated buffer's beginning
- * @param p_phys_addr	physical address of allocated buffer's beginning
- *
- */
-static inline void qed_chain_init_mem(struct qed_chain *p_chain,
-				      void *p_virt_addr, dma_addr_t p_phys_addr)
-{
-	p_chain->p_virt_addr = p_virt_addr;
-	p_chain->p_phys_addr = p_phys_addr;
-}
-
-/**
- * @brief qed_chain_init_pbl_mem -
- *
- * Initalizes a basic chain struct with its pbl buffers
- *
- * @param p_chain
- * @param p_virt_pbl	pointer to a pre allocated side table which will hold
- *                      virtual page addresses.
- * @param p_phys_pbl	pointer to a pre-allocated side table which will hold
- *                      physical page addresses.
- * @param pp_virt_addr_tbl
- *                      pointer to a pre-allocated side table which will hold
- *                      the virtual addresses of the chain pages.
- *
- */
-static inline void qed_chain_init_pbl_mem(struct qed_chain *p_chain,
-					  void *p_virt_pbl,
-					  dma_addr_t p_phys_pbl,
-					  struct addr_tbl_entry *pp_addr_tbl)
-{
-	p_chain->pbl_sp.table_phys = p_phys_pbl;
-	p_chain->pbl_sp.table_virt = p_virt_pbl;
-	p_chain->pbl.pp_addr_tbl = pp_addr_tbl;
-}
-
-/**
- * @brief qed_chain_init_next_ptr_elem -
- *
- * Initalizes a next pointer element
- *
- * @param p_chain
- * @param p_virt_curr	virtual address of a chain page of which the next
- *                      pointer element is initialized
- * @param p_virt_next	virtual address of the next chain page
- * @param p_phys_next	physical address of the next chain page
- *
- */
-static inline void
-qed_chain_init_next_ptr_elem(struct qed_chain *p_chain,
-			     void *p_virt_curr,
-			     void *p_virt_next, dma_addr_t p_phys_next)
-{
-	struct qed_chain_next *p_next;
-	u32 size;
-
-	size = p_chain->elem_size * p_chain->usable_per_page;
-	p_next = (struct qed_chain_next *)((u8 *)p_virt_curr + size);
-
-	DMA_REGPAIR_LE(p_next->next_phys, p_phys_next);
-
-	p_next->next_virt = p_virt_next;
-}
-
 /**
  * @brief qed_chain_get_last_elem -
  *
-- 
2.25.1

