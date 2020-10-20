Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73E028204A
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 04:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgJCCCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 22:02:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgJCCCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 22:02:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601690549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jiMlllEEKTQjIlICQJljkp75MtdRoQ3SeCkSnkimWXc=;
        b=exoInPDtu8OSK+7yucXoiQcvmg7D+SYLoJHoC58d306Ef/HfRaC8Uyp+EWdeUPoS6ZTKr0
        q981EYvJTYSQjfLR69W1c4KupPLyskpcyDABcm6i7ZWaQ6M1/bEsJKsdi6QMRebGNMGB7U
        8Nj6XCnSR0uepqmOzbcu7kGK9dAirsg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-OWteqTiIPCaVq9BquirjMw-1; Fri, 02 Oct 2020 22:02:27 -0400
X-MC-Unique: OWteqTiIPCaVq9BquirjMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B2B11006703;
        Sat,  3 Oct 2020 02:02:26 +0000 (UTC)
Received: from [10.72.12.21] (ovpn-12-21.pek2.redhat.com [10.72.12.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E0DA1992F;
        Sat,  3 Oct 2020 02:02:17 +0000 (UTC)
Subject: Re: [PATCH] vhost-vdpa: fix page pinning leakage in error path
To:     Si-Wei Liu <si-wei.liu@oracle.com>, tiwei.bie@intel.com,
        lingshan.zhu@intel.com, mst@redhat.com
Cc:     joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1601583799-15274-1-git-send-email-si-wei.liu@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <37df4421-7642-9b02-1859-af3a807d3e65@redhat.com>
Date:   Sat, 3 Oct 2020 10:02:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1601583799-15274-1-git-send-email-si-wei.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/2 上午4:23, Si-Wei Liu wrote:
> Pinned pages are not properly accounted particularly when
> mapping error occurs on IOTLB update. Clean up dangling
> pinned pages for the error path. As the inflight pinned
> pages, specifically for memory region that strides across
> multiple chunks, would need more than one free page for
> book keeping and accounting. For simplicity, pin pages
> for all memory in the IOVA range in one go rather than
> have multiple pin_user_pages calls to make up the entire
> region. This way it's easier to track and account the
> pages already mapped, particularly for clean-up in the
> error path.
>
> Fixes: 20453a45fb06 ("vhost: introduce vDPA-based backend")
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> ---
>   drivers/vhost/vdpa.c | 121 +++++++++++++++++++++++++++++++--------------------
>   1 file changed, 73 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 796fe97..abc4aa2 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -565,6 +565,8 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
>   			      perm_to_iommu_flags(perm));
>   	}
>   
> +	if (r)
> +		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
>   	return r;
>   }


Please use a separate patch for this fix.


