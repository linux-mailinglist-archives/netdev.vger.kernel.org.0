Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C60132A351
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382079AbhCBIz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:55:26 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13404 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835938AbhCBG2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 01:28:16 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DqRwL2jhmzjTLs;
        Tue,  2 Mar 2021 14:26:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 14:27:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 7/9] net: hns3: add support for user-def data of flow director
Date:   Tue, 2 Mar 2021 14:27:53 +0800
Message-ID: <1614666475-13059-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614666475-13059-1-git-send-email-tanhuazhong@huawei.com>
References: <1614666475-13059-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

For DEVICE_VERSION_V3, the hardware supports to match specified
data in the specified offset of packet payload. Each layer can
have one offset, and can't be masked when configure flow director
rule by ethtool command. The layer is choosed according to the
flow-type, ether for L2, ip4/ipv6 for L3, and tcp4/tcp6/udp4/udp6
for L4. For example, tcp4/tcp6/udp4/udp6 rules share the same
user-def offset, but each rule can have its own user-def value.

For the user-def field of ethtool -N/U command is 64 bits long.
The bit 0~15 is used for user-def value, and bit 32~47 for user-def
offset in HNS3 driver.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  14 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 301 ++++++++++++++++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  36 +++
 3 files changed, 337 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index ff52a65..03eca23 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -243,6 +243,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_FD_KEY_CONFIG		= 0x1202,
 	HCLGE_OPC_FD_TCAM_OP		= 0x1203,
 	HCLGE_OPC_FD_AD_OP		= 0x1204,
+	HCLGE_OPC_FD_USER_DEF_OP	= 0x1207,
 
 	/* MDIO command */
 	HCLGE_OPC_MDIO_CONFIG		= 0x1900,
@@ -1075,6 +1076,19 @@ struct hclge_fd_ad_config_cmd {
 	u8 rsv2[8];
 };
 
