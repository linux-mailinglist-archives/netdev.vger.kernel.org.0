Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36142E23B6
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 03:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgLXCit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 21:38:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39672 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728462AbgLXCit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 21:38:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608777442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PQ2p4ksHPTOq63DDyngHA9gf7FABh2CGteZ5vJN2Hj4=;
        b=ValuGKTXdGOIFmB3d0NdY9KO12PeZSwNyJ72adixZEClKJ8GXAFNP1QdyvqOAIcwIHwV7R
        UX5yHGP9fyK2rK6jZyEXZ8dHS0S23uUpKqawkjdbS2Pk5t5GhoIoXk7in88I79Oeepg75L
        /Z1njyNpNDJT6ogRrC/4g+9ZfKDJqyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-YqM85cXrO2aEDLgPJNwXEQ-1; Wed, 23 Dec 2020 21:37:18 -0500
X-MC-Unique: YqM85cXrO2aEDLgPJNwXEQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1A4E802B40;
        Thu, 24 Dec 2020 02:37:15 +0000 (UTC)
Received: from [10.72.13.109] (ovpn-13-109.pek2.redhat.com [10.72.13.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8146D5D9C6;
        Thu, 24 Dec 2020 02:37:00 +0000 (UTC)
Subject: Re: [RFC v2 08/13] vdpa: Introduce process_iotlb_msg() in
 vdpa_config_ops
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20201222145221.711-1-xieyongji@bytedance.com>
 <20201222145221.711-9-xieyongji@bytedance.com>
 <5b36bc51-1e19-2b59-6287-66aed435c8ed@redhat.com>
 <CACycT3tP8mgj043idjJW3BF12qmOhmHzYz8X5FyL8t5MbwLysw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4b13e574-d898-55cc-9ec6-78f28a7f2cd9@redhat.com>
Date:   Thu, 24 Dec 2020 10:36:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3tP8mgj043idjJW3BF12qmOhmHzYz8X5FyL8t5MbwLysw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/23 下午7:06, Yongji Xie wrote:
> On Wed, Dec 23, 2020 at 4:37 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2020/12/22 下午10:52, Xie Yongji wrote:
>>> This patch introduces a new method in the vdpa_config_ops to
>>> support processing the raw vhost memory mapping message in the
>>> vDPA device driver.
>>>
>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>> ---
>>>    drivers/vhost/vdpa.c | 5 ++++-
>>>    include/linux/vdpa.h | 7 +++++++
>>>    2 files changed, 11 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>> index 448be7875b6d..ccbb391e38be 100644
>>> --- a/drivers/vhost/vdpa.c
>>> +++ b/drivers/vhost/vdpa.c
>>> @@ -728,6 +728,9 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>>>        if (r)
>>>                return r;
>>>
>>> +     if (ops->process_iotlb_msg)
>>> +             return ops->process_iotlb_msg(vdpa, msg);
>>> +
>>>        switch (msg->type) {
>>>        case VHOST_IOTLB_UPDATE:
>>>                r = vhost_vdpa_process_iotlb_update(v, msg);
>>> @@ -770,7 +773,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>>>        int ret;
>>>
>>>        /* Device want to do DMA by itself */
>>> -     if (ops->set_map || ops->dma_map)
>>> +     if (ops->set_map || ops->dma_map || ops->process_iotlb_msg)
>>>                return 0;
>>>
>>>        bus = dma_dev->bus;
>>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>>> index 656fe264234e..7bccedf22f4b 100644
>>> --- a/include/linux/vdpa.h
>>> +++ b/include/linux/vdpa.h
>>> @@ -5,6 +5,7 @@
>>>    #include <linux/kernel.h>
>>>    #include <linux/device.h>
>>>    #include <linux/interrupt.h>
>>> +#include <linux/vhost_types.h>
>>>    #include <linux/vhost_iotlb.h>
>>>    #include <net/genetlink.h>
>>>
>>> @@ -172,6 +173,10 @@ struct vdpa_iova_range {
>>>     *                          @vdev: vdpa device
>>>     *                          Returns the iova range supported by
>>>     *                          the device.
>>> + * @process_iotlb_msg:               Process vhost memory mapping message (optional)
>>> + *                           Only used for VDUSE device now
>>> + *                           @vdev: vdpa device
>>> + *                           @msg: vhost memory mapping message
>>>     * @set_map:                        Set device memory mapping (optional)
>>>     *                          Needed for device that using device
>>>     *                          specific DMA translation (on-chip IOMMU)
>>> @@ -240,6 +245,8 @@ struct vdpa_config_ops {
>>>        struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev);
>>>
>>>        /* DMA ops */
>>> +     int (*process_iotlb_msg)(struct vdpa_device *vdev,
>>> +                              struct vhost_iotlb_msg *msg);
>>>        int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
>>>        int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
>>>                       u64 pa, u32 perm);
>>
>> Is there any reason that it can't be done via dma_map/dma_unmap or set_map?
>>
> To get the shmfd, we need the vma rather than physical address. And
> it's not necessary to pin the user pages in VDUSE case.


Right, actually, vhost-vDPA is planning to support shared virtual 
address space.

So let's try to reuse the existing config ops. How about just introduce 
an attribute to vdpa device that tells the bus tells the bus it can do 
shared virtual memory. Then when the device is probed by vhost-vDPA, use 
pages won't be pinned and we will do VA->VA mapping as IOVA->PA mapping 
in the vhost IOTLB and the config ops. vhost IOTLB needs to be extended 
to accept opaque pointer to store the file. And the file was pass via 
the config ops as well.

Thanks



>
> Thanks,
> Yongji
>

