Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0851573A69
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 17:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbiGMPpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 11:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236958AbiGMPpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 11:45:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9114E84A;
        Wed, 13 Jul 2022 08:45:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8621E6195E;
        Wed, 13 Jul 2022 15:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847BCC3411E;
        Wed, 13 Jul 2022 15:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657727137;
        bh=GZo3SLj/oGl49Xss42bjHxtoHp0PqzsJ7wTiSiRsKu8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qf191j2Qu9cUwxfj8D/zsyS2B4cUskeOsFriYkXt/W+kcMl4o9Mk5WdXS/GcPWXOq
         5Q4lPI07mFjOLy7o9uJApchupsOxpFIxEisxbyRPjmmWX3odJE+mPQO599lI3f1Jl2
         Rm/ZJrHp7XHl3HEpQSVc30Mxt8bictGaERSkKA64=
Date:   Wed, 13 Jul 2022 08:45:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     alexander.duyck@gmail.com, kuba@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        chen45464546@163.com
Subject: Re: [PATCH V2] mm: prevent page_frag_alloc() from corrupting the
 memory
Message-Id: <20220713084536.1af461b016a16c58baad7db2@linux-foundation.org>
In-Reply-To: <20220713150143.147537-1-mlombard@redhat.com>
References: <20220713150143.147537-1-mlombard@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 17:01:43 +0200 Maurizio Lombardi <mlombard@redhat.com> wrote:

> A number of drivers call page_frag_alloc() with a
> fragment's size > PAGE_SIZE.
> In low memory conditions, __page_frag_cache_refill() may fail the order 3
> cache allocation and fall back to order 0;
> In this case, the cache will be smaller than the fragment, causing
> memory corruptions.
> 
> Prevent this from happening by checking if the newly allocated cache
> is large enough for the fragment; if not, the allocation will fail
> and page_frag_alloc() will return NULL.
> 
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5617,6 +5617,8 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
>  		/* reset page count bias and offset to start of new frag */
>  		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
>  		offset = size - fragsz;
> +		if (unlikely(offset < 0))
> +			return NULL;
>  	}
>  
>  	nc->pagecnt_bias--;

I think we should have a comment here explaining (at least) why we'd
bale after a successful allocation and explaining why we don't call
free_the_page().  
