Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8BF25493A
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgH0PWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:22:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10283 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728601AbgH0Lat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 07:30:49 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B3D48D85BBB17A918967;
        Thu, 27 Aug 2020 19:12:40 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Thu, 27 Aug 2020 19:12:30 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v1 1/3] hinic: add support to query sq info
Date:   Thu, 27 Aug 2020 19:13:19 +0800
Message-ID: <20200827111321.24272-2-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827111321.24272-1-luobin9@huawei.com>
References: <20200827111321.24272-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add debugfs node for querying sq info, for example:
cat /sys/kernel/debug/hinic/0000:15:00.0/SQs/0x0/sq_pi

Signed-off-by: Luo bin <luobin9@huawei.com>
---
V0~V1:
- remove command interfaces to the read only files
- split addition of each object into a separate patch

 drivers/net/ethernet/huawei/hinic/Makefile    |   3 +-
 .../net/ethernet/huawei/hinic/hinic_debugfs.c | 162 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_debugfs.h |  27 +++
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |  15 ++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |   1 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.c   |   1 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.h   |   1 +
 .../net/ethernet/huawei/hinic/hinic_hw_qp.h   |   3 +
 .../net/ethernet/huawei/hinic/hinic_main.c    |  45 ++++-
 9 files changed, 254 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_debugfs.h

diff --git a/drivers/net/ethernet/huawei/hinic/Makefile b/drivers/net/ethernet/huawei/hinic/Makefile
index 67b59d0ba769..2f89119c9b69 100644
--- a/drivers/net/ethernet/huawei/hinic/Makefile
+++ b/drivers/net/ethernet/huawei/hinic/Makefile
@@ -4,4 +4,5 @@ obj-$(CONFIG_HINIC) += hinic.o
 hinic-y := hinic_main.o hinic_tx.o hinic_rx.o hinic_port.o hinic_hw_dev.o \
 	   hinic_hw_io.o hinic_hw_qp.o hinic_hw_cmdq.o hinic_hw_wq.o \
 	   hinic_hw_mgmt.o hinic_hw_api_cmd.o hinic_hw_eqs.o hinic_hw_if.o \
