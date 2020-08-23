Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843B724ED0F
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 13:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgHWLUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 07:20:40 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59648 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726956AbgHWLUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 07:20:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07NBKFO9010359;
        Sun, 23 Aug 2020 04:20:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=m+XGFizQgb3ZU34gCAbu+pEtKM7Z15oYGfr4wO9ndic=;
 b=OOMBzGVzt+Yr0ESKbi/eGSf4MSlg5h+wrLD2yDc0ltN6LqfWP/mdUqx+h7/No7dWPrtA
 dLsycaJ5xHHoJI08AyjJjBWKOKACzjP0PYRnSQYoDJMVeBkEeoGFD7mIyUkJjjfGGZC3
 DjW3o84ptCDg7SABUS9FLG8/azAO9V/YgBbWnJeg2ZiPefNTjrdMz2Qf5xNZp0+zdP3B
 95vOPdN5VC2Cg2iipjD48HKqlObTc22lkEnZF3h646eJitsMNvwoYTypZM3TSdgNBWVO
 lZDMlyt+BtM8eOhhu2SOF7i/ibK+dpiLIPD6x5ZpZELqFFTdyk/UUjjmSlKJik9iONmc pg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3330qpb9nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Aug 2020 04:20:22 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 23 Aug
 2020 04:20:22 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 23 Aug
 2020 04:20:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 23 Aug 2020 04:20:21 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 196D23F704A;
        Sun, 23 Aug 2020 04:20:17 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v7 net-next 07/10] qed*: make use of devlink recovery infrastructure
Date:   Sun, 23 Aug 2020 14:19:31 +0300
Message-ID: <20200823111934.305-8-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200823111934.305-1-irusskikh@marvell.com>
References: <20200823111934.305-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-22_14:2020-08-21,2020-08-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove forcible recovery trigger and put it as a normal devlink
callback.

This allows user to enable/disable it via

    devlink health set pci/0000:03:00.0 reporter fw_fatal auto_recover false

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed.h         |  1 +
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 14 ++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_main.c    |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 10 ----------
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index ccd789eeda3e..f34b25a79449 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -981,6 +981,7 @@ void qed_bw_update(struct qed_hwfn *hwfn, struct qed_ptt *ptt);
 u32 qed_unzip_data(struct qed_hwfn *p_hwfn,
 		   u32 input_len, u8 *input_buf,
 		   u32 max_size, u8 *unzip_buf);
+int qed_recovery_process(struct qed_dev *cdev);
 void qed_schedule_recovery_handler(struct qed_hwfn *p_hwfn);
 void qed_hw_error_occurred(struct qed_hwfn *p_hwfn,
 			   enum qed_hw_err_type err_type);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index 4de786d4261b..bc4e40f135ff 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -32,8 +32,22 @@ int qed_report_fatal_error(struct devlink *devlink, enum qed_hw_err_type err_typ
 	return 0;
 }
 
+static int
+qed_fw_fatal_reporter_recover(struct devlink_health_reporter *reporter,
+			      void *priv_ctx,
+			      struct netlink_ext_ack *extack)
+{
+	struct qed_devlink *qdl = devlink_health_reporter_priv(reporter);
+	struct qed_dev *cdev = qdl->cdev;
+
+	qed_recovery_process(cdev);
+
+	return 0;
+}
+
 static const struct devlink_health_reporter_ops qed_fw_fatal_reporter_ops = {
 		.name = "fw_fatal",
+		.recover = qed_fw_fatal_reporter_recover,
 };
 
 #define QED_REPORTER_FW_GRACEFUL_PERIOD 1200000
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index a64d594f9294..db5d003770ba 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -2817,7 +2817,7 @@ static int qed_set_led(struct qed_dev *cdev, enum qed_led_mode mode)
 	return status;
 }
 
-static int qed_recovery_process(struct qed_dev *cdev)
+int qed_recovery_process(struct qed_dev *cdev)
 {
 	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
 	struct qed_ptt *p_ptt;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index bafdf46a9b1f..58e1a6e542eb 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -2595,8 +2595,6 @@ static void qede_atomic_hw_err_handler(struct qede_dev *edev)
 
 static void qede_generic_hw_err_handler(struct qede_dev *edev)
 {
-	struct qed_dev *cdev = edev->cdev;
-
 	DP_NOTICE(edev,
 		  "Generic sleepable HW error handling started - err_flags 0x%lx\n",
 		  edev->err_flags);
@@ -2604,14 +2602,6 @@ static void qede_generic_hw_err_handler(struct qede_dev *edev)
 	if (edev->devlink)
 		edev->ops->common->report_fatal_error(edev->devlink, edev->last_err_type);
 
-	/* Trigger a recovery process.
-	 * This is placed in the sleep requiring section just to make
-	 * sure it is the last one, and that all the other operations
-	 * were completed.
-	 */
-	if (test_bit(QEDE_ERR_IS_RECOVERABLE, &edev->err_flags))
-		edev->ops->common->recovery_process(cdev);
-
 	clear_bit(QEDE_ERR_IS_HANDLED, &edev->err_flags);
 
 	DP_NOTICE(edev, "Generic sleepable HW error handling is done\n");
-- 
2.17.1

