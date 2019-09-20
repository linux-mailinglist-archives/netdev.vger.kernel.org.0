Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A5AB88EB
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 03:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394593AbfITBbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 21:31:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391404AbfITBbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 21:31:20 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA48B308FB9D;
        Fri, 20 Sep 2019 01:31:19 +0000 (UTC)
Received: from [10.72.12.88] (ovpn-12-88.pek2.redhat.com [10.72.12.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5392F100197A;
        Fri, 20 Sep 2019 01:31:00 +0000 (UTC)
Subject: Re: [RFC v4 0/3] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
References: <20190917010204.30376-1-tiwei.bie@intel.com>
 <993841ed-942e-c90b-8016-8e7dc76bf13a@redhat.com>
 <20190917105801.GA24855@___>
 <fa6957f3-19ad-f351-8c43-65bc8342b82e@redhat.com>
 <20190918102923-mutt-send-email-mst@kernel.org>
 <d2efe7e4-cf13-437d-e2dc-e2779fac7d2f@redhat.com>
 <20190919154552.GA27657@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <43aaf7dc-f08b-8898-3c55-908ff4d68866@redhat.com>
Date:   Fri, 20 Sep 2019 09:30:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919154552.GA27657@___>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 20 Sep 2019 01:31:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/19 下午11:45, Tiwei Bie wrote:
> On Thu, Sep 19, 2019 at 09:08:11PM +0800, Jason Wang wrote:
>> On 2019/9/18 下午10:32, Michael S. Tsirkin wrote:
>>>>>> So I have some questions:
>>>>>>
>>>>>> 1) Compared to method 2, what's the advantage of creating a new vhost char
>>>>>> device? I guess it's for keep the API compatibility?
>>>>> One benefit is that we can avoid doing vhost ioctls on
>>>>> VFIO device fd.
>>>> Yes, but any benefit from doing this?
>>> It does seem a bit more modular, but it's certainly not a big deal.
>> Ok, if we go this way, it could be as simple as provide some callback to
>> vhost, then vhost can just forward the ioctl through parent_ops.
>>
>>>>>> 2) For method 2, is there any easy way for user/admin to distinguish e.g
>>>>>> ordinary vfio-mdev for vhost from ordinary vfio-mdev?
>>>>> I think device-api could be a choice.
>>>> Ok.
>>>>
>>>>
>>>>>> I saw you introduce
>>>>>> ops matching helper but it's not friendly to management.
>>>>> The ops matching helper is just to check whether a given
>>>>> vfio-device is based on a mdev device.
>>>>>
>>>>>> 3) A drawback of 1) and 2) is that it must follow vfio_device_ops that
>>>>>> assumes the parameter comes from userspace, it prevents support kernel
>>>>>> virtio drivers.
>>>>>>
>>>>>> 4) So comes the idea of method 3, since it register a new vhost-mdev driver,
>>>>>> we can use device specific ops instead of VFIO ones, then we can have a
>>>>>> common API between vDPA parent and vhost-mdev/virtio-mdev drivers.
>>>>> As the above draft shows, this requires introducing a new
>>>>> VFIO device driver. I think Alex's opinion matters here.
>> Just to clarify, a new type of mdev driver but provides dummy
>> vfio_device_ops for VFIO to make container DMA ioctl work.
> I see. Thanks! IIUC, you mean we can provide a very tiny
> VFIO device driver in drivers/vhost/mdev.c, e.g.:
>
> static int vfio_vhost_mdev_open(void *device_data)
> {
> 	if (!try_module_get(THIS_MODULE))
> 		return -ENODEV;
> 	return 0;
> }
>
> static void vfio_vhost_mdev_release(void *device_data)
> {
> 	module_put(THIS_MODULE);
> }
>
> static const struct vfio_device_ops vfio_vhost_mdev_dev_ops = {
> 	.name		= "vfio-vhost-mdev",
> 	.open		= vfio_vhost_mdev_open,
> 	.release	= vfio_vhost_mdev_release,
> };
>
> static int vhost_mdev_probe(struct device *dev)
> {
> 	struct mdev_device *mdev = to_mdev_device(dev);
>
> 	... Check the mdev device_id proposed in ...
> 	... https://lkml.org/lkml/2019/9/12/151 ...


To clarify, this should be done through the id_table fields in 
vhost_mdev_driver, and it should claim it supports virtio-mdev device only:


static struct mdev_class_id id_table[] = {
     { MDEV_ID_VIRTIO },
     { 0 },
};


static struct mdev_driver vhost_mdev_driver = {
     ...
     .id_table = id_table,
}


>
> 	return vfio_add_group_dev(dev, &vfio_vhost_mdev_dev_ops, mdev);


And in vfio_vhost_mdev_ops, all its need is to just implement vhost-net 
ioctl and translate them to virtio-mdev transport (e.g device_ops I 
proposed or ioctls other whatever other method) API. And it could have a 
dummy ops implementation for the other device_ops.


> }
>
> static void vhost_mdev_remove(struct device *dev)
> {
> 	vfio_del_group_dev(dev);
> }
>
> static struct mdev_driver vhost_mdev_driver = {
> 	.name	= "vhost_mdev",
> 	.probe	= vhost_mdev_probe,
> 	.remove	= vhost_mdev_remove,
> };
>
> So we can bind above mdev driver to the virtio-mdev compatible
> mdev devices when we want to use vhost-mdev.
>
> After binding above driver to the mdev device, we can setup IOMMU
> via VFIO and get VFIO device fd of this mdev device, and pass it
> to vhost fd (/dev/vhost-mdev) with a SET_BACKEND ioctl.


Then what vhost-mdev char device did is just forwarding ioctl back to 
this vfio device fd which seems a overkill. It's simpler that just do 
ioctl on the device ops directly.

Thanks


>
> Thanks,
> Tiwei
>
>> Thanks
>>
>>
>>>> Yes, it is.
>>>>
>>>> Thanks
>>>>
>>>>
