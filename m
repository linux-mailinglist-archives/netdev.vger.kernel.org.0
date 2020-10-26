Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CF8298D0B
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 13:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775411AbgJZMrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 08:47:16 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36019 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1775403AbgJZMrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 08:47:15 -0400
Received: by mail-yb1-f193.google.com with SMTP id f140so7537490ybg.3;
        Mon, 26 Oct 2020 05:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=krigQ3i6dCn+qzXzyflYkj7VuDlk3im8wf3RIOQnyu0=;
        b=pxj7fdi5TwNz1sp0SG2lcxXmD0z87mAO+WmV/PZXXxNp/FMCekwhBBg0DHy3OdGuOX
         i31VsFgafs/VXGMZUvU6Biuar+lcVhGWctnL8wjUeER61KPnR/SQugSNcYNzTaweDqih
         qMjYLUlUqfM6NUJ5Pt6dg8gnQMpOHvJF1ftBOrJrlCJGfDwMZ7OlyVIovhKARNYMfQZu
         bdAx3bT4z5bDwJiEArnxN7p9prYUm3scJeMUnVVN8kF7wc0xSxdJNr4hOwYvfJgk5OlI
         hoWBzGVln/nxok/OLuvN2VTGyymqZyPVj2wB17u+epv6X58lCuoMBJHhV888Sisqjtn3
         G7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=krigQ3i6dCn+qzXzyflYkj7VuDlk3im8wf3RIOQnyu0=;
        b=UpL5IQp0KFjCDqpOXvACVdLGU9aPzh/qFcDxojT737Du/2C6OiyMNAVDfPzH8/piox
         qlIVDh3JkXUUn+F9mx00cjjfnq8Dwpu5qgPOPZkhKjhyAF+SNGuoF1edwkVcqKsgymmC
         +t4bcD8MCZLj1JkUt+TMJGWWvL5MJCj/GDWUbEm2Wmj8og/Z2Jr5K2cotDkdLGu8nTyn
         P7XxlDxgrfbCUMUSI99bapD9slu6YttM8V6LdbsglsPDbsIwrs9/kLcpWkahuQOGjiQH
         aPNYx5XfA2r7U+aIVYF/JrDc6lhB5rdsTh//wNGpFcwztH1oCxmSsgiCskkBqt0daLZ/
         GXaQ==
X-Gm-Message-State: AOAM533wuzqxsWRoZ36rtgQ9oe0v6VYvn7U0oxfY3c0+2UxPGuXtWWUm
        sBsOa1rhNngwMXxpXt7AtE2izWLgbU2w1ROKeTXR3nrNEcQ=
X-Google-Smtp-Source: ABdhPJzrnX+CzY0KVfOlcv5KZkRi5XGyHH+EvYDjHWe0C/bOb802ge8/+ABSQDcFQ2AVcpP57bskV/8mSTnyaYvKz7c=
X-Received: by 2002:a25:2e4c:: with SMTP id b12mr20497894ybn.336.1603716433785;
 Mon, 26 Oct 2020 05:47:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201026093907.13799-1-menglong8.dong@gmail.com> <acbb8a3a7bd83ee1121dfa91c207e4681a01d2d8.camel@redhat.com>
In-Reply-To: <acbb8a3a7bd83ee1121dfa91c207e4681a01d2d8.camel@redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Mon, 26 Oct 2020 20:47:01 +0800
Message-ID: <CADxym3bwD+XBRmrtN6Bh1p9QQy_H7gx1o98eU+pWgPeDtVxX5w@mail.gmail.com>
Subject: Re: [PATCH] net: udp: increase UDP_MIB_RCVBUFERRORS when ENOBUFS
To:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello~

On Mon, Oct 26, 2020 at 5:52 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Mon, 2020-10-26 at 17:39 +0800, Menglong Dong wrote:
> > The error returned from __udp_enqueue_schedule_skb is ENOMEM or ENOBUFS.
> > For now, only ENOMEM is counted into UDP_MIB_RCVBUFERRORS in
> > __udp_queue_rcv_skb. UDP_MIB_RCVBUFERRORS should count all of the
> > failed skb because of memory errors during udp receiving, not just because of the limit of sock receive queue. We can see this
> > in __udp4_lib_mcast_deliver:
> >
> >               nskb = skb_clone(skb, GFP_ATOMIC);
> >
> >               if (unlikely(!nskb)) {
> >                       atomic_inc(&sk->sk_drops);
> >                       __UDP_INC_STATS(net, UDP_MIB_RCVBUFERRORS,
> >                                       IS_UDPLITE(sk));
> >                       __UDP_INC_STATS(net, UDP_MIB_INERRORS,
> >                                       IS_UDPLITE(sk));
> >                       continue;
> >               }
> >
> > See, UDP_MIB_RCVBUFERRORS is increased when skb clone failed. From this
> > point, ENOBUFS from __udp_enqueue_schedule_skb should be counted, too.
> > It means that the buffer used by all of the UDP sock is to the limit, and
> > it ought to be counted.
> >
> > Signed-off-by: Menglong Dong <menglong8.dong@gmail.com>
> > ---
> >  net/ipv4/udp.c | 4 +---
> >  net/ipv6/udp.c | 4 +---
> >  2 files changed, 2 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 09f0a23d1a01..49a69d8d55b3 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -2035,9 +2035,7 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> >               int is_udplite = IS_UDPLITE(sk);
> >
> >               /* Note that an ENOMEM error is charged twice */
> > -             if (rc == -ENOMEM)
> > -                     UDP_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS,
> > -                                     is_udplite);
> > +             UDP_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS, is_udplite);
> >               UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
> >               kfree_skb(skb);
> >               trace_udp_fail_queue_rcv_skb(rc, sk);
> > diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> > index 29d9691359b9..d5e23b150fd9 100644
> > --- a/net/ipv6/udp.c
> > +++ b/net/ipv6/udp.c
> > @@ -634,9 +634,7 @@ static int __udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> >               int is_udplite = IS_UDPLITE(sk);
> >
> >               /* Note that an ENOMEM error is charged twice */
> > -             if (rc == -ENOMEM)
> > -                     UDP6_INC_STATS(sock_net(sk),
> > -                                      UDP_MIB_RCVBUFERRORS, is_udplite);
> > +             UDP6_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS, is_udplite);
> >               UDP6_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
> >               kfree_skb(skb);
> >               return -1;
>
> The diffstat is nice, but I'm unsure we can do this kind of change
> (well, I really think we should not do it): it will fool any kind of
> existing users (application, scripts, admin) currently reading the
> above counters and expecting UDP_MIB_RCVBUFERRORS being increased with
> the existing schema.
>
> Cheers,
>
> Paolo
>

Well, your words make sense, this change isn't friendly for the existing users.
It really puzzled me when this ENOBUFS happened, no counters were done and
I hardly figured out what happened.

So, is it a good idea to introduce a 'UDP_MIB_MEMERRORS'?

Cheers,

Menglong Dong
