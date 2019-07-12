Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB5666B50
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 13:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfGLLDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 07:03:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53308 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfGLLDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 07:03:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PD94wZRNXHIjHblu3nIrY4xxlHZYXkLegGZyayPXJPA=; b=LdoVKmUIYMMAH0RwU1/sb66Wt
        PDIews2/h6sozwC0zDIT4qd9SogFPE8J/64yxNOntCL5i28uDH3ABs3F9LZSk85qfeMr/Kt5nyaA0
        Cquj6eo1chq4GUCT+inbwuTEOZh4AnYQaFsOhi8FkO0DtOhKIzr0rtXPOKgkX6CORU7N63f/cN0uw
        RjxLEuZUDL5JKAbluFeI8rfg2CtCfW/UhC0HK1DmeRDhd5H/GtQxVwWuSOT7jSZQcaa0WwNsGbKui
        Rv7WZunOPBMTk/6IuVd+sc9fV0N25106/kjObkCTCppnjgcs0hF8Cp2YAaEfufGieuJllqDsFPGMV
        wcgMqYSaA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hltJA-0000LI-PF; Fri, 12 Jul 2019 11:01:44 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1B88C2080B963; Fri, 12 Jul 2019 13:01:42 +0200 (CEST)
Date:   Fri, 12 Jul 2019 13:01:42 +0200
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
Message-ID: <20190712110142.GS3402@hirez.programming.kicks-ass.net>
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
> This patch adds support for checking RCU reader sections in list
> traversal macros. Optionally, if the list macro is called under SRCU or
> other lock/mutex protection, then appropriate lockdep expressions can be
> passed to make the checks pass.
> 
> Existing list_for_each_entry_rcu() invocations don't need to pass the
> optional fourth argument (cond) unless they are under some non-RCU
> protection and needs to make lockdep check pass.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  include/linux/rculist.h  | 29 ++++++++++++++++++++++++-----
>  include/linux/rcupdate.h |  7 +++++++
>  kernel/rcu/Kconfig.debug | 11 +++++++++++
>  kernel/rcu/update.c      | 26 ++++++++++++++++++++++++++
>  4 files changed, 68 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index e91ec9ddcd30..78c15ec6b2c9 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -40,6 +40,23 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
>   */
>  #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
>  
> +/*
> + * Check during list traversal that we are within an RCU reader
> + */
> +
> +#define SIXTH_ARG(a1, a2, a3, a4, a5, a6, ...) a6
> +#define COUNT_VARGS(...) SIXTH_ARG(dummy, ## __VA_ARGS__, 4, 3, 2, 1, 0)

You don't seem to actually use it in this patch; also linux/kernel.h has
COUNT_ARGS().
