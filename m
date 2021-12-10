Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3897347015B
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241591AbhLJNR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:17:57 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15724 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbhLJNRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:17:55 -0500
Received: from kwepemi100009.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J9WWK4tBQzZdVx;
        Fri, 10 Dec 2021 21:11:25 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100009.china.huawei.com (7.221.188.242) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 21:14:19 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 21:14:18 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 2/2] net: hns3: fix race condition in debugfs
Date:   Fri, 10 Dec 2021 21:09:34 +0800
Message-ID: <20211210130934.36278-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211210130934.36278-1-huangguangbin2@huawei.com>
References: <20211210130934.36278-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

When multiple threads concurrently access the debugfs content, data
and pointer exceptions may occur. Therefore, mutex lock protection is
added for debugfs.

Fixes: 5e69ea7ee2a6 ("net: hns3: refactor the debugfs process")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  2 ++
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 20 +++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 3f7a9a4c59d5..63f5abcc6bf4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -839,6 +839,8 @@ struct hnae3_handle {
 
 	u8 netdev_flags;
 	struct dentry *hnae3_dbgfs;
+	/* protects concurrent contention between debugfs commands */
+	struct mutex dbgfs_lock;
 
 	/* Network interface message level enabled bits */
 	u32 msg_enable;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 081295bff765..c381f8af67f0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -1226,6 +1226,7 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 	if (ret)
 		return ret;
 
+	mutex_lock(&handle->dbgfs_lock);
 	save_buf = &hns3_dbg_cmd[index].buf;
 
 	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state) ||
@@ -1238,15 +1239,15 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 		read_buf = *save_buf;
 	} else {
 		read_buf = kvzalloc(hns3_dbg_cmd[index].buf_len, GFP_KERNEL);
-		if (!read_buf)
-			return -ENOMEM;
+		if (!read_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
 		/* save the buffer addr until the last read operation */
 		*save_buf = read_buf;
-	}
 
-	/* get data ready for the first time to read */
-	if (!*ppos) {
+		/* get data ready for the first time to read */
 		ret = hns3_dbg_read_cmd(dbg_data, hns3_dbg_cmd[index].cmd,
 					read_buf, hns3_dbg_cmd[index].buf_len);
 		if (ret)
@@ -1255,8 +1256,10 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 
 	size = simple_read_from_buffer(buffer, count, ppos, read_buf,
 				       strlen(read_buf));
-	if (size > 0)
+	if (size > 0) {
+		mutex_unlock(&handle->dbgfs_lock);
 		return size;
+	}
 
 out:
 	/* free the buffer for the last read operation */
@@ -1265,6 +1268,7 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 		*save_buf = NULL;
 	}
 
+	mutex_unlock(&handle->dbgfs_lock);
 	return ret;
 }
 
@@ -1337,6 +1341,8 @@ int hns3_dbg_init(struct hnae3_handle *handle)
 			debugfs_create_dir(hns3_dbg_dentry[i].name,
 					   handle->hnae3_dbgfs);
 
+	mutex_init(&handle->dbgfs_lock);
+
 	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd); i++) {
 		if ((hns3_dbg_cmd[i].cmd == HNAE3_DBG_CMD_TM_NODES &&
 		     ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2) ||
@@ -1363,6 +1369,7 @@ int hns3_dbg_init(struct hnae3_handle *handle)
 	return 0;
 
 out:
+	mutex_destroy(&handle->dbgfs_lock);
 	debugfs_remove_recursive(handle->hnae3_dbgfs);
 	handle->hnae3_dbgfs = NULL;
 	return ret;
@@ -1378,6 +1385,7 @@ void hns3_dbg_uninit(struct hnae3_handle *handle)
 			hns3_dbg_cmd[i].buf = NULL;
 		}
 
+	mutex_destroy(&handle->dbgfs_lock);
 	debugfs_remove_recursive(handle->hnae3_dbgfs);
 	handle->hnae3_dbgfs = NULL;
 }
-- 
2.33.0

