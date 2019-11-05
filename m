Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7428AF064B
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 20:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfKETvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 14:51:48 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44439 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfKETvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 14:51:47 -0500
Received: by mail-qk1-f195.google.com with SMTP id m16so21995810qki.11;
        Tue, 05 Nov 2019 11:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OJMmTu/o7IxYfO7udzJCeswUDWPqRc2N4ga4xPOFpjw=;
        b=TrzyKGJrK+mYAuaddUVlJ9e6CCtsGICv9mKMPmSeGd7A/eGecgduOlZt/WnKa0YNAh
         6S/mj+bpAHOUCgTc3i5/WmoUIPF0kRfWSQ7789TQwb+CuHrE0jdCChDSK1v6GuYxbrKu
         vK2pH1eMUfITATG9R5KGc8NHqhwEc9n6xrGD1xo9XFV6OXm40ro44fXPzYS6TZ9xnArh
         gzg3HHwwtei251BU4+hoejL5y/LgUpKSpBrdj39I9y8YkEHbWOiBKVd38FVHY7o05i08
         bCazQ//y2gK2JwiKDNhZ1B7AiMg4HQP6oA3hA9cT6ZPN5+ATEFhGYkGc12CfN0SeWz56
         kU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OJMmTu/o7IxYfO7udzJCeswUDWPqRc2N4ga4xPOFpjw=;
        b=LsM4WIdwvInn75+A2TAVYMAHBUA2k/Jx+pBbYegIh+UOKQhI6PCIBsBKcW7+awOt7U
         3MHuz36mbp2KCG/rxqryb7CBXlWGclZUc5M0y41lr03l2bnSsH6HsM2/WaSusAdB7H15
         qlqWfbEOGMyPhYSmGiqrAwVIsOkMpEZklFY1eda5gWqQzhQ52qbKY5zIjOO+SjpyzWm7
         0iTAzG7n1s0NGOoVKRsGSsfF1uK9FbcP6X7mrHmuSe46X6z0q3qVvqoCsvF0yHzuFth1
         lSGxsVlFbxj3UPk7J8Na1z3tIg1ySj0ugD3lWDZgMUKlZou1Gf/inIDPGufKdYtdoG7w
         p80Q==
X-Gm-Message-State: APjAAAXmlHlM4dVjEorJF3avEMUZuhaM5ieUwY0netVzhqhJTRCeaaIx
        AEvYZKt/rLCIbMIuWENuYxad7Re+a5zSVWxR89o=
X-Google-Smtp-Source: APXvYqyjzDMZGI5InHSlK5B8kmiQUntDEfugQeFWcjZFyp4cRsbeBWUAnAXlxLTO8LGDiufEu1MpmPcwoFr8puRHme4=
X-Received: by 2002:a37:b3c4:: with SMTP id c187mr2821262qkf.36.1572983506016;
 Tue, 05 Nov 2019 11:51:46 -0800 (PST)
MIME-Version: 1.0
References: <20191102220025.2475981-1-ast@kernel.org> <20191102220025.2475981-4-ast@kernel.org>
In-Reply-To: <20191102220025.2475981-4-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Nov 2019 11:51:34 -0800
Message-ID: <CAEf4BzanGJGy7CtxG5we1w6f00arbZ+csjNc9yTNtXBM26_9Vg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Introduce BPF trampoline
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 2, 2019 at 3:01 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Introduce BPF trampoline concept to allow kernel code to call into BPF programs
> with practically zero overhead.  The trampoline generation logic is
> architecture dependent.  It's converting native calling convention into BPF
> calling convention.  BPF ISA is 64-bit (even on 32-bit architectures). The
> registers R1 to R5 are used to pass arguments into BPF functions. The main BPF
> program accepts only single argument "ctx" in R1. Whereas CPU native calling
> convention is different. x86-64 is passing first 6 arguments in registers
> and the rest on the stack. x86-32 is passing first 3 arguments in registers.
> sparc64 is passing first 6 in registers. And so on.
>
> The trampolines between BPF and kernel already exist.  BPF_CALL_x macros in
> include/linux/filter.h statically compile trampolines from BPF into kernel
> helpers. They convert up to five u64 arguments into kernel C pointers and
> integers. On 64-bit architectures this BPF_to_kernel trampolines are nops. On
> 32-bit architecture they're meaningful.
>
> The opposite job kernel_to_BPF trampolines is done by CAST_TO_U64 macros and
> __bpf_trace_##call() shim functions in include/trace/bpf_probe.h. They convert
> kernel function arguments into array of u64s that BPF program consumes via
> R1=ctx pointer.
>
> This patch set is doing the same job as __bpf_trace_##call() static
> trampolines, but dynamically for any kernel function. There are ~22k global
> kernel functions that are attachable via ftrace. The function arguments and
> types are described in BTF.  The job of btf_distill_kernel_func() function is
> to extract useful information from BTF into "function model" that architecture
> dependent trampoline generators will use to generate assembly code to cast
> kernel function arguments into array of u64s.  For example the kernel function
> eth_type_trans has two pointers. They will be casted to u64 and stored into
> stack of generated trampoline. The pointer to that stack space will be passed
> into BPF program in R1. On x86-64 such generated trampoline will consume 16
> bytes of stack and two stores of %rdi and %rsi into stack. The verifier will
> make sure that only two u64 are accessed read-only by BPF program. The verifier
> will also recognize the precise type of the pointers being accessed and will
> not allow typecasting of the pointer to a different type within BPF program.
>
> The tracing use case in the datacenter demonstrated that certain key kernel
> functions have (like tcp_retransmit_skb) have 2 or more kprobes that are always
> active.  Other functions have both kprobe and kretprobe.  So it is essential to
> keep both kernel code and BPF programs executing at maximum speed. Hence
> generated BPF trampoline is re-generated every time new program is attached or
> detached to maintain maximum performance.
>
> To avoid the high cost of retpoline the attached BPF programs are called
> directly. __bpf_prog_enter/exit() are used to support per-program execution
> stats.  In the future this logic will be optimized further by adding support
> for bpf_stats_enabled_key inside generated assembly code. Introduction of
> preemptible and sleepable BPF programs will completely remove the need to call
> to __bpf_prog_enter/exit().
>
> Detach of a BPF program from the trampoline should not fail. To avoid memory
> allocation in detach path the half of the page is used as a reserve and flipped
> after each attach/detach. 2k bytes is enough to call 40+ BPF programs directly
> which is enough for BPF tracing use cases. This limit can be increased in the
> future.
>
> BPF_TRACE_FENTRY programs have access to raw kernel function arguments while
> BPF_TRACE_FEXIT programs have access to kernel return value as well. Often
> kprobe BPF program remembers function arguments in a map while kretprobe
> fetches arguments from a map and analyzes them together with return value.
> BPF_TRACE_FEXIT accelerates this typical use case.
>
> Recursion prevention for kprobe BPF programs is done via per-cpu
> bpf_prog_active counter. In practice that turned out to be a mistake. It
> caused programs to randomly skip execution. The tracing tools missed results
> they were looking for. Hence BPF trampoline doesn't provide builtin recursion
> prevention. It's a job of BPF program itself and will be addressed in the
> follow up patches.
>
> BPF trampoline is intended to be used beyond tracing and fentry/fexit use cases
> in the future. For example to remove retpoline cost from XDP programs.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>
