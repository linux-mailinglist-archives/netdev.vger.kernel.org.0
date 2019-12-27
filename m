Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5ECF12B5C3
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 17:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfL0QBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 11:01:15 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:37045 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfL0QBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 11:01:14 -0500
Received: by mail-oi1-f196.google.com with SMTP id z64so3298967oia.4
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 08:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WK4iVOH39mVAlbG5FDJY7+5ncV7Ux3BI9B86Yy9O7b0=;
        b=jjupyFidZ3ABMcE/XksfEcnLE4mrmVpxhijeS2I1/Uu4MvFUp7DJkrqTm+lKvB9X8D
         j7nD5NXB3VAuB62hAmy/lRAMJQR6cLMYe28NR1kyvmk9OYdfXG07TrS65ls0Q8MlL5R0
         /r5QaCIRQ1Z9d+6LqwAVlt1uN5miYrV9dHBR0Pkexux6IrjzZKmjRD7c1SYBvvMMIKY5
         js4OL854wQmvOFTtMZWiUlfy7+r6wqhK9LJYpSPQptoyMi8cz9S62SVCdBMqQuxg0qEZ
         HPfsw5kq0LKikPia3H+Yr3HUCgrfUtn6AYyvMYAxjXHbylC/DemUZRM81C9/lXslezZT
         4xhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WK4iVOH39mVAlbG5FDJY7+5ncV7Ux3BI9B86Yy9O7b0=;
        b=BT/tGLfeIYaHjYpQOQd9x02RzR2016vGg14TowdOYuEH8M/YWqtVXkILTssctzpHEn
         +41KMrBLfzmKRGvXkeGV4HzUio/sipwojngsAhVxOjKV1VbQuvQywguXmiCEdNJFH1k0
         4XoVpXsja4QpGLNbHSyisbRjC/6qcu6/u3I0S5+5c1Z5mH0K/El/9azDYcKhkpgZcVAu
         jTBcOLPIdHkd/WO5+y8Bpa6vjePTmXtjeU6PLB0lPmJMg7x9WOU2VKGVNbPvpB8C6fbu
         WwAbiHXCQ+26a2OxGEGTOIsVwqwW4X6Zo4664A6RdsJRYE13MqRofgELo0m3GyCE4hez
         srdw==
X-Gm-Message-State: APjAAAXtQMkD7LFgSLbZmxB+UTRMSACZnyUePx2KGJOVATcYHeESdvhR
        jkOKeQsOjn8VapbF7OVdp0lz5iabEsjvnUKe6/Ty8Q==
X-Google-Smtp-Source: APXvYqzAiyrMQgVU2ufN8tK3Im9ebDRZ0AroUjOcLkTELouAOnBEyCb80Y3myT5ec1Lh10PWe8PCjFrTdFqlIw+jViw=
X-Received: by 2002:a05:6808:2c4:: with SMTP id a4mr1275942oid.22.1577462473030;
 Fri, 27 Dec 2019 08:01:13 -0800 (PST)
MIME-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com> <20191223202754.127546-5-edumazet@google.com>
In-Reply-To: <20191223202754.127546-5-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 27 Dec 2019 11:00:56 -0500
Message-ID: <CADVnQyma12zfkJs4uVN6kLZX_ubDUhsVX6mZ0-4Ci-+xF4xH5w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/5] tcp_cubic: tweak Hystart detection for
 short RTT flows
To:     Eric Dumazet <edumazet@google.com>
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

