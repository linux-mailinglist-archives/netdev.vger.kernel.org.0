Return-Path: <netdev+bounces-3672-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A55F6708460
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 446461C21083
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569D921067;
	Thu, 18 May 2023 14:56:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06A523C6A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 14:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7CCC433EF;
	Thu, 18 May 2023 14:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684421805;
	bh=falOcbL4ZZzvoQbqldjfq18URK37IBRaR29UBqVOjsk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dDDWYbaKviNkf6e5ZNGk+G/Cbzx/2OiZ2ynEHeldkHvdLZMetuHksyWOJmATx2ysB
	 uvQfUuFerlLwgNbz+KAD2e/oPzHYgHx/iL58dhb/Hue8WKHacs/NwB6gq7wWqbdT4K
	 BOyBNHIwj7aYjsMnuoljesAIG4CVio4ZyJZe3LnOYNaegS8PtbAfnljjSGKhVXT41l
	 BPk87oVE5+9u4zM5U2od2Rkn6oG5S8l+zQzPCDjv75/nB5ZE+wf7vWYlo1Cc47Kz2Q
	 fUcNN7RSTXcwXNUCajZgIOkEs0RZ34+oLCdsWRz4Y1PDw3emRweMsSqkLL0MJeyDRa
	 WVHqU0xDpaZeQ==
Date: Thu, 18 May 2023 07:56:43 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, Larysa Zaremba
 <larysa.zaremba@intel.com>, <netdev@vger.kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, <linux-kernel@vger.kernel.org>, "Christoph
 Hellwig" <hch@lst.de>, Eric Dumazet <edumazet@google.com>, Michal Kubiak
 <michal.kubiak@intel.com>, <intel-wired-lan@lists.osuosl.org>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Magnus
 Karlsson <magnus.karlsson@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 07/11] net: page_pool: add
 DMA-sync-for-CPU inline helpers
Message-ID: <20230518075643.3a242837@kernel.org>
In-Reply-To: <9feef136-7ff3-91a4-4198-237b07a91c0c@intel.com>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
	<20230516161841.37138-8-aleksander.lobakin@intel.com>
	<20230517211211.1d1bbd0b@kernel.org>
	<9feef136-7ff3-91a4-4198-237b07a91c0c@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 May 2023 15:45:33 +0200 Alexander Lobakin wrote:
> >> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> >> index 8435013de06e..f740c50b661f 100644
> >> --- a/include/net/page_pool.h
> >> +++ b/include/net/page_pool.h
> >> @@ -32,7 +32,7 @@
> >>  
> >>  #include <linux/mm.h> /* Needed by ptr_ring */
> >>  #include <linux/ptr_ring.h>
> >> -#include <linux/dma-direction.h>
> >> +#include <linux/dma-mapping.h>  
> > 
> > highly nit picky - but isn't dma-mapping.h pretty heavy?
> > And we include page_pool.h in skbuff.h. Not that it matters
> > today, but maybe one day we'll succeed putting skbuff.h
> > on a diet -- so perhaps it's better to put "inline helpers
> > with non-trivial dependencies" into a new header?  
> 
> Maybe we could rather stop including page_pool.h into skbuff.h? It's
> used there only for  1 external, which could be declared directly in
> skbuff.h. When Matteo was developing PP recycling, he was storing
> mem_info in skb as well, but then it was optimized and we don't do that
> anymore.
> It annoys sometimes to see the whole kernel rebuilt each time I edit
> pag_pool.h :D In fact, only PP-enabled drivers and core code need it.

Or maybe we can do both? I think that separating types, defines and
simple wrappers from helpers should be considered good code hygiene.

> >>  #define PP_FLAG_DMA_MAP		BIT(0) /* Should page_pool do the DMA
> >>  					* map/unmap  
> >   
> >> +/**
> >> + * page_pool_dma_sync_for_cpu - sync Rx page for CPU after it's written by HW
> >> + * @pool: page_pool which this page belongs to
> >> + * @page: page to sync
> >> + * @dma_sync_size: size of the data written to the page
> >> + *
> >> + * Can be used as a shorthand to sync Rx pages before accessing them in the
> >> + * driver. Caller must ensure the pool was created with %PP_FLAG_DMA_MAP.
> >> + */
> >> +static inline void page_pool_dma_sync_for_cpu(const struct page_pool *pool,
> >> +					      const struct page *page,
> >> +					      u32 dma_sync_size)
> >> +{
> >> +	dma_sync_single_range_for_cpu(pool->p.dev,
> >> +				      page_pool_get_dma_addr(page),
> >> +				      pool->p.offset, dma_sync_size,
> >> +				      page_pool_get_dma_dir(pool));  
> > 
> > Likely a dumb question but why does this exist?
> > Is there a case where the "maybe" version is not safe?  
> 
> If the driver doesn't set DMA_SYNC_DEV flag, then the "maybe" version
> will never do anything. But we may want to use these helpers in such
> drivers too?

Oh, I see, the polarity of the flag is awkward. Hm.
Maybe just rename things, drop the "maybe_" and prefix the non-checking
version with __ ? We expect drivers to call the version which check the
flag mostly (AFAIU), so it should have the most obvious name.
Plus perhaps a sentence in the kdoc explaining why __ exists would be
good, if it wasn't obvious to me it may not be obvious to others..

