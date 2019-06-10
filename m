Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA8F3BF8E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390152AbfFJWlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:41:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50199 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388328AbfFJWlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:41:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id c66so891360wmf.0
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R4+fUUeRVFMeSMJsBklKNySqGjFd01J2rCysZiDEyXM=;
        b=BqhXmXvmxJTT+mjn5tDXbTvKiQ9Ye5I2WLNXHhZv+4nb+WDODALLuBvHKF9zZs3Ji4
         3zePUeu3gNVsJbCjI5TLH7ugtMnQQCgRsVGwIO381CQCS2gho/VeiMY4qn3w2rnCoSFT
         bQQVu3sTGW+nRZ941SwrNy8jAXyZPbcWOcb7kf5UYHoPTDoySwdgqsPDiLneBwq98w8i
         acvQ9b+AGmejwS5wlpEQazfpu7Qfp7jd8mAqPKd3ErujLhue1530OyAYTFmq6BmnG/ah
         9G3efKpscwPYocp64FXhh/E74jLuRHkcEPkSd7tz9zcD947YQgfZ7CLeaT8ouya71+xL
         a5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R4+fUUeRVFMeSMJsBklKNySqGjFd01J2rCysZiDEyXM=;
        b=iggX/GprJCkoxs7IWso+UD4SyHf300vlfrRxZyAAMY51bFbytV2/EFBHEzBaDbYjC0
         GLgJXVCvpg/sXga0SHAPzY1x2A2hsBgQIRBuHzWd6yTwCwDS0Uv59REp8awtrRWWwOoC
         Z9EFKn7GBxQ9k7b/ENPgWgp59tnKla/Xs7Vjye2GJOkvDSqDt9BzGPjzqrimFjKedXm8
         U3zPiHbqmIliQ5kqMHr975DRNrTYrIOXfASdw9CauEvId+gccRS5oKaWM1IvbZ+FZchI
         VnSWaf7NeZsaucdXIS5hZ2qqY6W6kAu/4XjtU2G7JlrYYvnRBmqVVzD+UM2Dh7W9yQ1z
         jNYA==
X-Gm-Message-State: APjAAAUYlEw2bXQvwzKkN2OfYa62tuig7AKzwY/CpFsDssedEiLC0amp
        f2ExRN6Q55siBCRgXlQGRUvgWnAj3bYIzOZlqja1Wg==
X-Google-Smtp-Source: APXvYqwH7vYPL4qL09SR8Wv7l56gD1nNGwRmNKGCa5MTJaDUCmOhjZR8hVOBQK7H6xL6MFOQCOzZi+mpOy2x2HNycBg=
X-Received: by 2002:a1c:4184:: with SMTP id o126mr15158759wma.68.1560206460925;
 Mon, 10 Jun 2019 15:41:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190610214543.92576-1-edumazet@google.com> <CAGHK07A7QuGpcfNGv0h3hdMj8U1GVkrmRyuwWRMRyrOwJWCOAQ@mail.gmail.com>
 <CANn89iKrm2GuAsnP_Wpo4xre6dKKx9QouoXw9iop-nuzUiY_sw@mail.gmail.com>
In-Reply-To: <CANn89iKrm2GuAsnP_Wpo4xre6dKKx9QouoXw9iop-nuzUiY_sw@mail.gmail.com>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Tue, 11 Jun 2019 08:40:24 +1000
Message-ID: <CAGHK07A3r1FTDPyNFLKq2S9TaT1COKEGF3wpCgjBmY0+TSnnXg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: take care of SYN_RECV sockets in
 tcp_v4_send_ack() and tcp_v6_send_response()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sounds good Eric. Thanks

On Tue, Jun 11, 2019 at 8:34 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Jun 10, 2019 at 3:27 PM Jonathan Maxwell <jmaxwell37@gmail.com> wrote:
> >
> > Thanks for fixing that Eric.
>
> Hi Jonathan.
>
> There is no bug actually, at least not on sk->sk_mark part.
>
> I will send a simpler patch so that sock_net_uid() correctly fetches
> sk->sk_uid for FASTOPEN socket.
>
> Thanks !
>
>
>
> >
> > On Tue, Jun 11, 2019 at 7:45 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > TCP can send ACK packets on behalf of SYN_RECV sockets.
> > >
> > > tcp_v4_send_ack() and tcp_v6_send_response() incorrectly
> > > dereference sk->sk_mark for non TIME_WAIT sockets.
> > >
> > > This field is not defined for SYN_RECV sockets.
> > >
> > > Using sk_to_full_sk() should get back to the listener socket.
> > >
> > > Note that this also provides a socket pointer to sock_net_uid() calls.
> > >
> > > Fixes: 00483690552c ("tcp: Add mark for TIMEWAIT sockets")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Cc: Jon Maxwell <jmaxwell37@gmail.com>
> > > ---
> > >  net/ipv4/tcp_ipv4.c | 6 ++++--
> > >  net/ipv6/tcp_ipv6.c | 1 +
> > >  2 files changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > > index f059fbd81a84314ae6fef37f600b0cf28bd2ad30..2bb27d5eae78efdff52a741904d7526a234595d8 100644
> > > --- a/net/ipv4/tcp_ipv4.c
> > > +++ b/net/ipv4/tcp_ipv4.c
> > > @@ -856,12 +856,14 @@ static void tcp_v4_send_ack(const struct sock *sk,
> > >         if (oif)
> > >                 arg.bound_dev_if = oif;
> > >         arg.tos = tos;
> > > -       arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
> > >         local_bh_disable();
> > >         ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
> > > -       if (sk)
> > > +       if (sk) {
> > > +               sk = sk_to_full_sk(sk);
> > >                 ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
> > >                                    inet_twsk(sk)->tw_mark : sk->sk_mark;
> > > +       }
> > > +       arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
> > >         ip_send_unicast_reply(ctl_sk,
> > >                               skb, &TCP_SKB_CB(skb)->header.h4.opt,
> > >                               ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
> > > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > > index ad7039137a20f9ad8581d9ca01347c67aa8a8433..ea4dd988bc7f9a90e0d95283e10db5a517a59027 100644
> > > --- a/net/ipv6/tcp_ipv6.c
> > > +++ b/net/ipv6/tcp_ipv6.c
> > > @@ -884,6 +884,7 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
> > >         }
> > >
> > >         if (sk) {
> > > +               sk = sk_to_full_sk(sk);
> > >                 if (sk->sk_state == TCP_TIME_WAIT) {
> > >                         mark = inet_twsk(sk)->tw_mark;
> > >                         /* autoflowlabel relies on buff->hash */
> > > --
> > > 2.22.0.rc2.383.gf4fbbf30c2-goog
> > >
