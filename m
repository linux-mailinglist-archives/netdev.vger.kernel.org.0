Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28B2422E28
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbhJEQmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233896AbhJEQmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:42:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F247B611C5;
        Tue,  5 Oct 2021 16:40:18 +0000 (UTC)
Date:   Tue, 5 Oct 2021 12:40:17 -0400
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
        coreteam <coreteam@netfilter.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
Message-ID: <20211005124017.1662f3f3@gandalf.local.home>
In-Reply-To: <155148572.2789.1633450504238.JavaMail.zimbra@efficios.com>
References: <20211005094728.203ecef2@gandalf.local.home>
        <505004021.2637.1633446912223.JavaMail.zimbra@efficios.com>
        <20211005115817.2e1b57bd@gandalf.local.home>
        <155148572.2789.1633450504238.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 12:15:04 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> See Documentation/RCU/arrayRCU.rst:
> 
> "It might be tempting to consider use
> of RCU to instead protect the index into an array, however, this use

Ah, array indexes. Now that makes sense.

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

Thanks for looking at this. I'll go punt and just expose the structure.
It's not a big deal, but I like abstraction of structures when they can be,
just to keep from the temptation of tweaking them directly, and causing
updates later to be more difficult.

Too bad that the failure here is not RCU or the macros, but what I would
call a bug in a specific compiler.

-- Steve

