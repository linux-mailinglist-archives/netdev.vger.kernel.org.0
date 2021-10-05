Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C26422D29
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbhJEQAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234282AbhJEQAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:00:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6D4C61166;
        Tue,  5 Oct 2021 15:58:18 +0000 (UTC)
Date:   Tue, 5 Oct 2021 11:58:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
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
        coreteam@netfilter.org, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
Message-ID: <20211005115817.2e1b57bd@gandalf.local.home>
In-Reply-To: <505004021.2637.1633446912223.JavaMail.zimbra@efficios.com>
References: <20211005094728.203ecef2@gandalf.local.home>
        <505004021.2637.1633446912223.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 11:15:12 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- On Oct 5, 2021, at 9:47 AM, rostedt rostedt@goodmis.org wrote:
> [...]
> > #define rcu_dereference_raw(p) \
> > ({ \
> > 	/* Dependency order vs. p above. */ \
> > 	typeof(p) ________p1 = READ_ONCE(p); \
> > -	((typeof(*p) __force __kernel *)(________p1)); \
> > +	((typeof(p) __force __kernel)(________p1)); \
> > })  
> 
> AFAIU doing so removes validation that @p is indeed a pointer, so a user might mistakenly
> try to use rcu_dereference() on an integer, and get away with it. I'm not sure we want to
> loosen this check. I wonder if there might be another way to achieve the same check without
> requiring the structure to be declared, e.g. with __builtin_types_compatible_p ?

Is that really an issue? Because you would be assigning it to an integer.


	x = rcu_dereference_raw(y);

And that just makes 'x' a copy of 'y' and not really a reference to it, thus
if you don't have a pointer, it's just a fancy READ_ONCE(y).

-- Steve

