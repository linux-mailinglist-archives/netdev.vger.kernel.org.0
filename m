Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12623389B4C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhETCXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:17 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3431 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhETCXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:17 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Flthr0JyzzCs2R;
        Thu, 20 May 2021 10:19:08 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:55 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:54 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Hao Chen <chenhao288@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 05/15] net: hns3: refactor dump fd tcam of debugfs
Date:   Thu, 20 May 2021 10:21:34 +0800
Message-ID: <1621477304-4495-6-git-send-email-tanhuazhong@huawei.com>
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

From: Hao Chen <chenhao288@hisilicon.com>

Currently, the debugfs command for fd tcam is implemented by
"echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create a single file
"fd_tcam" for it, and query it by command "cat fd_tcam",
return the result to userspace, rather than record in dmesg.

The display style is below:
$ cat fd_tcam
read result tcam key x(31):
00000000
00000000
00000000
08000000
00000600
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
read result tcam key y(31):
00000000
00000000
00000000
f7ff0000
0000f900
00000000
00000000
00000000
00000000
00000000
00000000
00000000
0000fff8

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 11 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 88 ++++++++++++++--------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |  5 ++
 5 files changed, 74 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index f4c8796..730f56d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -279,6 +279,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_QUEUE_MAP,
 	HNAE3_DBG_CMD_RX_QUEUE_INFO,
 	HNAE3_DBG_CMD_TX_QUEUE_INFO,
+	HNAE3_DBG_CMD_FD_TCAM,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 93455c7..37aa891 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -29,6 +29,9 @@ static struct hns3_dbg_dentry_info hns3_dbg_dentry[] = {
 	{
 		.name = "queue"
 	},
+	{
+		.name = "fd"
+	},
 	/* keep common at the bottom and add new directory above */
 	{
 		.name = "common"
@@ -236,6 +239,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN_1MB,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "fd_tcam",
+		.cmd = HNAE3_DBG_CMD_FD_TCAM,
+		.dentry = HNS3_DBG_DENTRY_FD,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -707,7 +717,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	if (!hns3_is_phys_func(h->pdev))
 		return;
 
-	dev_info(&h->pdev->dev, "dump fd tcam\n");
 	dev_info(&h->pdev->dev, "dump tc\n");
 	dev_info(&h->pdev->dev, "dump tm map <q_num>\n");
 	dev_info(&h->pdev->dev, "dump tm\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index 0e109b0..f3766ff 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -32,6 +32,7 @@ enum hns3_dbg_dentry_type {
 	HNS3_DBG_DENTRY_MAC,
 	HNS3_DBG_DENTRY_REG,
 	HNS3_DBG_DENTRY_QUEUE,
+	HNS3_DBG_DENTRY_FD,
 	HNS3_DBG_DENTRY_COMMON,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 1ad7bff..c92800d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1455,13 +1455,17 @@ static int hclge_dbg_dump_mng_table(struct hclge_dev *hdev, char *buf, int len)
 	return 0;
 }
 
-static int hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
-				  bool sel_x, u32 loc)
+#define HCLGE_DBG_TCAM_BUF_SIZE 256
+
+static int hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, bool sel_x,
+				  char *tcam_buf,
+				  struct hclge_dbg_tcam_msg tcam_msg)
 {
 	struct hclge_fd_tcam_config_1_cmd *req1;
 	struct hclge_fd_tcam_config_2_cmd *req2;
 	struct hclge_fd_tcam_config_3_cmd *req3;
 	struct hclge_desc desc[3];
+	int pos = 0;
 	int ret, i;
 	u32 *req;
 
@@ -1475,31 +1479,35 @@ static int hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
 	req2 = (struct hclge_fd_tcam_config_2_cmd *)desc[1].data;
 	req3 = (struct hclge_fd_tcam_config_3_cmd *)desc[2].data;
 
-	req1->stage  = stage;
+	req1->stage  = tcam_msg.stage;
 	req1->xy_sel = sel_x ? 1 : 0;
-	req1->index  = cpu_to_le32(loc);
+	req1->index  = cpu_to_le32(tcam_msg.loc);
 
 	ret = hclge_cmd_send(&hdev->hw, desc, 3);
 	if (ret)
 		return ret;
 
-	dev_info(&hdev->pdev->dev, " read result tcam key %s(%u):\n",
-		 sel_x ? "x" : "y", loc);
+	pos += scnprintf(tcam_buf + pos, HCLGE_DBG_TCAM_BUF_SIZE - pos,
+			 "read result tcam key %s(%u):\n", sel_x ? "x" : "y",
+			 tcam_msg.loc);
 
 	/* tcam_data0 ~ tcam_data1 */
 	req = (u32 *)req1->tcam_data;
 	for (i = 0; i < 2; i++)
-		dev_info(&hdev->pdev->dev, "%08x\n", *req++);
+		pos += scnprintf(tcam_buf + pos, HCLGE_DBG_TCAM_BUF_SIZE - pos,
+				 "%08x\n", *req++);
 
 	/* tcam_data2 ~ tcam_data7 */
 	req = (u32 *)req2->tcam_data;
 	for (i = 0; i < 6; i++)
-		dev_info(&hdev->pdev->dev, "%08x\n", *req++);
+		pos += scnprintf(tcam_buf + pos, HCLGE_DBG_TCAM_BUF_SIZE - pos,
+				 "%08x\n", *req++);
 
 	/* tcam_data8 ~ tcam_data12 */
 	req = (u32 *)req3->tcam_data;
 	for (i = 0; i < 5; i++)
-		dev_info(&hdev->pdev->dev, "%08x\n", *req++);
+		pos += scnprintf(tcam_buf + pos, HCLGE_DBG_TCAM_BUF_SIZE - pos,
+				 "%08x\n", *req++);
 
 	return ret;
 }
