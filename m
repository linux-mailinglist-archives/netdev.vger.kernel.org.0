Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849DF423007
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhJESat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJESas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 14:30:48 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66465C061749;
        Tue,  5 Oct 2021 11:28:57 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 9FB465877C256; Tue,  5 Oct 2021 20:28:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 9C8A260C1CB34;
        Tue,  5 Oct 2021 20:28:54 +0200 (CEST)
Date:   Tue, 5 Oct 2021 20:28:54 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     rostedt <rostedt@goodmis.org>
cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
Message-ID: <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr>
References: <20211005094728.203ecef2@gandalf.local.home> <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk> <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tuesday 2021-10-05 20:06, Mathieu Desnoyers wrote:
>> instead of just "typeof(p)", to force the decay to a pointer.
>
>If the type of @p is an integer, (p) + 0 is still valid, so it will not
>prevent users from passing an integer type as argument, which is what
>the current implementation prevents.
>
>Also, AFAIU, the compiler wants to know the sizeof(p) in order to evaluate
>(p + 0). Steven's goal is to hide the structure declaration, so that would
>not work either.

>>>> typeof(*p) *________p1 = (typeof(*p) *__force)READ_ONCE(p);


#define static_cast(type, expr) ((struct { type x; }){(expr)}.x)
typeof(p) p1 = (typeof(p) __force)static_cast(void *, READ_ONCE(p));

Let the name not fool you; it's absolutely _not_ the same as C++'s 
static_cast, but still: it does emit a warning when you do pass an 
integer, which is better than no warning at all in that case.

 *flies away*
