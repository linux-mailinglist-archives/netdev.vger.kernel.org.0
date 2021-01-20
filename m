Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D3A2FCB1F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 07:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbhATGjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 01:39:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729648AbhATG01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 01:26:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611123898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CDA4xwYeepwFlkHJwgrw6oW3JHghWeOFqqsJlNpUR/Q=;
        b=NDrSmWMDX/BkbaL382GPXqFkI487NGZNoJdT5rFonLsTBNbj2v7Om/ct4DJLddzGPXxCon
        QQ4w6Ki3eCIULvb1ENVFIulbA3Ol8qJcfKRXI5J4Tn4UM9/U7CBC47aP/Ti6sYYGBzKlmb
        k4Z6XU9lBpMM08JnWZtcfQEx4j9Xwzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-wjWc5C-GNYGX9unYD_fSZg-1; Wed, 20 Jan 2021 01:24:54 -0500
X-MC-Unique: wjWc5C-GNYGX9unYD_fSZg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 198978015C6;
        Wed, 20 Jan 2021 06:24:52 +0000 (UTC)
Received: from [10.72.13.124] (ovpn-13-124.pek2.redhat.com [10.72.13.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79BE25D9DD;
        Wed, 20 Jan 2021 06:24:40 +0000 (UTC)
Subject: Re: [RFC v3 06/11] vhost-vdpa: Add an opaque pointer for vhost IOTLB
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119045920.447-7-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <455fe36a-23a2-5720-a721-8ae46515186b@redhat.com>
Date:   Wed, 20 Jan 2021 14:24:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210119045920.447-7-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/19 下午12:59, Xie Yongji wrote:
> Add an opaque pointer for vhost IOTLB to store the
> corresponding vma->vm_file and offset on the DMA mapping.


Let's split the patch into two.

1) opaque pointer
2) vma stuffs


>
> It will be used in VDUSE case later.
>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/vdpa/vdpa_sim/vdpa_sim.c | 11 ++++---
>   drivers/vhost/iotlb.c            |  5 ++-
>   drivers/vhost/vdpa.c             | 66 +++++++++++++++++++++++++++++++++++-----
>   drivers/vhost/vhost.c            |  4 +--
>   include/linux/vdpa.h             |  3 +-
>   include/linux/vhost_iotlb.h      |  8 ++++-
>   6 files changed, 79 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index 03c796873a6b..1ffcef67954f 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -279,7 +279,7 @@ static dma_addr_t vdpasim_map_page(struct device *dev, struct page *page,
>   	 */
>   	spin_lock(&vdpasim->iommu_lock);
>   	ret = vhost_iotlb_add_range(iommu, pa, pa + size - 1,
> -				    pa, dir_to_perm(dir));
> +				    pa, dir_to_perm(dir), NULL);


Maybe its better to introduce

vhost_iotlb_add_range_ctx() which can accepts the opaque (context). And 
let vhost_iotlb_add_range() just call that.


