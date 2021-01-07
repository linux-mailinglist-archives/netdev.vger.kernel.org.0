Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0C32ED517
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbhAGRHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:07:02 -0500
Received: from mga14.intel.com ([192.55.52.115]:53928 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbhAGRGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:06:51 -0500
IronPort-SDR: N5ZaqAO0KcgIzCwGUVMk50oiyipUXEHqxTCEHgXbtxubKGtudx1uVx7MGBLqTF9ZHGB0kreBzp
 kgtmNPoHe4iw==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="176680913"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="176680913"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 09:06:10 -0800
IronPort-SDR: rt7FEuUbiMWWbDx6uph6jJDO0VmYE6WCa4b5R0J2OGGCrpHPw2MwO01KlUitTh+OmN+w0mfXVi
 AEVSRzXb2pxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="422643835"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga001.jf.intel.com with ESMTP; 07 Jan 2021 09:06:05 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [PATCH 07/18] net: iosm: char device for FW flash & coredump
Date:   Thu,  7 Jan 2021 22:35:12 +0530
Message-Id: <20210107170523.26531-8-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210107170523.26531-1-m.chetan.kumar@intel.com>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implements a char device for flashing Modem FW image while Device
is in boot rom phase and for collecting traces on modem crash.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_sio.c | 266 +++++++++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_sio.h |  78 ++++++++++
 2 files changed, 344 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_sio.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_sio.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_sio.c b/drivers/net/wwan/iosm/iosm_ipc_sio.c
new file mode 100644
index 000000000000..dfa7bff15c51
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_sio.c
@@ -0,0 +1,266 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#include <linux/poll.h>
+#include <asm/ioctls.h>
+
+#include "iosm_ipc_sio.h"
+
+static struct mutex sio_floc;		/* Mutex Lock for sio read */
+static struct mutex sio_floc_wr;	/* Mutex Lock for sio write */
+
+/* Open a shared memory device and initialize the head of the rx skbuf list. */
+static int ipc_sio_fop_open(struct inode *inode, struct file *filp)
+{
+	struct iosm_sio *ipc_sio =
+		container_of(filp->private_data, struct iosm_sio, misc);
+
+	struct iosm_sio_open_file *sio_op = kzalloc(sizeof(*sio_op),
+						    GFP_KERNEL);
+	if (!sio_op)
+		return -ENOMEM;
+
+	if (test_and_set_bit(IS_OPEN, &ipc_sio->flag)) {
+		kfree(sio_op);
+		return -EBUSY;
+	}
+
+	ipc_sio->channel = imem_sys_sio_open(ipc_sio->ipc_imem);
+
+	if (!ipc_sio->channel) {
+		kfree(sio_op);
+		return -EIO;
+	}
+
+	mutex_lock(&sio_floc);
+
+	inode->i_private = sio_op;
+	ipc_sio->sio_fop = sio_op;
+	sio_op->sio_dev = ipc_sio;
+
+	mutex_unlock(&sio_floc);
+	return 0;
+}
+
+static int ipc_sio_fop_release(struct inode *inode, struct file *filp)
+{
+	struct iosm_sio_open_file *sio_op = inode->i_private;
+
+	mutex_lock(&sio_floc);
+
+	if (sio_op->sio_dev) {
+		clear_bit(IS_OPEN, &sio_op->sio_dev->flag);
+		imem_sys_sio_close(sio_op->sio_dev);
+		sio_op->sio_dev->sio_fop = NULL;
+	}
+
+	kfree(sio_op);
+
+	mutex_unlock(&sio_floc);
+	return 0;
+}
+
+/* Copy the data from skbuff to the user buffer */
+static ssize_t ipc_sio_fop_read(struct file *filp, char __user *buf,
+				size_t size, loff_t *l)
+{
+	struct iosm_sio_open_file *sio_op = filp->f_inode->i_private;
+	struct sk_buff *skb = NULL;
+	struct iosm_sio *ipc_sio;
+	ssize_t read_byt;
+	int ret_err;
+
+	if (!buf) {
+		ret_err = -EINVAL;
+		goto err;
+	}
+
+	mutex_lock(&sio_floc);
+
+	if (!sio_op->sio_dev) {
+		ret_err = -EIO;
+		goto err_free_lock;
+	}
+
+	ipc_sio = sio_op->sio_dev;
+
+	if (!(filp->f_flags & O_NONBLOCK))
+		set_bit(IS_BLOCKING, &ipc_sio->flag);
+
+	/* only log in blocking mode to reduce flooding the log */
+	if (test_bit(IS_BLOCKING, &ipc_sio->flag))
+		dev_dbg(ipc_sio->dev, "sio read chid[%d] size=%zu",
+			ipc_sio->channel->channel_id, size);
+
+	/* First provide the pending skbuf to the user. */
+	if (ipc_sio->rx_pending_buf) {
+		skb = ipc_sio->rx_pending_buf;
+		ipc_sio->rx_pending_buf = NULL;
+	}
+
+	/* check skb is available in rx_list or wait for skb in case of
+	 * blocking read
+	 */
+	while (!skb && !(skb = skb_dequeue(&ipc_sio->rx_list))) {
+		if (!test_bit(IS_BLOCKING, &ipc_sio->flag)) {
+			ret_err = -EAGAIN;
+			goto err_free_lock;
+		}
+		/* Suspend the user app and wait a certain time for data
+		 * from CP.
+		 */
+		wait_for_completion_interruptible_timeout
+		(&ipc_sio->read_sem, msecs_to_jiffies(IPC_READ_TIMEOUT));
+
+		if (test_bit(IS_DEINIT, &ipc_sio->flag)) {
+			ret_err = -EPERM;
+			goto err_free_lock;
+		}
+	}
+
+	read_byt = imem_sys_sio_read(ipc_sio, buf, size, skb);
+	mutex_unlock(&sio_floc);
+	return read_byt;
+
+err_free_lock:
+	mutex_unlock(&sio_floc);
+err:
+	return ret_err;
+}
+
+/* Route the user data to the shared memory layer. */
+static ssize_t ipc_sio_fop_write(struct file *filp, const char __user *buf,
+				 size_t size, loff_t *l)
+{
+	struct iosm_sio_open_file *sio_op = filp->f_inode->i_private;
+	struct iosm_sio *ipc_sio;
+	bool is_blocking;
+	ssize_t write_byt;
+	int ret_err;
+
+	if (!buf) {
+		ret_err = -EINVAL;
+		goto err;
+	}
+
+	mutex_lock(&sio_floc_wr);
+	if (!sio_op->sio_dev) {
+		ret_err = -EIO;
+		goto err_free_lock;
+	}
+
+	ipc_sio = sio_op->sio_dev;
+
+	is_blocking = !(filp->f_flags & O_NONBLOCK);
+	if (!is_blocking) {
+		if (test_bit(WRITE_IN_USE, &ipc_sio->flag)) {
+			ret_err = -EAGAIN;
+			goto err_free_lock;
+		}
+	}
+
+	write_byt =  imem_sys_sio_write(ipc_sio, buf, size, is_blocking);
+	mutex_unlock(&sio_floc_wr);
+	return write_byt;
+
+err_free_lock:
+	mutex_unlock(&sio_floc_wr);
+err:
+	return ret_err;
+}
+
+/* poll for applications using nonblocking I/O */
+static __poll_t ipc_sio_fop_poll(struct file *filp, poll_table *wait)
+{
+	struct iosm_sio *ipc_sio =
+		container_of(filp->private_data, struct iosm_sio, misc);
+	__poll_t mask = 0;
+
+	/* Just registers wait_queue hook. This doesn't really wait. */
+	poll_wait(filp, &ipc_sio->poll_inq, wait);
+
+	/* Test the fill level of the skbuf rx queue. */
+	if (!skb_queue_empty(&ipc_sio->rx_list) || ipc_sio->rx_pending_buf)
+		mask |= EPOLLIN | EPOLLRDNORM; /* readable */
+
+	if (!test_bit(WRITE_IN_USE, &ipc_sio->flag))
+		mask |= EPOLLOUT | EPOLLWRNORM; /* writable */
+
+	return mask;
+}
+
+struct iosm_sio *ipc_sio_init(struct iosm_imem *ipc_imem, const char *name)
+{
+	static const struct file_operations fops = {
+		.owner = THIS_MODULE,
+		.open = ipc_sio_fop_open,
+		.release = ipc_sio_fop_release,
+		.read = ipc_sio_fop_read,
+		.write = ipc_sio_fop_write,
+		.poll = ipc_sio_fop_poll,
+	};
+
+	struct iosm_sio *ipc_sio = kzalloc(sizeof(*ipc_sio), GFP_KERNEL);
+
+	if (!ipc_sio)
+		return NULL;
+
+	ipc_sio->dev = ipc_imem->dev;
+	ipc_sio->pcie = ipc_imem->pcie;
+	ipc_sio->ipc_imem = ipc_imem;
+
+	mutex_init(&sio_floc);
+	mutex_init(&sio_floc_wr);
+	init_completion(&ipc_sio->read_sem);
+
+	skb_queue_head_init(&ipc_sio->rx_list);
+	init_waitqueue_head(&ipc_sio->poll_inq);
+
+	strncpy(ipc_sio->devname, name, sizeof(ipc_sio->devname) - 1);
+	ipc_sio->devname[IPC_SIO_DEVNAME_LEN - 1] = '\0';
+
+	ipc_sio->misc.minor = MISC_DYNAMIC_MINOR;
+	ipc_sio->misc.name = ipc_sio->devname;
+	ipc_sio->misc.fops = &fops;
+	ipc_sio->misc.mode = IPC_CHAR_DEVICE_DEFAULT_MODE;
+
+	if (misc_register(&ipc_sio->misc) != 0) {
+		kfree(ipc_sio);
+		return NULL;
+	}
+
+	return ipc_sio;
+}
+
+void ipc_sio_deinit(struct iosm_sio *ipc_sio)
+{
+	if (ipc_sio) {
+		misc_deregister(&ipc_sio->misc);
+
+		set_bit(IS_DEINIT, &ipc_sio->flag);
+		/* Applying memory barrier so that ipc_sio->flag is updated
+		 * before being read
+		 */
+		smp_mb__after_atomic();
+		if (test_bit(IS_BLOCKING, &ipc_sio->flag)) {
+			complete(&ipc_sio->read_sem);
+			complete(&ipc_sio->channel->ul_sem);
+		}
+
+		mutex_lock(&sio_floc);
+		mutex_lock(&sio_floc_wr);
+
+		ipc_pcie_kfree_skb(ipc_sio->pcie, ipc_sio->rx_pending_buf);
+		skb_queue_purge(&ipc_sio->rx_list);
+
+		if (ipc_sio->sio_fop)
+			ipc_sio->sio_fop->sio_dev = NULL;
+
+		mutex_unlock(&sio_floc_wr);
+		mutex_unlock(&sio_floc);
+
+		kfree(ipc_sio);
+	}
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_sio.h b/drivers/net/wwan/iosm/iosm_ipc_sio.h
new file mode 100644
index 000000000000..fedc14d5f3c2
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_sio.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_SIO_H
+#define IOSM_IPC_SIO_H
+
+#include <linux/miscdevice.h>
+#include <linux/skbuff.h>
+
+#include "iosm_ipc_imem_ops.h"
+
+/* IPC char. device default mode. Only privileged user can access. */
+#define IPC_CHAR_DEVICE_DEFAULT_MODE 0600
+
+#define IS_OPEN 0
+#define IS_BLOCKING 1
+#define WRITE_IN_USE 2
+#define IS_DEINIT 3
+
+/**
+ * struct iosm_sio_open_file - Reference to struct iosm_sio
+ * @sio_dev:	iosm_sio instance
+ */
+struct iosm_sio_open_file {
+	struct iosm_sio *sio_dev;
+};
+
+/**
+ * struct iosm_sio - State of the char driver layer.
+ * @misc:		OS misc device component
+ * @sio_fop:		reference to iosm_sio structure
+ * @ipc_imem:		imem instance
+ * @dev:		Pointer to device struct
+ * @pcie:		PCIe component
+ * @rx_pending_buf:	Storage for skb when its data has not been fully read
+ * @misc:		OS misc device component
+ * @devname:		Device name
+ * @channel:		Channel instance
+ * @rx_list:		Downlink skbuf list received from CP.
+ * @read_sem:		Needed for the blocking read or downlink transfer
+ * @poll_inq:		Read queues to support the poll system call
+ * @flag:		Flags to monitor state of device
+ * @wmaxcommand:	Max buffer size
+ */
+struct iosm_sio {
+	struct miscdevice misc;
+	struct iosm_sio_open_file *sio_fop;
+	struct iosm_imem *ipc_imem;
+	struct device *dev;
+	struct iosm_pcie *pcie;
+	struct sk_buff *rx_pending_buf;
+	char devname[IPC_SIO_DEVNAME_LEN];
+	struct ipc_mem_channel *channel;
+	struct sk_buff_head rx_list;
+	struct completion read_sem;
+	wait_queue_head_t poll_inq;
+	unsigned long flag;
+	u16 wmaxcommand;
+};
+
+/**
+ * ipc_sio_init - Allocate and create a character device.
+ * @ipc_imem:	Pointer to iosm_imem structure
+ * @name:	Pointer to character device name
+ *
+ * Returns: Pointer to sio instance on success and NULL on failure
+ */
+struct iosm_sio *ipc_sio_init(struct iosm_imem *ipc_imem, const char *name);
+
+/**
+ * ipc_sio_deinit - Dellocate and free resource for a character device.
+ * @ipc_sio:	Pointer to the ipc sio data-struct
+ */
+void ipc_sio_deinit(struct iosm_sio *ipc_sio);
+
+#endif
-- 
2.12.3

