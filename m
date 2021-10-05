Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CF6423025
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbhJESl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhJESl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 14:41:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB861613D3;
        Tue,  5 Oct 2021 18:40:03 +0000 (UTC)
Date:   Tue, 5 Oct 2021 14:40:02 -0400
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
Message-ID: <20211005144002.34008ea0@gandalf.local.home>
In-Reply-To: <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr>
References: <20211005094728.203ecef2@gandalf.local.home>
        <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
        <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
        <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 20:28:54 +0200 (CEST)
Jan Engelhardt <jengelh@inai.de> wrote:

> On Tuesday 2021-10-05 20:06, Mathieu Desnoyers wrote:
> >> instead of just "typeof(p)", to force the decay to a pointer.  
> >
> >If the type of @p is an integer, (p) + 0 is still valid, so it will not
> >prevent users from passing an integer type as argument, which is what
> >the current implementation prevents.
> >
> >Also, AFAIU, the compiler wants to know the sizeof(p) in order to evaluate
> >(p + 0). Steven's goal is to hide the structure declaration, so that would
> >not work either.  
> 
> >>>> typeof(*p) *________p1 = (typeof(*p) *__force)READ_ONCE(p);  
> 
> 
> #define static_cast(type, expr) ((struct { type x; }){(expr)}.x)
> typeof(p) p1 = (typeof(p) __force)static_cast(void *, READ_ONCE(p));
> 
> Let the name not fool you; it's absolutely _not_ the same as C++'s 
> static_cast, but still: it does emit a warning when you do pass an 
> integer, which is better than no warning at all in that case.
> 
>  *flies away*

Are you suggesting I should continue this exercise ;-)

-- Steve
