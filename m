Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67DD3F81F8
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 07:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238711AbhHZFO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 01:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238571AbhHZFOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 01:14:24 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3C9C061757;
        Wed, 25 Aug 2021 22:13:37 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id d16so2820205ljq.4;
        Wed, 25 Aug 2021 22:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Sd0+XXFPugAVdBjgsEQFMRcu4xSZzGD3CudwU0zHpw=;
        b=hyyr/p5tGhiebDOvJuNjtLIWcBr08r7T6S27++36/FgGfHuEla/KCLopPdXqqStUK2
         bco1swQzp3x+d7vruMjPVgZXKLLIsZK0U5AUaKrF1+8eeTlq/t4wmVJef5ri4odVJ0ii
         0HhjfZOFOQ4zUZuffRoN044rwCQy+I0q20/YUxKoLGrVl6ccyjgxlHofPY0LBcTVlZFr
         2NgYkN2aISXrFvu5xYJz1XTcQ88XK516wAFZaTvaPUZ/AbSbR9Fc5fOixFqlx2Cyg+G2
         3laPYkYtAce31B01+RKRubJcK7RxgEaL/V2HnYxTT700abmAHnGD3LDVYoZmSvV22DNo
         ivpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Sd0+XXFPugAVdBjgsEQFMRcu4xSZzGD3CudwU0zHpw=;
        b=ExL9BSahxxw8/yqztkSaX0AuKKXcO5KENMEMCIMeHDjzb3EbuXjcZHeahnJ1dKIIid
         7okv9gd3lBlW2s/opHCFazcGtKSkSnCe3Qfbc86GYNVFbOBLpZ9jntwaRRcW7s3ytE3S
         Kw3YltGKnlVHyL2Tb2kjef9SSJQbpYhzk1LGiipuBq2XV9GqrGhZg/g2vPSNjoY0HQmc
         VG7H0BmPMgDkzCLSUY3VUm3TWtzCUTr4XzaglJ/xcTA+TQOJp685d4Bb13bw2h8j0ZW5
         KrsxfO1SVkaMVsJ2tHk0nofaT85l6mAcFTHEATmx8l1nAVchkjzrJOupZQ9Nw46fZcqT
         fzLg==
X-Gm-Message-State: AOAM530vo6JjRW0Zf/8Itc4rr/wCHTR1CslHlnZpI69+HYxFNGcC8rK3
        4n3FKNvDa0JbHx65PhmtidQBAHjkPZ2oABsNZsUfMNaVOjY=
X-Google-Smtp-Source: ABdhPJzLtahGOcyAtDvWWVsYfc6nYZpPEj1i7jqeH0tKbfPDgm581v+elTyBIWWY7byCV3dXi7wSrepAFDCFLeIjt/k=
X-Received: by 2002:a2e:8e8f:: with SMTP id z15mr1393895ljk.121.1629954815329;
 Wed, 25 Aug 2021 22:13:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210825154043.247764-1-yan2228598786@gmail.com>
 <CANn89iJO8jzjFWvJ610TPmKDE8WKi8ojTr_HWXLz5g=4pdQHEA@mail.gmail.com> <20210825231942.18f9b17e@rorschach.local.home>
In-Reply-To: <20210825231942.18f9b17e@rorschach.local.home>
From:   Brendan Gregg <brendan.d.gregg@gmail.com>
Date:   Thu, 26 Aug 2021 15:13:07 +1000
Message-ID: <CAE40pdd+yHnh6fyjYV0UDcZ_ZwTCzP019Mf4_tTKWFc_5M6gaw@mail.gmail.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` parameter for tracing v2
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Zhongya Yan <yan2228598786@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 1:20 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 25 Aug 2021 08:47:46 -0700
> Eric Dumazet <edumazet@google.com> wrote:
>
> > > @@ -5703,15 +5700,15 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
> > >                         TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
> > >                 NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
> > >                 tcp_send_challenge_ack(sk, skb);
> > > -               goto discard;
> > > +               tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));
> >
> > I'd rather use a string. So that we can more easily identify _why_ the
> > packet was drop, without looking at the source code
> > of the exact kernel version to locate line number 1057
> >
> > You can be sure that we will get reports in the future from users of
> > heavily modified kernels.
> > Having to download a git tree, or apply semi-private patches is a no go.
> >
> > If you really want to include __FILE__ and __LINE__, these both can be
> > stringified and included in the report, with the help of macros.
>
> I agree the __LINE__ is pointless, but if this has a tracepoint
> involved, then you can simply enable the stacktrace trigger to it and
> it will save a stack trace in the ring buffer for you.
>
>    echo stacktrace > /sys/kernel/tracing/events/tcp/tcp_drop/trigger
>
> And when the event triggers it will record a stack trace. You can also
> even add a filter to do it only for specific reasons.
>
>    echo 'stacktrace if reason == 1' > /sys/kernel/tracing/events/tcp/tcp_drop/trigger
>
> And it even works for flags:
>
>    echo 'stacktrace if reason & 0xa' > /sys/kernel/tracing/events/tcp/tcp_drop/trigger
>
> Which gives another reason to use an enum over a string.

You can't do string comparisons? The more string support Ftrace has,
the more convenient they will be. Using bpftrace as an example of
convenience and showing drop frequency counted by human-readable
reason and stack trace:

# bpftrace -e 'k:tcp_drop { @[str(arg2), kstack] = count(); }'

Don't need further translation beyond the str(arg2). And filtering on
backlog drops:

bpftrace -e 'k:tcp_drop /str(arg2) == "SYN backlog drop"/ { @[kstack]
= count(); }'

etc. (Although ultimately we'll want a tracepoint added in tcp_drop
with those arguments.) If it's a enum I'll need to translate it back,
and deal with enum additions that my tool might not be coded for. I
can do it, it just needs maintenance, e.g. [0]. Plus the kernel code
needs maintenance. For a narrow observability use case, it starts to
feel like overkill to maintain an enum.

I wouldn't mind an optional _additional_ reason argument that's the
enum SNMP counter if appropriate. E.g.:

tcpdrop(sk, skb, "Accept backlog full", LINUX_MIB_LISTENDROPS);
tcpdrop(sk, skb, "No route", LINUX_MIB_LISTENDROPS);

So you could trace LINUX_MIB_LISTENDROPS and see different string
reasons for each different code path.

I don't feel strongly about having __LINE__. I'd look it up from the
stack trace anyway.

Brendan

[0] https://github.com/brendangregg/bpf-perf-tools-book/blob/master/originals/Ch16_Hypervisors/kvmexits.bt
