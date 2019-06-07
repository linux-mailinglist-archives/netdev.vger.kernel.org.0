Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0EBB38287
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 04:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbfFGCFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 22:05:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58498 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728204AbfFGCFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 22:05:24 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EF31DEA096CB3D593D66;
        Fri,  7 Jun 2019 10:05:17 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 7 Jun 2019 10:05:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 06/12] net: hns3: trigger VF reset if a VF has an over_8bd_nfe_err
Date:   Fri, 7 Jun 2019 10:03:07 +0800
Message-ID: <1559872993-14507-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
References: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

We trigger PF reset when a RAS error of NIC named over_8bd_nfe_err
occurred before. But it is possible that a VF causes that error, it's
reasonable to trigger VF reset instead of PF reset in this case.
This patch add detection of vf_id if a over_8bd_nfe_err occurs, if
vf_id is 0, we trigger PF reset. Otherwise, we will trigger VF reset
on the VF with error.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 17 +++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 79 ++++++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |  3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  2 +-
 4 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 5e6c749..7d78b5a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -180,6 +180,9 @@ enum hclge_opcode_type {
 	HCLGE_OPC_CFG_COM_TQP_QUEUE	= 0x0B20,
 	HCLGE_OPC_RESET_TQP_QUEUE	= 0x0B22,
 
+	/* PPU commands */
+	HCLGE_OPC_PPU_PF_OTHER_INT_DFX	= 0x0B4A,
+
 	/* TSO command */
 	HCLGE_OPC_TSO_GENERIC_CONFIG	= 0x0C01,
 	HCLGE_OPC_GRO_GENERIC_CONFIG    = 0x0C10,
@@ -980,6 +983,20 @@ struct hclge_get_m7_bd_cmd {
 	u8 rsv[20];
 };
 
+struct hclge_query_ppu_pf_other_int_dfx_cmd {
+	__le16 over_8bd_no_fe_qid;
+	__le16 over_8bd_no_fe_vf_id;
+	__le16 tso_mss_cmp_min_err_qid;
+	__le16 tso_mss_cmp_min_err_vf_id;
+	__le16 tso_mss_cmp_max_err_qid;
+	__le16 tso_mss_cmp_max_err_vf_id;
+	__le16 tx_rd_fbd_poison_qid;
+	__le16 tx_rd_fbd_poison_vf_id;
+	__le16 rx_rd_fbd_poison_qid;
+	__le16 rx_rd_fbd_poison_vf_id;
+	u8 rsv[4];
+};
+
 int hclge_cmd_init(struct hclge_dev *hdev);
 static inline void hclge_write_reg(void __iomem *base, u32 reg, u32 value)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 4f2af3d..cb6ed8c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1687,6 +1687,81 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
+/* hclge_query_8bd_info: query information about over_8bd_nfe_err
+ * @hdev: pointer to struct hclge_dev
+ * @vf_id: Index of the virtual function with error
+ * @q_id: Physical index of the queue with error
+ *
+ * This function get specific index of queue and function which causes
+ * over_8bd_nfe_err by using command. If vf_id is 0, it means error is
+ * caused by PF instead of VF.
+ */
+static int hclge_query_over_8bd_err_info(struct hclge_dev *hdev, u16 *vf_id,
+					 u16 *q_id)
+{
+	struct hclge_query_ppu_pf_other_int_dfx_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_PPU_PF_OTHER_INT_DFX, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		return ret;
+
+	req = (struct hclge_query_ppu_pf_other_int_dfx_cmd *)desc.data;
+	*vf_id = le16_to_cpu(req->over_8bd_no_fe_vf_id);
+	*q_id = le16_to_cpu(req->over_8bd_no_fe_qid);
+
+	return 0;
+}
+
+/* hclge_handle_over_8bd_err: handle MSI-X error named over_8bd_nfe_err
+ * @hdev: pointer to struct hclge_dev
+ * @reset_requests: reset level that we need to trigger later
+ *
+ * over_8bd_nfe_err is a special MSI-X because it may caused by a VF, in
+ * that case, we need to trigger VF reset. Otherwise, a PF reset is needed.
+ */
+static void hclge_handle_over_8bd_err(struct hclge_dev *hdev,
+				      unsigned long *reset_requests)
+{
+	struct device *dev = &hdev->pdev->dev;
+	u16 vf_id;
+	u16 q_id;
+	int ret;
+
+	ret = hclge_query_over_8bd_err_info(hdev, &vf_id, &q_id);
+	if (ret) {
+		dev_err(dev, "fail(%d) to query over_8bd_no_fe info\n",
+			ret);
+		return;
+	}
+
+	dev_warn(dev, "PPU_PF_ABNORMAL_INT_ST over_8bd_no_fe found, vf_id(%d), queue_id(%d)\n",
+		 vf_id, q_id);
+
+	if (vf_id) {
+		if (vf_id >= hdev->num_alloc_vport) {
+			dev_err(dev, "invalid vf id(%d)\n", vf_id);
+			return;
+		}
+
+		/* If we need to trigger other reset whose level is higher
+		 * than HNAE3_VF_FUNC_RESET, no need to trigger a VF reset
+		 * here.
+		 */
+		if (*reset_requests != 0)
+			return;
+
+		ret = hclge_inform_reset_assert_to_vf(&hdev->vport[vf_id]);
+		if (ret)
+			dev_warn(dev, "inform reset to vf(%d) failed %d!\n",
+				 hdev->vport->vport_id, ret);
+	} else {
+		set_bit(HNAE3_FUNC_RESET, reset_requests);
+	}
+}
+
 int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 			       unsigned long *reset_requests)
 {
@@ -1799,6 +1874,10 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 		set_bit(reset_level, reset_requests);
 	}
 
+	status = le32_to_cpu(*desc_data) & HCLGE_PPU_PF_OVER_8BD_ERR_MASK;
+	if (status)
+		hclge_handle_over_8bd_err(hdev, reset_requests);
+
 	/* clear all PF MSIx errors */
 	hclge_cmd_reuse_desc(&desc[0], false);
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], pf_bd_num);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 6684733..be1186a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -83,7 +83,8 @@
 #define HCLGE_PPU_MPF_INT_ST3_MASK	GENMASK(7, 0)
 #define HCLGE_PPU_MPF_INT_ST2_MSIX_MASK	GENMASK(29, 28)
 #define HCLGE_PPU_PF_INT_RAS_MASK	0x18
-#define HCLGE_PPU_PF_INT_MSIX_MASK	0x27
+#define HCLGE_PPU_PF_INT_MSIX_MASK	0x26
+#define HCLGE_PPU_PF_OVER_8BD_ERR_MASK	0x01
 #define HCLGE_QCN_FIFO_INT_MASK		GENMASK(17, 0)
 #define HCLGE_QCN_ECC_INT_MASK		GENMASK(21, 0)
 #define HCLGE_NCSI_ECC_INT_MASK		GENMASK(1, 0)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index d20f017..2003817 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -93,7 +93,7 @@ int hclge_inform_reset_assert_to_vf(struct hclge_vport *vport)
 	else if (hdev->reset_type == HNAE3_FLR_RESET)
 		reset_type = HNAE3_VF_FULL_RESET;
 	else
-		return -EINVAL;
+		reset_type = HNAE3_VF_FUNC_RESET;
 
 	memcpy(&msg_data[0], &reset_type, sizeof(u16));
 
-- 
2.7.4

