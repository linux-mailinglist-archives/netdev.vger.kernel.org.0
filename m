Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E218231D7B
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgG2LjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:39:15 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40604 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726858AbgG2LjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 07:39:13 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TBZxMY006688;
        Wed, 29 Jul 2020 04:39:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=pD9dVeRKATmDxXcbfn7NhMKl34uAnOytPddBa65wiO4=;
 b=RDRVMEe0gzguM/2O2u4++sKxn29fboWTCE16UY8IiNYfe/H8KNirkT8f04xsaaXgieIh
 ddhoXTNm5Vd6ISe2rBfcXDqlIn4OvIKxXrCKuLoHtX1GSOPHbH3rmSMY2lkbn0cxm2q7
 dx7CuGKVRr8k/ZNz9oLm6H53RdPDVFnYKXTNDDAJuCoT9opAR4QoAuQLE6aU0Hb3I2gp
 rgccm5sBCyECpZiW2d9mRxLSQ5OPXkdEMqU9rIOvGxZMEPrgEZctqT5Kk6hLfgu5ce0C
 4u+R4Gm2fj3PwTY6eZnsaJeAZpDhE8H5onuyMUZRYLnhdqiNnenl5M2VRnTG6Hvo8V41 KA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3r0r6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 04:39:11 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 04:39:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 04:39:10 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 4AAE43F7040;
        Wed, 29 Jul 2020 04:39:08 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v3 net-next 06/11] qed: health reporter init deinit seq
Date:   Wed, 29 Jul 2020 14:38:41 +0300
Message-ID: <20200729113846.1551-7-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200729113846.1551-1-irusskikh@marvell.com>
References: <20200729113846.1551-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_04:2020-07-29,2020-07-29 signatures=0
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
---
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 30 +++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_devlink.h |  3 ++
 include/linux/qed/qed_if.h                    |  1 +
 3 files changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index 5bd5528dc409..843a35f14cca 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -14,6 +14,34 @@ enum qed_devlink_param_id {
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
+	if (IS_ERR(dl->fw_reporter))
+		DP_NOTICE(dl->cdev, "Failed to create fw reporter, err = %ld\n",
+			  PTR_ERR(dl->fw_reporter));
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
@@ -144,6 +172,8 @@ void qed_devlink_unregister(struct devlink *devlink)
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

