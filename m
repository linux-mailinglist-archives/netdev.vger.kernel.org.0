Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5564F279F35
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbgI0HPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:15:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14244 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbgI0HPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 03:15:43 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6C72534911D9A984CB76;
        Sun, 27 Sep 2020 15:15:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sun, 27 Sep 2020 15:15:32 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/10] net: hns3: add support to query device capability
Date:   Sun, 27 Sep 2020 15:12:41 +0800
Message-ID: <1601190768-50075-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
References: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

In order to improve code maintainability and compatibility,
add support to query the device capability by expanding the
existing version query command. The device capability refers
to the features supported by the device.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c          | 10 ----------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c   | 15 ++++++++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h   |  4 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 14 +++++++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h |  4 +++-
 5 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index c44a685..1c4e820e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2076,15 +2076,6 @@ static void hns3_disable_sriov(struct pci_dev *pdev)
 	pci_disable_sriov(pdev);
 }
 
-static void hns3_get_dev_capability(struct pci_dev *pdev,
-				    struct hnae3_ae_dev *ae_dev)
-{
-	if (pdev->revision >= 0x21) {
-		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FD_B, 1);
-		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_GRO_B, 1);
-	}
-}
-
 /* hns3_probe - Device initialization routine
  * @pdev: PCI device information struct
  * @ent: entry in hns3_pci_tbl
@@ -2106,7 +2097,6 @@ static int hns3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ae_dev->pdev = pdev;
 	ae_dev->flag = ent->driver_data;
-	hns3_get_dev_capability(pdev, ae_dev);
 	pci_set_drvdata(pdev, ae_dev);
 
 	ret = hnae3_register_ae_dev(ae_dev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 03b7a96..9f6b1a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -330,7 +330,8 @@ int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 	return retval;
 }
 
-static enum hclge_cmd_status hclge_cmd_query_version(struct hclge_dev *hdev)
+static enum hclge_cmd_status
+hclge_cmd_query_version_and_capability(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclge_query_version_cmd *resp;
@@ -350,6 +351,12 @@ static enum hclge_cmd_status hclge_cmd_query_version(struct hclge_dev *hdev)
 					 HNAE3_PCI_REVISION_BIT_SIZE;
 	ae_dev->dev_version |= hdev->pdev->revision;
 
+	if (!resp->caps[0] &&
+	    ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
+		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FD_B, 1);
+		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_GRO_B, 1);
+	}
+
 	return ret;
 }
 
@@ -436,10 +443,12 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 		goto err_cmd_init;
 	}
 
-	ret = hclge_cmd_query_version(hdev);
+	/* get version and device capabilities */
+	ret = hclge_cmd_query_version_and_capability(hdev);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"failed to query version ret=%d\n", ret);
+			"failed to query version and capabilities, ret = %d\n",
+			ret);
 		goto err_cmd_init;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index de73463..1252e88 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -362,10 +362,12 @@ struct hclge_rx_priv_buff_cmd {
 	u8 rsv[6];
 };
 
+#define HCLGE_QUERY_CAP_LENGTH		3
 struct hclge_query_version_cmd {
 	__le32 firmware;
 	__le32 hardware;
-	__le32 rsv[4];
+	__le32 rsv;
+	__le32 caps[HCLGE_QUERY_CAP_LENGTH]; /* capabilities of device */
 };
 
 #define HCLGE_RX_PRIV_EN_B	15
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index b323756..3a1f7b5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -313,7 +313,7 @@ int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclgevf_desc *desc, int num)
 	return status;
 }
 
-static int hclgevf_cmd_query_version(struct hclgevf_dev *hdev)
+static int hclgevf_cmd_query_version_and_capability(struct hclgevf_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclgevf_query_version_cmd *resp;
@@ -333,6 +333,12 @@ static int hclgevf_cmd_query_version(struct hclgevf_dev *hdev)
 				 HNAE3_PCI_REVISION_BIT_SIZE;
 	ae_dev->dev_version |= hdev->pdev->revision;
 
+	if (!resp->caps[0] &&
+	    ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
+		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FD_B, 1);
+		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_GRO_B, 1);
+	}
+
 	return status;
 }
 
@@ -400,9 +406,11 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 		goto err_cmd_init;
 	}
 
-	ret = hclgevf_cmd_query_version(hdev);
+	/* get version and device capabilities */
+	ret = hclgevf_cmd_query_version_and_capability(hdev);
 	if (ret) {
-		dev_err(&hdev->pdev->dev, "failed(%d) to query version\n", ret);
+		dev_err(&hdev->pdev->dev,
+			"failed to query version and capabilities, ret = %d\n", ret);
 		goto err_cmd_init;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 0601df6..52e7651 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -141,10 +141,12 @@ struct hclgevf_ctrl_vector_chain {
 	u8 resv;
 };
 
+#define HCLGEVF_QUERY_CAP_LENGTH		3
 struct hclgevf_query_version_cmd {
 	__le32 firmware;
 	__le32 hardware;
-	__le32 rsv[4];
+	__le32 rsv;
+	__le32 caps[HCLGEVF_QUERY_CAP_LENGTH]; /* capabilities of device */
 };
 
 #define HCLGEVF_MSIX_OFT_ROCEE_S       0
-- 
2.7.4

