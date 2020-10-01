Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D474628017A
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732513AbgJAOk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732020AbgJAOkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 10:40:55 -0400
Received: from localhost (fla63-h02-176-172-189-251.dsl.sta.abo.bbox.fr [176.172.189.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1EAA20780;
        Thu,  1 Oct 2020 14:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601563255;
        bh=DhY0IbX8UQYySEuqd6kJGsABVcgsf2XJo61neYj6iVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O/ZBWi78hPtqwdVSIbY+TWkDscWVTruDQBqStBOGnT7e3MLHlds9c04L+sw7/cR00
         wKD5yk9vWLUR0g2enFwY8Oe+xu94OWyMYPnHGjkTdYEt/ybCkVId/EB7jaxqN2Ruxm
         S+YC8oQanUYpQVJcvT8ZLAmjC9SR480rBNdwAxVg=
Date:   Thu, 1 Oct 2020 16:40:52 +0200
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
Subject: Re: [PATCH v4 03/13] task_isolation: userspace hard isolation from
 kernel
Message-ID: <20201001144052.GA6595@lothringen>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
 <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 02:49:49PM +0000, Alex Belits wrote:
> +/**
> + * task_isolation_kernel_enter() - clear low-level task isolation flag
> + *
> + * This should be called immediately after entering kernel.
> + */
> +static inline void task_isolation_kernel_enter(void)
> +{
> +	unsigned long flags;
> +
> +	/*
> +	 * This function runs on a CPU that ran isolated task.
> +	 *
> +	 * We don't want this CPU running code from the rest of kernel
> +	 * until other CPUs know that it is no longer isolated.
> +	 * When CPU is running isolated task until this point anything
> +	 * that causes an interrupt on this CPU must end up calling this
> +	 * before touching the rest of kernel. That is, this function or
> +	 * fast_task_isolation_cpu_cleanup() or stop_isolation() calling
> +	 * it. If any interrupt, including scheduling timer, arrives, it
> +	 * will still end up here early after entering kernel.
> +	 * From this point interrupts are disabled until all CPUs will see
> +	 * that this CPU is no longer running isolated task.
> +	 *
> +	 * See also fast_task_isolation_cpu_cleanup().
> +	 */
> +	smp_rmb();

I'm a bit confused what this read memory barrier is ordering. Also against
what it pairs.

> +	if((this_cpu_read(ll_isol_flags) & FLAG_LL_TASK_ISOLATION) == 0)
> +		return;
> +
> +	local_irq_save(flags);
> +
> +	/* Clear low-level flags */
> +	this_cpu_write(ll_isol_flags, 0);
> +
> +	/*
> +	 * If something happened that requires a barrier that would
> +	 * otherwise be called from remote CPUs by CPU kick procedure,
> +	 * this barrier runs instead of it. After this barrier, CPU
> +	 * kick procedure would see the updated ll_isol_flags, so it
> +	 * will run its own IPI to trigger a barrier.
> +	 */
> +	smp_mb();
> +	/*
> +	 * Synchronize instructions -- this CPU was not kicked while
> +	 * in isolated mode, so it might require synchronization.
> +	 * There might be an IPI if kick procedure happened and
> +	 * ll_isol_flags was already updated while it assembled a CPU
> +	 * mask. However if this did not happen, synchronize everything
> +	 * here.
> +	 */
> +	instr_sync();

It's the first time I meet an instruction barrier. I should get information
about that but what is it ordering here?

> +	local_irq_restore(flags);
> +}

Thanks.
