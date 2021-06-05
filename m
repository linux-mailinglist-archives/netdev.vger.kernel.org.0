Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A42639C9E7
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 18:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhFEQhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 12:37:08 -0400
Received: from linux.microsoft.com ([13.77.154.182]:48346 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFEQhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 12:37:08 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by linux.microsoft.com (Postfix) with ESMTPSA id F2E3C20B802A;
        Sat,  5 Jun 2021 09:35:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F2E3C20B802A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622910920;
        bh=cOclEmmWl6j6+WY9j7NfknHEEHkDrYdGYI0sPaVF3h0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sTFupoEnOZa+Rg9zsHZoCvqOc14skuu1zRcwpinyRGbdbTusvqQrZDUm0fjbulPTF
         sVrftj5RO8RAowEHni7wtOe2n/P/gl20hV6SUtbkq1vkwkJTA8qTEdWVj8lguBKVx8
         /00lyf31dKHGn9dPLpuaHeNnfb/kAifuczy0T20Y=
Received: by mail-pj1-f43.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so9185221pjs.2;
        Sat, 05 Jun 2021 09:35:19 -0700 (PDT)
X-Gm-Message-State: AOAM531Agx8VrbqAEAQJQtambbnDsRlKP5GFCekXBUOEnwFdW3jL3o55
        EjRbKe+lgjeCSHTcs0s46yAsqUH507TgQrFTfiU=
X-Google-Smtp-Source: ABdhPJygiZdUBMofrvGIJKnAiSIUtdPe75CqrwuMthYT+s5sMbTwwbqXGEATDjb4JXV1JYjGO5sE09p+XSOr4C1NyS8=
X-Received: by 2002:a17:90b:109:: with SMTP id p9mr23537983pjz.11.1622910919349;
 Sat, 05 Jun 2021 09:35:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210521161527.34607-1-mcroce@linux.microsoft.com>
 <20210521161527.34607-4-mcroce@linux.microsoft.com> <badedf51-ce74-061d-732c-61d0678180b3@huawei.com>
 <YLnnaRLMlnm+LKwX@iliass-mbp> <722e5567-d8ee-228c-978e-9d5966257bb1@gmail.com>
In-Reply-To: <722e5567-d8ee-228c-978e-9d5966257bb1@gmail.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sat, 5 Jun 2021 18:34:43 +0200
X-Gmail-Original-Message-ID: <CAFnufp3rWwFgknBUBy9mHB36zpTKRiTeUAFeJXKVvp2DzvG3bw@mail.gmail.com>
Message-ID: <CAFnufp3rWwFgknBUBy9mHB36zpTKRiTeUAFeJXKVvp2DzvG3bw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/5] page_pool: Allow drivers to hint on SKB recycling
To:     David Ahern <dsahern@gmail.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Yunsheng Lin <linyunsheng@huawei.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Ayush Sawal <ayush.sawal@chelsio.com>,
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
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 6:06 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/4/21 2:42 AM, Ilias Apalodimas wrote:
> > [...]
> >>> +   /* Driver set this to memory recycling info. Reset it on recycle.
> >>> +    * This will *not* work for NIC using a split-page memory model.
> >>> +    * The page will be returned to the pool here regardless of the
> >>> +    * 'flipped' fragment being in use or not.
> >>> +    */
> >>
> >> I am not sure I understand how does the last part of comment related
> >> to the code below, as there is no driver using split-page memory model
> >> will reach here because those driver will not call skb_mark_for_recycle(),
> >> right?
> >>
> >
> > Yes the comment is there to prohibit people (mlx5 only actually) to add the
> > recycling bit on their driver.  Because if they do it will *probably* work
> > but they might get random corrupted packets which will be hard to debug.
> >
>
> What's the complexity for getting it to work with split page model?
> Since 1500 is the default MTU, requiring a page per packet means a lot
> of wasted memory.

We could create a new memory model, e.g. MEM_TYPE_PAGE_SPLIT, and
restore the behavior present in the previous versions of this serie,
which is, save xdp_mem_info in struct page.
As this could slightly impact the performances, this can be added in a
future change when the drivers which are doing it want to use this
recycling api.

-- 
per aspera ad upstream
