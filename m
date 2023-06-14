Return-Path: <netdev+bounces-10798-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4393730582
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7295D281462
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5062F2EC19;
	Wed, 14 Jun 2023 16:56:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C538E7F;
	Wed, 14 Jun 2023 16:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE09C433C0;
	Wed, 14 Jun 2023 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686761811;
	bh=JDM0HAS6PaF/JR+qgqrW0SQvJ7ciVgLgv02udiikKF8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lWoXAirWNGlRowrSNl53iWU7sefp8jy2qQoYUvLgsAZZHYTTuHm0i1aG7UvY1WiKe
	 o/FijxZxDdaEp9RpSFAOwgPvlOQPCHqZPTc9fkax1p3WS0p8c9u7DABC1zPLIhl6oM
	 hhzndx/99LsY3KtkY1XEdh9BqeDlhKIHvZDhw2oqmTJLhSjq5lFkTsRxqAQzuhT9yj
	 aEqoYYwGVubSxcBU31D11zjeke0Ngg9hvPSPzyIn88YYXbLfPKSCvJ1hVkqCzrcmpT
	 9QqWR0liaBff4/zRssAvO/SwZmSl5JyCmiG15Qsv5kXl34npzpqwTertF8tKtrmcfe
	 k3WU9Nd/ufj/g==
Date: Wed, 14 Jun 2023 09:56:49 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Alexander Duyck <alexander.duyck@gmail.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric
 Dumazet <edumazet@google.com>, Jonathan Corbet <corbet@lwn.net>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John
 Fastabend <john.fastabend@gmail.com>, <linux-doc@vger.kernel.org>,
 <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next v4 5/5] page_pool: update document about frag
 API
Message-ID: <20230614095649.5f7d8d40@kernel.org>
In-Reply-To: <1dc9b2e3-65ee-aa33-d604-a758fea98eb8@huawei.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
	<20230612130256.4572-6-linyunsheng@huawei.com>
	<20230613214041.1c29a357@kernel.org>
	<1dc9b2e3-65ee-aa33-d604-a758fea98eb8@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 20:04:39 +0800 Yunsheng Lin wrote:
> > Seems like the semantics of page_pool_alloc() are always better than
> > page_pool_alloc_frag(). Is there a reason to keep these two separate?  
> 
> I am agree the semantics of page_pool_alloc() is better, I was thinking
> about combining those two too.
> The reason I am keeping it is about the nic hw with fixed buffer size for
> each desc, and that buffer size is always smaller than or equal to half
> of the page allocated from page pool, so it doesn't bother doing the
> checking of 'size << 1 > max_size' and doesn't care about the actual
> truesize.

I see. Let's reorg the documentation, then? Something along the lines
of, maybe:


The page_pool allocator is optimized for recycling page or page frag used by skb
packet and xdp frame.

Basic use involves replacing napi_alloc_frag() and alloc_pages() calls
with page_pool_alloc(). page_pool_alloc() allocates memory with or
without page splitting depending on the requested memory size.

If the driver knows that it always requires full pages or its allocates
are always smaller than half a page, it can use one of the more specific
API calls:

1. page_pool_alloc_pages(): allocate memory without page splitting when
   driver knows that the memory it need is always bigger than half of the
   page allocated from page pool. There is no cache line dirtying for
   'struct page' when a page is recycled back to the page pool.

2. page_pool_alloc_frag(): allocate memory with page splitting when driver knows
   that the memory it need is always smaller than or equal to half of the page
   allocated from page pool. Page splitting enables memory saving and thus avoid
   TLB/cache miss for data access, but there also is some cost to implement page
   splitting, mainly some cache line dirtying/bouncing for 'struct page' and
   atomic operation for page->pp_frag_count.

