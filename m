Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153F92C1867
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbgKWW3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:29:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729058AbgKWW3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:29:11 -0500
Received: from localhost (unknown [176.167.152.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18DD1206D5;
        Mon, 23 Nov 2020 22:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606170550;
        bh=xXNk1SHeG0DaBJJsaGjypi7ccMGVaxlbxK413/BOw4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ixP3Yo9U3LEyuDTmCaRqPijWNey8CBiHdJfyFxnoMlHmfOcb4S2gKkJlPWpPLtHQg
         kvc5oiRGqS0ZAHNBtaEIoKLepU2ALrH0nhLNWTasgX6yRBBbAHzbf8Q61ptTFdZKh4
         xqCRZIkjtAaouTmcyAvseDOYLX1ZGfEePoTtoxDU=
Date:   Mon, 23 Nov 2020 23:29:07 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Alex Belits <abelits@marvell.com>
Cc:     "nitesh@redhat.com" <nitesh@redhat.com>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 9/9] task_isolation: kick_all_cpus_sync: don't kick
 isolated cpus
Message-ID: <20201123222907.GC1751@lothringen>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
 <3236b13f42679031960c5605be20664e90e75223.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3236b13f42679031960c5605be20664e90e75223.camel@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 05:58:42PM +0000, Alex Belits wrote:
> From: Yuri Norov <ynorov@marvell.com>
> 
> Make sure that kick_all_cpus_sync() does not call CPUs that are running
> isolated tasks.
> 
> Signed-off-by: Yuri Norov <ynorov@marvell.com>
> [abelits@marvell.com: use safe task_isolation_cpumask() implementation]
> Signed-off-by: Alex Belits <abelits@marvell.com>
> ---
>  kernel/smp.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 4d17501433be..b2faecf58ed0 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -932,9 +932,21 @@ static void do_nothing(void *unused)
>   */
>  void kick_all_cpus_sync(void)
>  {
> +	struct cpumask mask;
> +
>  	/* Make sure the change is visible before we kick the cpus */
>  	smp_mb();
> -	smp_call_function(do_nothing, NULL, 1);
> +
> +	preempt_disable();
> +#ifdef CONFIG_TASK_ISOLATION
> +	cpumask_clear(&mask);
> +	task_isolation_cpumask(&mask);
> +	cpumask_complement(&mask, &mask);
> +#else
> +	cpumask_setall(&mask);
> +#endif
> +	smp_call_function_many(&mask, do_nothing, NULL, 1);
> +	preempt_enable();

Same comment about IPIs here.

>  }
>  EXPORT_SYMBOL_GPL(kick_all_cpus_sync);
>  
> -- 
> 2.20.1
> 
