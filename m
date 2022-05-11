Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D14522A55
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241801AbiEKDUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241670AbiEKDTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:46 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D41E6EC5B
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:41 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239172tq4fkd80
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:32 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: HoyAXBWgsknDQukLakJ7x3bSAmq5Lcz+0/x5YqBZebs29aAqjuIPIFuWi6f0Z
        HaGU6a7qutIKsAjuAtpG9hMGJMlwLDq5dwMUHV4WDOKu9OeUKXjxlp5Z3HXCqoYxQQlS9wf
        xqqORAdxWdruC8hmQLolngZK+SKaYliYFVBbvn0wOZKpx7rB2wN12ujkN7fg9/aP/McJ/Ev
        zswlOOWbU4fljaX5ZBTUEUq+dujpaRf1uyFFdTY/pJNjs40qpB4lG/rC7MPtuEUheHF1R9I
        Ga0SiLbafv+mPW/gNiNu9OzXsHUZN22Xo+ZrLDtxDnKW1OuwP/hkD1ZbwvFVT+zLpiVOF+4
        qs/OwnDeq6NpZpXTl6okGaR4Fcuy4W34dhDex/Y
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 13/14] net: txgbe: Support debug filesystem
Date:   Wed, 11 May 2022 11:26:58 +0800
Message-Id: <20220511032659.641834-14-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign3
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for debug filesystem.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   1 +
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  10 +
 .../ethernet/wangxun/txgbe/txgbe_debugfs.c    | 582 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  14 +
 4 files changed, 607 insertions(+)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_debugfs.c

diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index 7fe32feeded8..c338a84abca8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -10,4 +10,5 @@ txgbe-objs := txgbe_main.o txgbe_ethtool.o \
               txgbe_hw.o txgbe_phy.o \
               txgbe_lib.o txgbe_ptp.o
 
+txgbe-$(CONFIG_DEBUG_FS) += txgbe_debugfs.o
 txgbe-$(CONFIG_TXGBE_PCI_RECOVER) += txgbe_pcierr.o
