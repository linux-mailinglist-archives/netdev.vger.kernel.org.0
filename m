Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F53508ED
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbfFXK3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:29:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4204 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726716AbfFXK3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:29:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OATM0M025693;
        Mon, 24 Jun 2019 03:29:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=FAZZhQ5fv6TXabPyvi4g0Alx5MM8DK14uXaAXhV3Jos=;
 b=AQQYtdrwOiI86ddUBbRiC93YoWXRMf6JMXTRNstWTYkTh5wZzUQNLjrmIQcw3k8DA8TJ
 koCEgprgD1hQwfhopyyqjG/aqML3o+roVqO3kK+OZzPEy06E0aCdRnJ5pqKcAZ7O2YKp
 PH36PGD1aiznbNEpLz8T3jnsbNEpumdpcSy6moW19Sou293MNbN+wB73pekBjiyu1lJP
 bgp+IMLmZCaVVlwBc3sfDsVvuWvwhEcOEZql44B8qzrqHp7YN68aBZsR7bdIgv/M6i3Y
 +NQ1bgUOsK8J0Gjh9dzLpbJNWjGgXd7dA+fBLc6AWVrW9PgohyFrfS8SJfteVd2PkGdk lA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tarxr8tks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 03:29:45 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 24 Jun
 2019 03:29:44 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 24 Jun 2019 03:29:44 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 5D96B3F7040;
        Mon, 24 Jun 2019 03:29:42 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 rdma-next 3/3] RDMA/qedr: Add iWARP doorbell recovery support
Date:   Mon, 24 Jun 2019 13:28:09 +0300
Message-ID: <20190624102809.8793-4-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190624102809.8793-1-michal.kalderon@marvell.com>
References: <20190624102809.8793-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_08:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the iWARP specific doorbells to the doorbell
recovery mechanism

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/qedr.h  | 12 +++++++-----
 drivers/infiniband/hw/qedr/verbs.c | 37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 006712ac1c88..6c5524d6b04e 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -238,6 +238,11 @@ struct qedr_ucontext {
 	struct mutex mm_list_lock;
 };
 
+union db_prod32 {
+	struct rdma_pwm_val16_data data;
+	u32 raw;
+};
+
 union db_prod64 {
 	struct rdma_pwm_val32_data data;
 	u64 raw;
@@ -268,6 +273,8 @@ struct qedr_userq {
 	void __iomem *db_addr;
 	struct qedr_user_db_rec *db_rec_data;
 	u64 db_rec_phys;
+	void __iomem *db_rec_db2_addr;
+	union db_prod32 db_rec_db2_data;
 };
 
 struct qedr_cq {
@@ -317,11 +324,6 @@ struct qedr_mm {
 	struct list_head entry;
 };
 
-union db_prod32 {
-	struct rdma_pwm_val16_data data;
-	u32 raw;
-};
-
 struct qedr_qp_hwq_info {
 	/* WQE Elements */
 	struct qed_chain pbl;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index cbf4cccd174d..c15196ce9662 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1767,6 +1767,10 @@ static void qedr_cleanup_user(struct qedr_dev *dev, struct qedr_qp *qp)
 				     &qp->urq.db_rec_data->db_data);
 		free_page((unsigned long)qp->urq.db_rec_data);
 	}
+
+	if (rdma_protocol_iwarp(&dev->ibdev, 1))
+		qedr_db_recovery_del(dev, qp->urq.db_rec_db2_addr,
+				     &qp->urq.db_rec_db2_data);
 }
 
 static int qedr_create_user_qp(struct qedr_dev *dev,
@@ -1841,6 +1845,17 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	qp->usq.db_addr = ctx->dpi_addr + uresp.sq_db_offset;
 	qp->urq.db_addr = ctx->dpi_addr + uresp.rq_db_offset;
 
+	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
+		qp->urq.db_rec_db2_addr = ctx->dpi_addr + uresp.rq_db2_offset;
+
+		/* calculate the db_rec_db2 data since it is constant so no
+		 *  need to reflect from user
+		 */
+		qp->urq.db_rec_db2_data.data.icid = cpu_to_le16(qp->icid);
+		qp->urq.db_rec_db2_data.data.value =
+			cpu_to_le16(DQ_TCM_IWARP_POST_RQ_CF_CMD);
+	}
+
 	rc = qedr_db_recovery_add(dev, qp->usq.db_addr,
 				  &qp->usq.db_rec_data->db_data,
 				  DB_REC_WIDTH_32B,
@@ -1854,6 +1869,15 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 				  DB_REC_USER);
 	if (rc)
 		goto err;
+
+	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
+		rc = qedr_db_recovery_add(dev, qp->urq.db_rec_db2_addr,
+					  &qp->urq.db_rec_db2_data,
+					  DB_REC_WIDTH_32B,
+					  DB_REC_USER);
+		if (rc)
+			goto err;
+	}
 	qedr_qp_user_print(dev, qp);
 
 	return rc;
@@ -1894,7 +1918,13 @@ static int qedr_set_iwarp_db_info(struct qedr_dev *dev, struct qedr_qp *qp)
 				  &qp->rq.db_data,
 				  DB_REC_WIDTH_32B,
 				  DB_REC_KERNEL);
+	if (rc)
+		return rc;
 
+	rc = qedr_db_recovery_add(dev, qp->rq.iwarp_db2,
+				  &qp->rq.iwarp_db2_data,
+				  DB_REC_WIDTH_32B,
+				  DB_REC_KERNEL);
 	return rc;
 }
 
@@ -2023,8 +2053,13 @@ static void qedr_cleanup_kernel(struct qedr_dev *dev, struct qedr_qp *qp)
 
 	qedr_db_recovery_del(dev, qp->sq.db, &qp->sq.db_data);
 
-	if (!qp->srq)
+	if (!qp->srq) {
 		qedr_db_recovery_del(dev, qp->rq.db, &qp->rq.db_data);
+
+		if (rdma_protocol_iwarp(&dev->ibdev, 1))
+			qedr_db_recovery_del(dev, qp->rq.iwarp_db2,
+					     &qp->rq.iwarp_db2_data);
+	}
 }
 
 static int qedr_create_kernel_qp(struct qedr_dev *dev,
-- 
2.14.5

