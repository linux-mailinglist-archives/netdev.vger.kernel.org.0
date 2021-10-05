Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA7C422DF5
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbhJEQbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236088AbhJEQbG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:31:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2189D61373;
        Tue,  5 Oct 2021 16:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633451356;
        bh=iwigj6eqF85kwprTmioYxRpgk7wef6bzF9Dh2dvCPjw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=AlXg6bGLNt7mMzBF/flLI36K2EjnFNxsBWAu6yprqL0wtI8WnL9FR1JLjxK+2foPA
         jfdoChtdolfmJnadyhnhdglJpcA3NvDTReEmu41CYpBxcx4I09xz/9jBm0JIM+oUBG
         GwrGAm2OhG7s5lqdXitgyMHwK2MpXzzkaPaEAoai+NN6loKruu6mH5D1vkxk873n+9
         ibhq+PXrqr9yCgkzlF01zxyvkwigyxbkPytXlmd9WIT93erDqC5KBKDcgFW/SWCM5c
         285Qeaajs7HoZNhb2B9+5VREBGmTjJmid0ze2Zv3L1ML7+tXNgHsYqLX89RJ3Noi4F
         gIB761HlQ35Dg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id D979A5C098A; Tue,  5 Oct 2021 09:29:15 -0700 (PDT)
Date:   Tue, 5 Oct 2021 09:29:15 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20211005162915.GT880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20211005094728.203ecef2@gandalf.local.home>
 <505004021.2637.1633446912223.JavaMail.zimbra@efficios.com>
 <20211005115817.2e1b57bd@gandalf.local.home>
 <155148572.2789.1633450504238.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155148572.2789.1633450504238.JavaMail.zimbra@efficios.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 12:15:04PM -0400, Mathieu Desnoyers wrote:
> ----- On Oct 5, 2021, at 11:58 AM, rostedt rostedt@goodmis.org wrote:
> 
> > On Tue, 5 Oct 2021 11:15:12 -0400 (EDT)
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> >> ----- On Oct 5, 2021, at 9:47 AM, rostedt rostedt@goodmis.org wrote:
> >> [...]
> >> > #define rcu_dereference_raw(p) \
> >> > ({ \
> >> > 	/* Dependency order vs. p above. */ \
> >> > 	typeof(p) ________p1 = READ_ONCE(p); \
> >> > -	((typeof(*p) __force __kernel *)(________p1)); \
> >> > +	((typeof(p) __force __kernel)(________p1)); \
> >> > })
> >> 
> >> AFAIU doing so removes validation that @p is indeed a pointer, so a user might
> >> mistakenly
> >> try to use rcu_dereference() on an integer, and get away with it. I'm not sure
> >> we want to
> >> loosen this check. I wonder if there might be another way to achieve the same
> >> check without
> >> requiring the structure to be declared, e.g. with __builtin_types_compatible_p ?
> > 
> > Is that really an issue? Because you would be assigning it to an integer.
> > 
> > 
> >	x = rcu_dereference_raw(y);
> > 
> > And that just makes 'x' a copy of 'y' and not really a reference to it, thus
> > if you don't have a pointer, it's just a fancy READ_ONCE(y).
> 
> See Documentation/RCU/arrayRCU.rst:
> 
> "It might be tempting to consider use
> of RCU to instead protect the index into an array, however, this use
> case is **not** supported.  The problem with RCU-protected indexes into
> arrays is that compilers can play way too many optimization games with
> integers, which means that the rules governing handling of these indexes
> are far more trouble than they are worth.  If RCU-protected indexes into
> arrays prove to be particularly valuable (which they have not thus far),
> explicit cooperation from the compiler will be required to permit them
> to be safely used."
> 
> So AFAIU validation that rcu_dereference receives a pointer as parameter
> is done on purpose.

What Mathieu said!

On the other hand, I am starting to believe that explicit cooperation
from compilers might actually be forthcoming in my lifetime, so there
might well be that...

							Thanx, Paul
