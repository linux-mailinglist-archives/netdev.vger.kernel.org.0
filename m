Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB182F738A
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 08:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731530AbhAOHK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 02:10:58 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11020 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbhAOHK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 02:10:58 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DHC362x4dzj77H;
        Fri, 15 Jan 2021 15:09:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Fri, 15 Jan 2021 15:10:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next] net: hns3: debugfs add dump tm info of nodes, priority and qset
Date:   Fri, 15 Jan 2021 15:09:29 +0800
Message-ID: <1610694569-43099-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

To increase methods to dump more tm info, adds three debugfs commands
to dump tm info of nodes, priority and qset. And a new tm file of debugfs
is created for only dumping tm info.

Unlike previous debugfs commands, to dump each tm information, user needs
to enter two commands now. The first command writes parameters to tm and
the second command reads info from tm. For examples, to dump tm info of
priority 0, user needs to enter follow two commands:
1. echo dump priority 0 > tm
2. cat tm

The reason for adding new tm file is because we accepted Jakub Kicinski's
opinion as link https://lkml.org/lkml/2020/9/29/2101. And in order to
avoid generating too many files, we implement write ops to allow user to
input parameters.

However, If there are two or more users concurrently write parameters to
tm, parameters of the latest command will overwrite previous commands,
this concurrency problem will confuse users, but now there is no good
method to fix it.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   9 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 118 ++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   6 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 251 +++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  23 ++
 8 files changed, 411 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a7daf6d..39b8ac7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -247,6 +247,10 @@ struct hnae3_vector_info {
 	int vector;
 };
 
+enum hnae3_dbg_module_type {
+	HNAE3_DBG_MODULE_TYPE_TM,
+};
+
 #define HNAE3_RING_TYPE_B 0
 #define HNAE3_RING_TYPE_TX 0
 #define HNAE3_RING_TYPE_RX 1
@@ -465,6 +469,8 @@ struct hnae3_ae_dev {
  *   Delete clsflower rule
  * cls_flower_active
  *   Check if any cls flower rule exist
+ * dbg_read_cmd
+ *   Execute debugfs read command.
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -620,6 +626,8 @@ struct hnae3_ae_ops {
 	int (*add_arfs_entry)(struct hnae3_handle *handle, u16 queue_id,
 			      u16 flow_id, struct flow_keys *fkeys);
 	int (*dbg_run_cmd)(struct hnae3_handle *handle, const char *cmd_buf);
+	int (*dbg_read_cmd)(struct hnae3_handle *handle, const char *cmd_buf,
+			    char *buf, int len);
 	pci_ers_result_t (*handle_hw_ras_error)(struct hnae3_ae_dev *ae_dev);
 	bool (*get_hw_reset_stat)(struct hnae3_handle *handle);
 	bool (*ae_dev_resetting)(struct hnae3_handle *handle);
@@ -757,6 +765,7 @@ struct hnae3_handle {
 
 	u8 netdev_flags;
 	struct dentry *hnae3_dbgfs;
+	int dbgfs_type;
 
 	/* Network interface message level enabled bits */
 	u32 msg_enable;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 9d4e9c0..e2b6924 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -12,6 +12,10 @@
 
 static struct dentry *hns3_dbgfs_root;
 
+#define HNS3_HELP_INFO "help"
+
+#define HNS3_DBG_MODULE_NAME_TM		"tm"
+
 static int hns3_dbg_queue_info(struct hnae3_handle *h,
 			       const char *cmd_buf)
 {
@@ -338,6 +342,23 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "%s", printf_buf);
 }
 
+static void hns3_dbg_tm_help(struct hnae3_handle *h, char *buf, int len)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
+	int pos;
+
+	pos = scnprintf(buf, len, "available commands:\n");
+
+	if (!hns3_is_phys_func(h->pdev))
+		return;
+
+	if (ae_dev->dev_version > HNAE3_DEVICE_VERSION_V2)
+		pos += scnprintf(buf + pos, len - pos, "dump nodes\n");
+
+	pos += scnprintf(buf + pos, len - pos, "dump priority <pri id>\n");
+	pos += scnprintf(buf + pos, len - pos, "dump qset <qset id>\n");
+}
+
 static void hns3_dbg_dev_caps(struct hnae3_handle *h)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
@@ -484,6 +505,93 @@ static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
 	return count;
 }
 
