Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B20346527
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhCWQ3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:29:37 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52298 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbhCWQ3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 12:29:09 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by linux.microsoft.com (Postfix) with ESMTPSA id 50D0D20B5684;
        Tue, 23 Mar 2021 09:29:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 50D0D20B5684
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616516949;
        bh=wWC5laX9IDoCEzRycyyox6gck/DlbB0qqaILtReIe6U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iPUPVcwmfeMhzq1717y6BGYGBREhAWaqdduP7d4jTpKVtV7/H1LEu3fWDh1tj97fD
         EzOFr41L/K7sPQ4k6l1bIfC8h+m+n2wiQ8akx1j9Gei1ev0QY4cwdRcEvgjt3GAN+4
         cVBtI+GtUiCejLxglJ5xKlArX1QLgS17MMB7jeaQ=
Received: by mail-pj1-f46.google.com with SMTP id t18so10305421pjs.3;
        Tue, 23 Mar 2021 09:29:09 -0700 (PDT)
X-Gm-Message-State: AOAM533CHoXVFEko43kX6Pj3KP+qarHUg5yqQpaIGOq0n7YJJ8BguPp/
        6RmmMMRGXDsQ66OweGtHARHevz3vyC8bj+Fhp80=
X-Google-Smtp-Source: ABdhPJzKNVedOi+ZW5BsUCPk7n1vLnsCXUlcFkk0/uFRDBsAS9TmrDgU5Gk7RN5Bmx35cH9o65pTPHJHYuPlBRoxuK4=
X-Received: by 2002:a17:90a:f190:: with SMTP id bv16mr5136541pjb.187.1616516948785;
 Tue, 23 Mar 2021 09:29:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
 <20210323154112.131110-1-alobakin@pm.me> <YFoNoohTULmcpeCr@enceladus>
 <20210323170447.78d65d05@carbon> <YFoTBm0mJ4GyuHb6@enceladus>
In-Reply-To: <YFoTBm0mJ4GyuHb6@enceladus>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Tue, 23 Mar 2021 17:28:32 +0100
X-Gmail-Original-Message-ID: <CAFnufp1K+t76n9shfOZB_scV7myUWCTXbB+yf5sr-8ORYQxCEQ@mail.gmail.com>
Message-ID: <CAFnufp1K+t76n9shfOZB_scV7myUWCTXbB+yf5sr-8ORYQxCEQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] page_pool: recycle buffers
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 5:10 PM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Tue, Mar 23, 2021 at 05:04:47PM +0100, Jesper Dangaard Brouer wrote:
> > On Tue, 23 Mar 2021 17:47:46 +0200
> > Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> >
> > > On Tue, Mar 23, 2021 at 03:41:23PM +0000, Alexander Lobakin wrote:
> > > > From: Matteo Croce <mcroce@linux.microsoft.com>
> > > > Date: Mon, 22 Mar 2021 18:02:55 +0100
> > > >
> > > > > From: Matteo Croce <mcroce@microsoft.com>
> > > > >
> > > > > This series enables recycling of the buffers allocated with the page_pool API.
> > > > > The first two patches are just prerequisite to save space in a struct and
> > > > > avoid recycling pages allocated with other API.
> > > > > Patch 2 was based on a previous idea from Jonathan Lemon.
> > > > >
> > > > > The third one is the real recycling, 4 fixes the compilation of __skb_frag_unref
> > > > > users, and 5,6 enable the recycling on two drivers.
> > > > >
> > > > > In the last two patches I reported the improvement I have with the series.
> > > > >
> > > > > The recycling as is can't be used with drivers like mlx5 which do page split,
> > > > > but this is documented in a comment.
> > > > > In the future, a refcount can be used so to support mlx5 with no changes.
> > > > >
> > > > > Ilias Apalodimas (2):
> > > > >   page_pool: DMA handling and allow to recycles frames via SKB
> > > > >   net: change users of __skb_frag_unref() and add an extra argument
> > > > >
> > > > > Jesper Dangaard Brouer (1):
> > > > >   xdp: reduce size of struct xdp_mem_info
> > > > >
> > > > > Matteo Croce (3):
> > > > >   mm: add a signature in struct page
> > > > >   mvpp2: recycle buffers
> > > > >   mvneta: recycle buffers
> > > > >
> > > > >  .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  2 +-
> > > > >  drivers/net/ethernet/marvell/mvneta.c         |  4 +-
> > > > >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 17 +++----
> > > > >  drivers/net/ethernet/marvell/sky2.c           |  2 +-
> > > > >  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
> > > > >  include/linux/mm_types.h                      |  1 +
> > > > >  include/linux/skbuff.h                        | 33 +++++++++++--
> > > > >  include/net/page_pool.h                       | 15 ++++++
> > > > >  include/net/xdp.h                             |  5 +-
> > > > >  net/core/page_pool.c                          | 47 +++++++++++++++++++
> > > > >  net/core/skbuff.c                             | 20 +++++++-
> > > > >  net/core/xdp.c                                | 14 ++++--
> > > > >  net/tls/tls_device.c                          |  2 +-
> > > > >  13 files changed, 138 insertions(+), 26 deletions(-)
> > > >
> > > > Just for the reference, I've performed some tests on 1G SoC NIC with
> > > > this patchset on, here's direct link: [0]
> > > >
> > >
> > > Thanks for the testing!
> > > Any chance you can get a perf measurement on this?
> >
> > I guess you mean perf-report (--stdio) output, right?
> >
>
> Yea,
> As hinted below, I am just trying to figure out if on Alexander's platform the
> cost of syncing, is bigger that free-allocate. I remember one armv7 were that
> was the case.
>
> > > Is DMA syncing taking a substantial amount of your cpu usage?
> >
> > (+1 this is an important question)
> >
> > > >
> > > > [0] https://lore.kernel.org/netdev/20210323153550.130385-1-alobakin@pm.me
> > > >
> >

That would be the same as for mvneta:

Overhead  Shared Object     Symbol
  24.10%  [kernel]          [k] __pi___inval_dcache_area
  23.02%  [mvneta]          [k] mvneta_rx_swbm
   7.19%  [kernel]          [k] kmem_cache_alloc

Anyway, I tried to use the recycling *and* napi_build_skb on mvpp2,
and I get lower packet rate than recycling alone.
I don't know why, we should investigate it.

Regards,
-- 
per aspera ad upstream
