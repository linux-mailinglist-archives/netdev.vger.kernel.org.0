Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2DA3680D7
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhDVMtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236008AbhDVMtb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 08:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C42B761417;
        Thu, 22 Apr 2021 12:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619095736;
        bh=sio4yeEIpcAeAuHiVfe5CZRdx47ywV9hEITNO0odMhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kE/zD7pFcFxF7sC9BIItIyqC7453Q2szTEBLlsKU70yuC9IaDYMdcGSJSZZc4+jaO
         a352SBjIYIFv9MIhAQF9NfLs+ByM5vQPLQfTtoegTH/G3Xt7HbL89GbyRT97Jr2kyN
         UuzCpspdrmOq0SDo5pKDdJjGBbdS7oTut34USllAKcJ1+EOM2bTWT1SwyWlkGU6IFl
         xWdvsq965CA50pKiJOW/gFt3+K30scIpxFFSyOlkJAjnv20i6L3ijG49qrfZrXGwU1
         wHc3saIp5vHS9RQ0L/RjR2k+UdkdrSGHGzdBq8EgoZUxsWHYVBHN9R1spslWObPkAP
         dZnbFc6DTGnQg==
Date:   Thu, 22 Apr 2021 13:48:50 +0100
From:   Will Deacon <will@kernel.org>
To:     Liam Howlett <liam.howlett@oracle.com>, ebiederm@xmission.com
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH 2/3] arm64: signal: sigreturn() and rt_sigreturn()
 sometime returns the wrong signals
Message-ID: <20210422124849.GA1521@willie-the-truck>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
 <20210420165001.3790670-2-Liam.Howlett@Oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420165001.3790670-2-Liam.Howlett@Oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+Eric as he actually understands how this is supposed to work]

On Tue, Apr 20, 2021 at 04:50:13PM +0000, Liam Howlett wrote:
> arm64_notify_segfault() was used to force a SIGSEGV in all error cases
> in sigreturn() and rt_sigreturn() to avoid writing a new sig handler.
> There is now a better sig handler to use which does not search the VMA
> address space and return a slightly incorrect error code.  Restore the
> older and correct si_code of SI_KERNEL by using arm64_notify_die().  In
> the case of !access_ok(), simply return SIGSEGV with si_code
> SEGV_ACCERR.
> 
> This change requires exporting arm64_notfiy_die() to the arm64 traps.h
> 
> Fixes: f71016a8a8c5 (arm64: signal: Call arm64_notify_segfault when
> failing to deliver signal)
> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> ---
>  arch/arm64/include/asm/traps.h |  2 ++
>  arch/arm64/kernel/signal.c     |  8 ++++++--
>  arch/arm64/kernel/signal32.c   | 18 ++++++++++++++----
>  3 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.h
> index 54f32a0675df..9b76144fcba6 100644
> --- a/arch/arm64/include/asm/traps.h
> +++ b/arch/arm64/include/asm/traps.h
> @@ -29,6 +29,8 @@ void arm64_notify_segfault(unsigned long addr);
>  void arm64_force_sig_fault(int signo, int code, unsigned long far, const char *str);
>  void arm64_force_sig_mceerr(int code, unsigned long far, short lsb, const char *str);
>  void arm64_force_sig_ptrace_errno_trap(int errno, unsigned long far, const char *str);
> +void arm64_notify_die(const char *str, struct pt_regs *regs, int signo,
> +		      int sicode, unsigned long far, int err);
>  
>  /*
>   * Move regs->pc to next instruction and do necessary setup before it
> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index 6237486ff6bb..9fde6dc760c3 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -544,7 +544,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
>  	frame = (struct rt_sigframe __user *)regs->sp;
>  
>  	if (!access_ok(frame, sizeof (*frame)))
> -		goto badframe;
> +		goto e_access;
>  
>  	if (restore_sigframe(regs, frame))
>  		goto badframe;
> @@ -555,7 +555,11 @@ SYSCALL_DEFINE0(rt_sigreturn)
>  	return regs->regs[0];
>  
>  badframe:
> -	arm64_notify_segfault(regs->sp);
> +	arm64_notify_die("Bad frame", regs, SIGSEGV, SI_KERNEL, regs->sp, 0);
> +	return 0;
> +
> +e_access:
> +	force_signal_inject(SIGSEGV, SEGV_ACCERR, regs->sp, 0);
>  	return 0;

This seems really error-prone to me, but maybe I'm just missing some
context. What's the rule for reporting an si_code of SI_KERNEL vs
SEGV_ACCERR, and is the former actually valid for SIGSEGV?

With this change, pointing the (signal) stack to a kernel address will
result in SEGV_ACCERR but pointing it to something like a PROT_NONE user
address will give SI_KERNEL (well, assuming that we manage to deliver
the SEGV somehow). I'm having a hard time seeing why that's a useful
distinction to make..

If it's important to get this a particular way around, please can you
add some selftests?

Will
