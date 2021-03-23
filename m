Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACDE346986
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 21:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhCWUEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 16:04:24 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:14096 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhCWUDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 16:03:52 -0400
Date:   Tue, 23 Mar 2021 20:03:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616529830; bh=KzQfT9TlC/HL+PAaYny121WxluMck+pIoVeudAPRlxs=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=XxMdhfeHie96mRVGyP/C8uaM55wnnyIASJEQ+hp8QHascdyICmoiYUh1wI8P24IK8
         wqKEOFUlU4lrvSX1lsK3fugyI26dF70RSaLbcTrA7Pfl1qmISXUoa0uz+csTPZfAaH
         P61buRnQ06GwQMZ4Bihhr8S46Kr97+LA+0g88bXxqwfHcXG7+/LzO5LICChnNmPd8R
         G/P5KVhqRiTvsqWvykYHjEiG3/xyRypYsf+G91g8OhhpA5PU4iatgMN4cqqYtxC97L
         bURkxvT7FpCjVe3zUoEBx0r4K0M2WGC6r1jpsp6rfHDt14g+gbj8/kfHNiAd8X5uNX
         8vDC5MNhJJQvw==
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next 0/6] page_pool: recycle buffers
Message-ID: <20210323200338.578264-1-alobakin@pm.me>
In-Reply-To: <YFofANKiR3tD9zgm@enceladus>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com> <20210323154112.131110-1-alobakin@pm.me> <YFoNoohTULmcpeCr@enceladus> <20210323170447.78d65d05@carbon> <YFoTBm0mJ4GyuHb6@enceladus> <CAFnufp1K+t76n9shfOZB_scV7myUWCTXbB+yf5sr-8ORYQxCEQ@mail.gmail.com> <20210323165523.187134-1-alobakin@pm.me> <YFofANKiR3tD9zgm@enceladus>
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

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Tue, 23 Mar 2021 19:01:52 +0200

> On Tue, Mar 23, 2021 at 04:55:31PM +0000, Alexander Lobakin wrote:
> > > > > > >
>
> [...]
>
> > > > > >
> > > > > > Thanks for the testing!
> > > > > > Any chance you can get a perf measurement on this?
> > > > >
> > > > > I guess you mean perf-report (--stdio) output, right?
> > > > >
> > > >
> > > > Yea,
> > > > As hinted below, I am just trying to figure out if on Alexander's p=
latform the
> > > > cost of syncing, is bigger that free-allocate. I remember one armv7=
 were that
> > > > was the case.
> > > >
> > > > > > Is DMA syncing taking a substantial amount of your cpu usage?
> > > > >
> > > > > (+1 this is an important question)
> >
> > Sure, I'll drop perf tools to my test env and share the results,
> > maybe tomorrow or in a few days.

Oh we-e-e-ell...
Looks like I've been fooled by I-cache misses or smth like that.
That happens sometimes, not only on my machines, and not only on
MIPS if I'm not mistaken.
Sorry for confusing you guys.

I got drastically different numbers after I enabled CONFIG_KALLSYMS +
CONFIG_PERF_EVENTS for perf tools.
The only difference in code is that I rebased onto Mel's
mm-bulk-rebase-v6r4.

(lunar is my WIP NIC driver)

1. 5.12-rc3 baseline:

TCP: 566 Mbps
UDP: 615 Mbps

perf top:
     4.44%  [lunar]              [k] lunar_rx_poll_page_pool
     3.56%  [kernel]             [k] r4k_wait_irqoff
     2.89%  [kernel]             [k] free_unref_page
     2.57%  [kernel]             [k] dma_map_page_attrs
     2.32%  [kernel]             [k] get_page_from_freelist
     2.28%  [lunar]              [k] lunar_start_xmit
     1.82%  [kernel]             [k] __copy_user
     1.75%  [kernel]             [k] dev_gro_receive
     1.52%  [kernel]             [k] cpuidle_enter_state_coupled
     1.46%  [kernel]             [k] tcp_gro_receive
     1.35%  [kernel]             [k] __rmemcpy
     1.33%  [nf_conntrack]       [k] nf_conntrack_tcp_packet
     1.30%  [kernel]             [k] __dev_queue_xmit
     1.22%  [kernel]             [k] pfifo_fast_dequeue
     1.17%  [kernel]             [k] skb_release_data
     1.17%  [kernel]             [k] skb_segment

free_unref_page() and get_page_from_freelist() consume a lot.

2. 5.12-rc3 + Page Pool recycling by Matteo:
TCP: 589 Mbps
UDP: 633 Mbps

