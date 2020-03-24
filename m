Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 284FA1912BE
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgCXOTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:19:42 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63146 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727464AbgCXOTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:19:41 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OEAdRw017443;
        Tue, 24 Mar 2020 07:19:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=AJOql5yoGOPf2k7TOIU9hoLBZ0yo3+jqrmvIpwacCRU=;
 b=aLU/7BPK45GbVmFaADBkfTlDaZNUfUttr1fJpGCbBOy2/GifIZB72ftEVwNtSA9dETMk
 y38jese6zSBbcVARwaDKaWt6ERjPXsHuySlZH4SUj85dQgMPSSm5F+NrxpWrf3QMc14u
 ilSst9XcyoytGkBpya3cFGEngdRl0orSlcuCxsfo99dLT4ywNlkq0BfJfEFFwvE0AuxE
 QrdM/ZgdZpCGVQXQqM/mWOQidYgP81S2BiENqHPAr46AO651l1IxiXCS0EhwE4rCjo80
 yUx1rcM5J3mnfB9lv/ijgXcEGkkyMevEbftxA4TV0j675tvQ/YYWzlPzr1KghfDJgPrN kw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ywvkqsq17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 07:19:40 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Mar
 2020 07:19:38 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 24 Mar 2020 07:19:38 -0700
Received: from lb-tlvb-ybason.il.qlogic.org (unknown [10.5.221.176])
        by maili.marvell.com (Postfix) with ESMTP id 1D5303F703F;
        Tue, 24 Mar 2020 07:19:36 -0700 (PDT)
From:   Yuval Basson <ybason@marvell.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Yuval Basson <ybason@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>
Subject: [PATCH net-next 3/3] qed: Fix race condition between scheduling and destroying the slowpath workqueue
Date:   Tue, 24 Mar 2020 16:13:48 +0200
Message-ID: <20200324141348.7897-4-ybason@marvell.com>
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

Calling queue_delayed_work concurrently with
destroy_workqueue might race to an unexpected outcome -
scheduled task after wq is destroyed or other resources
(like ptt_pool) are freed (yields NULL pointer dereference).
cancel_delayed_work prevents the race by cancelling
the timer triggered for scheduling a new task.

Signed-off-by: Yuval Basson <ybason@marvell.com>
Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index fb13863..ade927d 100644
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
@@ -1126,7 +1123,7 @@ void qed_periodic_db_rec_start(struct qed_hwfn *p_hwfn)
 
 static void qed_slowpath_wq_stop(struct qed_dev *cdev)
 {
-	int i, sleep_count = QED_PERIODIC_DB_REC_WAIT_COUNT;
+	int i;
 
 	if (IS_VF(cdev))
 		return;
@@ -1139,13 +1136,7 @@ static void qed_slowpath_wq_stop(struct qed_dev *cdev)
 		clear_bit(QED_SLOWPATH_ACTIVE,
 			  &cdev->hwfns[i].slowpath_task_flags);
 
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

