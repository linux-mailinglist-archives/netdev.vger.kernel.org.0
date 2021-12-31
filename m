Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3181848233C
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhLaKUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:20:03 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15995 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhLaKT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:19:57 -0500
Received: from kwepemi100003.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JQLdv0rkczZdtG;
        Fri, 31 Dec 2021 18:16:35 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100003.china.huawei.com (7.221.188.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:19:55 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:19:55 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 05/10] net: hns3: refactor PF cmdq resource APIs with new common APIs
Date:   Fri, 31 Dec 2021 18:14:54 +0800
Message-ID: <20211231101459.56083-6-huangguangbin2@huawei.com>
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
the old APIs in PF cmdq module and deletes the old cmdq resource APIs.
Still we kept hclge_cmd_setup_basic_desc name as a seam API to avoid too
many meaningless replacement.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         | 227 ++----------------
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  70 +-----
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  10 +-
 .../hisilicon/hns3/hns3pf/hclge_err.c         |  25 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  54 ++---
 5 files changed, 63 insertions(+), 323 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 16fdcb701953..0f4b934c0683 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -11,105 +11,6 @@
 #include "hnae3.h"
 #include "hclge_main.h"
 
-static int hclge_alloc_cmd_desc(struct hclge_comm_cmq_ring *ring)
-{
-	int size  = ring->desc_num * sizeof(struct hclge_desc);
-
-	ring->desc = dma_alloc_coherent(&ring->pdev->dev,
-					size, &ring->desc_dma_addr, GFP_KERNEL);
-	if (!ring->desc)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void hclge_free_cmd_desc(struct hclge_comm_cmq_ring *ring)
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
-static int hclge_alloc_cmd_queue(struct hclge_dev *hdev, int ring_type)
-{
-	struct hclge_hw *hw = &hdev->hw;
-	struct hclge_comm_cmq_ring *ring =
-		(ring_type == HCLGE_TYPE_CSQ) ? &hw->hw.cmq.csq :
-						&hw->hw.cmq.crq;
-	int ret;
-
-	ring->ring_type = ring_type;
-	ring->pdev = hdev->pdev;
-
-	ret = hclge_alloc_cmd_desc(ring);
-	if (ret) {
-		dev_err(&hdev->pdev->dev, "descriptor %s alloc error %d\n",
-			(ring_type == HCLGE_TYPE_CSQ) ? "CSQ" : "CRQ", ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-void hclge_cmd_reuse_desc(struct hclge_desc *desc, bool is_read)
-{
-	desc->flag = cpu_to_le16(HCLGE_CMD_FLAG_NO_INTR | HCLGE_CMD_FLAG_IN);
-	if (is_read)
-		desc->flag |= cpu_to_le16(HCLGE_CMD_FLAG_WR);
-	else
-		desc->flag &= cpu_to_le16(~HCLGE_CMD_FLAG_WR);
-}
-
-void hclge_cmd_setup_basic_desc(struct hclge_desc *desc,
-				enum hclge_opcode_type opcode, bool is_read)
-{
-	memset((void *)desc, 0, sizeof(struct hclge_desc));
-	desc->opcode = cpu_to_le16(opcode);
-	desc->flag = cpu_to_le16(HCLGE_CMD_FLAG_NO_INTR | HCLGE_CMD_FLAG_IN);
-
-	if (is_read)
-		desc->flag |= cpu_to_le16(HCLGE_CMD_FLAG_WR);
-}
-
-static void hclge_cmd_config_regs(struct hclge_hw *hw,
-				  struct hclge_comm_cmq_ring *ring)
-{
-	dma_addr_t dma = ring->desc_dma_addr;
-	u32 reg_val;
-
-	if (ring->ring_type == HCLGE_TYPE_CSQ) {
-		hclge_write_dev(hw, HCLGE_NIC_CSQ_BASEADDR_L_REG,
-				lower_32_bits(dma));
-		hclge_write_dev(hw, HCLGE_NIC_CSQ_BASEADDR_H_REG,
-				upper_32_bits(dma));
-		reg_val = hclge_read_dev(hw, HCLGE_NIC_CSQ_DEPTH_REG);
-		reg_val &= HCLGE_NIC_SW_RST_RDY;
-		reg_val |= ring->desc_num >> HCLGE_NIC_CMQ_DESC_NUM_S;
-		hclge_write_dev(hw, HCLGE_NIC_CSQ_DEPTH_REG, reg_val);
-		hclge_write_dev(hw, HCLGE_NIC_CSQ_HEAD_REG, 0);
-		hclge_write_dev(hw, HCLGE_NIC_CSQ_TAIL_REG, 0);
-	} else {
-		hclge_write_dev(hw, HCLGE_NIC_CRQ_BASEADDR_L_REG,
-				lower_32_bits(dma));
-		hclge_write_dev(hw, HCLGE_NIC_CRQ_BASEADDR_H_REG,
-				upper_32_bits(dma));
-		hclge_write_dev(hw, HCLGE_NIC_CRQ_DEPTH_REG,
-				ring->desc_num >> HCLGE_NIC_CMQ_DESC_NUM_S);
-		hclge_write_dev(hw, HCLGE_NIC_CRQ_HEAD_REG, 0);
-		hclge_write_dev(hw, HCLGE_NIC_CRQ_TAIL_REG, 0);
-	}
-}
-
-static void hclge_cmd_init_regs(struct hclge_hw *hw)
-{
-	hclge_cmd_config_regs(hw, &hw->hw.cmq.csq);
-	hclge_cmd_config_regs(hw, &hw->hw.cmq.crq);
-}
-
 /**
  * hclge_cmd_send - send command to command queue
  * @hw: pointer to the hw struct
@@ -124,87 +25,6 @@ int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 	return hclge_comm_cmd_send(&hw->hw, desc, num, true);
 }
 
-static void hclge_set_default_capability(struct hclge_dev *hdev)
-{
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-
-	set_bit(HNAE3_DEV_SUPPORT_FD_B, ae_dev->caps);
-	set_bit(HNAE3_DEV_SUPPORT_GRO_B, ae_dev->caps);
-	if (hdev->ae_dev->dev_version == HNAE3_DEVICE_VERSION_V2) {
-		set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
-		set_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps);
-	}
-}
-
-static const struct hclge_caps_bit_map hclge_cmd_caps_bit_map0[] = {
-	{HCLGE_CAP_UDP_GSO_B, HNAE3_DEV_SUPPORT_UDP_GSO_B},
-	{HCLGE_CAP_PTP_B, HNAE3_DEV_SUPPORT_PTP_B},
-	{HCLGE_CAP_INT_QL_B, HNAE3_DEV_SUPPORT_INT_QL_B},
-	{HCLGE_CAP_TQP_TXRX_INDEP_B, HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B},
-	{HCLGE_CAP_HW_TX_CSUM_B, HNAE3_DEV_SUPPORT_HW_TX_CSUM_B},
-	{HCLGE_CAP_UDP_TUNNEL_CSUM_B, HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B},
-	{HCLGE_CAP_FD_FORWARD_TC_B, HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B},
-	{HCLGE_CAP_FEC_B, HNAE3_DEV_SUPPORT_FEC_B},
-	{HCLGE_CAP_PAUSE_B, HNAE3_DEV_SUPPORT_PAUSE_B},
-	{HCLGE_CAP_PHY_IMP_B, HNAE3_DEV_SUPPORT_PHY_IMP_B},
-	{HCLGE_CAP_RAS_IMP_B, HNAE3_DEV_SUPPORT_RAS_IMP_B},
-	{HCLGE_CAP_RXD_ADV_LAYOUT_B, HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B},
-	{HCLGE_CAP_PORT_VLAN_BYPASS_B, HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B},
-	{HCLGE_CAP_PORT_VLAN_BYPASS_B, HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B},
-};
-
-static void hclge_parse_capability(struct hclge_dev *hdev,
-				   struct hclge_query_version_cmd *cmd)
-{
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-	u32 caps, i;
-
-	caps = __le32_to_cpu(cmd->caps[0]);
-	for (i = 0; i < ARRAY_SIZE(hclge_cmd_caps_bit_map0); i++)
-		if (hnae3_get_bit(caps, hclge_cmd_caps_bit_map0[i].imp_bit))
-			set_bit(hclge_cmd_caps_bit_map0[i].local_bit,
-				ae_dev->caps);
-}
-
-static __le32 hclge_build_api_caps(void)
-{
-	u32 api_caps = 0;
-
-	hnae3_set_bit(api_caps, HCLGE_API_CAP_FLEX_RSS_TBL_B, 1);
-
-	return cpu_to_le32(api_caps);
-}
-
-static enum hclge_comm_cmd_status
-hclge_cmd_query_version_and_capability(struct hclge_dev *hdev)
-{
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-	struct hclge_query_version_cmd *resp;
-	struct hclge_desc desc;
-	int ret;
-
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_FW_VER, 1);
-	resp = (struct hclge_query_version_cmd *)desc.data;
-	resp->api_caps = hclge_build_api_caps();
-
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		return ret;
-
-	hdev->fw_version = le32_to_cpu(resp->firmware);
-
-	ae_dev->dev_version = le32_to_cpu(resp->hardware) <<
-					 HNAE3_PCI_REVISION_BIT_SIZE;
-	ae_dev->dev_version |= hdev->pdev->revision;
-
-	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
-		hclge_set_default_capability(hdev);
-
-	hclge_parse_capability(hdev, resp);
-
-	return ret;
-}
-
 int hclge_cmd_queue_init(struct hclge_dev *hdev)
 {
 	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
@@ -225,14 +45,14 @@ int hclge_cmd_queue_init(struct hclge_dev *hdev)
 	cmdq->tx_timeout = HCLGE_CMDQ_TX_TIMEOUT;
 
 	/* Setup queue rings */
-	ret = hclge_alloc_cmd_queue(hdev, HCLGE_TYPE_CSQ);
+	ret = hclge_comm_alloc_cmd_queue(&hdev->hw.hw, HCLGE_COMM_TYPE_CSQ);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"CSQ ring setup error %d\n", ret);
 		return ret;
 	}
 
-	ret = hclge_alloc_cmd_queue(hdev, HCLGE_TYPE_CRQ);
+	ret = hclge_comm_alloc_cmd_queue(&hdev->hw.hw, HCLGE_COMM_TYPE_CRQ);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"CRQ ring setup error %d\n", ret);
@@ -241,34 +61,10 @@ int hclge_cmd_queue_init(struct hclge_dev *hdev)
 
 	return 0;
 err_csq:
-	hclge_free_cmd_desc(&hdev->hw.hw.cmq.csq);
+	hclge_comm_free_cmd_desc(&hdev->hw.hw.cmq.csq);
 	return ret;
 }
 
