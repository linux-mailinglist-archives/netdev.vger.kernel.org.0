Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F02BC57D
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 12:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504460AbfIXKMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 06:12:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438540AbfIXKMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 06:12:02 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1163330860BD;
        Tue, 24 Sep 2019 10:12:01 +0000 (UTC)
Received: from [10.72.12.44] (ovpn-12-44.pek2.redhat.com [10.72.12.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7AF219C58;
        Tue, 24 Sep 2019 10:11:39 +0000 (UTC)
Subject: Re: [PATCH 1/6] mdev: class id support
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
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com
References: <20190923130331.29324-1-jasowang@redhat.com>
 <20190923130331.29324-2-jasowang@redhat.com>
 <20190923100529.54568ad8@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e565c496-7ce8-5889-57c7-7356458c50d5@redhat.com>
Date:   Tue, 24 Sep 2019 18:11:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190923100529.54568ad8@x1.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 24 Sep 2019 10:12:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/24 上午12:05, Alex Williamson wrote:
> On Mon, 23 Sep 2019 21:03:26 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> Mdev bus only supports vfio driver right now, so it doesn't implement
>> match method. But in the future, we may add drivers other than vfio,
>> one example is virtio-mdev[1] driver. This means we need to add device
>> class id support in bus match method to pair the mdev device and mdev
>> driver correctly.
>>
>> So this patch adds id_table to mdev_driver and class_id for mdev
>> parent with the match method for mdev bus.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>  Documentation/driver-api/vfio-mediated-device.rst |  7 +++++--
>>  drivers/gpu/drm/i915/gvt/kvmgt.c                  |  2 +-
>>  drivers/s390/cio/vfio_ccw_ops.c                   |  2 +-
>>  drivers/s390/crypto/vfio_ap_ops.c                 |  3 ++-
>>  drivers/vfio/mdev/mdev_core.c                     | 14 ++++++++++++--
>>  drivers/vfio/mdev/mdev_driver.c                   | 14 ++++++++++++++
>>  drivers/vfio/mdev/mdev_private.h                  |  1 +
>>  drivers/vfio/mdev/vfio_mdev.c                     |  6 ++++++
>>  include/linux/mdev.h                              |  7 ++++++-
>>  include/linux/mod_devicetable.h                   |  8 ++++++++
>>  samples/vfio-mdev/mbochs.c                        |  2 +-
>>  samples/vfio-mdev/mdpy.c                          |  2 +-
>>  samples/vfio-mdev/mtty.c                          |  2 +-
>>  13 files changed, 59 insertions(+), 11 deletions(-)
>>
>> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
>> index 25eb7d5b834b..0e052072e1d8 100644
>> --- a/Documentation/driver-api/vfio-mediated-device.rst
>> +++ b/Documentation/driver-api/vfio-mediated-device.rst
>> @@ -102,12 +102,14 @@ structure to represent a mediated device's driver::
>>        * @probe: called when new device created
>>        * @remove: called when device removed
>>        * @driver: device driver structure
>> +      * @id_table: the ids serviced by this driver.
>>        */
>>       struct mdev_driver {
>>  	     const char *name;
>>  	     int  (*probe)  (struct device *dev);
>>  	     void (*remove) (struct device *dev);
>>  	     struct device_driver    driver;
>> +	     const struct mdev_class_id *id_table;
>>       };
>>  
>>  A mediated bus driver for mdev should use this structure in the function calls
>> @@ -116,7 +118,7 @@ to register and unregister itself with the core driver:
>>  * Register::
>>  
>>      extern int  mdev_register_driver(struct mdev_driver *drv,
>> -				   struct module *owner);
>> +                                     struct module *owner);
>>  
>>  * Unregister::
>>  
>> @@ -163,7 +165,8 @@ A driver should use the mdev_parent_ops structure in the function call to
>>  register itself with the mdev core driver::
>>  
>>  	extern int  mdev_register_device(struct device *dev,
>> -	                                 const struct mdev_parent_ops *ops);
>> +	                                 const struct mdev_parent_ops *ops,
>> +	                                 u8 class_id);
>>  
>>  However, the mdev_parent_ops structure is not required in the function call
>>  that a driver should use to unregister itself with the mdev core driver::
>> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> index 23aa3e50cbf8..19d51a35f019 100644
>> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
>> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> @@ -1625,7 +1625,7 @@ static int kvmgt_host_init(struct device *dev, void *gvt, const void *ops)
>>  		return -EFAULT;
>>  	intel_vgpu_ops.supported_type_groups = kvm_vgpu_type_groups;
>>  
>> -	return mdev_register_device(dev, &intel_vgpu_ops);
>> +	return mdev_register_vfio_device(dev, &intel_vgpu_ops);
>>  }
>>  
>>  static void kvmgt_host_exit(struct device *dev)
>> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
>> index f0d71ab77c50..246ff0f80944 100644
>> --- a/drivers/s390/cio/vfio_ccw_ops.c
>> +++ b/drivers/s390/cio/vfio_ccw_ops.c
>> @@ -588,7 +588,7 @@ static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
>>  
>>  int vfio_ccw_mdev_reg(struct subchannel *sch)
>>  {
>> -	return mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops);
>> +	return mdev_register_vfio_device(&sch->dev, &vfio_ccw_mdev_ops);
>>  }
>>  
>>  void vfio_ccw_mdev_unreg(struct subchannel *sch)
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 5c0f53c6dde7..7487fc39d2c5 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1295,7 +1295,8 @@ int vfio_ap_mdev_register(void)
>>  {
>>  	atomic_set(&matrix_dev->available_instances, MAX_ZDEV_ENTRIES_EXT);
>>  
>> -	return mdev_register_device(&matrix_dev->device, &vfio_ap_matrix_ops);
>> +	return mdev_register_vfio_device(&matrix_dev->device,
>> +					 &vfio_ap_matrix_ops);
>>  }
>>  
>>  void vfio_ap_mdev_unregister(void)
>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>> index b558d4cfd082..a02c256a3514 100644
>> --- a/drivers/vfio/mdev/mdev_core.c
>> +++ b/drivers/vfio/mdev/mdev_core.c
>> @@ -135,11 +135,14 @@ static int mdev_device_remove_cb(struct device *dev, void *data)
>>   * mdev_register_device : Register a device
>>   * @dev: device structure representing parent device.
>>   * @ops: Parent device operation structure to be registered.
>> + * @id: device id.
>>   *
>>   * Add device to list of registered parent devices.
>>   * Returns a negative value on error, otherwise 0.
>>   */
>> -int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>> +int mdev_register_device(struct device *dev,
>> +			 const struct mdev_parent_ops *ops,
>> +			 u8 class_id)
>>  {
>>  	int ret;
>>  	struct mdev_parent *parent;
>> @@ -175,6 +178,7 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>>  
>>  	parent->dev = dev;
>>  	parent->ops = ops;
>> +	parent->class_id = class_id;
>>  
> I don't think we want to tie the class_id to the parent.  mdev parent
> devices can create various types of devices, some might be virtio, some
> might be vfio.  I think the cover letter even suggests that's a
> direction these virtio devices might be headed.  It seems the class
> should be on the resulting device itself.  That also suggests that at
> the parent we cannot have a single device_ops, the ops used will depend
> on the type of device created.  Perhaps that means we need vfio_ops
> alongside virtio_ops, rather than a common device_ops.  Thanks,
>
> Alex
>

Yes, will do it in V2.

Thanks

