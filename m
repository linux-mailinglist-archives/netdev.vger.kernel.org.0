Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191CE389B59
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhETCXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:37 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4757 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhETCXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:18 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Flth11K81zpfGB;
        Thu, 20 May 2021 10:18:25 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:54 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:54 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 01/15] net: hns3: refactor dump reg of debugfs
Date:   Thu, 20 May 2021 10:21:30 +0800
Message-ID: <1621477304-4495-2-git-send-email-tanhuazhong@huawei.com>
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

From: Yufeng Mo <moyufeng@huawei.com>

Currently, the debugfs command for reg is implemented by
"echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create some files
"bios_common/ssu/igu_egu/rpu/ncsi/rtc/ppp/rcb/tqp/mac" for it,
and query it by command "cat xxx", return the result to
userspace, rather than record in dmesg.

The display style is below:
$ cat bios_common
BP_CPU_STATE: 0x0
DFX_MSIX_INFO_NIC_0: 0xc000
DFX_MSIX_INFO_NIC_1: 0x0
DFX_MSIX_INFO_NIC_2: 0x0
DFX_MSIX_INFO_NIC_3: 0x0
DFX_MSIX_INFO_ROC_0: 0xc000
DFX_MSIX_INFO_ROC_1: 0x0
DFX_MSIX_INFO_ROC_2: 0x0
DFX_MSIX_INFO_ROC_3: 0x0

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  10 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  84 ++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 356 ++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |   4 +-
 5 files changed, 321 insertions(+), 134 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index d1cdb74..9ef4132 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -265,6 +265,16 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_RESET_INFO,
 	HNAE3_DBG_CMD_IMP_INFO,
 	HNAE3_DBG_CMD_NCL_CONFIG,
