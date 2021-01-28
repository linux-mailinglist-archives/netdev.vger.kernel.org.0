Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD06306D83
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhA1GQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:16:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229900AbhA1GQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:16:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611814494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fgRtHFrCUHDBzGNeWEeT3eYxAFV/0uXWAeAeQDDdkrU=;
        b=TMJkk4RiAOgi7rXn+OsFopGlAzCqL++0r9P3655jC/9YokGinNftr4phdaS6Ed9x8HmTks
        1IB4uUl1wmqMDTwJqVzZtMdnsipz4CCR6q7T/nCSjkpXgsOXnGWcZ4h6tzSNeYVyagVMYt
        eLkVgYm7sRj6L/lNjXuRKKzIk7RtjP8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-jJnOhnlyMCSfZeCJe8mhcw-1; Thu, 28 Jan 2021 01:14:52 -0500
X-MC-Unique: jJnOhnlyMCSfZeCJe8mhcw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDA6C9CC00;
        Thu, 28 Jan 2021 06:14:49 +0000 (UTC)
Received: from [10.72.12.167] (ovpn-12-167.pek2.redhat.com [10.72.12.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CB0560C13;
        Thu, 28 Jan 2021 06:14:34 +0000 (UTC)
Subject: Re: [RFC v3 08/11] vduse: Introduce VDUSE - vDPA Device in Userspace
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
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119050756.600-1-xieyongji@bytedance.com>
 <20210119050756.600-2-xieyongji@bytedance.com>
 <1bb3af07-0ec2-109c-d6d1-83d4d1f410c3@redhat.com>
 <CACycT3uJtKqEp7CHBKhvmSL41gTrCcMrt_-tacGCbX1nabuG6w@mail.gmail.com>
 <ea170064-6fcf-133b-f3bd-d1f1862d4143@redhat.com>
 <CACycT3upvTrkm5Cd6KzphSk=FYDjAVCbFJ0CLmha5sP_h=5KGg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bdb57829-d4a4-eaca-d43b-70d39df96bf6@redhat.com>
Date:   Thu, 28 Jan 2021 14:14:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3upvTrkm5Cd6KzphSk=FYDjAVCbFJ0CLmha5sP_h=5KGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/28 下午2:03, Yongji Xie wrote:
>>>>> +
>>>>> +static const struct file_operations vduse_domain_fops = {
>>>>> +     .mmap = vduse_domain_mmap,
>>>>> +     .release = vduse_domain_release,
>>>>> +};
>>>> It's better to explain the reason for introducing a dedicated file for
>>>> mmap() here.
>>>>
>>> To make the implementation of iova_domain independent with vduse_dev.
>> My understanding is that, the only usage for this is to:
>>
>> 1) support different type of iova mappings
>> 2) or switch between iova domain mappings
>>
>> But I can't think of a need for this.
>>
> For example, share one iova_domain between several vduse devices.


Interesting.


>
> And it will be helpful if we want to split this patch into iova domain
> part and vduse device part. Because the page fault handler should be
> paired with dma_map/dma_unmap.


Ok.

[...]


>
>>>> This looks not safe, let's use idr here.
>>>>
>>> Could you give more details? Looks like idr should not used in this
>>> case which can not tolerate failure. And using a list to store the msg
>>> is better than using idr when the msg needs to be re-inserted in some
>>> cases.
>> My understanding is the "unique" (probably need a better name) is a
>> token that is used to uniquely identify a message. The reply from
>> userspace is required to write with exact the same token(unique). IDR
>> seems better but consider we can hardly hit 64bit overflow, atomic might
>> be OK as well.
>>
>> Btw, under what case do we need to do "re-inserted"?
>>
> When userspace daemon receive the message but doesn't reply it before crash.


Do we have code to do this?

[...]


>
>>>> So we had multiple types of requests/responses, is this better to
>>>> introduce a queue based admin interface other than ioctl?
>>>>
>>> Sorry, I didn't get your point. What do you mean by queue-based admin
>>> interface? Virtqueue-based?
>> Yes, a queue(virtqueue). The commands could be passed through the queue.
>> (Just an idea, not sure it's worth)
>>
> I considered it before. But I found it still needs some extra works
> (setup eventfd, set vring base and so on) to setup the admin virtqueue
> before using it for communication. So I turn to use this simple way.


Yes. We might consider it in the future.

[...]


>
>>>> Any reason for such IOTLB invalidation here?
>>>>
>>> As I mentioned before, this is used to notify userspace to update the
>>> IOTLB. Mainly for virtio-vdpa case.
>> So the question is, usually, there could be several times of status
>> setting during driver initialization. Do we really need to update IOTLB
>> every time?
>>
> I think we can check whether there are some changes after the last
> IOTLB updating here.


So the question still, except reset (write 0), any other status that can 
affect IOTLB?

[...]

>
>> Something like swiotlb default value (64M)?
>>
> Do we need a module parameter to change it?


We can.

[...]

>
>>>>> +     union {
>>>>> +             struct vduse_vq_num vq_num; /* virtqueue num */
>>>>> +             struct vduse_vq_addr vq_addr; /* virtqueue address */
>>>>> +             struct vduse_vq_ready vq_ready; /* virtqueue ready status */
>>>>> +             struct vduse_vq_state vq_state; /* virtqueue state */
>>>>> +             struct vduse_dev_config_data config; /* virtio device config space */
>>>>> +             struct vduse_iova_range iova; /* iova range for updating */
>>>>> +             __u64 features; /* virtio features */
>>>>> +             __u8 status; /* device status */
>>>> Let's add some padding for future extensions.
>>>>
>>> Is sizeof(vduse_dev_config_data) ok? Or char[1024]?
>> 1024 seems too large, 128 or 256 looks better.
>>
> If so, sizeof(vduse_dev_config_data) is enough.


Ok if we don't need a message more than that in the future.

Thanks

