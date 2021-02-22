Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FC1320EF3
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 02:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhBVBMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 20:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhBVBMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 20:12:16 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C564C061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 17:11:36 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id w6so771081qti.6
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 17:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lK8Mx+c5zZgdOHePxCDJj4TbNSdiPp5ut0xpUlWpTP4=;
        b=rcMCVDBPeo3ywQPLQp4MLR8zL13+yAP/nOJx434ceO+XNxpEPbwifgMv0gGiy4S1LF
         qIPAXddodfvt9TwFWufgNWZTMx6ggRM04UijSrb0fU6vSfm9yVGWMiKeBXRXRqsePFcE
         VYNunsgPf3Mh6YwoEQhe2lU0fp2npnKIACKTvUBbXknQcV8/6R+g99QpTWa40JbSdS27
         Xz9ztbvbeYtnVfx67cgN9NcM3BAHamw/MafjuVn8R+d4RbFwDYivHRaMp9x0gYav6plR
         a2+bTb+Wc3jYVgftXR1SRFnb6bXCh24i1Bis0uEOS7M/ZGcpe0bQ7q4AIa6eHcZLcjA7
         Rayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lK8Mx+c5zZgdOHePxCDJj4TbNSdiPp5ut0xpUlWpTP4=;
        b=OLdj4lMKFKUtWyUe1jklqcxtaVg8832cbA6ufE3ZXO62nRBh/d3fNblpbwcls/rg4S
         8M0VKhMgLeYsgy9RkrwaO708F7Uf0sikc6VD9ioL45Oi11w28jGdq+1mDKk2hHoMgyJM
         oBajTYCjmdD1uOQX7g6NqR2mMiRXdRXk+RIqD9ydK7lVcgJQzpyvhfu+ViKo+SEmsIEK
         poJ4L/9L/TqJLw6wIB6J5rEZDRBE9j4J9xdd9nVgqbA6aH/JvKsWYfM8unP3rCflvcrV
         +Q+yMU+m6PU+aqDMan3JepjKvZCcCjAiUqJQEe6nO25urPLPTppypUzud498NEV4H6qS
         20JA==
X-Gm-Message-State: AOAM53370IMP0p2NYAiGjFMm3W5E1UW1rvU+QbhwmLXspyCnlEH33qha
        sltizLdXmT0qMHWio6MBeQWZ/o+beauAw1gQKVk=
X-Google-Smtp-Source: ABdhPJy8daQq+hIo3HPMJX5ByHMxxCCzUxSVQ9iGoxxJcESoG5yTTIgw7mRZNzNbKEz/jIOp4ydajuze4Ke/Zb42WkA=
X-Received: by 2002:ac8:dc5:: with SMTP id t5mr18840782qti.246.1613956295101;
 Sun, 21 Feb 2021 17:11:35 -0800 (PST)
MIME-Version: 1.0
References: <20210220110356.84399-1-redsky110@gmail.com> <20210220.134402.2070871604757928182.davem@davemloft.net>
 <YDGHyxkTUGcuQbNZ@azazel.net>
In-Reply-To: <YDGHyxkTUGcuQbNZ@azazel.net>
From:   Honglei Wang <redsky110@gmail.com>
Date:   Mon, 22 Feb 2021 09:11:26 +0800
Message-ID: <CA+kCZ7_hUzitt9rjdUkJxWa+pMXU+3321Yw59n=8+NNpT5YDUg@mail.gmail.com>
Subject: Re: [PATCH] tcp: avoid unnecessary loop if even ports are used up
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 6:06 AM Jeremy Sowden <jeremy@azazel.net> wrote:
>
> On 2021-02-20, at 13:44:02 -0800, David Miller wrote:
> > From: Honglei Wang <redsky110@gmail.com>
> > Date: Sat, 20 Feb 2021 19:03:56 +0800
> >
> > > We are getting port for connect() from even ports firstly now. This
> > > makes bind() users have more available slots at odd part. But there is a
> > > problem here when the even ports are used up. This happens when there
> > > is a flood of short life cycle connections. In this scenario, it starts
> > > getting ports from the odd part, but each requirement has to walk all of
> > > the even port and the related hash buckets (it probably gets nothing
> > > before the workload pressure's gone) before go to the odd part. This
> > > makes the code path __inet_hash_connect()->__inet_check_established()
> > > and the locks there hot.
> > >
> > > This patch tries to improve the strategy so we can go faster when the
> > > even part is used up. It'll record the last gotten port was odd or even,
> > > if it's an odd one, it means there is no available even port for us and
> > > we probably can't get an even port this time, neither. So we just walk
> > > 1/16 of the whole even ports. If we can get one in this way, it probably
> > > means there are more available even part, we'll go back to the old
> > > strategy and walk all of them when next connect() comes. If still can't
> > > get even port in the 1/16 part, we just go to the odd part directly and
> > > avoid doing unnecessary loop.
> > >
> > > Signed-off-by: Honglei Wang <redsky110@gmail.com>
> > > ---
> > >  net/ipv4/inet_hashtables.c | 21 +++++++++++++++++++--
> > >  1 file changed, 19 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > > index 45fb450b4522..c95bf5cf9323 100644
> > > --- a/net/ipv4/inet_hashtables.c
> > > +++ b/net/ipv4/inet_hashtables.c
> > > @@ -721,9 +721,10 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> > >     struct net *net = sock_net(sk);
> > >     struct inet_bind_bucket *tb;
> > >     u32 remaining, offset;
> > > -   int ret, i, low, high;
> > > +   int ret, i, low, high, span;
> > >     static u32 hint;
> > >     int l3mdev;
> > > +   static bool last_port_is_odd;
> > >
> > >     if (port) {
> > >             head = &hinfo->bhash[inet_bhashfn(net, port,
> > > @@ -756,8 +757,19 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> > >      */
> > >     offset &= ~1U;
> > >  other_parity_scan:
> > > +   /* If the last available port is odd, it means
> > > +    * we walked all of the even ports, but got
> > > +    * nothing last time. It's telling us the even
> > > +    * part is busy to get available port. In this
> > > +    * case, we can go a bit faster.
> > > +    */
> > > +   if (last_port_is_odd && !(offset & 1) && remaining > 32)
> >
> > The first time this executes, won't last_port_is_odd be uninitialized?
>
> It's declared static, so it will be zero-initialized.
>
Yep, it'll be initialized as zero by default. I tried to initialize it
explicitly to false for the code logic, but the checkpatch.pl yielded
that it's incorrect to initialize static bool to false.
(Sorry for the last response which I forgot send with plain text mode..)

Thanks,
Honglei
> J.
