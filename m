Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744155E39F
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 14:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfGCMQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 08:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCMQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 08:16:41 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 35E6530872E8;
        Wed,  3 Jul 2019 12:16:41 +0000 (UTC)
Received: from [10.72.12.173] (ovpn-12-173.pek2.redhat.com [10.72.12.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A9EF5D9DE;
        Wed,  3 Jul 2019 12:16:25 +0000 (UTC)
Subject: Re: [RFC v2] vhost: introduce mdev based hardware vhost backend
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com
References: <20190703091339.1847-1-tiwei.bie@intel.com>
 <7b8279b2-aa7e-7adc-eeff-20dfaf4400d0@redhat.com>
 <20190703115245.GA22374@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <64833f91-02cd-7143-f12e-56ab93b2418d@redhat.com>
Date:   Wed, 3 Jul 2019 20:16:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703115245.GA22374@___>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 03 Jul 2019 12:16:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/3 下午7:52, Tiwei Bie wrote:
> On Wed, Jul 03, 2019 at 06:09:51PM +0800, Jason Wang wrote:
>> On 2019/7/3 下午5:13, Tiwei Bie wrote:
>>> Details about this can be found here:
>>>
>>> https://lwn.net/Articles/750770/
>>>
>>> What's new in this version
>>> ==========================
>>>
>>> A new VFIO device type is introduced - vfio-vhost. This addressed
>>> some comments from here: https://patchwork.ozlabs.org/cover/984763/
>>>
>>> Below is the updated device interface:
>>>
>>> Currently, there are two regions of this device: 1) CONFIG_REGION
>>> (VFIO_VHOST_CONFIG_REGION_INDEX), which can be used to setup the
>>> device; 2) NOTIFY_REGION (VFIO_VHOST_NOTIFY_REGION_INDEX), which
>>> can be used to notify the device.
>>>
>>> 1. CONFIG_REGION
>>>
>>> The region described by CONFIG_REGION is the main control interface.
>>> Messages will be written to or read from this region.
>>>
>>> The message type is determined by the `request` field in message
>>> header. The message size is encoded in the message header too.
>>> The message format looks like this:
>>>
>>> struct vhost_vfio_op {
>>> 	__u64 request;
>>> 	__u32 flags;
>>> 	/* Flag values: */
>>>    #define VHOST_VFIO_NEED_REPLY 0x1 /* Whether need reply */
>>> 	__u32 size;
>>> 	union {
>>> 		__u64 u64;
>>> 		struct vhost_vring_state state;
>>> 		struct vhost_vring_addr addr;
>>> 	} payload;
>>> };
>>>
>>> The existing vhost-kernel ioctl cmds are reused as the message
>>> requests in above structure.
>>
>> Still a comments like V1. What's the advantage of inventing a new protocol?
> I'm trying to make it work in VFIO's way..
>
>> I believe either of the following should be better:
>>
>> - using vhost ioctl,  we can start from SET_VRING_KICK/SET_VRING_CALL and
>> extend it with e.g notify region. The advantages is that all exist userspace
>> program could be reused without modification (or minimal modification). And
>> vhost API hides lots of details that is not necessary to be understood by
>> application (e.g in the case of container).
> Do you mean reusing vhost's ioctl on VFIO device fd directly,
> or introducing another mdev driver (i.e. vhost_mdev instead of
> using the existing vfio_mdev) for mdev device?


Can we simply add them into ioctl of mdev_parent_ops?


>
>> - using PCI layout, then you don't even need to re-invent notifiy region at
>> all and we can pass-through them to guest.
> Like what you said previously, virtio has transports other than PCI.
> And it will look a bit odd when using transports other than PCI..


Yes.


>
>> Personally, I prefer vhost ioctl.
> +1
>
>>
> [...]
>>> 3. VFIO interrupt ioctl API
>>>
>>> VFIO interrupt ioctl API is used to setup device interrupts.
>>> IRQ-bypass can also be supported.
>>>
>>> Currently, the data path interrupt can be configured via the
>>> VFIO_VHOST_VQ_IRQ_INDEX with virtqueue's callfd.
>>
>> How about DMA API? Do you expect to use VFIO IOMMU API or using vhost
>> SET_MEM_TABLE? VFIO IOMMU API is more generic for sure but with
>> SET_MEM_TABLE DMA can be done at the level of parent device which means it
>> can work for e.g the card with on-chip IOMMU.
> Agree. In this RFC, it assumes userspace will use VFIO IOMMU API
> to do the DMA programming. But like what you said, there could be
> a problem when using cards with on-chip IOMMU.


Yes, another issue is SET_MEM_TABLE can not be used to update just a 
part of the table. This seems less flexible than VFIO API but it could 
be extended.


>
>> And what's the plan for vIOMMU?
> As this RFC assumes userspace will use VFIO IOMMU API, userspace
> just needs to follow the same way like what vfio-pci device does
> in QEMU to support vIOMMU.


Right, this is more a question for the qemu part. It means it needs to 
go for ordinary VFIO path to get all notifiers/listeners support from 
vIOMMU.


>
>>
>>> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
>>> ---
>>>    drivers/vhost/Makefile     |   2 +
>>>    drivers/vhost/vdpa.c       | 770 +++++++++++++++++++++++++++++++++++++
>>>    include/linux/vdpa_mdev.h  |  72 ++++
>>>    include/uapi/linux/vfio.h  |  19 +
>>>    include/uapi/linux/vhost.h |  25 ++
>>>    5 files changed, 888 insertions(+)
>>>    create mode 100644 drivers/vhost/vdpa.c
>>>    create mode 100644 include/linux/vdpa_mdev.h
>>
>> We probably need some sample parent device implementation. It could be a
>> software datapath like e.g we can start from virtio-net device in guest or a
>> vhost/tap on host.
> Yeah, something like this would be interesting!


Plan to do something like that :) ?

Thanks


>
> Thanks,
> Tiwei
>
>> Thanks
>>
>>
