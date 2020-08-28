Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C1E255363
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 05:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgH1Dha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 23:37:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35122 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727817AbgH1Dha (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 23:37:30 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 09C35411544DE6C27D1C;
        Fri, 28 Aug 2020 11:37:27 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 28 Aug 2020 11:36:57 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v2 3/3] hinic: add support to query function table
Date:   Fri, 28 Aug 2020 11:37:48 +0800
Message-ID: <20200828033748.26172-4-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200828033748.26172-1-luobin9@huawei.com>
References: <20200828033748.26172-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add debugfs node for querying function table, for example:
cat /sys/kernel/debug/hinic/0000:15:00.0/func_table/valid

Signed-off-by: Luo bin <luobin9@huawei.com>
---
V0~V1:
- remove command interfaces to the read only files
- split addition of each object into a separate patch

V1~V2:
- remove vlan_id and vlan_mode from the func_table_fields

 .../net/ethernet/huawei/hinic/hinic_debugfs.c | 92 ++++++++++++++++++-
 .../net/ethernet/huawei/hinic/hinic_debugfs.h | 79 ++++++++++++++++
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |  3 +
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  2 +
 .../net/ethernet/huawei/hinic/hinic_main.c    | 15 +++
 5 files changed, 190 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
index d10d0a6d9f13..19eb839177ec 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
@@ -70,6 +70,63 @@ static u64 hinic_dbg_get_rq_info(struct hinic_dev *nic_dev, struct hinic_rq *rq,
 	return 0;
 }
 
