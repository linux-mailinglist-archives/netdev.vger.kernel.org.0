Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B58432674
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 04:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfFCCLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 22:11:50 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17654 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726988AbfFCCLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 22:11:04 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E3DDCBCD024AB5A01301;
        Mon,  3 Jun 2019 10:11:00 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 3 Jun 2019 10:10:53 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 10/10] net: hns3: delay and separate enabling of NIC and ROCE HW errors
Date:   Mon, 3 Jun 2019 10:09:22 +0800
Message-ID: <1559527762-22931-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559527762-22931-1-git-send-email-tanhuazhong@huawei.com>
References: <1559527762-22931-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

All RAS and MSI-X should be enabled just in the final stage of HNS3
initialization. It means that they should be enabled in
hclge_init_xxx_client_instance instead of hclge_ae_dev(). Especially
MSI-X, if it is enabled before opening vector0 IRQ, there are some
chances that a MSI-X error will cause failure on initialization of
 NIC client instane. So this patch delays enabling of HW errors.
Otherwise, we also separate enabling of ROCE RAS from NIC, because
it's not reasonable to enable ROCE RAS if we even don't have a ROCE
driver.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  9 +----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |  3 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 45 +++++++++++++++-------
 3 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index b4a7e6a..784512d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1493,7 +1493,7 @@ hclge_log_and_clear_rocee_ras_error(struct hclge_dev *hdev)
 	return reset_type;
 }
 
-static int hclge_config_rocee_ras_interrupt(struct hclge_dev *hdev, bool en)
+int hclge_config_rocee_ras_interrupt(struct hclge_dev *hdev, bool en)
 {
 	struct device *dev = &hdev->pdev->dev;
 	struct hclge_desc desc;
@@ -1566,10 +1566,9 @@ static const struct hclge_hw_blk hw_blk[] = {
 	{ /* sentinel */ }
 };
 
-int hclge_hw_error_set_state(struct hclge_dev *hdev, bool state)
+int hclge_config_nic_hw_error(struct hclge_dev *hdev, bool state)
 {
 	const struct hclge_hw_blk *module = hw_blk;
-	struct device *dev = &hdev->pdev->dev;
 	int ret = 0;
 
 	while (module->name) {
@@ -1581,10 +1580,6 @@ int hclge_hw_error_set_state(struct hclge_dev *hdev, bool state)
 		module++;
 	}
 
-	ret = hclge_config_rocee_ras_interrupt(hdev, state);
-	if (ret)
-		dev_err(dev, "fail(%d) to configure ROCEE err int\n", ret);
-
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index c56b11e..81d115a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -119,7 +119,8 @@ struct hclge_hw_error {
 };
 
 int hclge_config_mac_tnl_int(struct hclge_dev *hdev, bool en);
-int hclge_hw_error_set_state(struct hclge_dev *hdev, bool state);
+int hclge_config_nic_hw_error(struct hclge_dev *hdev, bool state);
+int hclge_config_rocee_ras_interrupt(struct hclge_dev *hdev, bool en);
 pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev);
 int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 			       unsigned long *reset_requests);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4873a8e..35d2a45 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8202,10 +8202,16 @@ static int hclge_init_nic_client_instance(struct hnae3_ae_dev *ae_dev,
 	set_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state);
 	hnae3_set_client_init_flag(client, ae_dev, 1);
 
+	/* Enable nic hw error interrupts */
+	ret = hclge_config_nic_hw_error(hdev, true);
+	if (ret)
+		dev_err(&ae_dev->pdev->dev,
+			"fail(%d) to enable hw error interrupts\n", ret);
+
 	if (netif_msg_drv(&hdev->vport->nic))
 		hclge_info_show(hdev);
 
-	return 0;
+	return ret;
 }
 
 static int hclge_init_roce_client_instance(struct hnae3_ae_dev *ae_dev,
@@ -8285,7 +8291,13 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 		}
 	}
 
-	return 0;
+	/* Enable roce ras interrupts */
+	ret = hclge_config_rocee_ras_interrupt(hdev, true);
+	if (ret)
+		dev_err(&ae_dev->pdev->dev,
+			"fail(%d) to enable roce ras interrupts\n", ret);
+
+	return ret;
 
 clear_nic:
 	hdev->nic_client = NULL;
@@ -8589,13 +8601,6 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		goto err_mdiobus_unreg;
 	}
 
-	ret = hclge_hw_error_set_state(hdev, true);
-	if (ret) {
-		dev_err(&pdev->dev,
-			"fail(%d) to enable hw error interrupts\n", ret);
-		goto err_mdiobus_unreg;
-	}
-
 	INIT_KFIFO(hdev->mac_tnl_log);
 
 	hclge_dcb_ops_set(hdev);
@@ -8719,15 +8724,26 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 	}
 
 	/* Re-enable the hw error interrupts because
-	 * the interrupts get disabled on core/global reset.
+	 * the interrupts get disabled on global reset.
 	 */
-	ret = hclge_hw_error_set_state(hdev, true);
+	ret = hclge_config_nic_hw_error(hdev, true);
 	if (ret) {
 		dev_err(&pdev->dev,
-			"fail(%d) to re-enable HNS hw error interrupts\n", ret);
+			"fail(%d) to re-enable NIC hw error interrupts\n",
+			ret);
 		return ret;
 	}
 
+	if (hdev->roce_client) {
+		ret = hclge_config_rocee_ras_interrupt(hdev, true);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"fail(%d) to re-enable roce ras interrupts\n",
+				ret);
+			return ret;
+		}
+	}
+
 	hclge_reset_vport_state(hdev);
 
 	dev_info(&pdev->dev, "Reset done, %s driver initialization finished.\n",
@@ -8752,8 +8768,11 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_enable_vector(&hdev->misc_vector, false);
 	synchronize_irq(hdev->misc_vector.vector_irq);
 
+	/* Disable all hw interrupts */
 	hclge_config_mac_tnl_int(hdev, false);
-	hclge_hw_error_set_state(hdev, false);
+	hclge_config_nic_hw_error(hdev, false);
+	hclge_config_rocee_ras_interrupt(hdev, false);
+
 	hclge_cmd_uninit(hdev);
 	hclge_misc_irq_uninit(hdev);
 	hclge_pci_uninit(hdev);
-- 
2.7.4

