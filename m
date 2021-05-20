Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B8D389B51
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhETCXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4542 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhETCXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:17 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Flths0gFZzkXFM;
        Thu, 20 May 2021 10:19:09 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:55 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:55 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/15] net: hns3: refactor dump tm of debugfs
Date:   Thu, 20 May 2021 10:21:36 +0800
Message-ID: <1621477304-4495-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621477304-4495-1-git-send-email-tanhuazhong@huawei.com>
References: <1621477304-4495-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

Currently, user gets some tm info by implementing debugfs command
"echo dump tm > cmd", this command will dump info in dmesg. It's
unnecessary and heavy.

In addition, the info of this command mixes info of qset, priority,
pg and port. Qset and priority have their own command to get info of
themself, so can remove info of qset and priority from this command.

To optimize it, create two new files "tm_pg", "tm_port" in tm directory
and use cat command to separately get info of pg and port.

The display style is below:
$ cat tm_pg
ID  PRI_MAP  MODE DWRR  C_IR_B  C_IR_U  C_IR_S  C_BS_B  C_BS_S ...
00   0x1f    dwrr  1       75       9       0      31      20  ...

$ cat tm_port
IR_B  IR_U  IR_S  BS_B  BS_S  FLAG  RATE(Mbps)
75     9     0    31    20    1     200000

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  15 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 304 +++++++--------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 125 ++++++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  15 +-
 6 files changed, 257 insertions(+), 206 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 5de8b11..e783d167 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -255,6 +255,8 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_TM_PRI,
 	HNAE3_DBG_CMD_TM_QSET,
 	HNAE3_DBG_CMD_TM_MAP,
