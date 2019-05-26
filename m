Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15DCF2A9AB
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 14:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfEZMYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 08:24:13 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40594 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727577AbfEZMYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 08:24:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4QCKcvZ000645;
        Sun, 26 May 2019 05:24:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=UaxcEuIzqTFWsmPpQTeI9UrKIOvmbVQJ5BlfSMV2pBc=;
 b=ml8YDDqOhds/au96Z1MQJHNonNeh0ttfCqwMDIpUXTzxBYrcjU2C+ei9bKBXUr6vcjFN
 oes442R1T9TjyQNxvuNno1gyITJcYae633sOlNOJG017+u7MAZaAzPj44iJMVwCpmMyS
 IJKF2p4uyzM8njxXsr7wR+AfyldnYvw7CDkQesfsq46gPGJbr6PWS6dhfHefykca/yPP
 ygRg+RBBXSyOIfcwdPa4E72da/bAS8WP6zAugi7a1igiLxjeOTVacDFQiF3Svvhgse79
 oL517CgUVLPS8qmEvcmUyVF3gaCijVsjkeNPeVyAemA/8fAsNbK3rcr3Km0kO4kdoHkB Pg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2sq57fubtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 26 May 2019 05:24:06 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 26 May
 2019 05:24:05 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Sun, 26 May 2019 05:24:05 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 2409A3F7040;
        Sun, 26 May 2019 05:24:02 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <dledford@redhat.com>, <jgg@ziepe.ca>, <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 net-next 07/11] qed: Add qed devlink parameters table
Date:   Sun, 26 May 2019 15:22:26 +0300
Message-ID: <20190526122230.30039-8-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190526122230.30039-1-michal.kalderon@marvell.com>
References: <20190526122230.30039-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-26_08:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The table currently contains a single parameter for
configuring whether iWARP should be enabled on a 100g
device. Enabling iWARP on a 100g device impacts L2
performance and is therefore not enabled by default.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h      |   3 +
 drivers/net/ethernet/qlogic/qed/qed_main.c | 110 +++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index e8e8d7c4af5a..89fe091c958d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -863,6 +863,9 @@ struct qed_dev {
 	u32 rdma_max_inline;
 	u32 rdma_max_srq_sge;
 	u16 tunn_feature_mask;
+
+	struct devlink			*dl;
+	bool				iwarp_cmt;
 };
 
 #define NUM_OF_VFS(dev)         (QED_IS_BB(dev) ? MAX_NUM_VFS_BB \
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 7f19fefe0d79..829dd60ab937 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -48,6 +48,7 @@
 #include <linux/crc32.h>
 #include <linux/qed/qed_if.h>
 #include <linux/qed/qed_ll2_if.h>
+#include <net/devlink.h>
 
 #include "qed.h"
 #include "qed_sriov.h"
@@ -342,6 +343,107 @@ static int qed_set_power_state(struct qed_dev *cdev, pci_power_t state)
 	return 0;
 }
 
+struct qed_devlink {
+	struct qed_dev *cdev;
+};
+
+enum qed_devlink_param_id {
+	QED_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	QED_DEVLINK_PARAM_ID_IWARP_CMT,
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
+static int qed_devlink_register(struct qed_dev *cdev)
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
+static void qed_devlink_unregister(struct qed_dev *cdev)
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
+
 /* probing */
 static struct qed_dev *qed_probe(struct pci_dev *pdev,
 				 struct qed_probe_params *params)
@@ -370,6 +472,12 @@ static struct qed_dev *qed_probe(struct pci_dev *pdev,
 	}
 	DP_INFO(cdev, "PCI init completed successfully\n");
 
+	rc = qed_devlink_register(cdev);
+	if (rc) {
+		DP_INFO(cdev, "Failed to register devlink.\n");
+		goto err2;
+	}
+
 	rc = qed_hw_prepare(cdev, QED_PCI_DEFAULT);
 	if (rc) {
 		DP_ERR(cdev, "hw prepare failed\n");
@@ -399,6 +507,8 @@ static void qed_remove(struct qed_dev *cdev)
 
 	qed_set_power_state(cdev, PCI_D3hot);
 
+	qed_devlink_unregister(cdev);
+
 	qed_free_cdev(cdev);
 }
 
-- 
2.14.5

