Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB85357AC0
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 05:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhDHD0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 23:26:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40984 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229844AbhDHD02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 23:26:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617852377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gqqfJQKIdte55u7kG25HpIFh+raZcUjLo8p4M5prlro=;
        b=QxMSTgxRhWqUIInRgytFve11ls1/ZxEqoYZfFBBGPyB4azgzjNVUW1Xu29F9ukvvi/LM5e
        EQmqIDQwn+EWyNy6gGg76qBMi9KtmEhc7uMjJwF+zVQn/vVlip+Ov0sl+AqfRm+r8SxdYa
        40/LxWim+LKOkUsYT455UkJ9PRpDvQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-3pXw21HFO6KHRixokR3V1g-1; Wed, 07 Apr 2021 23:26:10 -0400
X-MC-Unique: 3pXw21HFO6KHRixokR3V1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E777B1006C83;
        Thu,  8 Apr 2021 03:26:07 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-194.pek2.redhat.com [10.72.12.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60B555CC3E;
        Thu,  8 Apr 2021 03:25:51 +0000 (UTC)
Subject: Re: [PATCH v6 08/10] vduse: Implement an MMU-based IOMMU driver
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-9-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <30862242-293b-f42f-d8ce-2c31a52e3697@redhat.com>
Date:   Thu, 8 Apr 2021 11:25:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210331080519.172-9-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/31 ÏÂÎç4:05, Xie Yongji Ð´µÀ:
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


Acked-by: Jason Wang <jasowang@redhat.com>

With some nits:


> ---
>   drivers/vdpa/vdpa_user/iova_domain.c | 521 +++++++++++++++++++++++++++++++++++
>   drivers/vdpa/vdpa_user/iova_domain.h |  70 +++++
>   2 files changed, 591 insertions(+)
>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h


[...]


> +static void vduse_domain_bounce(struct vduse_iova_domain *domain,
> +				dma_addr_t iova, size_t size,
> +				enum dma_data_direction dir)
> +{
> +	struct vduse_bounce_map *map;
> +	unsigned int offset;
> +	void *addr;
> +	size_t sz;
> +
> +	while (size) {
> +		map = &domain->bounce_maps[iova >> PAGE_SHIFT];
> +		offset = offset_in_page(iova);
> +		sz = min_t(size_t, PAGE_SIZE - offset, size);
> +
> +		if (WARN_ON(!map->bounce_page ||
> +			    map->orig_phys == INVALID_PHYS_ADDR))
> +			return;
> +
> +		addr = page_address(map->bounce_page) + offset;
> +		do_bounce(map->orig_phys + offset, addr, sz, dir);
> +		size -= sz;
> +		iova += sz;
> +	}
> +}
> +
> +static struct page *
> +vduse_domain_get_mapping_page(struct vduse_iova_domain *domain, u64 iova)


It's better to rename this as "vduse_domain_get_coherent_page?".


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


[...]


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


Let's add a comment as what has been done in dma-iommu.c?

(In the future, it looks to me it's better to move them to 
alloc_iova_fast()).

Thanks


