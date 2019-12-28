Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F0B12BE0F
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 17:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfL1Qba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 11:31:30 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:33502 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfL1Qba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 11:31:30 -0500
Received: by mail-yb1-f193.google.com with SMTP id n66so12439984ybg.0
        for <netdev@vger.kernel.org>; Sat, 28 Dec 2019 08:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BAH0TqgiRPPEuOJbsqKFmPkFjgBnmOlBnhpP5aq/S+M=;
        b=RL3lQiEroyzFiyPVJuluQZZNUn+ge3p94acg55iSEZhRDRbv8SmVKbnB26xDyx4xFR
         oV9m/3lW0mDXXK+/OftR9OAUvvGNuyIjqWE4hl/VutDO0U22u0sZvShpOEMOLOpxbC+Y
         FaKLQS9pWPPU4hUlASmf073qMDVLclrgCuMv44yNKv+gMvHgZTJQuHlZhrvK1CgRyZxo
         FsNx0iP9bo/y7MV5oONZ/Kfu7WdmTuQvqvPit3Wk7WwzCNr8D/U2DVePhPY5ZHoy1oXk
         GgzdAt03bHJbSwxGnvtFimB193Oeg++fb4w2gb0sXk7zY5izurZH2l25FeFnf5Alx0UD
         veOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BAH0TqgiRPPEuOJbsqKFmPkFjgBnmOlBnhpP5aq/S+M=;
        b=gsfTYCyUpv9p4WfHl9JvTPLuMFGhFn59fhJdX2phdM8xAtQcSJc0BZs6Yi6qJ2nesH
         pvObwBEYYRBI5/pSqzFOKYhKEoRff4xf7J+45yKZzDNU4u3M1HYMCMkJazRR2eadnOvQ
         azyssTyeuJp8QH56mXQCIykl2xrGEvzF74SWMeeJRmGJOHcEhf3USRSNftSvRRXOWLgM
         LTp1uJd9oXJDKAhdyHo/ZiBeOt0FIiUhQDMTygcMfhE8XTmTodBGaBnKagBtS/hgKs9G
         IK0Ii7+ToZxTm6hlAmhMMCeP4kcHfh2oxOKMxFSpKRRcGcAlz1uLN0qP5AhreqU5P0sr
         hQUA==
X-Gm-Message-State: APjAAAWh0YWm+m2JrEf9NJcJGTQ0IFBW/GWAiGOO7wNKFzAbH9xRKrD6
        I8gqo82hybhRAtv496rIbOZvzu2XeinzBYuHqbZqQQ==
X-Google-Smtp-Source: APXvYqx1uWRhPhvWJs8VKwO0NdS26MsNAaLrlqppXbq1JVQaocC91VRPpk+i6S3Tz5N+2dZUduPotrZ86BFvUIWy5S0=
X-Received: by 2002:a25:7ec7:: with SMTP id z190mr22757732ybc.364.1577550688183;
 Sat, 28 Dec 2019 08:31:28 -0800 (PST)
MIME-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com> <20191223202754.127546-5-edumazet@google.com>
 <CADVnQyma12zfkJs4uVN6kLZX_ubDUhsVX6mZ0-4Ci-+xF4xH5w@mail.gmail.com>
In-Reply-To: <CADVnQyma12zfkJs4uVN6kLZX_ubDUhsVX6mZ0-4Ci-+xF4xH5w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 28 Dec 2019 08:31:16 -0800
Message-ID: <CANn89iLX2LgitKfNSh5Tw0bVmCRyvrMt5RVxJtFkgwxik+RGXw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/5] tcp_cubic: tweak Hystart detection for
 short RTT flows
