Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786D7389B57
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhETCXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:35 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3608 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbhETCXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:18 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FltjS2lVlzmWYW;
        Thu, 20 May 2021 10:19:40 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:56 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:56 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 15/15] net: hns3: remove the useless debugfs file node cmd
Date:   Thu, 20 May 2021 10:21:44 +0800
Message-ID: <1621477304-4495-16-git-send-email-tanhuazhong@huawei.com>
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

Currently, all debugfs commands have been reconstructed, and the
debugfs file node cmd is useless. So remove this debugfs file node.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 106 ---------------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  10 --
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   1 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 -
 5 files changed, 119 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 09a0658..57fa7fc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -668,7 +668,6 @@ struct hnae3_ae_ops {
 	void (*enable_fd)(struct hnae3_handle *handle, bool enable);
 	int (*add_arfs_entry)(struct hnae3_handle *handle, u16 queue_id,
 			      u16 flow_id, struct flow_keys *fkeys);
-	int (*dbg_run_cmd)(struct hnae3_handle *handle, const char *cmd_buf);
 	int (*dbg_read_cmd)(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
 			    char *buf, int len);
 	pci_ers_result_t (*handle_hw_ras_error)(struct hnae3_ae_dev *ae_dev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 04102d7..57ba5a1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -773,11 +773,6 @@ static int hns3_dbg_tx_bd_info(struct hns3_dbg_data *d, char *buf, int len)
 	return 0;
 }
 
-static void hns3_dbg_help(struct hnae3_handle *h)
-{
-	dev_info(&h->pdev->dev, "available commands\n");
-}
-
 static void
 hns3_dbg_dev_caps(struct hnae3_handle *h, char *buf, int len, int *pos)
 {
@@ -852,97 +847,6 @@ static int hns3_dbg_dev_info(struct hnae3_handle *h, char *buf, int len)
 	return 0;
 }
 
-static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
-				 size_t count, loff_t *ppos)
-{
-	int uncopy_bytes;
-	char *buf;
-	int len;
-
-	if (*ppos != 0)
-		return 0;
-
-	if (count < HNS3_DBG_READ_LEN)
-		return -ENOSPC;
-
-	buf = kzalloc(HNS3_DBG_READ_LEN, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	len = scnprintf(buf, HNS3_DBG_READ_LEN, "%s\n",
-			"Please echo help to cmd to get help information");
-	uncopy_bytes = copy_to_user(buffer, buf, len);
-
-	kfree(buf);
-
-	if (uncopy_bytes)
-		return -EFAULT;
-
-	return (*ppos = len);
-}
-
-static int hns3_dbg_check_cmd(struct hnae3_handle *handle, char *cmd_buf)
-{
-	int ret = 0;
-
-	if (strncmp(cmd_buf, "help", 4) == 0)
-		hns3_dbg_help(handle);
-	else if (handle->ae_algo->ops->dbg_run_cmd)
-		ret = handle->ae_algo->ops->dbg_run_cmd(handle, cmd_buf);
-	else
-		ret = -EOPNOTSUPP;
-
-	return ret;
-}
-
-static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
-				  size_t count, loff_t *ppos)
-{
-	struct hnae3_handle *handle = filp->private_data;
-	struct hns3_nic_priv *priv  = handle->priv;
-	char *cmd_buf, *cmd_buf_tmp;
-	int uncopied_bytes;
-	int ret;
-
-	if (*ppos != 0)
-		return 0;
-
-	/* Judge if the instance is being reset. */
-	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state) ||
-	    test_bit(HNS3_NIC_STATE_RESETTING, &priv->state))
-		return 0;
-
-	if (count > HNS3_DBG_WRITE_LEN)
-		return -ENOSPC;
-
-	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
-	if (!cmd_buf)
-		return count;
-
-	uncopied_bytes = copy_from_user(cmd_buf, buffer, count);
-	if (uncopied_bytes) {
-		kfree(cmd_buf);
-		return -EFAULT;
-	}
-
-	cmd_buf[count] = '\0';
-
-	cmd_buf_tmp = strchr(cmd_buf, '\n');
-	if (cmd_buf_tmp) {
-		*cmd_buf_tmp = '\0';
-		count = cmd_buf_tmp - cmd_buf + 1;
-	}
-
-	ret = hns3_dbg_check_cmd(handle, cmd_buf);
-	if (ret)
-		hns3_dbg_help(handle);
-
-	kfree(cmd_buf);
-	cmd_buf = NULL;
-
-	return count;
-}
-
 static int hns3_dbg_get_cmd_index(struct hnae3_handle *handle,
 				  const unsigned char *name, u32 *index)
 {
@@ -1071,13 +975,6 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 	return ret;
 }
 
-static const struct file_operations hns3_dbg_cmd_fops = {
-	.owner = THIS_MODULE,
-	.open  = simple_open,
-	.read  = hns3_dbg_cmd_read,
-	.write = hns3_dbg_cmd_write,
-};
-
 static const struct file_operations hns3_dbg_fops = {
 	.owner = THIS_MODULE,
 	.open  = simple_open,
@@ -1140,9 +1037,6 @@ int hns3_dbg_init(struct hnae3_handle *handle)
 				debugfs_create_dir(name, hns3_dbgfs_root);
 	handle->hnae3_dbgfs = hns3_dbg_dentry[HNS3_DBG_DENTRY_COMMON].dentry;
 
-	debugfs_create_file("cmd", 0600, handle->hnae3_dbgfs, handle,
-			    &hns3_dbg_cmd_fops);
-
 	for (i = 0; i < HNS3_DBG_DENTRY_COMMON; i++)
 		hns3_dbg_dentry[i].dentry =
 			debugfs_create_dir(hns3_dbg_dentry[i].name,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index e7a043a..dd9eb6e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1907,16 +1907,6 @@ static int hclge_dbg_dump_mac_mc(struct hclge_dev *hdev, char *buf, int len)
 	return 0;
 }
 
-int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
-{
-	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_dev *hdev = vport->back;
-
-	dev_info(&hdev->pdev->dev, "unknown command\n");
-
-	return -EINVAL;
-}
-
 static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 	{
 		.cmd = HNAE3_DBG_CMD_TM_NODES,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d4d3f0b..3882f82 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12610,7 +12610,6 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_fd_all_rules = hclge_get_all_rules,
 	.enable_fd = hclge_enable_fd,
 	.add_arfs_entry = hclge_add_fd_entry_by_arfs,
-	.dbg_run_cmd = hclge_dbg_run_cmd,
 	.dbg_read_cmd = hclge_dbg_read_cmd,
 	.handle_hw_ras_error = hclge_handle_hw_ras_error,
 	.get_hw_reset_stat = hclge_get_hw_reset_stat,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 8bf451e..4bdb024 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1062,7 +1062,6 @@ int hclge_func_reset_cmd(struct hclge_dev *hdev, int func_id);
 int hclge_vport_start(struct hclge_vport *vport);
 void hclge_vport_stop(struct hclge_vport *vport);
 int hclge_set_vport_mtu(struct hclge_vport *vport, int new_mtu);
-int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf);
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
 		       char *buf, int len);
 u16 hclge_covert_handle_qid_global(struct hnae3_handle *handle, u16 queue_id);
-- 
2.7.4

