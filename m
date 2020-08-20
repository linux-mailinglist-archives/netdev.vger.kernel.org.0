Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D87924C5E1
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 20:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgHTSws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 14:52:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3838 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727998AbgHTSw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 14:52:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KITqMT029090;
        Thu, 20 Aug 2020 11:52:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=xTpoSCz6MiHdc8Ah/WmFCGfwUa+Adq1bTFDP9s6xe/4=;
 b=iSEXiWgenhJC5tsND5V7nvE5vT69QqOtMWSd905dhu/Dowg018mWNwPufhX75jI1JT0A
 HiOOx2WJ+Fsfqy3vG4e57Tj5UFR2icW+yTAJIMsBqaL3Y8CL9MXrJ+YoEtDL9ofB6Nn/
 vZftRfz/Gh2CIl2maBfKYT38dlDGyj1rdRNMy2pJ8Xq7ruN+SkfQ29AkiX3mn0QUJxCm
 M5ZYIqJ+0DLb6wdhtEj2z/i2b2wJiHFy0MbzBPCE1pdXSUdvFye355i+ATDGhf6QIL3u
 YRXhBU4+bYrP1ZUo4DN/Jop//qNJt+gfY8oy81K5nXtAuwu/c5rF4XBqv6cwYCukTrKD OA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fhxys8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Aug 2020 11:52:21 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Aug
 2020 11:52:21 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Aug
 2020 11:52:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Aug 2020 11:52:19 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 68D143F703F;
        Thu, 20 Aug 2020 11:52:17 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v6 net-next 02/10] qed/qede: make devlink survive recovery
Date:   Thu, 20 Aug 2020 21:51:56 +0300
Message-ID: <20200820185204.652-3-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200820185204.652-1-irusskikh@marvell.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink instance lifecycle was linked to qed_dev object,
that caused devlink to be recreated on each recovery.

Changing it by making higher level driver (qede) responsible for its
life. This way devlink now survives recoveries.

qede now stores devlink structure pointer as a part of its device
object, devlink private data contains a linkage structure,
qed_devlink.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h         |  1 -
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 40 ++++++++-----------
 drivers/net/ethernet/qlogic/qed/qed_devlink.h |  4 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 10 +----
 drivers/net/ethernet/qlogic/qede/qede.h       |  1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 18 +++++++++
 include/linux/qed/qed_if.h                    |  9 +++++
 7 files changed, 48 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index b2a7b53ee760..b6ce1488abcc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -849,7 +849,6 @@ struct qed_dev {
 	u32 rdma_max_srq_sge;
 	u16 tunn_feature_mask;
 
-	struct devlink			*dl;
 	bool				iwarp_cmt;
 };
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index eb693787c99e..a62c47c61edf 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/qed/qed_if.h>
 #include "qed.h"
 #include "qed_devlink.h"
 
@@ -13,17 +14,12 @@ enum qed_devlink_param_id {
 	QED_DEVLINK_PARAM_ID_IWARP_CMT,
 };
 
