Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1755B3043AA
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 17:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392872AbhAZQV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 11:21:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:37032 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390281AbhAZQUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 11:20:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7774CACF5;
        Tue, 26 Jan 2021 16:19:55 +0000 (UTC)
Subject: Re: [PATCH net-next 1/4] mm: page_frag: Introduce
 page_frag_alloc_align()
To:     Kevin Hao <haokexin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org
References: <20210123115903.31302-1-haokexin@gmail.com>
 <20210123115903.31302-2-haokexin@gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <42fecf9d-70c9-b686-d2f7-080b299060d9@suse.cz>
Date:   Tue, 26 Jan 2021 17:19:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210123115903.31302-2-haokexin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/21 12:59 PM, Kevin Hao wrote:
> In the current implementation of page_frag_alloc(), it doesn't have
> any align guarantee for the returned buffer address. But for some
> hardwares they do require the DMA buffer to be aligned correctly,
> so we would have to use some workarounds like below if the buffers
> allocated by the page_frag_alloc() are used by these hardwares for
> DMA.
>     buf = page_frag_alloc(really_needed_size + align);
>     buf = PTR_ALIGN(buf, align);
> 
> These codes seems ugly and would waste a lot of memories if the buffers
> are used in a network driver for the TX/RX. So introduce
> page_frag_alloc_align() to make sure that an aligned buffer address is
> returned.
> 
> Signed-off-by: Kevin Hao <haokexin@gmail.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Agree with Jakub about static inline.

> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5135,8 +5135,8 @@ void __page_frag_cache_drain(struct page *page, unsigned int count)
>  }
>  EXPORT_SYMBOL(__page_frag_cache_drain);
>  
> -void *page_frag_alloc(struct page_frag_cache *nc,
> -		      unsigned int fragsz, gfp_t gfp_mask)
> +void *page_frag_alloc_align(struct page_frag_cache *nc,
> +		      unsigned int fragsz, gfp_t gfp_mask, int align)
>  {
>  	unsigned int size = PAGE_SIZE;
>  	struct page *page;
> @@ -5188,10 +5188,18 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>  	}
>  
>  	nc->pagecnt_bias--;
> +	offset = align ? ALIGN_DOWN(offset, align) : offset;

We don't change offset if align == 0, so I'd go with simpler
if (align)
	offset = ...

>  	nc->offset = offset;
>  
>  	return nc->va + offset;
>  }
> +EXPORT_SYMBOL(page_frag_alloc_align);
> +
> +void *page_frag_alloc(struct page_frag_cache *nc,
> +		      unsigned int fragsz, gfp_t gfp_mask)
> +{
> +	return page_frag_alloc_align(nc, fragsz, gfp_mask, 0);
> +}
>  EXPORT_SYMBOL(page_frag_alloc);
>  
>  /*
> 