-static int hclge_firmware_compat_config(struct hclge_dev *hdev, bool en)
-{
-	struct hclge_firmware_compat_cmd *req;
-	struct hclge_desc desc;
-	u32 compat = 0;
-
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_IMP_COMPAT_CFG, false);
-
-	if (en) {
-		req = (struct hclge_firmware_compat_cmd *)desc.data;
-
-		hnae3_set_bit(compat, HCLGE_LINK_EVENT_REPORT_EN_B, 1);
-		hnae3_set_bit(compat, HCLGE_NCSI_ERROR_REPORT_EN_B, 1);
-		if (hnae3_dev_phy_imp_supported(hdev))
-			hnae3_set_bit(compat, HCLGE_PHY_IMP_EN_B, 1);
-		hnae3_set_bit(compat, HCLGE_MAC_STATS_EXT_EN_B, 1);
-		hnae3_set_bit(compat, HCLGE_SYNC_RX_RING_HEAD_EN_B, 1);
-
-		req->compat = cpu_to_le32(compat);
-	}
-
-	return hclge_cmd_send(&hdev->hw, &desc, 1);
-}
-
 int hclge_cmd_init(struct hclge_dev *hdev)
 {
 	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
@@ -282,7 +78,7 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 	cmdq->crq.next_to_clean = 0;
 	cmdq->crq.next_to_use = 0;
 
-	hclge_cmd_init_regs(&hdev->hw);
+	hclge_comm_cmd_init_regs(&hdev->hw.hw);
 
 	spin_unlock(&cmdq->crq.lock);
 	spin_unlock_bh(&cmdq->csq.lock);
@@ -301,7 +97,10 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 	}
 
 	/* get version and device capabilities */
