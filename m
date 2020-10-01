Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CB6280199
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732499AbgJAOrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732020AbgJAOrf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 10:47:35 -0400
Received: from localhost (fla63-h02-176-172-189-251.dsl.sta.abo.bbox.fr [176.172.189.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F27AF207DE;
        Thu,  1 Oct 2020 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601563654;
        bh=i8gkPOTOaQ0+zyvFuAkWNLjAJL2goMrnBIOZltkQ8Ck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AZLGzuFNTPMn09I0z3LQqB6nzf+J1qT4KmkpA1/2qQMnhaYS05nYkxwEHglBaBKuK
         OD4eWHWTOmOuR6j18ekhqESCIE/U4IteqNC3m2p98CQYXbpth1LrOuqwP+CvdoDQ2N
         vjlq3eoDrlemL6LFh9S2r7IqXrpMviURP4YvS3WE=
Date:   Thu, 1 Oct 2020 16:47:31 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Alex Belits <abelits@marvell.com>
Cc:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 11/13] task_isolation: net: don't flush backlog on
 CPUs running isolated tasks
Message-ID: <20201001144731.GC6595@lothringen>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
 <01470cf1f1a2e79e46a87bb5a8a4780a1c3cc740.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01470cf1f1a2e79e46a87bb5a8a4780a1c3cc740.camel@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 02:58:24PM +0000, Alex Belits wrote:
> From: Yuri Norov <ynorov@marvell.com>
> 
> If CPU runs isolated task, there's no any backlog on it, and
> so we don't need to flush it.

What guarantees that we have no backlog on it?

> Currently flush_all_backlogs()
> enqueues corresponding work on all CPUs including ones that run
> isolated tasks. It leads to breaking task isolation for nothing.
> 
> In this patch, backlog flushing is enqueued only on non-isolated CPUs.
> 
> Signed-off-by: Yuri Norov <ynorov@marvell.com>
> [abelits@marvell.com: use safe task_isolation_on_cpu() implementation]
> Signed-off-by: Alex Belits <abelits@marvell.com>
> ---
>  net/core/dev.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 90b59fc50dc9..83a282f7453d 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -74,6 +74,7 @@
>  #include <linux/cpu.h>
>  #include <linux/types.h>
>  #include <linux/kernel.h>
> +#include <linux/isolation.h>
>  #include <linux/hash.h>
>  #include <linux/slab.h>
>  #include <linux/sched.h>
> @@ -5624,9 +5625,13 @@ static void flush_all_backlogs(void)
>  
>  	get_online_cpus();
>  
> -	for_each_online_cpu(cpu)
> +	smp_rmb();

What is it ordering?

> +	for_each_online_cpu(cpu) {
> +		if (task_isolation_on_cpu(cpu))
> +			continue;
>  		queue_work_on(cpu, system_highpri_wq,
>  			      per_cpu_ptr(&flush_works, cpu));
> +	}
>  
>  	for_each_online_cpu(cpu)
>  		flush_work(per_cpu_ptr(&flush_works, cpu));

Thanks.
