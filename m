Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB92A43E7A
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389379AbfFMPuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:50:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18149 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731693AbfFMJOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 05:14:18 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4BBF0C634AE669F01C9C;
        Thu, 13 Jun 2019 17:14:14 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 13 Jun 2019 17:14:06 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 01/12] net: hns3: delay setting of reset level for hw errors until slot_reset is called
Date:   Thu, 13 Jun 2019 17:12:21 +0800
Message-ID: <1560417152-53050-2-git-send-email-tanhuazhong@huawei.com>
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

Presently the error handling code sets the reset level required
for the recovery of the hw errors to the reset framework in the
error_detected AER callback. However the rest_event would be
called later from the slot_reset callback. This can cause issue
of using the wrong reset_level if a high priority reset request
occur before the slot_reset is called.

This patch delays setting of the reset level, required
for the hw errors, to the reset framework until the
slot_reset is called.

Reported-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  3 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 15 ++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 61 ++++++++++------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 14 +++--
 4 files changed, 51 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 63cdc18..79044b5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -214,6 +214,7 @@ struct hnae3_ae_dev {
 	struct list_head node;
 	u32 flag;
 	u8 override_pci_need_reset; /* fix to stop multiple reset happening */
+	unsigned long hw_err_reset_req;
 	enum hnae3_reset_type reset_type;
 	void *priv;
 };
@@ -459,6 +460,8 @@ struct hnae3_ae_ops {
 				  u16 vlan, u8 qos, __be16 proto);
 	int (*enable_hw_strip_rxvtag)(struct hnae3_handle *handle, bool enable);
 	void (*reset_event)(struct pci_dev *pdev, struct hnae3_handle *handle);
