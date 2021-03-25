Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD94349325
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCYNeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:34:37 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:20391 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhCYNeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 09:34:07 -0400
Date:   Thu, 25 Mar 2021 13:33:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616679243; bh=TNcqNIUGi5IWLeEp3KkdTlzXyUEpBuLEIC37/Wa1Bno=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=NlvHt1XOAsoKLYbRojzvQhEKl/dCwJH25h2fND3oo6JGcBeJOaQ6uOHTcrdu8bAWy
         YaxG6wwQ/wzjIFrsu1uc9DoU+oN8ML3ReRR0B0PrTwPA+/EBTBht46sonbfO+cS7WY
         /Dcm3VDXbNq5UeMyGdcsv75ryM+ofhL8VSXEiy/WFWx1nezNk3Gw0/Ehj3Zz3D6rZA
         5INj5uRlIMIdBMMlu5kXDEuek6OnsdoUmCiYDAqcgfcVBCQDKCpPIBn43yfS+fXem2
         4/eI/oTNgPa6rXbwupzm8d39KtK8sjR/o7nfkLkXqXlKtqIW0sqine4Fuzl5Akyheq
         Yk2KHi8rPXA7w==
To:     Mel Gorman <mgorman@techsingularity.net>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH 9/9] net: page_pool: use alloc_pages_bulk in refill code path
Message-ID: <20210325133340.14527-1-alobakin@pm.me>
In-Reply-To: <20210325114228.27719-10-mgorman@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net> <20210325114228.27719-10-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Date: Thu, 25 Mar 2021 11:42:28 +0000

