Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA3D4232C8
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 23:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbhJEV0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 17:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235679AbhJEV03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 17:26:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 917CE6120A;
        Tue,  5 Oct 2021 21:24:36 +0000 (UTC)
Date:   Tue, 5 Oct 2021 17:24:35 -0400
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
Message-ID: <20211005172435.190c62d9@gandalf.local.home>
In-Reply-To: <pn2qp6r2-238q-rs8n-p8n0-9s37sr614123@vanv.qr>
References: <20211005094728.203ecef2@gandalf.local.home>
        <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
        <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
        <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr>
        <20211005144002.34008ea0@gandalf.local.home>
        <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr>
        <20211005154029.46f9c596@gandalf.local.home>
        <20211005163754.66552fb3@gandalf.local.home>
        <pn2qp6r2-238q-rs8n-p8n0-9s37sr614123@vanv.qr>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 23:09:08 +0200 (CEST)
Jan Engelhardt <jengelh@inai.de> wrote:

> On Tuesday 2021-10-05 22:37, Steven Rostedt wrote:
> >
> >Really, thinking about abstraction, I don't believe there's anything wrong
> >with returning a pointer of one type, and then typecasting it to a pointer
> >of another type. Is there? As long as whoever uses the returned type does
> >nothing with it.  
> 
> Illegal.
> https://en.cppreference.com/w/c/language/conversion
> subsection "Pointer conversion"
> "No other guarantees are offered"

Basically (one alternative I was looking at) was simply passing around a
void pointer. Not sure how the RCU macros would handle that. But to
completely abstract it out, I was thinking of just returning void * and
accepting void *, but I didn't want to do that because now we just lost any
kind of type checking done by the compiler. The tricks I was playing was to
keep some kind of type checking.

> 
> >struct trace_pid_list *trace_pid_list_alloc(void)
> >{
> >	struct pid_list *pid_list;
> >
> >	pid_list = kmalloc(sizeof(*pid_list), GFP_KERNEL);
> >	[..]
> >
> >	return (struct trace_pid_list *)pid_list;
> >}  
> 
> struct trace_pid_list { void *pid_list; };
> struct trace_pid_list trace_pid_list_alloc(void)
> {
> 	struct trace_pid_list t;
> 	t.pid_list = kmalloc(sizeof(t.orig), GFP_KERNEL);
> 	return t;
> }
> void freethat(struct strace_pid_list x)
> {
> 	kfree(x.pid_list);
> }
> 
> Might run afoul of -Waggregate-return in C.

The above isn't exactly what I was suggesting.

And really, not that I'm going to do this, I could have followed the rest
of the kernel with:

struct trace_pid_list {
	int max;
	[..]
};

int *trace_pid_list_alloc(void)
{
	struct trace_pid_list *pid_list;

	pid_list = kmalloc(sizeof(*pid_list), GFP_KERNEL);

	[..]
	return &pid_list->max;
}

void trace_pid_list_free(int *p)
{
	struct trace_pid_list *pid_list = container_of(p, struct pid_list, max);

	[..]
	free(pid_list);
}


Because we do this all over the kernel. Talk about lying to the compiler ;-)

-- Steve

