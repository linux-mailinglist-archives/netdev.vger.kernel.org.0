Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F54D33FB16
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhCQWZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:25:51 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:45339 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhCQWZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 18:25:30 -0400
Date:   Wed, 17 Mar 2021 22:25:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616019928; bh=5n1xnqSMFADL1/lMD7qStSm5B6KLSEf5T3JUcTW1bsY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=biwV2HLcM/lhcnM9SIzEGveA/OmmawFLe2izpoqh/Gf6KgxJXs4y6+W3ds+y0G6Q2
         TCyzuC+8sxYNqryLGBGD8uGKOyPB3jx02wpAyCTIX5oxHy2XhIdXIAgqobUi4Jrj55
         tfE0cMC8e1YjDOUEnPnCQOpHpvrRJiM77azXOp03/boZXTWrrByZp0RLP4iRzQwZAw
         cLyFPKvk+OzXAy51wytOZN2R5AhfdIQBCk4J27iX15Uzoy/0ZfJn8RTav1ajA0PbVe
         59PLXrSpjoxeIVtn0WHzB7tRvQ9zbF18GHSGCqylh5ADZ5eqhMENY+WzsXwz2LtoON
         NbS+Orj8kTxAg==
To:     Jesper Dangaard Brouer <brouer@redhat.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH 0/7 v4] Introduce a bulk order-0 page allocator with two in-tree users
Message-ID: <20210317222506.1266004-1-alobakin@pm.me>
In-Reply-To: <20210317181943.1a339b1e@carbon>
References: <20210312154331.32229-1-mgorman@techsingularity.net> <20210317163055.800210-1-alobakin@pm.me> <20210317173844.6b10f879@carbon> <20210317165220.808975-1-alobakin@pm.me> <20210317181943.1a339b1e@carbon>
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
Date: Wed, 17 Mar 2021 18:19:43 +0100

> On Wed, 17 Mar 2021 16:52:32 +0000
> Alexander Lobakin <alobakin@pm.me> wrote:
>
> > From: Jesper Dangaard Brouer <brouer@redhat.com>
> > Date: Wed, 17 Mar 2021 17:38:44 +0100
> >
> > > On Wed, 17 Mar 2021 16:31:07 +0000
> > > Alexander Lobakin <alobakin@pm.me> wrote:
> > >
> > > > From: Mel Gorman <mgorman@techsingularity.net>
> > > > Date: Fri, 12 Mar 2021 15:43:24 +0000
> > > >
> > > > Hi there,
> > > >
> > > > > This series is based on top of Matthew Wilcox's series "Rationali=
se
> > > > > __alloc_pages wrapper" and does not apply to 5.12-rc2. If you wan=
t to
> > > > > test and are not using Andrew's tree as a baseline, I suggest usi=
ng the
> > > > > following git tree
> > > > >
> > > > > git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bu=
lk-rebase-v4r2
> > > >
> > > > I gave this series a go on my setup, it showed a bump of 10 Mbps on
> > > > UDP forwarding, but dropped TCP forwarding by almost 50 Mbps.
> > > >
> > > > (4 core 1.2GHz MIPS32 R2, page size of 16 Kb, Page Pool order-0
> > > > allocations with MTU of 1508 bytes, linear frames via build_skb(),
> > > > GRO + TSO/USO)
> > >
> > > What NIC driver is this?
> >
> > Ah, forgot to mention. It's a WIP driver, not yet mainlined.
> > The NIC itself is basically on-SoC 1G chip.
>
> Hmm, then it is really hard to check if your driver is doing something
> else that could cause this.
>
> Well, can you try to lower the page_pool bulking size, to test the
> theory from Wilcox that we should do smaller bulking to avoid pushing
> cachelines into L2 when walking the LRU list.  You might have to go as
> low as bulk=3D8 (for N-way associative level of L1 cache).

Turned out it suffered from GCC's decisions.
All of the following was taken on GCC 10.2.0 with -O2 in dotconfig.

vmlinux differences between baseline and this series:

(I used your followup instead of the last patch from the tree)

Function                                     old     new   delta
__rmqueue_pcplist                              -    2024   +2024
__alloc_pages_bulk                             -    1456   +1456
__page_pool_alloc_pages_slow                 284     600    +316
page_pool_dma_map                              -     164    +164
get_page_from_freelist                      5676    3760   -1916

The uninlining of __rmqueue_pcplist() hurts a lot. It slightly slows
down the "regular" page allocator, but makes __alloc_pages_bulk()
much slower than the per-page (in my case at least) due to calling
this function out from the loop.

One possible solution is to mark __rmqueue_pcplist() and
rmqueue_bulk() as __always_inline. Only both and only with
__always_inline, or GCC will emit rmqueue_bulk.constprop and
make the numbers even poorer.
This nearly doubles the size of bulk allocator, but eliminates
all performance hits.

Function                                     old     new   delta
__alloc_pages_bulk                          1456    3512   +2056
get_page_from_freelist                      3760    5744   +1984
find_suitable_fallback.part                    -     160    +160
min_free_kbytes_sysctl_handler                96     128     +32
find_suitable_fallback                       164      28    -136
__rmqueue_pcplist                           2024       -   -2024

Between baseline and this series with __always_inline hints:

Function                                     old     new   delta
__alloc_pages_bulk                             -    3512   +3512
find_suitable_fallback.part                    -     160    +160
get_page_from_freelist                      5676    5744     +68
min_free_kbytes_sysctl_handler                96     128     +32
find_suitable_fallback                       164      28    -136

Another suboptimal place I've found is two functions in Page Pool
code which are marked as 'noinline'.
Maybe there's a reason behind this, but removing the annotations
and additionally marking page_pool_dma_map() as inline simplifies
the object code and in fact improves the performance (+15 Mbps on
my setup):

add/remove: 0/3 grow/shrink: 1/0 up/down: 1024/-1096 (-72)
Function                                     old     new   delta
page_pool_alloc_pages                        100    1124   +1024
page_pool_dma_map                            164       -    -164
page_pool_refill_alloc_cache                 332       -    -332
__page_pool_alloc_pages_slow                 600       -    -600

1124 is a normal size for a hotpath function.
These fragmentation and jumps between page_pool_alloc_pages(),
__page_pool_alloc_pages_slow() and page_pool_refill_alloc_cache()
are really excessive and unhealthy for performance, as well as
page_pool_dma_map() uninlined by GCC.

So the best results I got so far were with these additional changes:
 - mark __rmqueue_pcplist() as __always_inline;
 - mark rmqueue_bulk() as __always_inline;
 - drop 'noinline' from page_pool_refill_alloc_cache();
 - drop 'noinline' from __page_pool_alloc_pages_slow();
 - mark page_pool_dma_map() as inline.

(inlines in C files aren't generally recommended, but well, GCC
 is far from perfect)

> In function: __page_pool_alloc_pages_slow() adjust variable:
>   const int bulk =3D PP_ALLOC_CACHE_REFILL;

Regarding bulk size, it makes no sense on my machine. I tried
{ 8, 16, 32, 64 } and they differed by 1-2 Mbps max / standard
deviation.
Most of the bulk operations I've seen usually take the value of
16 as a "golden ratio" though.

>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

Thanks,
Al