+enum func_tbl_info {
+	VALID,
+	RX_MODE,
+	MTU,
+	RQ_DEPTH,
+	QUEUE_NUM,
+};
+
+static char *func_table_fields[] = {"valid", "rx_mode", "mtu", "rq_depth", "cfg_q_num"};
+
+static int hinic_dbg_get_func_table(struct hinic_dev *nic_dev, int idx)
+{
+	struct tag_sml_funcfg_tbl *funcfg_table_elem;
+	struct hinic_cmd_lt_rd *read_data;
+	u16 out_size = sizeof(*read_data);
+	int err;
+
+	read_data = kzalloc(sizeof(*read_data), GFP_KERNEL);
+	if (!read_data)
+		return ~0;
+
+	read_data->node = TBL_ID_FUNC_CFG_SM_NODE;
+	read_data->inst = TBL_ID_FUNC_CFG_SM_INST;
+	read_data->entry_size = HINIC_FUNCTION_CONFIGURE_TABLE_SIZE;
+	read_data->lt_index = HINIC_HWIF_FUNC_IDX(nic_dev->hwdev->hwif);
+	read_data->len = HINIC_FUNCTION_CONFIGURE_TABLE_SIZE;
+
+	err = hinic_port_msg_cmd(nic_dev->hwdev, HINIC_PORT_CMD_RD_LINE_TBL, read_data,
+				 sizeof(*read_data), read_data, &out_size);
+	if (err || out_size != sizeof(*read_data) || read_data->status) {
+		netif_err(nic_dev, drv, nic_dev->netdev,
+			  "Failed to get func table, err: %d, status: 0x%x, out size: 0x%x\n",
+			  err, read_data->status, out_size);
+		kfree(read_data);
+		return ~0;
+	}
+
+	funcfg_table_elem = (struct tag_sml_funcfg_tbl *)read_data->data;
+
+	switch (idx) {
+	case VALID:
+		return funcfg_table_elem->dw0.bs.valid;
+	case RX_MODE:
+		return funcfg_table_elem->dw0.bs.nic_rx_mode;
+	case MTU:
+		return funcfg_table_elem->dw1.bs.mtu;
+	case RQ_DEPTH:
+		return funcfg_table_elem->dw13.bs.cfg_rq_depth;
+	case QUEUE_NUM:
+		return funcfg_table_elem->dw13.bs.cfg_q_num;
+	}
+
+	kfree(read_data);
+
+	return ~0;
+}
+
 static ssize_t hinic_dbg_cmd_read(struct file *filp, char __user *buffer, size_t count,
 				  loff_t *ppos)
 {
@@ -91,6 +148,10 @@ static ssize_t hinic_dbg_cmd_read(struct file *filp, char __user *buffer, size_t
 		out = hinic_dbg_get_rq_info(dbg->dev, dbg->object, *desc);
 		break;
 
+	case HINIC_DBG_FUNC_TABLE:
+		out = hinic_dbg_get_func_table(dbg->dev, *desc);
+		break;
+
 	default:
 		netif_warn(dbg->dev, drv, dbg->dev->netdev, "Invalid hinic debug cmd: %d\n",
 			   dbg->type);
@@ -136,7 +197,9 @@ static int create_dbg_files(struct hinic_dev *dev, enum hinic_dbg_type type, voi
 
 static void rem_dbg_files(struct hinic_debug_priv *dbg)
 {
-	debugfs_remove_recursive(dbg->root);
+	if (dbg->type != HINIC_DBG_FUNC_TABLE)
+		debugfs_remove_recursive(dbg->root);
+
 	kfree(dbg);
 }
 
@@ -184,6 +247,21 @@ void hinic_rq_debug_rem(struct hinic_rq *rq)
 		rem_dbg_files(rq->dbg);
 }
 
+int hinic_func_table_debug_add(struct hinic_dev *dev)
+{
+	if (HINIC_IS_VF(dev->hwdev->hwif))
+		return 0;
+
+	return create_dbg_files(dev, HINIC_DBG_FUNC_TABLE, dev, dev->func_tbl_dbgfs, &dev->dbg,
+				func_table_fields, ARRAY_SIZE(func_table_fields));
+}
+
+void hinic_func_table_debug_rem(struct hinic_dev *dev)
+{
+	if (!HINIC_IS_VF(dev->hwdev->hwif) && dev->dbg)
+		rem_dbg_files(dev->dbg);
+}
+
 void hinic_sq_dbgfs_init(struct hinic_dev *nic_dev)
 {
 	nic_dev->sq_dbgfs = debugfs_create_dir("SQs", nic_dev->dbgfs_root);
@@ -204,6 +282,18 @@ void hinic_rq_dbgfs_uninit(struct hinic_dev *nic_dev)
 	debugfs_remove_recursive(nic_dev->rq_dbgfs);
 }
 
+void hinic_func_tbl_dbgfs_init(struct hinic_dev *nic_dev)
+{
+	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+		nic_dev->func_tbl_dbgfs = debugfs_create_dir("func_table", nic_dev->dbgfs_root);
+}
+
+void hinic_func_tbl_dbgfs_uninit(struct hinic_dev *nic_dev)
+{
+	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+		debugfs_remove_recursive(nic_dev->func_tbl_dbgfs);
+}
+
 void hinic_dbg_init(struct hinic_dev *nic_dev)
 {
 	nic_dev->dbgfs_root = debugfs_create_dir(pci_name(nic_dev->hwdev->hwif->pdev),
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
index 186ca4a26919..e9e00cfa1329 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
@@ -8,6 +8,77 @@
 
 #include "hinic_dev.h"
 
+#define    TBL_ID_FUNC_CFG_SM_NODE                      11
+#define    TBL_ID_FUNC_CFG_SM_INST                      1
+
+#define HINIC_FUNCTION_CONFIGURE_TABLE_SIZE             64
+#define HINIC_FUNCTION_CONFIGURE_TABLE			1
+
+struct hinic_cmd_lt_rd {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	unsigned char node;
+	unsigned char inst;
+	unsigned char entry_size;
+	unsigned char rsvd;
+	unsigned int lt_index;
+	unsigned int offset;
+	unsigned int len;
+	unsigned char data[100];
+};
+
+struct tag_sml_funcfg_tbl {
+	union {
+		struct {
+			u32 rsvd0            :8;
+			u32 nic_rx_mode      :5;
+			u32 rsvd1            :18;
+			u32 valid            :1;
+		} bs;
+
+		u32 value;
+	} dw0;
+
+	union {
+		struct {
+			u32 vlan_id             :12;
+			u32 vlan_mode           :3;
+			u32 fast_recycled_mode  :1;
+			u32 mtu                 :16;
+		} bs;
+
+		u32 value;
+	} dw1;
+
+	u32 dw2;
+	u32 dw3;
+	u32 dw4;
+	u32 dw5;
+	u32 dw6;
+	u32 dw7;
+	u32 dw8;
+	u32 dw9;
+	u32 dw10;
+	u32 dw11;
+	u32 dw12;
+
+	union {
+		struct {
+			u32 rsvd2               :15;
+			u32 cfg_q_num           :9;
+			u32 cfg_rq_depth        :6;
+			u32 vhd_type            :2;
+		} bs;
+
+		u32 value;
+	} dw13;
+
+	u32 dw14;
+	u32 dw15;
+};
+
 int hinic_sq_debug_add(struct hinic_dev *dev, u16 sq_id);
 
 void hinic_sq_debug_rem(struct hinic_sq *sq);
@@ -16,6 +87,10 @@ int hinic_rq_debug_add(struct hinic_dev *dev, u16 rq_id);
 
 void hinic_rq_debug_rem(struct hinic_rq *rq);
 
+int hinic_func_table_debug_add(struct hinic_dev *dev);
+
+void hinic_func_table_debug_rem(struct hinic_dev *dev);
+
 void hinic_sq_dbgfs_init(struct hinic_dev *nic_dev);
 
 void hinic_sq_dbgfs_uninit(struct hinic_dev *nic_dev);
@@ -24,6 +99,10 @@ void hinic_rq_dbgfs_init(struct hinic_dev *nic_dev);
 
 void hinic_rq_dbgfs_uninit(struct hinic_dev *nic_dev);
 
+void hinic_func_tbl_dbgfs_init(struct hinic_dev *nic_dev);
+
+void hinic_func_tbl_dbgfs_uninit(struct hinic_dev *nic_dev);
+
 void hinic_dbg_init(struct hinic_dev *nic_dev);
 
 void hinic_dbg_uninit(struct hinic_dev *nic_dev);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index 0876a699d205..fb3e89141a0d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -61,6 +61,7 @@ struct hinic_intr_coal_info {
 enum hinic_dbg_type {
 	HINIC_DBG_SQ_INFO,
 	HINIC_DBG_RQ_INFO,
+	HINIC_DBG_FUNC_TABLE,
 };
 
 struct hinic_debug_priv {
@@ -114,6 +115,8 @@ struct hinic_dev {
 	struct dentry			*dbgfs_root;
 	struct dentry			*sq_dbgfs;
 	struct dentry			*rq_dbgfs;
+	struct dentry			*func_tbl_dbgfs;
+	struct hinic_debug_priv		*dbg;
 	struct devlink			*devlink;
 	bool				cable_unplugged;
 	bool				module_unrecognized;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 701eb81e09a7..416492e48274 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -96,6 +96,8 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_RSS_TEMP_MGR	= 49,
 
+	HINIC_PORT_CMD_RD_LINE_TBL	= 57,
+
 	HINIC_PORT_CMD_RSS_CFG		= 66,
 
 	HINIC_PORT_CMD_FWCTXT_INIT      = 69,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 27ae780d581a..797c55a1d9c6 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1302,6 +1302,14 @@ static int nic_dev_init(struct pci_dev *pdev)
 
 	hinic_dbg_init(nic_dev);
 
+	hinic_func_tbl_dbgfs_init(nic_dev);
+
+	err = hinic_func_table_debug_add(nic_dev);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to add func_table debug\n");
+		goto err_add_func_table_dbg;
+	}
+
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to register netdev\n");
@@ -1311,6 +1319,9 @@ static int nic_dev_init(struct pci_dev *pdev)
 	return 0;
 
 err_reg_netdev:
+	hinic_func_table_debug_rem(nic_dev);
+err_add_func_table_dbg:
+	hinic_func_tbl_dbgfs_uninit(nic_dev);
 	hinic_dbg_uninit(nic_dev);
 	hinic_free_intr_coalesce(nic_dev);
 err_init_intr:
@@ -1434,6 +1445,10 @@ static void hinic_remove(struct pci_dev *pdev)
 
 	unregister_netdev(netdev);
 
+	hinic_func_table_debug_rem(nic_dev);
+
+	hinic_func_tbl_dbgfs_uninit(nic_dev);
+
 	hinic_dbg_uninit(nic_dev);
 
 	hinic_free_intr_coalesce(nic_dev);
-- 
2.17.1

