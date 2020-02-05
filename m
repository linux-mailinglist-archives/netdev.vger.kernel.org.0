Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18AD71524A3
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 03:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgBECDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 21:03:03 -0500
Received: from mga18.intel.com ([134.134.136.126]:32494 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbgBECDD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 21:03:03 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 18:03:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,404,1574150400"; 
   d="scan'208";a="231570076"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by orsmga003.jf.intel.com with ESMTP; 04 Feb 2020 18:02:55 -0800
Date:   Wed, 5 Feb 2020 10:02:47 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        shahafs@mellanox.com, jgg@mellanox.com, rob.miller@broadcom.com,
        haotian.wang@sifive.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, rdunlap@infradead.org, hch@infradead.org,
        jiri@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200205020247.GA368700@___>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
> On 2020/1/31 上午11:36, Tiwei Bie wrote:
> > This patch introduces a vDPA based vhost backend. This
> > backend is built on top of the same interface defined
> > in virtio-vDPA and provides a generic vhost interface
> > for userspace to accelerate the virtio devices in guest.
> > 
> > This backend is implemented as a vDPA device driver on
> > top of the same ops used in virtio-vDPA. It will create
> > char device entry named vhost-vdpa/$vdpa_device_index
> > for userspace to use. Userspace can use vhost ioctls on
> > top of this char device to setup the backend.
> > 
> > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> > ---
> > This patch depends on below series:
> > https://lkml.org/lkml/2020/1/16/353
> > 
> > Please note that _SET_MEM_TABLE isn't fully supported yet.
> > Comments would be appreciated!
> > 
> > Changes since last patch (https://lkml.org/lkml/2019/11/18/1068)
> > - Switch to the vDPA bus;
> > - Switch to vhost's own chardev;
> > 
> >   drivers/vhost/Kconfig            |  12 +
> >   drivers/vhost/Makefile           |   3 +
> >   drivers/vhost/vdpa.c             | 705 +++++++++++++++++++++++++++++++
> >   include/uapi/linux/vhost.h       |  21 +
> >   include/uapi/linux/vhost_types.h |   8 +
> >   5 files changed, 749 insertions(+)
> >   create mode 100644 drivers/vhost/vdpa.c
> > 
> > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > index f21c45aa5e07..13e6a94d0243 100644
> > --- a/drivers/vhost/Kconfig
> > +++ b/drivers/vhost/Kconfig
> > @@ -34,6 +34,18 @@ config VHOST_VSOCK
> >   	To compile this driver as a module, choose M here: the module will be called
> >   	vhost_vsock.
> > +config VHOST_VDPA
> > +	tristate "Vhost driver for vDPA based backend"
> > +	depends on EVENTFD && VDPA
> > +	select VHOST
> > +	default n
> > +	---help---
> > +	This kernel module can be loaded in host kernel to accelerate
> > +	guest virtio devices with the vDPA based backends.
> > +
> > +	To compile this driver as a module, choose M here: the module
> > +	will be called vhost_vdpa.
> > +
> >   config VHOST
> >   	tristate
> >           depends on VHOST_IOTLB
> > diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> > index df99756fbb26..a65e9f4a2c0a 100644
> > --- a/drivers/vhost/Makefile
> > +++ b/drivers/vhost/Makefile
> > @@ -10,6 +10,9 @@ vhost_vsock-y := vsock.o
> >   obj-$(CONFIG_VHOST_RING) += vringh.o
> > +obj-$(CONFIG_VHOST_VDPA) += vhost_vdpa.o
> > +vhost_vdpa-y := vdpa.o
> > +
> >   obj-$(CONFIG_VHOST)	+= vhost.o
> >   obj-$(CONFIG_VHOST_IOTLB) += vhost_iotlb.o
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > new file mode 100644
> > index 000000000000..631d994d37ac
> > --- /dev/null
> > +++ b/drivers/vhost/vdpa.c
> > @@ -0,0 +1,705 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2018-2020 Intel Corporation.
> > + *
> > + * Author: Tiwei Bie <tiwei.bie@intel.com>
> > + *
> > + * Thanks to Jason Wang and Michael S. Tsirkin for the valuable
> > + * comments and suggestions.  And thanks to Cunming Liang and
> > + * Zhihong Wang for all their supports.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/cdev.h>
> > +#include <linux/device.h>
> > +#include <linux/uuid.h>
> > +#include <linux/vdpa.h>
> > +#include <linux/nospec.h>
> > +#include <linux/vhost.h>
> > +#include <linux/virtio_net.h>
> > +
> > +#include "vhost.h"
> > +
> > +enum {
> > +	VHOST_VDPA_FEATURES =
> > +		(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
> > +		(1ULL << VIRTIO_F_ANY_LAYOUT) |
> > +		(1ULL << VIRTIO_F_VERSION_1) |
> > +		(1ULL << VIRTIO_F_IOMMU_PLATFORM) |
> > +		(1ULL << VIRTIO_F_RING_PACKED) |
> > +		(1ULL << VIRTIO_F_ORDER_PLATFORM) |
> > +		(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> > +		(1ULL << VIRTIO_RING_F_EVENT_IDX),
> > +
> > +	VHOST_VDPA_NET_FEATURES = VHOST_VDPA_FEATURES |
> > +		(1ULL << VIRTIO_NET_F_CSUM) |
> > +		(1ULL << VIRTIO_NET_F_GUEST_CSUM) |
> > +		(1ULL << VIRTIO_NET_F_MTU) |
> > +		(1ULL << VIRTIO_NET_F_MAC) |
> > +		(1ULL << VIRTIO_NET_F_GUEST_TSO4) |
> > +		(1ULL << VIRTIO_NET_F_GUEST_TSO6) |
> > +		(1ULL << VIRTIO_NET_F_GUEST_ECN) |
> > +		(1ULL << VIRTIO_NET_F_GUEST_UFO) |
> > +		(1ULL << VIRTIO_NET_F_HOST_TSO4) |
> > +		(1ULL << VIRTIO_NET_F_HOST_TSO6) |
> > +		(1ULL << VIRTIO_NET_F_HOST_ECN) |
> > +		(1ULL << VIRTIO_NET_F_HOST_UFO) |
> > +		(1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> > +		(1ULL << VIRTIO_NET_F_STATUS) |
> > +		(1ULL << VIRTIO_NET_F_SPEED_DUPLEX),
> > +};
> > +
> > +/* Currently, only network backend w/o multiqueue is supported. */
> > +#define VHOST_VDPA_VQ_MAX	2
> > +
> > +struct vhost_vdpa {
> > +	/* The lock is to protect this structure. */
> > +	struct mutex mutex;
> > +	struct vhost_dev vdev;
> > +	struct vhost_virtqueue *vqs;
> > +	struct vdpa_device *vdpa;
> > +	struct device *dev;
> > +	atomic_t opened;
> > +	int nvqs;
> > +	int virtio_id;
> > +	int minor;
> > +};
> > +
> > +static struct {
> > +	/* The lock is to protect this structure. */
> > +	struct mutex mutex;
> > +	struct class *class;
> > +	struct idr idr;
> > +	struct cdev cdev;
> > +	dev_t devt;
> > +	wait_queue_head_t release_q;
> > +} vhost_vdpa;
> > +
> > +static const u64 vhost_vdpa_features[] = {
> > +	[VIRTIO_ID_NET] = VHOST_VDPA_NET_FEATURES,
> > +};
> > +
> > +static int vhost_vdpa_alloc_minor(struct vhost_vdpa *v)
> > +{
> > +	return idr_alloc(&vhost_vdpa.idr, v, 0, MINORMASK + 1,
> > +			 GFP_KERNEL);
> > +}
> > +
> > +static void vhost_vdpa_free_minor(int minor)
> > +{
> > +	idr_remove(&vhost_vdpa.idr, minor);
> > +}
> > +
> > +static struct vhost_vdpa *vhost_vdpa_get_from_minor(int minor)
> > +{
> > +	struct vhost_vdpa *v;
> > +
> > +	mutex_lock(&vhost_vdpa.mutex);
> > +	v = idr_find(&vhost_vdpa.idr, minor);
> > +	mutex_unlock(&vhost_vdpa.mutex);
> > +
> > +	return v;
> > +}
> > +
> > +static void handle_vq_kick(struct vhost_work *work)
> > +{
> > +	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
> > +						  poll.work);
> > +	struct vhost_vdpa *v = container_of(vq->dev, struct vhost_vdpa, vdev);
> > +	const struct vdpa_config_ops *ops = v->vdpa->config;
> > +
> > +	ops->kick_vq(v->vdpa, vq - v->vqs);
> > +}
> > +
> > +static irqreturn_t vhost_vdpa_virtqueue_cb(void *private)
> > +{
> > +	struct vhost_virtqueue *vq = private;
> > +	struct eventfd_ctx *call_ctx = vq->call_ctx;
> > +
> > +	if (call_ctx)
> > +		eventfd_signal(call_ctx, 1);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static void vhost_vdpa_reset(struct vhost_vdpa *v)
> > +{
> > +	struct vdpa_device *vdpa = v->vdpa;
> > +	const struct vdpa_config_ops *ops = vdpa->config;
> > +
> > +	ops->set_status(vdpa, 0);
> > +}
> > +
> > +static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
> > +{
> > +	struct vdpa_device *vdpa = v->vdpa;
> > +	const struct vdpa_config_ops *ops = vdpa->config;
> > +	u32 device_id;
> > +
> > +	device_id = ops->get_device_id(vdpa);
> > +
> > +	if (copy_to_user(argp, &device_id, sizeof(device_id)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> > +static long vhost_vdpa_get_status(struct vhost_vdpa *v, u8 __user *statusp)
> > +{
> > +	struct vdpa_device *vdpa = v->vdpa;
> > +	const struct vdpa_config_ops *ops = vdpa->config;
> > +	u8 status;
> > +
> > +	status = ops->get_status(vdpa);
> > +
> > +	if (copy_to_user(statusp, &status, sizeof(status)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> > +static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
> > +{
> > +	struct vdpa_device *vdpa = v->vdpa;
> > +	const struct vdpa_config_ops *ops = vdpa->config;
> > +	u8 status;
> > +
> > +	if (copy_from_user(&status, statusp, sizeof(status)))
> > +		return -EFAULT;
> > +
> > +	/*
> > +	 * Userspace shouldn't remove status bits unless reset the
> > +	 * status to 0.
> > +	 */
> > +	if (status != 0 && (ops->get_status(vdpa) & ~status) != 0)
> > +		return -EINVAL;
> > +
> > +	ops->set_status(vdpa, status);
> > +
> > +	return 0;
> > +}
> > +
> > +static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
> > +				      struct vhost_vdpa_config *c)
> > +{
> > +	long size = 0;
> > +
> > +	switch (v->virtio_id) {
> > +	case VIRTIO_ID_NET:
> > +		size = sizeof(struct virtio_net_config);
> > +		break;
> > +	}
> > +
> > +	if (c->len == 0)
> > +		return -EINVAL;
> > +
> > +	if (c->len > size - c->off)
> > +		return -E2BIG;
> > +
> > +	return 0;
> > +}
> > +
> > +static long vhost_vdpa_get_config(struct vhost_vdpa *v,
> > +				  struct vhost_vdpa_config __user *c)
> > +{
> > +	struct vdpa_device *vdpa = v->vdpa;
> > +	const struct vdpa_config_ops *ops = vdpa->config;
> > +	struct vhost_vdpa_config config;
> > +	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
> > +	u8 *buf;
> > +
> > +	if (copy_from_user(&config, c, size))
> > +		return -EFAULT;
> > +	if (vhost_vdpa_config_validate(v, &config))
> > +		return -EINVAL;
> > +	buf = kvzalloc(config.len, GFP_KERNEL);
> > +	if (!buf)
> > +		return -ENOMEM;
> > +
> > +	ops->get_config(vdpa, config.off, buf, config.len);
> > +
> > +	if (copy_to_user(c->buf, buf, config.len)) {
> > +		kvfree(buf);
> > +		return -EFAULT;
> > +	}
> > +
> > +	kvfree(buf);
> > +	return 0;
> > +}
> > +
> > +static long vhost_vdpa_set_config(struct vhost_vdpa *v,
> > +				  struct vhost_vdpa_config __user *c)
> > +{
> > +	struct vdpa_device *vdpa = v->vdpa;
> > +	const struct vdpa_config_ops *ops = vdpa->config;
> > +	struct vhost_vdpa_config config;
> > +	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
> > +	u8 *buf;
> > +
> > +	if (copy_from_user(&config, c, size))
> > +		return -EFAULT;
> > +	if (vhost_vdpa_config_validate(v, &config))
> > +		return -EINVAL;
> > +	buf = kvzalloc(config.len, GFP_KERNEL);
> > +	if (!buf)
> > +		return -ENOMEM;
> > +
> > +	if (copy_from_user(buf, c->buf, config.len)) {
> > +		kvfree(buf);
> > +		return -EFAULT;
> > +	}
> > +
> > +	ops->set_config(vdpa, config.off, buf, config.len);
> > +
> > +	kvfree(buf);
> > +	return 0;
> > +}
> > +
> > +static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
> > +{
> > +	struct vdpa_device *vdpa = v->vdpa;
> > +	const struct vdpa_config_ops *ops = vdpa->config;
> > +	u64 features;
> > +
> > +	features = ops->get_features(vdpa);
> > +	features &= vhost_vdpa_features[v->virtio_id];
> > +
> > +	if (copy_to_user(featurep, &features, sizeof(features)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> > +static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
> > +{
> > +	struct vdpa_device *vdpa = v->vdpa;
> > +	const struct vdpa_config_ops *ops = vdpa->config;
> > +	u64 features;
> > +
> > +	/*
> > +	 * It's not allowed to change the features after they have
> > +	 * been negotiated.
> > +	 */
> > +	if (ops->get_status(vdpa) & VIRTIO_CONFIG_S_FEATURES_OK)
> > +		return -EBUSY;
> > +
> > +	if (copy_from_user(&features, featurep, sizeof(features)))
> > +		return -EFAULT;
> > +
> > +	if (features & ~vhost_vdpa_features[v->virtio_id])
> > +		return -EINVAL;
> > +
> > +	if (ops->set_features(vdpa, features))
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *argp)
> > +{
> > +	struct vdpa_device *vdpa = v->vdpa;
> > +	const struct vdpa_config_ops *ops = vdpa->config;
> > +	u16 num;
> > +
> > +	num = ops->get_vq_num_max(vdpa);
> > +
> > +	if (copy_to_user(argp, &num, sizeof(num)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> > +static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
> > +				   void __user *argp)
> > +{
> > +	struct vdpa_device *vdpa = v->vdpa;
> > +	const struct vdpa_config_ops *ops = vdpa->config;
> > +	struct vdpa_callback cb;
> > +	struct vhost_virtqueue *vq;
> > +	struct vhost_vring_state s;
> > +	u8 status;
> > +	u32 idx;
> > +	long r;
> > +
> > +	r = get_user(idx, (u32 __user *)argp);
> > +	if (r < 0)
> > +		return r;
> > +	if (idx >= v->nvqs)
> > +		return -ENOBUFS;
> > +
> > +	idx = array_index_nospec(idx, v->nvqs);
> > +	vq = &v->vqs[idx];
> > +
> > +	status = ops->get_status(vdpa);
> > +
> > +	/*
> > +	 * It's not allowed to detect and program vqs before
> > +	 * features negotiation or after enabling driver.
> > +	 */
> > +	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK) ||
> > +	    (status & VIRTIO_CONFIG_S_DRIVER_OK))
> > +		return -EBUSY;
> > +
> > +	if (cmd == VHOST_VDPA_SET_VRING_ENABLE) {
> > +		if (copy_from_user(&s, argp, sizeof(s)))
> > +			return -EFAULT;
> > +		ops->set_vq_ready(vdpa, idx, s.num);
> > +		return 0;
> > +	}
> > +
> > +	/*
> > +	 * It's not allowed to detect and program vqs with
> > +	 * vqs enabled.
> > +	 */
> > +	if (ops->get_vq_ready(vdpa, idx))
> > +		return -EBUSY;
> > +
> > +	if (cmd == VHOST_GET_VRING_BASE)
> > +		vq->last_avail_idx = ops->get_vq_state(v->vdpa, idx);
> > +
> > +	r = vhost_vring_ioctl(&v->vdev, cmd, argp);
> > +	if (r)
> > +		return r;
> > +
> > +	switch (cmd) {
> > +	case VHOST_SET_VRING_ADDR:
> > +		if (ops->set_vq_address(vdpa, idx, (u64)vq->desc,
> > +					(u64)vq->avail, (u64)vq->used))
> > +			r = -EINVAL;
> > +		break;
> > +
> > +	case VHOST_SET_VRING_BASE:
> > +		if (ops->set_vq_state(vdpa, idx, vq->last_avail_idx))
> > +			r = -EINVAL;
> > +		break;
> > +
> > +	case VHOST_SET_VRING_CALL:
> > +		if (vq->call_ctx) {
> > +			cb.callback = vhost_vdpa_virtqueue_cb;
> > +			cb.private = vq;
> > +		} else {
> > +			cb.callback = NULL;
> > +			cb.private = NULL;
> > +		}
> > +		ops->set_vq_cb(vdpa, idx, &cb);
> > +		break;
> > +
> > +	case VHOST_SET_VRING_NUM:
> > +		ops->set_vq_num(vdpa, idx, vq->num);
> > +		break;
> > +	}
> > +
> > +	return r;
> > +}
> > +
> > +static long vhost_vdpa_do_dma_mapping(struct vhost_vdpa *v)
> > +{
> > +	/* TODO: fix this */
> 
> 
> Before trying to do this it looks to me we need the following during the
> probe
> 
> 1) if set_map() is not supported by the vDPA device probe the IOMMU that is
> supported by the vDPA device
> 2) allocate IOMMU domain
> 
> And then:
> 
> 3) pin pages through GUP and do proper accounting
> 4) store GPA->HPA mapping in the umem
> 5) generate diffs of memory table and using IOMMU API to setup the dma
> mapping in this method
> 
> For 1), I'm not sure parent is sufficient for to doing this or need to
> introduce new API like iommu_device in mdev.

Agree. We may also need to introduce something like
the iommu_device.

> 
> 
> > +	return -ENOTSUPP;
> > +}
> > +
> > +static int vhost_vdpa_open(struct inode *inode, struct file *filep)
> > +{
> > +	struct vhost_vdpa *v;
> > +	struct vhost_dev *dev;
> > +	struct vhost_virtqueue **vqs;
> > +	int nvqs, i, r, opened;
> > +
> > +	v = vhost_vdpa_get_from_minor(iminor(inode));
> > +	if (!v)
> > +		return -ENODEV;
> > +
> > +	opened = atomic_cmpxchg(&v->opened, 0, 1);
> > +	if (opened) {
> > +		r = -EBUSY;
> > +		goto err;
> > +	}
> > +
> > +	nvqs = v->nvqs;
> > +	vhost_vdpa_reset(v);
> > +
> > +	vqs = kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
> > +	if (!vqs) {
> > +		r = -ENOMEM;
> > +		goto err;
> > +	}
> > +
> > +	dev = &v->vdev;
> > +	for (i = 0; i < nvqs; i++) {
> > +		vqs[i] = &v->vqs[i];
> > +		vqs[i]->handle_kick = handle_vq_kick;
> > +	}
> > +	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0);
> > +
> > +	filep->private_data = v;
> > +
> > +	return 0;
> > +
> > +err:
> > +	atomic_dec(&v->opened);
> > +	return r;
> > +}
> > +
> > +static int vhost_vdpa_release(struct inode *inode, struct file *filep)
> > +{
> > +	struct vhost_vdpa *v = filep->private_data;
> > +
> > +	mutex_lock(&v->mutex);
> > +	filep->private_data = NULL;
> > +	vhost_vdpa_reset(v);
> > +	vhost_dev_stop(&v->vdev);
> > +	vhost_dev_cleanup(&v->vdev);
> > +	kfree(v->vdev.vqs);
> > +	mutex_unlock(&v->mutex);
> > +
> > +	atomic_dec(&v->opened);
> > +	wake_up(&vhost_vdpa.release_q);
> > +
> > +	return 0;
> > +}
> > +
> > +static long vhost_vdpa_unlocked_ioctl(struct file *filep,
> > +				      unsigned int cmd, unsigned long arg)
> > +{
> > +	struct vhost_vdpa *v = filep->private_data;
> > +	struct vdpa_device *vdpa = v->vdpa;
> > +	const struct vdpa_config_ops *ops = vdpa->config;
> > +	void __user *argp = (void __user *)arg;
> > +	long r;
> > +
> > +	mutex_lock(&v->mutex);
> > +
> > +	switch (cmd) {
> > +	case VHOST_VDPA_GET_DEVICE_ID:
> > +		r = vhost_vdpa_get_device_id(v, argp);
> > +		break;
> > +	case VHOST_VDPA_GET_STATUS:
> > +		r = vhost_vdpa_get_status(v, argp);
> > +		break;
> > +	case VHOST_VDPA_SET_STATUS:
> > +		r = vhost_vdpa_set_status(v, argp);
> > +		break;
> > +	case VHOST_VDPA_GET_CONFIG:
> > +		r = vhost_vdpa_get_config(v, argp);
> > +		break;
> > +	case VHOST_VDPA_SET_CONFIG:
> > +		r = vhost_vdpa_set_config(v, argp);
> > +		break;
> > +	case VHOST_GET_FEATURES:
> > +		r = vhost_vdpa_get_features(v, argp);
> > +		break;
> > +	case VHOST_SET_FEATURES:
> > +		r = vhost_vdpa_set_features(v, argp);
> > +		break;
> > +	case VHOST_VDPA_GET_VRING_NUM:
> > +		r = vhost_vdpa_get_vring_num(v, argp);
> > +		break;
> > +	case VHOST_SET_LOG_BASE:
> > +	case VHOST_SET_LOG_FD:
> > +		r = -ENOIOCTLCMD;
> > +		break;
> > +	default:
> > +		mutex_lock(&v->vdev.mutex);
> > +		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
> > +		if (r == -ENOIOCTLCMD)
> > +			r = vhost_vdpa_vring_ioctl(v, cmd, argp);
> > +		mutex_unlock(&v->vdev.mutex);
> > +		break;
> > +	}
> > +
> > +	if (r)
> > +		goto out;
> > +
> > +	switch (cmd) {
> > +	case VHOST_SET_MEM_TABLE:
> > +		if (ops->set_map)
> > +			r = ops->set_map(vdpa, v->vdev.umem);
> 
> 
> I think we need do the following to make sure set_map() works:
> 
> 1) pin pages through GUP and do proper accounting for e.g ulimit
> 2) using GPA->HPA mapping for dev->umem
> 3) then there's no need to deal VHOST_SET_MEM_TABLE in vhost_dev_ioctl(), or
> add some specific callbacks in vhost_set_memory().

OK.

Thanks!
Tiwei

> 
> Thanks
> 
> 
