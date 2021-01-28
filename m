Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82A630753E
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhA1Lw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:52:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11529 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhA1Lw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:52:56 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DRJhG31qYzjFTt;
        Thu, 28 Jan 2021 19:50:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 28 Jan 2021 19:52:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 2/2] net: hns3: add debugfs support for tm nodes, priority and qset info
Date:   Thu, 28 Jan 2021 19:51:36 +0800
Message-ID: <1611834696-56207-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611834696-56207-1-git-send-email-tanhuazhong@huawei.com>
References: <1611834696-56207-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

In order to query tm info of nodes, priority and qset
for debugging, adds three debugfs files tm_nodes,
tm_priority and tm_qset in newly created tm directory.

Unlike previous debugfs commands, these three files
just support read ops, so they only support to use cat
command to dump their info.

The new tm file style is acccording to suggestion from
Jakub Kicinski's opinion as link https://lkml.org/lkml/2020/9/29/2101.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   8 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  55 +++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 153 +++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
 5 files changed, 218 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a7daf6d..fe09cf6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -465,6 +465,8 @@ struct hnae3_ae_dev {
  *   Delete clsflower rule
  * cls_flower_active
  *   Check if any cls flower rule exist
+ * dbg_read_cmd
+ *   Execute debugfs read command.
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -620,6 +622,8 @@ struct hnae3_ae_ops {
 	int (*add_arfs_entry)(struct hnae3_handle *handle, u16 queue_id,
 			      u16 flow_id, struct flow_keys *fkeys);
 	int (*dbg_run_cmd)(struct hnae3_handle *handle, const char *cmd_buf);
+	int (*dbg_read_cmd)(struct hnae3_handle *handle, const char *cmd_buf,
+			    char *buf, int len);
 	pci_ers_result_t (*handle_hw_ras_error)(struct hnae3_ae_dev *ae_dev);
 	bool (*get_hw_reset_stat)(struct hnae3_handle *handle);
 	bool (*ae_dev_resetting)(struct hnae3_handle *handle);
@@ -777,6 +781,10 @@ struct hnae3_handle {
 #define hnae3_get_bit(origin, shift) \
 	hnae3_get_field((origin), (0x1 << (shift)), (shift))
 
+#define HNAE3_DBG_TM_NODES		"tm_nodes"
+#define HNAE3_DBG_TM_PRI		"tm_priority"
+#define HNAE3_DBG_TM_QSET		"tm_qset"
+
 int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev);
 void hnae3_unregister_ae_dev(struct hnae3_ae_dev *ae_dev);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 9d4e9c0..6978304 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -7,7 +7,7 @@
 #include "hnae3.h"
 #include "hns3_enet.h"
 
-#define HNS3_DBG_READ_LEN 256
+#define HNS3_DBG_READ_LEN 65536
 #define HNS3_DBG_WRITE_LEN 1024
 
 static struct dentry *hns3_dbgfs_root;
@@ -484,6 +484,42 @@ static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
 	return count;
 }
 
+static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
+			     size_t count, loff_t *ppos)
+{
+	struct hnae3_handle *handle = filp->private_data;
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	struct hns3_nic_priv *priv = handle->priv;
+	char *cmd_buf, *read_buf;
+	ssize_t size = 0;
+	int ret = 0;
+
+	if (!filp->f_path.dentry->d_iname)
+		return -EINVAL;
+
+	read_buf = kzalloc(HNS3_DBG_READ_LEN, GFP_KERNEL);
+	if (!read_buf)
+		return -ENOMEM;
+
+	cmd_buf = filp->f_path.dentry->d_iname;
+
+	if (ops->dbg_read_cmd)
+		ret = ops->dbg_read_cmd(handle, cmd_buf, read_buf,
+					HNS3_DBG_READ_LEN);
+
+	if (ret) {
+		dev_info(priv->dev, "unknown command\n");
+		goto out;
+	}
+
+	size = simple_read_from_buffer(buffer, count, ppos, read_buf,
+				       strlen(read_buf));
+
+out:
+	kfree(read_buf);
+	return size;
+}
+
 static const struct file_operations hns3_dbg_cmd_fops = {
 	.owner = THIS_MODULE,
 	.open  = simple_open,
@@ -491,14 +527,31 @@ static const struct file_operations hns3_dbg_cmd_fops = {
 	.write = hns3_dbg_cmd_write,
 };
 
+static const struct file_operations hns3_dbg_fops = {
+	.owner = THIS_MODULE,
+	.open  = simple_open,
+	.read  = hns3_dbg_read,
+};
+
 void hns3_dbg_init(struct hnae3_handle *handle)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	const char *name = pci_name(handle->pdev);
+	struct dentry *entry_dir;
 
 	handle->hnae3_dbgfs = debugfs_create_dir(name, hns3_dbgfs_root);
 
 	debugfs_create_file("cmd", 0600, handle->hnae3_dbgfs, handle,
 			    &hns3_dbg_cmd_fops);
+
+	entry_dir = debugfs_create_dir("tm", handle->hnae3_dbgfs);
+	if (ae_dev->dev_version > HNAE3_DEVICE_VERSION_V2)
+		debugfs_create_file(HNAE3_DBG_TM_NODES, 0600, entry_dir, handle,
+				    &hns3_dbg_fops);
+	debugfs_create_file(HNAE3_DBG_TM_PRI, 0600, entry_dir, handle,
+			    &hns3_dbg_fops);
+	debugfs_create_file(HNAE3_DBG_TM_QSET, 0600, entry_dir, handle,
+			    &hns3_dbg_fops);
 }
 
 void hns3_dbg_uninit(struct hnae3_handle *handle)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 8f6dea5..8f3fefe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -800,6 +800,140 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 		cmd, ret);
 }
 
