Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC1830ADC
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfEaI5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:57:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39622 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727137AbfEaI4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:56:41 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4C4FD9F9D2F233FEB8F4;
        Fri, 31 May 2019 16:56:37 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Fri, 31 May 2019 16:56:29 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 12/12] net: hns3: delay and separate enabling of NIC and ROCE HW errors
Date:   Fri, 31 May 2019 16:54:58 +0800
Message-ID: <1559292898-64090-13-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
References: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
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
index e9c6038..a0a29a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1433,7 +1433,7 @@ hclge_log_and_clear_rocee_ras_error(struct hclge_dev *hdev)
 	return reset_type;
 }
 
-static int hclge_config_rocee_ras_interrupt(struct hclge_dev *hdev, bool en)
+int hclge_config_rocee_ras_interrupt(struct hclge_dev *hdev, bool en)
 {
 	struct device *dev = &hdev->pdev->dev;
 	struct hclge_desc desc;
@@ -1506,10 +1506,9 @@ static const struct hclge_hw_blk hw_blk[] = {
 	{ /* sentinel */ }
 };
 
-int hclge_hw_error_set_state(struct hclge_dev *hdev, bool state)
+int hclge_config_nic_hw_error(struct hclge_dev *hdev, bool state)
 {
 	const struct hclge_hw_blk *module = hw_blk;
-	struct device *dev = &hdev->pdev->dev;
 	int ret = 0;
 
 	while (module->name) {
@@ -1521,10 +1520,6 @@ int hclge_hw_error_set_state(struct hclge_dev *hdev, bool state)
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
index 7976660..ee5ef00 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8210,10 +8210,16 @@ static int hclge_init_nic_client_instance(struct hnae3_ae_dev *ae_dev,
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
@@ -8293,7 +8299,13 @@ static int hclge_init_client_instance(struct hnae3_client *client,
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
@@ -8597,13 +8609,6 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
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
@@ -8727,15 +8732,26 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
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
@@ -8760,8 +8776,11 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
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

