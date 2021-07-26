Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30523D5162
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 04:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbhGZCKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 22:10:42 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:12261 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbhGZCKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 22:10:14 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GY45Y3Wttz1CNn0;
        Mon, 26 Jul 2021 10:44:49 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 26 Jul 2021 10:50:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 26 Jul 2021 10:50:41 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <moyufeng@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V3 net-next 3/7] net: hns3: add support for registering devlink for VF
Date:   Mon, 26 Jul 2021 10:47:03 +0800
Message-ID: <1627267627-38467-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1627267627-38467-1-git-send-email-huangguangbin2@huawei.com>
References: <1627267627-38467-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Add devlink register support for HNS3 ethernet VF driver.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    |  2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c        | 54 ++++++++++++++++++++++
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.h        | 15 ++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  8 ++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  3 ++
 5 files changed, 81 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.h

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
index 2c26ea607a53..51ff7d86ee90 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
@@ -7,4 +7,4 @@ ccflags-y := -I $(srctree)/drivers/net/ethernet/hisilicon/hns3
 ccflags-y += -I $(srctree)/$(src)
 
 obj-$(CONFIG_HNS3_HCLGEVF) += hclgevf.o
-hclgevf-objs = hclgevf_main.o hclgevf_cmd.o hclgevf_mbx.o
+hclgevf-objs = hclgevf_main.o hclgevf_cmd.o hclgevf_mbx.o  hclgevf_devlink.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
new file mode 100644
index 000000000000..55337a975981
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (c) 2021 Hisilicon Limited. */
+
+#include <net/devlink.h>
+
+#include "hclgevf_devlink.h"
+
+static const struct devlink_ops hclgevf_devlink_ops = {
+};
+
+int hclgevf_devlink_init(struct hclgevf_dev *hdev)
+{
+	struct pci_dev *pdev = hdev->pdev;
+	struct hclgevf_devlink_priv *priv;
+	struct devlink *devlink;
+	int ret;
+
+	devlink = devlink_alloc(&hclgevf_devlink_ops,
+				sizeof(struct hclgevf_devlink_priv));
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
+void hclgevf_devlink_uninit(struct hclgevf_dev *hdev)
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
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.h
new file mode 100644
index 000000000000..e09ea3d8a963
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2021 Hisilicon Limited. */
+
+#ifndef __HCLGEVF_DEVLINK_H
+#define __HCLGEVF_DEVLINK_H
+
+#include "hclgevf_main.h"
+
+struct hclgevf_devlink_priv {
+	struct hclgevf_dev *hdev;
+};
+
+int hclgevf_devlink_init(struct hclgevf_dev *hdev);
+void hclgevf_devlink_uninit(struct hclgevf_dev *hdev);
+#endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 8784d61e833f..3a19f08bfff3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -8,6 +8,7 @@
 #include "hclgevf_main.h"
 #include "hclge_mbx.h"
 #include "hnae3.h"
+#include "hclgevf_devlink.h"
 
 #define HCLGEVF_NAME	"hclgevf"
 
@@ -3337,6 +3338,10 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	if (ret)
 		return ret;
 
+	ret = hclgevf_devlink_init(hdev);
+	if (ret)
+		goto err_devlink_init;
+
 	ret = hclgevf_cmd_queue_init(hdev);
 	if (ret)
 		goto err_cmd_queue_init;
@@ -3441,6 +3446,8 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 err_cmd_init:
 	hclgevf_cmd_uninit(hdev);
 err_cmd_queue_init:
+	hclgevf_devlink_uninit(hdev);
+err_devlink_init:
 	hclgevf_pci_uninit(hdev);
 	clear_bit(HCLGEVF_STATE_IRQ_INITED, &hdev->state);
 	return ret;
@@ -3462,6 +3469,7 @@ static void hclgevf_uninit_hdev(struct hclgevf_dev *hdev)
 	}
 
 	hclgevf_cmd_uninit(hdev);
+	hclgevf_devlink_uninit(hdev);
 	hclgevf_pci_uninit(hdev);
 	hclgevf_uninit_mac_list(hdev);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index d7d02848d674..6f222a3a0bf2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -6,6 +6,7 @@
 #include <linux/fs.h>
 #include <linux/if_vlan.h>
 #include <linux/types.h>
+#include <net/devlink.h>
 #include "hclge_mbx.h"
 #include "hclgevf_cmd.h"
 #include "hnae3.h"
@@ -330,6 +331,8 @@ struct hclgevf_dev {
 	u32 flag;
 	unsigned long serv_processed_cnt;
 	unsigned long last_serv_processed;
+
+	struct devlink *devlink;
 };
 
 static inline bool hclgevf_is_reset_pending(struct hclgevf_dev *hdev)
-- 
2.8.1

