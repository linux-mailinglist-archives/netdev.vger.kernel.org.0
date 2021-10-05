Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080034230D8
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhJETmY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Oct 2021 15:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231343AbhJETmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 15:42:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FA61611C5;
        Tue,  5 Oct 2021 19:40:30 +0000 (UTC)
Date:   Tue, 5 Oct 2021 15:40:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam <coreteam@netfilter.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
Message-ID: <20211005154029.46f9c596@gandalf.local.home>
In-Reply-To: <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr>
References: <20211005094728.203ecef2@gandalf.local.home>
        <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
        <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
        <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr>
        <20211005144002.34008ea0@gandalf.local.home>
        <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 21:06:36 +0200 (CEST)
Jan Engelhardt <jengelh@inai.de> wrote:

> On Tuesday 2021-10-05 20:40, Steven Rostedt wrote:
> >>   
> >> >>>> typeof(*p) *________p1 = (typeof(*p) *__force)READ_ONCE(p);    
> >> 
> >> #define static_cast(type, expr) ((struct { type x; }){(expr)}.x)
> >> typeof(p) p1 = (typeof(p) __force)static_cast(void *, READ_ONCE(p));
> >> 
> >> Let the name not fool you; it's absolutely _not_ the same as C++'s 
> >> static_cast, but still: it does emit a warning when you do pass an 
> >> integer, which is better than no warning at all in that case.
> >> 
> >>  *flies away*  
> >
> >Are you suggesting I should continue this exercise ;-)  
> 
> “After all, why not?”
> 
> typeof(p) p1 = (typeof(p) __force)READ_ONCE(p) +
>                BUILD_BUG_ON_EXPR(__builtin_classify_type(p) != 5);

I may try it, because exposing the structure I want to hide, is pulling out
a lot of other crap with it :-p

struct trace_pid_list {
	raw_spinlock_t			lock;
	struct irq_work			refill_irqwork;
	union upper_chunk		*upper[UPPER1_SIZE]; // 1 or 2K in size
	union upper_chunk		*upper_list;
	union lower_chunk		*lower_list;
	int				free_upper_chunks;
	int				free_lower_chunks;
};

I can still abstract out the unions, but this means I need to also pull out
the define of "UPPER1_SIZE". Not to mention, I need to make sure irq_work
and spin locks are defined.

Another approach is to have it return:

struct trace_pid_list {
	unsigned long		ignore;
};

Rename the above struct trace_pid_list to struct trace_pid_internal.

And internally have:

union trace_pid_data {
	struct trace_pid_list		external;
	struct trace_pid_internal	internal;
};

Then use the internal version within the C file that modifies it, and just
return a pointer to the external part.

That should follow the "C standard".

-- Steve
