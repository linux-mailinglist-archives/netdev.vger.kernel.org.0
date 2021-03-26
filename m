Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC0C34A079
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 05:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhCZE1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 00:27:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbhCZE1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 00:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616732840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fD/t2Drm3azUWItrUUo2B2L0wNjzhSFs21+qnTdgLMo=;
        b=UTMkoOPCfIrFR4JDYrhU2Yhe+E2hlalkKKx4DJKWolJS6luCfahr6ho6kBEYxYzEDNi7YO
        0VJBsBhgibsoCPC1oVSxEdZGwePuTEXLWqI1FNwl5YB4DNioLA++42PqeIBsoUMiOfbziA
        NgdheiDW6CyhcTRdV/1YL0WuvkyMd3A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-UTjyX0SOMWiMqma1ZuF7Xg-1; Fri, 26 Mar 2021 00:27:16 -0400
X-MC-Unique: UTjyX0SOMWiMqma1ZuF7Xg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16064107ACCD;
        Fri, 26 Mar 2021 04:27:15 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-134.pek2.redhat.com [10.72.13.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CC99772E0;
        Fri, 26 Mar 2021 04:27:01 +0000 (UTC)
Subject: Re: [PATCH v5 08/11] vduse: Implement an MMU-based IOMMU driver
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2db71996-037e-494d-6ef0-de3ff164d3c3@redhat.com>
Date:   Fri, 26 Mar 2021 12:26:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CACycT3uS870yy04rw7KBk==sioi+VNunxVz6BQH-Lmxk6m-VSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/3/25 下午3:38, Yongji Xie 写道:
> On Thu, Mar 25, 2021 at 12:53 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/3/24 下午3:39, Yongji Xie 写道:
>>> On Wed, Mar 24, 2021 at 11:54 AM Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/3/15 下午1:37, Xie Yongji 写道:
>>>>> This implements an MMU-based IOMMU driver to support mapping
>>>>> kernel dma buffer into userspace. The basic idea behind it is
>>>>> treating MMU (VA->PA) as IOMMU (IOVA->PA). The driver will set
>>>>> up MMU mapping instead of IOMMU mapping for the DMA transfer so
>>>>> that the userspace process is able to use its virtual address to
>>>>> access the dma buffer in kernel.
>>>>>
>>>>> And to avoid security issue, a bounce-buffering mechanism is
>>>>> introduced to prevent userspace accessing the original buffer
>>>>> directly.
>>>>>
>>>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>>>> ---
>>>>>     drivers/vdpa/vdpa_user/iova_domain.c | 535 +++++++++++++++++++++++++++++++++++
>>>>>     drivers/vdpa/vdpa_user/iova_domain.h |  75 +++++
>>>>>     2 files changed, 610 insertions(+)
>>>>>     create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>>>>>     create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>>>>>
>>>>> diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
>>>>> new file mode 100644
>>>>> index 000000000000..83de216b0e51
>>>>> --- /dev/null
>>>>> +++ b/drivers/vdpa/vdpa_user/iova_domain.c
>>>>> @@ -0,0 +1,535 @@
>>>>> +// SPDX-License-Identifier: GPL-2.0-only
>>>>> +/*
>>>>> + * MMU-based IOMMU implementation
>>>>> + *
>>>>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
>>>> 2021 as well.
>>>>
>>> Sure.
>>>
>>>>> + *
>>>>> + * Author: Xie Yongji <xieyongji@bytedance.com>
>>>>> + *
>>>>> + */
>>>>> +
>>>>> +#include <linux/slab.h>
>>>>> +#include <linux/file.h>
>>>>> +#include <linux/anon_inodes.h>
>>>>> +#include <linux/highmem.h>
>>>>> +#include <linux/vmalloc.h>
>>>>> +#include <linux/vdpa.h>
>>>>> +
>>>>> +#include "iova_domain.h"
>>>>> +
>>>>> +static int vduse_iotlb_add_range(struct vduse_iova_domain *domain,
>>>>> +                              u64 start, u64 last,
>>>>> +                              u64 addr, unsigned int perm,
>>>>> +                              struct file *file, u64 offset)
>>>>> +{
>>>>> +     struct vdpa_map_file *map_file;
>>>>> +     int ret;
>>>>> +
>>>>> +     map_file = kmalloc(sizeof(*map_file), GFP_ATOMIC);
>>>>> +     if (!map_file)
>>>>> +             return -ENOMEM;
>>>>> +
>>>>> +     map_file->file = get_file(file);
>>>>> +     map_file->offset = offset;
>>>>> +
>>>>> +     ret = vhost_iotlb_add_range_ctx(domain->iotlb, start, last,
>>>>> +                                     addr, perm, map_file);
>>>>> +     if (ret) {
>>>>> +             fput(map_file->file);
>>>>> +             kfree(map_file);
>>>>> +             return ret;
>>>>> +     }
>>>>> +     return 0;
>>>>> +}
>>>>> +
>>>>> +static void vduse_iotlb_del_range(struct vduse_iova_domain *domain,
>>>>> +                               u64 start, u64 last)
>>>>> +{
>>>>> +     struct vdpa_map_file *map_file;
>>>>> +     struct vhost_iotlb_map *map;
>>>>> +
>>>>> +     while ((map = vhost_iotlb_itree_first(domain->iotlb, start, last))) {
>>>>> +             map_file = (struct vdpa_map_file *)map->opaque;
>>>>> +             fput(map_file->file);
>>>>> +             kfree(map_file);
>>>>> +             vhost_iotlb_map_free(domain->iotlb, map);
>>>>> +     }
>>>>> +}
>>>>> +
>>>>> +int vduse_domain_set_map(struct vduse_iova_domain *domain,
>>>>> +                      struct vhost_iotlb *iotlb)
>>>>> +{
>>>>> +     struct vdpa_map_file *map_file;
>>>>> +     struct vhost_iotlb_map *map;
>>>>> +     u64 start = 0ULL, last = ULLONG_MAX;
>>>>> +     int ret;
>>>>> +
>>>>> +     spin_lock(&domain->iotlb_lock);
>>>>> +     vduse_iotlb_del_range(domain, start, last);
>>>>> +
>>>>> +     for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
>>>>> +          map = vhost_iotlb_itree_next(map, start, last)) {
>>>>> +             map_file = (struct vdpa_map_file *)map->opaque;
>>>>> +             ret = vduse_iotlb_add_range(domain, map->start, map->last,
>>>>> +                                         map->addr, map->perm,
>>>>> +                                         map_file->file,
>>>>> +                                         map_file->offset);
>>>>> +             if (ret)
>>>>> +                     goto err;
>>>>> +     }
>>>>> +     spin_unlock(&domain->iotlb_lock);
>>>>> +
>>>>> +     return 0;
>>>>> +err:
>>>>> +     vduse_iotlb_del_range(domain, start, last);
>>>>> +     spin_unlock(&domain->iotlb_lock);
>>>>> +     return ret;
>>>>> +}
>>>>> +
>>>>> +static void vduse_domain_map_bounce_page(struct vduse_iova_domain *domain,
>>>>> +                                      u64 iova, u64 size, u64 paddr)
>>>>> +{
>>>>> +     struct vduse_bounce_map *map;
>>>>> +     unsigned int index;
>>>>> +     u64 last = iova + size - 1;
>>>>> +
>>>>> +     while (iova < last) {
>>>>> +             map = &domain->bounce_maps[iova >> PAGE_SHIFT];
>>>>> +             index = offset_in_page(iova) >> IOVA_ALLOC_ORDER;
>>>>> +             map->orig_phys[index] = paddr;
>>>>> +             paddr += IOVA_ALLOC_SIZE;
>>>>> +             iova += IOVA_ALLOC_SIZE;
>>>>> +     }
>>>>> +}
>>>>> +
>>>>> +static void vduse_domain_unmap_bounce_page(struct vduse_iova_domain *domain,
>>>>> +                                        u64 iova, u64 size)
>>>>> +{
>>>>> +     struct vduse_bounce_map *map;
>>>>> +     unsigned int index;
>>>>> +     u64 last = iova + size - 1;
>>>>> +
>>>>> +     while (iova < last) {
>>>>> +             map = &domain->bounce_maps[iova >> PAGE_SHIFT];
>>>>> +             index = offset_in_page(iova) >> IOVA_ALLOC_ORDER;
>>>>> +             map->orig_phys[index] = INVALID_PHYS_ADDR;
>>>>> +             iova += IOVA_ALLOC_SIZE;
>>>>> +     }
>>>>> +}
>>>>> +
>>>>> +static void do_bounce(phys_addr_t orig, void *addr, size_t size,
>>>>> +                   enum dma_data_direction dir)
>>>>> +{
>>>>> +     unsigned long pfn = PFN_DOWN(orig);
>>>>> +
>>>>> +     if (PageHighMem(pfn_to_page(pfn))) {
>>>>> +             unsigned int offset = offset_in_page(orig);
>>>>> +             char *buffer;
>>>>> +             unsigned int sz = 0;
>>>>> +
>>>>> +             while (size) {
>>>>> +                     sz = min_t(size_t, PAGE_SIZE - offset, size);
>>>>> +
>>>>> +                     buffer = kmap_atomic(pfn_to_page(pfn));
>>>> So kmap_atomic() can autoamtically go with fast path if the page does
>>>> not belong to highmem.
>>>>
>>>> I think we can removce the condition and just use kmap_atomic() for all
>>>> the cases here.
>>>>
>>> Looks good to me.
>>>
>>>>> +                     if (dir == DMA_TO_DEVICE)
>>>>> +                             memcpy(addr, buffer + offset, sz);
>>>>> +                     else
>>>>> +                             memcpy(buffer + offset, addr, sz);
>>>>> +                     kunmap_atomic(buffer);
>>>>> +
>>>>> +                     size -= sz;
>>>>> +                     pfn++;
>>>>> +                     addr += sz;
>>>>> +                     offset = 0;
>>>>> +             }
>>>>> +     } else if (dir == DMA_TO_DEVICE) {
>>>>> +             memcpy(addr, phys_to_virt(orig), size);
>>>>> +     } else {
>>>>> +             memcpy(phys_to_virt(orig), addr, size);
>>>>> +     }
>>>>> +}
>>>>> +
>>>>> +static void vduse_domain_bounce(struct vduse_iova_domain *domain,
>>>>> +                             dma_addr_t iova, size_t size,
>>>>> +                             enum dma_data_direction dir)
>>>>> +{
>>>>> +     struct vduse_bounce_map *map;
>>>>> +     unsigned int index, offset;
>>>>> +     void *addr;
>>>>> +     size_t sz;
>>>>> +
>>>>> +     while (size) {
>>>>> +             map = &domain->bounce_maps[iova >> PAGE_SHIFT];
>>>>> +             offset = offset_in_page(iova);
>>>>> +             sz = min_t(size_t, IOVA_ALLOC_SIZE, size);
>>>>> +
>>>>> +             if (map->bounce_page &&
>>>>> +                 map->orig_phys[index] != INVALID_PHYS_ADDR) {
>>>>> +                     addr = page_address(map->bounce_page) + offset;
>>>>> +                     index = offset >> IOVA_ALLOC_ORDER;
>>>>> +                     do_bounce(map->orig_phys[index], addr, sz, dir);
>>>>> +             }
>>>>> +             size -= sz;
>>>>> +             iova += sz;
>>>>> +     }
>>>>> +}
>>>>> +
>>>>> +static struct page *
>>>>> +vduse_domain_get_mapping_page(struct vduse_iova_domain *domain, u64 iova)
>>>>> +{
>>>>> +     u64 start = iova & PAGE_MASK;
>>>>> +     u64 last = start + PAGE_SIZE - 1;
>>>>> +     struct vhost_iotlb_map *map;
>>>>> +     struct page *page = NULL;
>>>>> +
>>>>> +     spin_lock(&domain->iotlb_lock);
>>>>> +     map = vhost_iotlb_itree_first(domain->iotlb, start, last);
>>>>> +     if (!map)
>>>>> +             goto out;
>>>>> +
>>>>> +     page = pfn_to_page((map->addr + iova - map->start) >> PAGE_SHIFT);
>>>>> +     get_page(page);
>>>>> +out:
>>>>> +     spin_unlock(&domain->iotlb_lock);
>>>>> +
>>>>> +     return page;
>>>>> +}
>>>>> +
>>>>> +static struct page *
>>>>> +vduse_domain_alloc_bounce_page(struct vduse_iova_domain *domain, u64 iova)
>>>>> +{
>>>>> +     u64 start = iova & PAGE_MASK;
>>>>> +     struct page *page = alloc_page(GFP_KERNEL);
>>>>> +     struct vduse_bounce_map *map;
>>>>> +
>>>>> +     if (!page)
>>>>> +             return NULL;
>>>>> +
>>>>> +     spin_lock(&domain->iotlb_lock);
>>>>> +     map = &domain->bounce_maps[iova >> PAGE_SHIFT];
>>>>> +     if (map->bounce_page) {
>>>>> +             __free_page(page);
>>>>> +             goto out;
>>>>> +     }
>>>>> +     map->bounce_page = page;
>>>>> +
>>>>> +     /* paired with vduse_domain_map_page() */
>>>>> +     smp_mb();
>>>> So this is suspicious. It's better to explain like, we need make sure A
>>>> must be done after B.
>>> OK. I see. It's used to protect this pattern:
>>>
>>>      vduse_domain_alloc_bounce_page:          vduse_domain_map_page:
>>>      write map->bounce_page                           write map->orig_phys
>>>      mb()                                                            mb()
>>>      read map->orig_phys                                 read map->bounce_page
>>>
>>> Make sure there will always be a path to do bouncing.
>>
>> Ok.
>>
>>
>>>> And it looks to me the iotlb_lock is sufficnet to do the synchronization
>>>> here. E.g any reason that you don't take it in
>>>> vduse_domain_map_bounce_page().
>>>>
>>> Yes, we can. But the performance in multi-queue cases will go down if
>>> we use iotlb_lock on this critical path.
>>>
>>>> And what's more, is there anyway to aovid holding the spinlock during
>>>> bouncing?
>>>>
>>> Looks like we can't. In the case that multiple page faults happen on
>>> the same page, we should make sure the bouncing is done before any
>>> page fault handler returns.
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
> If so, we need to allocate lots of pages from the pool reserved for
> atomic memory allocation requests.


This should be fine, a lot of drivers tries to allocate pages in atomic 
context. The point is to simplify the codes to make it easy to 
determince the correctness so we can add optimization on top simply by 
benchmarking the difference.

E.g we have serveral places that accesses orig_phys:

1) map_page(), write
2) unmap_page(), write
3) page fault handler, read

It's not clear to me how they were synchronized. Or if it was 
synchronzied implicitly (via iova allocator?), we'd better document it. 
Or simply use spinlock (which is the preferrable way I'd like to go). We 
probably don't need to worry too much about the cost of spinlock since 
iova allocater use it heavily.

Thanks


>
> Thanks,
> Yongji
>