+	HNAE3_DBG_CMD_REG_BIOS_COMMON,
+	HNAE3_DBG_CMD_REG_SSU,
+	HNAE3_DBG_CMD_REG_IGU_EGU,
+	HNAE3_DBG_CMD_REG_RPU,
+	HNAE3_DBG_CMD_REG_NCSI,
+	HNAE3_DBG_CMD_REG_RTC,
+	HNAE3_DBG_CMD_REG_PPP,
+	HNAE3_DBG_CMD_REG_RCB,
+	HNAE3_DBG_CMD_REG_TQP,
+	HNAE3_DBG_CMD_REG_MAC,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index ba4ee8c..af0751e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -23,6 +23,9 @@ static struct hns3_dbg_dentry_info hns3_dbg_dentry[] = {
 	{
 		.name = "mac_list"
 	},
+	{
+		.name = "reg"
+	},
 	/* keep common at the bottom and add new directory above */
 	{
 		.name = "common"
@@ -132,6 +135,76 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN_128KB,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "bios_common",
+		.cmd = HNAE3_DBG_CMD_REG_BIOS_COMMON,
+		.dentry = HNS3_DBG_DENTRY_REG,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "ssu",
+		.cmd = HNAE3_DBG_CMD_REG_SSU,
+		.dentry = HNS3_DBG_DENTRY_REG,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "igu_egu",
+		.cmd = HNAE3_DBG_CMD_REG_IGU_EGU,
+		.dentry = HNS3_DBG_DENTRY_REG,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "rpu",
+		.cmd = HNAE3_DBG_CMD_REG_RPU,
+		.dentry = HNS3_DBG_DENTRY_REG,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "ncsi",
+		.cmd = HNAE3_DBG_CMD_REG_NCSI,
+		.dentry = HNS3_DBG_DENTRY_REG,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "rtc",
+		.cmd = HNAE3_DBG_CMD_REG_RTC,
+		.dentry = HNS3_DBG_DENTRY_REG,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "ppp",
+		.cmd = HNAE3_DBG_CMD_REG_PPP,
+		.dentry = HNS3_DBG_DENTRY_REG,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "rcb",
+		.cmd = HNAE3_DBG_CMD_REG_RCB,
+		.dentry = HNS3_DBG_DENTRY_REG,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "tqp",
+		.cmd = HNAE3_DBG_CMD_REG_TQP,
+		.dentry = HNS3_DBG_DENTRY_REG,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "mac",
+		.cmd = HNAE3_DBG_CMD_REG_MAC,
+		.dentry = HNS3_DBG_DENTRY_REG,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -530,17 +603,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump qs shaper [qs id]\n");
 
 	memset(printf_buf, 0, HNS3_DBG_BUF_LEN);
-	strncat(printf_buf, "dump reg [[bios common] [ssu <port_id>]",
-		HNS3_DBG_BUF_LEN - 1);
-	strncat(printf_buf + strlen(printf_buf),
-		" [igu egu <port_id>] [rpu <tc_queue_num>]",
-		HNS3_DBG_BUF_LEN - strlen(printf_buf) - 1);
-	strncat(printf_buf + strlen(printf_buf),
-		" [rtc] [ppp] [rcb] [tqp <queue_num>] [mac]]\n",
-		HNS3_DBG_BUF_LEN - strlen(printf_buf) - 1);
-	dev_info(&h->pdev->dev, "%s", printf_buf);
-
-	memset(printf_buf, 0, HNS3_DBG_BUF_LEN);
 	strncat(printf_buf, "dump reg dcb <port_id> <pri_id> <pg_id>",
 		HNS3_DBG_BUF_LEN - 1);
 	strncat(printf_buf + strlen(printf_buf), " <rq_id> <nq_id> <qset_id>\n",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index a7af927..6060bfc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -29,6 +29,7 @@ enum hns3_dbg_dentry_type {
 	HNS3_DBG_DENTRY_TX_BD,
 	HNS3_DBG_DENTRY_RX_BD,
 	HNS3_DBG_DENTRY_MAC,
+	HNS3_DBG_DENTRY_REG,
 	HNS3_DBG_DENTRY_COMMON,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 8a92ab4..2f666289 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -15,62 +15,62 @@ static const char * const hclge_mac_state_str[] = {
 };
 
 static const struct hclge_dbg_reg_type_info hclge_dbg_reg_info[] = {
-	{ .reg_type = "bios common",
+	{ .cmd = HNAE3_DBG_CMD_REG_BIOS_COMMON,
 	  .dfx_msg = &hclge_dbg_bios_common_reg[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_bios_common_reg),
 		       .offset = HCLGE_DBG_DFX_BIOS_OFFSET,
 		       .cmd = HCLGE_OPC_DFX_BIOS_COMMON_REG } },
-	{ .reg_type = "ssu",
+	{ .cmd = HNAE3_DBG_CMD_REG_SSU,
 	  .dfx_msg = &hclge_dbg_ssu_reg_0[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_ssu_reg_0),
 		       .offset = HCLGE_DBG_DFX_SSU_0_OFFSET,
 		       .cmd = HCLGE_OPC_DFX_SSU_REG_0 } },
-	{ .reg_type = "ssu",
+	{ .cmd = HNAE3_DBG_CMD_REG_SSU,
 	  .dfx_msg = &hclge_dbg_ssu_reg_1[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_ssu_reg_1),
 		       .offset = HCLGE_DBG_DFX_SSU_1_OFFSET,
 		       .cmd = HCLGE_OPC_DFX_SSU_REG_1 } },
-	{ .reg_type = "ssu",
+	{ .cmd = HNAE3_DBG_CMD_REG_SSU,
 	  .dfx_msg = &hclge_dbg_ssu_reg_2[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_ssu_reg_2),
 		       .offset = HCLGE_DBG_DFX_SSU_2_OFFSET,
 		       .cmd = HCLGE_OPC_DFX_SSU_REG_2 } },
-	{ .reg_type = "igu egu",
+	{ .cmd = HNAE3_DBG_CMD_REG_IGU_EGU,
 	  .dfx_msg = &hclge_dbg_igu_egu_reg[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_igu_egu_reg),
 		       .offset = HCLGE_DBG_DFX_IGU_OFFSET,
 		       .cmd = HCLGE_OPC_DFX_IGU_EGU_REG } },
-	{ .reg_type = "rpu",
+	{ .cmd = HNAE3_DBG_CMD_REG_RPU,
 	  .dfx_msg = &hclge_dbg_rpu_reg_0[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_rpu_reg_0),
 		       .offset = HCLGE_DBG_DFX_RPU_0_OFFSET,
 		       .cmd = HCLGE_OPC_DFX_RPU_REG_0 } },
-	{ .reg_type = "rpu",
+	{ .cmd = HNAE3_DBG_CMD_REG_RPU,
 	  .dfx_msg = &hclge_dbg_rpu_reg_1[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_rpu_reg_1),
 		       .offset = HCLGE_DBG_DFX_RPU_1_OFFSET,
 		       .cmd = HCLGE_OPC_DFX_RPU_REG_1 } },
-	{ .reg_type = "ncsi",
+	{ .cmd = HNAE3_DBG_CMD_REG_NCSI,
 	  .dfx_msg = &hclge_dbg_ncsi_reg[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_ncsi_reg),
 		       .offset = HCLGE_DBG_DFX_NCSI_OFFSET,
 		       .cmd = HCLGE_OPC_DFX_NCSI_REG } },
-	{ .reg_type = "rtc",
+	{ .cmd = HNAE3_DBG_CMD_REG_RTC,
 	  .dfx_msg = &hclge_dbg_rtc_reg[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_rtc_reg),
 		       .offset = HCLGE_DBG_DFX_RTC_OFFSET,
 		       .cmd = HCLGE_OPC_DFX_RTC_REG } },
-	{ .reg_type = "ppp",
+	{ .cmd = HNAE3_DBG_CMD_REG_PPP,
 	  .dfx_msg = &hclge_dbg_ppp_reg[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_ppp_reg),
 		       .offset = HCLGE_DBG_DFX_PPP_OFFSET,
 		       .cmd = HCLGE_OPC_DFX_PPP_REG } },
-	{ .reg_type = "rcb",
+	{ .cmd = HNAE3_DBG_CMD_REG_RCB,
 	  .dfx_msg = &hclge_dbg_rcb_reg[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_rcb_reg),
 		       .offset = HCLGE_DBG_DFX_RCB_OFFSET,
 		       .cmd = HCLGE_OPC_DFX_RCB_REG } },
-	{ .reg_type = "tqp",
+	{ .cmd = HNAE3_DBG_CMD_REG_TQP,
 	  .dfx_msg = &hclge_dbg_tqp_reg[0],
 	  .reg_msg = { .msg_num = ARRAY_SIZE(hclge_dbg_tqp_reg),
 		       .offset = HCLGE_DBG_DFX_TQP_OFFSET,
@@ -106,7 +106,8 @@ static char *hclge_dbg_get_func_id_str(char *buf, u8 id)
 	return buf;
 }
 
-static int hclge_dbg_get_dfx_bd_num(struct hclge_dev *hdev, int offset)
+static int hclge_dbg_get_dfx_bd_num(struct hclge_dev *hdev, int offset,
+				    u32 *bd_num)
 {
 	struct hclge_desc desc[HCLGE_GET_DFX_REG_TYPE_CNT];
 	int entries_per_desc;
@@ -116,13 +117,21 @@ static int hclge_dbg_get_dfx_bd_num(struct hclge_dev *hdev, int offset)
 	ret = hclge_query_bd_num_cmd_send(hdev, desc);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"get dfx bdnum fail, ret = %d\n", ret);
+			"failed to get dfx bd_num, offset = %d, ret = %d\n",
+			offset, ret);
 		return ret;
 	}
 
 	entries_per_desc = ARRAY_SIZE(desc[0].data);
 	index = offset % entries_per_desc;
-	return le32_to_cpu(desc[offset / entries_per_desc].data[index]);
+
+	*bd_num = le32_to_cpu(desc[offset / entries_per_desc].data[index]);
+	if (!(*bd_num)) {
+		dev_err(&hdev->pdev->dev, "The value of dfx bd_num is 0!\n");
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static int hclge_dbg_cmd_send(struct hclge_dev *hdev,
@@ -149,66 +158,108 @@ static int hclge_dbg_cmd_send(struct hclge_dev *hdev,
 	return ret;
 }
 
-static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
-				      const struct hclge_dbg_reg_type_info *reg_info,
-				      const char *cmd_buf)
+static int
+hclge_dbg_dump_reg_tqp(struct hclge_dev *hdev,
+		       const struct hclge_dbg_reg_type_info *reg_info,
+		       char *buf, int len, int *pos)
 {
-#define IDX_OFFSET	1
-
-	const char *s = &cmd_buf[strlen(reg_info->reg_type) + IDX_OFFSET];
 	const struct hclge_dbg_dfx_message *dfx_message = reg_info->dfx_msg;
 	const struct hclge_dbg_reg_common_msg *reg_msg = &reg_info->reg_msg;
 	struct hclge_desc *desc_src;
+	u32 index, entry, i, cnt;
+	int bd_num, min_num, ret;
 	struct hclge_desc *desc;
-	int entries_per_desc;
-	int bd_num, buf_len;
-	int index = 0;
-	int min_num;
-	int ret, i;
 
-	if (*s) {
-		ret = kstrtouint(s, 0, &index);
-		index = (ret != 0) ? 0 : index;
-	}
+	ret = hclge_dbg_get_dfx_bd_num(hdev, reg_msg->offset, &bd_num);
+	if (ret)
+		return ret;
 
-	bd_num = hclge_dbg_get_dfx_bd_num(hdev, reg_msg->offset);
-	if (bd_num <= 0) {
-		dev_err(&hdev->pdev->dev, "get cmd(%d) bd num(%d) failed\n",
-			reg_msg->offset, bd_num);
-		return;
+	desc_src = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
+	if (!desc_src)
+		return -ENOMEM;
+
+	min_num = min_t(int, bd_num * HCLGE_DESC_DATA_LEN, reg_msg->msg_num);
+
+	for (i = 0, cnt = 0; i < min_num; i++, dfx_message++)
+		*pos += scnprintf(buf + *pos, len - *pos, "item%u = %s\n",
+				  cnt++, dfx_message->message);
+
+	for (i = 0; i < cnt; i++)
+		*pos += scnprintf(buf + *pos, len - *pos, "item%u\t", i);
+
+	*pos += scnprintf(buf + *pos, len - *pos, "\n");
+
+	for (index = 0; index < hdev->vport[0].alloc_tqps; index++) {
+		dfx_message = reg_info->dfx_msg;
+		desc = desc_src;
+		ret = hclge_dbg_cmd_send(hdev, desc, index, bd_num,
+					 reg_msg->cmd);
+		if (ret)
+			break;
+
+		for (i = 0; i < min_num; i++, dfx_message++) {
+			entry = i % HCLGE_DESC_DATA_LEN;
+			if (i > 0 && !entry)
+				desc++;
+
+			*pos += scnprintf(buf + *pos, len - *pos, "%#x\t",
+					  le32_to_cpu(desc->data[entry]));
+		}
+		*pos += scnprintf(buf + *pos, len - *pos, "\n");
 	}
 
-	buf_len = sizeof(struct hclge_desc) * bd_num;
-	desc_src = kzalloc(buf_len, GFP_KERNEL);
+	kfree(desc_src);
+	return ret;
+}
+
+static int
+hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
+			  const struct hclge_dbg_reg_type_info *reg_info,
+			  char *buf, int len, int *pos)
+{
+	const struct hclge_dbg_reg_common_msg *reg_msg = &reg_info->reg_msg;
+	const struct hclge_dbg_dfx_message *dfx_message = reg_info->dfx_msg;
+	struct hclge_desc *desc_src;
+	int bd_num, min_num, ret;
+	struct hclge_desc *desc;
+	u32 entry, i;
+
+	ret = hclge_dbg_get_dfx_bd_num(hdev, reg_msg->offset, &bd_num);
+	if (ret)
+		return ret;
+
+	desc_src = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
 	if (!desc_src)
-		return;
+		return -ENOMEM;
 
 	desc = desc_src;
-	ret = hclge_dbg_cmd_send(hdev, desc, index, bd_num, reg_msg->cmd);
+
+	ret = hclge_dbg_cmd_send(hdev, desc, 0, bd_num, reg_msg->cmd);
 	if (ret) {
-		kfree(desc_src);
-		return;
+		kfree(desc);
+		return ret;
 	}
 
-	entries_per_desc = ARRAY_SIZE(desc->data);
-	min_num = min_t(int, bd_num * entries_per_desc, reg_msg->msg_num);
+	min_num = min_t(int, bd_num * HCLGE_DESC_DATA_LEN, reg_msg->msg_num);
 
-	desc = desc_src;
-	for (i = 0; i < min_num; i++) {
-		if (i > 0 && (i % entries_per_desc) == 0)
+	for (i = 0; i < min_num; i++, dfx_message++) {
+		entry = i % HCLGE_DESC_DATA_LEN;
+		if (i > 0 && !entry)
 			desc++;
-		if (dfx_message->flag)
-			dev_info(&hdev->pdev->dev, "%s: 0x%x\n",
-				 dfx_message->message,
-				 le32_to_cpu(desc->data[i % entries_per_desc]));
+		if (!dfx_message->flag)
+			continue;
 
-		dfx_message++;
+		*pos += scnprintf(buf + *pos, len - *pos, "%s: %#x\n",
+				  dfx_message->message,
+				  le32_to_cpu(desc->data[entry]));
 	}
 
 	kfree(desc_src);
+	return 0;
 }
 
-static void hclge_dbg_dump_mac_enable_status(struct hclge_dev *hdev)
+static int  hclge_dbg_dump_mac_enable_status(struct hclge_dev *hdev, char *buf,
+					     int len, int *pos)
 {
 	struct hclge_config_mac_mode_cmd *req;
 	struct hclge_desc desc;
@@ -221,43 +272,51 @@ static void hclge_dbg_dump_mac_enable_status(struct hclge_dev *hdev)
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to dump mac enable status, ret = %d\n", ret);
-		return;
+		return ret;
 	}
 
 	req = (struct hclge_config_mac_mode_cmd *)desc.data;
 	loop_en = le32_to_cpu(req->txrx_pad_fcs_loop_en);
 
-	dev_info(&hdev->pdev->dev, "config_mac_trans_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_TX_EN_B));
-	dev_info(&hdev->pdev->dev, "config_mac_rcv_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_RX_EN_B));
-	dev_info(&hdev->pdev->dev, "config_pad_trans_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_PAD_TX_B));
-	dev_info(&hdev->pdev->dev, "config_pad_rcv_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_PAD_RX_B));
-	dev_info(&hdev->pdev->dev, "config_1588_trans_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_1588_TX_B));
-	dev_info(&hdev->pdev->dev, "config_1588_rcv_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_1588_RX_B));
-	dev_info(&hdev->pdev->dev, "config_mac_app_loop_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_APP_LP_B));
-	dev_info(&hdev->pdev->dev, "config_mac_line_loop_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_LINE_LP_B));
-	dev_info(&hdev->pdev->dev, "config_mac_fcs_tx_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_FCS_TX_B));
-	dev_info(&hdev->pdev->dev, "config_mac_rx_oversize_truncate_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_RX_OVERSIZE_TRUNCATE_B));
-	dev_info(&hdev->pdev->dev, "config_mac_rx_fcs_strip_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_RX_FCS_STRIP_B));
-	dev_info(&hdev->pdev->dev, "config_mac_rx_fcs_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_RX_FCS_B));
-	dev_info(&hdev->pdev->dev, "config_mac_tx_under_min_err_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_TX_UNDER_MIN_ERR_B));
-	dev_info(&hdev->pdev->dev, "config_mac_tx_oversize_truncate_en: %#x\n",
-		 hnae3_get_bit(loop_en, HCLGE_MAC_TX_OVERSIZE_TRUNCATE_B));
+	*pos += scnprintf(buf + *pos, len - *pos, "mac_trans_en: %#x\n",
+			  hnae3_get_bit(loop_en, HCLGE_MAC_TX_EN_B));
+	*pos += scnprintf(buf + *pos, len - *pos, "mac_rcv_en: %#x\n",
+			  hnae3_get_bit(loop_en, HCLGE_MAC_RX_EN_B));
+	*pos += scnprintf(buf + *pos, len - *pos, "pad_trans_en: %#x\n",
+			  hnae3_get_bit(loop_en, HCLGE_MAC_PAD_TX_B));
+	*pos += scnprintf(buf + *pos, len - *pos, "pad_rcv_en: %#x\n",
+			  hnae3_get_bit(loop_en, HCLGE_MAC_PAD_RX_B));
+	*pos += scnprintf(buf + *pos, len - *pos, "1588_trans_en: %#x\n",
+			  hnae3_get_bit(loop_en, HCLGE_MAC_1588_TX_B));
+	*pos += scnprintf(buf + *pos, len - *pos, "1588_rcv_en: %#x\n",
+			  hnae3_get_bit(loop_en, HCLGE_MAC_1588_RX_B));
+	*pos += scnprintf(buf + *pos, len - *pos, "mac_app_loop_en: %#x\n",
+			  hnae3_get_bit(loop_en, HCLGE_MAC_APP_LP_B));
+	*pos += scnprintf(buf + *pos, len - *pos, "mac_line_loop_en: %#x\n",
+			  hnae3_get_bit(loop_en, HCLGE_MAC_LINE_LP_B));
+	*pos += scnprintf(buf + *pos, len - *pos, "mac_fcs_tx_en: %#x\n",
+			  hnae3_get_bit(loop_en, HCLGE_MAC_FCS_TX_B));
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "mac_rx_oversize_truncate_en: %#x\n",
+			  hnae3_get_bit(loop_en,
+					HCLGE_MAC_RX_OVERSIZE_TRUNCATE_B));
+	*pos += scnprintf(buf + *pos, len - *pos, "mac_rx_fcs_strip_en: %#x\n",
+			  hnae3_get_bit(loop_en, HCLGE_MAC_RX_FCS_STRIP_B));
+	*pos += scnprintf(buf + *pos, len - *pos, "mac_rx_fcs_en: %#x\n",
+			  hnae3_get_bit(loop_en, HCLGE_MAC_RX_FCS_B));
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "mac_tx_under_min_err_en: %#x\n",
+			  hnae3_get_bit(loop_en, HCLGE_MAC_TX_UNDER_MIN_ERR_B));
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "mac_tx_oversize_truncate_en: %#x\n",
+			  hnae3_get_bit(loop_en,
+					HCLGE_MAC_TX_OVERSIZE_TRUNCATE_B));
+
+	return 0;
 }
 
-static void hclge_dbg_dump_mac_frame_size(struct hclge_dev *hdev)
+static int hclge_dbg_dump_mac_frame_size(struct hclge_dev *hdev, char *buf,
+					 int len, int *pos)
 {
 	struct hclge_config_max_frm_size_cmd *req;
 	struct hclge_desc desc;
@@ -269,17 +328,21 @@ static void hclge_dbg_dump_mac_frame_size(struct hclge_dev *hdev)
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to dump mac frame size, ret = %d\n", ret);
-		return;
+		return ret;
 	}
 
 	req = (struct hclge_config_max_frm_size_cmd *)desc.data;
 
-	dev_info(&hdev->pdev->dev, "max_frame_size: %u\n",
-		 le16_to_cpu(req->max_frm_size));
-	dev_info(&hdev->pdev->dev, "min_frame_size: %u\n", req->min_frm_size);
+	*pos += scnprintf(buf + *pos, len - *pos, "max_frame_size: %u\n",
+			  le16_to_cpu(req->max_frm_size));
+	*pos += scnprintf(buf + *pos, len - *pos, "min_frame_size: %u\n",
+			  req->min_frm_size);
+
+	return 0;
 }
 
-static void hclge_dbg_dump_mac_speed_duplex(struct hclge_dev *hdev)
+static int hclge_dbg_dump_mac_speed_duplex(struct hclge_dev *hdev, char *buf,
+					   int len, int *pos)
 {
 #define HCLGE_MAC_SPEED_SHIFT	0
 #define HCLGE_MAC_SPEED_MASK	GENMASK(5, 0)
@@ -295,25 +358,34 @@ static void hclge_dbg_dump_mac_speed_duplex(struct hclge_dev *hdev)
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to dump mac speed duplex, ret = %d\n", ret);
-		return;
+		return ret;
 	}
 
 	req = (struct hclge_config_mac_speed_dup_cmd *)desc.data;
 
-	dev_info(&hdev->pdev->dev, "speed: %#lx\n",
-		 hnae3_get_field(req->speed_dup, HCLGE_MAC_SPEED_MASK,
-				 HCLGE_MAC_SPEED_SHIFT));
-	dev_info(&hdev->pdev->dev, "duplex: %#x\n",
-		 hnae3_get_bit(req->speed_dup, HCLGE_MAC_DUPLEX_SHIFT));
+	*pos += scnprintf(buf + *pos, len - *pos, "speed: %#lx\n",
+			  hnae3_get_field(req->speed_dup, HCLGE_MAC_SPEED_MASK,
+					  HCLGE_MAC_SPEED_SHIFT));
+	*pos += scnprintf(buf + *pos, len - *pos, "duplex: %#x\n",
+			  hnae3_get_bit(req->speed_dup,
+					HCLGE_MAC_DUPLEX_SHIFT));
+	return 0;
 }
 
-static void hclge_dbg_dump_mac(struct hclge_dev *hdev)
+static int hclge_dbg_dump_mac(struct hclge_dev *hdev, char *buf, int len)
 {
-	hclge_dbg_dump_mac_enable_status(hdev);
+	int pos = 0;
+	int ret;
+
+	ret = hclge_dbg_dump_mac_enable_status(hdev, buf, len, &pos);
+	if (ret)
+		return ret;
 
-	hclge_dbg_dump_mac_frame_size(hdev);
+	ret = hclge_dbg_dump_mac_frame_size(hdev, buf, len, &pos);
+	if (ret)
+		return ret;
 
-	hclge_dbg_dump_mac_speed_duplex(hdev);
+	return hclge_dbg_dump_mac_speed_duplex(hdev, buf, len, &pos);
 }
 
 static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
@@ -432,35 +504,28 @@ static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
 		cmd, ret);
 }
 
-static void hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev, const char *cmd_buf)
+static int hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev,
+				  enum hnae3_dbg_cmd cmd, char *buf, int len)
 {
 	const struct hclge_dbg_reg_type_info *reg_info;
-	bool has_dump = false;
+	int pos = 0, ret = 0;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(hclge_dbg_reg_info); i++) {
 		reg_info = &hclge_dbg_reg_info[i];
-		if (!strncmp(cmd_buf, reg_info->reg_type,
-			     strlen(reg_info->reg_type))) {
-			hclge_dbg_dump_reg_common(hdev, reg_info, cmd_buf);
-			has_dump = true;
+		if (cmd == reg_info->cmd) {
+			if (cmd == HNAE3_DBG_CMD_REG_TQP)
+				return hclge_dbg_dump_reg_tqp(hdev, reg_info,
+							      buf, len, &pos);
+
+			ret = hclge_dbg_dump_reg_common(hdev, reg_info, buf,
+							len, &pos);
+			if (ret)
+				break;
 		}
 	}
 
-	if (strncmp(cmd_buf, "mac", strlen("mac")) == 0) {
-		hclge_dbg_dump_mac(hdev);
-		has_dump = true;
-	}
-
-	if (strncmp(cmd_buf, "dcb", 3) == 0) {
-		hclge_dbg_dump_dcb(hdev, &cmd_buf[sizeof("dcb")]);
-		has_dump = true;
-	}
-
-	if (!has_dump) {
-		dev_info(&hdev->pdev->dev, "unknown command\n");
-		return;
-	}
+	return ret;
 }
 
 static void hclge_print_tc_info(struct hclge_dev *hdev, bool flag, int index)
@@ -1807,7 +1872,7 @@ static int hclge_dbg_dump_mac_mc(struct hclge_dev *hdev, char *buf, int len)
 
 int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 {
-#define DUMP_REG	"dump reg"
+#define DUMP_REG_DCB	"dump reg dcb"
 #define DUMP_TM_MAP	"dump tm map"
 
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -1827,8 +1892,8 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 		hclge_dbg_dump_qos_pri_map(hdev);
 	} else if (strncmp(cmd_buf, "dump qos buf cfg", 16) == 0) {
 		hclge_dbg_dump_qos_buf_cfg(hdev);
-	} else if (strncmp(cmd_buf, DUMP_REG, strlen(DUMP_REG)) == 0) {
-		hclge_dbg_dump_reg_cmd(hdev, &cmd_buf[sizeof(DUMP_REG)]);
+	} else if (strncmp(cmd_buf, DUMP_REG_DCB, strlen(DUMP_REG_DCB)) == 0) {
+		hclge_dbg_dump_dcb(hdev, &cmd_buf[sizeof(DUMP_REG_DCB)]);
 	} else if (strncmp(cmd_buf, "dump serv info", 14) == 0) {
 		hclge_dbg_dump_serv_info(hdev);
 	} else if (strncmp(cmd_buf, "dump mac tnl status", 19) == 0) {
@@ -1889,18 +1954,65 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_NCL_CONFIG,
 		.dbg_dump = hclge_dbg_dump_ncl_config,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_REG_BIOS_COMMON,
+		.dbg_dump_reg = hclge_dbg_dump_reg_cmd,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_REG_SSU,
+		.dbg_dump_reg = hclge_dbg_dump_reg_cmd,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_REG_IGU_EGU,
+		.dbg_dump_reg = hclge_dbg_dump_reg_cmd,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_REG_RPU,
+		.dbg_dump_reg = hclge_dbg_dump_reg_cmd,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_REG_NCSI,
+		.dbg_dump_reg = hclge_dbg_dump_reg_cmd,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_REG_RTC,
+		.dbg_dump_reg = hclge_dbg_dump_reg_cmd,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_REG_PPP,
+		.dbg_dump_reg = hclge_dbg_dump_reg_cmd,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_REG_RCB,
+		.dbg_dump_reg = hclge_dbg_dump_reg_cmd,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_REG_TQP,
+		.dbg_dump_reg = hclge_dbg_dump_reg_cmd,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_REG_MAC,
+		.dbg_dump = hclge_dbg_dump_mac,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
 		       char *buf, int len)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
+	const struct hclge_dbg_func *cmd_func;
 	struct hclge_dev *hdev = vport->back;
 	u32 i;
 
 	for (i = 0; i < ARRAY_SIZE(hclge_dbg_cmd_func); i++) {
-		if (cmd == hclge_dbg_cmd_func[i].cmd)
-			return hclge_dbg_cmd_func[i].dbg_dump(hdev, buf, len);
+		if (cmd == hclge_dbg_cmd_func[i].cmd) {
+			cmd_func = &hclge_dbg_cmd_func[i];
+			if (cmd_func->dbg_dump)
+				return cmd_func->dbg_dump(hdev, buf, len);
+			else
+				return cmd_func->dbg_dump_reg(hdev, cmd, buf,
+							      len);
+		}
 	}
 
 	dev_err(&hdev->pdev->dev, "invalid command(%d)\n", cmd);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index bf6a0ff..933f157 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -77,7 +77,7 @@ struct hclge_dbg_dfx_message {
 
 #define HCLGE_DBG_MAC_REG_TYPE_LEN	32
 struct hclge_dbg_reg_type_info {
-	const char *reg_type;
+	enum hnae3_dbg_cmd cmd;
 	const struct hclge_dbg_dfx_message *dfx_msg;
 	struct hclge_dbg_reg_common_msg reg_msg;
 };
@@ -85,6 +85,8 @@ struct hclge_dbg_reg_type_info {
 struct hclge_dbg_func {
 	enum hnae3_dbg_cmd cmd;
 	int (*dbg_dump)(struct hclge_dev *hdev, char *buf, int len);
+	int (*dbg_dump_reg)(struct hclge_dev *hdev, enum hnae3_dbg_cmd cmd,
+			    char *buf, int len);
 };
 
 static const struct hclge_dbg_dfx_message hclge_dbg_bios_common_reg[] = {
-- 
2.7.4

