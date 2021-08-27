Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118C83F967F
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 10:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244705AbhH0Iyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 04:54:46 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3693 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbhH0Iyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 04:54:45 -0400
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gwtl94LbQz67LY3;
        Fri, 27 Aug 2021 16:52:37 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 27 Aug 2021 10:53:54 +0200
Received: from [10.47.92.37] (10.47.92.37) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Fri, 27 Aug
 2021 09:53:53 +0100
From:   John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v11 10/12] vduse: Implement an MMU-based software IOTLB
To:     Xie Yongji <xieyongji@bytedance.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>, <parav@nvidia.com>, <hch@infradead.org>,
        <christian.brauner@canonical.com>, <rdunlap@infradead.org>,
        <willy@infradead.org>, <viro@zeniv.linux.org.uk>,
        <axboe@kernel.dk>, <bcrl@kvack.org>, <corbet@lwn.net>,
        <mika.penttila@nextfour.com>, <dan.carpenter@oracle.com>,
        <joro@8bytes.org>, <gregkh@linuxfoundation.org>,
        <zhe.he@windriver.com>, <xiaodong.liu@intel.com>,
        <joe@perches.com>, <robin.murphy@arm.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <iommu@lists.linux-foundation.org>, <songmuchun@bytedance.com>,
        <linux-fsdevel@vger.kernel.org>
References: <20210818120642.165-1-xieyongji@bytedance.com>
 <20210818120642.165-11-xieyongji@bytedance.com>
Message-ID: <2d807de3-e245-c2fb-ae5d-7cacbe35dfcb@huawei.com>
Date:   Fri, 27 Aug 2021 09:57:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210818120642.165-11-xieyongji@bytedance.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.92.37]
X-ClientProxiedBy: lhreml706-chm.china.huawei.com (10.201.108.55) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/2021 13:06, Xie Yongji wrote:
> +
> +static dma_addr_t
> +vduse_domain_alloc_iova(struct iova_domain *iovad,
> +			unsigned long size, unsigned long limit)
> +{
> +	unsigned long shift = iova_shift(iovad);
> +	unsigned long iova_len = iova_align(iovad, size) >> shift;
> +	unsigned long iova_pfn;
> +
> +	/*
> +	 * Freeing non-power-of-two-sized allocations back into the IOVA caches
> +	 * will come back to bite us badly, so we have to waste a bit of space
> +	 * rounding up anything cacheable to make sure that can't happen. The
> +	 * order of the unadjusted size will still match upon freeing.
> +	 */
> +	if (iova_len < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
> +		iova_len = roundup_pow_of_two(iova_len);

Whether it's proper to use this "fast" API or not here, this seems to be 
copied verbatim from dma-iommu.c, which tells me that something should 
be factored out.

Indeed, this rounding up seems a requirement of the rcache, so not sure 
why this is not done there.

> +	iova_pfn = alloc_iova_fast(iovad, iova_len, limit >> shift, true);


