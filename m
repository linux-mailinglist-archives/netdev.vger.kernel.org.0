Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB6A41C7FF
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345279AbhI2PNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:13:25 -0400
Received: from smtp2.axis.com ([195.60.68.18]:4224 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345093AbhI2PNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1632928286;
  x=1664464286;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nAUse+dxd5LuLHc4GeZK/htyf/VxSZ2m3arqdhXKFAg=;
  b=lbKn8o8ZG6K/N2DDnibRuDllTiZ1Phty9e6qwwM9S/ijbrWRN+rwVkYt
   QdfDNb3QGVFEr9jHFNOrUqScxZFEbXL+aegODzmh7rzNNZc8orrByejBv
   T0PK9W0q5S3qtKuo7HS4vyZIeaVJXxEeht0MSsTyzQoy+DcJzMS3ePNph
   fZ04BWKVZdaT/CkH6y2nGr/hGKBdOMH2R7VlFg/Glk9/4jXl8KJUy4L4j
   nPwJwquNdIyBeiaoR3CTUGSIVJr/yxcYItF1U7AJ6zSx383XxINMwlHLU
   Eg0keDEw4L8ash/PEnO+cdAYQYcLtBlhDQI93LU2l0daDscZNvEoJbAst
   Q==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kernel@axis.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [RFC PATCH 07/10] vhost: add support for kernel control
Date:   Wed, 29 Sep 2021 17:11:16 +0200
Message-ID: <20210929151119.14778-8-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210929151119.14778-1-vincent.whitchurch@axis.com>
References: <20210929151119.14778-1-vincent.whitchurch@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add functions to allow vhost buffers to be placed in kernel space and
for the vhost driver to be controlled from a kernel driver after initial
setup by userspace.

The kernel control is only possible on new /dev/vhost-*-kernel devices,
and on these devices userspace cannot write to the iotlb, nor can it
control the placement and attributes of the virtqueues, nor start/stop
the virtqueue handling after the kernel starts using it.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 drivers/vhost/common.c | 201 +++++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.c  |  92 +++++++++++++++++--
 drivers/vhost/vhost.h  |   3 +
 include/linux/vhost.h  |  23 +++++
 4 files changed, 310 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/vhost.h

diff --git a/drivers/vhost/common.c b/drivers/vhost/common.c
index a5722ad65e24..f9758920a33a 100644
--- a/drivers/vhost/common.c
+++ b/drivers/vhost/common.c
@@ -25,7 +25,9 @@
 struct vhost_ops;
 
 struct vhost {
+	char kernelname[128];
 	struct miscdevice misc;
+	struct miscdevice kernelmisc;
 	const struct vhost_ops *ops;
 };
 
@@ -46,6 +48,24 @@ static int vhost_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int vhost_kernel_open(struct inode *inode, struct file *file)
+{
+	struct miscdevice *misc = file->private_data;
+	struct vhost *vhost = container_of(misc, struct vhost, kernelmisc);
+	struct vhost_dev *dev;
+
+	dev = vhost->ops->open(vhost);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+
+	dev->vhost = vhost;
+	dev->file = file;
+	dev->kernel = true;
+	file->private_data = dev;
+
+	return 0;
+}
+
 static int vhost_release(struct inode *inode, struct file *file)
 {
 	struct vhost_dev *dev = file->private_data;
@@ -69,6 +89,46 @@ static long vhost_ioctl(struct file *file, unsigned int ioctl, unsigned long arg
 	return ret;
 }
 
+static long vhost_kernel_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
+{
+	struct vhost_dev *dev = file->private_data;
+	struct vhost *vhost = dev->vhost;
+	long ret;
+
+	/* Only the kernel is allowed to control virtqueue attributes */
+	switch (ioctl) {
+	case VHOST_SET_VRING_NUM:
+	case VHOST_SET_VRING_ADDR:
+	case VHOST_SET_VRING_BASE:
+	case VHOST_SET_VRING_ENDIAN:
+	case VHOST_SET_MEM_TABLE:
+	case VHOST_SET_LOG_BASE:
+	case VHOST_SET_LOG_FD:
+		return -EPERM;
+	}
+
+	mutex_lock(&dev->mutex);
+
+	/*
+	 * Userspace should perform all reqired setup on the vhost device
+	 * _before_ asking the kernel to start using it.
+	 *
+	 * Note that ->kernel_attached is never reset, if userspace wants to
+	 * attach again it should open the device again.
+	 */
+	if (dev->kernel_attached) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
+	ret = vhost->ops->ioctl(dev, ioctl, arg);
+
+out_unlock:
+	mutex_unlock(&dev->mutex);
+
+	return ret;
+}
+
 static ssize_t vhost_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
@@ -105,6 +165,129 @@ static const struct file_operations vhost_fops = {
 	.poll           = vhost_poll,
 };
 
+static const struct file_operations vhost_kernel_fops = {
+	.owner          = THIS_MODULE,
+	.open           = vhost_kernel_open,
+	.release        = vhost_release,
+	.llseek		= noop_llseek,
+	.unlocked_ioctl = vhost_kernel_ioctl,
+	.compat_ioctl   = compat_ptr_ioctl,
+};
+
+static void vhost_dev_lock_vqs(struct vhost_dev *d)
+{
+	int i;
+
+	for (i = 0; i < d->nvqs; ++i)
+		mutex_lock_nested(&d->vqs[i]->mutex, i);
+}
+
+static void vhost_dev_unlock_vqs(struct vhost_dev *d)
+{
+	int i;
+
+	for (i = 0; i < d->nvqs; ++i)
+		mutex_unlock(&d->vqs[i]->mutex);
+}
+
+struct vhost_dev *vhost_dev_get(int fd)
+{
+	struct file *file;
+	struct vhost_dev *dev;
+	struct vhost_dev *ret;
+	int err;
+	int i;
+
+	file = fget(fd);
+	if (!file)
+		return ERR_PTR(-EBADF);
+
+	if (file->f_op != &vhost_kernel_fops) {
+		ret = ERR_PTR(-EINVAL);
+		goto err_fput;
+	}
+
+	dev = file->private_data;
+
+	mutex_lock(&dev->mutex);
+	vhost_dev_lock_vqs(dev);
+
+	err = vhost_dev_check_owner(dev);
+	if (err) {
+		ret = ERR_PTR(err);
+		goto err_unlock;
+	}
+
+	if (dev->kernel_attached) {
+		ret = ERR_PTR(-EBUSY);
+		goto err_unlock;
+	}
+
+	if (!dev->iotlb) {
+		ret = ERR_PTR(-EINVAL);
+		goto err_unlock;
+	}
+
+	for (i = 0; i < dev->nvqs; i++) {
+		struct vhost_virtqueue *vq = dev->vqs[i];
+
+		if (vq->private_data) {
+			ret = ERR_PTR(-EBUSY);
+			goto err_unlock;
+		}
+	}
+
+	dev->kernel_attached = true;
+
+	vhost_dev_unlock_vqs(dev);
+	mutex_unlock(&dev->mutex);
+
+	return dev;
+
+err_unlock:
+	vhost_dev_unlock_vqs(dev);
+	mutex_unlock(&dev->mutex);
+err_fput:
+	fput(file);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vhost_dev_get);
+
+void vhost_dev_start_vq(struct vhost_dev *dev, u16 idx)
+{
+	struct vhost *vhost = dev->vhost;
+
+	mutex_lock(&dev->mutex);
+	vhost->ops->start_vq(dev, idx);
+	mutex_unlock(&dev->mutex);
+}
+EXPORT_SYMBOL_GPL(vhost_dev_start_vq);
+
+void vhost_dev_stop_vq(struct vhost_dev *dev, u16 idx)
+{
+	struct vhost *vhost = dev->vhost;
+
+	mutex_lock(&dev->mutex);
+	vhost->ops->stop_vq(dev, idx);
+	mutex_unlock(&dev->mutex);
+}
+EXPORT_SYMBOL_GPL(vhost_dev_stop_vq);
+
+void vhost_dev_put(struct vhost_dev *dev)
+{
+	/* The virtqueues should already be stopped. */
+	fput(dev->file);
+}
+EXPORT_SYMBOL_GPL(vhost_dev_put);
+
+static bool vhost_kernel_supported(const struct vhost_ops *ops)
+{
+	if (!IS_ENABLED(CONFIG_VHOST_KERNEL))
+		return false;
+
+	return ops->start_vq && ops->stop_vq;
+}
+
 struct vhost *vhost_register(const struct vhost_ops *ops)
 {
 	struct vhost *vhost;
@@ -125,12 +308,30 @@ struct vhost *vhost_register(const struct vhost_ops *ops)
 		return ERR_PTR(ret);
 	}
 
+	if (vhost_kernel_supported(ops)) {
+		snprintf(vhost->kernelname, sizeof(vhost->kernelname),
+			 "%s-kernel", ops->name);
+
+		vhost->kernelmisc.minor = MISC_DYNAMIC_MINOR;
+		vhost->kernelmisc.name = vhost->kernelname;
+		vhost->kernelmisc.fops = &vhost_kernel_fops;
+
+		ret = misc_register(&vhost->kernelmisc);
+		if (ret) {
+			misc_deregister(&vhost->misc);
+			kfree(vhost);
+			return ERR_PTR(ret);
+		}
+	}
+
 	return vhost;
 }
 EXPORT_SYMBOL_GPL(vhost_register);
 
 void vhost_unregister(struct vhost *vhost)
 {
+	if (vhost_kernel_supported(vhost->ops))
+		misc_deregister(&vhost->kernelmisc);
 	misc_deregister(&vhost->misc);
 	kfree(vhost);
 }
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9d6496b7ad85..56a69ecfd910 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -486,6 +486,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->mm = NULL;
 	dev->worker = NULL;
 	dev->kernel = false;
+	dev->kernel_attached = false;
 	dev->iov_limit = iov_limit;
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
@@ -1329,6 +1330,30 @@ static int vhost_process_iotlb_msg(struct vhost_dev *dev,
 
 	return ret;
 }
+
+int vhost_dev_iotlb_update(struct vhost_dev *dev, u64 iova, u64 size, u64 kaddr, unsigned int perm)
+{
+	int ret = 0;
+
+	mutex_lock(&dev->mutex);
+	vhost_dev_lock_vqs(dev);
+
+	if (!dev->iotlb) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (vhost_iotlb_add_range(dev->iotlb, iova, iova + size - 1, kaddr, perm))
+		ret = -ENOMEM;
+
+out_unlock:
+	vhost_dev_unlock_vqs(dev);
+	mutex_unlock(&dev->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vhost_dev_iotlb_update);
+
 ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 			     struct iov_iter *from)
 {
@@ -1677,27 +1702,35 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 	return -EFAULT;
 }
 
-static long vhost_vring_set_num(struct vhost_dev *d,
+static int __vhost_vring_set_num(struct vhost_dev *d,
 				struct vhost_virtqueue *vq,
-				void __user *argp)
+				unsigned int num)
 {
-	struct vhost_vring_state s;
-
 	/* Resizing ring with an active backend?
 	 * You don't want to do that. */
 	if (vq->private_data)
 		return -EBUSY;
 
-	if (copy_from_user(&s, argp, sizeof s))
-		return -EFAULT;
-
-	if (!s.num || s.num > 0xffff || (s.num & (s.num - 1)))
+	if (!num || num > 0xffff || (num & (num - 1)))
 		return -EINVAL;
-	vq->num = s.num;
+
+	vq->num = num;
 
 	return 0;
 }
 
+static long vhost_vring_set_num(struct vhost_dev *d,
+				struct vhost_virtqueue *vq,
+				void __user *argp)
+{
+	struct vhost_vring_state s;
+
+	if (copy_from_user(&s, argp, sizeof(s)))
+		return -EFAULT;
+
+	return __vhost_vring_set_num(d, vq, s.num);
+}
+
 static long vhost_vring_set_addr(struct vhost_dev *d,
 				 struct vhost_virtqueue *vq,
 				 void __user *argp)
@@ -1750,6 +1783,47 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
 	return 0;
 }
 
