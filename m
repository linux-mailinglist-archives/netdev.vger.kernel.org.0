Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC0D42313C
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 22:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbhJEUEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 16:04:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230333AbhJEUEr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 16:04:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD35E613B5;
        Tue,  5 Oct 2021 20:02:54 +0000 (UTC)
Date:   Tue, 5 Oct 2021 16:02:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
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
Message-ID: <20211005160252.54640350@gandalf.local.home>
In-Reply-To: <CAHk-=wiL+wyCOTedh48Oz0cNOKJq2GNwtxg6423hf-1FuGrv_A@mail.gmail.com>
References: <20211005094728.203ecef2@gandalf.local.home>
        <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
        <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
        <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr>
        <20211005144002.34008ea0@gandalf.local.home>
        <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr>
        <20211005154029.46f9c596@gandalf.local.home>
        <CAHk-=wiL+wyCOTedh48Oz0cNOKJq2GNwtxg6423hf-1FuGrv_A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 12:46:43 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Oct 5, 2021 at 12:40 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > I may try it, because exposing the structure I want to hide, is pulling out
> > a lot of other crap with it :-p  
> 
> One option is just "don't do rcu_access of a pointer that you're not
> supposed to touch in a file that isn't supposed to touch it".

The problem is, the RCU isn't for touching it, it is for knowing it exists.

> 
> IOW, why are you doing that
> 
>      pid_list = rcu_dereference_sched(tr->function_pids);
> 
> in a place that isn't supposed to look at the pid_list in the first place?
> 
> Yeah, yeah, I see how you just pass it to trace_ignore_this_task() as
> an argument, but maybe the real fix is to just pass that trace_array
> pointer instead?
> 
> IOW, if you want to keep that structure private, maybe you really just
> shouldn't have non-private users of it randomly doing RCU lookups of
> it?
>

Ideally, I wanted to keep the logic of the pid lists separate, and not have
it know about the trace array at all.

And this was the best "incremental" approach I had, as the code is
currently all just open coded.

The RCU lookups are not an internal use functionality of the pid lists. The
updates to the pid list are done by allocating a new pid_list, copying the
old pid_list with the new updates and then swapping the pointers. The logic
of the pid_list is orthogonal to the RCU update. It's just "allocate some
random thing" and use RCU to swap it with the old random thing.

That is, the logic to synchronize updates is left to the user not the pid
list itself.

I also want to limit function calls, as this is called from the function
tracer (every function being traced) and if the pid_list pointer is NULL it
skips it. Hence, I want to avoid calling a function to know if the pointer
is NULL or not.

-- Steve
