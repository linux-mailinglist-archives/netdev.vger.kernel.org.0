Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78183229C12
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733031AbgGVPzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:55:33 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2818 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733022AbgGVPzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:55:32 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MFUJum010156;
        Wed, 22 Jul 2020 08:55:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=UpCPSJ/iBdVZDvnXIc6xx5MbAVrLjyn3mzJWpCIxBzU=;
 b=H6BviFnmNMph1D57KUDgs7zWn1ghzMmiuzpIwRZWAqMogeVDZJjEGoulnOkcQJuNYyFJ
 n6T6VPewuRRgGlhYrBn/scavgNYnfW/f5esqpp9z9cSAlKYZT8SSGrf7xaVBN+3MTUD7
 2gBSMAKnoSxlyzZPrCKUXPrZzD7EpkRhJiRwFYjGyaykC1iMLNUoVm0m2jH9qPm6WQMK
 hE5Iy9gmIufi8nAd/Rid9EiOR4hhcdVujbyOokE5b62XriOFh0PX2sUEsCgpz5l97t/7
 M4pS5x4P2EGPjK0YVMel5OZDqPqhFTZGXM77rwp9l4AQP6VB9srgfUgMNFjOFlHN4YuK iQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxensfrm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 08:55:16 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 08:55:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 08:55:14 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 8C02F3F7040;
        Wed, 22 Jul 2020 08:55:08 -0700 (PDT)
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
Subject: [PATCH net-next 07/15] qed: simplify initialization of the chains with an external PBL
Date:   Wed, 22 Jul 2020 18:53:41 +0300
Message-ID: <20200722155349.747-8-alobakin@marvell.com>
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

Fill PBL table parameters for chains with an external PBL data earlier on
qed_chain_init_params() rather than on allocation itself. This simplifies
allocation code and allows to extend struct ext_pbl for other chain types.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_chain.c | 37 +++++++++++----------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_chain.c b/drivers/net/ethernet/qlogic/qed/qed_chain.c
index e2c5741ed160..2a61007442ae 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_chain.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_chain.c
@@ -9,7 +9,8 @@ static void qed_chain_init_params(struct qed_chain *chain,
 				  u32 page_cnt, u8 elem_size,
 				  enum qed_chain_use_mode intended_use,
 				  enum qed_chain_mode mode,
-				  enum qed_chain_cnt_type cnt_type)
+				  enum qed_chain_cnt_type cnt_type,
+				  const struct qed_chain_ext_pbl *ext_pbl)
 {
 	memset(chain, 0, sizeof(*chain));
 
@@ -29,6 +30,13 @@ static void qed_chain_init_params(struct qed_chain *chain,
 	chain->page_cnt = page_cnt;
 	chain->capacity = chain->usable_per_page * page_cnt;
 	chain->size = chain->elem_per_page * page_cnt;
+
+	if (ext_pbl && ext_pbl->p_pbl_virt) {
+		chain->pbl_sp.table_virt = ext_pbl->p_pbl_virt;
+		chain->pbl_sp.table_phys = ext_pbl->p_pbl_phys;
+
+		chain->b_external_pbl = true;
+	}
 }
 
 static void qed_chain_init_next_ptr_elem(const struct qed_chain *chain,
@@ -228,8 +236,7 @@ static int qed_chain_alloc_single(struct qed_dev *cdev,
 	return 0;
 }
 
-static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain,
-			       struct qed_chain_ext_pbl *ext_pbl)
+static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain)
 {
 	struct device *dev = &cdev->pdev->dev;
 	struct addr_tbl_entry *addr_tbl;
@@ -251,21 +258,14 @@ static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain,
 
 	chain->pbl.pp_addr_tbl = addr_tbl;
 
-	if (ext_pbl) {
-		size = 0;
-		pbl_virt = ext_pbl->p_pbl_virt;
-		pbl_phys = ext_pbl->p_pbl_phys;
+	if (chain->b_external_pbl)
+		goto alloc_pages;
 
-		chain->b_external_pbl = true;
-	} else {
-		size = array_size(page_cnt, sizeof(*pbl_virt));
-		if (unlikely(size == SIZE_MAX))
-			return -EOVERFLOW;
-
-		pbl_virt = dma_alloc_coherent(dev, size, &pbl_phys,
-					      GFP_KERNEL);
-	}
+	size = array_size(page_cnt, sizeof(*pbl_virt));
+	if (unlikely(size == SIZE_MAX))
+		return -EOVERFLOW;
 
+	pbl_virt = dma_alloc_coherent(dev, size, &pbl_phys, GFP_KERNEL);
 	if (!pbl_virt)
 		return -ENOMEM;
 
@@ -273,6 +273,7 @@ static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain,
 	chain->pbl_sp.table_phys = pbl_phys;
 	chain->pbl_sp.table_size = size;
 
+alloc_pages:
 	for (i = 0; i < page_cnt; i++) {
 		virt = dma_alloc_coherent(dev, QED_CHAIN_PAGE_SIZE, &phys,
 					  GFP_KERNEL);
@@ -323,7 +324,7 @@ int qed_chain_alloc(struct qed_dev *cdev,
 	}
 
 	qed_chain_init_params(chain, page_cnt, elem_size, intended_use, mode,
-			      cnt_type);
+			      cnt_type, ext_pbl);
 
 	switch (mode) {
 	case QED_CHAIN_MODE_NEXT_PTR:
@@ -333,7 +334,7 @@ int qed_chain_alloc(struct qed_dev *cdev,
 		rc = qed_chain_alloc_single(cdev, chain);
 		break;
 	case QED_CHAIN_MODE_PBL:
-		rc = qed_chain_alloc_pbl(cdev, chain, ext_pbl);
+		rc = qed_chain_alloc_pbl(cdev, chain);
 		break;
 	default:
 		return -EINVAL;
-- 
2.25.1

