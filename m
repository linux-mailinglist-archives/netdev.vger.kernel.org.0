Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C3F39F761
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhFHNNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:13:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8093 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbhFHNNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:13:36 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzrCl0QQmzYs0j;
        Tue,  8 Jun 2021 21:08:51 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 21:11:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 21:11:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/5] net: hns3: add support for handling all errors through MSI-X
Date:   Tue, 8 Jun 2021 21:08:27 +0800
Message-ID: <1623157711-26846-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623157711-26846-1-git-send-email-huangguangbin2@huawei.com>
References: <1623157711-26846-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Currently, hardware errors can be reported through AER or MSI-X mode.
However, the AER mode is intended to handle only bus errors, but not
hardware errors. On the other hand, virtual machines cannot handle
AER errors. When an AER error is reported, virtual machines will be
suspended. So add support for handling all these hardware errors
through MSI-X mode which depends on a newer version of firmware,
and reserve the handler of the AER mode for compatibility.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 16 ++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 47 +++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 3 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index f125aa425872..540dd15d7771 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1611,11 +1611,27 @@ static const struct hclge_hw_blk hw_blk[] = {
 	{ /* sentinel */ }
 };
 
+static void hclge_config_all_msix_error(struct hclge_dev *hdev, bool enable)
+{
+	u32 reg_val;
+
+	reg_val = hclge_read_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG);
+
+	if (enable)
+		reg_val |= BIT(HCLGE_VECTOR0_ALL_MSIX_ERR_B);
+	else
+		reg_val &= ~BIT(HCLGE_VECTOR0_ALL_MSIX_ERR_B);
+
+	hclge_write_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG, reg_val);
+}
+
 int hclge_config_nic_hw_error(struct hclge_dev *hdev, bool state)
 {
 	const struct hclge_hw_blk *module = hw_blk;
 	int ret = 0;
 
+	hclge_config_all_msix_error(hdev, state);
+
 	while (module->name) {
 		if (module->config_err_int) {
 			ret = module->config_err_int(hdev, state);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 45102681bd2a..d5be3bc50b5c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3307,11 +3307,13 @@ static int hclge_set_vf_link_state(struct hnae3_handle *handle, int vf,
 
 static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 {
-	u32 cmdq_src_reg, msix_src_reg;
+	u32 cmdq_src_reg, msix_src_reg, hw_err_src_reg;
 
 	/* fetch the events from their corresponding regs */
 	cmdq_src_reg = hclge_read_dev(&hdev->hw, HCLGE_VECTOR0_CMDQ_SRC_REG);
 	msix_src_reg = hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS);
+	hw_err_src_reg = hclge_read_dev(&hdev->hw,
+					HCLGE_RAS_PF_OTHER_INT_STS_REG);
 
 	/* Assumption: If by any chance reset and mailbox events are reported
 	 * together then we will only process reset event in this go and will
@@ -3339,11 +3341,11 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 		return HCLGE_VECTOR0_EVENT_RST;
 	}
 
-	/* check for vector0 msix event source */
-	if (msix_src_reg & HCLGE_VECTOR0_REG_MSIX_MASK) {
-		*clearval = msix_src_reg;
+	/* check for vector0 msix event and hardware error event source */
+	if (msix_src_reg & HCLGE_VECTOR0_REG_MSIX_MASK ||
+	    hw_err_src_reg & HCLGE_RAS_REG_NFE_MASK ||
+	    hw_err_src_reg & HCLGE_RAS_REG_ROCEE_ERR_MASK)
 		return HCLGE_VECTOR0_EVENT_ERR;
-	}
 
 	/* check for vector0 mailbox(=CMDQ RX) event source */
 	if (BIT(HCLGE_VECTOR0_RX_CMDQ_INT_B) & cmdq_src_reg) {
@@ -3354,9 +3356,8 @@ static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
 
 	/* print other vector0 event source */
 	dev_info(&hdev->pdev->dev,
-		 "CMDQ INT status:0x%x, other INT status:0x%x\n",
-		 cmdq_src_reg, msix_src_reg);
-	*clearval = msix_src_reg;
+		 "INT status: CMDQ(%#x) HW errors(%#x) other(%#x)\n",
+		 cmdq_src_reg, hw_err_src_reg, msix_src_reg);
 
 	return HCLGE_VECTOR0_EVENT_OTHER;
 }
@@ -3427,15 +3428,10 @@ static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 
 	hclge_clear_event_cause(hdev, event_cause, clearval);
 
-	/* Enable interrupt if it is not cause by reset. And when
-	 * clearval equal to 0, it means interrupt status may be
-	 * cleared by hardware before driver reads status register.
-	 * For this case, vector0 interrupt also should be enabled.
-	 */
-	if (!clearval ||
-	    event_cause == HCLGE_VECTOR0_EVENT_MBX) {
+	/* Enable interrupt if it is not caused by reset event or error event */
+	if (event_cause == HCLGE_VECTOR0_EVENT_MBX ||
+	    event_cause == HCLGE_VECTOR0_EVENT_OTHER)
 		hclge_enable_vector(&hdev->misc_vector, true);
-	}
 
 	return IRQ_HANDLED;
 }
@@ -4244,22 +4240,27 @@ static void hclge_misc_err_recovery(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct device *dev = &hdev->pdev->dev;
+	enum hnae3_reset_type reset_type;
 	u32 msix_sts_reg;
 
 	msix_sts_reg = hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS);
-
 	if (msix_sts_reg & HCLGE_VECTOR0_REG_MSIX_MASK) {
-		if (hclge_handle_hw_msix_error(hdev,
-					       &hdev->default_reset_request))
+		if (hclge_handle_hw_msix_error
+				(hdev, &hdev->default_reset_request))
 			dev_info(dev, "received msix interrupt 0x%x\n",
 				 msix_sts_reg);
+	}
+	hclge_enable_vector(&hdev->misc_vector, true);
 
-		if (hdev->default_reset_request)
-			if (ae_dev->ops->reset_event)
-				ae_dev->ops->reset_event(hdev->pdev, NULL);
+	hclge_handle_hw_ras_error(ae_dev);
+	if (ae_dev->hw_err_reset_req) {
+		reset_type = hclge_get_reset_level(ae_dev,
+						   &ae_dev->hw_err_reset_req);
+		hclge_set_def_reset_request(ae_dev, reset_type);
 	}
 
-	hclge_enable_vector(&hdev->misc_vector, true);
+	if (hdev->default_reset_request && ae_dev->ops->reset_event)
+		ae_dev->ops->reset_event(hdev->pdev, NULL);
 }
 
 static void hclge_errhand_service_task(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9b8abb5d7a8e..582972a6f60e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -190,6 +190,7 @@ enum HLCGE_PORT_TYPE {
 #define HCLGE_VECTOR0_IMP_RESET_INT_B	1
 #define HCLGE_VECTOR0_IMP_CMDQ_ERR_B	4U
 #define HCLGE_VECTOR0_IMP_RD_POISON_B	5U
+#define HCLGE_VECTOR0_ALL_MSIX_ERR_B	6U
 
 #define HCLGE_MAC_DEFAULT_FRAME \
 	(ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN + ETH_DATA_LEN)
-- 
2.8.1