-	   hinic_common.o hinic_ethtool.o hinic_devlink.o hinic_hw_mbox.o hinic_sriov.o
+	   hinic_common.o hinic_ethtool.o hinic_devlink.o hinic_hw_mbox.o \
+	   hinic_sriov.o hinic_debugfs.o
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
new file mode 100644
index 000000000000..2a1050cb400e
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Huawei HiNIC PCI Express Linux driver
+ * Copyright(c) 2017 Huawei Technologies Co., Ltd
+ */
+
+#include <linux/debugfs.h>
+#include <linux/device.h>
+
+#include "hinic_debugfs.h"
+
+static struct dentry *hinic_dbgfs_root;
+
+enum sq_dbg_info {
+	GLB_SQ_ID,
+	SQ_PI,
+	SQ_CI,
+	SQ_FI,
+	SQ_MSIX_ENTRY,
+};
+
+static char *sq_fields[] = {"glb_sq_id", "sq_pi", "sq_ci", "sq_fi", "sq_msix_entry"};
+
+static u64 hinic_dbg_get_sq_info(struct hinic_dev *nic_dev, struct hinic_sq *sq, int idx)
+{
+	struct hinic_wq *wq = sq->wq;
+
+	switch (idx) {
+	case GLB_SQ_ID:
+		return nic_dev->hwdev->func_to_io.global_qpn + sq->qid;
+	case SQ_PI:
+		return atomic_read(&wq->prod_idx) & wq->mask;
+	case SQ_CI:
+		return atomic_read(&wq->cons_idx) & wq->mask;
+	case SQ_FI:
+		return be16_to_cpu(*(__be16 *)(sq->hw_ci_addr)) & wq->mask;
+	case SQ_MSIX_ENTRY:
+		return sq->msix_entry;
+	}
+
+	return 0;
+}
+
+static ssize_t hinic_dbg_cmd_read(struct file *filp, char __user *buffer, size_t count,
+				  loff_t *ppos)
+{
+	struct hinic_debug_priv *dbg;
+	char ret_buf[20];
+	int *desc;
+	u64 out;
+	int ret;
+
+	desc = filp->private_data;
+	dbg = container_of(desc, struct hinic_debug_priv, field_id[*desc]);
+
+	switch (dbg->type) {
+	case HINIC_DBG_SQ_INFO:
+		out = hinic_dbg_get_sq_info(dbg->dev, dbg->object, *desc);
+		break;
+
+	default:
+		netif_warn(dbg->dev, drv, dbg->dev->netdev, "Invalid hinic debug cmd: %d\n",
+			   dbg->type);
+		return -EINVAL;
+	}
+
+	ret = snprintf(ret_buf, sizeof(ret_buf), "0x%llx\n", out);
+
+	return simple_read_from_buffer(buffer, count, ppos, ret_buf, ret);
+}
+
+static const struct file_operations hinic_dbg_cmd_fops = {
+	.owner = THIS_MODULE,
+	.open  = simple_open,
+	.read  = hinic_dbg_cmd_read,
+};
+
+static int create_dbg_files(struct hinic_dev *dev, enum hinic_dbg_type type, void *data,
+			    struct dentry *root, struct hinic_debug_priv **dbg, char **field,
+			    int nfile)
+{
+	struct hinic_debug_priv *tmp;
+	int i;
+
+	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	tmp->dev = dev;
+	tmp->object = data;
+	tmp->type = type;
+	tmp->root = root;
+
+	for (i = 0; i < nfile; i++) {
+		tmp->field_id[i] = i;
+		debugfs_create_file(field[i], 0400, root, &tmp->field_id[i], &hinic_dbg_cmd_fops);
+	}
+
+	*dbg = tmp;
+
+	return 0;
+}
+
+static void rem_dbg_files(struct hinic_debug_priv *dbg)
+{
+	debugfs_remove_recursive(dbg->root);
+	kfree(dbg);
+}
+
+int hinic_sq_debug_add(struct hinic_dev *dev, u16 sq_id)
+{
+	struct hinic_sq *sq;
+	struct dentry *root;
+	char sub_dir[16];
+
+	sq = dev->txqs[sq_id].sq;
+
+	sprintf(sub_dir, "0x%x", sq_id);
+
+	root = debugfs_create_dir(sub_dir, dev->sq_dbgfs);
+
+	return create_dbg_files(dev, HINIC_DBG_SQ_INFO, sq, root, &sq->dbg, sq_fields,
+				ARRAY_SIZE(sq_fields));
+}
+
+void hinic_sq_debug_rem(struct hinic_sq *sq)
+{
+	if (sq->dbg)
+		rem_dbg_files(sq->dbg);
+}
+
+void hinic_sq_dbgfs_init(struct hinic_dev *nic_dev)
+{
+	nic_dev->sq_dbgfs = debugfs_create_dir("SQs", nic_dev->dbgfs_root);
+}
+
+void hinic_sq_dbgfs_uninit(struct hinic_dev *nic_dev)
+{
+	debugfs_remove_recursive(nic_dev->sq_dbgfs);
+}
+
+void hinic_dbg_init(struct hinic_dev *nic_dev)
+{
+	nic_dev->dbgfs_root = debugfs_create_dir(pci_name(nic_dev->hwdev->hwif->pdev),
+						 hinic_dbgfs_root);
+}
+
+void hinic_dbg_uninit(struct hinic_dev *nic_dev)
+{
+	debugfs_remove_recursive(nic_dev->dbgfs_root);
+	nic_dev->dbgfs_root = NULL;
+}
+
+void hinic_dbg_register_debugfs(const char *debugfs_dir_name)
+{
+	hinic_dbgfs_root = debugfs_create_dir(debugfs_dir_name, NULL);
+}
+
+void hinic_dbg_unregister_debugfs(void)
+{
+	debugfs_remove_recursive(hinic_dbgfs_root);
+	hinic_dbgfs_root = NULL;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
new file mode 100644
index 000000000000..45fb3b40f487
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Huawei HiNIC PCI Express Linux driver
+ * Copyright(c) 2017 Huawei Technologies Co., Ltd
+ */
+
+#ifndef HINIC_DEBUGFS_H
+#define HINIC_DEBUGFS_H
+
+#include "hinic_dev.h"
+
+int hinic_sq_debug_add(struct hinic_dev *dev, u16 sq_id);
+
+void hinic_sq_debug_rem(struct hinic_sq *sq);
+
+void hinic_sq_dbgfs_init(struct hinic_dev *nic_dev);
+
+void hinic_sq_dbgfs_uninit(struct hinic_dev *nic_dev);
+
+void hinic_dbg_init(struct hinic_dev *nic_dev);
+
+void hinic_dbg_uninit(struct hinic_dev *nic_dev);
+
+void hinic_dbg_register_debugfs(const char *debugfs_dir_name);
+
+void hinic_dbg_unregister_debugfs(void);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index 0a1e20edf7cf..95d9548014ac 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -58,6 +58,18 @@ struct hinic_intr_coal_info {
 	u8	resend_timer_cfg;
 };
 
+enum hinic_dbg_type {
+	HINIC_DBG_SQ_INFO,
+};
+
+struct hinic_debug_priv {
+	struct hinic_dev	*dev;
+	void			*object;
+	enum hinic_dbg_type	type;
+	struct dentry		*root;
+	int			field_id[64];
+};
+
 struct hinic_dev {
 	struct net_device               *netdev;
 	struct hinic_hwdev              *hwdev;
@@ -97,6 +109,9 @@ struct hinic_dev {
 	int				lb_test_rx_idx;
 	int				lb_pkt_len;
 	u8				*lb_test_rx_buf;
+
+	struct dentry			*dbgfs_root;
+	struct dentry			*sq_dbgfs;
 	struct devlink			*devlink;
 	bool				cable_unplugged;
 	bool				module_unrecognized;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 0c737765d113..239685152f6e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -465,6 +465,7 @@ int hinic_hwdev_ifup(struct hinic_hwdev *hwdev, u16 sq_depth, u16 rq_depth)
 	func_to_io->hwdev = hwdev;
 	func_to_io->sq_depth = sq_depth;
 	func_to_io->rq_depth = rq_depth;
+	func_to_io->global_qpn = base_qpn;
 
 	err = hinic_io_init(func_to_io, hwif, nic_cap->max_qps, num_ceqs,
 			    ceq_msix_entries);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
index 3e3fa742e476..39a38edb89d6 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
@@ -305,6 +305,7 @@ static int init_qp(struct hinic_func_to_io *func_to_io,
 
 	func_to_io->sq_db[q_id] = db_base;
 
+	qp->sq.qid = q_id;
 	err = hinic_init_sq(&qp->sq, hwif, &func_to_io->sq_wq[q_id],
 			    sq_msix_entry,
 			    CI_ADDR(func_to_io->ci_addr_base, q_id),
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
index ee6d60762d84..52159a90278a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
@@ -59,6 +59,7 @@ struct hinic_nic_cfg {
 struct hinic_func_to_io {
 	struct hinic_hwif       *hwif;
 	struct hinic_hwdev      *hwdev;
+	u16			global_qpn;
 	struct hinic_ceqs       ceqs;
 
 	struct hinic_wqs        wqs;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
index ca3e2d060284..936605cec4ab 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
@@ -81,6 +81,8 @@ struct hinic_sq {
 
 	struct hinic_wq         *wq;
 
+	u16			qid;
+
 	u32                     irq;
 	u16                     msix_entry;
 
@@ -90,6 +92,7 @@ struct hinic_sq {
 	void __iomem            *db_base;
 
 	struct sk_buff          **saved_skb;
+	struct hinic_debug_priv	*dbg;
 };
 
 struct hinic_rq {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 501056fd32ee..aad1e5e1bfbe 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 
+#include "hinic_debugfs.h"
 #include "hinic_hw_qp.h"
 #include "hinic_hw_dev.h"
 #include "hinic_devlink.h"
@@ -153,6 +154,8 @@ static int create_txqs(struct hinic_dev *nic_dev)
 	if (!nic_dev->txqs)
 		return -ENOMEM;
 
+	hinic_sq_dbgfs_init(nic_dev);
+
 	for (i = 0; i < num_txqs; i++) {
 		struct hinic_sq *sq = hinic_hwdev_get_sq(nic_dev->hwdev, i);
 
@@ -162,13 +165,27 @@ static int create_txqs(struct hinic_dev *nic_dev)
 				  "Failed to init Txq\n");
 			goto err_init_txq;
 		}
+
+		err = hinic_sq_debug_add(nic_dev, i);
+		if (err) {
+			netif_err(nic_dev, drv, netdev,
+				  "Failed to add SQ%d debug\n", i);
+			goto err_add_sq_dbg;
+		}
+
 	}
 
 	return 0;
 
+err_add_sq_dbg:
+	hinic_clean_txq(&nic_dev->txqs[i]);
 err_init_txq:
-	for (j = 0; j < i; j++)
+	for (j = 0; j < i; j++) {
+		hinic_sq_debug_rem(nic_dev->txqs[j].sq);
 		hinic_clean_txq(&nic_dev->txqs[j]);
+	}
+
+	hinic_sq_dbgfs_uninit(nic_dev);
 
 	devm_kfree(&netdev->dev, nic_dev->txqs);
 	return err;
@@ -186,8 +203,12 @@ static void free_txqs(struct hinic_dev *nic_dev)
 	if (!nic_dev->txqs)
 		return;
 
-	for (i = 0; i < num_txqs; i++)
+	for (i = 0; i < num_txqs; i++) {
+		hinic_sq_debug_rem(nic_dev->txqs[i].sq);
 		hinic_clean_txq(&nic_dev->txqs[i]);
+	}
+
+	hinic_sq_dbgfs_uninit(nic_dev);
 
 	devm_kfree(&netdev->dev, nic_dev->txqs);
 	nic_dev->txqs = NULL;
@@ -1260,6 +1281,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 		goto err_init_intr;
 	}
 
+	hinic_dbg_init(nic_dev);
+
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to register netdev\n");
@@ -1269,6 +1292,7 @@ static int nic_dev_init(struct pci_dev *pdev)
 	return 0;
 
 err_reg_netdev:
+	hinic_dbg_uninit(nic_dev);
 	hinic_free_intr_coalesce(nic_dev);
 err_init_intr:
 err_set_pfc:
@@ -1391,6 +1415,8 @@ static void hinic_remove(struct pci_dev *pdev)
 
 	unregister_netdev(netdev);
 
+	hinic_dbg_uninit(nic_dev);
+
 	hinic_free_intr_coalesce(nic_dev);
 
 	hinic_port_del_mac(nic_dev, netdev->dev_addr, 0);
@@ -1445,4 +1471,17 @@ static struct pci_driver hinic_driver = {
 	.sriov_configure = hinic_pci_sriov_configure,
 };
 
-module_pci_driver(hinic_driver);
+static int __init hinic_module_init(void)
+{
+	hinic_dbg_register_debugfs(HINIC_DRV_NAME);
+	return pci_register_driver(&hinic_driver);
+}
+
+static void __exit hinic_module_exit(void)
+{
+	pci_unregister_driver(&hinic_driver);
+	hinic_dbg_unregister_debugfs();
+}
+
+module_init(hinic_module_init);
+module_exit(hinic_module_exit);
-- 
2.17.1

