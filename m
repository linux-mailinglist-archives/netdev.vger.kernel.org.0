Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246012C0C40
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbgKWNwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:52:11 -0500
Received: from mga14.intel.com ([192.55.52.115]:1467 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbgKWNwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:52:11 -0500
IronPort-SDR: edPVF73VhlCMbLO0uWe9GrgfbOIhMjF8U07jaJGExK1ur3ksfLi4h498Wn4+Er9/y3sECN4Xyn
 nG2TXj5b3kDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="170981450"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="170981450"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 05:52:10 -0800
IronPort-SDR: DMV56W5TPesAGPnB/ZoztFkP2wF4LaXMRYM5D4VcXcXOTLiFYrek7Y90waQMeoHyx4rn7/qLLK
 Iy91NcQb40MQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="370035544"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga007.jf.intel.com with ESMTP; 23 Nov 2020 05:52:08 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [RFC 07/18] net: iosm: char device for FW flash & coredump
Date:   Mon, 23 Nov 2020 19:21:12 +0530
Message-Id: <20201123135123.48892-8-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20201123135123.48892-1-m.chetan.kumar@intel.com>
References: <20201123135123.48892-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implements a char device for flashing Modem FW image while Device
is in boot rom phase and for collecting traces on modem crash.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_sio.c | 188 +++++++++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_sio.h |  72 ++++++++++++++
 2 files changed, 260 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_sio.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_sio.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_sio.c b/drivers/net/wwan/iosm/iosm_ipc_sio.c
new file mode 100644
index 000000000000..c35e7c6face1
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_sio.c
@@ -0,0 +1,188 @@
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
+/* Open a shared memory device and initialize the head of the rx skbuf list. */
+static int ipc_sio_fop_open(struct inode *inode, struct file *filp)
+{
+	struct iosm_sio *ipc_sio =
+		container_of(filp->private_data, struct iosm_sio, misc);
+
+	if (test_and_set_bit(0, &ipc_sio->sio_is_open))
+		return -EBUSY;
+
+	ipc_sio->channel_id = imem_sys_sio_open(ipc_sio->imem_instance);
+
+	if (ipc_sio->channel_id < 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int ipc_sio_fop_release(struct inode *inode, struct file *filp)
+{
+	struct iosm_sio *ipc_sio =
+		container_of(filp->private_data, struct iosm_sio, misc);
+
+	if (ipc_sio->channel_id < 0)
+		return -EINVAL;
+
+	imem_sys_sio_close(ipc_sio);
+
+	clear_bit(0, &ipc_sio->sio_is_open);
+
+	return 0;
+}
+
+/* Copy the data from skbuff to the user buffer */
+static ssize_t ipc_sio_fop_read(struct file *filp, char __user *buf,
+				size_t size, loff_t *l)
+{
+	struct sk_buff *skb = NULL;
+	struct iosm_sio *ipc_sio;
+	bool is_blocking;
+
+	if (!buf)
+		return -EINVAL;
+
+	ipc_sio = container_of(filp->private_data, struct iosm_sio, misc);
+
+	is_blocking = !(filp->f_flags & O_NONBLOCK);
+
+	/* only log in blocking mode to reduce flooding the log */
+	if (is_blocking)
+		dev_dbg(ipc_sio->dev, "sio read chid[%d] size=%zu",
+			ipc_sio->channel_id, size);
+
+	/* First provide the pending skbuf to the user. */
+	if (ipc_sio->rx_pending_buf) {
+		skb = ipc_sio->rx_pending_buf;
+		ipc_sio->rx_pending_buf = NULL;
+	}
+
+	/* Check rx queue until skb is available */
+	while (!skb) {
+		skb = skb_dequeue(&ipc_sio->rx_list);
+		if (skb)
+			break;
+
+		if (!is_blocking)
+			return -EAGAIN;
+		/* Suspend the user app and wait a certain time for data
+		 * from CP.
+		 */
+		if (WAIT_FOR_TIMEOUT(&ipc_sio->read_sem, IPC_READ_TIMEOUT) <
+		    0) {
+			return -ETIMEDOUT;
+		}
+	}
+
+	return imem_sys_sio_read(ipc_sio, buf, size, skb);
+}
+
+/* Route the user data to the shared memory layer. */
+static ssize_t ipc_sio_fop_write(struct file *filp, const char __user *buf,
+				 size_t size, loff_t *l)
+{
+	struct iosm_sio *ipc_sio;
+	bool is_blocking;
+
+	if (!buf)
+		return -EINVAL;
+
+	ipc_sio = container_of(filp->private_data, struct iosm_sio, misc);
+
+	is_blocking = !(filp->f_flags & O_NONBLOCK);
+
+	if (ipc_sio->channel_id < 0)
+		return -EPERM;
+
+	return imem_sys_sio_write(ipc_sio, buf, size, is_blocking);
+}
+
+/* poll for applications using nonblocking I/O */
+static __poll_t ipc_sio_fop_poll(struct file *filp, poll_table *wait)
+{
+	struct iosm_sio *ipc_sio =
+		container_of(filp->private_data, struct iosm_sio, misc);
+	__poll_t mask = EPOLLOUT | EPOLLWRNORM; /* writable */
+
+	/* Just registers wait_queue hook. This doesn't really wait. */
+	poll_wait(filp, &ipc_sio->poll_inq, wait);
+
+	/* Test the fill level of the skbuf rx queue. */
+	if (!skb_queue_empty(&ipc_sio->rx_list) || ipc_sio->rx_pending_buf)
+		mask |= EPOLLIN | EPOLLRDNORM; /* readable */
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
+	ipc_sio->imem_instance = ipc_imem;
+
+	ipc_sio->channel_id = -1;
+	ipc_sio->sio_is_open = 0;
+	atomic_set(&ipc_sio->dreg_called, 0);
+
+	init_completion(&ipc_sio->read_sem);
+
+	skb_queue_head_init(&ipc_sio->rx_list);
+	init_waitqueue_head(&ipc_sio->poll_inq);
+	init_waitqueue_head(&ipc_sio->poll_outq);
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
+	if (atomic_cmpxchg(&ipc_sio->dreg_called, 0, 1) != 0)
+		return;
+
+	misc_deregister(&ipc_sio->misc);
+
+	/* Wakeup the user app. */
+	complete(&ipc_sio->read_sem);
+
+	ipc_pcie_kfree_skb(ipc_sio->pcie, ipc_sio->rx_pending_buf);
+	ipc_sio->rx_pending_buf = NULL;
+
+	skb_queue_purge(&ipc_sio->rx_list);
+
+	kfree(ipc_sio);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_sio.h b/drivers/net/wwan/iosm/iosm_ipc_sio.h
new file mode 100644
index 000000000000..d2a8e91ea117
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_sio.h
@@ -0,0 +1,72 @@
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
+/**
+ * struct iosm_sio - State of the char driver layer.
+ * @misc:		OS misc device component
+ * @imem_instance:	imem instance
+ * @dev:		Pointer to device struct
+ * @pcie:		PCIe component
+ * @rx_pending_buf:	Storage for skb when its data has not been fully read
+ * @misc:		OS misc device component
+ * @devname:		Device name
+ * @channel_id:		Channel ID as received from ipc_sio_ops.open
+ * @rx_list:		Downlink skbuf list received from CP.
+ * @read_sem:		Needed for the blocking read or downlink transfer
+ * @poll_inq:		Read queues to support the poll system call
+ * @poll_outq:		write queues to support the poll system call
+ * @sio_is_open:	Sio Open flag to restricts the number of concurrent open
+ *			operations to one
+ * @mbim_is_open:	Mbim Open flag to restricts the number of concurrent
+ *			open operations to one
+ * @dreg_called:	dreg_called indicates that deregister has been called.
+ *			This makes sure dreg is only executed once.
+ * @wmaxcommand:	Max buffer size
+ */
+struct iosm_sio {
+	struct miscdevice misc;
+	void *imem_instance;
+	struct device *dev;
+	struct iosm_pcie *pcie;
+	struct sk_buff *rx_pending_buf;
+	char devname[IPC_SIO_DEVNAME_LEN];
+	int channel_id;
+	struct sk_buff_head rx_list;
+	struct completion read_sem;
+	wait_queue_head_t poll_inq;
+	wait_queue_head_t poll_outq;
+	unsigned long sio_is_open;
+	unsigned long mbim_is_open;
+	atomic_t dreg_called;
+	u16 wmaxcommand;
+};
+
+/**
+ * ipc_sio_init - Allocate and create a character device
+ * @ipc_imem:	Pointer to iosm_imem structure
+ * @name:	Pointer to character device name
+ *
+ * Returns: Pointer to sio instance on success and NULL on failure
+ */
+struct iosm_sio *ipc_sio_init(struct iosm_imem *ipc_imem, const char *name);
+
+/**
+ * ipc_sio_deinit - Free all the memory allocated for the ipc sio structure.
+ * @ipc_sio:	Pointer to the ipc sio data-struct
+ */
+void ipc_sio_deinit(struct iosm_sio *ipc_sio);
+
+#endif
-- 
2.12.3

