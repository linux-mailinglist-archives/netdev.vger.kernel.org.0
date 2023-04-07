Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB8C6DA9B0
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjDGIDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDGIDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:03:22 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF71D49CA
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:03:19 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id x20so42879644ljq.9
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 01:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680854598;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3j4Q7cktauelFtkBQ8mgrv3DlgNJEJ8f5ALLLkx2XZA=;
        b=hIoSKpjkUvX5wJN2pkJT1ouYrx/ZSyl/UmJ9YVTFcqWkK45TVEymG1brVSzJPVYkyf
         6bapkkNJiteqOGXA9x7I4YzPfyBOCu2/VjR4hDrjmGJKjyztrhTHHx34NlMwfPEsUapI
         Ek/5HU3StjTkgS3N1Ww7IiHGA0WpizwSgYUjDRUdcNgIorplP/RW+vLYETo2eHQ62Ss6
         3CioB4uX8oJTqHw/SbFreqT7UNkxT0lrMyZ/qZhufdcfVsnszywu/EBWGNC41+n0tqCS
         YeLuWnojEIzN0lKbSIMgHFD9cV7yrankp9MsyVk5LqX/Fmr70xpuVR7cK21LmuoColo9
         UVjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680854598;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3j4Q7cktauelFtkBQ8mgrv3DlgNJEJ8f5ALLLkx2XZA=;
        b=3gP9VpIXEklpKedTZRheF2p/RCzp/hz4l7oLdPwpNfPDVIEEiARxcP5ijMe/kxXvo2
         pEc+tJdF4revuObR3N8bHvJVzqJHevhPc5ZyilzddEUfuB8I5LUHd0bBTsQXUj7aKVlk
         r6EC7gGgRMKUk37Gcc5I9AtBFoCltx52q6O5QKL9G7SGE+603jBV2R+Zq1Htia0rRRZc
         lXorEZldZ+Du/czREw71enFd02GJ30vrXl7hmfiaMU5WQXA9nh9YfUHw91GZpzPi2H+6
         feBfOsu2uDBsWjaRmtzlD13RHkpau+oTUYB8mPpVwJxcogbXQnAhnDt87By6Z+n21clU
         N0HA==
X-Gm-Message-State: AAQBX9cbnVsEN5SsAjx8rAj/wQL6ZOPVNhJrFuXsFTHcDiAmD9d5Fvlb
        ODXv+Y7lVx8EK59EW2UhYUULYZLTvoqbSfzN391pkg==
X-Google-Smtp-Source: AKy350YG9PUR5yhji4xohTkzlAbFThOf9qkOZIAm5zrJQj9P+/lJVIC+ZLk9gDlqOZsfsW52J6W7lAV91/QauwS3N1U=
X-Received: by 2002:a2e:b04e:0:b0:299:9de5:2f05 with SMTP id
 d14-20020a2eb04e000000b002999de52f05mr369691ljl.2.1680854597998; Fri, 07 Apr
 2023 01:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230406114825.18597-1-liangchen.linux@gmail.com> <ed4b1f1bf72ea1234a283a26d88e00658e9e4311.camel@gmail.com>
In-Reply-To: <ed4b1f1bf72ea1234a283a26d88e00658e9e4311.camel@gmail.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Fri, 7 Apr 2023 11:02:41 +0300
Message-ID: <CAC_iWjJ_30s898KhBQNy7jO_xNtxnz5BqgjE5OCxTzE+hQSP+g@mail.gmail.com>
Subject: Re: [PATCH v2] skbuff: Fix a race between coalescing and releasing SKBs
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Liang Chen <liangchen.linux@gmail.com>, kuba@kernel.org,
        hawk@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Thu, 6 Apr 2023 at 18:25, Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, 2023-04-06 at 19:48 +0800, Liang Chen wrote:
> > Commit 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment
> > recycling") allowed coalescing to proceed with non page pool page and
> > page pool page when @from is cloned, i.e.
> >
> > to->pp_recycle    --> false
> > from->pp_recycle  --> true
> > skb_cloned(from)  --> true
> >
> > However, it actually requires skb_cloned(@from) to hold true until
> > coalescing finishes in this situation. If the other cloned SKB is
> > released while the merging is in process, from_shinfo->nr_frags will be
> > set to 0 towards the end of the function, causing the increment of frag
> > page _refcount to be unexpectedly skipped resulting in inconsistent
> > reference counts. Later when SKB(@to) is released, it frees the page
> > directly even though the page pool page is still in use, leading to
> > use-after-free or double-free errors.
> >
> > So it needs to be specially handled at where the ref count may get lost.
> >
> > The double-free error message below prompted us to investigate:
> > BUG: Bad page state in process swapper/1  pfn:0e0d1
> > page:00000000c6548b28 refcount:-1 mapcount:0 mapping:0000000000000000
> > index:0x2 pfn:0xe0d1
> > flags: 0xfffffc0000000(node=0|zone=1|lastcpupid=0x1fffff)
> > raw: 000fffffc0000000 0000000000000000 ffffffff00000101 0000000000000000
> > raw: 0000000000000002 0000000000000000 ffffffffffffffff 0000000000000000
> > page dumped because: nonzero _refcount
> >
> > CPU: 1 PID: 0 Comm: swapper/1 Tainted: G            E      6.2.0+
> > Call Trace:
> >  <IRQ>
> > dump_stack_lvl+0x32/0x50
> > bad_page+0x69/0xf0
> > free_pcp_prepare+0x260/0x2f0
> > free_unref_page+0x20/0x1c0
> > skb_release_data+0x10b/0x1a0
> > napi_consume_skb+0x56/0x150
> > net_rx_action+0xf0/0x350
> > ? __napi_schedule+0x79/0x90
> > __do_softirq+0xc8/0x2b1
> > __irq_exit_rcu+0xb9/0xf0
> > common_interrupt+0x82/0xa0
> > </IRQ>
> > <TASK>
> > asm_common_interrupt+0x22/0x40
> > RIP: 0010:default_idle+0xb/0x20
> >
> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > ---
> > Changes from v1:
> > - deal with the ref count problem instead of return back to give more opportunities to coalesce skbs.
> > ---
> >  net/core/skbuff.c | 22 ++++++++++++++++++++--
> >  1 file changed, 20 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 050a875d09c5..77da8ce74a1e 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -5643,7 +5643,19 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
> >
> >               skb_fill_page_desc(to, to_shinfo->nr_frags,
> >                                  page, offset, skb_headlen(from));
> > -             *fragstolen = true;
> > +
> > +             /* When @from is pp_recycle and @to isn't, coalescing is
> > +              * allowed to proceed if @from is cloned. However if the
> > +              * execution reaches this point, @from is already transitioned
> > +              * into non-cloned because the other cloned skb is released
> > +              * somewhere else concurrently. In this case, we need to make
> > +              * sure the ref count is incremented, not directly stealing
> > +              * from page pool.
> > +              */
> > +             if (to->pp_recycle != from->pp_recycle)
> > +                     get_page(page);
> > +             else
> > +                     *fragstolen = true;
> >       } else {
> >               if (to_shinfo->nr_frags +
> >                   from_shinfo->nr_frags > MAX_SKB_FRAGS)
> > @@ -5659,7 +5671,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
> >              from_shinfo->nr_frags * sizeof(skb_frag_t));
> >       to_shinfo->nr_frags += from_shinfo->nr_frags;
> >
> > -     if (!skb_cloned(from))
> > +     /* Same situation as above where head data presents. When @from is
> > +      * pp_recycle and @to isn't, coalescing is allowed to proceed if @from
> > +      * is cloned. However @from can be transitioned into non-cloned
> > +      * concurrently by this point. If it does happen, we need to make sure
> > +      * the ref count is properly incremented.
> > +      */
> > +     if (to->pp_recycle == from->pp_recycle && !skb_cloned(from))
> >               from_shinfo->nr_frags = 0;
> >
> >       /* if the skb is not cloned this does nothing
>
> So looking this over I believe this should resolve the issue you
> pointed out while maintaining current functionality.
>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Yes, this would work, but I am not sure we really want this here.
Is coalescing page-pool-owned and slab-owned SKBs frequent to justify
the additional overhead? If the answer is yes, the patch seems fine

Thanks
/Ilias
>
> One follow-on that we may want to do with this would be to look at
> consolidating the 3 spots where we are checking for our combination of
> pp_recycle comparison and skb_cloned and maybe pass one boolean flag
> indicating that we have to transfer everything by taking page
> references.
>
> Also I think we can actually increase the number of cases where we
> support coalescing if we were to take apart the skb_head_is_locked call
> and move the skb_cloned check from it into your recycle check in the
> portion where we are stealing from the header.
