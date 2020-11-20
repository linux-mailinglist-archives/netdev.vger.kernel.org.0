Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCF42BA5C0
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgKTJQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:16:24 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8566 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbgKTJQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:16:21 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CcrWK0F9FzLqhV;
        Fri, 20 Nov 2020 17:15:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Nov 2020 17:16:11 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/5] net: hns3: add support for mapping device memory
Date:   Fri, 20 Nov 2020 17:16:20 +0800
Message-ID: <1605863783-36995-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
References: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For device who has device memory accessed through the PCI BAR4,
IO descriptor push of NIC and direct WQE(Work Queue Element) of
RoCE will use this device memory, so add support for mapping
this device memory, and add this info to the RoCE client whose
new feature needs.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 33 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 33 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  1 +
 5 files changed, 69 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index f9d4d23..5bae5e8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -689,6 +689,7 @@ struct hnae3_knic_private_info {
 struct hnae3_roce_private_info {
 	struct net_device *netdev;
 	void __iomem *roce_io_base;
+	void __iomem *roce_mem_base;
 	int base_vector;
 	int num_vectors;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 892e7f6..9989930 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2436,6 +2436,7 @@ static int hclge_init_roce_base_info(struct hclge_vport *vport)
 
 	roce->rinfo.netdev = nic->kinfo.netdev;
 	roce->rinfo.roce_io_base = vport->back->hw.io_base;
+	roce->rinfo.roce_mem_base = vport->back->hw.mem_base;
 
 	roce->pdev = nic->pdev;
 	roce->ae_algo = nic->ae_algo;
@@ -9890,6 +9891,28 @@ static void hclge_uninit_client_instance(struct hnae3_client *client,
 	}
 }
 
+static int hclge_dev_mem_map(struct hclge_dev *hdev)
+{
+#define HCLGE_MEM_BAR		4
+
+	struct pci_dev *pdev = hdev->pdev;
+	struct hclge_hw *hw = &hdev->hw;
+
+	/* for device does not have device memory, return directly */
+	if (!(pci_select_bars(pdev, IORESOURCE_MEM) & BIT(HCLGE_MEM_BAR)))
+		return 0;
+
+	hw->mem_base = devm_ioremap_wc(&pdev->dev,
+				       pci_resource_start(pdev, HCLGE_MEM_BAR),
+				       pci_resource_len(pdev, HCLGE_MEM_BAR));
+	if (!hw->mem_base) {
+		dev_err(&pdev->dev, "failed to map device memroy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 static int hclge_pci_init(struct hclge_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
@@ -9928,9 +9951,16 @@ static int hclge_pci_init(struct hclge_dev *hdev)
 		goto err_clr_master;
 	}
 
+	ret = hclge_dev_mem_map(hdev);
+	if (ret)
+		goto err_unmap_io_base;
+
 	hdev->num_req_vfs = pci_sriov_get_totalvfs(pdev);
 
 	return 0;
+
+err_unmap_io_base:
+	pcim_iounmap(pdev, hdev->hw.io_base);
 err_clr_master:
 	pci_clear_master(pdev);
 	pci_release_regions(pdev);
@@ -9944,6 +9974,9 @@ static void hclge_pci_uninit(struct hclge_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
 
+	if (hdev->hw.mem_base)
+		devm_iounmap(&pdev->dev, hdev->hw.mem_base);
+
 	pcim_iounmap(pdev, hdev->hw.io_base);
 	pci_free_irq_vectors(pdev);
 	pci_clear_master(pdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 64e6afd..3ed4e84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -278,6 +278,7 @@ struct hclge_mac {
 
 struct hclge_hw {
 	void __iomem *io_base;
+	void __iomem *mem_base;
 	struct hclge_mac mac;
 	int num_vec;
 	struct hclge_cmq cmq;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 5ac5c35..5d6b419 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2442,6 +2442,7 @@ static int hclgevf_init_roce_base_info(struct hclgevf_dev *hdev)
 
 	roce->rinfo.netdev = nic->kinfo.netdev;
 	roce->rinfo.roce_io_base = hdev->hw.io_base;
+	roce->rinfo.roce_mem_base = hdev->hw.mem_base;
 
 	roce->pdev = nic->pdev;
 	roce->ae_algo = nic->ae_algo;
@@ -2887,6 +2888,29 @@ static void hclgevf_uninit_client_instance(struct hnae3_client *client,
 	}
 }
 
+static int hclgevf_dev_mem_map(struct hclgevf_dev *hdev)
+{
+#define HCLGEVF_MEM_BAR		4
+
+	struct pci_dev *pdev = hdev->pdev;
+	struct hclgevf_hw *hw = &hdev->hw;
+
+	/* for device does not have device memory, return directly */
+	if (!(pci_select_bars(pdev, IORESOURCE_MEM) & BIT(HCLGEVF_MEM_BAR)))
+		return 0;
+
+	hw->mem_base = devm_ioremap_wc(&pdev->dev,
+				       pci_resource_start(pdev,
+							  HCLGEVF_MEM_BAR),
+				       pci_resource_len(pdev, HCLGEVF_MEM_BAR));
+	if (!hw->mem_base) {
+		dev_err(&pdev->dev, "failed to map device memroy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 static int hclgevf_pci_init(struct hclgevf_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
@@ -2921,8 +2945,14 @@ static int hclgevf_pci_init(struct hclgevf_dev *hdev)
 		goto err_clr_master;
 	}
 
+	ret = hclgevf_dev_mem_map(hdev);
+	if (ret)
+		goto err_unmap_io_base;
+
 	return 0;
 
+err_unmap_io_base:
+	pci_iounmap(pdev, hdev->hw.io_base);
 err_clr_master:
 	pci_clear_master(pdev);
 	pci_release_regions(pdev);
@@ -2936,6 +2966,9 @@ static void hclgevf_pci_uninit(struct hclgevf_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
 
+	if (hdev->hw.mem_base)
+		devm_iounmap(&pdev->dev, hdev->hw.mem_base);
+
 	pci_iounmap(pdev, hdev->hw.io_base);
 	pci_clear_master(pdev);
 	pci_release_regions(pdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index c5bcc38..1b183bc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -164,6 +164,7 @@ struct hclgevf_mac {
 
 struct hclgevf_hw {
 	void __iomem *io_base;
+	void __iomem *mem_base;
 	int num_vec;
 	struct hclgevf_cmq cmq;
 	struct hclgevf_mac mac;
-- 
2.7.4

