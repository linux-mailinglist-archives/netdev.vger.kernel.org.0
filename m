Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCAE21268E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 16:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgGBOon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 10:44:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58070 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729047AbgGBOon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 10:44:43 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 062EZY2v001188;
        Thu, 2 Jul 2020 07:44:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=B3upgnUWY0uJY3pZ9pzqa9/MA57WpW4bsx/2g8URExs=;
 b=Dvu79jpf943sX4IcWDwSkQxIxlWjK10lvU/73u33x+hB0BPwC1hE7xDopMElTPhodiGd
 RK9UMIdCpqs+njNP/8bZLSCuHOkBUASTZptLmehVg5NV/xfxnVN3mTlB2SQvN2JLGduO
 nls1xR2Kk8NwU1Tx37amsWDc2ZlmABYxBmw/TdHusbHK9NUJBni4l/qY+agTnB2IFXNy
 7SaWvvrdofrvk82oo0lqKYm3AE2tBDqqyBWkUDBSg9428h0oT1oWP0peuPPKY/dbPYgt
 bJaqI/GGgOm+oV2ezxWo4cmS668TC94Of3JrrfHJSIsgAhECUjvGUclw8WPcVKqEbmge 7A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 31y0wsa3ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 07:44:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul
 2020 07:44:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul
 2020 07:44:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Jul 2020 07:44:40 -0700
Received: from sudarshana-rh72.punelab.qlogic.com. (unknown [10.30.45.63])
        by maili.marvell.com (Postfix) with ESMTP id 3AFA63F703F;
        Thu,  2 Jul 2020 07:44:38 -0700 (PDT)
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net 1/1] qed: Populate nvm-file attributes while reading nvm config partition.
Date:   Thu, 2 Jul 2020 20:14:35 +0530
Message-ID: <1593701075-14566-1-git-send-email-skalluru@marvell.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_09:2020-07-02,2020-07-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NVM config file address will be modified when the MBI image is upgraded.
Driver would return stale config values if user reads the nvm-config
(via ethtool -d) in this state. The fix is to re-populate nvm attribute
info while reading the nvm config values/partition.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c |  4 ++++
 drivers/net/ethernet/qlogic/qed/qed_dev.c   | 12 +++---------
 drivers/net/ethernet/qlogic/qed/qed_mcp.c   |  7 +++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h   |  7 +++++++
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index f4eebaa..a1270fd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -7930,6 +7930,10 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		DP_ERR(cdev, "qed_dbg_mcp_trace failed. rc = %d\n", rc);
 	}
 
+	/* Re-populate nvm attribute info */
+	qed_mcp_nvm_info_free(p_hwfn);
+	qed_mcp_nvm_info_populate(p_hwfn);
+
 	/* nvm cfg1 */
 	rc = qed_dbg_nvm_image(cdev,
 			       (u8 *)buffer + offset +
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 38a65b9..0331cce 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4461,12 +4461,6 @@ static int qed_get_dev_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	return 0;
 }
 
-static void qed_nvm_info_free(struct qed_hwfn *p_hwfn)
-{
-	kfree(p_hwfn->nvm_info.image_att);
-	p_hwfn->nvm_info.image_att = NULL;
-}
-
 static int qed_hw_prepare_single(struct qed_hwfn *p_hwfn,
 				 void __iomem *p_regview,
 				 void __iomem *p_doorbells,
@@ -4551,7 +4545,7 @@ static int qed_hw_prepare_single(struct qed_hwfn *p_hwfn,
 	return rc;
 err3:
 	if (IS_LEAD_HWFN(p_hwfn))
-		qed_nvm_info_free(p_hwfn);
+		qed_mcp_nvm_info_free(p_hwfn);
 err2:
 	if (IS_LEAD_HWFN(p_hwfn))
 		qed_iov_free_hw_info(p_hwfn->cdev);
@@ -4612,7 +4606,7 @@ int qed_hw_prepare(struct qed_dev *cdev,
 		if (rc) {
 			if (IS_PF(cdev)) {
 				qed_init_free(p_hwfn);
-				qed_nvm_info_free(p_hwfn);
+				qed_mcp_nvm_info_free(p_hwfn);
 				qed_mcp_free(p_hwfn);
 				qed_hw_hwfn_free(p_hwfn);
 			}
@@ -4646,7 +4640,7 @@ void qed_hw_remove(struct qed_dev *cdev)
 
 	qed_iov_free_hw_info(cdev);
 
-	qed_nvm_info_free(p_hwfn);
+	qed_mcp_nvm_info_free(p_hwfn);
 }
 
 static void qed_chain_free_next_ptr(struct qed_dev *cdev,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 280527c..99548d5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3151,6 +3151,13 @@ int qed_mcp_nvm_info_populate(struct qed_hwfn *p_hwfn)
 	return rc;
 }
 
+void qed_mcp_nvm_info_free(struct qed_hwfn *p_hwfn)
+{
+	kfree(p_hwfn->nvm_info.image_att);
+	p_hwfn->nvm_info.image_att = NULL;
+	p_hwfn->nvm_info.valid = false;
+}
+
 int
 qed_mcp_get_nvm_image_att(struct qed_hwfn *p_hwfn,
 			  enum qed_nvm_images image_id,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index 9c4c276..e382973 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -1193,6 +1193,13 @@ void qed_mcp_resc_lock_default_init(struct qed_resc_lock_params *p_lock,
 int qed_mcp_nvm_info_populate(struct qed_hwfn *p_hwfn);
 
 /**
+ * @brief Delete nvm info shadow in the given hardware function
+ *
+ * @param p_hwfn
+ */
+void qed_mcp_nvm_info_free(struct qed_hwfn *p_hwfn);
+
+/**
  * @brief Get the engine affinity configuration.
  *
  * @param p_hwfn
-- 
1.8.3.1

