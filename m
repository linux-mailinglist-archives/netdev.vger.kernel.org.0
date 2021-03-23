Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCBF346397
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 16:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhCWPhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 11:37:02 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:32335 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbhCWPgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 11:36:39 -0400
Date:   Tue, 23 Mar 2021 15:36:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616513797; bh=VPaqe8915pdFK+AwSOCui0k7CQEqtVBCRR5LPLrf8Oc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=IQRH/WvJzcYKFJnm1oknwYeEKw6/RpGLt8fhrZOh1AJJfC6R4QtrhHARYICHwKAfK
         9ob4Jia0HqqiQDBOf0/tKLhGO1da5CPsBXSyLAWVSdJCE7X3YTXAYYXjjwhX99iuv1
         tDYQ3acaaQX4mfzLd2UzLQgilEmZN0jcVgwZNRALfrmVa5QNEdMTO1WNbqTuofqr+M
         3BZ0n7bW2sHr+2wZR222xgLQbDhFPdIz9xGQoBb/Hv/S5r5P9lQzDeiVZS2AnKv2f6
         3siMeKUbYDYHowRAQ8AerdVfPhg6NUoiDmBnXe1INE8atzj/DQnK9H/JGYvyQjrx9U
         Gq6mIz4N/5aew==
To:     Jesper Dangaard Brouer <brouer@redhat.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next] page_pool: let the compiler optimize and inline core functions
Message-ID: <20210323153550.130385-1-alobakin@pm.me>
In-Reply-To: <20210323100138.791a77ce@carbon>
References: <20210322183047.10768-1-alobakin@pm.me> <20210323100138.791a77ce@carbon>
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

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Tue, 23 Mar 2021 10:01:38 +0100

