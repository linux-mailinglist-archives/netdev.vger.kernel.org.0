Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779A81D2BFB
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 11:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgENJ6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 05:58:16 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53080 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726098AbgENJ6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 05:58:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04E9tZfr002436;
        Thu, 14 May 2020 02:58:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Nciajaxh1hJJ5WReEF7H0cG2B6dluuR4zClycv5nYF0=;
 b=sJ4b7QvUEz/lmzWnr/m7qVgt2/TgT+hhGRbzucUdFravl3TYZvPU5n+yrMyeNkHvpr9b
 ktRCCs1YD03IKgyJY35mAYhjqdFkPP8g/XYSi53qIGgD8uH5fy31aAgJaEUF+rK2BJS2
 ApBcFJNrYlzjQxVdv1aBs/GKXOiw+mPEV5ryW9Cew6Ur6XRgmV1v3SIkdnIpK3MJO0wE
 lhWm5vIaWAF1Wgi8aHmzvY0Kox82JO9BtzgnN3M6rwxB8xb1anr8QeB38htJENk5oear
 2tBnvG1mp2uBCtDnkrf7D2vFYDdFMiZOG05mvTJSN36JPbUUZBRnANA8H9fSfeAQmgXX ZQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 3100xahqfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 02:58:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 02:58:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 02:58:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 02:58:10 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 1F0803F7041;
        Thu, 14 May 2020 02:58:07 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        "Michal Kalderon" <michal.kalderon@marvell.com>
Subject: [PATCH v2 net-next 06/11] net: qed: attention clearing properties
Date:   Thu, 14 May 2020 12:57:22 +0300
Message-ID: <20200514095727.1361-7-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514095727.1361-1-irusskikh@marvell.com>
References: <20200514095727.1361-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_02:2020-05-13,2020-05-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On different hardware events we have to respond differently,
on some of hardware indications hw attention (error condition)
should be cleared by the driver to continue normal functioning.

