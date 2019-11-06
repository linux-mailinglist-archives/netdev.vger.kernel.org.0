Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C727AF166E
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 13:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfKFM7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 07:59:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46916 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbfKFM7K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 07:59:10 -0500
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 67AF88665A
        for <netdev@vger.kernel.org>; Wed,  6 Nov 2019 12:59:10 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id 6so9463497qkc.4
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 04:59:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GnlkvgIKriOh4NHkn9TYP1AKjjF4cbq9NeAqGFKfq1c=;
        b=htBw2GFkOZCjd0R7XO3h5jXyMM/bp3A/Am0zGUx/Fh//3LWBwsydpEvRvc6ACnxoJx
         0kMNS/aVhUd6M4qN5KpNyG/uC8r62+qwn3J742vuzqIk+OGTJy7Fa/J61mRvqV1piUix
         YPONHzV71Q/G0jmB/IcJcFV5ceghEdgrORl6SKs0BSTgCY2gwAU6Sd8KOBCIWB34M+6g
         1zMJGu9Wkkr+yG3Nv9UwTinJf01cZ9x7f9QFk3l6mdeMybQRnu5aQ+tWsqftS4m3kWlf
         WVmTvLcOpZDS6+x6I1ad9CeUAktuLZA8Zj1NjFgJOimm91U60yaZoRHb5hCm2xc8hHN3
         e0Pw==
X-Gm-Message-State: APjAAAX1e7S8fZE1hdvit/o0ZBaqdz0vsUGgbrvwKeShwu4zwoDk5oGA
        eFYrPN92XMpRFM/wtPaFujDR4hASyROPQEj96Y5YVuJMLF3Vvm+w+8HNb/sdYfAtNTCjdkKttKm
        q3YZpa4Cnv5eAMrPT
X-Received: by 2002:ad4:4894:: with SMTP id bv20mr2006247qvb.132.1573045149343;
        Wed, 06 Nov 2019 04:59:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqyWw11X3eJi5WXKPTj+3bxx0BOpXrow8Po51TqbhUDeL3Qg0qSon1ZSpgY0l6xGMDruO6Tf1g==
X-Received: by 2002:ad4:4894:: with SMTP id bv20mr2006215qvb.132.1573045148811;
        Wed, 06 Nov 2019 04:59:08 -0800 (PST)
Received: from redhat.com (bzq-79-178-12-128.red.bezeqint.net. [79.178.12.128])
        by smtp.gmail.com with ESMTPSA id t16sm3063901qkm.73.2019.11.06.04.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 04:59:08 -0800 (PST)
Date:   Wed, 6 Nov 2019 07:59:02 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH v5] vhost: introduce mdev based hardware backend
Message-ID: <20191106075733-mutt-send-email-mst@kernel.org>
References: <20191105115332.11026-1-tiwei.bie@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105115332.11026-1-tiwei.bie@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 07:53:32PM +0800, Tiwei Bie wrote:
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
> the device fd, userspace can use vhost ioctls on top of it
> to setup the backend.
> 
> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>

So at this point, looks like the only thing missing is IFC, and then all
these patches can go in.
But as IFC is still being worked on anyway, it makes sense to
address the minor comments manwhile so we don't need
patches on top.
Right?

