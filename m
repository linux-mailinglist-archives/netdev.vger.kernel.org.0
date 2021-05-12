Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71B637BF6B
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhELOLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhELOLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:11:09 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA0EC06175F
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:10:00 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id v39so30873159ybd.4
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZMqb9pDlPkxQxt7DO3JSQX2FDPEZa9Tg1uyg9iwkb3w=;
        b=OV7yj3NQQdF7FlfLdQEdonq710miiphHYoEQVNeNZ/aiBaF4QduqoFFT+PXWILPjkX
         3lLKurAgxyUo4GVwvrLvBheX30QVU+hvIwSwo0XJOk9i6RCZk2lFYq4cfVn8gyMZcCpj
         0FRw/iy/24u2PDncsePYn6l0Rj8jfq5YN5I2LIey4wp0seVSlh2HD5eVdLyVPNxYGaz9
         i4ClNAwgNx1rLyC2Au/6hAjL1MYoriYfm4dd70BhFeDJnXG2VxqDvFekWkaKcfju6DmF
         TOUNPilaGx7Sod94c+dOHZgvHtrzjtHLOlD6Rx6V+8gI/3vJGfZI4gD2mjvfjOheQiCC
         qqcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZMqb9pDlPkxQxt7DO3JSQX2FDPEZa9Tg1uyg9iwkb3w=;
        b=VdF/uvExTnoKYofwHEQ2+vK4oFvRzWXGBTkFWofQUpIqj5JeurHPM/TXnlnTA2kV4S
         1TD1byJPh/OnfxjvX9CTNucWjbpkM+vaF4xmuJSLHBpPlMKRqAStqDku5ck+lFXaDs23
         meN4tzfvJCXoLuiBsLZBTOLq4rYDTeAKDiZ+4mTTOrNSlijvH34fx3XoLB+ebbuEa0oT
         SWmL44TfGpYs6VmHPH3dzhzz8IkRYYcY5kP5NERMxwBYLH6NKyAilGMoSZ7A67IheoEQ
         OCwPpE8Xl8P0HXTtuMiyP0fenzEZnbl5kjIEVHBoQYMTY0Oyo9Ap7EvbK/fzxzraPNwV
         GxBw==
X-Gm-Message-State: AOAM531Du8C9iNXJurDIVjmVp5v18vrq6nskdQtatbX1T2Q+o22bVIY3
        JNId1nEEK0B8Kr5z2WA0Ff4VkI6ARtrDdismeNaeGlEzo9vrVA==
X-Google-Smtp-Source: ABdhPJxHpb6RWithEu2vmhMDoaI9be2NUJek9rc1e/+bPZxqSoTLthtREkjsSfQchD2N3oC1udEzZ0LIqBewSkPZWUI=
X-Received: by 2002:a25:7ac5:: with SMTP id v188mr27529673ybc.132.1620828599169;
 Wed, 12 May 2021 07:09:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
 <20210511133118.15012-3-mcroce@linux.microsoft.com> <fa93976a-3460-0f7f-7af4-e78bfe55900a@gmail.com>
 <YJuk3o6CezbVrT+P@apalos.home>
In-Reply-To: <YJuk3o6CezbVrT+P@apalos.home>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 May 2021 16:09:47 +0200
Message-ID: <CANn89iLkq0zcbVeRRPGfeb5ZRcnz+e7dR1BCj-RGehNYE1Hzkw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/4] page_pool: Allow drivers to hint on SKB recycling
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        netdev <netdev@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
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
        LKML <linux-kernel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 11:50 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> [...]
> > > Since we added an extra argument on __skb_frag_unref() to handle
> > > recycling, update the current users of the function with that.
> >
> > This part could be done with a preliminary patch, only adding this
> > extra boolean, this would keep the 'complex' patch smaller.
>
> Sure
>
> [...]
> > >  #include <linux/uaccess.h>
> > >  #include <trace/events/skb.h>
> > > @@ -645,6 +648,11 @@ static void skb_free_head(struct sk_buff *skb)
> > >  {
> > >     unsigned char *head = skb->head;
> > >
> > > +#if IS_BUILTIN(CONFIG_PAGE_POOL)
> >
> > Why IS_BUILTIN() ?
>
> No reason, we'll replace it with an ifdef
>
> >
> > PAGE_POOL is either y or n
> >
> > IS_ENABLED() would look better, since we use IS_BUILTIN() for the cases where a module might be used.
> >
> > Or simply #ifdef CONFIG_PAGE_POOL
> >
> > > +   if (skb->pp_recycle && page_pool_return_skb_page(head))
> >
> > This probably should be attempted only in the (skb->head_frag) case ?
>
> I think the extra check makes sense.

What do you mean here ?

>
> >
> > Also this patch misses pskb_expand_head()
>
> I am not sure I am following. Misses what? pskb_expand_head() will either
> call skb_release_data() or skb_free_head(), which would either recycle or
> unmap the buffer for us (depending on the page refcnt)

 pskb_expand_head() allocates a new skb->head, from slab.

We should clear skb->pp_recycle for consistency of the skb->head_frag
clearing we perform there.

But then, I now realize you use skb->pp_recycle bit for both skb->head
and fragments,
and rely on this PP_SIGNATURE thing (I note that patch 1 changelog
does not describe why a random page will _not_ have this signature by
bad luck)

Please document/describe which struct page fields are aliased with
page->signature ?

Thanks !
