Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73D049AD3C
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442892AbiAYHL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442577AbiAYHJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 02:09:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31032C0619C8;
        Mon, 24 Jan 2022 22:02:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB3F2B815AD;
        Tue, 25 Jan 2022 06:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C99C340E0;
        Tue, 25 Jan 2022 06:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643090574;
        bh=lYHCTAfuBpcW1fQv1mxPpJzytki5j6wH1OTSPUKFVR8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X+ETSgoBC0jQWUiVRbZpaZN6tRrzqVuvEwUWlBxilgPYDFrfpnuJQghWNmN3toE7v
         tA5mQXh/7m4WnjgvP/FjKWr5Rj/C/M/JbEQ+0immcsceu3+hR0IIRzCgxIUsV0fSQT
         o+yOXCexL8RsducOQhBbMIGQCmTWkIWOX7VeBhhBApdgJtZWFL6eNVuCLLjQBjS8LU
         Mb7TITx/6nrUOYTSqk+5JFbFz+2GEL7HS6ld0ZTea4miSGor8m9x+DTpoYIbbO9Q4J
         rvJz2C3kZ74y8ThllmOeEVyV+F+q8EtG7Fj4DQNWCjz5+gN3e8GGO7tbc8+StDz6Eg
         srn3D29dsq86w==
Date:   Tue, 25 Jan 2022 15:02:49 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 4/9] rethook: x86: Add rethook x86 implementation
Message-Id: <20220125150249.620fe4dc6bbefb5dcfdff816@kernel.org>
In-Reply-To: <164304060913.1680787.1167309209346264268.stgit@devnote2>
References: <164304056155.1680787.14081905648619647218.stgit@devnote2>
        <164304060913.1680787.1167309209346264268.stgit@devnote2>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 01:10:09 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Add rethook for x86 implementation. Most of the code
> has been copied from kretprobes on x86.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>  Changes in v4:
>   - fix stack backtrace as same as kretprobe does.
> ---
>  arch/x86/Kconfig              |    1 
>  arch/x86/include/asm/unwind.h |    4 +
>  arch/x86/kernel/Makefile      |    1 
>  arch/x86/kernel/rethook.c     |  115 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 121 insertions(+)
>  create mode 100644 arch/x86/kernel/rethook.c
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5c2ccb85f2ef..0a7d48a63787 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -219,6 +219,7 @@ config X86
>  	select HAVE_KPROBES_ON_FTRACE
>  	select HAVE_FUNCTION_ERROR_INJECTION
>  	select HAVE_KRETPROBES
> +	select HAVE_RETHOOK
>  	select HAVE_KVM
>  	select HAVE_LIVEPATCH			if X86_64
>  	select HAVE_MIXED_BREAKPOINTS_REGS
> diff --git a/arch/x86/include/asm/unwind.h b/arch/x86/include/asm/unwind.h
> index 2a1f8734416d..9fe5f73f22f1 100644
> --- a/arch/x86/include/asm/unwind.h
> +++ b/arch/x86/include/asm/unwind.h
> @@ -5,6 +5,7 @@
>  #include <linux/sched.h>
>  #include <linux/ftrace.h>
>  #include <linux/kprobes.h>
> +#include <linux/rethook.h>
>  #include <asm/ptrace.h>
>  #include <asm/stacktrace.h>
>  
> @@ -107,6 +108,9 @@ static inline
>  unsigned long unwind_recover_kretprobe(struct unwind_state *state,
>  				       unsigned long addr, unsigned long *addr_p)
>  {
> +	if (IS_ENABLED(CONFIG_RETHOOK) && is_rethook_trampoline(addr))
> +		return rethook_find_ret_addr(state->task, (unsigned long)addr_p,
> +					     &state->kr_cur);

Hm, I found that this doesn't work since state->kr_cur is not defined when
CONFIG_KRETPROBES=n. Even if I define it with CONFIG_RETHOOK=y, if both
CONFIG_RETHOOK and CONFIG_KRETPROBES are 'n', the compiler caused a build
error. So I decided to use #ifdef here in the next version.

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
