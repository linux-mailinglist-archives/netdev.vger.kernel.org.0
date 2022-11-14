Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5127F627727
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbiKNIL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbiKNIL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:11:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17373193E2;
        Mon, 14 Nov 2022 00:11:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A69D260EED;
        Mon, 14 Nov 2022 08:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3893EC433D6;
        Mon, 14 Nov 2022 08:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668413515;
        bh=mpJwu8UPciVMvP4x1nO/f/d0FY4YaLljifKODSIp6Fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k33TWUYSnJeJJSqCSK3BK1qBtMxZcviktUaz1E62W4dNSUSNiuH0BnICAe2VnJwkr
         FNOrwgfUUfn04YPTZWuG2Brc2/2Kv9vEvb3/8v3JhkATlyBzq5V1Cc+d+mkM/n9Ht8
         sOXZo0nRCudqaHPxM6nNkk7jH8o8G8rRRQsQHgdP/ddk9Oh5tzG0si68G350HklqNg
         +F7Wb7tc9+mxb9JvX3yUo2LE/EVvs/p8wwXi59+xXFK7uSkHLvop1nTf694uRV5u1k
         at3vjj2xvE66J8AllakgkYKHls7+q1XFybccu4tkkwy3fA1YW4dwgpv14lYCJLk9YI
         oyu8ssz65EQug==
Date:   Mon, 14 Nov 2022 10:11:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 7/7] dma-mapping: reject __GFP_COMP in dma_alloc_attrs
Message-ID: <Y3H4RobK/pmDd3xG@unreal>
References: <20221113163535.884299-1-hch@lst.de>
 <20221113163535.884299-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113163535.884299-8-hch@lst.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 05:35:35PM +0100, Christoph Hellwig wrote:
> DMA allocations can never be turned back into a page pointer, so
> requesting compound pages doesn't make sense and it can't even be
> supported at all by various backends.
> 
> Reject __GFP_COMP with a warning in dma_alloc_attrs, and stop clearing
> the flag in the arm dma ops and dma-iommu.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/arm/mm/dma-mapping.c | 17 -----------------
>  drivers/iommu/dma-iommu.c |  3 ---
>  kernel/dma/mapping.c      |  8 ++++++++
>  3 files changed, 8 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index d7909091cf977..c135f6e37a00c 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -564,14 +564,6 @@ static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
>  	if (mask < 0xffffffffULL)
>  		gfp |= GFP_DMA;
>  
> -	/*
> -	 * Following is a work-around (a.k.a. hack) to prevent pages
> -	 * with __GFP_COMP being passed to split_page() which cannot
> -	 * handle them.  The real problem is that this flag probably
> -	 * should be 0 on ARM as it is not supported on this
> -	 * platform; see CONFIG_HUGETLBFS.
> -	 */
> -	gfp &= ~(__GFP_COMP);
>  	args.gfp = gfp;
>  
>  	*handle = DMA_MAPPING_ERROR;
> @@ -1093,15 +1085,6 @@ static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
>  		return __iommu_alloc_simple(dev, size, gfp, handle,
>  					    coherent_flag, attrs);
>  
> -	/*
> -	 * Following is a work-around (a.k.a. hack) to prevent pages
> -	 * with __GFP_COMP being passed to split_page() which cannot
> -	 * handle them.  The real problem is that this flag probably
> -	 * should be 0 on ARM as it is not supported on this
> -	 * platform; see CONFIG_HUGETLBFS.
> -	 */
> -	gfp &= ~(__GFP_COMP);
> -
>  	pages = __iommu_alloc_buffer(dev, size, gfp, attrs, coherent_flag);
>  	if (!pages)
>  		return NULL;
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 9297b741f5e80..f798c44e09033 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -744,9 +744,6 @@ static struct page **__iommu_dma_alloc_pages(struct device *dev,
>  	/* IOMMU can map any pages, so himem can also be used here */
>  	gfp |= __GFP_NOWARN | __GFP_HIGHMEM;
>  
> -	/* It makes no sense to muck about with huge pages */
> -	gfp &= ~__GFP_COMP;
> -
>  	while (count) {
>  		struct page *page = NULL;
>  		unsigned int order_size;
> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> index 33437d6206445..c026a5a5e0466 100644
> --- a/kernel/dma/mapping.c
> +++ b/kernel/dma/mapping.c
> @@ -498,6 +498,14 @@ void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
>  
>  	WARN_ON_ONCE(!dev->coherent_dma_mask);
>  
> +	/*
> +	 * DMA allocations can never be turned back into a page pointer, so
> +	 * requesting compound pages doesn't make sense (and can't even be
> +	 * supported at all by various backends).
> +	 */
> +	if (WARN_ON_ONCE(flag & __GFP_COMP))
> +		return NULL;

In RDMA patches, you wrote that GFP_USER is not legal flag either. So it
is better to WARN here for everything that is not allowed.

> +
>  	if (dma_alloc_from_dev_coherent(dev, size, dma_handle, &cpu_addr))
>  		return cpu_addr;
>  
> -- 
> 2.30.2
> 