+static int hclge_dbg_dump_tm_nodes(struct hclge_dev *hdev, char *buf, int len)
+{
+	struct hclge_tm_nodes_cmd *nodes;
+	struct hclge_desc desc;
+	int pos = 0;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_NODES, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump tm nodes, ret = %d\n", ret);
+		return ret;
+	}
+
+	nodes = (struct hclge_tm_nodes_cmd *)desc.data;
+
+	pos += scnprintf(buf + pos, len - pos, "       BASE_ID  MAX_NUM\n");
+	pos += scnprintf(buf + pos, len - pos, "PG      %4u      %4u\n",
+			 nodes->pg_base_id, nodes->pg_num);
+	pos += scnprintf(buf + pos, len - pos, "PRI     %4u      %4u\n",
+			 nodes->pri_base_id, nodes->pri_num);
+	pos += scnprintf(buf + pos, len - pos, "QSET    %4u      %4u\n",
+			 le16_to_cpu(nodes->qset_base_id),
+			 le16_to_cpu(nodes->qset_num));
+	pos += scnprintf(buf + pos, len - pos, "QUEUE   %4u      %4u\n",
+			 le16_to_cpu(nodes->queue_base_id),
+			 le16_to_cpu(nodes->queue_num));
+
+	return 0;
+}
+
+static int hclge_dbg_dump_tm_pri(struct hclge_dev *hdev, char *buf, int len)
+{
+	struct hclge_pri_shaper_para c_shaper_para;
+	struct hclge_pri_shaper_para p_shaper_para;
+	u8 pri_num, sch_mode, weight;
+	char *sch_mode_str;
+	int pos = 0;
+	int ret;
+	u8 i;
+
+	ret = hclge_tm_get_pri_num(hdev, &pri_num);
+	if (ret)
+		return ret;
+
+	pos += scnprintf(buf + pos, len - pos,
+			 "ID    MODE  DWRR  C_IR_B  C_IR_U  C_IR_S  C_BS_B  ");
+	pos += scnprintf(buf + pos, len - pos,
+			 "C_BS_S  C_FLAG  C_RATE(Mbps)  P_IR_B  P_IR_U  ");
+	pos += scnprintf(buf + pos, len - pos,
+			 "P_IR_S  P_BS_B  P_BS_S  P_FLAG  P_RATE(Mbps)\n");
+
+	for (i = 0; i < pri_num; i++) {
+		ret = hclge_tm_get_pri_sch_mode(hdev, i, &sch_mode);
+		if (ret)
+			return ret;
+
+		ret = hclge_tm_get_pri_weight(hdev, i, &weight);
+		if (ret)
+			return ret;
+
+		ret = hclge_tm_get_pri_shaper(hdev, i,
+					      HCLGE_OPC_TM_PRI_C_SHAPPING,
+					      &c_shaper_para);
+		if (ret)
+			return ret;
+
+		ret = hclge_tm_get_pri_shaper(hdev, i,
+					      HCLGE_OPC_TM_PRI_P_SHAPPING,
+					      &p_shaper_para);
+		if (ret)
+			return ret;
+
+		sch_mode_str = sch_mode & HCLGE_TM_TX_SCHD_DWRR_MSK ? "dwrr" :
+			       "sp";
+
+		pos += scnprintf(buf + pos, len - pos,
+				 "%04u  %4s  %3u   %3u     %3u     %3u     ",
+				 i, sch_mode_str, weight, c_shaper_para.ir_b,
+				 c_shaper_para.ir_u, c_shaper_para.ir_s);
+		pos += scnprintf(buf + pos, len - pos,
+				 "%3u     %3u       %1u     %6u        ",
+				 c_shaper_para.bs_b, c_shaper_para.bs_s,
+				 c_shaper_para.flag, c_shaper_para.rate);
+		pos += scnprintf(buf + pos, len - pos,
+				 "%3u     %3u     %3u     %3u     %3u       ",
+				 p_shaper_para.ir_b, p_shaper_para.ir_u,
+				 p_shaper_para.ir_s, p_shaper_para.bs_b,
+				 p_shaper_para.bs_s);
+		pos += scnprintf(buf + pos, len - pos, "%1u     %6u\n",
+				 p_shaper_para.flag, p_shaper_para.rate);
+	}
+
+	return 0;
+}
+
+static int hclge_dbg_dump_tm_qset(struct hclge_dev *hdev, char *buf, int len)
+{
+	u8 priority, link_vld, sch_mode, weight;
+	char *sch_mode_str;
+	int ret, pos;
+	u16 qset_num;
+	u16 i;
+
+	ret = hclge_tm_get_qset_num(hdev, &qset_num);
+	if (ret)
+		return ret;
+
+	pos = scnprintf(buf, len, "ID    MAP_PRI  LINK_VLD  MODE  DWRR\n");
+
+	for (i = 0; i < qset_num; i++) {
+		ret = hclge_tm_get_qset_map_pri(hdev, i, &priority, &link_vld);
+		if (ret)
+			return ret;
+
+		ret = hclge_tm_get_qset_sch_mode(hdev, i, &sch_mode);
+		if (ret)
+			return ret;
+
+		ret = hclge_tm_get_qset_weight(hdev, i, &weight);
+		if (ret)
+			return ret;
+
+		sch_mode_str = sch_mode & HCLGE_TM_TX_SCHD_DWRR_MSK ? "dwrr" :
+			       "sp";
+		pos += scnprintf(buf + pos, len - pos,
+				 "%04u  %4u        %1u      %4s  %3u\n",
+				 i, priority, link_vld, sch_mode_str, weight);
+	}
+
+	return 0;
+}
+
 static void hclge_dbg_dump_qos_pause_cfg(struct hclge_dev *hdev)
 {
 	struct hclge_cfg_pause_param_cmd *pause_param;
@@ -1591,3 +1725,22 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 
 	return 0;
 }
