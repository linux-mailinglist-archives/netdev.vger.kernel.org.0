Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C50D486A2C
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 19:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243044AbiAFSwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 13:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243032AbiAFSwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 13:52:20 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D86C061201
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 10:52:20 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id p5so2820943ybd.13
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 10:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IUMU++ei66mMLikIsKIpji8u8kZ4EgkMdb8bw4IJi7M=;
        b=tlN1qiT6Gf7LMzx8uZWwlCdeVUjgWHsn/rdMQ4OqiXOatO4j4I65aIsPQWrsbQTXMm
         VeyfzJwosM1D+4w/MrZOHodbr3H9qkQT/F8l/Pqc3NmqPJIKJ2uNSU+CntMOE5qTk2sx
         llCVdJv7PCutgMiWYji8xcelfaYiLS0PRX2GroQQIQtKmUyEmqQjQ8a6xaIRdpMuzFoB
         wa57qrmLP5ZD1AyqQrJyPbI6JW6KwyAANnuMwPbUivv/3GNF5g99VC7t+9PFavwPJgkk
         mgFD/Bj1spwxDllZuEIkeROgRSJj5kZAmViRYH27olKLFqsNwO3qp5uRrPPrfn3Y69W9
         Cn3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IUMU++ei66mMLikIsKIpji8u8kZ4EgkMdb8bw4IJi7M=;
        b=7LEvCRmxeXzJnzea3xmCFDl3RvA7aFmozzR3eXvIucJtlbM9QwUNbpn1z0CHn14ZL3
         tHh98NyKiNhYEVdmu00wxkF2OPDtV37M7sqUjutvoL5d9eWeMMNQzV04QnBmnVMhcMsM
         eEhRCQA1TxOfbdcfsWwNigVhFu3w/P+Ps4iMvXvkfZAG1ymqVHMwAAgLthiB5rwQy7g/
         8bl2b4FEX5Z2bfoDToMhsCVTj7W58ytXcTegPJK1MO7OCRq2WnhGYyejRE0Xd0AC9CNV
         5hTyogw06va8gHC6Eo7VGbGmn3o/nZKFbwZ9beRM3wLLFdlhjCushzuTby+kzY6Vb1+I
         kZXg==
X-Gm-Message-State: AOAM533360QdSm0DVojqo0EGMkaChI32npd+HJ63B19zYrjhev1bsz2j
        4oNYZ3OEjhTSAIsGwpu2KVjfTJwuwJtdaG28sehvbw==
X-Google-Smtp-Source: ABdhPJxS/EeBveDnUKjywJlxJMuNY1qYF6W0NzTjTkcduiGAwx5CMNjJFhQir1DyoVTfzpmGzz9X/HlHByvvv8gIUHU=
X-Received: by 2002:a25:af14:: with SMTP id a20mr81702404ybh.753.1641495138938;
 Thu, 06 Jan 2022 10:52:18 -0800 (PST)
MIME-Version: 1.0
References: <CA+wXwBRbLq6SW39qCD8GNG98YD5BJR2MFXmJV2zU1xwFjC-V0A@mail.gmail.com>
 <CANn89iLbKNkB9bzkA2nk+d2c6rq40-6-h9LXAVFCkub=T4BGsQ@mail.gmail.com> <CA+wXwBTQtzgsErFZZEUbEq=JMhdq-fF2OXJ7ztnnq6hPXs_L3Q@mail.gmail.com>