-struct qed_devlink {
-	struct qed_dev *cdev;
-};
-
 static int qed_dl_param_get(struct devlink *dl, u32 id,
 			    struct devlink_param_gset_ctx *ctx)
 {
-	struct qed_devlink *qed_dl;
+	struct qed_devlink *qed_dl = devlink_priv(dl);
 	struct qed_dev *cdev;
 
-	qed_dl = devlink_priv(dl);
 	cdev = qed_dl->cdev;
 	ctx->val.vbool = cdev->iwarp_cmt;
 
@@ -33,10 +29,9 @@ static int qed_dl_param_get(struct devlink *dl, u32 id,
 static int qed_dl_param_set(struct devlink *dl, u32 id,
 			    struct devlink_param_gset_ctx *ctx)
 {
-	struct qed_devlink *qed_dl;
+	struct qed_devlink *qed_dl = devlink_priv(dl);
 	struct qed_dev *cdev;
 
-	qed_dl = devlink_priv(dl);
 	cdev = qed_dl->cdev;
 	cdev->iwarp_cmt = ctx->val.vbool;
 
@@ -52,21 +47,19 @@ static const struct devlink_param qed_devlink_params[] = {
 
 static const struct devlink_ops qed_dl_ops;
 
-int qed_devlink_register(struct qed_dev *cdev)
+struct devlink *qed_devlink_register(struct qed_dev *cdev)
 {
 	union devlink_param_value value;
-	struct qed_devlink *qed_dl;
+	struct qed_devlink *qdevlink;
 	struct devlink *dl;
 	int rc;
 
-	dl = devlink_alloc(&qed_dl_ops, sizeof(*qed_dl));
+	dl = devlink_alloc(&qed_dl_ops, sizeof(struct qed_devlink));
 	if (!dl)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
-	qed_dl = devlink_priv(dl);
-
-	cdev->dl = dl;
-	qed_dl->cdev = cdev;
+	qdevlink = devlink_priv(dl);
+	qdevlink->cdev = cdev;
 
 	rc = devlink_register(dl, &cdev->pdev->dev);
 	if (rc)
@@ -85,26 +78,25 @@ int qed_devlink_register(struct qed_dev *cdev)
 	devlink_params_publish(dl);
 	cdev->iwarp_cmt = false;
 
-	return 0;
+	return dl;
 
 err_unregister:
 	devlink_unregister(dl);
 
 err_free:
-	cdev->dl = NULL;
 	devlink_free(dl);
 
-	return rc;
+	return ERR_PTR(rc);
 }
 
-void qed_devlink_unregister(struct qed_dev *cdev)
+void qed_devlink_unregister(struct devlink *devlink)
 {
-	if (!cdev->dl)
+	if (!devlink)
 		return;
 
-	devlink_params_unregister(cdev->dl, qed_devlink_params,
+	devlink_params_unregister(devlink, qed_devlink_params,
 				  ARRAY_SIZE(qed_devlink_params));
 
-	devlink_unregister(cdev->dl);
-	devlink_free(cdev->dl);
+	devlink_unregister(devlink);
+	devlink_free(devlink);
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.h b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
index b94c40e9b7c1..c79dc6bfa194 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
@@ -9,7 +9,7 @@
 #include <linux/qed/qed_if.h>
 #include <net/devlink.h>
 
-int qed_devlink_register(struct qed_dev *cdev);
-void qed_devlink_unregister(struct qed_dev *cdev);
+struct devlink *qed_devlink_register(struct qed_dev *cdev);
+void qed_devlink_unregister(struct devlink *devlink);
 
 #endif
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 8751355d9ef7..d6f76421379b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -539,12 +539,6 @@ static struct qed_dev *qed_probe(struct pci_dev *pdev,
 	}
 	DP_INFO(cdev, "PCI init completed successfully\n");
 
-	rc = qed_devlink_register(cdev);
-	if (rc) {
-		DP_INFO(cdev, "Failed to register devlink.\n");
-		goto err2;
-	}
-
 	rc = qed_hw_prepare(cdev, QED_PCI_DEFAULT);
 	if (rc) {
 		DP_ERR(cdev, "hw prepare failed\n");
@@ -574,8 +568,6 @@ static void qed_remove(struct qed_dev *cdev)
 
 	qed_set_power_state(cdev, PCI_D3hot);
 
-	qed_devlink_unregister(cdev);
-
 	qed_free_cdev(cdev);
 }
 
@@ -3012,6 +3004,8 @@ const struct qed_common_ops qed_common_ops_pass = {
 	.get_link = &qed_get_current_link,
 	.drain = &qed_drain,
 	.update_msglvl = &qed_init_dp,
+	.devlink_register = qed_devlink_register,
+	.devlink_unregister = qed_devlink_unregister,
 	.dbg_all_data = &qed_dbg_all_data,
 	.dbg_all_data_size = &qed_dbg_all_data_size,
 	.chain_alloc = &qed_chain_alloc,
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 803c1fcca8ad..1f0e7505a973 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -172,6 +172,7 @@ struct qede_dev {
 	struct qed_dev			*cdev;
 	struct net_device		*ndev;
 	struct pci_dev			*pdev;
+	struct devlink			*devlink;
 
 	u32				dp_module;
 	u8				dp_level;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 140a392a81bb..93071d41afe4 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1170,10 +1170,23 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
 			rc = -ENOMEM;
 			goto err2;
 		}
+
+		edev->devlink = qed_ops->common->devlink_register(cdev);
+		if (IS_ERR(edev->devlink)) {
+			DP_NOTICE(edev, "Cannot register devlink\n");
+			edev->devlink = NULL;
+			/* Go on, we can live without devlink */
+		}
 	} else {
 		struct net_device *ndev = pci_get_drvdata(pdev);
 
 		edev = netdev_priv(ndev);
+
+		if (edev && edev->devlink) {
+			struct qed_devlink *qdl = devlink_priv(edev->devlink);
+
+			qdl->cdev = cdev;
+		}
 		edev->cdev = cdev;
 		memset(&edev->stats, 0, sizeof(edev->stats));
 		memcpy(&edev->dev_info, &dev_info, sizeof(dev_info));
@@ -1296,6 +1309,11 @@ static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
 	qed_ops->common->slowpath_stop(cdev);
 	if (system_state == SYSTEM_POWER_OFF)
 		return;
+
+	if (mode != QEDE_REMOVE_RECOVERY && edev->devlink) {
+		qed_ops->common->devlink_unregister(edev->devlink);
+		edev->devlink = NULL;
+	}
 	qed_ops->common->remove(cdev);
 	edev->cdev = NULL;
 
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index cd6a5c7e56eb..d8368e1770df 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -21,6 +21,7 @@
 #include <linux/qed/common_hsi.h>
 #include <linux/qed/qed_chain.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <net/devlink.h>
 
 enum dcbx_protocol_type {
 	DCBX_PROTOCOL_ISCSI,
@@ -779,6 +780,10 @@ enum qed_nvm_flash_cmd {
 	QED_NVM_FLASH_CMD_NVM_MAX,
 };
 
+struct qed_devlink {
+	struct qed_dev *cdev;
+};
+
 struct qed_common_cb_ops {
 	void (*arfs_filter_op)(void *dev, void *fltr, u8 fw_rc);
 	void (*link_update)(void *dev, struct qed_link_output *link);
@@ -1137,6 +1142,10 @@ struct qed_common_ops {
  *
  */
 	int (*set_grc_config)(struct qed_dev *cdev, u32 cfg_id, u32 val);
+
+	struct devlink* (*devlink_register)(struct qed_dev *cdev);
+
+	void (*devlink_unregister)(struct devlink *devlink);
 };
 
 #define MASK_FIELD(_name, _value) \
-- 
2.17.1

