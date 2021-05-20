Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E0D389B4E
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhETCXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:20 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4543 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhETCXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:17 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Flthr6M9tzkWb1;
        Thu, 20 May 2021 10:19:08 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
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
Subject: [PATCH net-next 06/15] net: hns3: refactor dump tm map of debugfs
Date:   Thu, 20 May 2021 10:21:35 +0800
Message-ID: <1621477304-4495-7-git-send-email-tanhuazhong@huawei.com>
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

Currently, the debugfs command for tm map is implemented by
"echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create a single file
"tm_map" for it, and query it by command "cat tm_map",
return the result to userspace, rather than record in dmesg.

As user can't specify queue id in cat command, driver will return info
of all queue id.

The display style is below:
$ cat tm_map
queue_id   qset_id   pri_id   tc_id
0000         0000      00       00
INDEX | TM BP QSET MAPPING:
0000  | 00000000:00000000:00000000:00000000:00000000:00000000:00000000
0256  | 00000000:00000000:00000000:00000000:00000000:00000002:00000000
0512  | 00000000:00000000:00000000:00000004:00000000:00000000:00000000
0768  | 00000000:00000008:00000000:00000000:00000000:00000000:00000000

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   8 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 169 +++++++++------------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  60 ++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   2 +
 5 files changed, 145 insertions(+), 95 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 730f56d..5de8b11 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -254,6 +254,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_TM_NODES,
 	HNAE3_DBG_CMD_TM_PRI,
 	HNAE3_DBG_CMD_TM_QSET,
+	HNAE3_DBG_CMD_TM_MAP,
 	HNAE3_DBG_CMD_DEV_INFO,
 	HNAE3_DBG_CMD_TX_BD,
 	HNAE3_DBG_CMD_RX_BD,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 37aa891..39a24cc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -65,6 +65,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.init = hns3_dbg_common_file_init,
 	},
 	{
+		.name = "tm_map",
+		.cmd = HNAE3_DBG_CMD_TM_MAP,
+		.dentry = HNS3_DBG_DENTRY_TM,
+		.buf_len = HNS3_DBG_READ_LEN_1MB,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
 		.name = "dev_info",
 		.cmd = HNAE3_DBG_CMD_DEV_INFO,
 		.dentry = HNS3_DBG_DENTRY_COMMON,
@@ -718,7 +725,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 		return;
 
 	dev_info(&h->pdev->dev, "dump tc\n");
-	dev_info(&h->pdev->dev, "dump tm map <q_num>\n");
 	dev_info(&h->pdev->dev, "dump tm\n");
 	dev_info(&h->pdev->dev, "dump qos pause cfg\n");
 	dev_info(&h->pdev->dev, "dump qos pri map\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index c92800d..58ee389 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -905,115 +905,96 @@ static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
 		cmd, ret);
 }
 
