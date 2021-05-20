Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A94389B52
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhETCX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:26 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3435 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbhETCXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:18 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Flths1XPfzCsVw;
        Thu, 20 May 2021 10:19:09 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:56 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:56 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 12/15] net: hns3: refactor dump qs shaper of debugfs
Date:   Thu, 20 May 2021 10:21:41 +0800
Message-ID: <1621477304-4495-13-git-send-email-tanhuazhong@huawei.com>
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

Currently, user gets qset shaper parameters by implementing debugfs
command "echo dump qs shaper > cmd", this command will dump info in
dmesg. It's unnecessary and heavy.

As there is "tm_qset" file in tm directory for dump qset info, to
optimize these command, merge qset shaper parameters to tm_qset
file and use cat command to get them.

The display style is below:
$ cat tm_qset
ID    MAP_PRI  LINK_VLD  MODE  DWRR  IR_B  IR_U  IR_S  BS_B  BS_S  FLAG
0000     0        1      dwrr  100   150     7     0     5    20     0
0001     0        0        sp    0   150     7     0     5    20     0

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   1 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 129 +++++++--------------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  30 +++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   2 +
 4 files changed, 76 insertions(+), 86 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index bd348c1..599b405 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -767,7 +767,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 		return;
 
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
-	dev_info(&h->pdev->dev, "dump qs shaper [qs id]\n");
 }
 
 static void
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 45ccb04..2b7acf6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -991,19 +991,42 @@ static int hclge_dbg_dump_tm_pri(struct hclge_dev *hdev, char *buf, int len)
 	return 0;
 }
 
+static const struct hclge_dbg_item tm_qset_items[] = {
+	{ "ID", 4 },
+	{ "MAP_PRI", 2 },
+	{ "LINK_VLD", 2 },
+	{ "MODE", 2 },
+	{ "DWRR", 2 },
+	{ "IR_B", 2 },
+	{ "IR_U", 2 },
+	{ "IR_S", 2 },
+	{ "BS_B", 2 },
+	{ "BS_S", 2 },
+	{ "FLAG", 2 },
+	{ "RATE(Mbps)", 0 }
+};
+
 static int hclge_dbg_dump_tm_qset(struct hclge_dev *hdev, char *buf, int len)
 {
+	char data_str[ARRAY_SIZE(tm_qset_items)][HCLGE_DBG_DATA_STR_LEN];
+	char *result[ARRAY_SIZE(tm_qset_items)], *sch_mode_str;
 	u8 priority, link_vld, sch_mode, weight;
-	char *sch_mode_str;
+	struct hclge_tm_shaper_para shaper_para;
+	char content[HCLGE_DBG_TM_INFO_LEN];
+	u16 qset_num, i;
 	int ret, pos;
-	u16 qset_num;
-	u16 i;
+	u8 j;
 
 	ret = hclge_tm_get_qset_num(hdev, &qset_num);
 	if (ret)
 		return ret;
 
-	pos = scnprintf(buf, len, "ID    MAP_PRI  LINK_VLD  MODE  DWRR\n");
+	for (i = 0; i < ARRAY_SIZE(tm_qset_items); i++)
+		result[i] = &data_str[i][0];
+
+	hclge_dbg_fill_content(content, sizeof(content), tm_qset_items,
+			       NULL, ARRAY_SIZE(tm_qset_items));
+	pos = scnprintf(buf, len, "%s", content);
 
 	for (i = 0; i < qset_num; i++) {
 		ret = hclge_tm_get_qset_map_pri(hdev, i, &priority, &link_vld);
@@ -1018,11 +1041,25 @@ static int hclge_dbg_dump_tm_qset(struct hclge_dev *hdev, char *buf, int len)
 		if (ret)
 			return ret;
 
+		ret = hclge_tm_get_qset_shaper(hdev, i, &shaper_para);
+		if (ret)
+			return ret;
+
 		sch_mode_str = sch_mode & HCLGE_TM_TX_SCHD_DWRR_MSK ? "dwrr" :
 			       "sp";
-		pos += scnprintf(buf + pos, len - pos,
-				 "%04u  %4u        %1u      %4s  %3u\n",
-				 i, priority, link_vld, sch_mode_str, weight);
+
+		j = 0;
+		sprintf(result[j++], "%04u", i);
+		sprintf(result[j++], "%4u", priority);
+		sprintf(result[j++], "%4u", link_vld);
+		sprintf(result[j++], "%4s", sch_mode_str);
+		sprintf(result[j++], "%3u", weight);
+		hclge_dbg_fill_shaper_content(&shaper_para, result, &j);
+
+		hclge_dbg_fill_content(content, sizeof(content), tm_qset_items,
+				       (const char **)result,
+				       ARRAY_SIZE(tm_qset_items));
+		pos += scnprintf(buf + pos, len - pos, "%s", content);
 	}
 
 	return 0;
@@ -1787,81 +1824,6 @@ static void hclge_dbg_dump_mac_tnl_status(struct hclge_dev *hdev)
 	}
 }
 
