Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65563509393
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 01:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377311AbiDTX1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 19:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344735AbiDTX07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 19:26:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A142C1D315;
        Wed, 20 Apr 2022 16:24:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38DA861B07;
        Wed, 20 Apr 2022 23:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE565C385A1;
        Wed, 20 Apr 2022 23:24:06 +0000 (UTC)
Date:   Wed, 20 Apr 2022 19:24:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
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
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Collingbourne <pcc@google.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>
Subject: Re: [PATCH bpf-next v2 2/6] ftrace: Fix deadloop caused by direct
 call in ftrace selftest
Message-ID: <20220420192405.4e43a966@gandalf.local.home>
In-Reply-To: <20220414162220.1985095-3-xukuohai@huawei.com>
References: <20220414162220.1985095-1-xukuohai@huawei.com>
        <20220414162220.1985095-3-xukuohai@huawei.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Apr 2022 12:22:16 -0400
Xu Kuohai <xukuohai@huawei.com> wrote:

> After direct call is enabled for arm64, ftrace selftest enters a
> dead loop:
> 
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
> exits, so make trace_direct_tramp() a weak symbol and rewrite it for
> arm64.
> 
> To detect this issue directly, call DYN_FTRACE_TEST_NAME() before
> register_ftrace_graph().
> 
> Reported-by: Li Huafei <lihuafei1@huawei.com>
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> ---
>  arch/arm64/kernel/entry-ftrace.S | 10 ++++++++++
>  kernel/trace/trace_selftest.c    |  4 +++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
> index dfe62c55e3a2..e58eb06ec9b2 100644
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
> +	mov	x10, x30
> +	mov	x30, x9
> +	ret	x10
> +SYM_FUNC_END(trace_direct_tramp)
> +#endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
> +#endif /* CONFIG_FTRACE_SELFTEST */
> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index abcadbe933bb..38b0d5c9a1e0 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -785,7 +785,7 @@ static struct fgraph_ops fgraph_ops __initdata  = {
>  };
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> -noinline __noclone static void trace_direct_tramp(void) { }
> +void __weak trace_direct_tramp(void) { }
>  #endif
>  
>  /*


> @@ -868,6 +868,8 @@ trace_selftest_startup_function_graph(struct tracer *trace,
>  	if (ret)
>  		goto out;
>  
> +	DYN_FTRACE_TEST_NAME();

This doesn't look like it belongs in this patch.

-- Steve

> +
>  	ret = register_ftrace_graph(&fgraph_ops);
>  	if (ret) {
>  		warn_failed_init_tracer(trace, ret);

