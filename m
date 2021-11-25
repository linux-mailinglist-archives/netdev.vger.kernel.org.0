Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866E445DB59
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 14:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbhKYNn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 08:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354974AbhKYNlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 08:41:55 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B84C0613B4
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 05:32:37 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p18so5594882wmq.5
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 05:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t2x0D0Ff9mt6dLGhRLtVJULLK0TAoIx8sbPE2KXrwyY=;
        b=XSHPUgKy1jv6TCDhXKQenHkEaMxheW4aSMlJlBs50L4bsQ21W6RmKsUTKNr7tC46Mu
         iQIK/5m/4NChFeQsEM7PMQLN13xO/Mbu6y4tHccp5R2fW9cda86LlqsgTGSk1e2SMCEU
         eyjXRIKEEmR4DJto7nFUdWW4gQXBdmilVJLD7niYYZayDvYvdOyR2wfHZ3if6E7X5oLZ
         ZHBhQXypxmmznsVU4YzaUGPhH6+86GsSak+N1j9n68sFkQ5Vu1IuPZMmCtTGtciElO0I
         GwO3kKkbGEshPeHF+9np9xok9nzWDjbyicRMsq7XmZqpicXXo9ot8ebr7Ilz/eeY7x2q
         z1xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t2x0D0Ff9mt6dLGhRLtVJULLK0TAoIx8sbPE2KXrwyY=;
        b=gfEWQnlBZq2Thf5ot8dkn+Wotr2W18vF1bRKHMT3L+Epr944UmdY+5gD7bn4lLQY2s
         YEA4n3vyeSWfbBKoGVny0QFVqPluJEJyvRs9fo+o5TDbtibu/WAoOXV4xPhSdPyETNxk
         mtL9HuG6DGqnEzS+fFJ1eVxPUwV4XEskfA7yBHRRcVJMYNY+f4mTqwuurjSbqnUoRO4l
         CfcTpI97+Fp4DJ1zBjaprVqRxVvvJBNuEISASTxTKHTVLcv/Ni1GtpOZGoqz8DbpG4D8
         Zz2UueDyL+rrEBd3UnOKnr1t3GUuqox2Dm6IlAYg8/fMjyMQ26am5Mmv9Wy/McEktrga
         YRhw==
X-Gm-Message-State: AOAM533JY+LQKaIFHxfiGe+ZiPXioM1Kv2NriEd0kqMGIJhgpdyM5cIk
        hAtxXNBBWjnVdRAIq6vQWpvhjNYGJ0xaLVbHTXRd8w==
X-Google-Smtp-Source: ABdhPJw82pmcE9PyxEnhgj2TlfIMDV8kLXHopp7r4fzo1K9CDIkn0KDLOWHaaJBLOCk9Y6gn7LPpx/Dh3oWL+SHEFQg=
X-Received: by 2002:a05:600c:3ba3:: with SMTP id n35mr7457011wms.88.1637847155342;
 Thu, 25 Nov 2021 05:32:35 -0800 (PST)
MIME-Version: 1.0
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com> <06864387ba644a58816ab3a82a8b5f82@AcuMS.aculab.com>
In-Reply-To: <06864387ba644a58816ab3a82a8b5f82@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 25 Nov 2021 05:32:23 -0800
Message-ID: <CANn89i+HmN3DbfAtH+Uq_pBWYHXp5ioH8LyhGRAiHZhRLbs1nw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 1:41 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 24 November 2021 20:25
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Remove one pair of add/adc instructions and their dependency
> > against carry flag.
> >
> > We can leverage third argument to csum_partial():
> >
> >   X = csum_block_sub(X, csum_partial(start, len, 0), 0);
> >
> >   -->
> >
> >   X = csum_block_add(X, ~csum_partial(start, len, 0), 0);
> >
> >   -->
> >
> >   X = ~csum_partial(start, len, ~X);
>
> That doesn't seem to refer to the change in this file.
>

It is describing the change.

The first step, of copying first the __skb_postpull_rcsum(skb, start,
len, 0) content
into __skb_postpull_rcsum() was kind of obvious.



>         David
>
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  include/linux/skbuff.h | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index eba256af64a577b458998845f2dc01a5ec80745a..eae4bd3237a41cc1b60b44c91fbfe21dfdd8f117 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -3485,7 +3485,11 @@ __skb_postpull_rcsum(struct sk_buff *skb, const void *start, unsigned int len,
> >  static inline void skb_postpull_rcsum(struct sk_buff *skb,
> >                                     const void *start, unsigned int len)
> >  {
> > -     __skb_postpull_rcsum(skb, start, len, 0);
> > +     if (skb->ip_summed == CHECKSUM_COMPLETE)
> > +             skb->csum = ~csum_partial(start, len, ~skb->csum);
> > +     else if (skb->ip_summed == CHECKSUM_PARTIAL &&
> > +              skb_checksum_start_offset(skb) < 0)
> > +             skb->ip_summed = CHECKSUM_NONE;
> >  }
> >
> >  static __always_inline void
> > --
> > 2.34.0.rc2.393.gf8c9666880-goog
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