On Mon, Dec 23, 2019 at 3:28 PM Eric Dumazet <edumazet@google.com> wrote:
>
> After switching ca->delay_min to usec resolution, we exit
> slow start prematurely for very low RTT flows, setting
> snd_ssthresh to 20.
>
> The reason is that delay_min is fed with RTT of small packet
> trains. Then as cwnd is increased, TCP sends bigger TSO packets.
>
> LRO/GRO aggregation and/or interrupt mitigation strategies
> on receiver tend to inflate RTT samples.
>
> Fix this by adding to delay_min the expected delay of
> two TSO packets, given current pacing rate.
...
> diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
> index 068775b91fb5790e6e60a6490b49e7a266e4ed51..0e5428ed04fe4e50627e21a53c3d17f9f2dade4d 100644
> --- a/net/ipv4/tcp_cubic.c
> +++ b/net/ipv4/tcp_cubic.c
> @@ -436,8 +436,27 @@ static void bictcp_acked(struct sock *sk, const struct ack_sample *sample)
>                 delay = 1;
>
>         /* first time call or link delay decreases */
> -       if (ca->delay_min == 0 || ca->delay_min > delay)
> -               ca->delay_min = delay;
> +       if (ca->delay_min == 0 || ca->delay_min > delay) {
> +               unsigned long rate = READ_ONCE(sk->sk_pacing_rate);
> +
> +               /* Account for TSO/GRO delays.
> +                * Otherwise short RTT flows could get too small ssthresh,
> +                * since during slow start we begin with small TSO packets
> +                * and could lower ca->delay_min too much.
> +                * Ideally even with a very small RTT we would like to have
> +                * at least one TSO packet being sent and received by GRO,
> +                * and another one in qdisc layer.
> +                * We apply another 100% factor because @rate is doubled at
> +                * this point.

This comment mentions "@rate is doubled at this point". But AFAICT
this part of the code is executed on every ACK, not just in slow
start, so the rate is not really always doubled at this point. It
might be more clear/precise to say  "@rate can be doubled at this
point"?


> +                * We cap the cushion to 1ms.
> +                */
> +               if (rate)
> +                       delay += min_t(u64, USEC_PER_MSEC,
> +                                      div64_ul((u64)GSO_MAX_SIZE *
> +                                               4 * USEC_PER_SEC, rate));
> +               if (ca->delay_min == 0 || ca->delay_min > delay)
> +                       ca->delay_min = delay;
> +       }
>
>         /* hystart triggers when cwnd is larger than some threshold */
>         if (!ca->found && hystart && tcp_in_slow_start(tp) &&

AFAICT there may be some CPU usage impact here for high-speed
intra-datacenter flows due to an extra div64_ul() being executed on
most ACKs? It seems like if 'ca->delay_min > delay' then the code
executes the div64_ul() to calculate the cushion and add it to
'delay'. Then the  ca->delay_min is recorded with the cushion added.

But the first 'ca->delay_min > delay' comparison that determines
whether we execute the div64_ul() is comparing a ca->delay_min that
has a cushion included to the 'delay' that has no cushion included. So
if the raw 'delay' value is within the cushion of the raw min_rtt
value, then this 'ca->delay_min > delay' expression will evaluate to
true, and we'll run the div64_ul() even though there is probably not a
need to.

How big is the cushion? In back of the envelope terms, for a 10
Gbit/sec link where CUBIC has exited the initial slow start and is
using a pacing rate matching the link rate, then AFAICT the cushion
should be roughly:
  4 * 65536 * 1000000 / (1.2*10*10^9/8) ~= 175 usecs
So if that math is in the right ballpark, then any RTT sample that is
within roughly 175 usec of the true min_rtt is going to have
'ca->delay_min > delay' evaluate to true, and run the div64_ul() when
there is probably no need.

AFAICT there is also some risk with this patch that the steady-state
behavior of CUBIC becomes slightly more aggressive for moderate-rate,
low-RTT cases. In such cases this up to ~1ms of cushion to delay_min
will cause the bictcp_update() line:

 t += usecs_to_jiffies(ca->delay_min);

to calculate the target cwnd at a point in time that is ~1ms further
out than before, and thus possibly grow the cwnd faster than it would
have before.

To avoid the risk of extra divisions on many ACKs, and the risk of
more aggressive cwnd behavior in the steady state, WDYT about an
approach where the cushioned delay_min used by your revised Hystart
code (ACK train heuristic and delay heuristic) is maintained
separately from the "pure" delay_min used elsewhere in the CUBIC code,
perhaps as a new ca->delay_min_hystart field? I am wondering about an
approach something like:

/* Account for TSO/GRO delays. ...
*/
static u32 update_delay_min_hystart(struct sock *sk)
{
        unsigned long rate = READ_ONCE(sk->sk_pacing_rate);
        u32 ack_delay = 0;

        if (ca->found)
                return;  /* Hystart is done */

        if (rate)
                ack_delay = min_t(u64, USEC_PER_MSEC,
                                  div64_ul((u64)GSO_MAX_SIZE *
                                           4 * USEC_PER_SEC, rate));
        ca->delay_min_hystart = ca->delay_min + ack_delay;
}

...
        if (ca->delay_min == 0 || ca->delay_min > delay) {
                ca->delay_min = delay;
                update_delay_min_hystart(sk);
        }

WDYT?

neal
