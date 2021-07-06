Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E963BC6C8
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 08:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhGFGro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 02:47:44 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:10273 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhGFGri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 02:47:38 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GJtFY1RP2z1CDpv;
        Tue,  6 Jul 2021 14:39:29 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
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
Subject: [RFC PATCH net-next 6/8] net: hns3: add devlink reload support for VF
Date:   Tue, 6 Jul 2021 14:41:30 +0800
Message-ID: <1625553692-2773-7-git-send-email-huangguangbin2@huawei.com>
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

Add devlink reload support for HNS3 ethernet VF driver.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c        | 71 ++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index 1cc6e2fac3a3..53b0b8931325 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -32,8 +32,75 @@ static int hclgevf_devlink_info_get(struct devlink *devlink,
 	return devlink_info_version_running_put(req, "fw-version", version_str);
 }
 
+static int hclgevf_devlink_reload_down(struct devlink *devlink,
+				       bool netns_change,
+				       enum devlink_reload_action action,
+				       enum devlink_reload_limit limit,
+				       struct netlink_ext_ack *extack)
+{
+	struct hclgevf_devlink_priv *priv = devlink_priv(devlink);
+	struct hclgevf_dev *hdev = priv->hdev;
+	struct hnae3_handle *h = &hdev->nic;
+	struct pci_dev *pdev = hdev->pdev;
+	int ret;
+
+	if (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state)) {
+		dev_err(&pdev->dev, "reset is handling\n");
+		return -EBUSY;
+	}
+
+	switch (action) {
+	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		rtnl_lock();
+		ret = hdev->nic_client->ops->reset_notify(h, HNAE3_DOWN_CLIENT);
+		if (ret) {
+			rtnl_unlock();
+			return ret;
+		}
+
+		ret = hdev->nic_client->ops->reset_notify(h,
+							  HNAE3_UNINIT_CLIENT);
+		rtnl_unlock();
+		return ret;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int hclgevf_devlink_reload_up(struct devlink *devlink,
+				     enum devlink_reload_action action,
+				     enum devlink_reload_limit limit,
+				     u32 *actions_performed,
+				     struct netlink_ext_ack *extack)
+{
+	struct hclgevf_devlink_priv *priv = devlink_priv(devlink);
+	struct hclgevf_dev *hdev = priv->hdev;
+	struct hnae3_handle *h = &hdev->nic;
+	int ret;
+
+	*actions_performed = BIT(action);
+	switch (action) {
+	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		rtnl_lock();
+		ret = hdev->nic_client->ops->reset_notify(h, HNAE3_INIT_CLIENT);
+		if (ret) {
+			rtnl_unlock();
+			return ret;
+		}
+
+		ret = hdev->nic_client->ops->reset_notify(h, HNAE3_UP_CLIENT);
+		rtnl_unlock();
+		return ret;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct devlink_ops hclgevf_devlink_ops = {
 	.info_get = hclgevf_devlink_info_get,
+	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
+	.reload_down = hclgevf_devlink_reload_down,
+	.reload_up = hclgevf_devlink_reload_up,
 };
 
 int hclgevf_devlink_init(struct hclgevf_dev *hdev)
@@ -60,6 +127,8 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 
 	hdev->devlink = devlink;
 
+	devlink_reload_enable(devlink);
+
 	return 0;
 
 out_reg_fail:
@@ -74,6 +143,8 @@ void hclgevf_devlink_uninit(struct hclgevf_dev *hdev)
 	if (!devlink)
 		return;
 
+	devlink_reload_disable(devlink);
+
 	devlink_unregister(devlink);
 
 	devlink_free(devlink);
-- 
2.8.1

