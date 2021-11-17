Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210D34544F8
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 11:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbhKQKbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 05:31:08 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47100 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbhKQKbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 05:31:07 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id 378DD1F45D3D
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1637144887; bh=Vg2m2exil937GTPYwJbOzulKtOt63WQfO/CTQsl/0XY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ogb7b7NEQ8Gxx9gh/OVDcGL8xx54STxdy4i/fmEVqvlCInY/LsjfZB9cl6T2zaeOq
         3gCW6j7Qia50perVMXwtpKRjzFkogo4d1IfDzH5v8l1Ol8siBx+0EqsfgraqNiEQ78
         Flh5v6JxoVl3yBHVwebCNqoL4WSDvTcbsyyW8SrJ0pV7VLb5/JbHSAfPdLwqO0tog7
         Bs+0IWyTuQVL/0A23X8UC251wlP8g2MzTtMpO60aJ2LzujvZTWJBsPQ7M1gYH/rrHJ
         OU+q0DvrvFo66T8GNMPpWO7Uotb69H7XcIq6A0gawPjJjiw1PM7n3oQ0Q5JRWB+EYs
         /0ec1Gb9oKgWg==
Subject: Re: [PATCH net] page_pool: Revert "page_pool: disable dma mapping
 support..."
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, akpm@linux-foundation.org,
        peterz@infradead.org, vbabka@suse.cz, willy@infradead.org,
        will@kernel.org, feng.tang@intel.com, jgg@ziepe.ca,
        ebiederm@xmission.com, aarcange@redhat.com,
        "kernelci@groups.io" <kernelci@groups.io>
References: <20211117075652.58299-1-linyunsheng@huawei.com>
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <b5638a79-ee37-fd52-2d9c-ded2675529da@collabora.com>
Date:   Wed, 17 Nov 2021 10:28:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211117075652.58299-1-linyunsheng@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/11/2021 07:56, Yunsheng Lin wrote:
> This reverts commit d00e60ee54b12de945b8493cf18c1ada9e422514.
> 
> As reported by Guillaume in [1]:
> Enabling LPAE always enables CONFIG_ARCH_DMA_ADDR_T_64BIT
> in 32-bit systems, which breaks the bootup proceess when a
> ethernet driver is using page pool with PP_FLAG_DMA_MAP flag.
> As we were hoping we had no active consumers for such system
> when we removed the dma mapping support, and LPAE seems like
> a common feature for 32 bits system, so revert it.
> 
> 1. https://www.spinics.net/lists/netdev/msg779890.html
> 
> Fixes: d00e60ee54b1 ("page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA")
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Reported-by: "kernelci.org bot" <bot@kernelci.org>

Tested-by: "kernelci.org bot" <bot@kernelci.org>

Here's some test results with the revert patch applied on top of
mainline, to confirm the platform boots again:

  https://staging.kernelci.org/test/plan/id/6194d88fbe0f345a9b1760aa/

Thanks,
Guillaume

> ---
>  include/linux/mm_types.h | 13 ++++++++++++-
>  include/net/page_pool.h  | 12 +++++++++++-
>  net/core/page_pool.c     | 10 ++++------
>  3 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index bb8c6f5f19bc..c3a6e6209600 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -105,7 +105,18 @@ struct page {
>  			struct page_pool *pp;
>  			unsigned long _pp_mapping_pad;
>  			unsigned long dma_addr;
> -			atomic_long_t pp_frag_count;
> +			union {
> +				/**
> +				 * dma_addr_upper: might require a 64-bit
> +				 * value on 32-bit architectures.
> +				 */
> +				unsigned long dma_addr_upper;
> +				/**
> +				 * For frag page support, not supported in
> +				 * 32-bit architectures with 64-bit DMA.
> +				 */
> +				atomic_long_t pp_frag_count;
> +			};
>  		};
>  		struct {	/* slab, slob and slub */
>  			union {
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 3855f069627f..a4082406a003 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -216,14 +216,24 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>  	page_pool_put_full_page(pool, page, true);
>  }
>  
> +#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
> +		(sizeof(dma_addr_t) > sizeof(unsigned long))
> +
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
> -	return page->dma_addr;
> +	dma_addr_t ret = page->dma_addr;
> +
> +	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> +		ret |= (dma_addr_t)page->dma_addr_upper << 16 << 16;
> +
> +	return ret;
>  }
>  
>  static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>  {
>  	page->dma_addr = addr;
> +	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> +		page->dma_addr_upper = upper_32_bits(addr);
>  }
>  
>  static inline void page_pool_set_frag_count(struct page *page, long nr)
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 9b60e4301a44..1a6978427d6c 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -49,12 +49,6 @@ static int page_pool_init(struct page_pool *pool,
>  	 * which is the XDP_TX use-case.
>  	 */
>  	if (pool->p.flags & PP_FLAG_DMA_MAP) {
> -		/* DMA-mapping is not supported on 32-bit systems with
> -		 * 64-bit DMA mapping.
> -		 */
> -		if (sizeof(dma_addr_t) > sizeof(unsigned long))
> -			return -EOPNOTSUPP;
> -
>  		if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
>  		    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
>  			return -EINVAL;
> @@ -75,6 +69,10 @@ static int page_pool_init(struct page_pool *pool,
>  		 */
>  	}
>  
> +	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
> +	    pool->p.flags & PP_FLAG_PAGE_FRAG)
> +		return -EINVAL;
> +
>  	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
>  		return -ENOMEM;
>  
> 

