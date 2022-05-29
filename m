Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA795372F3
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 01:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiE2Xai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 19:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiE2Xad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 19:30:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F20186F1;
        Sun, 29 May 2022 16:30:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 557B460F60;
        Sun, 29 May 2022 23:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844B5C385B8;
        Sun, 29 May 2022 23:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653867030;
        bh=GpzTPsNqRojtOnbCgreA4wsBMUClKlvqnaoCqS7Q2yQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KQN+Ec1m1OMjJ+UgZwlfD9T6ILbxe9+b+NogjSKzaZo1W1GjKoD9jeHRuicyTluyc
         Y46PdY9URSoFNW57j4/XKpmaiBgrj1ciQxaSkul9U9dTYTKiq1R56QatdIs0SAEJHx
         OOvlfw0dtnht5dc3r6aVTVDcQB2SvqPjf1wmm0BM=
Date:   Sun, 29 May 2022 16:30:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Chen Lin <chen45464546@163.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mm: page_frag: Warn_on when frag_alloc size is bigger
 than PAGE_SIZE
Message-Id: <20220529163029.12425c1e5286d7c7e3fe3708@linux-foundation.org>
In-Reply-To: <1653752373-3172-1-git-send-email-chen45464546@163.com>
References: <1653752373-3172-1-git-send-email-chen45464546@163.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 May 2022 23:39:33 +0800 Chen Lin <chen45464546@163.com> wrote:

> netdev_alloc_frag->page_frag_alloc may cause memory corruption in 
> the following process:
> 
> 1. A netdev_alloc_frag function call need alloc 200 Bytes to build a skb.
> 
> 2. Insufficient memory to alloc PAGE_FRAG_CACHE_MAX_ORDER(32K) in 
> __page_frag_cache_refill to fill frag cache, then one page(eg:4K) 
> is allocated, now current frag cache is 4K, alloc is success, 
> nc->pagecnt_bias--.
> 
> 3. Then this 200 bytes skb in step 1 is freed, page->_refcount--.
> 
> 4. Another netdev_alloc_frag function call need alloc 5k, page->_refcount 
> is equal to nc->pagecnt_bias, reset page count bias and offset to 
> start of new frag. page_frag_alloc will return the 4K memory for a 
> 5K memory request.
> 
> 5. The caller write on the extra 1k memory which is not actual allocated 
> will cause memory corruption.
> 
> page_frag_alloc is for fragmented allocation. We should warn the caller 
> to avoid memory corruption.
> 

Let's cc Alexander and the networking developers.

> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5574,6 +5574,11 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
>  	struct page *page;
>  	int offset;
>  
> +	/* frag_alloc is not suitable for memory alloc which fragsz
> +	 * is bigger than PAGE_SIZE, use kmalloc or alloc_pages instead.
> +	 */
> +	WARN_ON(fragsz > PAGE_SIZE);
> +
>  	if (unlikely(!nc->va)) {
>  refill:
>  		page = __page_frag_cache_refill(nc, gfp_mask);

Odd.  All this does is generate a warning.  If the kernel is corrupting
memory, that's a bug which needs fixing?

