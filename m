Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848BEAF991
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfIKJyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:54:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbfIKJyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 05:54:04 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 40E9D11A27;
        Wed, 11 Sep 2019 09:54:04 +0000 (UTC)
Received: from [10.72.12.57] (ovpn-12-57.pek2.redhat.com [10.72.12.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54F636012A;
        Wed, 11 Sep 2019 09:53:50 +0000 (UTC)
Subject: Re: [RFC PATCH 3/4] virtio: introudce a mdev based transport
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com,
        cohuck@redhat.com, tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, idos@mellanox.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com
References: <20190910081935.30516-1-jasowang@redhat.com>
 <20190910081935.30516-4-jasowang@redhat.com>
 <20190910055744-mutt-send-email-mst@kernel.org>
 <572ffc34-3081-8503-d3cc-192edc9b5311@redhat.com>
 <20190910094807-mutt-send-email-mst@kernel.org>
 <390647ae-0a53-5f2b-ccb0-28ed657636e6@redhat.com>
 <20190911053502-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <27fa6786-6e00-a7d3-bd35-7c302514c1b5@redhat.com>
Date:   Wed, 11 Sep 2019 17:53:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190911053502-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 11 Sep 2019 09:54:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/11 下午5:36, Michael S. Tsirkin wrote:
> On Wed, Sep 11, 2019 at 10:38:39AM +0800, Jason Wang wrote:
>> On 2019/9/10 下午9:52, Michael S. Tsirkin wrote:
>>> On Tue, Sep 10, 2019 at 09:13:02PM +0800, Jason Wang wrote:
>>>> On 2019/9/10 下午6:01, Michael S. Tsirkin wrote:
>>>>>> +#ifndef _LINUX_VIRTIO_MDEV_H
>>>>>> +#define _LINUX_VIRTIO_MDEV_H
>>>>>> +
>>>>>> +#include <linux/interrupt.h>
>>>>>> +#include <linux/vringh.h>
>>>>>> +#include <uapi/linux/virtio_net.h>
>>>>>> +
>>>>>> +/*
>>>>>> + * Ioctls
>>>>>> + */
>>>>> Pls add a bit more content here. It's redundant to state these
>>>>> are ioctls. Much better to document what does each one do.
>>>> Ok.
>>>>
>>>>
>>>>>> +
>>>>>> +struct virtio_mdev_callback {
>>>>>> +	irqreturn_t (*callback)(void *);
>>>>>> +	void *private;
>>>>>> +};
>>>>>> +
>>>>>> +#define VIRTIO_MDEV 0xAF
>>>>>> +#define VIRTIO_MDEV_SET_VQ_CALLBACK _IOW(VIRTIO_MDEV, 0x00, \
>>>>>> +					 struct virtio_mdev_callback)
>>>>>> +#define VIRTIO_MDEV_SET_CONFIG_CALLBACK _IOW(VIRTIO_MDEV, 0x01, \
>>>>>> +					struct virtio_mdev_callback)
>>>>> Function pointer in an ioctl parameter? How does this ever make sense?
>>>> I admit this is hacky (casting).
>>>>
>>>>
>>>>> And can't we use a couple of registers for this, and avoid ioctls?
>>>> Yes, how about something like interrupt numbers for each virtqueue and
>>>> config?
>>> Should we just reuse VIRTIO_PCI_COMMON_Q_XXX then?
>>
>> You mean something like VIRTIO_PCI_COMMON_Q_MSIX? Then it becomes a PCI
>> transport in fact. And using either MSIX or irq number is actually another
>> layer of indirection. So I think we can just write callback function and
>> parameter through registers.
> I just realized, all these registers are just encoded so you
> can pass stuff through read/write. But it can instead be
> just a normal C function call with no messy encoding.
> So why do we want to do this encoding?


Just because it was easier to start as a POC since mdev_parent_ops is 
the only way to communicate between mdev driver and mdev device right 
now. We can invent private ops besides mdev_parent_ops, e.g a private 
pointer in mdev_parent_ops. I can try this in next version.

Thanks

