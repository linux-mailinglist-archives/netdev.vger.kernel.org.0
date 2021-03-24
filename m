Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326D3347794
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 12:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhCXLmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 07:42:40 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:41067 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhCXLmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 07:42:32 -0400
Date:   Wed, 24 Mar 2021 11:42:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616586135; bh=iAg3e2S/SIIqfMztGYOAyklPoK/Ma1o4j6PXJdfhC8I=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=hKRi7c27vm6w5WiPPi0nM4g0Z8Owpa6SayoShEUe4m52EWFmLaQlkkupm3Ce2KQns
         fhUU8Jn1Zd93TzcS4HKK3Hrx3PT6HPus3ql67jnDgkyFqMj0dUY1naX6e3LaTYgHKE
         UF0J4TJKDz+Am1Z3JAJsa0GfFHBRVxtyuUD+3vJPuJVIPkFDmxiCnCwB8eLp/pkhdz
         i5W9Hz7piBak6tg1AJAxPhjrF42CWZ4vElQjQy34DNfT041xxTH5IiE7sBS6MwFZr+
         3x8Jdt0vqRwF+WX54hygQAUrJK24PcHxnq+jwgo44/HSvBz6WpTXXN5VgPy5W13RN8
         Y3wO8eRZ+yRZA==
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
Message-ID: <20210324114158.3433-1-alobakin@pm.me>
In-Reply-To: <YFrvTtS8E/C5vYgo@enceladus>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com> <20210323154112.131110-1-alobakin@pm.me> <YFoNoohTULmcpeCr@enceladus> <20210323170447.78d65d05@carbon> <YFoTBm0mJ4GyuHb6@enceladus> <CAFnufp1K+t76n9shfOZB_scV7myUWCTXbB+yf5sr-8ORYQxCEQ@mail.gmail.com> <20210323165523.187134-1-alobakin@pm.me> <YFofANKiR3tD9zgm@enceladus> <20210323200338.578264-1-alobakin@pm.me> <YFrvTtS8E/C5vYgo@enceladus>
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
Date: Wed, 24 Mar 2021 09:50:38 +0200

> Hi Alexander,

Hi!

