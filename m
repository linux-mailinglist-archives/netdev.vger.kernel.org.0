Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27C83611F4
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 20:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhDOSS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 14:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233052AbhDOSS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 14:18:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BB0B610EA;
        Thu, 15 Apr 2021 18:18:32 +0000 (UTC)
Date:   Thu, 15 Apr 2021 14:18:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <20210415141831.7b8fbe72@gandalf.local.home>
In-Reply-To: <YHh6YeOPh0HIlb3e@krava>
References: <20210413121516.1467989-1-jolsa@kernel.org>
        <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
        <YHbd2CmeoaiLJj7X@krava>
        <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
        <20210415111002.324b6bfa@gandalf.local.home>
        <YHh6YeOPh0HIlb3e@krava>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 19:39:45 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> > I don't know how the BPF code does it, but if you are tracing the exit
> > of a function, I'm assuming that you hijack the return pointer and replace
> > it with a call to a trampoline that has access to the arguments. To do  
> 
> hi,
> it's bit different, the trampoline makes use of the fact that the
> call to trampoline is at the very begining of the function and, so
> it can call the origin function with 'call function + 5' instr.
> 
> so in nutshell the trampoline does:
> 
>   call entry_progs
>   call original_func+5

How does the above handle functions that have parameters on the stack?

>   call exit_progs
> 
> you can check this in arch/x86/net/bpf_jit_comp.c in moe detail:
> 
>  * The assembly code when eth_type_trans is called from trampoline:
>  *
>  * push rbp
>  * mov rbp, rsp
>  * sub rsp, 24                     // space for skb, dev, return value
>  * push rbx                        // temp regs to pass start time
>  * mov qword ptr [rbp - 24], rdi   // save skb pointer to stack
>  * mov qword ptr [rbp - 16], rsi   // save dev pointer to stack
>  * call __bpf_prog_enter           // rcu_read_lock and preempt_disable
>  * mov rbx, rax                    // remember start time if bpf stats are enabled
>  * lea rdi, [rbp - 24]             // R1==ctx of bpf prog
>  * call addr_of_jited_FENTRY_prog  // bpf prog can access skb and dev
> 
> entry program called ^^^
> 
>  * movabsq rdi, 64bit_addr_of_struct_bpf_prog  // unused if bpf stats are off
>  * mov rsi, rbx                    // prog start time
>  * call __bpf_prog_exit            // rcu_read_unlock, preempt_enable and stats math
>  * mov rdi, qword ptr [rbp - 24]   // restore skb pointer from stack
>  * mov rsi, qword ptr [rbp - 16]   // restore dev pointer from stack
>  * call eth_type_trans+5           // execute body of eth_type_trans
> 
> original function called ^^^

This would need to be limited to only functions that do not have any
parameters on the stack.

> 
>  * mov qword ptr [rbp - 8], rax    // save return value
>  * call __bpf_prog_enter           // rcu_read_lock and preempt_disable
>  * mov rbx, rax                    // remember start time in bpf stats are enabled
>  * lea rdi, [rbp - 24]             // R1==ctx of bpf prog
>  * call addr_of_jited_FEXIT_prog   // bpf prog can access skb, dev, return value
> 
> exit program called ^^^
> 
>  * movabsq rdi, 64bit_addr_of_struct_bpf_prog  // unused if bpf stats are off
>  * mov rsi, rbx                    // prog start time
>  * call __bpf_prog_exit            // rcu_read_unlock, preempt_enable and stats math
>  * mov rax, qword ptr [rbp - 8]    // restore eth_type_trans's return value
>  * pop rbx
>  * leave
>  * add rsp, 8                      // skip eth_type_trans's frame
>  * ret                             // return to its caller
> 
> > this you need a shadow stack to save the real return as well as the
> > parameters of the function. This is something that I have patches that do
> > similar things with function graph.
> > 
> > If you want this feature, lets work together and make this work for both
> > BPF and ftrace.  
> 
> it's been some time I saw a graph tracer, is there a way to make it
> access input arguments and make it available through ftrace_ops
> interface?

I have patches that could easily make it do so. And should probably get
them out again. The function graph tracer has a shadow stack, and my
patches allow you to store data on it for use with the exiting of the
program.

My last release of that code is here:

  https://lore.kernel.org/lkml/20190525031633.811342628@goodmis.org/

It allows you to "reserve data" to pass from the caller to the return, and
that could hold the arguments. See patch 15 of that series.


-- Steve

