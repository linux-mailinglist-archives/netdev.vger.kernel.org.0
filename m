Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFF37C82E
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 18:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbfGaQIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 12:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfGaQIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 12:08:44 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51510206A3;
        Wed, 31 Jul 2019 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564589323;
        bh=WAbIhLASr4HTtdR9ravIERTChOPpIFMTIBTHgYf/DsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=voCEdTTwgdgDUsyOjJhdQWJWFfTiMS0gs6bLzsXhFvDCtYcKYh9sECeK98JaU32pL
         LjwlA4InjmKn8msUdy+U1H1eUgNSFa0ND92uxVnYVE75pZdpr1yJTracnbE08QiQNx
         QaY6JGNBPqwff8qujBa7WhZTsL1uMTh8kNMksdP8=
Date:   Wed, 31 Jul 2019 17:08:37 +0100
From:   Will Deacon <will@kernel.org>
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Justin He <Justin.He@arm.com>
Subject: Re: [PATCH 1/2] arm64: Add support for function error injection
Message-ID: <20190731160836.qmzlk3ndbahwhfmu@willie-the-truck>
References: <20190716111301.1855-1-leo.yan@linaro.org>
 <20190716111301.1855-2-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716111301.1855-2-leo.yan@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 07:13:00PM +0800, Leo Yan wrote:
> This patch implement regs_set_return_value() and
> override_function_with_return() to support function error injection
> for arm64.
> 
> In the exception flow, arm64's general register x30 contains the value
> for the link register; so we can just update pt_regs::pc with it rather
> than redirecting execution to a dummy function that returns.
> 
> This patch is heavily inspired by the commit 7cd01b08d35f ("powerpc:
> Add support for function error injection").
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  arch/arm64/Kconfig                       |  1 +
>  arch/arm64/include/asm/error-injection.h | 13 +++++++++++++
>  arch/arm64/include/asm/ptrace.h          |  5 +++++
>  arch/arm64/lib/Makefile                  |  2 ++
>  arch/arm64/lib/error-inject.c            | 19 +++++++++++++++++++
>  5 files changed, 40 insertions(+)
>  create mode 100644 arch/arm64/include/asm/error-injection.h
>  create mode 100644 arch/arm64/lib/error-inject.c
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 697ea0510729..a6d9e622977d 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -142,6 +142,7 @@ config ARM64
>  	select HAVE_EFFICIENT_UNALIGNED_ACCESS
>  	select HAVE_FTRACE_MCOUNT_RECORD
>  	select HAVE_FUNCTION_TRACER
> +	select HAVE_FUNCTION_ERROR_INJECTION
>  	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_GCC_PLUGINS
>  	select HAVE_HW_BREAKPOINT if PERF_EVENTS
> diff --git a/arch/arm64/include/asm/error-injection.h b/arch/arm64/include/asm/error-injection.h
> new file mode 100644
> index 000000000000..da057e8ed224
> --- /dev/null
> +++ b/arch/arm64/include/asm/error-injection.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +
> +#ifndef __ASM_ERROR_INJECTION_H_
> +#define __ASM_ERROR_INJECTION_H_
> +
> +#include <linux/compiler.h>
> +#include <linux/linkage.h>
> +#include <asm/ptrace.h>
> +#include <asm-generic/error-injection.h>
> +
> +void override_function_with_return(struct pt_regs *regs);
> +
> +#endif /* __ASM_ERROR_INJECTION_H_ */

Why isn't this prototype in the asm-generic header? Seems weird to have to
duplicate it for each architecture.

> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> index dad858b6adc6..3aafbbe218a2 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -294,6 +294,11 @@ static inline unsigned long regs_return_value(struct pt_regs *regs)
>  	return regs->regs[0];
>  }
>  
> +static inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
> +{
> +	regs->regs[0] = rc;
> +}
> +
>  /**
>   * regs_get_kernel_argument() - get Nth function argument in kernel
>   * @regs:	pt_regs of that context
> diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
> index 33c2a4abda04..f182ccb0438e 100644
> --- a/arch/arm64/lib/Makefile
> +++ b/arch/arm64/lib/Makefile
> @@ -33,3 +33,5 @@ UBSAN_SANITIZE_atomic_ll_sc.o	:= n
>  lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
>  
>  obj-$(CONFIG_CRC32) += crc32.o
> +
> +obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
> diff --git a/arch/arm64/lib/error-inject.c b/arch/arm64/lib/error-inject.c
> new file mode 100644
> index 000000000000..35661c2de4b0
> --- /dev/null
> +++ b/arch/arm64/lib/error-inject.c
> @@ -0,0 +1,19 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/error-injection.h>
> +#include <linux/kprobes.h>
> +
> +void override_function_with_return(struct pt_regs *regs)
> +{
> +	/*
> +	 * 'regs' represents the state on entry of a predefined function in
> +	 * the kernel/module and which is captured on a kprobe.
> +	 *
> +	 * 'regs->regs[30]' contains the the link register for the probed

extra "the"

> +	 * function and assign it to 'regs->pc', so when kprobe returns
> +	 * back from exception it will override the end of probed function
> +	 * and drirectly return to the predefined function's caller.

directly

> +	 */
> +	regs->pc = regs->regs[30];

I suppose we could be all fancy and do:

	instruction_pointer_set(regs, procedure_link_pointer(regs));

How about that?

Will
