Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71EC47D164
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 12:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhLVL61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 06:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbhLVL60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 06:58:26 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A69CC061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:58:26 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id f186so5925488ybg.2
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iq7Beh/zr9UfMju4UgWIYfulv3+Lyolf0V5hgZcgiro=;
        b=op5kuTaF5y17SQ0rqkyuX8iGdDzuXw5tRqY0xj1mFpbv0zb2MASJwgUajwGpQ+CLz9
         aJK/ClKHoJMF8xU4YvbfJ0O9SSPLACg/zty4t4CL4QjUyJHsltzkPTLtnid7OSnp1fyg
         mtskXUAJU+5gNwaYTYHFl+ZqBCVcYEF2FNeoDCV++q8Zgjxc2wHcaO0HSWShKbYNc+In
         Ggkbygp/LEWXEqKOAO7+Qx2jt4BF3w5xkIdYazSOA9XFdOmFHansEffjP1t0iWWUWeC2
         3NvTn+qVkjKHOMIVOgMKrbVjXQadaLBVYdxz5C4mGWgJNurGvj9DDyGtXBJzZiid+VAS
         oyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iq7Beh/zr9UfMju4UgWIYfulv3+Lyolf0V5hgZcgiro=;
        b=EWHpLvSEHgwApftBpuXsg+vCn7rmfLoDIEyoG7IHxx7mY3WJ4PqUVr1iDgzBkemTlh
         wP9OAQyudwMdRdKM+TCrJUpLw287gai0UttTK2EPmCMgiVQ+pu7vrGwSqyLFjhWwuqA5
         fZs8BAe3kJMG5sxtMrFSh9LVZ+xRJ/t1M0fY/6ByLiQhOFShmoWXU+ESzLKTQoGIYcEs
         iw9X9gvHqyGfKaavdWFXU5kPTQnnRDiLmjMINrj1+KxBKk//QvXRcygmXiPVgX6S2seH
         90Ke6ssasreDNYoUCiPeTQFyLwgeP1oBHlc4+YdV96tv0uGY4e/9AZhCXxhsVE3SzAhh
         Yg5g==
X-Gm-Message-State: AOAM532fXk1Xoe7NvSGhStwG0AGEYhHHDTZgzb8ULcapO+FpsPJ1Bizv
        RoEsOfq1OngHb744acTcT4bseJV8atZRf5/bqH9NmiEs2lQ=
X-Google-Smtp-Source: ABdhPJw8GDefovTtZ+vH5DVFoS/vfUPwMQGY4iw/KUQK3Z5PEUw0ReDXq9WfAiizBNrwV3RSmFAy5jm4gdi+Y9OzpqQ=
X-Received: by 2002:a25:df4f:: with SMTP id w76mr4260067ybg.711.1640174304993;
 Wed, 22 Dec 2021 03:58:24 -0800 (PST)
MIME-Version: 1.0
References: <26109603287b4d21545bec125e43b218b545b746.1640111022.git.pabeni@redhat.com>
 <CANn89iKpiQzW1UnsQSYzULJ8d-QHsy7Wz=NtgvVXBqh-iuNptQ@mail.gmail.com> <dad55584ad20723f1579475a09ef7b3a3607e087.camel@redhat.com>
