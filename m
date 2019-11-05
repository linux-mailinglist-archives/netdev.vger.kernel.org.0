Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64AC5EF433
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 04:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbfKEDye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 22:54:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40441 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730066AbfKEDye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 22:54:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572926072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3I07E3uObpbSEb/d1mxG3jpZq7BSqc9Wt3AqZLwXCLU=;
        b=TVfDGvM2Jc5iSULQMKU+qEZUC8CPxfPdJVDqqXn2zCAvCkAzrr3mkO+lha8aRkRVNX0h4M
        criwfFSCWXtVkkXeFnK/Zly3u3m8HpTW0VoAJE4ktm52kQ9Vb/eA+bjkzdtPwZgSNeiK08
        ULP72x8GCuY1jtU2uJAovRYoqdNIwg8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-NFrZhYuXNP2BKjqU4iVQUQ-1; Mon, 04 Nov 2019 22:54:29 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35A9F800C73;
        Tue,  5 Nov 2019 03:54:25 +0000 (UTC)
Received: from [10.72.12.252] (ovpn-12-252.pek2.redhat.com [10.72.12.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 017FD5DA66;
        Tue,  5 Nov 2019 03:52:47 +0000 (UTC)
Subject: Re: [PATCH V7 4/6] mdev: introduce virtio device and its device ops
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
References: <20191104123952.17276-1-jasowang@redhat.com>
 <20191104123952.17276-5-jasowang@redhat.com>
 <20191104145024.5e437765@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1faf4f36-3f79-2e15-3f61-c406d68240ab@redhat.com>
Date:   Tue, 5 Nov 2019 11:52:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104145024.5e437765@x1.home>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: NFrZhYuXNP2BKjqU4iVQUQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/5 =E4=B8=8A=E5=8D=885:50, Alex Williamson wrote:
> On Mon,  4 Nov 2019 20:39:50 +0800
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
>>   include/linux/mdev_virtio_ops.h  | 166 +++++++++++++++++++++++++++++++
>>   4 files changed, 194 insertions(+)
>>   create mode 100644 include/linux/mdev_virtio_ops.h
>>
>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core=
.c
>> index 8d579d7ed82f..95ee4126ff9c 100644
>> --- a/drivers/vfio/mdev/mdev_core.c
>> +++ b/drivers/vfio/mdev/mdev_core.c
>> @@ -76,6 +76,26 @@ const struct mdev_vfio_device_ops *mdev_get_vfio_ops(=
struct mdev_device *mdev)
>>   }
>>   EXPORT_SYMBOL(mdev_get_vfio_ops);
>>  =20
>> +/* Specify the virtio device ops for the mdev device, this
>> + * must be called during create() callback for virtio mdev device.
>> + */
> Comment style.


Will fix.


>
>> +void mdev_set_virtio_ops(struct mdev_device *mdev,
>> +=09=09=09 const struct mdev_virtio_device_ops *virtio_ops)
>> +{
>> +=09mdev_set_class(mdev, MDEV_CLASS_ID_VIRTIO);
>> +=09mdev->virtio_ops =3D virtio_ops;
>> +}
>> +EXPORT_SYMBOL(mdev_set_virtio_ops);
>> +
>> +/* Get the virtio device ops for the mdev device. */
>> +const struct mdev_virtio_device_ops *
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
>> index 411227373625..2c74dd032409 100644
>> --- a/drivers/vfio/mdev/mdev_private.h
>> +++ b/drivers/vfio/mdev/mdev_private.h
>> @@ -11,6 +11,7 @@
>>   #define MDEV_PRIVATE_H
>>  =20
>>   #include <linux/mdev_vfio_ops.h>
>> +#include <linux/mdev_virtio_ops.h>
>>  =20
>>   int  mdev_bus_register(void);
>>   void mdev_bus_unregister(void);
>> @@ -38,6 +39,7 @@ struct mdev_device {
>>   =09u16 class_id;
>>   =09union {
>>   =09=09const struct mdev_vfio_device_ops *vfio_ops;
>> +=09=09const struct mdev_virtio_device_ops *virtio_ops;
>>   =09};
>>   };
>>  =20
>> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
>> index 9e37506d1987..f3d75a60c2b5 100644
>> --- a/include/linux/mdev.h
>> +++ b/include/linux/mdev.h
>> @@ -17,6 +17,7 @@
>>  =20
>>   struct mdev_device;
>>   struct mdev_vfio_device_ops;
>> +struct mdev_virtio_device_ops;
>>  =20
>>   /*
>>    * Called by the parent device driver to set the device which represen=
ts
>> @@ -112,6 +113,10 @@ void mdev_set_class(struct mdev_device *mdev, u16 i=
d);
>>   void mdev_set_vfio_ops(struct mdev_device *mdev,
>>   =09=09       const struct mdev_vfio_device_ops *vfio_ops);
>>   const struct mdev_vfio_device_ops *mdev_get_vfio_ops(struct mdev_devic=
e *mdev);
>> +void mdev_set_virtio_ops(struct mdev_device *mdev,
>> +=09=09=09 const struct mdev_virtio_device_ops *virtio_ops);
>> +const struct mdev_virtio_device_ops *
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
>> diff --git a/include/linux/mdev_virtio_ops.h b/include/linux/mdev_virtio=
_ops.h
>> new file mode 100644
>> index 000000000000..0dcae7fa31e5
>> --- /dev/null
>> +++ b/include/linux/mdev_virtio_ops.h
>> @@ -0,0 +1,166 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Virtio mediated device driver
>> + *
>> + * Copyright 2019, Red Hat Corp.
>> + *     Author: Jason Wang <jasowang@redhat.com>
>> + */
>> +#ifndef MDEV_VIRTIO_OPS_H
>> +#define MDEV_VIRTIO_OPS_H
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
>> + * struct mdev_virtio_device_ops - Structure to be registered for each
>> + * mdev device to register the device for virtio/vhost drivers.
>> + *
>> + * The device ops that is supported by VIRTIO_MDEV_F_VERSION_1, the
>> + * callbacks are mandatory unless explicity mentioned.
>> + *
>> + * @get_mdev_features:=09=09Get a set of bits that demonstrate
>> + *=09=09=09=09the capability of the mdev device. New
>> + *=09=09=09=09feature bits must be added when
>> + *=09=09=09=09introducing new device ops. This
>> + *=09=09=09=09allows the device ops to be extended
>> + *=09=09=09=09(one feature could have N new ops).
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09Returns the mdev features (API) support by
>> + *=09=09=09=09the device.
> I still don't see the point of VIRTIO_MDEV_F_VERSION_1.  In what case
> would it not be set?


It's a must for current driver implementation.


> What would it indicate to the caller if it were
> not set?  The existence of this interface seems to indicate version 1.


The idea is when VIRTIO_MDE_F_VERSION_1 is advertised, driver will=20
assume all the mandatory callbacks for this feature were implemented.=20
Then there's no need to check the existence of each callback.


>
> I'm also still unclear how device ops gets extended, can you give some
> examples?  Particularly, if feature A and feature B both add device ops
> callbacks, is the vendor allowed to support B but not A, and does that
> imply their device ops structure includes callbacks for A but they're
> unused?


For current API, the answer is yes. So if vendor only support feature B,=20
it needs to set the device_ops that support feature A to NULL.


> Why doesn't the previous patch take any of this into account
> for struct mdev_vfio_device_ops?  I think this is an internal API,
> therefore is it worthwhile to include feature and extension support?


I'm not sure if VFIO has the request. In that case new features could be=20
extended simply through transport/bus specific way (e.g PCIE capability=20
list). But in the case of virtio-mdev, we need invent something on our=20
own. If the simple mapping between features and device ops is proved to=20
be not sufficient or sub-optimal, we can introduce a more sophisticated=20
API.


>
>> + * @get_mdev_features:=09=09Set a set of features that will be
> s/get/set/


Will fix.


>
>> + *=09=09=09=09used by the driver.
>> + *=09=09=09=09@features: features used by the driver
>> + *=09=09=09=09Returns bollean: whether the features
> s/bollean/boolean/
>
> How does one provide a set of features to set given this prototype?
>
> bool (*set_mdev_feature)(struct mdev_device *mdev);
>
> This is starting to look like a grab bag of callbacks, what sort of
> mdev features would the driver have the ability to set on a device?


Yes, e.g device support A,B,C, but driver will only use B and C.


>
> Note that this is not listed as optional, but the sample driver doesn't
> implement it :-\


My bad, will fix this.

Thanks


> Thanks,
>
> Alex
>
>> + *=09=09=09=09is accepted by the device.
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
>> + * @set_features:=09=09Set virtio features supported by the driver
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
>> + * @get_generation:=09=09Get device config generaton (optional)
>> + *=09=09=09=09@mdev: mediated device
>> + *=09=09=09=09Returns u32: device generation
>> + */
>> +struct mdev_virtio_device_ops {
>> +=09/* Mdev device ops */
>> +=09u64 (*get_mdev_features)(struct mdev_device *mdev);
>> +=09bool (*set_mdev_feature)(struct mdev_device *mdev);
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
>> +};
>> +
>> +void mdev_set_virtio_ops(struct mdev_device *mdev,
>> +=09=09=09 const struct mdev_virtio_device_ops *virtio_ops);
>> +
>> +#endif

