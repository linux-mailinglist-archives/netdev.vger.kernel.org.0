Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C7277FB2
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 15:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfG1NzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 09:55:09 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33920 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfG1NzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 09:55:09 -0400
Received: by mail-yb1-f196.google.com with SMTP id q5so9001487ybp.1
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 06:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PEFfOXFor+Q98nfYcHFw9xxG8Fhw3sXvoeXsiVJG3QM=;
        b=q7ZvslWi07xd7XKg7+RUeQOA8QVofk4g4eABaF2q7CFh4FdE8XKbwhc4ekWRQIjCzG
         /iE4GLYDqUhDULkw3b/GLQAp+DSxrSHrWQzL1epzDOad6bCxeas/TkHk8E0Hlb92bd1W
         AOOyQZT78Toq8UdtjikrztSsjxwrxRPIwjp7qRaZhGL/8Ftfp3oxvIhw94PJmDjEsDqD
         kFnzkWqK7ZD6acA4FhUf9cbnQAd2KfuOSy+h2n/CEoWFcj2aFfO0N2cnhrwxtIELDmRW
         02sKCOHbyXQ/rqmWzPJ4eVl8BJWJGedANxkXdaHrGCLKnOHv5gf1ELEZ/450WfyfsvLU
         sX7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PEFfOXFor+Q98nfYcHFw9xxG8Fhw3sXvoeXsiVJG3QM=;
        b=TkLhMMbB+dYbo/E005lPKUp0LSLHJSCjbu5rSl1TfzHefC0U0Og+y4JE+5Wqz1WNKM
         1p+DtNYUXbOawO3DjUgSfTd3YuzPbGmTZOBt7WdBdL5bYFZ38HJaiCws+lF9NKR0cI2W
         T/sP55JuQl+M7cUvsSP/n7UAagUyil48l9W9heBbMbsVI2bW6enuDveM8yq2g9uvrZor
         /+KlYMpldFeIsapNShum1S3XR5nMUyo/Q0KPWHMeSlSfvF89Clm5t68BFmXGhkudNd/u
         tGMCzi68xFSVlyu7xc+P9xcy3rw6/R3gE8p36Mu1YRJ9/QQXs6ZeBj19mxQzU/9jxO+a
         M1mw==
X-Gm-Message-State: APjAAAUZDtE1lsKuFv7+CViFN9ABaZhhE3Hk/zWcS2haubNwkln57SwJ
        j2SzgzJ6HB040e8tFzSlLjy835HqGhO6FdA9UvceCQ==
X-Google-Smtp-Source: APXvYqyniZaZ5EF475/7fc+y5YIx7hCGSiTcr6ml46HOmotsHE9TZ79PHa8kfkxh6B+BabsfqslPKGOzaXR+VcsTItg=
X-Received: by 2002:a25:9343:: with SMTP id g3mr56953630ybo.234.1564322107438;
 Sun, 28 Jul 2019 06:55:07 -0700 (PDT)
MIME-Version: 1.0
References: <1564194225-14342-1-git-send-email-johunt@akamai.com>
 <CANn89iJtw_XrU-F0-frE=P6egH99kF0W0kTzReK701LmigcJ4Q@mail.gmail.com> <a9ec9cfd-c381-c02e-7d67-e24373c693d6@akamai.com>