> ---
> This patch depends on below series:
> https://lkml.org/lkml/2019/11/5/217
> 
> v4 -> v5:
> - Rebase on top of virtio-mdev series v8;
> - Use the virtio_ops of mdev_device in vhost-mdev (Jason);
> - Some minor improvements on commit log;
> 
> v3 -> v4:
> - Rebase on top of virtio-mdev series v6;
> - Some minor tweaks and improvements;
> 
> v2 -> v3:
> - Fix the return value (Jason);
> - Don't cache unnecessary information in vhost-mdev (Jason);
> - Get rid of the memset in open (Jason);
> - Add comments for VHOST_SET_MEM_TABLE, ... (Jason);
> - Filter out unsupported features in vhost-mdev (Jason);
> - Add _GET_DEVICE_ID ioctl (Jason);
> - Add _GET_CONFIG/_SET_CONFIG ioctls (Jason);
> - Drop _GET_QUEUE_NUM ioctl (Jason);
> - Fix the copy-paste errors in _IOW/_IOR usage;
> - Some minor fixes and improvements;
> 
> v1 -> v2:
> - Replace _SET_STATE with _SET_STATUS (MST);
> - Check status bits at each step (MST);
> - Report the max ring size and max number of queues (MST);
> - Add missing MODULE_DEVICE_TABLE (Jason);
> - Only support the network backend w/o multiqueue for now;
> - Some minor fixes and improvements;
> - Rebase on top of virtio-mdev series v4;
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
>  drivers/vfio/mdev/mdev_core.c    |  21 ++
>  drivers/vhost/Kconfig            |  12 +
>  drivers/vhost/Makefile           |   3 +
>  drivers/vhost/mdev.c             | 553 +++++++++++++++++++++++++++++++
>  include/linux/mdev.h             |   5 +
>  include/uapi/linux/vhost.h       |  18 +
>  include/uapi/linux/vhost_types.h |   8 +
>  7 files changed, 620 insertions(+)
>  create mode 100644 drivers/vhost/mdev.c
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index c58253404ed5..d855be5afbae 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -99,6 +99,27 @@ mdev_get_virtio_ops(struct mdev_device *mdev)
>  }
>  EXPORT_SYMBOL(mdev_get_virtio_ops);
>  
> +/*
> + * Specify the vhost device ops for the mdev device, this
> + * must be called during create() callback for vhost mdev device.
> + */
> +void mdev_set_vhost_ops(struct mdev_device *mdev,
> +			const struct mdev_virtio_device_ops *vhost_ops)
> +{
> +	mdev_set_class(mdev, MDEV_CLASS_ID_VHOST);
> +	mdev->virtio_ops = vhost_ops;
> +}
> +EXPORT_SYMBOL(mdev_set_vhost_ops);
> +
> +/* Get the vhost device ops for the mdev device. */
> +const struct mdev_virtio_device_ops *
> +mdev_get_vhost_ops(struct mdev_device *mdev)
> +{
> +	WARN_ON(mdev->class_id != MDEV_CLASS_ID_VHOST);
> +	return mdev->virtio_ops;
> +}
> +EXPORT_SYMBOL(mdev_get_vhost_ops);
> +
>  struct device *mdev_dev(struct mdev_device *mdev)
>  {
>  	return &mdev->dev;
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 3d03ccbd1adc..062cada28f89 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -34,6 +34,18 @@ config VHOST_VSOCK
>  	To compile this driver as a module, choose M here: the module will be called
>  	vhost_vsock.
>  
> +config VHOST_MDEV
> +	tristate "Vhost driver for Mediated devices"
> +	depends on EVENTFD && VFIO && VFIO_MDEV
> +	select VHOST
> +	default n
> +	---help---
> +	This kernel module can be loaded in host kernel to accelerate
> +	guest virtio devices with the mediated device based backends.
> +
> +	To compile this driver as a module, choose M here: the module will
> +	be called vhost_mdev.
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
> index 000000000000..0bcde0f3a9cd
> --- /dev/null
> +++ b/drivers/vhost/mdev.c
> @@ -0,0 +1,553 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Vhost driver for mediated device based backends.
> + *
> + * Copyright (C) 2018-2019 Intel Corporation.
> + *
> + * Author: Tiwei Bie <tiwei.bie@intel.com>
> + *
> + * Thanks to Jason Wang and Michael S. Tsirkin for the valuable
> + * comments and suggestions.  And thanks to Cunming Liang and
> + * Zhihong Wang for all their supports.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mdev.h>
> +#include <linux/mdev_virtio_ops.h>
> +#include <linux/nospec.h>
> +#include <linux/vfio.h>
> +#include <linux/vhost.h>
> +#include <linux/virtio_net.h>
> +
> +#include "vhost.h"
> +
> +enum {
> +	VHOST_MDEV_FEATURES =
> +		(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
> +		(1ULL << VIRTIO_F_ANY_LAYOUT) |
> +		(1ULL << VIRTIO_F_VERSION_1) |
> +		(1ULL << VIRTIO_F_IOMMU_PLATFORM) |
> +		(1ULL << VIRTIO_F_RING_PACKED) |
> +		(1ULL << VIRTIO_F_ORDER_PLATFORM) |
> +		(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> +		(1ULL << VIRTIO_RING_F_EVENT_IDX),
> +
> +	VHOST_MDEV_NET_FEATURES = VHOST_MDEV_FEATURES |
> +		(1ULL << VIRTIO_NET_F_CSUM) |
> +		(1ULL << VIRTIO_NET_F_GUEST_CSUM) |
> +		(1ULL << VIRTIO_NET_F_MTU) |
> +		(1ULL << VIRTIO_NET_F_MAC) |
> +		(1ULL << VIRTIO_NET_F_GUEST_TSO4) |
> +		(1ULL << VIRTIO_NET_F_GUEST_TSO6) |
> +		(1ULL << VIRTIO_NET_F_GUEST_ECN) |
> +		(1ULL << VIRTIO_NET_F_GUEST_UFO) |
> +		(1ULL << VIRTIO_NET_F_HOST_TSO4) |
> +		(1ULL << VIRTIO_NET_F_HOST_TSO6) |
> +		(1ULL << VIRTIO_NET_F_HOST_ECN) |
> +		(1ULL << VIRTIO_NET_F_HOST_UFO) |
> +		(1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> +		(1ULL << VIRTIO_NET_F_STATUS) |
> +		(1ULL << VIRTIO_NET_F_SPEED_DUPLEX),
> +};
> +
> +/* Currently, only network backend w/o multiqueue is supported. */
> +#define VHOST_MDEV_VQ_MAX	2
> +
> +struct vhost_mdev {
> +	/* The lock is to protect this structure. */
> +	struct mutex mutex;
> +	struct vhost_dev dev;
> +	struct vhost_virtqueue *vqs;
> +	int nvqs;
> +	int virtio_id;
> +	bool opened;
> +	struct mdev_device *mdev;
> +};
> +
> +static const u64 vhost_mdev_features[] = {
> +	[VIRTIO_ID_NET] = VHOST_MDEV_NET_FEATURES,
> +};
> +
> +static void handle_vq_kick(struct vhost_work *work)
> +{
> +	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
> +						  poll.work);
> +	struct vhost_mdev *m = container_of(vq->dev, struct vhost_mdev, dev);
> +	const struct mdev_virtio_device_ops *ops = mdev_get_vhost_ops(m->mdev);
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
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void vhost_mdev_reset(struct vhost_mdev *m)
> +{
> +	struct mdev_device *mdev = m->mdev;
> +	const struct mdev_virtio_device_ops *ops = mdev_get_vhost_ops(mdev);
> +
> +	ops->set_status(mdev, 0);
> +}
> +
> +static long vhost_mdev_get_device_id(struct vhost_mdev *m, u8 __user *argp)
> +{
> +	struct mdev_device *mdev = m->mdev;
> +	const struct mdev_virtio_device_ops *ops = mdev_get_vhost_ops(mdev);
> +	u32 device_id;
> +
> +	device_id = ops->get_device_id(mdev);
> +
> +	if (copy_to_user(argp, &device_id, sizeof(device_id)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static long vhost_mdev_get_status(struct vhost_mdev *m, u8 __user *statusp)
> +{
> +	struct mdev_device *mdev = m->mdev;
> +	const struct mdev_virtio_device_ops *ops = mdev_get_vhost_ops(mdev);
> +	u8 status;
> +
> +	status = ops->get_status(mdev);
> +
> +	if (copy_to_user(statusp, &status, sizeof(status)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static long vhost_mdev_set_status(struct vhost_mdev *m, u8 __user *statusp)
> +{
> +	struct mdev_device *mdev = m->mdev;
> +	const struct mdev_virtio_device_ops *ops = mdev_get_vhost_ops(mdev);
> +	u8 status;
> +
> +	if (copy_from_user(&status, statusp, sizeof(status)))
> +		return -EFAULT;
> +
> +	/*
> +	 * Userspace shouldn't remove status bits unless reset the
> +	 * status to 0.
> +	 */
> +	if (status != 0 && (ops->get_status(mdev) & ~status) != 0)
> +		return -EINVAL;
> +
> +	ops->set_status(mdev, status);
> +
> +	return 0;
> +}
> +
> +static int vhost_mdev_config_validate(struct vhost_mdev *m,
> +				      struct vhost_mdev_config *c)
> +{
> +	long size = 0;
> +
> +	switch (m->virtio_id) {
> +	case VIRTIO_ID_NET:
> +		size = sizeof(struct virtio_net_config);
> +		break;
> +	}
> +
> +	if (c->len == 0)
> +		return -EINVAL;
> +
> +	if (c->off >= size || c->len > size || c->off + c->len > size)
> +		return -E2BIG;
> +
> +	return 0;
> +}
> +
> +static long vhost_mdev_get_config(struct vhost_mdev *m,
> +				  struct vhost_mdev_config __user *c)
> +{
> +	struct mdev_device *mdev = m->mdev;
> +	const struct mdev_virtio_device_ops *ops = mdev_get_vhost_ops(mdev);
> +	struct vhost_mdev_config config;
> +	unsigned long size = offsetof(struct vhost_mdev_config, buf);
> +	u8 *buf;
> +
> +	if (copy_from_user(&config, c, size))
> +		return -EFAULT;
> +	if (vhost_mdev_config_validate(m, &config))
> +		return -EINVAL;
> +	buf = kvzalloc(config.len, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	ops->get_config(mdev, config.off, buf, config.len);
> +
> +	if (copy_to_user(c->buf, buf, config.len)) {
> +		kvfree(buf);
> +		return -EFAULT;
> +	}
> +
> +	kvfree(buf);
> +	return 0;
> +}
> +
> +static long vhost_mdev_set_config(struct vhost_mdev *m,
> +				  struct vhost_mdev_config __user *c)
> +{
> +	struct mdev_device *mdev = m->mdev;
> +	const struct mdev_virtio_device_ops *ops = mdev_get_vhost_ops(mdev);
> +	struct vhost_mdev_config config;
> +	unsigned long size = offsetof(struct vhost_mdev_config, buf);
> +	u8 *buf;
> +
> +	if (copy_from_user(&config, c, size))
> +		return -EFAULT;
> +	if (vhost_mdev_config_validate(m, &config))
> +		return -EINVAL;
> +	buf = kvzalloc(config.len, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(buf, c->buf, config.len)) {
> +		kvfree(buf);
> +		return -EFAULT;
> +	}
> +
> +	ops->set_config(mdev, config.off, buf, config.len);
> +
> +	kvfree(buf);
> +	return 0;
> +}
> +
> +static long vhost_mdev_get_features(struct vhost_mdev *m, u64 __user *featurep)
> +{
> +	struct mdev_device *mdev = m->mdev;
> +	const struct mdev_virtio_device_ops *ops = mdev_get_vhost_ops(mdev);
> +	u64 features;
> +
> +	features = ops->get_features(mdev);
> +	features &= vhost_mdev_features[m->virtio_id];
> +
> +	if (copy_to_user(featurep, &features, sizeof(features)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static long vhost_mdev_set_features(struct vhost_mdev *m, u64 __user *featurep)
> +{
> +	struct mdev_device *mdev = m->mdev;
> +	const struct mdev_virtio_device_ops *ops = mdev_get_vhost_ops(mdev);
> +	u64 features;
> +
> +	/*
> +	 * It's not allowed to change the features after they have
> +	 * been negotiated.
> +	 */
> +	if (ops->get_status(mdev) & VIRTIO_CONFIG_S_FEATURES_OK)
> +		return -EBUSY;
> +
> +	if (copy_from_user(&features, featurep, sizeof(features)))
> +		return -EFAULT;
> +
> +	if (features & ~vhost_mdev_features[m->virtio_id])
> +		return -EINVAL;
> +
> +	if (ops->set_features(mdev, features))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static long vhost_mdev_get_vring_num(struct vhost_mdev *m, u16 __user *argp)
> +{
> +	struct mdev_device *mdev = m->mdev;
> +	const struct mdev_virtio_device_ops *ops = mdev_get_vhost_ops(mdev);
> +	u16 num;
> +
> +	num = ops->get_vq_num_max(mdev);
> +
> +	if (copy_to_user(argp, &num, sizeof(num)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static long vhost_mdev_vring_ioctl(struct vhost_mdev *m, unsigned int cmd,
> +				   void __user *argp)
> +{
> +	struct mdev_device *mdev = m->mdev;
> +	const struct mdev_virtio_device_ops *ops = mdev_get_vhost_ops(mdev);
> +	struct virtio_mdev_callback cb;
> +	struct vhost_virtqueue *vq;
> +	struct vhost_vring_state s;
> +	u8 status;
> +	u32 idx;
> +	long r;
> +
> +	r = get_user(idx, (u32 __user *)argp);
> +	if (r < 0)
> +		return r;
> +	if (idx >= m->nvqs)
> +		return -ENOBUFS;
> +
> +	idx = array_index_nospec(idx, m->nvqs);
> +	vq = &m->vqs[idx];
> +
> +	status = ops->get_status(mdev);
> +
> +	/*
> +	 * It's not allowed to detect and program vqs before
> +	 * features negotiation or after enabling driver.
> +	 */
> +	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK) ||
> +	    (status & VIRTIO_CONFIG_S_DRIVER_OK))
> +		return -EBUSY;
> +
> +	if (cmd == VHOST_MDEV_SET_VRING_ENABLE) {
> +		if (copy_from_user(&s, argp, sizeof(s)))
> +			return -EFAULT;
> +		ops->set_vq_ready(mdev, idx, s.num);
> +		return 0;
> +	}
> +
> +	/*
> +	 * It's not allowed to detect and program vqs with
> +	 * vqs enabled.
> +	 */
> +	if (ops->get_vq_ready(mdev, idx))
> +		return -EBUSY;
> +
> +	if (cmd == VHOST_GET_VRING_BASE)
> +		vq->last_avail_idx = ops->get_vq_state(m->mdev, idx);
> +
> +	r = vhost_vring_ioctl(&m->dev, cmd, argp);
> +	if (r)
> +		return r;
> +
> +	switch (cmd) {
> +	case VHOST_SET_VRING_ADDR:
> +		/*
> +		 * In vhost-mdev, the ring addresses set by userspace should
> +		 * be the DMA addresses within the VFIO container/group.
> +		 */
> +		if (ops->set_vq_address(mdev, idx, (u64)vq->desc,
> +					(u64)vq->avail, (u64)vq->used))
> +			r = -EINVAL;
> +		break;
> +
> +	case VHOST_SET_VRING_BASE:
> +		if (ops->set_vq_state(mdev, idx, vq->last_avail_idx))
> +			r = -EINVAL;
> +		break;
> +
> +	case VHOST_SET_VRING_CALL:
> +		if (vq->call_ctx) {
> +			cb.callback = vhost_mdev_virtqueue_cb;
> +			cb.private = vq;
> +		} else {
> +			cb.callback = NULL;
> +			cb.private = NULL;
> +		}
> +		ops->set_vq_cb(mdev, idx, &cb);
> +		break;
> +
> +	case VHOST_SET_VRING_NUM:
> +		ops->set_vq_num(mdev, idx, vq->num);
> +		break;
> +	}
> +
> +	return r;
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
> +	case VHOST_MDEV_GET_DEVICE_ID:
> +		r = vhost_mdev_get_device_id(m, argp);
> +		break;
> +	case VHOST_MDEV_GET_STATUS:
> +		r = vhost_mdev_get_status(m, argp);
> +		break;
> +	case VHOST_MDEV_SET_STATUS:
> +		r = vhost_mdev_set_status(m, argp);
> +		break;
> +	case VHOST_MDEV_GET_CONFIG:
> +		r = vhost_mdev_get_config(m, argp);
> +		break;
> +	case VHOST_MDEV_SET_CONFIG:
> +		r = vhost_mdev_set_config(m, argp);
> +		break;
> +	case VHOST_GET_FEATURES:
> +		r = vhost_mdev_get_features(m, argp);
> +		break;
> +	case VHOST_SET_FEATURES:
> +		r = vhost_mdev_set_features(m, argp);
> +		break;
> +	case VHOST_MDEV_GET_VRING_NUM:
> +		r = vhost_mdev_get_vring_num(m, argp);
> +		break;
> +	default:
> +		/*
> +		 * VHOST_SET_MEM_TABLE, VHOST_SET_LOG_BASE, and
> +		 * VHOST_SET_LOG_FD are not used yet.
> +		 */
> +		r = vhost_dev_ioctl(&m->dev, cmd, argp);
> +		if (r == -ENOIOCTLCMD)
> +			r = vhost_mdev_vring_ioctl(m, cmd, argp);
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
> +	const struct mdev_virtio_device_ops *ops = mdev_get_vhost_ops(mdev);
> +	struct vhost_mdev *m;
> +	int nvqs, r;
> +
> +	/* Currently, we only accept the network devices. */
> +	if (ops->get_device_id(mdev) != VIRTIO_ID_NET)
> +		return -ENOTSUPP;
> +
> +	m = devm_kzalloc(dev, sizeof(*m), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +	if (!m)
> +		return -ENOMEM;
> +
> +	nvqs = VHOST_MDEV_VQ_MAX;
> +
> +	m->vqs = devm_kmalloc_array(dev, nvqs, sizeof(struct vhost_virtqueue),
> +				    GFP_KERNEL);
> +	if (!m->vqs)
> +		return -ENOMEM;
> +
> +	mutex_init(&m->mutex);
> +
> +	m->mdev = mdev;
> +	m->nvqs = nvqs;
> +	m->virtio_id = ops->get_device_id(mdev);
> +
> +	r = vfio_add_group_dev(dev, &vfio_vhost_mdev_dev_ops, m);
> +	if (r) {
> +		mutex_destroy(&m->mutex);
> +		return r;
> +	}
> +
> +	return 0;
> +}
> +
> +static void vhost_mdev_remove(struct device *dev)
> +{
> +	struct vhost_mdev *m;
> +
> +	m = vfio_del_group_dev(dev);
> +	mutex_destroy(&m->mutex);
> +}
> +
> +static const struct mdev_class_id vhost_mdev_match[] = {
> +	{ MDEV_CLASS_ID_VHOST },
> +	{ 0 },
> +};
> +MODULE_DEVICE_TABLE(mdev, vhost_mdev_match);
> +
> +static struct mdev_driver vhost_mdev_driver = {
> +	.name	= "vhost_mdev",
> +	.probe	= vhost_mdev_probe,
> +	.remove	= vhost_mdev_remove,
> +	.id_table = vhost_mdev_match,
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
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_DESCRIPTION("Mediated device based accelerator for virtio");
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index f3d75a60c2b5..8af7fb9e0149 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -117,6 +117,10 @@ void mdev_set_virtio_ops(struct mdev_device *mdev,
>  			 const struct mdev_virtio_device_ops *virtio_ops);
>  const struct mdev_virtio_device_ops *
>  mdev_get_virtio_ops(struct mdev_device *mdev);
> +void mdev_set_vhost_ops(struct mdev_device *mdev,
> +			const struct mdev_virtio_device_ops *vhost_ops);
> +const struct mdev_virtio_device_ops *
> +mdev_get_vhost_ops(struct mdev_device *mdev);
>  
>  extern struct bus_type mdev_bus_type;
>  
> @@ -133,6 +137,7 @@ struct mdev_device *mdev_from_dev(struct device *dev);
>  enum {
>  	MDEV_CLASS_ID_VFIO = 1,
>  	MDEV_CLASS_ID_VIRTIO = 2,
> +	MDEV_CLASS_ID_VHOST = 3,
>  	/* New entries must be added here */
>  };
>  
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 40d028eed645..061a2824a1b3 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -116,4 +116,22 @@
>  #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
>  #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
>  
> +/* VHOST_MDEV specific defines */
> +
> +/* Get the device id. The device ids follow the same definition of
> + * the device id defined in virtio-spec. */
> +#define VHOST_MDEV_GET_DEVICE_ID	_IOR(VHOST_VIRTIO, 0x70, __u32)
> +/* Get and set the status. The status bits follow the same definition
> + * of the device status defined in virtio-spec. */
> +#define VHOST_MDEV_GET_STATUS		_IOR(VHOST_VIRTIO, 0x71, __u8)
> +#define VHOST_MDEV_SET_STATUS		_IOW(VHOST_VIRTIO, 0x72, __u8)
> +/* Get and set the device config. The device config follows the same
> + * definition of the device config defined in virtio-spec. */
> +#define VHOST_MDEV_GET_CONFIG		_IOR(VHOST_VIRTIO, 0x73, struct vhost_mdev_config)
> +#define VHOST_MDEV_SET_CONFIG		_IOW(VHOST_VIRTIO, 0x74, struct vhost_mdev_config)
> +/* Enable/disable the ring. */
> +#define VHOST_MDEV_SET_VRING_ENABLE	_IOW(VHOST_VIRTIO, 0x75, struct vhost_vring_state)
> +/* Get the max ring size. */
> +#define VHOST_MDEV_GET_VRING_NUM	_IOR(VHOST_VIRTIO, 0x76, __u16)
> +
>  #endif
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
> index c907290ff065..7b105d0b2fb9 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -119,6 +119,14 @@ struct vhost_scsi_target {
>  	unsigned short reserved;
>  };
>  
> +/* VHOST_MDEV specific definitions */
> +
> +struct vhost_mdev_config {
> +	__u32 off;
> +	__u32 len;
> +	__u8 buf[0];
> +};
> +
>  /* Feature bits */
>  /* Log all write descriptors. Can be changed while device is active. */
>  #define VHOST_F_LOG_ALL 26
> -- 
> 2.23.0
