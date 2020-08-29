Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD022563CD
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 02:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgH2Ayt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 20:54:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42864 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726797AbgH2Ayl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 20:54:41 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 175909D91A7EB9DB5EF1;
        Sat, 29 Aug 2020 08:54:38 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Sat, 29 Aug 2020 08:54:30 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v3 2/3] hinic: add support to query rq info
Date:   Sat, 29 Aug 2020 08:55:19 +0800
Message-ID: <20200829005520.27364-3-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200829005520.27364-1-luobin9@huawei.com>
References: <20200829005520.27364-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add debugfs node for querying rq info, for example:
cat /sys/kernel/debug/hinic/0000:15:00.0/RQs/0x0/rq_hw_pi

Signed-off-by: Luo bin <luobin9@huawei.com>
---
V0~V1:
- remove command interfaces to the read only files
- split addition of each object into a separate patch

 .../net/ethernet/huawei/hinic/hinic_debugfs.c | 66 +++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_debugfs.h |  8 +++
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |  2 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.c   |  1 +
 .../net/ethernet/huawei/hinic/hinic_hw_qp.h   |  3 +
 .../net/ethernet/huawei/hinic/hinic_main.c    | 23 ++++++-
 6 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
index 2a1050cb400e..d10d0a6d9f13 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
@@ -40,6 +40,36 @@ static u64 hinic_dbg_get_sq_info(struct hinic_dev *nic_dev, struct hinic_sq *sq,
 	return 0;
 }
 
