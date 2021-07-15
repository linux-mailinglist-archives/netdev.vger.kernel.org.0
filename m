Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B703C99DB
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 09:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbhGOHvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 03:51:36 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7014 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240489AbhGOHve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 03:51:34 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GQRDh4LS2zXtLQ;
        Thu, 15 Jul 2021 15:43:00 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 15:48:39 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 15 Jul 2021 15:48:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 2/9] net: hns3: add support for registering devlink for PF
Date:   Thu, 15 Jul 2021 15:45:03 +0800
Message-ID: <1626335110-50769-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1626335110-50769-1-git-send-email-huangguangbin2@huawei.com>
References: <1626335110-50769-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Add devlink register support for HNS3 ethernet PF driver.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c | 54 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h | 15 ++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 10 +++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  2 +
 5 files changed, 81 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
index a685392dbfe9..d1bf5c4c0abb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
@@ -7,6 +7,6 @@ ccflags-y := -I $(srctree)/drivers/net/ethernet/hisilicon/hns3
 ccflags-y += -I $(srctree)/$(src)
 
 obj-$(CONFIG_HNS3_HCLGE) += hclge.o
-hclge-objs = hclge_main.o hclge_cmd.o hclge_mdio.o hclge_tm.o hclge_mbx.o hclge_err.o  hclge_debugfs.o hclge_ptp.o
+hclge-objs = hclge_main.o hclge_cmd.o hclge_mdio.o hclge_tm.o hclge_mbx.o hclge_err.o  hclge_debugfs.o hclge_ptp.o hclge_devlink.o
 
 hclge-$(CONFIG_HNS3_DCB) += hclge_dcb.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
new file mode 100644
index 000000000000..03b822b0a8e7
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (c) 2021 Hisilicon Limited. */
+
+#include <net/devlink.h>
+
+#include "hclge_devlink.h"
+
+static const struct devlink_ops hclge_devlink_ops = {
+};
+
+int hclge_devlink_init(struct hclge_dev *hdev)
+{
+	struct pci_dev *pdev = hdev->pdev;
+	struct hclge_devlink_priv *priv;
+	struct devlink *devlink;
+	int ret;
+
+	devlink = devlink_alloc(&hclge_devlink_ops,
+				sizeof(struct hclge_devlink_priv));
+	if (!devlink)
+		return -ENOMEM;
+
+	priv = devlink_priv(devlink);
+	priv->hdev = hdev;
+
+	ret = devlink_register(devlink, &pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register devlink, ret = %d\n",
+			ret);
+		goto out_reg_fail;
+	}
+
+	hdev->devlink = devlink;
+
+	return 0;
+
+out_reg_fail:
+	devlink_free(devlink);
+	return ret;
+}
+
+void hclge_devlink_uninit(struct hclge_dev *hdev)
+{
+	struct devlink *devlink = hdev->devlink;
+
+	if (!devlink)
+		return;
+
+	devlink_unregister(devlink);
+
+	devlink_free(devlink);
+
+	hdev->devlink = NULL;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
new file mode 100644
index 000000000000..918be04507a5
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2021 Hisilicon Limited. */
+
+#ifndef __HCLGE_DEVLINK_H
+#define __HCLGE_DEVLINK_H
+
+#include "hclge_main.h"
+
+struct hclge_devlink_priv {
+	struct hclge_dev *hdev;
+};
+
+int hclge_devlink_init(struct hclge_dev *hdev);
+void hclge_devlink_uninit(struct hclge_dev *hdev);
+#endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dd3354a57c62..adc20d6a23c3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -23,6 +23,7 @@
 #include "hclge_tm.h"
 #include "hclge_err.h"
 #include "hnae3.h"
+#include "hclge_devlink.h"
 
 #define HCLGE_NAME			"hclge"
 #define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))
@@ -11478,10 +11479,14 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto out;
 
+	ret = hclge_devlink_init(hdev);
+	if (ret)
+		goto err_pci_uninit;
+
 	/* Firmware command queue initialize */
 	ret = hclge_cmd_queue_init(hdev);
 	if (ret)
-		goto err_pci_uninit;
+		goto err_devlink_uninit;
 
 	/* Firmware command initialize */
 	ret = hclge_cmd_init(hdev);
@@ -11654,6 +11659,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	pci_free_irq_vectors(pdev);
 err_cmd_uninit:
 	hclge_cmd_uninit(hdev);
+err_devlink_uninit:
+	hclge_devlink_uninit(hdev);
 err_pci_uninit:
 	pcim_iounmap(pdev, hdev->hw.io_base);
 	pci_clear_master(pdev);
@@ -12044,6 +12051,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	hclge_cmd_uninit(hdev);
 	hclge_misc_irq_uninit(hdev);
+	hclge_devlink_uninit(hdev);
 	hclge_pci_uninit(hdev);
 	mutex_destroy(&hdev->vport_lock);
 	hclge_uninit_vport_vlan_table(hdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 3d3352491dba..cc31b12904ad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -8,6 +8,7 @@
 #include <linux/phy.h>
 #include <linux/if_vlan.h>
 #include <linux/kfifo.h>
+#include <net/devlink.h>
 
 #include "hclge_cmd.h"
 #include "hclge_ptp.h"
@@ -943,6 +944,7 @@ struct hclge_dev {
 	cpumask_t affinity_mask;
 	struct irq_affinity_notify affinity_notify;
 	struct hclge_ptp *ptp;
+	struct devlink *devlink;
 };
 
 /* VPort level vlan tag configuration for TX direction */
-- 
2.8.1

