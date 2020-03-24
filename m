Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC601912BD
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgCXOTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:19:39 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35336 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727769AbgCXOTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:19:38 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OEARi7015523;
        Tue, 24 Mar 2020 07:19:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=tz+0Oy1oseAKyHRCMNHycaB+NEa39ZNWpwVHfTPN4u0=;
 b=kUTS6cv4drNENMYBiEGQaFrBrEeT6npOgw4IH4RCeFxbbmlBAZGrxNpECM8qrBiUen/F
 5oQq7PJJwZoRARNlYmnerfr487EaUyB/7fIwmKsoBnaHTqvRmZWRAzDKwADG41bWW3ck
 PujS5/KqnPbvUab443afhJxn7OTBHNosQZfYRyX4xct1ZGdyGlXGgWnN/1U6dZrtl7bF
 fk8P879hgIh11cEGT/pay9nbwZ5m4+9+jIzS8WUdHwFZUfoggeADcs99eOCnSgoDPvIn
 CDr2R8tveHVAkcNv0MVUCGq+cbkFokxjdrAp//aQrTiLUaCdjUyHtvBxRKdGh3SmLqb0 8Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nkhbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 07:19:37 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Mar
 2020 07:19:36 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 24 Mar 2020 07:19:36 -0700
Received: from lb-tlvb-ybason.il.qlogic.org (unknown [10.5.221.176])
        by maili.marvell.com (Postfix) with ESMTP id BB8883F703F;
        Tue, 24 Mar 2020 07:19:34 -0700 (PDT)
From:   Yuval Basson <ybason@marvell.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Yuval Basson <ybason@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>
Subject: [PATCH net-next 2/3] qed: Add a flag for rescheduling the slowpath task
Date:   Tue, 24 Mar 2020 16:13:47 +0200
Message-ID: <20200324141348.7897-3-ybason@marvell.com>
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

Rechedule delayed work in case ptt_acquire failed.
Since it is the same task don't reset task's flags.

Signed-off-by: Yuval Basson <ybason@marvell.com>
Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h      |  1 +
 drivers/net/ethernet/qlogic/qed/qed_main.c | 15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index ca866c2..e3b238e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -566,6 +566,7 @@ enum qed_slowpath_wq_flag {
 	QED_SLOWPATH_MFW_TLV_REQ,
 	QED_SLOWPATH_PERIODIC_DB_REC,
 	QED_SLOWPATH_ACTIVE,
+	QED_SLOWPATH_RESCHEDULE,
 };
 
 struct qed_hwfn {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 016d658..fb13863 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1098,10 +1098,13 @@ static int qed_slowpath_delayed_work(struct qed_hwfn *hwfn,
 	if (!test_bit(QED_SLOWPATH_ACTIVE, &hwfn->slowpath_task_flags))
 		return -EINVAL;
 
-	/* Memory barrier for setting atomic bit */
-	smp_mb__before_atomic();
-	set_bit(wq_flag, &hwfn->slowpath_task_flags);
-	smp_mb__after_atomic();
+	if (wq_flag != QED_SLOWPATH_RESCHEDULE) {
+		/* Memory barrier for setting atomic bit */
+		smp_mb__before_atomic();
+		set_bit(wq_flag, &hwfn->slowpath_task_flags);
+		smp_mb__after_atomic();
+	}
+
 	queue_delayed_work(hwfn->slowpath_wq, &hwfn->slowpath_task, delay);
 
 	return 0;
@@ -1155,8 +1158,8 @@ static void qed_slowpath_task(struct work_struct *work)
 
 	if (!ptt) {
 		if (test_bit(QED_SLOWPATH_ACTIVE, &hwfn->slowpath_task_flags))
-			queue_delayed_work(hwfn->slowpath_wq,
-					   &hwfn->slowpath_task, 0);
+			qed_slowpath_delayed_work(hwfn,
+						  QED_SLOWPATH_RESCHEDULE, 0);
 
 		return;
 	}
-- 
1.8.3.1

