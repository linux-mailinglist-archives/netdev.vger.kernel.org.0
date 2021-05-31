Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB763953F5
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 04:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhEaClI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 22:41:08 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6085 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhEaCku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 22:40:50 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FtfYk62ktzYpr5;
        Mon, 31 May 2021 10:36:26 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:08 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 8/8] net: hns3: add debugfs support for vlan configuration
Date:   Mon, 31 May 2021 10:38:45 +0800
Message-ID: <1622428725-30049-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
References: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Add debugfs support for vlan configuraion. create a single file
"vlan_config" for it, and query it by command "cat vlan_config",
return the result to userspace.

The new display style is below:
$ cat vlan_config
I_PORT_VLAN_FILTER: on
E_PORT_VLAN_FILTER: off
FUNC_ID  I_VF_VLAN_FILTER  E_VF_VLAN_FILTER  PORT_VLAN_FILTER_BYPASS
pf       off               on                off
vf0      off               on                off
FUNC_ID  PVID    ACCEPT_TAG1  ACCEPT_TAG2  ACCEPT_UNTAG1  ACCEPT_UNTAG2
pf       0       on           on           on             on
vf0      0       on           on           on             on

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   7 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 283 +++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |  19 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  12 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  12 +
 6 files changed, 322 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 0ce353da..89b2b7f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -288,6 +288,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_REG_TQP,
 	HNAE3_DBG_CMD_REG_MAC,
 	HNAE3_DBG_CMD_REG_DCB,
+	HNAE3_DBG_CMD_VLAN_CONFIG,
 	HNAE3_DBG_CMD_QUEUE_MAP,
 	HNAE3_DBG_CMD_RX_QUEUE_INFO,
 	HNAE3_DBG_CMD_TX_QUEUE_INFO,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 3feba43..cf1efd2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -309,6 +309,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "vlan_config",
+		.cmd = HNAE3_DBG_CMD_VLAN_CONFIG,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 0b7c683..0d433a5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1894,6 +1894,285 @@ static void hclge_dbg_dump_mac_list(struct hclge_dev *hdev, char *buf, int len,
 	}
 }
 
