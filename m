Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780BC48545C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbiAEOZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:29 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34876 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240680AbiAEOZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:20 -0500
Received: from kwepemi100001.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JTWvr2vP5zccLm;
        Wed,  5 Jan 2022 22:24:40 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100001.china.huawei.com (7.221.188.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:13 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 02/15] net: hns3: refactor hclge_comm_send function in PF/VF drivers
Date:   Wed, 5 Jan 2022 22:20:02 +0800
Message-ID: <20220105142015.51097-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220105142015.51097-1-huangguangbin2@huawei.com>
References: <20220105142015.51097-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently, there are two different sets of special command codes in PF and
VF cmdq modules, this is because VF driver only uses small part of all the
command codes. In other words, these not used command codes in VF are also
sepcial command codes theoretically.

So this patch unifes the special command codes and deletes the bool param
is_pf of hclge_comm_send. All the related functions are refactored
according to the new hclge_comm_send function prototype.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hns3/hns3_common/hclge_comm_cmd.c         | 73 ++++++++-----------
 .../hns3/hns3_common/hclge_comm_cmd.h         |  6 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  6 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  6 +-
 4 files changed, 38 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index e3c9d2e400e4..d3e16e5764a0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -73,7 +73,7 @@ void hclge_comm_cmd_setup_basic_desc(struct hclge_desc *desc,
 		desc->flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_WR);
 }
 
-int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev, bool is_pf,
+int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev,
 				      struct hclge_comm_hw *hw, bool en)
 {
 	struct hclge_comm_firmware_compat_cmd *req;
@@ -96,7 +96,7 @@ int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev, bool is_pf,
 		req->compat = cpu_to_le32(compat);
 	}
 
-	return hclge_comm_cmd_send(hw, &desc, 1, is_pf);
+	return hclge_comm_cmd_send(hw, &desc, 1);
 }
 
 void hclge_comm_free_cmd_desc(struct hclge_comm_cmq_ring *ring)
