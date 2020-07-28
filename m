Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69092305F4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 10:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgG1I7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 04:59:14 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2216 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728195AbgG1I7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 04:59:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06S8u669016341;
        Tue, 28 Jul 2020 01:59:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=6oBkwcTKXsVAAh/y/hs+9UrcYEXtS8RdeKTd6QJsDCk=;
 b=L3HNpuyuHkjCN3kEpL9HdolsKdy6svZKQJrUVNk2A9fdCGOqUh9R/+SjJSOXa+gfVzOF
 IKzGYULrmIJu4Xk89serA2zsg/LBqqzW++8/8J8puE0wUOOtkRUJ0ibyJ8NF9lgRf45d
 78BdbrW2AwGHx7WQJ02CCVz3okUJqzJb5zjbY8G3pjNkei5fX2VkoPbcKA0PtqyQg8Kr
 M+Hv1/mFa/+3qxs+OUIIp7tvEQQz+xMj/BYA66soU6dJ04gMc0YKiDfrNVNesUyYH4WY
 H5AzIbDQLZnOldDnoQf59dT4ufFKdYnC2hkBYDBLEZH5vSixXRtOPwVGudZ8l34VFqJc Iw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32gm8njhgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Jul 2020 01:59:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 28 Jul
 2020 01:59:08 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 28 Jul
 2020 01:59:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 28 Jul 2020 01:59:07 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 838F63F703F;
        Tue, 28 Jul 2020 01:59:04 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v2 net-next 01/11] qed: move out devlink logic into a new file
Date:   Tue, 28 Jul 2020 11:58:49 +0300
Message-ID: <20200728085859.899-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728085859.899-1-irusskikh@marvell.com>
References: <20200728085859.899-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_01:2020-07-28,2020-07-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are extending devlink infrastructure, thus move the existing
stuff into a new file qed_devlink.c

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/Makefile      |   1 +
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 110 ++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_devlink.h |  15 +++
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 102 +---------------
 4 files changed, 127 insertions(+), 101 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.h

diff --git a/drivers/net/ethernet/qlogic/qed/Makefile b/drivers/net/ethernet/qlogic/qed/Makefile
index f947b105cf14..8251755ec18c 100644
--- a/drivers/net/ethernet/qlogic/qed/Makefile
+++ b/drivers/net/ethernet/qlogic/qed/Makefile
@@ -9,6 +9,7 @@ qed-y :=			\
 	qed_dcbx.o		\
 	qed_debug.o		\
 	qed_dev.o		\
+	qed_devlink.o		\
 	qed_hw.o		\
 	qed_init_fw_funcs.o	\
 	qed_init_ops.o		\
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
new file mode 100644
index 000000000000..eb693787c99e
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Marvell/Qlogic FastLinQ NIC driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#include <linux/kernel.h>
+#include "qed.h"
+#include "qed_devlink.h"
+
+enum qed_devlink_param_id {
+	QED_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	QED_DEVLINK_PARAM_ID_IWARP_CMT,
+};
+
+struct qed_devlink {
+	struct qed_dev *cdev;
+};
+
+static int qed_dl_param_get(struct devlink *dl, u32 id,
+			    struct devlink_param_gset_ctx *ctx)
+{
+	struct qed_devlink *qed_dl;
+	struct qed_dev *cdev;
+
+	qed_dl = devlink_priv(dl);
+	cdev = qed_dl->cdev;
+	ctx->val.vbool = cdev->iwarp_cmt;
+
+	return 0;
+}
+
+static int qed_dl_param_set(struct devlink *dl, u32 id,
+			    struct devlink_param_gset_ctx *ctx)
+{
+	struct qed_devlink *qed_dl;
+	struct qed_dev *cdev;
+
+	qed_dl = devlink_priv(dl);
+	cdev = qed_dl->cdev;
+	cdev->iwarp_cmt = ctx->val.vbool;
+
+	return 0;
+}
+
+static const struct devlink_param qed_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(QED_DEVLINK_PARAM_ID_IWARP_CMT,
+			     "iwarp_cmt", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     qed_dl_param_get, qed_dl_param_set, NULL),
+};
+
+static const struct devlink_ops qed_dl_ops;
+
+int qed_devlink_register(struct qed_dev *cdev)
+{
+	union devlink_param_value value;
+	struct qed_devlink *qed_dl;
+	struct devlink *dl;
+	int rc;
+
+	dl = devlink_alloc(&qed_dl_ops, sizeof(*qed_dl));
+	if (!dl)
+		return -ENOMEM;
+
+	qed_dl = devlink_priv(dl);
+
+	cdev->dl = dl;
+	qed_dl->cdev = cdev;
+
+	rc = devlink_register(dl, &cdev->pdev->dev);
+	if (rc)
+		goto err_free;
+
+	rc = devlink_params_register(dl, qed_devlink_params,
+				     ARRAY_SIZE(qed_devlink_params));
+	if (rc)
+		goto err_unregister;
+
+	value.vbool = false;
+	devlink_param_driverinit_value_set(dl,
+					   QED_DEVLINK_PARAM_ID_IWARP_CMT,
+					   value);
+
+	devlink_params_publish(dl);
+	cdev->iwarp_cmt = false;
+
+	return 0;
+
+err_unregister:
+	devlink_unregister(dl);
+
+err_free:
+	cdev->dl = NULL;
+	devlink_free(dl);
+
+	return rc;
+}
+
+void qed_devlink_unregister(struct qed_dev *cdev)
+{
+	if (!cdev->dl)
+		return;
+
+	devlink_params_unregister(cdev->dl, qed_devlink_params,
+				  ARRAY_SIZE(qed_devlink_params));
+
+	devlink_unregister(cdev->dl);
+	devlink_free(cdev->dl);
+}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.h b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
new file mode 100644
index 000000000000..b94c40e9b7c1
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Marvell/Qlogic FastLinQ NIC driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+#ifndef _QED_DEVLINK_H
+#define _QED_DEVLINK_H
+
+#include <linux/qed/qed_if.h>
+#include <net/devlink.h>
+
+int qed_devlink_register(struct qed_dev *cdev);
+void qed_devlink_unregister(struct qed_dev *cdev);
+
+#endif
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 2558cb680db3..8751355d9ef7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -39,6 +39,7 @@
 #include "qed_hw.h"
 #include "qed_selftest.h"
 #include "qed_debug.h"
