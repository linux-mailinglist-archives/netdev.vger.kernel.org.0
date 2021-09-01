Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570CA3FDDF3
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 16:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhIAOrT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Sep 2021 10:47:19 -0400
Received: from smtprelay0089.hostedemail.com ([216.40.44.89]:57968 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229748AbhIAOrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 10:47:18 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Sep 2021 10:47:18 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave08.hostedemail.com (Postfix) with ESMTP id B2C201801C50A;
        Wed,  1 Sep 2021 14:36:43 +0000 (UTC)
Received: from omf11.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 3C62918211CD1;
        Wed,  1 Sep 2021 14:36:41 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id 1666920A299;
        Wed,  1 Sep 2021 14:36:39 +0000 (UTC)
Date:   Wed, 01 Sep 2021 10:36:36 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE40pdd+yHnh6fyjYV0UDcZ_ZwTCzP019Mf4_tTKWFc_5M6gaw@mail.gmail.com>
References: <20210825154043.247764-1-yan2228598786@gmail.com> <CANn89iJO8jzjFWvJ610TPmKDE8WKi8ojTr_HWXLz5g=4pdQHEA@mail.gmail.com> <20210825231942.18f9b17e@rorschach.local.home> <CAE40pdd+yHnh6fyjYV0UDcZ_ZwTCzP019Mf4_tTKWFc_5M6gaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH] net: tcp_drop adds `reason` parameter for tracing v2
To:     Brendan Gregg <brendan.d.gregg@gmail.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Zhongya Yan <yan2228598786@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>
From:   Steven Rostedt <rostedt@goodmis.org>
Message-ID: <8BA159CD-11AC-425C-9C7F-AA943CE9179F@goodmis.org>
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 1666920A299
X-Spam-Status: No, score=-1.36
X-Stat-Signature: jpet5ridbywf63q8syd6xnbg433ik3o5
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/0p6giWY1Hn7URsSP2OX8RatZ7gAtDwwM=
X-HE-Tag: 1630506999-675233
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Aug 2021 15:13:07 +1000
Brendan Gregg <brendan.d.gregg@gmail.com> wrote:

> On Thu, Aug 26, 2021 at 1:20 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed, 25 Aug 2021 08:47:46 -0700
> > Eric Dumazet <edumazet@google.com> wrote:
> >  
> > > > @@ -5703,15 +5700,15 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
> > > >                         TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
> > > >                 NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
> > > >                 tcp_send_challenge_ack(sk, skb);
> > > > -               goto discard;
> > > > +               tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));  
> > >
> > > I'd rather use a string. So that we can more easily identify _why_ the
> > > packet was drop, without looking at the source code
> > > of the exact kernel version to locate line number 1057
> > >
> > > You can be sure that we will get reports in the future from users of
> > > heavily modified kernels.
> > > Having to download a git tree, or apply semi-private patches is a no go.
> > >
> > > If you really want to include __FILE__ and __LINE__, these both can be
> > > stringified and included in the report, with the help of macros.  
> >
> > I agree the __LINE__ is pointless, but if this has a tracepoint
> > involved, then you can simply enable the stacktrace trigger to it and
> > it will save a stack trace in the ring buffer for you.
> >
> >    echo stacktrace > /sys/kernel/tracing/events/tcp/tcp_drop/trigger
> >
> > And when the event triggers it will record a stack trace. You can also
> > even add a filter to do it only for specific reasons.
> >
> >    echo 'stacktrace if reason == 1' > /sys/kernel/tracing/events/tcp/tcp_drop/trigger
> >
> > And it even works for flags:
> >
> >    echo 'stacktrace if reason & 0xa' > /sys/kernel/tracing/events/tcp/tcp_drop/trigger
> >
> > Which gives another reason to use an enum over a string.  
> 
> You can't do string comparisons? The more string support Ftrace has,
> the more convenient they will be. Using bpftrace as an example of
> convenience and showing drop frequency counted by human-readable
> reason and stack trace:

Yes, you can (and pretty much always had this ability), but having
flags is usually makes it easier (and faster).

You can have 'stacktrace if reason ~ "*string*"' which will match
anything with "string" in it.

My main argument against strings is more of the space they take up in
the ring buffer than the ability to filter.

-- Steve

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity and top posting.
