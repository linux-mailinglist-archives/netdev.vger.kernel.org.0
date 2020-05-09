Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2081CBBDF
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 02:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgEIAii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 20:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbgEIAif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 20:38:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AF3620746;
        Sat,  9 May 2020 00:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588984715;
        bh=JYE9+M/aG072dPIHuxuvk9POKsJEMF02ttHiR9oDgzk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RtNYOnnITyiJrt+lymaFD888fAMBHMisLLXzR8M3Df5vC/vxfTCPQ1h1GFi9TZfOk
         AzdQQgBrWMqdWP18lLH5o11gmgnFb10JQK5qjcsLu6bmuAEIsAR7TqvxCMGNmYzdUU
         6vIbkVsVO5FpGhXS13jTjlTEyOb3jpj6QuZJkLBk=
Date:   Fri, 8 May 2020 17:38:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     netdev@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>, davem@davemloft.net,
        Sunil Kovvuri <sunil.kovvuri@gmail.com>
Subject: Re: [PATCH v2] octeontx2-pf: Use the napi_alloc_frag() to alloc the
 pool buffers
Message-ID: <20200508173833.0f48cccc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508114953.2753-1-haokexin@gmail.com>
References: <20200508114953.2753-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 May 2020 19:49:53 +0800 Kevin Hao wrote:
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index f1d2dea90a8c..612d33207326 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -379,40 +379,33 @@ void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
>  		     (pfvf->hw.cq_ecount_wait - 1));
>  }
>  
> -dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
> -			   gfp_t gfp)
> +dma_addr_t _otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)

If you need to respin please use double underscore as a prefix, it's
a far more common style in the kernel.

>  {
>  	dma_addr_t iova;
> +	u8 *buf;
>  
> -	/* Check if request can be accommodated in previous allocated page */
> -	if (pool->page && ((pool->page_offset + pool->rbsize) <=
> -	    (PAGE_SIZE << pool->rbpage_order))) {
> -		pool->pageref++;
> -		goto ret;
> -	}
> -
> -	otx2_get_page(pool);
> -
> -	/* Allocate a new page */
> -	pool->page = alloc_pages(gfp | __GFP_COMP | __GFP_NOWARN,
> -				 pool->rbpage_order);
> -	if (unlikely(!pool->page))
> +	buf = napi_alloc_frag(pool->rbsize);
> +	if (unlikely(!buf))
>  		return -ENOMEM;
>  
> -	pool->page_offset = 0;
> -ret:
> -	iova = (u64)otx2_dma_map_page(pfvf, pool->page, pool->page_offset,
> -				      pool->rbsize, DMA_FROM_DEVICE);
> -	if (!iova) {
> -		if (!pool->page_offset)
> -			__free_pages(pool->page, pool->rbpage_order);
> -		pool->page = NULL;
> +	iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
> +				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
> +	if (unlikely(dma_mapping_error(pfvf->dev, iova)))

Thanks for doing this, but aren't you leaking the buf on DMA mapping
error?

>  		return -ENOMEM;
> -	}
> -	pool->page_offset += pool->rbsize;
> +
>  	return iova;
>  }
