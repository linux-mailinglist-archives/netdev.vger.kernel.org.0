Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACA538027E
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhEND1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:27:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3679 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbhEND0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:49 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhDPB2s3tz1BMPs;
        Fri, 14 May 2021 11:22:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 11:25:27 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/12] net: hns3: refactor the debugfs process
Date:   Fri, 14 May 2021 11:25:11 +0800
Message-ID: <1620962720-62216-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
References: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Currently, each debugfs command needs to create a file to get
the information. To better support more debugfs commands, the
debugfs process is reconstructed, including the process of
creating dentries and files, and obtaining information.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  13 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 193 +++++++++++++++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |  29 ++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  32 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |   5 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +-
 8 files changed, 236 insertions(+), 47 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 1d265c3..eee9639 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -250,6 +250,13 @@ enum hnae3_port_base_vlan_state {
 	HNAE3_PORT_BASE_VLAN_NOCHANGE,
 };
 
+enum hnae3_dbg_cmd {
+	HNAE3_DBG_CMD_TM_NODES,
+	HNAE3_DBG_CMD_TM_PRI,
+	HNAE3_DBG_CMD_TM_QSET,
+	HNAE3_DBG_CMD_UNKNOWN,
+};
+
 struct hnae3_vector_info {
 	u8 __iomem *io_addr;
 	int vector;
@@ -627,7 +634,7 @@ struct hnae3_ae_ops {
 	int (*add_arfs_entry)(struct hnae3_handle *handle, u16 queue_id,
 			      u16 flow_id, struct flow_keys *fkeys);
 	int (*dbg_run_cmd)(struct hnae3_handle *handle, const char *cmd_buf);
-	int (*dbg_read_cmd)(struct hnae3_handle *handle, const char *cmd_buf,
+	int (*dbg_read_cmd)(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
 			    char *buf, int len);
 	pci_ers_result_t (*handle_hw_ras_error)(struct hnae3_ae_dev *ae_dev);
 	bool (*get_hw_reset_stat)(struct hnae3_handle *handle);
@@ -790,10 +797,6 @@ struct hnae3_handle {
 #define hnae3_get_bit(origin, shift) \
 	hnae3_get_field(origin, 0x1 << (shift), shift)
 
-#define HNAE3_DBG_TM_NODES		"tm_nodes"
-#define HNAE3_DBG_TM_PRI		"tm_priority"
-#define HNAE3_DBG_TM_QSET		"tm_qset"
-
 int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
 void hnae3_unregister_ae_dev(struct hnae3_ae_dev *ae_dev);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index e405fef..62a0595 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -5,13 +5,48 @@
 #include <linux/device.h>
 
 #include "hnae3.h"
+#include "hns3_debugfs.h"
 #include "hns3_enet.h"
 
-#define HNS3_DBG_READ_LEN 65536
-#define HNS3_DBG_WRITE_LEN 1024
-
 static struct dentry *hns3_dbgfs_root;
 
+static struct hns3_dbg_dentry_info hns3_dbg_dentry[] = {
+	{
+		.name = "tm"
+	},
+	/* keep common at the bottom and add new directory above */
+	{
+		.name = "common"
+	},
+};
+
+static int hns3_dbg_common_file_init(struct hnae3_handle *handle,
+				     unsigned int cmd);
+
+static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
+	{
+		.name = "tm_nodes",
+		.cmd = HNAE3_DBG_CMD_TM_NODES,
+		.dentry = HNS3_DBG_DENTRY_TM,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "tm_priority",
+		.cmd = HNAE3_DBG_CMD_TM_PRI,
+		.dentry = HNS3_DBG_DENTRY_TM,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "tm_qset",
+		.cmd = HNAE3_DBG_CMD_TM_QSET,
+		.dentry = HNS3_DBG_DENTRY_TM,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+};
+
 static int hns3_dbg_queue_info(struct hnae3_handle *h,
 			       const char *cmd_buf)
 {
@@ -493,37 +528,90 @@ static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
 	return count;
 }
 
+static int hns3_dbg_get_cmd_index(struct hnae3_handle *handle,
+				  const unsigned char *name, u32 *index)
+{
+	u32 i;
+
+	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd); i++) {
+		if (!strncmp(name, hns3_dbg_cmd[i].name,
+			     strlen(hns3_dbg_cmd[i].name))) {
+			*index = i;
+			return 0;
+		}
+	}
+
+	dev_err(&handle->pdev->dev, "unknown command(%s)\n", name);
+	return -EINVAL;
+}
+
+static int hns3_dbg_read_cmd(struct hnae3_handle *handle,
+			     enum hnae3_dbg_cmd cmd, char *buf, int len)
+{
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+
+	if (!ops->dbg_read_cmd)
+		return -EOPNOTSUPP;
+
+	return ops->dbg_read_cmd(handle, cmd, buf, len);
+}
+
 static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 			     size_t count, loff_t *ppos)
 {
 	struct hnae3_handle *handle = filp->private_data;
-	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
 	struct hns3_nic_priv *priv = handle->priv;
-	char *cmd_buf, *read_buf;
 	ssize_t size = 0;
-	int ret = 0;
-
-	read_buf = kzalloc(HNS3_DBG_READ_LEN, GFP_KERNEL);
-	if (!read_buf)
-		return -ENOMEM;
+	char **save_buf;
+	char *read_buf;
+	u32 index;
+	int ret;
 
-	cmd_buf = filp->f_path.dentry->d_iname;
+	ret = hns3_dbg_get_cmd_index(handle, filp->f_path.dentry->d_iname,
+				     &index);
+	if (ret)
+		return ret;
 
-	if (ops->dbg_read_cmd)
-		ret = ops->dbg_read_cmd(handle, cmd_buf, read_buf,
-					HNS3_DBG_READ_LEN);
+	save_buf = &hns3_dbg_cmd[index].buf;
 
-	if (ret) {
-		dev_info(priv->dev, "unknown command\n");
+	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state) ||
+	    test_bit(HNS3_NIC_STATE_RESETTING, &priv->state)) {
+		ret = -EBUSY;
 		goto out;
 	}
 
+	if (*save_buf) {
+		read_buf = *save_buf;
+	} else {
+		read_buf = kvzalloc(hns3_dbg_cmd[index].buf_len, GFP_KERNEL);
+		if (!read_buf)
+			return -ENOMEM;
+
+		/* save the buffer addr until the last read operation */
+		*save_buf = read_buf;
+	}
+
+	/* get data ready for the first time to read */
+	if (!*ppos) {
+		ret = hns3_dbg_read_cmd(handle, hns3_dbg_cmd[index].cmd,
+					read_buf, hns3_dbg_cmd[index].buf_len);
+		if (ret)
+			goto out;
+	}
+
 	size = simple_read_from_buffer(buffer, count, ppos, read_buf,
 				       strlen(read_buf));
+	if (size > 0)
+		return size;
 
 out:
-	kfree(read_buf);
-	return size;
+	/* free the buffer for the last read operation */
+	if (*save_buf) {
+		kvfree(*save_buf);
+		*save_buf = NULL;
+	}
+
+	return ret;
 }
 
 static const struct file_operations hns3_dbg_cmd_fops = {
@@ -539,29 +627,76 @@ static const struct file_operations hns3_dbg_fops = {
 	.read  = hns3_dbg_read,
 };
 
-void hns3_dbg_init(struct hnae3_handle *handle)
+static int
+hns3_dbg_common_file_init(struct hnae3_handle *handle, u32 cmd)
+{
+	struct dentry *entry_dir;
+
+	entry_dir = hns3_dbg_dentry[hns3_dbg_cmd[cmd].dentry].dentry;
+	debugfs_create_file(hns3_dbg_cmd[cmd].name, 0400, entry_dir,
+			    handle, &hns3_dbg_fops);
+
+	return 0;
+}
+
+int hns3_dbg_init(struct hnae3_handle *handle)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	const char *name = pci_name(handle->pdev);
-	struct dentry *entry_dir;
+	int ret;
+	u32 i;
 
-	handle->hnae3_dbgfs = debugfs_create_dir(name, hns3_dbgfs_root);
+	hns3_dbg_dentry[HNS3_DBG_DENTRY_COMMON].dentry =
+				debugfs_create_dir(name, hns3_dbgfs_root);
+	handle->hnae3_dbgfs = hns3_dbg_dentry[HNS3_DBG_DENTRY_COMMON].dentry;
 
 	debugfs_create_file("cmd", 0600, handle->hnae3_dbgfs, handle,
 			    &hns3_dbg_cmd_fops);
 
-	entry_dir = debugfs_create_dir("tm", handle->hnae3_dbgfs);
-	if (ae_dev->dev_version > HNAE3_DEVICE_VERSION_V2)
-		debugfs_create_file(HNAE3_DBG_TM_NODES, 0600, entry_dir, handle,
-				    &hns3_dbg_fops);
-	debugfs_create_file(HNAE3_DBG_TM_PRI, 0600, entry_dir, handle,
-			    &hns3_dbg_fops);
-	debugfs_create_file(HNAE3_DBG_TM_QSET, 0600, entry_dir, handle,
-			    &hns3_dbg_fops);
+	for (i = 0; i < HNS3_DBG_DENTRY_COMMON; i++)
+		hns3_dbg_dentry[i].dentry =
+			debugfs_create_dir(hns3_dbg_dentry[i].name,
+					   handle->hnae3_dbgfs);
+
+	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd); i++) {
+		if (hns3_dbg_cmd[i].cmd == HNAE3_DBG_CMD_TM_NODES &&
+		    ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2)
+			continue;
+
+		if (!hns3_dbg_cmd[i].init) {
+			dev_err(&handle->pdev->dev,
+				"cmd %s lack of init func\n",
+				hns3_dbg_cmd[i].name);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ret = hns3_dbg_cmd[i].init(handle, i);
+		if (ret) {
+			dev_err(&handle->pdev->dev, "failed to init cmd %s\n",
+				hns3_dbg_cmd[i].name);
+			goto out;
+		}
+	}
+
+	return 0;
+
+out:
+	debugfs_remove_recursive(handle->hnae3_dbgfs);
+	handle->hnae3_dbgfs = NULL;
+	return ret;
 }
 
 void hns3_dbg_uninit(struct hnae3_handle *handle)
 {
+	u32 i;
+
+	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd); i++)
+		if (hns3_dbg_cmd[i].buf) {
+			kvfree(hns3_dbg_cmd[i].buf);
+			hns3_dbg_cmd[i].buf = NULL;
+		}
+
 	debugfs_remove_recursive(handle->hnae3_dbgfs);
 	handle->hnae3_dbgfs = NULL;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
