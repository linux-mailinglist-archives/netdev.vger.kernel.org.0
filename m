Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AB3365D0B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbhDTQPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:15:25 -0400
Received: from mga05.intel.com ([192.55.52.43]:42702 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233208AbhDTQPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 12:15:11 -0400
IronPort-SDR: FuoxhgEO77VAPS4bO0AD3gva+W4+895M0cvcBhK+8GU/F8FpI6PdWE+1OsmZ5HVWiNifLmw5bs
 qLEiBTpfiQgA==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="280865971"
X-IronPort-AV: E=Sophos;i="5.82,237,1613462400"; 
   d="scan'208";a="280865971"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 09:14:40 -0700
IronPort-SDR: rTMJwZfMi/vMuisQJNOlmjzVBk3NyRe3IVaXVNbBY8r/R82H9cEZhocrw485PTBhGyDF3ArdxG
 2CdTbzD/Lr2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,237,1613462400"; 
   d="scan'208";a="454883247"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by fmsmga002.fm.intel.com with ESMTP; 20 Apr 2021 09:14:38 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V2 07/16] net: iosm: mbim control device
Date:   Tue, 20 Apr 2021 21:43:01 +0530
Message-Id: <20210420161310.16189-8-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210420161310.16189-1-m.chetan.kumar@intel.com>
References: <20210420161310.16189-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implements a char device for MBIM protocol communication &
provides a simple IOCTL for max transfer buffer size
configuration.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
v2:
* Renamed iosm_sio struct to iosm_cdev.
* Added memory barriers around atomic operations.
---
 drivers/net/wwan/iosm/iosm_ipc_mbim.c | 306 ++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_mbim.h |  78 +++++++
 2 files changed, 384 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mbim.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mbim.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mbim.c b/drivers/net/wwan/iosm/iosm_ipc_mbim.c
