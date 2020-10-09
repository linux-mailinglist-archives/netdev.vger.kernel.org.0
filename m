Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B864528802D
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 04:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbgJICBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 22:01:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729347AbgJICB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 22:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602208887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3s9R39Og5RHDHefHI3q9yhoEDWORC7I7mmgIVvKh3e0=;
        b=c4ouKCzkZ9qDQ+wRvdXUiYKyXyCd589llLsWmQ9rf7MwhKkOOrU6/K+16/CnaWOLE49LtM
        hi4YTCbE+ErzMi6KlP/lYkcKR2ImcC6eXq8C9L5fTmVhiLrjqeLLOlyVuSD7T7rtxu97rd
        lOmZjE54uDh1tKzxZGdtkrPETI+jl50=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-q4BrAy5gNG227A1gPlmfPA-1; Thu, 08 Oct 2020 22:01:23 -0400
X-MC-Unique: q4BrAy5gNG227A1gPlmfPA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F286B427C2;
        Fri,  9 Oct 2020 02:01:21 +0000 (UTC)
Received: from [10.72.13.133] (ovpn-13-133.pek2.redhat.com [10.72.13.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BC3B5D9E8;
        Fri,  9 Oct 2020 02:01:07 +0000 (UTC)
Subject: Re: [RFC PATCH 05/24] vhost-vdpa: passing iotlb to IOMMU mapping
 helpers
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-6-jasowang@redhat.com>
 <20200930112609.GA223360@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5f083453-d070-d8a8-1f75-5de1c299cd0b@redhat.com>
Date:   Fri, 9 Oct 2020 10:01:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200930112609.GA223360@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/30 下午7:26, Eli Cohen wrote:
> On Thu, Sep 24, 2020 at 11:21:06AM +0800, Jason Wang wrote:
>> To prepare for the ASID support for vhost-vdpa, try to pass IOTLB
>> object to dma helpers.
> Maybe it's worth mentioning here that this patch does not change any
> functionality and is presented as a preparation for passing different
> iotlb's instead of using dev->iotlb


Right, let me add them in the next version.

Thanks


>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vhost/vdpa.c | 40 ++++++++++++++++++++++------------------
>>   1 file changed, 22 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index 9c641274b9f3..74bef1c15a70 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -489,10 +489,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>>   	return r;
>>   }
>>   
>> -static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>> +static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
>> +				   struct vhost_iotlb *iotlb,
>> +				   u64 start, u64 last)
>>   {
>>   	struct vhost_dev *dev = &v->vdev;
>> -	struct vhost_iotlb *iotlb = dev->iotlb;
>>   	struct vhost_iotlb_map *map;
>>   	struct page *page;
>>   	unsigned long pfn, pinned;
>> @@ -514,8 +515,9 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>>   static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
>>   {
>>   	struct vhost_dev *dev = &v->vdev;
>> +	struct vhost_iotlb *iotlb = dev->iotlb;
>>   
>> -	vhost_vdpa_iotlb_unmap(v, 0ULL, 0ULL - 1);
>> +	vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
>>   	kfree(dev->iotlb);
>>   	dev->iotlb = NULL;
>>   }
>> @@ -542,15 +544,14 @@ static int perm_to_iommu_flags(u32 perm)
>>   	return flags | IOMMU_CACHE;
>>   }
>>   
>> -static int vhost_vdpa_map(struct vhost_vdpa *v,
>> +static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>>   			  u64 iova, u64 size, u64 pa, u32 perm)
>>   {
>> -	struct vhost_dev *dev = &v->vdev;
>>   	struct vdpa_device *vdpa = v->vdpa;
>>   	const struct vdpa_config_ops *ops = vdpa->config;
>>   	int r = 0;
>>   
>> -	r = vhost_iotlb_add_range(dev->iotlb, iova, iova + size - 1,
>> +	r = vhost_iotlb_add_range(iotlb, iova, iova + size - 1,
>>   				  pa, perm);
>>   	if (r)
>>   		return r;
>> @@ -559,7 +560,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
>>   		r = ops->dma_map(vdpa, iova, size, pa, perm);
>>   	} else if (ops->set_map) {
>>   		if (!v->in_batch)
>> -			r = ops->set_map(vdpa, dev->iotlb);
>> +			r = ops->set_map(vdpa, iotlb);
>>   	} else {
>>   		r = iommu_map(v->domain, iova, pa, size,
>>   			      perm_to_iommu_flags(perm));
>> @@ -568,29 +569,30 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
>>   	return r;
>>   }
>>   
>> -static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
>> +static void vhost_vdpa_unmap(struct vhost_vdpa *v,
>> +			     struct vhost_iotlb *iotlb,
>> +			     u64 iova, u64 size)
>>   {
>> -	struct vhost_dev *dev = &v->vdev;
>>   	struct vdpa_device *vdpa = v->vdpa;
>>   	const struct vdpa_config_ops *ops = vdpa->config;
>>   
>> -	vhost_vdpa_iotlb_unmap(v, iova, iova + size - 1);
>> +	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
>>   
>>   	if (ops->dma_map) {
>>   		ops->dma_unmap(vdpa, iova, size);
>>   	} else if (ops->set_map) {
>>   		if (!v->in_batch)
>> -			ops->set_map(vdpa, dev->iotlb);
>> +			ops->set_map(vdpa, iotlb);
>>   	} else {
>>   		iommu_unmap(v->domain, iova, size);
>>   	}
>>   }
>>   
>>   static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>> +					   struct vhost_iotlb *iotlb,
>>   					   struct vhost_iotlb_msg *msg)
>>   {
>>   	struct vhost_dev *dev = &v->vdev;
>> -	struct vhost_iotlb *iotlb = dev->iotlb;
>>   	struct page **page_list;
>>   	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
>>   	unsigned int gup_flags = FOLL_LONGTERM;
>> @@ -644,7 +646,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>>   			if (last_pfn && (this_pfn != last_pfn + 1)) {
>>   				/* Pin a contiguous chunk of memory */
>>   				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
>> -				if (vhost_vdpa_map(v, iova, csize,
>> +				if (vhost_vdpa_map(v, iotlb, iova, csize,
>>   						   map_pfn << PAGE_SHIFT,
>>   						   msg->perm))
>>   					goto out;
>> @@ -660,11 +662,12 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>>   	}
>>   
>>   	/* Pin the rest chunk */
>> -	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
>> +	ret = vhost_vdpa_map(v, iotlb, iova,
>> +			     (last_pfn - map_pfn + 1) << PAGE_SHIFT,
>>   			     map_pfn << PAGE_SHIFT, msg->perm);
>>   out:
>>   	if (ret) {
>> -		vhost_vdpa_unmap(v, msg->iova, msg->size);
>> +		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
>>   		atomic64_sub(npages, &dev->mm->pinned_vm);
>>   	}
>>   	mmap_read_unlock(dev->mm);
>> @@ -678,6 +681,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>>   	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
>>   	struct vdpa_device *vdpa = v->vdpa;
>>   	const struct vdpa_config_ops *ops = vdpa->config;
>> +	struct vhost_iotlb *iotlb = dev->iotlb;
>>   	int r = 0;
>>   
>>   	r = vhost_dev_check_owner(dev);
>> @@ -686,17 +690,17 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>>   
>>   	switch (msg->type) {
>>   	case VHOST_IOTLB_UPDATE:
>> -		r = vhost_vdpa_process_iotlb_update(v, msg);
>> +		r = vhost_vdpa_process_iotlb_update(v, iotlb, msg);
>>   		break;
>>   	case VHOST_IOTLB_INVALIDATE:
>> -		vhost_vdpa_unmap(v, msg->iova, msg->size);
>> +		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
>>   		break;
>>   	case VHOST_IOTLB_BATCH_BEGIN:
>>   		v->in_batch = true;
>>   		break;
>>   	case VHOST_IOTLB_BATCH_END:
>>   		if (v->in_batch && ops->set_map)
>> -			ops->set_map(vdpa, dev->iotlb);
>> +			ops->set_map(vdpa, iotlb);
>>   		v->in_batch = false;
>>   		break;
>>   	default:
>> -- 
>> 2.20.1
>>

