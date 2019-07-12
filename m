Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD24672E5
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 18:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfGLQA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 12:00:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35724 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfGLQA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 12:00:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tyTl1YbLBKPDWZGZvgKJMIcMQjGDx2jzfk/EinyXaGw=; b=OJmluq10NP9ipXVsYrmwopFcf
        do+lSJThkEy+P/MV/f2o9QPEWNc0Gh7X0FBRZSWSNdmGaYj4is98cT3u0ezQl96GDgZSt+jAi7LUF
        dgmWzIepmiPHhH4mZYRWfi7kxUTmjmcDJz7hlYH60YSSdmd3Hw0IttJOqjQ1kbRyE1tIxZJk8srJB
        IlCUyCp9dTm7j7m3hz11ELDmm4StRo9BXM8WcqhoSdEXy+QlzQMk2rwFn7NYspxNWjPesn9gCPQWU
        Iq/HoBQSN9wY4c/HLnRVXbE/JfP0y4ilrxP/RMaRHC4JdB7795AK+0L93m59yddMBltlvPsbIJi/Z
        DkwYvlJSQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hlxwr-0006qv-UH; Fri, 12 Jul 2019 15:59:02 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 546B4209772E8; Fri, 12 Jul 2019 17:58:59 +0200 (CEST)
Date:   Fri, 12 Jul 2019 17:58:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joel Fernandes <joel@joelfernandes.org>
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
Message-ID: <20190712155859.GV3419@hirez.programming.kicks-ass.net>
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-2-joel@joelfernandes.org>
 <20190712111125.GT3402@hirez.programming.kicks-ass.net>
 <20190712151051.GB235410@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712151051.GB235410@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 11:10:51AM -0400, Joel Fernandes wrote:
> Agreed, I will do it this way (without the debug_locks) like:
> 
> ---8<-----------------------
> 
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index ba861d1716d3..339aebc330db 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -296,27 +296,15 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
>  
>  int rcu_read_lock_any_held(void)
>  {
>  	if (!debug_lockdep_rcu_enabled())
>  		return 1;
>  	if (!rcu_is_watching())
>  		return 0;
>  	if (!rcu_lockdep_current_cpu_online())
>  		return 0;
> +	if (lock_is_held(&rcu_lock_map) || lock_is_held(&rcu_sched_lock_map))
> +		return 1;
> +	return !preemptible();
>  }
>  EXPORT_SYMBOL_GPL(rcu_read_lock_any_held);

OK, that looks sane. Thanks!