-static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
-				  const char *cmd_buf)
+static int hclge_dbg_dump_tm_bp_qset_map(struct hclge_dev *hdev, u8 tc_id,
+					 char *buf, int len)
 {
-	struct hclge_bp_to_qs_map_cmd *bp_to_qs_map_cmd;
-	struct hclge_nq_to_qs_link_cmd *nq_to_qs_map;
 	u32 qset_mapping[HCLGE_BP_EXT_GRP_NUM];
-	struct hclge_qs_to_pri_link_cmd *map;
-	struct hclge_tqp_tx_queue_tc_cmd *tc;
-	u16 group_id, queue_id, qset_id;
-	enum hclge_opcode_type cmd;
-	u8 grp_num, pri_id, tc_id;
+	struct hclge_bp_to_qs_map_cmd *map;
 	struct hclge_desc desc;
-	u16 qs_id_l;
-	u16 qs_id_h;
+	int pos = 0;
+	u8 group_id;
+	u8 grp_num;
+	u16 i = 0;
 	int ret;
-	u32 i;
-
-	ret = kstrtou16(cmd_buf, 0, &queue_id);
-	queue_id = (ret != 0) ? 0 : queue_id;
-
-	cmd = HCLGE_OPC_TM_NQ_TO_QS_LINK;
-	nq_to_qs_map = (struct hclge_nq_to_qs_link_cmd *)desc.data;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	nq_to_qs_map->nq_id = cpu_to_le16(queue_id);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_map_cmd_send;
-	qset_id = le16_to_cpu(nq_to_qs_map->qset_id);
-
-	/* convert qset_id to the following format, drop the vld bit
-	 *            | qs_id_h | vld | qs_id_l |
-	 * qset_id:   | 15 ~ 11 |  10 |  9 ~ 0  |
-	 *             \         \   /         /
-	 *              \         \ /         /
-	 * qset_id: | 15 | 14 ~ 10 |  9 ~ 0  |
-	 */
-	qs_id_l = hnae3_get_field(qset_id, HCLGE_TM_QS_ID_L_MSK,
-				  HCLGE_TM_QS_ID_L_S);
-	qs_id_h = hnae3_get_field(qset_id, HCLGE_TM_QS_ID_H_EXT_MSK,
-				  HCLGE_TM_QS_ID_H_EXT_S);
-	qset_id = 0;
-	hnae3_set_field(qset_id, HCLGE_TM_QS_ID_L_MSK, HCLGE_TM_QS_ID_L_S,
-			qs_id_l);
-	hnae3_set_field(qset_id, HCLGE_TM_QS_ID_H_MSK, HCLGE_TM_QS_ID_H_S,
-			qs_id_h);
-
-	cmd = HCLGE_OPC_TM_QS_TO_PRI_LINK;
-	map = (struct hclge_qs_to_pri_link_cmd *)desc.data;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	map->qs_id = cpu_to_le16(qset_id);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_map_cmd_send;
-	pri_id = map->priority;
-
-	cmd = HCLGE_OPC_TQP_TX_QUEUE_TC;
-	tc = (struct hclge_tqp_tx_queue_tc_cmd *)desc.data;
-	hclge_cmd_setup_basic_desc(&desc, cmd, true);
-	tc->queue_id = cpu_to_le16(queue_id);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		goto err_tm_map_cmd_send;
-	tc_id = tc->tc_id & 0x7;
-
-	dev_info(&hdev->pdev->dev, "queue_id | qset_id | pri_id | tc_id\n");
-	dev_info(&hdev->pdev->dev, "%04u     | %04u    | %02u     | %02u\n",
-		 queue_id, qset_id, pri_id, tc_id);
-
-	if (!hnae3_dev_dcb_supported(hdev)) {
-		dev_info(&hdev->pdev->dev,
-			 "Only DCB-supported dev supports tm mapping\n");
-		return;
-	}
 
 	grp_num = hdev->num_tqps <= HCLGE_TQP_MAX_SIZE_DEV_V2 ?
 		  HCLGE_BP_GRP_NUM : HCLGE_BP_EXT_GRP_NUM;
-	cmd = HCLGE_OPC_TM_BP_TO_QSET_MAPPING;
-	bp_to_qs_map_cmd = (struct hclge_bp_to_qs_map_cmd *)desc.data;
+	map = (struct hclge_bp_to_qs_map_cmd *)desc.data;
 	for (group_id = 0; group_id < grp_num; group_id++) {
-		hclge_cmd_setup_basic_desc(&desc, cmd, true);
-		bp_to_qs_map_cmd->tc_id = tc_id;
-		bp_to_qs_map_cmd->qs_group_id = group_id;
+		hclge_cmd_setup_basic_desc(&desc,
+					   HCLGE_OPC_TM_BP_TO_QSET_MAPPING,
+					   true);
+		map->tc_id = tc_id;
+		map->qs_group_id = group_id;
 		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-		if (ret)
-			goto err_tm_map_cmd_send;
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to get bp to qset map, ret = %d\n",
+				ret);
+			return ret;
+		}
 
