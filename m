Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4422B5492
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbgKPWqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:46:54 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:55904 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730751AbgKPWqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:46:51 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605566810; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=2N+XQFpZlcCFLvWd5ACnTJy4Yv6TcyDjCqcBKL0t8AA=; b=pcMJ1w2zRTsvuhHVAuOHx4jYfbfw2Tn/Ue6BQ0S2dsq32grfczb8Z8X1Fauuwwj/b8TMp5RS
 PnohTpMYGg0d0vymWeETle0a1aJa04slG3DjJBQZGK2VS0EuIH6B8OJaumxAnmgPnVuxyF9R
 ddJhx+UrDTG1NG1c8Ale37ohDQ0=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5fb3014b135ce186e945b7c6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 16 Nov 2020 22:46:34
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2EC16C433ED; Mon, 16 Nov 2020 22:46:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5277CC43462;
        Mon, 16 Nov 2020 22:46:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5277CC43462
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
From:   Hemant Kumar <hemantk@codeaurora.org>
To:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        skhan@linuxfoundation.org, Hemant Kumar <hemantk@codeaurora.org>
Subject: [PATCH v12 4/5] bus: mhi: Add userspace client interface driver
Date:   Mon, 16 Nov 2020 14:46:21 -0800
Message-Id: <1605566782-38013-5-git-send-email-hemantk@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605566782-38013-1-git-send-email-hemantk@codeaurora.org>
References: <1605566782-38013-1-git-send-email-hemantk@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This MHI client driver allows userspace clients to transfer
raw data between MHI device and host using standard file operations.
Driver instantiates UCI device object which is associated to device
file node. UCI device object instantiates UCI channel object when device
file node is opened. UCI channel object is used to manage MHI channels
by calling MHI core APIs for read and write operations. MHI channels
are started as part of device open(). MHI channels remain in start
state until last release() is called on UCI device file node. Device
file node is created with format

/dev/mhi_<controller_name>_<mhi_device_name>

Currently it supports LOOPBACK channel.

Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
---
 drivers/bus/mhi/Kconfig  |  13 +
 drivers/bus/mhi/Makefile |   3 +
 drivers/bus/mhi/uci.c    | 667 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 683 insertions(+)
 create mode 100644 drivers/bus/mhi/uci.c

diff --git a/drivers/bus/mhi/Kconfig b/drivers/bus/mhi/Kconfig
index da5cd0c..5194e8e 100644
--- a/drivers/bus/mhi/Kconfig
+++ b/drivers/bus/mhi/Kconfig
@@ -29,3 +29,16 @@ config MHI_BUS_PCI_GENERIC
 	  This driver provides MHI PCI controller driver for devices such as
 	  Qualcomm SDX55 based PCIe modems.
 
+config MHI_UCI
+	tristate "MHI UCI"
+	depends on MHI_BUS
+	help
+	  MHI based Userspace Client Interface (UCI) driver is used for
+	  transferring raw data between host and device using standard file
+	  operations from userspace. Open, read, write, poll and close
+	  operations are supported by this driver. Please check
+	  mhi_uci_match_table for all supported channels that are exposed to
+	  userspace.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called mhi_uci.
diff --git a/drivers/bus/mhi/Makefile b/drivers/bus/mhi/Makefile
index 0a2d778..69f2111 100644
--- a/drivers/bus/mhi/Makefile
+++ b/drivers/bus/mhi/Makefile
@@ -4,3 +4,6 @@ obj-y += core/
 obj-$(CONFIG_MHI_BUS_PCI_GENERIC) += mhi_pci_generic.o
 mhi_pci_generic-y += pci_generic.o
 
