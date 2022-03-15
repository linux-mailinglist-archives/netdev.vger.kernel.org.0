Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7508D4D9868
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 11:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346964AbiCOKKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 06:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346967AbiCOKKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 06:10:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E783AA4F;
        Tue, 15 Mar 2022 03:08:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EDECB811F5;
        Tue, 15 Mar 2022 10:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D348C340ED;
        Tue, 15 Mar 2022 10:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647338935;
        bh=lxm00edtpi4RNpe+KpYSEsp9DryXournPvBPfHZkDbs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KgM3jzk7pJpT27wth91xf1pluNMZZ9jgxdtCX7VqlZ8Exa/euL0490cSGWMUzNyKI
         feytnWZACE/JXw8UJtTURfUpS0oyAkjflalkXraP3u0Iior9/1+TQPyvtxHpzeqI7f
         nn0DCLsUlkdLEyy5S1yLSPKD9zNfyaFZhl3ga/ylqKzNAnNYH2a2GQz5zC7Onkn9cU
         e4WnBvGR7QUXPHhrmCX/D5a3hLb2pOQYzxsZvsYS0LuFVfiAdxYM3pcoC+kdgBlpsT
         318usooFXgjgA+MGkwA+2AyGfk2YvDfj0jT1pzm9xKuH70EhWOQ7gx6/7cUDcAPzYE
         HgNvtCYUMSEnA==
Date:   Tue, 15 Mar 2022 19:08:48 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Subject: Re: [PATCH v11 07/12] ARM: rethook: Add rethook arm implementation
Message-Id: <20220315190848.a28a889802b71820650f5478@kernel.org>
In-Reply-To: <164701440314.268462.2664594020245236625.stgit@devnote2>
References: <164701432038.268462.3329725152949938527.stgit@devnote2>
        <164701440314.268462.2664594020245236625.stgit@devnote2>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Mar 2022 01:00:03 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> +void __naked arch_rethook_trampoline(void)
> +{
> +	__asm__ __volatile__ (
> +#ifdef CONFIG_FRAME_POINTER
> +		"ldr	lr, =arch_rethook_trampoline	\n\t"

Oops, this must have the same issue reported by 0day build bot recently[1].

[1] https://lore.kernel.org/all/202203150516.KTorSVVU-lkp@intel.com/T/#u

I'll update this series with same fix.

Thank you,

> +	/* this makes a framepointer on pt_regs. */
> +#ifdef CONFIG_CC_IS_CLANG
> +		"stmdb	sp, {sp, lr, pc}	\n\t"
> +		"sub	sp, sp, #12		\n\t"
> +		/* In clang case, pt_regs->ip = lr. */
> +		"stmdb	sp!, {r0 - r11, lr}	\n\t"
> +		/* fp points regs->r11 (fp) */
> +		"add	fp, sp,	#44		\n\t"
> +#else /* !CONFIG_CC_IS_CLANG */
> +		/* In gcc case, pt_regs->ip = fp. */
> +		"stmdb	sp, {fp, sp, lr, pc}	\n\t"
> +		"sub	sp, sp, #16		\n\t"
> +		"stmdb	sp!, {r0 - r11}		\n\t"
> +		/* fp points regs->r15 (pc) */
> +		"add	fp, sp, #60		\n\t"
> +#endif /* CONFIG_CC_IS_CLANG */
> +#else /* !CONFIG_FRAME_POINTER */
> +		"sub	sp, sp, #16		\n\t"
> +		"stmdb	sp!, {r0 - r11}		\n\t"
> +#endif /* CONFIG_FRAME_POINTER */
> +		"mov	r0, sp			\n\t"
> +		"bl	arch_rethook_trampoline_callback	\n\t"
> +		"mov	lr, r0			\n\t"
> +		"ldmia	sp!, {r0 - r11}		\n\t"
> +		"add	sp, sp, #16		\n\t"
> +#ifdef CONFIG_THUMB2_KERNEL
> +		"bx	lr			\n\t"
> +#else
> +		"mov	pc, lr			\n\t"
> +#endif
> +		: : : "memory");
> +}
> +NOKPROBE_SYMBOL(arch_rethook_trampoline);
> +
> +/*
> + * At the entry of function with mcount. The stack and registers are prepared
> + * for the mcount function as below.
> + *
> + * mov     ip, sp
> + * push    {fp, ip, lr, pc}
> + * sub     fp, ip, #4	; FP[0] = PC, FP[-4] = LR, and FP[-12] = call-site FP.
> + * push    {lr}
> + * bl      <__gnu_mcount_nc> ; call ftrace
> + *
> + * And when returning from the function, call-site FP, SP and PC are restored
> + * from stack as below;
> + *
> + * ldm     sp, {fp, sp, pc}
> + *
> + * Thus, if the arch_rethook_prepare() is called from real function entry,
> + * it must change the LR and save FP in pt_regs. But if it is called via
> + * mcount context (ftrace), it must change the LR on stack, which is next
> + * to the PC (= FP[-4]), and save the FP value at FP[-12].
> + */
> +void arch_rethook_prepare(struct rethook_node *rh, struct pt_regs *regs, bool mcount)
> +{
> +	unsigned long *ret_addr, *frame;
> +
> +	if (mcount) {
> +		ret_addr = (unsigned long *)(regs->ARM_fp - 4);
> +		frame = (unsigned long *)(regs->ARM_fp - 12);
> +	} else {
> +		ret_addr = &regs->ARM_lr;
> +		frame = &regs->ARM_fp;
> +	}
> +
> +	rh->ret_addr = *ret_addr;
> +	rh->frame = *frame;
> +
> +	/* Replace the return addr with trampoline addr. */
> +	*ret_addr = (unsigned long)arch_rethook_trampoline;
> +}
> +NOKPROBE_SYMBOL(arch_rethook_prepare);
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