-		qset_mapping[group_id] =
-			le32_to_cpu(bp_to_qs_map_cmd->qs_bit_map);
+		qset_mapping[group_id] = le32_to_cpu(map->qs_bit_map);
 	}
 
-	dev_info(&hdev->pdev->dev, "index | tm bp qset maping:\n");
-
-	i = 0;
+	pos += scnprintf(buf + pos, len - pos, "INDEX | TM BP QSET MAPPING:\n");
 	for (group_id = 0; group_id < grp_num / 8; group_id++) {
-		dev_info(&hdev->pdev->dev,
+		pos += scnprintf(buf + pos, len - pos,
 			 "%04d  | %08x:%08x:%08x:%08x:%08x:%08x:%08x:%08x\n",
-			 group_id * 256, qset_mapping[(u32)(i + 7)],
-			 qset_mapping[(u32)(i + 6)], qset_mapping[(u32)(i + 5)],
-			 qset_mapping[(u32)(i + 4)], qset_mapping[(u32)(i + 3)],
-			 qset_mapping[(u32)(i + 2)], qset_mapping[(u32)(i + 1)],
+			 group_id * 256, qset_mapping[i + 7],
+			 qset_mapping[i + 6], qset_mapping[i + 5],
+			 qset_mapping[i + 4], qset_mapping[i + 3],
+			 qset_mapping[i + 2], qset_mapping[i + 1],
 			 qset_mapping[i]);
 		i += 8;
 	}
 
-	return;
+	return pos;
+}
 
-err_tm_map_cmd_send:
-	dev_err(&hdev->pdev->dev, "dump tqp map fail(0x%x), ret = %d\n",
-		cmd, ret);
+static int hclge_dbg_dump_tm_map(struct hclge_dev *hdev, char *buf, int len)
+{
+	u16 queue_id;
+	u16 qset_id;
+	u8 link_vld;
+	int pos = 0;
+	u8 pri_id;
+	u8 tc_id;
+	int ret;
+
+	for (queue_id = 0; queue_id < hdev->num_tqps; queue_id++) {
+		ret = hclge_tm_get_q_to_qs_map(hdev, queue_id, &qset_id);
+		if (ret)
+			return ret;
+
+		ret = hclge_tm_get_qset_map_pri(hdev, qset_id, &pri_id,
+						&link_vld);
+		if (ret)
+			return ret;
+
+		ret = hclge_tm_get_q_to_tc(hdev, queue_id, &tc_id);
+		if (ret)
+			return ret;
+
+		pos += scnprintf(buf + pos, len - pos,
+				 "QUEUE_ID   QSET_ID   PRI_ID   TC_ID\n");
+		pos += scnprintf(buf + pos, len - pos,
+				 "%04u        %4u       %3u      %2u\n",
+				 queue_id, qset_id, pri_id, tc_id);
+
+		if (!hnae3_dev_dcb_supported(hdev))
+			continue;
+
+		ret = hclge_dbg_dump_tm_bp_qset_map(hdev, tc_id, buf + pos,
+						    len - pos);
+		if (ret < 0)
+			return ret;
+		pos += ret;
+
+		pos += scnprintf(buf + pos, len - pos, "\n");
+	}
+
+	return 0;
 }
 
 static int hclge_dbg_dump_tm_nodes(struct hclge_dev *hdev, char *buf, int len)
