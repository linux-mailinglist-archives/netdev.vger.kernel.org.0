Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9483465BD
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhCWQzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:55:47 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:14862 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbhCWQzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 12:55:39 -0400
Date:   Tue, 23 Mar 2021 16:55:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616518537; bh=40YUHvnaoKlsOCx6BeoTLExdKdZj3udCVf35HyR4k7Y=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=bpA98RHgt3ozThgVr/Wb9S632VILvu7pvygpXX7MABqSr7m5cQrKZAa2NrjLI2GFW
         2L56FZuSBWuWZZt6d1nqIQZcrvl3isWy50qQ+xWPVLjjL7sU76jLIHNgbX6dL2bI9h
         2xorZs5QN87+itaEitK8YmOaIMhoimw1aR4JW371fc7s9pRMtKo0ZmEhd320PucdPv
         74wL9/ZGgD+/Xo8ddN1P5LxSrIfOQLc2eQLl6FQPe6y/Z3bkhTQObKTOJSparcTLNj
         36hEftlWtqYm+NjpmZswPiqiESdKoQm8LwB7Q9uMVpQAtjBpZ6LJC0S9kPCuOpqKXw
         KfHviNMEVJAug==
To:     Matteo Croce <mcroce@linux.microsoft.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
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
Message-ID: <20210323165523.187134-1-alobakin@pm.me>
In-Reply-To: <CAFnufp1K+t76n9shfOZB_scV7myUWCTXbB+yf5sr-8ORYQxCEQ@mail.gmail.com>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com> <20210323154112.131110-1-alobakin@pm.me> <YFoNoohTULmcpeCr@enceladus> <20210323170447.78d65d05@carbon> <YFoTBm0mJ4GyuHb6@enceladus> <CAFnufp1K+t76n9shfOZB_scV7myUWCTXbB+yf5sr-8ORYQxCEQ@mail.gmail.com>
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

From: Matteo Croce <mcroce@linux.microsoft.com>
Date: Tue, 23 Mar 2021 17:28:32 +0100

> On Tue, Mar 23, 2021 at 5:10 PM Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > On Tue, Mar 23, 2021 at 05:04:47PM +0100, Jesper Dangaard Brouer wrote:
> > > On Tue, 23 Mar 2021 17:47:46 +0200
> > > Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> > >
> > > > On Tue, Mar 23, 2021 at 03:41:23PM +0000, Alexander Lobakin wrote:
> > > > > From: Matteo Croce <mcroce@linux.microsoft.com>
> > > > > Date: Mon, 22 Mar 2021 18:02:55 +0100
> > > > >
> > > > > > From: Matteo Croce <mcroce@microsoft.com>
> > > > > >
> > > > > > This series enables recycling of the buffers allocated with the=
 page_pool API.
> > > > > > The first two patches are just prerequisite to save space in a =
struct and
> > > > > > avoid recycling pages allocated with other API.
> > > > > > Patch 2 was based on a previous idea from Jonathan Lemon.
> > > > > >
> > > > > > The third one is the real recycling, 4 fixes the compilation of=
 __skb_frag_unref
> > > > > > users, and 5,6 enable the recycling on two drivers.
> > > > > >
> > > > > > In the last two patches I reported the improvement I have with =
the series.
> > > > > >
> > > > > > The recycling as is can't be used with drivers like mlx5 which =
do page split,
> > > > > > but this is documented in a comment.
> > > > > > In the future, a refcount can be used so to support mlx5 with n=
o changes.
> > > > > >
> > > > > > Ilias Apalodimas (2):
> > > > > >   page_pool: DMA handling and allow to recycles frames via SKB
> > > > > >   net: change users of __skb_frag_unref() and add an extra argu=
ment
> > > > > >
> > > > > > Jesper Dangaard Brouer (1):
> > > > > >   xdp: reduce size of struct xdp_mem_info
> > > > > >
> > > > > > Matteo Croce (3):
> > > > > >   mm: add a signature in struct page
> > > > > >   mvpp2: recycle buffers
> > > > > >   mvneta: recycle buffers
> > > > > >
> > > > > >  .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  2 +-
> > > > > >  drivers/net/ethernet/marvell/mvneta.c         |  4 +-
> > > > > >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 17 +++----
> > > > > >  drivers/net/ethernet/marvell/sky2.c           |  2 +-
> > > > > >  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
> > > > > >  include/linux/mm_types.h                      |  1 +
> > > > > >  include/linux/skbuff.h                        | 33 +++++++++++=
--
> > > > > >  include/net/page_pool.h                       | 15 ++++++
> > > > > >  include/net/xdp.h                             |  5 +-
> > > > > >  net/core/page_pool.c                          | 47 +++++++++++=
++++++++
> > > > > >  net/core/skbuff.c                             | 20 +++++++-
> > > > > >  net/core/xdp.c                                | 14 ++++--
> > > > > >  net/tls/tls_device.c                          |  2 +-
> > > > > >  13 files changed, 138 insertions(+), 26 deletions(-)
> > > > >
> > > > > Just for the reference, I've performed some tests on 1G SoC NIC w=
ith
> > > > > this patchset on, here's direct link: [0]
> > > > >
> > > >
> > > > Thanks for the testing!
> > > > Any chance you can get a perf measurement on this?
> > >
> > > I guess you mean perf-report (--stdio) output, right?
> > >
> >
> > Yea,
> > As hinted below, I am just trying to figure out if on Alexander's platf=
orm the
> > cost of syncing, is bigger that free-allocate. I remember one armv7 wer=
e that
> > was the case.
> >
> > > > Is DMA syncing taking a substantial amount of your cpu usage?
> > >
> > > (+1 this is an important question)

Sure, I'll drop perf tools to my test env and share the results,
maybe tomorrow or in a few days.
From what I know for sure about MIPS and my platform,
post-Rx synching (dma_sync_single_for_cpu()) is a no-op, and
pre-Rx (dma_sync_single_for_device() etc.) is a bit expensive.
I always have sane page_pool->pp.max_len value (smth about 1668
for MTU of 1500) to minimize the overhead.

By the word, IIRC, all machines shipped with mvpp2 have hardware
cache coherency units and don't suffer from sync routines at all.
That may be the reason why mvpp2 wins the most from this series.

> > > > >
> > > > > [0] https://lore.kernel.org/netdev/20210323153550.130385-1-alobak=
in@pm.me
> > > > >
> > >
>
> That would be the same as for mvneta:
>
> Overhead  Shared Object     Symbol
>   24.10%  [kernel]          [k] __pi___inval_dcache_area
>   23.02%  [mvneta]          [k] mvneta_rx_swbm
>    7.19%  [kernel]          [k] kmem_cache_alloc
>
> Anyway, I tried to use the recycling *and* napi_build_skb on mvpp2,
> and I get lower packet rate than recycling alone.
> I don't know why, we should investigate it.

mvpp2 driver doesn't use napi_consume_skb() on its Tx completion path.
As a result, NAPI percpu caches get refilled only through
kmem_cache_alloc_bulk(), and most of skbuff_head recycling
doesn't work.

> Regards,
> --
> per aspera ad upstream

Oh, I love that one!

Al

