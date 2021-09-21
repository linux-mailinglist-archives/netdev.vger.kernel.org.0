Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E7B412BDE
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351273AbhIUCja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242050AbhIUCh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:37:29 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8960AC061366;
        Mon, 20 Sep 2021 18:48:54 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q11so34645922wrr.9;
        Mon, 20 Sep 2021 18:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XsbOPmeOKB/570fbfbzFbflSwEFMGZGM2JzXwh8J1SQ=;
        b=pssQgPnotXBLiLGXJUuGMURrg1xKMcKmrpCXmtAcY2GYBOzsCuKP+xX11XK2r2aiLT
         MjV2jXi6JjNruUvbh7FQaHBmXMfJKoxj/JTGPltimWzKuR5aJRVPYMH28yXgvjuFKwKO
         lml2O1C26GGPYHORcYSoIqEUYkKG+2Dw50rUyyv7e7/O9sNvtgrlXdBB041iTPl+sZFl
         hQ+O1qQnZBmGHa7XiXrJXv1uQ7f6Z99qqJa8eZSqHk6aE/C9XC9RACMVoPwSv0qZ9CVl
         SJD3uZGlreym4GSclGdAmG/R+qNc9beDSzHcX4zP32TCqC+rJ9O06qp0NaYw3tR4BoPN
         fizg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XsbOPmeOKB/570fbfbzFbflSwEFMGZGM2JzXwh8J1SQ=;
        b=dNyLeKNtJcmufAAXLzdObSR28da2lClG9iSFlXq7cLFDXX3WE7QrxbMPU0EVjf4Oi5
         MoDHYImSsdcSKHHvxuefE46iZLZ7YAknGQ/elUPi6oAWMaMN6P+/Nhf6iFSnrVW3b4jk
         anmmwoblnAg5kR4qMfXNbYI904/7JeesAjE2UYc030Tk7yn2JuOMRUY9ggN8RqTgIJrf
         sJTEcm9d/bvaIKfjQWUGeWemYoSjyXvGVSejsMaJuUz6tFQKdB0uw7zbcwDZpePoyuu+
         J5JT7Zs7B0bcQrErAOZKcAkJuAKQ4T3CYMONRzle0D/wAERzQyfMlc9LOidtF1yUBpDe
         ELYw==
X-Gm-Message-State: AOAM5310dsiUCJ2g7BsO3ln3ta5nTpy6S/2cIVldA3WiGKWZAolsmXHI
        7RQy/I7+FwxUQvcZf2tJves8/3kX1XuyONyEE7o=
X-Google-Smtp-Source: ABdhPJwY/pTvSi440fBtEY6yKwYEz81tNiEbE21xK0cTxa5Gyw8yPp6zppGev3v5wMUQOilFGAoPhpOa/lHkhMwxf1o=
X-Received: by 2002:a5d:5610:: with SMTP id l16mr32093271wrv.102.1632188933081;
 Mon, 20 Sep 2021 18:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210920174713.4998-1-l4stpr0gr4m@gmail.com> <20210920135027.5ec63a05@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210920135027.5ec63a05@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
Date:   Tue, 21 Sep 2021 10:48:40 +0900
Message-ID: <CAKW4uUxperg41z8Lu5QYsS-YEGt1anuD1CuiUqXC0ANFqJBosQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] Introducing lockless cache built on top of
 slab allocator
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021=EB=85=84 9=EC=9B=94 21=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 5:50, J=
akub Kicinski <kuba@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Tue, 21 Sep 2021 02:47:13 +0900 Kangmin Park wrote:
> > It is just introducing and proof of concept.
> > The patch code is based on other RFC patches. So, the code is not
> > correct yet, it is just simple proof of concept.
> >
> > Recently block layer implemented percpu, lockless cache on the top
> > of slab allocator. It can be used for IO polling.
> >
> > Link: https://lwn.net/Articles/868070/
> > Link: https://www.spinics.net/lists/linux-block/msg71964.html
> >
> > It gained some IOPS increase (performance increased by about 10%
> > on the block layer).
> >
> > And there are attempts to implement the percpu, lockless cache.
> >
> > Link: https://lore.kernel.org/linux-mm/20210920154816.31832-1-42.hyeyoo=
@gmail.com/T/#u
> >
> > If this cache is implemented successfully,
> > how about use this cache to allocate skb instead of kmem_cache_alloc_bu=
lk()
> > in napi_skb_cache_get()?
> >
> > I want your comment/opinion.
>
> Please take a look at skb cache in struct napi_alloc_cache.
> That should be your target here.
>

Oh, thanks for the advice.
I'll send you a v2 patch to replace/improve napi_alloc_cache
when progress is made in implementing the lockless cache.

Best Regards,
Kangmin Park

> > Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
> > ---
> >  net/core/skbuff.c | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 7c2ab27fcbf9..f9a9deca423d 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -170,11 +170,15 @@ static struct sk_buff *napi_skb_cache_get(void)
> >       struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
> >       struct sk_buff *skb;
> >
> > -     if (unlikely(!nc->skb_count))
> > -             nc->skb_count =3D kmem_cache_alloc_bulk(skbuff_head_cache=
,
> > -                                                   GFP_ATOMIC,
> > -                                                   NAPI_SKB_CACHE_BULK=
,
> > -                                                   nc->skb_cache);
> > +     if (unlikely(!nc->skb_count)) {
> > +             /* kmem_cache_alloc_cached should be changed to return th=
e size of
> > +              * the allocated cache
> > +              */
> > +             nc->skb_cache =3D kmem_cache_alloc_cached(skbuff_head_cac=
he,
> > +                                                     GFP_ATOMIC | SLB_=
LOCKLESS_CACHE);
> > +             nc->skb_count =3D this_cpu_ptr(skbuff_head_cache)->size;
> > +     }
> > +
> >       if (unlikely(!nc->skb_count))
> >               return NULL;
> >
