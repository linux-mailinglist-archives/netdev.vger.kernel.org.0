Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25464EC7BE
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343578AbiC3PHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244979AbiC3PHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:07:30 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489AA92310
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 08:05:44 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bh17so2643205ejb.8
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 08:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5XJS3AHalnFG3qpQL3QQEmH7km/Ll7WArQGG8lqamhI=;
        b=MP4D16s2s4uLcTI2+53g8Vb+VmeKdC1eIzKxJEPJ5IgN2yJbJJjn18hOBSO4o1+YSv
         HLuWckW7N9WgNKV4iVuGolWK8zSCHSk1De5wEySX+p5nGLh1bIAVspzOJbG7gmrlvQja
         SfOmm0hoMRN4NC7hhn93RIVrDuGl5XfIZMXVnVNfGuU//AtcA3YrC0Fx/NJBe8QHdbw2
         XOZXsSRqENZlgx42/8JOH1Pit7ZuK4OYgaci6CiqBYWErD1fdngbAOFrthr1cUxyeuyM
         SL8iWcQD15xENq1AsnUo71kjhjCczekqzyS7fP2dXpfrlrdJIci0yVP9hcH/klGQJwYY
         n33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5XJS3AHalnFG3qpQL3QQEmH7km/Ll7WArQGG8lqamhI=;
        b=h2bHeXxcwsQWhoIU9gdW0823sYGNSDkiHukQ2sjzHxXvf56un4WDJpKpKn5NqBMHRq
         kHCwRmHh+orh4FPhbHDK0v6EEg1Y7E1vcabv+hQI7o87djSeBmycO54I5L2gSw2cF+Rg
         5LfnKe6POGLfMtDNNKaptM27oZgKSoqUgVFsN80BX36kSSIIFPBYgEdEyAHvbThFqLMh
         fkS06rbVyWZ2XaUZITeuAqFf9fQ+SuLw+j5OjfEHTEKccjQsppKwfScjOA5yTHY6S6u1
         QcF2u10C3czvOYHhNxZ18RbJKzTZbCQ03vYRUnZohxJOtJuqQcQFuAeHCpDrCJbtgwNo
         hIaw==
X-Gm-Message-State: AOAM531t05JsMelKLQ+tGm3a2HVlWaVAIWAmQv7Mlu2gavc6Z5K2kJ1/
        eim3PLKsM5WKXdZQPGluf29mPb6pZm+CQClOtGFU03ljPUc=
X-Google-Smtp-Source: ABdhPJzGlHzPgfn2gG+acSXk08LcJ76XV8C0nME2tb6s5nybGT0w+VNRA9F/HgsbmgTD1ypkb0H2TE6oGQVUPH1HnnE=
X-Received: by 2002:a17:907:2d88:b0:6e4:9a7f:9175 with SMTP id
 gt8-20020a1709072d8800b006e49a7f9175mr1922223ejc.584.1648652742587; Wed, 30
 Mar 2022 08:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220328132258.78307-1-jean-philippe@linaro.org>
 <2de8c5818582bd9dfe0406541e3326c2bed0b6f2.camel@gmail.com> <YkRP7XwvdgFbvGsk@myrica>
In-Reply-To: <YkRP7XwvdgFbvGsk@myrica>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 30 Mar 2022 08:05:30 -0700
Message-ID: <CAKgT0UeaCq-Xtpy44huJoT69fNczOrODYCgshcHZQes1fVHWFQ@mail.gmail.com>
Subject: Re: [PATCH net v2] skbuff: disable coalescing for page_pool fragment recycling
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>, hawk@kernel.org,
        Alexander Duyck <alexanderduyck@fb.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 5:41 AM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> On Mon, Mar 28, 2022 at 08:03:46AM -0700, Alexander H Duyck wrote:
