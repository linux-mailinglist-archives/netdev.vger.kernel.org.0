Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3383B22A1EC
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733300AbgGVWMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:12:14 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57500 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733032AbgGVWMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:12:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MM6g1a019807;
        Wed, 22 Jul 2020 15:11:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=SVerhC+9GGCE5gDkusm4mu13mYnVROxSnyAfziKMekE=;
 b=e9jeHI8Eov7Zs2Gwygqzmai4Gh9mDnU6ymVAuEXra7CtntjwyJ0qtGt+AHwemuISADPu
 VbhMMdF6lxzVF9oArRTa7SB3BkXYVlOEkvvbvPK6qkRTzS15bGsX5DIT46eeVNO8r654
 VNXGpxZTQQY1t1Y2JcZvs6dHpihS07qcXiYH1GgmISatRBM6eBGA4QrpCJ8lngOErMYS
 xb4BFpA2u+l3JVSzerqF3WWE7YbirjJuebbgdtA74bepGJwZ4kgtMHPAb9OLJiKW2s3Q
 l1TlIbigo/DjusyMq92XDaA4e8+T1Rs13JaW3strRiSNZzn+JMvX6OZhQ7yzFv4W40K5 4w== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkt0mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 15:11:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 15:11:54 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 15:11:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 15:11:53 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 053243F7048;
        Wed, 22 Jul 2020 15:11:46 -0700 (PDT)
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
Subject: [PATCH v2 net-next 07/15] qed: simplify initialization of the chains with an external PBL
Date:   Thu, 23 Jul 2020 01:10:37 +0300
Message-ID: <20200722221045.5436-8-alobakin@marvell.com>
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
index b60ec3e4654c..6effee3b50f4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_chain.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_chain.c
@@ -11,7 +11,8 @@ static void qed_chain_init_params(struct qed_chain *chain,
 				  u32 page_cnt, u8 elem_size,
 				  enum qed_chain_use_mode intended_use,
 				  enum qed_chain_mode mode,
-				  enum qed_chain_cnt_type cnt_type)
+				  enum qed_chain_cnt_type cnt_type,
+				  const struct qed_chain_ext_pbl *ext_pbl)
 {
 	memset(chain, 0, sizeof(*chain));
 
@@ -31,6 +32,13 @@ static void qed_chain_init_params(struct qed_chain *chain,
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
@@ -230,8 +238,7 @@ static int qed_chain_alloc_single(struct qed_dev *cdev,
 	return 0;
 }
 
-static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain,
-			       struct qed_chain_ext_pbl *ext_pbl)
+static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain)
 {
 	struct device *dev = &cdev->pdev->dev;
 	struct addr_tbl_entry *addr_tbl;
@@ -253,21 +260,14 @@ static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain,
 
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
 
@@ -275,6 +275,7 @@ static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain,
 	chain->pbl_sp.table_phys = pbl_phys;
 	chain->pbl_sp.table_size = size;
 
+alloc_pages:
 	for (i = 0; i < page_cnt; i++) {
 		virt = dma_alloc_coherent(dev, QED_CHAIN_PAGE_SIZE, &phys,
 					  GFP_KERNEL);
@@ -325,7 +326,7 @@ int qed_chain_alloc(struct qed_dev *cdev,
 	}
 
 	qed_chain_init_params(chain, page_cnt, elem_size, intended_use, mode,
-			      cnt_type);
+			      cnt_type, ext_pbl);
 
 	switch (mode) {
 	case QED_CHAIN_MODE_NEXT_PTR:
@@ -335,7 +336,7 @@ int qed_chain_alloc(struct qed_dev *cdev,
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

