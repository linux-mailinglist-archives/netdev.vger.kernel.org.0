Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8042B66B66
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 13:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfGLLMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 07:12:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53624 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfGLLMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 07:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=It5jdfKhVmYVEt2Nrxa1ZDUn89wu3dnyJAHiP9qsY30=; b=XoGg2KePmkIpdC3B0kUZ7Tb2m
        LEO73lBhtob0kk2Q+fMch7o8KyW9XW5SW2zZJWtMeVgjr9uXT5sKGe9pYAEStu/imSHtwcWIH+jwR
        2rDlu/g7t9u/RxPTY7615E6o1hot1C/f4wmZwyUUwMGknaszEbF/uzPXj4AymDscDt6IVHRH6qMoc
        AYZl06xEbp6NonVv3HkCwoDaur1zxjcYG1U2ESixlaTWZ4TelqBbDltIxaqydkDJZJmMs7UdVKWCr
        XMqNArDoslHHDK1HxePnjZAzl98OtiiqECmG2gP+kMQuX5/oUHkDlZqfWTqmlYrxNWNArkVkw1WCt
        rEwBDifEw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hltSZ-0003PS-2W; Fri, 12 Jul 2019 11:11:27 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 78D742080B963; Fri, 12 Jul 2019 13:11:25 +0200 (CEST)
Date:   Fri, 12 Jul 2019 13:11:25 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org, oleg@redhat.com,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v1 1/6] rcu: Add support for consolidated-RCU reader
 checking
Message-ID: <20190712111125.GT3402@hirez.programming.kicks-ass.net>
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-2-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711234401.220336-2-joel@joelfernandes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 07:43:56PM -0400, Joel Fernandes (Google) wrote:
> +int rcu_read_lock_any_held(void)
> +{
> +	int lockdep_opinion = 0;
> +
> +	if (!debug_lockdep_rcu_enabled())
> +		return 1;
> +	if (!rcu_is_watching())
> +		return 0;
> +	if (!rcu_lockdep_current_cpu_online())
> +		return 0;
> +
> +	/* Preemptible RCU flavor */
> +	if (lock_is_held(&rcu_lock_map))

you forgot debug_locks here.

> +		return 1;
> +
> +	/* BH flavor */
> +	if (in_softirq() || irqs_disabled())

I'm not sure I'd put irqs_disabled() under BH, also this entire
condition is superfluous, see below.

> +		return 1;
> +
> +	/* Sched flavor */
> +	if (debug_locks)
> +		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> +	return lockdep_opinion || !preemptible();

that !preemptible() turns into:

  !(preempt_count()==0 && !irqs_disabled())

which is:

  preempt_count() != 0 || irqs_disabled()

and already includes irqs_disabled() and in_softirq().

> +}

So maybe something lke:

	if (debug_locks && (lock_is_held(&rcu_lock_map) ||
			    lock_is_held(&rcu_sched_lock_map)))
		return true;

	return !preemptible();


