Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB337E94DE
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 02:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfJ3B4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 21:56:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33513 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726025AbfJ3B4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 21:56:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572400598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n/MdHROwN4lHzYHWdnTaEKzeC0byJUN60gV1MfZdi6g=;
        b=XniAcgBJja1ZKuZYyZ0QFCVnbEfYFDi4NyG53NqnlRs96iVLc6pF7dLC47rTZdfbxflHr3
        Y000NRl5cYM9EQvbKXC3B7biszGLLpcFzJt9FQq4C4Xj+r8mHiY2WFsshoEwIuYE220GGX
        CqaOGD2ZIH71g8s3HkaNBt0OfxhJkj4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-niujm1rwPNuQc2cOmE2Jtg-1; Tue, 29 Oct 2019 21:56:34 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85C24476;
        Wed, 30 Oct 2019 01:56:33 +0000 (UTC)
Received: from [10.72.12.223] (ovpn-12-223.pek2.redhat.com [10.72.12.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D0BF5C1D8;
        Wed, 30 Oct 2019 01:55:57 +0000 (UTC)
Subject: Re: [PATCH v3] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, maxime.coquelin@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
References: <20191029100734.9861-1-tiwei.bie@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e653058c-d480-2195-8915-7bf7378ac76e@redhat.com>
Date:   Wed, 30 Oct 2019 09:55:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191029100734.9861-1-tiwei.bie@intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: niujm1rwPNuQc2cOmE2Jtg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/29 =E4=B8=8B=E5=8D=886:07, Tiwei Bie wrote:
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


Hi Tiwei:

The patch looks good overall, just few comments & nits.


>
> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> ---
> This patch depends on below series:
> https://lkml.org/lkml/2019/10/23/614
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
>  drivers/vfio/mdev/mdev_core.c    |  20 ++
>  drivers/vfio/mdev/mdev_private.h |   1 +
>  drivers/vhost/Kconfig            |  12 +
>  drivers/vhost/Makefile           |   3 +
>  drivers/vhost/mdev.c             | 554 +++++++++++++++++++++++++++++++
>  include/linux/mdev.h             |   5 +
>  include/uapi/linux/vhost.h       |  18 +
>  include/uapi/linux/vhost_types.h |   8 +
>  8 files changed, 621 insertions(+)
>  create mode 100644 drivers/vhost/mdev.c
>
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.=
c
> index 9b00c3513120..3cfd787d605c 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -96,6 +96,26 @@ mdev_get_virtio_ops(struct mdev_device *mdev)
>  }
>  EXPORT_SYMBOL(mdev_get_virtio_ops);
> =20
> +/* Specify the vhost device ops for the mdev device, this
> + * must be called during create() callback for vhost mdev device.
> + */
> +void mdev_set_vhost_ops(struct mdev_device *mdev,
> +=09=09=09const struct virtio_mdev_device_ops *vhost_ops)
> +{
> +=09mdev_set_class(mdev, MDEV_CLASS_ID_VHOST);
> +=09mdev->vhost_ops =3D vhost_ops;
> +}
> +EXPORT_SYMBOL(mdev_set_vhost_ops);
> +
> +/* Get the vhost device ops for the mdev device. */
> +const struct virtio_mdev_device_ops *
> +mdev_get_vhost_ops(struct mdev_device *mdev)
> +{
> +=09WARN_ON(mdev->class_id !=3D MDEV_CLASS_ID_VHOST);
> +=09return mdev->vhost_ops;
> +}
> +EXPORT_SYMBOL(mdev_get_vhost_ops);
> +
>  struct device *mdev_dev(struct mdev_device *mdev)
>  {
>  =09return &mdev->dev;
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_pr=
ivate.h
> index 7b47890c34e7..5597c846e52f 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -40,6 +40,7 @@ struct mdev_device {
>  =09union {
>  =09=09const struct vfio_mdev_device_ops *vfio_ops;
>  =09=09const struct virtio_mdev_device_ops *virtio_ops;
> +=09=09const struct virtio_mdev_device_ops *vhost_ops;
>  =09};
>  };
> =20
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 3d03ccbd1adc..062cada28f89 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -34,6 +34,18 @@ config VHOST_VSOCK
>  =09To compile this driver as a module, choose M here: the module will be=
 called
>  =09vhost_vsock.
> =20
> +config VHOST_MDEV
> +=09tristate "Vhost driver for Mediated devices"
> +=09depends on EVENTFD && VFIO && VFIO_MDEV
> +=09select VHOST
> +=09default n
> +=09---help---
> +=09This kernel module can be loaded in host kernel to accelerate
> +=09guest virtio devices with the mediated device based backends.
> +
> +=09To compile this driver as a module, choose M here: the module will
> +=09be called vhost_mdev.
> +
>  config VHOST
>  =09tristate
>  =09---help---
> diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> index 6c6df24f770c..ad9c0f8c6d8c 100644
> --- a/drivers/vhost/Makefile
> +++ b/drivers/vhost/Makefile
> @@ -10,4 +10,7 @@ vhost_vsock-y :=3D vsock.o
> =20
>  obj-$(CONFIG_VHOST_RING) +=3D vringh.o
> =20
> +obj-$(CONFIG_VHOST_MDEV) +=3D vhost_mdev.o
> +vhost_mdev-y :=3D mdev.o
> +
>  obj-$(CONFIG_VHOST)=09+=3D vhost.o
> diff --git a/drivers/vhost/mdev.c b/drivers/vhost/mdev.c
> new file mode 100644
> index 000000000000..35b2fb33e686
> --- /dev/null
> +++ b/drivers/vhost/mdev.c
> @@ -0,0 +1,554 @@
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
> +#include <linux/vfio.h>
> +#include <linux/vhost.h>
> +#include <linux/virtio_net.h>
> +#include <linux/virtio_mdev_ops.h>
> +
> +#include "vhost.h"
> +
> +enum {
> +=09VHOST_MDEV_FEATURES =3D
> +=09=09(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
> +=09=09(1ULL << VIRTIO_F_ANY_LAYOUT) |
> +=09=09(1ULL << VIRTIO_F_VERSION_1) |
> +=09=09(1ULL << VIRTIO_F_IOMMU_PLATFORM) |
> +=09=09(1ULL << VIRTIO_F_RING_PACKED) |
> +=09=09(1ULL << VIRTIO_F_ORDER_PLATFORM) |
> +=09=09(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> +=09=09(1ULL << VIRTIO_RING_F_EVENT_IDX),
> +
> +=09VHOST_MDEV_NET_FEATURES =3D VHOST_MDEV_FEATURES |
> +=09=09(1ULL << VIRTIO_NET_F_CSUM) |
> +=09=09(1ULL << VIRTIO_NET_F_GUEST_CSUM) |
> +=09=09(1ULL << VIRTIO_NET_F_MTU) |
> +=09=09(1ULL << VIRTIO_NET_F_MAC) |
> +=09=09(1ULL << VIRTIO_NET_F_GUEST_TSO4) |
> +=09=09(1ULL << VIRTIO_NET_F_GUEST_TSO6) |
> +=09=09(1ULL << VIRTIO_NET_F_GUEST_ECN) |
> +=09=09(1ULL << VIRTIO_NET_F_GUEST_UFO) |
> +=09=09(1ULL << VIRTIO_NET_F_HOST_TSO4) |
> +=09=09(1ULL << VIRTIO_NET_F_HOST_TSO6) |
> +=09=09(1ULL << VIRTIO_NET_F_HOST_ECN) |
> +=09=09(1ULL << VIRTIO_NET_F_HOST_UFO) |
> +=09=09(1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> +=09=09(1ULL << VIRTIO_NET_F_STATUS) |
> +=09=09(1ULL << VIRTIO_NET_F_SPEED_DUPLEX),
> +};
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
> +=09int virtio_id;
> +=09bool opened;
> +=09struct mdev_device *mdev;
> +};
> +
> +static const u64 vhost_mdev_features[] =3D {
> +=09[VIRTIO_ID_NET] =3D VHOST_MDEV_NET_FEATURES,
> +};
> +
> +static void handle_vq_kick(struct vhost_work *work)
> +{
> +=09struct vhost_virtqueue *vq =3D container_of(work, struct vhost_virtqu=
eue,
> +=09=09=09=09=09=09  poll.work);
> +=09struct vhost_mdev *m =3D container_of(vq->dev, struct vhost_mdev, dev=
);
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(m->md=
ev);
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
> +
> +=09return IRQ_HANDLED;
> +}
> +
> +static void vhost_mdev_reset(struct vhost_mdev *m)
> +{
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(mdev)=
;
> +
> +=09ops->set_status(mdev, 0);
> +}
> +
> +static long vhost_mdev_get_device_id(struct vhost_mdev *m, u8 __user *ar=
gp)
> +{
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(mdev)=
;
> +=09u32 device_id;
> +
> +=09device_id =3D ops->get_device_id(mdev);
> +
> +=09if (copy_to_user(argp, &device_id, sizeof(device_id)))
> +=09=09return -EFAULT;
> +
> +=09return 0;
> +}


I believe we need get_vendor_id() as well?


> +
> +static long vhost_mdev_get_status(struct vhost_mdev *m, u8 __user *statu=
sp)
> +{
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(mdev)=
;
> +=09u8 status;
> +
> +=09status =3D ops->get_status(mdev);
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
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(mdev)=
;
> +=09u8 status;
> +
> +=09if (copy_from_user(&status, statusp, sizeof(status)))
> +=09=09return -EFAULT;
> +
> +=09/*
> +=09 * Userspace shouldn't remove status bits unless reset the
> +=09 * status to 0.
> +=09 */
> +=09if (status !=3D 0 && (ops->get_status(mdev) & ~status) !=3D 0)
> +=09=09return -EINVAL;
> +
> +=09ops->set_status(mdev, status);
> +
> +=09return 0;
> +}
> +
> +static int vhost_mdev_config_validate(struct vhost_mdev *m,
> +=09=09=09=09      struct vhost_mdev_config *c)
> +{
> +=09long size =3D 0;
> +
> +=09switch (m->virtio_id) {
> +=09case VIRTIO_ID_NET:
> +=09=09size =3D sizeof(struct virtio_net_config);
> +=09=09break;
> +=09}
> +
> +=09if (c->len =3D=3D 0)
> +=09=09return -EINVAL;
> +
> +=09if (c->off >=3D size || c->len > size || c->off + c->len > size)
> +=09=09return -E2BIG;
> +
> +=09return 0;
> +}
> +
> +static long vhost_mdev_get_config(struct vhost_mdev *m,
> +=09=09=09=09  struct vhost_mdev_config __user *c)
> +{
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(mdev)=
;
> +=09struct vhost_mdev_config config;
> +=09unsigned long size =3D offsetof(struct vhost_mdev_config, buf);
> +=09u8 *buf;
> +
> +=09if (copy_from_user(&config, c, size))
> +=09=09return -EFAULT;
> +=09if (vhost_mdev_config_validate(m, &config))
> +=09=09return -EINVAL;


I think it's better to let the parent to do such validation. Especially
consider that the size of config may depend on feature (e.g MQ).


> +=09buf =3D kvzalloc(config.len, GFP_KERNEL);
> +=09if (!buf)
> +=09=09return -ENOMEM;
> +
> +=09ops->get_config(mdev, config.off, buf, config.len);
> +
> +=09if (copy_to_user(c->buf, buf, config.len)) {
> +=09=09kvfree(buf);
> +=09=09return -EFAULT;
> +=09}
> +
> +=09kvfree(buf);
> +=09return 0;
> +}
> +
> +static long vhost_mdev_set_config(struct vhost_mdev *m,
> +=09=09=09=09  struct vhost_mdev_config __user *c)
> +{
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(mdev)=
;
> +=09struct vhost_mdev_config config;
> +=09unsigned long size =3D offsetof(struct vhost_mdev_config, buf);
> +=09u8 *buf;
> +
> +=09if (copy_from_user(&config, c, size))
> +=09=09return -EFAULT;
> +=09if (vhost_mdev_config_validate(m, &config))
> +=09=09return -EINVAL;
> +=09buf =3D kvzalloc(config.len, GFP_KERNEL);
> +=09if (!buf)
> +=09=09return -ENOMEM;
> +
> +=09if (copy_from_user(buf, c->buf, config.len)) {
> +=09=09kvfree(buf);
> +=09=09return -EFAULT;
> +=09}
> +
> +=09ops->set_config(mdev, config.off, buf, config.len);
> +
> +=09kvfree(buf);
> +=09return 0;
> +}
> +
> +static long vhost_mdev_get_features(struct vhost_mdev *m, u64 __user *fe=
aturep)
> +{
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(mdev)=
;
> +=09u64 features;
> +
> +=09features =3D ops->get_features(mdev);
> +=09features &=3D vhost_mdev_features[m->virtio_id];
> +
> +=09if (copy_to_user(featurep, &features, sizeof(features)))
> +=09=09return -EFAULT;
> +
> +=09return 0;
> +}
> +
> +static long vhost_mdev_set_features(struct vhost_mdev *m, u64 __user *fe=
aturep)
> +{
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(mdev)=
;
> +=09u64 features;
> +
> +=09/*
> +=09 * It's not allowed to change the features after they have
> +=09 * been negotiated.
> +=09 */
> +=09if (ops->get_status(mdev) & VIRTIO_CONFIG_S_FEATURES_OK)
> +=09=09return -EBUSY;
> +
> +=09if (copy_from_user(&features, featurep, sizeof(features)))
> +=09=09return -EFAULT;
> +
> +=09if (features & ~vhost_mdev_features[m->virtio_id])
> +=09=09return -EINVAL;
> +
> +=09if (ops->set_features(mdev, features))
> +=09=09return -EINVAL;
> +
> +=09return 0;
> +}
> +
> +static long vhost_mdev_get_vring_num(struct vhost_mdev *m, u16 __user *a=
rgp)
> +{
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(mdev)=
;
> +=09u16 num;
> +
> +=09num =3D ops->get_vq_num_max(mdev);
> +
> +=09if (copy_to_user(argp, &num, sizeof(num)))
> +=09=09return -EFAULT;
> +
> +=09return 0;
> +}
> +
> +static long vhost_mdev_vring_ioctl(struct vhost_mdev *m, unsigned int cm=
d,
> +=09=09=09=09   void __user *argp)
> +{
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(mdev)=
;
> +=09struct virtio_mdev_callback cb;
> +=09struct vhost_virtqueue *vq;
> +=09struct vhost_vring_state s;
> +=09u8 status;
> +=09u32 idx;
> +=09long r;
> +
> +=09r =3D get_user(idx, (u32 __user *)argp);
> +=09if (r < 0)
> +=09=09return r;
> +=09if (idx >=3D m->nvqs)
> +=09=09return -ENOBUFS;
> +
> +=09status =3D ops->get_status(mdev);
> +
> +=09/*
> +=09 * It's not allowed to detect and program vqs before
> +=09 * features negotiation or after enabling driver.
> +=09 */
> +=09if (!(status & VIRTIO_CONFIG_S_FEATURES_OK) ||
> +=09    (status & VIRTIO_CONFIG_S_DRIVER_OK))
> +=09=09return -EBUSY;
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
> +=09=09return -EBUSY;
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


Nit: It looks to me that we need expose alignment of vq to userspace
(get_vq_align()).

Thanks


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
> +=09case VHOST_MDEV_GET_DEVICE_ID:
> +=09=09r =3D vhost_mdev_get_device_id(m, argp);
> +=09=09break;
> +=09case VHOST_MDEV_GET_STATUS:
> +=09=09r =3D vhost_mdev_get_status(m, argp);
> +=09=09break;
> +=09case VHOST_MDEV_SET_STATUS:
> +=09=09r =3D vhost_mdev_set_status(m, argp);
> +=09=09break;
> +=09case VHOST_MDEV_GET_CONFIG:
> +=09=09r =3D vhost_mdev_get_config(m, argp);
> +=09=09break;
> +=09case VHOST_MDEV_SET_CONFIG:
> +=09=09r =3D vhost_mdev_set_config(m, argp);
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
> +=09default:
> +=09=09/*
> +=09=09 * VHOST_SET_MEM_TABLE, VHOST_SET_LOG_BASE, and
> +=09=09 * VHOST_SET_LOG_FD are not used yet.
> +=09=09 */
> +=09=09r =3D vhost_dev_ioctl(&m->dev, cmd, argp);
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
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(mdev)=
;
> +=09struct vhost_mdev *m;
> +=09int nvqs, r;
> +
> +=09/* Currently, we only accept the network devices. */
> +=09if (ops->get_device_id(mdev) !=3D VIRTIO_ID_NET)
> +=09=09return -ENOTSUPP;
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
> +
> +=09m->vqs =3D devm_kmalloc_array(dev, nvqs, sizeof(struct vhost_virtqueu=
e),
> +=09=09=09=09    GFP_KERNEL);
> +=09if (!m->vqs)
> +=09=09return -ENOMEM;
> +
> +=09mutex_init(&m->mutex);
> +
> +=09m->mdev =3D mdev;
> +=09m->nvqs =3D nvqs;
> +=09m->virtio_id =3D ops->get_device_id(mdev);
> +
> +=09r =3D vfio_add_group_dev(dev, &vfio_vhost_mdev_dev_ops, m);
> +=09if (r) {
> +=09=09mutex_destroy(&m->mutex);
> +=09=09return r;
> +=09}
> +
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
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_DESCRIPTION("Mediated device based accelerator for virtio");
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 9b69b0bbebfd..3e1e03926355 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -117,6 +117,10 @@ void mdev_set_virtio_ops(struct mdev_device *mdev,
>  =09=09=09 const struct virtio_mdev_device_ops *virtio_ops);
>  const struct virtio_mdev_device_ops *
>  mdev_get_virtio_ops(struct mdev_device *mdev);
> +void mdev_set_vhost_ops(struct mdev_device *mdev,
> +=09=09=09const struct virtio_mdev_device_ops *vhost_ops);
> +const struct virtio_mdev_device_ops *
> +mdev_get_vhost_ops(struct mdev_device *mdev);
> =20
>  extern struct bus_type mdev_bus_type;
> =20
> @@ -133,6 +137,7 @@ struct mdev_device *mdev_from_dev(struct device *dev)=
;
>  enum {
>  =09MDEV_CLASS_ID_VFIO =3D 1,
>  =09MDEV_CLASS_ID_VIRTIO =3D 2,
> +=09MDEV_CLASS_ID_VHOST =3D 3,
>  =09/* New entries must be added here */
>  };
> =20
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 40d028eed645..061a2824a1b3 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -116,4 +116,22 @@
>  #define VHOST_VSOCK_SET_GUEST_CID=09_IOW(VHOST_VIRTIO, 0x60, __u64)
>  #define VHOST_VSOCK_SET_RUNNING=09=09_IOW(VHOST_VIRTIO, 0x61, int)
> =20
> +/* VHOST_MDEV specific defines */
> +
> +/* Get the device id. The device ids follow the same definition of
> + * the device id defined in virtio-spec. */
> +#define VHOST_MDEV_GET_DEVICE_ID=09_IOR(VHOST_VIRTIO, 0x70, __u32)
> +/* Get and set the status. The status bits follow the same definition
> + * of the device status defined in virtio-spec. */
> +#define VHOST_MDEV_GET_STATUS=09=09_IOR(VHOST_VIRTIO, 0x71, __u8)
> +#define VHOST_MDEV_SET_STATUS=09=09_IOW(VHOST_VIRTIO, 0x72, __u8)
> +/* Get and set the device config. The device config follows the same
> + * definition of the device config defined in virtio-spec. */
> +#define VHOST_MDEV_GET_CONFIG=09=09_IOR(VHOST_VIRTIO, 0x73, struct vhost=
_mdev_config)
> +#define VHOST_MDEV_SET_CONFIG=09=09_IOW(VHOST_VIRTIO, 0x74, struct vhost=
_mdev_config)
> +/* Enable/disable the ring. */
> +#define VHOST_MDEV_SET_VRING_ENABLE=09_IOW(VHOST_VIRTIO, 0x75, struct vh=
ost_vring_state)
> +/* Get the max ring size. */
> +#define VHOST_MDEV_GET_VRING_NUM=09_IOR(VHOST_VIRTIO, 0x76, __u16)
> +
>  #endif
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_=
types.h
> index c907290ff065..7b105d0b2fb9 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -119,6 +119,14 @@ struct vhost_scsi_target {
>  =09unsigned short reserved;
>  };
> =20
> +/* VHOST_MDEV specific definitions */
> +
> +struct vhost_mdev_config {
> +=09__u32 off;
> +=09__u32 len;
> +=09__u8 buf[0];
> +};
> +
>  /* Feature bits */
>  /* Log all write descriptors. Can be changed while device is active. */
>  #define VHOST_F_LOG_ALL 26