+static ssize_t hns3_dbg_tm_read(struct file *filp, char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	struct hnae3_handle *handle = filp->private_data;
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	struct hns3_nic_priv *priv  = handle->priv;
+	char *cmd_buf, *read_buf;
+	ssize_t size = 0;
+	int ret = 0;
+
+	if (strncmp(filp->f_path.dentry->d_iname, HNS3_DBG_MODULE_NAME_TM,
+		    strlen(HNS3_DBG_MODULE_NAME_TM)) != 0)
+		return -EINVAL;
+
+	if (!priv->dbg_in_msg.tm)
+		return -EINVAL;
+
+	read_buf = kzalloc(HNS3_DBG_READ_LEN, GFP_KERNEL);
+	if (!read_buf)
+		return -ENOMEM;
+
+	cmd_buf = priv->dbg_in_msg.tm;
+	handle->dbgfs_type = HNAE3_DBG_MODULE_TYPE_TM;
+
+	if (strncmp(cmd_buf, HNS3_HELP_INFO, strlen(HNS3_HELP_INFO)) == 0)
+		hns3_dbg_tm_help(handle, read_buf, HNS3_DBG_READ_LEN);
+	else if (ops->dbg_read_cmd)
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
+out:
+	kfree(read_buf);
+	return size;
+}
+
+static ssize_t hns3_dbg_tm_write(struct file *filp, const char __user *buffer,
+				 size_t count, loff_t *ppos)
+{
+	struct hnae3_handle *handle = filp->private_data;
+	struct hns3_nic_priv *priv  = handle->priv;
+	char *cmd_buf, *cmd_buf_tmp;
+	int uncopied_bytes;
+
+	if (*ppos != 0)
+		return 0;
+
+	/* Judge if the instance is being reset. */
+	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state) ||
+	    test_bit(HNS3_NIC_STATE_RESETTING, &priv->state))
+		return 0;
+
+	if (count > HNS3_DBG_WRITE_LEN)
+		return -ENOSPC;
+
+	kfree(priv->dbg_in_msg.tm);
+	priv->dbg_in_msg.tm = NULL;
+
+	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
+	if (!cmd_buf)
+		return count;
+
+	uncopied_bytes = copy_from_user(cmd_buf, buffer, count);
+	if (uncopied_bytes) {
+		kfree(cmd_buf);
+		return -EFAULT;
+	}
+
+	cmd_buf[count] = '\0';
+
+	cmd_buf_tmp = strchr(cmd_buf, '\n');
+	if (cmd_buf_tmp) {
+		*cmd_buf_tmp = '\0';
+		count = cmd_buf_tmp - cmd_buf + 1;
+	}
+
+	priv->dbg_in_msg.tm = cmd_buf;
+
+	return count;
+}
+
 static const struct file_operations hns3_dbg_cmd_fops = {
 	.owner = THIS_MODULE,
 	.open  = simple_open,
@@ -491,6 +599,13 @@ static const struct file_operations hns3_dbg_cmd_fops = {
 	.write = hns3_dbg_cmd_write,
 };
 
+static const struct file_operations hns3_dbg_tm_fops = {
+	.owner = THIS_MODULE,
+	.open  = simple_open,
+	.read  = hns3_dbg_tm_read,
+	.write = hns3_dbg_tm_write,
+};
+
 void hns3_dbg_init(struct hnae3_handle *handle)
 {
 	const char *name = pci_name(handle->pdev);
@@ -499,6 +614,9 @@ void hns3_dbg_init(struct hnae3_handle *handle)
 
 	debugfs_create_file("cmd", 0600, handle->hnae3_dbgfs, handle,
 			    &hns3_dbg_cmd_fops);
+
+	debugfs_create_file(HNS3_DBG_MODULE_NAME_TM, 0600, handle->hnae3_dbgfs,
+			    handle, &hns3_dbg_tm_fops);
 }
 
 void hns3_dbg_uninit(struct hnae3_handle *handle)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 0a7b606..76dd30d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -490,6 +490,10 @@ struct hns3_enet_tqp_vector {
 	unsigned long last_jiffies;
 } ____cacheline_internodealigned_in_smp;
 
+struct hns3_dbg_input_msg {
+	char *tm;
+};
+
 struct hns3_nic_priv {
 	struct hnae3_handle *ae_handle;
 	struct net_device *netdev;
@@ -510,6 +514,8 @@ struct hns3_nic_priv {
 
 	struct hns3_enet_coalesce tx_coal;
 	struct hns3_enet_coalesce rx_coal;
+
+	struct hns3_dbg_input_msg dbg_in_msg;
 };
 
 union l3_hdr_info {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index edfadb5..f861bdb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -160,6 +160,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_TM_PRI_SCH_MODE_CFG   = 0x0813,
 	HCLGE_OPC_TM_QS_SCH_MODE_CFG    = 0x0814,
 	HCLGE_OPC_TM_BP_TO_QSET_MAPPING = 0x0815,
+	HCLGE_OPC_TM_NODES		= 0x0816,
 	HCLGE_OPC_ETS_TC_WEIGHT		= 0x0843,
 	HCLGE_OPC_QSET_DFX_STS		= 0x0844,
 	HCLGE_OPC_PRI_DFX_STS		= 0x0845,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 8f6dea5..1f13a5b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -800,6 +800,224 @@ static void hclge_dbg_dump_tm_map(struct hclge_dev *hdev,
 		cmd, ret);
 }
 
+static void hclge_dbg_dump_tm_nodes(struct hclge_dev *hdev, char *buf, int len)
+{
+	struct hclge_tm_nodes_cmd *nodes;
+	struct hclge_desc desc;
+	int pos = 0;
+	int ret;
+
+	if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2) {
+		dev_err(&hdev->pdev->dev, "unsupported command!\n");
+		return;
+	}
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_NODES, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump tm nodes, ret = %d\n", ret);
+		return;
+	}
+
+	nodes = (struct hclge_tm_nodes_cmd *)desc.data;
+
+	pos += scnprintf(buf + pos, len - pos, "PG base_id: %u\n",
+			 nodes->pg_base_id);
+	pos += scnprintf(buf + pos, len - pos, "PG number: %u\n",
+			 nodes->pg_num);
+	pos += scnprintf(buf + pos, len - pos, "PRI base_id: %u\n",
+			 nodes->pri_base_id);
+	pos += scnprintf(buf + pos, len - pos, "PRI number: %u\n",
+			 nodes->pri_num);
+	pos += scnprintf(buf + pos, len - pos, "QSET base_id: %u\n",
+			 le16_to_cpu(nodes->qset_base_id));
+	pos += scnprintf(buf + pos, len - pos, "QSET number: %u\n",
+			 le16_to_cpu(nodes->qset_num));
+	pos += scnprintf(buf + pos, len - pos, "QUEUE base_id: %u\n",
+			 le16_to_cpu(nodes->queue_base_id));
+	pos += scnprintf(buf + pos, len - pos, "QUEUE number: %u\n",
+			 le16_to_cpu(nodes->queue_num));
+}
+
+static int hclge_dbg_dump_tm_pri_sch(struct hclge_dev *hdev, u8 pri_id,
+				     char *buf, int len)
+{
+	struct hclge_priority_weight_cmd *priority_weight;
+	struct hclge_pri_sch_mode_cfg_cmd *pri_sch_mode;
+	enum hclge_opcode_type cmd;
+	struct hclge_desc desc;
+	int pos = 0;
+	int ret;
+
+	cmd = HCLGE_OPC_TM_PRI_SCH_MODE_CFG;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	pri_sch_mode = (struct hclge_pri_sch_mode_cfg_cmd *)desc.data;
+	pri_sch_mode->pri_id = pri_id;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_pri_sch_cmd_send;
+
+	pos += scnprintf(buf + pos, len - pos, "PRI schedule mode: %s\n",
+			 (pri_sch_mode->sch_mode & HCLGE_TM_TX_SCHD_DWRR_MSK) ?
+			 "dwrr" : "sp");
+
+	cmd = HCLGE_OPC_TM_PRI_WEIGHT;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	priority_weight = (struct hclge_priority_weight_cmd *)desc.data;
+	priority_weight->pri_id = pri_id;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_pri_sch_cmd_send;
+
+	pos += scnprintf(buf + pos, len - pos, "PRI dwrr: %u\n",
+			 priority_weight->dwrr);
+
+	return pos;
+
+err_tm_pri_sch_cmd_send:
+	dev_err(&hdev->pdev->dev,
+		"failed to dump tm priority(0x%x), ret = %d\n", cmd, ret);
+
+	return pos;
+}
+
+static void hclge_dbg_dump_tm_pri_shaping(struct hclge_dev *hdev, u8 pri_id,
+					  char *buf, int len)
+{
+	struct hclge_pri_shapping_cmd *shap_cfg_cmd;
+	u8 ir_u, ir_b, ir_s, bs_b, bs_s;
+	enum hclge_opcode_type cmd;
+	struct hclge_desc desc;
+	u32 shapping_para;
+	int pos = 0;
+	int ret;
+
+	cmd = HCLGE_OPC_TM_PRI_C_SHAPPING;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	shap_cfg_cmd = (struct hclge_pri_shapping_cmd *)desc.data;
+	shap_cfg_cmd->pri_id = pri_id;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_pri_shaping_cmd_send;
+
+	shapping_para = le32_to_cpu(shap_cfg_cmd->pri_shapping_para);
+	ir_b = hclge_tm_get_field(shapping_para, IR_B);
+	ir_u = hclge_tm_get_field(shapping_para, IR_U);
+	ir_s = hclge_tm_get_field(shapping_para, IR_S);
+	bs_b = hclge_tm_get_field(shapping_para, BS_B);
+	bs_s = hclge_tm_get_field(shapping_para, BS_S);
+	pos += scnprintf(buf + pos, len - pos,
+			 "PRI_C ir_b:%u ir_u:%u ir_s:%u bs_b:%u bs_s:%u\n",
+			 ir_b, ir_u, ir_s, bs_b, bs_s);
+	pos += scnprintf(buf + pos, len - pos, "PRI_C flag: %#x\n",
+			 shap_cfg_cmd->flag);
+	pos += scnprintf(buf + pos, len - pos, "PRI_C pri_rate: %u(Mbps)\n",
+			 le32_to_cpu(shap_cfg_cmd->pri_rate));
+
+	cmd = HCLGE_OPC_TM_PRI_P_SHAPPING;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	shap_cfg_cmd = (struct hclge_pri_shapping_cmd *)desc.data;
+	shap_cfg_cmd->pri_id = pri_id;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_pri_shaping_cmd_send;
+
+	shapping_para = le32_to_cpu(shap_cfg_cmd->pri_shapping_para);
+	ir_b = hclge_tm_get_field(shapping_para, IR_B);
+	ir_u = hclge_tm_get_field(shapping_para, IR_U);
+	ir_s = hclge_tm_get_field(shapping_para, IR_S);
+	bs_b = hclge_tm_get_field(shapping_para, BS_B);
+	bs_s = hclge_tm_get_field(shapping_para, BS_S);
+	pos += scnprintf(buf + pos, len - pos,
+			 "PRI_P ir_b:%u ir_u:%u ir_s:%u bs_b:%u bs_s:%u\n",
+			 ir_b, ir_u, ir_s, bs_b, bs_s);
+	pos += scnprintf(buf + pos, len - pos, "PRI_P flag: %#x\n",
+			 shap_cfg_cmd->flag);
+	pos += scnprintf(buf + pos, len - pos, "PRI_P pri_rate: %u(Mbps)\n",
+			 le32_to_cpu(shap_cfg_cmd->pri_rate));
+
+	return;
+
+err_tm_pri_shaping_cmd_send:
+	dev_err(&hdev->pdev->dev,
+		"failed to dump tm priority(0x%x), ret = %d\n", cmd, ret);
+}
+
+static void hclge_dbg_dump_tm_pri(struct hclge_dev *hdev, const char *cmd_buf,
+				  char *buf, int len)
+{
+	int ret, pos;
+	u8 pri_id;
+
+	ret = kstrtou8(cmd_buf, 0, &pri_id);
+	pri_id = (ret != 0) ? 0 : pri_id;
+
+	pos = scnprintf(buf, len, "priority id: %u\n", pri_id);
+
+	pos += hclge_dbg_dump_tm_pri_sch(hdev, pri_id, buf + pos, len - pos);
+	hclge_dbg_dump_tm_pri_shaping(hdev, pri_id, buf + pos, len - pos);
+}
+
+static void hclge_dbg_dump_tm_qset(struct hclge_dev *hdev, const char *cmd_buf,
+				   char *buf, int len)
+{
+	struct hclge_qs_sch_mode_cfg_cmd *qs_sch_mode;
+	struct hclge_qs_weight_cmd *qs_weight;
+	struct hclge_qs_to_pri_link_cmd *map;
+	enum hclge_opcode_type cmd;
+	struct hclge_desc desc;
+	int ret, pos;
+	u16 qset_id;
+
+	ret = kstrtou16(cmd_buf, 0, &qset_id);
+	qset_id = (ret != 0) ? 0 : qset_id;
+
+	pos = scnprintf(buf, len, "qset id: %u\n", qset_id);
+
+	cmd = HCLGE_OPC_TM_QS_TO_PRI_LINK;
+	map = (struct hclge_qs_to_pri_link_cmd *)desc.data;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	map->qs_id = cpu_to_le16(qset_id);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_qset_cmd_send;
+
+	pos += scnprintf(buf + pos, len - pos, "QS map pri id: %u\n",
+			 map->priority);
+	pos += scnprintf(buf + pos, len - pos, "QS map link_vld: %u\n",
+			 map->link_vld);
+
+	cmd = HCLGE_OPC_TM_QS_SCH_MODE_CFG;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	qs_sch_mode = (struct hclge_qs_sch_mode_cfg_cmd *)desc.data;
+	qs_sch_mode->qs_id = cpu_to_le16(qset_id);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_qset_cmd_send;
+
+	pos += scnprintf(buf + pos, len - pos, "QS schedule mode: %s\n",
+			 (qs_sch_mode->sch_mode & HCLGE_TM_TX_SCHD_DWRR_MSK) ?
+			 "dwrr" : "sp");
+
+	cmd = HCLGE_OPC_TM_QS_WEIGHT;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	qs_weight = (struct hclge_qs_weight_cmd *)desc.data;
+	qs_weight->qs_id = cpu_to_le16(qset_id);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_qset_cmd_send;
+
+	pos += scnprintf(buf + pos, len - pos, "QS dwrr: %u\n",
+			 qs_weight->dwrr);
+
+	return;
+
+err_tm_qset_cmd_send:
+	dev_err(&hdev->pdev->dev, "failed to dump tm qset(0x%x), ret = %d\n",
+		cmd, ret);
+}
+
 static void hclge_dbg_dump_qos_pause_cfg(struct hclge_dev *hdev)
 {
 	struct hclge_cfg_pause_param_cmd *pause_param;
@@ -1591,3 +1809,36 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 
 	return 0;
 }
