Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060FABDDB7
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 14:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405367AbfIYMGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 08:06:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37630 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405340AbfIYMGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 08:06:49 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7ECDA18CB8E7;
        Wed, 25 Sep 2019 12:06:47 +0000 (UTC)
Received: from [10.72.12.148] (ovpn-12-148.pek2.redhat.com [10.72.12.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2103608C0;
        Wed, 25 Sep 2019 12:05:00 +0000 (UTC)
Subject: Re: [PATCH V2 5/8] mdev: introduce device specific ops
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
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com
References: <20190924135332.14160-1-jasowang@redhat.com>
 <20190924135332.14160-6-jasowang@redhat.com>
 <20190924170638.064d85f7@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <27a9a71f-5a10-77be-2f54-5af52a406a00@redhat.com>
Date:   Wed, 25 Sep 2019 20:04:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924170638.064d85f7@x1.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Wed, 25 Sep 2019 12:06:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/25 上午7:06, Alex Williamson wrote:
> On Tue, 24 Sep 2019 21:53:29 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> Currently, except for the create and remove, the rest of
>> mdev_parent_ops is designed for vfio-mdev driver only and may not help
>> for kernel mdev driver. With the help of class id, this patch
>> introduces device specific callbacks inside mdev_device
>> structure. This allows different set of callback to be used by
>> vfio-mdev and virtio-mdev.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>  .../driver-api/vfio-mediated-device.rst       |  4 +-
>>  MAINTAINERS                                   |  1 +
>>  drivers/gpu/drm/i915/gvt/kvmgt.c              | 17 +++---
>>  drivers/s390/cio/vfio_ccw_ops.c               | 17 ++++--
>>  drivers/s390/crypto/vfio_ap_ops.c             | 13 +++--
>>  drivers/vfio/mdev/mdev_core.c                 | 12 +++++
>>  drivers/vfio/mdev/mdev_private.h              |  1 +
>>  drivers/vfio/mdev/vfio_mdev.c                 | 37 ++++++-------
>>  include/linux/mdev.h                          | 42 ++++-----------
>>  include/linux/vfio_mdev.h                     | 52 +++++++++++++++++++
>>  samples/vfio-mdev/mbochs.c                    | 19 ++++---
>>  samples/vfio-mdev/mdpy.c                      | 19 ++++---
>>  samples/vfio-mdev/mtty.c                      | 17 ++++--
>>  13 files changed, 168 insertions(+), 83 deletions(-)
>>  create mode 100644 include/linux/vfio_mdev.h
>>
>> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
>> index a5bdc60d62a1..d50425b368bb 100644
>> --- a/Documentation/driver-api/vfio-mediated-device.rst
>> +++ b/Documentation/driver-api/vfio-mediated-device.rst
>> @@ -152,7 +152,9 @@ callbacks per mdev parent device, per mdev type, or any other categorization.
>>  Vendor drivers are expected to be fully asynchronous in this respect or
>>  provide their own internal resource protection.)
>>  
>> -The callbacks in the mdev_parent_ops structure are as follows:
>> +The device specific callbacks are referred through device_ops pointer
>> +in mdev_parent_ops. For vfio-mdev device, its callbacks in device_ops
>> +are as follows:
> This is not accurate.  device_ops is now on the mdev_device and is an
> mdev bus driver specific structure of callbacks that must be registered
> for each mdev device by the parent driver during the create callback.
> There's a one to one mapping of class_id to mdev_device_ops callbacks.


Yes.


>
> That also suggests to me that we could be more clever in registering
> both of these with mdev-core.  Can we embed the class_id in the ops
> structure in a common way so that the core can extract it and the bus
> drivers can access their specific callbacks?


That seems much cleaner, let me try to do that in V3.


>
>>  * open: open callback of mediated device
>>  * close: close callback of mediated device
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index b2326dece28e..89832b316500 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17075,6 +17075,7 @@ S:	Maintained
>>  F:	Documentation/driver-api/vfio-mediated-device.rst
>>  F:	drivers/vfio/mdev/
>>  F:	include/linux/mdev.h
>> +F:	include/linux/vfio_mdev.h
>>  F:	samples/vfio-mdev/
>>  
>>  VFIO PLATFORM DRIVER
>> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> index f793252a3d2a..b274f5ee481f 100644
>> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
>> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> @@ -42,6 +42,7 @@
>>  #include <linux/kvm_host.h>
>>  #include <linux/vfio.h>
>>  #include <linux/mdev.h>
>> +#include <linux/vfio_mdev.h>
>>  #include <linux/debugfs.h>
>>  
>>  #include <linux/nospec.h>
>> @@ -643,6 +644,8 @@ static void kvmgt_put_vfio_device(void *vgpu)
>>  	vfio_device_put(((struct intel_vgpu *)vgpu)->vdev.vfio_device);
>>  }
>>  
>> +static struct vfio_mdev_device_ops intel_vfio_vgpu_dev_ops;
>> +
>>  static int intel_vgpu_create(struct kobject *kobj, struct mdev_device *mdev)
>>  {
>>  	struct intel_vgpu *vgpu = NULL;
>> @@ -679,6 +682,7 @@ static int intel_vgpu_create(struct kobject *kobj, struct mdev_device *mdev)
>>  	ret = 0;
>>  
>>  	mdev_set_class_id(mdev, MDEV_ID_VFIO);
>> +	mdev_set_dev_ops(mdev, &intel_vfio_vgpu_dev_ops);
> This seems rather unrefined.  We're registering interdependent data in
> separate calls.  All drivers need to make both of these calls.  I'm not
> sure if this is a good idea, but what if we had:
>
> static const struct vfio_mdev_device_ops intel_vfio_vgpu_dev_ops = {
> 	.id			= MDEV_ID_VFIO,
>  	.open			= intel_vgpu_open,
>  	.release		= intel_vgpu_release,
>         ...
>
> And the set function passed &intel_vfio_vgpu_dev_ops.id and the mdev
> bus drivers used container_of to get to their callbacks?


Yes, with the check of mdev_device_create() if nothing is set by the device.


>
>>  out:
>>  	return ret;
>>  }
>> @@ -1601,20 +1605,21 @@ static const struct attribute_group *intel_vgpu_groups[] = {
>>  	NULL,
>>  };
>>  
>> -static struct mdev_parent_ops intel_vgpu_ops = {
>> -	.mdev_attr_groups       = intel_vgpu_groups,
>> -	.create			= intel_vgpu_create,
>> -	.remove			= intel_vgpu_remove,
>> -
>> +static struct vfio_mdev_device_ops intel_vfio_vgpu_dev_ops = {
>>  	.open			= intel_vgpu_open,
>>  	.release		= intel_vgpu_release,
>> -
>>  	.read			= intel_vgpu_read,
>>  	.write			= intel_vgpu_write,
>>  	.mmap			= intel_vgpu_mmap,
>>  	.ioctl			= intel_vgpu_ioctl,
>>  };
>>  
>> +static struct mdev_parent_ops intel_vgpu_ops = {
> These could maybe be made const at the same time.  Thanks,
>
> Alex


Ok, let me fix.

Thanks


