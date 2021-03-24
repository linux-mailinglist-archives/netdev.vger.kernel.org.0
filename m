Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A247C347045
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 04:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbhCXDyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 23:54:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235135AbhCXDyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 23:54:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616558063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l5oGdK5sWqGPPpEt5t5pdWAgrjrrOmlYhApczF7hx5I=;
        b=bqe3y6jzl+3z1868clFs05cNGM7mUP/hRqVVpSa9wGI3Zjx5+JqFhqLqtW1W/LlqxCuTP7
        vCnjM+SzIOt2R9i2Kn9Sw5J6d92C4R1h9zezRVwfCz3lvvymRny8BbRmKD9dnlul1u8tUA
        ww2t3uztq5njnn0IsUo1PoOnYnlepac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-GKozzIUBM3uTSmyQG-V2mw-1; Tue, 23 Mar 2021 23:54:21 -0400
X-MC-Unique: GKozzIUBM3uTSmyQG-V2mw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A88AA1084C83;
        Wed, 24 Mar 2021 03:54:18 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-134.pek2.redhat.com [10.72.12.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE57C5447C;
        Wed, 24 Mar 2021 03:54:05 +0000 (UTC)
Subject: Re: [PATCH v5 08/11] vduse: Implement an MMU-based IOMMU driver
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210315053721.189-1-xieyongji@bytedance.com>
 <20210315053721.189-9-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ec5b4146-9844-11b0-c9b0-c657d3328dd4@redhat.com>
Date:   Wed, 24 Mar 2021 11:54:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315053721.189-9-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/15 ÏÂÎç1:37, Xie Yongji Ð´µÀ:
> This implements an MMU-based IOMMU driver to support mapping
> kernel dma buffer into userspace. The basic idea behind it is
> treating MMU (VA->PA) as IOMMU (IOVA->PA). The driver will set
> up MMU mapping instead of IOMMU mapping for the DMA transfer so
> that the userspace process is able to use its virtual address to
> access the dma buffer in kernel.
>
> And to avoid security issue, a bounce-buffering mechanism is
> introduced to prevent userspace accessing the original buffer
> directly.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/vdpa/vdpa_user/iova_domain.c | 535 +++++++++++++++++++++++++++++++++++
>   drivers/vdpa/vdpa_user/iova_domain.h |  75 +++++
>   2 files changed, 610 insertions(+)
>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>
> diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
> new file mode 100644
> index 000000000000..83de216b0e51
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/iova_domain.c
> @@ -0,0 +1,535 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * MMU-based IOMMU implementation
> + *
> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.


2021 as well.


> + *
> + * Author: Xie Yongji <xieyongji@bytedance.com>
> + *
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/file.h>
> +#include <linux/anon_inodes.h>
> +#include <linux/highmem.h>
> +#include <linux/vmalloc.h>
> +#include <linux/vdpa.h>
> +
> +#include "iova_domain.h"
> +
> +static int vduse_iotlb_add_range(struct vduse_iova_domain *domain,
> +				 u64 start, u64 last,
> +				 u64 addr, unsigned int perm,
> +				 struct file *file, u64 offset)
> +{
> +	struct vdpa_map_file *map_file;
> +	int ret;
> +
> +	map_file = kmalloc(sizeof(*map_file), GFP_ATOMIC);
> +	if (!map_file)
> +		return -ENOMEM;
> +
> +	map_file->file = get_file(file);
> +	map_file->offset = offset;
> +
> +	ret = vhost_iotlb_add_range_ctx(domain->iotlb, start, last,
> +					addr, perm, map_file);
> +	if (ret) {
> +		fput(map_file->file);
> +		kfree(map_file);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static void vduse_iotlb_del_range(struct vduse_iova_domain *domain,
> +				  u64 start, u64 last)
> +{
> +	struct vdpa_map_file *map_file;
> +	struct vhost_iotlb_map *map;
> +
> +	while ((map = vhost_iotlb_itree_first(domain->iotlb, start, last))) {
> +		map_file = (struct vdpa_map_file *)map->opaque;
> +		fput(map_file->file);
> +		kfree(map_file);
> +		vhost_iotlb_map_free(domain->iotlb, map);
> +	}
> +}
> +
> +int vduse_domain_set_map(struct vduse_iova_domain *domain,
> +			 struct vhost_iotlb *iotlb)
> +{
> +	struct vdpa_map_file *map_file;
> +	struct vhost_iotlb_map *map;
> +	u64 start = 0ULL, last = ULLONG_MAX;
> +	int ret;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	vduse_iotlb_del_range(domain, start, last);
> +
> +	for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
> +	     map = vhost_iotlb_itree_next(map, start, last)) {
> +		map_file = (struct vdpa_map_file *)map->opaque;
> +		ret = vduse_iotlb_add_range(domain, map->start, map->last,
> +					    map->addr, map->perm,
> +					    map_file->file,
> +					    map_file->offset);
> +		if (ret)
> +			goto err;
> +	}
> +	spin_unlock(&domain->iotlb_lock);
> +
> +	return 0;
> +err:
> +	vduse_iotlb_del_range(domain, start, last);
> +	spin_unlock(&domain->iotlb_lock);
> +	return ret;
> +}
> +
> +static void vduse_domain_map_bounce_page(struct vduse_iova_domain *domain,
> +					 u64 iova, u64 size, u64 paddr)
> +{
> +	struct vduse_bounce_map *map;
> +	unsigned int index;
> +	u64 last = iova + size - 1;
> +
> +	while (iova < last) {
> +		map = &domain->bounce_maps[iova >> PAGE_SHIFT];
> +		index = offset_in_page(iova) >> IOVA_ALLOC_ORDER;
> +		map->orig_phys[index] = paddr;
> +		paddr += IOVA_ALLOC_SIZE;
> +		iova += IOVA_ALLOC_SIZE;
> +	}
> +}
> +
> +static void vduse_domain_unmap_bounce_page(struct vduse_iova_domain *domain,
> +					   u64 iova, u64 size)
> +{
> +	struct vduse_bounce_map *map;
> +	unsigned int index;
> +	u64 last = iova + size - 1;
> +
> +	while (iova < last) {
> +		map = &domain->bounce_maps[iova >> PAGE_SHIFT];
> +		index = offset_in_page(iova) >> IOVA_ALLOC_ORDER;
> +		map->orig_phys[index] = INVALID_PHYS_ADDR;
> +		iova += IOVA_ALLOC_SIZE;
> +	}
> +}
> +
> +static void do_bounce(phys_addr_t orig, void *addr, size_t size,
> +		      enum dma_data_direction dir)
> +{
> +	unsigned long pfn = PFN_DOWN(orig);
> +
> +	if (PageHighMem(pfn_to_page(pfn))) {
> +		unsigned int offset = offset_in_page(orig);
> +		char *buffer;
> +		unsigned int sz = 0;
> +
> +		while (size) {
> +			sz = min_t(size_t, PAGE_SIZE - offset, size);
> +
> +			buffer = kmap_atomic(pfn_to_page(pfn));


So kmap_atomic() can autoamtically go with fast path if the page does 
not belong to highmem.

I think we can removce the condition and just use kmap_atomic() for all 
the cases here.


> +			if (dir == DMA_TO_DEVICE)
> +				memcpy(addr, buffer + offset, sz);
> +			else
> +				memcpy(buffer + offset, addr, sz);
> +			kunmap_atomic(buffer);
> +
> +			size -= sz;
> +			pfn++;
> +			addr += sz;
> +			offset = 0;
> +		}
> +	} else if (dir == DMA_TO_DEVICE) {
> +		memcpy(addr, phys_to_virt(orig), size);
> +	} else {
> +		memcpy(phys_to_virt(orig), addr, size);
> +	}
> +}
> +
> +static void vduse_domain_bounce(struct vduse_iova_domain *domain,
> +				dma_addr_t iova, size_t size,
> +				enum dma_data_direction dir)
> +{
> +	struct vduse_bounce_map *map;
> +	unsigned int index, offset;
> +	void *addr;
> +	size_t sz;
> +
> +	while (size) {
> +		map = &domain->bounce_maps[iova >> PAGE_SHIFT];
> +		offset = offset_in_page(iova);
> +		sz = min_t(size_t, IOVA_ALLOC_SIZE, size);
> +
> +		if (map->bounce_page &&
> +		    map->orig_phys[index] != INVALID_PHYS_ADDR) {
> +			addr = page_address(map->bounce_page) + offset;
> +			index = offset >> IOVA_ALLOC_ORDER;
> +			do_bounce(map->orig_phys[index], addr, sz, dir);
> +		}
> +		size -= sz;
> +		iova += sz;
> +	}
> +}
> +
> +static struct page *
> +vduse_domain_get_mapping_page(struct vduse_iova_domain *domain, u64 iova)
> +{
> +	u64 start = iova & PAGE_MASK;
> +	u64 last = start + PAGE_SIZE - 1;
> +	struct vhost_iotlb_map *map;
> +	struct page *page = NULL;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	map = vhost_iotlb_itree_first(domain->iotlb, start, last);
> +	if (!map)
> +		goto out;
> +
> +	page = pfn_to_page((map->addr + iova - map->start) >> PAGE_SHIFT);
> +	get_page(page);
> +out:
> +	spin_unlock(&domain->iotlb_lock);
> +
> +	return page;
> +}
> +
> +static struct page *
> +vduse_domain_alloc_bounce_page(struct vduse_iova_domain *domain, u64 iova)
> +{
> +	u64 start = iova & PAGE_MASK;
> +	struct page *page = alloc_page(GFP_KERNEL);
> +	struct vduse_bounce_map *map;
> +
> +	if (!page)
> +		return NULL;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	map = &domain->bounce_maps[iova >> PAGE_SHIFT];
> +	if (map->bounce_page) {
> +		__free_page(page);
> +		goto out;
> +	}
> +	map->bounce_page = page;
> +
> +	/* paired with vduse_domain_map_page() */
> +	smp_mb();


So this is suspicious. It's better to explain like, we need make sure A 
must be done after B.

And it looks to me the iotlb_lock is sufficnet to do the synchronization 
here. E.g any reason that you don't take it in 
vduse_domain_map_bounce_page().

And what's more, is there anyway to aovid holding the spinlock during 
bouncing?


> +
> +	vduse_domain_bounce(domain, start, PAGE_SIZE, DMA_TO_DEVICE);
> +out:
> +	get_page(map->bounce_page);
> +	spin_unlock(&domain->iotlb_lock);
> +
> +	return map->bounce_page;
> +}
> +
> +static void
> +vduse_domain_free_bounce_pages(struct vduse_iova_domain *domain)
> +{
> +	struct vduse_bounce_map *map;
> +	unsigned long i, pfn, bounce_pfns;
> +
> +	bounce_pfns = domain->bounce_size >> PAGE_SHIFT;
> +
> +	for (pfn = 0; pfn < bounce_pfns; pfn++) {
> +		map = &domain->bounce_maps[pfn];
> +		for (i = 0; i < IOVA_MAPS_PER_PAGE; i++) {
> +			if (WARN_ON(map->orig_phys[i] != INVALID_PHYS_ADDR))
> +				continue;
> +		}
> +		if (!map->bounce_page)
> +			continue;
> +
> +		__free_page(map->bounce_page);
> +		map->bounce_page = NULL;
> +	}
> +}
> +
> +void vduse_domain_reset_bounce_map(struct vduse_iova_domain *domain)
> +{
> +	if (!domain->bounce_map)
> +		return;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	if (!domain->bounce_map)
> +		goto unlock;
> +
> +	vduse_iotlb_del_range(domain, 0, domain->bounce_size - 1);
> +	domain->bounce_map = 0;
> +	vduse_domain_free_bounce_pages(domain);
> +unlock:
> +	spin_unlock(&domain->iotlb_lock);
> +}
> +
> +static int vduse_domain_init_bounce_map(struct vduse_iova_domain *domain)
> +{
> +	int ret;
> +
> +	if (domain->bounce_map)
> +		return 0;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	if (domain->bounce_map)
> +		goto unlock;
> +
> +	ret = vduse_iotlb_add_range(domain, 0, domain->bounce_size - 1,
> +				    0, VHOST_MAP_RW, domain->file, 0);
> +	if (!ret)
> +		domain->bounce_map = 1;
> +unlock:
> +	spin_unlock(&domain->iotlb_lock);
> +	return ret;
> +}
> +
> +static dma_addr_t
> +vduse_domain_alloc_iova(struct iova_domain *iovad,
> +			unsigned long size, unsigned long limit)
> +{
> +	unsigned long shift = iova_shift(iovad);
> +	unsigned long iova_len = iova_align(iovad, size) >> shift;
> +	unsigned long iova_pfn;
> +
> +	if (iova_len < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
> +		iova_len = roundup_pow_of_two(iova_len);
> +	iova_pfn = alloc_iova_fast(iovad, iova_len, limit >> shift, true);
> +
> +	return iova_pfn << shift;
> +}
> +
> +static void vduse_domain_free_iova(struct iova_domain *iovad,
> +				   dma_addr_t iova, size_t size)
> +{
> +	unsigned long shift = iova_shift(iovad);
> +	unsigned long iova_len = iova_align(iovad, size) >> shift;
> +
> +	free_iova_fast(iovad, iova >> shift, iova_len);
> +}
> +
> +dma_addr_t vduse_domain_map_page(struct vduse_iova_domain *domain,
> +				 struct page *page, unsigned long offset,
> +				 size_t size, enum dma_data_direction dir,
> +				 unsigned long attrs)
> +{
> +	struct iova_domain *iovad = &domain->stream_iovad;
> +	unsigned long limit = domain->bounce_size - 1;
> +	phys_addr_t pa = page_to_phys(page) + offset;
> +	dma_addr_t iova = vduse_domain_alloc_iova(iovad, size, limit);
> +
> +	if (!iova)
> +		return DMA_MAPPING_ERROR;
> +
> +	if (vduse_domain_init_bounce_map(domain)) {
> +		vduse_domain_free_iova(iovad, iova, size);
> +		return DMA_MAPPING_ERROR;
> +	}
> +
> +	vduse_domain_map_bounce_page(domain, (u64)iova, (u64)size, pa);
> +
> +	/* paired with vduse_domain_alloc_bounce_page() */
> +	smp_mb();
> +
> +	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
> +		vduse_domain_bounce(domain, iova, size, DMA_TO_DEVICE);
> +
> +	return iova;
> +}
> +
> +void vduse_domain_unmap_page(struct vduse_iova_domain *domain,
> +			     dma_addr_t dma_addr, size_t size,
> +			     enum dma_data_direction dir, unsigned long attrs)
> +{
> +	struct iova_domain *iovad = &domain->stream_iovad;
> +
> +	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
> +		vduse_domain_bounce(domain, dma_addr, size, DMA_FROM_DEVICE);
> +
> +	vduse_domain_unmap_bounce_page(domain, (u64)dma_addr, (u64)size);
> +	vduse_domain_free_iova(iovad, dma_addr, size);
> +}
> +
> +void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
> +				  size_t size, dma_addr_t *dma_addr,
> +				  gfp_t flag, unsigned long attrs)
> +{
> +	struct iova_domain *iovad = &domain->consistent_iovad;
> +	unsigned long limit = domain->iova_limit;
> +	dma_addr_t iova = vduse_domain_alloc_iova(iovad, size, limit);
> +	void *orig = alloc_pages_exact(size, flag);
> +
> +	if (!iova || !orig)
> +		goto err;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	if (vduse_iotlb_add_range(domain, (u64)iova, (u64)iova + size - 1,
> +				  virt_to_phys(orig), VHOST_MAP_RW,
> +				  domain->file, (u64)iova)) {
> +		spin_unlock(&domain->iotlb_lock);
> +		goto err;
> +	}
> +	spin_unlock(&domain->iotlb_lock);
> +
> +	*dma_addr = iova;
> +
> +	return orig;
> +err:
> +	*dma_addr = DMA_MAPPING_ERROR;
> +	if (orig)
> +		free_pages_exact(orig, size);
> +	if (iova)
> +		vduse_domain_free_iova(iovad, iova, size);
> +
> +	return NULL;
> +}
> +
> +void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
> +				void *vaddr, dma_addr_t dma_addr,
> +				unsigned long attrs)
> +{
> +	struct iova_domain *iovad = &domain->consistent_iovad;
> +	struct vhost_iotlb_map *map;
> +	struct vdpa_map_file *map_file;
> +	phys_addr_t pa;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	map = vhost_iotlb_itree_first(domain->iotlb, (u64)dma_addr,
> +				      (u64)dma_addr + size - 1);
> +	if (WARN_ON(!map)) {
> +		spin_unlock(&domain->iotlb_lock);
> +		return;
> +	}
> +	map_file = (struct vdpa_map_file *)map->opaque;
> +	fput(map_file->file);
> +	kfree(map_file);
> +	pa = map->addr;
> +	vhost_iotlb_map_free(domain->iotlb, map);
> +	spin_unlock(&domain->iotlb_lock);
> +
> +	vduse_domain_free_iova(iovad, dma_addr, size);
> +	free_pages_exact(phys_to_virt(pa), size);


I wonder whether we should free the coherent page after munmap(). 
Otherwise usersapce can poke kernel pages in this way, e.g the page 
could be allocated and used by other subsystems?


> +}
> +
> +static vm_fault_t vduse_domain_mmap_fault(struct vm_fault *vmf)
> +{
> +	struct vduse_iova_domain *domain = vmf->vma->vm_private_data;
> +	unsigned long iova = vmf->pgoff << PAGE_SHIFT;
> +	struct page *page;
> +
> +	if (!domain)
> +		return VM_FAULT_SIGBUS;
> +
> +	if (iova < domain->bounce_size)
> +		page = vduse_domain_alloc_bounce_page(domain, iova);
> +	else
> +		page = vduse_domain_get_mapping_page(domain, iova);
> +
> +	if (!page)
> +		return VM_FAULT_SIGBUS;
> +
> +	vmf->page = page;
> +
> +	return 0;
> +}
> +
> +static const struct vm_operations_struct vduse_domain_mmap_ops = {
> +	.fault = vduse_domain_mmap_fault,
> +};
> +
> +static int vduse_domain_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct vduse_iova_domain *domain = file->private_data;
> +
> +	vma->vm_flags |= VM_DONTDUMP | VM_DONTEXPAND;
> +	vma->vm_private_data = domain;
> +	vma->vm_ops = &vduse_domain_mmap_ops;
> +
> +	return 0;
> +}
> +
> +static int vduse_domain_release(struct inode *inode, struct file *file)
> +{
> +	struct vduse_iova_domain *domain = file->private_data;
> +
> +	vduse_domain_reset_bounce_map(domain);
> +	put_iova_domain(&domain->stream_iovad);
> +	put_iova_domain(&domain->consistent_iovad);
> +	vhost_iotlb_free(domain->iotlb);
> +	vfree(domain->bounce_maps);
> +	kfree(domain);
> +
> +	return 0;
> +}
> +
> +static const struct file_operations vduse_domain_fops = {
> +	.mmap = vduse_domain_mmap,
> +	.release = vduse_domain_release,
> +};
> +
> +void vduse_domain_destroy(struct vduse_iova_domain *domain)
> +{
> +	fput(domain->file);
> +}
> +
> +struct vduse_iova_domain *
> +vduse_domain_create(unsigned long iova_limit, size_t bounce_size)
> +{
> +	struct vduse_iova_domain *domain;
> +	struct file *file;
> +	struct vduse_bounce_map *map;
> +	unsigned long i, pfn, bounce_pfns;
> +
> +	bounce_pfns = PAGE_ALIGN(bounce_size) >> PAGE_SHIFT;
> +	if (iova_limit <= bounce_size)
> +		return NULL;
> +
> +	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
> +	if (!domain)
> +		return NULL;
> +
> +	domain->iotlb = vhost_iotlb_alloc(0, 0);
> +	if (!domain->iotlb)
> +		goto err_iotlb;
> +
> +	domain->iova_limit = iova_limit;
> +	domain->bounce_size = PAGE_ALIGN(bounce_size);
> +	domain->bounce_maps = vzalloc(bounce_pfns *
> +				sizeof(struct vduse_bounce_map));
> +	if (!domain->bounce_maps)
> +		goto err_map;
> +
> +	for (pfn = 0; pfn < bounce_pfns; pfn++) {
> +		map = &domain->bounce_maps[pfn];
> +		for (i = 0; i < IOVA_MAPS_PER_PAGE; i++)
> +			map->orig_phys[i] = INVALID_PHYS_ADDR;
> +	}
> +	file = anon_inode_getfile("[vduse-domain]", &vduse_domain_fops,
> +				domain, O_RDWR);
> +	if (IS_ERR(file))
> +		goto err_file;
> +
> +	domain->file = file;
> +	spin_lock_init(&domain->iotlb_lock);
> +	init_iova_domain(&domain->stream_iovad,
> +			IOVA_ALLOC_SIZE, IOVA_START_PFN);
> +	init_iova_domain(&domain->consistent_iovad,
> +			PAGE_SIZE, bounce_pfns);


Any reason for treating coherent and stream DMA differently (the 
different granule)?


> +
> +	return domain;
> +err_file:
> +	vfree(domain->bounce_maps);
> +err_map:
> +	vhost_iotlb_free(domain->iotlb);
> +err_iotlb:
> +	kfree(domain);
> +	return NULL;
> +}
> +
> +int vduse_domain_init(void)
> +{
> +	return iova_cache_get();
> +}
> +
> +void vduse_domain_exit(void)
> +{
> +	iova_cache_put();
> +}
> diff --git a/drivers/vdpa/vdpa_user/iova_domain.h b/drivers/vdpa/vdpa_user/iova_domain.h
> new file mode 100644
> index 000000000000..faeeedfaa786
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/iova_domain.h
> @@ -0,0 +1,75 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * MMU-based IOMMU implementation
> + *
> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
> + *
> + * Author: Xie Yongji <xieyongji@bytedance.com>
> + *
> + */
> +
> +#ifndef _VDUSE_IOVA_DOMAIN_H
> +#define _VDUSE_IOVA_DOMAIN_H
> +
> +#include <linux/iova.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/vhost_iotlb.h>
> +
> +#define IOVA_START_PFN 1
> +
> +#define IOVA_ALLOC_ORDER 12
> +#define IOVA_ALLOC_SIZE (1 << IOVA_ALLOC_ORDER)
> +
> +#define IOVA_MAPS_PER_PAGE (1 << (PAGE_SHIFT - IOVA_ALLOC_ORDER))
> +
> +#define INVALID_PHYS_ADDR (~(phys_addr_t)0)
> +
> +struct vduse_bounce_map {
> +	struct page *bounce_page;
> +	u64 orig_phys[IOVA_MAPS_PER_PAGE];


Sorry if I had asked this before. But I'm not sure it's worth to have 
this extra complexitiy. If I read the code correctly, the 
IOVA_MAPS_PER_PAGE is 1 for the archs that have 4K page. Have you tested 
the code on the archs that have more than 4K page?

Thanks


> +};
> +
> +struct vduse_iova_domain {
> +	struct iova_domain stream_iovad;
> +	struct iova_domain consistent_iovad;
> +	struct vduse_bounce_map *bounce_maps;
> +	size_t bounce_size;
> +	unsigned long iova_limit;
> +	int bounce_map;
> +	struct vhost_iotlb *iotlb;
> +	spinlock_t iotlb_lock;
> +	struct file *file;
> +};
> +
> +int vduse_domain_set_map(struct vduse_iova_domain *domain,
> +			struct vhost_iotlb *iotlb);
> +
> +dma_addr_t vduse_domain_map_page(struct vduse_iova_domain *domain,
> +				struct page *page, unsigned long offset,
> +				size_t size, enum dma_data_direction dir,
> +				unsigned long attrs);
> +
> +void vduse_domain_unmap_page(struct vduse_iova_domain *domain,
> +			dma_addr_t dma_addr, size_t size,
> +			enum dma_data_direction dir, unsigned long attrs);
> +
> +void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
> +				size_t size, dma_addr_t *dma_addr,
> +				gfp_t flag, unsigned long attrs);
> +
> +void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size_t size,
> +				void *vaddr, dma_addr_t dma_addr,
> +				unsigned long attrs);
> +
> +void vduse_domain_reset_bounce_map(struct vduse_iova_domain *domain);
> +
> +void vduse_domain_destroy(struct vduse_iova_domain *domain);
> +
> +struct vduse_iova_domain *vduse_domain_create(unsigned long iova_limit,
> +						size_t bounce_size);
> +
> +int vduse_domain_init(void);
> +
> +void vduse_domain_exit(void);
> +
> +#endif /* _VDUSE_IOVA_DOMAIN_H */