+static int hclge_get_vlan_rx_offload_cfg(struct hclge_dev *hdev, u8 vf_id,
+					 struct hclge_dbg_vlan_cfg *vlan_cfg)
+{
+	struct hclge_vport_vtag_rx_cfg_cmd *req;
+	struct hclge_desc desc;
+	u16 bmap_index;
+	u8 rx_cfg;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_PORT_RX_CFG, true);
+
+	req = (struct hclge_vport_vtag_rx_cfg_cmd *)desc.data;
+	req->vf_offset = vf_id / HCLGE_VF_NUM_PER_CMD;
+	bmap_index = vf_id % HCLGE_VF_NUM_PER_CMD / HCLGE_VF_NUM_PER_BYTE;
+	req->vf_bitmap[bmap_index] = 1U << (vf_id % HCLGE_VF_NUM_PER_BYTE);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get vport%u rxvlan cfg, ret = %d\n",
+			vf_id, ret);
+		return ret;
+	}
+
+	rx_cfg = req->vport_vlan_cfg;
+	vlan_cfg->strip_tag1 = hnae3_get_bit(rx_cfg, HCLGE_REM_TAG1_EN_B);
+	vlan_cfg->strip_tag2 = hnae3_get_bit(rx_cfg, HCLGE_REM_TAG2_EN_B);
+	vlan_cfg->drop_tag1 = hnae3_get_bit(rx_cfg, HCLGE_DISCARD_TAG1_EN_B);
+	vlan_cfg->drop_tag2 = hnae3_get_bit(rx_cfg, HCLGE_DISCARD_TAG2_EN_B);
+	vlan_cfg->pri_only1 = hnae3_get_bit(rx_cfg, HCLGE_SHOW_TAG1_EN_B);
+	vlan_cfg->pri_only2 = hnae3_get_bit(rx_cfg, HCLGE_SHOW_TAG2_EN_B);
+
+	return 0;
+}
+
+static int hclge_get_vlan_tx_offload_cfg(struct hclge_dev *hdev, u8 vf_id,
+					 struct hclge_dbg_vlan_cfg *vlan_cfg)
+{
+	struct hclge_vport_vtag_tx_cfg_cmd *req;
+	struct hclge_desc desc;
+	u16 bmap_index;
+	u8 tx_cfg;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_PORT_TX_CFG, true);
+	req = (struct hclge_vport_vtag_tx_cfg_cmd *)desc.data;
+	req->vf_offset = vf_id / HCLGE_VF_NUM_PER_CMD;
+	bmap_index = vf_id % HCLGE_VF_NUM_PER_CMD / HCLGE_VF_NUM_PER_BYTE;
+	req->vf_bitmap[bmap_index] = 1U << (vf_id % HCLGE_VF_NUM_PER_BYTE);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get vport%u txvlan cfg, ret = %d\n",
+			vf_id, ret);
+		return ret;
+	}
+
+	tx_cfg = req->vport_vlan_cfg;
+	vlan_cfg->pvid = le16_to_cpu(req->def_vlan_tag1);
+
+	vlan_cfg->accept_tag1 = hnae3_get_bit(tx_cfg, HCLGE_ACCEPT_TAG1_B);
+	vlan_cfg->accept_tag2 = hnae3_get_bit(tx_cfg, HCLGE_ACCEPT_TAG2_B);
+	vlan_cfg->accept_untag1 = hnae3_get_bit(tx_cfg, HCLGE_ACCEPT_UNTAG1_B);
+	vlan_cfg->accept_untag2 = hnae3_get_bit(tx_cfg, HCLGE_ACCEPT_UNTAG2_B);
+	vlan_cfg->insert_tag1 = hnae3_get_bit(tx_cfg, HCLGE_PORT_INS_TAG1_EN_B);
+	vlan_cfg->insert_tag2 = hnae3_get_bit(tx_cfg, HCLGE_PORT_INS_TAG2_EN_B);
+	vlan_cfg->shift_tag = hnae3_get_bit(tx_cfg, HCLGE_TAG_SHIFT_MODE_EN_B);
+
+	return 0;
+}
+
+static int hclge_get_vlan_filter_config_cmd(struct hclge_dev *hdev,
+					    u8 vlan_type, u8 vf_id,
+					    struct hclge_desc *desc)
+{
+	struct hclge_vlan_filter_ctrl_cmd *req;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(desc, HCLGE_OPC_VLAN_FILTER_CTRL, true);
+	req = (struct hclge_vlan_filter_ctrl_cmd *)desc->data;
+	req->vlan_type = vlan_type;
+	req->vf_id = vf_id;
+
+	ret = hclge_cmd_send(&hdev->hw, desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to get vport%u vlan filter config, ret = %d.\n",
+			vf_id, ret);
+
+	return ret;
+}
+
+static int hclge_get_vlan_filter_state(struct hclge_dev *hdev, u8 vlan_type,
+				       u8 vf_id, u8 *vlan_fe)
+{
+	struct hclge_vlan_filter_ctrl_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	ret = hclge_get_vlan_filter_config_cmd(hdev, vlan_type, vf_id, &desc);
+	if (ret)
+		return ret;
+
+	req = (struct hclge_vlan_filter_ctrl_cmd *)desc.data;
+	*vlan_fe = req->vlan_fe;
+
+	return 0;
+}
+
+static int hclge_get_port_vlan_filter_bypass_state(struct hclge_dev *hdev,
+						   u8 vf_id, u8 *bypass_en)
+{
+	struct hclge_port_vlan_filter_bypass_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	if (!test_bit(HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B, hdev->ae_dev->caps))
+		return 0;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_PORT_VLAN_BYPASS, true);
+	req = (struct hclge_port_vlan_filter_bypass_cmd *)desc.data;
+	req->vf_id = vf_id;
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get vport%u port vlan filter bypass state, ret = %d.\n",
+			vf_id, ret);
+		return ret;
+	}
+
+	*bypass_en = hnae3_get_bit(req->bypass_state, HCLGE_INGRESS_BYPASS_B);
+
+	return 0;
+}
+
+static const struct hclge_dbg_item vlan_filter_items[] = {
+	{ "FUNC_ID", 2 },
+	{ "I_VF_VLAN_FILTER", 2 },
+	{ "E_VF_VLAN_FILTER", 2 },
+	{ "PORT_VLAN_FILTER_BYPASS", 0 }
+};
+
+static const struct hclge_dbg_item vlan_offload_items[] = {
+	{ "FUNC_ID", 2 },
+	{ "PVID", 4 },
+	{ "ACCEPT_TAG1", 2 },
+	{ "ACCEPT_TAG2", 2 },
+	{ "ACCEPT_UNTAG1", 2 },
+	{ "ACCEPT_UNTAG2", 2 },
+	{ "INSERT_TAG1", 2 },
+	{ "INSERT_TAG2", 2 },
+	{ "SHIFT_TAG", 2 },
+	{ "STRIP_TAG1", 2 },
+	{ "STRIP_TAG2", 2 },
+	{ "DROP_TAG1", 2 },
+	{ "DROP_TAG2", 2 },
+	{ "PRI_ONLY_TAG1", 2 },
+	{ "PRI_ONLY_TAG2", 0 }
+};
+
+static int hclge_dbg_dump_vlan_filter_config(struct hclge_dev *hdev, char *buf,
+					     int len, int *pos)
+{
+	char content[HCLGE_DBG_VLAN_FLTR_INFO_LEN], str_id[HCLGE_DBG_ID_LEN];
+	const char *result[ARRAY_SIZE(vlan_filter_items)];
+	u8 i, j, vlan_fe, bypass, ingress, egress;
+	u8 func_num = pci_num_vf(hdev->pdev) + 1; /* pf and enabled vf num */
+	int ret;
+
+	ret = hclge_get_vlan_filter_state(hdev, HCLGE_FILTER_TYPE_PORT, 0,
+					  &vlan_fe);
+	if (ret)
+		return ret;
+	ingress = vlan_fe & HCLGE_FILTER_FE_NIC_INGRESS_B;
+	egress = vlan_fe & HCLGE_FILTER_FE_NIC_EGRESS_B ? 1 : 0;
+
+	*pos += scnprintf(buf, len, "I_PORT_VLAN_FILTER: %s\n",
+			  state_str[ingress]);
+	*pos += scnprintf(buf + *pos, len - *pos, "E_PORT_VLAN_FILTER: %s\n",
+			  state_str[egress]);
+
+	hclge_dbg_fill_content(content, sizeof(content), vlan_filter_items,
+			       NULL, ARRAY_SIZE(vlan_filter_items));
+	*pos += scnprintf(buf + *pos, len - *pos, "%s", content);
+
+	for (i = 0; i < func_num; i++) {
+		ret = hclge_get_vlan_filter_state(hdev, HCLGE_FILTER_TYPE_VF, i,
+						  &vlan_fe);
+		if (ret)
+			return ret;
+
+		ingress = vlan_fe & HCLGE_FILTER_FE_NIC_INGRESS_B;
+		egress = vlan_fe & HCLGE_FILTER_FE_NIC_EGRESS_B ? 1 : 0;
+		ret = hclge_get_port_vlan_filter_bypass_state(hdev, i, &bypass);
+		if (ret)
+			return ret;
+		j = 0;
+		result[j++] = hclge_dbg_get_func_id_str(str_id, i);
+		result[j++] = state_str[ingress];
+		result[j++] = state_str[egress];
+		result[j++] =
+			test_bit(HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B,
+				 hdev->ae_dev->caps) ? state_str[bypass] : "NA";
+		hclge_dbg_fill_content(content, sizeof(content),
+				       vlan_filter_items, result,
+				       ARRAY_SIZE(vlan_filter_items));
+		*pos += scnprintf(buf + *pos, len - *pos, "%s", content);
+	}
+	*pos += scnprintf(buf + *pos, len - *pos, "\n");
+
+	return 0;
+}
+
+static int hclge_dbg_dump_vlan_offload_config(struct hclge_dev *hdev, char *buf,
+					      int len, int *pos)
+{
+	char str_id[HCLGE_DBG_ID_LEN], str_pvid[HCLGE_DBG_ID_LEN];
+	const char *result[ARRAY_SIZE(vlan_offload_items)];
+	char content[HCLGE_DBG_VLAN_OFFLOAD_INFO_LEN];
+	u8 func_num = pci_num_vf(hdev->pdev) + 1; /* pf and enabled vf num */
+	struct hclge_dbg_vlan_cfg vlan_cfg;
+	int ret;
+	u8 i, j;
+
+	hclge_dbg_fill_content(content, sizeof(content), vlan_offload_items,
+			       NULL, ARRAY_SIZE(vlan_offload_items));
+	*pos += scnprintf(buf + *pos, len - *pos, "%s", content);
+
+	for (i = 0; i < func_num; i++) {
+		ret = hclge_get_vlan_tx_offload_cfg(hdev, i, &vlan_cfg);
+		if (ret)
+			return ret;
+
+		ret = hclge_get_vlan_rx_offload_cfg(hdev, i, &vlan_cfg);
+		if (ret)
+			return ret;
+
+		sprintf(str_pvid, "%u", vlan_cfg.pvid);
+		j = 0;
+		result[j++] = hclge_dbg_get_func_id_str(str_id, i);
+		result[j++] = str_pvid;
+		result[j++] = state_str[vlan_cfg.accept_tag1];
+		result[j++] = state_str[vlan_cfg.accept_tag2];
+		result[j++] = state_str[vlan_cfg.accept_untag1];
+		result[j++] = state_str[vlan_cfg.accept_untag2];
+		result[j++] = state_str[vlan_cfg.insert_tag1];
+		result[j++] = state_str[vlan_cfg.insert_tag2];
+		result[j++] = state_str[vlan_cfg.shift_tag];
+		result[j++] = state_str[vlan_cfg.strip_tag1];
+		result[j++] = state_str[vlan_cfg.strip_tag2];
+		result[j++] = state_str[vlan_cfg.drop_tag1];
+		result[j++] = state_str[vlan_cfg.drop_tag2];
+		result[j++] = state_str[vlan_cfg.pri_only1];
+		result[j++] = state_str[vlan_cfg.pri_only2];
+
+		hclge_dbg_fill_content(content, sizeof(content),
+				       vlan_offload_items, result,
+				       ARRAY_SIZE(vlan_offload_items));
+		*pos += scnprintf(buf + *pos, len - *pos, "%s", content);
+	}
+
+	return 0;
+}
+
+static int hclge_dbg_dump_vlan_config(struct hclge_dev *hdev, char *buf,
+				      int len)
+{
+	int pos = 0;
+	int ret;
+
+	ret = hclge_dbg_dump_vlan_filter_config(hdev, buf, len, &pos);
+	if (ret)
+		return ret;
+
+	return hclge_dbg_dump_vlan_offload_config(hdev, buf, len, &pos);
+}
+
 static int hclge_dbg_dump_mac_uc(struct hclge_dev *hdev, char *buf, int len)
 {
 	hclge_dbg_dump_mac_list(hdev, buf, len, true);
@@ -2037,6 +2316,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_SERV_INFO,
 		.dbg_dump = hclge_dbg_dump_serv_info,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_VLAN_CONFIG,
+		.dbg_dump = hclge_dbg_dump_vlan_config,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index 642752e..c526591 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -735,6 +735,8 @@ static const struct hclge_dbg_dfx_message hclge_dbg_tqp_reg[] = {
 };
 
 #define HCLGE_DBG_INFO_LEN			256
+#define HCLGE_DBG_VLAN_FLTR_INFO_LEN		256
+#define HCLGE_DBG_VLAN_OFFLOAD_INFO_LEN		512
 #define HCLGE_DBG_ID_LEN			16
 #define HCLGE_DBG_ITEM_NAME_LEN			32
 #define HCLGE_DBG_DATA_STR_LEN			32
@@ -747,4 +749,21 @@ struct hclge_dbg_item {
 	u16 interval; /* blank numbers after the item */
 };
 
+struct hclge_dbg_vlan_cfg {
+	u16 pvid;
+	u8 accept_tag1;
+	u8 accept_tag2;
+	u8 accept_untag1;
+	u8 accept_untag2;
+	u8 insert_tag1;
+	u8 insert_tag2;
+	u8 shift_tag;
+	u8 strip_tag1;
+	u8 strip_tag2;
+	u8 drop_tag1;
+	u8 drop_tag2;
+	u8 pri_only1;
+	u8 pri_only2;
+};
+
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 35aa4ac..6ecc106 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9444,18 +9444,6 @@ static int hclge_set_vlan_filter_ctrl(struct hclge_dev *hdev, u8 vlan_type,
 	return ret;
 }
 
-#define HCLGE_FILTER_TYPE_VF		0
-#define HCLGE_FILTER_TYPE_PORT		1
-#define HCLGE_FILTER_FE_EGRESS_V1_B	BIT(0)
-#define HCLGE_FILTER_FE_NIC_INGRESS_B	BIT(0)
-#define HCLGE_FILTER_FE_NIC_EGRESS_B	BIT(1)
-#define HCLGE_FILTER_FE_ROCE_INGRESS_B	BIT(2)
-#define HCLGE_FILTER_FE_ROCE_EGRESS_B	BIT(3)
-#define HCLGE_FILTER_FE_EGRESS		(HCLGE_FILTER_FE_NIC_EGRESS_B \
-					| HCLGE_FILTER_FE_ROCE_EGRESS_B)
-#define HCLGE_FILTER_FE_INGRESS		(HCLGE_FILTER_FE_NIC_INGRESS_B \
-					| HCLGE_FILTER_FE_ROCE_INGRESS_B)
-
 static int hclge_set_vport_vlan_filter(struct hclge_vport *vport, bool enable)
 {
 	struct hclge_dev *hdev = vport->back;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index bb778433..7595f84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -321,6 +321,18 @@ enum hclge_fc_mode {
 	HCLGE_FC_DEFAULT
 };
 
+#define HCLGE_FILTER_TYPE_VF		0
+#define HCLGE_FILTER_TYPE_PORT		1
+#define HCLGE_FILTER_FE_EGRESS_V1_B	BIT(0)
+#define HCLGE_FILTER_FE_NIC_INGRESS_B	BIT(0)
+#define HCLGE_FILTER_FE_NIC_EGRESS_B	BIT(1)
+#define HCLGE_FILTER_FE_ROCE_INGRESS_B	BIT(2)
+#define HCLGE_FILTER_FE_ROCE_EGRESS_B	BIT(3)
+#define HCLGE_FILTER_FE_EGRESS		(HCLGE_FILTER_FE_NIC_EGRESS_B \
+					| HCLGE_FILTER_FE_ROCE_EGRESS_B)
+#define HCLGE_FILTER_FE_INGRESS		(HCLGE_FILTER_FE_NIC_INGRESS_B \
+					| HCLGE_FILTER_FE_ROCE_INGRESS_B)
+
 enum hclge_vlan_fltr_cap {
 	HCLGE_VLAN_FLTR_DEF,
 	HCLGE_VLAN_FLTR_CAN_MDF,
-- 
2.7.4

