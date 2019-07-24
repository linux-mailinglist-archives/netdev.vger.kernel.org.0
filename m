Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7476772544
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 05:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGXDVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 23:21:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50542 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726397AbfGXDVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 23:21:06 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8037A1016804BB4912D4;
        Wed, 24 Jul 2019 11:20:52 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 24 Jul 2019 11:20:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/11] net: hns3: modify firmware version display format
Date:   Wed, 24 Jul 2019 11:18:42 +0800
Message-ID: <1563938327-9865-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
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
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 11 +++++++++--
 4 files changed, 40 insertions(+), 5 deletions(-)

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
index 22f6acd..c2320bf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -419,7 +419,15 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 	}
 	hdev->fw_version = version;
 
-	dev_info(&hdev->pdev->dev, "The firmware version is %08x\n", version);
+	pr_info_once("The firmware version is %lu.%lu.%lu.%lu\n",
+		     hnae3_get_field(version, HNAE3_FW_VERSION_BYTE3_MASK,
+				     HNAE3_FW_VERSION_BYTE3_SHIFT),
+		     hnae3_get_field(version, HNAE3_FW_VERSION_BYTE2_MASK,
+				     HNAE3_FW_VERSION_BYTE2_SHIFT),
+		     hnae3_get_field(version, HNAE3_FW_VERSION_BYTE1_MASK,
+				     HNAE3_FW_VERSION_BYTE1_SHIFT),
+		     hnae3_get_field(version, HNAE3_FW_VERSION_BYTE0_MASK,
+				     HNAE3_FW_VERSION_BYTE0_SHIFT));
 
 	return 0;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 652b796..004125b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -405,8 +405,15 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 	}
 	hdev->fw_version = version;
 
-	dev_info(&hdev->pdev->dev, "The firmware version is %08x\n", version);
-
+	pr_info_once("The firmware version is %lu.%lu.%lu.%lu\n",
+		     hnae3_get_field(version, HNAE3_FW_VERSION_BYTE3_MASK,
+				     HNAE3_FW_VERSION_BYTE3_SHIFT),
+		     hnae3_get_field(version, HNAE3_FW_VERSION_BYTE2_MASK,
+				     HNAE3_FW_VERSION_BYTE2_SHIFT),
+		     hnae3_get_field(version, HNAE3_FW_VERSION_BYTE1_MASK,
+				     HNAE3_FW_VERSION_BYTE1_SHIFT),
+		     hnae3_get_field(version, HNAE3_FW_VERSION_BYTE0_MASK,
+				     HNAE3_FW_VERSION_BYTE0_SHIFT));
 	return 0;
 
 err_cmd_init:
-- 
2.7.4