-	ret = hclge_cmd_query_version_and_capability(hdev);
+	ret = hclge_comm_cmd_query_version_and_capability(hdev->ae_dev,
+							  &hdev->hw.hw,
+							  &hdev->fw_version,
+							  true);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to query version and capabilities, ret = %d\n",
@@ -322,7 +121,8 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 	/* ask the firmware to enable some features, driver can work without
 	 * it.
 	 */
-	ret = hclge_firmware_compat_config(hdev, true);
+	ret = hclge_comm_firmware_compat_config(hdev->ae_dev, true,
+						&hdev->hw.hw, true);
 	if (ret)
 		dev_warn(&hdev->pdev->dev,
 			 "Firmware compatible features not enabled(%d).\n",
@@ -356,7 +156,8 @@ void hclge_cmd_uninit(struct hclge_dev *hdev)
 
 	cmdq->csq.pdev = hdev->pdev;
 
-	hclge_firmware_compat_config(hdev, false);
+	hclge_comm_firmware_compat_config(hdev->ae_dev, true, &hdev->hw.hw,
+					  false);
 
 	set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
 	/* wait to ensure that the firmware completes the possible left
@@ -369,6 +170,6 @@ void hclge_cmd_uninit(struct hclge_dev *hdev)
 	spin_unlock(&cmdq->crq.lock);
 	spin_unlock_bh(&cmdq->csq.lock);
 
-	hclge_free_cmd_desc(&cmdq->csq);
-	hclge_free_cmd_desc(&cmdq->crq);
+	hclge_comm_free_cmd_desc(&cmdq->csq);
+	hclge_comm_free_cmd_desc(&cmdq->crq);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 16fc7f093028..b239b5bde1de 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -23,13 +23,6 @@ struct hclge_misc_vector {
 	char name[HNAE3_INT_NAME_LEN];
 };
 
-#define HCLGE_CMD_FLAG_IN	BIT(0)
-#define HCLGE_CMD_FLAG_OUT	BIT(1)
-#define HCLGE_CMD_FLAG_NEXT	BIT(2)
-#define HCLGE_CMD_FLAG_WR	BIT(3)
-#define HCLGE_CMD_FLAG_NO_INTR	BIT(4)
-#define HCLGE_CMD_FLAG_ERR_INTR	BIT(5)
-
 enum hclge_opcode_type {
 	/* Generic commands */
 	HCLGE_OPC_QUERY_FW_VER		= 0x0001,
@@ -273,6 +266,10 @@ enum hclge_opcode_type {
 	HCLGE_OPC_QUERY_LINK_DIAGNOSIS	= 0x702A,
 };
 
+#define hclge_cmd_setup_basic_desc(desc, opcode, is_read) \
+	hclge_comm_cmd_setup_basic_desc(desc, (enum hclge_comm_opcode_type)opcode, \
+					is_read)
+
 #define HCLGE_TQP_REG_OFFSET		0x80000
 #define HCLGE_TQP_REG_SIZE		0x200
 
@@ -339,38 +336,6 @@ struct hclge_rx_priv_buff_cmd {
 	u8 rsv[6];
 };
 
-enum HCLGE_CAP_BITS {
-	HCLGE_CAP_UDP_GSO_B,
-	HCLGE_CAP_QB_B,
-	HCLGE_CAP_FD_FORWARD_TC_B,
-	HCLGE_CAP_PTP_B,
-	HCLGE_CAP_INT_QL_B,
-	HCLGE_CAP_HW_TX_CSUM_B,
-	HCLGE_CAP_TX_PUSH_B,
-	HCLGE_CAP_PHY_IMP_B,
-	HCLGE_CAP_TQP_TXRX_INDEP_B,
-	HCLGE_CAP_HW_PAD_B,
-	HCLGE_CAP_STASH_B,
-	HCLGE_CAP_UDP_TUNNEL_CSUM_B,
-	HCLGE_CAP_RAS_IMP_B = 12,
-	HCLGE_CAP_FEC_B = 13,
-	HCLGE_CAP_PAUSE_B = 14,
-	HCLGE_CAP_RXD_ADV_LAYOUT_B = 15,
-	HCLGE_CAP_PORT_VLAN_BYPASS_B = 17,
-};
-
-enum HCLGE_API_CAP_BITS {
-	HCLGE_API_CAP_FLEX_RSS_TBL_B,
-};
-
-#define HCLGE_QUERY_CAP_LENGTH		3
-struct hclge_query_version_cmd {
-	__le32 firmware;
-	__le32 hardware;
-	__le32 api_caps;
-	__le32 caps[HCLGE_QUERY_CAP_LENGTH]; /* capabilities of device */
-};
-
 #define HCLGE_RX_PRIV_EN_B	15
 #define HCLGE_TC_NUM_ONE_DESC	4
 struct hclge_priv_wl {
@@ -963,13 +928,6 @@ struct hclge_common_lb_cmd {
 #define HCLGE_DEFAULT_NON_DCB_DV	0x7800	/* 30K byte */
 #define HCLGE_NON_DCB_ADDITIONAL_BUF	0x1400	/* 5120 byte */
 
-#define HCLGE_TYPE_CRQ			0
-#define HCLGE_TYPE_CSQ			1
-
-/* this bit indicates that the driver is ready for hardware reset */
-#define HCLGE_NIC_SW_RST_RDY_B		16
-#define HCLGE_NIC_SW_RST_RDY		BIT(HCLGE_NIC_SW_RST_RDY_B)
-
 #define HCLGE_NIC_CMQ_DESC_NUM		1024
 #define HCLGE_NIC_CMQ_DESC_NUM_S	3
 
@@ -1095,16 +1053,6 @@ struct hclge_query_ppu_pf_other_int_dfx_cmd {
 	u8 rsv[4];
 };
 
-#define HCLGE_LINK_EVENT_REPORT_EN_B	0
-#define HCLGE_NCSI_ERROR_REPORT_EN_B	1
-#define HCLGE_PHY_IMP_EN_B		2
-#define HCLGE_MAC_STATS_EXT_EN_B	3
-#define HCLGE_SYNC_RX_RING_HEAD_EN_B	4
-struct hclge_firmware_compat_cmd {
-	__le32 compat;
-	u8 rsv[20];
-};
-
 #define HCLGE_SFP_INFO_CMD_NUM	6
 #define HCLGE_SFP_INFO_BD0_LEN	20
 #define HCLGE_SFP_INFO_BDX_LEN	24
@@ -1187,20 +1135,10 @@ struct hclge_phy_reg_cmd {
 	u8 rsv1[18];
 };
 
-/* capabilities bits map between imp firmware and local driver */
-struct hclge_caps_bit_map {
-	u16 imp_bit;
-	u16 local_bit;
-};
-
 int hclge_cmd_init(struct hclge_dev *hdev);
 
 struct hclge_hw;
 int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num);
-void hclge_cmd_setup_basic_desc(struct hclge_desc *desc,
-				enum hclge_opcode_type opcode, bool is_read);
-void hclge_cmd_reuse_desc(struct hclge_desc *desc, bool is_read);
-
 enum hclge_comm_cmd_status hclge_cmd_mdio_write(struct hclge_hw *hw,
 						struct hclge_desc *desc);
 enum hclge_comm_cmd_status hclge_cmd_mdio_read(struct hclge_hw *hw,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index c287be8bc48d..9b870e79c290 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -150,7 +150,7 @@ static int hclge_dbg_cmd_send(struct hclge_dev *hdev,
 	desc->data[0] = cpu_to_le32(index);
 
 	for (i = 1; i < bd_num; i++) {
-		desc->flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+		desc->flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 		desc++;
 		hclge_cmd_setup_basic_desc(desc, cmd, true);
 	}
@@ -1266,7 +1266,7 @@ static int hclge_dbg_dump_rx_priv_wl_buf_cfg(struct hclge_dev *hdev, char *buf,
 	int i, ret;
 
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_RX_PRIV_WL_ALLOC, true);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_RX_PRIV_WL_ALLOC, true);
 	ret = hclge_cmd_send(&hdev->hw, desc, 2);
 	if (ret) {
@@ -1302,7 +1302,7 @@ static int hclge_dbg_dump_rx_common_threshold_cfg(struct hclge_dev *hdev,
 	int i, ret;
 
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_RX_COM_THRD_ALLOC, true);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_RX_COM_THRD_ALLOC, true);
 	ret = hclge_cmd_send(&hdev->hw, desc, 2);
 	if (ret) {
@@ -1447,9 +1447,9 @@ static int hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, bool sel_x,
 	u32 *req;
 
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_FD_TCAM_OP, true);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_FD_TCAM_OP, true);
-	desc[1].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[1].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[2], HCLGE_OPC_FD_TCAM_OP, true);
 
 	req1 = (struct hclge_fd_tcam_config_1_cmd *)desc[0].data;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 20e628c2bd44..42a9e73d8588 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1399,7 +1399,7 @@ static int hclge_config_common_hw_err_int(struct hclge_dev *hdev, bool en)
 
 	/* configure common error interrupts */
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_COMMON_ECC_INT_CFG, false);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_COMMON_ECC_INT_CFG, false);
 
 	if (en) {
@@ -1498,7 +1498,7 @@ static int hclge_config_ppp_error_interrupt(struct hclge_dev *hdev, u32 cmd,
 
 	/* configure PPP error interrupts */
 	hclge_cmd_setup_basic_desc(&desc[0], cmd, false);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[1], cmd, false);
 
 	if (cmd == HCLGE_PPP_CMD0_INT_CMD) {
@@ -1633,7 +1633,7 @@ static int hclge_config_ppu_error_interrupts(struct hclge_dev *hdev, u32 cmd,
 	/* configure PPU error interrupts */
 	if (cmd == HCLGE_PPU_MPF_ECC_INT_CMD) {
 		hclge_cmd_setup_basic_desc(&desc[0], cmd, false);
-		desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+		desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 		hclge_cmd_setup_basic_desc(&desc[1], cmd, false);
 		if (en) {
 			desc[0].data[0] =
@@ -1718,7 +1718,7 @@ static int hclge_config_ssu_hw_err_int(struct hclge_dev *hdev, bool en)
 
 	/* configure SSU ecc error interrupts */
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_SSU_ECC_INT_CMD, false);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_SSU_ECC_INT_CMD, false);
 	if (en) {
 		desc[0].data[0] = cpu_to_le32(HCLGE_SSU_1BIT_ECC_ERR_INT_EN);
@@ -1740,7 +1740,7 @@ static int hclge_config_ssu_hw_err_int(struct hclge_dev *hdev, bool en)
 
 	/* configure SSU common error interrupts */
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_SSU_COMMON_INT_CMD, false);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_SSU_COMMON_INT_CMD, false);
 
 	if (en) {
@@ -1963,7 +1963,7 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 				&ae_dev->hw_err_reset_req);
 
 	/* clear all main PF RAS errors */
-	hclge_cmd_reuse_desc(&desc[0], false);
+	hclge_comm_cmd_reuse_desc(&desc[0], false);
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], num);
 	if (ret)
 		dev_err(dev, "clear all mpf ras int cmd failed (%d)\n", ret);
