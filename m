Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80341316034
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhBJHoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:44:55 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12892 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbhBJHoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 02:44:54 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DbBZ01bPYz7jWg;
        Wed, 10 Feb 2021 15:42:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Feb 2021 15:44:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/13] net: hns3: clean up hns3_dbg_cmd_write()
Date:   Wed, 10 Feb 2021 15:43:15 +0800
Message-ID: <1612943005-59416-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612943005-59416-1-git-send-email-tanhuazhong@huawei.com>
References: <1612943005-59416-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
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
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 44 +++++++++++++---------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 818ac2c..dd11c57 100644
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
2.7.4

