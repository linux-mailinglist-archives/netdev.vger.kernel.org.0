Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF49F2D7A7D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 17:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390795AbgLKQEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 11:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390417AbgLKQDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 11:03:42 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BC2C0613CF;
        Fri, 11 Dec 2020 08:03:02 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id z136so9968611iof.3;
        Fri, 11 Dec 2020 08:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+abQIG78HGppl25COcLx0h9sjwwHX6wS+R3XmzIB6w8=;
        b=OZ0uHxJnwFIgUbyhA4A7dzfu7DXIuKUIAfd5jIDNbJKluZYhQcNfsSrd84xCQmQoSX
         rxypop3lhxDwCWEWFNU2XQcZSJHLawvaa82qD8+7AduiK5d9k1ufWiERCllkZc6ftEpE
         NIk/wJNo1M5sQ8UaXfwC+5mk8VviSsdNi72WQoZ/5NrUQ9NpS1K+ga33jvwsfwKY1jMj
         ZWy+He0OaIjOPwiJbxHJ2D8/0g396ohPGmRWFONZHaXzQ8X77qLLMP1lAhtR5QehmUeQ
         Am2zUH5ivLkgTA/P5gpbm7S5JEqr1etAN8v+/cD8lXI9dbsP6PqccTnerlgqQ6+/j36o
         Fm0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+abQIG78HGppl25COcLx0h9sjwwHX6wS+R3XmzIB6w8=;
        b=krq3pxhHdkIdgd1WIiOgGsW+657gWGKs+9Rws/59Fc2X8qsSPu+mfCDHQG+leWWBWa
         h2W8oSFg0RauookjBh7yrnusGV1sqX//NSjFJzztFbVn40FmHrFw2ztMCtCk+ZPGX+tU
         JUbC0vtzfM34JaGNpKjVQuKW/RqZsRy5OXnV9Gp7akcnAJqYm73CAYoPVi2VPJ3JlhEb
         V4j3rURjFYGW/wkIZ1N7HSd4n5m3F31n/n8QzxfehMAkRZ4fXj5k56X8mifSI+EZ9KP9
         pfaElzF2KzS2EXeKRAclKIv4bcTVhZILjg21vunxVBjQzX9xItTJGfdCwfipxynb9Ri9
         9RWw==
X-Gm-Message-State: AOAM533Fp2ku+ixfc7bKxivEo4RCEGlAko8KC4Zu23ni1dRfMOQSinGV
        /qEATu3P5jTOxSZj/u+UoWz5nO6YyqIcqgzll6Y=
X-Google-Smtp-Source: ABdhPJxmDHaSxaC5XBB+E5/8aq5JuvLyNHRbrWTDjsf8e0B5KYsO5CBvDEoSMuEcT3pA6aQ6gurIos769X3tHkUStbg=
X-Received: by 2002:a02:4:: with SMTP id 4mr16546331jaa.121.1607702581646;
 Fri, 11 Dec 2020 08:03:01 -0800 (PST)
MIME-Version: 1.0
References: <160765171921.6905.7897898635812579754.stgit@localhost.localdomain>
 <CANn89iJ5HnJYv6eWb1jm6rK173DFkp2GRnfvi9vnYwXZPzE4LQ@mail.gmail.com>
In-Reply-To: <CANn89iJ5HnJYv6eWb1jm6rK173DFkp2GRnfvi9vnYwXZPzE4LQ@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 11 Dec 2020 08:02:50 -0800
Message-ID: <CAKgT0Uf_q=FgMHd9_wq5Bx8rCC-kS0Qz563rE9dL2hpQ6Evppg@mail.gmail.com>
Subject: Re: [net PATCH] tcp: Mark fastopen SYN packet as lost when receiving ICMP_TOOBIG/ICMP_FRAG_NEEDED
To:     Eric Dumazet <edumazet@google.com>
Cc:     Yuchung Cheng <ycheng@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 10:24 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Dec 11, 2020 at 2:55 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > In the case of a fastopen SYN there are cases where it may trigger either a
> > ICMP_TOOBIG message in the case of IPv6 or a fragmentation request in the
> > case of IPv4. This results in the socket stalling for a second or more as
> > it does not respond to the message by retransmitting the SYN frame.
> >
> > Normally a SYN frame should not be able to trigger a ICMP_TOOBIG or
> > ICMP_FRAG_NEEDED however in the case of fastopen we can have a frame that
> > makes use of the entire MTU. In the case of fastopen it does, and an
> > additional complication is that the retransmit queue doesn't contain the
> > original frames. As a result when tcp_simple_retransmit is called and
> > walks the list of frames in the queue it may not mark the frames as lost
> > because both the SYN and the data packet each individually are smaller than
> > the MSS size after the adjustment. This results in the socket being stalled
> > until the retransmit timer kicks in and forces the SYN frame out again
> > without the data attached.
> >
> > In order to resolve this we need to mark the SYN frame as lost if it is the
> > first packet in the queue. Doing this allows the socket to recover much
> > more quickly without the retransmit timeout stall.
> >
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
>
>
> I do not think it is net candidate, but net-next
>
> Yuchung might correct me, but I think TCP Fastopen standard was very
> conservative about payload len in the SYN packet
>
> So receiving an ICMP was never considered.

That's fine. I can target this for net-next. I had just selected net
since I had considered it a fix, but I suppose it could be considered
a behavioral change.

> > ---
> >  include/net/tcp.h    |    1 +
> >  net/ipv4/tcp_input.c |    8 ++++++++
> >  net/ipv4/tcp_ipv4.c  |    6 ++++++
> >  net/ipv6/tcp_ipv6.c  |    4 ++++
> >  4 files changed, 19 insertions(+)
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index d4ef5bf94168..6181ad98727a 100644
> > --- a/include/net/tcp.h
>
>
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -546,6 +546,12 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
> >                         if (sk->sk_state == TCP_LISTEN)
> >                                 goto out;
> >
> > +                       /* fastopen SYN may have triggered the fragmentation
> > +                        * request. Mark the SYN or SYN/ACK as lost.
> > +                        */
> > +                       if (sk->sk_state == TCP_SYN_SENT)
> > +                               tcp_mark_syn_lost(sk);
>
> This is going to crash in some cases, you do not know if you own the socket.
> (Look a few lines below)

Okay, I will look into moving this down into the block below since I
assume if it is owned by user we cannot make these changes.

> > +
> >                         tp->mtu_info = info;
> >                         if (!sock_owned_by_user(sk)) {
> >                                 tcp_v4_mtu_reduced(sk);
> > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > index 992cbf3eb9e3..d7b1346863e3 100644
> > --- a/net/ipv6/tcp_ipv6.c
> > +++ b/net/ipv6/tcp_ipv6.c
> > @@ -443,6 +443,10 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
> >                 if (!ip6_sk_accept_pmtu(sk))
> >                         goto out;
> >
> > +               /* fastopen SYN may have triggered TOOBIG, mark it lost. */
> > +               if (sk->sk_state == TCP_SYN_SENT)
> > +                       tcp_mark_syn_lost(sk);
>
>
> Same issue here.

I'll move this one too.

> > +
> >                 tp->mtu_info = ntohl(info);
> >                 if (!sock_owned_by_user(sk))
> >                         tcp_v6_mtu_reduced(sk);
> >
> >
