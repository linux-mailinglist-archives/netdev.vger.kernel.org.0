Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C1239AA61
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 20:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhFCSrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 14:47:41 -0400
Received: from linux.microsoft.com ([13.77.154.182]:44720 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhFCSrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 14:47:40 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by linux.microsoft.com (Postfix) with ESMTPSA id B32AA20B8008;
        Thu,  3 Jun 2021 11:45:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B32AA20B8008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622745955;
        bh=lf8obqIyS2qhtxjR7Mi9MkEGyvvpajHXjSrq3w7AQBw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IqHYoY2eF51K4B1BRfEAgTvALDlLvh9m8WiqDYT7VaLO9gh/L/YLsH1C8E69nqCKD
         SXIdkxTZ11PHMWxStuJVNllURVLpim1rPcwpjR0Alv9K8BrGhygXgcccEG6/4CjREM
         /0dKw3pPaAMwpE5rQO6cgIgoojsVFwCfzI82Smds=
Received: by mail-pl1-f173.google.com with SMTP id u9so3288044plr.1;
        Thu, 03 Jun 2021 11:45:55 -0700 (PDT)
X-Gm-Message-State: AOAM5308j+KEEJGQ/VfkAM5GiUWH2oNGP/3MmPyl36sdXpYtg3T6U4x6
        io7E1NfugESON7BBot7pgNCAdAqfQ0a4sF8S8I0=
X-Google-Smtp-Source: ABdhPJyNuPz1nMtiXXYpEZb8kLY8qBLhgAqPuG4EN+LJF+UkcLXA3R73bIhWeQhXNcV1yibM3RwAOyya9JHIqmypciY=
X-Received: by 2002:a17:90a:7892:: with SMTP id x18mr643257pjk.39.1622745955243;
 Thu, 03 Jun 2021 11:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210521161527.34607-1-mcroce@linux.microsoft.com> <20210521161527.34607-4-mcroce@linux.microsoft.com>
In-Reply-To: <20210521161527.34607-4-mcroce@linux.microsoft.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Thu, 3 Jun 2021 20:45:19 +0200
X-Gmail-Original-Message-ID: <CAFnufp2Qbq53rT17eZD97tm3o5OFJeHEDAyaW8VhVcy4u+KeNQ@mail.gmail.com>
Message-ID: <CAFnufp2Qbq53rT17eZD97tm3o5OFJeHEDAyaW8VhVcy4u+KeNQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/5] page_pool: Allow drivers to hint on SKB recycling
To:     netdev@vger.kernel.org, linux-mm@kvack.org
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
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

On Fri, May 21, 2021 at 6:16 PM Matteo Croce <mcroce@linux.microsoft.com> wrote:
> +bool page_pool_return_skb_page(void *data)
> +{
> +       struct page_pool *pp;
> +       struct page *page;
> +
> +       page = virt_to_head_page(data);
> +       if (unlikely(page->pp_magic != PP_SIGNATURE))
> +               return false;
> +
> +       pp = (struct page_pool *)page->pp;
> +
> +       /* Driver set this to memory recycling info. Reset it on recycle.
> +        * This will *not* work for NIC using a split-page memory model.
> +        * The page will be returned to the pool here regardless of the
> +        * 'flipped' fragment being in use or not.
> +        */
> +       page->pp = NULL;
> +       page_pool_put_full_page(pp, virt_to_head_page(data), false);

Here I could just use the cached "page" instead of calling
virt_to_head_page() once again.

-- 
per aspera ad upstream
