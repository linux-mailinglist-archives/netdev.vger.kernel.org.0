Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0289E8F50
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731538AbfJ2SbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:31:17 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41000 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfJ2SbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:31:17 -0400
Received: by mail-qk1-f193.google.com with SMTP id m125so9311511qkd.8
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 11:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SKjgGSVN1E3sYih1eEcDRYLAGHoo67gQJRsUkH8Kz6U=;
        b=hb+PvmIiV0xrxKTTKB7rfY3JkIS0Izh1zgPsEvHTuwTb8Rd/+10iYsDhGF4CbMaYHp
         GJdIVzrlg+vFvLSUXieu+22DKmFO/W9tQlEFXA54jGd8SPxsxeMna6VwDqIAhUEW8nTQ
         VynAlgf4UqEnGBZIcxRvp5G3d4VTRGOllUc/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SKjgGSVN1E3sYih1eEcDRYLAGHoo67gQJRsUkH8Kz6U=;
        b=AyQrSCyJco4g7hts6za68bbLEC0KsDQg03LivMfdZ0NE7Acnri9ody9dLjxU3jxMXf
         uQuqNnha64Lbl3+zF4vBR3riZQncU5GrCvH6qVxF6dPYNa2cCIQv/bjl9sQOHk/PtnDB
         EgGX7JVQUvANxtn9duFNV1PbSsjV0lXCZQs/uUR6FYkV9JlxhLJhAg3PbLwuJWOTLtay
         tEcYLBzpWBtUunC3nTXytwtHO38msgtWuhluXlaCAqN8wiISW7qoo0Jr69IMBWR4nd+0
         sVn5ICStc+YcS+gTwlgFQu9Br3jcW55MVZZV1dFwt5M5QxLh0ffmZXvogTb8qKxwx5c7
         ZWbg==
X-Gm-Message-State: APjAAAWPMOD7gyJV0tImg+MIcQJ4Jk3wG1zUD6SkysmI3Wc0sxVndcob
        xTjElYtd1zt8GLVDpEPg9vcxSVYAxau/gXQ/IW8lCg==
X-Google-Smtp-Source: APXvYqzIe/sD4cuIqKaxGdh+49ge93XKHv8pIXjwjSL43rkZJFxkCZjMi1acMYtwyPJefhuMG3rsdovnGcOeBfP/iQo=
X-Received: by 2002:a37:4f0a:: with SMTP id d10mr9418010qkb.286.1572373874100;
 Tue, 29 Oct 2019 11:31:14 -0700 (PDT)
MIME-Version: 1.0
References: <CABWYdi1QmrHxNZT_DK4A2WUoj=r1+wxSngzaaTuGCatHisaTRw@mail.gmail.com>
 <CANn89iLE-3zxROxGOusPBRmQL4oN2Nqtg3rqXnpO8bkiFAw8EQ@mail.gmail.com>
In-Reply-To: <CANn89iLE-3zxROxGOusPBRmQL4oN2Nqtg3rqXnpO8bkiFAw8EQ@mail.gmail.com>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Tue, 29 Oct 2019 11:31:02 -0700
Message-ID: <CABWYdi2Eq30vEKKYxr-diofpeATNXiB3ZYKL6Q15y10w+vsCLg@mail.gmail.com>
Subject: Re: fq dropping packets between vlan and ethernet interfaces
To:     Eric Dumazet <edumazet@google.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm on 5.4-rc5. Let me apply e7a409c3f46cb0dbc7bfd4f6f9421d53e92614a5
on top and report back to you.

On Tue, Oct 29, 2019 at 11:27 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Oct 29, 2019 at 11:20 AM Ivan Babrou <ivan@cloudflare.com> wrote:
> >
> > Hello,
> >
> > We're trying to test Linux 5.4 early and hit an issue with FQ.
> >
> > The relevant part of our network setup involves four interfaces:
> >
> > * ext0 (ethernet, internet facing)
> > * vlan101@ext0 (vlan)
> > * int0 (ethernet, lan facing)
> > * vlan11@int0 (vlan)
> >
> > Both int0 and ext0 have fq on them:
> >
> > qdisc fq 1: dev ext0 root refcnt 65 limit 10000p flow_limit 100p
> > buckets 1024 orphan_mask 1023 quantum 3228 initial_quantum 16140
> > low_rate_threshold 550Kbit refill_delay 40.0ms
> > qdisc fq 8003: dev int0 root refcnt 65 limit 10000p flow_limit 100p
> > buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140
> > low_rate_threshold 550Kbit refill_delay 40.0ms
> >
> > The issue itself is that after some time ext0 stops feeding off
> > vlan101, which is visible as tcpdump not seeing packets on ext0, while
> > they flow over vlan101.
> >
> > I can see that fq_dequeue does not report any packets:
> >
> > $ sudo perf record -e qdisc:qdisc_dequeue -aR sleep 1
> > hping3 40335 [006] 63920.881016: qdisc:qdisc_dequeue: dequeue
> > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > packets=0 skbaddr=(nil)
> > hping3 40335 [006] 63920.881030: qdisc:qdisc_dequeue: dequeue
> > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > packets=0 skbaddr=(nil)
> > hping3 40335 [006] 63920.881041: qdisc:qdisc_dequeue: dequeue
> > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > packets=0 skbaddr=(nil)
> > hping3 40335 [006] 63920.881070: qdisc:qdisc_dequeue: dequeue
> > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > packets=0 skbaddr=(nil)
> >
> > Inside of fq_dequeue I'm able to see that we throw away packets in here:
> >
> > * https://elixir.bootlin.com/linux/v5.4-rc2/source/net/sched/sch_fq.c#L510
> >
> > The output of tc -s qdisc shows the following:
> >
> > qdisc fq 1: dev ext0 root refcnt 65 limit 10000p flow_limit 100p
> > buckets 1024 orphan_mask 1023 quantum 3228 initial_quantum 16140
> > low_rate_threshold 550Kbit refill_delay 40.0ms
> >  Sent 4872143400 bytes 8448638 pkt (dropped 201276670, overlimits 0
> > requeues 103)
> >  backlog 779376b 10000p requeues 103
> >   2806 flows (2688 inactive, 118 throttled), next packet delay
> > 1572240566653952889 ns
> >   354201 gc, 0 highprio, 804560 throttled, 3919 ns latency, 19492 flows_plimit
> > qdisc fq 8003: dev int0 root refcnt 65 limit 10000p flow_limit 100p
> > buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140
> > low_rate_threshold 550Kbit refill_delay 40.0ms
> >  Sent 15869093876 bytes 17387110 pkt (dropped 0, overlimits 0 requeues 2817)
> >  backlog 0b 0p requeues 2817
> >   2047 flows (2035 inactive, 0 throttled)
> >   225074 gc, 10 highprio, 102308 throttled, 7525 ns latency
> >
> > The key part here is probably that next packet delay for ext0 is the
> > current unix timestamp in nanoseconds. Naturally, we see this code
> > path being executed:
> >
> > * https://elixir.bootlin.com/linux/v5.4-rc2/source/net/sched/sch_fq.c#L462
> >
> > Unfortunately, I don't have a reliable reproduction for this issue. It
> > appears naturally with some traffic and I can do limited tracing with
> > perf and bcc tools while running hping3 to generate packets.
> >
> > The issue goes away if I replace fq with pfifo_fast on ext0.
>
> At which commit is your tree  precisely ?
>
> This sounds like the recent fix we had for fragmented packets.
>
> e7a409c3f46cb0dbc7bfd4f6f9421d53e92614a5 ipv4: fix IPSKB_FRAG_PMTU
> handling with fragmentation