In-Reply-To: <a9ec9cfd-c381-c02e-7d67-e24373c693d6@akamai.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 28 Jul 2019 15:54:56 +0200
Message-ID: <CANn89iLqeixzZkop8tqOQka_9ZiKurZL9Vj05bgU99M5Pbenqw@mail.gmail.com>
Subject: Re: [PATCH] tcp: add new tcp_mtu_probe_floor sysctl
To:     Josh Hunt <johunt@akamai.com>
Cc:     netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 28, 2019 at 1:21 AM Josh Hunt <johunt@akamai.com> wrote:
>
> On 7/27/19 12:05 AM, Eric Dumazet wrote:
> > On Sat, Jul 27, 2019 at 4:23 AM Josh Hunt <johunt@akamai.com> wrote:
> >>
> >> The current implementation of TCP MTU probing can considerably
> >> underestimate the MTU on lossy connections allowing the MSS to get down to
> >> 48. We have found that in almost all of these cases on our networks these
> >> paths can handle much larger MTUs meaning the connections are being
> >> artificially limited. Even though TCP MTU probing can raise the MSS back up
> >> we have seen this not to be the case causing connections to be "stuck" with
> >> an MSS of 48 when heavy loss is present.
> >>
> >> Prior to pushing out this change we could not keep TCP MTU probing enabled
> >> b/c of the above reasons. Now with a reasonble floor set we've had it
> >> enabled for the past 6 months.
> >
> > And what reasonable value have you used ???
>
> Reasonable for some may not be reasonable for others hence the new
> sysctl :) We're currently running with a fairly high value based off of
> the v6 min MTU minus headers and options, etc. We went conservative with
> our setting initially as it seemed a reasonable first step when
> re-enabling TCP MTU probing since with no configurable floor we saw a #
> of cases where connections were using severely reduced mss b/c of loss
> and not b/c of actual path restriction. I plan to reevaluate the setting
> at some point, but since the probing method is still the same it means
> the same clients who got stuck with mss of 48 before will land at
> whatever floor we set. Looking forward we are interested in trying to
> improve TCP MTU probing so it does not penalize clients like this.
>
> A suggestion for a more reasonable floor default would be 512, which is
> the same as the min_pmtu. Given both mechanisms are trying to achieve
> the same goal it seems like they should have a similar min/floor.
>
> >
> >>
> >> The new sysctl will still default to TCP_MIN_SND_MSS (48), but gives
> >> administrators the ability to control the floor of MSS probing.
> >>
> >> Signed-off-by: Josh Hunt <johunt@akamai.com>
> >> ---
> >>   Documentation/networking/ip-sysctl.txt | 6 ++++++
> >>   include/net/netns/ipv4.h               | 1 +
> >>   net/ipv4/sysctl_net_ipv4.c             | 9 +++++++++
> >>   net/ipv4/tcp_ipv4.c                    | 1 +
> >>   net/ipv4/tcp_timer.c                   | 2 +-
> >>   5 files changed, 18 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> >> index df33674799b5..49e95f438ed7 100644
> >> --- a/Documentation/networking/ip-sysctl.txt
> >> +++ b/Documentation/networking/ip-sysctl.txt
> >> @@ -256,6 +256,12 @@ tcp_base_mss - INTEGER
> >>          Path MTU discovery (MTU probing).  If MTU probing is enabled,
> >>          this is the initial MSS used by the connection.
> >>
> >> +tcp_mtu_probe_floor - INTEGER
> >> +       If MTU probing is enabled this caps the minimum MSS used for search_low
> >> +       for the connection.
> >> +
> >> +       Default : 48
> >> +
> >>   tcp_min_snd_mss - INTEGER
> >>          TCP SYN and SYNACK messages usually advertise an ADVMSS option,
> >>          as described in RFC 1122 and RFC 6691.
> >> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> >> index bc24a8ec1ce5..c0c0791b1912 100644
> >> --- a/include/net/netns/ipv4.h
> >> +++ b/include/net/netns/ipv4.h
> >> @@ -116,6 +116,7 @@ struct netns_ipv4 {
> >>          int sysctl_tcp_l3mdev_accept;
> >>   #endif
> >>          int sysctl_tcp_mtu_probing;
> >> +       int sysctl_tcp_mtu_probe_floor;
> >>          int sysctl_tcp_base_mss;
> >>          int sysctl_tcp_min_snd_mss;
> >>          int sysctl_tcp_probe_threshold;
> >> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> >> index 0b980e841927..59ded25acd04 100644
> >> --- a/net/ipv4/sysctl_net_ipv4.c
> >> +++ b/net/ipv4/sysctl_net_ipv4.c
> >> @@ -820,6 +820,15 @@ static struct ctl_table ipv4_net_table[] = {
> >>                  .extra2         = &tcp_min_snd_mss_max,
> >>          },
> >>          {
> >> +               .procname       = "tcp_mtu_probe_floor",
> >> +               .data           = &init_net.ipv4.sysctl_tcp_mtu_probe_floor,
> >> +               .maxlen         = sizeof(int),
> >> +               .mode           = 0644,
> >> +               .proc_handler   = proc_dointvec_minmax,
> >> +               .extra1         = &tcp_min_snd_mss_min,
> >> +               .extra2         = &tcp_min_snd_mss_max,
> >> +       },
> >> +       {
> >>                  .procname       = "tcp_probe_threshold",
> >>                  .data           = &init_net.ipv4.sysctl_tcp_probe_threshold,
> >>                  .maxlen         = sizeof(int),
> >> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> >> index d57641cb3477..e0a372676329 100644
> >> --- a/net/ipv4/tcp_ipv4.c
> >> +++ b/net/ipv4/tcp_ipv4.c
> >> @@ -2637,6 +2637,7 @@ static int __net_init tcp_sk_init(struct net *net)
> >>          net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
> >>          net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
> >>          net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
> >> +       net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
> >>
> >>          net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
> >>          net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
> >> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> >> index c801cd37cc2a..dbd9d2d0ee63 100644
> >> --- a/net/ipv4/tcp_timer.c
> >> +++ b/net/ipv4/tcp_timer.c
> >> @@ -154,7 +154,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
> >>          } else {
> >>                  mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
> >>                  mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
> >> -               mss = max(mss, 68 - tcp_sk(sk)->tcp_header_len);
> >> +               mss = max(mss, net->ipv4.sysctl_tcp_mtu_probe_floor);
> >>                  mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
> >>                  icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
> >>          }
> >
> >
> > Existing sysctl should be enough ?
>
> I don't think so. Changing tcp_min_snd_mss could impact clients that
> really want/need a small mss. When you added the new sysctl I tried to
> analyze the mss values we're seeing to understand what we could possibly
> raise it to. While not a huge amount, we see more clients than I
> expected announcing mss values in the 180-512 range. Given that I would
> not feel comfortable setting tcp_min_snd_mss to say 512 as I suggested
> above.

If these clients need mss values in 180-512 ranges, how MTU probing
would work for them,
if you set a floor to 512 ?

Are we sure the intent of tcp_base_mss was not to act as a floor ?

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index c801cd37cc2a9c11f2dd4b9681137755e501a538..6d15895e9dcfb2eff51bbcf3608c7e68c1970a9e
100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -153,7 +153,7 @@ static void tcp_mtu_probing(struct
inet_connection_sock *icsk, struct sock *sk)
                icsk->icsk_mtup.probe_timestamp = tcp_jiffies32;
        } else {
                mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
-               mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
+               mss = max(net->ipv4.sysctl_tcp_base_mss, mss);
                mss = max(mss, 68 - tcp_sk(sk)->tcp_header_len);
                mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
                icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);



>
> >
> > tcp_min_snd_mss  documentation could be slightly updated.
> >
> > And maybe its default value could be raised a bit.
> >
>
> Thanks
> Josh
