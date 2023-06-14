Return-Path: <netdev+bounces-10589-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3307F72F392
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 06:33:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4947E1C20B06
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 04:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13F1361;
	Wed, 14 Jun 2023 04:33:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9172E160
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 04:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BC3C433C8;
	Wed, 14 Jun 2023 04:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686717198;
	bh=BghHSIzrtx7a2ftuKdYMzdC4PbkRSEtlZX6gQl4iCnk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FyS9RqXQo6ucwy7BZ4oWV6CYondZTwWDU7HEGm/2hkYiy0YQNMTLt5SeDjXFtrALj
	 jSesN87t5LcirgJmYig11Ecw55ZBkREW+scnawS45dkaI5lZRZVrHYMr0ZgYy1cuGC
	 7gSMuDw2WdmuNrN3lofx7SfUWc3UOwHZkcGiuqfo16ZKjwxXUOG3fEs/xTjJ4N6iru
	 pyE1H11MTsQlA6KobRb4PbXg01+hyTXLjnYYDa2HYxzclfr+nn/diC5bEgV20IegcZ
	 Y7f2dgQqeTaXzKerxoLfydt535abqbihdyluGjb+fCYrPrqzpb+RafLY2Bm+nkOBPw
	 2YXFU//Dignlg==
Date: Tue, 13 Jun 2023 21:33:17 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Alexander Duyck <alexander.duyck@gmail.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric
 Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v4 2/5] page_pool: unify frag_count handling in
 page_pool_is_last_frag()
Message-ID: <20230613213317.4eb4be7c@kernel.org>
In-Reply-To: <20230612130256.4572-3-linyunsheng@huawei.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
	<20230612130256.4572-3-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Jun 2023 21:02:53 +0800 Yunsheng Lin wrote:
>  static inline void page_pool_fragment_page(struct page *page, long nr)
>  {
> -	atomic_long_set(&page->pp_frag_count, nr);
> +	if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> +		atomic_long_set(&page->pp_frag_count, nr);

why not let the driver take references on the page count in this case?
I'm not saying it's worth the effort, but a comment may be useful?

> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 9c4118c62997..69e3c5175236 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -352,6 +352,14 @@ static void page_pool_set_pp_info(struct page_pool *pool,
>  {
>  	page->pp = pool;
>  	page->pp_magic |= PP_SIGNATURE;
> +
> +	/* Ensuring all pages have been split into one big frag initially:

Again, I find the "one big frag" slightly confusing.
Maybe we should rename pp_frag_cnt into pp_refcnt?
After this series is looks even more like a page pool reference
count rather than some form of number of fragments.

> +	 * page_pool_set_pp_info() is only called once for every page when it
> +	 * is allocated from the page allocator and page_pool_fragment_page()
> +	 * is dirtying the same cache line as the page->pp_magic above, so
> +	 * the overhead is negligible.
> +	 */
> +	page_pool_fragment_page(page, 1);
>  	if (pool->p.init_callback)
>  		pool->p.init_callback(page, pool->p.init_arg);
>  }


