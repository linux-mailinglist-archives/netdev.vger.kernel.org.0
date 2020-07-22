Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A603229C4F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbgGVPzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:55:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34256 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733070AbgGVPzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:55:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MFUJuo010156;
        Wed, 22 Jul 2020 08:55:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=YdH18anOnOfotz7dCcu2Qk951gXqE+vLtMEFYOTUaAo=;
 b=K6stivlBJA9ez5HIR0uBC4lker25XNBaKRWPCUEDkcJlJnkmfW8XIcsdD2pnPjRFwzkN
 R9pQYcT0OnuZdPUE7cWOruRmxUOHu4UZos7h7F1EBq0AXuZ3vlME/AhBG+5bDNiCxyru
 tUVdmQu9u69fMi0gUXnqyJErysXDcKZVXCMex1/5XP1jjXnXHdZubDM4CI/kPXUzupBi
 ogrOCwCYuEzHHGRe+BDcxtHHCx/r+UfmgWroO/R/sMbySWEMt7fmiiNjoN2phGLRIEDd
 iYswtPli3j0j1gxBsAEqJfYXAgPIR3OzYeXxoXOSRHQ0QPe/OeYFDC75Jn9U/7Y+IiU0 iw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxensft2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 08:55:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 08:55:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 08:55:33 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 45AD23F7040;
        Wed, 22 Jul 2020 08:55:27 -0700 (PDT)
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
Subject: [PATCH net-next 10/15] qed: optimize common chain accessors
Date:   Wed, 22 Jul 2020 18:53:44 +0300
Message-ID: <20200722155349.747-11-alobakin@marvell.com>
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

Constify chain pointers and refactor qed_chain_get_elem_left{,u32}() a bit.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 include/linux/qed/qed_chain.h | 60 +++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index 8a96c361cc19..434479e2ab65 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -182,73 +182,79 @@ struct qed_chain_init_params {
 	((p)->cnt_type == QED_CHAIN_CNT_TYPE_U32)
 
 /* Accessors */
-static inline u16 qed_chain_get_prod_idx(struct qed_chain *p_chain)
+
+static inline u16 qed_chain_get_prod_idx(const struct qed_chain *chain)
+{
+	return chain->u.chain16.prod_idx;
+}
+
+static inline u16 qed_chain_get_cons_idx(const struct qed_chain *chain)
 {
-	return p_chain->u.chain16.prod_idx;
+	return chain->u.chain16.cons_idx;
 }
 
-static inline u16 qed_chain_get_cons_idx(struct qed_chain *p_chain)
+static inline u32 qed_chain_get_prod_idx_u32(const struct qed_chain *chain)
 {
-	return p_chain->u.chain16.cons_idx;
+	return chain->u.chain32.prod_idx;
 }
 
-static inline u32 qed_chain_get_cons_idx_u32(struct qed_chain *p_chain)
+static inline u32 qed_chain_get_cons_idx_u32(const struct qed_chain *chain)
 {
-	return p_chain->u.chain32.cons_idx;
+	return chain->u.chain32.cons_idx;
 }
 
-static inline u16 qed_chain_get_elem_left(struct qed_chain *p_chain)
+static inline u16 qed_chain_get_elem_left(const struct qed_chain *chain)
 {
-	u16 elem_per_page = p_chain->elem_per_page;
-	u32 prod = p_chain->u.chain16.prod_idx;
-	u32 cons = p_chain->u.chain16.cons_idx;
+	u32 prod = qed_chain_get_prod_idx(chain);
+	u32 cons = qed_chain_get_cons_idx(chain);
+	u16 elem_per_page = chain->elem_per_page;
 	u16 used;
 
 	if (prod < cons)
 		prod += (u32)U16_MAX + 1;
 
 	used = (u16)(prod - cons);
-	if (p_chain->mode == QED_CHAIN_MODE_NEXT_PTR)
-		used -= prod / elem_per_page - cons / elem_per_page;
+	if (chain->mode == QED_CHAIN_MODE_NEXT_PTR)
+		used -= (u16)(prod / elem_per_page - cons / elem_per_page);
 
-	return (u16)(p_chain->capacity - used);
+	return (u16)(chain->capacity - used);
 }
 
-static inline u32 qed_chain_get_elem_left_u32(struct qed_chain *p_chain)
+static inline u32 qed_chain_get_elem_left_u32(const struct qed_chain *chain)
 {
-	u16 elem_per_page = p_chain->elem_per_page;
-	u64 prod = p_chain->u.chain32.prod_idx;
-	u64 cons = p_chain->u.chain32.cons_idx;
+	u64 prod = qed_chain_get_prod_idx_u32(chain);
+	u64 cons = qed_chain_get_cons_idx_u32(chain);
+	u16 elem_per_page = chain->elem_per_page;
 	u32 used;
 
 	if (prod < cons)
 		prod += (u64)U32_MAX + 1;
 
 	used = (u32)(prod - cons);
-	if (p_chain->mode == QED_CHAIN_MODE_NEXT_PTR)
+	if (chain->mode == QED_CHAIN_MODE_NEXT_PTR)
 		used -= (u32)(prod / elem_per_page - cons / elem_per_page);
 
-	return p_chain->capacity - used;
+	return chain->capacity - used;
 }
 
-static inline u16 qed_chain_get_usable_per_page(struct qed_chain *p_chain)
+static inline u16 qed_chain_get_usable_per_page(const struct qed_chain *chain)
 {
-	return p_chain->usable_per_page;
+	return chain->usable_per_page;
 }
 
-static inline u8 qed_chain_get_unusable_per_page(struct qed_chain *p_chain)
+static inline u8 qed_chain_get_unusable_per_page(const struct qed_chain *chain)
 {
-	return p_chain->elem_unusable;
+	return chain->elem_unusable;
 }
 
-static inline u32 qed_chain_get_page_cnt(struct qed_chain *p_chain)
+static inline u32 qed_chain_get_page_cnt(const struct qed_chain *chain)
 {
-	return p_chain->page_cnt;
+	return chain->page_cnt;
 }
 
-static inline dma_addr_t qed_chain_get_pbl_phys(struct qed_chain *p_chain)
+static inline dma_addr_t qed_chain_get_pbl_phys(const struct qed_chain *chain)
 {
-	return p_chain->pbl_sp.table_phys;
+	return chain->pbl_sp.table_phys;
 }
 
 /**
-- 
2.25.1