@@ -2013,15 +1994,11 @@ static int hclge_dbg_dump_mac_mc(struct hclge_dev *hdev, char *buf, int len)
 
 int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 {
-#define DUMP_TM_MAP	"dump tm map"
-
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
 	if (strncmp(cmd_buf, "dump tc", 7) == 0) {
 		hclge_dbg_dump_tc(hdev);
-	} else if (strncmp(cmd_buf, DUMP_TM_MAP, strlen(DUMP_TM_MAP)) == 0) {
-		hclge_dbg_dump_tm_map(hdev, &cmd_buf[sizeof(DUMP_TM_MAP)]);
 	} else if (strncmp(cmd_buf, "dump tm", 7) == 0) {
 		hclge_dbg_dump_tm(hdev);
 	} else if (strncmp(cmd_buf, "dump qos pause cfg", 18) == 0) {
@@ -2059,6 +2036,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.dbg_dump = hclge_dbg_dump_tm_qset,
 	},
 	{
+		.cmd = HNAE3_DBG_CMD_TM_MAP,
+		.dbg_dump = hclge_dbg_dump_tm_map,
+	},
+	{
 		.cmd = HNAE3_DBG_CMD_MAC_UC,
 		.dbg_dump = hclge_dbg_dump_mac_uc,
 	},
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index ebb962b..bd99faf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1807,3 +1807,63 @@ int hclge_tm_get_pri_shaper(struct hclge_dev *hdev, u8 pri_id,
 	para->rate = le32_to_cpu(shap_cfg_cmd->pri_rate);
 	return 0;
 }
+
+int hclge_tm_get_q_to_qs_map(struct hclge_dev *hdev, u16 q_id, u16 *qset_id)
+{
+	struct hclge_nq_to_qs_link_cmd *map;
+	struct hclge_desc desc;
+	u16 qs_id_l;
+	u16 qs_id_h;
+	int ret;
+
+	map = (struct hclge_nq_to_qs_link_cmd *)desc.data;
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_NQ_TO_QS_LINK, true);
+	map->nq_id = cpu_to_le16(q_id);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get queue to qset map, ret = %d\n", ret);
+		return ret;
+	}
+	*qset_id = le16_to_cpu(map->qset_id);
+
+	/* convert qset_id to the following format, drop the vld bit
+	 *            | qs_id_h | vld | qs_id_l |
+	 * qset_id:   | 15 ~ 11 |  10 |  9 ~ 0  |
+	 *             \         \   /         /
+	 *              \         \ /         /
+	 * qset_id: | 15 | 14 ~ 10 |  9 ~ 0  |
+	 */
+	qs_id_l = hnae3_get_field(*qset_id, HCLGE_TM_QS_ID_L_MSK,
+				  HCLGE_TM_QS_ID_L_S);
+	qs_id_h = hnae3_get_field(*qset_id, HCLGE_TM_QS_ID_H_EXT_MSK,
+				  HCLGE_TM_QS_ID_H_EXT_S);
+	*qset_id = 0;
+	hnae3_set_field(*qset_id, HCLGE_TM_QS_ID_L_MSK, HCLGE_TM_QS_ID_L_S,
+			qs_id_l);
+	hnae3_set_field(*qset_id, HCLGE_TM_QS_ID_H_MSK, HCLGE_TM_QS_ID_H_S,
+			qs_id_h);
+	return 0;
+}
+
+int hclge_tm_get_q_to_tc(struct hclge_dev *hdev, u16 q_id, u8 *tc_id)
+{
+#define HCLGE_TM_TC_MASK		0x7
+
+	struct hclge_tqp_tx_queue_tc_cmd *tc;
+	struct hclge_desc desc;
+	int ret;
+
+	tc = (struct hclge_tqp_tx_queue_tc_cmd *)desc.data;
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TQP_TX_QUEUE_TC, true);
+	tc->queue_id = cpu_to_le16(q_id);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get queue to tc map, ret = %d\n", ret);
+		return ret;
+	}
+
+	*tc_id = tc->tc_id & HCLGE_TM_TC_MASK;
+	return 0;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index b25d760..c21e822 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -242,4 +242,6 @@ int hclge_tm_get_pri_weight(struct hclge_dev *hdev, u8 pri_id, u8 *weight);
 int hclge_tm_get_pri_shaper(struct hclge_dev *hdev, u8 pri_id,
 			    enum hclge_opcode_type cmd,
 			    struct hclge_pri_shaper_para *para);
+int hclge_tm_get_q_to_qs_map(struct hclge_dev *hdev, u16 q_id, u16 *qset_id);
+int hclge_tm_get_q_to_tc(struct hclge_dev *hdev, u16 q_id, u8 *tc_id);
 #endif
-- 
2.7.4