@@ -209,7 +209,7 @@ int hclge_comm_cmd_query_version_and_capability(struct hnae3_ae_dev *ae_dev,
 	resp = (struct hclge_comm_query_version_cmd *)desc.data;
 	resp->api_caps = hclge_comm_build_api_caps();
 
-	ret = hclge_comm_cmd_send(hw, &desc, 1, is_pf);
+	ret = hclge_comm_cmd_send(hw, &desc, 1);
 	if (ret)
 		return ret;
 
@@ -227,46 +227,32 @@ int hclge_comm_cmd_query_version_and_capability(struct hnae3_ae_dev *ae_dev,
 	return ret;
 }
 
-static bool hclge_is_elem_in_array(const u16 *spec_opcode, u32 size, u16 opcode)
+static const u16 spec_opcode[] = { HCLGE_COMM_OPC_STATS_64_BIT,
+				   HCLGE_COMM_OPC_STATS_32_BIT,
+				   HCLGE_COMM_OPC_STATS_MAC,
+				   HCLGE_COMM_OPC_STATS_MAC_ALL,
+				   HCLGE_COMM_OPC_QUERY_32_BIT_REG,
+				   HCLGE_COMM_OPC_QUERY_64_BIT_REG,
+				   HCLGE_COMM_QUERY_CLEAR_MPF_RAS_INT,
+				   HCLGE_COMM_QUERY_CLEAR_PF_RAS_INT,
+				   HCLGE_COMM_QUERY_CLEAR_ALL_MPF_MSIX_INT,
+				   HCLGE_COMM_QUERY_CLEAR_ALL_PF_MSIX_INT,
+				   HCLGE_COMM_QUERY_ALL_ERR_INFO };
+
+static bool hclge_comm_is_special_opcode(u16 opcode)
 {
+	/* these commands have several descriptors,
+	 * and use the first one to save opcode and return value
+	 */
 	u32 i;
 
-	for (i = 0; i < size; i++) {
+	for (i = 0; i < ARRAY_SIZE(spec_opcode); i++)
 		if (spec_opcode[i] == opcode)
 			return true;
-	}
 
 	return false;
 }
 
-static const u16 pf_spec_opcode[] = { HCLGE_COMM_OPC_STATS_64_BIT,
-				      HCLGE_COMM_OPC_STATS_32_BIT,
-				      HCLGE_COMM_OPC_STATS_MAC,
-				      HCLGE_COMM_OPC_STATS_MAC_ALL,
-				      HCLGE_COMM_OPC_QUERY_32_BIT_REG,
-				      HCLGE_COMM_OPC_QUERY_64_BIT_REG,
-				      HCLGE_COMM_QUERY_CLEAR_MPF_RAS_INT,
-				      HCLGE_COMM_QUERY_CLEAR_PF_RAS_INT,
-				      HCLGE_COMM_QUERY_CLEAR_ALL_MPF_MSIX_INT,
-				      HCLGE_COMM_QUERY_CLEAR_ALL_PF_MSIX_INT,
-				      HCLGE_COMM_QUERY_ALL_ERR_INFO };
-
-static const u16 vf_spec_opcode[] = { HCLGE_COMM_OPC_STATS_64_BIT,
-				      HCLGE_COMM_OPC_STATS_32_BIT,
-				      HCLGE_COMM_OPC_STATS_MAC };
-
-static bool hclge_comm_is_special_opcode(u16 opcode, bool is_pf)
-{
-	/* these commands have several descriptors,
-	 * and use the first one to save opcode and return value
-	 */
-	const u16 *spec_opcode = is_pf ? pf_spec_opcode : vf_spec_opcode;
-	u32 size = is_pf ? ARRAY_SIZE(pf_spec_opcode) :
-				ARRAY_SIZE(vf_spec_opcode);
-
-	return hclge_is_elem_in_array(spec_opcode, size, opcode);
-}
-
 static int hclge_comm_ring_space(struct hclge_comm_cmq_ring *ring)
 {
 	int ntc = ring->next_to_clean;
@@ -378,7 +364,7 @@ static int hclge_comm_cmd_convert_err_code(u16 desc_ret)
 
 static int hclge_comm_cmd_check_retval(struct hclge_comm_hw *hw,
 				       struct hclge_desc *desc, int num,
-				       int ntc, bool is_pf)
+				       int ntc)
 {
 	u16 opcode, desc_ret;
 	int handle;
@@ -390,7 +376,7 @@ static int hclge_comm_cmd_check_retval(struct hclge_comm_hw *hw,
 		if (ntc >= hw->cmq.csq.desc_num)
 			ntc = 0;
 	}
-	if (likely(!hclge_comm_is_special_opcode(opcode, is_pf)))
+	if (likely(!hclge_comm_is_special_opcode(opcode)))
 		desc_ret = le16_to_cpu(desc[num - 1].retval);
 	else
 		desc_ret = le16_to_cpu(desc[0].retval);
@@ -402,7 +388,7 @@ static int hclge_comm_cmd_check_retval(struct hclge_comm_hw *hw,
 
 static int hclge_comm_cmd_check_result(struct hclge_comm_hw *hw,
 				       struct hclge_desc *desc,
-				       int num, int ntc, bool is_pf)
+				       int num, int ntc)
 {
 	bool is_completed = false;
 	int handle, ret;
@@ -416,7 +402,7 @@ static int hclge_comm_cmd_check_result(struct hclge_comm_hw *hw,
 	if (!is_completed)
 		ret = -EBADE;
 	else
-		ret = hclge_comm_cmd_check_retval(hw, desc, num, ntc, is_pf);
+		ret = hclge_comm_cmd_check_retval(hw, desc, num, ntc);
 
 	/* Clean the command send queue */
 	handle = hclge_comm_cmd_csq_clean(hw);
@@ -433,13 +419,12 @@ static int hclge_comm_cmd_check_result(struct hclge_comm_hw *hw,
  * @hw: pointer to the hw struct
  * @desc: prefilled descriptor for describing the command
  * @num : the number of descriptors to be sent
- * @is_pf: bool to judge pf/vf module
  *
  * This is the main send command for command queue, it
  * sends the queue, cleans the queue, etc
  **/
 int hclge_comm_cmd_send(struct hclge_comm_hw *hw, struct hclge_desc *desc,
-			int num, bool is_pf)
+			int num)
 {
 	struct hclge_comm_cmq_ring *csq = &hw->cmq.csq;
 	int ret;
@@ -474,7 +459,7 @@ int hclge_comm_cmd_send(struct hclge_comm_hw *hw, struct hclge_desc *desc,
 	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CSQ_TAIL_REG,
 			     hw->cmq.csq.next_to_use);
 
-	ret = hclge_comm_cmd_check_result(hw, desc, num, ntc, is_pf);
+	ret = hclge_comm_cmd_check_result(hw, desc, num, ntc);
 
 	spin_unlock_bh(&hw->cmq.csq.lock);
 
@@ -495,12 +480,12 @@ static void hclge_comm_cmd_uninit_regs(struct hclge_comm_hw *hw)
 	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CRQ_TAIL_REG, 0);
 }
 
-void hclge_comm_cmd_uninit(struct hnae3_ae_dev *ae_dev, bool is_pf,
+void hclge_comm_cmd_uninit(struct hnae3_ae_dev *ae_dev,
 			   struct hclge_comm_hw *hw)
 {
 	struct hclge_comm_cmq *cmdq = &hw->cmq;
 
-	hclge_comm_firmware_compat_config(ae_dev, is_pf, hw, false);
+	hclge_comm_firmware_compat_config(ae_dev, hw, false);
 	set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hw->comm_state);
 
 	/* wait to ensure that the firmware completes the possible left
@@ -612,7 +597,7 @@ int hclge_comm_cmd_init(struct hnae3_ae_dev *ae_dev, struct hclge_comm_hw *hw,
 	/* ask the firmware to enable some features, driver can work without
 	 * it.
 	 */
-	ret = hclge_comm_firmware_compat_config(ae_dev, is_pf, hw, true);
+	ret = hclge_comm_firmware_compat_config(ae_dev, hw, true);
 	if (ret)
 		dev_warn(&ae_dev->pdev->dev,
 			 "Firmware compatible features not enabled(%d).\n",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index 2dd30a161cab..000c95534207 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -209,15 +209,15 @@ int hclge_comm_cmd_query_version_and_capability(struct hnae3_ae_dev *ae_dev,
 						u32 *fw_version, bool is_pf);
 int hclge_comm_alloc_cmd_queue(struct hclge_comm_hw *hw, int ring_type);
 int hclge_comm_cmd_send(struct hclge_comm_hw *hw, struct hclge_desc *desc,
-			int num, bool is_pf);
+			int num);
 void hclge_comm_cmd_reuse_desc(struct hclge_desc *desc, bool is_read);
-int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev, bool is_pf,
+int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev,
 				      struct hclge_comm_hw *hw, bool en);
 void hclge_comm_free_cmd_desc(struct hclge_comm_cmq_ring *ring);
 void hclge_comm_cmd_setup_basic_desc(struct hclge_desc *desc,
 				     enum hclge_comm_opcode_type opcode,
 				     bool is_read);
-void hclge_comm_cmd_uninit(struct hnae3_ae_dev *ae_dev, bool is_pf,
+void hclge_comm_cmd_uninit(struct hnae3_ae_dev *ae_dev,
 			   struct hclge_comm_hw *hw);
 int hclge_comm_cmd_queue_init(struct pci_dev *pdev, struct hclge_comm_hw *hw);
 int hclge_comm_cmd_init(struct hnae3_ae_dev *ae_dev, struct hclge_comm_hw *hw,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index bc117ea3c9c5..a365b9412437 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -490,7 +490,7 @@ static const struct key_info tuple_key_info[] = {
  **/
 int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 {
-	return hclge_comm_cmd_send(&hw->hw, desc, num, true);
+	return hclge_comm_cmd_send(&hw->hw, desc, num);
 }
 
 static int hclge_mac_update_stats_defective(struct hclge_dev *hdev)
@@ -11968,7 +11968,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 err_msi_uninit:
 	pci_free_irq_vectors(pdev);
 err_cmd_uninit:
-	hclge_comm_cmd_uninit(hdev->ae_dev, true, &hdev->hw.hw);
+	hclge_comm_cmd_uninit(hdev->ae_dev, &hdev->hw.hw);
 err_devlink_uninit:
 	hclge_devlink_uninit(hdev);
 err_pci_uninit:
@@ -12360,7 +12360,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_config_nic_hw_error(hdev, false);
 	hclge_config_rocee_ras_interrupt(hdev, false);
 
-	hclge_comm_cmd_uninit(hdev->ae_dev, true, &hdev->hw.hw);
+	hclge_comm_cmd_uninit(hdev->ae_dev, &hdev->hw.hw);
 	hclge_misc_irq_uninit(hdev);
 	hclge_devlink_uninit(hdev);
 	hclge_pci_uninit(hdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 08bd6fe0f29e..66a65594d286 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -102,7 +102,7 @@ static const u32 tqp_intr_reg_addr_list[] = {HCLGEVF_TQP_INTR_CTRL_REG,
  */
 int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclge_desc *desc, int num)
 {
-	return hclge_comm_cmd_send(&hw->hw, desc, num, false);
+	return hclge_comm_cmd_send(&hw->hw, desc, num);
 }
 
 void hclgevf_arq_init(struct hclgevf_dev *hdev)
@@ -3498,7 +3498,7 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	hclgevf_state_uninit(hdev);
 	hclgevf_uninit_msi(hdev);
 err_cmd_init:
-	hclge_comm_cmd_uninit(hdev->ae_dev, false, &hdev->hw.hw);
+	hclge_comm_cmd_uninit(hdev->ae_dev, &hdev->hw.hw);
 err_cmd_queue_init:
 	hclgevf_devlink_uninit(hdev);
 err_devlink_init:
@@ -3522,7 +3522,7 @@ static void hclgevf_uninit_hdev(struct hclgevf_dev *hdev)
 		hclgevf_uninit_msi(hdev);
 	}
 
-	hclge_comm_cmd_uninit(hdev->ae_dev, false, &hdev->hw.hw);
+	hclge_comm_cmd_uninit(hdev->ae_dev, &hdev->hw.hw);
 	hclgevf_devlink_uninit(hdev);
 	hclgevf_pci_uninit(hdev);
 	hclgevf_uninit_mac_list(hdev);
-- 
2.33.0

