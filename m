Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B91BAE0513
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 15:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388792AbfJVNbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 09:31:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60392 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732065AbfJVNbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 09:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571751060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aqfgTzYyyjwNir9aBEidZY2YXyw6cijRYkKXL3dpFUY=;
        b=bth30Jauach2H7vABo162fXLubG+9kpO+Ihg8fPP1gOjGHNs+c4+wmAvNLH4nOyOnJ1T46
        iPej13zKFs76amK60BZB+vdhZfs1ChpUWLljC0nt0zC6wlaZDgNa0PSq/bUCDDZUFT9GgG
        nHGHVE3fnKmXzLQ9uaflvwQf/0+EZ/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-cHX-FodvMUe-9PnCZqEIBg-1; Tue, 22 Oct 2019 09:30:56 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62D4D107AD33;
        Tue, 22 Oct 2019 13:30:55 +0000 (UTC)
Received: from [10.72.12.23] (ovpn-12-23.pek2.redhat.com [10.72.12.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB90D6062D;
        Tue, 22 Oct 2019 13:30:19 +0000 (UTC)
Subject: Re: [PATCH v2] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, maxime.coquelin@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
References: <20191022095230.2514-1-tiwei.bie@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <47a572fd-5597-1972-e177-8ee25ca51247@redhat.com>
Date:   Tue, 22 Oct 2019 21:30:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191022095230.2514-1-tiwei.bie@intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: cHX-FodvMUe-9PnCZqEIBg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/22 =E4=B8=8B=E5=8D=885:52, Tiwei Bie wrote:
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
> https://lkml.org/lkml/2019/10/17/286
>
> v1 -> v2:
> - Replace _SET_STATE with _SET_STATUS (MST);
> - Check status bits at each step (MST);
> - Report the max ring size and max number of queues (MST);
> - Add missing MODULE_DEVICE_TABLE (Jason);
> - Only support the network backend w/o multiqueue for now;


Any idea on how to extend it to support devices other than net? I think=20
we want a generic API or an API that could be made generic in the future.

Do we want to e.g having a generic vhost mdev for all kinds of devices=20
or introducing e.g vhost-net-mdev and vhost-scsi-mdev?


> - Some minor fixes and improvements;
> - Rebase on top of virtio-mdev series v4;
>
> RFC v4 -> v1:
> - Implement vhost-mdev as a mdev device driver directly and
>    connect it to VFIO container/group. (Jason);
> - Pass ring addresses as GPAs/IOVAs in vhost-mdev to avoid
>    meaningless HVA->GPA translations (Jason);
>
> RFC v3 -> RFC v4:
> - Build vhost-mdev on top of the same abstraction used by
>    virtio-mdev (Jason);
> - Introduce vhost fd and pass VFIO fd via SET_BACKEND ioctl (MST);
>
> RFC v2 -> RFC v3:
> - Reuse vhost's ioctls instead of inventing a VFIO regions/irqs
>    based vhost protocol on top of vfio-mdev (Jason);
>
> RFC v1 -> RFC v2:
> - Introduce a new VFIO device type to build a vhost protocol
>    on top of vfio-mdev;
>
>   drivers/vfio/mdev/mdev_core.c |  12 +
>   drivers/vhost/Kconfig         |   9 +
>   drivers/vhost/Makefile        |   3 +
>   drivers/vhost/mdev.c          | 415 ++++++++++++++++++++++++++++++++++
>   include/linux/mdev.h          |   3 +
>   include/uapi/linux/vhost.h    |  13 ++
>   6 files changed, 455 insertions(+)
>   create mode 100644 drivers/vhost/mdev.c
>
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.=
c
> index 5834f6b7c7a5..2963f65e6648 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -69,6 +69,18 @@ void mdev_set_virtio_ops(struct mdev_device *mdev,
>   }
>   EXPORT_SYMBOL(mdev_set_virtio_ops);
>  =20
> +/* Specify the vhost device ops for the mdev device, this
> + * must be called during create() callback for vhost mdev device.
> + */
> +void mdev_set_vhost_ops(struct mdev_device *mdev,
> +=09=09=09const struct virtio_mdev_device_ops *vhost_ops)
> +{
> +=09WARN_ON(mdev->class_id);
> +=09mdev->class_id =3D MDEV_CLASS_ID_VHOST;
> +=09mdev->device_ops =3D vhost_ops;
> +}
> +EXPORT_SYMBOL(mdev_set_vhost_ops);
> +
>   const void *mdev_get_dev_ops(struct mdev_device *mdev)
>   {
>   =09return mdev->device_ops;
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 3d03ccbd1adc..7b5c2f655af7 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -34,6 +34,15 @@ config VHOST_VSOCK
>   =09To compile this driver as a module, choose M here: the module will b=
e called
>   =09vhost_vsock.
>  =20
> +config VHOST_MDEV
> +=09tristate "Vhost driver for Mediated devices"
> +=09depends on EVENTFD && VFIO && VFIO_MDEV
> +=09select VHOST
> +=09default n
> +=09---help---
> +=09Say M here to enable the vhost_mdev module for use with
> +=09the mediated device based hardware vhost accelerators.
> +
>   config VHOST
>   =09tristate
>   =09---help---
> diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> index 6c6df24f770c..ad9c0f8c6d8c 100644
> --- a/drivers/vhost/Makefile
> +++ b/drivers/vhost/Makefile
> @@ -10,4 +10,7 @@ vhost_vsock-y :=3D vsock.o
>  =20
>   obj-$(CONFIG_VHOST_RING) +=3D vringh.o
>  =20
> +obj-$(CONFIG_VHOST_MDEV) +=3D vhost_mdev.o
> +vhost_mdev-y :=3D mdev.o
> +
>   obj-$(CONFIG_VHOST)=09+=3D vhost.o
> diff --git a/drivers/vhost/mdev.c b/drivers/vhost/mdev.c
> new file mode 100644
> index 000000000000..5f9cae61018c
> --- /dev/null
> +++ b/drivers/vhost/mdev.c
> @@ -0,0 +1,415 @@
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
> +#include <linux/virtio_ids.h>
> +
> +#include "vhost.h"
> +
> +/* Currently, only network backend w/o multiqueue is supported. */
> +#define VHOST_MDEV_VQ_MAX=092
> +
> +struct vhost_mdev {
> +=09/* The lock is to protect this structure. */
> +=09struct mutex mutex;
> +=09struct vhost_dev dev;
> +=09struct vhost_virtqueue *vqs;
> +=09int nvqs;
> +=09u64 status;
> +=09u64 features;
> +=09u64 acked_features;
> +=09bool opened;
> +=09struct mdev_device *mdev;
> +};
> +
> +static void handle_vq_kick(struct vhost_work *work)
> +{
> +=09struct vhost_virtqueue *vq =3D container_of(work, struct vhost_virtqu=
eue,
> +=09=09=09=09=09=09  poll.work);
> +=09struct vhost_mdev *m =3D container_of(vq->dev, struct vhost_mdev, dev=
);
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_dev_ops(m->mdev=
);
> +
> +=09ops->kick_vq(m->mdev, vq - m->vqs);
> +}
> +
> +static irqreturn_t vhost_mdev_virtqueue_cb(void *private)
> +{
> +=09struct vhost_virtqueue *vq =3D private;
> +=09struct eventfd_ctx *call_ctx =3D vq->call_ctx;
> +
> +=09if (call_ctx)
> +=09=09eventfd_signal(call_ctx, 1);
> +=09return IRQ_HANDLED;
> +}
> +
> +static void vhost_mdev_reset(struct vhost_mdev *m)
> +{
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_dev_ops(mdev);
> +
> +=09m->status =3D 0;
> +=09return ops->set_status(mdev, m->status);
> +}
> +
> +static long vhost_mdev_get_status(struct vhost_mdev *m, u8 __user *statu=
sp)
> +{
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_dev_ops(m->mdev=
);
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09u8 status;
> +
> +=09status =3D ops->get_status(mdev);
> +=09m->status =3D status;
> +
> +=09if (copy_to_user(statusp, &status, sizeof(status)))
> +=09=09return -EFAULT;
> +
> +=09return 0;
> +}
> +
> +static long vhost_mdev_set_status(struct vhost_mdev *m, u8 __user *statu=
sp)
> +{
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_dev_ops(m->mdev=
);
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09u8 status;
> +
> +=09if (copy_from_user(&status, statusp, sizeof(status)))
> +=09=09return -EFAULT;
> +
> +=09/*
> +=09 * Userspace shouldn't remove status bits unless reset the
> +=09 * status to 0.
> +=09 */
> +=09if (status !=3D 0 && (m->status & ~status) !=3D 0)
> +=09=09return -EINVAL;


We don't cache vq ready information but we cache status and features=20
here, any reason for this?


> +
> +=09ops->set_status(mdev, status);
> +=09m->status =3D ops->get_status(mdev);
> +
> +=09return 0;
> +}
> +
> +static long vhost_mdev_get_features(struct vhost_mdev *m, u64 __user *fe=
aturep)
> +{
> +=09if (copy_to_user(featurep, &m->features, sizeof(m->features)))
> +=09=09return -EFAULT;


As discussed in previous version do we need to filter out MQ feature here?


> +=09return 0;
> +}
> +
> +static long vhost_mdev_set_features(struct vhost_mdev *m, u64 __user *fe=
aturep)
> +{
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_dev_ops(m->mdev=
);
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09u64 features;
> +
> +=09/*
> +=09 * It's not allowed to change the features after they have
> +=09 * been negotiated.
> +=09 */
> +=09if (m->status & VIRTIO_CONFIG_S_FEATURES_OK)
> +=09=09return -EPERM;


-EBUSY?


> +
> +=09if (copy_from_user(&features, featurep, sizeof(features)))
> +=09=09return -EFAULT;
> +
> +=09if (features & ~m->features)
> +=09=09return -EINVAL;
> +
> +=09m->acked_features =3D features;
> +=09if (ops->set_features(mdev, m->acked_features))
> +=09=09return -ENODEV;


-EINVAL should be better, this would be more obvious for parent that=20
wants to force any feature.


> +
> +=09return 0;
> +}
> +
> +static long vhost_mdev_get_vring_num(struct vhost_mdev *m, u16 __user *a=
rgp)
> +{
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_dev_ops(m->mdev=
);
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09u16 num;
> +
> +=09num =3D ops->get_vq_num_max(mdev);
> +
> +=09if (copy_to_user(argp, &num, sizeof(num)))
> +=09=09return -EFAULT;
> +=09return 0;
> +}
> +
> +static long vhost_mdev_get_queue_num(struct vhost_mdev *m, u32 __user *a=
rgp)
> +{
> +=09u32 nvqs =3D m->nvqs;
> +
> +=09if (copy_to_user(argp, &nvqs, sizeof(nvqs)))
> +=09=09return -EFAULT;
> +=09return 0;
> +}
> +
> +static long vhost_mdev_vring_ioctl(struct vhost_mdev *m, unsigned int cm=
d,
> +=09=09=09=09   void __user *argp)
> +{
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_dev_ops(m->mdev=
);
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09struct virtio_mdev_callback cb;
> +=09struct vhost_virtqueue *vq;
> +=09struct vhost_vring_state s;
> +=09u32 idx;
> +=09long r;
> +
> +=09r =3D get_user(idx, (u32 __user *)argp);
> +=09if (r < 0)
> +=09=09return r;
> +=09if (idx >=3D m->nvqs)
> +=09=09return -ENOBUFS;
> +
> +=09/*
> +=09 * It's not allowed to detect and program vqs before
> +=09 * features negotiation or after enabling driver.
> +=09 */
> +=09if (!(m->status & VIRTIO_CONFIG_S_FEATURES_OK) ||
> +=09    (m->status & VIRTIO_CONFIG_S_DRIVER_OK))
> +=09=09return -EPERM;


So the question is: is it better to do this in parent or not?


> +
> +=09vq =3D &m->vqs[idx];
> +
> +=09if (cmd =3D=3D VHOST_MDEV_SET_VRING_ENABLE) {
> +=09=09if (copy_from_user(&s, argp, sizeof(s)))
> +=09=09=09return -EFAULT;
> +=09=09ops->set_vq_ready(mdev, idx, s.num);
> +=09=09return 0;
> +=09}
> +
> +=09/*
> +=09 * It's not allowed to detect and program vqs with
> +=09 * vqs enabled.
> +=09 */
> +=09if (ops->get_vq_ready(mdev, idx))
> +=09=09return -EPERM;
> +
> +=09if (cmd =3D=3D VHOST_GET_VRING_BASE)
> +=09=09vq->last_avail_idx =3D ops->get_vq_state(m->mdev, idx);
> +
> +=09r =3D vhost_vring_ioctl(&m->dev, cmd, argp);
> +=09if (r)
> +=09=09return r;
> +
> +=09switch (cmd) {
> +=09case VHOST_SET_VRING_ADDR:
> +=09=09/*
> +=09=09 * In vhost-mdev, the ring addresses set by userspace should
> +=09=09 * be the DMA addresses within the VFIO container/group.
> +=09=09 */
> +=09=09if (ops->set_vq_address(mdev, idx, (u64)vq->desc,
> +=09=09=09=09=09(u64)vq->avail, (u64)vq->used))
> +=09=09=09r =3D -ENODEV;
> +=09=09break;
> +
> +=09case VHOST_SET_VRING_BASE:
> +=09=09if (ops->set_vq_state(mdev, idx, vq->last_avail_idx))
> +=09=09=09r =3D -ENODEV;
> +=09=09break;
> +
> +=09case VHOST_SET_VRING_CALL:
> +=09=09if (vq->call_ctx) {
> +=09=09=09cb.callback =3D vhost_mdev_virtqueue_cb;
> +=09=09=09cb.private =3D vq;
> +=09=09} else {
> +=09=09=09cb.callback =3D NULL;
> +=09=09=09cb.private =3D NULL;
> +=09=09}
> +=09=09ops->set_vq_cb(mdev, idx, &cb);
> +=09=09break;
> +
> +=09case VHOST_SET_VRING_NUM:
> +=09=09ops->set_vq_num(mdev, idx, vq->num);
> +=09=09break;
> +=09}
> +
> +=09return r;
> +}
> +
> +static int vhost_mdev_open(void *device_data)
> +{
> +=09struct vhost_mdev *m =3D device_data;
> +=09struct vhost_dev *dev;
> +=09struct vhost_virtqueue **vqs;
> +=09int nvqs, i, r;
> +
> +=09if (!try_module_get(THIS_MODULE))
> +=09=09return -ENODEV;
> +
> +=09mutex_lock(&m->mutex);
> +
> +=09if (m->opened) {
> +=09=09r =3D -EBUSY;
> +=09=09goto err;
> +=09}
> +
> +=09nvqs =3D m->nvqs;
> +=09vhost_mdev_reset(m);
> +
> +=09memset(&m->dev, 0, sizeof(m->dev));
> +=09memset(m->vqs, 0, nvqs * sizeof(struct vhost_virtqueue));
> +
> +=09vqs =3D kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
> +=09if (!vqs) {
> +=09=09r =3D -ENOMEM;
> +=09=09goto err;
> +=09}
> +
> +=09dev =3D &m->dev;
> +=09for (i =3D 0; i < nvqs; i++) {
> +=09=09vqs[i] =3D &m->vqs[i];
> +=09=09vqs[i]->handle_kick =3D handle_vq_kick;
> +=09}
> +=09vhost_dev_init(dev, vqs, nvqs, 0, 0, 0);
> +=09m->opened =3D true;
> +=09mutex_unlock(&m->mutex);
> +
> +=09return 0;
> +
> +err:
> +=09mutex_unlock(&m->mutex);
> +=09module_put(THIS_MODULE);
> +=09return r;
> +}
> +
> +static void vhost_mdev_release(void *device_data)
> +{
> +=09struct vhost_mdev *m =3D device_data;
> +
> +=09mutex_lock(&m->mutex);
> +=09vhost_mdev_reset(m);
> +=09vhost_dev_stop(&m->dev);
> +=09vhost_dev_cleanup(&m->dev);
> +
> +=09kfree(m->dev.vqs);
> +=09m->opened =3D false;
> +=09mutex_unlock(&m->mutex);
> +=09module_put(THIS_MODULE);
> +}
> +
> +static long vhost_mdev_unlocked_ioctl(void *device_data,
> +=09=09=09=09      unsigned int cmd, unsigned long arg)
> +{
> +=09struct vhost_mdev *m =3D device_data;
> +=09void __user *argp =3D (void __user *)arg;
> +=09long r;
> +
> +=09mutex_lock(&m->mutex);
> +
> +=09switch (cmd) {
> +=09case VHOST_MDEV_GET_STATUS:
> +=09=09r =3D vhost_mdev_get_status(m, argp);
> +=09=09break;
> +=09case VHOST_MDEV_SET_STATUS:
> +=09=09r =3D vhost_mdev_set_status(m, argp);
> +=09=09break;
> +=09case VHOST_GET_FEATURES:
> +=09=09r =3D vhost_mdev_get_features(m, argp);
> +=09=09break;
> +=09case VHOST_SET_FEATURES:
> +=09=09r =3D vhost_mdev_set_features(m, argp);
> +=09=09break;
> +=09case VHOST_MDEV_GET_VRING_NUM:
> +=09=09r =3D vhost_mdev_get_vring_num(m, argp);
> +=09=09break;
> +=09case VHOST_MDEV_GET_QUEUE_NUM:
> +=09=09r =3D vhost_mdev_get_queue_num(m, argp);
> +=09=09break;


It's not clear to me that how this API will be used by userspace? I=20
think e.g features without MQ implies the queue num here.


> +=09default:
> +=09=09r =3D vhost_dev_ioctl(&m->dev, cmd, argp);


I believe having SET_MEM_TABLE/SET_LOG_BASE/SET_LOG_FD=C2=A0 is for future=
=20
support of those features. If it's true need add some comments on this.


> +=09=09if (r =3D=3D -ENOIOCTLCMD)
> +=09=09=09r =3D vhost_mdev_vring_ioctl(m, cmd, argp);
> +=09}
> +
> +=09mutex_unlock(&m->mutex);
> +=09return r;
> +}
> +
> +static const struct vfio_device_ops vfio_vhost_mdev_dev_ops =3D {
> +=09.name=09=09=3D "vfio-vhost-mdev",
> +=09.open=09=09=3D vhost_mdev_open,
> +=09.release=09=3D vhost_mdev_release,
> +=09.ioctl=09=09=3D vhost_mdev_unlocked_ioctl,
> +};
> +
> +static int vhost_mdev_probe(struct device *dev)
> +{
> +=09struct mdev_device *mdev =3D mdev_from_dev(dev);
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_dev_ops(mdev);
> +=09struct vhost_mdev *m;
> +=09int nvqs, r;
> +
> +=09/* Currently, only network backend is supported. */
> +=09if (ops->get_device_id(mdev) !=3D VIRTIO_ID_NET)
> +=09=09return -ENOTSUPP;


If we decide to go with the way of vhost-net-mdev, probably need=20
something smarter. E.g a vhost bus etc.


> +
> +=09if (ops->get_mdev_features(mdev) !=3D VIRTIO_MDEV_F_VERSION_1)
> +=09=09return -ENOTSUPP;
> +
> +=09m =3D devm_kzalloc(dev, sizeof(*m), GFP_KERNEL | __GFP_RETRY_MAYFAIL)=
;
> +=09if (!m)
> +=09=09return -ENOMEM;
> +
> +=09nvqs =3D VHOST_MDEV_VQ_MAX;
> +=09m->nvqs =3D nvqs;
> +
> +=09m->vqs =3D devm_kmalloc_array(dev, nvqs, sizeof(struct vhost_virtqueu=
e),
> +=09=09=09=09    GFP_KERNEL);
> +=09if (!m->vqs)
> +=09=09return -ENOMEM;


Is it better to move those allocation to open? Otherwise the memset=20
there seems strange.


> +
> +=09r =3D vfio_add_group_dev(dev, &vfio_vhost_mdev_dev_ops, m);
> +=09if (r)
> +=09=09return r;
> +
> +=09mutex_init(&m->mutex);
> +=09m->features =3D ops->get_features(mdev);
> +=09m->mdev =3D mdev;
> +=09return 0;
> +}
> +
> +static void vhost_mdev_remove(struct device *dev)
> +{
> +=09struct vhost_mdev *m;
> +
> +=09m =3D vfio_del_group_dev(dev);
> +=09mutex_destroy(&m->mutex);
> +}
> +
> +static const struct mdev_class_id vhost_mdev_match[] =3D {
> +=09{ MDEV_CLASS_ID_VHOST },
> +=09{ 0 },
> +};
> +MODULE_DEVICE_TABLE(mdev, vhost_mdev_match);
> +
> +static struct mdev_driver vhost_mdev_driver =3D {
> +=09.name=09=3D "vhost_mdev",
> +=09.probe=09=3D vhost_mdev_probe,
> +=09.remove=09=3D vhost_mdev_remove,
> +=09.id_table =3D vhost_mdev_match,
> +};
> +
> +static int __init vhost_mdev_init(void)
> +{
> +=09return mdev_register_driver(&vhost_mdev_driver, THIS_MODULE);
> +}
> +module_init(vhost_mdev_init);
> +
> +static void __exit vhost_mdev_exit(void)
> +{
> +=09mdev_unregister_driver(&vhost_mdev_driver);
> +}
> +module_exit(vhost_mdev_exit);
> +
> +MODULE_VERSION("0.0.1");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Mediated device based accelerator for virtio");
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 13e045e09d3b..6060cdbe6d3e 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -114,6 +114,8 @@ void mdev_set_vfio_ops(struct mdev_device *mdev,
>   =09=09       const struct vfio_mdev_device_ops *vfio_ops);
>   void mdev_set_virtio_ops(struct mdev_device *mdev,
>                            const struct virtio_mdev_device_ops *virtio_op=
s);
> +void mdev_set_vhost_ops(struct mdev_device *mdev,
> +=09=09=09const struct virtio_mdev_device_ops *vhost_ops);
>   const void *mdev_get_dev_ops(struct mdev_device *mdev);
>  =20
>   extern struct bus_type mdev_bus_type;
> @@ -131,6 +133,7 @@ struct mdev_device *mdev_from_dev(struct device *dev)=
;
>   enum {
>   =09MDEV_CLASS_ID_VFIO =3D 1,
>   =09MDEV_CLASS_ID_VIRTIO =3D 2,
> +=09MDEV_CLASS_ID_VHOST =3D 3,
>   =09/* New entries must be added here */
>   };
>  =20
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 40d028eed645..dad3c62bd91b 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -116,4 +116,17 @@
>   #define VHOST_VSOCK_SET_GUEST_CID=09_IOW(VHOST_VIRTIO, 0x60, __u64)
>   #define VHOST_VSOCK_SET_RUNNING=09=09_IOW(VHOST_VIRTIO, 0x61, int)
>  =20
> +/* VHOST_MDEV specific defines */
> +
> +/* Get and set the status of the backend. The status bits follow the
> + * same definition of the device status defined in virtio-spec. */
> +#define VHOST_MDEV_GET_STATUS=09=09_IOW(VHOST_VIRTIO, 0x70, __u8)
> +#define VHOST_MDEV_SET_STATUS=09=09_IOW(VHOST_VIRTIO, 0x71, __u8)
> +/* Enable/disable the ring. */
> +#define VHOST_MDEV_SET_VRING_ENABLE=09_IOW(VHOST_VIRTIO, 0x72, struct vh=
ost_vring_state)
> +/* Get the max ring size. */
> +#define VHOST_MDEV_GET_VRING_NUM=09_IOW(VHOST_VIRTIO, 0x73, __u16)
> +/* Get the max number of queues. */
> +#define VHOST_MDEV_GET_QUEUE_NUM=09_IOW(VHOST_VIRTIO, 0x74, __u32)


Do we need API for userspace to get backend capability? (that calls=20
get_mdev_device_features())

Thanks


> +
>   #endif

