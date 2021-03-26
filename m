Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53C834A293
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 08:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhCZHgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 03:36:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230321AbhCZHgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 03:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616744198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dSLEq+hMh1Ql2uL/IHuUBMQc9+yVTsv/4GeCDE92710=;
        b=ayT0XhuEHrQ9rHwzKP0RBRC33Ib8/AwKoAfRQJXRh5c2iNZHatjeJpllni2WOEPj4Rd0S7
        odIyU4q18ReYfeJWyv3pc5Q7Wvsx4wec8q8agTL1999hZZFMpIh7ng3Tn4DRetzI3zqvDe
        eHj7fA8jxWloRPeUYySCsQfv1su7SiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-wodSWgXbMYuwG4FqjYaUNw-1; Fri, 26 Mar 2021 03:36:36 -0400
X-MC-Unique: wodSWgXbMYuwG4FqjYaUNw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E68B784BA41;
        Fri, 26 Mar 2021 07:36:33 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-10.pek2.redhat.com [10.72.13.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31C995D9CA;
        Fri, 26 Mar 2021 07:36:20 +0000 (UTC)
Subject: Re: [PATCH v5 08/11] vduse: Implement an MMU-based IOMMU driver
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210315053721.189-1-xieyongji@bytedance.com>
 <20210315053721.189-9-xieyongji@bytedance.com>
 <ec5b4146-9844-11b0-c9b0-c657d3328dd4@redhat.com>
 <CACycT3v_-G6ju-poofXEzYt8QPKWNFHwsS7t=KTLgs-=g+iPQQ@mail.gmail.com>
 <7c90754b-681d-f3bf-514c-756abfcf3d23@redhat.com>
 <CACycT3uS870yy04rw7KBk==sioi+VNunxVz6BQH-Lmxk6m-VSg@mail.gmail.com>
 <2db71996-037e-494d-6ef0-de3ff164d3c3@redhat.com>
 <CACycT3v6Lj61fafztOuzBNFLs2TbKeqrNLXkzv5RK6-h-iTnvA@mail.gmail.com>
 <75e3b941-dfd2-ebbc-d752-8f25c1f14cab@redhat.com>
 <CACycT3t+2MC9rQ7iWdWQ4=O3ojCXHvHZ-M7y7AjXoXYZUiAOzQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <817336fa-c026-fd4d-dd2e-eb5f40c63ad4@redhat.com>
Date:   Fri, 26 Mar 2021 15:36:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CACycT3t+2MC9rQ7iWdWQ4=O3ojCXHvHZ-M7y7AjXoXYZUiAOzQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/3/26 下午2:56, Yongji Xie 写道:
> On Fri, Mar 26, 2021 at 2:16 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/3/26 下午1:14, Yongji Xie 写道:
>>
>> +     }
>> +     map->bounce_page = page;
>> +
>> +     /* paired with vduse_domain_map_page() */
>> +     smp_mb();
>>
>> So this is suspicious. It's better to explain like, we need make sure A
>> must be done after B.
>>
>> OK. I see. It's used to protect this pattern:
>>
>>       vduse_domain_alloc_bounce_page:          vduse_domain_map_page:
>>       write map->bounce_page                           write map->orig_phys
>>       mb()                                                            mb()
>>       read map->orig_phys                                 read map->bounce_page
>>
>> Make sure there will always be a path to do bouncing.
>>
>> Ok.
>>
>>
>> And it looks to me the iotlb_lock is sufficnet to do the synchronization
>> here. E.g any reason that you don't take it in
>> vduse_domain_map_bounce_page().
>>
>> Yes, we can. But the performance in multi-queue cases will go down if
>> we use iotlb_lock on this critical path.
>>
>> And what's more, is there anyway to aovid holding the spinlock during
>> bouncing?
>>
>> Looks like we can't. In the case that multiple page faults happen on
>> the same page, we should make sure the bouncing is done before any
>> page fault handler returns.
>>
>> So it looks to me all those extra complexitiy comes from the fact that
>> the bounce_page and orig_phys are set by different places so we need to
>> do the bouncing in two places.
>>
>> I wonder how much we can gain from the "lazy" boucning in page fault.
>> The buffer mapped via dma_ops from virtio driver is expected to be
>> accessed by the userspace soon.  It looks to me we can do all those
>> stuffs during dma_map() then things would be greatly simplified.
>>
>> If so, we need to allocate lots of pages from the pool reserved for
>> atomic memory allocation requests.
>>
>> This should be fine, a lot of drivers tries to allocate pages in atomic
>> context. The point is to simplify the codes to make it easy to
>> determince the correctness so we can add optimization on top simply by
>> benchmarking the difference.
>>
>> OK. I will use this way in the next version.
>>
>> E.g we have serveral places that accesses orig_phys:
>>
>> 1) map_page(), write
>> 2) unmap_page(), write
>> 3) page fault handler, read
>>
>> It's not clear to me how they were synchronized. Or if it was
>> synchronzied implicitly (via iova allocator?), we'd better document it.
>>
>> Yes.
>>
>> Or simply use spinlock (which is the preferrable way I'd like to go). We
>> probably don't need to worry too much about the cost of spinlock since
>> iova allocater use it heavily.
>>
>> Actually iova allocator implements a per-CPU cache to optimize it.
>>
>> Thanks,
>> Yongji
>>
>>
>> Right, but have a quick glance, I guess what you meant is that usually there's no lock contention unless cpu hot-plug. This can work but the problem is that such synchornization depends on the internal implementation of IOVA allocator which is kind of fragile. I still think we should do that on our own.
>>
> I might miss something. Looks like we don't need any synchronization
> if the page fault handler is removed as you suggested. We should not
> access the same orig_phys concurrently (in map_page() and
> unmap_page()) unless we free the iova before accessing.
>
> Thanks,
> Yongji


You're right. I overestimate the complexitiy that is required by the 
synchronization.

Thanks


>