+# MHI client
+mhi_uci-y := uci.o
+obj-$(CONFIG_MHI_UCI) += mhi_uci.o
diff --git a/drivers/bus/mhi/uci.c b/drivers/bus/mhi/uci.c
new file mode 100644
index 0000000..75b0831
--- /dev/null
+++ b/drivers/bus/mhi/uci.c
@@ -0,0 +1,667 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2018-2020, The Linux Foundation. All rights reserved.*/
+
+#include <linux/kernel.h>
+#include <linux/mhi.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+
+#define MHI_DEVICE_NAME "mhi"
+#define MHI_UCI_DRIVER_NAME "mhi_uci"
+#define MHI_MAX_UCI_MINORS 128
+
+static DEFINE_IDR(uci_idr);
+static DEFINE_MUTEX(uci_drv_mutex);
+static struct class *uci_dev_class;
+static int uci_dev_major;
+
+/**
+ * struct uci_chan - MHI channel for a UCI device
+ * @udev: associated UCI device object
+ * @ul_wq: wait queue for writer
+ * @write_lock: mutex write lock for ul channel
+ * @dl_wq: wait queue for reader
+ * @read_lock: mutex read lock for dl channel
+ * @dl_pending_lock: spin lock for dl_pending list
+ * @dl_pending: list of dl buffers userspace is waiting to read
+ * @cur_buf: current buffer userspace is reading
+ * @dl_size: size of the current dl buffer userspace is reading
+ * @ref_count: uci_chan reference count
+ */
+struct uci_chan {
+	struct uci_dev *udev;
+	wait_queue_head_t ul_wq;
+
+	/* ul channel lock to synchronize multiple writes */
+	struct mutex write_lock;
+
+	wait_queue_head_t dl_wq;
+
+	/* dl channel lock to synchronize multiple reads */
+	struct mutex read_lock;
+
+	/*
+	 * protects pending list in bh context, channel release, read and
+	 * poll
+	 */
+	spinlock_t dl_pending_lock;
+
+	struct list_head dl_pending;
+	struct uci_buf *cur_buf;
+	size_t dl_size;
+	struct kref ref_count;
+};
+
+/**
+ * struct uci_buf - UCI buffer
+ * @data: data buffer
+ * @len: length of data buffer
+ * @node: list node of the UCI buffer
+ */
+struct uci_buf {
+	void *data;
+	size_t len;
+	struct list_head node;
+};
+
+/**
+ * struct uci_dev - MHI UCI device
+ * @minor: UCI device node minor number
+ * @mhi_dev: associated mhi device object
+ * @uchan: UCI uplink and downlink channel object
+ * @mtu: max TRE buffer length
+ * @enabled: Flag to track the state of the UCI device
+ * @lock: mutex lock to manage uchan object
+ * @ref_count: uci_dev reference count
+ */
+struct uci_dev {
+	unsigned int minor;
+	struct mhi_device *mhi_dev;
+	struct uci_chan *uchan;
+	size_t mtu;
+	bool enabled;
+
+	/* synchronize open, release and driver remove */
+	struct mutex lock;
+	struct kref ref_count;
+};
+
+static void mhi_uci_dev_chan_release(struct kref *ref)
+{
+	struct uci_buf *buf_itr, *tmp;
+	struct uci_chan *uchan =
+		container_of(ref, struct uci_chan, ref_count);
+
+	if (uchan->udev->enabled)
+		mhi_unprepare_from_transfer(uchan->udev->mhi_dev);
+
+	spin_lock_bh(&uchan->dl_pending_lock);
+	list_for_each_entry_safe(buf_itr, tmp, &uchan->dl_pending, node) {
+		list_del(&buf_itr->node);
+		kfree(buf_itr->data);
+	}
+	spin_unlock_bh(&uchan->dl_pending_lock);
+
+	wake_up(&uchan->ul_wq);
+	wake_up(&uchan->dl_wq);
+
+	mutex_lock(&uchan->read_lock);
+	if (uchan->cur_buf)
+		kfree(uchan->cur_buf->data);
+
+	uchan->cur_buf = NULL;
+	mutex_unlock(&uchan->read_lock);
+
+	mutex_destroy(&uchan->write_lock);
+	mutex_destroy(&uchan->read_lock);
+
+	uchan->udev->uchan = NULL;
+	kfree(uchan);
+}
+
+static int mhi_queue_inbound(struct uci_dev *udev)
+{
+	struct mhi_device *mhi_dev = udev->mhi_dev;
+	struct device *dev = &mhi_dev->dev;
+	int nr_desc, i, ret = -EIO;
+	size_t dl_buf_size;
+	void *buf;
+	struct uci_buf *ubuf;
+
+	/*
+	 * skip queuing without error if dl channel is not supported. This
+	 * allows open to succeed for udev, supporting ul only channel.
+	 */
+	if (!udev->mhi_dev->dl_chan)
+		return 0;
+
+	nr_desc = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
+
+	for (i = 0; i < nr_desc; i++) {
+		buf = kmalloc(udev->mtu, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
+		dl_buf_size = udev->mtu - sizeof(*ubuf);
+
+		/* save uci_buf info at the end of buf */
+		ubuf = buf + dl_buf_size;
+		ubuf->data = buf;
+
+		dev_dbg(dev, "Allocated buf %d of %d size %zu\n", i, nr_desc,
+			dl_buf_size);
+
+		ret = mhi_queue_buf(mhi_dev, DMA_FROM_DEVICE, buf, dl_buf_size,
+				    MHI_EOT);
+		if (ret) {
+			kfree(buf);
+			dev_err(dev, "Failed to queue buffer %d\n", i);
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+static int mhi_uci_dev_start_chan(struct uci_dev *udev)
+{
+	int ret = 0;
+	struct uci_chan *uchan;
+
+	mutex_lock(&udev->lock);
+	if (!udev->uchan || !kref_get_unless_zero(&udev->uchan->ref_count)) {
+		uchan = kzalloc(sizeof(*uchan), GFP_KERNEL);
+		if (!uchan) {
+			ret = -ENOMEM;
+			goto error_chan_start;
+		}
+
+		udev->uchan = uchan;
+		uchan->udev = udev;
+		init_waitqueue_head(&uchan->ul_wq);
+		init_waitqueue_head(&uchan->dl_wq);
+		mutex_init(&uchan->write_lock);
+		mutex_init(&uchan->read_lock);
+		spin_lock_init(&uchan->dl_pending_lock);
+		INIT_LIST_HEAD(&uchan->dl_pending);
+
+		ret = mhi_prepare_for_transfer(udev->mhi_dev);
+		if (ret) {
+			dev_err(&udev->mhi_dev->dev, "Error starting transfer channels\n");
+			goto error_chan_cleanup;
+		}
+
+		ret = mhi_queue_inbound(udev);
+		if (ret)
+			goto error_chan_cleanup;
+
+		kref_init(&uchan->ref_count);
+	}
+
+	mutex_unlock(&udev->lock);
+
+	return 0;
+
+error_chan_cleanup:
+	mhi_uci_dev_chan_release(&uchan->ref_count);
+error_chan_start:
+	mutex_unlock(&udev->lock);
+	return ret;
+}
+
+static void mhi_uci_dev_release(struct kref *ref)
+{
+	struct uci_dev *udev =
+		container_of(ref, struct uci_dev, ref_count);
+
+	mutex_destroy(&udev->lock);
+
+	kfree(udev);
+}
+
+static int mhi_uci_open(struct inode *inode, struct file *filp)
+{
+	unsigned int minor = iminor(inode);
+	struct uci_dev *udev = NULL;
+	int ret;
+
+	mutex_lock(&uci_drv_mutex);
+	udev = idr_find(&uci_idr, minor);
+	if (!udev) {
+		pr_debug("uci dev: minor %d not found\n", minor);
+		mutex_unlock(&uci_drv_mutex);
+		return -ENODEV;
+	}
+
+	kref_get(&udev->ref_count);
+	mutex_unlock(&uci_drv_mutex);
+
+	ret = mhi_uci_dev_start_chan(udev);
+	if (ret) {
+		kref_put(&udev->ref_count, mhi_uci_dev_release);
+		return ret;
+	}
+
+	filp->private_data = udev;
+
+	return 0;
+}
+
+static int mhi_uci_release(struct inode *inode, struct file *file)
+{
+	struct uci_dev *udev = file->private_data;
+
+	mutex_lock(&udev->lock);
+	kref_put(&udev->uchan->ref_count, mhi_uci_dev_chan_release);
+	mutex_unlock(&udev->lock);
+
+	kref_put(&udev->ref_count, mhi_uci_dev_release);
+
+	return 0;
+}
+
+static __poll_t mhi_uci_poll(struct file *file, poll_table *wait)
+{
+	struct uci_dev *udev = file->private_data;
+	struct mhi_device *mhi_dev = udev->mhi_dev;
+	struct device *dev = &mhi_dev->dev;
+	struct uci_chan *uchan = udev->uchan;
+	__poll_t mask = 0;
+
+	poll_wait(file, &udev->uchan->ul_wq, wait);
+	poll_wait(file, &udev->uchan->dl_wq, wait);
+
+	if (!udev->enabled) {
+		mask = EPOLLERR;
+		goto done;
+	}
+
+	spin_lock_bh(&uchan->dl_pending_lock);
+	if (!list_empty(&uchan->dl_pending) || uchan->cur_buf)
+		mask |= EPOLLIN | EPOLLRDNORM;
+	spin_unlock_bh(&uchan->dl_pending_lock);
+
+	if (mhi_get_free_desc_count(mhi_dev, DMA_TO_DEVICE) > 0)
+		mask |= EPOLLOUT | EPOLLWRNORM;
+
+	dev_dbg(dev, "Client attempted to poll, returning mask 0x%x\n", mask);
+
+done:
+	return mask;
+}
+
+static ssize_t mhi_uci_write(struct file *file,
+			     const char __user *buf,
+			     size_t count,
+			     loff_t *offp)
+{
+	struct uci_dev *udev = file->private_data;
+	struct mhi_device *mhi_dev = udev->mhi_dev;
+	struct device *dev = &mhi_dev->dev;
+	struct uci_chan *uchan = udev->uchan;
+	size_t bytes_xfered = 0;
+	int ret, nr_desc = 0;
+
+	/* if ul channel is not supported return error */
+	if (!mhi_dev->ul_chan)
+		return -EOPNOTSUPP;
+
+	if (!buf || !count)
+		return -EINVAL;
+
+	dev_dbg(dev, "%s: to xfer: %zu bytes\n", __func__, count);
+
+	if (mutex_lock_interruptible(&uchan->write_lock))
+		return -EINTR;
+
+	while (count) {
+		size_t xfer_size;
+		void *kbuf;
+		enum mhi_flags flags;
+
+		/* wait for free descriptors */
+		ret = wait_event_interruptible(uchan->ul_wq,
+					       (!udev->enabled) ||
+				(nr_desc = mhi_get_free_desc_count(mhi_dev,
+					       DMA_TO_DEVICE)) > 0);
+
+		if (ret == -ERESTARTSYS) {
+			dev_dbg(dev, "Interrupted by a signal in %s, exiting\n",
+				__func__);
+			goto err_mtx_unlock;
+		}
+
+		if (!udev->enabled) {
+			ret = -ENODEV;
+			goto err_mtx_unlock;
+		}
+
+		xfer_size = min_t(size_t, count, udev->mtu);
+		kbuf = kmalloc(xfer_size, GFP_KERNEL);
+		if (!kbuf) {
+			ret = -ENOMEM;
+			goto err_mtx_unlock;
+		}
+
+		ret = copy_from_user(kbuf, buf, xfer_size);
+		if (ret) {
+			kfree(kbuf);
+			ret = -EFAULT;
+			goto err_mtx_unlock;
+		}
+
+		/* if ring is full after this force EOT */
+		if (nr_desc > 1 && (count - xfer_size))
+			flags = MHI_CHAIN;
+		else
+			flags = MHI_EOT;
+
+		ret = mhi_queue_buf(mhi_dev, DMA_TO_DEVICE, kbuf, xfer_size,
+				    flags);
+		if (ret) {
+			kfree(kbuf);
+			goto err_mtx_unlock;
+		}
+
+		bytes_xfered += xfer_size;
+		count -= xfer_size;
+		buf += xfer_size;
+	}
+
+	mutex_unlock(&uchan->write_lock);
+	dev_dbg(dev, "%s: bytes xferred: %zu\n", __func__, bytes_xfered);
+
+	return bytes_xfered;
+
+err_mtx_unlock:
+	mutex_unlock(&uchan->write_lock);
+
+	return ret;
+}
+
+static ssize_t mhi_uci_read(struct file *file,
+			    char __user *buf,
+			    size_t count,
+			    loff_t *ppos)
+{
+	struct uci_dev *udev = file->private_data;
+	struct mhi_device *mhi_dev = udev->mhi_dev;
+	struct uci_chan *uchan = udev->uchan;
+	struct device *dev = &mhi_dev->dev;
+	struct uci_buf *ubuf;
+	size_t rx_buf_size;
+	char *ptr;
+	size_t to_copy;
+	int ret = 0;
+
+	/* if dl channel is not supported return error */
+	if (!mhi_dev->dl_chan)
+		return -EOPNOTSUPP;
+
+	if (!buf)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&uchan->read_lock))
+		return -EINTR;
+
+	spin_lock_bh(&uchan->dl_pending_lock);
+	/* No data available to read, wait */
+	if (!uchan->cur_buf && list_empty(&uchan->dl_pending)) {
+		dev_dbg(dev, "No data available to read, waiting\n");
+
+		spin_unlock_bh(&uchan->dl_pending_lock);
+		ret = wait_event_interruptible(uchan->dl_wq,
+					       (!udev->enabled ||
+					      !list_empty(&uchan->dl_pending)));
+
+		if (ret == -ERESTARTSYS) {
+			dev_dbg(dev, "Interrupted by a signal in %s, exiting\n",
+				__func__);
+			goto err_mtx_unlock;
+		}
+
+		if (!udev->enabled) {
+			ret = -ENODEV;
+			goto err_mtx_unlock;
+		}
+		spin_lock_bh(&uchan->dl_pending_lock);
+	}
+
+	/* new read, get the next descriptor from the list */
+	if (!uchan->cur_buf) {
+		ubuf = list_first_entry_or_null(&uchan->dl_pending,
+						struct uci_buf, node);
+		if (!ubuf) {
+			ret = -EIO;
+			goto err_spin_unlock;
+		}
+
+		list_del(&ubuf->node);
+		uchan->cur_buf = ubuf;
+		uchan->dl_size = ubuf->len;
+		dev_dbg(dev, "Got pkt of size: %zu\n", uchan->dl_size);
+	}
+	spin_unlock_bh(&uchan->dl_pending_lock);
+
+	ubuf = uchan->cur_buf;
+
+	/* Copy the buffer to user space */
+	to_copy = min_t(size_t, count, uchan->dl_size);
+	ptr = ubuf->data + (ubuf->len - uchan->dl_size);
+
+	ret = copy_to_user(buf, ptr, to_copy);
+	if (ret) {
+		ret = -EFAULT;
+		goto err_mtx_unlock;
+	}
+
+	dev_dbg(dev, "Copied %zu of %zu bytes\n", to_copy, uchan->dl_size);
+	uchan->dl_size -= to_copy;
+
+	/* we finished with this buffer, queue it back to hardware */
+	if (!uchan->dl_size) {
+		uchan->cur_buf = NULL;
+
+		rx_buf_size = udev->mtu - sizeof(*ubuf);
+		ret = mhi_queue_buf(mhi_dev, DMA_FROM_DEVICE, ubuf->data,
+				    rx_buf_size, MHI_EOT);
+		if (ret) {
+			dev_err(dev, "Failed to recycle element: %d\n", ret);
+			kfree(ubuf->data);
+			goto err_mtx_unlock;
+		}
+	}
+	mutex_unlock(&uchan->read_lock);
+
+	dev_dbg(dev, "%s: Returning %zu bytes\n", __func__, to_copy);
+
+	return to_copy;
+
+err_spin_unlock:
+	spin_unlock_bh(&uchan->dl_pending_lock);
+err_mtx_unlock:
+	mutex_unlock(&uchan->read_lock);
+	return ret;
+}
+
+static const struct file_operations mhidev_fops = {
+	.owner = THIS_MODULE,
+	.open = mhi_uci_open,
+	.release = mhi_uci_release,
+	.read = mhi_uci_read,
+	.write = mhi_uci_write,
+	.poll = mhi_uci_poll,
+};
+
+static void mhi_ul_xfer_cb(struct mhi_device *mhi_dev,
+			   struct mhi_result *mhi_result)
+{
+	struct uci_dev *udev = dev_get_drvdata(&mhi_dev->dev);
+	struct uci_chan *uchan = udev->uchan;
+	struct device *dev = &mhi_dev->dev;
+
+	dev_dbg(dev, "%s: status: %d xfer_len: %zu\n", __func__,
+		mhi_result->transaction_status, mhi_result->bytes_xferd);
+
+	kfree(mhi_result->buf_addr);
+
+	if (!mhi_result->transaction_status)
+		wake_up(&uchan->ul_wq);
+}
+
+static void mhi_dl_xfer_cb(struct mhi_device *mhi_dev,
+			   struct mhi_result *mhi_result)
+{
+	struct uci_dev *udev = dev_get_drvdata(&mhi_dev->dev);
+	struct uci_chan *uchan = udev->uchan;
+	struct device *dev = &mhi_dev->dev;
+	struct uci_buf *ubuf;
+	size_t dl_buf_size = udev->mtu - sizeof(*ubuf);
+
+	dev_dbg(dev, "%s: status: %d receive_len: %zu\n", __func__,
+		mhi_result->transaction_status, mhi_result->bytes_xferd);
+
+	if (mhi_result->transaction_status &&
+	    mhi_result->transaction_status != -EOVERFLOW) {
+		kfree(mhi_result->buf_addr);
+		return;
+	}
+
+	ubuf = mhi_result->buf_addr + dl_buf_size;
+	ubuf->data = mhi_result->buf_addr;
+	ubuf->len = mhi_result->bytes_xferd;
+	spin_lock_bh(&uchan->dl_pending_lock);
+	list_add_tail(&ubuf->node, &uchan->dl_pending);
+	spin_unlock_bh(&uchan->dl_pending_lock);
+
+	wake_up(&uchan->dl_wq);
+}
+
+static int mhi_uci_probe(struct mhi_device *mhi_dev,
+			 const struct mhi_device_id *id)
+{
+	struct uci_dev *udev;
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct device *dev;
+	int index;
+
+	udev = kzalloc(sizeof(*udev), GFP_KERNEL);
+	if (!udev)
+		return -ENOMEM;
+
+	kref_init(&udev->ref_count);
+	mutex_init(&udev->lock);
+	udev->mhi_dev = mhi_dev;
+
+	mutex_lock(&uci_drv_mutex);
+	index = idr_alloc(&uci_idr, udev, 0, MHI_MAX_UCI_MINORS, GFP_KERNEL);
+	mutex_unlock(&uci_drv_mutex);
+	if (index < 0) {
+		kfree(udev);
+		return index;
+	}
+
+	udev->minor = index;
+
+	udev->mtu = min_t(size_t, id->driver_data, MHI_MAX_MTU);
+	dev_set_drvdata(&mhi_dev->dev, udev);
+	udev->enabled = true;
+
+	/* create device file node /dev/mhi_<cntrl_dev_name>_<mhi_dev_name> */
+	dev = device_create(uci_dev_class, &mhi_dev->dev,
+			    MKDEV(uci_dev_major, index), udev,
+			    MHI_DEVICE_NAME "_%s_%s",
+			    dev_name(mhi_cntrl->cntrl_dev), mhi_dev->name);
+	if (IS_ERR(dev)) {
+		mutex_lock(&uci_drv_mutex);
+		idr_remove(&uci_idr, udev->minor);
+		mutex_unlock(&uci_drv_mutex);
+		dev_set_drvdata(&mhi_dev->dev, NULL);
+		kfree(udev);
+		return PTR_ERR(dev);
+	}
+
+	dev_dbg(&mhi_dev->dev, "probed uci dev: %s\n", id->chan);
+
+	return 0;
+};
+
+static void mhi_uci_remove(struct mhi_device *mhi_dev)
+{
+	struct uci_dev *udev = dev_get_drvdata(&mhi_dev->dev);
+
+	/* disable the node */
+	mutex_lock(&udev->lock);
+	udev->enabled = false;
+
+	/* delete the node to prevent new opens */
+	device_destroy(uci_dev_class, MKDEV(uci_dev_major, udev->minor));
+
+	/* return error for any blocked read or write */
+	if (udev->uchan) {
+		wake_up(&udev->uchan->ul_wq);
+		wake_up(&udev->uchan->dl_wq);
+	}
+	mutex_unlock(&udev->lock);
+
+	mutex_lock(&uci_drv_mutex);
+	idr_remove(&uci_idr, udev->minor);
+	kref_put(&udev->ref_count, mhi_uci_dev_release);
+	mutex_unlock(&uci_drv_mutex);
+}
+
+/* .driver_data stores max mtu */
+static const struct mhi_device_id mhi_uci_match_table[] = {
+	{ .chan = "LOOPBACK", .driver_data = 0x1000},
+	{},
+};
+MODULE_DEVICE_TABLE(mhi, mhi_uci_match_table);
+
+static struct mhi_driver mhi_uci_driver = {
+	.id_table = mhi_uci_match_table,
+	.remove = mhi_uci_remove,
+	.probe = mhi_uci_probe,
+	.ul_xfer_cb = mhi_ul_xfer_cb,
+	.dl_xfer_cb = mhi_dl_xfer_cb,
+	.driver = {
+		.name = MHI_UCI_DRIVER_NAME,
+	},
+};
+
+static int __init mhi_uci_init(void)
+{
+	int ret;
+
+	ret = register_chrdev(0, MHI_UCI_DRIVER_NAME, &mhidev_fops);
+	if (ret < 0)
+		return ret;
+
+	uci_dev_major = ret;
+	uci_dev_class = class_create(THIS_MODULE, MHI_UCI_DRIVER_NAME);
+	if (IS_ERR(uci_dev_class)) {
+		unregister_chrdev(uci_dev_major, MHI_UCI_DRIVER_NAME);
+		return PTR_ERR(uci_dev_class);
+	}
+
+	ret = mhi_driver_register(&mhi_uci_driver);
+	if (ret) {
+		class_destroy(uci_dev_class);
+		unregister_chrdev(uci_dev_major, MHI_UCI_DRIVER_NAME);
+	}
+
+	return ret;
+}
+
+static void __exit mhi_uci_exit(void)
+{
+	mhi_driver_unregister(&mhi_uci_driver);
+	class_destroy(uci_dev_class);
+	unregister_chrdev(uci_dev_major, MHI_UCI_DRIVER_NAME);
+	idr_destroy(&uci_idr);
+}
+
+module_init(mhi_uci_init);
+module_exit(mhi_uci_exit);
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("MHI UCI Driver");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

