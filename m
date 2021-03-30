Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4A734EAAF
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhC3Ol3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbhC3OlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:41:10 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70E8C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:41:09 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id a143so17670930ybg.7
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CrrSkL0plsLLjotKYdqQ3Fk8WGFdJGU261WFqr9KToY=;
        b=n5eApJ7aqGC3SvYwDrMNo/ucJvF5XjlFXrmDHRTP3LZuM9024EGrugG5IJtgn/qXdN
         +ANItJNNsp7J9ugj6DHFEAURcx02RYmWlctlR6MUdwhCVYCr9mj1BQ38k9B5rVrV/oX/
         wu5psgPO9rIhDrEwkl8Cn8Sy4F1vJwwJKohlpTvuAi4/h9L4E8ZLA5cz+gAt8zrRr5+4
         4aqpIX2xYBKZCE2xrU12DlzrTf32Ub+cNAW5wb+kKMRkPkcT38EHDgkuCFwXG6S/4hEe
         +hojHWXSKrDsAptbt0wEOo2gJcFMjLXtJPJUkzpmbfiegog6Uc/UnpkRxpY1sSekgfkY
         G1Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CrrSkL0plsLLjotKYdqQ3Fk8WGFdJGU261WFqr9KToY=;
        b=BCEqbKT5pz/Blx/LJHfp41u5fL/v1/fUORjvZxIzenKCEt3b8nLt0M4YuQa1TL0a+9
         qQF9MeIOXqITwB91X64lrDQAUZyGN+d6wFPp8Dvij9+RCdo0jQO55L28Z/48tYWwMDtq
         AqzDZ2DJ0h7mxOB4EZ6L13QUA37DyH1Zm7CXXuhggXi36TLJ8WjqKMoEYM6H8CNhXjSn
         AsYeMgbZ4tOIzv3p2ToY1CGeIHYqXYNeaTs/Vr8+aTJ4WjSUt9PsQHkLJJQVap9xYMvz
         C9yzyZeW52wSUBgKuzimELIGPTTLvglOeMdW70LwGG7jMQBaZ3NaqMlVaMxcYzYaozsw
         7xaA==
X-Gm-Message-State: AOAM531NQmA04jMLNsc7ApasjOdUsLWvG8hA5LfJ+7ocF1KNSTLdugHj
        kdSCQdAmdEsjLX1WIPIcd9uZsY/yuEdaYbGc5haq6A==
X-Google-Smtp-Source: ABdhPJzHF2TZuZVyVhwAFIg51LaGGUVu9KwqX8kPEZ1tk0Ai9vJLqmojIZhDSk5vo9okdSjr/xf/lgFP87x0uLYhiTg=
X-Received: by 2002:a25:6a88:: with SMTP id f130mr20845835ybc.234.1617115268807;
 Tue, 30 Mar 2021 07:41:08 -0700 (PDT)
MIME-Version: 1.0
References: <880d627b79b24c0f92a47203193ed11f48c3031e.1617113947.git.pabeni@redhat.com>
 <CANn89iJQRf5GVhiUp3PA5y9p3_Nqrm8J2CcfxA=0yd9_aB=17w@mail.gmail.com>
In-Reply-To: <CANn89iJQRf5GVhiUp3PA5y9p3_Nqrm8J2CcfxA=0yd9_aB=17w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Mar 2021 16:40:57 +0200
Message-ID: <CANn89iJkXuhMdU0==ZV3s8z75p1hrhjY3reR_MWUh1i-gJVeCg@mail.gmail.com>
Subject: Re: [PATCH net] net: let skb_orphan_partial wake-up waiters.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 4:39 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Mar 30, 2021 at 4:25 PM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > Currently the mentioned helper can end-up freeing the socket wmem
> > without waking-up any processes waiting for more write memory.
> >
> > If the partially orphaned skb is attached to an UDP (or raw) socket,
> > the lack of wake-up can hang the user-space.
> >
> > Address the issue invoking the write_space callback after
> > releasing the memory, if the old skb destructor requires that.
> >
> > Fixes: f6ba8d33cfbb ("netem: fix skb_orphan_partial()")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  net/core/sock.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 0ed98f20448a2..7a38332d748e7 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -2137,6 +2137,8 @@ void skb_orphan_partial(struct sk_buff *skb)
> >
> >                 if (refcount_inc_not_zero(&sk->sk_refcnt)) {
> >                         WARN_ON(refcount_sub_and_test(skb->truesize, &sk->sk_wmem_alloc));
> > +                       if (skb->destructor == sock_wfree)
> > +                               sk->sk_write_space(sk);
>
> Interesting.
>
> Why TCP is not a problem here ?
>
> I would rather replace WARN_ON(refcount_sub_and_test(skb->truesize,
> &sk->sk_wmem_alloc)) by :
>                         skb_orphan(skb);

And of course re-add
                        skb->sk = sk;

>
> This will get rid of this suspect WARN_ON() at the same time ?
>
> >                         skb->destructor = sock_efree;
> >                 }
> >         } else {
> > --
> > 2.26.2
> >
