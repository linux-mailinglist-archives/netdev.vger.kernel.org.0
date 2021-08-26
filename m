Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C6D3F8669
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242369AbhHZL1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:27:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:18041 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241984AbhHZL0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 07:26:41 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GwL622pYVzbhmB;
        Thu, 26 Aug 2021 19:22:02 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 5/7] net: hns3: change the method of getting cmd index in debugfs
Date:   Thu, 26 Aug 2021 19:21:59 +0800
Message-ID: <1629976921-43438-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
References: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Currently, the cmd index is obtained in debugfs by comparing file names.
However, this method may cause errors when processing more complex file
names. So, change this method by saving cmd in private data and comparing
it when getting cmd index in debugfs for optimization.

Fixes: 5e69ea7ee2a6 ("net: hns3: refactor the debugfs process")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 14 +++++++-------
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |  1 +
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 532523069d74..80461ab0ce9e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -938,20 +938,19 @@ static int hns3_dbg_dev_info(struct hnae3_handle *h, char *buf, int len)
 	return 0;
 }
 
-static int hns3_dbg_get_cmd_index(struct hnae3_handle *handle,
-				  const unsigned char *name, u32 *index)
+static int hns3_dbg_get_cmd_index(struct hns3_dbg_data *dbg_data, u32 *index)
 {
 	u32 i;
 
 	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd); i++) {
-		if (!strncmp(name, hns3_dbg_cmd[i].name,
-			     strlen(hns3_dbg_cmd[i].name))) {
+		if (hns3_dbg_cmd[i].cmd == dbg_data->cmd) {
 			*index = i;
 			return 0;
 		}
 	}
 
-	dev_err(&handle->pdev->dev, "unknown command(%s)\n", name);
+	dev_err(&dbg_data->handle->pdev->dev, "unknown command(%d)\n",
+		dbg_data->cmd);
 	return -EINVAL;
 }
 
@@ -1019,8 +1018,7 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 	u32 index;
 	int ret;
 
-	ret = hns3_dbg_get_cmd_index(handle, filp->f_path.dentry->d_iname,
-				     &index);
+	ret = hns3_dbg_get_cmd_index(dbg_data, &index);
 	if (ret)
 		return ret;
 
@@ -1090,6 +1088,7 @@ static int hns3_dbg_bd_file_init(struct hnae3_handle *handle, u32 cmd)
 		char name[HNS3_DBG_FILE_NAME_LEN];
 
 		data[i].handle = handle;
+		data[i].cmd = hns3_dbg_cmd[cmd].cmd;
 		data[i].qid = i;
 		sprintf(name, "%s%u", hns3_dbg_cmd[cmd].name, i);
 		debugfs_create_file(name, 0400, entry_dir, &data[i],
@@ -1110,6 +1109,7 @@ hns3_dbg_common_file_init(struct hnae3_handle *handle, u32 cmd)
 		return -ENOMEM;
 
 	data->handle = handle;
+	data->cmd = hns3_dbg_cmd[cmd].cmd;
 	entry_dir = hns3_dbg_dentry[hns3_dbg_cmd[cmd].dentry].dentry;
 	debugfs_create_file(hns3_dbg_cmd[cmd].name, 0400, entry_dir,
 			    data, &hns3_dbg_fops);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index f3766ff38bb7..bd8801065e02 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -22,6 +22,7 @@ struct hns3_dbg_item {
 
 struct hns3_dbg_data {
 	struct hnae3_handle *handle;
+	enum hnae3_dbg_cmd cmd;
 	u16 qid;
 };
 
-- 
2.8.1

