Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DD150E3FA
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242728AbiDYPI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242719AbiDYPIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:08:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E955F1FCF3;
        Mon, 25 Apr 2022 08:05:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A19C6B8160D;
        Mon, 25 Apr 2022 15:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65958C385A4;
        Mon, 25 Apr 2022 15:05:14 +0000 (UTC)
Date:   Mon, 25 Apr 2022 11:05:12 -0400
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
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
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
Subject: Re: [PATCH bpf-next v3 2/7] ftrace: Fix deadloop caused by direct
 call in ftrace selftest
Message-ID: <20220425110512.538ce0bf@gandalf.local.home>
In-Reply-To: <20220424154028.1698685-3-xukuohai@huawei.com>
References: <20220424154028.1698685-1-xukuohai@huawei.com>
        <20220424154028.1698685-3-xukuohai@huawei.com>
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

On Sun, 24 Apr 2022 11:40:23 -0400
Xu Kuohai <xukuohai@huawei.com> wrote:

> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index abcadbe933bb..d2eff2b1d743 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -785,8 +785,24 @@ static struct fgraph_ops fgraph_ops __initdata  = {
>  };
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +#ifdef CONFIG_ARM64

Please find a way to add this in arm specific code. Do not add architecture
defines in generic code.

You could add:

#ifndef ARCH_HAVE_FTRACE_DIRECT_TEST_FUNC
noinline __noclone static void trace_direct_tramp(void) { }
#endif

here, and in arch/arm64/include/ftrace.h

#define ARCH_HAVE_FTRACE_DIRECT_TEST_FUNC

and define your test function in the arm64 specific code.

-- Steve




> +extern void trace_direct_tramp(void);
> +
> +asm (
> +"	.pushsection	.text, \"ax\", @progbits\n"
> +"	.type		trace_direct_tramp, %function\n"
> +"	.global		trace_direct_tramp\n"
> +"trace_direct_tramp:"
> +"	mov	x10, x30\n"
> +"	mov	x30, x9\n"
> +"	ret	x10\n"
> +"	.size		trace_direct_tramp, .-trace_direct_tramp\n"
> +"	.popsection\n"
> +);
> +#else
>  noinline __noclone static void trace_direct_tramp(void) { }
>  #endif
> +#endif
>  
>  /*
>   * Pretty much the same than for the function tracer from which the selftest

