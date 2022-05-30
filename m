Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AE4538807
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 22:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240056AbiE3UHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 16:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbiE3UHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 16:07:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94B23A5EA;
        Mon, 30 May 2022 13:07:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 536FD60F07;
        Mon, 30 May 2022 20:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F96C385B8;
        Mon, 30 May 2022 20:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653941226;
        bh=IceWjrQYTWx7mJhwvWrILoecanQR/v6aI5fgN3w/Z6M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UKcu6oBA4OkyYyd4gqvvLzf6pUAiSjmWDo2UTQBcfEzHlVORWQTrDxG26KuK7bVbc
         uSt0Wn04xLzbkFGtKHtq8LvlOxcrHkPCRPpAVeYS19ZIcCEPrf+V1up1LiDZzEm+1K
         lYZll9twRNetusEsoa7avPOcR+QpEuZszGyf8at0=
Date:   Mon, 30 May 2022 13:07:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Chen Lin <chen45464546@163.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        alexander.h.duyck@linux.intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] mm: page_frag: Warn_on when frag_alloc size is
 bigger than PAGE_SIZE
Message-Id: <20220530130705.29c5fa4a5225265d3736bfa4@linux-foundation.org>
In-Reply-To: <1653917942-5982-1-git-send-email-chen45464546@163.com>
References: <20220529163029.12425c1e5286d7c7e3fe3708@linux-foundation.org>
        <1653917942-5982-1-git-send-email-chen45464546@163.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 May 2022 21:39:02 +0800 Chen Lin <chen45464546@163.com> wrote:

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
> When fragsz is larger than one page, we report the failure and return.
> I don't think it is a good idea to make efforts to support the
> allocation of more than one page in this function because the total
> frag cache size(PAGE_FRAG_CACHE_MAX_SIZE 32768) is relatively small.
> When the request is larger than one page, the caller should switch to
> use other kernel interfaces, such as kmalloc and alloc_Pages.
> 
> This bug is mainly caused by the reuse of the previously allocated
> frag cache memory by the following LARGER allocations. This bug existed
> before page_frag_alloc was ported from __netdev_alloc_frag in 
> net/core/skbuff.c, so most Linux versions have this problem.
> 

I won't attempt to address the large issues here (like, should
networking be changed to support this).  But I can nitpick :)

> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5574,6 +5574,16 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
>  	struct page *page;
>  	int offset;
>  
> +	/* frag_alloc is not suitable for memory alloc which fragsz

Like this please:

	/*
	 * frag_alloc...

> +	 * is bigger than PAGE_SIZE, use kmalloc or alloc_pages instead.
> +	 */
> +	if (unlikely(fragsz > PAGE_SIZE)) {
> +		WARN(1, "alloc fragsz(%d) > PAGE_SIZE(%ld) not supported,
> +			alloc fail\n", fragsz, PAGE_SIZE);

It's neater to do

	if (WARN(fragsz > PAGE_SIZE, "alloc fragsz(%d...", ...))
		return NULL;

Also, you have a newline and a bunch of tabs in that string.

Also, please consider WARN_ONCE.  We don't want to provide misbehaved
or malicious userspace with the ability to flood the logs with
warnings.


