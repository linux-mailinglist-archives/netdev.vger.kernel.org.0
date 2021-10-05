Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FA542322B
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 22:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbhJEUju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 16:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230098AbhJEUjt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 16:39:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5065C613D5;
        Tue,  5 Oct 2021 20:37:57 +0000 (UTC)
Date:   Tue, 5 Oct 2021 16:37:54 -0400
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
Message-ID: <20211005163754.66552fb3@gandalf.local.home>
In-Reply-To: <20211005154029.46f9c596@gandalf.local.home>
References: <20211005094728.203ecef2@gandalf.local.home>
        <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
        <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
        <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr>
        <20211005144002.34008ea0@gandalf.local.home>
        <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr>
        <20211005154029.46f9c596@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 15:40:29 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> struct trace_pid_list {
> 	unsigned long		ignore;
> };
> 
> Rename the above struct trace_pid_list to struct trace_pid_internal.
> 
> And internally have:
> 
> union trace_pid_data {
> 	struct trace_pid_list		external;
> 	struct trace_pid_internal	internal;
> };
> 
> Then use the internal version within the C file that modifies it, and just
> return a pointer to the external part.

So this has proved to be a PITA.

> 
> That should follow the "C standard".

Really, thinking about abstraction, I don't believe there's anything wrong
with returning a pointer of one type, and then typecasting it to a pointer
of another type. Is there? As long as whoever uses the returned type does
nothing with it.

That is, if I simply do:

In the header file:

struct trace_pid_list {
	void *ignore;
};

struct trace_pid_list *trace_pid_list_alloc(void);
void trace_pid_list_free(struct trace_pid_list *pid_list);


And then in the C file:

struct pid_list {
	[...]
};

struct trace_pid_list *trace_pid_list_alloc(void)
{
	struct pid_list *pid_list;

	pid_list = kmalloc(sizeof(*pid_list), GFP_KERNEL);
	[..]

	return (struct trace_pid_list *)pid_list;
}

void trace_pid_list_free(struct trace_pid_list *list)
{
	struct pid_list *pid_list = (struct pid_list *)list;

	[..]
	kfree(pid_list);
}

That should be perfectly fine for standard C. Right?

-- Steve

