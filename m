Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8762E34EC74
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhC3Paj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbhC3PaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:30:09 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED63AC061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:30:08 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id i144so17866824ybg.1
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wNV+FNgyZJFWRKsemS2Jza+eOkzrfmivWEXnKX6zpjY=;
        b=r8x+5Isl/gKB5mII54nEAoQi+gerTrhuS9hv0YU34cuSIDOalRQxLrzoDr6xQfES0Q
         QUPz7NRPFaa0tYexZNVKEV/xFji63z4geUz/N5+Qtt335ex8/K3KFNehjPJTqrPp7sXb
         yRNkdaXGoHIhC1qwpa22ieMYSr/Brpq2fBbKuGtoDWL3QXmj6ahaLizEcydvcPvMLEjq
         XTEhMdJggL8fAo/J7g7g/h7hS4fRfBaDt698QxYDeX5DBI7z/G5IG47vtiygt5hvx/W7
         kJVs4sUFGHmz2OX4JcofeQ1LV+8Tt3zbIARdLM9XZ81+DWKqjsBSMmZjKjOM78PxozXu
         Jacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wNV+FNgyZJFWRKsemS2Jza+eOkzrfmivWEXnKX6zpjY=;
        b=nD0pr2tGSGeD4IBg4zxUglphC4JJnTNTk022DGlOgQxvE7I/QaP/QvBUwbS+HFebUI
         CYF18nR0odL12rCBrX2TSJoBhhKq60OIA3+M25VaPVT7yOWIhxg+HXE/HOMsJMsKThCI
         0J7hRZAM+1y9ncAj5ZODwzxhCfyf0SOeyz3H8xO8g07Amc3Y6tfssaH7gkQLZeqUMIdG
         9UYmpdRR7GqbA5e0FKxbDGhdW7fnOhlkzzR0nu5BZUe+jYG98TkBYfxNeH91jcWxwMKP
         6SX3HGABKHzI0V4MAF0bZZs9Q4eoTFj4qfYXTFdznIc9suUf6IWyNgfRtuohkiM4Q2bN
         I09Q==
X-Gm-Message-State: AOAM533/G/cCyjdzX9jWDU2dVUPpmlNOkapx5vNcdNY93KNkJBZ1UiCq
        yKFv0h4EqhhJYOvEsQr+bTYlx1b1LLylPcnr/RNYOSwZh882ZQ==
X-Google-Smtp-Source: ABdhPJxEHBrY3f+im0+V7zWdUb151wVKCBnrB01GAIDTVD1ipUxLZ+3/5EYHdhn/1SBmigp6hp1U/EywFc7VgYBPmOs=
X-Received: by 2002:a25:850b:: with SMTP id w11mr48091540ybk.518.1617118207842;
 Tue, 30 Mar 2021 08:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <880d627b79b24c0f92a47203193ed11f48c3031e.1617113947.git.pabeni@redhat.com>
 <CANn89iJQRf5GVhiUp3PA5y9p3_Nqrm8J2CcfxA=0yd9_aB=17w@mail.gmail.com>
 <CANn89iJkXuhMdU0==ZV3s8z75p1hrhjY3reR_MWUh1i-gJVeCg@mail.gmail.com> <99736955c48b19366a2a06f43ea4a0d507454dbc.camel@redhat.com>
In-Reply-To: <99736955c48b19366a2a06f43ea4a0d507454dbc.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Mar 2021 17:29:56 +0200
Message-ID: <CANn89i++Scdr8f7PbOk0ZkX6+NwhaQBTKmqXXiaQAjFXDijAsQ@mail.gmail.com>
Subject: Re: [PATCH net] net: let skb_orphan_partial wake-up waiters.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 5:18 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2021-03-30 at 16:40 +0200, Eric Dumazet wrote:
> > On Tue, Mar 30, 2021 at 4:39 PM Eric Dumazet <edumazet@google.com> wrote:
> > > On Tue, Mar 30, 2021 at 4:25 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > Currently the mentioned helper can end-up freeing the socket wmem
> > > > without waking-up any processes waiting for more write memory.
> > > >
> > > > If the partially orphaned skb is attached to an UDP (or raw) socket,
> > > > the lack of wake-up can hang the user-space.
> > > >
> > > > Address the issue invoking the write_space callback after
> > > > releasing the memory, if the old skb destructor requires that.
> > > >
> > > > Fixes: f6ba8d33cfbb ("netem: fix skb_orphan_partial()")
> > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > ---
> > > >  net/core/sock.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > > index 0ed98f20448a2..7a38332d748e7 100644
> > > > --- a/net/core/sock.c
> > > > +++ b/net/core/sock.c
> > > > @@ -2137,6 +2137,8 @@ void skb_orphan_partial(struct sk_buff *skb)
> > > >
> > > >                 if (refcount_inc_not_zero(&sk->sk_refcnt)) {
> > > >                         WARN_ON(refcount_sub_and_test(skb->truesize, &sk->sk_wmem_alloc));
> > > > +                       if (skb->destructor == sock_wfree)
> > > > +                               sk->sk_write_space(sk);
> > >
> > > Interesting.
> > >
> > > Why TCP is not a problem here ?
>
> AFAICS, tcp_wfree() does not call sk->sk_write_space(). Processes
> waiting for wmem are woken by ack processing.
>
> > > I would rather replace WARN_ON(refcount_sub_and_test(skb->truesize,
> > > &sk->sk_wmem_alloc)) by :
> > >                         skb_orphan(skb);
> >
> > And of course re-add
> >                         skb->sk = sk;
>
> Double checking to be sure. The patched slice of skb_orphan_partial()
> will then look like:
>
>         if (can_skb_orphan_partial(skb)) {
>                 struct sock *sk = skb->sk;
>
>                 if (refcount_inc_not_zero(&sk->sk_refcnt)) {
>                         skb_orphan(skb);
>                         skb->sk = sk;
>                         skb->destructor = sock_efree;
>                 }
>         } // ...
>
> Am I correct?
>

Yes.

We also could add a helper for the whole construct, since many other
paths do almost the same.
(They might use sock_hold(), but it seems safe to use the
refcount_inc_not_zero())
Or they omit the skb_orphan() (see can_skb_set_owner), which seems also risky.

static inline void skb_set_owner_sk_safe(sk, skb)
{
    if (sk && refcount_inc_not_zero(&sk->sk_refcnt)) {
           skb_orphan(skb);
           skb->destructor = sock_efree;
          skb->sk = sk;
    }
}



> Thanks!
>
> Paolo
>
