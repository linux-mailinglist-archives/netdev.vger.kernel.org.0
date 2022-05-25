Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D40533E23
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 15:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240693AbiEYNoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 09:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbiEYNoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 09:44:12 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB8A160D86;
        Wed, 25 May 2022 06:44:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51AD723A;
        Wed, 25 May 2022 06:44:11 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.0.228])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77FAD3F66F;
        Wed, 25 May 2022 06:44:03 -0700 (PDT)
Date:   Wed, 25 May 2022 14:43:55 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        hpa@zytor.com, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next v5 2/6] ftrace: Fix deadloop caused by direct
 call in ftrace selftest
Message-ID: <Yo4ymwu92gM75/Z5@FVFF77S0Q05N>
References: <20220518131638.3401509-1-xukuohai@huawei.com>
 <20220518131638.3401509-3-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518131638.3401509-3-xukuohai@huawei.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 09:16:34AM -0400, Xu Kuohai wrote:
> After direct call is enabled for arm64, ftrace selftest enters a
> dead loop:

IIUC this means that patch 1 alone is broken, and presumably this patch should
have been part of it?

> <trace_selftest_dynamic_test_func>:
> 00  bti     c
> 01  mov     x9, x30                            <trace_direct_tramp>:
> 02  bl      <trace_direct_tramp>    ---------->     ret
>                                                      |
>                                          lr/x30 is 03, return to 03
>                                                      |
> 03  mov     w0, #0x0   <-----------------------------|
>      |                                               |
>      |                   dead loop!                  |
>      |                                               |
> 04  ret   ---- lr/x30 is still 03, go back to 03 ----|
> 
> The reason is that when the direct caller trace_direct_tramp() returns
> to the patched function trace_selftest_dynamic_test_func(), lr is still
> the address after the instrumented instruction in the patched function,
> so when the patched function exits, it returns to itself!
> 
> To fix this issue, we need to restore lr before trace_direct_tramp()
> exits, so rewrite a dedicated trace_direct_tramp() for arm64.

As mentioned on patch 1 I'd prefer we solved this through indirection, which
would avoid the need for this and would make things more robust generally by
keeping the unusual calling convention private to the patch-site and regular
trampoline.

Thanks,
Mark.

> Reported-by: Li Huafei <lihuafei1@huawei.com>
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> ---
>  arch/arm64/include/asm/ftrace.h  | 10 ++++++++++
>  arch/arm64/kernel/entry-ftrace.S | 10 ++++++++++
>  kernel/trace/trace_selftest.c    |  2 ++
>  3 files changed, 22 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
> index 14a35a5df0a1..6f6b184e72fb 100644
> --- a/arch/arm64/include/asm/ftrace.h
> +++ b/arch/arm64/include/asm/ftrace.h
> @@ -126,6 +126,16 @@ static inline bool arch_syscall_match_sym_name(const char *sym,
>  	 */
>  	return !strcmp(sym + 8, name);
>  }
> +
> +#ifdef CONFIG_FTRACE_SELFTEST
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +
> +#define trace_direct_tramp trace_direct_tramp
> +extern void trace_direct_tramp(void);
> +
> +#endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
> +#endif /* CONFIG_FTRACE_SELFTEST */
> +
>  #endif /* ifndef __ASSEMBLY__ */
>  
>  #endif /* __ASM_FTRACE_H */
> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
> index dfe62c55e3a2..a47e87d4d3dd 100644
> --- a/arch/arm64/kernel/entry-ftrace.S
> +++ b/arch/arm64/kernel/entry-ftrace.S
> @@ -357,3 +357,13 @@ SYM_CODE_START(return_to_handler)
>  	ret
>  SYM_CODE_END(return_to_handler)
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> +
> +#ifdef CONFIG_FTRACE_SELFTEST
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +SYM_FUNC_START(trace_direct_tramp)
> +	mov x10, x30
> +	mov x30, x9
> +	ret x10
> +SYM_FUNC_END(trace_direct_tramp)
> +#endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
> +#endif /* CONFIG_FTRACE_SELFTEST */
> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index abcadbe933bb..e7ccd0d10c39 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -785,8 +785,10 @@ static struct fgraph_ops fgraph_ops __initdata  = {
>  };
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +#ifndef trace_direct_tramp
>  noinline __noclone static void trace_direct_tramp(void) { }
>  #endif
> +#endif
>  
>  /*
>   * Pretty much the same than for the function tracer from which the selftest
> -- 
> 2.30.2
> 