In-Reply-To: <CA+wXwBTQtzgsErFZZEUbEq=JMhdq-fF2OXJ7ztnnq6hPXs_L3Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 Jan 2022 10:52:07 -0800
Message-ID: <CANn89iKTw5aZ0GvybkO=3B17HkGRmFKcqz9FqJFuo5r--=afOA@mail.gmail.com>
Subject: Re: Expensive tcp_collapse with high tcp_rmem limit
To:     Daniel Dao <dqminh@cloudflare.com>
Cc:     netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 4:32 AM Daniel Dao <dqminh@cloudflare.com> wrote:
>
> On Wed, Jan 5, 2022 at 1:38 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, Jan 5, 2022 at 4:15 AM Daniel Dao <dqminh@cloudflare.com> wrote:
> > >
> > > Hello,
> > >
> > > We are looking at increasing the maximum value of TCP receive buffer in order
> > > to take better advantage of high BDP links. For historical reasons (
> > > https://blog.cloudflare.com/the-story-of-one-latency-spike/), this was set to
> > > a lower than default value.
> > >
> > > We are still occasionally seeing long time spent in tcp_collapse, and the time
> > > seems to be proportional with max rmem. For example, with net.ipv4.tcp_rmem = 8192 2097152 16777216,
> > > we observe tcp_collapse latency with the following bpftrace command:
> > >
> >
> > I suggest you add more traces, like the payload/truesize ratio when
> > these events happen.
> > and tp->rcv_ssthresh, sk->sk_rcvbuf
> >
> > TCP stack by default assumes a conservative [1] payload/truesize ratio of 50%
>
> I forgot to add that for this experiment we also set tcp_adv_win_scale
> = -2 to see if it
> reduces the chance of triggering tcp_collapse
>
> >
> > Meaning that a 16MB sk->rcvbuf would translate to a TCP RWIN of 8MB.
> >
> > I suspect that you use XDP, and standard MTU=1500.
> > Drivers in XDP mode use one page (4096 bytes on x86) per incoming frame.
> > In this case, the ratio is ~1428/4096 = 35%
> >
> > This is one of the reason we switched to a 4K MTU at Google, because we
> > have an effective ratio close to 100% (even if XDP was used)
> >
> > [1] The 50% ratio of TCP is defeated with small MSS, and malicious traffic.
>
> I updated the bpftrace script to get data on len/truesize on collapsed skb
>
>   kprobe:tcp_collapse {
>     $sk = (struct sock *) arg0;
>     $tp = (struct tcp_sock *) arg0;
>     printf("tid %d: rmem_alloc=%ld sk_rcvbuf=%ld rcv_ssthresh=%ld\n", tid,
>         $sk->sk_backlog.rmem_alloc.counter, $sk->sk_rcvbuf, $tp->rcv_ssthresh);
>     printf("tid %d: advmss=%ld wclamp=%ld rcv_wnd=%ld\n", tid, $tp->advmss,
>         $tp->window_clamp, $tp->rcv_wnd);
>     @start[tid] = nsecs;
>   }
>
>   kretprobe:tcp_collapse /@start[tid] != 0/ {
>     $us = (nsecs - @start[tid])/1000;
>     @us = hist($us);
>     printf("tid %d: %ld us\n", tid, $us);
>     delete(@start[tid]);
>   }
>
>   kprobe:tcp_collapse_one {
>     $skb = (struct sk_buff *) arg1;
>     printf("tid %d: s=%ld len=%ld truesize=%ld\n", tid, sizeof(struct
> sk_buff), $skb->len, $skb->truesize);
>   }
>
>   interval:s:6000 { exit(); }
>
> Here is the output:
>
>   tid 0: rmem_alloc=16780416 sk_rcvbuf=16777216 rcv_ssthresh=2920
>   tid 0: advmss=1460 wclamp=4194304 rcv_wnd=450560
>   tid 0: len=3316 truesize=15808
>   tid 0: len=4106 truesize=16640
>   tid 0: len=3967 truesize=16512
>   tid 0: len=2988 truesize=15488

Ouch.
What kind of NIC driver is used on your host ?

>   ...
>   tid 0: len=5279 truesize=17664
>   tid 0: len=425 truesize=2048
>   tid 0: 17176 us
>
> The skb looks indeed bloated (len=3316, truesize=15808), so collapsing
> definitely
> helps. It just took a long time to go through thousands of 16KB skb
>
> >
> >
> > >   bpftrace -e 'kprobe:tcp_collapse { @start[tid] = nsecs; } kretprobe:tcp_collapse /@start[tid] != 0/ { $us = (nsecs - @start[tid])/1000; @us = hist($us); delete(@start[tid]); printf("%ld us\n", $us);} interval:s:6000 { exit(); }'
> > >   Attaching 3 probes...
> > >   15496 us
> > >   14301 us
> > >   12248 us
> > >   @us:
> > >   [8K, 16K)              3 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
> > >
> > > Spending up to 16ms with 16MiB maximum receive buffer seems high.  Are there any
> > > recommendations on possible approaches to reduce the tcp_collapse latency ?
> > > Would clamping the duration of a tcp_collapse call be reasonable, since we only
> > > need to spend enough time to free space to queue the required skb ?
> >
> > It depends if the incoming skb is queued in in-order queue or
> > out-of-order queue.
> > For out-of-orders, we have a strategy in tcp_prune_ofo_queue() which
> > should work reasonably well after commit
> > 72cd43ba64fc17 tcp: free batches of packets in tcp_prune_ofo_queue()
> >
> > Given the nature of tcp_collapse(), limiting it to even 1ms of processing time
> > would still allow for malicious traffic to hurt you quite a lot.
>
> I don't yet understand why we have cases of bloated skbs. But it seems
> like adapting the
> batch prune strategy in tcp_prune_ofo_queue() to tcp_collapse makes sense to me.
>

Except that you would still have to parse the linear list.

> I think every collapsed skb saves us truesize - len (?), and we can
> set goal to free up 12.5% of sk_rcvbuf
> same as tcp_prune_ofo_queue()

I think that you should first look if you are under some kind of attack [1]

Eventually you would still have to make room, involving expensive copies.

12% of 16MB is still a lot of memory to copy.

[1] Detecting an attack signature could allow you to zap the socket
and save ~16MB of memory per flow.
