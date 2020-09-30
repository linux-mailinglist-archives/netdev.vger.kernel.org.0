Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB7A27E79D
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 13:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbgI3L0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 07:26:35 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6628 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgI3L0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 07:26:34 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f746b370001>; Wed, 30 Sep 2020 04:25:43 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Sep
 2020 11:26:13 +0000
Date:   Wed, 30 Sep 2020 14:26:09 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rob.miller@broadcom.com>, <lingshan.zhu@intel.com>,
        <eperezma@redhat.com>, <hanand@xilinx.com>,
        <mhabets@solarflare.com>, <eli@mellanox.com>,
        <amorenoz@redhat.com>, <maxime.coquelin@redhat.com>,
        <stefanha@redhat.com>, <sgarzare@redhat.com>
Subject: Re: [RFC PATCH 05/24] vhost-vdpa: passing iotlb to IOMMU mapping
 helpers
Message-ID: <20200930112609.GA223360@mtl-vdi-166.wap.labs.mlnx>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-6-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200924032125.18619-6-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601465143; bh=u57iORwVvbadjjyoszxFFavgb47TLdIvXVYH0Cqdc+g=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=i4tKtThQimyZ7JSMvWCUBSmEHDw2aBUIDvMxnN4HDSMcw2xveDTMwDTfEuKkIhfx8
         m5mzX9G5vxpjoZwjjc55uX3PRK3bhpJ099uKxSn23cOQTlKaAycAFGRHp3LTZY/sJM
         ZQGhXpQAVF+04cXZLE0nyl3HAc22+0/4OJVj31YPbt7MShwoY27WQsfdfKWYuw1D+k
         ox1xmCWTJ4ldq7jUukJ6JVhABYvRk6C6ItNSEr4qMnJwMsHYwiMrV0a75FR4Yuy/V7
         VTpXSKu2Q5xA19u3gNzKmWHcjn/2Ffcmsd4V/PPAD1yeqkijuqCVAsO9eezlrTtGT/
         1K4PEizEOlr+Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 11:21:06AM +0800, Jason Wang wrote:
> To prepare for the ASID support for vhost-vdpa, try to pass IOTLB
> object to dma helpers.

Maybe it's worth mentioning here that this patch does not change any
functionality and is presented as a preparation for passing different
iotlb's instead of using dev->iotlb

> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 40 ++++++++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 9c641274b9f3..74bef1c15a70 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -489,10 +489,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  	return r;
>  }
>  
> -static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
> +static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
> +				   struct vhost_iotlb *iotlb,
> +				   u64 start, u64 last)
>  {
>  	struct vhost_dev *dev = &v->vdev;
> -	struct vhost_iotlb *iotlb = dev->iotlb;
>  	struct vhost_iotlb_map *map;
>  	struct page *page;
>  	unsigned long pfn, pinned;
> @@ -514,8 +515,9 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>  static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
>  {
>  	struct vhost_dev *dev = &v->vdev;
> +	struct vhost_iotlb *iotlb = dev->iotlb;
>  
> -	vhost_vdpa_iotlb_unmap(v, 0ULL, 0ULL - 1);
> +	vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
>  	kfree(dev->iotlb);
>  	dev->iotlb = NULL;
>  }
> @@ -542,15 +544,14 @@ static int perm_to_iommu_flags(u32 perm)
>  	return flags | IOMMU_CACHE;
>  }
>  
> -static int vhost_vdpa_map(struct vhost_vdpa *v,
> +static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>  			  u64 iova, u64 size, u64 pa, u32 perm)
>  {
> -	struct vhost_dev *dev = &v->vdev;
>  	struct vdpa_device *vdpa = v->vdpa;
>  	const struct vdpa_config_ops *ops = vdpa->config;
>  	int r = 0;
>  
> -	r = vhost_iotlb_add_range(dev->iotlb, iova, iova + size - 1,
> +	r = vhost_iotlb_add_range(iotlb, iova, iova + size - 1,
>  				  pa, perm);
>  	if (r)
>  		return r;
> @@ -559,7 +560,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
>  		r = ops->dma_map(vdpa, iova, size, pa, perm);
>  	} else if (ops->set_map) {
>  		if (!v->in_batch)
> -			r = ops->set_map(vdpa, dev->iotlb);
> +			r = ops->set_map(vdpa, iotlb);
>  	} else {
>  		r = iommu_map(v->domain, iova, pa, size,
>  			      perm_to_iommu_flags(perm));
> @@ -568,29 +569,30 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
>  	return r;
>  }
>  
> -static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
> +static void vhost_vdpa_unmap(struct vhost_vdpa *v,
> +			     struct vhost_iotlb *iotlb,
> +			     u64 iova, u64 size)
>  {
> -	struct vhost_dev *dev = &v->vdev;
>  	struct vdpa_device *vdpa = v->vdpa;
>  	const struct vdpa_config_ops *ops = vdpa->config;
>  
> -	vhost_vdpa_iotlb_unmap(v, iova, iova + size - 1);
> +	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
>  
>  	if (ops->dma_map) {
>  		ops->dma_unmap(vdpa, iova, size);
>  	} else if (ops->set_map) {
>  		if (!v->in_batch)
> -			ops->set_map(vdpa, dev->iotlb);
> +			ops->set_map(vdpa, iotlb);
>  	} else {
>  		iommu_unmap(v->domain, iova, size);
>  	}
>  }
>  
>  static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
> +					   struct vhost_iotlb *iotlb,
>  					   struct vhost_iotlb_msg *msg)
>  {
>  	struct vhost_dev *dev = &v->vdev;
> -	struct vhost_iotlb *iotlb = dev->iotlb;
>  	struct page **page_list;
>  	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
>  	unsigned int gup_flags = FOLL_LONGTERM;
> @@ -644,7 +646,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>  			if (last_pfn && (this_pfn != last_pfn + 1)) {
>  				/* Pin a contiguous chunk of memory */
>  				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
> -				if (vhost_vdpa_map(v, iova, csize,
> +				if (vhost_vdpa_map(v, iotlb, iova, csize,
>  						   map_pfn << PAGE_SHIFT,
>  						   msg->perm))
>  					goto out;
> @@ -660,11 +662,12 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>  	}
>  
>  	/* Pin the rest chunk */
> -	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
> +	ret = vhost_vdpa_map(v, iotlb, iova,
> +			     (last_pfn - map_pfn + 1) << PAGE_SHIFT,
>  			     map_pfn << PAGE_SHIFT, msg->perm);
>  out:
>  	if (ret) {
> -		vhost_vdpa_unmap(v, msg->iova, msg->size);
> +		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
>  		atomic64_sub(npages, &dev->mm->pinned_vm);
>  	}
>  	mmap_read_unlock(dev->mm);
> @@ -678,6 +681,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>  	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
>  	struct vdpa_device *vdpa = v->vdpa;
>  	const struct vdpa_config_ops *ops = vdpa->config;
> +	struct vhost_iotlb *iotlb = dev->iotlb;
>  	int r = 0;
>  
>  	r = vhost_dev_check_owner(dev);
> @@ -686,17 +690,17 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>  
>  	switch (msg->type) {
>  	case VHOST_IOTLB_UPDATE:
> -		r = vhost_vdpa_process_iotlb_update(v, msg);
> +		r = vhost_vdpa_process_iotlb_update(v, iotlb, msg);
>  		break;
>  	case VHOST_IOTLB_INVALIDATE:
> -		vhost_vdpa_unmap(v, msg->iova, msg->size);
> +		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
>  		break;
>  	case VHOST_IOTLB_BATCH_BEGIN:
>  		v->in_batch = true;
>  		break;
>  	case VHOST_IOTLB_BATCH_END:
>  		if (v->in_batch && ops->set_map)
> -			ops->set_map(vdpa, dev->iotlb);
> +			ops->set_map(vdpa, iotlb);
>  		v->in_batch = false;
>  		break;
>  	default:
> -- 
> 2.20.1
> 
