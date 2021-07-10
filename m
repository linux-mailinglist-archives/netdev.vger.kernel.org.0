Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448533C35D3
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 19:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhGJRej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 13:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhGJRei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 13:34:38 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A2AC0613DD;
        Sat, 10 Jul 2021 10:31:53 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id l2so19320051edt.1;
        Sat, 10 Jul 2021 10:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zduc9jpX7e7ip13ou3ijSJWzMOCnUHnEmxXUSbY5bJU=;
        b=C/P2TgL9cTJl1yI9f+phOSafGQBnJS5mZXs9udeyY4KKHXeif1izj9c0XCynBI6Gow
         jzeskIMwthwCHcyYcivZOSh2G1l05+Qe6rnKXQy4WsBmAmxGDOJl80BD2s773df1fR1j
         qQxZnZXKWhUfY6NxzcEfzIFOimmG1sHPH5xQAveYfd//7aHZP7A97QXhhCsDbDrBS6sJ
         cKy3pKveko5G5SF9OGb/tCuTfF1P6Encmj96T96QzHHVnUHbGhLi9qE/nXU6xRUvUPNj
         k+OMs2RqAYaNYAy3U+WOK5Rq6qm6M/0o7BjuF6o8k00IdGdS+LfD1u0HxV6Z8ZXCBwoL
         bQ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zduc9jpX7e7ip13ou3ijSJWzMOCnUHnEmxXUSbY5bJU=;
        b=uEDUPoYT7AX9jWXCVOfgs2EP8JCLgr8HLWSYnr4MCTzR5Gw9RnTMIPokKnIQL0Q1wr
         CXBIpKWM5t3J/0McFStBHm9NRgT0HHnS/zS2Orqz2WP8vdgtasnCvr80kEZkFXoxpT1Y
         fhFWmM9xIcvjXyNCOGWatTqqONprdlW40YsyqPmc1PxP3ziUbllBtNYgbSYnjZ4PA6zq
         jjf1jy6fBpkBpMVFxzw3bwFvRLS+im8WJ9Rjr61gMre2KEJjtZLy88FazNTsgx8E4bQF
         O8JENA/Gy/X0nnEsLXHKH+hiDJRB+N8yKx+aSaeHOt6RCFZ2jw3oWXFzbQziAtoOVmva
         TgkA==
X-Gm-Message-State: AOAM533cN1B2c6jfIdwkc3IGxmKSwYXYPRAjSWJ5fZWfdSTecAJzlgVs
        QE6u+uk8vu3Jho3dePrwCDJvT8a1YMc7fqjL8sM=
X-Google-Smtp-Source: ABdhPJyg1jRGhmZQTptVGcxevUXjZHvrJwenNbSbMbtZFCyCAsyOajHY7yoULfJluUj6Ks8aq5llIrezy6kNlO/fsYM=
X-Received: by 2002:a05:6402:40c4:: with SMTP id z4mr55523898edb.364.1625938311902;
 Sat, 10 Jul 2021 10:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com> <1625903002-31619-4-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1625903002-31619-4-git-send-email-linyunsheng@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 10 Jul 2021 10:31:41 -0700
Message-ID: <CAKgT0Udnb_KgHyWiwxDF+r+DkytgZd4CQJz4QR85JpinhZAJzw@mail.gmail.com>
Subject: Re: [PATCH rfc v2 3/5] page_pool: add page recycling support based on
 elevated refcnt
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, hawk@kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, nogikh@google.com,
        Marco Elver <elver@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 12:44 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
<snip>
> @@ -419,6 +471,20 @@ static __always_inline struct page *
>  __page_pool_put_page(struct page_pool *pool, struct page *page,
>                      unsigned int dma_sync_size, bool allow_direct)
>  {
> +       int bias = page_pool_get_pagecnt_bias(page);
> +
> +       /* Handle the elevated refcnt case first */
> +       if (bias) {
> +               /* It is not the last user yet */
> +               if (!page_pool_bias_page_recyclable(page, bias))
> +                       return NULL;
> +
> +               if (likely(!page_is_pfmemalloc(page)))
> +                       goto recyclable;
> +               else
> +                       goto unrecyclable;
> +       }
> +

So this part is still broken. Anything that takes a reference to the
page and holds it while this is called will cause it to break. For
example with the recent fixes we put in place all it would take is a
skb_clone followed by pskb_expand_head and this starts leaking memory.

One of the key bits in order for pagecnt_bias to work is that you have
to deduct the bias once there are no more parties using it. Otherwise
you leave the reference count artificially inflated and the page will
never be freed. It works fine for the single producer single consumer
case but once you introduce multiple consumers this is going to fall
apart.
