Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338E532CB53
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 05:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhCDEXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 23:23:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233387AbhCDEWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 23:22:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614831684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ql4/2JdGvyiU2L0vSjfNkpvS5Y9CbZX+WsSes4XDNzY=;
        b=RTGuyTe7CrFI3sBXj96qrdSHDPHIDnMPovfWffJNhmgwOJHjAPcyJ7A6GYIRkCrszuuHoY
        DQog247XFyeCIj/YzpBE2ZWD0dNg9FwyTj45mruRQ17vQxr59XPR8MCtZWdV4Yo6jXWeKP
        R7VfGv+JUTri7ks1s62tUmEvtDPrcTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-33vzA97_Ozq5yZMm7O-LgQ-1; Wed, 03 Mar 2021 23:21:20 -0500
X-MC-Unique: 33vzA97_Ozq5yZMm7O-LgQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02CC21936B78;
        Thu,  4 Mar 2021 04:21:18 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-244.pek2.redhat.com [10.72.13.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5E5A6F92F;
        Thu,  4 Mar 2021 04:20:43 +0000 (UTC)
Subject: Re: [RFC v4 06/11] vduse: Implement an MMU-based IOMMU driver
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-7-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <573ab913-55ce-045a-478f-1200bd78cf7b@redhat.com>
Date:   Thu, 4 Mar 2021 12:20:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210223115048.435-7-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/23 7:50 下午, Xie Yongji wrote:
> This implements a MMU-based IOMMU driver to support mapping
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
>   drivers/vdpa/vdpa_user/iova_domain.c | 486 +++++++++++++++++++++++++++++++++++
>   drivers/vdpa/vdpa_user/iova_domain.h |  61 +++++
>   2 files changed, 547 insertions(+)
>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>
> diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
> new file mode 100644
> index 000000000000..9285d430d486
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/iova_domain.c
> @@ -0,0 +1,486 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * MMU-based IOMMU implementation
> + *
> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
> + *
> + * Author: Xie Yongji <xieyongji@bytedance.com>
> + *
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/file.h>
> +#include <linux/anon_inodes.h>
> +#include <linux/highmem.h>
> +
> +#include "iova_domain.h"
> +
> +#define IOVA_START_PFN 1
> +#define IOVA_ALLOC_ORDER 12
> +#define IOVA_ALLOC_SIZE (1 << IOVA_ALLOC_ORDER)
> +
> +static inline struct page *
> +vduse_domain_get_bounce_page(struct vduse_iova_domain *domain, u64 iova)
> +{
> +	u64 index = iova >> PAGE_SHIFT;
> +
> +	return domain->bounce_pages[index];
> +}
> +
> +static inline void
> +vduse_domain_set_bounce_page(struct vduse_iova_domain *domain,
> +				u64 iova, struct page *page)
> +{
> +	u64 index = iova >> PAGE_SHIFT;
> +
> +	domain->bounce_pages[index] = page;
> +}
> +
> +static enum dma_data_direction perm_to_dir(int perm)
> +{
> +	enum dma_data_direction dir;
> +
> +	switch (perm) {
> +	case VHOST_MAP_WO:
> +		dir = DMA_FROM_DEVICE;
> +		break;
> +	case VHOST_MAP_RO:
> +		dir = DMA_TO_DEVICE;
> +		break;
> +	case VHOST_MAP_RW:
> +		dir = DMA_BIDIRECTIONAL;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return dir;
> +}
> +
> +static int dir_to_perm(enum dma_data_direction dir)
> +{
> +	int perm = -EFAULT;
> +
> +	switch (dir) {
> +	case DMA_FROM_DEVICE:
> +		perm = VHOST_MAP_WO;
> +		break;
> +	case DMA_TO_DEVICE:
> +		perm = VHOST_MAP_RO;
> +		break;
> +	case DMA_BIDIRECTIONAL:
> +		perm = VHOST_MAP_RW;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return perm;
> +}


Let's move the above two helpers to vhost_iotlb.h so they could be used 
by other driver e.g (vpda_sim)


> +
> +static void do_bounce(phys_addr_t orig, void *addr, size_t size,
> +			enum dma_data_direction dir)
> +{
> +	unsigned long pfn = PFN_DOWN(orig);
> +
> +	if (PageHighMem(pfn_to_page(pfn))) {
> +		unsigned int offset = offset_in_page(orig);
> +		char *buffer;
> +		unsigned int sz = 0;
> +		unsigned long flags;
> +
> +		while (size) {
> +			sz = min_t(size_t, PAGE_SIZE - offset, size);
> +
> +			local_irq_save(flags);
> +			buffer = kmap_atomic(pfn_to_page(pfn));
> +			if (dir == DMA_TO_DEVICE)
> +				memcpy(addr, buffer + offset, sz);
> +			else
> +				memcpy(buffer + offset, addr, sz);
> +			kunmap_atomic(buffer);
> +			local_irq_restore(flags);


I wonder why we need to deal with highmem and irq flags explicitly like 
this. Doesn't kmap_atomic() will take care all of those?


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
> +	u64 last = start + PAGE_SIZE - 1;
> +	struct vhost_iotlb_map *map;
> +	struct page *page = NULL, *new_page = alloc_page(GFP_KERNEL);
> +
> +	if (!new_page)
> +		return NULL;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	if (!vhost_iotlb_itree_first(domain->iotlb, start, last)) {
> +		__free_page(new_page);
> +		goto out;
> +	}
> +	page = vduse_domain_get_bounce_page(domain, iova);
> +	if (page) {
> +		get_page(page);
> +		__free_page(new_page);
> +		goto out;
> +	}
> +	vduse_domain_set_bounce_page(domain, iova, new_page);
> +	get_page(new_page);
> +	page = new_page;
> +
> +	for (map = vhost_iotlb_itree_first(domain->iotlb, start, last); map;
> +	     map = vhost_iotlb_itree_next(map, start, last)) {
> +		unsigned int src_offset = 0, dst_offset = 0;
> +		phys_addr_t src;
> +		void *dst;
> +		size_t sz;
> +
> +		if (perm_to_dir(map->perm) == DMA_FROM_DEVICE)
> +			continue;
> +
> +		if (start > map->start)
> +			src_offset = start - map->start;
> +		else
> +			dst_offset = map->start - start;
> +
> +		src = map->addr + src_offset;
> +		dst = page_address(page) + dst_offset;
> +		sz = min_t(size_t, map->size - src_offset,
> +				PAGE_SIZE - dst_offset);
> +		do_bounce(src, dst, sz, DMA_TO_DEVICE);
> +	}
> +out:
> +	spin_unlock(&domain->iotlb_lock);
> +
> +	return page;
> +}
> +
> +static void
> +vduse_domain_free_bounce_pages(struct vduse_iova_domain *domain,
> +				u64 iova, size_t size)
> +{
> +	struct page *page;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	if (WARN_ON(vhost_iotlb_itree_first(domain->iotlb, iova,
> +						iova + size - 1)))
> +		goto out;
> +
> +	while (size > 0) {
> +		page = vduse_domain_get_bounce_page(domain, iova);
> +		if (page) {
> +			vduse_domain_set_bounce_page(domain, iova, NULL);
> +			__free_page(page);
> +		}
> +		size -= PAGE_SIZE;
> +		iova += PAGE_SIZE;
> +	}
> +out:
> +	spin_unlock(&domain->iotlb_lock);
> +}
> +
> +static void vduse_domain_bounce(struct vduse_iova_domain *domain,
> +				dma_addr_t iova, phys_addr_t orig,
> +				size_t size, enum dma_data_direction dir)
> +{
> +	unsigned int offset = offset_in_page(iova);
> +
> +	while (size) {
> +		struct page *p = vduse_domain_get_bounce_page(domain, iova);
> +		size_t sz = min_t(size_t, PAGE_SIZE - offset, size);
> +
> +		WARN_ON(!p && dir == DMA_FROM_DEVICE);
> +
> +		if (p)
> +			do_bounce(orig, page_address(p) + offset, sz, dir);
> +
> +		size -= sz;
> +		orig += sz;
> +		iova += sz;
> +		offset = 0;
> +	}
> +}
> +
> +static dma_addr_t vduse_domain_alloc_iova(struct iova_domain *iovad,
> +				unsigned long size, unsigned long limit)
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
> +				dma_addr_t iova, size_t size)
> +{
> +	unsigned long shift = iova_shift(iovad);
> +	unsigned long iova_len = iova_align(iovad, size) >> shift;
> +
> +	free_iova_fast(iovad, iova >> shift, iova_len);
> +}
> +
> +dma_addr_t vduse_domain_map_page(struct vduse_iova_domain *domain,
> +				struct page *page, unsigned long offset,
> +				size_t size, enum dma_data_direction dir,
> +				unsigned long attrs)
> +{
> +	struct iova_domain *iovad = &domain->stream_iovad;
> +	unsigned long limit = domain->bounce_size - 1;
> +	phys_addr_t pa = page_to_phys(page) + offset;
> +	dma_addr_t iova = vduse_domain_alloc_iova(iovad, size, limit);
> +	int ret;
> +
> +	if (!iova)
> +		return DMA_MAPPING_ERROR;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	ret = vhost_iotlb_add_range(domain->iotlb, (u64)iova,
> +				    (u64)iova + size - 1,
> +				    pa, dir_to_perm(dir));
> +	spin_unlock(&domain->iotlb_lock);
> +	if (ret) {
> +		vduse_domain_free_iova(iovad, iova, size);
> +		return DMA_MAPPING_ERROR;
> +	}
> +	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
> +		vduse_domain_bounce(domain, iova, pa, size, DMA_TO_DEVICE);
> +
> +	return iova;
> +}
> +
> +void vduse_domain_unmap_page(struct vduse_iova_domain *domain,
> +			dma_addr_t dma_addr, size_t size,
> +			enum dma_data_direction dir, unsigned long attrs)
> +{
> +	struct iova_domain *iovad = &domain->stream_iovad;
> +	struct vhost_iotlb_map *map;
> +	phys_addr_t pa;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	map = vhost_iotlb_itree_first(domain->iotlb, (u64)dma_addr,
> +				      (u64)dma_addr + size - 1);
> +	if (WARN_ON(!map)) {
> +		spin_unlock(&domain->iotlb_lock);
> +		return;
> +	}
> +	pa = map->addr;
> +	vhost_iotlb_map_free(domain->iotlb, map);
> +	spin_unlock(&domain->iotlb_lock);
> +
> +	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
> +		vduse_domain_bounce(domain, dma_addr, pa,
> +					size, DMA_FROM_DEVICE);
> +
> +	vduse_domain_free_iova(iovad, dma_addr, size);
> +}
> +
> +void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
> +				size_t size, dma_addr_t *dma_addr,
> +				gfp_t flag, unsigned long attrs)
> +{
> +	struct iova_domain *iovad = &domain->consistent_iovad;
> +	unsigned long limit = domain->iova_limit;
> +	dma_addr_t iova = vduse_domain_alloc_iova(iovad, size, limit);
> +	void *orig = alloc_pages_exact(size, flag);
> +	int ret;
> +
> +	if (!iova || !orig)
> +		goto err;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	ret = vhost_iotlb_add_range(domain->iotlb, (u64)iova,
> +				    (u64)iova + size - 1,
> +				    virt_to_phys(orig), VHOST_MAP_RW);
> +	spin_unlock(&domain->iotlb_lock);
> +	if (ret)
> +		goto err;
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
> +	phys_addr_t pa;
> +
> +	spin_lock(&domain->iotlb_lock);
> +	map = vhost_iotlb_itree_first(domain->iotlb, (u64)dma_addr,
> +				      (u64)dma_addr + size - 1);
> +	if (WARN_ON(!map)) {
> +		spin_unlock(&domain->iotlb_lock);
> +		return;
> +	}
> +	pa = map->addr;
> +	vhost_iotlb_map_free(domain->iotlb, map);
> +	spin_unlock(&domain->iotlb_lock);
> +
> +	vduse_domain_free_iova(iovad, dma_addr, size);
> +	free_pages_exact(phys_to_virt(pa), size);
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
> +	vduse_domain_free_bounce_pages(domain, 0, domain->bounce_size);
> +	put_iova_domain(&domain->stream_iovad);
> +	put_iova_domain(&domain->consistent_iovad);
> +	vhost_iotlb_free(domain->iotlb);
> +	vfree(domain->bounce_pages);
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
> +	unsigned long bounce_pfns = PAGE_ALIGN(bounce_size) >> PAGE_SHIFT;
> +
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
> +	domain->bounce_pages = vzalloc(bounce_pfns * sizeof(struct page *));
> +	if (!domain->bounce_pages)
> +		goto err_page;
> +
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
> +
> +	return domain;
> +err_file:
> +	vfree(domain->bounce_pages);
> +err_page:
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
> index 000000000000..9c85d8346626
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/iova_domain.h
> @@ -0,0 +1,61 @@
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
> +struct vduse_iova_domain {
> +	struct iova_domain stream_iovad;
> +	struct iova_domain consistent_iovad;
> +	struct page **bounce_pages;
> +	size_t bounce_size;
> +	unsigned long iova_limit;
> +	struct vhost_iotlb *iotlb;


Sorry if I've asked this before.

But what's the reason for maintaing a dedicated IOTLB here? I think we 
could reuse vduse_dev->iommu since the device can not be used by both 
virtio and vhost in the same time or use vduse_iova_domain->iotlb for 
set_map().

Also, since vhost IOTLB support per mapping token (opauqe), can we use 
that instead of the bounce_pages *?

Thanks


> +	spinlock_t iotlb_lock;
> +	struct file *file;
> +};
> +
> +static inline struct file *
> +vduse_domain_file(struct vduse_iova_domain *domain)
> +{
> +	return domain->file;
> +}
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

