Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DC7449928
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhKHQOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:14:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229568AbhKHQOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 11:14:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66D1A6101C;
        Mon,  8 Nov 2021 16:11:16 +0000 (UTC)
Date:   Mon, 8 Nov 2021 11:11:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jonathon Reinhart <jonathon.reinhart@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        tglx@linutronix.de, peterz@infradead.org
Subject: Re: [PATCH net-next] net: sysctl data could be in .bss
Message-ID: <20211108111114.2e37c9d6@gandalf.local.home>
In-Reply-To: <CAPFHKzduJiebgnAAjEvx4vBJCFn7-eyfJ+k6JQja2waxqKeCwQ@mail.gmail.com>
References: <20211020083854.1101670-1-atenart@kernel.org>
        <20211022130146.3dacef0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAPFHKzduJiebgnAAjEvx4vBJCFn7-eyfJ+k6JQja2waxqKeCwQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 00:24:33 -0500
Jonathon Reinhart <jonathon.reinhart@gmail.com> wrote:

> On Fri, Oct 22, 2021 at 4:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Widening the CC list a little.

Thanks!

[..]

> The core_kernel_data() function was introduced in a2d063ac216c1, and
> the commit message says:
> 
> "It may or may not return true for RO data... This utility function is
> used to determine if data is safe from ever being freed. Thus it
> should return true for all RW global data that is not in a module or
> has been allocated, or false otherwise."
> 
> The intent of the function seems to be more in line with the
> higher-level "is this global kernel data" semantics you suggested. The
> purpose seems to be to differentiate between "part of the loaded
> kernel image" vs. a dynamic allocation (which would include a loaded
> module image). And given that it *might* return true for RO data
> (depending on the arch linker script, presumably), I think it would be
> safe to include .bss -- clearly, with that caveat in place, it isn't
> promising strict section semantics.
> 
> There are only two existing in-tree consumers:
> 
> 1. __register_ftrace_function() [kernel/trace/ftrace.c] -- Sets
> FTRACE_OPS_FL_DYNAMIC if core_kernel_data(ops) returns false, which
> denotes "dynamically allocated ftrace_ops which need special care". It
> would be unlikely (if not impossible) for the "ops" object in question
> to be all-zero and end up in the .bss, but if it were, then the
> current behavior would be wrong. IOW, it would be more correct to
> include .bss.
> 
> 2. ensure_safe_net_sysctl() [net/sysctl_net.c] (The subject of this
> thread) -- Trying to distinguish "global kernel data" (static/global
> variables) from kmalloc-allocated objects. More correct to include
> .bss.
> 
> Both of these callers only seem to delineate between static and
> dynamic object allocations. Put another way, if core_kernel_bss(), all
> existing callers should be updated to check core_kernel_data() ||
> core_kernel_bss().
> 
> Since Steven introduced it, and until I added
> ensure_safe_net_sysctl(), he / tracing was the only consumer.

I agree with your analysis.

The intent is that allocated ftrace_ops (things that function tracer uses
to know what callbacks are called from function entry), must go through a
very slow synchronization (rcu_synchronize_tasks). But this is not needed
if the ftrace_ops is part of the core kernel (.data or .bss) as that will
never be freed, and thus does not need to worry about it disappearing while
they are still in use.

> 
> Thinking critically from the C language perspective, I can't come up
> with any case where one would actually expect core_kernel_data() to
> return true for 'int global = 1' and false for 'int global = 0'.
> 
> In conclusion, I agree with your alternative proposal Jakub, and I
> think this patch is the right way forward:
> 
> diff --git a/kernel/extable.c b/kernel/extable.c
> index b0ea5eb0c3b4..8b6f1d0bdaf6 100644
> --- a/kernel/extable.c
> +++ b/kernel/extable.c
> @@ -97,6 +97,9 @@ int core_kernel_data(unsigned long addr)
>         if (addr >= (unsigned long)_sdata &&
>             addr < (unsigned long)_edata)
>                 return 1;
> +       if (addr >= (unsigned long)__bss_start &&
> +           addr < (unsigned long)__bss_stop)
> +               return 1;
>         return 0;
>  }

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

