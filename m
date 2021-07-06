Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA3A3BC6CB
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 08:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhGFGrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 02:47:47 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6421 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbhGFGri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 02:47:38 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GJtHv3Tcvz78ZJ;
        Tue,  6 Jul 2021 14:41:31 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
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
Subject: [RFC PATCH net-next 7/8] net: hns3: add support for PF setting rx/tx buffer size by devlink param
Date:   Tue, 6 Jul 2021 14:41:31 +0800
Message-ID: <1625553692-2773-8-git-send-email-huangguangbin2@huawei.com>
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

Add support for PF setting rx/tx buffer size by devlink param

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  8 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c | 89 +++++++++++++++++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h |  7 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  3 +
 5 files changed, 105 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index e0b7c3c44e7b..14934db9c59a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -763,6 +763,7 @@ struct hnae3_knic_private_info {
 	u16 num_tx_desc;
 	u16 num_rx_desc;
 	u32 tx_spare_buf_size;
+	u32 devlink_tx_spare_buf_size;
 
 	struct hnae3_tc_info tc_info;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index cdb5f14fb6bc..cdb473d26bcc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1037,8 +1037,12 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 	dma_addr_t dma;
 	int order;
 
-	alloc_size = tx_spare_buf_size ? tx_spare_buf_size :
-		     ring->tqp->handle->kinfo.tx_spare_buf_size;
+	if (ring->tqp->handle->kinfo.devlink_tx_spare_buf_size)
+		alloc_size = ring->tqp->handle->kinfo.devlink_tx_spare_buf_size;
+	else if (tx_spare_buf_size)
+		alloc_size = tx_spare_buf_size;
+	else
+		alloc_size = ring->tqp->handle->kinfo.tx_spare_buf_size;
 	if (!alloc_size)
 		return;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 276a4261bb9b..38a85fe77076 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -32,6 +32,37 @@ static int hclge_devlink_info_get(struct devlink *devlink,
 	return devlink_info_version_running_put(req, "fw-version", version_str);
 }
 
+static void hclge_devlink_get_param_setting(struct devlink *devlink)
+{
+	struct hclge_devlink_priv *priv = devlink_priv(devlink);
+	struct hclge_dev *hdev = priv->hdev;
+	struct pci_dev *pdev = hdev->pdev;
+	union devlink_param_value val;
+	int i, ret;
+
+	ret = devlink_param_driverinit_value_get(devlink,
+						 HCLGE_DEVLINK_PARAM_ID_RX_BUF_LEN,
+						 &val);
+	if (!ret) {
+		hdev->rx_buf_len = val.vu32;
+		hdev->vport->nic.kinfo.rx_buf_len = hdev->rx_buf_len;
+		for (i = 0; i < hdev->num_tqps; i++)
+			hdev->htqp[i].q.buf_size = hdev->rx_buf_len;
+	} else {
+		dev_err(&pdev->dev,
+			"failed to get rx buffer size, ret = %d\n", ret);
+	}
+
+	ret = devlink_param_driverinit_value_get(devlink,
+						 HCLGE_DEVLINK_PARAM_ID_TX_BUF_SIZE,
+						 &val);
+	if (!ret)
+		hdev->vport->nic.kinfo.devlink_tx_spare_buf_size = val.vu32;
+	else
+		dev_err(&pdev->dev,
+			"failed to get tx buffer size, ret = %d\n", ret);
+}
+
 static int hclge_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				     enum devlink_reload_action action,
 				     enum devlink_reload_limit limit,
@@ -80,6 +111,7 @@ static int hclge_devlink_reload_up(struct devlink *devlink,
 	*actions_performed = BIT(action);
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		hclge_devlink_get_param_setting(devlink);
 		rtnl_lock();
 		ret = hdev->nic_client->ops->reset_notify(h, HNAE3_INIT_CLIENT);
 		if (ret) {
@@ -102,6 +134,49 @@ static const struct devlink_ops hclge_devlink_ops = {
 	.reload_up = hclge_devlink_reload_up,
 };
 
+static int hclge_devlink_rx_buffer_size_validate(struct devlink *devlink,
+						 u32 id,
+						 union devlink_param_value val,
+						 struct netlink_ext_ack *extack)
+{
+#define HCLGE_RX_BUF_LEN_2K	2048
+#define HCLGE_RX_BUF_LEN_4K	4096
+
+	if (val.vu32 != HCLGE_RX_BUF_LEN_2K &&
+	    val.vu32 != HCLGE_RX_BUF_LEN_4K) {
+		NL_SET_ERR_MSG_MOD(extack, "Supported size is 2048 or 4096");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static const struct devlink_param hclge_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(HCLGE_DEVLINK_PARAM_ID_RX_BUF_LEN,
+			     "rx_buffer_len", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			     NULL, NULL,
+			     hclge_devlink_rx_buffer_size_validate),
+	DEVLINK_PARAM_DRIVER(HCLGE_DEVLINK_PARAM_ID_TX_BUF_SIZE,
+			     "tx_buffer_size", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			     NULL, NULL, NULL),
+};
+
+void hclge_devlink_set_params_init_values(struct hclge_dev *hdev)
+{
+	union devlink_param_value value;
+
+	value.vu32 = hdev->rx_buf_len;
+	devlink_param_driverinit_value_set(hdev->devlink,
+					   HCLGE_DEVLINK_PARAM_ID_RX_BUF_LEN,
+					   value);
+	value.vu32 = hdev->tx_spare_buf_size;
+	devlink_param_driverinit_value_set(hdev->devlink,
+					   HCLGE_DEVLINK_PARAM_ID_TX_BUF_SIZE,
+					   value);
+}
+
 int hclge_devlink_init(struct hclge_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
@@ -126,10 +201,20 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 
 	hdev->devlink = devlink;
 
+	ret = devlink_params_register(devlink, hclge_devlink_params,
+				      ARRAY_SIZE(hclge_devlink_params));
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
@@ -144,6 +229,8 @@ void hclge_devlink_uninit(struct hclge_dev *hdev)
 
 	devlink_reload_disable(devlink);
 
+	devlink_params_unregister(devlink, hclge_devlink_params,
+				  ARRAY_SIZE(hclge_devlink_params));
 	devlink_unregister(devlink);
 
 	devlink_free(devlink);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
index 918be04507a5..e81402e68aa7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
@@ -6,10 +6,17 @@
 
 #include "hclge_main.h"
 
+enum hclge_devlink_param_id {
+	HCLGE_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	HCLGE_DEVLINK_PARAM_ID_RX_BUF_LEN,
+	HCLGE_DEVLINK_PARAM_ID_TX_BUF_SIZE,
+};
+
 struct hclge_devlink_priv {
 	struct hclge_dev *hdev;
 };
 
 int hclge_devlink_init(struct hclge_dev *hdev);
+void hclge_devlink_set_params_init_values(struct hclge_dev *hdev);
 void hclge_devlink_uninit(struct hclge_dev *hdev);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index adc20d6a23c3..fdf14470a846 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11510,6 +11510,9 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		goto err_cmd_uninit;
 	}
 
+	hclge_devlink_set_params_init_values(hdev);
+	devlink_params_publish(hdev->devlink);
+
 	ret = hclge_init_msi(hdev);
 	if (ret) {
 		dev_err(&pdev->dev, "Init MSI/MSI-X error, ret = %d.\n", ret);
-- 
2.8.1

