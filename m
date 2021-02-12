Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5403198B5
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBLDWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:22:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12513 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhBLDW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:22:28 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DcJfC5fmbzjMHp;
        Fri, 12 Feb 2021 11:20:19 +0800 (CST)
Received: from SZA170332453E.china.huawei.com (10.46.104.160) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Feb 2021 11:21:36 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 03/13] net: hns3: clean up hns3_dbg_cmd_write()
Date:   Fri, 12 Feb 2021 11:21:03 +0800
Message-ID: <20210212032113.5384-4-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20210212032113.5384-1-tanhuazhong@huawei.com>
References: <20210212032113.5384-1-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.46.104.160]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

As more commands are added, hns3_dbg_cmd_write() is going to
get more bloated, so move the part about command check into
a separate function.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 44 +++++++++++--------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 818ac2c7c7ea..dd11c57027bb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -423,6 +423,30 @@ static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
 	return (*ppos = len);
 }
 
+static int hns3_dbg_check_cmd(struct hnae3_handle *handle, char *cmd_buf)
+{
+	int ret = 0;
+
+	if (strncmp(cmd_buf, "help", 4) == 0)
+		hns3_dbg_help(handle);
+	else if (strncmp(cmd_buf, "queue info", 10) == 0)
+		ret = hns3_dbg_queue_info(handle, cmd_buf);
+	else if (strncmp(cmd_buf, "queue map", 9) == 0)
+		ret = hns3_dbg_queue_map(handle);
+	else if (strncmp(cmd_buf, "bd info", 7) == 0)
+		ret = hns3_dbg_bd_info(handle, cmd_buf);
+	else if (strncmp(cmd_buf, "dev capability", 14) == 0)
+		hns3_dbg_dev_caps(handle);
+	else if (strncmp(cmd_buf, "dev spec", 8) == 0)
+		hns3_dbg_dev_specs(handle);
+	else if (handle->ae_algo->ops->dbg_run_cmd)
+		ret = handle->ae_algo->ops->dbg_run_cmd(handle, cmd_buf);
+	else
+		ret = -EOPNOTSUPP;
+
+	return ret;
+}
+
 static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
 				  size_t count, loff_t *ppos)
 {
@@ -430,7 +454,7 @@ static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
 	struct hns3_nic_priv *priv  = handle->priv;
 	char *cmd_buf, *cmd_buf_tmp;
 	int uncopied_bytes;
-	int ret = 0;
+	int ret;
 
 	if (*ppos != 0)
 		return 0;
@@ -461,23 +485,7 @@ static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
 		count = cmd_buf_tmp - cmd_buf + 1;
 	}
 
-	if (strncmp(cmd_buf, "help", 4) == 0)
-		hns3_dbg_help(handle);
-	else if (strncmp(cmd_buf, "queue info", 10) == 0)
-		ret = hns3_dbg_queue_info(handle, cmd_buf);
-	else if (strncmp(cmd_buf, "queue map", 9) == 0)
-		ret = hns3_dbg_queue_map(handle);
-	else if (strncmp(cmd_buf, "bd info", 7) == 0)
-		ret = hns3_dbg_bd_info(handle, cmd_buf);
-	else if (strncmp(cmd_buf, "dev capability", 14) == 0)
-		hns3_dbg_dev_caps(handle);
-	else if (strncmp(cmd_buf, "dev spec", 8) == 0)
-		hns3_dbg_dev_specs(handle);
-	else if (handle->ae_algo->ops->dbg_run_cmd)
-		ret = handle->ae_algo->ops->dbg_run_cmd(handle, cmd_buf);
-	else
-		ret = -EOPNOTSUPP;
-
+	ret = hns3_dbg_check_cmd(handle, cmd_buf);
 	if (ret)
 		hns3_dbg_help(handle);
 
-- 
2.25.1

