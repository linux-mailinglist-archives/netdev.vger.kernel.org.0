Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4CF637A6
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 16:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfGIOTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 10:19:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27806 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfGIOTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 10:19:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69EG7nZ017350;
        Tue, 9 Jul 2019 07:19:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=CwQ3s0B+xuwLtK43tyBIfa7FV1IWsqPwmWK7npMynPY=;
 b=Ogvc3HcfcZVc0KKkT/3Shs8tyHJZ3G6fFqETqwaBbQ0cDTuHHxK92EWJP5JyQYmaGWpV
 b/DjznD2JORQxplcBe6Rs1UjDbn9qyoT14+bJtK44knmq5tQPpNBLm36VBPIZHRW3GGq
 vbrZoSbvhgQoYHnTYlxUPeWALh99TwIg2BLXLb96YiMnzBfPmtXIjwaxMtBDzUL6JBm6
 bm93M0xcJNJy+Ln+CUo4Xqv+EndiMuyaX7qA7SUlMvxH5jzlyTsKGrCK1fC/Y1RFmI09
 hpGZuP4yrqxojx6TbBY47VhFnHzn8M/PlMDFExp9Dn1+JauBBn2L68BsDQzcY/6PYRzP JA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tmn10hjyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 07:19:21 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 9 Jul
 2019 07:19:19 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 9 Jul 2019 07:19:19 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 6E7BB3F703F;
        Tue,  9 Jul 2019 07:19:17 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>, <galpress@amazon.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v6 rdma-next 6/6] RDMA/qedr: Add iWARP doorbell recovery support
Date:   Tue, 9 Jul 2019 17:17:35 +0300
Message-ID: <20190709141735.19193-7-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190709141735.19193-1-michal.kalderon@marvell.com>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_05:,,
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
index 8aed24b32de6..dc9ebbf625d2 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -234,6 +234,11 @@ struct qedr_ucontext {
 	bool db_rec;
 };
 
+union db_prod32 {
+	struct rdma_pwm_val16_data data;
+	u32 raw;
+};
+
 union db_prod64 {
 	struct rdma_pwm_val32_data data;
 	u64 raw;
@@ -265,6 +270,8 @@ struct qedr_userq {
 	struct qedr_user_db_rec *db_rec_data;
 	u64 db_rec_phys;
 	u64 db_rec_key;
+	void __iomem *db_rec_db2_addr;
+	union db_prod32 db_rec_db2_data;
 };
 
 struct qedr_cq {
@@ -300,11 +307,6 @@ struct qedr_pd {
 	struct qedr_ucontext *uctx;
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
index b0b9ec70f2fd..64190de4ce23 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1684,6 +1684,10 @@ static void qedr_cleanup_user(struct qedr_dev *dev, struct qedr_qp *qp)
 	if (qp->urq.db_rec_data)
 		qedr_db_recovery_del(dev, qp->urq.db_addr,
 				     &qp->urq.db_rec_data->db_data);
+
+	if (rdma_protocol_iwarp(&dev->ibdev, 1))
+		qedr_db_recovery_del(dev, qp->urq.db_rec_db2_addr,
+				     &qp->urq.db_rec_db2_data);
 }
 
 static int qedr_create_user_qp(struct qedr_dev *dev,
@@ -1758,6 +1762,17 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
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
@@ -1771,6 +1786,15 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
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
@@ -1811,7 +1835,13 @@ static int qedr_set_iwarp_db_info(struct qedr_dev *dev, struct qedr_qp *qp)
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
 
@@ -1940,8 +1970,13 @@ static void qedr_cleanup_kernel(struct qedr_dev *dev, struct qedr_qp *qp)
 
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

