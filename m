Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D997389B56
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhETCXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:33 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3433 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhETCXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:17 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Flthr6nq8zCsRs;
        Thu, 20 May 2021 10:19:08 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
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
        <linuxarm@huawei.com>, Hao Chen <chenhao288@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/15] net: hns3: refactor queue map of debugfs
Date:   Thu, 20 May 2021 10:21:32 +0800
Message-ID: <1621477304-4495-4-git-send-email-tanhuazhong@huawei.com>
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

Currently, the debugfs command for queue map is implemented by
"echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create a single file
"queue_map" for it, and query it by command "cat queue_map",
return the result to userspace, rather than record in dmesg.

The display style is below:
$ cat queue_map
local_queue_id   global_queue_id   vector_id
0                0                 341

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 58 ++++++++++++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |  1 +
 3 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 65fd333..f844eb2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -276,6 +276,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_REG_TQP,
 	HNAE3_DBG_CMD_REG_MAC,
 	HNAE3_DBG_CMD_REG_DCB,
+	HNAE3_DBG_CMD_QUEUE_MAP,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 9add389..fc4e17b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -26,6 +26,9 @@ static struct hns3_dbg_dentry_info hns3_dbg_dentry[] = {
 	{
 		.name = "reg"
 	},
+	{
+		.name = "queue"
+	},
 	/* keep common at the bottom and add new directory above */
 	{
 		.name = "common"
@@ -212,6 +215,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "queue_map",
+		.cmd = HNAE3_DBG_CMD_QUEUE_MAP,
+		.dentry = HNS3_DBG_DENTRY_QUEUE,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -403,27 +413,44 @@ static int hns3_dbg_queue_info(struct hnae3_handle *h,
 	return 0;
 }
 
-static int hns3_dbg_queue_map(struct hnae3_handle *h)
+static const struct hns3_dbg_item queue_map_items[] = {
+	{ "local_queue_id", 2 },
+	{ "global_queue_id", 2 },
+	{ "vector_id", 2 },
+};
+
+static int hns3_dbg_queue_map(struct hnae3_handle *h, char *buf, int len)
 {
+	char data_str[ARRAY_SIZE(queue_map_items)][HNS3_DBG_DATA_STR_LEN];
+	char *result[ARRAY_SIZE(queue_map_items)];
 	struct hns3_nic_priv *priv = h->priv;
-	int i;
+	char content[HNS3_DBG_INFO_LEN];
+	int pos = 0;
+	int j;
+	u32 i;
 
 	if (!h->ae_algo->ops->get_global_queue_id)
 		return -EOPNOTSUPP;
 
-	dev_info(&h->pdev->dev, "map info for queue id and vector id\n");
-	dev_info(&h->pdev->dev,
-		 "local queue id | global queue id | vector id\n");
-	for (i = 0; i < h->kinfo.num_tqps; i++) {
-		u16 global_qid;
+	for (i = 0; i < ARRAY_SIZE(queue_map_items); i++)
+		result[i] = &data_str[i][0];
 
-		global_qid = h->ae_algo->ops->get_global_queue_id(h, i);
+	hns3_dbg_fill_content(content, sizeof(content), queue_map_items,
+			      NULL, ARRAY_SIZE(queue_map_items));
+	pos += scnprintf(buf + pos, len - pos, "%s", content);
+	for (i = 0; i < h->kinfo.num_tqps; i++) {
 		if (!priv->ring || !priv->ring[i].tqp_vector)
 			continue;
-
-		dev_info(&h->pdev->dev,
-			 "      %4d            %4u            %4d\n",
-			 i, global_qid, priv->ring[i].tqp_vector->vector_irq);
+		j = 0;
+		sprintf(result[j++], "%u", i);
+		sprintf(result[j++], "%u",
+			h->ae_algo->ops->get_global_queue_id(h, i));
+		sprintf(result[j++], "%u",
+			priv->ring[i].tqp_vector->vector_irq);
+		hns3_dbg_fill_content(content, sizeof(content), queue_map_items,
+				      (const char **)result,
+				      ARRAY_SIZE(queue_map_items));
+		pos += scnprintf(buf + pos, len - pos, "%s", content);
 	}
 
 	return 0;
@@ -590,7 +617,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 {
 	dev_info(&h->pdev->dev, "available commands\n");
 	dev_info(&h->pdev->dev, "queue info <number>\n");
-	dev_info(&h->pdev->dev, "queue map\n");
 
 	if (!hns3_is_phys_func(h->pdev))
 		return;
@@ -717,8 +743,6 @@ static int hns3_dbg_check_cmd(struct hnae3_handle *handle, char *cmd_buf)
 		hns3_dbg_help(handle);
 	else if (strncmp(cmd_buf, "queue info", 10) == 0)
 		ret = hns3_dbg_queue_info(handle, cmd_buf);
-	else if (strncmp(cmd_buf, "queue map", 9) == 0)
-		ret = hns3_dbg_queue_map(handle);
 	else if (handle->ae_algo->ops->dbg_run_cmd)
 		ret = handle->ae_algo->ops->dbg_run_cmd(handle, cmd_buf);
 	else
@@ -794,6 +818,10 @@ static int hns3_dbg_get_cmd_index(struct hnae3_handle *handle,
 
 static const struct hns3_dbg_func hns3_dbg_cmd_func[] = {
 	{
+		.cmd = HNAE3_DBG_CMD_QUEUE_MAP,
+		.dbg_dump = hns3_dbg_queue_map,
+	},
+	{
 		.cmd = HNAE3_DBG_CMD_DEV_INFO,
 		.dbg_dump = hns3_dbg_dev_info,
 	},
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index 6060bfc..4cab37a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -30,6 +30,7 @@ enum hns3_dbg_dentry_type {
 	HNS3_DBG_DENTRY_RX_BD,
 	HNS3_DBG_DENTRY_MAC,
 	HNS3_DBG_DENTRY_REG,
+	HNS3_DBG_DENTRY_QUEUE,
 	HNS3_DBG_DENTRY_COMMON,
 };
 
-- 
2.7.4

