Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE09843C8DB
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 13:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241727AbhJ0LxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 07:53:22 -0400
Received: from foss.arm.com ([217.140.110.172]:42440 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240073AbhJ0LxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 07:53:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9AD31FB;
        Wed, 27 Oct 2021 04:50:51 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.72.240])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51AF43F73D;
        Wed, 27 Oct 2021 04:50:47 -0700 (PDT)
Date:   Wed, 27 Oct 2021 12:50:43 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Tong Tiangen <tongtiangen@huawei.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next,v3] riscv, bpf: Add BPF exception tables
Message-ID: <20211027115043.GB54628@C02TD0UTHF1T.local>
References: <20211027111822.3801679-1-tongtiangen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027111822.3801679-1-tongtiangen@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 11:18:22AM +0000, Tong Tiangen wrote:
> When a tracing BPF program attempts to read memory without using the
> bpf_probe_read() helper, the verifier marks the load instruction with
> the BPF_PROBE_MEM flag. Since the riscv JIT does not currently recognize
> this flag it falls back to the interpreter.
> 
> Add support for BPF_PROBE_MEM, by appending an exception table to the
> BPF program. If the load instruction causes a data abort, the fixup
> infrastructure finds the exception table and fixes up the fault, by
> clearing the destination register and jumping over the faulting
> instruction.
> 
> A more generic solution would add a "handler" field to the table entry,
> like on x86 and s390.
> 
> The same issue in ARM64 is fixed in:
> commit 800834285361 ("bpf, arm64: Add BPF exception tables")

> +#ifdef CONFIG_BPF_JIT
> +int rv_bpf_fixup_exception(const struct exception_table_entry *ex, struct pt_regs *regs);
> +#endif
> +
>  int fixup_exception(struct pt_regs *regs)
>  {
>  	const struct exception_table_entry *fixup;
>  
>  	fixup = search_exception_tables(regs->epc);
> -	if (fixup) {
> -		regs->epc = fixup->fixup;
> -		return 1;
> -	}
> -	return 0;
> +	if (!fixup)
> +		return 0;
> +
> +#ifdef CONFIG_BPF_JIT
> +	if (regs->epc >= BPF_JIT_REGION_START && regs->epc < BPF_JIT_REGION_END)
> +		return rv_bpf_fixup_exception(fixup, regs);
> +#endif
> +
> +	regs->epc = fixup->fixup;
> +	return 1;
>  }

As a heads-up, on the extable front, both arm64 and x86 are moving to
having an enumerated "type" field to select the handler:

x86:

  https://lore.kernel.org/lkml/20210908132525.211958725@linutronix.de/

arm64:

  https://lore.kernel.org/linux-arm-kernel/20211019160219.5202-11-mark.rutland@arm.com/

... and going forwards, riscv might want to do likewise.

Thanks,
Mark.
