Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3FB24ED0D
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 13:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgHWLUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 07:20:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47446 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726871AbgHWLUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 07:20:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07NBKGSO010399;
        Sun, 23 Aug 2020 04:20:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=vQFSE/NvGXYm1YcXiOsLA0vf2zKE5NshoWm400IuEdI=;
 b=AG0nC6NxQV8BgzkC2RgN1bhkMawPhFIn95Dvj08o2RvCYN3m8FXhY+XTtx7YDvT0yxLJ
 nCg9F6Od3iFQRecG84epXMH02ig5VYwXPh5qo4hGq96zeapSnTCaepo5fs2/d7L3wlNw
 U2GX5oik4VOUKjHtQs7eJ43/8aun5Kr0evQ2Yb0mLZR4MmdKrOMBWpIMsopJW/oKU+1T
 oxh4FW5daaK8Wx21aDW0gUP0pAI6aEBllFa31zCVQg2B3gWt99w45ohgTloN62BIttqa
 KdPjzFbPCxtMkvGbfrT/shDWw0WcRp7SxXYfRTfBPfXk/QRRapVcuVFGTO8mqIhJtYHy Pg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 3330qpb9n3-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Aug 2020 04:20:17 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 23 Aug
 2020 04:20:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 23 Aug 2020 04:20:14 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 734F03F704B;
        Sun, 23 Aug 2020 04:20:11 -0700 (PDT)
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
Subject: [PATCH v7 net-next 05/10] qed: health reporter init deinit seq
Date:   Sun, 23 Aug 2020 14:19:29 +0300
Message-ID: <20200823111934.305-6-irusskikh@marvell.com>
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

Here we declare health reporter ops (empty for now)
and register these in qed probe and remove callbacks.

This way we get devlink attached to all kind of qed* PCI
device entities: networking or storage offload entity.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 34 +++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_devlink.h |  3 ++
 include/linux/qed/qed_if.h                    |  1 +
 3 files changed, 38 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index 47d54a96cbb9..8b2c72fa8c44 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -14,6 +14,36 @@ enum qed_devlink_param_id {
 	QED_DEVLINK_PARAM_ID_IWARP_CMT,
 };
 
+static const struct devlink_health_reporter_ops qed_fw_fatal_reporter_ops = {
+		.name = "fw_fatal",
+};
+
+#define QED_REPORTER_FW_GRACEFUL_PERIOD 1200000
+
+void qed_fw_reporters_create(struct devlink *devlink)
+{
+	struct qed_devlink *dl = devlink_priv(devlink);
+
+	dl->fw_reporter = devlink_health_reporter_create(devlink, &qed_fw_fatal_reporter_ops,
+							 QED_REPORTER_FW_GRACEFUL_PERIOD, dl);
+	if (IS_ERR(dl->fw_reporter)) {
+		DP_NOTICE(dl->cdev, "Failed to create fw reporter, err = %ld\n",
+			  PTR_ERR(dl->fw_reporter));
+		dl->fw_reporter = NULL;
+	}
+}
+
+void qed_fw_reporters_destroy(struct devlink *devlink)
+{
+	struct qed_devlink *dl = devlink_priv(devlink);
+	struct devlink_health_reporter *rep;
+
+	rep = dl->fw_reporter;
+
+	if (!IS_ERR_OR_NULL(rep))
+		devlink_health_reporter_destroy(rep);
+}
+
 static int qed_dl_param_get(struct devlink *dl, u32 id,
 			    struct devlink_param_gset_ctx *ctx)
 {
@@ -126,6 +156,8 @@ struct devlink *qed_devlink_register(struct qed_dev *cdev)
 	devlink_params_publish(dl);
 	cdev->iwarp_cmt = false;
 
+	qed_fw_reporters_create(dl);
+
 	return dl;
 
 err_unregister:
@@ -142,6 +174,8 @@ void qed_devlink_unregister(struct devlink *devlink)
 	if (!devlink)
 		return;
 
+	qed_fw_reporters_destroy(devlink);
+
 	devlink_params_unregister(devlink, qed_devlink_params,
 				  ARRAY_SIZE(qed_devlink_params));
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.h b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
index c79dc6bfa194..c68ecf778826 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
@@ -12,4 +12,7 @@
 struct devlink *qed_devlink_register(struct qed_dev *cdev);
 void qed_devlink_unregister(struct devlink *devlink);
 
+void qed_fw_reporters_create(struct devlink *devlink);
+void qed_fw_reporters_destroy(struct devlink *devlink);
+
 #endif
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index d8368e1770df..30fe06fe06a0 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -782,6 +782,7 @@ enum qed_nvm_flash_cmd {
 
 struct qed_devlink {
 	struct qed_dev *cdev;
+	struct devlink_health_reporter *fw_reporter;
 };
 
 struct qed_common_cb_ops {
-- 
2.17.1