+
+int hclge_dbg_read_cmd(struct hnae3_handle *handle, const char *cmd_buf,
+		       char *buf, int len)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	if (strncmp(cmd_buf, HNAE3_DBG_TM_NODES,
+		    strlen(HNAE3_DBG_TM_NODES)) == 0)
+		return hclge_dbg_dump_tm_nodes(hdev, buf, len);
+	else if (strncmp(cmd_buf, HNAE3_DBG_TM_PRI,
+			 strlen(HNAE3_DBG_TM_PRI)) == 0)
+		return hclge_dbg_dump_tm_pri(hdev, buf, len);
+	else if (strncmp(cmd_buf, HNAE3_DBG_TM_QSET,
+			 strlen(HNAE3_DBG_TM_QSET)) == 0)
+		return hclge_dbg_dump_tm_qset(hdev, buf, len);
+
+	return -EINVAL;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c242883..16ccb1a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11850,6 +11850,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.enable_fd = hclge_enable_fd,
 	.add_arfs_entry = hclge_add_fd_entry_by_arfs,
 	.dbg_run_cmd = hclge_dbg_run_cmd,
+	.dbg_read_cmd = hclge_dbg_read_cmd,
 	.handle_hw_ras_error = hclge_handle_hw_ras_error,
 	.get_hw_reset_stat = hclge_get_hw_reset_stat,
 	.ae_dev_resetting = hclge_ae_dev_resetting,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index ca46bc9..32e5f82 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1006,6 +1006,8 @@ int hclge_vport_start(struct hclge_vport *vport);
 void hclge_vport_stop(struct hclge_vport *vport);
 int hclge_set_vport_mtu(struct hclge_vport *vport, int new_mtu);
 int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf);
+int hclge_dbg_read_cmd(struct hnae3_handle *handle, const char *cmd_buf,
+		       char *buf, int len);
 u16 hclge_covert_handle_qid_global(struct hnae3_handle *handle, u16 queue_id);
 int hclge_notify_client(struct hclge_dev *hdev,
 			enum hnae3_reset_notify_type type);
-- 
2.7.4

