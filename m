Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FBF3CA096
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 16:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhGOO2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 10:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhGOO2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 10:28:22 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D39C06175F;
        Thu, 15 Jul 2021 07:25:28 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id l26so8370170eda.10;
        Thu, 15 Jul 2021 07:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hPi0AV58UCJPRZJrgAK/kxp1/ZQY1bqf97Po2jccYNs=;
        b=LLL4gUVy6wLxp/YE/ivmkO8qS/9tp+5x6psoELU1VXCOGHoY2uXa0cIUuhHPInf8+i
         RXOn4Y/SXvp1ygUF4b9nuip+DiK2c1fsE0id24jdQz0D4e7NHD0MVtIgpbUvW94/YH18
         WJQz7AzyukzPW6Bb+ppedCLiSHzl+HErzy9kl/Zz6Hzhw6dH7LP22s23/gqKh51MlZT2
         YXzfstAffMcpV7Z2x1lE7oPLMAZoy1BEs0tYaWaHUnONT0sAJ4+2wDIHtlYbTQL1EuQS
         fmdNCbNU5DYAndiwM2W6YvYDqxcLGOIQ0DwhIvMr71q7dH3habTamd2HQaFqrWrtUOwj
         ENSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hPi0AV58UCJPRZJrgAK/kxp1/ZQY1bqf97Po2jccYNs=;
        b=mb0w+IvyhXXzIa8m2pbIGKxgep7uJoGvP04lm4feudpgtFx+tpLQmqTXpn8G3dwSVA
         ApCZH3wkS80qECLxGtqJMCoaH0/tEPiHJYCu/3P7LaWRZtBqxugV72c6d/ixQx1X3fa2
         FakG4FXuAwriSpxp5cEdB9/iT4ODSvYFmeCbN1gq08M5uFoqKr0e3fZYbgvmUIIZeHeI
         oNcxGMcbJUXBrrpUhRViJtJP5mcxwQV71WoeRbILi7cNxgB52ldQ6xQmeZEP1fFedA9f
         C1+Ck5qKrtzChpmq62bSaHtRot3QG1snPZZ6ojHdMCuj8YFcfY9dMvUBoWkmKvslfYxX
         M7BA==
X-Gm-Message-State: AOAM530j07FfqijVOjfPf4k49JTaoQcan42oPgV/U/p/LKC+oZV08F5V
        FqnsFsoXdjYfgdkQ9okPazBfwF8g/4yiX7LWsSw=
X-Google-Smtp-Source: ABdhPJwTjk1uiGO5+qcj/KLWcqWaSngcqReoqp5gQyPFUbIj9ogDDbh1GjJAN/IaNlcZh5gEzJBdHGrFz2pgvoNF29E=
X-Received: by 2002:aa7:d554:: with SMTP id u20mr7402567edr.50.1626359127039;
 Thu, 15 Jul 2021 07:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210709062943.101532-1-ilias.apalodimas@linaro.org> <bf326953-495f-db01-e554-42f4421d237a@huawei.com>
In-Reply-To: <bf326953-495f-db01-e554-42f4421d237a@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 15 Jul 2021 07:25:16 -0700
Message-ID: <CAKgT0UemhFPHo9krmQfm=yNTSjwpBwVkoFtLEEQ-qLVh=-BeHg@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] skbuff: Fix a potential race while recycling
 page_pool packets
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matteo Croce <mcroce@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 9:02 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/7/9 14:29, Ilias Apalodimas wrote:
> > As Alexander points out, when we are trying to recycle a cloned/expanded
> > SKB we might trigger a race.  The recycling code relies on the
> > pp_recycle bit to trigger,  which we carry over to cloned SKBs.
> > If that cloned SKB gets expanded or if we get references to the frags,
> > call skbb_release_data() and overwrite skb->head, we are creating separate
> > instances accessing the same page frags.  Since the skb_release_data()
> > will first try to recycle the frags,  there's a potential race between
> > the original and cloned SKB, since both will have the pp_recycle bit set.
> >
> > Fix this by explicitly those SKBs not recyclable.
> > The atomic_sub_return effectively limits us to a single release case,
> > and when we are calling skb_release_data we are also releasing the
> > option to perform the recycling, or releasing the pages from the page pool.
> >
> > Fixes: 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling")
> > Reported-by: Alexander Duyck <alexanderduyck@fb.com>
> > Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
> > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > ---
> > Changes since v1:
> > - Set the recycle bit to 0 during skb_release_data instead of the
> >   individual fucntions triggering the issue, in order to catch all
> >   cases
> >  net/core/skbuff.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 12aabcda6db2..f91f09a824be 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -663,7 +663,7 @@ static void skb_release_data(struct sk_buff *skb)
> >       if (skb->cloned &&
> >           atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
> >                             &shinfo->dataref))
> > -             return;
> > +             goto exit;
>
> Is it possible this patch may break the head frag page for the original skb,
> supposing it's head frag page is from the page pool and below change clears
> the pp_recycle for original skb, causing a page leaking for the page pool?

I don't see how. The assumption here is that when atomic_sub_return
gets down to 0 we will still have an skb with skb->pp_recycle set and
it will flow down and encounter skb_free_head below. All we are doing
is skipping those steps and clearing skb->pp_recycle for all but the
last buffer and the last one to free it will trigger the recycling.

> >
> >       skb_zcopy_clear(skb, true);
> >
> > @@ -674,6 +674,8 @@ static void skb_release_data(struct sk_buff *skb)
> >               kfree_skb_list(shinfo->frag_list);
> >
> >       skb_free_head(skb);
> > +exit:
> > +     skb->pp_recycle = 0;

Note the path here. We don't clear skb->pp_recycle for the last buffer
where "dataref == 0" until *AFTER* the head has been freed, and all
clones will have skb->pp_recycle = 1 as long as they are a clone of
the original skb that had it set.
