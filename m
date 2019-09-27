Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7577C062A
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 15:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfI0NSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 09:18:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfI0NSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 09:18:13 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8AFDA30ADBBB;
        Fri, 27 Sep 2019 13:18:12 +0000 (UTC)
Received: from [10.72.12.24] (ovpn-12-24.pek2.redhat.com [10.72.12.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C9315D9C9;
        Fri, 27 Sep 2019 13:17:58 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <20190926042156-mutt-send-email-mst@kernel.org> <20190926131439.GA11652@___>
 <8ab5a8d9-284d-bba5-803d-08523c0814e1@redhat.com>
 <20190927053935-mutt-send-email-mst@kernel.org>
 <a959fe1e-3095-e0f0-0c9b-57f6eaa9c8b7@redhat.com>
 <20190927084408-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b6f6ffb2-0b16-5041-be2e-94b805c6a4c9@redhat.com>
Date:   Fri, 27 Sep 2019 21:17:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927084408-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 27 Sep 2019 13:18:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/27 下午8:46, Michael S. Tsirkin wrote:
> On Fri, Sep 27, 2019 at 08:17:47PM +0800, Jason Wang wrote:
>> On 2019/9/27 下午5:41, Michael S. Tsirkin wrote:
>>> On Fri, Sep 27, 2019 at 11:27:12AM +0800, Jason Wang wrote:
>>>> On 2019/9/26 下午9:14, Tiwei Bie wrote:
>>>>> On Thu, Sep 26, 2019 at 04:35:18AM -0400, Michael S. Tsirkin wrote:
>>>>>> On Thu, Sep 26, 2019 at 12:54:27PM +0800, Tiwei Bie wrote:
>>>>> [...]
>>>>>>> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
>>>>>>> index 40d028eed645..5afbc2f08fa3 100644
>>>>>>> --- a/include/uapi/linux/vhost.h
>>>>>>> +++ b/include/uapi/linux/vhost.h
>>>>>>> @@ -116,4 +116,12 @@
>>>>>>>     #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
>>>>>>>     #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
>>>>>>> +/* VHOST_MDEV specific defines */
>>>>>>> +
>>>>>>> +#define VHOST_MDEV_SET_STATE	_IOW(VHOST_VIRTIO, 0x70, __u64)
>>>>>>> +
>>>>>>> +#define VHOST_MDEV_S_STOPPED	0
>>>>>>> +#define VHOST_MDEV_S_RUNNING	1
>>>>>>> +#define VHOST_MDEV_S_MAX	2
>>>>>>> +
>>>>>>>     #endif
>>>>>> So assuming we have an underlying device that behaves like virtio:
>>>>> I think they are really good questions/suggestions. Thanks!
>>>>>
>>>>>> 1. Should we use SET_STATUS maybe?
>>>>> I like this idea. I will give it a try.
>>>>>
>>>>>> 2. Do we want a reset ioctl?
>>>>> I think it is helpful. If we use SET_STATUS, maybe we
>>>>> can use it to support the reset.
>>>>>
>>>>>> 3. Do we want ability to enable rings individually?
>>>>> I will make it possible at least in the vhost layer.
>>>> Note the API support e.g set_vq_ready().
>>> virtio spec calls this "enabled" so let's stick to that.
>>
>> Ok.
>>
>>
>>>>>> 4. Does device need to limit max ring size?
>>>>>> 5. Does device need to limit max number of queues?
>>>>> I think so. It's helpful to have ioctls to report the max
>>>>> ring size and max number of queues.
>>>> An issue is the max number of queues is done through a device specific way,
>>>> usually device configuration space. This is supported by the transport API,
>>>> but how to expose it to userspace may need more thought.
>>>>
>>>> Thanks
>>> an ioctl for device config?  But for v1 I'd be quite happy to just have
>>> a minimal working device with 2 queues.
>>
>> I'm fully agree, and it will work as long as VIRTIO_NET_F_MQ and
>> VIRTIO_NET_F_CTRL_VQ is not advertised by the mdev device.
>>
>> Thanks
> Hmm this means we need to validate the features bits,
> not just pass them through to the hardware.
> Problem is, how do we add more feature bits later,
> without testing all hardware?
> I guess this means the device specific driver must do it.
>

That looks not good, maybe a virtio device id based features blacklist 
in vhost-mdev. Then MQ and CTRL_VQ could be filtered out by vhost-mdev.

Thanks


>>>>> Thanks!