+enum rq_dbg_info {
+	GLB_RQ_ID,
+	RQ_HW_PI,
+	RQ_SW_CI,
+	RQ_SW_PI,
+	RQ_MSIX_ENTRY,
+};
+
+static char *rq_fields[] = {"glb_rq_id", "rq_hw_pi", "rq_sw_ci", "rq_sw_pi", "rq_msix_entry"};
+
+static u64 hinic_dbg_get_rq_info(struct hinic_dev *nic_dev, struct hinic_rq *rq, int idx)
+{
+	struct hinic_wq *wq = rq->wq;
+
+	switch (idx) {
+	case GLB_RQ_ID:
+		return nic_dev->hwdev->func_to_io.global_qpn + rq->qid;
+	case RQ_HW_PI:
+		return be16_to_cpu(*(__be16 *)(rq->pi_virt_addr)) & wq->mask;
+	case RQ_SW_CI:
+		return atomic_read(&wq->cons_idx) & wq->mask;
+	case RQ_SW_PI:
+		return atomic_read(&wq->prod_idx) & wq->mask;
+	case RQ_MSIX_ENTRY:
+		return rq->msix_entry;
+	}
+
+	return 0;
+}
+
 static ssize_t hinic_dbg_cmd_read(struct file *filp, char __user *buffer, size_t count,
 				  loff_t *ppos)
 {
@@ -57,6 +87,10 @@ static ssize_t hinic_dbg_cmd_read(struct file *filp, char __user *buffer, size_t
 		out = hinic_dbg_get_sq_info(dbg->dev, dbg->object, *desc);
 		break;
 
+	case HINIC_DBG_RQ_INFO:
+		out = hinic_dbg_get_rq_info(dbg->dev, dbg->object, *desc);
+		break;
+
 	default:
 		netif_warn(dbg->dev, drv, dbg->dev->netdev, "Invalid hinic debug cmd: %d\n",
 			   dbg->type);
@@ -128,6 +162,28 @@ void hinic_sq_debug_rem(struct hinic_sq *sq)
 		rem_dbg_files(sq->dbg);
 }
 
+int hinic_rq_debug_add(struct hinic_dev *dev, u16 rq_id)
+{
+	struct hinic_rq *rq;
+	struct dentry *root;
+	char sub_dir[16];
+
+	rq = dev->rxqs[rq_id].rq;
+
+	sprintf(sub_dir, "0x%x", rq_id);
+
+	root = debugfs_create_dir(sub_dir, dev->rq_dbgfs);
+
+	return create_dbg_files(dev, HINIC_DBG_RQ_INFO, rq, root, &rq->dbg, rq_fields,
+				ARRAY_SIZE(rq_fields));
+}
+
+void hinic_rq_debug_rem(struct hinic_rq *rq)
+{
+	if (rq->dbg)
+		rem_dbg_files(rq->dbg);
+}
+
 void hinic_sq_dbgfs_init(struct hinic_dev *nic_dev)
 {
 	nic_dev->sq_dbgfs = debugfs_create_dir("SQs", nic_dev->dbgfs_root);
@@ -138,6 +194,16 @@ void hinic_sq_dbgfs_uninit(struct hinic_dev *nic_dev)
 	debugfs_remove_recursive(nic_dev->sq_dbgfs);
 }
 
+void hinic_rq_dbgfs_init(struct hinic_dev *nic_dev)
+{
+	nic_dev->rq_dbgfs = debugfs_create_dir("RQs", nic_dev->dbgfs_root);
+}
+
+void hinic_rq_dbgfs_uninit(struct hinic_dev *nic_dev)
+{
+	debugfs_remove_recursive(nic_dev->rq_dbgfs);
+}
+
 void hinic_dbg_init(struct hinic_dev *nic_dev)
 {
 	nic_dev->dbgfs_root = debugfs_create_dir(pci_name(nic_dev->hwdev->hwif->pdev),
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
index 45fb3b40f487..186ca4a26919 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
@@ -12,10 +12,18 @@ int hinic_sq_debug_add(struct hinic_dev *dev, u16 sq_id);
 
 void hinic_sq_debug_rem(struct hinic_sq *sq);
 
+int hinic_rq_debug_add(struct hinic_dev *dev, u16 rq_id);
+
+void hinic_rq_debug_rem(struct hinic_rq *rq);
+
 void hinic_sq_dbgfs_init(struct hinic_dev *nic_dev);
 
 void hinic_sq_dbgfs_uninit(struct hinic_dev *nic_dev);
 
+void hinic_rq_dbgfs_init(struct hinic_dev *nic_dev);
+
+void hinic_rq_dbgfs_uninit(struct hinic_dev *nic_dev);
+
 void hinic_dbg_init(struct hinic_dev *nic_dev);
 
 void hinic_dbg_uninit(struct hinic_dev *nic_dev);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index 95d9548014ac..0876a699d205 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -60,6 +60,7 @@ struct hinic_intr_coal_info {
 
 enum hinic_dbg_type {
 	HINIC_DBG_SQ_INFO,
+	HINIC_DBG_RQ_INFO,
 };
 
 struct hinic_debug_priv {
@@ -112,6 +113,7 @@ struct hinic_dev {
 
 	struct dentry			*dbgfs_root;
 	struct dentry			*sq_dbgfs;
+	struct dentry			*rq_dbgfs;
 	struct devlink			*devlink;
 	bool				cable_unplugged;
 	bool				module_unrecognized;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
index 39a38edb89d6..6772d8978722 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
@@ -315,6 +315,7 @@ static int init_qp(struct hinic_func_to_io *func_to_io,
 		goto err_sq_init;
 	}
 
+	qp->rq.qid = q_id;
 	err = hinic_init_rq(&qp->rq, hwif, &func_to_io->rq_wq[q_id],
 			    rq_msix_entry);
 	if (err) {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
index 936605cec4ab..0dfa51ad5855 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
@@ -100,6 +100,8 @@ struct hinic_rq {
 
 	struct hinic_wq         *wq;
 
+	u16			qid;
+
 	struct cpumask		affinity_mask;
 	u32                     irq;
 	u16                     msix_entry;
@@ -113,6 +115,7 @@ struct hinic_rq {
 
 	u16                     *pi_virt_addr;
 	dma_addr_t              pi_dma_addr;
+	struct hinic_debug_priv	*dbg;
 };
 
 struct hinic_qp {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index aad1e5e1bfbe..27ae780d581a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -234,6 +234,8 @@ static int create_rxqs(struct hinic_dev *nic_dev)
 	if (!nic_dev->rxqs)
 		return -ENOMEM;
 
+	hinic_rq_dbgfs_init(nic_dev);
+
 	for (i = 0; i < num_rxqs; i++) {
 		struct hinic_rq *rq = hinic_hwdev_get_rq(nic_dev->hwdev, i);
 
@@ -243,13 +245,26 @@ static int create_rxqs(struct hinic_dev *nic_dev)
 				  "Failed to init rxq\n");
 			goto err_init_rxq;
 		}
+
+		err = hinic_rq_debug_add(nic_dev, i);
+		if (err) {
+			netif_err(nic_dev, drv, netdev,
+				  "Failed to add RQ%d debug\n", i);
+			goto err_add_rq_dbg;
+		}
 	}
 
 	return 0;
 
+err_add_rq_dbg:
+	hinic_clean_rxq(&nic_dev->rxqs[i]);
 err_init_rxq:
-	for (j = 0; j < i; j++)
+	for (j = 0; j < i; j++) {
+		hinic_rq_debug_rem(nic_dev->rxqs[j].rq);
 		hinic_clean_rxq(&nic_dev->rxqs[j]);
+	}
+
+	hinic_rq_dbgfs_uninit(nic_dev);
 
 	devm_kfree(&netdev->dev, nic_dev->rxqs);
 	return err;
@@ -267,8 +282,12 @@ static void free_rxqs(struct hinic_dev *nic_dev)
 	if (!nic_dev->rxqs)
 		return;
 
-	for (i = 0; i < num_rxqs; i++)
+	for (i = 0; i < num_rxqs; i++) {
+		hinic_rq_debug_rem(nic_dev->rxqs[i].rq);
 		hinic_clean_rxq(&nic_dev->rxqs[i]);
+	}
+
+	hinic_rq_dbgfs_uninit(nic_dev);
 
 	devm_kfree(&netdev->dev, nic_dev->rxqs);
 	nic_dev->rxqs = NULL;
-- 
2.17.1