> From: Jesper Dangaard Brouer <brouer@redhat.com>
>
> There are cases where the page_pool need to refill with pages from the
> page allocator. Some workloads cause the page_pool to release pages
> instead of recycling these pages.
>
> For these workload it can improve performance to bulk alloc pages from
> the page-allocator to refill the alloc cache.
>
> For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
> redirecting xdp_frame packets into a veth, that does XDP_PASS to create
> an SKB from the xdp_frame, which then cannot return the page to the
> page_pool.
>
> Performance results under GitHub xdp-project[1]:
>  [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/pag=
e_pool06_alloc_pages_bulk.org
>
> Mel: The patch "net: page_pool: convert to use alloc_pages_bulk_array
> variant" was squashed with this patch. From the test page, the array
> variant was superior with one of the test results as follows.
>
> =09Kernel=09=09XDP stats       CPU     pps           Delta
> =09Baseline=09XDP-RX CPU      total   3,771,046       n/a
> =09List=09=09XDP-RX CPU      total   3,940,242    +4.49%
> =09Array=09=09XDP-RX CPU      total   4,249,224   +12.68%
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>

I tested it a lot for past two weeks and I'm very satisfied with
the results, especially the new array-based version.
Haven't had a chance to test this particular set yet, but still.

Reviewed-by: Alexander Lobakin <alobakin@pm.me>

Great work, thank you all guys!

> ---
>  include/net/page_pool.h |  2 +-
>  net/core/page_pool.c    | 82 ++++++++++++++++++++++++++++-------------
>  2 files changed, 57 insertions(+), 27 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index b5b195305346..6d517a37c18b 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -65,7 +65,7 @@
>  #define PP_ALLOC_CACHE_REFILL=0964
>  struct pp_alloc_cache {
>  =09u32 count;
> -=09void *cache[PP_ALLOC_CACHE_SIZE];
> +=09struct page *cache[PP_ALLOC_CACHE_SIZE];
>  };
>
>  struct page_pool_params {
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 40e1b2beaa6c..9ec1aa9640ad 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -203,38 +203,17 @@ static bool page_pool_dma_map(struct page_pool *poo=
l, struct page *page)
>  =09return true;
>  }
>
> -/* slow path */
> -noinline
> -static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
> -=09=09=09=09=09=09 gfp_t _gfp)
> +static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
> +=09=09=09=09=09=09 gfp_t gfp)
>  {
> -=09unsigned int pp_flags =3D pool->p.flags;
>  =09struct page *page;
> -=09gfp_t gfp =3D _gfp;
> -
> -=09/* We could always set __GFP_COMP, and avoid this branch, as
> -=09 * prep_new_page() can handle order-0 with __GFP_COMP.
> -=09 */
> -=09if (pool->p.order)
> -=09=09gfp |=3D __GFP_COMP;
> -
> -=09/* FUTURE development:
> -=09 *
> -=09 * Current slow-path essentially falls back to single page
> -=09 * allocations, which doesn't improve performance.  This code
> -=09 * need bulk allocation support from the page allocator code.
> -=09 */
>
> -=09/* Cache was empty, do real allocation */
> -#ifdef CONFIG_NUMA
> +=09gfp |=3D __GFP_COMP;
>  =09page =3D alloc_pages_node(pool->p.nid, gfp, pool->p.order);
> -#else
> -=09page =3D alloc_pages(gfp, pool->p.order);
> -#endif
> -=09if (!page)
> +=09if (unlikely(!page))
>  =09=09return NULL;
>
> -=09if ((pp_flags & PP_FLAG_DMA_MAP) &&
> +=09if ((pool->p.flags & PP_FLAG_DMA_MAP) &&
>  =09    unlikely(!page_pool_dma_map(pool, page))) {
>  =09=09put_page(page);
>  =09=09return NULL;
> @@ -243,6 +222,57 @@ static struct page *__page_pool_alloc_pages_slow(str=
uct page_pool *pool,
>  =09/* Track how many pages are held 'in-flight' */
>  =09pool->pages_state_hold_cnt++;
>  =09trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
> +=09return page;
> +}
> +
> +/* slow path */
> +noinline
> +static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
> +=09=09=09=09=09=09 gfp_t gfp)
> +{
> +=09const int bulk =3D PP_ALLOC_CACHE_REFILL;
> +=09unsigned int pp_flags =3D pool->p.flags;
> +=09unsigned int pp_order =3D pool->p.order;
> +=09struct page *page;
> +=09int i, nr_pages;
> +
> +=09/* Don't support bulk alloc for high-order pages */
> +=09if (unlikely(pp_order))
> +=09=09return __page_pool_alloc_page_order(pool, gfp);
> +
> +=09/* Unnecessary as alloc cache is empty, but guarantees zero count */
> +=09if (unlikely(pool->alloc.count > 0))
> +=09=09return pool->alloc.cache[--pool->alloc.count];
> +
> +=09/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
> +=09memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
> +
> +=09nr_pages =3D alloc_pages_bulk_array(gfp, bulk, pool->alloc.cache);
> +=09if (unlikely(!nr_pages))
> +=09=09return NULL;
> +
> +=09/* Pages have been filled into alloc.cache array, but count is zero a=
nd
> +=09 * page element have not been (possibly) DMA mapped.
> +=09 */
> +=09for (i =3D 0; i < nr_pages; i++) {
> +=09=09page =3D pool->alloc.cache[i];
> +=09=09if ((pp_flags & PP_FLAG_DMA_MAP) &&
> +=09=09    unlikely(!page_pool_dma_map(pool, page))) {
> +=09=09=09put_page(page);
> +=09=09=09continue;
> +=09=09}
> +=09=09pool->alloc.cache[pool->alloc.count++] =3D page;
> +=09=09/* Track how many pages are held 'in-flight' */
> +=09=09pool->pages_state_hold_cnt++;
> +=09=09trace_page_pool_state_hold(pool, page,
> +=09=09=09=09=09   pool->pages_state_hold_cnt);
> +=09}
> +
> +=09/* Return last page */
> +=09if (likely(pool->alloc.count > 0))
> +=09=09page =3D pool->alloc.cache[--pool->alloc.count];
> +=09else
> +=09=09page =3D NULL;
>
>  =09/* When page just alloc'ed is should/must have refcnt 1. */
>  =09return page;
> --
> 2.26.2

Al

