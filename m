Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C036D2875
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 21:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbjCaTGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 15:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjCaTGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 15:06:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BFC2293F
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 12:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4671B831E1
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 19:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8EDC433D2;
        Fri, 31 Mar 2023 19:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680289604;
        bh=FJkjOD05xEE3n8ZEWc/dSZM75D4kguMZHMCk7s0HZEs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LzGnqA3giRJOC5SjaIH3122MlK7fX+rWm9rVDz7vgex+OCu5TBXkQ0h0RzhF0kj8q
         2y7OEwwI4BkLQ1VcIN3B/sfRIAVDh5QSxKQNH9bbyau7LE6wSE8IFMrnCaTEGejZk8
         u5KoIlVXTyBX6QtOrw6CH7fDFg6OYWkUE//nWULWYOKBq+tma09uh0hwmznuKIBm/G
         igROZ46qFl44gy3IKCiNk1vzRnKD1JXV+aJnOjcZrHKLvjmFcS6/eCKxlW+gwvN1UX
         WNm4gEqFlaVudTsuBbJisSF5y4KkH8mDI4SU6Q1TdyRVxM32GtCowu9vkHctU1gKbg
         dE3w/+nGKrDYA==
Date:   Fri, 31 Mar 2023 12:06:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     davem@davemloft.net, brouer@redhat.com, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely
 localized NAPI
Message-ID: <20230331120643.09ce0e59@kernel.org>
In-Reply-To: <c646d51c-4e91-bd86-9a5b-97b5a1ce33d0@redhat.com>
References: <20230331043906.3015706-1-kuba@kernel.org>
        <c646d51c-4e91-bd86-9a5b-97b5a1ce33d0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 11:31:31 +0200 Jesper Dangaard Brouer wrote:
> On 31/03/2023 06.39, Jakub Kicinski wrote:
> > With that and patched bnxt (XDP enabled to engage the page pool, sigh,
> > bnxt really needs page pool work :() I see a 2.6% perf boost with
> > a TCP stream test (app on a different physical core than softirq).
> > 
> > The CPU use of relevant functions decreases as expected:
> > 
> >    page_pool_refill_alloc_cache   1.17% -> 0%
> >    _raw_spin_lock                 2.41% -> 0.98%
> > 
> > Only consider lockless path to be safe when NAPI is scheduled
> > - in practice this should cover majority if not all of steady state
> > workloads. It's usually the NAPI kicking in that causes the skb flush.
> 
> Make sense, but do read the comment above struct pp_alloc_cache.
> The sizing of pp_alloc_cache is important for this trick/heuristic to
> work, meaning the pp_alloc_cache have enough room.
> It is definitely on purpose that pp_alloc_cache have 128 elements and is
> only refill'ed with 64 elements, which leaves room for this kind of
> trick.  But if Eric's deferred skb freeing have more than 64 pages to
> free, then we will likely fallback to ptr_ring recycling.
> 
> Code wise, I suggest that you/we change page_pool_put_page_bulk() to
> have a variant that 'allow_direct' (looking at code below, you might
> already do this as this patch over-steer 'allow_direct').  Using the
> bulk API, would then bulk into ptr_ring in the cases we cannot use
> direct cache.

Interesting point, let me re-run some tests with the statistics enabled.
For a simple stream test I think it may just be too steady to trigger
over/underflow. Each skb will carry at most 18 pages, and driver should
only produce 64 packets / consume 64 pages. Each NAPI cycle will start
by flushing the deferred free. So unless there is a hiccup either at the
app or NAPI side - the flows of pages in each direction should be steady
enough to do well with just 128 cache entries. Let me get the data and
report back.

> >   /* If the page refcnt == 1, this will try to recycle the page.
> >    * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
> >    * the configured size min(dma_sync_size, pool->max_len).
> > @@ -570,6 +583,9 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
> >   			page_pool_dma_sync_for_device(pool, page,
> >   						      dma_sync_size);
> >   
> > +		if (!allow_direct)
> > +			allow_direct = page_pool_safe_producer(pool);
> > +  
> 
> I remember some use-case for veth, that explicitly disables
> "allow_direct".  I cannot remember why exactly, but we need to make sure
> that doesn't break something (as this code can undo the allow_direct).

I can't find anything in veth :( Trying to grep drivers for
page_pool_put / page_pool_recycle problems best I could find is commit
e38553bdc377 ("net: fec: Use page_pool_put_full_page when freeing rx buffers").
