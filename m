Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDEDFD7631
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 14:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfJOMNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 08:13:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53128 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfJOMNx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 08:13:53 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6C5E2306F4AE;
        Tue, 15 Oct 2019 12:13:53 +0000 (UTC)
Received: from [10.72.12.168] (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B70B608C0;
        Tue, 15 Oct 2019 12:13:31 +0000 (UTC)
Subject: Re: [PATCH V3 2/7] mdev: bus uevent support
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
 <20191011081557.28302-3-jasowang@redhat.com>
 <20191015122707.1fd52240.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <515d31c5-a7d9-5a22-b570-2035ecf03c09@redhat.com>
Date:   Tue, 15 Oct 2019 20:13:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015122707.1fd52240.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 15 Oct 2019 12:13:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/15 下午6:27, Cornelia Huck wrote:
> On Fri, 11 Oct 2019 16:15:52 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> This patch adds bus uevent support for mdev bus in order to allow
>> cooperation with userspace.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vfio/mdev/mdev_driver.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
>> index b7c40ce86ee3..319d886ffaf7 100644
>> --- a/drivers/vfio/mdev/mdev_driver.c
>> +++ b/drivers/vfio/mdev/mdev_driver.c
>> @@ -82,9 +82,17 @@ static int mdev_match(struct device *dev, struct device_driver *drv)
>>   	return 0;
>>   }
>>   
>> +static int mdev_uevent(struct device *dev, struct kobj_uevent_env *env)
>> +{
>> +	struct mdev_device *mdev = to_mdev_device(dev);
>> +
>> +	return add_uevent_var(env, "MODALIAS=mdev:c%02X", mdev->class_id);
>> +}
>> +
>>   struct bus_type mdev_bus_type = {
>>   	.name		= "mdev",
>>   	.match		= mdev_match,
>> +	.uevent		= mdev_uevent,
>>   	.probe		= mdev_probe,
>>   	.remove		= mdev_remove,
>>   };
> I'd merge that into the previous patch.


Will do.

Thanks


