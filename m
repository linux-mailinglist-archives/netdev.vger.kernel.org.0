Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE81F5387BF
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 21:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242991AbiE3T30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 15:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiE3T3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 15:29:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386CB38195;
        Mon, 30 May 2022 12:29:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C48B6B80EF2;
        Mon, 30 May 2022 19:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAF2C385B8;
        Mon, 30 May 2022 19:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653938960;
        bh=idqKKXbx/E3isLNQEL00SKD3nzVRYsHGoE11alqF8pM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rS3Ya/tJ4jpchbK4aX7d3wiI3UVD6YdXmTJojVXz43YaylAuXpHEEEruxWY63qw5v
         cDyuDCWZD3/HsC64Hbl7guv+3q0WrlhRxO6Oj+avimOszEwJtcoRVM1rUAezb+hKl1
         O6Jmu8LBK3lV60pn0VszRuShrdAocGpqWRlVLZ4bNZveHJEZQJdgnA7XCI9qFMLKl7
         h+t07BUzrSKm70RPf7JkJIZvNZ+InU8PXkH0CrWvIKTnuQMya2oyOZfNMqCG/bdHm8
         ejbkOb6dwJeajpWnip8KaCtuUO/cwfeJo6nG+5mVqcLQEP1D45nEWwkNlA4127Xz58
         RiAC1GagYoadA==
Date:   Mon, 30 May 2022 12:29:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chen Lin <chen45464546@163.com>
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] mm: page_frag: Warn_on when frag_alloc size is
 bigger than PAGE_SIZE
Message-ID: <20220530122918.549ef054@kernel.org>
In-Reply-To: <20220530122705.4e74bc1e@kernel.org>
References: <20220529163029.12425c1e5286d7c7e3fe3708@linux-foundation.org>
        <1653917942-5982-1-git-send-email-chen45464546@163.com>
        <20220530122705.4e74bc1e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 May 2022 12:27:05 -0700 Jakub Kicinski wrote:
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e008a3df0485..360a545ee5e8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5537,6 +5537,7 @@ EXPORT_SYMBOL(free_pages);
>   * sk_buff->head, or to be used in the "frags" portion of skb_shared_info.
>   */
>  static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
> +					     unsigned int fragsz,
>  					     gfp_t gfp_mask)
>  {
>  	struct page *page = NULL;
> @@ -5549,7 +5550,7 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
>  				PAGE_FRAG_CACHE_MAX_ORDER);
>  	nc->size = page ? PAGE_FRAG_CACHE_MAX_SIZE : PAGE_SIZE;
>  #endif
> -	if (unlikely(!page))
> +	if (unlikely(!page && fragsz <= PAGE_SIZE))
>  		page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);
>  
>  	nc->va = page ? page_address(page) : NULL;
> @@ -5576,7 +5577,7 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
>  
>  	if (unlikely(!nc->va)) {
>  refill:
> -		page = __page_frag_cache_refill(nc, gfp_mask);
> +		page = __page_frag_cache_refill(nc, fragsz, gfp_mask);
>  		if (!page)
>  			return NULL;

Oh, well, the reuse also needs an update. We can slap a similar
condition next to the pfmemalloc check.