@@ -2036,7 +2036,7 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 	}
 
 	/* clear all PF RAS errors */
-	hclge_cmd_reuse_desc(&desc[0], false);
+	hclge_comm_cmd_reuse_desc(&desc[0], false);
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], num);
 	if (ret)
 		dev_err(dev, "clear all pf ras int cmd failed (%d)\n", ret);
@@ -2087,8 +2087,8 @@ static int hclge_log_rocee_axi_error(struct hclge_dev *hdev)
 				   true);
 	hclge_cmd_setup_basic_desc(&desc[2], HCLGE_QUERY_ROCEE_AXI_RAS_INFO_CMD,
 				   true);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-	desc[1].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
+	desc[1].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], 3);
 	if (ret) {
@@ -2119,7 +2119,7 @@ static int hclge_log_rocee_ecc_error(struct hclge_dev *hdev)
 
 	ret = hclge_cmd_query_error(hdev, &desc[0],
 				    HCLGE_QUERY_ROCEE_ECC_RAS_INFO_CMD,
-				    HCLGE_CMD_FLAG_NEXT);
+				    HCLGE_COMM_CMD_FLAG_NEXT);
 	if (ret) {
 		dev_err(dev, "failed(%d) to query ROCEE ECC error sts\n", ret);
 		return ret;
@@ -2235,7 +2235,7 @@ hclge_log_and_clear_rocee_ras_error(struct hclge_dev *hdev)
 	}
 
 	/* clear error status */
