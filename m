Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4801B6EC81A
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 10:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjDXIuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 04:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDXIuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 04:50:24 -0400
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3778FA8;
        Mon, 24 Apr 2023 01:50:22 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0VgrC-uE_1682326217;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgrC-uE_1682326217)
          by smtp.aliyun-inc.com;
          Mon, 24 Apr 2023 16:50:18 +0800
Message-ID: <1682326210.6946251-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH bpf-next] xsk: Use pool->dma_pages to check for DMA
Date:   Mon, 24 Apr 2023 16:50:10 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Kal Conley <kal.conley@dectris.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <20230423180157.93559-1-kal.conley@dectris.com>
In-Reply-To: <20230423180157.93559-1-kal.conley@dectris.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Apr 2023 20:01:56 +0200, Kal Conley <kal.conley@dectris.com> wrote:
> Compare pool->dma_pages instead of pool->dma_pages_cnt to check for an
> active DMA mapping. pool->dma_pages needs to be read anyway to access
> the map so this compiles to more efficient code.
>
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>


Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

> ---
>  include/net/xsk_buff_pool.h | 2 +-
>  net/xdp/xsk_buff_pool.c     | 7 ++++---
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index d318c769b445..a8d7b8a3688a 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -180,7 +180,7 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
>  	if (likely(!cross_pg))
>  		return false;
>
> -	return pool->dma_pages_cnt &&
> +	return pool->dma_pages &&
>  	       !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
>  }
>
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index b2df1e0f8153..26f6d304451e 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -350,7 +350,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
>  {
>  	struct xsk_dma_map *dma_map;
>
> -	if (pool->dma_pages_cnt == 0)
> +	if (!pool->dma_pages)
>  		return;
>
>  	dma_map = xp_find_dma_map(pool);
> @@ -364,6 +364,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
>
>  	__xp_dma_unmap(dma_map, attrs);
>  	kvfree(pool->dma_pages);
> +	pool->dma_pages = NULL;
>  	pool->dma_pages_cnt = 0;
>  	pool->dev = NULL;
>  }
> @@ -503,7 +504,7 @@ static struct xdp_buff_xsk *__xp_alloc(struct xsk_buff_pool *pool)
>  	if (pool->unaligned) {
>  		xskb = pool->free_heads[--pool->free_heads_cnt];
>  		xp_init_xskb_addr(xskb, pool, addr);
> -		if (pool->dma_pages_cnt)
> +		if (pool->dma_pages)
>  			xp_init_xskb_dma(xskb, pool, pool->dma_pages, addr);
>  	} else {
>  		xskb = &pool->heads[xp_aligned_extract_idx(pool, addr)];
> @@ -569,7 +570,7 @@ static u32 xp_alloc_new_from_fq(struct xsk_buff_pool *pool, struct xdp_buff **xd
>  		if (pool->unaligned) {
>  			xskb = pool->free_heads[--pool->free_heads_cnt];
>  			xp_init_xskb_addr(xskb, pool, addr);
> -			if (pool->dma_pages_cnt)
> +			if (pool->dma_pages)
>  				xp_init_xskb_dma(xskb, pool, pool->dma_pages, addr);
>  		} else {
>  			xskb = &pool->heads[xp_aligned_extract_idx(pool, addr)];
> --
> 2.39.2
>