new file mode 100644
index 0000000..1648f68
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2021 Hisilicon Limited. */
+
+#ifndef __HNS3_DEBUGFS_H
+#define __HNS3_DEBUGFS_H
+
+#define HNS3_DBG_READ_LEN	65536
+#define HNS3_DBG_WRITE_LEN	1024
+
+enum hns3_dbg_dentry_type {
+	HNS3_DBG_DENTRY_TM,
+	HNS3_DBG_DENTRY_COMMON,
+};
+
+struct hns3_dbg_dentry_info {
+	const char *name;
+	struct dentry *dentry;
+};
+
+struct hns3_dbg_cmd_info {
+	const char *name;
+	enum hnae3_dbg_cmd cmd;
+	enum hns3_dbg_dentry_type dentry;
+	u32 buf_len;
+	char *buf;
+	int (*init)(struct hnae3_handle *handle, unsigned int cmd);
+};
+
+#endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5826d86..02ce7a3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4648,7 +4648,12 @@ static int hns3_client_init(struct hnae3_handle *handle)
 
 	hns3_dcbnl_setup(handle);
 
-	hns3_dbg_init(handle);
+	ret = hns3_dbg_init(handle);
+	if (ret) {
+		dev_err(priv->dev, "failed to init debugfs, ret = %d\n",
+			ret);
+		goto out_client_start;
+	}
 
 	netdev->max_mtu = HNS3_MAX_MTU(ae_dev->dev_specs.max_frm_size);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index c9aebda..5c72f41 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -650,7 +650,7 @@ void hns3_dcbnl_setup(struct hnae3_handle *handle);
 static inline void hns3_dcbnl_setup(struct hnae3_handle *handle) {}
 #endif
 
