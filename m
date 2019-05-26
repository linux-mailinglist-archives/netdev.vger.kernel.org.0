Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D502A9A9
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 14:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfEZMYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 08:24:08 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42710 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727793AbfEZMYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 08:24:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4QCNtBe028842;
        Sun, 26 May 2019 05:24:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=kFcOCEUtmRIPxXa4GVLGAHkBy8y9IAXOwmnnSpBUudU=;
 b=sWq70UVajvSJPi27fktlaJKUJNqBZx8EstyfhXPXW6LLjB+4i2AvPS/Vvy3sef2ekXFD
 R/rC9sOBOnA0IhMvhK/pYJJjat35EPf0tfhMVnZ5IfbuYbWi48uJZXGf/GW7BqoeGRVM
 9uqwgGIVpLOjlg5qEv076V7qtmwxG372a72+PGTiAHNlmGQCxotjHVAELMMDBK6GpY4+
 yZ1NOsjOR8sjJrB1M79ecaAGkMLeUAsuHM56jSAJCer+Jno69rkO9rtX2QFgu2NB7Jcr
 rPb5jIcVlDVPFn2lqJVIrL4f1tkVIXqlzuq58cXYj3EzKAX2xthS3g//QSEh+c4rc4X1 zg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2sqm7r11yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 26 May 2019 05:24:03 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 26 May
 2019 05:24:02 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Sun, 26 May 2019 05:24:02 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 636A63F703F;
        Sun, 26 May 2019 05:24:00 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <dledford@redhat.com>, <jgg@ziepe.ca>, <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Denis Bolotin <denis.bolotin@marvell.com>
Subject: [PATCH v2 net-next 06/11] qed: Set the doorbell address correctly
Date:   Sun, 26 May 2019 15:22:25 +0300
Message-ID: <20190526122230.30039-7-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190526122230.30039-1-michal.kalderon@marvell.com>
References: <20190526122230.30039-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-26_09:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In 100g mode the doorbell bar is united for both engines. Set
the correct offset in the hwfn so that the doorbell returned
for RoCE is in the affined hwfn.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Denis Bolotin <denis.bolotin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c  | 29 ++++++++++++++++++-----------
 drivers/net/ethernet/qlogic/qed/qed_rdma.c |  2 +-
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 640214cca1c6..61ca49a967df 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4426,6 +4426,7 @@ static void qed_nvm_info_free(struct qed_hwfn *p_hwfn)
 static int qed_hw_prepare_single(struct qed_hwfn *p_hwfn,
 				 void __iomem *p_regview,
 				 void __iomem *p_doorbells,
+				 u64 db_phys_addr,
 				 enum qed_pci_personality personality)
 {
 	struct qed_dev *cdev = p_hwfn->cdev;
@@ -4434,6 +4435,7 @@ static int qed_hw_prepare_single(struct qed_hwfn *p_hwfn,
 	/* Split PCI bars evenly between hwfns */
 	p_hwfn->regview = p_regview;
 	p_hwfn->doorbells = p_doorbells;
+	p_hwfn->db_phys_addr = db_phys_addr;
 
 	if (IS_VF(p_hwfn->cdev))
 		return qed_vf_hw_prepare(p_hwfn);
@@ -4529,7 +4531,9 @@ int qed_hw_prepare(struct qed_dev *cdev,
 	/* Initialize the first hwfn - will learn number of hwfns */
 	rc = qed_hw_prepare_single(p_hwfn,
 				   cdev->regview,
-				   cdev->doorbells, personality);
+				   cdev->doorbells,
+				   cdev->db_phys_addr,
+				   personality);
 	if (rc)
 		return rc;
 
@@ -4538,22 +4542,25 @@ int qed_hw_prepare(struct qed_dev *cdev,
 	/* Initialize the rest of the hwfns */
 	if (cdev->num_hwfns > 1) {
 		void __iomem *p_regview, *p_doorbell;
-		u8 __iomem *addr;
+		u64 db_phys_addr;
+		u32 offset;
 
 		/* adjust bar offset for second engine */
-		addr = cdev->regview +
-		       qed_hw_bar_size(p_hwfn, p_hwfn->p_main_ptt,
-				       BAR_ID_0) / 2;
-		p_regview = addr;
+		offset = qed_hw_bar_size(p_hwfn, p_hwfn->p_main_ptt,
+					 BAR_ID_0) / 2;
+		p_regview = cdev->regview + offset;
 
-		addr = cdev->doorbells +
-		       qed_hw_bar_size(p_hwfn, p_hwfn->p_main_ptt,
-				       BAR_ID_1) / 2;
-		p_doorbell = addr;
+		offset = qed_hw_bar_size(p_hwfn, p_hwfn->p_main_ptt,
+					 BAR_ID_1) / 2;
+
+		p_doorbell = cdev->doorbells + offset;
+
+		db_phys_addr = cdev->db_phys_addr + offset;
 
 		/* prepare second hw function */
 		rc = qed_hw_prepare_single(&cdev->hwfns[1], p_regview,
-					   p_doorbell, personality);
+					   p_doorbell, db_phys_addr,
+					   personality);
 
 		/* in case of error, need to free the previously
 		 * initiliazed hwfn 0.
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 4284374daa4f..e4d63359864e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -803,7 +803,7 @@ static int qed_rdma_add_user(void *rdma_cxt,
 				     dpi_start_offset +
 				     ((out_params->dpi) * p_hwfn->dpi_size));
 
-	out_params->dpi_phys_addr = p_hwfn->cdev->db_phys_addr +
+	out_params->dpi_phys_addr = p_hwfn->db_phys_addr +
 				    dpi_start_offset +
 				    ((out_params->dpi) * p_hwfn->dpi_size);
 
-- 
2.14.5

