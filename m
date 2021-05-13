Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45C1380102
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 01:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhEMXyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 19:54:46 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41922 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhEMXyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 19:54:46 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7CF4820B8016;
        Thu, 13 May 2021 16:53:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7CF4820B8016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620950015;
        bh=74exrwhdEAndba6EEggC6xPKpjQILxDdAehUL/iquxA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b+KNMoqREIqx46idPfncLneexiy4iBoRpX+ChVNjqQut8RgcoeIYL/Fr8YAzPM9Pl
         8Q4UJxhtfLzV3UIgEYqHWDn3E4uA/Lx5Y4VxiElQtCIhrpnjXSq5rX7NzvCORGjsx2
         rsXmVsFci83Av+jB5KeQ0yDsNC+cjPAS9Vl24ucU=
Received: by mail-pf1-f171.google.com with SMTP id c13so9689377pfv.4;
        Thu, 13 May 2021 16:53:35 -0700 (PDT)
X-Gm-Message-State: AOAM532KIWaY7e3iGbrAU6ndgwW8IXyTIm+r+LnfNkFgMSJ8o6qhHN2Y
        PyN/AhM6zSR67k/Efxr/fxe+vrC91IA1talfOu0=
X-Google-Smtp-Source: ABdhPJzRgCD5ObQcFpxCY7nlnqj1S/fiXzXBQfzUBfVXg2LuiGUoPmo/XFxC3ZhAJ3P7tq1jlOZ0eCMvsl0hXlFkOhw=
X-Received: by 2002:a63:4d22:: with SMTP id a34mr16258481pgb.421.1620950014935;
 Thu, 13 May 2021 16:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
 <20210513165846.23722-5-mcroce@linux.microsoft.com> <20210513182048.GA12395@shell.armlinux.org.uk>
In-Reply-To: <20210513182048.GA12395@shell.armlinux.org.uk>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Fri, 14 May 2021 01:52:58 +0200
X-Gmail-Original-Message-ID: <CAFnufp2HP1e7hg_bKpWwASDLhK+jgAtZX+mQGJg08nSVzxgioA@mail.gmail.com>
Message-ID: <CAFnufp2HP1e7hg_bKpWwASDLhK+jgAtZX+mQGJg08nSVzxgioA@mail.gmail.com>
Subject: Re: [PATCH net-next v5 4/5] mvpp2: recycle buffers
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 8:21 PM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Thu, May 13, 2021 at 06:58:45PM +0200, Matteo Croce wrote:
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > index b2259bf1d299..9dceabece56c 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -3847,6 +3847,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
> >       struct mvpp2_pcpu_stats ps = {};
> >       enum dma_data_direction dma_dir;
> >       struct bpf_prog *xdp_prog;
> > +     struct xdp_rxq_info *rxqi;
> >       struct xdp_buff xdp;
> >       int rx_received;
> >       int rx_done = 0;
> > @@ -3912,15 +3913,15 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
> >               else
> >                       frag_size = bm_pool->frag_size;
> >
> > +             if (bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE)
> > +                     rxqi = &rxq->xdp_rxq_short;
> > +             else
> > +                     rxqi = &rxq->xdp_rxq_long;
> >
> > +             if (xdp_prog) {
> > +                     xdp.rxq = rxqi;
> >
> > +                     xdp_init_buff(&xdp, PAGE_SIZE, rxqi);
> >                       xdp_prepare_buff(&xdp, data,
> >                                        MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
> >                                        rx_bytes, false);
> > @@ -3964,7 +3965,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
> >               }
> >
> >               if (pp)
> > +                     skb_mark_for_recycle(skb, virt_to_page(data), pp);
> >               else
> >                       dma_unmap_single_attrs(dev->dev.parent, dma_addr,
> >                                              bm_pool->buf_size, DMA_FROM_DEVICE,
>
> Looking at the above, which I've only quoted the _resulting_ code after
> your patch above, I don't see why you have moved the
> "bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE" conditional outside of
> the test for xdp_prog - I don't see rxqi being used except within that
> conditional. Please can you explain the reasoning there?
>

Back in v3, skb_mark_for_recycle() was accepting an xdp_mem_info*, so
I needed rxqi out of that conditional scope to get that pointer.
Now we just need a page_pool*, so I can restore the original chunk.
Nice catch.

Thanks,
-- 
per aspera ad upstream