-void hns3_dbg_init(struct hnae3_handle *handle);
+int hns3_dbg_init(struct hnae3_handle *handle);
 void hns3_dbg_uninit(struct hnae3_handle *handle);
 void hns3_dbg_register_debugfs(const char *debugfs_dir_name);
 void hns3_dbg_unregister_debugfs(void);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 85d3064..7f1abdf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1800,21 +1800,33 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 	return 0;
 }
 
-int hclge_dbg_read_cmd(struct hnae3_handle *handle, const char *cmd_buf,
+static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
+	{
+		.cmd = HNAE3_DBG_CMD_TM_NODES,
+		.dbg_dump = hclge_dbg_dump_tm_nodes,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_TM_PRI,
+		.dbg_dump = hclge_dbg_dump_tm_pri,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_TM_QSET,
+		.dbg_dump = hclge_dbg_dump_tm_qset,
+	},
+};
+
+int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
 		       char *buf, int len)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
+	u32 i;
 
-	if (strncmp(cmd_buf, HNAE3_DBG_TM_NODES,
-		    strlen(HNAE3_DBG_TM_NODES)) == 0)
-		return hclge_dbg_dump_tm_nodes(hdev, buf, len);
-	else if (strncmp(cmd_buf, HNAE3_DBG_TM_PRI,
-			 strlen(HNAE3_DBG_TM_PRI)) == 0)
-		return hclge_dbg_dump_tm_pri(hdev, buf, len);
-	else if (strncmp(cmd_buf, HNAE3_DBG_TM_QSET,
-			 strlen(HNAE3_DBG_TM_QSET)) == 0)
-		return hclge_dbg_dump_tm_qset(hdev, buf, len);
+	for (i = 0; i < ARRAY_SIZE(hclge_dbg_cmd_func); i++) {
+		if (cmd == hclge_dbg_cmd_func[i].cmd)
+			return hclge_dbg_cmd_func[i].dbg_dump(hdev, buf, len);
+	}
 
