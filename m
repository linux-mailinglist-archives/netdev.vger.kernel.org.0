Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC6C32E304
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCEHhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:37:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhCEHhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 02:37:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614929835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zckMKEYr1zLlnl+M28V4/wViPEezLVE4dC4UmG7LvNs=;
        b=Toq5W9kCR2OGfTt7jz5GvdR7+MCPN+52kARF2gkc2cgIPq/yc3H60MNv7EbfCzqORzLG97
        0YfeTKoynMWCWpx9mx6fOXaWEI+lir4jZP9pIgnj2jfucro4oC6EtlgRWqv6Wmk1umOg3h
        /VTPKPYlQtSgXXoKcBzzEpixkcGic0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-asz0IBm8PGe-BoaTg01i8Q-1; Fri, 05 Mar 2021 02:37:12 -0500
X-MC-Unique: asz0IBm8PGe-BoaTg01i8Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97C63108BD07;
        Fri,  5 Mar 2021 07:37:09 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-165.pek2.redhat.com [10.72.12.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A17E1F413;
        Fri,  5 Mar 2021 07:36:53 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b01d9ee7-b038-cef2-8996-cd6401003267@redhat.com>
Date:   Fri, 5 Mar 2021 15:36:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CACycT3ug30sQptdoSP8XzRJVN7Yb2DPLBtfG-RNbus3BOhdONA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/5 3:27 下午, Yongji Xie wrote:
> On Fri, Mar 5, 2021 at 3:01 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/3/5 2:36 下午, Yongji Xie wrote:
>>> On Fri, Mar 5, 2021 at 11:42 AM Jason Wang <jasowang@redhat.com> wrote:
>>>> On 2021/3/5 11:30 上午, Yongji Xie wrote:
>>>>> On Fri, Mar 5, 2021 at 11:05 AM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> On 2021/3/4 4:58 下午, Yongji Xie wrote:
>>>>>>> On Thu, Mar 4, 2021 at 2:59 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>>> On 2021/2/23 7:50 下午, Xie Yongji wrote:
>>>>>>>>> This patch introduces a workqueue to support injecting
>>>>>>>>> virtqueue's interrupt asynchronously. This is mainly
>>>>>>>>> for performance considerations which makes sure the push()
>>>>>>>>> and pop() for used vring can be asynchronous.
>>>>>>>> Do you have pref numbers for this patch?
>>>>>>>>
>>>>>>> No, I can do some tests for it if needed.
>>>>>>>
>>>>>>> Another problem is the VIRTIO_RING_F_EVENT_IDX feature will be useless
>>>>>>> if we call irq callback in ioctl context. Something like:
>>>>>>>
>>>>>>> virtqueue_push();
>>>>>>> virtio_notify();
>>>>>>>         ioctl()
>>>>>>> -------------------------------------------------
>>>>>>>             irq_cb()
>>>>>>>                 virtqueue_get_buf()
>>>>>>>
>>>>>>> The used vring is always empty each time we call virtqueue_push() in
>>>>>>> userspace. Not sure if it is what we expected.
>>>>>> I'm not sure I get the issue.
>>>>>>
>>>>>> THe used ring should be filled by virtqueue_push() which is done by
>>>>>> userspace before?
>>>>>>
>>>>> After userspace call virtqueue_push(), it always call virtio_notify()
>>>>> immediately. In traditional VM (vhost-vdpa) cases, virtio_notify()
>>>>> will inject an irq to VM and return, then vcpu thread will call
>>>>> interrupt handler. But in container (virtio-vdpa) cases,
>>>>> virtio_notify() will call interrupt handler directly. So it looks like
>>>>> we have to optimize the virtio-vdpa cases. But one problem is we don't
>>>>> know whether we are in the VM user case or container user case.
>>>> Yes, but I still don't get why used ring is empty after the ioctl()?
>>>> Used ring does not use bounce page so it should be visible to the kernel
>>>> driver. What did I miss :) ?
>>>>
>>> Sorry, I'm not saying the kernel can't see the correct used vring. I
>>> mean the kernel will consume the used vring in the ioctl context
>>> directly in the virtio-vdpa case. In userspace's view, that means
>>> virtqueue_push() is used vring's producer and virtio_notify() is used
>>> vring's consumer. They will be called one by one in one thread rather
>>> than different threads, which looks odd and has a bad effect on
>>> performance.
>>
>> Yes, that's why we need a workqueue (WQ_UNBOUND you used). Or do you
>> want to squash this patch into patch 8?
>>
>> So I think we can see obvious difference when virtio-vdpa is used.
>>
> But it looks like we don't need this workqueue in vhost-vdpa cases.
> Any suggestions?


I haven't had a deep thought. But I feel we can solve this by using the 
irq bypass manager (or something similar). Then we don't need it to be 
relayed via workqueue and vdpa. But I'm not sure how hard it will be.

Do you see any obvious performance regression by using the workqueue? Or 
we can optimize it in the future.

Thanks


>
> Thanks,
> Yongji
>

