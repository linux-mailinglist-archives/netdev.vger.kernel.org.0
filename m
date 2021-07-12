Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002733C41E5
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 05:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhGLDdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 23:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhGLDds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 23:33:48 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D68C0613DD;
        Sun, 11 Jul 2021 20:31:00 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id dj21so5797005edb.0;
        Sun, 11 Jul 2021 20:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7DJb5zdwKGROhdoFv50zrkRCj7TCgmob56fldHVm5S0=;
        b=Mrxmr3EqqmDfeBXsY/V6WelqqFHbuM8zDFZYRCJH3gyKJkVblxSqOy+ww5QdwWzTNc
         on2CdsaKKx3wRn/tuwpTHm8qZ32lBAbgvUbhLPLuf1itXF2P4u+UcduaNUm/DxVqvHQr
         UpkTLIkbfKlYKfYWBn1yIr6yYDacQswmm40WuYjigD0SHCAes/Arh35UlM3mNC127957
         OzTobS+E1jzEHnEngMItx6ffcqe/r5jQNQ4J0qyQxR+jPpM+W605KXyBH3mvqdKCUbG9
         4z/bozNkX6cFZOnyCOp8KAADZUfMXtUEaFXiMLJx7x6Vim+klVNvmw7rz5Af0qbbL0t5
         0C1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7DJb5zdwKGROhdoFv50zrkRCj7TCgmob56fldHVm5S0=;
        b=qiwacmlXsQGLa3HELdNAkg/jiW1gypc30Z56itoellvC05nyJbdYEXw/rkQC8RjQ6l
         K6uYG323SaxtC3IDb9JuX8SD7Bmh9T75bpgW8A8l2ywDbH4OgxL9h3kevJPbG2QhcwpC
         Eb/AwEGEM5yxnvLjrXBnclLKEKlhadwuT7SIlz/6LS9YlMrQSGB//m5SUcl5NY9RDqME
         x6EMju6MdAgneJgVgR7ZhxIdI6OMhoFbKTXTKNtwpY/uE1G1m+ewPAXADKrWKKZU+Hsk
         4uoCQZpz6KS6N8zSB4XAQMBkf2RcTN5trImM3YgLMVlikn1ej30iQqlclrM9lyzggTfA
         gN0Q==
X-Gm-Message-State: AOAM533IeUz7cSQkJq8NvgP7+tvJ2ouN0Ak94T9pkq3v2l0hMVqm6I7a
        5pDQNLK1yuPUpG5tha2yJRKepWG30Upz4Vu7mw4=
X-Google-Smtp-Source: ABdhPJzpyHVnSetWPQB1vOrZPwkuLJUCJ1fCgdR2DAxxSBVu/6hBhBgsDda06lZIxceY0kN3GSLboeqUnJ2Fdqjtdto=
X-Received: by 2002:a05:6402:3089:: with SMTP id de9mr9201653edb.69.1626060658742;
 Sun, 11 Jul 2021 20:30:58 -0700 (PDT)
MIME-Version: 1.0
References: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com>
 <1625903002-31619-4-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Udnb_KgHyWiwxDF+r+DkytgZd4CQJz4QR85JpinhZAJzw@mail.gmail.com> <d45619d1-5235-9dd4-77aa-497fa1115c80@huawei.com>
In-Reply-To: <d45619d1-5235-9dd4-77aa-497fa1115c80@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 11 Jul 2021 20:30:47 -0700
Message-ID: <CAKgT0Uf1FJrg515QuTk9bB4t3R+5GvnONyEVR_eKYk-OMun_DA@mail.gmail.com>
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

