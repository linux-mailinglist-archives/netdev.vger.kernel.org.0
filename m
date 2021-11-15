Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFA14502C9
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 11:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhKOKwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 05:52:30 -0500
Received: from mga17.intel.com ([192.55.52.151]:46516 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231140AbhKOKwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 05:52:25 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="214141881"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="214141881"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 02:49:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="535470376"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by orsmga001.jf.intel.com with ESMTP; 15 Nov 2021 02:49:26 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com
Subject: [PATCH net-next] net: wwan: iosm: device trace collection using relayfs
Date:   Mon, 15 Nov 2021 16:26:59 +0530
Message-Id: <20211115105659.331730-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch brings in support for device trace collection.
It implements relayfs interface for pushing device trace
from kernel space to user space.

On driver load iosm debugfs entry is created in below path
/sys/kernel/debug/

In order to collect device trace user need to write 1 to
trace_ctl interface, followed by collecting incoming trace's
on trace0.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/Makefile            |   3 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.c     |  13 ++
 drivers/net/wwan/iosm/iosm_ipc_imem.h     |   2 +
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c |  31 +++-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h |   9 +-
 drivers/net/wwan/iosm/iosm_ipc_port.c     |   2 +-
 drivers/net/wwan/iosm/iosm_ipc_trace.c    | 198 ++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_trace.h    |  53 ++++++
 8 files changed, 298 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_trace.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_trace.h

diff --git a/drivers/net/wwan/iosm/Makefile b/drivers/net/wwan/iosm/Makefile
index b838034bb120..5c2528beca2a 100644
--- a/drivers/net/wwan/iosm/Makefile
+++ b/drivers/net/wwan/iosm/Makefile
@@ -21,6 +21,7 @@ iosm-y = \
 	iosm_ipc_mux_codec.o		\
 	iosm_ipc_devlink.o		\
 	iosm_ipc_flash.o		\
-	iosm_ipc_coredump.o
+	iosm_ipc_coredump.o		\
+	iosm_ipc_trace.o
 
 obj-$(CONFIG_IOSM) := iosm.o
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index cff3b43ca4d7..f23701fcc914 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -10,6 +10,7 @@
 #include "iosm_ipc_flash.h"
 #include "iosm_ipc_imem.h"
 #include "iosm_ipc_port.h"
+#include "iosm_ipc_trace.h"
 
 /* Check the wwan ips if it is valid with Channel as input. */
 static int ipc_imem_check_wwan_ips(struct ipc_mem_channel *chnl)
@@ -265,9 +266,14 @@ static void ipc_imem_dl_skb_process(struct iosm_imem *ipc_imem,
 	switch (pipe->channel->ctype) {
 	case IPC_CTYPE_CTRL:
 		port_id = pipe->channel->channel_id;
+		ipc_pcie_addr_unmap(ipc_imem->pcie, IPC_CB(skb)->len,
+				    IPC_CB(skb)->mapping,
+				    IPC_CB(skb)->direction);
 		if (port_id == IPC_MEM_CTRL_CHL_ID_7)
 			ipc_imem_sys_devlink_notify_rx(ipc_imem->ipc_devlink,
 						       skb);
+		else if (port_id == ipc_imem->trace->chl_id)
+			ipc_trace_port_rx(ipc_imem->trace, skb);
 		else
 			wwan_port_rx(ipc_imem->ipc_port[port_id]->iosm_port,
 				     skb);
@@ -548,6 +554,12 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 		ctrl_chl_idx++;
 	}
 
+	ipc_imem->trace = ipc_imem_trace_channel_init(ipc_imem);
+	if (!ipc_imem->trace) {
+		dev_err(ipc_imem->dev, "trace channel init failed");
+		return;
+	}
+
 	ipc_task_queue_send_task(ipc_imem, ipc_imem_send_mdm_rdy_cb, 0, NULL, 0,
 				 false);
 
@@ -1165,6 +1177,7 @@ void ipc_imem_cleanup(struct iosm_imem *ipc_imem)
 		ipc_mux_deinit(ipc_imem->mux);
 		ipc_wwan_deinit(ipc_imem->wwan);
 		ipc_port_deinit(ipc_imem->ipc_port);
+		ipc_trace_deinit(ipc_imem->trace);
 	}
 
 	if (ipc_imem->ipc_devlink)
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index 6be6708b4eec..cec38009c44a 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -304,6 +304,7 @@ enum ipc_phase {
  * @sio:			IPC SIO data structure pointer
  * @ipc_port:			IPC PORT data structure pointer
  * @pcie:			IPC PCIe
+ * @trace:			IPC trace data structure pointer
  * @dev:			Pointer to device structure
  * @ipc_requested_state:	Expected IPC state on CP.
  * @channels:			Channel list with UL/DL pipe pairs.
@@ -349,6 +350,7 @@ struct iosm_imem {
 	struct iosm_mux *mux;
 	struct iosm_cdev *ipc_port[IPC_MEM_MAX_CHANNELS];
 	struct iosm_pcie *pcie;
+	struct iosm_trace *trace;
 	struct device *dev;
 	enum ipc_mem_device_ipc_state ipc_requested_state;
 	struct ipc_mem_channel channels[IPC_MEM_MAX_CHANNELS];
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index 825e8e5ffb2a..43f1796a8984 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -11,6 +11,7 @@
 #include "iosm_ipc_imem_ops.h"
 #include "iosm_ipc_port.h"
 #include "iosm_ipc_task_queue.h"
+#include "iosm_ipc_trace.h"
 
 /* Open a packet data online channel between the network layer and CP. */
 int ipc_imem_sys_wwan_open(struct iosm_imem *ipc_imem, int if_id)
@@ -107,6 +108,23 @@ void ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
 			"failed to register the ipc_wwan interfaces");
 }
 
+/**
+ * ipc_imem_trace_channel_init - Initializes trace channel.
+ * @ipc_imem:          Pointer to iosm_imem struct.
+ *
+ * Returns: Pointer to trace instance on success else NULL
+ */
+struct iosm_trace *ipc_imem_trace_channel_init(struct iosm_imem *ipc_imem)
+{
+	struct ipc_chnl_cfg chnl_cfg = { 0 };
+
+	ipc_chnl_cfg_get(&chnl_cfg, IPC_MEM_CTRL_CHL_ID_3);
+	ipc_imem_channel_init(ipc_imem, IPC_CTYPE_CTRL, chnl_cfg,
+			      IRQ_MOD_OFF);
+
+	return ipc_trace_init(ipc_imem);
+}
+
 /* Map SKB to DMA for transfer */
 static int ipc_imem_map_skb_to_dma(struct iosm_imem *ipc_imem,
 				   struct sk_buff *skb)
@@ -182,11 +200,14 @@ static bool ipc_imem_is_channel_active(struct iosm_imem *ipc_imem,
 	return false;
 }
 
-/* Release a sio link to CP. */
-void ipc_imem_sys_cdev_close(struct iosm_cdev *ipc_cdev)
+/**
+ * ipc_imem_sys_port_close - Release a sio link to CP.
+ * @ipc_imem:          Imem instance.
+ * @channel:           Channel instance.
+ */
+void ipc_imem_sys_port_close(struct iosm_imem *ipc_imem,
+			     struct ipc_mem_channel *channel)
 {
-	struct iosm_imem *ipc_imem = ipc_cdev->ipc_imem;
-	struct ipc_mem_channel *channel = ipc_cdev->channel;
 	enum ipc_phase curr_phase;
 	int status = 0;
 	u32 tail = 0;
@@ -643,6 +664,6 @@ int ipc_imem_sys_devlink_read(struct iosm_devlink *devlink, u8 *data,
 	memcpy(data, skb->data, skb->len);
 
 devlink_read_fail:
-	ipc_pcie_kfree_skb(devlink->pcie, skb);
+	dev_kfree_skb(skb);
 	return rc;
 }
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
index f0c88ac5643c..e36ee2782629 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
@@ -43,12 +43,8 @@
  */
 struct ipc_mem_channel *ipc_imem_sys_port_open(struct iosm_imem *ipc_imem,
 					       int chl_id, int hp_id);
-
-/**
- * ipc_imem_sys_cdev_close - Release a sio link to CP.
- * @ipc_cdev:		iosm sio instance.
- */
-void ipc_imem_sys_cdev_close(struct iosm_cdev *ipc_cdev);
+void ipc_imem_sys_port_close(struct iosm_imem *ipc_imem,
+			     struct ipc_mem_channel *channel);
 
 /**
  * ipc_imem_sys_cdev_write - Route the uplink buffer to CP.
@@ -145,4 +141,5 @@ int ipc_imem_sys_devlink_read(struct iosm_devlink *ipc_devlink, u8 *data,
  */
 int ipc_imem_sys_devlink_write(struct iosm_devlink *ipc_devlink,
 			       unsigned char *buf, int count);
+struct iosm_trace *ipc_imem_trace_channel_init(struct iosm_imem *ipc_imem);
 #endif
diff --git a/drivers/net/wwan/iosm/iosm_ipc_port.c b/drivers/net/wwan/iosm/iosm_ipc_port.c
index beb944847398..b6d81c627277 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_port.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_port.c
@@ -27,7 +27,7 @@ static void ipc_port_ctrl_stop(struct wwan_port *port)
 {
 	struct iosm_cdev *ipc_port = wwan_port_get_drvdata(port);
 
-	ipc_imem_sys_cdev_close(ipc_port);
+	ipc_imem_sys_port_close(ipc_port->ipc_imem, ipc_port->channel);
 }
 
 /* transfer control data to modem */
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.c b/drivers/net/wwan/iosm/iosm_ipc_trace.c
new file mode 100644
index 000000000000..a067fc02545a
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020-2021 Intel Corporation.
+ */
+
+#include "iosm_ipc_trace.h"
+
+/* sub buffer size and number of sub buffer */
+#define IOSM_TRC_SUB_BUFF_SIZE 131072
+#define IOSM_TRC_N_SUB_BUFF 32
+
+#define IOSM_TRC_FILE_PERM 0600
+
+#define IOSM_TRC_DEBUGFS_DIR "iosm"
+#define IOSM_TRC_DEBUGFS_TRACE "trace"
+#define IOSM_TRC_DEBUGFS_TRACE_CTRL "trace_ctrl"
+
+/**
+ * ipc_trace_port_rx - Receive trace packet from cp and write to relay buffer
+ * @ipc_trace:  Pointer to the ipc trace data-struct
+ * @skb:        Pointer to struct sk_buff
+ */
+void ipc_trace_port_rx(struct iosm_trace *ipc_trace, struct sk_buff *skb)
+{
+	if (ipc_trace->ipc_rchan)
+		relay_write(ipc_trace->ipc_rchan, skb->data, skb->len);
+
+	dev_kfree_skb(skb);
+}
+
+/* Creates relay file in debugfs. */
+static struct dentry *
+ipc_trace_create_buf_file_handler(const char *filename,
+				  struct dentry *parent,
+				  umode_t mode,
+				  struct rchan_buf *buf,
+				  int *is_global)
+{
+	*is_global = 1;
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
+
+/* Removes relay file from debugfs. */
+static int ipc_trace_remove_buf_file_handler(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+	return 0;
+}
+
+static int ipc_trace_subbuf_start_handler(struct rchan_buf *buf, void *subbuf,
+					  void *prev_subbuf,
+					  size_t prev_padding)
+{
+	if (relay_buf_full(buf)) {
+		pr_err_ratelimited("Relay_buf full dropping traces");
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Relay interface callbacks */
+static struct rchan_callbacks relay_callbacks = {
+	.subbuf_start = ipc_trace_subbuf_start_handler,
+	.create_buf_file = ipc_trace_create_buf_file_handler,
+	.remove_buf_file = ipc_trace_remove_buf_file_handler,
+};
+
+/* Copy the trace control mode to user buffer */
+static ssize_t ipc_trace_ctrl_file_read(struct file *filp, char __user *buffer,
+					size_t count, loff_t *ppos)
+{
+	struct iosm_trace *ipc_trace = filp->private_data;
+	char buf[16];
+	int len;
+
+	mutex_lock(&ipc_trace->trc_mutex);
+	len = snprintf(buf, sizeof(buf), "%d\n", ipc_trace->mode);
+	mutex_unlock(&ipc_trace->trc_mutex);
+
+	return simple_read_from_buffer(buffer, count, ppos, buf, len);
+}
+
+/* Open and close the trace channel depending on user input */
+static ssize_t ipc_trace_ctrl_file_write(struct file *filp,
+					 const char __user *buffer,
+					 size_t count, loff_t *ppos)
+{
+	struct iosm_trace *ipc_trace = filp->private_data;
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(buffer, count, 10, &val);
+
+	if (ret)
+		return ret;
+
+	mutex_lock(&ipc_trace->trc_mutex);
+	if (val == TRACE_ENABLE && ipc_trace->mode != TRACE_ENABLE) {
+		ipc_trace->channel = ipc_imem_sys_port_open(ipc_trace->ipc_imem,
+							    ipc_trace->chl_id,
+							    IPC_HP_CDEV_OPEN);
+		if (!ipc_trace->channel) {
+			ret = -EIO;
+			goto unlock;
+		}
+		ipc_trace->mode = TRACE_ENABLE;
+	} else if (val == TRACE_DISABLE && ipc_trace->mode != TRACE_DISABLE) {
+		ipc_trace->mode = TRACE_DISABLE;
+		/* close trace channel */
+		ipc_imem_sys_port_close(ipc_trace->ipc_imem,
+					ipc_trace->channel);
+		relay_flush(ipc_trace->ipc_rchan);
+	}
+	ret = count;
+unlock:
+	mutex_unlock(&ipc_trace->trc_mutex);
+	return ret;
+}
+
+static const struct file_operations ipc_trace_fops = {
+	.open = simple_open,
+	.write = ipc_trace_ctrl_file_write,
+	.read  = ipc_trace_ctrl_file_read,
+};
+
+/**
+ * ipc_trace_init - Create trace interface & debugfs entries
+ * @ipc_imem:   Pointer to iosm_imem structure
+ *
+ * Returns: Pointer to trace instance on success else NULL
+ */
+struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem)
+{
+	struct iosm_trace *ipc_trace = kzalloc(sizeof(*ipc_trace), GFP_KERNEL);
+	struct dentry *ctrl_file;
+
+	if (!ipc_trace)
+		return NULL;
+
+	ipc_trace->mode = TRACE_DISABLE;
+	ipc_trace->dev = ipc_imem->dev;
+	ipc_trace->ipc_imem = ipc_imem;
+	ipc_trace->chl_id = IPC_MEM_CTRL_CHL_ID_3;
+
+	mutex_init(&ipc_trace->trc_mutex);
+
+	ipc_trace->debugfs_pdev = debugfs_create_dir(IOSM_TRC_DEBUGFS_DIR,
+						     NULL);
+
+	if (!ipc_trace->debugfs_pdev) {
+		dev_err(ipc_trace->dev, "debugfs directory creation failed");
+		goto debugfs_create_dir_err;
+	}
+
+	ctrl_file = debugfs_create_file(IOSM_TRC_DEBUGFS_TRACE_CTRL,
+					IOSM_TRC_FILE_PERM,
+					ipc_trace->debugfs_pdev,
+					ipc_trace, &ipc_trace_fops);
+
+	if (!ctrl_file) {
+		dev_err(ipc_trace->dev,
+			"debugfs trace_ctrl file creation failed");
+		goto debugfs_create_file_err;
+	}
+
+	ipc_trace->ipc_rchan = relay_open(IOSM_TRC_DEBUGFS_TRACE,
+					  ipc_trace->debugfs_pdev,
+					  IOSM_TRC_SUB_BUFF_SIZE,
+					  IOSM_TRC_N_SUB_BUFF,
+					  &relay_callbacks, NULL);
+
+	if (!ipc_trace->ipc_rchan) {
+		dev_err(ipc_trace->dev, "relay_open failed");
+		goto debugfs_create_file_err;
+	}
+
+	return ipc_trace;
+debugfs_create_file_err:
+	debugfs_remove_recursive(ipc_trace->debugfs_pdev);
+debugfs_create_dir_err:
+	mutex_destroy(&ipc_trace->trc_mutex);
+	kfree(ipc_trace);
+	return NULL;
+}
+
+/**
+ * ipc_trace_deinit - Closing relayfs, removing debugfs entries
+ * @ipc_trace: Pointer to the iosm_trace data struct
+ */
+void ipc_trace_deinit(struct iosm_trace *ipc_trace)
+{
+	relay_close(ipc_trace->ipc_rchan);
+	debugfs_remove_recursive(ipc_trace->debugfs_pdev);
+	mutex_destroy(&ipc_trace->trc_mutex);
+	kfree(ipc_trace);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.h b/drivers/net/wwan/iosm/iosm_ipc_trace.h
new file mode 100644
index 000000000000..e854af7a33ee
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020-2021 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_TRACE_H
+#define IOSM_IPC_TRACE_H
+
+#include <linux/debugfs.h>
+#include <linux/relay.h>
+
+#include "iosm_ipc_chnl_cfg.h"
+#include "iosm_ipc_imem_ops.h"
+
+/**
+ * enum trace_ctrl_mode - State of trace channel
+ * @TRACE_DISABLE:	mode for disable trace
+ * @TRACE_ENABLE:	mode for enable trace
+ */
+enum trace_ctrl_mode {
+	TRACE_DISABLE = 0,
+	TRACE_ENABLE,
+};
+
+/**
+ * struct iosm_trace - Struct for trace interface
+ * @debugfs_pdev:	Pointer to debugfs directory
+ * @ipc_rchan:		Pointer to relay channel
+ * @ctrl_file:		Pointer to trace control file
+ * @ipc_imem:		Imem instance
+ * @dev:		Pointer to device struct
+ * @channel:		Channel instance
+ * @chl_id:		Channel Indentifier
+ * @trc_mutex:		Mutex used for read and write mode
+ * @mode:		Mode for enable and disable trace
+ */
+
+struct iosm_trace {
+	struct dentry *debugfs_pdev;
+	struct rchan *ipc_rchan;
+	struct dentry *ctrl_file;
+	struct iosm_imem *ipc_imem;
+	struct device *dev;
+	struct ipc_mem_channel *channel;
+	enum ipc_channel_id chl_id;
+	struct mutex trc_mutex;	/* Mutex used for read and write mode */
+	enum trace_ctrl_mode mode;
+};
+
+struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem);
+void ipc_trace_deinit(struct iosm_trace *ipc_trace);
+void ipc_trace_port_rx(struct iosm_trace *ipc_trace, struct sk_buff *skb);
+#endif
-- 
2.25.1

