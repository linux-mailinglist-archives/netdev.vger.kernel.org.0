Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7187093E
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfGVTFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:05:44 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1537 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfGVTFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:05:43 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3609060000>; Mon, 22 Jul 2019 12:05:42 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 22 Jul 2019 12:05:41 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 22 Jul 2019 12:05:41 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 22 Jul
 2019 19:05:41 +0000
Subject: Re: [PATCH 3/3] gup: new put_user_page_dirty*() helpers
To:     <john.hubbard@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ilya Dryomov <idryomov@gmail.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ming Lei <ming.lei@redhat.com>, Sage Weil <sage@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Yan Zheng <zyan@redhat.com>, <netdev@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-mm@kvack.org>,
        <linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190722043012.22945-1-jhubbard@nvidia.com>
 <20190722043012.22945-4-jhubbard@nvidia.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <3a294582-9c60-b70c-8389-68c5d3326765@nvidia.com>
Date:   Mon, 22 Jul 2019 12:05:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190722043012.22945-4-jhubbard@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563822342; bh=8K12rdfwIMLeACivZ31dz3qePpqi9G1AM6eI//iYEN8=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Qy0etjiupH0o/2VLEf2Kfw/6ThF3QIOwnl/C/rvCFndMqXXmTJum25AxDmXBD9fx0
         +lec8POS98AIoHo7ixvgZ3iz684XA4lS1yZHPSINz9aZy0LmoLhaZPsSSFU5/Bo03T
         52w9cXBaViCVqsTggF6GWpW0Oah+V7bMe4hi03+YNd2MQZn5Lsu0QELVxORLPDbDhK
         rF6Wkh2eu1qSHQDfDMZEY9MYZ4nx59fTNJ9YnYLTvixS/iWf/D9hx5YrGY30jFkb1V
         lkJLRCre9OmDJ3XF6bKkUZ7HtN33TM2Oviu2bFiwB2p3PM/eluQleNA55IB3j7XWpo
         T97GFPuEvUYQA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/19 9:30 PM, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> While converting call sites to use put_user_page*() [1], quite a few
> places ended up needing a single-page routine to put and dirty a
> page.
> 
> Provide put_user_page_dirty() and put_user_page_dirty_lock(),
> and use them in a few places: net/xdp, drm/via/, drivers/infiniband.
> 

Please disregard this one, I'm going to drop it, as per the
discussion in patch 1.

thanks,
-- 
John Hubbard
NVIDIA

> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  drivers/gpu/drm/via/via_dmablit.c        |  2 +-
>  drivers/infiniband/core/umem.c           |  2 +-
>  drivers/infiniband/hw/usnic/usnic_uiom.c |  2 +-
>  include/linux/mm.h                       | 10 ++++++++++
>  net/xdp/xdp_umem.c                       |  2 +-
>  5 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_dmablit.c
> index 219827ae114f..d30b2d75599f 100644
> --- a/drivers/gpu/drm/via/via_dmablit.c
> +++ b/drivers/gpu/drm/via/via_dmablit.c
> @@ -189,7 +189,7 @@ via_free_sg_info(struct pci_dev *pdev, drm_via_sg_info_t *vsg)
>  		for (i = 0; i < vsg->num_pages; ++i) {
>  			if (NULL != (page = vsg->pages[i])) {
>  				if (!PageReserved(page) && (DMA_FROM_DEVICE == vsg->direction))
> -					put_user_pages_dirty(&page, 1);
> +					put_user_page_dirty(page);
>  				else
>  					put_user_page(page);
>  			}
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index 08da840ed7ee..a7337cc3ca20 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -55,7 +55,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
>  	for_each_sg_page(umem->sg_head.sgl, &sg_iter, umem->sg_nents, 0) {
>  		page = sg_page_iter_page(&sg_iter);
>  		if (umem->writable && dirty)
> -			put_user_pages_dirty_lock(&page, 1);
> +			put_user_page_dirty_lock(page);
>  		else
>  			put_user_page(page);
>  	}
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
> index 0b0237d41613..d2ded624fb2a 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> @@ -76,7 +76,7 @@ static void usnic_uiom_put_pages(struct list_head *chunk_list, int dirty)
>  			page = sg_page(sg);
>  			pa = sg_phys(sg);
>  			if (dirty)
> -				put_user_pages_dirty_lock(&page, 1);
> +				put_user_page_dirty_lock(page);
>  			else
>  				put_user_page(page);
>  			usnic_dbg("pa: %pa\n", &pa);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0334ca97c584..c0584c6d9d78 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1061,6 +1061,16 @@ void put_user_pages_dirty(struct page **pages, unsigned long npages);
>  void put_user_pages_dirty_lock(struct page **pages, unsigned long npages);
>  void put_user_pages(struct page **pages, unsigned long npages);
>  
> +static inline void put_user_page_dirty(struct page *page)
> +{
> +	put_user_pages_dirty(&page, 1);
> +}
> +
> +static inline void put_user_page_dirty_lock(struct page *page)
> +{
> +	put_user_pages_dirty_lock(&page, 1);
> +}
> +
>  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>  #define SECTION_IN_PAGE_FLAGS
>  #endif
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 9cbbb96c2a32..1d122e52c6de 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -171,7 +171,7 @@ static void xdp_umem_unpin_pages(struct xdp_umem *umem)
>  	for (i = 0; i < umem->npgs; i++) {
>  		struct page *page = umem->pgs[i];
>  
> -		put_user_pages_dirty_lock(&page, 1);
> +		put_user_page_dirty_lock(page);
>  	}
>  
>  	kfree(umem->pgs);
> 
