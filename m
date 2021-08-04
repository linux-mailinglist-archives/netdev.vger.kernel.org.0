Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF5B3E0499
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239228AbhHDPoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:44:09 -0400
Received: from foss.arm.com ([217.140.110.172]:33872 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239214AbhHDPoG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 11:44:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 191B531B;
        Wed,  4 Aug 2021 08:43:53 -0700 (PDT)
Received: from [10.57.36.146] (unknown [10.57.36.146])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D22B33F66F;
        Wed,  4 Aug 2021 08:43:48 -0700 (PDT)
Subject: Re: [PATCH v10 01/17] iova: Export alloc_iova_fast() and
 free_iova_fast()
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        songmuchun@bytedance.com, Jens Axboe <axboe@kernel.dk>,
        He Zhe <zhe.he@windriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, bcrl@kvack.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-2-xieyongji@bytedance.com>
 <43d88942-1cd3-c840-6fec-4155fd544d80@redhat.com>
 <CACycT3vcpwyA3xjD29f1hGnYALyAd=-XcWp8+wJiwSqpqUu00w@mail.gmail.com>
 <6e05e25e-e569-402e-d81b-8ac2cff1c0e8@arm.com>
 <CACycT3sm2r8NMMUPy1k1PuSZZ3nM9aic-O4AhdmRRCwgmwGj4Q@mail.gmail.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <417ce5af-4deb-5319-78ce-b74fb4dd0582@arm.com>
Date:   Wed, 4 Aug 2021 16:43:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CACycT3sm2r8NMMUPy1k1PuSZZ3nM9aic-O4AhdmRRCwgmwGj4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-04 06:02, Yongji Xie wrote:
> On Tue, Aug 3, 2021 at 6:54 PM Robin Murphy <robin.murphy@arm.com> wrote:
>>
>> On 2021-08-03 09:54, Yongji Xie wrote:
>>> On Tue, Aug 3, 2021 at 3:41 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>
>>>>
>>>> 在 2021/7/29 下午3:34, Xie Yongji 写道:
>>>>> Export alloc_iova_fast() and free_iova_fast() so that
>>>>> some modules can use it to improve iova allocation efficiency.
>>>>
>>>>
>>>> It's better to explain why alloc_iova() is not sufficient here.
>>>>
>>>
>>> Fine.
>>
>> What I fail to understand from the later patches is what the IOVA domain
>> actually represents. If the "device" is a userspace process then
>> logically the "IOVA" would be the userspace address, so presumably
>> somewhere you're having to translate between this arbitrary address
>> space and actual usable addresses - if you're worried about efficiency
>> surely it would be even better to not do that?
>>
> 
> Yes, userspace daemon needs to translate the "IOVA" in a DMA
> descriptor to the VA (from mmap(2)). But this actually doesn't affect
> performance since it's an identical mapping in most cases.

I'm not familiar with the vhost_iotlb stuff, but it looks suspiciously 
like you're walking yet another tree to make those translations. Even if 
the buffer can be mapped all at once with a fixed offset such that each 
DMA mapping call doesn't need a lookup for each individual "IOVA" - that 
might be what's happening already, but it's a bit hard to follow just 
reading the patches in my mail client - vhost_iotlb_add_range() doesn't 
look like it's super-cheap to call, and you're serialising on a lock for 
that.

My main point, though, is that if you've already got something else 
keeping track of the actual addresses, then the way you're using an 
iova_domain appears to be something you could do with a trivial bitmap 
allocator. That's why I don't buy the efficiency argument. The main 
design points of the IOVA allocator are to manage large address spaces 
while trying to maximise spatial locality to minimise the underlying 
pagetable usage, and allocating with a flexible limit to support 
multiple devices with different addressing capabilities in the same 
address space. If none of those aspects are relevant to the use-case - 
which AFAICS appears to be true here - then as a general-purpose 
resource allocator it's rubbish and has an unreasonably massive memory 
overhead and there are many, many better choices.

FWIW I've recently started thinking about moving all the caching stuff 
out of iova_domain and into the iommu-dma layer since it's now a giant 
waste of space for all the other current IOVA users.

>> Presumably userspace doesn't have any concern about alignment and the
>> things we have to worry about for the DMA API in general, so it's pretty
>> much just allocating slots in a buffer, and there are far more effective
>> ways to do that than a full-blown address space manager.
> 
> Considering iova allocation efficiency, I think the iova allocator is
> better here. In most cases, we don't even need to hold a spin lock
> during iova allocation.
> 
>> If you're going
>> to reuse any infrastructure I'd have expected it to be SWIOTLB rather
>> than the IOVA allocator. Because, y'know, you're *literally implementing
>> a software I/O TLB* ;)
>>
> 
> But actually what we can reuse in SWIOTLB is the IOVA allocator.

Huh? Those are completely unrelated and orthogonal things - SWIOTLB does 
not use an external allocator (see find_slots()). By SWIOTLB I mean 
specifically the library itself, not dma-direct or any of the other 
users built around it. The functionality for managing slots in a buffer 
and bouncing data in and out can absolutely be reused - that's why users 
like the Xen and iommu-dma code *are* reusing it instead of open-coding 
their own versions.

> And
> the IOVA management in SWIOTLB is not what we want. For example,
> SWIOTLB allocates and uses contiguous memory for bouncing, which is
> not necessary in VDUSE case.

alloc_iova() allocates a contiguous (in IOVA address) region of space. 
In vduse_domain_map_page() you use it to allocate a contiguous region of 
space from your bounce buffer. Can you clarify how that is fundamentally 
different from allocating a contiguous region of space from a bounce 
buffer? Nobody's saying the underlying implementation details of where 
the buffer itself comes from can't be tweaked.

> And VDUSE needs coherent mapping which is
> not supported by the SWIOTLB. Besides, the SWIOTLB works in singleton
> mode (designed for platform IOMMU) , but VDUSE is based on on-chip
> IOMMU (supports multiple instances).
That's not entirely true - the IOMMU bounce buffering scheme introduced 
in intel-iommu and now moved into the iommu-dma layer was already a step 
towards something conceptually similar. It does still rely on stealing 
the underlying pages from the global SWIOTLB pool at the moment, but the 
bouncing is effectively done in a per-IOMMU-domain context.

The next step is currently queued in linux-next, wherein we can now have 
individual per-device SWIOTLB pools. In fact at that point I think you 
might actually be able to do your thing without implementing any special 
DMA ops at all - you'd need to set up a pool for your "device" with 
force_bounce set, then when you mmap() that to userspace, set up 
dev->dma_range_map to describe an offset from the physical address of 
the buffer to the userspace address, and I think dma-direct would be 
tricked into doing the right thing. It's a bit wacky, but it could stand 
to save a hell of a lot of bother.

Finally, enhancing SWIOTLB to cope with virtually-mapped buffers that 
don't have to be physically contiguous is a future improvement which I 
think could benefit various use-cases - indeed it's possibly already on 
the table for IOMMU bounce pages - so would probably be welcome in general.

 > So I still prefer to reuse the
 > IOVA allocator to implement a MMU-based software IOTLB.

If you're dead set on open-coding all the bounce-buffering machinery, 
then I'd honestly recommend open-coding a more suitable buffer allocator 
as well ;)

Thanks,
Robin.
