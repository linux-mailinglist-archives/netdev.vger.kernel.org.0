Return-Path: <netdev+bounces-3490-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B67CB7078C0
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:08:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 241431C2101C
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8DF39E;
	Thu, 18 May 2023 04:08:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCFA394
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DAFC433EF;
	Thu, 18 May 2023 04:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684382886;
	bh=ADz8kxD3Luyc/5/5hhVRSVuuJbhH+25ni9y4rvosUjo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fVrI0irRX5VsTxRAKOoWx+H3FkBZ4ItcOevDWVNX+Sykq22FT8OQzNyzomFxA9+98
	 tR5zFpOhvHTLs2w+xiHklppIvqhxKmavy0kipowd/fsGbQyR3G6+k8306KWzrrWCg9
	 pRO7C0Ht/9AHEmuouBckI4umXvClVr8IsH+b1OEJyT3maHzaQiCEcphaS1it/cVQkj
	 n10hKZ43zivv43EX06PqmToFieGnOxFDR4vDtSGWRhQZdYYpAHLB9UL1rtu7vQUlzz
	 I64wOU4/Ivoz5CEw8cxBrs7MLzO/OwdE3mIXWTNilX1xqIbndGLr27mxGMf74f7vTo
	 TqEU9TYgtDUqg==
Date: Wed, 17 May 2023 21:08:04 -0700
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
Subject: Re: [PATCH net-next 06/11] net: page_pool: avoid calling no-op
 externals when possible
Message-ID: <20230517210804.7de610bd@kernel.org>
In-Reply-To: <20230516161841.37138-7-aleksander.lobakin@intel.com>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
	<20230516161841.37138-7-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 May 2023 18:18:36 +0200 Alexander Lobakin wrote:
> +		/* Try to avoid calling no-op syncs */
> +		pool->p.flags |= PP_FLAG_DMA_MAYBE_SYNC;
> +		pool->p.flags &= ~PP_FLAG_DMA_SYNC_DEV;
>  	}
>  
>  	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
> @@ -323,6 +327,12 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>  
>  	page_pool_set_dma_addr(page, dma);
>  
> +	if ((pool->p.flags & PP_FLAG_DMA_MAYBE_SYNC) &&
> +	    dma_need_sync(pool->p.dev, dma)) {
> +		pool->p.flags |= PP_FLAG_DMA_SYNC_DEV;
> +		pool->p.flags &= ~PP_FLAG_DMA_MAYBE_SYNC;
> +	}

is it just me or does it feel cleaner to allocate a page at init,
and throw it into the cache, rather than adding a condition to a
fast(ish) path?

