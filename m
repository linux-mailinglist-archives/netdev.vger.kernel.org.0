Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41E4279F36
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbgI0HPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:15:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14249 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730433AbgI0HPp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 03:15:45 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 84F9161C29FCD6CB7378;
        Sun, 27 Sep 2020 15:15:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sun, 27 Sep 2020 15:15:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/10] net: hns3: add support to query device specifications
Date:   Sun, 27 Sep 2020 15:12:45 +0800
Message-ID: <1601190768-50075-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
References: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

To improve code maintainability and compatibility, new commands
HCLGE_OPC_QUERY_DEV_SPECS for PF and HCLGEVF_OPC_QUERY_DEV_SPECS
for VF are introduced to query device specifications, instead of
statically defining specifications by checking the hardware version
or other methods.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        | 11 ++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 16 +++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 62 +++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   | 15 +++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 64 ++++++++++++++++++++++
 5 files changed, 167 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 32f0cce..cc48221 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -267,6 +267,16 @@ struct hnae3_ring_chain_node {
 #define HNAE3_IS_TX_RING(node) \
 	(((node)->flag & (1 << HNAE3_RING_TYPE_B)) == HNAE3_RING_TYPE_TX)
 
+/* device specification info from firmware */
+struct hnae3_dev_specs {
+	u32 mac_entry_num; /* number of mac-vlan table entry */
+	u32 mng_entry_num; /* number of manager table entry */
+	u16 rss_ind_tbl_size;
+	u16 rss_key_size;
+	u16 int_ql_max; /* max value of interrupt coalesce based on INT_QL */
+	u8 max_non_tso_bd_num; /* max BD number of one non-TSO packet */
+};
+
 struct hnae3_client_ops {
 	int (*init_instance)(struct hnae3_handle *handle);
 	void (*uninit_instance)(struct hnae3_handle *handle, bool reset);
@@ -294,6 +304,7 @@ struct hnae3_ae_dev {
 	struct list_head node;
 	u32 flag;
 	unsigned long hw_err_reset_req;
+	struct hnae3_dev_specs dev_specs;
 	u32 dev_version;
 	unsigned long caps[BITS_TO_LONGS(HNAE3_DEV_CAPS_MAX_NUM)];
 	void *priv;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 3489c75..d37066a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -115,7 +115,8 @@ enum hclge_opcode_type {
 	HCLGE_OPC_DFX_RCB_REG		= 0x004D,
 	HCLGE_OPC_DFX_TQP_REG		= 0x004E,
 	HCLGE_OPC_DFX_SSU_REG_2		= 0x004F,
-	HCLGE_OPC_DFX_QUERY_CHIP_CAP	= 0x0050,
+
+	HCLGE_OPC_QUERY_DEV_SPECS	= 0x0050,
 
 	/* MAC command */
 	HCLGE_OPC_CONFIG_MAC_MODE	= 0x0301,
@@ -1088,6 +1089,19 @@ struct hclge_sfp_info_bd0_cmd {
 	u8 data[HCLGE_SFP_INFO_BD0_LEN];
 };
 
+#define HCLGE_QUERY_DEV_SPECS_BD_NUM		4
+
+struct hclge_dev_specs_0_cmd {
+	__le32 rsv0;
+	__le32 mac_entry_num;
+	__le32 mng_entry_num;
+	__le16 rss_ind_tbl_size;
+	__le16 rss_key_size;
+	__le16 int_ql_max;
+	u8 max_non_tso_bd_num;
+	u8 rsv1[5];
+};
+
 int hclge_cmd_init(struct hclge_dev *hdev);
 static inline void hclge_write_reg(void __iomem *base, u32 reg, u32 value)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 871632a..7825864 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1356,6 +1356,61 @@ static int hclge_get_cfg(struct hclge_dev *hdev, struct hclge_cfg *hcfg)
 	return 0;
 }
 
+static void hclge_set_default_dev_specs(struct hclge_dev *hdev)
+{
+#define HCLGE_MAX_NON_TSO_BD_NUM			8U
+
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+
+	ae_dev->dev_specs.max_non_tso_bd_num = HCLGE_MAX_NON_TSO_BD_NUM;
+	ae_dev->dev_specs.rss_ind_tbl_size = HCLGE_RSS_IND_TBL_SIZE;
+	ae_dev->dev_specs.rss_key_size = HCLGE_RSS_KEY_SIZE;
+}
+
+static void hclge_parse_dev_specs(struct hclge_dev *hdev,
+				  struct hclge_desc *desc)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	struct hclge_dev_specs_0_cmd *req0;
+
+	req0 = (struct hclge_dev_specs_0_cmd *)desc[0].data;
+
+	ae_dev->dev_specs.max_non_tso_bd_num = req0->max_non_tso_bd_num;
+	ae_dev->dev_specs.rss_ind_tbl_size =
+		le16_to_cpu(req0->rss_ind_tbl_size);
+	ae_dev->dev_specs.rss_key_size = le16_to_cpu(req0->rss_key_size);
+}
+
+static int hclge_query_dev_specs(struct hclge_dev *hdev)
+{
+	struct hclge_desc desc[HCLGE_QUERY_DEV_SPECS_BD_NUM];
+	int ret;
+	int i;
+
+	/* set default specifications as devices lower than version V3 do not
+	 * support querying specifications from firmware.
+	 */
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3) {
+		hclge_set_default_dev_specs(hdev);
+		return 0;
+	}
+
+	for (i = 0; i < HCLGE_QUERY_DEV_SPECS_BD_NUM - 1; i++) {
+		hclge_cmd_setup_basic_desc(&desc[i], HCLGE_OPC_QUERY_DEV_SPECS,
+					   true);
+		desc[i].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	}
+	hclge_cmd_setup_basic_desc(&desc[i], HCLGE_OPC_QUERY_DEV_SPECS, true);
+
+	ret = hclge_cmd_send(&hdev->hw, desc, HCLGE_QUERY_DEV_SPECS_BD_NUM);
+	if (ret)
+		return ret;
+
+	hclge_parse_dev_specs(hdev, desc);
+
+	return 0;
+}
+
 static int hclge_get_cap(struct hclge_dev *hdev)
 {
 	int ret;
@@ -9990,6 +10045,13 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_cmd_uninit;
 
+	ret = hclge_query_dev_specs(hdev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to query dev specifications, ret = %d.\n",
+			ret);
+		goto err_cmd_uninit;
+	}
+
 	ret = hclge_configure(hdev);
 	if (ret) {
 		dev_err(&pdev->dev, "Configure dev error, ret = %d.\n", ret);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 326f3cb..9460c12 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -91,6 +91,8 @@ enum hclgevf_opcode_type {
 	/* Generic command */
 	HCLGEVF_OPC_QUERY_FW_VER	= 0x0001,
 	HCLGEVF_OPC_QUERY_VF_RSRC	= 0x0024,
+	HCLGEVF_OPC_QUERY_DEV_SPECS	= 0x0050,
+
 	/* TQP command */
 	HCLGEVF_OPC_QUERY_TX_STATUS	= 0x0B03,
 	HCLGEVF_OPC_QUERY_RX_STATUS	= 0x0B13,
@@ -270,6 +272,19 @@ struct hclgevf_cfg_tx_queue_pointer_cmd {
 #define HCLGEVF_NIC_CMQ_DESC_NUM_S	3
 #define HCLGEVF_NIC_CMDQ_INT_SRC_REG	0x27100
 
+#define HCLGEVF_QUERY_DEV_SPECS_BD_NUM		4
+
+struct hclgevf_dev_specs_0_cmd {
+	__le32 rsv0;
+	__le32 mac_entry_num;
+	__le32 mng_entry_num;
+	__le16 rss_ind_tbl_size;
+	__le16 rss_key_size;
+	__le16 int_ql_max;
+	u8 max_non_tso_bd_num;
+	u8 rsv1[5];
+};
+
 static inline void hclgevf_write_reg(void __iomem *base, u32 reg, u32 value)
 {
 	writel(value, base + reg);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 9a6f355..b64fa0b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2939,6 +2939,63 @@ static int hclgevf_query_vf_resource(struct hclgevf_dev *hdev)
 	return 0;
 }
 
+static void hclgevf_set_default_dev_specs(struct hclgevf_dev *hdev)
+{
+#define HCLGEVF_MAX_NON_TSO_BD_NUM			8U
+
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+
+	ae_dev->dev_specs.max_non_tso_bd_num =
+					HCLGEVF_MAX_NON_TSO_BD_NUM;
+	ae_dev->dev_specs.rss_ind_tbl_size = HCLGEVF_RSS_IND_TBL_SIZE;
+	ae_dev->dev_specs.rss_key_size = HCLGEVF_RSS_KEY_SIZE;
+}
+
+static void hclgevf_parse_dev_specs(struct hclgevf_dev *hdev,
+				    struct hclgevf_desc *desc)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	struct hclgevf_dev_specs_0_cmd *req0;
+
+	req0 = (struct hclgevf_dev_specs_0_cmd *)desc[0].data;
+
+	ae_dev->dev_specs.max_non_tso_bd_num = req0->max_non_tso_bd_num;
+	ae_dev->dev_specs.rss_ind_tbl_size =
+					le16_to_cpu(req0->rss_ind_tbl_size);
+	ae_dev->dev_specs.rss_key_size = le16_to_cpu(req0->rss_key_size);
+}
+
+static int hclgevf_query_dev_specs(struct hclgevf_dev *hdev)
+{
+	struct hclgevf_desc desc[HCLGEVF_QUERY_DEV_SPECS_BD_NUM];
+	int ret;
+	int i;
+
+	/* set default specifications as devices lower than version V3 do not
+	 * support querying specifications from firmware.
+	 */
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3) {
+		hclgevf_set_default_dev_specs(hdev);
+		return 0;
+	}
+
+	for (i = 0; i < HCLGEVF_QUERY_DEV_SPECS_BD_NUM - 1; i++) {
+		hclgevf_cmd_setup_basic_desc(&desc[i],
+					     HCLGEVF_OPC_QUERY_DEV_SPECS, true);
+		desc[i].flag |= cpu_to_le16(HCLGEVF_CMD_FLAG_NEXT);
+	}
+	hclgevf_cmd_setup_basic_desc(&desc[i], HCLGEVF_OPC_QUERY_DEV_SPECS,
+				     true);
+
+	ret = hclgevf_cmd_send(&hdev->hw, desc, HCLGEVF_QUERY_DEV_SPECS_BD_NUM);
+	if (ret)
+		return ret;
+
+	hclgevf_parse_dev_specs(hdev, desc);
+
+	return 0;
+}
+
 static int hclgevf_pci_reset(struct hclgevf_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
@@ -3047,6 +3104,13 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	if (ret)
 		goto err_cmd_init;
 
+	ret = hclgevf_query_dev_specs(hdev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"failed to query dev specifications, ret = %d\n", ret);
+		goto err_cmd_init;
+	}
+
 	ret = hclgevf_init_msi(hdev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed(%d) to init MSI/MSI-X\n", ret);
-- 
2.7.4

