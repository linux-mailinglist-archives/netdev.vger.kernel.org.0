Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D29943E6B
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbfFMPtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:49:50 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18153 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731702AbfFMJOV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 05:14:21 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 396BA4459CE4CA10A628;
        Thu, 13 Jun 2019 17:14:14 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 13 Jun 2019 17:14:07 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/12] net: hns3: process H/W errors occurred before HNS dev initialization
Date:   Thu, 13 Jun 2019 17:12:23 +0800
Message-ID: <1560417152-53050-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
References: <1560417152-53050-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiju Jose <shiju.jose@huawei.com>

Presently the HNS driver enables the HNS H/W error interrupts after
the dev initialization is completed. However some exceptions such as
NCSI errors can occur when the network port driver is not loaded
and those errors required reporting to the BMC.
Therefore the firmware enabled all the HNS ras error interrupts
before the driver is loaded. And in some cases, there will be some
H/W errors remained unclear before reboot. Thus the HNS driver needs
to process and recover those hw errors occurred before HNS driver is
initialized.

This patch adds processing of the HNS hw errors(RAS and MSI-X)
which occurred before the driver initialization. For RAS, because
they are enabled by firmware, so we can detect specific bits, then
log and clear them. But for MSI-X which can not be enabled before
open vector0 irq, we can't detect the specific error bits, so we
just write 1 to all interrupt source registers to clear.

Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 111 +++++++++++++++++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +
 3 files changed, 107 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 3ea305e..ab9c5d5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1595,6 +1595,12 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 	struct device *dev = &hdev->pdev->dev;
 	u32 status;
 