To:     Neal Cardwell <ncardwell@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 8:01 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Mon, Dec 23, 2019 at 3:28 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > After switching ca->delay_min to usec resolution, we exit
> > slow start prematurely for very low RTT flows, setting
> > snd_ssthresh to 20.
> >
> > The reason is that delay_min is fed with RTT of small packet
> > trains. Then as cwnd is increased, TCP sends bigger TSO packets.
> >
> > LRO/GRO aggregation and/or interrupt mitigation strategies
> > on receiver tend to inflate RTT samples.
> >
> > Fix this by adding to delay_min the expected delay of
> > two TSO packets, given current pacing rate.
> ...
> > diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
> > index 068775b91fb5790e6e60a6490b49e7a266e4ed51..0e5428ed04fe4e50627e21a53c3d17f9f2dade4d 100644
> > --- a/net/ipv4/tcp_cubic.c
> > +++ b/net/ipv4/tcp_cubic.c
> > @@ -436,8 +436,27 @@ static void bictcp_acked(struct sock *sk, const struct ack_sample *sample)
> >                 delay = 1;
> >
> >         /* first time call or link delay decreases */
> > -       if (ca->delay_min == 0 || ca->delay_min > delay)
> > -               ca->delay_min = delay;
> > +       if (ca->delay_min == 0 || ca->delay_min > delay) {
> > +               unsigned long rate = READ_ONCE(sk->sk_pacing_rate);
> > +
> > +               /* Account for TSO/GRO delays.
> > +                * Otherwise short RTT flows could get too small ssthresh,
> > +                * since during slow start we begin with small TSO packets
> > +                * and could lower ca->delay_min too much.
> > +                * Ideally even with a very small RTT we would like to have
> > +                * at least one TSO packet being sent and received by GRO,
> > +                * and another one in qdisc layer.
> > +                * We apply another 100% factor because @rate is doubled at
> > +                * this point.
>
> This comment mentions "@rate is doubled at this point". But AFAICT
> this part of the code is executed on every ACK, not just in slow
> start, so the rate is not really always doubled at this point. It
> might be more clear/precise to say  "@rate can be doubled at this
> point"?
>
>
> > +                * We cap the cushion to 1ms.
> > +                */
> > +               if (rate)
> > +                       delay += min_t(u64, USEC_PER_MSEC,
> > +                                      div64_ul((u64)GSO_MAX_SIZE *
> > +                                               4 * USEC_PER_SEC, rate));
> > +               if (ca->delay_min == 0 || ca->delay_min > delay)
> > +                       ca->delay_min = delay;
> > +       }
> >
> >         /* hystart triggers when cwnd is larger than some threshold */
> >         if (!ca->found && hystart && tcp_in_slow_start(tp) &&
>
> AFAICT there may be some CPU usage impact here for high-speed
> intra-datacenter flows due to an extra div64_ul() being executed on
> most ACKs? It seems like if 'ca->delay_min > delay' then the code
> executes the div64_ul() to calculate the cushion and add it to
> 'delay'. Then the  ca->delay_min is recorded with the cushion added.
>
> But the first 'ca->delay_min > delay' comparison that determines
> whether we execute the div64_ul() is comparing a ca->delay_min that
> has a cushion included to the 'delay' that has no cushion included. So
> if the raw 'delay' value is within the cushion of the raw min_rtt
> value, then this 'ca->delay_min > delay' expression will evaluate to
> true, and we'll run the div64_ul() even though there is probably not a
> need to.
>
> How big is the cushion? In back of the envelope terms, for a 10
> Gbit/sec link where CUBIC has exited the initial slow start and is
> using a pacing rate matching the link rate, then AFAICT the cushion
> should be roughly:
>   4 * 65536 * 1000000 / (1.2*10*10^9/8) ~= 175 usecs
> So if that math is in the right ballpark, then any RTT sample that is
> within roughly 175 usec of the true min_rtt is going to have
> 'ca->delay_min > delay' evaluate to true, and run the div64_ul() when
> there is probably no need.

In my tests the cushion was about ~100 usec for 10Gbit links.

>
> AFAICT there is also some risk with this patch that the steady-state
> behavior of CUBIC becomes slightly more aggressive for moderate-rate,
> low-RTT cases. In such cases this up to ~1ms of cushion to delay_min
> will cause the bictcp_update() line:
>
>  t += usecs_to_jiffies(ca->delay_min);
>
> to calculate the target cwnd at a point in time that is ~1ms further
> out than before, and thus possibly grow the cwnd faster than it would
> have before.
>
> To avoid the risk of extra divisions on many ACKs, and the risk of
> more aggressive cwnd behavior in the steady state, WDYT about an
> approach where the cushioned delay_min used by your revised Hystart
> code (ACK train heuristic and delay heuristic) is maintained
> separately from the "pure" delay_min used elsewhere in the CUBIC code,
> perhaps as a new ca->delay_min_hystart field? I am wondering about an
> approach something like:
>
> /* Account for TSO/GRO delays. ...
> */
> static u32 update_delay_min_hystart(struct sock *sk)
> {
>         unsigned long rate = READ_ONCE(sk->sk_pacing_rate);
>         u32 ack_delay = 0;
>
>         if (ca->found)
>                 return;  /* Hystart is done */
>
>         if (rate)
>                 ack_delay = min_t(u64, USEC_PER_MSEC,
>                                   div64_ul((u64)GSO_MAX_SIZE *
>                                            4 * USEC_PER_SEC, rate));
>         ca->delay_min_hystart = ca->delay_min + ack_delay;

Note that while testing this, I found that ca->delay_min_hystart was
latched while initial sk_pacing_rate is rather small.

This means we exit slow start with much higher cwnd/ssthresh (Hystart
triggers too late IMO)

$ nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpaa24 -l
-4000000; done;nstat|egrep "Hystart"
   4209
  13236
   3602
  16635
  16139
   4159
   3963
   3956
   4319
   4121
TcpExtTCPHystartTrainDetect     7                  0.0
TcpExtTCPHystartTrainCwnd       8256               0.0

$ dmesg|tail -7
[  144.637752]  ack_train delay_min 23 (delay_min_hystart 348) cwnd 1704
[  146.924494]  ack_train delay_min 28 (delay_min_hystart 202) cwnd 480
[  150.338917]  ack_train delay_min 20 (delay_min_hystart 264) cwnd 1614
[  151.481355]  ack_train delay_min 23 (delay_min_hystart 172) cwnd 1026
[  152.607829]  ack_train delay_min 20 (delay_min_hystart 241) cwnd 1071
[  153.742571]  ack_train delay_min 20 (delay_min_hystart 237) cwnd 1434
[  154.890514]  ack_train delay_min 21 (delay_min_hystart 116) cwnd 927


We might have to compute the ack_delay even if ca->delay_min has not
been lowered (since sk_pacing_rate is doubling every RTT regardless of
delay_min changes)

> }
>
> ...
>         if (ca->delay_min == 0 || ca->delay_min > delay) {
>                 ca->delay_min = delay;
>                 update_delay_min_hystart(sk);
>         }
>
> WDYT?


I think these are all very good suggestions Neal, I cooked a patch
that I will send after more tests.

Thanks for spending time on this stuff, especially at this time of the year :)