On Sun, Jul 11, 2021 at 7:06 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/7/11 1:31, Alexander Duyck wrote:
> > On Sat, Jul 10, 2021 at 12:44 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> > <snip>
> >> @@ -419,6 +471,20 @@ static __always_inline struct page *
> >>  __page_pool_put_page(struct page_pool *pool, struct page *page,
> >>                      unsigned int dma_sync_size, bool allow_direct)
> >>  {
> >> +       int bias = page_pool_get_pagecnt_bias(page);
> >> +
> >> +       /* Handle the elevated refcnt case first */
> >> +       if (bias) {
> >> +               /* It is not the last user yet */
> >> +               if (!page_pool_bias_page_recyclable(page, bias))
> >> +                       return NULL;
> >> +
> >> +               if (likely(!page_is_pfmemalloc(page)))
> >> +                       goto recyclable;
> >> +               else
> >> +                       goto unrecyclable;
> >> +       }
> >> +
> >
> > So this part is still broken. Anything that takes a reference to the
> > page and holds it while this is called will cause it to break. For
> > example with the recent fixes we put in place all it would take is a
> > skb_clone followed by pskb_expand_head and this starts leaking memory.
>
> Ok, it seems the fix is confilcting with the expectation this patch is
> based, which is "the last user will always call page_pool_put_full_page()
> in order to do the recycling or do the resource cleanup(dma unmaping..etc)
> and freeing.".
>
> As the user of the new skb after skb_clone() and pskb_expand_head() is
> not aware of that their frag page may still be in the page pool after
> the fix?

No it isn't the fix that is conflicting. It is the fundamental
assumption that is flawed.

We cannot guarantee that some other entity will not take a reference
on the page. In order for this to work you have to guarantee that no
other entity will use get_page/put_page on this page while you are
using it.

This is the reason why all the other implementations that do
pagecnt_bias always remove the leftover count once they are done with
the page. What was throwing me off before is that I was assuming you
were doing that somewhere and you weren't. Instead this patch
effectively turned the page count into a ticket lock of sorts and the
problem is this approach only works as long as no other entities can
take a reference on the page.

> >
> > One of the key bits in order for pagecnt_bias to work is that you have
> > to deduct the bias once there are no more parties using it. Otherwise
> > you leave the reference count artificially inflated and the page will
> > never be freed. It works fine for the single producer single consumer
> > case but once you introduce multiple consumers this is going to fall
> > apart.
>
> It seems we have diffferent understanding about consumer, I treat the
> above user of new skb after skb_clone() and pskb_expand_head() as the
> consumer of the page pool too, so that new skb should keep the recycle
> bit in order for that to happen.

The problem is updating pskb_expand_head to call
page_pool_return_skb_page still wouldn't resolve the issue. The
fundamental assumption is flawed that the thread holding the skb will
always be the last one to free the page.

> If the semantic is "the new user of a page should not be handled by page
> pool if page pool is not aware of the new user(the new user is added by
> calling page allocator API instead of calling the page pool API, like the
> skb_clone() and pskb_expand_head() above) ", I suppose I am ok with that
> semantic too as long as the above semantic is aligned with the people
> involved.

The bigger issue is that this use of the page_ref_count violates how
the page struct is meant to be used. The count is meant to be atomic
and capable of getting to 0. The fact that we are now leaving the bias
floating is going to introduce a number of issues.

> Also, it seems _refcount and dma_addr in "struct page" is in the same cache
> line, which means there is already cache line bouncing already between _refcount
> and dma_addr updating, so it may makes senses to only use bias to indicate
> number of the page pool user for a page, instead of using "bias - page_ref_count",
> as the page_ref_count is not reliable if somebody is using the page allocator API
> directly.
>
> And the trick part seems to be how to make the bias atomic for allocating and
> freeing.

What we end up essentially needing to do is duplicate that
page_ref_count as a page_frag_count and just leave the original
page_ref_count at 1. If we do that and then just decrement that new
count instead it would allow us to defer the unmapping/recycling and
we just fall back into the original path when we finally hit 0.

The only limitation then is the fact that we would be looking at
potentially 2 atomic operations in the worst case if we release the
page as you would need one to get the frag_count to 0, and then
another to decrement the ref_count. For the standard case that would
work about the same as what you already had though, as you were
already having to perform an atomic_dec_and_test on the page_ref_count
anyway.