\ No newline at end of file
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index fe51bdf96f3e..78f4a56d6cff 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -510,6 +510,9 @@ struct txgbe_adapter {
 	struct txgbe_mac_addr *mac_table;
 
 	__le16 vxlan_port;
+
+	struct dentry *txgbe_dbg_adapter;
+
 	unsigned long fwd_bitmask; /* bitmask indicating in use pools */
 
 #define TXGBE_MAX_RETA_ENTRIES 128
@@ -607,6 +610,13 @@ void txgbe_write_eitr(struct txgbe_q_vector *q_vector);
 int txgbe_poll(struct napi_struct *napi, int budget);
 void txgbe_disable_rx_queue(struct txgbe_adapter *adapter,
 			    struct txgbe_ring *ring);
+#ifdef CONFIG_DEBUG_FS
+void txgbe_dbg_adapter_init(struct txgbe_adapter *adapter);
+void txgbe_dbg_adapter_exit(struct txgbe_adapter *adapter);
+void txgbe_dbg_init(void);
+void txgbe_dbg_exit(void);
+void txgbe_dump(struct txgbe_adapter *adapter);
+#endif
 
 static inline struct netdev_queue *txring_txq(const struct txgbe_ring *ring)
 {
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_debugfs.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_debugfs.c
new file mode 100644
index 000000000000..93affdcea720
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_debugfs.c
@@ -0,0 +1,582 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
+
+#include "txgbe.h"
+
+#include <linux/debugfs.h>
+#include <linux/module.h>
+
+static struct dentry *txgbe_dbg_root;
+static int txgbe_data_mode;
+
+#define TXGBE_DATA_FUNC(dm)  ((dm) & ~0xFFFF)
+#define TXGBE_DATA_ARGS(dm)  ((dm) & 0xFFFF)
+enum txgbe_data_func {
+	TXGBE_FUNC_NONE        = (0 << 16),
+	TXGBE_FUNC_DUMP_BAR    = (1 << 16),
+	TXGBE_FUNC_DUMP_RDESC  = (2 << 16),
+	TXGBE_FUNC_DUMP_TDESC  = (3 << 16),
+	TXGBE_FUNC_FLASH_READ  = (4 << 16),
+	TXGBE_FUNC_FLASH_WRITE = (5 << 16),
+};
+
+/**
+ * reg_ops operation
+ **/
+static char txgbe_dbg_reg_ops_buf[256] = "";
+static ssize_t
+txgbe_dbg_reg_ops_read(struct file *filp, char __user *buffer,
+		       size_t count, loff_t *ppos)
+{
+	struct txgbe_adapter *adapter = filp->private_data;
+	char *buf;
+	int len;
+
+	/* don't allow partial reads */
+	if (*ppos != 0)
+		return 0;
+
+	buf = kasprintf(GFP_KERNEL, "%s: mode=0x%08x\n%s\n",
+			adapter->netdev->name, txgbe_data_mode,
+			txgbe_dbg_reg_ops_buf);
+	if (!buf)
+		return -ENOMEM;
+
+	if (count < strlen(buf)) {
+		kfree(buf);
+		return -ENOSPC;
+	}
+
+	len = simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+
+	kfree(buf);
+	return len;
+}
+
+static ssize_t
+txgbe_dbg_reg_ops_write(struct file *filp,
+			const char __user *buffer,
+			size_t count, loff_t *ppos)
+{
+	struct txgbe_adapter *adapter = filp->private_data;
+	char *pc = txgbe_dbg_reg_ops_buf;
+	int len;
+
+	/* don't allow partial writes */
+	if (*ppos != 0)
+		return 0;
+	if (count >= sizeof(txgbe_dbg_reg_ops_buf))
+		return -ENOSPC;
+
+	len = simple_write_to_buffer(txgbe_dbg_reg_ops_buf,
+				     sizeof(txgbe_dbg_reg_ops_buf) - 1,
+				     ppos,
+				     buffer,
+				     count);
+	if (len < 0)
+		return len;
+
+	pc[len] = '\0';
+
+	if (strncmp(pc, "dump", 4) == 0) {
+		u32 mode = 0;
+		u16 args;
+
+		pc += 4;
+		pc += strspn(pc, " \t");
+
+		if (!strncmp(pc, "bar", 3)) {
+			pc += 3;
+			mode = TXGBE_FUNC_DUMP_BAR;
+		} else if (!strncmp(pc, "rdesc", 5)) {
+			pc += 5;
+			mode = TXGBE_FUNC_DUMP_RDESC;
+		} else if (!strncmp(pc, "tdesc", 5)) {
+			pc += 5;
+			mode = TXGBE_FUNC_DUMP_TDESC;
+		} else {
+			txgbe_dump(adapter);
+		}
+
+		if (mode && !kstrtou16(pc, 0, &args))
+			mode |= args;
+
+		txgbe_data_mode = mode;
+	} else if (strncmp(pc, "flash", 4) == 0) {
+		u32 mode = 0;
+		u16 args;
+
+		pc += 5;
+		pc += strspn(pc, " \t");
+		if (!strncmp(pc, "read", 3)) {
+			pc += 4;
+			mode = TXGBE_FUNC_FLASH_READ;
+		} else if (!strncmp(pc, "write", 5)) {
+			pc += 5;
+			mode = TXGBE_FUNC_FLASH_WRITE;
+		}
+
+		if (mode && !kstrtou16(pc, 0, &args))
+			mode |= args;
+
+		txgbe_data_mode = mode;
+	} else if (strncmp(txgbe_dbg_reg_ops_buf, "write", 5) == 0) {
+		u32 reg, value;
+		int cnt;
+
+		cnt = sscanf(&txgbe_dbg_reg_ops_buf[5], "%x %x", &reg, &value);
+		if (cnt == 2) {
+			wr32(&adapter->hw, reg, value);
+			txgbe_dev_info("write: 0x%08x = 0x%08x\n", reg, value);
+		} else {
+			txgbe_dev_info("write <reg> <value>\n");
+		}
+	} else if (strncmp(txgbe_dbg_reg_ops_buf, "read", 4) == 0) {
+		u32 reg, value;
+		int cnt;
+
+		cnt = !kstrtou32(&txgbe_dbg_reg_ops_buf[4], 0, &reg);
+		if (cnt == 1) {
+			value = rd32(&adapter->hw, reg);
+			txgbe_dev_info("read 0x%08x = 0x%08x\n", reg, value);
+		} else {
+			txgbe_dev_info("read <reg>\n");
+		}
+	} else {
+		txgbe_dev_info("Unknown command %s\n", txgbe_dbg_reg_ops_buf);
+		txgbe_dev_info("Available commands:\n");
+		txgbe_dev_info("   read <reg>\n");
+		txgbe_dev_info("   write <reg> <value>\n");
+	}
+	return count;
+}
+
+static const struct file_operations txgbe_dbg_reg_ops_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read =  txgbe_dbg_reg_ops_read,
+	.write = txgbe_dbg_reg_ops_write,
+};
+
+/**
+ * netdev_ops operation
+ **/
+static char txgbe_dbg_netdev_ops_buf[256] = "";
+static ssize_t
+txgbe_dbg_netdev_ops_read(struct file *filp,
+			  char __user *buffer,
+			  size_t count, loff_t *ppos)
+{
+	struct txgbe_adapter *adapter = filp->private_data;
+	char *buf;
+	int len;
+
+	/* don't allow partial reads */
+	if (*ppos != 0)
+		return 0;
+
+	buf = kasprintf(GFP_KERNEL, "%s: mode=0x%08x\n%s\n",
+			adapter->netdev->name, txgbe_data_mode,
+			txgbe_dbg_netdev_ops_buf);
+	if (!buf)
+		return -ENOMEM;
+
+	if (count < strlen(buf)) {
+		kfree(buf);
+		return -ENOSPC;
+	}
+
+	len = simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
+
+	kfree(buf);
+	return len;
+}
+
+static ssize_t
+txgbe_dbg_netdev_ops_write(struct file *filp,
+			   const char __user *buffer,
+			   size_t count, loff_t *ppos)
+{
+	struct txgbe_adapter *adapter = filp->private_data;
+	int len;
+
+	/* don't allow partial writes */
+	if (*ppos != 0)
+		return 0;
+	if (count >= sizeof(txgbe_dbg_netdev_ops_buf))
+		return -ENOSPC;
+
+	len = simple_write_to_buffer(txgbe_dbg_netdev_ops_buf,
+				     sizeof(txgbe_dbg_netdev_ops_buf) - 1,
+				     ppos,
+				     buffer,
+				     count);
+	if (len < 0)
+		return len;
+
+	txgbe_dbg_netdev_ops_buf[len] = '\0';
+
+	if (strncmp(txgbe_dbg_netdev_ops_buf, "tx_timeout", 10) == 0) {
+		adapter->netdev->netdev_ops->ndo_tx_timeout(adapter->netdev, 0);
+		txgbe_dev_info("tx_timeout called\n");
+	} else {
+		txgbe_dev_info("Unknown command: %s\n", txgbe_dbg_netdev_ops_buf);
+		txgbe_dev_info("Available commands:\n");
+		txgbe_dev_info("    tx_timeout\n");
+	}
+	return count;
+}
+
+static const struct file_operations txgbe_dbg_netdev_ops_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = txgbe_dbg_netdev_ops_read,
+	.write = txgbe_dbg_netdev_ops_write,
+};
+
+/**
+ * txgbe_dbg_adapter_init - setup the debugfs directory for the adapter
+ * @adapter: the adapter that is starting up
+ **/
+void txgbe_dbg_adapter_init(struct txgbe_adapter *adapter)
+{
+	const char *name = pci_name(adapter->pdev);
+	struct dentry *pfile;
+
+	adapter->txgbe_dbg_adapter = debugfs_create_dir(name, txgbe_dbg_root);
+	if (!adapter->txgbe_dbg_adapter) {
+		txgbe_dev_err("debugfs entry for %s failed\n", name);
+		return;
+	}
+
+	pfile = debugfs_create_file("reg_ops", 0600,
+				    adapter->txgbe_dbg_adapter, adapter,
+				    &txgbe_dbg_reg_ops_fops);
+	if (!pfile)
+		txgbe_dev_err("debugfs reg_ops for %s failed\n", name);
+
+	pfile = debugfs_create_file("netdev_ops", 0600,
+				    adapter->txgbe_dbg_adapter, adapter,
+				    &txgbe_dbg_netdev_ops_fops);
+	if (!pfile)
+		txgbe_dev_err("debugfs netdev_ops for %s failed\n", name);
+}
+
+/**
+ * txgbe_dbg_adapter_exit - clear out the adapter's debugfs entries
+ * @pf: the pf that is stopping
+ **/
+void txgbe_dbg_adapter_exit(struct txgbe_adapter *adapter)
+{
+	debugfs_remove_recursive(adapter->txgbe_dbg_adapter);
+	adapter->txgbe_dbg_adapter = NULL;
+}
+
+/**
+ * txgbe_dbg_init - start up debugfs for the driver
+ **/
+void txgbe_dbg_init(void)
+{
+	txgbe_dbg_root = debugfs_create_dir(txgbe_driver_name, NULL);
+	if (!txgbe_dbg_root)
+		pr_err("init of debugfs failed\n");
+}
+
+/**
+ * txgbe_dbg_exit - clean out the driver's debugfs entries
+ **/
+void txgbe_dbg_exit(void)
+{
+	debugfs_remove_recursive(txgbe_dbg_root);
+}
+
+struct txgbe_reg_info {
+	u32 offset;
+	u32 length;
+	char *name;
+};
+
+static struct txgbe_reg_info txgbe_reg_info_tbl[] = {
+	/* General Registers */
+	{TXGBE_CFG_PORT_CTL, 1, "CTRL"},
+	{TXGBE_CFG_PORT_ST, 1, "STATUS"},
+
+	/* RX Registers */
+	{TXGBE_PX_RR_CFG(0), 1, "SRRCTL"},
+	{TXGBE_PX_RR_RP(0), 1, "RDH"},
+	{TXGBE_PX_RR_WP(0), 1, "RDT"},
+	{TXGBE_PX_RR_CFG(0), 1, "RXDCTL"},
+	{TXGBE_PX_RR_BAL(0), 1, "RDBAL"},
+	{TXGBE_PX_RR_BAH(0), 1, "RDBAH"},
+
+	/* TX Registers */
+	{TXGBE_PX_TR_BAL(0), 1, "TDBAL"},
+	{TXGBE_PX_TR_BAH(0), 1, "TDBAH"},
+	{TXGBE_PX_TR_RP(0), 1, "TDH"},
+	{TXGBE_PX_TR_WP(0), 1, "TDT"},
+	{TXGBE_PX_TR_CFG(0), 1, "TXDCTL"},
+
+	/* MACVLAN */
+	{TXGBE_PSR_MAC_SWC_VM_H, 128, "PSR_MAC_SWC_VM"},
+	{TXGBE_PSR_MAC_SWC_AD_L, 128, "PSR_MAC_SWC_AD"},
+	{TXGBE_PSR_VLAN_TBL(0),  128, "PSR_VLAN_TBL"},
+
+	/* QoS */
+	{TXGBE_TDM_RP_RATE, 128, "TDM_RP_RATE"},
+
+	/* List Terminator */
+	{ .name = NULL }
+};
+
+/**
+ * txgbe_regdump - register printout routine
+ **/
+static void
+txgbe_regdump(struct txgbe_hw *hw, struct txgbe_reg_info *reg_info)
+{
+	int i, n = 0;
+	u32 buffer[32 * 8];
+
+	switch (reg_info->offset) {
+	case TXGBE_PSR_MAC_SWC_VM_H:
+		for (i = 0; i < reg_info->length; i++) {
+			wr32(hw, TXGBE_PSR_MAC_SWC_IDX, i);
+			buffer[n++] =
+				rd32(hw, TXGBE_PSR_MAC_SWC_VM_H);
+			buffer[n++] =
+				rd32(hw, TXGBE_PSR_MAC_SWC_VM_L);
+		}
+		break;
+	case TXGBE_PSR_MAC_SWC_AD_L:
+		for (i = 0; i < reg_info->length; i++) {
+			wr32(hw, TXGBE_PSR_MAC_SWC_IDX, i);
+			buffer[n++] =
+				rd32(hw, TXGBE_PSR_MAC_SWC_AD_H);
+			buffer[n++] =
+				rd32(hw, TXGBE_PSR_MAC_SWC_AD_L);
+		}
+		break;
+	case TXGBE_TDM_RP_RATE:
+		for (i = 0; i < reg_info->length; i++) {
+			wr32(hw, TXGBE_TDM_RP_IDX, i);
+			buffer[n++] = rd32(hw, TXGBE_TDM_RP_RATE);
+		}
+		break;
+	default:
+		for (i = 0; i < reg_info->length; i++)
+			buffer[n++] = rd32(hw, reg_info->offset + 4 * i);
+		break;
+	}
+	BUG_ON(n);
+}
+
+/**
+ * txgbe_dump - Print registers, tx-rings and rx-rings
+ **/
+void txgbe_dump(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct txgbe_hw *hw = &adapter->hw;
+	struct txgbe_reg_info *reg_info;
+	int n = 0;
+	struct txgbe_ring *tx_ring;
+	struct txgbe_tx_buffer *tx_buffer;
+	union txgbe_tx_desc *tx_desc;
+	struct my_u0 { u64 a; u64 b; } *u0;
+	struct txgbe_ring *rx_ring;
+	union txgbe_rx_desc *rx_desc;
+	struct txgbe_rx_buffer *rx_buffer_info;
+	u32 staterr;
+	int i = 0;
+
+	if (!netif_msg_hw(adapter))
+		return;
+
+	/* Print Registers */
+	dev_info(&adapter->pdev->dev, "Register Dump\n");
+	pr_info(" Register Name   Value\n");
+	for (reg_info = txgbe_reg_info_tbl; reg_info->name; reg_info++)
+		txgbe_regdump(hw, reg_info);
+
+	/* Print TX Ring Summary */
+	if (!netdev || !netif_running(netdev))
+		return;
+
+	dev_info(&adapter->pdev->dev, "TX Rings Summary\n");
+	pr_info(" %s     %s              %s        %s\n",
+		"Queue [NTU] [NTC] [bi(ntc)->dma  ]",
+		"leng", "ntw", "timestamp");
+	for (n = 0; n < adapter->num_tx_queues; n++) {
+		tx_ring = adapter->tx_ring[n];
+		tx_buffer = &tx_ring->tx_buffer_info[tx_ring->next_to_clean];
+		pr_info(" %5d %5X %5X %016llX %08X %p %016llX\n",
+			n, tx_ring->next_to_use, tx_ring->next_to_clean,
+			(u64)dma_unmap_addr(tx_buffer, dma),
+			dma_unmap_len(tx_buffer, len),
+			tx_buffer->next_to_watch,
+			(u64)tx_buffer->time_stamp);
+	}
+
+	/* Print TX Rings */
+	if (!netif_msg_tx_done(adapter))
+		goto rx_ring_summary;
+
+	dev_info(&adapter->pdev->dev, "TX Rings Dump\n");
+
+	/* Transmit Descriptor Formats
+	 *
+	 * Transmit Descriptor (Read)
+	 *   +--------------------------------------------------------------+
+	 * 0 |         Buffer Address [63:0]                                |
+	 *   +--------------------------------------------------------------+
+	 * 8 |PAYLEN  |POPTS|CC|IDX  |STA  |DCMD  |DTYP |MAC  |RSV  |DTALEN |
+	 *   +--------------------------------------------------------------+
+	 *   63     46 45 40 39 38 36 35 32 31  24 23 20 19 18 17 16 15     0
+	 *
+	 * Transmit Descriptor (Write-Back)
+	 *   +--------------------------------------------------------------+
+	 * 0 |                          RSV [63:0]                          |
+	 *   +--------------------------------------------------------------+
+	 * 8 |            RSV           |  STA  |           RSV             |
+	 *   +--------------------------------------------------------------+
+	 *   63                       36 35   32 31                         0
+	 */
+
+	for (n = 0; n < adapter->num_tx_queues; n++) {
+		tx_ring = adapter->tx_ring[n];
+		pr_info("------------------------------------\n");
+		pr_info("TX QUEUE INDEX = %d\n", tx_ring->queue_index);
+		pr_info("------------------------------------\n");
+		pr_info("%s%s    %s              %s        %s          %s\n",
+			"T [desc]     [address 63:0  ] ",
+			"[PlPOIdStDDt Ln] [bi->dma       ] ",
+			"leng", "ntw", "timestamp", "bi->skb");
+
+		for (i = 0; tx_ring->desc && (i < tx_ring->count); i++) {
+			tx_desc = TXGBE_TX_DESC(tx_ring, i);
+			tx_buffer = &tx_ring->tx_buffer_info[i];
+			u0 = (struct my_u0 *)tx_desc;
+			if (dma_unmap_len(tx_buffer, len) > 0) {
+				pr_info("T [0x%03X]    %016llX %016llX %016llX %08X %p %016llX %p",
+					i,
+					le64_to_cpu(u0->a),
+					le64_to_cpu(u0->b),
+					(u64)dma_unmap_addr(tx_buffer, dma),
+					dma_unmap_len(tx_buffer, len),
+					tx_buffer->next_to_watch,
+					(u64)tx_buffer->time_stamp,
+					tx_buffer->skb);
+				if (i == tx_ring->next_to_use &&
+				    i == tx_ring->next_to_clean)
+					pr_info(" NTC/U\n");
+				else if (i == tx_ring->next_to_use)
+					pr_info(" NTU\n");
+				else if (i == tx_ring->next_to_clean)
+					pr_info(" NTC\n");
+				else
+					pr_info("\n");
+
+				if (netif_msg_pktdata(adapter) &&
+				    tx_buffer->skb)
+					print_hex_dump(KERN_INFO, "",
+						       DUMP_PREFIX_ADDRESS, 16, 1,
+						       tx_buffer->skb->data,
+						       dma_unmap_len(tx_buffer, len),
+						       true);
+			}
+		}
+	}
+
+	/* Print RX Rings Summary */
+rx_ring_summary:
+	dev_info(&adapter->pdev->dev, "RX Rings Summary\n");
+	pr_info("Queue [NTU] [NTC]\n");
+	for (n = 0; n < adapter->num_rx_queues; n++) {
+		rx_ring = adapter->rx_ring[n];
+		pr_info("%5d %5X %5X\n",
+			n, rx_ring->next_to_use, rx_ring->next_to_clean);
+	}
+
+	/* Print RX Rings */
+	if (!netif_msg_rx_status(adapter))
+		return;
+
+	dev_info(&adapter->pdev->dev, "RX Rings Dump\n");
+
+	/* Receive Descriptor Formats
+	 *
+	 * Receive Descriptor (Read)
+	 *    63                                           1        0
+	 *    +-----------------------------------------------------+
+	 *  0 |       Packet Buffer Address [63:1]           |A0/NSE|
+	 *    +----------------------------------------------+------+
+	 *  8 |       Header Buffer Address [63:1]           |  DD  |
+	 *    +-----------------------------------------------------+
+	 *
+	 *
+	 * Receive Descriptor (Write-Back)
+	 *
+	 *   63       48 47    32 31  30      21 20 17 16   4 3     0
+	 *   +------------------------------------------------------+
+	 * 0 |RSS / Frag Checksum|SPH| HDR_LEN  |RSC- |Packet|  RSS |
+	 *   |/ RTT / PCoE_PARAM |   |          | CNT | Type | Type |
+	 *   |/ Flow Dir Flt ID  |   |          |     |      |      |
+	 *   +------------------------------------------------------+
+	 * 8 | VLAN Tag | Length |Extended Error| Xtnd Status/NEXTP |
+	 *   +------------------------------------------------------+
+	 *   63       48 47    32 31          20 19                 0
+	 */
+
+	for (n = 0; n < adapter->num_rx_queues; n++) {
+		rx_ring = adapter->rx_ring[n];
+		pr_info("------------------------------------\n");
+		pr_info("RX QUEUE INDEX = %d\n", rx_ring->queue_index);
+		pr_info("------------------------------------\n");
+		pr_info("%s%s%s",
+			"R  [desc]      [ PktBuf     A0] ",
+			"[  HeadBuf   DD] [bi->dma       ] [bi->skb       ] ",
+			"<-- Adv Rx Read format\n");
+		pr_info("%s%s%s",
+			"RWB[desc]      [PcsmIpSHl PtRs] ",
+			"[vl er S cks ln] ---------------- [bi->skb       ] ",
+			"<-- Adv Rx Write-Back format\n");
+
+		for (i = 0; i < rx_ring->count; i++) {
+			rx_buffer_info = &rx_ring->rx_buffer_info[i];
+			rx_desc = TXGBE_RX_DESC(rx_ring, i);
+			u0 = (struct my_u0 *)rx_desc;
+			staterr = le32_to_cpu(rx_desc->wb.upper.status_error);
+			if (staterr & TXGBE_RXD_STAT_DD) {
+				/* Descriptor Done */
+				pr_info("RWB[0x%03X]     %016llX %016llX ---------------- %p",
+					i, le64_to_cpu(u0->a),
+					le64_to_cpu(u0->b),
+					rx_buffer_info->skb);
+			} else {
+				pr_info("R  [0x%03X]     %016llX %016llX %016llX %p",
+					i, le64_to_cpu(u0->a),
+					le64_to_cpu(u0->b),
+					(u64)rx_buffer_info->page_dma,
+					rx_buffer_info->skb);
+
+				if (netif_msg_pktdata(adapter) &&
+				    rx_buffer_info->page_dma) {
+					print_hex_dump(KERN_INFO, "",
+						       DUMP_PREFIX_ADDRESS, 16, 1,
+						       page_address(rx_buffer_info->page) +
+						       rx_buffer_info->page_offset,
+						       txgbe_rx_bufsz(rx_ring),
+						       true);
+				}
+			}
+
+			if (i == rx_ring->next_to_use)
+				pr_info(" NTU\n");
+			else if (i == rx_ring->next_to_clean)
+				pr_info(" NTC\n");
+			else
+				pr_info("\n");
+		}
+	}
+}
+
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 474786bdec3d..1dee2877d346 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -6570,6 +6570,9 @@ static int txgbe_probe(struct pci_dev *pdev,
 	txgbe_info(probe, "WangXun(R) 10 Gigabit Network Connection\n");
 	cards_found++;
 
+#ifdef CONFIG_DEBUG_FS
+	txgbe_dbg_adapter_init(adapter);
+#endif
 	/* setup link for SFP devices with MNG FW, else wait for TXGBE_UP */
 	if (txgbe_mng_present(hw) && txgbe_is_sfp(hw) &&
 	    ((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
@@ -6618,6 +6621,10 @@ static void txgbe_remove(struct pci_dev *pdev)
 		return;
 
 	netdev = adapter->netdev;
+#ifdef CONFIG_DEBUG_FS
+	txgbe_dbg_adapter_exit(adapter);
+#endif
+
 	set_bit(__TXGBE_REMOVING, &adapter->state);
 	cancel_work_sync(&adapter->service_task);
 
@@ -6703,6 +6710,10 @@ static int __init txgbe_init_module(void)
 		return -ENOMEM;
 	}
 
+#ifdef CONFIG_DEBUG_FS
+	txgbe_dbg_init();
+#endif
+
 	ret = pci_register_driver(&txgbe_driver);
 	return ret;
 }
@@ -6720,6 +6731,9 @@ static void __exit txgbe_exit_module(void)
 	pci_unregister_driver(&txgbe_driver);
 	if (txgbe_wq)
 		destroy_workqueue(txgbe_wq);
+#ifdef CONFIG_DEBUG_FS
+	txgbe_dbg_exit();
+#endif
 }
 
 module_exit(txgbe_exit_module);
-- 
2.27.0



