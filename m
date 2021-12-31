Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0288C482342
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhLaKUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:20:11 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34869 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhLaKT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:19:58 -0500
Received: from kwepemi100004.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JQLjB1hnXzccCh;
        Fri, 31 Dec 2021 18:19:26 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100004.china.huawei.com (7.221.188.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:19:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:19:55 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 06/10] net: hns3: refactor VF cmdq resource APIs with new common APIs
Date:   Fri, 31 Dec 2021 18:14:55 +0800
Message-ID: <20211231101459.56083-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211231101459.56083-1-huangguangbin2@huawei.com>
References: <20211231101459.56083-1-huangguangbin2@huawei.com>
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

This patch uses common cmdq resource allocate/free/query APIs to replace
the old APIs in VF cmdq module and deletes the old cmdq resource APIs.
Still we kept hclgevf_cmd_setup_basic_desc name as a seam API to avoid too
many meaningless replacement.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.c       | 206 ++----------------
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       |  44 +---
 2 files changed, 19 insertions(+), 231 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 526da4e8aa42..9e0d900d2fb5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -11,100 +11,6 @@
 #include "hclgevf_main.h"
 #include "hnae3.h"
 
-static void hclgevf_cmd_config_regs(struct hclgevf_hw *hw,
-				    struct hclge_comm_cmq_ring *ring)
-{
-	u32 reg_val;
-
-	if (ring->ring_type == HCLGEVF_TYPE_CSQ) {
-		reg_val = lower_32_bits(ring->desc_dma_addr);
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_BASEADDR_L_REG, reg_val);
-		reg_val = upper_32_bits(ring->desc_dma_addr);
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_BASEADDR_H_REG, reg_val);
-
-		reg_val = hclgevf_read_dev(hw, HCLGEVF_NIC_CSQ_DEPTH_REG);
-		reg_val &= HCLGEVF_NIC_SW_RST_RDY;
-		reg_val |= (ring->desc_num >> HCLGEVF_NIC_CMQ_DESC_NUM_S);
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_DEPTH_REG, reg_val);
-
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_HEAD_REG, 0);
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_TAIL_REG, 0);
-	} else {
-		reg_val = lower_32_bits(ring->desc_dma_addr);
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_BASEADDR_L_REG, reg_val);
-		reg_val = upper_32_bits(ring->desc_dma_addr);
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_BASEADDR_H_REG, reg_val);
-
-		reg_val = (ring->desc_num >> HCLGEVF_NIC_CMQ_DESC_NUM_S);
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_DEPTH_REG, reg_val);
-
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_HEAD_REG, 0);
-		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_TAIL_REG, 0);
-	}
-}
-
-static void hclgevf_cmd_init_regs(struct hclgevf_hw *hw)
-{
-	hclgevf_cmd_config_regs(hw, &hw->hw.cmq.csq);
-	hclgevf_cmd_config_regs(hw, &hw->hw.cmq.crq);
-}
-
-static int hclgevf_alloc_cmd_desc(struct hclge_comm_cmq_ring *ring)
-{
-	int size = ring->desc_num * sizeof(struct hclge_desc);
-
-	ring->desc = dma_alloc_coherent(&ring->pdev->dev, size,
-					&ring->desc_dma_addr, GFP_KERNEL);
-	if (!ring->desc)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void hclgevf_free_cmd_desc(struct hclge_comm_cmq_ring *ring)
-{
-	int size  = ring->desc_num * sizeof(struct hclge_desc);
-
-	if (ring->desc) {
-		dma_free_coherent(&ring->pdev->dev, size,
-				  ring->desc, ring->desc_dma_addr);
-		ring->desc = NULL;
-	}
-}
-
-static int hclgevf_alloc_cmd_queue(struct hclgevf_dev *hdev, int ring_type)
-{
-	struct hclgevf_hw *hw = &hdev->hw;
-	struct hclge_comm_cmq_ring *ring =
-		(ring_type == HCLGEVF_TYPE_CSQ) ? &hw->hw.cmq.csq :
-						  &hw->hw.cmq.crq;
-	int ret;
-
-	ring->pdev = hdev->pdev;
-	ring->ring_type = ring_type;
-
-	/* allocate CSQ/CRQ descriptor */
-	ret = hclgevf_alloc_cmd_desc(ring);
-	if (ret)
-		dev_err(&hdev->pdev->dev, "failed(%d) to alloc %s desc\n", ret,
-			(ring_type == HCLGEVF_TYPE_CSQ) ? "CSQ" : "CRQ");
-
-	return ret;
-}
-
-void hclgevf_cmd_setup_basic_desc(struct hclge_desc *desc,
-				  enum hclgevf_opcode_type opcode, bool is_read)
-{
-	memset(desc, 0, sizeof(struct hclge_desc));
-	desc->opcode = cpu_to_le16(opcode);
-	desc->flag = cpu_to_le16(HCLGEVF_CMD_FLAG_NO_INTR |
-				 HCLGEVF_CMD_FLAG_IN);
-	if (is_read)
-		desc->flag |= cpu_to_le16(HCLGEVF_CMD_FLAG_WR);
-	else
-		desc->flag &= cpu_to_le16(~HCLGEVF_CMD_FLAG_WR);
-}
-
 /* hclgevf_cmd_send - send command to command queue
  * @hw: pointer to the hw struct
  * @desc: prefilled descriptor for describing the command
@@ -118,75 +24,6 @@ int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclge_desc *desc, int num)
 	return hclge_comm_cmd_send(&hw->hw, desc, num, false);
 }
 
-static void hclgevf_set_default_capability(struct hclgevf_dev *hdev)
-{
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-
-	set_bit(HNAE3_DEV_SUPPORT_FD_B, ae_dev->caps);
-	set_bit(HNAE3_DEV_SUPPORT_GRO_B, ae_dev->caps);
-	set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
-}
-
-static const struct hclgevf_caps_bit_map hclgevf_cmd_caps_bit_map0[] = {
-	{HCLGEVF_CAP_UDP_GSO_B, HNAE3_DEV_SUPPORT_UDP_GSO_B},
-	{HCLGEVF_CAP_INT_QL_B, HNAE3_DEV_SUPPORT_INT_QL_B},
-	{HCLGEVF_CAP_TQP_TXRX_INDEP_B, HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B},
-	{HCLGEVF_CAP_HW_TX_CSUM_B, HNAE3_DEV_SUPPORT_HW_TX_CSUM_B},
-	{HCLGEVF_CAP_UDP_TUNNEL_CSUM_B, HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B},
-	{HCLGEVF_CAP_RXD_ADV_LAYOUT_B, HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B},
-};
-
-static void hclgevf_parse_capability(struct hclgevf_dev *hdev,
-				     struct hclgevf_query_version_cmd *cmd)
-{
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-	u32 caps, i;
-
-	caps = __le32_to_cpu(cmd->caps[0]);
-	for (i = 0; i < ARRAY_SIZE(hclgevf_cmd_caps_bit_map0); i++)
-		if (hnae3_get_bit(caps, hclgevf_cmd_caps_bit_map0[i].imp_bit))
-			set_bit(hclgevf_cmd_caps_bit_map0[i].local_bit,
-				ae_dev->caps);
-}
-
-static __le32 hclgevf_build_api_caps(void)
-{
-	u32 api_caps = 0;
-
-	hnae3_set_bit(api_caps, HCLGEVF_API_CAP_FLEX_RSS_TBL_B, 1);
-
-	return cpu_to_le32(api_caps);
-}
-
-static int hclgevf_cmd_query_version_and_capability(struct hclgevf_dev *hdev)
-{
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-	struct hclgevf_query_version_cmd *resp;
-	struct hclge_desc desc;
-	int status;
-
-	resp = (struct hclgevf_query_version_cmd *)desc.data;
-
-	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_QUERY_FW_VER, 1);
-	resp->api_caps = hclgevf_build_api_caps();
-	status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
-	if (status)
-		return status;
-
-	hdev->fw_version = le32_to_cpu(resp->firmware);
-
-	ae_dev->dev_version = le32_to_cpu(resp->hardware) <<
-				 HNAE3_PCI_REVISION_BIT_SIZE;
-	ae_dev->dev_version |= hdev->pdev->revision;
-
-	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
-		hclgevf_set_default_capability(hdev);
-
-	hclgevf_parse_capability(hdev, resp);
-
-	return status;
-}
-
 int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev)
 {
 	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
@@ -197,18 +34,19 @@ int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev)
 	spin_lock_init(&cmdq->crq.lock);
 
 	cmdq->csq.pdev = hdev->pdev;
+	cmdq->crq.pdev = hdev->pdev;
 	cmdq->tx_timeout = HCLGEVF_CMDQ_TX_TIMEOUT;
 	cmdq->csq.desc_num = HCLGEVF_NIC_CMQ_DESC_NUM;
 	cmdq->crq.desc_num = HCLGEVF_NIC_CMQ_DESC_NUM;
 
-	ret = hclgevf_alloc_cmd_queue(hdev, HCLGEVF_TYPE_CSQ);
+	ret = hclge_comm_alloc_cmd_queue(&hdev->hw.hw, HCLGE_COMM_TYPE_CSQ);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"CSQ ring setup error %d\n", ret);
 		return ret;
 	}
 
-	ret = hclgevf_alloc_cmd_queue(hdev, HCLGEVF_TYPE_CRQ);
+	ret = hclge_comm_alloc_cmd_queue(&hdev->hw.hw, HCLGE_COMM_TYPE_CRQ);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"CRQ ring setup error %d\n", ret);
@@ -217,29 +55,10 @@ int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev)
 
 	return 0;
 err_csq:
-	hclgevf_free_cmd_desc(&cmdq->csq);
+	hclge_comm_free_cmd_desc(&cmdq->csq);
 	return ret;
 }
 
-static int hclgevf_firmware_compat_config(struct hclgevf_dev *hdev, bool en)
-{
-	struct hclgevf_firmware_compat_cmd *req;
-	struct hclge_desc desc;
-	u32 compat = 0;
-
-	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_IMP_COMPAT_CFG, false);
-
-	if (en) {
-		req = (struct hclgevf_firmware_compat_cmd *)desc.data;
-
-		hnae3_set_bit(compat, HCLGEVF_SYNC_RX_RING_HEAD_EN_B, 1);
-
-		req->compat = cpu_to_le32(compat);
-	}
-
-	return hclgevf_cmd_send(&hdev->hw, &desc, 1);
-}
-
 int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
@@ -259,7 +78,7 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 	cmdq->crq.next_to_clean = 0;
 	cmdq->crq.next_to_use = 0;
 
-	hclgevf_cmd_init_regs(&hdev->hw);
+	hclge_comm_cmd_init_regs(&hdev->hw.hw);
 
 	spin_unlock(&cmdq->crq.lock);
 	spin_unlock_bh(&cmdq->csq.lock);
@@ -275,7 +94,10 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 	}
 
 	/* get version and device capabilities */
-	ret = hclgevf_cmd_query_version_and_capability(hdev);
+	ret = hclge_comm_cmd_query_version_and_capability(hdev->ae_dev,
+							  &hdev->hw.hw,
+							  &hdev->fw_version,
+							  false);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to query version and capabilities, ret = %d\n", ret);
@@ -296,7 +118,8 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 		/* ask the firmware to enable some features, driver can work
 		 * without it.
 		 */
-		ret = hclgevf_firmware_compat_config(hdev, true);
+		ret = hclge_comm_firmware_compat_config(hdev->ae_dev, false,
+							&hdev->hw.hw, true);
 		if (ret)
 			dev_warn(&hdev->pdev->dev,
 				 "Firmware compatible features not enabled(%d).\n",
@@ -328,7 +151,8 @@ static void hclgevf_cmd_uninit_regs(struct hclgevf_hw *hw)
 void hclgevf_cmd_uninit(struct hclgevf_dev *hdev)
 {
 	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
-	hclgevf_firmware_compat_config(hdev, false);
+	hclge_comm_firmware_compat_config(hdev->ae_dev, false, &hdev->hw.hw,
+					  false);
 	set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
 
 	/* wait to ensure that the firmware completes the possible left
@@ -341,6 +165,6 @@ void hclgevf_cmd_uninit(struct hclgevf_dev *hdev)
 	spin_unlock(&cmdq->crq.lock);
 	spin_unlock_bh(&cmdq->csq.lock);
 
-	hclgevf_free_cmd_desc(&cmdq->csq);
-	hclgevf_free_cmd_desc(&cmdq->crq);
+	hclge_comm_free_cmd_desc(&cmdq->csq);
+	hclge_comm_free_cmd_desc(&cmdq->crq);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 89ad11ce0381..1ed70849bf63 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -98,34 +98,6 @@ struct hclgevf_ctrl_vector_chain {
 	u8 resv;
 };
 
-enum HCLGEVF_CAP_BITS {
-	HCLGEVF_CAP_UDP_GSO_B,
-	HCLGEVF_CAP_QB_B,
-	HCLGEVF_CAP_FD_FORWARD_TC_B,
-	HCLGEVF_CAP_PTP_B,
-	HCLGEVF_CAP_INT_QL_B,
-	HCLGEVF_CAP_HW_TX_CSUM_B,
-	HCLGEVF_CAP_TX_PUSH_B,
-	HCLGEVF_CAP_PHY_IMP_B,
-	HCLGEVF_CAP_TQP_TXRX_INDEP_B,
-	HCLGEVF_CAP_HW_PAD_B,
-	HCLGEVF_CAP_STASH_B,
-	HCLGEVF_CAP_UDP_TUNNEL_CSUM_B,
-	HCLGEVF_CAP_RXD_ADV_LAYOUT_B = 15,
-};
-
-enum HCLGEVF_API_CAP_BITS {
-	HCLGEVF_API_CAP_FLEX_RSS_TBL_B,
-};
-
-#define HCLGEVF_QUERY_CAP_LENGTH		3
-struct hclgevf_query_version_cmd {
-	__le32 firmware;
-	__le32 hardware;
-	__le32 api_caps;
-	__le32 caps[HCLGEVF_QUERY_CAP_LENGTH]; /* capabilities of device */
-};
-
 #define HCLGEVF_MSIX_OFT_ROCEE_S       0
 #define HCLGEVF_MSIX_OFT_ROCEE_M       (0xffff << HCLGEVF_MSIX_OFT_ROCEE_S)
 #define HCLGEVF_VEC_NUM_S              0
@@ -215,9 +187,6 @@ struct hclgevf_cfg_tx_queue_pointer_cmd {
 	u8 rsv[14];
 };
 
-#define HCLGEVF_TYPE_CRQ		0
-#define HCLGEVF_TYPE_CSQ		1
-
 /* this bit indicates that the driver is ready for hardware reset */
 #define HCLGEVF_NIC_SW_RST_RDY_B	16
 #define HCLGEVF_NIC_SW_RST_RDY		BIT(HCLGEVF_NIC_SW_RST_RDY_B)
@@ -227,6 +196,10 @@ struct hclgevf_cfg_tx_queue_pointer_cmd {
 
 #define HCLGEVF_QUERY_DEV_SPECS_BD_NUM		4
 
+#define hclgevf_cmd_setup_basic_desc(desc, opcode, is_read) \
+	hclge_comm_cmd_setup_basic_desc(desc, (enum hclge_comm_opcode_type)opcode, \
+					is_read)
+
 struct hclgevf_dev_specs_0_cmd {
 	__le32 rsv0;
 	__le32 mac_entry_num;
@@ -247,18 +220,9 @@ struct hclgevf_dev_specs_1_cmd {
 	u8 rsv1[18];
 };
 
-/* capabilities bits map between imp firmware and local driver */
-struct hclgevf_caps_bit_map {
-	u16 imp_bit;
-	u16 local_bit;
-};
-
 int hclgevf_cmd_init(struct hclgevf_dev *hdev);
 void hclgevf_cmd_uninit(struct hclgevf_dev *hdev);
 int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev);
 
 int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclge_desc *desc, int num);
-void hclgevf_cmd_setup_basic_desc(struct hclge_desc *desc,
-				  enum hclgevf_opcode_type opcode,
-				  bool is_read);
 #endif
-- 
2.33.0