> > >  (3b) Now while handling TCP, coalesce SKB3 with SKB1:
> > >
> > >       tcp_v4_rcv(SKB3)
> > >         tcp_try_coalesce(to=SKB1, from=SKB3)    // succeeds
> > >         kfree_skb_partial(SKB3)
> > >           skb_release_data(SKB3)                // drops one dataref
> > >
> > >                       SKB1 _____ PAGE1
> > >                            \____
> > >                       SKB2 _____ PAGE2
> > >                                  /
> > >                 RX_BD3 _________/
> > >
> > >     In tcp_try_coalesce(), __skb_frag_ref() takes a page reference to
> > >     PAGE2, where it should instead have increased the page_pool frag
> > >     reference, pp_frag_count. Without coalescing, when releasing both
> > >     SKB2 and SKB3, a single reference to PAGE2 would be dropped. Now
> > >     when releasing SKB1 and SKB2, two references to PAGE2 will be
> > >     dropped, resulting in underflow.
> > >
> > >  (3c) Drop SKB2:
> > >
> > >       af_packet_rcv(SKB2)
> > >         consume_skb(SKB2)
> > >           skb_release_data(SKB2)                // drops second dataref
> > >             page_pool_return_skb_page(PAGE2)    // drops one pp_frag_count
> > >
> > >                       SKB1 _____ PAGE1
> > >                            \____
> > >                                  PAGE2
> > >                                  /
> > >                 RX_BD3 _________/
> > >
> > > (4) Userspace calls recvmsg()
> > >     Copies SKB1 and releases it. Since SKB3 was coalesced with SKB1, we
> > >     release the SKB3 page as well:
> > >
> > >     tcp_eat_recv_skb(SKB1)
> > >       skb_release_data(SKB1)
> > >         page_pool_return_skb_page(PAGE1)
> > >         page_pool_return_skb_page(PAGE2)        // drops second pp_frag_count
> > >
> > > (5) PAGE2 is freed, but the third RX descriptor was still using it!
> > >     In our case this causes IOMMU faults, but it would silently corrupt
> > >     memory if the IOMMU was disabled.
> > >
> > > Prevent coalescing the SKB if it may hold shared page_pool fragment
> > > references.
> > >
> > > Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
> > > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > ---
> > >  net/core/skbuff.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 10bde7c6db44..56b45b9f0b4d 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -5276,6 +5276,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
> > >     if (skb_cloned(to))
> > >             return false;
> > >
> > > +   /* We don't support taking page_pool frag references at the moment.
> > > +    * If the SKB is cloned and could have page_pool frag references, don't
> > > +    * coalesce it.
> > > +    */
> > > +   if (skb_cloned(from) && from->pp_recycle)
> > > +           return false;
> > > +
> > >     /* The page pool signature of struct page will eventually figure out
> > >      * which pages can be recycled or not but for now let's prohibit slab
> > >      * allocated and page_pool allocated SKBs from being coalesced.
> >
> >
> > This is close but not quite. Actually now that I think about it we can
> > probably alter the block below rather than adding a new one.
> >
> > The issue is we want only reference counted pages in standard skbs, and
> > pp_frag_count pages in pp_recycle skbs. So we already had logic along
> > the lines of:
> >       if (to->pp_recycle != from->pp_recycle)
> >               return false;
> >
> > I would say we need to change that because from->pp_recycle is the
> > piece that is probably too simplistic. Basically we will get a page
> > pool page if from->pp_recycle && !skb_cloned(from). So we can probably
> > just tweak the check below to be something along the lines of:
> >       if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
> >               return false;
>
> Just to confirm this is fine: the behavior now changes for
> to->pp_recycle == 0, from->pp_recycle == 1 and skb_cloned(from) == 1
> In this case we now coalesce and take a page ref. So the page has two refs
> and two pp_frag_count. (3c) drops one pp_frag_count. If there wasn't
> another RX desc holding a pp_frag_count (ie. no step (5)), that would also
> drop a page ref, but since 'to' SKB is holding a second page ref the page
> is not recycled. That reference gets dropped at (4) and the page is freed
> there.  With step (5), the page would get recycled into page_pool, but
> without (5) the page is discarded.
>
> I guess it works, just want to make sure that it's OK to mix page_pool
> pp_frag_count and normal reference counting at the same time.
>
> Thanks,
> Jean

The key thing is that we don't want to mix and match them within an
skb. This logic really isn't too different from what we do in
pskb_expand_head if the skb is cloned. Basically what we are doing is
transitioning "from" pages from page pool pages to reference counted
pages in the case that the skb is cloned and then placing them in a
skb that does page reference counting.
