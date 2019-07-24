Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38EC672553
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 05:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfGXDWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 23:22:05 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50514 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725837AbfGXDWF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 23:22:05 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 75780A375791336FA717;
        Wed, 24 Jul 2019 11:20:52 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 24 Jul 2019 11:20:45 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/11] net: hns3: add support for handling IMP error
Date:   Wed, 24 Jul 2019 11:18:47 +0800
Message-ID: <1563938327-9865-12-git-send-email-tanhuazhong@huawei.com>
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

From: Weihang Li <liweihang@hisilicon.com>

When IMP goes errors, the hardware reports a RAS to the driver,
the driver record this kind of error. Then a IMP reset will happen,
the driver checks the reason and takes the corresponding action
when doing IMP reset.

So this patch adds imp_err_state field to the struct hclge_dev
to record the error type, and handle_imp_error ops to handle it.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 37 ++++++++++++++++++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |  4 +++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 29 +++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  9 ++++++
 5 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a4624db..3a1d6cc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -515,6 +515,7 @@ struct hnae3_ae_ops {
 	int (*mac_connect_phy)(struct hnae3_handle *handle);
 	void (*mac_disconnect_phy)(struct hnae3_handle *handle);
 	void (*restore_vlan_table)(struct hnae3_handle *handle);
+	void (*handle_imp_error)(struct hnae3_handle *handle);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 0a72438..25df66d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -683,6 +683,28 @@ static int hclge_cmd_query_error(struct hclge_dev *hdev,
 	return ret;
 }
 
+static int hclge_check_imp_poison_err(struct hclge_dev *hdev)
+{
+	struct device *dev = &hdev->pdev->dev;
+	int ras_status;
+	int ret = false;
+
+	ras_status = hclge_read_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG);
+	if (ras_status & HCLGE_RAS_IMP_RD_POISON_MASK) {
+		set_bit(HCLGE_IMP_RD_POISON, &hdev->imp_err_state);
+		/* This error will be handle by IMP reset */
+		dev_info(dev, "IMP RD poison detected!\n");
+		ret = true;
+	} else if (ras_status & HCLGE_RAS_IMP_CMDQ_ERR_MASK) {
+		set_bit(HCLGE_IMP_CMDQ_ERROR, &hdev->imp_err_state);
+		/* This error will be handle by IMP reset */
+		dev_info(dev, "IMP CMDQ error detected!\n");
+		ret = true;
+	}
+
+	return ret;
+}
+
 static int hclge_clear_mac_tnl_int(struct hclge_dev *hdev)
 {
 	struct hclge_desc desc;
@@ -1321,10 +1343,12 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 	/* log PPU(RCB) errors */
 	desc_data = (__le32 *)&desc[3];
 	status = le32_to_cpu(*desc_data) & HCLGE_PPU_PF_INT_RAS_MASK;
-	if (status)
+	if (status) {
 		hclge_log_error(dev, "PPU_PF_ABNORMAL_INT_ST0",
 				&hclge_ppu_pf_abnormal_int[0], status,
 				&ae_dev->hw_err_reset_req);
+		hdev->ppu_poison_ras_err = true;
+	}
 
 	/* clear all PF RAS errors */
 	hclge_cmd_reuse_desc(&desc[0], false);
@@ -1632,6 +1656,7 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 	struct hclge_dev *hdev = ae_dev->priv;
 	struct device *dev = &hdev->pdev->dev;
 	u32 status;
+	int ret;
 
 	if (!test_bit(HCLGE_STATE_SERVICE_INITED, &hdev->state)) {
 		dev_err(dev,
@@ -1639,6 +1664,9 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 		return PCI_ERS_RESULT_NONE;
 	}
 
+	if (hclge_check_imp_poison_err(hdev))
+		return PCI_ERS_RESULT_RECOVERED;
+
 	status = hclge_read_dev(&hdev->hw, HCLGE_RAS_PF_OTHER_INT_STS_REG);
 
 	if (status & HCLGE_RAS_REG_NFE_MASK ||
@@ -1652,7 +1680,12 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 		dev_warn(dev,
 			 "HNS Non-Fatal RAS error(status=0x%x) identified\n",
 			 status);
-		hclge_handle_all_ras_errors(hdev);
+		ret = hclge_handle_all_ras_errors(hdev);
+		if (ret) {
+			ret = hclge_check_imp_poison_err(hdev);
+			if (ret)
+				return PCI_ERS_RESULT_RECOVERED;
+		}
 	}
 
 	/* Handling Non-fatal Rocee RAS errors */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 7ea8bb2..4839fc4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -12,6 +12,10 @@
 #define HCLGE_PF_MSIX_INT_MIN_BD_NUM	4
 
 #define HCLGE_RAS_PF_OTHER_INT_STS_REG   0x20B00
+#define HCLGE_RAS_IMP_RD_POISON_MASK \
+	BIT(HCLGE_VECTOR0_IMP_RD_POISON_B)
+#define HCLGE_RAS_IMP_CMDQ_ERR_MASK \
+	BIT(HCLGE_VECTOR0_IMP_CMDQ_ERR_B)
 #define HCLGE_RAS_REG_NFE_MASK   0xFF00
 #define HCLGE_RAS_REG_ROCEE_ERR_MASK   0x3000000
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 45acbc9..36a2b65 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3281,6 +3281,7 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 {
 #define HCLGE_RESET_SYNC_TIME 100
 
+	struct hnae3_handle *handle = &hdev->vport[0].nic;
 	u32 reg_val;
 	int ret = 0;
 
@@ -3315,6 +3316,8 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 		hdev->rst_stats.flr_rst_cnt++;
 		break;
 	case HNAE3_IMP_RESET:
+		if (handle && handle->ae_algo->ops->handle_imp_error)
+			handle->ae_algo->ops->handle_imp_error(handle);
 		reg_val = hclge_read_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG);
 		hclge_write_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG,
 				BIT(HCLGE_VECTOR0_IMP_RESET_INT_B) | reg_val);
@@ -3517,6 +3520,9 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
 	else if (time_after(jiffies, (hdev->last_reset_time + 4 * 5 * HZ)))
 		hdev->reset_level = HNAE3_FUNC_RESET;
 
+	if (hdev->ppu_poison_ras_err)
+		hdev->ppu_poison_ras_err = false;
+
 	dev_info(&hdev->pdev->dev, "received reset event , reset type is %d",
 		 hdev->reset_level);
 
@@ -3545,6 +3551,27 @@ static void hclge_reset_timer(struct timer_list *t)
 	hclge_reset_event(hdev->pdev, NULL);
 }
 