-	hclge_cmd_reuse_desc(&desc[0], false);
+	hclge_comm_cmd_reuse_desc(&desc[0], false);
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], 1);
 	if (ret) {
 		dev_err(dev, "failed(%d) to clear ROCEE RAS error\n", ret);
@@ -2405,7 +2405,8 @@ static int hclge_clear_hw_msix_error(struct hclge_dev *hdev,
 	else
 		desc[0].opcode = cpu_to_le16(HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT);
 
-	desc[0].flag = cpu_to_le16(HCLGE_CMD_FLAG_NO_INTR | HCLGE_CMD_FLAG_IN);
+	desc[0].flag = cpu_to_le16(HCLGE_COMM_CMD_FLAG_NO_INTR |
+				   HCLGE_COMM_CMD_FLAG_IN);
 
 	return hclge_cmd_send(&hdev->hw, &desc[0], bd_num);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 2eae9f7edfe0..068d0adaab68 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1568,7 +1568,7 @@ static int hclge_query_dev_specs(struct hclge_dev *hdev)
 	for (i = 0; i < HCLGE_QUERY_DEV_SPECS_BD_NUM - 1; i++) {
 		hclge_cmd_setup_basic_desc(&desc[i], HCLGE_OPC_QUERY_DEV_SPECS,
 					   true);
-		desc[i].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+		desc[i].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	}
 	hclge_cmd_setup_basic_desc(&desc[i], HCLGE_OPC_QUERY_DEV_SPECS, true);
 
@@ -2422,9 +2422,9 @@ static int hclge_rx_priv_wl_config(struct hclge_dev *hdev,
 
 		/* The first descriptor set the NEXT bit to 1 */
 		if (i == 0)
-			desc[i].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+			desc[i].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 		else
-			desc[i].flag &= ~cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+			desc[i].flag &= ~cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 
 		for (j = 0; j < HCLGE_TC_NUM_ONE_DESC; j++) {
 			u32 idx = i * HCLGE_TC_NUM_ONE_DESC + j;
@@ -2467,9 +2467,9 @@ static int hclge_common_thrd_config(struct hclge_dev *hdev,
 
 		/* The first descriptor set the NEXT bit to 1 */
 		if (i == 0)
-			desc[i].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+			desc[i].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 		else
-			desc[i].flag &= ~cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+			desc[i].flag &= ~cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 
 		for (j = 0; j < HCLGE_TC_NUM_ONE_DESC; j++) {
 			tc = &s_buf->tc_thrd[i * HCLGE_TC_NUM_ONE_DESC + j];
@@ -3240,7 +3240,7 @@ static int hclge_get_phy_link_ksettings(struct hnae3_handle *handle,
 
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_PHY_LINK_KSETTING,
 				   true);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_PHY_LINK_KSETTING,
 				   true);
 
@@ -3297,7 +3297,7 @@ hclge_set_phy_link_ksettings(struct hnae3_handle *handle,
 
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_PHY_LINK_KSETTING,
 				   false);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_PHY_LINK_KSETTING,
 				   false);
 
@@ -3875,7 +3875,7 @@ static void hclge_func_reset_sync_vf(struct hclge_dev *hdev)
 			return;
 		}
 		msleep(HCLGE_PF_RESET_SYNC_TIME);
-		hclge_cmd_reuse_desc(&desc, true);
+		hclge_comm_cmd_reuse_desc(&desc, true);
 	} while (cnt++ < HCLGE_PF_RESET_SYNC_CNT);
 
 	dev_warn(&hdev->pdev->dev, "sync with VF timeout!\n");
@@ -4034,9 +4034,9 @@ static void hclge_reset_handshake(struct hclge_dev *hdev, bool enable)
 
 	reg_val = hclge_read_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG);
 	if (enable)
-		reg_val |= HCLGE_NIC_SW_RST_RDY;
+		reg_val |= HCLGE_COMM_NIC_SW_RST_RDY;
 	else
-		reg_val &= ~HCLGE_NIC_SW_RST_RDY;
+		reg_val &= ~HCLGE_COMM_NIC_SW_RST_RDY;
 
 	hclge_write_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG, reg_val);
 }