+
+static int hclge_dbg_read_cmd_tm(struct hnae3_handle *handle,
+				 const char *cmd_buf, char *buf, int len)
+{
+#define DUMP_TM_NODE	"dump nodes"
+#define DUMP_TM_PRI	"dump priority"
+#define DUMP_TM_QSET	"dump qset"
+
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	if (strncmp(cmd_buf, DUMP_TM_NODE, strlen(DUMP_TM_NODE)) == 0)
+		hclge_dbg_dump_tm_nodes(hdev, buf, len);
+	else if (strncmp(cmd_buf, DUMP_TM_PRI, strlen(DUMP_TM_PRI)) == 0)
+		hclge_dbg_dump_tm_pri(hdev, &cmd_buf[sizeof(DUMP_TM_PRI)],
+				      buf, len);
+	else if (strncmp(cmd_buf, DUMP_TM_QSET, strlen(DUMP_TM_QSET)) == 0)
+		hclge_dbg_dump_tm_qset(hdev, &cmd_buf[sizeof(DUMP_TM_QSET)],
+				       buf, len);
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+int hclge_dbg_read_cmd(struct hnae3_handle *handle, const char *cmd_buf,
+		       char *buf, int len)
+{
+	if (handle->dbgfs_type == HNAE3_DBG_MODULE_TYPE_TM)
+		return hclge_dbg_read_cmd_tm(handle, cmd_buf, buf, len);
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
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 5498d73..4fd7e4f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -65,6 +65,18 @@ struct hclge_priority_weight_cmd {
 	u8 dwrr;
 };
 
+struct hclge_pri_sch_mode_cfg_cmd {
+	u8 pri_id;
+	u8 rev[3];
+	u8 sch_mode;
+};
+
+struct hclge_qs_sch_mode_cfg_cmd {
+	__le16 qs_id;
+	u8 rev[2];
+	u8 sch_mode;
+};
+
 struct hclge_qs_weight_cmd {
 	__le16 qs_id;
 	u8 dwrr;
@@ -173,6 +185,17 @@ struct hclge_shaper_ir_para {
 	u8 ir_s; /* IR_S parameter of IR shaper */
 };
 
+struct hclge_tm_nodes_cmd {
+	u8 pg_base_id;
+	u8 pri_base_id;
+	__le16 qset_base_id;
+	__le16 queue_base_id;
+	u8 pg_num;
+	u8 pri_num;
+	__le16 qset_num;
+	__le16 queue_num;
+};
+
 #define hclge_tm_set_field(dest, string, val) \
 			   hnae3_set_field((dest), \
 			   (HCLGE_TM_SHAP_##string##_MSK), \
-- 
2.7.4

