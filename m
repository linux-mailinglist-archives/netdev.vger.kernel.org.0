Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AB52C0C44
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbgKWNwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:52:17 -0500
Received: from mga14.intel.com ([192.55.52.115]:1467 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbgKWNwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:52:15 -0500
IronPort-SDR: a2bd40c91DcbpzZpjgq4vZ4Ia93oBQ5z6/4UBPAdSFubVH8I7hrbS3WB6ODhmCUUE6dlsa9hfp
 9k9x27A+dUvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="170981463"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="170981463"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 05:52:14 -0800
IronPort-SDR: +36Rq6FaH2mev9KCyshvDQkWeXrJDLwjCLfBxof5e8r39JxAL/kh3yiOnhQ8MDBQ6RYs0JRrg7
 +GmhKsW2mpZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="370035554"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga007.jf.intel.com with ESMTP; 23 Nov 2020 05:52:11 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [RFC 08/18] net: iosm: MBIM control device
Date:   Mon, 23 Nov 2020 19:21:13 +0530
Message-Id: <20201123135123.48892-9-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20201123135123.48892-1-m.chetan.kumar@intel.com>
References: <20201123135123.48892-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implements a char device for MBIM protocol communication &
provides a simple IOCTL for max transfer buffer size
configuration.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_mbim.c | 205 ++++++++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_mbim.h |  24 ++++
 2 files changed, 229 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mbim.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mbim.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mbim.c b/drivers/net/wwan/iosm/iosm_ipc_mbim.c
new file mode 100644
index 000000000000..b263c77d6eb2
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_mbim.c
@@ -0,0 +1,205 @@
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
+#define IPC_READ_TIMEOUT 500
+
+/* MBIM IOCTL for max buffer size. */
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
+	if (test_and_set_bit(0, &ipc_mbim->mbim_is_open))
+		return -EBUSY;
+
+	ipc_mbim->channel_id = imem_sys_mbim_open(ipc_mbim->imem_instance);
+
+	if (ipc_mbim->channel_id < 0)
+		return -EIO;
+
+	return 0;
+}
+
+/* Close a shared memory control device and free the rx skbuf list. */
+static int ipc_mbim_fop_release(struct inode *inode, struct file *filp)
+{
+	struct iosm_sio *ipc_mbim =
+		container_of(filp->private_data, struct iosm_sio, misc);
+
+	if (ipc_mbim->channel_id < 0)
+		return -EINVAL;
+
+	imem_sys_sio_close(ipc_mbim);
+
+	clear_bit(0, &ipc_mbim->mbim_is_open);
+	return 0;
+}
+
+/* Copy the data from skbuff to the user buffer */
+static ssize_t ipc_mbim_fop_read(struct file *filp, char __user *buf,
+				 size_t size, loff_t *l)
+{
+	struct sk_buff *skb = NULL;
+	struct iosm_sio *ipc_mbim;
+	bool is_blocking;
+
+	if (!access_ok(buf, size))
+		return -EINVAL;
+
+	ipc_mbim = container_of(filp->private_data, struct iosm_sio, misc);
+
+	is_blocking = !(filp->f_flags & O_NONBLOCK);
+
+	/* First provide the pending skbuf to the user. */
+	if (ipc_mbim->rx_pending_buf) {
+		skb = ipc_mbim->rx_pending_buf;
+		ipc_mbim->rx_pending_buf = NULL;
+	}
+
+	/* Check rx queue until skb is available */
+	while (!skb) {
+		skb = skb_dequeue(&ipc_mbim->rx_list);
+		if (skb)
+			break;
+
+		if (!is_blocking)
+			return -EAGAIN;
+
+		/* Suspend the user app and wait a certain time for data
+		 * from CP.
+		 */
+		if (WAIT_FOR_TIMEOUT(&ipc_mbim->read_sem, IPC_READ_TIMEOUT) < 0)
+			return -ETIMEDOUT;
+	}
+
+	return imem_sys_sio_read(ipc_mbim, buf, size, skb);
+}
+
+/* Route the user data to the shared memory layer. */
+static ssize_t ipc_mbim_fop_write(struct file *filp, const char __user *buf,
+				  size_t size, loff_t *l)
+{
+	struct iosm_sio *ipc_mbim;
+	bool is_blocking;
+
+	if (!access_ok(buf, size))
+		return -EINVAL;
+
+	ipc_mbim = container_of(filp->private_data, struct iosm_sio, misc);
+
+	is_blocking = !(filp->f_flags & O_NONBLOCK);
+
+	if (ipc_mbim->channel_id < 0)
+		return -EPERM;
+
+	return imem_sys_sio_write(ipc_mbim, buf, size, is_blocking);
+}
+
+/* Poll mechanism for applications that use nonblocking IO */
+static __poll_t ipc_mbim_fop_poll(struct file *filp, poll_table *wait)
+{
+	struct iosm_sio *ipc_mbim =
+		container_of(filp->private_data, struct iosm_sio, misc);
+	__poll_t mask = EPOLLOUT | EPOLLWRNORM; /* writable */
+
+	/* Just registers wait_queue hook. This doesn't really wait. */
+	poll_wait(filp, &ipc_mbim->poll_inq, wait);
+
+	/* Test the fill level of the skbuf rx queue. */
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
+	ipc_mbim->imem_instance = ipc_imem;
+
+	ipc_mbim->wmaxcommand = WDM_MAX_SIZE;
+	ipc_mbim->channel_id = -1;
+	ipc_mbim->mbim_is_open = 0;
+
+	init_completion(&ipc_mbim->read_sem);
+
+	skb_queue_head_init(&ipc_mbim->rx_list);
+	init_waitqueue_head(&ipc_mbim->poll_inq);
+	init_waitqueue_head(&ipc_mbim->poll_outq);
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
+	/* Wakeup the user app. */
+	complete(&ipc_mbim->read_sem);
+
+	ipc_pcie_kfree_skb(ipc_mbim->pcie, ipc_mbim->rx_pending_buf);
+	ipc_mbim->rx_pending_buf = NULL;
+
+	skb_queue_purge(&ipc_mbim->rx_list);
+	kfree(ipc_mbim);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_mbim.h b/drivers/net/wwan/iosm/iosm_ipc_mbim.h
new file mode 100644
index 000000000000..4d87c52903ed
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_mbim.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_MBIM_H
+#define IOSM_IPC_MBIM_H
+
+/**
+ * ipc_mbim_init - Initialize and create a character device
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

