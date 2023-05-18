Return-Path: <netdev+bounces-3491-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02A837078CB
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0A6D2817A0
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED6B139E;
	Thu, 18 May 2023 04:12:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C095394
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2F1C433EF;
	Thu, 18 May 2023 04:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684383133;
	bh=qGNLvFxonxA6l6xCteXuotmOKPJ70RuXFSolajrmk2Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hm2c1q4KPQ2Y4wfEz64Xyu4o/4eQqP+fb6otFMaZFhdttgZtZZ4HzUV6RSJCzWL12
	 V8YPPtDhp5WvcVDkMe0l+ifFksDWYM1MTWGFRtxGOxhMVB+40FGt0vQDuTGdb5qQrM
	 NrDejuHVEeRKb/p7oqKXEYmQb1tzZoDvdVub2y//s1FqezJK5TsXtyv/phpSy79Ljq
	 mFmbZK8Vcrl0IyZS8pxN4DfKF8r0BluVJow3ceUcoXuMTQz+4ku395maKDR2MLdER6
	 lKWh9x3CwMkKvJy9LyolkgiV97k3kyYK1FlU4jZuQzg7RPGcs+sxUjorh2PUDuwdbD
	 L7kv/o5IBYgYA==
Date: Wed, 17 May 2023 21:12:11 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Maciej Fijalkowski
 <maciej.fijalkowski@intel.com>, Magnus Karlsson
 <magnus.karlsson@intel.com>, Michal Kubiak <michal.kubiak@intel.com>,
 Larysa Zaremba <larysa.zaremba@intel.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
 intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 07/11] net: page_pool: add DMA-sync-for-CPU
 inline helpers
Message-ID: <20230517211211.1d1bbd0b@kernel.org>
In-Reply-To: <20230516161841.37138-8-aleksander.lobakin@intel.com>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
	<20230516161841.37138-8-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 May 2023 18:18:37 +0200 Alexander Lobakin wrote:
> Each driver is responsible for syncing buffers written by HW for CPU
> before accessing them. Almost each PP-enabled driver uses the same
> pattern, which could be shorthanded into a static inline to make driver
> code a little bit more compact.
> Introduce a couple such functions. The first one takes the actual size
> of the data written by HW and is the main one to be used on Rx. The
> second does the same, but only if the PP performs DMA synchronizations
> at all. The last one picks max_len from the PP params and is designed
> for more extreme cases when the size is unknown, but the buffer still
> needs to be synced.
> Also constify pointer arguments of page_pool_get_dma_dir() and
> page_pool_get_dma_addr() to give a bit more room for optimization,
> as both of them are read-only.

Very neat.

> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 8435013de06e..f740c50b661f 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -32,7 +32,7 @@
>  
>  #include <linux/mm.h> /* Needed by ptr_ring */
>  #include <linux/ptr_ring.h>
> -#include <linux/dma-direction.h>
> +#include <linux/dma-mapping.h>

highly nit picky - but isn't dma-mapping.h pretty heavy?
And we include page_pool.h in skbuff.h. Not that it matters
today, but maybe one day we'll succeed putting skbuff.h
on a diet -- so perhaps it's better to put "inline helpers
with non-trivial dependencies" into a new header?

>  #define PP_FLAG_DMA_MAP		BIT(0) /* Should page_pool do the DMA
>  					* map/unmap

> +/**
> + * page_pool_dma_sync_for_cpu - sync Rx page for CPU after it's written by HW
> + * @pool: page_pool which this page belongs to
> + * @page: page to sync
> + * @dma_sync_size: size of the data written to the page
> + *
> + * Can be used as a shorthand to sync Rx pages before accessing them in the
> + * driver. Caller must ensure the pool was created with %PP_FLAG_DMA_MAP.
> + */
> +static inline void page_pool_dma_sync_for_cpu(const struct page_pool *pool,
> +					      const struct page *page,
> +					      u32 dma_sync_size)
> +{
> +	dma_sync_single_range_for_cpu(pool->p.dev,
> +				      page_pool_get_dma_addr(page),
> +				      pool->p.offset, dma_sync_size,
> +				      page_pool_get_dma_dir(pool));

Likely a dumb question but why does this exist?
Is there a case where the "maybe" version is not safe?

> +}
> +
> +/**
> + * page_pool_dma_maybe_sync_for_cpu - sync Rx page for CPU if needed
> + * @pool: page_pool which this page belongs to
> + * @page: page to sync
> + * @dma_sync_size: size of the data written to the page
> + *
> + * Performs DMA sync for CPU, but only when required (swiotlb, IOMMU etc.).
> + */
> +static inline void
> +page_pool_dma_maybe_sync_for_cpu(const struct page_pool *pool,
> +				 const struct page *page, u32 dma_sync_size)
> +{
> +	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> +		page_pool_dma_sync_for_cpu(pool, page, dma_sync_size);
> +}

