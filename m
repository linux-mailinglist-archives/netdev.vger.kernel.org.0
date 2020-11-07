Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B91E2AA2C8
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 07:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgKGGbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 01:31:33 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6759 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727934AbgKGGbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 01:31:17 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CSnT14ywSzkdB9;
        Sat,  7 Nov 2020 14:31:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sat, 7 Nov 2020 14:30:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/11] net: hns3: add debugfs support for interrupt coalesce
Date:   Sat, 7 Nov 2020 14:31:21 +0800
Message-ID: <1604730681-32559-12-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604730681-32559-1-git-send-email-tanhuazhong@huawei.com>
References: <1604730681-32559-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since user may need to check the current configuration of the
interrupt coalesce, so add debugfs support for query this info,
which includes DIM profile, coalesce configuration of both software
and hardware.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 124 +++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index a5ebca8..1efeed6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -12,6 +12,91 @@
 
 static struct dentry *hns3_dbgfs_root;
 
+static ssize_t hns3_dbg_coal_write(struct file *filp, const char __user *buffer,
+				   size_t count, loff_t *ppos)
+{
+	struct hnae3_handle *h = filp->private_data;
+	struct hns3_nic_priv *priv  = h->priv;
+	struct hns3_enet_tqp_vector *tqp_vector;
+	struct hns3_enet_coalesce *coal;
+	int uncopied_bytes;
+	unsigned int idx;
+	struct dim *dim;
+	char *cmd_buf;
+
+	if (*ppos != 0)
+		return 0;
+
+	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state)) {
+		dev_err(&h->pdev->dev, "device is not initialized\n");
+		return -EFAULT;
+	}
+
+	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
+	if (!cmd_buf)
+		return -ENOMEM;
+
+	uncopied_bytes = copy_from_user(cmd_buf, buffer, count);
+	if (uncopied_bytes) {
+		kfree(cmd_buf);
+		return -EFAULT;
+	}
+
+	cmd_buf[count] = '\0';
+
+	if (kstrtouint(cmd_buf, 0, &idx))
+		idx = 0;
+
+	if (idx >= priv->vector_num) {
+		dev_err(&h->pdev->dev,
+			"vector index(%u) is out of range(0-%u)\n", idx,
+			priv->vector_num - 1);
+		kfree(cmd_buf);
+		return -EINVAL;
+	}
+
+	tqp_vector = &priv->tqp_vector[idx];
+	coal = &tqp_vector->tx_group.coal;
+	dim = &tqp_vector->tx_group.dim;
+
+	dev_info(&h->pdev->dev, "vector[%u] interrupt coalesce info:\n", idx);
+	dev_info(&h->pdev->dev,
+		 "TX DIM info state = %d profile_ix = %d mode = %d tune_state = %d steps_right = %d steps_left = %d tired = %d\n",
+		 dim->state, dim->profile_ix, dim->mode, dim->tune_state,
+		 dim->steps_right, dim->steps_left, dim->tired);
+
+	dev_info(&h->pdev->dev, "TX GL info sw_gl = %u, hw_gl = %u\n",
+		 coal->int_gl,
+		 readl(tqp_vector->mask_addr + HNS3_VECTOR_GL1_OFFSET));
+
+	if (coal->ql_enable)
+		dev_info(&h->pdev->dev, "TX QL info sw_ql = %u, hw_ql = %u\n",
+			 coal->int_ql,
+			 readl(tqp_vector->mask_addr + HNS3_VECTOR_TX_QL_OFFSET));
+
+	coal = &tqp_vector->rx_group.coal;
+	dim = &tqp_vector->rx_group.dim;
+
+	dev_info(&h->pdev->dev,
+		 "RX dim_info state = %d profile_ix = %d mode = %d tune_state = %d steps_right = %d steps_left = %d tired = %d\n",
+		 dim->state, dim->profile_ix, dim->mode, dim->tune_state,
+		 dim->steps_right, dim->steps_left, dim->tired);
+
+	dev_info(&h->pdev->dev, "RX GL info sw_gl = %u, hw_gl = %u\n",
+		 coal->int_gl,
+		 readl(tqp_vector->mask_addr + HNS3_VECTOR_GL0_OFFSET));
+
+	if (coal->ql_enable)
+		dev_info(&h->pdev->dev, "RX QL info sw_ql = %u, hw_ql = %u\n",
+			 coal->int_ql,
+			 readl(tqp_vector->mask_addr + HNS3_VECTOR_RX_QL_OFFSET));
+
+	kfree(cmd_buf);
+	cmd_buf = NULL;
+
+	return count;
+}
+
 static int hns3_dbg_queue_info(struct hnae3_handle *h,
 			       const char *cmd_buf)
 {
@@ -352,6 +437,35 @@ static void hns3_dbg_dev_specs(struct hnae3_handle *h)
 	dev_info(priv->dev, "MAX INT GL: %u\n", dev_specs->max_int_gl);
 }
 
+static ssize_t hns3_dbg_coal_read(struct file *filp, char __user *buffer,
+				  size_t count, loff_t *ppos)
+{
+	int uncopy_bytes;
+	char *buf;
+	int len;
+
+	if (*ppos != 0)
+		return 0;
+
+	if (count < HNS3_DBG_READ_LEN)
+		return -ENOSPC;
+
+	buf = kzalloc(HNS3_DBG_READ_LEN, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	len = scnprintf(buf, HNS3_DBG_READ_LEN, "%s\n",
+			"Please echo index to coal");
+	uncopy_bytes = copy_to_user(buffer, buf, len);
+
+	kfree(buf);
+
+	if (uncopy_bytes)
+		return -EFAULT;
+
+	return (*ppos = len);
+}
+
 static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
 				 size_t count, loff_t *ppos)
 {
@@ -452,6 +566,13 @@ static const struct file_operations hns3_dbg_cmd_fops = {
 	.write = hns3_dbg_cmd_write,
 };
 
+static const struct file_operations hns3_dbg_coal_fops = {
+	.owner = THIS_MODULE,
+	.open  = simple_open,
+	.read  = hns3_dbg_coal_read,
+	.write = hns3_dbg_coal_write,
+};
+
 void hns3_dbg_init(struct hnae3_handle *handle)
 {
 	const char *name = pci_name(handle->pdev);
@@ -460,6 +581,9 @@ void hns3_dbg_init(struct hnae3_handle *handle)
 
 	debugfs_create_file("cmd", 0600, handle->hnae3_dbgfs, handle,
 			    &hns3_dbg_cmd_fops);
+
+	debugfs_create_file("coal", 0600, handle->hnae3_dbgfs, handle,
+			    &hns3_dbg_coal_fops);
 }
 
 void hns3_dbg_uninit(struct hnae3_handle *handle)
-- 
2.7.4