Here we introduce attention clear flags, and put them on some
important events (in aeu_descs).

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h        |  3 +++
 drivers/net/ethernet/qlogic/qed/qed_int.c    | 22 ++++++++++++++++----
 drivers/net/ethernet/qlogic/qed/qed_int.h    | 11 ++++++++++
 drivers/net/ethernet/qlogic/qed/qed_main.c   |  7 ++++++-
 drivers/net/ethernet/qlogic/qede/qede_main.c |  6 ++++++
 include/linux/qed/qed_if.h                   |  9 ++++++++
 6 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 07f6ef930b52..66ed39d6f357 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -838,6 +838,9 @@ struct qed_dev {
 	/* Recovery */
 	bool recov_in_prog;
 
+	/* Indicates whether should prevent attentions from being reasserted */
+	bool attn_clr_en;
+
 	/* LLH info */
 	u8 ppfid_bitmap;
 	struct qed_llh_info *p_llh_info;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 1b1447b2f059..b7b974f0ef21 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -96,6 +96,7 @@ struct aeu_invert_reg_bit {
 #define ATTENTION_BB(value)             (value << ATTENTION_BB_SHIFT)
 #define ATTENTION_BB_DIFFERENT          BIT(23)
 
+#define ATTENTION_CLEAR_ENABLE          BIT(28)
 	unsigned int flags;
 
 	/* Callback to call if attention will be triggered */
@@ -371,6 +372,13 @@ static int qed_fw_assertion(struct qed_hwfn *p_hwfn)
 	return -EINVAL;
 }
 
+static int qed_general_attention_35(struct qed_hwfn *p_hwfn)
+{
+	DP_INFO(p_hwfn, "General attention 35!\n");
+
+	return 0;
+}
+
 #define QED_DORQ_ATTENTION_REASON_MASK  (0xfffff)
 #define QED_DORQ_ATTENTION_OPAQUE_MASK  (0xffff)
 #define QED_DORQ_ATTENTION_OPAQUE_SHIFT (0x0)
@@ -613,14 +621,15 @@ static struct aeu_invert_reg aeu_descs[NUM_ATTN_REGS] = {
 
 	{
 		{       /* After Invert 4 */
-			{"General Attention 32", ATTENTION_SINGLE,
-			 qed_fw_assertion,
+			{"General Attention 32", ATTENTION_SINGLE |
+			 ATTENTION_CLEAR_ENABLE, qed_fw_assertion,
 			 MAX_BLOCK_ID},
 			{"General Attention %d",
 			 (2 << ATTENTION_LENGTH_SHIFT) |
 			 (33 << ATTENTION_OFFSET_SHIFT), NULL, MAX_BLOCK_ID},
-			{"General Attention 35", ATTENTION_SINGLE,
-			 NULL, MAX_BLOCK_ID},
+			{"General Attention 35", ATTENTION_SINGLE |
+			 ATTENTION_CLEAR_ENABLE, qed_general_attention_35,
+			 MAX_BLOCK_ID},
 			{"NWS Parity",
 			 ATTENTION_PAR | ATTENTION_BB_DIFFERENT |
 			 ATTENTION_BB(AEU_INVERT_REG_SPECIAL_CNIG_0),
@@ -2361,6 +2370,11 @@ void qed_int_disable_post_isr_release(struct qed_dev *cdev)
 		cdev->hwfns[i].b_int_requested = false;
 }
 
+void qed_int_attn_clr_enable(struct qed_dev *cdev, bool clr_enable)
+{
+	cdev->attn_clr_en = clr_enable;
+}
+
 int qed_int_set_timer_res(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 			  u8 timer_res, u16 sb_id, bool tx)
 {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.h b/drivers/net/ethernet/qlogic/qed/qed_int.h
index 9ad568d93ae6..e09db3386367 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.h
@@ -190,6 +190,17 @@ void qed_int_get_num_sbs(struct qed_hwfn	*p_hwfn,
  */
 void qed_int_disable_post_isr_release(struct qed_dev *cdev);
 
+/**
+ * @brief qed_int_attn_clr_enable - sets whether the general behavior is
+ *        preventing attentions from being reasserted, or following the
+ *        attributes of the specific attention.
+ *
+ * @param cdev
+ * @param clr_enable
+ *
+ */
+void qed_int_attn_clr_enable(struct qed_dev *cdev, bool clr_enable);
+
 /**
  * @brief - Doorbell Recovery handler.
  *          Run doorbell recovery in case of PF overflow (and flush DORQ if
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index d7c9d94e4c59..83e798d4eebb 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -2491,10 +2491,14 @@ void qed_hw_error_occurred(struct qed_hwfn *p_hwfn,
 
 	DP_NOTICE(p_hwfn, "HW error occurred [%s]\n", err_str);
 
-	/* Call the HW error handler of the protocol driver
+	/* Call the HW error handler of the protocol driver.
+	 * If it is not available - perform a minimal handling of preventing
+	 * HW attentions from being reasserted.
 	 */
 	if (ops && ops->schedule_hw_err_handler)
 		ops->schedule_hw_err_handler(cookie, err_type);
+	else
+		qed_int_attn_clr_enable(p_hwfn->cdev, true);
 }
 
 static int qed_set_coalesce(struct qed_dev *cdev, u16 rx_coal, u16 tx_coal,
@@ -2718,6 +2722,7 @@ const struct qed_common_ops qed_common_ops_pass = {
 	.set_led = &qed_set_led,
 	.recovery_process = &qed_recovery_process,
 	.recovery_prolog = &qed_recovery_prolog,
+	.attn_clr_enable = &qed_int_attn_clr_enable,
 	.update_drv_state = &qed_update_drv_state,
 	.update_mac = &qed_update_mac,
 	.update_mtu = &qed_update_mtu,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index e67d5da23792..ee7662da6413 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -2516,6 +2516,8 @@ static void qede_recovery_handler(struct qede_dev *edev)
 
 static void qede_atomic_hw_err_handler(struct qede_dev *edev)
 {
+	struct qed_dev *cdev = edev->cdev;
+
 	DP_NOTICE(edev,
 		  "Generic non-sleepable HW error handling started - err_flags 0x%lx\n",
 		  edev->err_flags);
@@ -2523,6 +2525,10 @@ static void qede_atomic_hw_err_handler(struct qede_dev *edev)
 	/* Get a call trace of the flow that led to the error */
 	WARN_ON(test_bit(QEDE_ERR_WARN, &edev->err_flags));
 
+	/* Prevent HW attentions from being reasserted */
+	if (test_bit(QEDE_ERR_ATTN_CLR_EN, &edev->err_flags))
+		edev->ops->common->attn_clr_enable(cdev, true);
+
 	DP_NOTICE(edev, "Generic non-sleepable HW error handling is done\n");
 }
 
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 1b7d9548ee43..978e91e9ab65 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -1046,6 +1046,15 @@ struct qed_common_ops {
  */
 	int (*set_led)(struct qed_dev *cdev,
 		       enum qed_led_mode mode);
+
+/**
+ * @brief attn_clr_enable - Prevent attentions from being reasserted
+ *
+ * @param cdev
+ * @param clr_enable
+ */
+	void (*attn_clr_enable)(struct qed_dev *cdev, bool clr_enable);
+
 /**
  * @brief db_recovery_add - add doorbell information to the doorbell
  * recovery mechanism.
-- 
2.17.1

