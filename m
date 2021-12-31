Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DC0482361
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhLaK1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:27:50 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34870 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhLaK1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:27:43 -0500
Received: from kwepemi100008.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JQLt71rzKzccD6;
        Fri, 31 Dec 2021 18:27:11 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100008.china.huawei.com (7.221.188.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:41 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:40 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 07/13] net: hns3: create common cmdq resource allocate/free/query APIs
Date:   Fri, 31 Dec 2021 18:22:37 +0800
Message-ID: <20211231102243.3006-8-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211231102243.3006-1-huangguangbin2@huawei.com>
References: <20211231102243.3006-1-huangguangbin2@huawei.com>
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

The PF and VF cmdq module resource allocate/free/query APIs are almost the
same espect the suffixes of API names. These same implementations bring
double development and bugfix work.

This patch creates common cmdq resource allocate/free/query APIs called by
PF and VF cmdq init/uninit APIs. The next patch will use the new unified
APIs to replace init/uninit APIs.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hns3/hns3_common/hclge_comm_cmd.c         | 223 ++++++++++++++++++
 .../hns3/hns3_common/hclge_comm_cmd.h         |  89 ++++++-
 2 files changed, 311 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index 89e999248b9a..06bb95677ad4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -4,6 +4,229 @@
 #include "hnae3.h"
 #include "hclge_comm_cmd.h"
 