new file mode 100644
index 000000000000..72822b4048ab
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_mbim.c
@@ -0,0 +1,306 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#include <linux/poll.h>
+#include <linux/skbuff.h>
+#include <linux/uaccess.h>
+
+#include "iosm_ipc_imem_ops.h"
+#include "iosm_ipc_mbim.h"
+
+#define IOCTL_WDM_MAX_COMMAND _IOR('H', 0xA0, __u16)
+#define WDM_MAX_SIZE 4096
+
+static struct mutex mbim_flock;		/* Mutex Lock for mbim read */
+static struct mutex mbim_flock_wr;	/* Mutex Lock for mbim write */
+
+/* MBIM IOCTL for configuring max MBIM packet size. */
+static long ipc_mbim_fop_unlocked_ioctl(struct file *filp, unsigned int cmd,
+					unsigned long arg)
+{
+	struct iosm_cdev *ipc_mbim =
+		container_of(filp->private_data, struct iosm_cdev, misc);
+
+	if (cmd != IOCTL_WDM_MAX_COMMAND ||
+	    !access_ok((void __user *)arg, sizeof(ipc_mbim->wmaxcommand)))
+		return -EINVAL;
+
+	if (copy_to_user((void __user *)arg, &ipc_mbim->wmaxcommand,
+			 sizeof(ipc_mbim->wmaxcommand)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/* Open a shared memory device and initialize the head of the rx skbuf list. */
+static int ipc_mbim_fop_open(struct inode *inode, struct file *filp)
+{
+	struct iosm_cdev *ipc_mbim =
+		container_of(filp->private_data, struct iosm_cdev, misc);
+
+	struct iosm_cdev_open_file *mbim_op = kzalloc(sizeof(*mbim_op),
+						      GFP_KERNEL);
+	if (!mbim_op)
+		return -ENOMEM;
+
+	if (test_and_set_bit(IS_OPEN, &ipc_mbim->flag)) {
+		kfree(mbim_op);
+		return -EBUSY;
+	}
+
+	ipc_mbim->channel = imem_sys_mbim_open(ipc_mbim->ipc_imem);
+
+	if (!ipc_mbim->channel) {
+		kfree(mbim_op);
+		return -EIO;
+	}
+
+	mutex_lock(&mbim_flock);
+
+	inode->i_private = mbim_op;
+	ipc_mbim->cdev_fop = mbim_op;
+	mbim_op->ipc_cdev = ipc_mbim;
+
+	mutex_unlock(&mbim_flock);
+	return 0;
+}
+
+/* Close a shared memory control device and free the rx skbuf list. */
+static int ipc_mbim_fop_release(struct inode *inode, struct file *filp)
+{
+	struct iosm_cdev_open_file *mbim_op = inode->i_private;
+
+	mutex_lock(&mbim_flock);
+	if (mbim_op->ipc_cdev) {
+		/* Complete all memory stores before clearing bit. */
+		smp_mb__before_atomic();
+
+		clear_bit(IS_OPEN, &mbim_op->ipc_cdev->flag);
+
+		/* Complete all memory stores after clearing bit. */
+		smp_mb__after_atomic();
+
+		imem_sys_cdev_close(mbim_op->ipc_cdev);
+		mbim_op->ipc_cdev->cdev_fop = NULL;
+	}
+	kfree(mbim_op);
+	mutex_unlock(&mbim_flock);
+	return 0;
+}
+
+/* Copy the data from skbuff to the user buffer */
+static ssize_t ipc_mbim_fop_read(struct file *filp, char __user *buf,
+				 size_t size, loff_t *l)
+{
+	struct iosm_cdev_open_file *mbim_op = filp->f_inode->i_private;
+	struct sk_buff *skb = NULL;
+	struct iosm_cdev *ipc_mbim;
+	ssize_t read_byt;
+	int ret_err;
+
+	if (!access_ok(buf, size)) {
+		ret_err = -EINVAL;
+		goto err;
+	}
+
+	mutex_lock(&mbim_flock);
+
+	if (!mbim_op->ipc_cdev) {
+		ret_err = -EIO;
+		goto err_free_lock;
+	}
+
+	ipc_mbim = mbim_op->ipc_cdev;
+
+	if (!(filp->f_flags & O_NONBLOCK)) {
+		/* Complete all memory stores before setting bit */
+		smp_mb__before_atomic();
+
+		set_bit(IS_BLOCKING, &ipc_mbim->flag);
+
+		/* Complete all memory stores after setting bit */
+		smp_mb__after_atomic();
+	}
+
+	/* First provide the pending skbuf to the user. */
+	if (ipc_mbim->rx_pending_buf) {
+		skb = ipc_mbim->rx_pending_buf;
+		ipc_mbim->rx_pending_buf = NULL;
+	}
+
+	/* Check rx queue until skb is available */
+	while (!skb && !(skb = skb_dequeue(&ipc_mbim->rx_list))) {
+		if (!test_bit(IS_BLOCKING, &ipc_mbim->flag)) {
+			ret_err = -EAGAIN;
+			goto err_free_lock;
+		}
+
+		/* Suspend the user app and wait a certain time for data
+		 * from CP.
+		 */
+		if (!wait_for_completion_interruptible_timeout
+		(&ipc_mbim->read_sem, msecs_to_jiffies(IPC_READ_TIMEOUT))) {
+			dev_err(ipc_mbim->dev, "Read timedout");
+			ret_err = -ETIMEDOUT;
+			goto err_free_lock;
+		}
+
+		if (test_bit(IS_DEINIT, &ipc_mbim->flag)) {
+			ret_err = -EPERM;
+			goto err_free_lock;
+		}
+	}
+
+	read_byt = imem_sys_cdev_read(ipc_mbim, buf, size, skb);
+	mutex_unlock(&mbim_flock);
+	return read_byt;
+
+err_free_lock:
+	mutex_unlock(&mbim_flock);
+err:
+	return ret_err;
+}
+
+/* Route the user data to the shared memory layer. */
+static ssize_t ipc_mbim_fop_write(struct file *filp, const char __user *buf,
+				  size_t size, loff_t *l)
+{
+	struct iosm_cdev_open_file *mbim_op = filp->f_inode->i_private;
+	struct iosm_cdev *ipc_mbim;
+	bool is_blocking;
+	ssize_t write_byt;
+	int ret_err;
+
+	if (!access_ok(buf, size)) {
+		ret_err = -EINVAL;
+		goto err;
+	}
+
+	mutex_lock(&mbim_flock_wr);
+
+	if (!mbim_op->ipc_cdev) {
+		ret_err = -EIO;
+		goto err_free_lock;
+	}
+
+	ipc_mbim = mbim_op->ipc_cdev;
+
+	is_blocking = !(filp->f_flags & O_NONBLOCK);
+
+	if (test_bit(WRITE_IN_USE, &ipc_mbim->flag)) {
+		ret_err = -EAGAIN;
+		goto err_free_lock;
+	}
+	write_byt = imem_sys_cdev_write(ipc_mbim, buf, size, is_blocking);
+
+	mutex_unlock(&mbim_flock_wr);
+	return write_byt;
+
+err_free_lock:
+	mutex_unlock(&mbim_flock_wr);
+err:
+	return ret_err;
+}
+
+/* Poll mechanism for applications that use nonblocking IO */
+static __poll_t ipc_mbim_fop_poll(struct file *filp, poll_table *wait)
+{
+	struct iosm_cdev *ipc_mbim =
+		container_of(filp->private_data, struct iosm_cdev, misc);
+	__poll_t mask = 0;
+
+	/* Just registers wait_queue hook. This doesn't really wait. */
+	poll_wait(filp, &ipc_mbim->poll_inq, wait);
+
+	/* Test the fill level of the skbuf rx queue. */
+	if (!test_bit(WRITE_IN_USE, &ipc_mbim->flag))
+		mask |= EPOLLOUT | EPOLLWRNORM; /* writable */
+
+	if (!skb_queue_empty(&ipc_mbim->rx_list) || ipc_mbim->rx_pending_buf)
+		mask |= EPOLLIN | EPOLLRDNORM; /* readable */
+
+	return mask;
+}
+
+struct iosm_cdev *ipc_mbim_init(struct iosm_imem *ipc_imem, const char *name)
+{
+	struct iosm_cdev *ipc_mbim = kzalloc(sizeof(*ipc_mbim), GFP_KERNEL);
+
+	static const struct file_operations fops = {
+		.owner = THIS_MODULE,
+		.open = ipc_mbim_fop_open,
+		.release = ipc_mbim_fop_release,
+		.read = ipc_mbim_fop_read,
+		.write = ipc_mbim_fop_write,
+		.poll = ipc_mbim_fop_poll,
+		.unlocked_ioctl = ipc_mbim_fop_unlocked_ioctl,
+	};
+
+	if (!ipc_mbim)
+		return NULL;
+
+	ipc_mbim->dev = ipc_imem->dev;
+	ipc_mbim->pcie = ipc_imem->pcie;
+	ipc_mbim->ipc_imem = ipc_imem;
+
+	ipc_mbim->wmaxcommand = WDM_MAX_SIZE;
+
+	mutex_init(&mbim_flock);
+	mutex_init(&mbim_flock_wr);
+	init_completion(&ipc_mbim->read_sem);
+
+	skb_queue_head_init(&ipc_mbim->rx_list);
+	init_waitqueue_head(&ipc_mbim->poll_inq);
+
+	strncpy(ipc_mbim->devname, name, sizeof(ipc_mbim->devname) - 1);
+	ipc_mbim->devname[IPC_CDEV_NAME_LEN - 1] = '\0';
+
+	ipc_mbim->misc.minor = MISC_DYNAMIC_MINOR;
+	ipc_mbim->misc.name = ipc_mbim->devname;
+	ipc_mbim->misc.fops = &fops;
+	ipc_mbim->misc.mode = IPC_CHAR_DEVICE_DEFAULT_MODE;
+
+	if (misc_register(&ipc_mbim->misc)) {
+		kfree(ipc_mbim);
+		return NULL;
+	}
+
+	dev_set_drvdata(ipc_mbim->misc.this_device, ipc_mbim);
+
+	return ipc_mbim;
+}
+
+void ipc_mbim_deinit(struct iosm_cdev *ipc_mbim)
+{
+	misc_deregister(&ipc_mbim->misc);
+
+	/* Complete all memory stores before setting bit */
+	smp_mb__before_atomic();
+
+	set_bit(IS_DEINIT, &ipc_mbim->flag);
+
+	/* Complete all memory stores after setting bit */
+	smp_mb__after_atomic();
+
+	if (test_bit(IS_BLOCKING, &ipc_mbim->flag)) {
+		complete(&ipc_mbim->read_sem);
+		complete(&ipc_mbim->channel->ul_sem);
+	}
+
+	mutex_lock(&mbim_flock);
+	mutex_lock(&mbim_flock_wr);
+
+	ipc_pcie_kfree_skb(ipc_mbim->pcie, ipc_mbim->rx_pending_buf);
+	ipc_mbim->rx_pending_buf = NULL;
+	skb_queue_purge(&ipc_mbim->rx_list);
+
+	if (ipc_mbim->cdev_fop)
+		ipc_mbim->cdev_fop->ipc_cdev = NULL;
+
+	mutex_unlock(&mbim_flock_wr);
+	mutex_unlock(&mbim_flock);
+
+	kfree(ipc_mbim);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_mbim.h b/drivers/net/wwan/iosm/iosm_ipc_mbim.h
new file mode 100644
index 000000000000..f311de5598f4
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_mbim.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_MBIM_H
+#define IOSM_IPC_MBIM_H
+
+#include <linux/miscdevice.h>
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
+ * struct iosm_cdev_open_file - Reference to struct iosm_cdev
+ * @ipc_cdev:	iosm_cdev instance
+ */
+struct iosm_cdev_open_file {
+	struct iosm_cdev *ipc_cdev;
+};
+
+/**
+ * struct iosm_cdev - State of the char driver layer.
+ * @misc:		OS misc device component
+ * @cdev_fop:		reference to iosm_cdev structure
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
+struct iosm_cdev {
+	struct miscdevice misc;
+	struct iosm_cdev_open_file *cdev_fop;
+	struct iosm_imem *ipc_imem;
+	struct device *dev;
+	struct iosm_pcie *pcie;
+	struct sk_buff *rx_pending_buf;
+	char devname[IPC_CDEV_NAME_LEN];
+	struct ipc_mem_channel *channel;
+	struct sk_buff_head rx_list;
+	struct completion read_sem;
+	wait_queue_head_t poll_inq;
+	unsigned long flag;
+	u16 wmaxcommand;
+};
+
+/**
+ * ipc_mbim_init - Initialize and create a character device for MBIM
+ *		   communication.
+ * @ipc_imem:	Pointer to iosm_imem structure
+ * @name:	Pointer to character device name
+ *
+ * Returns: 0 on success
+ */
+struct iosm_cdev *ipc_mbim_init(struct iosm_imem *ipc_imem, const char *name);
+
+/**
+ * ipc_mbim_deinit - Frees all the memory allocated for the ipc mbim structure.
+ * @ipc_mbim:	Pointer to the ipc mbim data-struct
+ */
+void ipc_mbim_deinit(struct iosm_cdev *ipc_mbim);
+
+#endif
-- 
2.25.1