In-Reply-To: <dad55584ad20723f1579475a09ef7b3a3607e087.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Dec 2021 03:58:13 -0800
Message-ID: <CANn89iKDA4TMpQeQoxicd8rkph5+Am2iuoSDETvFn03CiQQV3g@mail.gmail.com>
Subject: Re: [PATCH net] veth: ensure skb entering GRO are not cloned.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Ignat Korchagin <ignat@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 3:06 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Tue, 2021-12-21 at 20:31 -0800, Eric Dumazet wrote:
> > On Tue, Dec 21, 2021 at 1:34 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > >
> > > After commit d3256efd8e8b ("veth: allow enabling NAPI even without XDP"),
> > > if GRO is enabled on a veth device and TSO is disabled on the peer
> > > device, TCP skbs will go through the NAPI callback. If there is no XDP
> > > program attached, the veth code does not perform any share check, and
> > > shared/cloned skbs could enter the GRO engine.
> > >
> > >
> >
> > ...
> >
> > > Address the issue checking for cloned skbs even in the GRO-without-XDP
> > > input path.
> > >
> > > Reported-and-tested-by: Ignat Korchagin <ignat@cloudflare.com>
> > > Fixes: d3256efd8e8b ("veth: allow enabling NAPI even without XDP")
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > >  drivers/net/veth.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > > index b78894c38933..abd1f949b2f5 100644
> > > --- a/drivers/net/veth.c
> > > +++ b/drivers/net/veth.c
> > > @@ -718,6 +718,14 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
> > >         rcu_read_lock();
> > >         xdp_prog = rcu_dereference(rq->xdp_prog);
> > >         if (unlikely(!xdp_prog)) {
> > > +               if (unlikely(skb_shared(skb) || skb_head_is_locked(skb))) {
> >
> > Why skb_head_is_locked() needed here ?
> > I would think skb_cloned() is enough for the problem we want to address.
>
> Thank you for the feedback.
>
> I double checked the above: in my test even skb_cloned() suffice.
>
> > > +                       struct sk_buff *nskb = skb_copy(skb, GFP_ATOMIC | __GFP_NOWARN);
> > > +
> > > +                       if (!nskb)
> > > +                               goto drop;
> > > +                       consume_skb(skb);
> > > +                       skb = nskb;
> > > +               }
> > >                 rcu_read_unlock();
> > >                 goto out;
> > >         }
> > > --
> > > 2.33.1
> > >
> >
> > - It seems adding yet memory alloc/free and copies is defeating GRO purpose.
> > - After skb_copy(), GRO is forced to use the expensive frag_list way
> > for aggregation anyway.
> > - veth mtu could be set to 64KB, so we could have order-4 allocation
> > attempts here.
> >
> > Would the following fix [1] be better maybe, in terms of efficiency,
> > and keeping around skb EDT/tstamp
> > information (see recent thread with Martin and Daniel )
> >
> > I think it also focuses more on the problem (GRO is not capable of
> > dealing with cloned skb yet).
> > Who knows, maybe in the future we will _have_ to add more checks in
> > GRO fast path for some other reason,
> > since it is becoming the Swiss army knife of networking :)
>
> Only vaguely related: I have a bunch of micro optimizations for the GRO
> engine. I did not submit the patches because I can observe the gain
> only in micro-benchmarks, but I'm wondering if that could be visible
> with very high speed TCP stream? I can share the code if that could be
> of general interest (after some rebasing, the patches predates gro.c)
>
> > Although I guess this whole case (disabling TSO) is moot, I have no
> > idea why anyone would do that :)
> >
> > [1]
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 50eb43e5bf459bb998e264d399bc85d4e9d73594..fe7a4d2f7bfc834ea56d1da185c0f53bfbd22ad0
> > 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -879,8 +879,12 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
> >
> >                         stats->xdp_bytes += skb->len;
> >                         skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
> > -                       if (skb)
> > -                               napi_gro_receive(&rq->xdp_napi, skb);
> > +                       if (skb) {
> > +                               if (skb_shared(skb) || skb_cloned(skb))
> > +                                       netif_receive_skb(skb);
> > +                               else
> > +                                       napi_gro_receive(&rq->xdp_napi, skb);
> > +                       }
> >                 }
> >                 done++;
> >         }
>
> I tested the above, and it works, too.
>
> I thought about something similar, but I overlooked possible OoO or
> behaviour changes when a packet socket is attached to the paired device
> (as it would disable GRO).

Have you tried a pskb_expand_head() instead of a full copy ?
Perhaps that would be enough, and keep all packets going through GRO to
make sure OOO is covered.

>
> It looks like tcpdump should have not ill-effects (the mmap rx-path
> releases the skb clone before the orig packet reaches the other end),
> so I guess the above is fine (and sure is better to avoid more
> timestamp related problem).
>
> Do you prefer to submit it formally, or do you prefer I'll send a v2
> with the latter code?

Sure, please submit a V2.

>
> Thanks!
>
> Paolo
>
>
