Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A55B7602D
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 09:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfGZHxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 03:53:38 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2771 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725955AbfGZHxh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 03:53:37 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CEDD9B706184787A6841;
        Fri, 26 Jul 2019 15:53:34 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Fri, 26 Jul 2019 15:53:26 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <saeedm@mellanox.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 05/10] net: hns3: modify firmware version display format
Date:   Fri, 26 Jul 2019 15:51:25 +0800
Message-ID: <1564127490-22173-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564127490-22173-1-git-send-email-tanhuazhong@huawei.com>
References: <1564127490-22173-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

This patch modifies firmware version display format in
hclge(vf)_cmd_init() and hns3_get_drvinfo(). Also, adds
some optimizations for firmware version display format.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h              |  9 +++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c       | 15 +++++++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c   | 10 +++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 10 +++++++++-
 4 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 48c7b70..a4624db 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -179,6 +179,15 @@ struct hnae3_vector_info {
 #define HNAE3_RING_GL_RX 0
 #define HNAE3_RING_GL_TX 1
 
+#define HNAE3_FW_VERSION_BYTE3_SHIFT	24
+#define HNAE3_FW_VERSION_BYTE3_MASK	GENMASK(31, 24)
+#define HNAE3_FW_VERSION_BYTE2_SHIFT	16
+#define HNAE3_FW_VERSION_BYTE2_MASK	GENMASK(23, 16)
+#define HNAE3_FW_VERSION_BYTE1_SHIFT	8
+#define HNAE3_FW_VERSION_BYTE1_MASK	GENMASK(15, 8)
+#define HNAE3_FW_VERSION_BYTE0_SHIFT	0
+#define HNAE3_FW_VERSION_BYTE0_MASK	GENMASK(7, 0)
+
 struct hnae3_ring_chain_node {
 	struct hnae3_ring_chain_node *next;
 	u32 tqp_index;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 5bff98a..e71c92b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -527,6 +527,7 @@ static void hns3_get_drvinfo(struct net_device *netdev,
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
+	u32 fw_version;
 
 	if (!h->ae_algo->ops->get_fw_version) {
 		netdev_err(netdev, "could not get fw version!\n");
@@ -545,8 +546,18 @@ static void hns3_get_drvinfo(struct net_device *netdev,
 		sizeof(drvinfo->bus_info));
 	drvinfo->bus_info[ETHTOOL_BUSINFO_LEN - 1] = '\0';
 
-	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version), "0x%08x",
-		 priv->ae_handle->ae_algo->ops->get_fw_version(h));
+	fw_version = priv->ae_handle->ae_algo->ops->get_fw_version(h);
+
+	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
+		 "%lu.%lu.%lu.%lu",
+		 hnae3_get_field(fw_version, HNAE3_FW_VERSION_BYTE3_MASK,
+				 HNAE3_FW_VERSION_BYTE3_SHIFT),
+		 hnae3_get_field(fw_version, HNAE3_FW_VERSION_BYTE2_MASK,
+				 HNAE3_FW_VERSION_BYTE2_SHIFT),
+		 hnae3_get_field(fw_version, HNAE3_FW_VERSION_BYTE1_MASK,
+				 HNAE3_FW_VERSION_BYTE1_SHIFT),
+		 hnae3_get_field(fw_version, HNAE3_FW_VERSION_BYTE0_MASK,
+				 HNAE3_FW_VERSION_BYTE0_SHIFT));
 }
 
 static u32 hns3_get_link(struct net_device *netdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 22f6acd..d9858f2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -419,7 +419,15 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 	}
 	hdev->fw_version = version;
 
-	dev_info(&hdev->pdev->dev, "The firmware version is %08x\n", version);
+	dev_info(&hdev->pdev->dev, "The firmware version is %lu.%lu.%lu.%lu\n",
+		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE3_MASK,
+				 HNAE3_FW_VERSION_BYTE3_SHIFT),
+		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE2_MASK,
+				 HNAE3_FW_VERSION_BYTE2_SHIFT),
+		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE1_MASK,
+				 HNAE3_FW_VERSION_BYTE1_SHIFT),
+		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE0_MASK,
+				 HNAE3_FW_VERSION_BYTE0_SHIFT));
 
 	return 0;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 652b796..8f21eb3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -405,7 +405,15 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 	}
 	hdev->fw_version = version;
 
-	dev_info(&hdev->pdev->dev, "The firmware version is %08x\n", version);
+	dev_info(&hdev->pdev->dev, "The firmware version is %lu.%lu.%lu.%lu\n",
+		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE3_MASK,
+				 HNAE3_FW_VERSION_BYTE3_SHIFT),
+		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE2_MASK,
+				 HNAE3_FW_VERSION_BYTE2_SHIFT),
+		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE1_MASK,
+				 HNAE3_FW_VERSION_BYTE1_SHIFT),
+		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE0_MASK,
+				 HNAE3_FW_VERSION_BYTE0_SHIFT));
 
 	return 0;
 
-- 
2.7.4

