Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518162ED512
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbhAGRGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:06:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:53939 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbhAGRGy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:06:54 -0500
IronPort-SDR: vOdRYzxAL4QOO0o28lMW1yCfY880JxjZoPRUyjEvUEBE+TEVRO19mmyuB8UUAqWO0BeXwBqi6U
 iqOc8JRiYYPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="176680924"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="176680924"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 09:06:13 -0800
IronPort-SDR: U3wsYmFmF7SwwPQhTBAAvSLbRtu/YOuALNfKJHo1VKq9yl1igG7pzUQydco05TJ6PqHeTsUMwd
 teVeRL7Htimw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="422643855"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga001.jf.intel.com with ESMTP; 07 Jan 2021 09:06:11 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [PATCH 08/18] net: iosm: MBIM control device
Date:   Thu,  7 Jan 2021 22:35:13 +0530
Message-Id: <20210107170523.26531-9-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210107170523.26531-1-m.chetan.kumar@intel.com>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implements a char device for MBIM protocol communication &
provides a simple IOCTL for max transfer buffer size
configuration.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_mbim.c | 286 ++++++++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_mbim.h |  25 +++
 2 files changed, 311 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mbim.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mbim.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mbim.c b/drivers/net/wwan/iosm/iosm_ipc_mbim.c
