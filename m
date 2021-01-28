Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F86C30753B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhA1Lw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:52:57 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11528 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhA1Lwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:52:51 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DRJhG3H0czjFYB;
        Thu, 28 Jan 2021 19:50:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 28 Jan 2021 19:52:01 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 1/2] net: hns3: add interfaces to query information of tm priority/qset
Date:   Thu, 28 Jan 2021 19:51:35 +0800
Message-ID: <1611834696-56207-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611834696-56207-1-git-send-email-tanhuazhong@huawei.com>
References: <1611834696-56207-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

Add some interfaces to get information of tm priority and qset,
then they can be used by debugfs.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 186 +++++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  48 +++++-
 3 files changed, 234 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index edfadb5..f861bdb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -160,6 +160,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_TM_PRI_SCH_MODE_CFG   = 0x0813,
 	HCLGE_OPC_TM_QS_SCH_MODE_CFG    = 0x0814,
 	HCLGE_OPC_TM_BP_TO_QSET_MAPPING = 0x0815,
+	HCLGE_OPC_TM_NODES		= 0x0816,
 	HCLGE_OPC_ETS_TC_WEIGHT		= 0x0843,
 	HCLGE_OPC_QSET_DFX_STS		= 0x0844,
 	HCLGE_OPC_PRI_DFX_STS		= 0x0845,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 82742a6..216ab1e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1616,3 +1616,189 @@ int hclge_tm_vport_map_update(struct hclge_dev *hdev)
 
 	return hclge_tm_bp_setup(hdev);
 }
+
+int hclge_tm_get_qset_num(struct hclge_dev *hdev, u16 *qset_num)
+{
+	struct hclge_tm_nodes_cmd *nodes;
+	struct hclge_desc desc;
+	int ret;
+
+	if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2) {
+		/* Each PF has 8 qsets and each VF has 1 qset */
+		*qset_num = HCLGE_TM_PF_MAX_QSET_NUM + pci_num_vf(hdev->pdev);
+		return 0;
+	}
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_NODES, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get qset num, ret = %d\n", ret);
+		return ret;
+	}
+
+	nodes = (struct hclge_tm_nodes_cmd *)desc.data;
+	*qset_num = le16_to_cpu(nodes->qset_num);
+	return 0;
+}
+
+int hclge_tm_get_pri_num(struct hclge_dev *hdev, u8 *pri_num)
+{
+	struct hclge_tm_nodes_cmd *nodes;
+	struct hclge_desc desc;
+	int ret;
+
+	if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2) {
+		*pri_num = HCLGE_TM_PF_MAX_PRI_NUM;
+		return 0;
+	}
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_NODES, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get pri num, ret = %d\n", ret);
+		return ret;
+	}
+
+	nodes = (struct hclge_tm_nodes_cmd *)desc.data;
+	*pri_num = nodes->pri_num;
+	return 0;
+}
+
+int hclge_tm_get_qset_map_pri(struct hclge_dev *hdev, u16 qset_id, u8 *priority,
+			      u8 *link_vld)
+{
+	struct hclge_qs_to_pri_link_cmd *map;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_QS_TO_PRI_LINK, true);
+	map = (struct hclge_qs_to_pri_link_cmd *)desc.data;
+	map->qs_id = cpu_to_le16(qset_id);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get qset map priority, ret = %d\n", ret);
+		return ret;
+	}
+
+	*priority = map->priority;
+	*link_vld = map->link_vld;
+	return 0;
+}
+
+int hclge_tm_get_qset_sch_mode(struct hclge_dev *hdev, u16 qset_id, u8 *mode)
+{
+	struct hclge_qs_sch_mode_cfg_cmd *qs_sch_mode;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_QS_SCH_MODE_CFG, true);
+	qs_sch_mode = (struct hclge_qs_sch_mode_cfg_cmd *)desc.data;
+	qs_sch_mode->qs_id = cpu_to_le16(qset_id);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get qset sch mode, ret = %d\n", ret);
+		return ret;
+	}
+
+	*mode = qs_sch_mode->sch_mode;
+	return 0;
+}
+
+int hclge_tm_get_qset_weight(struct hclge_dev *hdev, u16 qset_id, u8 *weight)
+{
+	struct hclge_qs_weight_cmd *qs_weight;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_QS_WEIGHT, true);
+	qs_weight = (struct hclge_qs_weight_cmd *)desc.data;
+	qs_weight->qs_id = cpu_to_le16(qset_id);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get qset weight, ret = %d\n", ret);
+		return ret;
+	}
+
+	*weight = qs_weight->dwrr;
+	return 0;
+}
+
+int hclge_tm_get_pri_sch_mode(struct hclge_dev *hdev, u8 pri_id, u8 *mode)
+{
+	struct hclge_pri_sch_mode_cfg_cmd *pri_sch_mode;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_PRI_SCH_MODE_CFG, true);
+	pri_sch_mode = (struct hclge_pri_sch_mode_cfg_cmd *)desc.data;
+	pri_sch_mode->pri_id = pri_id;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get priority sch mode, ret = %d\n", ret);
+		return ret;
+	}
+
+	*mode = pri_sch_mode->sch_mode;
+	return 0;
+}
+
+int hclge_tm_get_pri_weight(struct hclge_dev *hdev, u8 pri_id, u8 *weight)
+{
+	struct hclge_priority_weight_cmd *priority_weight;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_PRI_WEIGHT, true);
+	priority_weight = (struct hclge_priority_weight_cmd *)desc.data;
+	priority_weight->pri_id = pri_id;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get priority weight, ret = %d\n", ret);
+		return ret;
+	}
+
+	*weight = priority_weight->dwrr;
+	return 0;
+}
+
+int hclge_tm_get_pri_shaper(struct hclge_dev *hdev, u8 pri_id,
+			    enum hclge_opcode_type cmd,
+			    struct hclge_pri_shaper_para *para)
+{
+	struct hclge_pri_shapping_cmd *shap_cfg_cmd;
+	struct hclge_desc desc;
+	u32 shapping_para;
+	int ret;
+
+	if (cmd != HCLGE_OPC_TM_PRI_C_SHAPPING &&
+	    cmd != HCLGE_OPC_TM_PRI_P_SHAPPING)
+		return -EINVAL;
+
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	shap_cfg_cmd = (struct hclge_pri_shapping_cmd *)desc.data;
+	shap_cfg_cmd->pri_id = pri_id;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get priority shaper(%#x), ret = %d\n",
+			cmd, ret);
+		return ret;
+	}
+
+	shapping_para = le32_to_cpu(shap_cfg_cmd->pri_shapping_para);
+	para->ir_b = hclge_tm_get_field(shapping_para, IR_B);
+	para->ir_u = hclge_tm_get_field(shapping_para, IR_U);
+	para->ir_s = hclge_tm_get_field(shapping_para, IR_S);
+	para->bs_b = hclge_tm_get_field(shapping_para, BS_B);
+	para->bs_s = hclge_tm_get_field(shapping_para, BS_S);
+	para->flag = shap_cfg_cmd->flag;
+	para->rate = le32_to_cpu(shap_cfg_cmd->pri_rate);
+	return 0;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 5498d73..d33cb04 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -21,6 +21,9 @@
 
 #define HCLGE_ETHER_MAX_RATE	100000
 