+void hclge_handle_imp_error(struct hnae3_handle *handle)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	u32 reg_val;
+
+	if (test_and_clear_bit(HCLGE_IMP_RD_POISON, &hdev->imp_err_state)) {
+		dev_err(&hdev->pdev->dev, "Detected IMP RD poison!\n");
+		reg_val = hclge_read_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG) &
+			  ~BIT(HCLGE_VECTOR0_IMP_RD_POISON_B);
+		hclge_write_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG, reg_val);
+	}
+
+	if (test_and_clear_bit(HCLGE_IMP_CMDQ_ERROR, &hdev->imp_err_state)) {
+		dev_err(&hdev->pdev->dev, "Detected IMP CMDQ error!\n");
+		reg_val = hclge_read_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG) &
+			  ~BIT(HCLGE_VECTOR0_IMP_CMDQ_ERR_B);
+		hclge_write_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG, reg_val);
+	}
+}
+
 static void hclge_reset_subtask(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
@@ -3560,6 +3587,7 @@ static void hclge_reset_subtask(struct hclge_dev *hdev)
 	 */
 	hdev->last_reset_time = jiffies;
 	hdev->reset_type = hclge_get_reset_level(ae_dev, &hdev->reset_pending);
+
 	if (hdev->reset_type != HNAE3_NONE_RESET)
 		hclge_reset(hdev);
 
@@ -9516,6 +9544,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.mac_connect_phy = hclge_mac_connect_phy,
 	.mac_disconnect_phy = hclge_mac_disconnect_phy,
 	.restore_vlan_table = hclge_restore_vlan_table,
+	.handle_imp_error = hclge_handle_imp_error,
 };
 
 static struct hnae3_ae_algo ae_algo = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 688e425..7b7ba30 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -178,6 +178,8 @@ enum HLCGE_PORT_TYPE {
 #define HCLGE_VECTOR0_RX_CMDQ_INT_B	1
 
 #define HCLGE_VECTOR0_IMP_RESET_INT_B	1
+#define HCLGE_VECTOR0_IMP_CMDQ_ERR_B	4
+#define HCLGE_VECTOR0_IMP_RD_POISON_B	5
 
 #define HCLGE_MAC_DEFAULT_FRAME \
 	(ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN + ETH_DATA_LEN)
@@ -676,6 +678,11 @@ enum HCLGE_MAC_ADDR_TYPE {
 	HCLGE_MAC_ADDR_MC
 };
 
+enum HCLGE_IMP_ERR_TYPE {
+	HCLGE_IMP_RD_POISON,
+	HCLGE_IMP_CMDQ_ERROR,
+};
+
 struct hclge_vport_vlan_cfg {
 	struct list_head node;
 	int hd_tbl_status;
@@ -777,6 +784,8 @@ struct hclge_dev {
 	u8 tc_num_last_time;
 	enum hclge_fc_mode fc_mode_last_time;
 	u8 support_sfp_query;
+	bool ppu_poison_ras_err;
+	unsigned long imp_err_state;
 
 #define HCLGE_FLAG_TC_BASE_SCH_MODE		1
 #define HCLGE_FLAG_VNET_BASE_SCH_MODE		2
-- 
2.7.4

