Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF8E35A99A
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 02:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbhDJAkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 20:40:18 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52614 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbhDJAkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 20:40:17 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by linux.microsoft.com (Postfix) with ESMTPSA id A584220B5683;
        Fri,  9 Apr 2021 17:40:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A584220B5683
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618015203;
        bh=JxAWTKu0RsLOn+CtOJNoC1FW0WcD7DLqFKDKm5Tu7xg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oHL6t39YonTW38B5zIyWMIxXPFYAXsrJ1LA+xAxog1i3nr6opzclHK9FMNwuSJPjp
         G+O74GkXOPZ6fYtvi5mj7L2gjH2mejD4EkEumfzzh21qpKtYX+e8olGqz8gfjD3Hz+
         Z1/3PwXzhgpo+Uh1MrFjw71nPxqY5i2+/NOUWl6k=
Received: by mail-pj1-f42.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so5765558pjb.4;
        Fri, 09 Apr 2021 17:40:03 -0700 (PDT)
X-Gm-Message-State: AOAM532z8fWhtlAfHeIOvh7bNlggRgaxC39Qlm12m7mzEXBpXMjK6+EN
        qTWef47rBPltY2VScCk18PLuW5LQJTOtZBWFkEQ=
X-Google-Smtp-Source: ABdhPJxsiSBaEo0q7IWG1XR6kNJzbJXnsnMAllDVNr0h3y82Zw+JbOCz2+OIKyRWvvOv4WiFz2E42r9sXZlYYlk4Od0=
X-Received: by 2002:a17:90a:5306:: with SMTP id x6mr11539930pjh.39.1618015203252;
 Fri, 09 Apr 2021 17:40:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <20210409223801.104657-4-mcroce@linux.microsoft.com> <YHDtQWyzFmrjuQWr@apalos.home>
In-Reply-To: <YHDtQWyzFmrjuQWr@apalos.home>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sat, 10 Apr 2021 02:39:27 +0200
X-Gmail-Original-Message-ID: <CAFnufp0aRJnJU4ZvLnp+zj2mp7FkgXGTon5JDFDU4BMoPsdUaQ@mail.gmail.com>
Message-ID: <CAFnufp0aRJnJU4ZvLnp+zj2mp7FkgXGTon5JDFDU4BMoPsdUaQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/5] page_pool: Allow drivers to hint on SKB recycling
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
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
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 10, 2021 at 2:11 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Hi Matteo,
>
> [...]
> > +bool page_pool_return_skb_page(void *data);
> > +
> >  struct page_pool *page_pool_create(const struct page_pool_params *params);
> >
> >  #ifdef CONFIG_PAGE_POOL
> > @@ -243,4 +247,13 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
> >               spin_unlock_bh(&pool->ring.producer_lock);
> >  }
> >
> > +/* Store mem_info on struct page and use it while recycling skb frags */
> > +static inline
> > +void page_pool_store_mem_info(struct page *page, struct xdp_mem_info *mem)
> > +{
> > +     u32 *xmi = (u32 *)mem;
> > +
>
> I just noticed this changed from the original patchset I was carrying.
> On the original, I had a union containing a u32 member to explicitly avoid
> this casting. Let's wait for comments on the rest of the series, but i'd like
> to change that back in a v4. Aplogies, I completely missed this on the
> previous postings ...
>

Hi,

I had to change this because including net/xdp.h here caused a
circular dependency.
I think that the safest thing we can do is to use memcpy(), which will
handle the alignments correctly, depending on the architecture.

Cheers,
-- 
per aspera ad upstream
