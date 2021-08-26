Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9173F80E3
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 05:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhHZDUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 23:20:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhHZDUc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 23:20:32 -0400
Received: from rorschach.local.home (unknown [24.94.146.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 676B1610C7;
        Thu, 26 Aug 2021 03:19:44 +0000 (UTC)
Date:   Wed, 25 Aug 2021 23:19:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Zhongya Yan <yan2228598786@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` parameter for tracing v2
Message-ID: <20210825231942.18f9b17e@rorschach.local.home>
In-Reply-To: <CANn89iJO8jzjFWvJ610TPmKDE8WKi8ojTr_HWXLz5g=4pdQHEA@mail.gmail.com>
References: <20210825154043.247764-1-yan2228598786@gmail.com>
        <CANn89iJO8jzjFWvJ610TPmKDE8WKi8ojTr_HWXLz5g=4pdQHEA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Aug 2021 08:47:46 -0700
Eric Dumazet <edumazet@google.com> wrote:

> > @@ -5703,15 +5700,15 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
> >                         TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
> >                 NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
> >                 tcp_send_challenge_ack(sk, skb);
> > -               goto discard;
> > +               tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));  
> 
> I'd rather use a string. So that we can more easily identify _why_ the
> packet was drop, without looking at the source code
> of the exact kernel version to locate line number 1057
> 
> You can be sure that we will get reports in the future from users of
> heavily modified kernels.
> Having to download a git tree, or apply semi-private patches is a no go.
> 
> If you really want to include __FILE__ and __LINE__, these both can be
> stringified and included in the report, with the help of macros.

I agree the __LINE__ is pointless, but if this has a tracepoint
involved, then you can simply enable the stacktrace trigger to it and
it will save a stack trace in the ring buffer for you.

   echo stacktrace > /sys/kernel/tracing/events/tcp/tcp_drop/trigger

And when the event triggers it will record a stack trace. You can also
even add a filter to do it only for specific reasons.

   echo 'stacktrace if reason == 1' > /sys/kernel/tracing/events/tcp/tcp_drop/trigger

And it even works for flags:

   echo 'stacktrace if reason & 0xa' > /sys/kernel/tracing/events/tcp/tcp_drop/trigger

Which gives another reason to use an enum over a string.

-- Steve
