Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E62524D8D6
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgHUPij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgHUPie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 11:38:34 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EC872063A;
        Fri, 21 Aug 2020 15:38:33 +0000 (UTC)
Date:   Fri, 21 Aug 2020 11:38:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] random32: Use rcuidle variant for tracepoint
Message-ID: <20200821113831.340ba051@oasis.local.home>
In-Reply-To: <CANn89i+1MQRCSRVg-af758en5e9nwQBes3aBSjQ6BY1pV5+HdQ@mail.gmail.com>
References: <20200821063043.1949509-1-elver@google.com>
        <20200821085907.GJ1362448@hirez.programming.kicks-ass.net>
        <CANn89i+1MQRCSRVg-af758en5e9nwQBes3aBSjQ6BY1pV5+HdQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Aug 2020 08:06:49 -0700
Eric Dumazet <edumazet@google.com> wrote:

> On Fri, Aug 21, 2020 at 1:59 AM <peterz@infradead.org> wrote:
> >
> > On Fri, Aug 21, 2020 at 08:30:43AM +0200, Marco Elver wrote:  
> > > With KCSAN enabled, prandom_u32() may be called from any context,
> > > including idle CPUs.
> > >
> > > Therefore, switch to using trace_prandom_u32_rcuidle(), to avoid various
> > > issues due to recursion and lockdep warnings when KCSAN and tracing is
> > > enabled.  
> >
> > At some point we're going to have to introduce noinstr to idle as well.
> > But until that time this should indeed cure things.  
> 
> I do not understand what the issue is.  This _rcuidle() is kind of opaque ;)

kasan can be called when RCU is not "watching". That is, in the idle
code, RCU will stop bothering idle CPUs by checking on them to move
along the grace period. Just before going to idle, RCU will just set
that its in a quiescent state. The issue is, after RCU has basically
shutdown, and before getting to where the CPU is "sleeping", kasan is
called, and kasan call a tracepoint. The problem is that tracepoints
are protected by RCU. If RCU has shutdown, then it loses the
protection. There's code to detect this and give a warning.

All tracepoints have a _rcuidle() version. What this does is adds a
little bit more overhead to the tracepoint when enabled to check if RCU
is watching or not. If it is not watching, it tells RCU to start
watching again while it runs the tracepoint, and afterward it lets RCU
know that it can go back to not watching.

> 
> Would this alternative patch work, or is it something more fundamental ?

As I hope the above explained. The answer is "no".

-- Steve

> 
> Thanks !
> 
> diff --git a/lib/random32.c b/lib/random32.c
> index 932345323af092a93fc2690b0ebbf4f7485ae4f3..17af2d1631e5ab6e02ad1e9288af7e007bed6d5f
> 100644
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -83,9 +83,10 @@ u32 prandom_u32(void)
>         u32 res;
> 
>         res = prandom_u32_state(state);
> -       trace_prandom_u32(res);
>         put_cpu_var(net_rand_state);
> 
> +       trace_prandom_u32(res);
> +
>         return res;
>  }
>  EXPORT_SYMBOL(prandom_u32);