>   
> @@ -592,21 +594,19 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   	struct vhost_dev *dev = &v->vdev;
>   	struct vhost_iotlb *iotlb = dev->iotlb;
>   	struct page **page_list;
> -	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
> +	struct vm_area_struct **vmas;
>   	unsigned int gup_flags = FOLL_LONGTERM;
> -	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
> -	unsigned long locked, lock_limit, pinned, i;
> +	unsigned long map_pfn, last_pfn = 0;
> +	unsigned long npages, lock_limit;
> +	unsigned long i, nmap = 0;
>   	u64 iova = msg->iova;
> +	long pinned;
>   	int ret = 0;
>   
>   	if (vhost_iotlb_itree_first(iotlb, msg->iova,
>   				    msg->iova + msg->size - 1))
>   		return -EEXIST;
>   
> -	page_list = (struct page **) __get_free_page(GFP_KERNEL);
> -	if (!page_list)
> -		return -ENOMEM;
> -
>   	if (msg->perm & VHOST_ACCESS_WO)
>   		gup_flags |= FOLL_WRITE;
>   
> @@ -614,61 +614,86 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   	if (!npages)
>   		return -EINVAL;
>   
> +	page_list = kvmalloc_array(npages, sizeof(struct page *), GFP_KERNEL);
> +	vmas = kvmalloc_array(npages, sizeof(struct vm_area_struct *),
> +			      GFP_KERNEL);
> +	if (!page_list || !vmas) {
> +		ret = -ENOMEM;
> +		goto free;
> +	}
> +
>   	mmap_read_lock(dev->mm);
>   
> -	locked = atomic64_add_return(npages, &dev->mm->pinned_vm);
>   	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> -
> -	if (locked > lock_limit) {
> +	if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
>   		ret = -ENOMEM;
> -		goto out;
> +		goto unlock;
>   	}
>   
> -	cur_base = msg->uaddr & PAGE_MASK;
> -	iova &= PAGE_MASK;
> +	pinned = pin_user_pages(msg->uaddr & PAGE_MASK, npages, gup_flags,
> +				page_list, vmas);
> +	if (npages != pinned) {
> +		if (pinned < 0) {
> +			ret = pinned;
> +		} else {
> +			unpin_user_pages(page_list, pinned);
> +			ret = -ENOMEM;
> +		}
> +		goto unlock;
> +	}
>   
> -	while (npages) {
> -		pinned = min_t(unsigned long, npages, list_size);
> -		ret = pin_user_pages(cur_base, pinned,
> -				     gup_flags, page_list, NULL);
> -		if (ret != pinned)
> -			goto out;
> -
> -		if (!last_pfn)
> -			map_pfn = page_to_pfn(page_list[0]);
> -
> -		for (i = 0; i < ret; i++) {
> -			unsigned long this_pfn = page_to_pfn(page_list[i]);
> -			u64 csize;
> -
> -			if (last_pfn && (this_pfn != last_pfn + 1)) {
> -				/* Pin a contiguous chunk of memory */
> -				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
> -				if (vhost_vdpa_map(v, iova, csize,
> -						   map_pfn << PAGE_SHIFT,
> -						   msg->perm))
> -					goto out;
> -				map_pfn = this_pfn;
> -				iova += csize;
> +	iova &= PAGE_MASK;
> +	map_pfn = page_to_pfn(page_list[0]);
> +
> +	/* One more iteration to avoid extra vdpa_map() call out of loop. */
> +	for (i = 0; i <= npages; i++) {
> +		unsigned long this_pfn;
> +		u64 csize;
> +
> +		/* The last chunk may have no valid PFN next to it */
> +		this_pfn = i < npages ? page_to_pfn(page_list[i]) : -1UL;
> +
> +		if (last_pfn && (this_pfn == -1UL ||
> +				 this_pfn != last_pfn + 1)) {
> +			/* Pin a contiguous chunk of memory */
> +			csize = last_pfn - map_pfn + 1;
> +			ret = vhost_vdpa_map(v, iova, csize << PAGE_SHIFT,
> +					     map_pfn << PAGE_SHIFT,
> +					     msg->perm);
> +			if (ret) {
> +				/*
> +				 * Unpin the rest chunks of memory on the
> +				 * flight with no corresponding vdpa_map()
> +				 * calls having been made yet. On the other
> +				 * hand, vdpa_unmap() in the failure path
> +				 * is in charge of accounting the number of
> +				 * pinned pages for its own.
> +				 * This asymmetrical pattern of accounting
> +				 * is for efficiency to pin all pages at
> +				 * once, while there is no other callsite
> +				 * of vdpa_map() than here above.
> +				 */
> +				unpin_user_pages(&page_list[nmap],
> +						 npages - nmap);
> +				goto out;
>   			}
> -
> -			last_pfn = this_pfn;
> +			atomic64_add(csize, &dev->mm->pinned_vm);
> +			nmap += csize;
> +			iova += csize << PAGE_SHIFT;
> +			map_pfn = this_pfn;
>   		}
> -
> -		cur_base += ret << PAGE_SHIFT;
> -		npages -= ret;
> +		last_pfn = this_pfn;
>   	}
>   
> -	/* Pin the rest chunk */
> -	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
> -			     map_pfn << PAGE_SHIFT, msg->perm);
> +	WARN_ON(nmap != npages);
>   out:
> -	if (ret) {
> +	if (ret)
>   		vhost_vdpa_unmap(v, msg->iova, msg->size);
> -		atomic64_sub(npages, &dev->mm->pinned_vm);
> -	}
> +unlock:
>   	mmap_read_unlock(dev->mm);
> -	free_page((unsigned long)page_list);
> +free:
> +	kvfree(vmas);
> +	kvfree(page_list);
>   	return ret;
>   }


This looks like a rework, so I'd suggest to use use another patch for 
this part.

(I was on vacation, so the reply would be slow)

Thanks


>   