perf top:
     4.27%  [lunar]              [k] lunar_rx_poll_page_pool
     2.68%  [lunar]              [k] lunar_start_xmit
     2.41%  [kernel]             [k] dma_map_page_attrs
     1.92%  [kernel]             [k] r4k_wait_irqoff
     1.89%  [kernel]             [k] __copy_user
     1.62%  [kernel]             [k] dev_gro_receive
     1.51%  [kernel]             [k] cpuidle_enter_state_coupled
     1.44%  [kernel]             [k] tcp_gro_receive
     1.40%  [kernel]             [k] __rmemcpy
     1.38%  [nf_conntrack]       [k] nf_conntrack_tcp_packet
     1.37%  [kernel]             [k] free_unref_page
     1.35%  [kernel]             [k] __dev_queue_xmit
     1.30%  [kernel]             [k] skb_segment
     1.28%  [kernel]             [k] get_page_from_freelist
     1.27%  [kernel]             [k] r4k_dma_cache_inv

+20 Mbps increase on both TCP and UDP. free_unref_page() and
get_page_from_freelist() dropped down the list significantly.

3. 5.12-rc3 + Page Pool recycling + PP bulk allocator (Mel & Jesper):
TCP: 596
UDP: 641

perf top:
     4.38%  [lunar]              [k] lunar_rx_poll_page_pool
     3.34%  [kernel]             [k] r4k_wait_irqoff
     3.14%  [kernel]             [k] dma_map_page_attrs
     2.49%  [lunar]              [k] lunar_start_xmit
     1.85%  [kernel]             [k] dev_gro_receive
     1.76%  [kernel]             [k] free_unref_page
     1.76%  [kernel]             [k] __copy_user
     1.65%  [kernel]             [k] inet_gro_receive
     1.57%  [kernel]             [k] tcp_gro_receive
     1.48%  [kernel]             [k] cpuidle_enter_state_coupled
     1.43%  [nf_conntrack]       [k] nf_conntrack_tcp_packet
     1.42%  [kernel]             [k] __rmemcpy
     1.25%  [kernel]             [k] skb_segment
     1.21%  [kernel]             [k] r4k_dma_cache_inv

+10 Mbps on top of recycling.
get_page_from_freelist() is gone.
NAPI polling, CPU idle cycle (r4k_wait_irqoff) and DMA mapping
routine became the top consumers.

4-5. __always_inline for rmqueue_bulk() and __rmqueue_pcplist(),
removing 'noinline' from net/core/page_pool.c etc.

...makes absolutely no sense anymore.
I see Mel took Jesper's patch to make __rmqueue_pcplist() inline into
mm-bulk-rebase-v6r5, not sure if it's really needed now.

So I'm really glad we sorted out the things and I can see the real
performance improvements from both recycling and bulk allocations.

> > From what I know for sure about MIPS and my platform,
> > post-Rx synching (dma_sync_single_for_cpu()) is a no-op, and
> > pre-Rx (dma_sync_single_for_device() etc.) is a bit expensive.
> > I always have sane page_pool->pp.max_len value (smth about 1668
> > for MTU of 1500) to minimize the overhead.
> >
> > By the word, IIRC, all machines shipped with mvpp2 have hardware
> > cache coherency units and don't suffer from sync routines at all.
> > That may be the reason why mvpp2 wins the most from this series.
>
> Yep exactly. It's also the reason why you explicitly have to opt-in using=
 the
> recycling (by marking the skb for it), instead of hiding the feature in t=
he
> page pool internals
>
> Cheers
> /Ilias
>
> >
> > > > > > >
> > > > > > > [0] https://lore.kernel.org/netdev/20210323153550.130385-1-al=
obakin@pm.me
> > > > > > >
> > > > >
> > >
> > > That would be the same as for mvneta:
> > >
> > > Overhead  Shared Object     Symbol
> > >   24.10%  [kernel]          [k] __pi___inval_dcache_area
> > >   23.02%  [mvneta]          [k] mvneta_rx_swbm
> > >    7.19%  [kernel]          [k] kmem_cache_alloc
> > >
> > > Anyway, I tried to use the recycling *and* napi_build_skb on mvpp2,
> > > and I get lower packet rate than recycling alone.
> > > I don't know why, we should investigate it.
> >
> > mvpp2 driver doesn't use napi_consume_skb() on its Tx completion path.
> > As a result, NAPI percpu caches get refilled only through
> > kmem_cache_alloc_bulk(), and most of skbuff_head recycling
> > doesn't work.
> >
> > > Regards,
> > > --
> > > per aspera ad upstream
> >
> > Oh, I love that one!
> >
> > Al
> >

Thanks,
Al