+static void hclge_comm_cmd_config_regs(struct hclge_comm_hw *hw,
+				       struct hclge_comm_cmq_ring *ring)
+{
+	dma_addr_t dma = ring->desc_dma_addr;
+	u32 reg_val;
+
+	if (ring->ring_type == HCLGE_COMM_TYPE_CSQ) {
+		hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CSQ_BASEADDR_L_REG,
+				     lower_32_bits(dma));
+		hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CSQ_BASEADDR_H_REG,
+				     upper_32_bits(dma));
+		reg_val = hclge_comm_read_dev(hw, HCLGE_COMM_NIC_CSQ_DEPTH_REG);
+		reg_val &= HCLGE_COMM_NIC_SW_RST_RDY;
+		reg_val |= ring->desc_num >> HCLGE_COMM_NIC_CMQ_DESC_NUM_S;
+		hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CSQ_DEPTH_REG, reg_val);
+		hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CSQ_HEAD_REG, 0);
+		hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CSQ_TAIL_REG, 0);
+	} else {
+		hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CRQ_BASEADDR_L_REG,
+				     lower_32_bits(dma));
+		hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CRQ_BASEADDR_H_REG,
+				     upper_32_bits(dma));
+		reg_val = ring->desc_num >> HCLGE_COMM_NIC_CMQ_DESC_NUM_S;
+		hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CRQ_DEPTH_REG, reg_val);
+		hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CRQ_HEAD_REG, 0);
+		hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CRQ_TAIL_REG, 0);
+	}
+}
+
+void hclge_comm_cmd_init_regs(struct hclge_comm_hw *hw)
+{
+	hclge_comm_cmd_config_regs(hw, &hw->cmq.csq);
+	hclge_comm_cmd_config_regs(hw, &hw->cmq.crq);
+}
+
+void hclge_comm_cmd_reuse_desc(struct hclge_desc *desc, bool is_read)
+{
+	desc->flag = cpu_to_le16(HCLGE_COMM_CMD_FLAG_NO_INTR |
+				 HCLGE_COMM_CMD_FLAG_IN);
+	if (is_read)
+		desc->flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_WR);
+	else
+		desc->flag &= cpu_to_le16(~HCLGE_COMM_CMD_FLAG_WR);
+}
+
+static void hclge_comm_set_default_capability(struct hnae3_ae_dev *ae_dev,
+					      bool is_pf)
+{
+	set_bit(HNAE3_DEV_SUPPORT_FD_B, ae_dev->caps);
+	set_bit(HNAE3_DEV_SUPPORT_GRO_B, ae_dev->caps);
+	if (is_pf && ae_dev->dev_version == HNAE3_DEVICE_VERSION_V2) {
+		set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
+		set_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps);
+	}
+}
+
+void hclge_comm_cmd_setup_basic_desc(struct hclge_desc *desc,
+				     enum hclge_comm_opcode_type opcode,
+				     bool is_read)
+{
+	memset((void *)desc, 0, sizeof(struct hclge_desc));
+	desc->opcode = cpu_to_le16(opcode);
+	desc->flag = cpu_to_le16(HCLGE_COMM_CMD_FLAG_NO_INTR |
+				 HCLGE_COMM_CMD_FLAG_IN);
+
+	if (is_read)
+		desc->flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_WR);
+}
+
+int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev, bool is_pf,
+				      struct hclge_comm_hw *hw, bool en)
+{
+	struct hclge_comm_firmware_compat_cmd *req;
+	struct hclge_desc desc;
+	u32 compat = 0;
+
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_COMM_OPC_IMP_COMPAT_CFG,
+					false);
+
+	if (en) {
+		req = (struct hclge_comm_firmware_compat_cmd *)desc.data;
+
+		hnae3_set_bit(compat, HCLGE_COMM_LINK_EVENT_REPORT_EN_B, 1);
+		hnae3_set_bit(compat, HCLGE_COMM_NCSI_ERROR_REPORT_EN_B, 1);
+		if (hclge_comm_dev_phy_imp_supported(ae_dev))
+			hnae3_set_bit(compat, HCLGE_COMM_PHY_IMP_EN_B, 1);
+		hnae3_set_bit(compat, HCLGE_COMM_MAC_STATS_EXT_EN_B, 1);
+		hnae3_set_bit(compat, HCLGE_COMM_SYNC_RX_RING_HEAD_EN_B, 1);
+
+		req->compat = cpu_to_le32(compat);
+	}
+
+	return hclge_comm_cmd_send(hw, &desc, 1, is_pf);
+}
+
+void hclge_comm_free_cmd_desc(struct hclge_comm_cmq_ring *ring)
+{
+	int size  = ring->desc_num * sizeof(struct hclge_desc);
+
+	if (!ring->desc)
+		return;
+
+	dma_free_coherent(&ring->pdev->dev, size,
+			  ring->desc, ring->desc_dma_addr);
+	ring->desc = NULL;
+}
+
+static int hclge_comm_alloc_cmd_desc(struct hclge_comm_cmq_ring *ring)
+{
+	int size  = ring->desc_num * sizeof(struct hclge_desc);
+
+	ring->desc = dma_alloc_coherent(&ring->pdev->dev,
+					size, &ring->desc_dma_addr, GFP_KERNEL);
+	if (!ring->desc)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static __le32 hclge_comm_build_api_caps(void)
+{
+	u32 api_caps = 0;
+
+	hnae3_set_bit(api_caps, HCLGE_COMM_API_CAP_FLEX_RSS_TBL_B, 1);
+
+	return cpu_to_le32(api_caps);
+}
+
+static const struct hclge_comm_caps_bit_map hclge_pf_cmd_caps[] = {
+	{HCLGE_COMM_CAP_UDP_GSO_B, HNAE3_DEV_SUPPORT_UDP_GSO_B},
+	{HCLGE_COMM_CAP_PTP_B, HNAE3_DEV_SUPPORT_PTP_B},
+	{HCLGE_COMM_CAP_INT_QL_B, HNAE3_DEV_SUPPORT_INT_QL_B},
+	{HCLGE_COMM_CAP_TQP_TXRX_INDEP_B, HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B},
+	{HCLGE_COMM_CAP_HW_TX_CSUM_B, HNAE3_DEV_SUPPORT_HW_TX_CSUM_B},
+	{HCLGE_COMM_CAP_UDP_TUNNEL_CSUM_B, HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B},
+	{HCLGE_COMM_CAP_FD_FORWARD_TC_B, HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B},
+	{HCLGE_COMM_CAP_FEC_B, HNAE3_DEV_SUPPORT_FEC_B},
+	{HCLGE_COMM_CAP_PAUSE_B, HNAE3_DEV_SUPPORT_PAUSE_B},
+	{HCLGE_COMM_CAP_PHY_IMP_B, HNAE3_DEV_SUPPORT_PHY_IMP_B},
+	{HCLGE_COMM_CAP_QB_B, HNAE3_DEV_SUPPORT_QB_B},
+	{HCLGE_COMM_CAP_TX_PUSH_B, HNAE3_DEV_SUPPORT_TX_PUSH_B},
+	{HCLGE_COMM_CAP_RAS_IMP_B, HNAE3_DEV_SUPPORT_RAS_IMP_B},
+	{HCLGE_COMM_CAP_RXD_ADV_LAYOUT_B, HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B},
+	{HCLGE_COMM_CAP_PORT_VLAN_BYPASS_B,
+	 HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B},
+	{HCLGE_COMM_CAP_PORT_VLAN_BYPASS_B, HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B},
+};
+
+static const struct hclge_comm_caps_bit_map hclge_vf_cmd_caps[] = {
+	{HCLGE_COMM_CAP_UDP_GSO_B, HNAE3_DEV_SUPPORT_UDP_GSO_B},
+	{HCLGE_COMM_CAP_INT_QL_B, HNAE3_DEV_SUPPORT_INT_QL_B},
+	{HCLGE_COMM_CAP_TQP_TXRX_INDEP_B, HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B},
+	{HCLGE_COMM_CAP_HW_TX_CSUM_B, HNAE3_DEV_SUPPORT_HW_TX_CSUM_B},
+	{HCLGE_COMM_CAP_UDP_TUNNEL_CSUM_B, HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B},
+	{HCLGE_COMM_CAP_QB_B, HNAE3_DEV_SUPPORT_QB_B},
+	{HCLGE_COMM_CAP_TX_PUSH_B, HNAE3_DEV_SUPPORT_TX_PUSH_B},
+	{HCLGE_COMM_CAP_RXD_ADV_LAYOUT_B, HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B},
+};
+
+static void
+hclge_comm_parse_capability(struct hnae3_ae_dev *ae_dev, bool is_pf,
+			    struct hclge_comm_query_version_cmd *cmd)
+{
+	const struct hclge_comm_caps_bit_map *caps_map =
+				is_pf ? hclge_pf_cmd_caps : hclge_vf_cmd_caps;
+	u32 size = is_pf ? ARRAY_SIZE(hclge_pf_cmd_caps) :
+				ARRAY_SIZE(hclge_vf_cmd_caps);
+	u32 caps, i;
+
+	caps = __le32_to_cpu(cmd->caps[0]);
+	for (i = 0; i < size; i++)
+		if (hnae3_get_bit(caps, caps_map[i].imp_bit))
+			set_bit(caps_map[i].local_bit, ae_dev->caps);
+}
+
+int hclge_comm_alloc_cmd_queue(struct hclge_comm_hw *hw, int ring_type)
+{
+	struct hclge_comm_cmq_ring *ring =
+		(ring_type == HCLGE_COMM_TYPE_CSQ) ? &hw->cmq.csq :
+						     &hw->cmq.crq;
+	int ret;
+
+	ring->ring_type = ring_type;
+
+	ret = hclge_comm_alloc_cmd_desc(ring);
+	if (ret)
+		dev_err(&ring->pdev->dev, "descriptor %s alloc error %d\n",
+			(ring_type == HCLGE_COMM_TYPE_CSQ) ? "CSQ" : "CRQ",
+			ret);
+
+	return ret;
+}
+
+int hclge_comm_cmd_query_version_and_capability(struct hnae3_ae_dev *ae_dev,
+						struct hclge_comm_hw *hw,
+						u32 *fw_version, bool is_pf)
+{
+	struct hclge_comm_query_version_cmd *resp;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_COMM_OPC_QUERY_FW_VER, 1);
+	resp = (struct hclge_comm_query_version_cmd *)desc.data;
+	resp->api_caps = hclge_comm_build_api_caps();
+
+	ret = hclge_comm_cmd_send(hw, &desc, 1, is_pf);
+	if (ret)
+		return ret;
+
+	*fw_version = le32_to_cpu(resp->firmware);
+
+	ae_dev->dev_version = le32_to_cpu(resp->hardware) <<
+					 HNAE3_PCI_REVISION_BIT_SIZE;
+	ae_dev->dev_version |= ae_dev->pdev->revision;
+
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
+		hclge_comm_set_default_capability(ae_dev, is_pf);
+
+	hclge_comm_parse_capability(ae_dev, is_pf, resp);
+
+	return ret;
+}
+
 static bool hclge_is_elem_in_array(const u16 *spec_opcode, u32 size, u16 opcode)
 {
 	u32 i;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index 5164c666cae7..2d28197fd6cf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -7,13 +7,41 @@
 
 #include "hnae3.h"
 
+#define HCLGE_COMM_CMD_FLAG_IN			BIT(0)
+#define HCLGE_COMM_CMD_FLAG_NEXT		BIT(2)
+#define HCLGE_COMM_CMD_FLAG_WR			BIT(3)
 #define HCLGE_COMM_CMD_FLAG_NO_INTR		BIT(4)
 
 #define HCLGE_COMM_SEND_SYNC(flag) \
 	((flag) & HCLGE_COMM_CMD_FLAG_NO_INTR)
 
+#define HCLGE_COMM_LINK_EVENT_REPORT_EN_B	0
+#define HCLGE_COMM_NCSI_ERROR_REPORT_EN_B	1
+#define HCLGE_COMM_PHY_IMP_EN_B			2
+#define HCLGE_COMM_MAC_STATS_EXT_EN_B		3
+#define HCLGE_COMM_SYNC_RX_RING_HEAD_EN_B	4
+
+#define hclge_comm_dev_phy_imp_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, (ae_dev)->caps)
+
+#define HCLGE_COMM_TYPE_CRQ			0
+#define HCLGE_COMM_TYPE_CSQ			1
+
+#define HCLGE_COMM_NIC_CSQ_BASEADDR_L_REG	0x27000
+#define HCLGE_COMM_NIC_CSQ_BASEADDR_H_REG	0x27004
+#define HCLGE_COMM_NIC_CSQ_DEPTH_REG		0x27008
 #define HCLGE_COMM_NIC_CSQ_TAIL_REG		0x27010
 #define HCLGE_COMM_NIC_CSQ_HEAD_REG		0x27014
+#define HCLGE_COMM_NIC_CRQ_BASEADDR_L_REG	0x27018
+#define HCLGE_COMM_NIC_CRQ_BASEADDR_H_REG	0x2701C
+#define HCLGE_COMM_NIC_CRQ_DEPTH_REG		0x27020
+#define HCLGE_COMM_NIC_CRQ_TAIL_REG		0x27024
+#define HCLGE_COMM_NIC_CRQ_HEAD_REG		0x27028
+
+/* this bit indicates that the driver is ready for hardware reset */
+#define HCLGE_COMM_NIC_SW_RST_RDY_B		16
+#define HCLGE_COMM_NIC_SW_RST_RDY		BIT(HCLGE_COMM_NIC_SW_RST_RDY_B)
+#define HCLGE_COMM_NIC_CMQ_DESC_NUM_S		3
 
 enum hclge_comm_cmd_return_status {
 	HCLGE_COMM_CMD_EXEC_SUCCESS	= 0,
@@ -44,6 +72,46 @@ enum hclge_comm_special_cmd {
 	HCLGE_COMM_QUERY_ALL_ERR_INFO		= 0x1517,
 };
 
+enum HCLGE_COMM_CAP_BITS {
+	HCLGE_COMM_CAP_UDP_GSO_B,
+	HCLGE_COMM_CAP_QB_B,
+	HCLGE_COMM_CAP_FD_FORWARD_TC_B,
+	HCLGE_COMM_CAP_PTP_B,
+	HCLGE_COMM_CAP_INT_QL_B,
+	HCLGE_COMM_CAP_HW_TX_CSUM_B,
+	HCLGE_COMM_CAP_TX_PUSH_B,
+	HCLGE_COMM_CAP_PHY_IMP_B,
+	HCLGE_COMM_CAP_TQP_TXRX_INDEP_B,
+	HCLGE_COMM_CAP_HW_PAD_B,
+	HCLGE_COMM_CAP_STASH_B,
+	HCLGE_COMM_CAP_UDP_TUNNEL_CSUM_B,
+	HCLGE_COMM_CAP_RAS_IMP_B = 12,
+	HCLGE_COMM_CAP_FEC_B = 13,
+	HCLGE_COMM_CAP_PAUSE_B = 14,
+	HCLGE_COMM_CAP_RXD_ADV_LAYOUT_B = 15,
+	HCLGE_COMM_CAP_PORT_VLAN_BYPASS_B = 17,
+};
+
+enum HCLGE_COMM_API_CAP_BITS {
+	HCLGE_COMM_API_CAP_FLEX_RSS_TBL_B,
+};
+
+enum hclge_comm_opcode_type {
+	HCLGE_COMM_OPC_QUERY_FW_VER		= 0x0001,
+	HCLGE_COMM_OPC_IMP_COMPAT_CFG		= 0x701A,
+};
+
+/* capabilities bits map between imp firmware and local driver */
+struct hclge_comm_caps_bit_map {
+	u16 imp_bit;
+	u16 local_bit;
+};
+
+struct hclge_comm_firmware_compat_cmd {
+	__le32 compat;
+	u8 rsv[20];
+};
+
 enum hclge_comm_cmd_state {
 	HCLGE_COMM_STATE_CMD_DISABLE,
 };
@@ -53,6 +121,14 @@ struct hclge_comm_errcode {
 	int common_errno;
 };
 
+#define HCLGE_COMM_QUERY_CAP_LENGTH		3
+struct hclge_comm_query_version_cmd {
+	__le32 firmware;
+	__le32 hardware;
+	__le32 api_caps;
+	__le32 caps[HCLGE_COMM_QUERY_CAP_LENGTH]; /* capabilities of device */
+};
+
 #define HCLGE_DESC_DATA_LEN		6
 struct hclge_desc {
 	__le16 opcode;
@@ -115,7 +191,18 @@ static inline u32 hclge_comm_read_reg(u8 __iomem *base, u32 reg)
 #define hclge_comm_read_dev(a, reg) \
 	hclge_comm_read_reg((a)->io_base, reg)
 
+void hclge_comm_cmd_init_regs(struct hclge_comm_hw *hw);
+int hclge_comm_cmd_query_version_and_capability(struct hnae3_ae_dev *ae_dev,
+						struct hclge_comm_hw *hw,
+						u32 *fw_version, bool is_pf);
+int hclge_comm_alloc_cmd_queue(struct hclge_comm_hw *hw, int ring_type);
 int hclge_comm_cmd_send(struct hclge_comm_hw *hw, struct hclge_desc *desc,
 			int num, bool is_pf);
-
+void hclge_comm_cmd_reuse_desc(struct hclge_desc *desc, bool is_read);
+int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev, bool is_pf,
+				      struct hclge_comm_hw *hw, bool en);
+void hclge_comm_free_cmd_desc(struct hclge_comm_cmq_ring *ring);
+void hclge_comm_cmd_setup_basic_desc(struct hclge_desc *desc,
+				     enum hclge_comm_opcode_type opcode,
+				     bool is_read);
 #endif
-- 
2.33.0