> On Mon, 22 Mar 2021 18:30:55 +0000
> Alexander Lobakin <alobakin@pm.me> wrote:
>
> > As per disscussion in Page Pool bulk allocator thread [0],
> > there are two functions in Page Pool core code that are marked as
> > 'noinline'. The reason for this is not so clear, and even if it
> > was made to reduce hotpath overhead, in fact it only makes things
> > worse.
> > As both of these functions as being called only once through the
> > code, they could be inlined/folded into the non-static entry point.
> > However, 'noinline' marks effectively prevent from doing that and
> > induce totally unneeded fragmentation (baseline -> after removal):
> >
> > add/remove: 0/3 grow/shrink: 1/0 up/down: 1024/-1096 (-72)
> > Function                                     old     new   delta
> > page_pool_alloc_pages                        100    1124   +1024
> > page_pool_dma_map                            164       -    -164
> > page_pool_refill_alloc_cache                 332       -    -332
> > __page_pool_alloc_pages_slow                 600       -    -600
> >
> > (taken from Mel's branch, hence factored-out page_pool_dma_map())
>
> I see that the refactor of page_pool_dma_map() caused it to be
> uninlined, that were a mistake.  Thanks for high-lighting that again
> as I forgot about this (even-though I think Alex Duyck did point this
> out earlier).
>
> I am considering if we should allow compiler to inline
> page_pool_refill_alloc_cache + __page_pool_alloc_pages_slow, for the
> sake of performance and I loose the ability to diagnose the behavior
> from perf-report.  Mind that page_pool avoids stat for the sake of
> performance, but these noinline makes it possible to diagnose the
> behavior anyway.
>
> >
> > 1124 is a normal hotpath frame size, but these jumps between tiny
> > page_pool_alloc_pages(), page_pool_refill_alloc_cache() and
> > __page_pool_alloc_pages_slow() are really redundant and harmful
> > for performance.
>
> Well, I disagree. (this is a NACK)
>
> If pages were recycled then the code never had to visit
> __page_pool_alloc_pages_slow().  And today without the bulk page-alloc
> (that we are working on adding together with Mel) we have to visit
> __page_pool_alloc_pages_slow() every time, which is a bad design, but
> I'm trying to fix that.
>
> Matteo is working on recycling here[1]:
>  [1] https://lore.kernel.org/netdev/20210322170301.26017-1-mcroce@linux.m=
icrosoft.com/
>
> It would be really great if you could try out his patchset, as it will
> help your driver avoid the slow path of the page_pool.  Given you are
> very detailed oriented, I do want to point out that Matteo's patchset
> is only the first step, as to really improve performance for page_pool,
> we need to bulk return these page_pool pages (it is requires some
> restructure of the core code, that will be confusing at this point).

I tested it out when I saw the first RFC. Its code seemed fine to me
and I was wondering what could it bring to my workloads.
The reason why I didn't post the results is because they're actually
poor on my system.

I retested it again, this time v1 instead of RFC and also tried
the combined with bulk allocation variant.

VLAN NAT, GRO + TSO/USO, Page size 16 Kb.
XDP_PASS -> napi_build_skb() -> napi_gro_receive().

I disable fraglist offload and nftables Flow offload to drop
the performance below link speed.

1.
 - 5.12-rc3:

TCP=09572 Mbps
UDP=09616 Mbps

2.
 - 5.12-rc3;
 - Page Pool recycling by Matteo (with replacing
   page_pool_release_page() with skb_mark_for_recycle()
   in my driver):

TCP=09540 Mbps
UDP=09572 Mbps

First time when I saw the results, I didn't believe everything works
as expected from the code I saw, and pages are actually being recycled.
But then I traced skb and pages' paths and made sure that recycling
actually happens (on every frame).
The reason for such a heavy drop, at least that I can guess, is that
page_frag_free() that's being called on skb->head and its frags is
very lightweight and straightforward. When recycling is on, the
following chain is being called for skb head and every frag:

page_pool_return_skb_page()
 xdp_return_skb_frame()
  __xdp_return()
   page_pool_put_full_page()

Also, as allow_direct is false (which is fine -- for context safety
reasons), recycled pages are being returned into the ptr_ring (with
taking and freeing the spinlock) instead of the direct cache. So next
Page Pool allocations will inavoidably hit (noinline)
page_pool_refill_alloc_cache(), take the spinlock again and so on.

3.
 - 5.12-rc3;
 - Page Pool recycling;
 - bulk allocations:

TCP=09545 Mbps
UDP=09610 Mbps

As I wrote earlier, bulk allocator suffers from compiler which
uninlines __rmqueue_pcplist() and rmqueue_bulk(), at least on
my board.
So I don't take these results into account at all, instead:

4.
 - 5.12-rc3;
 - Page Pool recycling;
 - bulk allocations with
 - marking __rmqueue_pcplist() and rmqueue_bulk() as __always_inline:

TCP=09590 Mbps
UDP=09635 Mbps

I think here we finally hit the point where bulk allocations and
page recycling (perhaps partially) come in.
And just for reference:

5.
 - 5.12-rc3;
 - Page Pool recycling;
 - bulk allocations, with
 - marking __rmqueue_pcplist() and rmqueue_bulk() as __always_inline
   and also
 - dropping 'noinline' mark from page_pool_refill_alloc_cache() and
   __page_pool_alloc_pages_slow():

TCP=09595 Mbps
UDP=09650 Mbps

 - PP recycling always stores recycled pages in ptr_ring, so
   page_pool_refill_alloc_cache() is still on the hotpath;
 - bulk allocator places new pages into direct cache, but it
   hides inside __page_pool_alloc_pages_slow().

>
> > This simple removal of 'noinline' keywords bumps the throughput
> > on XDP_PASS + napi_build_skb() + napi_gro_receive() on 25+ Mbps
> > for 1G embedded NIC.
> >
> > [0] https://lore.kernel.org/netdev/20210317222506.1266004-1-alobakin@pm=
.me
> >
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  net/core/page_pool.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index ad8b0707af04..589e4df6ef2b 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -102,7 +102,6 @@ EXPORT_SYMBOL(page_pool_create);
> >
> >  static void page_pool_return_page(struct page_pool *pool, struct page =
*page);
> >
> > -noinline
> >  static struct page *page_pool_refill_alloc_cache(struct page_pool *poo=
l)
> >  {
> >  =09struct ptr_ring *r =3D &pool->ring;
> > @@ -181,7 +180,6 @@ static void page_pool_dma_sync_for_device(struct pa=
ge_pool *pool,
> >  }
> >
> >  /* slow path */
> > -noinline
> >  static struct page *__page_pool_alloc_pages_slow(struct page_pool *poo=
l,
> >  =09=09=09=09=09=09 gfp_t _gfp)
> >  {
> > --
> > 2.31.0
> >
> >
>
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

Thanks,
Al