-static void hclge_dbg_dump_qs_shaper_single(struct hclge_dev *hdev, u16 qsid)
-{
-	struct hclge_qs_shapping_cmd *shap_cfg_cmd;
-	u8 ir_u, ir_b, ir_s, bs_b, bs_s;
-	struct hclge_desc desc;
-	u32 shapping_para;
-	u32 rate;
-	int ret;
-
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QCN_SHAPPING_CFG, true);
-
-	shap_cfg_cmd = (struct hclge_qs_shapping_cmd *)desc.data;
-	shap_cfg_cmd->qs_id = cpu_to_le16(qsid);
-
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"qs%u failed to get tx_rate, ret=%d\n",
-			qsid, ret);
-		return;
-	}
-
-	shapping_para = le32_to_cpu(shap_cfg_cmd->qs_shapping_para);
-	ir_b = hclge_tm_get_field(shapping_para, IR_B);
-	ir_u = hclge_tm_get_field(shapping_para, IR_U);
-	ir_s = hclge_tm_get_field(shapping_para, IR_S);
-	bs_b = hclge_tm_get_field(shapping_para, BS_B);
-	bs_s = hclge_tm_get_field(shapping_para, BS_S);
-	rate = le32_to_cpu(shap_cfg_cmd->qs_rate);
-
-	dev_info(&hdev->pdev->dev,
-		 "qs%u ir_b:%u, ir_u:%u, ir_s:%u, bs_b:%u, bs_s:%u, flag:%#x, rate:%u(Mbps)\n",
-		 qsid, ir_b, ir_u, ir_s, bs_b, bs_s, shap_cfg_cmd->flag, rate);
-}
-
-static void hclge_dbg_dump_qs_shaper_all(struct hclge_dev *hdev)
-{
-	struct hnae3_knic_private_info *kinfo;
-	struct hclge_vport *vport;
-	int vport_id, i;
-
-	for (vport_id = 0; vport_id <= pci_num_vf(hdev->pdev); vport_id++) {
-		vport = &hdev->vport[vport_id];
-		kinfo = &vport->nic.kinfo;
-
-		dev_info(&hdev->pdev->dev, "qs cfg of vport%d:\n", vport_id);
-
-		for (i = 0; i < kinfo->tc_info.num_tc; i++) {
-			u16 qsid = vport->qs_offset + i;
-
-			hclge_dbg_dump_qs_shaper_single(hdev, qsid);
-		}
-	}
-}
-
-static void hclge_dbg_dump_qs_shaper(struct hclge_dev *hdev,
-				     const char *cmd_buf)
-{
-	u16 qsid;
-	int ret;
-
-	ret = kstrtou16(cmd_buf, 0, &qsid);
-	if (ret) {
-		hclge_dbg_dump_qs_shaper_all(hdev);
-		return;
-	}
-
-	if (qsid >= hdev->ae_dev->dev_specs.max_qset_num) {
-		dev_err(&hdev->pdev->dev, "qsid(%u) out of range[0-%u]\n",
-			qsid, hdev->ae_dev->dev_specs.max_qset_num - 1);
-		return;
-	}
-
-	hclge_dbg_dump_qs_shaper_single(hdev, qsid);
-}
 
 static const struct hclge_dbg_item mac_list_items[] = {
 	{ "FUNC_ID", 2 },
@@ -1935,9 +1897,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 		hclge_dbg_dump_serv_info(hdev);
 	} else if (strncmp(cmd_buf, "dump mac tnl status", 19) == 0) {
 		hclge_dbg_dump_mac_tnl_status(hdev);
-	} else if (strncmp(cmd_buf, "dump qs shaper", 14) == 0) {
-		hclge_dbg_dump_qs_shaper(hdev,
-					 &cmd_buf[sizeof("dump qs shaper")]);
 	} else {
 		dev_info(&hdev->pdev->dev, "unknown command\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 45870fe..78d5bf1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1733,6 +1733,36 @@ int hclge_tm_get_qset_weight(struct hclge_dev *hdev, u16 qset_id, u8 *weight)
 	return 0;
 }
 
+int hclge_tm_get_qset_shaper(struct hclge_dev *hdev, u16 qset_id,
+			     struct hclge_tm_shaper_para *para)
+{
+	struct hclge_qs_shapping_cmd *shap_cfg_cmd;
+	struct hclge_desc desc;
+	u32 shapping_para;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QCN_SHAPPING_CFG, true);
+	shap_cfg_cmd = (struct hclge_qs_shapping_cmd *)desc.data;
+	shap_cfg_cmd->qs_id = cpu_to_le16(qset_id);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get qset %u shaper, ret = %d\n", qset_id,
+			ret);
+		return ret;
+	}
+
+	shapping_para = le32_to_cpu(shap_cfg_cmd->qs_shapping_para);
+	para->ir_b = hclge_tm_get_field(shapping_para, IR_B);
+	para->ir_u = hclge_tm_get_field(shapping_para, IR_U);
+	para->ir_s = hclge_tm_get_field(shapping_para, IR_S);
+	para->bs_b = hclge_tm_get_field(shapping_para, BS_B);
+	para->bs_s = hclge_tm_get_field(shapping_para, BS_S);
+	para->flag = shap_cfg_cmd->flag;
+	para->rate = le32_to_cpu(shap_cfg_cmd->qs_rate);
+	return 0;
+}
+
 int hclge_tm_get_pri_sch_mode(struct hclge_dev *hdev, u8 pri_id, u8 *mode)
 {
 	struct hclge_pri_sch_mode_cfg_cmd *pri_sch_mode;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index d6f1481..2ee9b79 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -237,6 +237,8 @@ int hclge_tm_get_qset_map_pri(struct hclge_dev *hdev, u16 qset_id, u8 *priority,
 			      u8 *link_vld);
 int hclge_tm_get_qset_sch_mode(struct hclge_dev *hdev, u16 qset_id, u8 *mode);
 int hclge_tm_get_qset_weight(struct hclge_dev *hdev, u16 qset_id, u8 *weight);
+int hclge_tm_get_qset_shaper(struct hclge_dev *hdev, u16 qset_id,
+			     struct hclge_tm_shaper_para *para);
 int hclge_tm_get_pri_sch_mode(struct hclge_dev *hdev, u8 pri_id, u8 *mode);
 int hclge_tm_get_pri_weight(struct hclge_dev *hdev, u8 pri_id, u8 *weight);
 int hclge_tm_get_pri_shaper(struct hclge_dev *hdev, u8 pri_id,
-- 
2.7.4

