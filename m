Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C7E289DAB
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 04:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbgJJCrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 22:47:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730373AbgJJC15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 22:27:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602296873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=12HYuK0Nk24tj0+2XOPv/OD1JosPiyVfbvcjChBbyBo=;
        b=HWbb6HMKe5nGwcvrgp8qhXITk4jZ2UwpJDLAf6sldjYgKDPA768+v1nV6kLhmbx2dvCFcA
        mRA9463XPjxQet8kvQ7OqnpiB6tpfTUiK5lmC3WLw5XbmvDtCvERRdQ3eito65RIwVaYV8
        TJIjwCtJNaTk2hYAnalvCk1M9on/OTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-o5FaSILcPOSSXt_gosPSqQ-1; Fri, 09 Oct 2020 22:27:51 -0400
X-MC-Unique: o5FaSILcPOSSXt_gosPSqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 779BA805F05;
        Sat, 10 Oct 2020 02:27:49 +0000 (UTC)
Received: from [10.72.13.27] (ovpn-13-27.pek2.redhat.com [10.72.13.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFA5319728;
        Sat, 10 Oct 2020 02:27:40 +0000 (UTC)
Subject: Re: [PATCH v3 2/2] vhost-vdpa: fix page pinning leakage in error path
To:     Si-Wei Liu <si-wei.liu@oracle.com>, mst@redhat.com,
        lingshan.zhu@intel.com
Cc:     joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com>
 <1601701330-16837-3-git-send-email-si-wei.liu@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <574a64e3-8873-0639-fe32-248cb99204bc@redhat.com>
Date:   Sat, 10 Oct 2020 10:27:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1601701330-16837-3-git-send-email-si-wei.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/3 下午1:02, Si-Wei Liu wrote:
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
> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> ---
> Changes in v3:
> - Factor out vhost_vdpa_map() change to a separate patch
>
> Changes in v2:
> - Fix incorrect target SHA1 referenced
>
>   drivers/vhost/vdpa.c | 119 ++++++++++++++++++++++++++++++---------------------
>   1 file changed, 71 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 0f27919..dad41dae 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -595,21 +595,19 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
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
> @@ -617,61 +615,86 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   	if (!npages)
>   		return -EINVAL;
>   
> +	page_list = kvmalloc_array(npages, sizeof(struct page *), GFP_KERNEL);
> +	vmas = kvmalloc_array(npages, sizeof(struct vm_area_struct *),
> +			      GFP_KERNEL);


This will result high order memory allocation which was what the code 
tried to avoid originally.

Using an unlimited size will cause a lot of side effects consider VM or 
userspace may try to pin several TB of memory.


> +	if (!page_list || !vmas) {
> +		ret = -ENOMEM;
> +		goto free;
> +	}


Any reason that you want to use vmas?


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


So what I suggest is to fix the pinning leakage first and do the 
possible optimization on top (which is still questionable to me).

Thanks


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
>   