+#define HCLGE_FD_USER_DEF_OFT_S		0
+#define HCLGE_FD_USER_DEF_OFT_M		GENMASK(14, 0)
+#define HCLGE_FD_USER_DEF_EN_B		15
+struct hclge_fd_user_def_cfg_cmd {
+	__le16 ol2_cfg;
+	__le16 l2_cfg;
+	__le16 ol3_cfg;
+	__le16 l3_cfg;
+	__le16 ol4_cfg;
+	__le16 l4_cfg;
+	u8 rsv[12];
+};
+
 struct hclge_get_m7_bd_cmd {
 	__le32 bd_num;
 	u8 rsv[20];
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index bbeb541..15998fc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -414,7 +414,9 @@ static const struct key_info tuple_key_info[] = {
 	{ INNER_ETH_TYPE, 16, KEY_OPT_LE16,
 	  offsetof(struct hclge_fd_rule, tuples.ether_proto),
 	  offsetof(struct hclge_fd_rule, tuples_mask.ether_proto) },
-	{ INNER_L2_RSV, 16, KEY_OPT_LE16, -1, -1 },
+	{ INNER_L2_RSV, 16, KEY_OPT_LE16,
+	  offsetof(struct hclge_fd_rule, tuples.l2_user_def),
+	  offsetof(struct hclge_fd_rule, tuples_mask.l2_user_def) },
 	{ INNER_IP_TOS, 8, KEY_OPT_U8,
 	  offsetof(struct hclge_fd_rule, tuples.ip_tos),
 	  offsetof(struct hclge_fd_rule, tuples_mask.ip_tos) },
@@ -427,14 +429,18 @@ static const struct key_info tuple_key_info[] = {
 	{ INNER_DST_IP, 32, KEY_OPT_IP,
 	  offsetof(struct hclge_fd_rule, tuples.dst_ip),
 	  offsetof(struct hclge_fd_rule, tuples_mask.dst_ip) },
-	{ INNER_L3_RSV, 16, KEY_OPT_LE16, -1, -1 },
+	{ INNER_L3_RSV, 16, KEY_OPT_LE16,
+	  offsetof(struct hclge_fd_rule, tuples.l3_user_def),
+	  offsetof(struct hclge_fd_rule, tuples_mask.l3_user_def) },
 	{ INNER_SRC_PORT, 16, KEY_OPT_LE16,
 	  offsetof(struct hclge_fd_rule, tuples.src_port),
 	  offsetof(struct hclge_fd_rule, tuples_mask.src_port) },
 	{ INNER_DST_PORT, 16, KEY_OPT_LE16,
 	  offsetof(struct hclge_fd_rule, tuples.dst_port),
 	  offsetof(struct hclge_fd_rule, tuples_mask.dst_port) },
-	{ INNER_L4_RSV, 32, KEY_OPT_LE32, -1, -1 },
+	{ INNER_L4_RSV, 32, KEY_OPT_LE32,
+	  offsetof(struct hclge_fd_rule, tuples.l4_user_def),
+	  offsetof(struct hclge_fd_rule, tuples_mask.l4_user_def) },
 };
 
 static int hclge_mac_update_stats_defective(struct hclge_dev *hdev)
@@ -5110,15 +5116,75 @@ static void hclge_fd_insert_rule_node(struct hlist_head *hlist,
 		hlist_add_head(&rule->rule_node, hlist);
 }
 
+static int hclge_fd_inc_user_def_refcnt(struct hclge_dev *hdev,
+					struct hclge_fd_rule *rule)
+{
+	struct hclge_fd_user_def_info *info;
+	struct hclge_fd_user_def_cfg *cfg;
+
+	if (!rule || rule->rule_type != HCLGE_FD_EP_ACTIVE ||
+	    rule->ep.user_def.layer == HCLGE_FD_USER_DEF_NONE)
+		return 0;
+
+	/* for valid layer is start from 1, so need minus 1 to get the cfg */
+	cfg = &hdev->fd_cfg.user_def_cfg[rule->ep.user_def.layer - 1];
+	info = &rule->ep.user_def;
+
+	if (cfg->ref_cnt && cfg->offset != info->offset) {
+		dev_err(&hdev->pdev->dev,
+			"No available offset for layer%d fd rule, each layer only support one user def offset.\n",
+			info->layer + 1);
+		return -ENOSPC;
+	}
+
+	if (!cfg->ref_cnt) {
+		cfg->offset = info->offset;
+		set_bit(HCLGE_STATE_FD_USER_DEF_CHANGED, &hdev->state);
+	}
+	cfg->ref_cnt++;
+
+	return 0;
+}
+
+static void hclge_fd_dec_user_def_refcnt(struct hclge_dev *hdev,
+					 struct hclge_fd_rule *rule)
+{
+	struct hclge_fd_user_def_cfg *cfg;
+
+	if (!rule || rule->rule_type != HCLGE_FD_EP_ACTIVE ||
+	    rule->ep.user_def.layer == HCLGE_FD_USER_DEF_NONE)
+		return;
+
+	/* for valid layer is start from 1, so need minus 1 to get the cfg */
+	cfg = &hdev->fd_cfg.user_def_cfg[rule->ep.user_def.layer - 1];
+
+	if (!cfg->ref_cnt)
+		return;
+
+	cfg->ref_cnt--;
+	if (!cfg->ref_cnt) {
+		cfg->offset = 0;
+		set_bit(HCLGE_STATE_FD_USER_DEF_CHANGED, &hdev->state);
+	}
+}
+
 static int hclge_update_fd_list(struct hclge_dev *hdev,
 				enum HCLGE_FD_NODE_STATE state, u16 location,
 				struct hclge_fd_rule *new_rule)
 {
 	struct hlist_head *hlist = &hdev->fd_rule_list;
 	struct hclge_fd_rule *fd_rule, *parent = NULL;
+	int ret;
 
 	fd_rule = hclge_find_fd_rule(hlist, location, &parent);
 	if (fd_rule) {
+		hclge_fd_dec_user_def_refcnt(hdev, fd_rule);
+		if (state == HCLGE_FD_TO_ADD) {
+			ret = hclge_fd_inc_user_def_refcnt(hdev, new_rule);
+			if (ret)
+				return ret;
+		}
+
 		hclge_update_fd_rule_node(hdev, fd_rule, new_rule, state);
 		set_bit(HCLGE_STATE_FD_TBL_CHANGED, &hdev->state);
 		hclge_task_schedule(hdev, 0);
@@ -5133,6 +5199,10 @@ static int hclge_update_fd_list(struct hclge_dev *hdev,
 		return -ENOENT;
 	}
 
+	ret = hclge_fd_inc_user_def_refcnt(hdev, new_rule);
+	if (ret)
+		return ret;
+
 	hclge_fd_insert_rule_node(hlist, new_rule, parent);
 	if (!test_bit(location, hdev->fd_bmap)) {
 		set_bit(location, hdev->fd_bmap);
@@ -5288,6 +5358,53 @@ static int hclge_set_fd_key_config(struct hclge_dev *hdev,
 	return ret;
 }
 
+static int hclge_fd_set_user_def_cmd(struct hclge_dev *hdev,
+				     struct hclge_fd_user_def_cfg *cfg)
+{
+	struct hclge_fd_user_def_cfg_cmd *req;
+	struct hclge_desc desc;
+	u16 data = 0;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_FD_USER_DEF_OP, false);
+
+	req = (struct hclge_fd_user_def_cfg_cmd *)desc.data;
+
+	hnae3_set_bit(data, HCLGE_FD_USER_DEF_EN_B, cfg[0].ref_cnt > 0);
+	hnae3_set_field(data, HCLGE_FD_USER_DEF_OFT_M,
+			HCLGE_FD_USER_DEF_OFT_S, cfg[0].offset);
+	req->ol2_cfg = cpu_to_le16(data);
+
+	data = 0;
+	hnae3_set_bit(data, HCLGE_FD_USER_DEF_EN_B, cfg[1].ref_cnt > 0);
+	hnae3_set_field(data, HCLGE_FD_USER_DEF_OFT_M,
+			HCLGE_FD_USER_DEF_OFT_S, cfg[1].offset);
+	req->ol3_cfg = cpu_to_le16(data);
+
+	data = 0;
+	hnae3_set_bit(data, HCLGE_FD_USER_DEF_EN_B, cfg[2].ref_cnt > 0);
+	hnae3_set_field(data, HCLGE_FD_USER_DEF_OFT_M,
+			HCLGE_FD_USER_DEF_OFT_S, cfg[2].offset);
+	req->ol4_cfg = cpu_to_le16(data);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to set fd user def data, ret= %d\n", ret);
+	return ret;
+}
+
+static void hclge_fd_disable_user_def(struct hclge_dev *hdev)
+{
+	struct hclge_fd_user_def_cfg *cfg = hdev->fd_cfg.user_def_cfg;
+
+	spin_lock_bh(&hdev->fd_rule_lock);
+	memset(cfg, 0, sizeof(hdev->fd_cfg.user_def_cfg));
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
+	hclge_fd_set_user_def_cmd(hdev, cfg);
+}
+
 static int hclge_init_fd_config(struct hclge_dev *hdev)
 {
 #define LOW_2_WORDS		0x03
@@ -5328,9 +5445,12 @@ static int hclge_init_fd_config(struct hclge_dev *hdev)
 				BIT(INNER_SRC_PORT) | BIT(INNER_DST_PORT);
 
 	/* If use max 400bit key, we can support tuples for ether type */
-	if (hdev->fd_cfg.fd_mode == HCLGE_FD_MODE_DEPTH_2K_WIDTH_400B_STAGE_1)
+	if (hdev->fd_cfg.fd_mode == HCLGE_FD_MODE_DEPTH_2K_WIDTH_400B_STAGE_1) {
 		key_cfg->tuple_active |=
 				BIT(INNER_DST_MAC) | BIT(INNER_SRC_MAC);
+		if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
+			key_cfg->tuple_active |= HCLGE_FD_TUPLE_USER_DEF_TUPLES;
+	}
 
 	/* roce_type is used to filter roce frames
 	 * dst_vport is used to specify the rule
@@ -5824,9 +5944,98 @@ static int hclge_fd_check_ext_tuple(struct hclge_dev *hdev,
 	return 0;
 }
 
+static int hclge_fd_get_user_def_layer(u32 flow_type, u32 *unused_tuple,
+				       struct hclge_fd_user_def_info *info)
+{
+	switch (flow_type) {
+	case ETHER_FLOW:
+		info->layer = HCLGE_FD_USER_DEF_L2;
+		*unused_tuple &= ~BIT(INNER_L2_RSV);
+		break;
+	case IP_USER_FLOW:
+	case IPV6_USER_FLOW:
+		info->layer = HCLGE_FD_USER_DEF_L3;
+		*unused_tuple &= ~BIT(INNER_L3_RSV);
+		break;
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW:
+	case TCP_V6_FLOW:
+	case UDP_V6_FLOW:
+		info->layer = HCLGE_FD_USER_DEF_L4;
+		*unused_tuple &= ~BIT(INNER_L4_RSV);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static bool hclge_fd_is_user_def_all_masked(struct ethtool_rx_flow_spec *fs)
+{
+	return be32_to_cpu(fs->m_ext.data[1] | fs->m_ext.data[0]) == 0;
+}
+
+static int hclge_fd_parse_user_def_field(struct hclge_dev *hdev,
+					 struct ethtool_rx_flow_spec *fs,
+					 u32 *unused_tuple,
+					 struct hclge_fd_user_def_info *info)
+{
+	u32 tuple_active = hdev->fd_cfg.key_cfg[HCLGE_FD_STAGE_1].tuple_active;
+	u32 flow_type = fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT);
+	u16 data, offset, data_mask, offset_mask;
+	int ret;
+
+	info->layer = HCLGE_FD_USER_DEF_NONE;
+	*unused_tuple |= HCLGE_FD_TUPLE_USER_DEF_TUPLES;
+
+	if (!(fs->flow_type & FLOW_EXT) || hclge_fd_is_user_def_all_masked(fs))
+		return 0;
+
+	/* user-def data from ethtool is 64 bit value, the bit0~15 is used
+	 * for data, and bit32~47 is used for offset.
+	 */
+	data = be32_to_cpu(fs->h_ext.data[1]) & HCLGE_FD_USER_DEF_DATA;
+	data_mask = be32_to_cpu(fs->m_ext.data[1]) & HCLGE_FD_USER_DEF_DATA;
+	offset = be32_to_cpu(fs->h_ext.data[0]) & HCLGE_FD_USER_DEF_OFFSET;
+	offset_mask = be32_to_cpu(fs->m_ext.data[0]) & HCLGE_FD_USER_DEF_OFFSET;
+
+	if (!(tuple_active & HCLGE_FD_TUPLE_USER_DEF_TUPLES)) {
+		dev_err(&hdev->pdev->dev, "user-def bytes are not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (offset > HCLGE_FD_MAX_USER_DEF_OFFSET) {
+		dev_err(&hdev->pdev->dev,
+			"user-def offset[%u] should be no more than %u\n",
+			offset, HCLGE_FD_MAX_USER_DEF_OFFSET);
+		return -EINVAL;
+	}
+
+	if (offset_mask != HCLGE_FD_USER_DEF_OFFSET_UNMASK) {
+		dev_err(&hdev->pdev->dev, "user-def offset can't be masked\n");
+		return -EINVAL;
+	}
+
+	ret = hclge_fd_get_user_def_layer(flow_type, unused_tuple, info);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"unsupported flow type for user-def bytes, ret = %d\n",
+			ret);
+		return ret;
+	}
+
+	info->data = data;
+	info->data_mask = data_mask;
+	info->offset = offset;
+
+	return 0;
+}
+
 static int hclge_fd_check_spec(struct hclge_dev *hdev,
 			       struct ethtool_rx_flow_spec *fs,
-			       u32 *unused_tuple)
+			       u32 *unused_tuple,
+			       struct hclge_fd_user_def_info *info)
 {
 	u32 flow_type;
 	int ret;
@@ -5839,11 +6048,9 @@ static int hclge_fd_check_spec(struct hclge_dev *hdev,
 		return -EINVAL;
 	}
 
-	if ((fs->flow_type & FLOW_EXT) &&
-	    (fs->h_ext.data[0] != 0 || fs->h_ext.data[1] != 0)) {
-		dev_err(&hdev->pdev->dev, "user-def bytes are not supported\n");
-		return -EOPNOTSUPP;
-	}
+	ret = hclge_fd_parse_user_def_field(hdev, fs, unused_tuple, info);
+	if (ret)
+		return ret;
 
 	flow_type = fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT);
 	switch (flow_type) {
@@ -6017,9 +6224,33 @@ static void hclge_fd_get_ether_tuple(struct hclge_dev *hdev,
 	rule->tuples_mask.ether_proto = be16_to_cpu(fs->m_u.ether_spec.h_proto);
 }
 
+static void hclge_fd_get_user_def_tuple(struct hclge_fd_user_def_info *info,
+					struct hclge_fd_rule *rule)
+{
+	switch (info->layer) {
+	case HCLGE_FD_USER_DEF_L2:
+		rule->tuples.l2_user_def = info->data;
+		rule->tuples_mask.l2_user_def = info->data_mask;
+		break;
+	case HCLGE_FD_USER_DEF_L3:
+		rule->tuples.l3_user_def = info->data;
+		rule->tuples_mask.l3_user_def = info->data_mask;
+		break;
+	case HCLGE_FD_USER_DEF_L4:
+		rule->tuples.l4_user_def = (u32)info->data << 16;
+		rule->tuples_mask.l4_user_def = (u32)info->data_mask << 16;
+		break;
+	default:
+		break;
+	}
+
+	rule->ep.user_def = *info;
+}
+
 static int hclge_fd_get_tuple(struct hclge_dev *hdev,
 			      struct ethtool_rx_flow_spec *fs,
-			      struct hclge_fd_rule *rule)
+			      struct hclge_fd_rule *rule,
+			      struct hclge_fd_user_def_info *info)
 {
 	u32 flow_type = fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT);
 
@@ -6058,6 +6289,7 @@ static int hclge_fd_get_tuple(struct hclge_dev *hdev,
 	if (fs->flow_type & FLOW_EXT) {
 		rule->tuples.vlan_tag1 = be16_to_cpu(fs->h_ext.vlan_tci);
 		rule->tuples_mask.vlan_tag1 = be16_to_cpu(fs->m_ext.vlan_tci);
+		hclge_fd_get_user_def_tuple(info, rule);
 	}
 
 	if (fs->flow_type & FLOW_MAC_EXT) {
@@ -6156,6 +6388,7 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
+	struct hclge_fd_user_def_info info;
 	u16 dst_vport_id = 0, q_index = 0;
 	struct ethtool_rx_flow_spec *fs;
 	struct hclge_fd_rule *rule;
@@ -6177,7 +6410,7 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 
 	fs = (struct ethtool_rx_flow_spec *)&cmd->fs;
 
-	ret = hclge_fd_check_spec(hdev, fs, &unused);
+	ret = hclge_fd_check_spec(hdev, fs, &unused, &info);
 	if (ret)
 		return ret;
 
@@ -6190,7 +6423,7 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 	if (!rule)
 		return -ENOMEM;
 
-	ret = hclge_fd_get_tuple(hdev, fs, rule);
+	ret = hclge_fd_get_tuple(hdev, fs, rule, &info);
 	if (ret) {
 		kfree(rule);
 		return ret;
@@ -6274,6 +6507,7 @@ static void hclge_clear_fd_rules_in_list(struct hclge_dev *hdev,
 static void hclge_del_all_fd_entries(struct hclge_dev *hdev)
 {
 	hclge_clear_fd_rules_in_list(hdev, true);
+	hclge_fd_disable_user_def(hdev);
 }
 
 static int hclge_restore_fd_entries(struct hnae3_handle *handle)
@@ -6450,6 +6684,24 @@ static void hclge_fd_get_ether_info(struct hclge_fd_rule *rule,
 			0 : cpu_to_be16(rule->tuples_mask.ether_proto);
 }
 
+static void hclge_fd_get_user_def_info(struct ethtool_rx_flow_spec *fs,
+				       struct hclge_fd_rule *rule)
+{
+	if ((rule->unused_tuple & HCLGE_FD_TUPLE_USER_DEF_TUPLES) ==
+	    HCLGE_FD_TUPLE_USER_DEF_TUPLES) {
+		fs->h_ext.data[0] = 0;
+		fs->h_ext.data[1] = 0;
+		fs->m_ext.data[0] = 0;
+		fs->m_ext.data[1] = 0;
+	} else {
+		fs->h_ext.data[0] = cpu_to_be32(rule->ep.user_def.offset);
+		fs->h_ext.data[1] = cpu_to_be32(rule->ep.user_def.data);
+		fs->m_ext.data[0] =
+				cpu_to_be32(HCLGE_FD_USER_DEF_OFFSET_UNMASK);
+		fs->m_ext.data[1] = cpu_to_be32(rule->ep.user_def.data_mask);
+	}
+}
+
 static void hclge_fd_get_ext_info(struct ethtool_rx_flow_spec *fs,
 				  struct hclge_fd_rule *rule)
 {
@@ -6459,6 +6711,8 @@ static void hclge_fd_get_ext_info(struct ethtool_rx_flow_spec *fs,
 				rule->unused_tuple & BIT(INNER_VLAN_TAG_FST) ?
 				cpu_to_be16(VLAN_VID_MASK) :
 				cpu_to_be16(rule->tuples_mask.vlan_tag1);
+
+		hclge_fd_get_user_def_info(fs, rule);
 	}
 
 	if (fs->flow_type & FLOW_MAC_EXT) {
@@ -7059,6 +7313,23 @@ static void hclge_sync_fd_rule_num(struct hclge_dev *hdev)
 	hclge_sync_fd_state(hdev);
 }
 
+static void hclge_sync_fd_user_def_cfg(struct hclge_dev *hdev)
+{
+	struct hclge_fd_user_def_cfg cfg[HCLGE_FD_USER_DEF_LAYER_NUM];
+	int ret;
+
+	if (!test_and_clear_bit(HCLGE_STATE_FD_USER_DEF_CHANGED, &hdev->state))
+		return;
+
+	spin_lock_bh(&hdev->fd_rule_lock);
+	memcpy(cfg, hdev->fd_cfg.user_def_cfg, sizeof(cfg));
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
+	ret = hclge_fd_set_user_def_cmd(hdev, cfg);
+	if (ret)
+		set_bit(HCLGE_STATE_FD_USER_DEF_CHANGED, &hdev->state);
+}
+
 static void hclge_sync_fd_table(struct hclge_dev *hdev)
 {
 	struct hlist_head *hlist = &hdev->fd_rule_list;
@@ -7074,6 +7345,8 @@ static void hclge_sync_fd_table(struct hclge_dev *hdev)
 		hclge_clear_fd_rules_in_list(hdev, clear_list);
 	}
 
+	hclge_sync_fd_user_def_cfg(hdev);
+
 	if (!test_and_clear_bit(HCLGE_STATE_FD_TBL_CHANGED, &hdev->state))
 		return;
 
@@ -9650,7 +9923,7 @@ static void hclge_restore_hw_table(struct hclge_dev *hdev)
 	hclge_restore_mac_table_common(vport);
 	hclge_restore_vport_vlan_table(vport);
 	set_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
-
+	set_bit(HCLGE_STATE_FD_USER_DEF_CHANGED, &hdev->state);
 	hclge_restore_fd_entries(handle);
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 696bcc1..2d1f7f8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -225,6 +225,7 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_RST_FAIL,
 	HCLGE_STATE_FD_TBL_CHANGED,
 	HCLGE_STATE_FD_CLEAR_ALL,
+	HCLGE_STATE_FD_USER_DEF_CHANGED,
 	HCLGE_STATE_MAX
 };
 
@@ -538,6 +539,9 @@ enum HCLGE_FD_TUPLE {
 	MAX_TUPLE,
 };
 
+#define HCLGE_FD_TUPLE_USER_DEF_TUPLES \
+	(BIT(INNER_L2_RSV) | BIT(INNER_L3_RSV) | BIT(INNER_L4_RSV))
+
 enum HCLGE_FD_META_DATA {
 	PACKET_TYPE_ID,
 	IP_FRAGEMENT,
@@ -572,6 +576,11 @@ struct key_info {
 #define MAX_KEY_BYTES	(MAX_KEY_DWORDS * 4)
 #define MAX_META_DATA_LENGTH	32
 
+#define HCLGE_FD_MAX_USER_DEF_OFFSET	9000
+#define HCLGE_FD_USER_DEF_DATA		GENMASK(15, 0)
+#define HCLGE_FD_USER_DEF_OFFSET	GENMASK(15, 0)
+#define HCLGE_FD_USER_DEF_OFFSET_UNMASK	GENMASK(15, 0)
+
 /* assigned by firmware, the real filter number for each pf may be less */
 #define MAX_FD_FILTER_NUM	4096
 #define HCLGE_ARFS_EXPIRE_INTERVAL	5UL
@@ -601,6 +610,26 @@ enum HCLGE_FD_NODE_STATE {
 	HCLGE_FD_ADDING
 };
 
+enum HCLGE_FD_USER_DEF_LAYER {
+	HCLGE_FD_USER_DEF_NONE,
+	HCLGE_FD_USER_DEF_L2,
+	HCLGE_FD_USER_DEF_L3,
+	HCLGE_FD_USER_DEF_L4,
+};
+
+#define HCLGE_FD_USER_DEF_LAYER_NUM 3
+struct hclge_fd_user_def_cfg {
+	u16 ref_cnt;
+	u16 offset;
+};
+
+struct hclge_fd_user_def_info {
+	enum HCLGE_FD_USER_DEF_LAYER layer;
+	u16 data;
+	u16 data_mask;
+	u16 offset;
+};
+
 struct hclge_fd_key_cfg {
 	u8 key_sel;
 	u8 inner_sipv6_word_en;
@@ -617,6 +646,7 @@ struct hclge_fd_cfg {
 	u32 rule_num[MAX_STAGE_NUM]; /* rule entry number */
 	u16 cnt_num[MAX_STAGE_NUM]; /* rule hit counter number */
 	struct hclge_fd_key_cfg key_cfg[MAX_STAGE_NUM];
+	struct hclge_fd_user_def_cfg user_def_cfg[HCLGE_FD_USER_DEF_LAYER_NUM];
 };
 
 #define IPV4_INDEX	3
@@ -633,6 +663,9 @@ struct hclge_fd_rule_tuples {
 	u16 dst_port;
 	u16 vlan_tag1;
 	u16 ether_proto;
+	u16 l2_user_def;
+	u16 l3_user_def;
+	u32 l4_user_def;
 	u8 ip_tos;
 	u8 ip_proto;
 };
@@ -651,6 +684,9 @@ struct hclge_fd_rule {
 		struct {
 			u16 flow_id; /* only used for arfs */
 		} arfs;
+		struct {
+			struct hclge_fd_user_def_info user_def;
+		} ep;
 	};
 	u16 queue_id;
 	u16 vf_id;
-- 
2.7.4

