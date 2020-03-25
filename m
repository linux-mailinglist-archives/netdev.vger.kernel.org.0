Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E235A193239
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 21:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgCYU4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 16:56:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59804 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727253AbgCYU4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 16:56:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PKuHBo019636;
        Wed, 25 Mar 2020 13:56:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=5TFVXJNf3MUIGDyL6nEu09CzeVHywB50kL/wBP23BqQ=;
 b=Acn9vJRpAc9vi2ETvPMxZ8KWehde2EjSVhqpz9muQkaWfDObeFX5tCMN3Zw3gy5I89G4
 3yLFjdBCThHVmOt8EUwgk9A+dzN1jw6sFiiK+/oTimSnYGdagrBHsV4748+OHnluK+uB
 hnx78yKJPYLd0fdtEHfv3UGYsTu+IOq111wGv56EQRRt1hg0kJCJwjx+0JdYl92KAzbg
 HhjxY7HmN0h/IgLOd1Wgvl3ihnquDII2xK7grmeiY0haLOAGX1iEZt21eEzWotCZjUKe
 d24qFFzvFdaU3NZRBdO0qsI0ftMsjkOSqisCvm9sZhBU55ZYyKrdlOXZ29B0S+j89QHp hQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9ntcmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 13:56:47 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 13:56:46 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 13:56:45 -0700
Received: from lb-tlvb-ybason.il.qlogic.org (unknown [10.5.221.176])
        by maili.marvell.com (Postfix) with ESMTP id C376E3F703F;
        Wed, 25 Mar 2020 13:56:44 -0700 (PDT)
From:   Yuval Basson <ybason@marvell.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Denis Bolotin <dbolotin@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Yuval Basson <ybason@marvell.com>
Subject: [PATCH v2 net-next] qed: Fix race condition between scheduling and destroying the slowpath workqueue
Date:   Wed, 25 Mar 2020 22:50:43 +0200
Message-ID: <20200325205043.23157-1-ybason@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_11:2020-03-24,2020-03-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling queue_delayed_work concurrently with
destroy_workqueue might race to an unexpected outcome -
scheduled task after wq is destroyed or other resources
(like ptt_pool) are freed (yields NULL pointer dereference).
cancel_delayed_work prevents the race by cancelling
the timer triggered for scheduling a new task.

Fixes: 59ccf86fe ("qed: Add driver infrastucture for handling mfw requests")
Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Yuval Basson <ybason@marvell.com>
---

Changes in v2:
- This patch is sent as a stand-alone after being part of a patch series where the first
  two patches were dropped https://www.spinics.net/lists/netdev/msg639940.html.

 drivers/net/ethernet/qlogic/qed/qed_main.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 2c189c6..96356e8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1087,9 +1087,6 @@ static void qed_update_pf_params(struct qed_dev *cdev,
 #define QED_PERIODIC_DB_REC_INTERVAL_MS		100
 #define QED_PERIODIC_DB_REC_INTERVAL \
 	msecs_to_jiffies(QED_PERIODIC_DB_REC_INTERVAL_MS)
-#define QED_PERIODIC_DB_REC_WAIT_COUNT		10
-#define QED_PERIODIC_DB_REC_WAIT_INTERVAL \
-	(QED_PERIODIC_DB_REC_INTERVAL_MS / QED_PERIODIC_DB_REC_WAIT_COUNT)
 
 static int qed_slowpath_delayed_work(struct qed_hwfn *hwfn,
 				     enum qed_slowpath_wq_flag wq_flag,
@@ -1123,7 +1120,7 @@ void qed_periodic_db_rec_start(struct qed_hwfn *p_hwfn)
 
 static void qed_slowpath_wq_stop(struct qed_dev *cdev)
 {
-	int i, sleep_count = QED_PERIODIC_DB_REC_WAIT_COUNT;
+	int i;
 
 	if (IS_VF(cdev))
 		return;
@@ -1135,13 +1132,7 @@ static void qed_slowpath_wq_stop(struct qed_dev *cdev)
 		/* Stop queuing new delayed works */
 		cdev->hwfns[i].slowpath_wq_active = false;
 
-		/* Wait until the last periodic doorbell recovery is executed */
-		while (test_bit(QED_SLOWPATH_PERIODIC_DB_REC,
-				&cdev->hwfns[i].slowpath_task_flags) &&
-		       sleep_count--)
-			msleep(QED_PERIODIC_DB_REC_WAIT_INTERVAL);
-
-		flush_workqueue(cdev->hwfns[i].slowpath_wq);
+		cancel_delayed_work(&cdev->hwfns[i].slowpath_task);
 		destroy_workqueue(cdev->hwfns[i].slowpath_wq);
 	}
 }
-- 
1.8.3.1

