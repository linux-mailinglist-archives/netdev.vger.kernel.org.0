Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D75E292C
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 05:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406665AbfJXDwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 23:52:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27266 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390968AbfJXDwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 23:52:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571889139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VsUeyu7Hg7lzJzx0M4XP0/ITNGEfAT97k25KT//Mhkw=;
        b=cx0ZWd+txIksMBfQtti4QSDqbTbRbf4ch28QMhAPCcpc1GgMGJz73Eb7EE688dyCnIi0k/
        kshd5Sj0tyR6FS1r6U5n64f4SGxDCCPujFTASNGk5kmkHEiVu40GLc/oV48yp6/1UTXTK+
        iwDrvI5uaWyoye8Rt4fMtYPZXtNBX8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-OHmX8ps-Mii-Fm2ayqGxVA-1; Wed, 23 Oct 2019 23:52:15 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22267800D49;
        Thu, 24 Oct 2019 03:52:11 +0000 (UTC)
Received: from [10.72.12.199] (ovpn-12-199.pek2.redhat.com [10.72.12.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A04EF5D6D0;
        Thu, 24 Oct 2019 03:51:41 +0000 (UTC)
Subject: Re: [PATCH V5 4/6] mdev: introduce virtio device and its device ops
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
References: <20191023130752.18980-1-jasowang@redhat.com>
 <20191023130752.18980-5-jasowang@redhat.com>
 <20191023155728.2a55bc71@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1699cc4e-7d52-b2dc-8016-358a36a4f4ea@redhat.com>
Date:   Thu, 24 Oct 2019 11:51:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191023155728.2a55bc71@x1.home>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: OHmX8ps-Mii-Fm2ayqGxVA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/24 =E4=B8=8A=E5=8D=885:57, Alex Williamson wrote:
> On Wed, 23 Oct 2019 21:07:50 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> This patch implements basic support for mdev driver that supports
>> virtio transport for kernel virtio driver.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vfio/mdev/mdev_core.c    |  20 ++++
>>   drivers/vfio/mdev/mdev_private.h |   2 +
>>   include/linux/mdev.h             |   6 ++
>>   include/linux/virtio_mdev_ops.h  | 159 +++++++++++++++++++++++++++++++
>>   4 files changed, 187 insertions(+)
>>   create mode 100644 include/linux/virtio_mdev_ops.h
>>
>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core=
.c
>> index 555bd61d8c38..9b00c3513120 100644
>> --- a/drivers/vfio/mdev/mdev_core.c
>> +++ b/drivers/vfio/mdev/mdev_core.c
>> @@ -76,6 +76,26 @@ const struct vfio_mdev_device_ops *mdev_get_vfio_ops(=
struct mdev_device *mdev)
>>   }
>>   EXPORT_SYMBOL(mdev_get_vfio_ops);
>>  =20
>> +/* Specify the virtio device ops for the mdev device, this
>> + * must be called during create() callback for virtio mdev device.
>> + */
>> +void mdev_set_virtio_ops(struct mdev_device *mdev,
>> +=09=09=09 const struct virtio_mdev_device_ops *virtio_ops)
>> +{
>> +=09mdev_set_class(mdev, MDEV_CLASS_ID_VIRTIO);
>> +=09mdev->virtio_ops =3D virtio_ops;
>> +}
>> +EXPORT_SYMBOL(mdev_set_virtio_ops);
>> +
>> +/* Get the virtio device ops for the mdev device. */
>> +const struct virtio_mdev_device_ops *
>> +mdev_get_virtio_ops(struct mdev_device *mdev)
>> +{
>> +=09WARN_ON(mdev->class_id !=3D MDEV_CLASS_ID_VIRTIO);
>> +=09return mdev->virtio_ops;
>> +}
>> +EXPORT_SYMBOL(mdev_get_virtio_ops);
>> +
>>   struct device *mdev_dev(struct mdev_device *mdev)
>>   {
>>   =09return &mdev->dev;
>> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_p=
rivate.h
>> index 0770410ded2a..7b47890c34e7 100644
>> --- a/drivers/vfio/mdev/mdev_private.h
>> +++ b/drivers/vfio/mdev/mdev_private.h
>> @@ -11,6 +11,7 @@
>>   #define MDEV_PRIVATE_H
>>  =20
>>   #include <linux/vfio_mdev_ops.h>
>> +#include <linux/virtio_mdev_ops.h>
>>  =20
>>   int  mdev_bus_register(void);
>>   void mdev_bus_unregister(void);
>> @@ -38,6 +39,7 @@ struct mdev_device {
>>   =09u16 class_id;
>>   =09union {
>>   =09=09const struct vfio_mdev_device_ops *vfio_ops;
>> +=09=09const struct virtio_mdev_device_ops *virtio_ops;
>>   =09};
>>   };
>>  =20
>> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
>> index 4625f1a11014..9b69b0bbebfd 100644
>> --- a/include/linux/mdev.h
>> +++ b/include/linux/mdev.h
>> @@ -17,6 +17,7 @@
>>  =20
>>   struct mdev_device;
>>   struct vfio_mdev_device_ops;
>> +struct virtio_mdev_device_ops;
>>  =20
>>   /*
>>    * Called by the parent device driver to set the device which represen=
ts
>> @@ -112,6 +113,10 @@ void mdev_set_class(struct mdev_device *mdev, u16 i=
d);
>>   void mdev_set_vfio_ops(struct mdev_device *mdev,
>>   =09=09       const struct vfio_mdev_device_ops *vfio_ops);
>>   const struct vfio_mdev_device_ops *mdev_get_vfio_ops(struct mdev_devic=
e *mdev);
>> +void mdev_set_virtio_ops(struct mdev_device *mdev,
>> +=09=09=09 const struct virtio_mdev_device_ops *virtio_ops);
>> +const struct virtio_mdev_device_ops *
>> +mdev_get_virtio_ops(struct mdev_device *mdev);
>>  =20
>>   extern struct bus_type mdev_bus_type;
>>  =20
>> @@ -127,6 +132,7 @@ struct mdev_device *mdev_from_dev(struct device *dev=
);
>>  =20
>>   enum {
>>   =09MDEV_CLASS_ID_VFIO =3D 1,
>> +=09MDEV_CLASS_ID_VIRTIO =3D 2,
>>   =09/* New entries must be added here */
>>   };
>>  =20
>> diff --git a/include/linux/virtio_mdev_ops.h b/include/linux/virtio_mdev=
_ops.h
>> new file mode 100644
>> index 000000000000..d417b41f2845
>> --- /dev/null
>> +++ b/include/linux/virtio_mdev_ops.h
>> @@ -0,0 +1,159 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Virtio mediated device driver
>> + *
>> + * Copyright 2019, Red Hat Corp.
>> + *     Author: Jason Wang <jasowang@redhat.com>
>> + */
>> +#ifndef _LINUX_VIRTIO_MDEV_H
>> +#define _LINUX_VIRTIO_MDEV_H
>> +
>> +#include <linux/interrupt.h>
>> +#include <linux/mdev.h>
>> +#include <uapi/linux/vhost.h>
>> +
>> +#define VIRTIO_MDEV_DEVICE_API_STRING=09=09"virtio-mdev"
>> +#define VIRTIO_MDEV_F_VERSION_1 0x1
>> +
>> +struct virtio_mdev_callback {
>> +=09irqreturn_t (*callback)(void *data);
>> +=09void *private;
>> +};
>> +
>> +/**
>> + * struct vfio_mdev_device_ops - Structure to be registered for each
>> + * mdev device to register the device for virtio/vhost drivers.
>> + *
>> + * The device ops that is supported by VIRTIO_MDEV_F_VERSION_1, the
>> + * callbacks are mandatory unless explicity mentioned.
> If the version of the callbacks is returned by a callback within the
> structure defined by the version... isn't that a bit circular?  This
> seems redundant to me versus the class id.  The fact that the parent
> driver defines the device as MDEV_CLASS_ID_VIRTIO should tell us this
> already.  If it was incremented, we'd need an MDEV_CLASS_ID_VIRTIOv2,
> which the virtio-mdev bus driver could add to its id table and handle
> differently.


My understanding is versions are only allowed to increase monotonically,=20
this seems less flexible than features. E.g we have features A, B, C,=20
mdev device can choose to support only a subset. E.g when mdev device=20
can support dirty page logging, it can add a new feature bit for driver=20
to know that it support new device ops. MDEV_CLASS_ID_VIRTIOv2 may only=20
be useful when we will invent a complete new API.


>
>> + *
>> + * @set_vq_address:=09=09Set the address of virtqueue
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@idx: virtqueue index
>> + *=09=09=09=09@desc_area: address of desc area
>> + *=09=09=09=09@driver_area: address of driver area
>> + *=09=09=09=09@device_area: address of device area
>> + *=09=09=09=09Returns integer: success (0) or error (< 0)
>> + * @set_vq_num:=09=09=09Set the size of virtqueue
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@idx: virtqueue index
>> + *=09=09=09=09@num: the size of virtqueue
>> + * @kick_vq:=09=09=09Kick the virtqueue
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@idx: virtqueue index
>> + * @set_vq_cb:=09=09=09Set the interrupt callback function for
>> + *=09=09=09=09a virtqueue
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@idx: virtqueue index
>> + *=09=09=09=09@cb: virtio-mdev interrupt callback structure
>> + * @set_vq_ready:=09=09Set ready status for a virtqueue
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@idx: virtqueue index
>> + *=09=09=09=09@ready: ready (true) not ready(false)
>> + * @get_vq_ready:=09=09Get ready status for a virtqueue
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@idx: virtqueue index
>> + *=09=09=09=09Returns boolean: ready (true) or not (false)
>> + * @set_vq_state:=09=09Set the state for a virtqueue
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@idx: virtqueue index
>> + *=09=09=09=09@state: virtqueue state (last_avail_idx)
>> + *=09=09=09=09Returns integer: success (0) or error (< 0)
>> + * @get_vq_state:=09=09Get the state for a virtqueue
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@idx: virtqueue index
>> + *=09=09=09=09Returns virtqueue state (last_avail_idx)
>> + * @get_vq_align:=09=09Get the virtqueue align requirement
>> + *=09=09=09=09for the device
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09Returns virtqueue algin requirement
>> + * @get_features:=09=09Get virtio features supported by the device
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09Returns the virtio features support by the
>> + *=09=09=09=09device
>> + * @get_features:=09=09Set virtio features supported by the driver
>         ^ s/g/s/
>
> Thanks,
> Alex


Will fix.

Thanks


>
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@features: feature support by the driver
>> + *=09=09=09=09Returns integer: success (0) or error (< 0)
>> + * @set_config_cb:=09=09Set the config interrupt callback
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@cb: virtio-mdev interrupt callback structure
>> + * @get_vq_num_max:=09=09Get the max size of virtqueue
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09Returns u16: max size of virtqueue
>> + * @get_device_id:=09=09Get virtio device id
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09Returns u32: virtio device id
>> + * @get_vendor_id:=09=09Get id for the vendor that provides this device
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09Returns u32: virtio vendor id
>> + * @get_status:=09=09=09Get the device status
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09Returns u8: virtio device status
>> + * @set_status:=09=09=09Set the device status
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@status: virtio device status
>> + * @get_config:=09=09=09Read from device specific configuration space
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@offset: offset from the beginning of
>> + *=09=09=09=09configuration space
>> + *=09=09=09=09@buf: buffer used to read to
>> + *=09=09=09=09@len: the length to read from
>> + *=09=09=09=09configration space
>> + * @set_config:=09=09=09Write to device specific configuration space
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09@offset: offset from the beginning of
>> + *=09=09=09=09configuration space
>> + *=09=09=09=09@buf: buffer used to write from
>> + *=09=09=09=09@len: the length to write to
>> + *=09=09=09=09configration space
>> + * @get_mdev_features:=09=09Get a set of bits that demonstrate
>> + *=09=09=09=09thecapability of the mdev device. New
>> + *=09=09=09=09features bits must be added when
>> + *=09=09=09=09introducing new device ops.
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09Returns the mdev features (API) support by
>> + *=09=09=09=09the device.
>> + * @get_generation:=09=09Get device config generaton (optionally)
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09Returns u32: device generation
>> + */
>> +struct virtio_mdev_device_ops {
>> +=09/* Virtqueue ops */
>> +=09int (*set_vq_address)(struct mdev_device *mdev,
>> +=09=09=09      u16 idx, u64 desc_area, u64 driver_area,
>> +=09=09=09      u64 device_area);
>> +=09void (*set_vq_num)(struct mdev_device *mdev, u16 idx, u32 num);
>> +=09void (*kick_vq)(struct mdev_device *mdev, u16 idx);
>> +=09void (*set_vq_cb)(struct mdev_device *mdev, u16 idx,
>> +=09=09=09  struct virtio_mdev_callback *cb);
>> +=09void (*set_vq_ready)(struct mdev_device *mdev, u16 idx, bool ready);
>> +=09bool (*get_vq_ready)(struct mdev_device *mdev, u16 idx);
>> +=09int (*set_vq_state)(struct mdev_device *mdev, u16 idx, u64 state);
>> +=09u64 (*get_vq_state)(struct mdev_device *mdev, u16 idx);
>> +
>> +=09/* Virtio device ops */
>> +=09u16 (*get_vq_align)(struct mdev_device *mdev);
>> +=09u64 (*get_features)(struct mdev_device *mdev);
>> +=09int (*set_features)(struct mdev_device *mdev, u64 features);
>> +=09void (*set_config_cb)(struct mdev_device *mdev,
>> +=09=09=09      struct virtio_mdev_callback *cb);
>> +=09u16 (*get_vq_num_max)(struct mdev_device *mdev);
>> +=09u32 (*get_device_id)(struct mdev_device *mdev);
>> +=09u32 (*get_vendor_id)(struct mdev_device *mdev);
>> +=09u8 (*get_status)(struct mdev_device *mdev);
>> +=09void (*set_status)(struct mdev_device *mdev, u8 status);
>> +=09void (*get_config)(struct mdev_device *mdev, unsigned int offset,
>> +=09=09=09   void *buf, unsigned int len);
>> +=09void (*set_config)(struct mdev_device *mdev, unsigned int offset,
>> +=09=09=09   const void *buf, unsigned int len);
>> +=09u32 (*get_generation)(struct mdev_device *mdev);
>> +
>> +=09/* Mdev device ops */
>> +=09u64 (*get_mdev_features)(struct mdev_device *mdev);
>> +};
>> +
>> +void mdev_set_virtio_ops(struct mdev_device *mdev,
>> +=09=09=09 const struct virtio_mdev_device_ops *virtio_ops);
>> +
>> +#endif

