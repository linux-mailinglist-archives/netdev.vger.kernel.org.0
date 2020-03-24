Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398741912BC
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgCXOTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:19:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60316 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727223AbgCXOTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:19:37 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OEAiCo017480;
        Tue, 24 Mar 2020 07:19:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=StYw9Nn+QHHnHMBdWEp4CPugOfAxI4/0dSupbp2sta4=;
 b=OUWtuR6y4Z+R1iEk4sme/zBkmp+tKQwxET7RH0ze0WC0DsEDPv7YJT2RaqTjM9UGdVTw
 EkB4ob4jyPRHmtkedCeBUzfKMTybq1GvOMpBhilxPTu1QTUaqe/P/Wp3U3lJ2X9JF/6X
 mSLg71/8tal/tkM96tig/hYyMCKmI+eCxp+POKgZ1gNkhmL8e2wsS9D1/+ljG3VE2Hq1
 H0z8X1ZsN7YtpmuOZu9evLkhoB02OjykU0ekm+2yLmicQWglzRN0khOvFzR48vZe1Go1
 1R7gELQ+6S7jOoVQzyxU+vAjWpl7AI8K2RtdLVESPyz2fqqoGQODXKQk8AEUA6nX5VxB qA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ywvkqsq11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 07:19:35 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Mar
 2020 07:19:33 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 24 Mar 2020 07:19:33 -0700
Received: from lb-tlvb-ybason.il.qlogic.org (unknown [10.5.221.176])
        by maili.marvell.com (Postfix) with ESMTP id 84EC43F703F;
        Tue, 24 Mar 2020 07:19:32 -0700 (PDT)
From:   Yuval Basson <ybason@marvell.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Yuval Basson <ybason@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>
Subject: [PATCH net-next 1/3] qed: Replace wq_active Boolean with an atomic QED_SLOWPATH_ACTIVE flag
Date:   Tue, 24 Mar 2020 16:13:46 +0200
Message-ID: <20200324141348.7897-2-ybason@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200324141348.7897-1-ybason@marvell.com>
References: <20200324141348.7897-1-ybason@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_05:2020-03-23,2020-03-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The atomic opertaion might prevent a potential race condition.

Signed-off-by: Yuval Basson <ybason@marvell.com>
Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h      | 2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index fa41bf0..ca866c2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -565,6 +565,7 @@ struct qed_simd_fp_handler {
 enum qed_slowpath_wq_flag {
 	QED_SLOWPATH_MFW_TLV_REQ,
 	QED_SLOWPATH_PERIODIC_DB_REC,
+	QED_SLOWPATH_ACTIVE,
 };
 
 struct qed_hwfn {
@@ -700,7 +701,6 @@ struct qed_hwfn {
 	unsigned long iov_task_flags;
 #endif
 	struct z_stream_s *stream;
-	bool slowpath_wq_active;
 	struct workqueue_struct *slowpath_wq;
 	struct delayed_work slowpath_task;
 	unsigned long slowpath_task_flags;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 2c189c6..016d658 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1095,7 +1095,7 @@ static int qed_slowpath_delayed_work(struct qed_hwfn *hwfn,
 				     enum qed_slowpath_wq_flag wq_flag,
 				     unsigned long delay)
 {
-	if (!hwfn->slowpath_wq_active)
+	if (!test_bit(QED_SLOWPATH_ACTIVE, &hwfn->slowpath_task_flags))
 		return -EINVAL;
 
 	/* Memory barrier for setting atomic bit */
@@ -1133,7 +1133,8 @@ static void qed_slowpath_wq_stop(struct qed_dev *cdev)
 			continue;
 
 		/* Stop queuing new delayed works */
-		cdev->hwfns[i].slowpath_wq_active = false;
+		clear_bit(QED_SLOWPATH_ACTIVE,
+			  &cdev->hwfns[i].slowpath_task_flags);
 
 		/* Wait until the last periodic doorbell recovery is executed */
 		while (test_bit(QED_SLOWPATH_PERIODIC_DB_REC,
@@ -1153,7 +1154,7 @@ static void qed_slowpath_task(struct work_struct *work)
 	struct qed_ptt *ptt = qed_ptt_acquire(hwfn);
 
 	if (!ptt) {
-		if (hwfn->slowpath_wq_active)
+		if (test_bit(QED_SLOWPATH_ACTIVE, &hwfn->slowpath_task_flags))
 			queue_delayed_work(hwfn->slowpath_wq,
 					   &hwfn->slowpath_task, 0);
 
@@ -1199,7 +1200,7 @@ static int qed_slowpath_wq_start(struct qed_dev *cdev)
 		}
 
 		INIT_DELAYED_WORK(&hwfn->slowpath_task, qed_slowpath_task);
-		hwfn->slowpath_wq_active = true;
+		set_bit(QED_SLOWPATH_ACTIVE, &hwfn->slowpath_task_flags);
 	}
 
 	return 0;
-- 
1.8.3.1

