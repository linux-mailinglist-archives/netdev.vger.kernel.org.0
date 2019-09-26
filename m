Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD474BED82
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbfIZIf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:35:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59498 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727178AbfIZIf1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 04:35:27 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4B64C19D335
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 08:35:27 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id x25so1664940qtq.2
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 01:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q8/GcQR5ni68P/nfPOzl/IY40Wa2hMRW33NF9DmZFkU=;
        b=p1aYiIpxG21QYzH4IxlW/edyiFmoIdlxdjFB52CnREndLqaotGrp1FLtpwsmvW/yMv
         L+3KOD6FmTL/RcFxYydfqfJIi3emlrAy+vcVifv+xOe81xZjz6sZLt6yQ5RUjnrvGeXz
         9ZU7MJZMkLTScbp/HjxjDJ7Mwx6jqba5zho9DSt54kLKW8avUgr8hGOiC1WD5LyzJ81D
         d9jmbUntvqIabVypAclMCrQ76jyvmJIfJsl9WPie4M/hfI7KuKX/SBzo7WayoHYH/PjR
         wjxKItpLGmSaa84RfqIn4qUnmI6wuMeuFhJ3IfuDw5g9gqpLq0vuylUibjhB65u1Zg+K
         pNeQ==
X-Gm-Message-State: APjAAAUqlsTFfw8vdi0OFQth7jaMURJnjuiDSXah6HTZATiABKouxAdN
        qSD9YoZxG1VN5NEEcNm/+a2F4hud4Rth+qObCvaasVlvS0p779El/OBJ69WXW8vbuX/25d5r/vO
        nhAIcOHi0yPWDen02
X-Received: by 2002:ac8:e8d:: with SMTP id v13mr2540528qti.96.1569486926508;
        Thu, 26 Sep 2019 01:35:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw4sLJYbiq3BD4u4tZxQGZMP3TBfMXfSwYJbBr31HNrjhr3+HDckGOLnXErJgFXopV5nklRug==
X-Received: by 2002:ac8:e8d:: with SMTP id v13mr2540506qti.96.1569486926229;
        Thu, 26 Sep 2019 01:35:26 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id c26sm834048qtk.93.2019.09.26.01.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 01:35:25 -0700 (PDT)
