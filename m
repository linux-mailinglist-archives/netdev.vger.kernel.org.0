Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895BCD8797
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 06:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391015AbfJPElI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 00:41:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55874 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbfJPElI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 00:41:08 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3E8CA8E1CED;
        Wed, 16 Oct 2019 04:41:07 +0000 (UTC)
Received: from [10.72.12.53] (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7DDE5D9CD;
        Wed, 16 Oct 2019 04:38:53 +0000 (UTC)
Subject: Re: [PATCH V3 1/7] mdev: class id support
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
References: <20191011081557.28302-1-jasowang@redhat.com>
 <20191011081557.28302-2-jasowang@redhat.com>
 <20191015103806.0538ccb2@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3f6121a9-7d25-df8d-86ec-14443ab036f6@redhat.com>
Date:   Wed, 16 Oct 2019 12:38:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015103806.0538ccb2@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Wed, 16 Oct 2019 04:41:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/16 上午12:38, Alex Williamson wrote:
> On Fri, 11 Oct 2019 16:15:51 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>    
>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>> index b558d4cfd082..724e9b9841d8 100644
>> --- a/drivers/vfio/mdev/mdev_core.c
>> +++ b/drivers/vfio/mdev/mdev_core.c
>> @@ -45,6 +45,12 @@ void mdev_set_drvdata(struct mdev_device *mdev, void *data)
>>   }
>>   EXPORT_SYMBOL(mdev_set_drvdata);
>>   
>> +void mdev_set_class(struct mdev_device *mdev, u16 id)
>> +{
>> +	mdev->class_id = id;
>> +}
>> +EXPORT_SYMBOL(mdev_set_class);
>> +
>>   struct device *mdev_dev(struct mdev_device *mdev)
>>   {
>>   	return &mdev->dev;
>> @@ -135,6 +141,7 @@ static int mdev_device_remove_cb(struct device *dev, void *data)
>>    * mdev_register_device : Register a device
>>    * @dev: device structure representing parent device.
>>    * @ops: Parent device operation structure to be registered.
>> + * @id: class id.
>>    *
>>    * Add device to list of registered parent devices.
>>    * Returns a negative value on error, otherwise 0.
>> @@ -324,6 +331,9 @@ int mdev_device_create(struct kobject *kobj,
>>   	if (ret)
>>   		goto ops_create_fail;
>>   
>> +	if (!mdev->class_id)
> This is a sanity test failure of the parent driver on a privileged
> path, I think it's fair to print a warning when this occurs rather than
> only return an errno to the user.  In fact, ret is not set to an error
> value here, so it looks like this fails to create the device but
> returns success.  Thanks,
>
> Alex


Will fix.

Thanks


>
>> +		goto class_id_fail;
>> +
>>   	ret = device_add(&mdev->dev);
>>   	if (ret)
>>   		goto add_fail;
>> @@ -340,6 +350,7 @@ int mdev_device_create(struct kobject *kobj,
>>   
>>   sysfs_fail:
>>   	device_del(&mdev->dev);
>> +class_id_fail:
>>   add_fail:
>>   	parent->ops->remove(mdev);
>>   ops_create_fail:
