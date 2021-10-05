Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4684232B4
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 23:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhJEVLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 17:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhJEVLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 17:11:00 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A0DC061749;
        Tue,  5 Oct 2021 14:09:09 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 15A2B586F499E; Tue,  5 Oct 2021 23:09:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 1240C60EFF223;
        Tue,  5 Oct 2021 23:09:08 +0200 (CEST)
Date:   Tue, 5 Oct 2021 23:09:08 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
In-Reply-To: <20211005163754.66552fb3@gandalf.local.home>
Message-ID: <pn2qp6r2-238q-rs8n-p8n0-9s37sr614123@vanv.qr>
References: <20211005094728.203ecef2@gandalf.local.home> <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk> <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com> <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr> <20211005144002.34008ea0@gandalf.local.home>
 <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr> <20211005154029.46f9c596@gandalf.local.home> <20211005163754.66552fb3@gandalf.local.home>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tuesday 2021-10-05 22:37, Steven Rostedt wrote:
>
>Really, thinking about abstraction, I don't believe there's anything wrong
>with returning a pointer of one type, and then typecasting it to a pointer
>of another type. Is there? As long as whoever uses the returned type does
>nothing with it.

Illegal.
https://en.cppreference.com/w/c/language/conversion
subsection "Pointer conversion"
"No other guarantees are offered"

>struct trace_pid_list *trace_pid_list_alloc(void)
>{
>	struct pid_list *pid_list;
>
>	pid_list = kmalloc(sizeof(*pid_list), GFP_KERNEL);
>	[..]
>
>	return (struct trace_pid_list *)pid_list;
>}

struct trace_pid_list { void *pid_list; };
struct trace_pid_list trace_pid_list_alloc(void)
{
	struct trace_pid_list t;
	t.pid_list = kmalloc(sizeof(t.orig), GFP_KERNEL);
	return t;
}
void freethat(struct strace_pid_list x)
{
	kfree(x.pid_list);
}

Might run afoul of -Waggregate-return in C.