>   	spin_unlock(&vdpasim->iommu_lock);
>   	if (ret)
>   		return DMA_MAPPING_ERROR;
> @@ -317,7 +317,7 @@ static void *vdpasim_alloc_coherent(struct device *dev, size_t size,
>   
>   		ret = vhost_iotlb_add_range(iommu, (u64)pa,
>   					    (u64)pa + size - 1,
> -					    pa, VHOST_MAP_RW);
> +					    pa, VHOST_MAP_RW, NULL);
>   		if (ret) {
>   			*dma_addr = DMA_MAPPING_ERROR;
>   			kfree(addr);
> @@ -625,7 +625,8 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
>   	for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
>   	     map = vhost_iotlb_itree_next(map, start, last)) {
>   		ret = vhost_iotlb_add_range(vdpasim->iommu, map->start,
> -					    map->last, map->addr, map->perm);
> +					    map->last, map->addr,
> +					    map->perm, NULL);
>   		if (ret)
>   			goto err;
>   	}
> @@ -639,14 +640,14 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
>   }
>   
>   static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
> -			   u64 pa, u32 perm)
> +			   u64 pa, u32 perm, void *opaque)
>   {
>   	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>   	int ret;
>   
>   	spin_lock(&vdpasim->iommu_lock);
>   	ret = vhost_iotlb_add_range(vdpasim->iommu, iova, iova + size - 1, pa,
> -				    perm);
> +				    perm, NULL);
>   	spin_unlock(&vdpasim->iommu_lock);
>   
>   	return ret;
> diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> index 0fd3f87e913c..3bd5bd06cdbc 100644
> --- a/drivers/vhost/iotlb.c
> +++ b/drivers/vhost/iotlb.c
> @@ -42,13 +42,15 @@ EXPORT_SYMBOL_GPL(vhost_iotlb_map_free);
>    * @last: last of IOVA range
>    * @addr: the address that is mapped to @start
>    * @perm: access permission of this range
> + * @opaque: the opaque pointer for the IOTLB mapping
>    *
>    * Returns an error last is smaller than start or memory allocation
>    * fails
>    */
>   int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
>   			  u64 start, u64 last,
> -			  u64 addr, unsigned int perm)
> +			  u64 addr, unsigned int perm,
> +			  void *opaque)
>   {
>   	struct vhost_iotlb_map *map;
>   
> @@ -71,6 +73,7 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
>   	map->last = last;
>   	map->addr = addr;
>   	map->perm = perm;
> +	map->opaque = opaque;
>   
>   	iotlb->nmaps++;
>   	vhost_iotlb_itree_insert(map, &iotlb->root);
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 36b6950ba37f..e83e5be7cec8 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -488,6 +488,7 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>   	struct vhost_dev *dev = &v->vdev;
>   	struct vdpa_device *vdpa = v->vdpa;
>   	struct vhost_iotlb *iotlb = dev->iotlb;
> +	struct vhost_iotlb_file *iotlb_file;
>   	struct vhost_iotlb_map *map;
>   	struct page *page;
>   	unsigned long pfn, pinned;
> @@ -504,6 +505,10 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>   			}
>   			atomic64_sub(map->size >> PAGE_SHIFT,
>   					&dev->mm->pinned_vm);
> +		} else if (map->opaque) {
> +			iotlb_file = (struct vhost_iotlb_file *)map->opaque;
> +			fput(iotlb_file->file);
> +			kfree(iotlb_file);
>   		}
>   		vhost_iotlb_map_free(iotlb, map);
>   	}
> @@ -540,8 +545,8 @@ static int perm_to_iommu_flags(u32 perm)
>   	return flags | IOMMU_CACHE;
>   }
>   
> -static int vhost_vdpa_map(struct vhost_vdpa *v,
> -			  u64 iova, u64 size, u64 pa, u32 perm)
> +static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
> +			  u64 size, u64 pa, u32 perm, void *opaque)
>   {
>   	struct vhost_dev *dev = &v->vdev;
>   	struct vdpa_device *vdpa = v->vdpa;
> @@ -549,12 +554,12 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
>   	int r = 0;
>   
>   	r = vhost_iotlb_add_range(dev->iotlb, iova, iova + size - 1,
> -				  pa, perm);
> +				  pa, perm, opaque);
>   	if (r)
>   		return r;
>   
>   	if (ops->dma_map) {
> -		r = ops->dma_map(vdpa, iova, size, pa, perm);
> +		r = ops->dma_map(vdpa, iova, size, pa, perm, opaque);
>   	} else if (ops->set_map) {
>   		if (!v->in_batch)
>   			r = ops->set_map(vdpa, dev->iotlb);
> @@ -591,6 +596,51 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
>   	}
>   }
>   
> +static int vhost_vdpa_sva_map(struct vhost_vdpa *v,
> +			      u64 iova, u64 size, u64 uaddr, u32 perm)
> +{
> +	u64 offset, map_size, map_iova = iova;
> +	struct vhost_iotlb_file *iotlb_file;
> +	struct vm_area_struct *vma;
> +	int ret;


Lacking mmap_read_lock().


> +
> +	while (size) {
> +		vma = find_vma(current->mm, uaddr);
> +		if (!vma) {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +		map_size = min(size, vma->vm_end - uaddr);
> +		offset = (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->vm_start;
> +		iotlb_file = NULL;
> +		if (vma->vm_file && (vma->vm_flags & VM_SHARED)) {


I wonder if we need more strict check here. When developing vhost-vdpa, 
I try hard to make sure the map can only work for user pages.

So the question is: do we need to exclude MMIO area or only allow shmem 
to work here?



> +			iotlb_file = kmalloc(sizeof(*iotlb_file), GFP_KERNEL);
> +			if (!iotlb_file) {
> +				ret = -ENOMEM;
> +				goto err;
> +			}
> +			iotlb_file->file = get_file(vma->vm_file);
> +			iotlb_file->offset = offset;
> +		}


I wonder if it's better to allocate iotlb_file and make iotlb_file->file 
= NULL && iotlb_file->offset = 0. This can force a consistent code for 
the vDPA parents.

Or we can simply fail the map without a file as backend.


> +		ret = vhost_vdpa_map(v, map_iova, map_size, uaddr,
> +					perm, iotlb_file);
> +		if (ret) {
> +			if (iotlb_file) {
> +				fput(iotlb_file->file);
> +				kfree(iotlb_file);
> +			}
> +			goto err;
> +		}
> +		size -= map_size;
> +		uaddr += map_size;
> +		map_iova += map_size;
> +	}
> +	return 0;
> +err:
> +	vhost_vdpa_unmap(v, iova, map_iova - iova);
> +	return ret;
> +}
> +
>   static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   					   struct vhost_iotlb_msg *msg)
>   {
> @@ -615,8 +665,8 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   		return -EEXIST;
>   
>   	if (vdpa->sva)
> -		return vhost_vdpa_map(v, msg->iova, msg->size,
> -				      msg->uaddr, msg->perm);
> +		return vhost_vdpa_sva_map(v, msg->iova, msg->size,
> +					  msg->uaddr, msg->perm);


So I think it's better squash vhost_vdpa_sva_map() and related changes 
into previous patch.


>   
>   	/* Limit the use of memory for bookkeeping */
>   	page_list = (struct page **) __get_free_page(GFP_KERNEL);
> @@ -671,7 +721,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
>   				ret = vhost_vdpa_map(v, iova, csize,
>   						     map_pfn << PAGE_SHIFT,
> -						     msg->perm);
> +						     msg->perm, NULL);
>   				if (ret) {
>   					/*
>   					 * Unpin the pages that are left unmapped
> @@ -700,7 +750,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   
>   	/* Pin the rest chunk */
>   	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
> -			     map_pfn << PAGE_SHIFT, msg->perm);
> +			     map_pfn << PAGE_SHIFT, msg->perm, NULL);
>   out:
>   	if (ret) {
>   		if (nchunks) {
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index a262e12c6dc2..120dd5b3c119 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1104,7 +1104,7 @@ static int vhost_process_iotlb_msg(struct vhost_dev *dev,
>   		vhost_vq_meta_reset(dev);
>   		if (vhost_iotlb_add_range(dev->iotlb, msg->iova,
>   					  msg->iova + msg->size - 1,
> -					  msg->uaddr, msg->perm)) {
> +					  msg->uaddr, msg->perm, NULL)) {
>   			ret = -ENOMEM;
>   			break;
>   		}
> @@ -1450,7 +1450,7 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
>   					  region->guest_phys_addr +
>   					  region->memory_size - 1,
>   					  region->userspace_addr,
> -					  VHOST_MAP_RW))
> +					  VHOST_MAP_RW, NULL))
>   			goto err;
>   	}
>   
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index f86869651614..b264c627e94b 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -189,6 +189,7 @@ struct vdpa_iova_range {
>    *				@size: size of the area
>    *				@pa: physical address for the map
>    *				@perm: device access permission (VHOST_MAP_XX)
> + *				@opaque: the opaque pointer for the mapping
>    *				Returns integer: success (0) or error (< 0)
>    * @dma_unmap:			Unmap an area of IOVA (optional but
>    *				must be implemented with dma_map)
> @@ -243,7 +244,7 @@ struct vdpa_config_ops {
>   	/* DMA ops */
>   	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
>   	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
> -		       u64 pa, u32 perm);
> +		       u64 pa, u32 perm, void *opaque);
>   	int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
>   
>   	/* Free device resources */
> diff --git a/include/linux/vhost_iotlb.h b/include/linux/vhost_iotlb.h
> index 6b09b786a762..66a50c11c8ca 100644
> --- a/include/linux/vhost_iotlb.h
> +++ b/include/linux/vhost_iotlb.h
> @@ -4,6 +4,11 @@
>   
>   #include <linux/interval_tree_generic.h>
>   
> +struct vhost_iotlb_file {
> +	struct file *file;
> +	u64 offset;
> +};