+#include "qed_devlink.h"
 
 #define QED_ROCE_QPS			(8192)
 #define QED_ROCE_DPIS			(8)
@@ -510,107 +511,6 @@ static int qed_set_power_state(struct qed_dev *cdev, pci_power_t state)
 	return 0;
 }
 
-struct qed_devlink {
-	struct qed_dev *cdev;
-};
-
-enum qed_devlink_param_id {
-	QED_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
-	QED_DEVLINK_PARAM_ID_IWARP_CMT,
-};
-
-static int qed_dl_param_get(struct devlink *dl, u32 id,
-			    struct devlink_param_gset_ctx *ctx)
-{
-	struct qed_devlink *qed_dl;
-	struct qed_dev *cdev;
-
-	qed_dl = devlink_priv(dl);
-	cdev = qed_dl->cdev;
-	ctx->val.vbool = cdev->iwarp_cmt;
-
-	return 0;
-}
-
-static int qed_dl_param_set(struct devlink *dl, u32 id,
-			    struct devlink_param_gset_ctx *ctx)
-{
-	struct qed_devlink *qed_dl;
-	struct qed_dev *cdev;
-
-	qed_dl = devlink_priv(dl);
-	cdev = qed_dl->cdev;
-	cdev->iwarp_cmt = ctx->val.vbool;
-
-	return 0;
-}
-
-static const struct devlink_param qed_devlink_params[] = {
-	DEVLINK_PARAM_DRIVER(QED_DEVLINK_PARAM_ID_IWARP_CMT,
-			     "iwarp_cmt", DEVLINK_PARAM_TYPE_BOOL,
-			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
-			     qed_dl_param_get, qed_dl_param_set, NULL),
-};
-
-static const struct devlink_ops qed_dl_ops;
-
-static int qed_devlink_register(struct qed_dev *cdev)
-{
-	union devlink_param_value value;
-	struct qed_devlink *qed_dl;
-	struct devlink *dl;
-	int rc;
-
-	dl = devlink_alloc(&qed_dl_ops, sizeof(*qed_dl));
-	if (!dl)
-		return -ENOMEM;
-
-	qed_dl = devlink_priv(dl);
-
-	cdev->dl = dl;
-	qed_dl->cdev = cdev;
-
-	rc = devlink_register(dl, &cdev->pdev->dev);
-	if (rc)
-		goto err_free;
-
-	rc = devlink_params_register(dl, qed_devlink_params,
-				     ARRAY_SIZE(qed_devlink_params));
-	if (rc)
-		goto err_unregister;
-
-	value.vbool = false;
-	devlink_param_driverinit_value_set(dl,
-					   QED_DEVLINK_PARAM_ID_IWARP_CMT,
-					   value);
-
-	devlink_params_publish(dl);
-	cdev->iwarp_cmt = false;
-
-	return 0;
-
-err_unregister:
-	devlink_unregister(dl);
-
-err_free:
-	cdev->dl = NULL;
-	devlink_free(dl);
-
-	return rc;
-}
-
-static void qed_devlink_unregister(struct qed_dev *cdev)
-{
-	if (!cdev->dl)
-		return;
-
-	devlink_params_unregister(cdev->dl, qed_devlink_params,
-				  ARRAY_SIZE(qed_devlink_params));
-
-	devlink_unregister(cdev->dl);
-	devlink_free(cdev->dl);
-}
-
 /* probing */
 static struct qed_dev *qed_probe(struct pci_dev *pdev,
 				 struct qed_probe_params *params)
-- 
2.17.1