+	dev_err(&hdev->pdev->dev, "invalid command(%d)\n", cmd);
 	return -EINVAL;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index ca2ab6c..0c14453 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -83,6 +83,11 @@ struct hclge_dbg_reg_type_info {
 	struct hclge_dbg_reg_common_msg reg_msg;
 };
 
+struct hclge_dbg_func {
+	enum hnae3_dbg_cmd cmd;
+	int (*dbg_dump)(struct hclge_dev *hdev, char *buf, int len);
+};
+
 static const struct hclge_dbg_dfx_message hclge_dbg_bios_common_reg[] = {
 	{false, "Reserved"},
 	{true,	"BP_CPU_STATE"},
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 10f5c11..9e17c02 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1061,7 +1061,7 @@ int hclge_vport_start(struct hclge_vport *vport);
 void hclge_vport_stop(struct hclge_vport *vport);
 int hclge_set_vport_mtu(struct hclge_vport *vport, int new_mtu);
 int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf);
-int hclge_dbg_read_cmd(struct hnae3_handle *handle, const char *cmd_buf,
+int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
 		       char *buf, int len);
 u16 hclge_covert_handle_qid_global(struct hnae3_handle *handle, u16 queue_id);
 int hclge_notify_client(struct hclge_dev *hdev,
-- 
2.7.4