Date:   Thu, 26 Sep 2019 04:35:18 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
Message-ID: <20190926042156-mutt-send-email-mst@kernel.org>
References: <20190926045427.4973-1-tiwei.bie@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926045427.4973-1-tiwei.bie@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 12:54:27PM +0800, Tiwei Bie wrote:
> This patch introduces a mdev based hardware vhost backend.
> This backend is built on top of the same abstraction used
> in virtio-mdev and provides a generic vhost interface for
> userspace to accelerate the virtio devices in guest.
> 
> This backend is implemented as a mdev device driver on top
> of the same mdev device ops used in virtio-mdev but using
> a different mdev class id, and it will register the device
> as a VFIO device for userspace to use. Userspace can setup
> the IOMMU with the existing VFIO container/group APIs and
> then get the device fd with the device name. After getting
> the device fd of this device, userspace can use vhost ioctls
> to setup the backend.
> 
> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> ---
> This patch depends on below series:
> https://lkml.org/lkml/2019/9/24/357
> 
> RFC v4 -> v1:
> - Implement vhost-mdev as a mdev device driver directly and
>   connect it to VFIO container/group. (Jason);
> - Pass ring addresses as GPAs/IOVAs in vhost-mdev to avoid
>   meaningless HVA->GPA translations (Jason);
> 
> RFC v3 -> RFC v4:
> - Build vhost-mdev on top of the same abstraction used by
>   virtio-mdev (Jason);
> - Introduce vhost fd and pass VFIO fd via SET_BACKEND ioctl (MST);
> 
> RFC v2 -> RFC v3:
> - Reuse vhost's ioctls instead of inventing a VFIO regions/irqs
>   based vhost protocol on top of vfio-mdev (Jason);
> 
> RFC v1 -> RFC v2:
> - Introduce a new VFIO device type to build a vhost protocol
>   on top of vfio-mdev;
> 
>  drivers/vhost/Kconfig      |   9 +
>  drivers/vhost/Makefile     |   3 +
>  drivers/vhost/mdev.c       | 381 +++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vhost.h |   8 +
>  4 files changed, 401 insertions(+)
>  create mode 100644 drivers/vhost/mdev.c
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 3d03ccbd1adc..decf0be8efe9 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -34,6 +34,15 @@ config VHOST_VSOCK
>  	To compile this driver as a module, choose M here: the module will be called
>  	vhost_vsock.
>  
> +config VHOST_MDEV
> +	tristate "Vhost driver for Mediated devices"
> +	depends on EVENTFD && VFIO && VFIO_MDEV
> +	select VHOST
> +	default n
> +	---help---
> +	Say M here to enable the vhost_mdev module for use with
> +	the mediated device based hardware vhost accelerators
> +
>  config VHOST
>  	tristate
>  	---help---
> diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> index 6c6df24f770c..ad9c0f8c6d8c 100644
> --- a/drivers/vhost/Makefile
> +++ b/drivers/vhost/Makefile
> @@ -10,4 +10,7 @@ vhost_vsock-y := vsock.o
>  
>  obj-$(CONFIG_VHOST_RING) += vringh.o
>  
> +obj-$(CONFIG_VHOST_MDEV) += vhost_mdev.o
> +vhost_mdev-y := mdev.o
> +
>  obj-$(CONFIG_VHOST)	+= vhost.o
> diff --git a/drivers/vhost/mdev.c b/drivers/vhost/mdev.c
> new file mode 100644
> index 000000000000..1c12a25b86a2
> --- /dev/null
> +++ b/drivers/vhost/mdev.c
> @@ -0,0 +1,381 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2018-2019 Intel Corporation.
> + */
> +
> +#include <linux/compat.h>
> +#include <linux/kernel.h>
> +#include <linux/miscdevice.h>
> +#include <linux/mdev.h>
> +#include <linux/module.h>
> +#include <linux/vfio.h>
> +#include <linux/vhost.h>
> +#include <linux/virtio_mdev.h>
> +
> +#include "vhost.h"
> +
> +struct vhost_mdev {
> +	/* The lock is to protect this structure. */
> +	struct mutex mutex;
> +	struct vhost_dev dev;
> +	struct vhost_virtqueue *vqs;
> +	int nvqs;
> +	u64 state;
> +	u64 features;
> +	u64 acked_features;
> +	bool opened;
> +	struct mdev_device *mdev;
> +};
> +
> +static u8 mdev_get_status(struct mdev_device *mdev)
> +{
> +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
> +
> +	return ops->get_status(mdev);
> +}
> +
> +static void mdev_set_status(struct mdev_device *mdev, u8 status)
> +{
> +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
> +
> +	return ops->set_status(mdev, status);
> +}
> +
> +static void mdev_add_status(struct mdev_device *mdev, u8 status)
> +{
> +	status |= mdev_get_status(mdev);
> +	mdev_set_status(mdev, status);
> +}
> +
> +static void mdev_reset(struct mdev_device *mdev)
> +{
> +	mdev_set_status(mdev, 0);
> +}
> +
> +static void handle_vq_kick(struct vhost_work *work)
> +{
> +	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
> +						  poll.work);
> +	struct vhost_mdev *m = container_of(vq->dev, struct vhost_mdev, dev);
> +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(m->mdev);
> +
> +	ops->kick_vq(m->mdev, vq - m->vqs);
> +}
> +
> +static irqreturn_t vhost_mdev_virtqueue_cb(void *private)
> +{
> +	struct vhost_virtqueue *vq = private;
> +	struct eventfd_ctx *call_ctx = vq->call_ctx;
> +
> +	if (call_ctx)
> +		eventfd_signal(call_ctx, 1);
> +	return IRQ_HANDLED;
> +}
> +
> +static long vhost_mdev_reset(struct vhost_mdev *m)
> +{
> +	struct mdev_device *mdev = m->mdev;
> +
> +	mdev_reset(mdev);
> +	mdev_add_status(mdev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> +	mdev_add_status(mdev, VIRTIO_CONFIG_S_DRIVER);
> +	return 0;
> +}
> +
> +static long vhost_mdev_start(struct vhost_mdev *m)
> +{
> +	struct mdev_device *mdev = m->mdev;
> +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
> +	struct virtio_mdev_callback cb;
> +	struct vhost_virtqueue *vq;
> +	int idx;
> +
> +	ops->set_features(mdev, m->acked_features);
> +
> +	mdev_add_status(mdev, VIRTIO_CONFIG_S_FEATURES_OK);
> +	if (!(mdev_get_status(mdev) & VIRTIO_CONFIG_S_FEATURES_OK))
> +		goto reset;
> +
> +	for (idx = 0; idx < m->nvqs; idx++) {
> +		vq = &m->vqs[idx];
> +
> +		if (!vq->desc || !vq->avail || !vq->used)
> +			break;
> +
> +		if (ops->set_vq_state(mdev, idx, vq->last_avail_idx))
> +			goto reset;
> +
> +		/*
> +		 * In vhost-mdev, userspace should pass ring addresses
> +		 * in guest physical addresses when IOMMU is disabled or
> +		 * IOVAs when IOMMU is enabled.
> +		 */
> +		if (ops->set_vq_address(mdev, idx, (u64)vq->desc,
> +					(u64)vq->avail, (u64)vq->used))
> +			goto reset;
> +
> +		ops->set_vq_num(mdev, idx, vq->num);
> +
> +		cb.callback = vhost_mdev_virtqueue_cb;
> +		cb.private = vq;
> +		ops->set_vq_cb(mdev, idx, &cb);
> +
> +		ops->set_vq_ready(mdev, idx, 1);
> +	}
> +
> +	mdev_add_status(mdev, VIRTIO_CONFIG_S_DRIVER_OK);
> +	if (mdev_get_status(mdev) & VIRTIO_CONFIG_S_NEEDS_RESET)
> +		goto reset;
> +	return 0;
> +
> +reset:
> +	vhost_mdev_reset(m);
> +	return -ENODEV;
> +}
> +
> +static long vhost_set_state(struct vhost_mdev *m, u64 __user *statep)
> +{
> +	u64 state;
> +	long r;
> +
> +	if (copy_from_user(&state, statep, sizeof(state)))
> +		return -EFAULT;
> +
> +	if (state >= VHOST_MDEV_S_MAX)
> +		return -EINVAL;
> +
> +	if (m->state == state)
> +		return 0;
> +
> +	m->state = state;
> +
> +	switch (m->state) {
> +	case VHOST_MDEV_S_RUNNING:
> +		r = vhost_mdev_start(m);
> +		break;
> +	case VHOST_MDEV_S_STOPPED:
> +		r = vhost_mdev_reset(m);
> +		break;
> +	default:
> +		r = -EINVAL;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +static long vhost_get_features(struct vhost_mdev *m, u64 __user *featurep)
> +{
> +	if (copy_to_user(featurep, &m->features, sizeof(m->features)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static long vhost_set_features(struct vhost_mdev *m, u64 __user *featurep)
> +{
> +	u64 features;
> +
> +	if (copy_from_user(&features, featurep, sizeof(features)))
> +		return -EFAULT;
> +
> +	if (features & ~m->features)
> +		return -EINVAL;
> +
> +	m->acked_features = features;
> +
> +	return 0;
> +}
> +
> +static long vhost_get_vring_base(struct vhost_mdev *m, void __user *argp)
> +{
> +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(m->mdev);
> +	struct vhost_virtqueue *vq;
> +	u32 idx;
> +	long r;
> +
> +	r = get_user(idx, (u32 __user *)argp);
> +	if (r < 0)
> +		return r;
> +	if (idx >= m->nvqs)
> +		return -ENOBUFS;
> +
> +	vq = &m->vqs[idx];
> +	vq->last_avail_idx = ops->get_vq_state(m->mdev, idx);
> +
> +	return vhost_vring_ioctl(&m->dev, VHOST_GET_VRING_BASE, argp);
> +}
> +
> +static int vhost_mdev_open(void *device_data)
> +{
> +	struct vhost_mdev *m = device_data;
> +	struct vhost_dev *dev;
> +	struct vhost_virtqueue **vqs;
> +	int nvqs, i, r;
> +
> +	if (!try_module_get(THIS_MODULE))
> +		return -ENODEV;
> +
> +	mutex_lock(&m->mutex);
> +
> +	if (m->opened) {
> +		r = -EBUSY;
> +		goto err;
> +	}
> +
> +	nvqs = m->nvqs;
> +	vhost_mdev_reset(m);
> +
> +	memset(&m->dev, 0, sizeof(m->dev));
> +	memset(m->vqs, 0, nvqs * sizeof(struct vhost_virtqueue));
> +
> +	vqs = kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
> +	if (!vqs) {
> +		r = -ENOMEM;
> +		goto err;
> +	}
> +
> +	dev = &m->dev;
> +	for (i = 0; i < nvqs; i++) {
> +		vqs[i] = &m->vqs[i];
> +		vqs[i]->handle_kick = handle_vq_kick;
> +	}
> +	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0);
> +	m->opened = true;
> +	mutex_unlock(&m->mutex);
> +
> +	return 0;
> +
> +err:
> +	mutex_unlock(&m->mutex);
> +	module_put(THIS_MODULE);
> +	return r;
> +}
> +
> +static void vhost_mdev_release(void *device_data)
> +{
> +	struct vhost_mdev *m = device_data;
> +
> +	mutex_lock(&m->mutex);
> +	vhost_mdev_reset(m);
> +	vhost_dev_stop(&m->dev);
> +	vhost_dev_cleanup(&m->dev);
> +
> +	kfree(m->dev.vqs);
> +	m->opened = false;
> +	mutex_unlock(&m->mutex);
> +	module_put(THIS_MODULE);
> +}
> +
> +static long vhost_mdev_unlocked_ioctl(void *device_data,
> +				      unsigned int cmd, unsigned long arg)
> +{
> +	struct vhost_mdev *m = device_data;
> +	void __user *argp = (void __user *)arg;
> +	long r;
> +
> +	mutex_lock(&m->mutex);
> +
> +	switch (cmd) {
> +	case VHOST_MDEV_SET_STATE:
> +		r = vhost_set_state(m, argp);
> +		break;
> +	case VHOST_GET_FEATURES:
> +		r = vhost_get_features(m, argp);
> +		break;
> +	case VHOST_SET_FEATURES:
> +		r = vhost_set_features(m, argp);
> +		break;
> +	case VHOST_GET_VRING_BASE:
> +		r = vhost_get_vring_base(m, argp);
> +		break;
> +	default:
> +		r = vhost_dev_ioctl(&m->dev, cmd, argp);
> +		if (r == -ENOIOCTLCMD)
> +			r = vhost_vring_ioctl(&m->dev, cmd, argp);
> +	}
> +
> +	mutex_unlock(&m->mutex);
> +	return r;
> +}
> +
> +static const struct vfio_device_ops vfio_vhost_mdev_dev_ops = {
> +	.name		= "vfio-vhost-mdev",
> +	.open		= vhost_mdev_open,
> +	.release	= vhost_mdev_release,
> +	.ioctl		= vhost_mdev_unlocked_ioctl,
> +};
> +
> +static int vhost_mdev_probe(struct device *dev)
> +{
> +	struct mdev_device *mdev = mdev_from_dev(dev);
> +	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
> +	struct vhost_mdev *m;
> +	int nvqs, r;
> +
> +	m = kzalloc(sizeof(*m), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +	if (!m)
> +		return -ENOMEM;
> +
> +	mutex_init(&m->mutex);
> +
> +	nvqs = ops->get_queue_max(mdev);
> +	m->nvqs = nvqs;
> +
> +	m->vqs = kmalloc_array(nvqs, sizeof(struct vhost_virtqueue),
> +			       GFP_KERNEL);
> +	if (!m->vqs) {
> +		r = -ENOMEM;
> +		goto err;
> +	}
> +
> +	r = vfio_add_group_dev(dev, &vfio_vhost_mdev_dev_ops, m);
> +	if (r)
> +		goto err;
> +
> +	m->features = ops->get_features(mdev);
> +	m->mdev = mdev;
> +	return 0;
> +
> +err:
> +	kfree(m->vqs);
> +	kfree(m);
> +	return r;
> +}
> +
> +static void vhost_mdev_remove(struct device *dev)
> +{
> +	struct vhost_mdev *m;
> +
> +	m = vfio_del_group_dev(dev);
> +	mutex_destroy(&m->mutex);
> +	kfree(m->vqs);
> +	kfree(m);
> +}
> +
> +static struct mdev_class_id id_table[] = {
> +	{ MDEV_ID_VHOST },
> +	{ 0 },
> +};
> +
> +static struct mdev_driver vhost_mdev_driver = {
> +	.name	= "vhost_mdev",
> +	.probe	= vhost_mdev_probe,
> +	.remove	= vhost_mdev_remove,
> +	.id_table = id_table,
> +};
> +
> +static int __init vhost_mdev_init(void)
> +{
> +	return mdev_register_driver(&vhost_mdev_driver, THIS_MODULE);
> +}
> +module_init(vhost_mdev_init);
> +
> +static void __exit vhost_mdev_exit(void)
> +{
> +	mdev_unregister_driver(&vhost_mdev_driver);
> +}
> +module_exit(vhost_mdev_exit);
> +
> +MODULE_VERSION("0.0.1");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Mediated device based accelerator for virtio");
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 40d028eed645..5afbc2f08fa3 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -116,4 +116,12 @@
>  #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
>  #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
>  
> +/* VHOST_MDEV specific defines */
> +
> +#define VHOST_MDEV_SET_STATE	_IOW(VHOST_VIRTIO, 0x70, __u64)
> +
> +#define VHOST_MDEV_S_STOPPED	0
> +#define VHOST_MDEV_S_RUNNING	1
> +#define VHOST_MDEV_S_MAX	2
> +
>  #endif

So assuming we have an underlying device that behaves like virtio:

1. Should we use SET_STATUS maybe?
2. Do we want a reset ioctl?
3. Do we want ability to enable rings individually?
4. Does device need to limit max ring size?
5. Does device need to limit max number of queues?

-- 
MST