+int vhost_dev_set_vring_num(struct vhost_dev *dev, unsigned int idx, unsigned int num)
+{
+	struct vhost_virtqueue *vq;
+	int ret;
+
+	if (idx >= dev->nvqs)
+		return -ENOBUFS;
+
+	vq = dev->vqs[idx];
+
+	mutex_lock(&vq->mutex);
+	ret = __vhost_vring_set_num(dev, vq, num);
+	mutex_unlock(&vq->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vhost_dev_set_vring_num);
+
+int vhost_dev_set_num_addr(struct vhost_dev *dev, unsigned int idx, void *desc,
+			   void *avail, void *used)
+{
+	struct vhost_virtqueue *vq;
+	int ret = 0;
+
+	if (idx >= dev->nvqs)
+		return -ENOBUFS;
+
+	vq = dev->vqs[idx];
+
+	mutex_lock(&vq->mutex);
+	vq->kern.desc = desc;
+	vq->kern.avail = avail;
+	vq->kern.used = used;
+	vq->last_avail_idx = 0;
+	vq->avail_idx = vq->last_avail_idx;
+	mutex_unlock(&vq->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vhost_dev_set_num_addr);
+
 static long vhost_vring_set_num_addr(struct vhost_dev *d,
 				     struct vhost_virtqueue *vq,
 				     unsigned int ioctl,
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 408ff243ed31..6cd5d6b0d644 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -23,6 +23,8 @@ struct vhost_ops {
 	struct vhost_dev * (*open)(struct vhost *vhost);
 	long (*ioctl)(struct vhost_dev *dev, unsigned int ioctl, unsigned long arg);
 	void (*release)(struct vhost_dev *dev);
+	void (*start_vq)(struct vhost_dev *dev, u16 idx);
+	void (*stop_vq)(struct vhost_dev *dev, u16 idx);
 };
 
 struct vhost *vhost_register(const struct vhost_ops *ops);
@@ -191,6 +193,7 @@ struct vhost_dev {
 	u64 kcov_handle;
 	bool use_worker;
 	bool kernel;
+	bool kernel_attached;
 	int (*msg_handler)(struct vhost_dev *dev,
 			   struct vhost_iotlb_msg *msg);
 };
diff --git a/include/linux/vhost.h b/include/linux/vhost.h
new file mode 100644
index 000000000000..cdfe244c776b
--- /dev/null
+++ b/include/linux/vhost.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _INCLUDE_LINUX_VHOST_H
+#define _INCLUDE_LINUX_VHOST_H
+
+#include <uapi/linux/vhost.h>
+
+struct vhost_dev;
+
+struct vhost_dev *vhost_dev_get(int fd);
+void vhost_dev_put(struct vhost_dev *dev);
+
+int vhost_dev_set_vring_num(struct vhost_dev *dev, unsigned int idx,
+			    unsigned int num);
+int vhost_dev_set_num_addr(struct vhost_dev *dev, unsigned int idx, void *desc,
+			   void *avail, void *used);
+
+void vhost_dev_start_vq(struct vhost_dev *dev, u16 idx);
+void vhost_dev_stop_vq(struct vhost_dev *dev, u16 idx);
+
+int vhost_dev_iotlb_update(struct vhost_dev *dev, u64 iova, u64 size,
+			   u64 kaddr, unsigned int perm);
+
+#endif
-- 
2.28.0