@@ -5903,9 +5903,9 @@ static int hclge_fd_tcam_config(struct hclge_dev *hdev, u8 stage, bool sel_x,
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_FD_TCAM_OP, false);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_FD_TCAM_OP, false);
-	desc[1].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[1].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	hclge_cmd_setup_basic_desc(&desc[2], HCLGE_OPC_FD_TCAM_OP, false);
 
 	req1 = (struct hclge_fd_tcam_config_1_cmd *)desc[0].data;
@@ -7899,7 +7899,7 @@ static int hclge_config_switch_param(struct hclge_dev *hdev, int vfid,
 	}
 
 	/* modify and write new config parameter */
-	hclge_cmd_reuse_desc(&desc, false);
+	hclge_comm_cmd_reuse_desc(&desc, false);
 	req->switch_param = (req->switch_param & param_mask) | switch_param;
 	req->param_mask = param_mask;
 
@@ -7993,7 +7993,7 @@ static int hclge_set_app_loopback(struct hclge_dev *hdev, bool en)
 	/* 3 Config mac work mode with loopback flag
 	 * and its original configure parameters
 	 */
-	hclge_cmd_reuse_desc(&desc, false);
+	hclge_comm_cmd_reuse_desc(&desc, false);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
 		dev_err(&hdev->pdev->dev,
@@ -8566,14 +8566,14 @@ static int hclge_lookup_mac_vlan_tbl(struct hclge_vport *vport,
 
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_MAC_VLAN_ADD, true);
 	if (is_mc) {
-		desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+		desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 		memcpy(desc[0].data,
 		       req,
 		       sizeof(struct hclge_mac_vlan_tbl_entry_cmd));
 		hclge_cmd_setup_basic_desc(&desc[1],
 					   HCLGE_OPC_MAC_VLAN_ADD,
 					   true);
-		desc[1].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+		desc[1].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 		hclge_cmd_setup_basic_desc(&desc[2],
 					   HCLGE_OPC_MAC_VLAN_ADD,
 					   true);
@@ -8623,12 +8623,12 @@ static int hclge_add_mac_vlan_tbl(struct hclge_vport *vport,
 							   resp_code,
 							   HCLGE_MAC_VLAN_ADD);
 	} else {
-		hclge_cmd_reuse_desc(&mc_desc[0], false);
-		mc_desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-		hclge_cmd_reuse_desc(&mc_desc[1], false);
-		mc_desc[1].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-		hclge_cmd_reuse_desc(&mc_desc[2], false);
-		mc_desc[2].flag &= cpu_to_le16(~HCLGE_CMD_FLAG_NEXT);
+		hclge_comm_cmd_reuse_desc(&mc_desc[0], false);
+		mc_desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
+		hclge_comm_cmd_reuse_desc(&mc_desc[1], false);
+		mc_desc[1].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
+		hclge_comm_cmd_reuse_desc(&mc_desc[2], false);
+		mc_desc[2].flag &= cpu_to_le16(~HCLGE_COMM_CMD_FLAG_NEXT);
 		memcpy(mc_desc[0].data, req,
 		       sizeof(struct hclge_mac_vlan_tbl_entry_cmd));
 		ret = hclge_cmd_send(&hdev->hw, mc_desc, 3);
@@ -9753,7 +9753,7 @@ static int hclge_set_vlan_filter_ctrl(struct hclge_dev *hdev, u8 vlan_type,
 	}
 
 	/* modify and write new config parameter */
-	hclge_cmd_reuse_desc(&desc, false);
+	hclge_comm_cmd_reuse_desc(&desc, false);
 	req->vlan_fe = filter_en ?
 			(req->vlan_fe | fe_type) : (req->vlan_fe & ~fe_type);
 
@@ -9879,7 +9879,7 @@ static int hclge_set_vf_vlan_filter_cmd(struct hclge_dev *hdev, u16 vfid,
 	hclge_cmd_setup_basic_desc(&desc[1],
 				   HCLGE_OPC_VLAN_FILTER_VF_CFG, false);
 
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 
 	vf_byte_off = vfid / 8;
 	vf_byte_val = 1 << (vfid % 8);
@@ -12610,7 +12610,7 @@ int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev, struct hclge_desc *desc)
 	for (i = 0; i < HCLGE_GET_DFX_REG_TYPE_CNT - 1; i++) {
 		hclge_cmd_setup_basic_desc(&desc[i], HCLGE_OPC_DFX_BD_NUM,
 					   true);
-		desc[i].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+		desc[i].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	}
 
 	/* initialize the last command BD */
@@ -12654,7 +12654,7 @@ static int hclge_dfx_reg_cmd_send(struct hclge_dev *hdev,
 
 	hclge_cmd_setup_basic_desc(desc, cmd, true);
 	for (i = 0; i < bd_num - 1; i++) {
-		desc->flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+		desc->flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 		desc++;
 		hclge_cmd_setup_basic_desc(desc, cmd, true);
 	}
@@ -13087,7 +13087,7 @@ static u16 hclge_get_sfp_eeprom_info(struct hclge_dev *hdev, u32 offset,
 
 		/* bd0~bd4 need next flag */
 		if (i < HCLGE_SFP_INFO_CMD_NUM - 1)
-			desc[i].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+			desc[i].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	}
 
 	/* setup bd0, this bd contains offset and read length. */
-- 
2.33.0

