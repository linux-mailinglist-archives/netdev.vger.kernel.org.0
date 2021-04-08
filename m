Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A28357AD6
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 05:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhDHDkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 23:40:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16031 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhDHDkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 23:40:10 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FG6QH73XTzNtq5;
        Thu,  8 Apr 2021 11:37:11 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 8 Apr 2021 11:39:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/2] net: hns3: add suspend and resume pm_ops
Date:   Thu, 8 Apr 2021 11:40:05 +0800
Message-ID: <1617853205-32760-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617853205-32760-1-git-send-email-tanhuazhong@huawei.com>
References: <1617853205-32760-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

To implement the system suspend/resume functions, the NIC driver needs
to support:
1. When the system enters the suspend mode, the driver needs to
implement the suspend callback function of the NIC device. The driver
needs to mute the device, stop all RX/TX activities of the device, and
unmap the interrupt.
2. When the system enters the resume mode, the driver needs to
implement the resume callback function of the NIC device and restore
the device to the state before suspension.

When the system enters the suspend and resume mode, the NIC driver
actually executes the PF function reset process.

When the PFs are suspending/resuming, VFs also enter the suspend/resume
state because the PFs trigger the VFs to reset, therefore no operation
is required when the VF pci_driver is suspending or resuming.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 29 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  2 ++
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 67fc5aa..25afe5a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2365,6 +2365,32 @@ static void hns3_shutdown(struct pci_dev *pdev)
 		pci_set_power_state(pdev, PCI_D3hot);
 }
 
+static int __maybe_unused hns3_suspend(struct device *dev)
+{
+	struct hnae3_ae_dev *ae_dev = dev_get_drvdata(dev);
+
+	if (hns3_is_phys_func(ae_dev->pdev)) {
+		dev_info(dev, "Begin to suspend.\n");
+		if (ae_dev && ae_dev->ops && ae_dev->ops->reset_prepare)
+			ae_dev->ops->reset_prepare(ae_dev, HNAE3_FUNC_RESET);
+	}
+
+	return 0;
+}
+
+static int __maybe_unused hns3_resume(struct device *dev)
+{
+	struct hnae3_ae_dev *ae_dev = dev_get_drvdata(dev);
+
+	if (hns3_is_phys_func(ae_dev->pdev)) {
+		dev_info(dev, "Begin to resume.\n");
+		if (ae_dev && ae_dev->ops && ae_dev->ops->reset_done)
+			ae_dev->ops->reset_done(ae_dev);
+	}
+
+	return 0;
+}
+
 static pci_ers_result_t hns3_error_detected(struct pci_dev *pdev,
 					    pci_channel_state_t state)
 {
@@ -2443,12 +2469,15 @@ static const struct pci_error_handlers hns3_err_handler = {
 	.reset_done	= hns3_reset_done,
 };
 
+static SIMPLE_DEV_PM_OPS(hns3_pm_ops, hns3_suspend, hns3_resume);
+
 static struct pci_driver hns3_driver = {
 	.name     = hns3_driver_name,
 	.id_table = hns3_pci_tbl,
 	.probe    = hns3_probe,
 	.remove   = hns3_remove,
 	.shutdown = hns3_shutdown,
+	.driver.pm  = &hns3_pm_ops,
 	.sriov_configure = hns3_pci_sriov_configure,
 	.err_handler    = &hns3_err_handler,
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 47c95dc..c446b63 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11094,6 +11094,8 @@ static void hclge_reset_prepare_general(struct hnae3_ae_dev *ae_dev,
 
 	if (hdev->reset_type == HNAE3_FLR_RESET)
 		hdev->rst_stats.flr_rst_cnt++;
+	else if (hdev->reset_type == HNAE3_FUNC_RESET)
+		hdev->rst_stats.pf_rst_cnt++;
 }
 
 static void hclge_reset_done(struct hnae3_ae_dev *ae_dev)
-- 
2.7.4

