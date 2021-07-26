Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4613D5163
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 04:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhGZCKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 22:10:44 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12407 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbhGZCKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 22:10:14 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GY48N139LzcjKJ;
        Mon, 26 Jul 2021 10:47:16 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 26 Jul 2021 10:50:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 26 Jul 2021 10:50:42 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <moyufeng@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V3 net-next 6/7] net: hns3: add devlink reload support for PF
Date:   Mon, 26 Jul 2021 10:47:06 +0800
Message-ID: <1627267627-38467-7-git-send-email-huangguangbin2@huawei.com>
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

From: Hao Chen <chenhao288@hisilicon.com>

Add devlink reload support for HNS3 ethernet PF driver.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c | 70 ++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 7de423d510c5..06d29945d4e1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -34,8 +34,74 @@ static int hclge_devlink_info_get(struct devlink *devlink,
 						version_str);
 }
 
+static int hclge_devlink_reload_down(struct devlink *devlink, bool netns_change,
+				     enum devlink_reload_action action,
+				     enum devlink_reload_limit limit,
+				     struct netlink_ext_ack *extack)
+{
+	struct hclge_devlink_priv *priv = devlink_priv(devlink);
+	struct hclge_dev *hdev = priv->hdev;
+	struct hnae3_handle *h = &hdev->vport->nic;
+	struct pci_dev *pdev = hdev->pdev;
+	int ret;
+
+	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state)) {
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
+static int hclge_devlink_reload_up(struct devlink *devlink,
+				   enum devlink_reload_action action,
+				   enum devlink_reload_limit limit,
+				   u32 *actions_performed,
+				   struct netlink_ext_ack *extack)
+{
+	struct hclge_devlink_priv *priv = devlink_priv(devlink);
+	struct hclge_dev *hdev = priv->hdev;
+	struct hnae3_handle *h = &hdev->vport->nic;
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
 static const struct devlink_ops hclge_devlink_ops = {
 	.info_get = hclge_devlink_info_get,
+	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
+	.reload_down = hclge_devlink_reload_down,
+	.reload_up = hclge_devlink_reload_up,
 };
 
 int hclge_devlink_init(struct hclge_dev *hdev)
@@ -62,6 +128,8 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 
 	hdev->devlink = devlink;
 
+	devlink_reload_enable(devlink);
+
 	return 0;
 
 out_reg_fail:
@@ -76,6 +144,8 @@ void hclge_devlink_uninit(struct hclge_dev *hdev)
 	if (!devlink)
 		return;
 
+	devlink_reload_disable(devlink);
+
 	devlink_unregister(devlink);
 
 	devlink_free(devlink);
-- 
2.8.1

