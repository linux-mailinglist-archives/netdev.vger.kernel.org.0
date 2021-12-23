Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0808547E774
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349583AbhLWSIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244679AbhLWSIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:08:20 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328CCC061401
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 10:08:20 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id g5so4813575ilj.12
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 10:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IbKysMGWDbyPu2Ek6J8h+vNng07HIpOMSXozvlsXQYU=;
        b=EW1lfkZE/pNVmYFrrK/nETmcqq9RY/lcnCXhICfwh+udVTjucfBe256YxFwDP5pBmD
         EZGgAbF7dXDfmdehMVULsycJ3nX35hvKQ0R9xroIt+81L1e4c3k7YWZuoMYVke30SstA
         53cG0JNjuFkbZUTaAJm69+5dmRCXKE8ojv0uueCoYy+uvqD7PHNCJiQqnLcb/LPYUHIK
         BbVwc8o3XAo2NrLhDlgwLr+TG06LWax6IDUUUGZ4qp6P2nzCLL4F6EnQkVZLw1e1s5OR
         dSiLs26uaDiF0BfrN5KIcyiOcsmtEVJmt7C+45XNqs9ao/oHjObyi1UQJRdOxg+0oNad
         Ttbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IbKysMGWDbyPu2Ek6J8h+vNng07HIpOMSXozvlsXQYU=;
        b=M6OlwMWBnGsR51ovmal3uLIK8hfsdGuOz7EIzXNV46z9bHw8w5FU4CGZAwmO4FODZZ
         G3QE8TSB5tdxoYmsSg1o90JFnSjr/7ng94iIAwl7iv5FOGad1Bo6BnsOSqtxJvJxJpt0
         T9tfNUBBllFqob46XD0BQzmA5wq3M2Zc+xOSV+rdn8ifm3Aboq+3NNRBghff/droJlht
         ZOGWaYGvY/pGWrVdM4nqVZqM77c16++Tr7ZUkxC0a8XcSiDfTPFohUezzHvFI4W/opER
         HrWUVgQK7RpmZIaVDBdPndM9X8mxAPmSq+10PND9N/8Wwwu6aL88QJ5+Kib4D75gdeY1
         I4iw==
X-Gm-Message-State: AOAM53221POxGK7jbBn1yyGyrUBPOR9tHQC7qkmmqT335l2QF09enut0
        OjTQSUuBRuIB/Pg78SusjjJYitzGyXo1EBnlRq8=
X-Google-Smtp-Source: ABdhPJxoX2Zm5pRSPVjfDxcthmnEibuXBqKoKhdMIfxRguwT0Y8FCbPUHeGKJqxtx64iWlh3jsnXuk1kr317FpAc9is=
X-Received: by 2002:a05:6e02:1989:: with SMTP id g9mr1632455ilf.88.1640282899359;
 Thu, 23 Dec 2021 10:08:19 -0800 (PST)
MIME-Version: 1.0
References: <26109603287b4d21545bec125e43b218b545b746.1640111022.git.pabeni@redhat.com>
 <CANn89iKpiQzW1UnsQSYzULJ8d-QHsy7Wz=NtgvVXBqh-iuNptQ@mail.gmail.com>
In-Reply-To: <CANn89iKpiQzW1UnsQSYzULJ8d-QHsy7Wz=NtgvVXBqh-iuNptQ@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 23 Dec 2021 10:08:05 -0800
Message-ID: <CAA93jw7U9tMHLcZVtsnN+7BxR6NkDqUkyu0oEhxeZ4XU9HUCVQ@mail.gmail.com>
Subject: Re: [PATCH net] veth: ensure skb entering GRO are not cloned.
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev <netdev@vger.kernel.org>,
        Ignat Korchagin <ignat@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 5:17 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Dec 21, 2021 at 1:34 PM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > After commit d3256efd8e8b ("veth: allow enabling NAPI even without XDP"=
),
> > if GRO is enabled on a veth device and TSO is disabled on the peer
> > device, TCP skbs will go through the NAPI callback. If there is no XDP
> > program attached, the veth code does not perform any share check, and
> > shared/cloned skbs could enter the GRO engine.
> >
> >
>
> ...
>
> > Address the issue checking for cloned skbs even in the GRO-without-XDP
> > input path.
> >
> > Reported-and-tested-by: Ignat Korchagin <ignat@cloudflare.com>
> > Fixes: d3256efd8e8b ("veth: allow enabling NAPI even without XDP")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  drivers/net/veth.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index b78894c38933..abd1f949b2f5 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -718,6 +718,14 @@ static struct sk_buff *veth_xdp_rcv_skb(struct vet=
h_rq *rq,
> >         rcu_read_lock();
> >         xdp_prog =3D rcu_dereference(rq->xdp_prog);
> >         if (unlikely(!xdp_prog)) {
> > +               if (unlikely(skb_shared(skb) || skb_head_is_locked(skb)=
)) {
>
> Why skb_head_is_locked() needed here ?
> I would think skb_cloned() is enough for the problem we want to address.
>
> > +                       struct sk_buff *nskb =3D skb_copy(skb, GFP_ATOM=
IC | __GFP_NOWARN);
> > +
> > +                       if (!nskb)
> > +                               goto drop;
> > +                       consume_skb(skb);
> > +                       skb =3D nskb;
> > +               }
> >                 rcu_read_unlock();
> >                 goto out;
> >         }
> > --
> > 2.33.1
> >
>
> - It seems adding yet memory alloc/free and copies is defeating GRO purpo=
se.
> - After skb_copy(), GRO is forced to use the expensive frag_list way
> for aggregation anyway.
> - veth mtu could be set to 64KB, so we could have order-4 allocation
> attempts here.
>
> Would the following fix [1] be better maybe, in terms of efficiency,
> and keeping around skb EDT/tstamp
> information (see recent thread with Martin and Daniel )

I've always liked the idea of being able to coherently timestamp from
packet ingress to egress.

> I think it also focuses more on the problem (GRO is not capable of
> dealing with cloned skb yet).
> Who knows, maybe in the future we will _have_ to add more checks in
> GRO fast path for some other reason,
> since it is becoming the Swiss army knife of networking :)

GRO is the bane of my sub-gbit existence. I've been wishing we had a
compile time option to always split it up or a righter path forward
using veth interfaces here: https://github.com/rchac/LibreQoS

> Although I guess this whole case (disabling TSO) is moot, I have no
> idea why anyone would do that :)
>
> [1]
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 50eb43e5bf459bb998e264d399bc85d4e9d73594..fe7a4d2f7bfc834ea56d1da18=
5c0f53bfbd22ad0
> 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -879,8 +879,12 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budg=
et,
>
>                         stats->xdp_bytes +=3D skb->len;
>                         skb =3D veth_xdp_rcv_skb(rq, skb, bq, stats);
> -                       if (skb)
> -                               napi_gro_receive(&rq->xdp_napi, skb);
> +                       if (skb) {
> +                               if (skb_shared(skb) || skb_cloned(skb))
> +                                       netif_receive_skb(skb);
> +                               else
> +                                       napi_gro_receive(&rq->xdp_napi, s=
kb);
> +                       }
>                 }
>                 done++;
>         }



--=20
I tried to build a better future, a few times:
https://wayforward.archive.org/?site=3Dhttps%3A%2F%2Fwww.icei.org

Dave T=C3=A4ht CEO, TekLibre, LLC
