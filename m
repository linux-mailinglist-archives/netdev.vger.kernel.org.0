Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49C02BA5C6
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgKTJQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:16:54 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8565 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbgKTJQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:16:22 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CcrWK0tc3zLqkn;
        Fri, 20 Nov 2020 17:15:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Nov 2020 17:16:11 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/5] net: hns3: add support for 1280 queues
Date:   Fri, 20 Nov 2020 17:16:19 +0800
Message-ID: <1605863783-36995-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
References: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

For DEVICE_VERSION_V1/2, there are total 1024 queues and
queue sets. For DEVICE_VERSION_V3, it increases to 1280,
and can be assigned to one pf， so remove the limitation
of 1024.

To keep compatible with DEVICE_VERSION_V1/2 and old driver
version, the queue number is split into two part:
tqp_num(range 0~1023) and ext_tqp_num(range 1024~1279).

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  7 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 30 +++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 29 ++++++++++++-----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 37 ++++++++++++++++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  | 11 +++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  3 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 16 ++++++++--
 7 files changed, 111 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 5b7967c..f458d32 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -307,6 +307,9 @@ enum hclge_opcode_type {
 #define HCLGE_TQP_REG_OFFSET		0x80000
 #define HCLGE_TQP_REG_SIZE		0x200
 
+#define HCLGE_TQP_MAX_SIZE_DEV_V2	1024
+#define HCLGE_TQP_EXT_REG_OFFSET	0x100
+
 #define HCLGE_RCB_INIT_QUERY_TIMEOUT	10
 #define HCLGE_RCB_INIT_FLAG_EN_B	0
 #define HCLGE_RCB_INIT_FLAG_FINI_B	8
@@ -479,7 +482,8 @@ struct hclge_pf_res_cmd {
 	__le16 pf_own_fun_number;
 	__le16 tx_buf_size;
 	__le16 dv_buf_size;
-	__le32 rsv[2];
+	__le16 ext_tqp_num;
+	u8 rsv[6];
 };
 
 #define HCLGE_CFG_OFFSET_S	0
@@ -643,7 +647,6 @@ struct hclge_config_mac_speed_dup_cmd {
 	u8 rsv[22];
 };
 
-#define HCLGE_RING_ID_MASK		GENMASK(9, 0)
 #define HCLGE_TQP_ENABLE_B		0
 
 #define HCLGE_MAC_CFG_AN_EN_B		0
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 16df050..c82d2ca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -681,14 +681,17 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 {
 	struct hclge_bp_to_qs_map_cmd *bp_to_qs_map_cmd;
 	struct hclge_nq_to_qs_link_cmd *nq_to_qs_map;
+	u32 qset_mapping[HCLGE_BP_EXT_GRP_NUM];
 	struct hclge_qs_to_pri_link_cmd *map;
 	struct hclge_tqp_tx_queue_tc_cmd *tc;
 	enum hclge_opcode_type cmd;
 	struct hclge_desc desc;
 	int queue_id, group_id;
-	u32 qset_mapping[32];
 	int tc_id, qset_id;
 	int pri_id, ret;
+	u16 qs_id_l;
+	u16 qs_id_h;
+	u8 grp_num;
 	u32 i;
 
 	ret = kstrtouint(cmd_buf, 0, &queue_id);
@@ -701,7 +704,24 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
 		goto err_tm_map_cmd_send;
-	qset_id = le16_to_cpu(nq_to_qs_map->qset_id) & 0x3FF;
+	qset_id = le16_to_cpu(nq_to_qs_map->qset_id);
+
+	/* convert qset_id to the following format, drop the vld bit
+	 *            | qs_id_h | vld | qs_id_l |
+	 * qset_id:   | 15 ~ 11 |  10 |  9 ~ 0  |
+	 *             \         \   /         /
+	 *              \         \ /         /
+	 * qset_id: | 15 | 14 ~ 10 |  9 ~ 0  |
+	 */
+	qs_id_l = hnae3_get_field(qset_id, HCLGE_TM_QS_ID_L_MSK,
+				  HCLGE_TM_QS_ID_L_S);
+	qs_id_h = hnae3_get_field(qset_id, HCLGE_TM_QS_ID_H_EXT_MSK,
+				  HCLGE_TM_QS_ID_H_EXT_S);
+	qset_id = 0;
+	hnae3_set_field(qset_id, HCLGE_TM_QS_ID_L_MSK, HCLGE_TM_QS_ID_L_S,
+			qs_id_l);
+	hnae3_set_field(qset_id, HCLGE_TM_QS_ID_H_MSK, HCLGE_TM_QS_ID_H_S,
+			qs_id_h);
 
 	cmd = HCLGE_OPC_TM_QS_TO_PRI_LINK;
 	map = (struct hclge_qs_to_pri_link_cmd *)desc.data;
@@ -731,9 +751,11 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 		return;
 	}
 
+	grp_num = hdev->num_tqps <= HCLGE_TQP_MAX_SIZE_DEV_V2 ?
+		  HCLGE_BP_GRP_NUM : HCLGE_BP_EXT_GRP_NUM;
 	cmd = HCLGE_OPC_TM_BP_TO_QSET_MAPPING;
 	bp_to_qs_map_cmd = (struct hclge_bp_to_qs_map_cmd *)desc.data;
-	for (group_id = 0; group_id < 32; group_id++) {
+	for (group_id = 0; group_id < grp_num; group_id++) {
 		hclge_cmd_setup_basic_desc(&desc, cmd, true);
 		bp_to_qs_map_cmd->tc_id = tc_id;
 		bp_to_qs_map_cmd->qs_group_id = group_id;
@@ -748,7 +770,7 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 	dev_info(&hdev->pdev->dev, "index | tm bp qset maping:\n");
 
 	i = 0;
-	for (group_id = 0; group_id < 4; group_id++) {
+	for (group_id = 0; group_id < grp_num / 8; group_id++) {
 		dev_info(&hdev->pdev->dev,
 			 "%04d  | %08x:%08x:%08x:%08x:%08x:%08x:%08x:%08x\n",
 			 group_id * 256, qset_mapping[(u32)(i + 7)],
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7102001..892e7f6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -556,7 +556,7 @@ static int hclge_tqps_update_stats(struct hnae3_handle *handle)
 		hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_QUERY_RX_STATS,
 					   true);
 
-		desc[0].data[0] = cpu_to_le32((tqp->index & 0x1ff));
+		desc[0].data[0] = cpu_to_le32(tqp->index);
 		ret = hclge_cmd_send(&hdev->hw, desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
@@ -576,7 +576,7 @@ static int hclge_tqps_update_stats(struct hnae3_handle *handle)
 					   HCLGE_OPC_QUERY_TX_STATS,
 					   true);
 
-		desc[0].data[0] = cpu_to_le32((tqp->index & 0x1ff));
+		desc[0].data[0] = cpu_to_le32(tqp->index);
 		ret = hclge_cmd_send(&hdev->hw, desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
@@ -886,7 +886,8 @@ static int hclge_query_pf_resource(struct hclge_dev *hdev)
 	}
 
 	req = (struct hclge_pf_res_cmd *)desc.data;
-	hdev->num_tqps = le16_to_cpu(req->tqp_num);
+	hdev->num_tqps = le16_to_cpu(req->tqp_num) +
+			 le16_to_cpu(req->ext_tqp_num);
 	hdev->pkt_buf_size = le16_to_cpu(req->buf_size) << HCLGE_BUF_UNIT_S;
 
 	if (req->tx_buf_size)
@@ -1598,8 +1599,20 @@ static int hclge_alloc_tqps(struct hclge_dev *hdev)
 		tqp->q.buf_size = hdev->rx_buf_len;
 		tqp->q.tx_desc_num = hdev->num_tx_desc;
 		tqp->q.rx_desc_num = hdev->num_rx_desc;
-		tqp->q.io_base = hdev->hw.io_base + HCLGE_TQP_REG_OFFSET +
-			i * HCLGE_TQP_REG_SIZE;
+
+		/* need an extended offset to configure queues >=
+		 * HCLGE_TQP_MAX_SIZE_DEV_V2
+		 */
+		if (i < HCLGE_TQP_MAX_SIZE_DEV_V2)
+			tqp->q.io_base = hdev->hw.io_base +
+					 HCLGE_TQP_REG_OFFSET +
+					 i * HCLGE_TQP_REG_SIZE;
+		else
+			tqp->q.io_base = hdev->hw.io_base +
+					 HCLGE_TQP_REG_OFFSET +
+					 HCLGE_TQP_EXT_REG_OFFSET +
+					 (i - HCLGE_TQP_MAX_SIZE_DEV_V2) *
+					 HCLGE_TQP_REG_SIZE;
 
 		tqp++;
 	}
@@ -6852,7 +6865,7 @@ static int hclge_tqp_enable(struct hclge_dev *hdev, unsigned int tqp_id,
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CFG_COM_TQP_QUEUE, false);
-	req->tqp_id = cpu_to_le16(tqp_id & HCLGE_RING_ID_MASK);
+	req->tqp_id = cpu_to_le16(tqp_id);
 	req->stream_id = cpu_to_le16(stream_id);
 	if (enable)
 		req->enable |= 1U << HCLGE_TQP_ENABLE_B;
@@ -9314,7 +9327,7 @@ static int hclge_send_reset_tqp_cmd(struct hclge_dev *hdev, u16 queue_id,
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RESET_TQP_QUEUE, false);
 
 	req = (struct hclge_reset_tqp_queue_cmd *)desc.data;
-	req->tqp_id = cpu_to_le16(queue_id & HCLGE_RING_ID_MASK);
+	req->tqp_id = cpu_to_le16(queue_id);
 	if (enable)
 		hnae3_set_bit(req->reset_req, HCLGE_TQP_RESET_B, 1U);
 
@@ -9337,7 +9350,7 @@ static int hclge_get_reset_status(struct hclge_dev *hdev, u16 queue_id)
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RESET_TQP_QUEUE, true);
 
 	req = (struct hclge_reset_tqp_queue_cmd *)desc.data;
-	req->tqp_id = cpu_to_le16(queue_id & HCLGE_RING_ID_MASK);
+	req->tqp_id = cpu_to_le16(queue_id);
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index e8495f5..b50b079 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -302,12 +302,30 @@ static int hclge_tm_q_to_qs_map_cfg(struct hclge_dev *hdev,
 {
 	struct hclge_nq_to_qs_link_cmd *map;
 	struct hclge_desc desc;
+	u16 qs_id_l;
+	u16 qs_id_h;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_NQ_TO_QS_LINK, false);
 
 	map = (struct hclge_nq_to_qs_link_cmd *)desc.data;
 
 	map->nq_id = cpu_to_le16(q_id);
+
+	/* convert qs_id to the following format to support qset_id >= 1024
+	 * qs_id: | 15 | 14 ~ 10 |  9 ~ 0   |
+	 *            /         / \         \
+	 *           /         /   \         \
+	 * qset_id: | 15 ~ 11 |  10 |  9 ~ 0  |
+	 *          | qs_id_h | vld | qs_id_l |
+	 */
+	qs_id_l = hnae3_get_field(qs_id, HCLGE_TM_QS_ID_L_MSK,
+				  HCLGE_TM_QS_ID_L_S);
+	qs_id_h = hnae3_get_field(qs_id, HCLGE_TM_QS_ID_H_MSK,
+				  HCLGE_TM_QS_ID_H_S);
+	hnae3_set_field(qs_id, HCLGE_TM_QS_ID_L_MSK, HCLGE_TM_QS_ID_L_S,
+			qs_id_l);
+	hnae3_set_field(qs_id, HCLGE_TM_QS_ID_H_EXT_MSK, HCLGE_TM_QS_ID_H_EXT_S,
+			qs_id_h);
 	map->qset_id = cpu_to_le16(qs_id | HCLGE_TM_Q_QS_LINK_VLD_MSK);
 
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
@@ -1296,15 +1314,23 @@ static int hclge_pfc_setup_hw(struct hclge_dev *hdev)
 				      hdev->tm_info.pfc_en);
 }
 
-/* Each Tc has a 1024 queue sets to backpress, it divides to
- * 32 group, each group contains 32 queue sets, which can be
- * represented by u32 bitmap.
+/* for the queues that use for backpress, divides to several groups,
+ * each group contains 32 queue sets, which can be represented by u32 bitmap.
  */
 static int hclge_bp_setup_hw(struct hclge_dev *hdev, u8 tc)
 {
+	u16 grp_id_shift = HCLGE_BP_GRP_ID_S;
+	u16 grp_id_mask = HCLGE_BP_GRP_ID_M;
+	u8 grp_num = HCLGE_BP_GRP_NUM;
 	int i;
 
-	for (i = 0; i < HCLGE_BP_GRP_NUM; i++) {
+	if (hdev->num_tqps > HCLGE_TQP_MAX_SIZE_DEV_V2) {
+		grp_num = HCLGE_BP_EXT_GRP_NUM;
+		grp_id_mask = HCLGE_BP_EXT_GRP_ID_M;
+		grp_id_shift = HCLGE_BP_EXT_GRP_ID_S;
+	}
+
+	for (i = 0; i < grp_num; i++) {
 		u32 qs_bitmap = 0;
 		int k, ret;
 
@@ -1313,8 +1339,7 @@ static int hclge_bp_setup_hw(struct hclge_dev *hdev, u8 tc)
 			u16 qs_id = vport->qs_offset + tc;
 			u8 grp, sub_grp;
 
-			grp = hnae3_get_field(qs_id, HCLGE_BP_GRP_ID_M,
-					      HCLGE_BP_GRP_ID_S);
+			grp = hnae3_get_field(qs_id, grp_id_mask, grp_id_shift);
 			sub_grp = hnae3_get_field(qs_id, HCLGE_BP_SUB_GRP_ID_M,
 						  HCLGE_BP_SUB_GRP_ID_S);
 			if (i == grp)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index bb2a2d8..42c2270 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -39,6 +39,12 @@ struct hclge_nq_to_qs_link_cmd {
 	__le16 nq_id;
 	__le16 rsvd;
 #define HCLGE_TM_Q_QS_LINK_VLD_MSK	BIT(10)
+#define HCLGE_TM_QS_ID_L_MSK		GENMASK(9, 0)
+#define HCLGE_TM_QS_ID_L_S		0
+#define HCLGE_TM_QS_ID_H_MSK		GENMASK(14, 10)
+#define HCLGE_TM_QS_ID_H_S		10
+#define HCLGE_TM_QS_ID_H_EXT_S		11
+#define HCLGE_TM_QS_ID_H_EXT_MSK	GENMASK(15, 11)
 	__le16 qset_id;
 };
 
@@ -109,6 +115,11 @@ struct hclge_qs_shapping_cmd {
 #define HCLGE_BP_SUB_GRP_ID_M		GENMASK(4, 0)
 #define HCLGE_BP_GRP_ID_S		5
 #define HCLGE_BP_GRP_ID_M		GENMASK(9, 5)
+
+#define HCLGE_BP_EXT_GRP_NUM		40
+#define HCLGE_BP_EXT_GRP_ID_S		5
+#define HCLGE_BP_EXT_GRP_ID_M		GENMASK(10, 5)
+
 struct hclge_bp_to_qs_map_cmd {
 	u8 tc_id;
 	u8 rsvd[2];
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index f94f5d4..8b34a63 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -111,6 +111,9 @@ enum hclgevf_opcode_type {
 #define HCLGEVF_TQP_REG_OFFSET		0x80000
 #define HCLGEVF_TQP_REG_SIZE		0x200
 
+#define HCLGEVF_TQP_MAX_SIZE_DEV_V2	1024
+#define HCLGEVF_TQP_EXT_REG_OFFSET	0x100
+
 struct hclgevf_tqp_map {
 	__le16 tqp_id;	/* Absolute tqp id for in this pf */
 	u8 tqp_vf; /* VF id */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 71007e7..5ac5c35 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -403,8 +403,20 @@ static int hclgevf_alloc_tqps(struct hclgevf_dev *hdev)
 		tqp->q.buf_size = hdev->rx_buf_len;
 		tqp->q.tx_desc_num = hdev->num_tx_desc;
 		tqp->q.rx_desc_num = hdev->num_rx_desc;
-		tqp->q.io_base = hdev->hw.io_base + HCLGEVF_TQP_REG_OFFSET +
-			i * HCLGEVF_TQP_REG_SIZE;
+
+		/* need an extended offset to configure queues >=
+		 * HCLGEVF_TQP_MAX_SIZE_DEV_V2.
+		 */
+		if (i < HCLGEVF_TQP_MAX_SIZE_DEV_V2)
+			tqp->q.io_base = hdev->hw.io_base +
+					 HCLGEVF_TQP_REG_OFFSET +
+					 i * HCLGEVF_TQP_REG_SIZE;
+		else
+			tqp->q.io_base = hdev->hw.io_base +
+					 HCLGEVF_TQP_REG_OFFSET +
+					 HCLGEVF_TQP_EXT_REG_OFFSET +
+					 (i - HCLGEVF_TQP_MAX_SIZE_DEV_V2) *
+					 HCLGEVF_TQP_REG_SIZE;
 
 		tqp++;
 	}
-- 
2.7.4

