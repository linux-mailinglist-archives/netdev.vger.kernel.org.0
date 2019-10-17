Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1734DB0C1
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406237AbfJQPIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:08:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12187 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405952AbfJQPIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 11:08:25 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC4F530789A0;
        Thu, 17 Oct 2019 15:08:23 +0000 (UTC)
Received: from gondolin (dhcp-192-202.str.redhat.com [10.33.192.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8FD860872;
        Thu, 17 Oct 2019 15:07:57 +0000 (UTC)
Date:   Thu, 17 Oct 2019 17:07:55 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
Subject: Re: [PATCH V4 3/6] mdev: introduce device specific ops
Message-ID: <20191017170755.15506ada.cohuck@redhat.com>
In-Reply-To: <20191017104836.32464-4-jasowang@redhat.com>
References: <20191017104836.32464-1-jasowang@redhat.com>
        <20191017104836.32464-4-jasowang@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 17 Oct 2019 15:08:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Oct 2019 18:48:33 +0800
Jason Wang <jasowang@redhat.com> wrote:

> Currently, except for the create and remove, the rest of
> mdev_parent_ops is designed for vfio-mdev driver only and may not help
> for kernel mdev driver. With the help of class id, this patch
> introduces device specific callbacks inside mdev_device
> structure. This allows different set of callback to be used by
> vfio-mdev and virtio-mdev.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       | 25 +++++----
>  MAINTAINERS                                   |  1 +
>  drivers/gpu/drm/i915/gvt/kvmgt.c              | 18 ++++---
>  drivers/s390/cio/vfio_ccw_ops.c               | 18 ++++---
>  drivers/s390/crypto/vfio_ap_ops.c             | 14 +++--
>  drivers/vfio/mdev/mdev_core.c                 | 18 +++++--
>  drivers/vfio/mdev/mdev_private.h              |  1 +
>  drivers/vfio/mdev/vfio_mdev.c                 | 37 ++++++-------
>  include/linux/mdev.h                          | 45 ++++------------
>  include/linux/vfio_mdev.h                     | 52 +++++++++++++++++++
>  samples/vfio-mdev/mbochs.c                    | 20 ++++---
>  samples/vfio-mdev/mdpy.c                      | 20 ++++---
>  samples/vfio-mdev/mtty.c                      | 18 ++++---
>  13 files changed, 184 insertions(+), 103 deletions(-)
>  create mode 100644 include/linux/vfio_mdev.h
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index f9a78d75a67a..0cca84d19603 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -152,11 +152,22 @@ callbacks per mdev parent device, per mdev type, or any other categorization.
>  Vendor drivers are expected to be fully asynchronous in this respect or
>  provide their own internal resource protection.)
>  
> -The callbacks in the mdev_parent_ops structure are as follows:
> -
> -* open: open callback of mediated device
> -* close: close callback of mediated device
> -* ioctl: ioctl callback of mediated device
> +As multiple types of mediated devices may be supported, the device
> +must set up the class id and the device specific callbacks in create()

s/in create()/in the create()/

> +callback. E.g for vfio-mdev device it needs to be done through:

"Each class provides a helper function to do so; e.g. for vfio-mdev
devices, the function to be called is:"

?

> +
> +    int mdev_set_vfio_ops(struct mdev_device *mdev,
> +                          const struct vfio_mdev_ops *vfio_ops);
> +
> +The class id (set to MDEV_CLASS_ID_VFIO) is used to match a device

"(set by this helper function to MDEV_CLASS_ID_VFIO)" ?

> +with an mdev driver via its id table. The device specific callbacks
> +(specified in *ops) are obtainable via mdev_get_dev_ops() (for use by

"(specified in *vfio_ops by the caller)" ?

> +the mdev bus driver). A vfio-mdev device (class id MDEV_CLASS_ID_VFIO)
> +uses the following device-specific ops:
> +
> +* open: open callback of vfio mediated device
> +* close: close callback of vfio mediated device
> +* ioctl: ioctl callback of vfio mediated device
>  * read : read emulation callback
>  * write: write emulation callback
>  * mmap: mmap emulation callback
> @@ -167,10 +178,6 @@ register itself with the mdev core driver::
>  	extern int  mdev_register_device(struct device *dev,
>  	                                 const struct mdev_parent_ops *ops);
>  
> -It is also required to specify the class_id in create() callback through::
> -
> -	int mdev_set_class(struct mdev_device *mdev, u16 id);
> -

I'm wondering if this patch set should start out with introducing
helper functions already (i.e. don't introduce mdev_set_class(), but
start out with mdev_set_class_vfio() which will gain the *vfio_ops
argument in this patch.)

>  However, the mdev_parent_ops structure is not required in the function call
>  that a driver should use to unregister itself with the mdev core driver::
>  

(...)

> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 3a9c52d71b4e..d0f3113c8071 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -45,15 +45,23 @@ void mdev_set_drvdata(struct mdev_device *mdev, void *data)
>  }
>  EXPORT_SYMBOL(mdev_set_drvdata);
>  
> -/* Specify the class for the mdev device, this must be called during
> - * create() callback.
> +/* Specify the VFIO device ops for the mdev device, this
> + * must be called during create() callback for VFIO mdev device.
>   */

/*
 * Specify the mdev device to be a VFIO mdev device, and set the
 * VFIO devices ops for it. This must be called from the create()
 * callback for VFIO mdev devices.
 */

?

> -void mdev_set_class(struct mdev_device *mdev, u16 id)
> +void mdev_set_vfio_ops(struct mdev_device *mdev,
> +		       const struct vfio_mdev_device_ops *vfio_ops)
>  {
>  	WARN_ON(mdev->class_id);
> -	mdev->class_id = id;
> +	mdev->class_id = MDEV_CLASS_ID_VFIO;
> +	mdev->device_ops = vfio_ops;
>  }
> -EXPORT_SYMBOL(mdev_set_class);
> +EXPORT_SYMBOL(mdev_set_vfio_ops);
> +
> +const void *mdev_get_dev_ops(struct mdev_device *mdev)
> +{
> +	return mdev->device_ops;
> +}
> +EXPORT_SYMBOL(mdev_get_dev_ops);
>  
>  struct device *mdev_dev(struct mdev_device *mdev)
>  {

(...)

The code change looks good to me; I'm just wondering if we should
introduce mdev_set_class() at all (see above).
