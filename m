Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5795ACD8F
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 10:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237344AbiIEISt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 04:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237183AbiIEISV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 04:18:21 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F8831359;
        Mon,  5 Sep 2022 01:18:18 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MLhD04VR6znV1N;
        Mon,  5 Sep 2022 16:15:44 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 16:18:16 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 16:18:13 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 3/5] net: hns3: debugfs add dump dscp map info
Date:   Mon, 5 Sep 2022 16:15:37 +0800
Message-ID: <20220905081539.62131-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220905081539.62131-1-huangguangbin2@huawei.com>
References: <20220905081539.62131-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add dump the map relation for dscp, priority and TC, and
the current tc map mode.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  7 +++
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 60 ++++++++++++++++++-
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 33b5ac47f342..9ae094189d3a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -272,6 +272,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_TC_SCH_INFO,
 	HNAE3_DBG_CMD_QOS_PAUSE_CFG,
 	HNAE3_DBG_CMD_QOS_PRI_MAP,
+	HNAE3_DBG_CMD_QOS_DSCP_MAP,
 	HNAE3_DBG_CMD_QOS_BUF_CFG,
 	HNAE3_DBG_CMD_DEV_INFO,
 	HNAE3_DBG_CMD_TX_BD,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 93aeb615191d..0f8f5c466871 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -105,6 +105,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "qos_dscp_map",
+		.cmd = HNAE3_DBG_CMD_QOS_DSCP_MAP,
+		.dentry = HNS3_DBG_DENTRY_TM,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 	{
 		.name = "qos_buf_cfg",
 		.cmd = HNAE3_DBG_CMD_QOS_BUF_CFG,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 59121767a853..55f696d071e5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -14,6 +14,8 @@ static const char * const hclge_mac_state_str[] = {
 	"TO_ADD", "TO_DEL", "ACTIVE"
 };
 
+static const char * const tc_map_mode_str[] = { "PRIO", "DSCP" };
+
 static const struct hclge_dbg_reg_type_info hclge_dbg_reg_info[] = {
 	{ .cmd = HNAE3_DBG_CMD_REG_BIOS_COMMON,
 	  .dfx_msg = &hclge_dbg_bios_common_reg[0],
@@ -1115,10 +1117,11 @@ static int hclge_dbg_dump_qos_pause_cfg(struct hclge_dev *hdev, char *buf,
 	return 0;
 }
 
+#define HCLGE_DBG_TC_MASK		0x0F
+
 static int hclge_dbg_dump_qos_pri_map(struct hclge_dev *hdev, char *buf,
 				      int len)
 {
-#define HCLGE_DBG_TC_MASK		0x0F
 #define HCLGE_DBG_TC_BIT_WIDTH		4
 
 	struct hclge_qos_pri_map_cmd *pri_map;
@@ -1152,6 +1155,57 @@ static int hclge_dbg_dump_qos_pri_map(struct hclge_dev *hdev, char *buf,
 	return 0;
 }
 
+static int hclge_dbg_dump_qos_dscp_map(struct hclge_dev *hdev, char *buf,
+				       int len)
+{
+	struct hclge_desc desc[HCLGE_DSCP_MAP_TC_BD_NUM];
+	u8 *req0 = (u8 *)desc[0].data;
+	u8 *req1 = (u8 *)desc[1].data;
+	u8 dscp_tc[HCLGE_MAX_DSCP];
+	int pos, ret;
+	u8 i, j;
+
+	pos = scnprintf(buf, len, "tc map mode: %s\n",
+			tc_map_mode_str[hdev->vport[0].nic.kinfo.tc_map_mode]);
+
+	if (hdev->vport[0].nic.kinfo.tc_map_mode != HNAE3_TC_MAP_MODE_DSCP)
+		return 0;
+
+	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_QOS_MAP, true);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
+	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_QOS_MAP, true);
+	ret = hclge_cmd_send(&hdev->hw, desc, HCLGE_DSCP_MAP_TC_BD_NUM);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump qos dscp map, ret = %d\n", ret);
+		return ret;
+	}
+
+	pos += scnprintf(buf + pos, len - pos, "\nDSCP  PRIO  TC\n");
+
+	/* The low 32 dscp setting use bd0, high 32 dscp setting use bd1 */
+	for (i = 0; i < HCLGE_MAX_DSCP / HCLGE_DSCP_MAP_TC_BD_NUM; i++) {
+		j = i + HCLGE_MAX_DSCP / HCLGE_DSCP_MAP_TC_BD_NUM;
+		/* Each dscp setting has 4 bits, so each byte saves two dscp
+		 * setting
+		 */
+		dscp_tc[i] = req0[i >> 1] >> HCLGE_DSCP_TC_SHIFT(i);
+		dscp_tc[j] = req1[i >> 1] >> HCLGE_DSCP_TC_SHIFT(i);
+		dscp_tc[i] &= HCLGE_DBG_TC_MASK;
+		dscp_tc[j] &= HCLGE_DBG_TC_MASK;
+	}
+
+	for (i = 0; i < HCLGE_MAX_DSCP; i++) {
+		if (hdev->tm_info.dscp_prio[i] == HCLGE_PRIO_ID_INVALID)
+			continue;
+
+		pos += scnprintf(buf + pos, len - pos, " %2u    %u    %u\n",
+				 i, hdev->tm_info.dscp_prio[i], dscp_tc[i]);
+	}
+
+	return 0;
+}
+
 static int hclge_dbg_dump_tx_buf_cfg(struct hclge_dev *hdev, char *buf, int len)
 {
 	struct hclge_tx_buff_alloc_cmd *tx_buf_cmd;
@@ -2376,6 +2430,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_QOS_PRI_MAP,
 		.dbg_dump = hclge_dbg_dump_qos_pri_map,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_QOS_DSCP_MAP,
+		.dbg_dump = hclge_dbg_dump_qos_dscp_map,
+	},
 	{
 		.cmd = HNAE3_DBG_CMD_QOS_BUF_CFG,
 		.dbg_dump = hclge_dbg_dump_qos_buf_cfg,
-- 
2.33.0