I think we'd better either:

1) simply use struct vhost_iotlb_file * instead of void *opaque for 
vhost_iotlb_map

or

2)rename and move the vhost_iotlb_file to vdpa

2) looks better since we want to let vhost iotlb to carry any type of 
context (opaque pointer)

And if we do this, the modification of vdpa_config_ops deserves a 
separate patch.

Thanks


> +
>   struct vhost_iotlb_map {
>   	struct rb_node rb;
>   	struct list_head link;
> @@ -17,6 +22,7 @@ struct vhost_iotlb_map {
>   	u32 perm;
>   	u32 flags_padding;
>   	u64 __subtree_last;
> +	void *opaque;
>   };
>   
>   #define VHOST_IOTLB_FLAG_RETIRE 0x1
> @@ -30,7 +36,7 @@ struct vhost_iotlb {
>   };
>   
>   int vhost_iotlb_add_range(struct vhost_iotlb *iotlb, u64 start, u64 last,
> -			  u64 addr, unsigned int perm);
> +			  u64 addr, unsigned int perm, void *opaque);
>   void vhost_iotlb_del_range(struct vhost_iotlb *iotlb, u64 start, u64 last);
>   
>   struct vhost_iotlb *vhost_iotlb_alloc(unsigned int limit, unsigned int flags);

