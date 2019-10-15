Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9A1D7648
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 14:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfJOMRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 08:17:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfJOMRe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 08:17:34 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 12DEBC05B00E;
        Tue, 15 Oct 2019 12:17:33 +0000 (UTC)
Received: from [10.72.12.168] (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99C9760BE2;
        Tue, 15 Oct 2019 12:17:02 +0000 (UTC)
Subject: Re: [PATCH V3 4/7] mdev: introduce device specific ops
To:     Cornelia Huck <cohuck@redhat.com>
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
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com
References: <20191011081557.28302-1-jasowang@redhat.com>
 <20191011081557.28302-5-jasowang@redhat.com>
 <20191015124137.4f948bd2.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <eb7ecd99-7465-6be4-7ecd-84c11f66e0ac@redhat.com>
Date:   Tue, 15 Oct 2019 20:17:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015124137.4f948bd2.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 15 Oct 2019 12:17:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/15 下午6:41, Cornelia Huck wrote:
> On Fri, 11 Oct 2019 16:15:54 +0800
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
>>   .../driver-api/vfio-mediated-device.rst       | 22 +++++---
>>   MAINTAINERS                                   |  1 +
>>   drivers/gpu/drm/i915/gvt/kvmgt.c              | 18 ++++---
>>   drivers/s390/cio/vfio_ccw_ops.c               | 18 ++++---
>>   drivers/s390/crypto/vfio_ap_ops.c             | 14 +++--
>>   drivers/vfio/mdev/mdev_core.c                 |  9 +++-
>>   drivers/vfio/mdev/mdev_private.h              |  1 +
>>   drivers/vfio/mdev/vfio_mdev.c                 | 37 ++++++-------
>>   include/linux/mdev.h                          | 42 +++------------
>>   include/linux/vfio_mdev.h                     | 52 +++++++++++++++++++
>>   samples/vfio-mdev/mbochs.c                    | 20 ++++---
>>   samples/vfio-mdev/mdpy.c                      | 21 +++++---
>>   samples/vfio-mdev/mtty.c                      | 18 ++++---
>>   13 files changed, 177 insertions(+), 96 deletions(-)
>>   create mode 100644 include/linux/vfio_mdev.h
>>
>> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
>> index 2035e48da7b2..553574ebba73 100644
>> --- a/Documentation/driver-api/vfio-mediated-device.rst
>> +++ b/Documentation/driver-api/vfio-mediated-device.rst
>> @@ -152,11 +152,20 @@ callbacks per mdev parent device, per mdev type, or any other categorization.
>>   Vendor drivers are expected to be fully asynchronous in this respect or
>>   provide their own internal resource protection.)
>>   
>> -The callbacks in the mdev_parent_ops structure are as follows:
>> +In order to support multiple types of device/driver, device needs to
>> +provide both class_id and device_ops through:
> "As multiple types of mediated devices may be supported, the device
> needs to set up the class id and the device specific callbacks via:"
>
> ?
>
>>   
>> -* open: open callback of mediated device
>> -* close: close callback of mediated device
>> -* ioctl: ioctl callback of mediated device
>> +    void mdev_set_class(struct mdev_device *mdev, u16 id, const void *ops);
>> +
>> +The class_id is used to be paired with ids in id_table in mdev_driver
>> +structure for probing the correct driver.
> "The class id  (specified in id) is used to match a device with an mdev
> driver via its id table."
>
> ?
>
>> The device_ops is device
>> +specific callbacks which can be get through mdev_get_dev_ops()
>> +function by mdev bus driver.
> "The device specific callbacks (specified in *ops) are obtainable via
> mdev_get_dev_ops() (for use by the mdev bus driver.)"
>
> ?
>
>> For vfio-mdev device, its device specific
>> +ops are as follows:
> "A vfio-mdev device (class id MDEV_ID_VFIO) uses the following
> device-specific ops:"
>
> ?


All you propose is better than what I wrote, will change the docs.


>
>> +
>> +* open: open callback of vfio mediated device
>> +* close: close callback of vfio mediated device
>> +* ioctl: ioctl callback of vfio mediated device
>>   * read : read emulation callback
>>   * write: write emulation callback
>>   * mmap: mmap emulation callback
>> @@ -167,9 +176,10 @@ register itself with the mdev core driver::
>>   	extern int  mdev_register_device(struct device *dev,
>>   	                                 const struct mdev_parent_ops *ops);
>>   
>> -It is also required to specify the class_id through::
>> +It is also required to specify the class_id and device specific ops through::
>>   
>> -	extern int mdev_set_class(struct device *dev, u16 id);
>> +	extern int mdev_set_class(struct device *dev, u16 id,
>> +	                          const void *ops);
> Apologies if that has already been discussed, but do we want a 1:1
> relationship between id and ops, or can different devices with the same
> id register different ops?


I think we have a N:1 mapping between id and ops, e.g we want both 
virtio-mdev and vhost-mdev use a single set of device ops.

Thanks


> If the former, would it make sense to first
> register the ops for an id (once), and then have the ->create callback
> only set the class id (with the core doing the lookup of the ops)?
>
>>   
>>   However, the mdev_parent_ops structure is not required in the function call
>>   that a driver should use to unregister itself with the mdev core driver::
