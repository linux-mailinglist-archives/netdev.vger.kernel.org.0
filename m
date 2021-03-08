Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB7533063D
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 04:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhCHDFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 22:05:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40330 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232550AbhCHDEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 22:04:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615172692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZQ70pDj5dEOXIb2t5wCoSU7jEwsufzOZ8z9pXIzIxMM=;
        b=AZZ3Nn1bI8bh8uqXgwhxDnb5/HV9L4/Fb0K21GL3RxzRbWzu94oEQYjs22XGZpnWzbo4Vg
        NC9sUuOON8S/5ORU5ZLvvEIvsp76eNzfesD01x47ifa0bXRmdMkNo6ASsAzRBWSnJ5Q+0z
        bUvrj5y++Aj6UIV6+4EMT9LelE6V67A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-uCwZu4jqOIGomMe_kzQ61Q-1; Sun, 07 Mar 2021 22:04:48 -0500
X-MC-Unique: uCwZu4jqOIGomMe_kzQ61Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB6AF5223;
        Mon,  8 Mar 2021 03:04:45 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99C8B5D9D0;
        Mon,  8 Mar 2021 03:04:33 +0000 (UTC)
Subject: Re: [RFC v4 10/11] vduse: Introduce a workqueue for irq injection
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-11-xieyongji@bytedance.com>
 <d63e4cfd-4992-8493-32b0-18e0478f6e1a@redhat.com>
 <CACycT3tqM=ALOG1r0Ve6UTGmwJ7Wg7fQpLZypjZsJF1mJ+adMA@mail.gmail.com>
 <2d3418d9-856c-37ee-7614-af5b721becd7@redhat.com>
 <CACycT3u0+LTbtFMS75grKGZ2mnXzHnKug+HGWbf+nqVybqwkZQ@mail.gmail.com>
 <b3faa4a6-a65b-faf7-985a-b2771533c8bb@redhat.com>
 <CACycT3uZ2ZPjUwVZqzQPZ4ke=VrHCkfNvYagA-oxggPUEUi0Vg@mail.gmail.com>
 <e933ec33-9d47-0ef5-9152-25cedd330ce2@redhat.com>
 <CACycT3ug30sQptdoSP8XzRJVN7Yb2DPLBtfG-RNbus3BOhdONA@mail.gmail.com>
 <b01d9ee7-b038-cef2-8996-cd6401003267@redhat.com>
 <CACycT3vSRvRUbqbPNjAPQ-TeXnbqtrQO+gD1M0qDRRqX1zovVA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <44c21bf4-874d-24c9-334b-053c54e8422e@redhat.com>
Date:   Mon, 8 Mar 2021 11:04:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CACycT3vSRvRUbqbPNjAPQ-TeXnbqtrQO+gD1M0qDRRqX1zovVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/5 4:12 下午, Yongji Xie wrote:
> On Fri, Mar 5, 2021 at 3:37 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/3/5 3:27 下午, Yongji Xie wrote:
>>> On Fri, Mar 5, 2021 at 3:01 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> On 2021/3/5 2:36 下午, Yongji Xie wrote:
>>>>> On Fri, Mar 5, 2021 at 11:42 AM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> On 2021/3/5 11:30 上午, Yongji Xie wrote:
>>>>>>> On Fri, Mar 5, 2021 at 11:05 AM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>>> On 2021/3/4 4:58 下午, Yongji Xie wrote:
>>>>>>>>> On Thu, Mar 4, 2021 at 2:59 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>>>>> On 2021/2/23 7:50 下午, Xie Yongji wrote:
>>>>>>>>>>> This patch introduces a workqueue to support injecting
>>>>>>>>>>> virtqueue's interrupt asynchronously. This is mainly
>>>>>>>>>>> for performance considerations which makes sure the push()
>>>>>>>>>>> and pop() for used vring can be asynchronous.
>>>>>>>>>> Do you have pref numbers for this patch?
>>>>>>>>>>
>>>>>>>>> No, I can do some tests for it if needed.
>>>>>>>>>
>>>>>>>>> Another problem is the VIRTIO_RING_F_EVENT_IDX feature will be useless
>>>>>>>>> if we call irq callback in ioctl context. Something like:
>>>>>>>>>
>>>>>>>>> virtqueue_push();
>>>>>>>>> virtio_notify();
>>>>>>>>>          ioctl()
>>>>>>>>> -------------------------------------------------
>>>>>>>>>              irq_cb()
>>>>>>>>>                  virtqueue_get_buf()
>>>>>>>>>
>>>>>>>>> The used vring is always empty each time we call virtqueue_push() in
>>>>>>>>> userspace. Not sure if it is what we expected.
>>>>>>>> I'm not sure I get the issue.
>>>>>>>>
>>>>>>>> THe used ring should be filled by virtqueue_push() which is done by
>>>>>>>> userspace before?
>>>>>>>>
>>>>>>> After userspace call virtqueue_push(), it always call virtio_notify()
>>>>>>> immediately. In traditional VM (vhost-vdpa) cases, virtio_notify()
>>>>>>> will inject an irq to VM and return, then vcpu thread will call
>>>>>>> interrupt handler. But in container (virtio-vdpa) cases,
>>>>>>> virtio_notify() will call interrupt handler directly. So it looks like
>>>>>>> we have to optimize the virtio-vdpa cases. But one problem is we don't
>>>>>>> know whether we are in the VM user case or container user case.
>>>>>> Yes, but I still don't get why used ring is empty after the ioctl()?
>>>>>> Used ring does not use bounce page so it should be visible to the kernel
>>>>>> driver. What did I miss :) ?
>>>>>>
>>>>> Sorry, I'm not saying the kernel can't see the correct used vring. I
>>>>> mean the kernel will consume the used vring in the ioctl context
>>>>> directly in the virtio-vdpa case. In userspace's view, that means
>>>>> virtqueue_push() is used vring's producer and virtio_notify() is used
>>>>> vring's consumer. They will be called one by one in one thread rather
>>>>> than different threads, which looks odd and has a bad effect on
>>>>> performance.
>>>> Yes, that's why we need a workqueue (WQ_UNBOUND you used). Or do you
>>>> want to squash this patch into patch 8?
>>>>
>>>> So I think we can see obvious difference when virtio-vdpa is used.
>>>>
>>> But it looks like we don't need this workqueue in vhost-vdpa cases.
>>> Any suggestions?
>>
>> I haven't had a deep thought. But I feel we can solve this by using the
>> irq bypass manager (or something similar). Then we don't need it to be
>> relayed via workqueue and vdpa. But I'm not sure how hard it will be.
>>
>   Or let vdpa bus drivers give us some information?


This kind of 'type' is proposed in the early RFC of vDPA series. One 
issue is that at device level, we should not differ virtio from vhost, 
so if we introduce that, it might encourge people to design a device 
that is dedicated to vhost or virtio which might not be good.

But we can re-visit this when necessary.

Thanks


>
>> Do you see any obvious performance regression by using the workqueue? Or
>> we can optimize it in the future.
>>
> Agree.
>
> Thanks,
> Yongji
>