new file mode 100644
index 000000000000..885037a5642e
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_mbim.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#include <linux/poll.h>
+#include <linux/uaccess.h>
+
+#include "iosm_ipc_imem_ops.h"
+#include "iosm_ipc_mbim.h"
+#include "iosm_ipc_sio.h"
+
+#define IOCTL_WDM_MAX_COMMAND _IOR('H', 0xA0, __u16)
+#define WDM_MAX_SIZE 4096
+
+static struct mutex mbim_floc;		/* Mutex Lock for mbim read */
+static struct mutex mbim_floc_wr;	/* Mutex Lock for mbim write */
+
+/* MBIM IOCTL for configuring max MBIM packet size. */
+static long ipc_mbim_fop_unlocked_ioctl(struct file *filp, unsigned int cmd,
+					unsigned long arg)
+{
+	struct iosm_sio *ipc_mbim =
+		container_of(filp->private_data, struct iosm_sio, misc);
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
+	struct iosm_sio *ipc_mbim =
+		container_of(filp->private_data, struct iosm_sio, misc);
+
+	struct iosm_sio_open_file *mbim_op = kzalloc(sizeof(*mbim_op),
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
+	mutex_lock(&mbim_floc);
+
+	inode->i_private = mbim_op;
+	ipc_mbim->sio_fop = mbim_op;
+	mbim_op->sio_dev = ipc_mbim;
+
+	mutex_unlock(&mbim_floc);
+	return 0;
+}
+
+/* Close a shared memory control device and free the rx skbuf list. */
+static int ipc_mbim_fop_release(struct inode *inode, struct file *filp)
+{
+	struct iosm_sio_open_file *mbim_op = inode->i_private;
+
+	mutex_lock(&mbim_floc);
+	if (mbim_op->sio_dev) {
+		clear_bit(IS_OPEN, &mbim_op->sio_dev->flag);
+		imem_sys_sio_close(mbim_op->sio_dev);
+		mbim_op->sio_dev->sio_fop = NULL;
+	}
+	kfree(mbim_op);
+	mutex_unlock(&mbim_floc);
+	return 0;
+}
+
+/* Copy the data from skbuff to the user buffer */
+static ssize_t ipc_mbim_fop_read(struct file *filp, char __user *buf,
+				 size_t size, loff_t *l)
+{
+	struct iosm_sio_open_file *mbim_op = filp->f_inode->i_private;
+	struct sk_buff *skb = NULL;
+	struct iosm_sio *ipc_mbim;
+	ssize_t read_byt;
+	int ret_err;
+
+	if (!access_ok(buf, size)) {
+		ret_err = -EINVAL;
+		goto err;
+	}
+
+	mutex_lock(&mbim_floc);
+
+	if (!mbim_op->sio_dev) {
+		ret_err = -EIO;
+		goto err_free_lock;
+	}
+
+	ipc_mbim = mbim_op->sio_dev;
+
+	if (!(filp->f_flags & O_NONBLOCK))
+		set_bit(IS_BLOCKING, &ipc_mbim->flag);
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
+		wait_for_completion_interruptible_timeout
+		(&ipc_mbim->read_sem, msecs_to_jiffies(IPC_READ_TIMEOUT));
+
+		if (test_bit(IS_DEINIT, &ipc_mbim->flag)) {
+			ret_err = -EPERM;
+			goto err_free_lock;
+		}
+	}
+
+	read_byt = imem_sys_sio_read(ipc_mbim, buf, size, skb);
+	mutex_unlock(&mbim_floc);
+	return read_byt;
+
+err_free_lock:
+	mutex_unlock(&mbim_floc);
+err:
+	return ret_err;
+}
+
+/* Route the user data to the shared memory layer. */
+static ssize_t ipc_mbim_fop_write(struct file *filp, const char __user *buf,
+				  size_t size, loff_t *l)
+{
+	struct iosm_sio_open_file *mbim_op = filp->f_inode->i_private;
+	struct iosm_sio *ipc_mbim;
+	bool is_blocking;
+	ssize_t write_byt;
+	int ret_err;
+
+	if (!access_ok(buf, size)) {
+		ret_err = -EINVAL;
+		goto err;
+	}
+
+	mutex_lock(&mbim_floc_wr);
+
+	if (!mbim_op->sio_dev) {
+		ret_err = -EIO;
+		goto err_free_lock;
+	}
+
+	ipc_mbim = mbim_op->sio_dev;
+
+	is_blocking = !(filp->f_flags & O_NONBLOCK);
+
+	if (test_bit(WRITE_IN_USE, &ipc_mbim->flag)) {
+		ret_err = -EAGAIN;
+		goto err_free_lock;
+	}
+	write_byt = imem_sys_sio_write(ipc_mbim, buf, size, is_blocking);
+
+	mutex_unlock(&mbim_floc_wr);
+	return write_byt;
+
+err_free_lock:
+	mutex_unlock(&mbim_floc_wr);
+err:
+	return ret_err;
+}
+
+/* Poll mechanism for applications that use nonblocking IO */
+static __poll_t ipc_mbim_fop_poll(struct file *filp, poll_table *wait)
+{
+	struct iosm_sio *ipc_mbim =
+		container_of(filp->private_data, struct iosm_sio, misc);
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
+struct iosm_sio *ipc_mbim_init(struct iosm_imem *ipc_imem, const char *name)
+{
+	struct iosm_sio *ipc_mbim = kzalloc(sizeof(*ipc_mbim), GFP_KERNEL);
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
+	mutex_init(&mbim_floc);
+	mutex_init(&mbim_floc_wr);
+	init_completion(&ipc_mbim->read_sem);
+
+	skb_queue_head_init(&ipc_mbim->rx_list);
+	init_waitqueue_head(&ipc_mbim->poll_inq);
+
+	strncpy(ipc_mbim->devname, name, sizeof(ipc_mbim->devname) - 1);
+	ipc_mbim->devname[IPC_SIO_DEVNAME_LEN - 1] = '\0';
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
+void ipc_mbim_deinit(struct iosm_sio *ipc_mbim)
+{
+	misc_deregister(&ipc_mbim->misc);
+
+	set_bit(IS_DEINIT, &ipc_mbim->flag);
+	/* Applying memory barrier so that ipc_mbim->flag is updated
+	 * before being read
+	 */
+	smp_mb__after_atomic();
+
+	if (test_bit(IS_BLOCKING, &ipc_mbim->flag)) {
+		complete(&ipc_mbim->read_sem);
+		complete(&ipc_mbim->channel->ul_sem);
+	}
+
+	mutex_lock(&mbim_floc);
+	mutex_lock(&mbim_floc_wr);
+
+	ipc_pcie_kfree_skb(ipc_mbim->pcie, ipc_mbim->rx_pending_buf);
+	ipc_mbim->rx_pending_buf = NULL;
+	skb_queue_purge(&ipc_mbim->rx_list);
+
+	if (ipc_mbim->sio_fop)
+		ipc_mbim->sio_fop->sio_dev = NULL;
+
+	mutex_unlock(&mbim_floc_wr);
+	mutex_unlock(&mbim_floc);
+
+	kfree(ipc_mbim);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_mbim.h b/drivers/net/wwan/iosm/iosm_ipc_mbim.h
new file mode 100644
index 000000000000..0ca0be6fd4d8
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_mbim.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_MBIM_H
+#define IOSM_IPC_MBIM_H
+
+/**
+ * ipc_mbim_init - Initialize and create a character device for MBIM
+ *		   communication.
+ * @ipc_imem:	Pointer to iosm_imem structure
+ * @name:	Pointer to character device name
+ *
+ * Returns: 0 on success
+ */
+struct iosm_sio *ipc_mbim_init(struct iosm_imem *ipc_imem, const char *name);
+
+/**
+ * ipc_mbim_deinit - Frees all the memory allocated for the ipc mbim structure.
+ * @ipc_mbim:	Pointer to the ipc mbim data-struct
+ */
+void ipc_mbim_deinit(struct iosm_sio *ipc_mbim);
+
+#endif
-- 
2.12.3