+	enum hnae3_reset_type (*get_reset_level)(struct hnae3_ae_dev *ae_dev,
+						 unsigned long *addr);
 	void (*set_default_reset_request)(struct hnae3_ae_dev *ae_dev,
 					  enum hnae3_reset_type rst_type);
 	void (*get_channels)(struct hnae3_handle *handle,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index fe2c2c5..66d733b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1930,17 +1930,22 @@ static pci_ers_result_t hns3_error_detected(struct pci_dev *pdev,
 static pci_ers_result_t hns3_slot_reset(struct pci_dev *pdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
+	const struct hnae3_ae_ops *ops = ae_dev->ops;
+	enum hnae3_reset_type reset_type;
 	struct device *dev = &pdev->dev;
 
-	dev_info(dev, "requesting reset due to PCI error\n");
-
 	if (!ae_dev || !ae_dev->ops)
 		return PCI_ERS_RESULT_NONE;
 
 	/* request the reset */
-	if (ae_dev->ops->reset_event) {
-		if (!ae_dev->override_pci_need_reset)
-			ae_dev->ops->reset_event(pdev, NULL);
+	if (ops->reset_event) {
+		if (!ae_dev->override_pci_need_reset) {
+			reset_type = ops->get_reset_level(ae_dev,
+						&ae_dev->hw_err_reset_req);
+			ops->set_default_reset_request(ae_dev, reset_type);
+			dev_info(dev, "requesting reset due to PCI error\n");
+			ops->reset_event(pdev, NULL);
+		}
 
 		return PCI_ERS_RESULT_RECOVERED;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 4126287..1a2ea1b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1069,13 +1069,6 @@ static int hclge_config_ssu_hw_err_int(struct hclge_dev *hdev, bool en)
 	return ret;
 }
 
-#define HCLGE_SET_DEFAULT_RESET_REQUEST(reset_type) \
-	do { \
-		if (ae_dev->ops->set_default_reset_request) \
-			ae_dev->ops->set_default_reset_request(ae_dev, \
-							       reset_type); \
-	} while (0)
-
 /* hclge_handle_mpf_ras_error: handle all main PF RAS errors
  * @hdev: pointer to struct hclge_dev
  * @desc: descriptor for describing the command
@@ -1110,7 +1103,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 		reset_level = hclge_log_error(dev, "IMP_TCM_ECC_INT_STS",
 					      &hclge_imp_tcm_ecc_int[0],
 					      status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	status = le32_to_cpu(desc[0].data[1]);
@@ -1118,20 +1111,18 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 		reset_level = hclge_log_error(dev, "CMDQ_MEM_ECC_INT_STS",
 					      &hclge_cmdq_nic_mem_ecc_int[0],
 					      status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
-	if ((le32_to_cpu(desc[0].data[2])) & BIT(0)) {
+	if ((le32_to_cpu(desc[0].data[2])) & BIT(0))
 		dev_warn(dev, "imp_rd_data_poison_err found\n");
-		HCLGE_SET_DEFAULT_RESET_REQUEST(HNAE3_NONE_RESET);
-	}
 
 	status = le32_to_cpu(desc[0].data[3]);
 	if (status) {
 		reset_level = hclge_log_error(dev, "TQP_INT_ECC_INT_STS",
 					      &hclge_tqp_int_ecc_int[0],
 					      status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	status = le32_to_cpu(desc[0].data[4]);
@@ -1139,7 +1130,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 		reset_level = hclge_log_error(dev, "MSIX_ECC_INT_STS",
 					      &hclge_msix_sram_ecc_int[0],
 					      status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	/* log SSU(Storage Switch Unit) errors */
@@ -1149,14 +1140,14 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 		reset_level = hclge_log_error(dev, "SSU_ECC_MULTI_BIT_INT_0",
 					      &hclge_ssu_mem_ecc_err_int[0],
 					      status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	status = le32_to_cpu(*(desc_data + 3)) & BIT(0);
 	if (status) {
 		dev_warn(dev, "SSU_ECC_MULTI_BIT_INT_1 ssu_mem32_ecc_mbit_err found [error status=0x%x]\n",
 			 status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(HNAE3_GLOBAL_RESET);
+		set_bit(HNAE3_GLOBAL_RESET, &ae_dev->hw_err_reset_req);
 	}
 
 	status = le32_to_cpu(*(desc_data + 4)) & HCLGE_SSU_COMMON_ERR_INT_MASK;
@@ -1164,7 +1155,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 		reset_level = hclge_log_error(dev, "SSU_COMMON_ERR_INT",
 					      &hclge_ssu_com_err_int[0],
 					      status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	/* log IGU(Ingress Unit) errors */
@@ -1173,7 +1164,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 	if (status) {
 		reset_level = hclge_log_error(dev, "IGU_INT_STS",
 					      &hclge_igu_int[0], status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	/* log PPP(Programmable Packet Process) errors */
@@ -1184,7 +1175,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 			hclge_log_error(dev, "PPP_MPF_ABNORMAL_INT_ST1",
 					&hclge_ppp_mpf_abnormal_int_st1[0],
 					status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	status = le32_to_cpu(*(desc_data + 3)) & HCLGE_PPP_MPF_INT_ST3_MASK;
@@ -1193,7 +1184,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 			hclge_log_error(dev, "PPP_MPF_ABNORMAL_INT_ST3",
 					&hclge_ppp_mpf_abnormal_int_st3[0],
 					status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	/* log PPU(RCB) errors */
@@ -1202,7 +1193,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 	if (status) {
 		dev_warn(dev, "PPU_MPF_ABNORMAL_INT_ST1 %s found\n",
 			 "rpu_rx_pkt_ecc_mbit_err");
-		HCLGE_SET_DEFAULT_RESET_REQUEST(HNAE3_GLOBAL_RESET);
+		set_bit(HNAE3_GLOBAL_RESET, &ae_dev->hw_err_reset_req);
 	}
 
 	status = le32_to_cpu(*(desc_data + 2));
@@ -1211,7 +1202,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 			hclge_log_error(dev, "PPU_MPF_ABNORMAL_INT_ST2",
 					&hclge_ppu_mpf_abnormal_int_st2[0],
 					status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	status = le32_to_cpu(*(desc_data + 3)) & HCLGE_PPU_MPF_INT_ST3_MASK;
@@ -1220,7 +1211,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 			hclge_log_error(dev, "PPU_MPF_ABNORMAL_INT_ST3",
 					&hclge_ppu_mpf_abnormal_int_st3[0],
 					status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	/* log TM(Traffic Manager) errors */
@@ -1229,7 +1220,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 	if (status) {
 		reset_level = hclge_log_error(dev, "TM_SCH_RINT",
 					      &hclge_tm_sch_rint[0], status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	/* log QCN(Quantized Congestion Control) errors */
@@ -1238,7 +1229,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 	if (status) {
 		reset_level = hclge_log_error(dev, "QCN_FIFO_RINT",
 					      &hclge_qcn_fifo_rint[0], status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	status = le32_to_cpu(*(desc_data + 1)) & HCLGE_QCN_ECC_INT_MASK;
@@ -1246,7 +1237,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 		reset_level = hclge_log_error(dev, "QCN_ECC_RINT",
 					      &hclge_qcn_ecc_rint[0],
 					      status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	/* log NCSI errors */
@@ -1255,7 +1246,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 	if (status) {
 		reset_level = hclge_log_error(dev, "NCSI_ECC_INT_RPT",
 					      &hclge_ncsi_err_int[0], status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	/* clear all main PF RAS errors */
@@ -1301,7 +1292,7 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 		reset_level = hclge_log_error(dev, "SSU_PORT_BASED_ERR_INT",
 					      &hclge_ssu_port_based_err_int[0],
 					      status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	status = le32_to_cpu(desc[0].data[1]);
@@ -1309,7 +1300,7 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 		reset_level = hclge_log_error(dev, "SSU_FIFO_OVERFLOW_INT",
 					      &hclge_ssu_fifo_overflow_int[0],
 					      status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	status = le32_to_cpu(desc[0].data[2]);
@@ -1317,7 +1308,7 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 		reset_level = hclge_log_error(dev, "SSU_ETS_TCG_INT",
 					      &hclge_ssu_ets_tcg_int[0],
 					      status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	/* log IGU(Ingress Unit) EGU(Egress Unit) TNL errors */
@@ -1327,7 +1318,7 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 		reset_level = hclge_log_error(dev, "IGU_EGU_TNL_INT_STS",
 					      &hclge_igu_egu_tnl_int[0],
 					      status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	/* log PPU(RCB) errors */
@@ -1337,7 +1328,7 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 		reset_level = hclge_log_error(dev, "PPU_PF_ABNORMAL_INT_ST0",
 					      &hclge_ppu_pf_abnormal_int[0],
 					      status);
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_level);
+		set_bit(reset_level, &ae_dev->hw_err_reset_req);
 	}
 
 	/* clear all PF RAS errors */
@@ -1597,7 +1588,7 @@ static void hclge_handle_rocee_ras_error(struct hnae3_ae_dev *ae_dev)
 
 	reset_type = hclge_log_and_clear_rocee_ras_error(hdev);
 	if (reset_type != HNAE3_NONE_RESET)
-		HCLGE_SET_DEFAULT_RESET_REQUEST(reset_type);
+		set_bit(reset_type, &ae_dev->hw_err_reset_req);
 }
 
 static const struct hclge_hw_blk hw_blk[] = {
@@ -1657,6 +1648,10 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 
 	status = hclge_read_dev(&hdev->hw, HCLGE_RAS_PF_OTHER_INT_STS_REG);
 
+	if (status & HCLGE_RAS_REG_NFE_MASK ||
+	    status & HCLGE_RAS_REG_ROCEE_ERR_MASK)
+		ae_dev->hw_err_reset_req = 0;
+
 	/* Handling Non-fatal HNS RAS errors */
 	if (status & HCLGE_RAS_REG_NFE_MASK) {
 		dev_warn(dev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b7ba893..f3e9030 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -41,6 +41,8 @@ static int hclge_set_umv_space(struct hclge_dev *hdev, u16 space_size,
 			       u16 *allocated_size, bool is_alloc);
 static void hclge_rfs_filter_expire(struct hclge_dev *hdev);
 static void hclge_clear_arfs_rules(struct hnae3_handle *handle);
+static enum hnae3_reset_type hclge_get_reset_level(struct hnae3_ae_dev *ae_dev,
+						   unsigned long *addr);
 
 static struct hnae3_ae_algo ae_algo;
 
@@ -3066,10 +3068,11 @@ static void hclge_do_reset(struct hclge_dev *hdev)
 	}
 }
 
-static enum hnae3_reset_type hclge_get_reset_level(struct hclge_dev *hdev,
+static enum hnae3_reset_type hclge_get_reset_level(struct hnae3_ae_dev *ae_dev,
 						   unsigned long *addr)
 {
 	enum hnae3_reset_type rst_level = HNAE3_NONE_RESET;
+	struct hclge_dev *hdev = ae_dev->priv;
 
 	/* first, resolve any unknown reset type to the known type(s) */
 	if (test_bit(HNAE3_UNKNOWN_RESET, addr)) {
@@ -3398,7 +3401,7 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
 		return;
 	else if (hdev->default_reset_request)
 		hdev->reset_level =
-			hclge_get_reset_level(hdev,
+			hclge_get_reset_level(ae_dev,
 					      &hdev->default_reset_request);
 	else if (time_after(jiffies, (hdev->last_reset_time + 4 * 5 * HZ)))
 		hdev->reset_level = HNAE3_FUNC_RESET;
@@ -3434,6 +3437,8 @@ static void hclge_reset_timer(struct timer_list *t)
 
 static void hclge_reset_subtask(struct hclge_dev *hdev)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+
 	/* check if there is any ongoing reset in the hardware. This status can
 	 * be checked from reset_pending. If there is then, we need to wait for
 	 * hardware to complete reset.
@@ -3444,12 +3449,12 @@ static void hclge_reset_subtask(struct hclge_dev *hdev)
 	 *       now.
 	 */
 	hdev->last_reset_time = jiffies;
-	hdev->reset_type = hclge_get_reset_level(hdev, &hdev->reset_pending);
+	hdev->reset_type = hclge_get_reset_level(ae_dev, &hdev->reset_pending);
 	if (hdev->reset_type != HNAE3_NONE_RESET)
 		hclge_reset(hdev);
 
 	/* check if we got any *new* reset requests to be honored */
-	hdev->reset_type = hclge_get_reset_level(hdev, &hdev->reset_request);
+	hdev->reset_type = hclge_get_reset_level(ae_dev, &hdev->reset_request);
 	if (hdev->reset_type != HNAE3_NONE_RESET)
 		hclge_do_reset(hdev);
 
@@ -9231,6 +9236,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.set_vf_vlan_filter = hclge_set_vf_vlan_filter,
 	.enable_hw_strip_rxvtag = hclge_en_hw_strip_rxvtag,
 	.reset_event = hclge_reset_event,
+	.get_reset_level = hclge_get_reset_level,
 	.set_default_reset_request = hclge_set_def_reset_request,
 	.get_tqps_and_rss_info = hclge_get_tqps_and_rss_info,
 	.set_channels = hclge_set_channels,
-- 
2.7.4

