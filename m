Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB633BC6C6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 08:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhGFGrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 02:47:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:14018 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhGFGrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 02:47:37 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GJtJ95wS5zZnqj;
        Tue,  6 Jul 2021 14:41:45 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 6 Jul 2021 14:44:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 6 Jul 2021 14:44:56 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>
Subject: [RFC PATCH net-next 8/8] net: hns3: add support for VF setting rx/tx buffer size by devlink param
Date:   Tue, 6 Jul 2021 14:41:32 +0800
Message-ID: <1625553692-2773-9-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1625553692-2773-1-git-send-email-huangguangbin2@huawei.com>
References: <1625553692-2773-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Add support for VF setting rx/tx buffer size by devlink param

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c        | 89 +++++++++++++++++++++-
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.h        |  7 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  3 +
 3 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index 53b0b8931325..2092ef1a337e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -32,6 +32,37 @@ static int hclgevf_devlink_info_get(struct devlink *devlink,
 	return devlink_info_version_running_put(req, "fw-version", version_str);
 }
 
+static void hclgevf_devlink_get_param_setting(struct devlink *devlink)
+{
+	struct hclgevf_devlink_priv *priv = devlink_priv(devlink);
+	struct hclgevf_dev *hdev = priv->hdev;
+	struct pci_dev *pdev = hdev->pdev;
+	union devlink_param_value val;
+	int i, ret;
+
+	ret = devlink_param_driverinit_value_get(devlink,
+						 HCLGEVF_DEVLINK_PARAM_ID_RX_BUF_LEN,
+						 &val);
+	if (!ret) {
+		hdev->rx_buf_len = val.vu32;
+		hdev->nic.kinfo.rx_buf_len = hdev->rx_buf_len;
+		for (i = 0; i < hdev->num_tqps; i++)
+			hdev->htqp[i].q.buf_size = hdev->rx_buf_len;
+	} else {
+		dev_err(&pdev->dev,
+			"failed to get rx buffer size, ret = %d\n", ret);
+	}
+
+	ret = devlink_param_driverinit_value_get(devlink,
+						 HCLGEVF_DEVLINK_PARAM_ID_TX_BUF_SIZE,
+						 &val);
+	if (!ret)
+		hdev->nic.kinfo.devlink_tx_spare_buf_size = val.vu32;
+	else
+		dev_err(&pdev->dev,
+			"failed to get tx buffer size, ret = %d\n", ret);
+}
+
 static int hclgevf_devlink_reload_down(struct devlink *devlink,
 				       bool netns_change,
 				       enum devlink_reload_action action,
@@ -81,6 +112,7 @@ static int hclgevf_devlink_reload_up(struct devlink *devlink,
 	*actions_performed = BIT(action);
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		hclgevf_devlink_get_param_setting(devlink);
 		rtnl_lock();
 		ret = hdev->nic_client->ops->reset_notify(h, HNAE3_INIT_CLIENT);
 		if (ret) {
@@ -103,6 +135,49 @@ static const struct devlink_ops hclgevf_devlink_ops = {
 	.reload_up = hclgevf_devlink_reload_up,
 };
 
+static int
+hclgevf_devlink_rx_buffer_size_validate(struct devlink *devlink, u32 id,
+					union devlink_param_value val,
+					struct netlink_ext_ack *extack)
+{
+#define HCLGEVF_RX_BUF_LEN_2K	2048
+#define HCLGEVF_RX_BUF_LEN_4K	4096
+
+	if (val.vu32 != HCLGEVF_RX_BUF_LEN_2K &&
+	    val.vu32 != HCLGEVF_RX_BUF_LEN_4K) {
+		NL_SET_ERR_MSG_MOD(extack, "Supported size is 2048 or 4096");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static const struct devlink_param hclgevf_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(HCLGEVF_DEVLINK_PARAM_ID_RX_BUF_LEN,
+			     "rx_buffer_len", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			     NULL, NULL,
+			     hclgevf_devlink_rx_buffer_size_validate),
+	DEVLINK_PARAM_DRIVER(HCLGEVF_DEVLINK_PARAM_ID_TX_BUF_SIZE,
+			     "tx_buffer_size", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			     NULL, NULL, NULL),
+};
+
+void hclgevf_devlink_set_params_init_values(struct hclgevf_dev *hdev)
+{
+	union devlink_param_value value;
+
+	value.vu32 = hdev->rx_buf_len;
+	devlink_param_driverinit_value_set(hdev->devlink,
+					   HCLGEVF_DEVLINK_PARAM_ID_RX_BUF_LEN,
+					   value);
+	value.vu32 = 0;
+	devlink_param_driverinit_value_set(hdev->devlink,
+					   HCLGEVF_DEVLINK_PARAM_ID_TX_BUF_SIZE,
+					   value);
+}
+
 int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
@@ -127,10 +202,20 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 
 	hdev->devlink = devlink;
 
+	ret = devlink_params_register(devlink, hclgevf_devlink_params,
+				      ARRAY_SIZE(hclgevf_devlink_params));
+	if (ret) {
+		dev_err(&pdev->dev,
+			"failed to register devlink params, ret = %d\n", ret);
+		goto out_param_reg_fail;
+	}
+
 	devlink_reload_enable(devlink);
 
 	return 0;
-
+out_param_reg_fail:
+	hdev->devlink = NULL;
+	devlink_unregister(devlink);
 out_reg_fail:
 	devlink_free(devlink);
 	return ret;
@@ -145,6 +230,8 @@ void hclgevf_devlink_uninit(struct hclgevf_dev *hdev)
 
 	devlink_reload_disable(devlink);
 
+	devlink_params_unregister(devlink, hclgevf_devlink_params,
+				  ARRAY_SIZE(hclgevf_devlink_params));
 	devlink_unregister(devlink);
 
 	devlink_free(devlink);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.h
index e09ea3d8a963..2159ec4a3523 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.h
@@ -6,10 +6,17 @@
 
 #include "hclgevf_main.h"
 
+enum hclgevf_devlink_param_id {
+	HCLGEVF_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	HCLGEVF_DEVLINK_PARAM_ID_RX_BUF_LEN,
+	HCLGEVF_DEVLINK_PARAM_ID_TX_BUF_SIZE,
+};
+
 struct hclgevf_devlink_priv {
 	struct hclgevf_dev *hdev;
 };
 
+void hclgevf_devlink_set_params_init_values(struct hclgevf_dev *hdev);
 int hclgevf_devlink_init(struct hclgevf_dev *hdev);
 void hclgevf_devlink_uninit(struct hclgevf_dev *hdev);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 1e03c4d16125..ce7d652594e1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3374,6 +3374,9 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 		goto err_config;
 	}
 
+	hclgevf_devlink_set_params_init_values(hdev);
+	devlink_params_publish(hdev->devlink);
+
 	ret = hclgevf_alloc_tqps(hdev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed(%d) to allocate TQPs\n", ret);
-- 
2.8.1

