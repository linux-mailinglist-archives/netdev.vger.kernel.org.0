Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CAC423144
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 22:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhJEUIv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Oct 2021 16:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhJEUIu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 16:08:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30FDB610CE;
        Tue,  5 Oct 2021 20:06:58 +0000 (UTC)
Date:   Tue, 5 Oct 2021 16:06:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Jan Engelhardt <jengelh@inai.de>,
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
Message-ID: <20211005160656.29e8bf38@gandalf.local.home>
In-Reply-To: <1403497170.3059.1633463398562.JavaMail.zimbra@efficios.com>
References: <20211005094728.203ecef2@gandalf.local.home>
        <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
        <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
        <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr>
        <20211005144002.34008ea0@gandalf.local.home>
        <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr>
        <20211005154029.46f9c596@gandalf.local.home>
        <1403497170.3059.1633463398562.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 15:49:58 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- On Oct 5, 2021, at 3:40 PM, rostedt rostedt@goodmis.org wrote:
> 
> > On Tue, 5 Oct 2021 21:06:36 +0200 (CEST)
> > Jan Engelhardt <jengelh@inai.de> wrote:
> >   
> >> On Tuesday 2021-10-05 20:40, Steven Rostedt wrote:  
> >> >>     
> >> >> >>>> typeof(*p) *________p1 = (typeof(*p) *__force)READ_ONCE(p);  
> >> >> 
> >> >> #define static_cast(type, expr) ((struct { type x; }){(expr)}.x)
> >> >> typeof(p) p1 = (typeof(p) __force)static_cast(void *, READ_ONCE(p));
> >> >> 
> >> >> Let the name not fool you; it's absolutely _not_ the same as C++'s
> >> >> static_cast, but still: it does emit a warning when you do pass an
> >> >> integer, which is better than no warning at all in that case.
> >> >> 
> >> >>  *flies away*  
> >> >
> >> >Are you suggesting I should continue this exercise ;-)  
> >> 
> >> “After all, why not?”
> >> 
> >> typeof(p) p1 = (typeof(p) __force)READ_ONCE(p) +
> >>                BUILD_BUG_ON_EXPR(__builtin_classify_type(p) != 5);  
> > 
> > I may try it, because exposing the structure I want to hide, is pulling out
> > a lot of other crap with it :-p  
> 
> I like the static_cast() approach above. It is neat way to validate that the
> argument is a pointer without need to dereference the pointer.
> 
> I would also be open to consider this trick for liburcu's userspace API.
> 
> About the other proposed solution based on __builtin_classify_type, I am
> reluctant to use something designed specifically for varargs in a context
> where they are not used.
> 

Unfortunately, it doesn't solve the Debian gcc 10 compiler failing when
passing the function name instead of a pointer to the function in
RCU_INIT_POINTER()  That alone makes me feel like I shouldn't touch that
macro :-(

And who knows what other version of gcc will fail on passing the address :-p

-- Steve

