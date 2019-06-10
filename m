Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E267F3BF87
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390311AbfFJWeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:34:23 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:41272 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390266AbfFJWeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:34:23 -0400
Received: by mail-yb1-f194.google.com with SMTP id d2so4399857ybh.8
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TsVEpXGaziOtf6dCMTqugok1VaOj/14Vc+zvAlbZSKs=;
        b=lw3U0vAkMXIGClOAh3vBcxTZEhEddDD9ZRGTJT+JieGCMYz3Ir12CzGUSA5BdHa4yv
         nEaxDL7o03Hza/L5VfAIj4FL/xDZlFlk1cMwnShNWBLPfZAvNoUDHW5Zdg8mljNSv9tf
         qI6EGSMRU2gRlA47ciB4MwalzLBj8pppmDwbDJUDL1nIGeWfRYPgKQtyf1vRq0HTEFgc
         aRzsi5gi0T11St62PK8PpTvID7/GQTYYVQWO2CjPHTWRzKZmuC1tKS/XJV8bawDQgge6
         dDwMiDImb7KZbzOzkjssbnwLhdinYgPvN35FgteC6t4AD5NEvFTQVr0CKI+t86XyWMgm
         7sog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TsVEpXGaziOtf6dCMTqugok1VaOj/14Vc+zvAlbZSKs=;
        b=PNPG+SFC7PG3tLRaJYljb4yVjFc/zEUWiP5tzX7qV9W+sKUZARx84xrY+AD+smYFFw
         jFdKZZyZm4SCZT5q2dvRiQm0dGzyhCRV+N3TKzbmYKMIqdMcrGhhb8CIW3zw2O//kFDg
         2epK6Ov9hJXrezmACFrgotsUwPd2Sole2oCiwFHZkzca+327KSI6jgWkpar73//PPalK
         YFoun7mp8SLrJEnAEWZS4SM4JVjGQYMKNTXUlnMfzJWqpoysIf0jafcKm7JDDMJrNZAw
         p4Hc0VeWZ7DTm6vLP0hIgXuOf4ZVJ3yKATJHo1boqpA1WhaAxD48smQ6rmnitozGb7cW
         Ppiw==
X-Gm-Message-State: APjAAAXL/68LUcfJh9WmEampuxMjh91/FAOczc5GSy1Hs+EKh2CC/yQI
        PQn7ouhXqnYoZQDnC7n4HuZ50ZvXff8L4Z//k0HrEFMtXIa8Cg==
X-Google-Smtp-Source: APXvYqwE/15G107WoEoVtG4/tFL9mvkHRucbvTk61v8wSxbG492eifhMQOPAM2KpQs38+2fnKJrj3CdFjVffqlu7FFc=
X-Received: by 2002:a25:7642:: with SMTP id r63mr37451561ybc.253.1560206061733;
 Mon, 10 Jun 2019 15:34:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190610214543.92576-1-edumazet@google.com> <CAGHK07A7QuGpcfNGv0h3hdMj8U1GVkrmRyuwWRMRyrOwJWCOAQ@mail.gmail.com>
In-Reply-To: <CAGHK07A7QuGpcfNGv0h3hdMj8U1GVkrmRyuwWRMRyrOwJWCOAQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 10 Jun 2019 15:34:10 -0700
Message-ID: <CANn89iKrm2GuAsnP_Wpo4xre6dKKx9QouoXw9iop-nuzUiY_sw@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: take care of SYN_RECV sockets in
 tcp_v4_send_ack() and tcp_v6_send_response()
To:     Jonathan Maxwell <jmaxwell37@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 3:27 PM Jonathan Maxwell <jmaxwell37@gmail.com> wrote:
>
> Thanks for fixing that Eric.

Hi Jonathan.

There is no bug actually, at least not on sk->sk_mark part.

I will send a simpler patch so that sock_net_uid() correctly fetches
sk->sk_uid for FASTOPEN socket.

Thanks !



>
> On Tue, Jun 11, 2019 at 7:45 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > TCP can send ACK packets on behalf of SYN_RECV sockets.
> >
> > tcp_v4_send_ack() and tcp_v6_send_response() incorrectly
> > dereference sk->sk_mark for non TIME_WAIT sockets.
> >
> > This field is not defined for SYN_RECV sockets.
> >
> > Using sk_to_full_sk() should get back to the listener socket.
> >
> > Note that this also provides a socket pointer to sock_net_uid() calls.
> >
> > Fixes: 00483690552c ("tcp: Add mark for TIMEWAIT sockets")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Jon Maxwell <jmaxwell37@gmail.com>
> > ---
> >  net/ipv4/tcp_ipv4.c | 6 ++++--
> >  net/ipv6/tcp_ipv6.c | 1 +
> >  2 files changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index f059fbd81a84314ae6fef37f600b0cf28bd2ad30..2bb27d5eae78efdff52a741904d7526a234595d8 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -856,12 +856,14 @@ static void tcp_v4_send_ack(const struct sock *sk,
> >         if (oif)
> >                 arg.bound_dev_if = oif;
> >         arg.tos = tos;
> > -       arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
> >         local_bh_disable();
> >         ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
> > -       if (sk)
> > +       if (sk) {
> > +               sk = sk_to_full_sk(sk);
> >                 ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
> >                                    inet_twsk(sk)->tw_mark : sk->sk_mark;
> > +       }
> > +       arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
> >         ip_send_unicast_reply(ctl_sk,
> >                               skb, &TCP_SKB_CB(skb)->header.h4.opt,
> >                               ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
> > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > index ad7039137a20f9ad8581d9ca01347c67aa8a8433..ea4dd988bc7f9a90e0d95283e10db5a517a59027 100644
> > --- a/net/ipv6/tcp_ipv6.c
> > +++ b/net/ipv6/tcp_ipv6.c
> > @@ -884,6 +884,7 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
> >         }
> >
> >         if (sk) {
> > +               sk = sk_to_full_sk(sk);
> >                 if (sk->sk_state == TCP_TIME_WAIT) {
> >                         mark = inet_twsk(sk)->tw_mark;
> >                         /* autoflowlabel relies on buff->hash */
> > --
> > 2.22.0.rc2.383.gf4fbbf30c2-goog
> >