> On Tue, Mar 23, 2021 at 08:03:46PM +0000, Alexander Lobakin wrote:
> > From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > Date: Tue, 23 Mar 2021 19:01:52 +0200
> >
> > > On Tue, Mar 23, 2021 at 04:55:31PM +0000, Alexander Lobakin wrote:
> > > > > > > > >
> > >
> > > [...]
> > >
> > > > > > > >
> > > > > > > > Thanks for the testing!
> > > > > > > > Any chance you can get a perf measurement on this?
> > > > > > >
> > > > > > > I guess you mean perf-report (--stdio) output, right?
> > > > > > >
> > > > > >
> > > > > > Yea,
> > > > > > As hinted below, I am just trying to figure out if on Alexander=
's platform the
> > > > > > cost of syncing, is bigger that free-allocate. I remember one a=
rmv7 were that
> > > > > > was the case.
> > > > > >
> > > > > > > > Is DMA syncing taking a substantial amount of your cpu usag=
e?
> > > > > > >
> > > > > > > (+1 this is an important question)
> > > >
> > > > Sure, I'll drop perf tools to my test env and share the results,
> > > > maybe tomorrow or in a few days.
> >
> > Oh we-e-e-ell...
> > Looks like I've been fooled by I-cache misses or smth like that.
> > That happens sometimes, not only on my machines, and not only on
> > MIPS if I'm not mistaken.
> > Sorry for confusing you guys.
> >
> > I got drastically different numbers after I enabled CONFIG_KALLSYMS +
> > CONFIG_PERF_EVENTS for perf tools.
> > The only difference in code is that I rebased onto Mel's
> > mm-bulk-rebase-v6r4.
> >
> > (lunar is my WIP NIC driver)
> >
> > 1. 5.12-rc3 baseline:
> >
> > TCP: 566 Mbps
> > UDP: 615 Mbps
> >
> > perf top:
> >      4.44%  [lunar]              [k] lunar_rx_poll_page_pool
> >      3.56%  [kernel]             [k] r4k_wait_irqoff
> >      2.89%  [kernel]             [k] free_unref_page
> >      2.57%  [kernel]             [k] dma_map_page_attrs
> >      2.32%  [kernel]             [k] get_page_from_freelist
> >      2.28%  [lunar]              [k] lunar_start_xmit
> >      1.82%  [kernel]             [k] __copy_user
> >      1.75%  [kernel]             [k] dev_gro_receive
> >      1.52%  [kernel]             [k] cpuidle_enter_state_coupled
> >      1.46%  [kernel]             [k] tcp_gro_receive
> >      1.35%  [kernel]             [k] __rmemcpy
> >      1.33%  [nf_conntrack]       [k] nf_conntrack_tcp_packet
> >      1.30%  [kernel]             [k] __dev_queue_xmit
> >      1.22%  [kernel]             [k] pfifo_fast_dequeue
> >      1.17%  [kernel]             [k] skb_release_data
> >      1.17%  [kernel]             [k] skb_segment
> >
> > free_unref_page() and get_page_from_freelist() consume a lot.
> >
> > 2. 5.12-rc3 + Page Pool recycling by Matteo:
> > TCP: 589 Mbps
> > UDP: 633 Mbps
> >
> > perf top:
> >      4.27%  [lunar]              [k] lunar_rx_poll_page_pool
> >      2.68%  [lunar]              [k] lunar_start_xmit
> >      2.41%  [kernel]             [k] dma_map_page_attrs
> >      1.92%  [kernel]             [k] r4k_wait_irqoff
> >      1.89%  [kernel]             [k] __copy_user
> >      1.62%  [kernel]             [k] dev_gro_receive
> >      1.51%  [kernel]             [k] cpuidle_enter_state_coupled
> >      1.44%  [kernel]             [k] tcp_gro_receive
> >      1.40%  [kernel]             [k] __rmemcpy
> >      1.38%  [nf_conntrack]       [k] nf_conntrack_tcp_packet
> >      1.37%  [kernel]             [k] free_unref_page
> >      1.35%  [kernel]             [k] __dev_queue_xmit
> >      1.30%  [kernel]             [k] skb_segment
> >      1.28%  [kernel]             [k] get_page_from_freelist
> >      1.27%  [kernel]             [k] r4k_dma_cache_inv
> >
> > +20 Mbps increase on both TCP and UDP. free_unref_page() and
> > get_page_from_freelist() dropped down the list significantly.
> >
> > 3. 5.12-rc3 + Page Pool recycling + PP bulk allocator (Mel & Jesper):
> > TCP: 596
> > UDP: 641
> >
> > perf top:
> >      4.38%  [lunar]              [k] lunar_rx_poll_page_pool
> >      3.34%  [kernel]             [k] r4k_wait_irqoff
> >      3.14%  [kernel]             [k] dma_map_page_attrs
> >      2.49%  [lunar]              [k] lunar_start_xmit
> >      1.85%  [kernel]             [k] dev_gro_receive
> >      1.76%  [kernel]             [k] free_unref_page
> >      1.76%  [kernel]             [k] __copy_user
> >      1.65%  [kernel]             [k] inet_gro_receive
> >      1.57%  [kernel]             [k] tcp_gro_receive
> >      1.48%  [kernel]             [k] cpuidle_enter_state_coupled
> >      1.43%  [nf_conntrack]       [k] nf_conntrack_tcp_packet
> >      1.42%  [kernel]             [k] __rmemcpy
> >      1.25%  [kernel]             [k] skb_segment
> >      1.21%  [kernel]             [k] r4k_dma_cache_inv
> >
> > +10 Mbps on top of recycling.
> > get_page_from_freelist() is gone.
> > NAPI polling, CPU idle cycle (r4k_wait_irqoff) and DMA mapping
> > routine became the top consumers.
>
> Again, thanks for the extensive testing.
> I assume you dont use page pool to map the buffers right?
> Because if the ampping is preserved the only thing you have to do is sync=
 it
> after the packet reception

No, I use Page Pool for both DMA mapping and synching for device.
The reason why DMA mapping takes a lot of CPU is that I test NATing,
so NIC firstly receives the frames and then xmits them with modified
headers -> this DMA map overhead is from lunar_start_xmit(), not
Rx path.
The actual Rx synching is r4k_dma_cache_inv() and it's not that
expensive.

> >
> > 4-5. __always_inline for rmqueue_bulk() and __rmqueue_pcplist(),
> > removing 'noinline' from net/core/page_pool.c etc.
> >
> > ...makes absolutely no sense anymore.
> > I see Mel took Jesper's patch to make __rmqueue_pcplist() inline into
> > mm-bulk-rebase-v6r5, not sure if it's really needed now.
> >
> > So I'm really glad we sorted out the things and I can see the real
> > performance improvements from both recycling and bulk allocations.
> >
>
> Those will probably be even bigger with and io(sm)/mu present

Sure, DMA mapping is way more expensive through IOMMUs. I don't have
one on my boards, so can't collect any useful info.

> [...]
>
> Cheers
> /Ilias

Thanks,
Al

