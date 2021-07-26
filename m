Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0588E3D5160
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 04:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhGZCKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 22:10:40 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7429 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhGZCKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 22:10:14 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GY4831Hsfz80BK;
        Mon, 26 Jul 2021 10:46:59 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
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
Subject: [PATCH V3 net-next 4/7] net: hns3: add support for devlink get info for PF
Date:   Mon, 26 Jul 2021 10:47:04 +0800
Message-ID: <1627267627-38467-5-git-send-email-huangguangbin2@huawei.com>
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

Add devlink get info support for HNS3 ethernet PF driver.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 03b822b0a8e7..7de423d510c5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -5,7 +5,37 @@
 
 #include "hclge_devlink.h"
 
+static int hclge_devlink_info_get(struct devlink *devlink,
+				  struct devlink_info_req *req,
+				  struct netlink_ext_ack *extack)
+{
+#define	HCLGE_DEVLINK_FW_STRING_LEN	32
+	struct hclge_devlink_priv *priv = devlink_priv(devlink);
+	char version_str[HCLGE_DEVLINK_FW_STRING_LEN];
+	struct hclge_dev *hdev = priv->hdev;
+	int ret;
+
+	ret = devlink_info_driver_name_put(req, KBUILD_MODNAME);
+	if (ret)
+		return ret;
+
+	snprintf(version_str, sizeof(version_str), "%lu.%lu.%lu.%lu",
+		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE3_MASK,
+				 HNAE3_FW_VERSION_BYTE3_SHIFT),
+		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE2_MASK,
+				 HNAE3_FW_VERSION_BYTE2_SHIFT),
+		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE1_MASK,
+				 HNAE3_FW_VERSION_BYTE1_SHIFT),
+		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE0_MASK,
+				 HNAE3_FW_VERSION_BYTE0_SHIFT));
+
+	return devlink_info_version_running_put(req,
+						DEVLINK_INFO_VERSION_GENERIC_FW,
+						version_str);
+}
+
 static const struct devlink_ops hclge_devlink_ops = {
+	.info_get = hclge_devlink_info_get,
 };
 
 int hclge_devlink_init(struct hclge_dev *hdev)
-- 
2.8.1