@@ -1517,59 +1525,75 @@ static int hclge_dbg_get_rules_location(struct hclge_dev *hdev, u16 *rule_locs)
 	}
 	spin_unlock_bh(&hdev->fd_rule_lock);
 
-	if (cnt != hdev->hclge_fd_rule_num)
+	if (cnt != hdev->hclge_fd_rule_num || cnt == 0)
 		return -EINVAL;
 
 	return cnt;
 }
 
-static void hclge_dbg_fd_tcam(struct hclge_dev *hdev)
+static int hclge_dbg_dump_fd_tcam(struct hclge_dev *hdev, char *buf, int len)
 {
+	u32 rule_num = hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1];
+	struct hclge_dbg_tcam_msg tcam_msg;
 	int i, ret, rule_cnt;
 	u16 *rule_locs;
+	char *tcam_buf;
+	int pos = 0;
 
 	if (!hnae3_dev_fd_supported(hdev)) {
 		dev_err(&hdev->pdev->dev,
 			"Only FD-supported dev supports dump fd tcam\n");
-		return;
+		return -EOPNOTSUPP;
 	}
 
-	if (!hdev->hclge_fd_rule_num ||
-	    !hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1])
-		return;
+	if (!hdev->hclge_fd_rule_num || !rule_num)
+		return 0;
 
-	rule_locs = kcalloc(hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1],
-			    sizeof(u16), GFP_KERNEL);
+	rule_locs = kcalloc(rule_num, sizeof(u16), GFP_KERNEL);
 	if (!rule_locs)
-		return;
+		return -ENOMEM;
+
+	tcam_buf = kzalloc(HCLGE_DBG_TCAM_BUF_SIZE, GFP_KERNEL);
+	if (!tcam_buf) {
+		kfree(rule_locs);
+		return -ENOMEM;
+	}
 
 	rule_cnt = hclge_dbg_get_rules_location(hdev, rule_locs);
-	if (rule_cnt <= 0) {
+	if (rule_cnt < 0) {
+		ret = rule_cnt;
 		dev_err(&hdev->pdev->dev,
-			"failed to get rule number, ret = %d\n", rule_cnt);
-		kfree(rule_locs);
-		return;
+			"failed to get rule number, ret = %d\n", ret);
+		goto out;
 	}
 
 	for (i = 0; i < rule_cnt; i++) {
-		ret = hclge_dbg_fd_tcam_read(hdev, 0, true, rule_locs[i]);
+		tcam_msg.stage = HCLGE_FD_STAGE_1;
+		tcam_msg.loc = rule_locs[i];
+
+		ret = hclge_dbg_fd_tcam_read(hdev, true, tcam_buf, tcam_msg);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
 				"failed to get fd tcam key x, ret = %d\n", ret);
-			kfree(rule_locs);
-			return;
+			goto out;
 		}
 
-		ret = hclge_dbg_fd_tcam_read(hdev, 0, false, rule_locs[i]);
+		pos += scnprintf(buf + pos, len - pos, "%s", tcam_buf);
+
+		ret = hclge_dbg_fd_tcam_read(hdev, false, tcam_buf, tcam_msg);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
 				"failed to get fd tcam key y, ret = %d\n", ret);
-			kfree(rule_locs);
-			return;
+			goto out;
 		}
+
+		pos += scnprintf(buf + pos, len - pos, "%s", tcam_buf);
 	}
 
+out:
+	kfree(tcam_buf);
 	kfree(rule_locs);
+	return ret;
 }
 
 int hclge_dbg_dump_rst_info(struct hclge_dev *hdev, char *buf, int len)
@@ -1994,9 +2018,7 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	if (strncmp(cmd_buf, "dump fd tcam", 12) == 0) {
-		hclge_dbg_fd_tcam(hdev);
-	} else if (strncmp(cmd_buf, "dump tc", 7) == 0) {
+	if (strncmp(cmd_buf, "dump tc", 7) == 0) {
 		hclge_dbg_dump_tc(hdev);
 	} else if (strncmp(cmd_buf, DUMP_TM_MAP, strlen(DUMP_TM_MAP)) == 0) {
 		hclge_dbg_dump_tm_map(hdev, &cmd_buf[sizeof(DUMP_TM_MAP)]);
@@ -2112,6 +2134,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_REG_DCB,
 		.dbg_dump = hclge_dbg_dump_dcb,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_FD_TCAM,
+		.dbg_dump = hclge_dbg_dump_fd_tcam,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index 933f157..25b42da 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -69,6 +69,11 @@ struct hclge_dbg_reg_common_msg {
 	enum hclge_opcode_type cmd;
 };
 
+struct hclge_dbg_tcam_msg {
+	u8 stage;
+	u32 loc;
+};
+
 #define	HCLGE_DBG_MAX_DFX_MSG_LEN	60
 struct hclge_dbg_dfx_message {
 	int flag;
-- 
2.7.4