+	HNAE3_DBG_CMD_TM_PG,
+	HNAE3_DBG_CMD_TM_PORT,
 	HNAE3_DBG_CMD_DEV_INFO,
 	HNAE3_DBG_CMD_TX_BD,
 	HNAE3_DBG_CMD_RX_BD,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 39a24cc..4061f1f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -72,6 +72,20 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.init = hns3_dbg_common_file_init,
 	},
 	{
+		.name = "tm_pg",
+		.cmd = HNAE3_DBG_CMD_TM_PG,
+		.dentry = HNS3_DBG_DENTRY_TM,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "tm_port",
+		.cmd = HNAE3_DBG_CMD_TM_PORT,
+		.dentry = HNS3_DBG_DENTRY_TM,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
 		.name = "dev_info",
 		.cmd = HNAE3_DBG_CMD_DEV_INFO,
 		.dentry = HNS3_DBG_DENTRY_COMMON,
@@ -725,7 +739,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 		return;
 
 	dev_info(&h->pdev->dev, "dump tc\n");
-	dev_info(&h->pdev->dev, "dump tm\n");
 	dev_info(&h->pdev->dev, "dump qos pause cfg\n");
 	dev_info(&h->pdev->dev, "dump qos pri map\n");
 	dev_info(&h->pdev->dev, "dump qos buf cfg\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 58ee389..506f0ab 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -685,224 +685,120 @@ static void hclge_dbg_dump_tc(struct hclge_dev *hdev)
 		hclge_print_tc_info(hdev, ets_weight->tc_weight[i], i);
 }
 
-static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
-{
-	struct hclge_port_shapping_cmd *port_shap_cfg_cmd;
-	struct hclge_bp_to_qs_map_cmd *bp_to_qs_map_cmd;
-	struct hclge_pg_shapping_cmd *pg_shap_cfg_cmd;
-	enum hclge_opcode_type cmd;
-	struct hclge_desc desc;
-	int ret;
+static const struct hclge_dbg_item tm_pg_items[] = {
+	{ "ID", 2 },
+	{ "PRI_MAP", 2 },
+	{ "MODE", 2 },
+	{ "DWRR", 2 },
+	{ "C_IR_B", 2 },
+	{ "C_IR_U", 2 },
+	{ "C_IR_S", 2 },
+	{ "C_BS_B", 2 },
+	{ "C_BS_S", 2 },
+	{ "C_FLAG", 2 },
+	{ "C_RATE(Mbps)", 2 },
+	{ "P_IR_B", 2 },
+	{ "P_IR_U", 2 },
+	{ "P_IR_S", 2 },
+	{ "P_BS_B", 2 },
+	{ "P_BS_S", 2 },
+	{ "P_FLAG", 2 },
+	{ "P_RATE(Mbps)", 0 }
+};
 
-	cmd = HCLGE_OPC_TM_PG_C_SHAPPING;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_pg_cmd_send;
+static void hclge_dbg_fill_shaper_content(struct hclge_tm_shaper_para *para,
+					  char **result, u8 *index)
+{
+	sprintf(result[(*index)++], "%3u", para->ir_b);
+	sprintf(result[(*index)++], "%3u", para->ir_u);
+	sprintf(result[(*index)++], "%3u", para->ir_s);
+	sprintf(result[(*index)++], "%3u", para->bs_b);
+	sprintf(result[(*index)++], "%3u", para->bs_s);
+	sprintf(result[(*index)++], "%3u", para->flag);
+	sprintf(result[(*index)++], "%6u", para->rate);
+}
 
-	pg_shap_cfg_cmd = (struct hclge_pg_shapping_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "PG_C pg_id: %u\n", pg_shap_cfg_cmd->pg_id);
-	dev_info(&hdev->pdev->dev, "PG_C pg_shapping: 0x%x\n",
-		 le32_to_cpu(pg_shap_cfg_cmd->pg_shapping_para));
+static int hclge_dbg_dump_tm_pg(struct hclge_dev *hdev, char *buf, int len)
+{
+	char data_str[ARRAY_SIZE(tm_pg_items)][HCLGE_DBG_DATA_STR_LEN];
+	struct hclge_tm_shaper_para c_shaper_para, p_shaper_para;
+	char *result[ARRAY_SIZE(tm_pg_items)], *sch_mode_str;
+	u8 pg_id, sch_mode, weight, pri_bit_map, i, j;
+	char content[HCLGE_DBG_TM_INFO_LEN];
+	int pos = 0;
+	int ret;
 
-	cmd = HCLGE_OPC_TM_PG_P_SHAPPING;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_pg_cmd_send;
-
-	pg_shap_cfg_cmd = (struct hclge_pg_shapping_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "PG_P pg_id: %u\n", pg_shap_cfg_cmd->pg_id);
-	dev_info(&hdev->pdev->dev, "PG_P pg_shapping: 0x%x\n",
-		 le32_to_cpu(pg_shap_cfg_cmd->pg_shapping_para));
-	dev_info(&hdev->pdev->dev, "PG_P flag: %#x\n", pg_shap_cfg_cmd->flag);
-	dev_info(&hdev->pdev->dev, "PG_P pg_rate: %u(Mbps)\n",
-		 le32_to_cpu(pg_shap_cfg_cmd->pg_rate));
-
-	cmd = HCLGE_OPC_TM_PORT_SHAPPING;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_pg_cmd_send;
+	for (i = 0; i < ARRAY_SIZE(tm_pg_items); i++)
+		result[i] = &data_str[i][0];
 
-	port_shap_cfg_cmd = (struct hclge_port_shapping_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "PORT port_shapping: 0x%x\n",
-		 le32_to_cpu(port_shap_cfg_cmd->port_shapping_para));
-	dev_info(&hdev->pdev->dev, "PORT flag: %#x\n", port_shap_cfg_cmd->flag);
-	dev_info(&hdev->pdev->dev, "PORT port_rate: %u(Mbps)\n",
-		 le32_to_cpu(port_shap_cfg_cmd->port_rate));
+	hclge_dbg_fill_content(content, sizeof(content), tm_pg_items,
+			       NULL, ARRAY_SIZE(tm_pg_items));
+	pos += scnprintf(buf + pos, len - pos, "%s", content);
 
-	cmd = HCLGE_OPC_TM_PG_SCH_MODE_CFG;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_pg_cmd_send;
+	for (pg_id = 0; pg_id < hdev->tm_info.num_pg; pg_id++) {
+		ret = hclge_tm_get_pg_to_pri_map(hdev, pg_id, &pri_bit_map);
+		if (ret)
+			return ret;
 
-	dev_info(&hdev->pdev->dev, "PG_SCH pg_id: %u\n",
-		 le32_to_cpu(desc.data[0]));
+		ret = hclge_tm_get_pg_sch_mode(hdev, pg_id, &sch_mode);
+		if (ret)
+			return ret;
 
-	cmd = HCLGE_OPC_TM_PRI_SCH_MODE_CFG;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_pg_cmd_send;
+		ret = hclge_tm_get_pg_weight(hdev, pg_id, &weight);
+		if (ret)
+			return ret;
 
-	dev_info(&hdev->pdev->dev, "PRI_SCH pri_id: %u\n",
-		 le32_to_cpu(desc.data[0]));
+		ret = hclge_tm_get_pg_shaper(hdev, pg_id,
+					     HCLGE_OPC_TM_PG_C_SHAPPING,
+					     &c_shaper_para);
+		if (ret)
+			return ret;
 
-	cmd = HCLGE_OPC_TM_QS_SCH_MODE_CFG;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_pg_cmd_send;
+		ret = hclge_tm_get_pg_shaper(hdev, pg_id,
+					     HCLGE_OPC_TM_PG_P_SHAPPING,
+					     &p_shaper_para);
+		if (ret)
+			return ret;
 
-	dev_info(&hdev->pdev->dev, "QS_SCH qs_id: %u\n",
-		 le32_to_cpu(desc.data[0]));
+		sch_mode_str = sch_mode & HCLGE_TM_TX_SCHD_DWRR_MSK ? "dwrr" :
+				       "sp";
 
-	if (!hnae3_dev_dcb_supported(hdev)) {
-		dev_info(&hdev->pdev->dev,
-			 "Only DCB-supported dev supports tm mapping\n");
-		return;
+		j = 0;
+		sprintf(result[j++], "%02u", pg_id);
+		sprintf(result[j++], "0x%02x", pri_bit_map);
+		sprintf(result[j++], "%4s", sch_mode_str);
+		sprintf(result[j++], "%3u", weight);
+		hclge_dbg_fill_shaper_content(&c_shaper_para, result, &j);
+		hclge_dbg_fill_shaper_content(&p_shaper_para, result, &j);
+
+		hclge_dbg_fill_content(content, sizeof(content), tm_pg_items,
+				       (const char **)result,
+				       ARRAY_SIZE(tm_pg_items));
+		pos += scnprintf(buf + pos, len - pos, "%s", content);
 	}
 
-	cmd = HCLGE_OPC_TM_BP_TO_QSET_MAPPING;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_pg_cmd_send;
-
-	bp_to_qs_map_cmd = (struct hclge_bp_to_qs_map_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "BP_TO_QSET tc_id: %u\n",
-		 bp_to_qs_map_cmd->tc_id);
-	dev_info(&hdev->pdev->dev, "BP_TO_QSET qs_group_id: 0x%x\n",
-		 bp_to_qs_map_cmd->qs_group_id);
-	dev_info(&hdev->pdev->dev, "BP_TO_QSET qs_bit_map: 0x%x\n",
-		 le32_to_cpu(bp_to_qs_map_cmd->qs_bit_map));
-	return;
-
-err_tm_pg_cmd_send:
-	dev_err(&hdev->pdev->dev, "dump tm_pg fail(0x%x), ret = %d\n",
-		cmd, ret);
+	return 0;
 }
 
-static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
+static int hclge_dbg_dump_tm_port(struct hclge_dev *hdev,  char *buf, int len)
 {
-	struct hclge_priority_weight_cmd *priority_weight;
-	struct hclge_pg_to_pri_link_cmd *pg_to_pri_map;
-	struct hclge_qs_to_pri_link_cmd *qs_to_pri_map;
-	struct hclge_nq_to_qs_link_cmd *nq_to_qs_map;
-	struct hclge_pri_shapping_cmd *shap_cfg_cmd;
-	struct hclge_pg_weight_cmd *pg_weight;
-	struct hclge_qs_weight_cmd *qs_weight;
-	enum hclge_opcode_type cmd;
-	struct hclge_desc desc;
+	struct hclge_tm_shaper_para shaper_para;
+	int pos = 0;
 	int ret;
 
-	cmd = HCLGE_OPC_TM_PG_TO_PRI_LINK;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_cmd_send;
-
-	pg_to_pri_map = (struct hclge_pg_to_pri_link_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "dump tm\n");
-	dev_info(&hdev->pdev->dev, "PG_TO_PRI gp_id: %u\n",
-		 pg_to_pri_map->pg_id);
-	dev_info(&hdev->pdev->dev, "PG_TO_PRI map: 0x%x\n",
-		 pg_to_pri_map->pri_bit_map);
-
-	cmd = HCLGE_OPC_TM_QS_TO_PRI_LINK;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_cmd_send;
-
-	qs_to_pri_map = (struct hclge_qs_to_pri_link_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "QS_TO_PRI qs_id: %u\n",
-		 le16_to_cpu(qs_to_pri_map->qs_id));
-	dev_info(&hdev->pdev->dev, "QS_TO_PRI priority: %u\n",
-		 qs_to_pri_map->priority);
-	dev_info(&hdev->pdev->dev, "QS_TO_PRI link_vld: %u\n",
-		 qs_to_pri_map->link_vld);
-
-	cmd = HCLGE_OPC_TM_NQ_TO_QS_LINK;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_cmd_send;
-
-	nq_to_qs_map = (struct hclge_nq_to_qs_link_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "NQ_TO_QS nq_id: %u\n",
-		 le16_to_cpu(nq_to_qs_map->nq_id));
-	dev_info(&hdev->pdev->dev, "NQ_TO_QS qset_id: 0x%x\n",
-		 le16_to_cpu(nq_to_qs_map->qset_id));
-
-	cmd = HCLGE_OPC_TM_PG_WEIGHT;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_cmd_send;
-
-	pg_weight = (struct hclge_pg_weight_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "PG pg_id: %u\n", pg_weight->pg_id);
-	dev_info(&hdev->pdev->dev, "PG dwrr: %u\n", pg_weight->dwrr);
-
-	cmd = HCLGE_OPC_TM_QS_WEIGHT;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_cmd_send;
-
-	qs_weight = (struct hclge_qs_weight_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "QS qs_id: %u\n",
-		 le16_to_cpu(qs_weight->qs_id));
-	dev_info(&hdev->pdev->dev, "QS dwrr: %u\n", qs_weight->dwrr);
-
-	cmd = HCLGE_OPC_TM_PRI_WEIGHT;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	ret = hclge_tm_get_port_shaper(hdev, &shaper_para);
 	if (ret)
-		goto err_tm_cmd_send;
-
-	priority_weight = (struct hclge_priority_weight_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "PRI pri_id: %u\n", priority_weight->pri_id);
-	dev_info(&hdev->pdev->dev, "PRI dwrr: %u\n", priority_weight->dwrr);
-
-	cmd = HCLGE_OPC_TM_PRI_C_SHAPPING;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_cmd_send;
-
-	shap_cfg_cmd = (struct hclge_pri_shapping_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "PRI_C pri_id: %u\n", shap_cfg_cmd->pri_id);
-	dev_info(&hdev->pdev->dev, "PRI_C pri_shapping: 0x%x\n",
-		 le32_to_cpu(shap_cfg_cmd->pri_shapping_para));
-	dev_info(&hdev->pdev->dev, "PRI_C flag: %#x\n", shap_cfg_cmd->flag);
-	dev_info(&hdev->pdev->dev, "PRI_C pri_rate: %u(Mbps)\n",
-		 le32_to_cpu(shap_cfg_cmd->pri_rate));
-
-	cmd = HCLGE_OPC_TM_PRI_P_SHAPPING;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_cmd_send;
-
-	shap_cfg_cmd = (struct hclge_pri_shapping_cmd *)desc.data;
-	dev_info(&hdev->pdev->dev, "PRI_P pri_id: %u\n", shap_cfg_cmd->pri_id);
-	dev_info(&hdev->pdev->dev, "PRI_P pri_shapping: 0x%x\n",
-		 le32_to_cpu(shap_cfg_cmd->pri_shapping_para));
-	dev_info(&hdev->pdev->dev, "PRI_P flag: %#x\n", shap_cfg_cmd->flag);
-	dev_info(&hdev->pdev->dev, "PRI_P pri_rate: %u(Mbps)\n",
-		 le32_to_cpu(shap_cfg_cmd->pri_rate));
-
-	hclge_dbg_dump_tm_pg(hdev);
+		return ret;
 
-	return;
+	pos += scnprintf(buf + pos, len - pos,
+			 "IR_B  IR_U  IR_S  BS_B  BS_S  FLAG  RATE(Mbps)\n");
+	pos += scnprintf(buf + pos, len - pos,
+			 "%3u   %3u   %3u   %3u   %3u     %1u   %6u\n",
+			 shaper_para.ir_b, shaper_para.ir_u, shaper_para.ir_s,
+			 shaper_para.bs_b, shaper_para.bs_s, shaper_para.flag,
+			 shaper_para.rate);
 
-err_tm_cmd_send:
-	dev_err(&hdev->pdev->dev, "dump tm fail(0x%x), ret = %d\n",
-		cmd, ret);
+	return 0;
 }
 
 static int hclge_dbg_dump_tm_bp_qset_map(struct hclge_dev *hdev, u8 tc_id,
@@ -1031,8 +927,8 @@ static int hclge_dbg_dump_tm_nodes(struct hclge_dev *hdev, char *buf, int len)
 
 static int hclge_dbg_dump_tm_pri(struct hclge_dev *hdev, char *buf, int len)
 {
-	struct hclge_pri_shaper_para c_shaper_para;
-	struct hclge_pri_shaper_para p_shaper_para;
+	struct hclge_tm_shaper_para c_shaper_para;
+	struct hclge_tm_shaper_para p_shaper_para;
 	u8 pri_num, sch_mode, weight;
 	char *sch_mode_str;
 	int pos = 0;
@@ -1999,8 +1895,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 
 	if (strncmp(cmd_buf, "dump tc", 7) == 0) {
 		hclge_dbg_dump_tc(hdev);
-	} else if (strncmp(cmd_buf, "dump tm", 7) == 0) {
-		hclge_dbg_dump_tm(hdev);
 	} else if (strncmp(cmd_buf, "dump qos pause cfg", 18) == 0) {
 		hclge_dbg_dump_qos_pause_cfg(hdev);
 	} else if (strncmp(cmd_buf, "dump qos pri map", 16) == 0) {
@@ -2040,6 +1934,14 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.dbg_dump = hclge_dbg_dump_tm_map,
 	},
 	{
+		.cmd = HNAE3_DBG_CMD_TM_PG,
+		.dbg_dump = hclge_dbg_dump_tm_pg,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_TM_PORT,
+		.dbg_dump = hclge_dbg_dump_tm_port,
+	},
+	{
 		.cmd = HNAE3_DBG_CMD_MAC_UC,
 		.dbg_dump = hclge_dbg_dump_mac_uc,
 	},
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index 25b42da..c4956e3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -738,6 +738,8 @@ static const struct hclge_dbg_dfx_message hclge_dbg_tqp_reg[] = {
 #define HCLGE_DBG_ID_LEN			16
 #define HCLGE_DBG_ITEM_NAME_LEN			32
 #define HCLGE_DBG_DATA_STR_LEN			32
+#define HCLGE_DBG_TM_INFO_LEN			256
+
 struct hclge_dbg_item {
 	char name[HCLGE_DBG_ITEM_NAME_LEN];
 	u16 interval; /* blank numbers after the item */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index bd99faf..45870fe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1775,7 +1775,7 @@ int hclge_tm_get_pri_weight(struct hclge_dev *hdev, u8 pri_id, u8 *weight)
 
 int hclge_tm_get_pri_shaper(struct hclge_dev *hdev, u8 pri_id,
 			    enum hclge_opcode_type cmd,
-			    struct hclge_pri_shaper_para *para)
+			    struct hclge_tm_shaper_para *para)
 {
 	struct hclge_pri_shapping_cmd *shap_cfg_cmd;
 	struct hclge_desc desc;
@@ -1867,3 +1867,126 @@ int hclge_tm_get_q_to_tc(struct hclge_dev *hdev, u16 q_id, u8 *tc_id)
 	*tc_id = tc->tc_id & HCLGE_TM_TC_MASK;
 	return 0;
 }
+
+int hclge_tm_get_pg_to_pri_map(struct hclge_dev *hdev, u8 pg_id,
+			       u8 *pri_bit_map)
+{
+	struct hclge_pg_to_pri_link_cmd *map;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_PG_TO_PRI_LINK, true);
+	map = (struct hclge_pg_to_pri_link_cmd *)desc.data;
+	map->pg_id = pg_id;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get pg to pri map, ret = %d\n", ret);
+		return ret;
+	}
+
+	*pri_bit_map = map->pri_bit_map;
+	return 0;
+}
+
+int hclge_tm_get_pg_weight(struct hclge_dev *hdev, u8 pg_id, u8 *weight)
+{
+	struct hclge_pg_weight_cmd *pg_weight_cmd;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_PG_WEIGHT, true);
+	pg_weight_cmd = (struct hclge_pg_weight_cmd *)desc.data;
+	pg_weight_cmd->pg_id = pg_id;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get pg weight, ret = %d\n", ret);
+		return ret;
+	}
+
+	*weight = pg_weight_cmd->dwrr;
+	return 0;
+}
+
+int hclge_tm_get_pg_sch_mode(struct hclge_dev *hdev, u8 pg_id, u8 *mode)
+{
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_PG_SCH_MODE_CFG, true);
+	desc.data[0] = cpu_to_le32(pg_id);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get pg sch mode, ret = %d\n", ret);
+		return ret;
+	}
+
+	*mode = (u8)le32_to_cpu(desc.data[1]);
+	return 0;
+}
+
+int hclge_tm_get_pg_shaper(struct hclge_dev *hdev, u8 pg_id,
+			   enum hclge_opcode_type cmd,
+			   struct hclge_tm_shaper_para *para)
+{
+	struct hclge_pg_shapping_cmd *shap_cfg_cmd;
+	struct hclge_desc desc;
+	u32 shapping_para;
+	int ret;
+
+	if (cmd != HCLGE_OPC_TM_PG_C_SHAPPING &&
+	    cmd != HCLGE_OPC_TM_PG_P_SHAPPING)
+		return -EINVAL;
+
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	shap_cfg_cmd = (struct hclge_pg_shapping_cmd *)desc.data;
+	shap_cfg_cmd->pg_id = pg_id;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get pg shaper(%#x), ret = %d\n",
+			cmd, ret);
+		return ret;
+	}
+
+	shapping_para = le32_to_cpu(shap_cfg_cmd->pg_shapping_para);
+	para->ir_b = hclge_tm_get_field(shapping_para, IR_B);
+	para->ir_u = hclge_tm_get_field(shapping_para, IR_U);
+	para->ir_s = hclge_tm_get_field(shapping_para, IR_S);
+	para->bs_b = hclge_tm_get_field(shapping_para, BS_B);
+	para->bs_s = hclge_tm_get_field(shapping_para, BS_S);
+	para->flag = shap_cfg_cmd->flag;
+	para->rate = le32_to_cpu(shap_cfg_cmd->pg_rate);
+	return 0;
+}
+
+int hclge_tm_get_port_shaper(struct hclge_dev *hdev,
+			     struct hclge_tm_shaper_para *para)
+{
+	struct hclge_port_shapping_cmd *port_shap_cfg_cmd;
+	struct hclge_desc desc;
+	u32 shapping_para;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_PORT_SHAPPING, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get port shaper, ret = %d\n", ret);
+		return ret;
+	}
+
+	port_shap_cfg_cmd = (struct hclge_port_shapping_cmd *)desc.data;
+	shapping_para = le32_to_cpu(port_shap_cfg_cmd->port_shapping_para);
+	para->ir_b = hclge_tm_get_field(shapping_para, IR_B);
+	para->ir_u = hclge_tm_get_field(shapping_para, IR_U);
+	para->ir_s = hclge_tm_get_field(shapping_para, IR_S);
+	para->bs_b = hclge_tm_get_field(shapping_para, BS_B);
+	para->bs_s = hclge_tm_get_field(shapping_para, BS_S);
+	para->flag = port_shap_cfg_cmd->flag;
+	para->rate = le32_to_cpu(port_shap_cfg_cmd->port_rate);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index c21e822..d6f1481 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -199,14 +199,14 @@ struct hclge_tm_nodes_cmd {
 	__le16 queue_num;
 };
 
