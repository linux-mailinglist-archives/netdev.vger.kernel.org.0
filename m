Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C28A1151498
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 04:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgBDDat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 22:30:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36453 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727090AbgBDDas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 22:30:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580787044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iag3EfZRes23G0KCmN4NSN6tu6y212GAW/4KEmho8xo=;
        b=T6g0bg3yucsgjS2CSnWy2QFX2SU1wsR4MDlEosfy/BT80WgUpXFkBQmaNWgQ+uvdq1gAke
        ebupS6n1lG30v8xhgfzkQiQSkrqO4mAjCc6uve72ffll3V/ZHmfFtPFwtbq5qPWf830BfN
        9bpmZRiCcL4pIyeOtLvk0KnhqzXO0CQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-4UvyUyTiOZ62hFzLYoz3kA-1; Mon, 03 Feb 2020 22:30:30 -0500
X-MC-Unique: 4UvyUyTiOZ62hFzLYoz3kA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A02A8010E5;
        Tue,  4 Feb 2020 03:30:27 +0000 (UTC)
Received: from [10.72.12.170] (ovpn-12-170.pek2.redhat.com [10.72.12.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF8045D9C5;
        Tue,  4 Feb 2020 03:30:12 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce vDPA based backend
To:     Tiwei Bie <tiwei.bie@intel.com>, mst@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        shahafs@mellanox.com, jgg@mellanox.com, rob.miller@broadcom.com,
        haotian.wang@sifive.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, rdunlap@infradead.org, hch@infradead.org,
        jiri@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
References: <20200131033651.103534-1-tiwei.bie@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
Date:   Tue, 4 Feb 2020 11:30:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200131033651.103534-1-tiwei.bie@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/31 =E4=B8=8A=E5=8D=8811:36, Tiwei Bie wrote:
> This patch introduces a vDPA based vhost backend. This
> backend is built on top of the same interface defined
> in virtio-vDPA and provides a generic vhost interface
> for userspace to accelerate the virtio devices in guest.
>
> This backend is implemented as a vDPA device driver on
> top of the same ops used in virtio-vDPA. It will create
> char device entry named vhost-vdpa/$vdpa_device_index
> for userspace to use. Userspace can use vhost ioctls on
> top of this char device to setup the backend.
>
> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> ---
> This patch depends on below series:
> https://lkml.org/lkml/2020/1/16/353
>
> Please note that _SET_MEM_TABLE isn't fully supported yet.
> Comments would be appreciated!
>
> Changes since last patch (https://lkml.org/lkml/2019/11/18/1068)
> - Switch to the vDPA bus;
> - Switch to vhost's own chardev;
>
>   drivers/vhost/Kconfig            |  12 +
>   drivers/vhost/Makefile           |   3 +
>   drivers/vhost/vdpa.c             | 705 ++++++++++++++++++++++++++++++=
+
>   include/uapi/linux/vhost.h       |  21 +
>   include/uapi/linux/vhost_types.h |   8 +
>   5 files changed, 749 insertions(+)
>   create mode 100644 drivers/vhost/vdpa.c
>
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index f21c45aa5e07..13e6a94d0243 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -34,6 +34,18 @@ config VHOST_VSOCK
>   	To compile this driver as a module, choose M here: the module will b=
e called
>   	vhost_vsock.
>  =20
> +config VHOST_VDPA
> +	tristate "Vhost driver for vDPA based backend"
> +	depends on EVENTFD && VDPA
> +	select VHOST
> +	default n
> +	---help---
> +	This kernel module can be loaded in host kernel to accelerate
> +	guest virtio devices with the vDPA based backends.
> +
> +	To compile this driver as a module, choose M here: the module
> +	will be called vhost_vdpa.
> +
>   config VHOST
>   	tristate
>           depends on VHOST_IOTLB
> diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> index df99756fbb26..a65e9f4a2c0a 100644
> --- a/drivers/vhost/Makefile
> +++ b/drivers/vhost/Makefile
> @@ -10,6 +10,9 @@ vhost_vsock-y :=3D vsock.o
>  =20
>   obj-$(CONFIG_VHOST_RING) +=3D vringh.o
>  =20
> +obj-$(CONFIG_VHOST_VDPA) +=3D vhost_vdpa.o
> +vhost_vdpa-y :=3D vdpa.o
> +
>   obj-$(CONFIG_VHOST)	+=3D vhost.o
>  =20
>   obj-$(CONFIG_VHOST_IOTLB) +=3D vhost_iotlb.o
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> new file mode 100644
> index 000000000000..631d994d37ac
> --- /dev/null
> +++ b/drivers/vhost/vdpa.c
> @@ -0,0 +1,705 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2018-2020 Intel Corporation.
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
> +#include <linux/cdev.h>
> +#include <linux/device.h>
> +#include <linux/uuid.h>
> +#include <linux/vdpa.h>
> +#include <linux/nospec.h>
> +#include <linux/vhost.h>
> +#include <linux/virtio_net.h>
> +
> +#include "vhost.h"
> +
> +enum {
> +	VHOST_VDPA_FEATURES =3D
> +		(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
> +		(1ULL << VIRTIO_F_ANY_LAYOUT) |
> +		(1ULL << VIRTIO_F_VERSION_1) |
> +		(1ULL << VIRTIO_F_IOMMU_PLATFORM) |
> +		(1ULL << VIRTIO_F_RING_PACKED) |
> +		(1ULL << VIRTIO_F_ORDER_PLATFORM) |
> +		(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> +		(1ULL << VIRTIO_RING_F_EVENT_IDX),
> +
> +	VHOST_VDPA_NET_FEATURES =3D VHOST_VDPA_FEATURES |
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
> +#define VHOST_VDPA_VQ_MAX	2
> +
> +struct vhost_vdpa {
> +	/* The lock is to protect this structure. */
> +	struct mutex mutex;
> +	struct vhost_dev vdev;
> +	struct vhost_virtqueue *vqs;
> +	struct vdpa_device *vdpa;
> +	struct device *dev;
> +	atomic_t opened;
> +	int nvqs;
> +	int virtio_id;
> +	int minor;
> +};
> +
> +static struct {
> +	/* The lock is to protect this structure. */
> +	struct mutex mutex;
> +	struct class *class;
> +	struct idr idr;
> +	struct cdev cdev;
> +	dev_t devt;
> +	wait_queue_head_t release_q;
> +} vhost_vdpa;
> +
> +static const u64 vhost_vdpa_features[] =3D {
> +	[VIRTIO_ID_NET] =3D VHOST_VDPA_NET_FEATURES,
> +};
> +
> +static int vhost_vdpa_alloc_minor(struct vhost_vdpa *v)
> +{
> +	return idr_alloc(&vhost_vdpa.idr, v, 0, MINORMASK + 1,
> +			 GFP_KERNEL);
> +}
> +
> +static void vhost_vdpa_free_minor(int minor)
> +{
> +	idr_remove(&vhost_vdpa.idr, minor);
> +}
> +
> +static struct vhost_vdpa *vhost_vdpa_get_from_minor(int minor)
> +{
> +	struct vhost_vdpa *v;
> +
> +	mutex_lock(&vhost_vdpa.mutex);
> +	v =3D idr_find(&vhost_vdpa.idr, minor);
> +	mutex_unlock(&vhost_vdpa.mutex);
> +
> +	return v;
> +}
> +
> +static void handle_vq_kick(struct vhost_work *work)
> +{
> +	struct vhost_virtqueue *vq =3D container_of(work, struct vhost_virtqu=
eue,
> +						  poll.work);
> +	struct vhost_vdpa *v =3D container_of(vq->dev, struct vhost_vdpa, vde=
v);
> +	const struct vdpa_config_ops *ops =3D v->vdpa->config;
> +
> +	ops->kick_vq(v->vdpa, vq - v->vqs);
> +}
> +
> +static irqreturn_t vhost_vdpa_virtqueue_cb(void *private)
> +{
> +	struct vhost_virtqueue *vq =3D private;
> +	struct eventfd_ctx *call_ctx =3D vq->call_ctx;
> +
> +	if (call_ctx)
> +		eventfd_signal(call_ctx, 1);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void vhost_vdpa_reset(struct vhost_vdpa *v)
> +{
> +	struct vdpa_device *vdpa =3D v->vdpa;
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +
> +	ops->set_status(vdpa, 0);
> +}
> +
> +static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *=
argp)
> +{
> +	struct vdpa_device *vdpa =3D v->vdpa;
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	u32 device_id;
> +
> +	device_id =3D ops->get_device_id(vdpa);
> +
> +	if (copy_to_user(argp, &device_id, sizeof(device_id)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static long vhost_vdpa_get_status(struct vhost_vdpa *v, u8 __user *sta=
tusp)
> +{
> +	struct vdpa_device *vdpa =3D v->vdpa;
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	u8 status;
> +
> +	status =3D ops->get_status(vdpa);
> +
> +	if (copy_to_user(statusp, &status, sizeof(status)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *sta=
tusp)
> +{
> +	struct vdpa_device *vdpa =3D v->vdpa;
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	u8 status;
> +
> +	if (copy_from_user(&status, statusp, sizeof(status)))
> +		return -EFAULT;
> +
> +	/*
> +	 * Userspace shouldn't remove status bits unless reset the
> +	 * status to 0.
> +	 */
> +	if (status !=3D 0 && (ops->get_status(vdpa) & ~status) !=3D 0)
> +		return -EINVAL;
> +
> +	ops->set_status(vdpa, status);
> +
> +	return 0;
> +}
> +
> +static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
> +				      struct vhost_vdpa_config *c)
> +{
> +	long size =3D 0;
> +
> +	switch (v->virtio_id) {
> +	case VIRTIO_ID_NET:
> +		size =3D sizeof(struct virtio_net_config);
> +		break;
> +	}
> +
> +	if (c->len =3D=3D 0)
> +		return -EINVAL;
> +
> +	if (c->len > size - c->off)
> +		return -E2BIG;
> +
> +	return 0;
> +}
> +
> +static long vhost_vdpa_get_config(struct vhost_vdpa *v,
> +				  struct vhost_vdpa_config __user *c)
> +{
> +	struct vdpa_device *vdpa =3D v->vdpa;
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	struct vhost_vdpa_config config;
> +	unsigned long size =3D offsetof(struct vhost_vdpa_config, buf);
> +	u8 *buf;
> +
> +	if (copy_from_user(&config, c, size))
> +		return -EFAULT;
> +	if (vhost_vdpa_config_validate(v, &config))
> +		return -EINVAL;
> +	buf =3D kvzalloc(config.len, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	ops->get_config(vdpa, config.off, buf, config.len);
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
> +static long vhost_vdpa_set_config(struct vhost_vdpa *v,
> +				  struct vhost_vdpa_config __user *c)
> +{
> +	struct vdpa_device *vdpa =3D v->vdpa;
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	struct vhost_vdpa_config config;
> +	unsigned long size =3D offsetof(struct vhost_vdpa_config, buf);
> +	u8 *buf;
> +
> +	if (copy_from_user(&config, c, size))
> +		return -EFAULT;
> +	if (vhost_vdpa_config_validate(v, &config))
> +		return -EINVAL;
> +	buf =3D kvzalloc(config.len, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(buf, c->buf, config.len)) {
> +		kvfree(buf);
> +		return -EFAULT;
> +	}
> +
> +	ops->set_config(vdpa, config.off, buf, config.len);
> +
> +	kvfree(buf);
> +	return 0;
> +}
> +
> +static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *=
featurep)
> +{
> +	struct vdpa_device *vdpa =3D v->vdpa;
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	u64 features;
> +
> +	features =3D ops->get_features(vdpa);
> +	features &=3D vhost_vdpa_features[v->virtio_id];
> +
> +	if (copy_to_user(featurep, &features, sizeof(features)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *=
featurep)
> +{
> +	struct vdpa_device *vdpa =3D v->vdpa;
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	u64 features;
> +
> +	/*
> +	 * It's not allowed to change the features after they have
> +	 * been negotiated.
> +	 */
> +	if (ops->get_status(vdpa) & VIRTIO_CONFIG_S_FEATURES_OK)
> +		return -EBUSY;
> +
> +	if (copy_from_user(&features, featurep, sizeof(features)))
> +		return -EFAULT;
> +
> +	if (features & ~vhost_vdpa_features[v->virtio_id])
> +		return -EINVAL;
> +
> +	if (ops->set_features(vdpa, features))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user =
*argp)
> +{
> +	struct vdpa_device *vdpa =3D v->vdpa;
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	u16 num;
> +
> +	num =3D ops->get_vq_num_max(vdpa);
> +
> +	if (copy_to_user(argp, &num, sizeof(num)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int =
cmd,
> +				   void __user *argp)
> +{
> +	struct vdpa_device *vdpa =3D v->vdpa;
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	struct vdpa_callback cb;
> +	struct vhost_virtqueue *vq;
> +	struct vhost_vring_state s;
> +	u8 status;
> +	u32 idx;
> +	long r;
> +
> +	r =3D get_user(idx, (u32 __user *)argp);
> +	if (r < 0)
> +		return r;
> +	if (idx >=3D v->nvqs)
> +		return -ENOBUFS;
> +
> +	idx =3D array_index_nospec(idx, v->nvqs);
> +	vq =3D &v->vqs[idx];
> +
> +	status =3D ops->get_status(vdpa);
> +
> +	/*
> +	 * It's not allowed to detect and program vqs before
> +	 * features negotiation or after enabling driver.
> +	 */
> +	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK) ||
> +	    (status & VIRTIO_CONFIG_S_DRIVER_OK))
> +		return -EBUSY;
> +
> +	if (cmd =3D=3D VHOST_VDPA_SET_VRING_ENABLE) {
> +		if (copy_from_user(&s, argp, sizeof(s)))
> +			return -EFAULT;
> +		ops->set_vq_ready(vdpa, idx, s.num);
> +		return 0;
> +	}
> +
> +	/*
> +	 * It's not allowed to detect and program vqs with
> +	 * vqs enabled.
> +	 */
> +	if (ops->get_vq_ready(vdpa, idx))
> +		return -EBUSY;
> +
> +	if (cmd =3D=3D VHOST_GET_VRING_BASE)
> +		vq->last_avail_idx =3D ops->get_vq_state(v->vdpa, idx);
> +
> +	r =3D vhost_vring_ioctl(&v->vdev, cmd, argp);
> +	if (r)
> +		return r;
> +
> +	switch (cmd) {
> +	case VHOST_SET_VRING_ADDR:
> +		if (ops->set_vq_address(vdpa, idx, (u64)vq->desc,
> +					(u64)vq->avail, (u64)vq->used))
> +			r =3D -EINVAL;
> +		break;
> +
> +	case VHOST_SET_VRING_BASE:
> +		if (ops->set_vq_state(vdpa, idx, vq->last_avail_idx))
> +			r =3D -EINVAL;
> +		break;
> +
> +	case VHOST_SET_VRING_CALL:
> +		if (vq->call_ctx) {
> +			cb.callback =3D vhost_vdpa_virtqueue_cb;
> +			cb.private =3D vq;
> +		} else {
> +			cb.callback =3D NULL;
> +			cb.private =3D NULL;
> +		}
> +		ops->set_vq_cb(vdpa, idx, &cb);
> +		break;
> +
> +	case VHOST_SET_VRING_NUM:
> +		ops->set_vq_num(vdpa, idx, vq->num);
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +static long vhost_vdpa_do_dma_mapping(struct vhost_vdpa *v)
> +{
> +	/* TODO: fix this */


Before trying to do this it looks to me we need the following during the=20
probe

1) if set_map() is not supported by the vDPA device probe the IOMMU that=20
is supported by the vDPA device
2) allocate IOMMU domain

And then:

3) pin pages through GUP and do proper accounting
4) store GPA->HPA mapping in the umem
5) generate diffs of memory table and using IOMMU API to setup the dma=20
mapping in this method

For 1), I'm not sure parent is sufficient for to doing this or need to=20
introduce new API like iommu_device in mdev.


> +	return -ENOTSUPP;
> +}
> +
> +static int vhost_vdpa_open(struct inode *inode, struct file *filep)
> +{
> +	struct vhost_vdpa *v;
> +	struct vhost_dev *dev;
> +	struct vhost_virtqueue **vqs;
> +	int nvqs, i, r, opened;
> +
> +	v =3D vhost_vdpa_get_from_minor(iminor(inode));
> +	if (!v)
> +		return -ENODEV;
> +
> +	opened =3D atomic_cmpxchg(&v->opened, 0, 1);
> +	if (opened) {
> +		r =3D -EBUSY;
> +		goto err;
> +	}
> +
> +	nvqs =3D v->nvqs;
> +	vhost_vdpa_reset(v);
> +
> +	vqs =3D kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
> +	if (!vqs) {
> +		r =3D -ENOMEM;
> +		goto err;
> +	}
> +
> +	dev =3D &v->vdev;
> +	for (i =3D 0; i < nvqs; i++) {
> +		vqs[i] =3D &v->vqs[i];
> +		vqs[i]->handle_kick =3D handle_vq_kick;
> +	}
> +	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0);
> +
> +	filep->private_data =3D v;
> +
> +	return 0;
> +
> +err:
> +	atomic_dec(&v->opened);
> +	return r;
> +}
> +
> +static int vhost_vdpa_release(struct inode *inode, struct file *filep)
> +{
> +	struct vhost_vdpa *v =3D filep->private_data;
> +
> +	mutex_lock(&v->mutex);
> +	filep->private_data =3D NULL;
> +	vhost_vdpa_reset(v);
> +	vhost_dev_stop(&v->vdev);
> +	vhost_dev_cleanup(&v->vdev);
> +	kfree(v->vdev.vqs);
> +	mutex_unlock(&v->mutex);
> +
> +	atomic_dec(&v->opened);
> +	wake_up(&vhost_vdpa.release_q);
> +
> +	return 0;
> +}
> +
> +static long vhost_vdpa_unlocked_ioctl(struct file *filep,
> +				      unsigned int cmd, unsigned long arg)
> +{
> +	struct vhost_vdpa *v =3D filep->private_data;
> +	struct vdpa_device *vdpa =3D v->vdpa;
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	void __user *argp =3D (void __user *)arg;
> +	long r;
> +
> +	mutex_lock(&v->mutex);
> +
> +	switch (cmd) {
> +	case VHOST_VDPA_GET_DEVICE_ID:
> +		r =3D vhost_vdpa_get_device_id(v, argp);
> +		break;
> +	case VHOST_VDPA_GET_STATUS:
> +		r =3D vhost_vdpa_get_status(v, argp);
> +		break;
> +	case VHOST_VDPA_SET_STATUS:
> +		r =3D vhost_vdpa_set_status(v, argp);
> +		break;
> +	case VHOST_VDPA_GET_CONFIG:
> +		r =3D vhost_vdpa_get_config(v, argp);
> +		break;
> +	case VHOST_VDPA_SET_CONFIG:
> +		r =3D vhost_vdpa_set_config(v, argp);
> +		break;
> +	case VHOST_GET_FEATURES:
> +		r =3D vhost_vdpa_get_features(v, argp);
> +		break;
> +	case VHOST_SET_FEATURES:
> +		r =3D vhost_vdpa_set_features(v, argp);
> +		break;
> +	case VHOST_VDPA_GET_VRING_NUM:
> +		r =3D vhost_vdpa_get_vring_num(v, argp);
> +		break;
> +	case VHOST_SET_LOG_BASE:
> +	case VHOST_SET_LOG_FD:
> +		r =3D -ENOIOCTLCMD;
> +		break;
> +	default:
> +		mutex_lock(&v->vdev.mutex);
> +		r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
> +		if (r =3D=3D -ENOIOCTLCMD)
> +			r =3D vhost_vdpa_vring_ioctl(v, cmd, argp);
> +		mutex_unlock(&v->vdev.mutex);
> +		break;
> +	}
> +
> +	if (r)
> +		goto out;
> +
> +	switch (cmd) {
> +	case VHOST_SET_MEM_TABLE:
> +		if (ops->set_map)
> +			r =3D ops->set_map(vdpa, v->vdev.umem);


I think we need do the following to make sure set_map() works:

1) pin pages through GUP and do proper accounting for e.g ulimit
2) using GPA->HPA mapping for dev->umem
3) then there's no need to deal VHOST_SET_MEM_TABLE in=20
vhost_dev_ioctl(), or add some specific callbacks in vhost_set_memory().

Thanks


> +		else
> +			r =3D vhost_vdpa_do_dma_mapping(v);
> +		break;
> +	}
> +
> +out:
> +	mutex_unlock(&v->mutex);
> +	return r;
> +}
> +
> +static const struct file_operations vhost_vdpa_fops =3D {
> +	.owner		=3D THIS_MODULE,
> +	.open		=3D vhost_vdpa_open,
> +	.release	=3D vhost_vdpa_release,
> +	.unlocked_ioctl	=3D vhost_vdpa_unlocked_ioctl,
> +	.compat_ioctl	=3D compat_ptr_ioctl,
> +};
> +
> +static int vhost_vdpa_probe(struct device *dev)
> +{
> +	struct vdpa_device *vdpa =3D dev_to_vdpa(dev);
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	struct vhost_vdpa *v;
> +	struct device *d;
> +	int minor, nvqs;
> +	int r;
> +
> +	/* Currently, we only accept the network devices. */
> +	if (ops->get_device_id(vdpa) !=3D VIRTIO_ID_NET) {
> +		r =3D -ENOTSUPP;
> +		goto err;
> +	}
> +
> +	v =3D kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +	if (!v) {
> +		r =3D -ENOMEM;
> +		goto err;
> +	}
> +
> +	nvqs =3D VHOST_VDPA_VQ_MAX;
> +
> +	v->vqs =3D kmalloc_array(nvqs, sizeof(struct vhost_virtqueue),
> +			       GFP_KERNEL);
> +	if (!v->vqs) {
> +		r =3D -ENOMEM;
> +		goto err_alloc_vqs;
> +	}
> +
> +	mutex_init(&v->mutex);
> +	atomic_set(&v->opened, 0);
> +
> +	v->vdpa =3D vdpa;
> +	v->nvqs =3D nvqs;
> +	v->virtio_id =3D ops->get_device_id(vdpa);
> +
> +	mutex_lock(&vhost_vdpa.mutex);
> +
> +	minor =3D vhost_vdpa_alloc_minor(v);
> +	if (minor < 0) {
> +		r =3D minor;
> +		goto err_alloc_minor;
> +	}
> +
> +	d =3D device_create(vhost_vdpa.class, NULL,
> +			  MKDEV(MAJOR(vhost_vdpa.devt), minor),
> +			  v, "%d", vdpa->index);
> +	if (IS_ERR(d)) {
> +		r =3D PTR_ERR(d);
> +		goto err_device_create;
> +	}
> +
> +	mutex_unlock(&vhost_vdpa.mutex);
> +
> +	v->dev =3D d;
> +	v->minor =3D minor;
> +	dev_set_drvdata(dev, v);
> +
> +	return 0;
> +
> +err_device_create:
> +	vhost_vdpa_free_minor(minor);
> +err_alloc_minor:
> +	mutex_unlock(&vhost_vdpa.mutex);
> +	kfree(v->vqs);
> +err_alloc_vqs:
> +	kfree(v);
> +err:
> +	return r;
> +}
> +
> +static void vhost_vdpa_remove(struct device *dev)
> +{
> +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
> +	struct vhost_vdpa *v =3D dev_get_drvdata(dev);
> +	int opened;
> +
> +	add_wait_queue(&vhost_vdpa.release_q, &wait);
> +
> +	do {
> +		opened =3D atomic_cmpxchg(&v->opened, 0, 1);
> +		if (!opened)
> +			break;
> +		wait_woken(&wait, TASK_UNINTERRUPTIBLE, HZ * 10);
> +	} while (1);
> +
> +	remove_wait_queue(&vhost_vdpa.release_q, &wait);
> +
> +	mutex_lock(&vhost_vdpa.mutex);
> +	device_destroy(vhost_vdpa.class,
> +		       MKDEV(MAJOR(vhost_vdpa.devt), v->minor));
> +	vhost_vdpa_free_minor(v->minor);
> +	mutex_unlock(&vhost_vdpa.mutex);
> +	kfree(v->vqs);
> +	kfree(v);
> +}
> +
> +static struct vdpa_driver vhost_vdpa_driver =3D {
> +	.drv =3D {
> +		.name	=3D "vhost_vdpa",
> +	},
> +	.probe	=3D vhost_vdpa_probe,
> +	.remove	=3D vhost_vdpa_remove,
> +};
> +
> +static char *vhost_vdpa_devnode(struct device *dev, umode_t *mode)
> +{
> +	return kasprintf(GFP_KERNEL, "vhost-vdpa/%s", dev_name(dev));
> +}
> +
> +static int __init vhost_vdpa_init(void)
> +{
> +	int r;
> +
> +	idr_init(&vhost_vdpa.idr);
> +	mutex_init(&vhost_vdpa.mutex);
> +	init_waitqueue_head(&vhost_vdpa.release_q);
> +
> +	/* /dev/vhost-vdpa/$vdpa_device_index */
> +	vhost_vdpa.class =3D class_create(THIS_MODULE, "vhost-vdpa");
> +	if (IS_ERR(vhost_vdpa.class)) {
> +		r =3D PTR_ERR(vhost_vdpa.class);
> +		goto err_class;
> +	}
> +
> +	vhost_vdpa.class->devnode =3D vhost_vdpa_devnode;
> +
> +	r =3D alloc_chrdev_region(&vhost_vdpa.devt, 0, MINORMASK + 1,
> +				"vhost-vdpa");
> +	if (r)
> +		goto err_alloc_chrdev;
> +
> +	cdev_init(&vhost_vdpa.cdev, &vhost_vdpa_fops);
> +	r =3D cdev_add(&vhost_vdpa.cdev, vhost_vdpa.devt, MINORMASK + 1);
> +	if (r)
> +		goto err_cdev_add;
> +
> +	r =3D register_vdpa_driver(&vhost_vdpa_driver);
> +	if (r)
> +		goto err_register_vdpa_driver;
> +
> +	return 0;
> +
> +err_register_vdpa_driver:
> +	cdev_del(&vhost_vdpa.cdev);
> +err_cdev_add:
> +	unregister_chrdev_region(vhost_vdpa.devt, MINORMASK + 1);
> +err_alloc_chrdev:
> +	class_destroy(vhost_vdpa.class);
> +err_class:
> +	idr_destroy(&vhost_vdpa.idr);
> +	return r;
> +}
> +module_init(vhost_vdpa_init);
> +
> +static void __exit vhost_vdpa_exit(void)
> +{
> +	unregister_vdpa_driver(&vhost_vdpa_driver);
> +	cdev_del(&vhost_vdpa.cdev);
> +	unregister_chrdev_region(vhost_vdpa.devt, MINORMASK + 1);
> +	class_destroy(vhost_vdpa.class);
> +	idr_destroy(&vhost_vdpa.idr);
> +}
> +module_exit(vhost_vdpa_exit);
> +
> +MODULE_VERSION("0.0.1");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_DESCRIPTION("vDPA based vhost backend for virtio");
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 40d028eed645..23f6db2106f5 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -116,4 +116,25 @@
>   #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
>   #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
>  =20
> +/* VHOST_VDPA specific defines */
> +
> +/* Get the device id. The device ids follow the same definition of
> + * the device id defined in virtio-spec. */
> +#define VHOST_VDPA_GET_DEVICE_ID	_IOR(VHOST_VIRTIO, 0x70, __u32)
> +/* Get and set the status. The status bits follow the same definition
> + * of the device status defined in virtio-spec. */
> +#define VHOST_VDPA_GET_STATUS		_IOR(VHOST_VIRTIO, 0x71, __u8)
> +#define VHOST_VDPA_SET_STATUS		_IOW(VHOST_VIRTIO, 0x72, __u8)
> +/* Get and set the device config. The device config follows the same
> + * definition of the device config defined in virtio-spec. */
> +#define VHOST_VDPA_GET_CONFIG		_IOR(VHOST_VIRTIO, 0x73, \
> +					     struct vhost_vdpa_config)
> +#define VHOST_VDPA_SET_CONFIG		_IOW(VHOST_VIRTIO, 0x74, \
> +					     struct vhost_vdpa_config)
> +/* Enable/disable the ring. */
> +#define VHOST_VDPA_SET_VRING_ENABLE	_IOW(VHOST_VIRTIO, 0x75, \
> +					     struct vhost_vring_state)
> +/* Get the max ring size. */
> +#define VHOST_VDPA_GET_VRING_NUM	_IOR(VHOST_VIRTIO, 0x76, __u16)
> +
>   #endif
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhos=
t_types.h
> index c907290ff065..669457ce5c48 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -119,6 +119,14 @@ struct vhost_scsi_target {
>   	unsigned short reserved;
>   };
>  =20
> +/* VHOST_VDPA specific definitions */
> +
> +struct vhost_vdpa_config {
> +	__u32 off;
> +	__u32 len;
> +	__u8 buf[0];
> +};
> +
>   /* Feature bits */
>   /* Log all write descriptors. Can be changed while device is active. =
*/
>   #define VHOST_F_LOG_ALL 26