+	if (!test_bit(HCLGE_STATE_SERVICE_INITED, &hdev->state)) {
+		dev_err(dev,
+			"Can't recover - RAS error reported during dev init\n");
+		return PCI_ERS_RESULT_NONE;
+	}
+
 	status = hclge_read_dev(&hdev->hw, HCLGE_RAS_PF_OTHER_INT_STS_REG);
 
 	if (status & HCLGE_RAS_REG_NFE_MASK ||
@@ -1631,6 +1637,21 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
+static int hclge_clear_hw_msix_error(struct hclge_dev *hdev,
+				     struct hclge_desc *desc, bool is_mpf,
+				     u32 bd_num)
+{
+	if (is_mpf)
+		desc[0].opcode =
+			cpu_to_le16(HCLGE_QUERY_CLEAR_ALL_MPF_MSIX_INT);
+	else
+		desc[0].opcode = cpu_to_le16(HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT);
+
+	desc[0].flag = cpu_to_le16(HCLGE_CMD_FLAG_NO_INTR | HCLGE_CMD_FLAG_IN);
+
+	return hclge_cmd_send(&hdev->hw, &desc[0], bd_num);
+}
+
 /* hclge_query_8bd_info: query information about over_8bd_nfe_err
  * @hdev: pointer to struct hclge_dev
  * @vf_id: Index of the virtual function with error
@@ -1706,8 +1727,8 @@ static void hclge_handle_over_8bd_err(struct hclge_dev *hdev,
 	}
 }
 
-int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
-			       unsigned long *reset_requests)
+static int hclge_handle_all_hw_msix_error(struct hclge_dev *hdev,
+					  unsigned long *reset_requests)
 {
 	struct hclge_mac_tnl_stats mac_tnl_stats;
 	struct device *dev = &hdev->pdev->dev;
@@ -1764,8 +1785,7 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 				status, reset_requests);
 
 	/* clear all main PF MSIx errors */
-	hclge_cmd_reuse_desc(&desc[0], false);
-	ret = hclge_cmd_send(&hdev->hw, &desc[0], mpf_bd_num);
+	ret = hclge_clear_hw_msix_error(hdev, desc, true, mpf_bd_num);
 	if (ret) {
 		dev_err(dev, "clear all mpf msix int cmd failed (%d)\n",
 			ret);
@@ -1811,11 +1831,10 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 		hclge_handle_over_8bd_err(hdev, reset_requests);
 
 	/* clear all PF MSIx errors */
-	hclge_cmd_reuse_desc(&desc[0], false);
-	ret = hclge_cmd_send(&hdev->hw, &desc[0], pf_bd_num);
+	ret = hclge_clear_hw_msix_error(hdev, desc, false, pf_bd_num);
 	if (ret) {
-		dev_err(dev, "clear all pf msix int cmd failed (%d)\n",
-			ret);
+		dev_err(dev, "clear all pf msix int cmd failed (%d)\n", ret);
+		goto msi_error;
 	}
 
 	/* query and clear mac tnl interruptions */
@@ -1847,3 +1866,79 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 out:
 	return ret;
 }
+
+int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
+			       unsigned long *reset_requests)
+{
+	struct device *dev = &hdev->pdev->dev;
+
+	if (!test_bit(HCLGE_STATE_SERVICE_INITED, &hdev->state)) {
+		dev_err(dev,
+			"Can't handle - MSIx error reported during dev init\n");
+		return 0;
+	}
+
+	return hclge_handle_all_hw_msix_error(hdev, reset_requests);
+}
+
+void hclge_handle_all_hns_hw_errors(struct hnae3_ae_dev *ae_dev)
+{
+#define HCLGE_DESC_NO_DATA_LEN 8
+
+	struct hclge_dev *hdev = ae_dev->priv;
+	struct device *dev = &hdev->pdev->dev;
+	u32 mpf_bd_num, pf_bd_num, bd_num;
+	struct hclge_desc desc_bd;
+	struct hclge_desc *desc;
+	u32 status;
+	int ret;
+
+	ae_dev->hw_err_reset_req = 0;
+	status = hclge_read_dev(&hdev->hw, HCLGE_RAS_PF_OTHER_INT_STS_REG);
+
+	/* query the number of bds for the MSIx int status */
+	hclge_cmd_setup_basic_desc(&desc_bd, HCLGE_QUERY_MSIX_INT_STS_BD_NUM,
+				   true);
+	ret = hclge_cmd_send(&hdev->hw, &desc_bd, 1);
+	if (ret) {
+		dev_err(dev, "fail(%d) to query msix int status bd num\n",
+			ret);
+		return;
+	}
+
+	mpf_bd_num = le32_to_cpu(desc_bd.data[0]);
+	pf_bd_num = le32_to_cpu(desc_bd.data[1]);
+	bd_num = max_t(u32, mpf_bd_num, pf_bd_num);
+
+	desc = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
+	if (!desc)
+		return;
+
+	/* Clear HNS hw errors reported through msix  */
+	memset(&desc[0].data[0], 0xFF, mpf_bd_num * sizeof(struct hclge_desc) -
+	       HCLGE_DESC_NO_DATA_LEN);
+	ret = hclge_clear_hw_msix_error(hdev, desc, true, mpf_bd_num);
+	if (ret) {
+		dev_err(dev, "fail(%d) to clear mpf msix int during init\n",
+			ret);
+		goto msi_error;
+	}
+
+	memset(&desc[0].data[0], 0xFF, pf_bd_num * sizeof(struct hclge_desc) -
+	       HCLGE_DESC_NO_DATA_LEN);
+	ret = hclge_clear_hw_msix_error(hdev, desc, false, pf_bd_num);
+	if (ret) {
+		dev_err(dev, "fail(%d) to clear pf msix int during init\n",
+			ret);
+		goto msi_error;
+	}
+
+	/* Handle Non-fatal HNS RAS errors */
+	if (status & HCLGE_RAS_REG_NFE_MASK) {
+		dev_warn(dev, "HNS hw error(RAS) identified during init\n");
+		hclge_handle_all_ras_errors(hdev);
+	}
+
+msi_error:
+	kfree(desc);
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index be1186a..d821a76 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -123,6 +123,7 @@ struct hclge_hw_error {
 int hclge_config_mac_tnl_int(struct hclge_dev *hdev, bool en);
 int hclge_config_nic_hw_error(struct hclge_dev *hdev, bool state);
 int hclge_config_rocee_ras_interrupt(struct hclge_dev *hdev, bool en);
+void hclge_handle_all_hns_hw_errors(struct hnae3_ae_dev *ae_dev);
 pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev);
 int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 			       unsigned long *reset_requests);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f3e9030..d9863c30 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8611,6 +8611,9 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	hclge_clear_all_event_cause(hdev);
 
+	/* Log and clear the hw errors those already occurred */
+	hclge_handle_all_hns_hw_errors(ae_dev);
+
 	/* Enable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, true);
 
-- 
2.7.4