-struct hclge_pri_shaper_para {
+struct hclge_tm_shaper_para {
+	u32 rate;
 	u8 ir_b;
 	u8 ir_u;
 	u8 ir_s;
 	u8 bs_b;
 	u8 bs_s;
 	u8 flag;
-	u32 rate;
 };
 
 #define hclge_tm_set_field(dest, string, val) \
@@ -241,7 +241,16 @@ int hclge_tm_get_pri_sch_mode(struct hclge_dev *hdev, u8 pri_id, u8 *mode);
 int hclge_tm_get_pri_weight(struct hclge_dev *hdev, u8 pri_id, u8 *weight);
 int hclge_tm_get_pri_shaper(struct hclge_dev *hdev, u8 pri_id,
 			    enum hclge_opcode_type cmd,
-			    struct hclge_pri_shaper_para *para);
+			    struct hclge_tm_shaper_para *para);
 int hclge_tm_get_q_to_qs_map(struct hclge_dev *hdev, u16 q_id, u16 *qset_id);
 int hclge_tm_get_q_to_tc(struct hclge_dev *hdev, u16 q_id, u8 *tc_id);
+int hclge_tm_get_pg_to_pri_map(struct hclge_dev *hdev, u8 pg_id,
+			       u8 *pri_bit_map);
+int hclge_tm_get_pg_weight(struct hclge_dev *hdev, u8 pg_id, u8 *weight);
+int hclge_tm_get_pg_sch_mode(struct hclge_dev *hdev, u8 pg_id, u8 *mode);
+int hclge_tm_get_pg_shaper(struct hclge_dev *hdev, u8 pg_id,
+			   enum hclge_opcode_type cmd,
+			   struct hclge_tm_shaper_para *para);
+int hclge_tm_get_port_shaper(struct hclge_dev *hdev,
+			     struct hclge_tm_shaper_para *para);
 #endif
-- 
2.7.4

