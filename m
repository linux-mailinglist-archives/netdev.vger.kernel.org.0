Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15AC3F4AF2
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 14:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237158AbhHWMne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 08:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237098AbhHWMn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 08:43:28 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70700C061757
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 05:42:45 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l7-20020a1c2507000000b002e6be5d86b3so10640260wml.3
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 05:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q/UWlBClyKQs23UTI9wEd50PA0Zjsj8+FD2ie2aZnWk=;
        b=izr7VN0ZFPKezUdn8aUGowQ4Q242LM4pMy2XACDgXfAew5+RlSUT9KEvDFzdmXQMHd
         Kg5D+nU2YLhRgtprrF//cRuTBFyc/gmwgJZ17rPitSClO6iMPfF5euXz2wSJWW8qITZV
         CuEA49Mnt6NPUu0XP2RFt6YF+wKFAGI//pY1Tbyfh3Ry48miYoKiASupghlE9ecUlhx+
         /d9EzPN5XsR1fUX1tqyH9FnYQzmULmIgAkKAR+wiP7H7uifzLy2RuNHxfWnBVmZUKr3p
         tsT2kydUdpbXWQN1+ZF4rxZNZCL1bKLKtl/8+IWCENp5U3kVUfH1R/Yqx9NJTPmi1e55
         1WuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q/UWlBClyKQs23UTI9wEd50PA0Zjsj8+FD2ie2aZnWk=;
        b=Ny0Huh2CCna8//9GXpB6B0PJLpnqvYiJTQL1YJRRZu3i31aA1pivdPdKkfLmShRG7s
         6moZUvXkWciFWo0yEk/E69qisXTUdgTKRiFbMYMq5p92gLivwviW4rUT0Ft+8DhQPK8Z
         dp4BiehRp4/zhuudb9b0KrUqdCThvPV9mzUKDMcEtrg10ar4AxaQewSXt1OCd4lO10mL
         x6TBBs3clgSTurY+T5mhKbxVytXvTMV6p8NLx5DWN+KZm1EoCA9dCpto36/eMQt6TQQl
         o5JDwBz2IYc1Euhh+C99Gft9Bihivh0OQlurUJdguj6z7UkXoA0WOeMueX3c1ZzUVC5E
         mkqQ==
X-Gm-Message-State: AOAM533t+IjUTXgG94jWYhrt5BbAs7WG1g4Qw/HrfvzRXvQ0DBXMptsd
        UWp4hU/244mb3J41YNuI6uahtg==
X-Google-Smtp-Source: ABdhPJybNkRqoQMot6QOKvfOY6tyfLAaZ0/9ilyLDU4PaaQwrHb7MAHQtd0vTpZlyynMUf3HYg1Z/w==
X-Received: by 2002:a1c:7d06:: with SMTP id y6mr16113076wmc.7.1629722564040;
        Mon, 23 Aug 2021 05:42:44 -0700 (PDT)
Received: from enceladus (ppp-94-66-247-68.home.otenet.gr. [94.66.247.68])
        by smtp.gmail.com with ESMTPSA id y15sm1488413wrw.64.2021.08.23.05.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 05:42:43 -0700 (PDT)
Date:   Mon, 23 Aug 2021 15:42:41 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com
Subject: Re: [PATCH net-next v2 2/2] page_pool: optimize the cpu sync
 operation when DMA mapping
Message-ID: <YSOXwdLgeY1ti8ZO@enceladus>
References: <1629442611-61547-1-git-send-email-linyunsheng@huawei.com>
 <1629442611-61547-3-git-send-email-linyunsheng@huawei.com>
 <YR94YYRv2qpQtdSZ@Iliass-MBP>
 <16468e57-49d8-0a23-0058-c920af99d74a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16468e57-49d8-0a23-0058-c920af99d74a@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 11:56:48AM +0800, Yunsheng Lin wrote:
> On 2021/8/20 17:39, Ilias Apalodimas wrote:
> > On Fri, Aug 20, 2021 at 02:56:51PM +0800, Yunsheng Lin wrote:
> >> If the DMA_ATTR_SKIP_CPU_SYNC is not set, cpu syncing is
> >> also done in dma_map_page_attrs(), so set the attrs according
> >> to pool->p.flags to avoid calling cpu sync function again.
> > 
> > Isn't DMA_ATTR_SKIP_CPU_SYNC checked within dma_map_page_attrs() anyway?
> 
> Yes, the checking in dma_map_page_attrs() should save us from
> calling dma_sync_single_for_device() again if we set the attrs
> according to "pool->p.flags & PP_FLAG_DMA_SYNC_DEV".

But we aren't syncing anything right now when we allocate the pages since
this is called with DMA_ATTR_SKIP_CPU_SYNC. We are syncing the allocated
range on the end of the function, if the pool was created and was requested
to take care of the mappings for us.

> 
> As dma_sync_single_for_device() is EXPORT_SYMBOL()'ed, and
> should be a no-op for dma coherent device, so there may be a
> function calling overhead for dma coherent device, letting
> dma_map_page_attrs() handling the sync seems to avoid the stack
> pushing/poping overhead:
> 
> https://elixir.bootlin.com/linux/latest/source/kernel/dma/direct.h#L104
> 
> The one thing I am not sure about is that the pool->p.offset
> and pool->p.max_len are used to decide the sync range before this
> patch, while the sync range is the same as the map range when doing
> the sync in dma_map_page_attrs().

I am not sure I am following here. We always sync the entire range as well
in the current code as the mapping function is called with max_len.

> 
> I assumed the above is not a issue? only sync more than we need?
> and it won't hurt the performance?

We can sync more than we need, but if it's a non-coherent architecture,
there's a performance penalty. 

Regards
/Ilias
> 
> > 
> > Regards
> > /Ilias
> >>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >> ---
> >>  net/core/page_pool.c | 9 +++++----
> >>  1 file changed, 5 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> >> index 1a69784..3df5554 100644
> >> --- a/net/core/page_pool.c
> >> +++ b/net/core/page_pool.c
> >> @@ -191,8 +191,12 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
> >>  
> >>  static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
> >>  {
> >> +	unsigned long attrs = DMA_ATTR_SKIP_CPU_SYNC;
> >>  	dma_addr_t dma;
> >>  
> >> +	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> >> +		attrs = 0;
> >> +
> >>  	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
> >>  	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
> >>  	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
> >> @@ -200,15 +204,12 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
> >>  	 */
> >>  	dma = dma_map_page_attrs(pool->p.dev, page, 0,
> >>  				 (PAGE_SIZE << pool->p.order),
> >> -				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> >> +				 pool->p.dma_dir, attrs);
> >>  	if (dma_mapping_error(pool->p.dev, dma))
> >>  		return false;
> >>  
> >>  	page_pool_set_dma_addr(page, dma);
> >>  
> >> -	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> >> -		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
> >> -
> >>  	return true;
> >>  }
> >>  
> >> -- 
> >> 2.7.4
> >>
> > .
> > 
