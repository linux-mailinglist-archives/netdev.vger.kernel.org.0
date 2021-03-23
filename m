Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAEC3455F5
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 04:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhCWDK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 23:10:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229494AbhCWDJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 23:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616468989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dK8t4LNmU+Ag0hLnSBmusXqV+wwlg2B/cGi7B01CKSg=;
        b=ajRipIbnpsLxkgESdqoB1dmJzXki5bb1V1tBzc3VbVGwBcvYobX1BD6KMEhS5YlsReGwI7
        lBuPyOoIwZ9tAg1UCop4VYX40VoR2vPd2hY3Daxq60rhJSeApgizd15Zw1lUFJn13btKMi
        ziZp2SuYx+zY6/SgV6IgRXd6Hry0JDs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-Isdm_G_dMz-H0cIhUFbcMw-1; Mon, 22 Mar 2021 23:09:46 -0400
X-MC-Unique: Isdm_G_dMz-H0cIhUFbcMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D46E619251D4;
        Tue, 23 Mar 2021 03:09:36 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-238.pek2.redhat.com [10.72.12.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B92610023B0;
        Tue, 23 Mar 2021 03:09:22 +0000 (UTC)
Subject: Re: [PATCH v5 06/11] vdpa: factor out vhost_vdpa_pa_map()
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210315053721.189-1-xieyongji@bytedance.com>
 <20210315053721.189-7-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <45a307b5-85a4-0cbc-0bbc-7e8edbbac9ca@redhat.com>
Date:   Tue, 23 Mar 2021 11:09:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315053721.189-7-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/15 ÏÂÎç1:37, Xie Yongji Ð´µÀ:
> The upcoming patch is going to support VA mapping. So let's
> factor out the logic of PA mapping firstly to make the code
> more readable.
>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


Acked-by: Jason Wang <jasowang@redhat.com>

While at it, I think it's better to factor out the unmap() part? Since 
the unpin and page dirty is not needed for va device.

Thanks


> ---
>   drivers/vhost/vdpa.c | 46 ++++++++++++++++++++++++++++------------------
>   1 file changed, 28 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index b24ec69a374b..7c83fbf3edac 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -579,37 +579,28 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
>   	}
>   }
>   
> -static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
> -					   struct vhost_iotlb_msg *msg)
> +static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
> +			     u64 iova, u64 size, u64 uaddr, u32 perm)
>   {
>   	struct vhost_dev *dev = &v->vdev;
> -	struct vhost_iotlb *iotlb = dev->iotlb;
>   	struct page **page_list;
>   	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
>   	unsigned int gup_flags = FOLL_LONGTERM;
>   	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
>   	unsigned long lock_limit, sz2pin, nchunks, i;
> -	u64 iova = msg->iova;
> +	u64 start = iova;
>   	long pinned;
>   	int ret = 0;
>   
> -	if (msg->iova < v->range.first ||
> -	    msg->iova + msg->size - 1 > v->range.last)
> -		return -EINVAL;
> -
> -	if (vhost_iotlb_itree_first(iotlb, msg->iova,
> -				    msg->iova + msg->size - 1))
> -		return -EEXIST;
> -
>   	/* Limit the use of memory for bookkeeping */
>   	page_list = (struct page **) __get_free_page(GFP_KERNEL);
>   	if (!page_list)
>   		return -ENOMEM;
>   
> -	if (msg->perm & VHOST_ACCESS_WO)
> +	if (perm & VHOST_ACCESS_WO)
>   		gup_flags |= FOLL_WRITE;
>   
> -	npages = PAGE_ALIGN(msg->size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
> +	npages = PAGE_ALIGN(size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
>   	if (!npages) {
>   		ret = -EINVAL;
>   		goto free;
> @@ -623,7 +614,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   		goto unlock;
>   	}
>   
> -	cur_base = msg->uaddr & PAGE_MASK;
> +	cur_base = uaddr & PAGE_MASK;
>   	iova &= PAGE_MASK;
>   	nchunks = 0;
>   
> @@ -654,7 +645,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
>   				ret = vhost_vdpa_map(v, iova, csize,
>   						     map_pfn << PAGE_SHIFT,
> -						     msg->perm);
> +						     perm);
>   				if (ret) {
>   					/*
>   					 * Unpin the pages that are left unmapped
> @@ -683,7 +674,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   
>   	/* Pin the rest chunk */
>   	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
> -			     map_pfn << PAGE_SHIFT, msg->perm);
> +			     map_pfn << PAGE_SHIFT, perm);
>   out:
>   	if (ret) {
>   		if (nchunks) {
> @@ -702,13 +693,32 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   			for (pfn = map_pfn; pfn <= last_pfn; pfn++)
>   				unpin_user_page(pfn_to_page(pfn));
>   		}
> -		vhost_vdpa_unmap(v, msg->iova, msg->size);
> +		vhost_vdpa_unmap(v, start, size);
>   	}
>   unlock:
>   	mmap_read_unlock(dev->mm);
>   free:
>   	free_page((unsigned long)page_list);
>   	return ret;
> +
> +}
> +
> +static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
> +					   struct vhost_iotlb_msg *msg)
> +{
> +	struct vhost_dev *dev = &v->vdev;
> +	struct vhost_iotlb *iotlb = dev->iotlb;
> +
> +	if (msg->iova < v->range.first ||
> +	    msg->iova + msg->size - 1 > v->range.last)
> +		return -EINVAL;
> +
> +	if (vhost_iotlb_itree_first(iotlb, msg->iova,
> +				    msg->iova + msg->size - 1))
> +		return -EEXIST;
> +
> +	return vhost_vdpa_pa_map(v, msg->iova, msg->size, msg->uaddr,
> +				 msg->perm);
>   }
>   
>   static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,

