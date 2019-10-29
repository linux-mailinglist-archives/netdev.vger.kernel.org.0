Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9C0E829D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 08:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfJ2Hmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 03:42:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:37298 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbfJ2Hmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 03:42:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 00:42:31 -0700
X-IronPort-AV: E=Sophos;i="5.68,243,1569308400"; 
   d="scan'208";a="193524324"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.238.129.48]) ([10.238.129.48])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 29 Oct 2019 00:42:23 -0700
Subject: Re: [PATCH V5 4/6] mdev: introduce virtio device and its device ops
To:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
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
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <df1eb77c-d159-da11-bb8f-df2c19089ac6@linux.intel.com>
Date:   Tue, 29 Oct 2019 15:42:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191023130752.18980-5-jasowang@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/23/2019 9:07 PM, Jason Wang wrote:
> This patch implements basic support for mdev driver that supports
> virtio transport for kernel virtio driver.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/vfio/mdev/mdev_core.c    |  20 ++++
>   drivers/vfio/mdev/mdev_private.h |   2 +
>   include/linux/mdev.h             |   6 ++
>   include/linux/virtio_mdev_ops.h  | 159 +++++++++++++++++++++++++++++++
>   4 files changed, 187 insertions(+)
>   create mode 100644 include/linux/virtio_mdev_ops.h
>
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 555bd61d8c38..9b00c3513120 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -76,6 +76,26 @@ const struct vfio_mdev_device_ops *mdev_get_vfio_ops(struct mdev_device *mdev)
>   }
>   EXPORT_SYMBOL(mdev_get_vfio_ops);
>   
> +/* Specify the virtio device ops for the mdev device, this
> + * must be called during create() callback for virtio mdev device.
> + */
> +void mdev_set_virtio_ops(struct mdev_device *mdev,
> +			 const struct virtio_mdev_device_ops *virtio_ops)
> +{
> +	mdev_set_class(mdev, MDEV_CLASS_ID_VIRTIO);
> +	mdev->virtio_ops = virtio_ops;
> +}
> +EXPORT_SYMBOL(mdev_set_virtio_ops);
> +
> +/* Get the virtio device ops for the mdev device. */
> +const struct virtio_mdev_device_ops *
> +mdev_get_virtio_ops(struct mdev_device *mdev)
> +{
> +	WARN_ON(mdev->class_id != MDEV_CLASS_ID_VIRTIO);
> +	return mdev->virtio_ops;
> +}
> +EXPORT_SYMBOL(mdev_get_virtio_ops);
> +
>   struct device *mdev_dev(struct mdev_device *mdev)
>   {
>   	return &mdev->dev;
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 0770410ded2a..7b47890c34e7 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -11,6 +11,7 @@
>   #define MDEV_PRIVATE_H
>   
>   #include <linux/vfio_mdev_ops.h>
> +#include <linux/virtio_mdev_ops.h>
>   
>   int  mdev_bus_register(void);
>   void mdev_bus_unregister(void);
> @@ -38,6 +39,7 @@ struct mdev_device {
>   	u16 class_id;
>   	union {
>   		const struct vfio_mdev_device_ops *vfio_ops;
> +		const struct virtio_mdev_device_ops *virtio_ops;
>   	};
>   };
>   
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 4625f1a11014..9b69b0bbebfd 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -17,6 +17,7 @@
>   
>   struct mdev_device;
>   struct vfio_mdev_device_ops;
> +struct virtio_mdev_device_ops;
>   
>   /*
>    * Called by the parent device driver to set the device which represents
> @@ -112,6 +113,10 @@ void mdev_set_class(struct mdev_device *mdev, u16 id);
>   void mdev_set_vfio_ops(struct mdev_device *mdev,
>   		       const struct vfio_mdev_device_ops *vfio_ops);
>   const struct vfio_mdev_device_ops *mdev_get_vfio_ops(struct mdev_device *mdev);
> +void mdev_set_virtio_ops(struct mdev_device *mdev,
> +			 const struct virtio_mdev_device_ops *virtio_ops);
> +const struct virtio_mdev_device_ops *
> +mdev_get_virtio_ops(struct mdev_device *mdev);
>   
>   extern struct bus_type mdev_bus_type;
>   
> @@ -127,6 +132,7 @@ struct mdev_device *mdev_from_dev(struct device *dev);
>   
>   enum {
>   	MDEV_CLASS_ID_VFIO = 1,
> +	MDEV_CLASS_ID_VIRTIO = 2,
>   	/* New entries must be added here */
>   };
>   
> diff --git a/include/linux/virtio_mdev_ops.h b/include/linux/virtio_mdev_ops.h
> new file mode 100644
> index 000000000000..d417b41f2845
> --- /dev/null
> +++ b/include/linux/virtio_mdev_ops.h
> @@ -0,0 +1,159 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Virtio mediated device driver
> + *
> + * Copyright 2019, Red Hat Corp.
> + *     Author: Jason Wang <jasowang@redhat.com>
> + */
> +#ifndef _LINUX_VIRTIO_MDEV_H
> +#define _LINUX_VIRTIO_MDEV_H
> +
> +#include <linux/interrupt.h>
> +#include <linux/mdev.h>
> +#include <uapi/linux/vhost.h>
> +
> +#define VIRTIO_MDEV_DEVICE_API_STRING		"virtio-mdev"
> +#define VIRTIO_MDEV_F_VERSION_1 0x1
> +
> +struct virtio_mdev_callback {
> +	irqreturn_t (*callback)(void *data);
> +	void *private;
> +};
> +
> +/**
> + * struct vfio_mdev_device_ops - Structure to be registered for each
> + * mdev device to register the device for virtio/vhost drivers.
> + *
> + * The device ops that is supported by VIRTIO_MDEV_F_VERSION_1, the
> + * callbacks are mandatory unless explicity mentioned.
> + *
> + * @set_vq_address:		Set the address of virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@desc_area: address of desc area
> + *				@driver_area: address of driver area
> + *				@device_area: address of device area
> + *				Returns integer: success (0) or error (< 0)
> + * @set_vq_num:			Set the size of virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@num: the size of virtqueue
> + * @kick_vq:			Kick the virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + * @set_vq_cb:			Set the interrupt callback function for
> + *				a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@cb: virtio-mdev interrupt callback structure
> + * @set_vq_ready:		Set ready status for a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@ready: ready (true) not ready(false)
> + * @get_vq_ready:		Get ready status for a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				Returns boolean: ready (true) or not (false)
> + * @set_vq_state:		Set the state for a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@state: virtqueue state (last_avail_idx)
> + *				Returns integer: success (0) or error (< 0)
> + * @get_vq_state:		Get the state for a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				Returns virtqueue state (last_avail_idx)
> + * @get_vq_align:		Get the virtqueue align requirement
> + *				for the device
> + *				@mdev: mediated device
> + *				Returns virtqueue algin requirement
> + * @get_features:		Get virtio features supported by the device
> + *				@mdev: mediated device
> + *				Returns the virtio features support by the
> + *				device
> + * @get_features:		Set virtio features supported by the driver
> + *				@mdev: mediated device
> + *				@features: feature support by the driver
> + *				Returns integer: success (0) or error (< 0)
> + * @set_config_cb:		Set the config interrupt callback
> + *				@mdev: mediated device
> + *				@cb: virtio-mdev interrupt callback structure
> + * @get_vq_num_max:		Get the max size of virtqueue
> + *				@mdev: mediated device
> + *				Returns u16: max size of virtqueue
> + * @get_device_id:		Get virtio device id
> + *				@mdev: mediated device
> + *				Returns u32: virtio device id
> + * @get_vendor_id:		Get id for the vendor that provides this device
> + *				@mdev: mediated device
> + *				Returns u32: virtio vendor id
> + * @get_status:			Get the device status
> + *				@mdev: mediated device
> + *				Returns u8: virtio device status
> + * @set_status:			Set the device status
> + *				@mdev: mediated device
> + *				@status: virtio device status
> + * @get_config:			Read from device specific configuration space
> + *				@mdev: mediated device
> + *				@offset: offset from the beginning of
> + *				configuration space
> + *				@buf: buffer used to read to
> + *				@len: the length to read from
> + *				configration space
> + * @set_config:			Write to device specific configuration space
> + *				@mdev: mediated device
> + *				@offset: offset from the beginning of
> + *				configuration space
> + *				@buf: buffer used to write from
> + *				@len: the length to write to
> + *				configration space
> + * @get_mdev_features:		Get a set of bits that demonstrate
> + *				thecapability of the mdev device. New
> + *				features bits must be added when
> + *				introducing new device ops.
> + *				@mdev: mediated device
> + *				Returns the mdev features (API) support by
> + *				the device.
> + * @get_generation:		Get device config generaton (optionally)
> + *				@mdev: mediated device
> + *				Returns u32: device generation
> + */
> +struct virtio_mdev_device_ops {
> +	/* Virtqueue ops */
> +	int (*set_vq_address)(struct mdev_device *mdev,
> +			      u16 idx, u64 desc_area, u64 driver_area,
> +			      u64 device_area);
> +	void (*set_vq_num)(struct mdev_device *mdev, u16 idx, u32 num);
> +	void (*kick_vq)(struct mdev_device *mdev, u16 idx);
> +	void (*set_vq_cb)(struct mdev_device *mdev, u16 idx,
> +			  struct virtio_mdev_callback *cb);
> +	void (*set_vq_ready)(struct mdev_device *mdev, u16 idx, bool ready);
> +	bool (*get_vq_ready)(struct mdev_device *mdev, u16 idx);
> +	int (*set_vq_state)(struct mdev_device *mdev, u16 idx, u64 state);
> +	u64 (*get_vq_state)(struct mdev_device *mdev, u16 idx);
> +
> +	/* Virtio device ops */
> +	u16 (*get_vq_align)(struct mdev_device *mdev);
> +	u64 (*get_features)(struct mdev_device *mdev);
> +	int (*set_features)(struct mdev_device *mdev, u64 features);
> +	void (*set_config_cb)(struct mdev_device *mdev,
> +			      struct virtio_mdev_callback *cb);
> +	u16 (*get_vq_num_max)(struct mdev_device *mdev);
> +	u32 (*get_device_id)(struct mdev_device *mdev);
> +	u32 (*get_vendor_id)(struct mdev_device *mdev);
> +	u8 (*get_status)(struct mdev_device *mdev);
> +	void (*set_status)(struct mdev_device *mdev, u8 status);

Hi Jason

Is it possible to make set_status() return an u8 or bool, because this 
may fail in real hardware. Without a returned code, I am not sure  
whether it is a good idea to set the status | NEED_RESET when fail.

Thanks,
BR
Zhu Lingshan
> +	void (*get_config)(struct mdev_device *mdev, unsigned int offset,
> +			   void *buf, unsigned int len);
> +	void (*set_config)(struct mdev_device *mdev, unsigned int offset,
> +			   const void *buf, unsigned int len);
> +	u32 (*get_generation)(struct mdev_device *mdev);
> +
> +	/* Mdev device ops */
> +	u64 (*get_mdev_features)(struct mdev_device *mdev);
> +};
> +
> +void mdev_set_virtio_ops(struct mdev_device *mdev,
> +			 const struct virtio_mdev_device_ops *virtio_ops);
> +
> +#endif