+#define HCLGE_TM_PF_MAX_PRI_NUM		8
+#define HCLGE_TM_PF_MAX_QSET_NUM	8
+
 struct hclge_pg_to_pri_link_cmd {
 	u8 pg_id;
 	u8 rsvd1[3];
@@ -65,6 +68,18 @@ struct hclge_priority_weight_cmd {
 	u8 dwrr;
 };
 
+struct hclge_pri_sch_mode_cfg_cmd {
+	u8 pri_id;
+	u8 rsvd[3];
+	u8 sch_mode;
+};
+
+struct hclge_qs_sch_mode_cfg_cmd {
+	__le16 qs_id;
+	u8 rsvd[2];
+	u8 sch_mode;
+};
+
 struct hclge_qs_weight_cmd {
 	__le16 qs_id;
 	u8 dwrr;
@@ -173,6 +188,27 @@ struct hclge_shaper_ir_para {
 	u8 ir_s; /* IR_S parameter of IR shaper */
 };
 
+struct hclge_tm_nodes_cmd {
+	u8 pg_base_id;
+	u8 pri_base_id;
+	__le16 qset_base_id;
+	__le16 queue_base_id;
+	u8 pg_num;
+	u8 pri_num;
+	__le16 qset_num;
+	__le16 queue_num;
+};
+
+struct hclge_pri_shaper_para {
+	u8 ir_b;
+	u8 ir_u;
+	u8 ir_s;
+	u8 bs_b;
+	u8 bs_s;
+	u8 flag;
+	u32 rate;
+};
+
 #define hclge_tm_set_field(dest, string, val) \
 			   hnae3_set_field((dest), \
 			   (HCLGE_TM_SHAP_##string##_MSK), \
@@ -195,5 +231,15 @@ int hclge_pause_addr_cfg(struct hclge_dev *hdev, const u8 *mac_addr);
 int hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats);
 int hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats);
 int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate);
-
+int hclge_tm_get_qset_num(struct hclge_dev *hdev, u16 *qset_num);
+int hclge_tm_get_pri_num(struct hclge_dev *hdev, u8 *pri_num);
+int hclge_tm_get_qset_map_pri(struct hclge_dev *hdev, u16 qset_id, u8 *priority,
+			      u8 *link_vld);
+int hclge_tm_get_qset_sch_mode(struct hclge_dev *hdev, u16 qset_id, u8 *mode);
+int hclge_tm_get_qset_weight(struct hclge_dev *hdev, u16 qset_id, u8 *weight);
+int hclge_tm_get_pri_sch_mode(struct hclge_dev *hdev, u8 pri_id, u8 *mode);
+int hclge_tm_get_pri_weight(struct hclge_dev *hdev, u8 pri_id, u8 *weight);
+int hclge_tm_get_pri_shaper(struct hclge_dev *hdev, u8 pri_id,
+			    enum hclge_opcode_type cmd,
+			    struct hclge_pri_shaper_para *para);
 #endif
-- 
2.7.4

