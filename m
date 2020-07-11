Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF3721C1DB
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 05:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgGKDUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 23:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgGKDUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 23:20:43 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CF8C08C5DC;
        Fri, 10 Jul 2020 20:20:43 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id d21so4258100lfb.6;
        Fri, 10 Jul 2020 20:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yNnhoOlC+rFp5S2PXytvDIfd1ZquWf26R//5lR2c/cE=;
        b=iFqfA2xBtv6HZ7wwonTGMUSSr4tKw82dLV1DCf3ktcMSwNsKWUDPbtwnW8RFc4cMuD
         rynaq3z0iVgF/xuriLR5sZP07rOCIsflCu432+CZCRLUtpBTl2eyOkl/RqqqU9YjpMd+
         ssYaF0phw5XnctQw85aNcSU7shiYwye7cGSCjscDUvciG6ou7WilTb5jgMoL3mPtjXXK
         NvOKznVcvmbrOjlKHyoiO7l9qAS64YpHiKnOnOHrbnduRUX36HrSA6G8+jGH8mbsASBg
         t6nzJRslABrWuio7HNzz2LzgCBNtu1bidH+Re0RUFRaJgPH4GU2sEe/gT5cF8iDdilGo
         eNUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yNnhoOlC+rFp5S2PXytvDIfd1ZquWf26R//5lR2c/cE=;
        b=aMep27mcyqQ85iCIw4lH14QXT3d1rXHzaQaaWY/0RYEQbqgUpzJRVOGe3NWlxv7oV3
         LhEavGczDzk/bG8mVC7kGWSrVNvsAOnVp/tgSzsgHNlsD36KRmsFGPiM/I5NLz630CEF
         P08ODdexvQ+ucPeKEUWbEGFRhOVf1D6/2TbaDmxamfXmETumtk6UurW4v9s7QN5exczN
         4HNTXzZL6YNlcR0y6Oq7PnMIVRaRiwpi8zux0cMlcwIf1eFf30n5+dpcAYZT+Y8t8u69
         2M4PYBEHUL0W5qHmHh2Uf33wMBpNI3eRiD8en0j/axVAHewRMGTqe8779lxMrZcnNkVq
         MBEg==
X-Gm-Message-State: AOAM532n+eq0oBEACysSClrL+JSaNezprHyrMJ5uVy1sx3rxKOlw3M29
        7fQGbI1QydQCqV2CSDPr4SJxfylrrDfWO0TWEow=
X-Google-Smtp-Source: ABdhPJwGf4j3gAhloQa+b/nVvHF6KDy4oRzXN6+4gc0SV7UlQJHxKhMa24pS4BRfWhNtM8jGuxb3OG521QbJ4wZHR9E=
X-Received: by 2002:a05:6512:54d:: with SMTP id h13mr45475820lfl.8.1594437641424;
 Fri, 10 Jul 2020 20:20:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200702134930.4717-1-maciej.fijalkowski@intel.com>
 <20200702134930.4717-5-maciej.fijalkowski@intel.com> <20200710235632.lhn6edwf4a2l3kiz@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200710235632.lhn6edwf4a2l3kiz@ast-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Jul 2020 20:20:29 -0700
Message-ID: <CAADnVQJhhQnjQdrQgMCsx2EDDwELkCvY7Zpfdi_SJUmH6VzZYw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 4/5] bpf, x64: rework pro/epilogue and
 tailcall handling in JIT
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 4:56 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jul 02, 2020 at 03:49:29PM +0200, Maciej Fijalkowski wrote:
> > This commit serves two things:
> > 1) it optimizes BPF prologue/epilogue generation
> > 2) it makes possible to have tailcalls within BPF subprogram
> >
> > Both points are related to each other since without 1), 2) could not be
> > achieved.
> >
> > In [1], Alexei says:
> > "The prologue will look like:
> > nop5
> > xor eax,eax  // two new bytes if bpf_tail_call() is used in this
> >              // function
> > push rbp
> > mov rbp, rsp
> > sub rsp, rounded_stack_depth
> > push rax // zero init tail_call counter
> > variable number of push rbx,r13,r14,r15
> >
> > Then bpf_tail_call will pop variable number rbx,..
> > and final 'pop rax'
> > Then 'add rsp, size_of_current_stack_frame'
> > jmp to next function and skip over 'nop5; xor eax,eax; push rpb; mov
> > rbp, rsp'
> >
> > This way new function will set its own stack size and will init tail
> > call
> > counter with whatever value the parent had.
> >
> > If next function doesn't use bpf_tail_call it won't have 'xor eax,eax'.
> > Instead it would need to have 'nop2' in there."
> >
> > Implement that suggestion.
> >
> > Since the layout of stack is changed, tail call counter handling can not
> > rely anymore on popping it to rbx just like it have been handled for
> > constant prologue case and later overwrite of rbx with actual value of
> > rbx pushed to stack. Therefore, let's use one of the register (%rcx) that
> > is considered to be volatile/caller-saved and pop the value of tail call
> > counter in there in the epilogue.
> >
> > Drop the BUILD_BUG_ON in emit_prologue and in
> > emit_bpf_tail_call_indirect where instruction layout is not constant
> > anymore.
> >
> > Introduce new poke target, 'ip_aux' to poke descriptor that is dedicated
>
> imo ip_aux approach has too much x86 specific code in kernel/bpf/arraymap.c
> Ex. NOP_ATOMIC5 is x86 only and will break build on all other archs.
>
> But I'm not sure ip_aux is really necessary.
> It's nice to optimize the case when tail_call target is NULL, but
> redundant unwind + nop5 + push_regs_again makes for much simpler design
> without worrying about state transitions.
>
> So I don't think optimizing the case of target==NULL is really worth the complexity.
>
> > for skipping the register pops and stack unwind that are generated right
> > before the actual jump to target program.
> > For case when the target program is not present, BPF program will skip
> > the pop instructions and nop5 dedicated for jmpq $target. An example of
> > such state when only R6 of callee saved registers is used by program:
> >
> > ffffffffc0513aa1:       e9 0e 00 00 00          jmpq   0xffffffffc0513ab4
> > ffffffffc0513aa6:       5b                      pop    %rbx
> > ffffffffc0513aa7:       58                      pop    %rax
> > ffffffffc0513aa8:       48 81 c4 00 00 00 00    add    $0x0,%rsp
> > ffffffffc0513aaf:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> > ffffffffc0513ab4:       48 89 df                mov    %rbx,%rdi
>
> so this last rbx->rdi insn is not part of bpf_tail_call insn, right?
> That is just 'R1 = R6;' bpf insn jited.
>
> >
> > When target program is inserted, the jump that was there to skip
> > pops/nop5 will become the nop5, so CPU will go over pops and do the
> > actual tailcall.
> >
> > One might ask why there simply can not be pushes after the nop5?
>
> exactly... and...
>
> > In the following example snippet:
> >
> > ffffffffc037030c:       48 89 fb                mov    %rdi,%rbx
> > (...)
> > ffffffffc0370332:       5b                      pop    %rbx
> > ffffffffc0370333:       58                      pop    %rax
> > ffffffffc0370334:       48 81 c4 00 00 00 00    add    $0x0,%rsp
> > ffffffffc037033b:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> > ffffffffc0370340:       48 81 ec 00 00 00 00    sub    $0x0,%rsp
> > ffffffffc0370347:       50                      push   %rax
> > ffffffffc0370348:       53                      push   %rbx
> > ffffffffc0370349:       48 89 df                mov    %rbx,%rdi
> > ffffffffc037034c:       e8 f7 21 00 00          callq  0xffffffffc0372548
> >
> > There is the bpf2bpf call right after the tailcall and jump target is
> > not present. ctx is %rbx and BPF subprogram that we will call into on
> > ffffffffc037034c is relying on it, e.g. it will pick ctx from there.
> > Such code layout is therefore broken as we would overwrite the content
> > of %rbx with the value that was pushed on the prologue.
>
> I don't understand above explanation.
> Are you saying 'callq  0xffffffffc0372548' above is a call to bpf subprogram?
> The 'mov %rbx,%rdi' was 'R1 = R6' before JIT.
> The code is storing ctx into R1 to pass into bpf subprogram.
> It's not part of proposed emit_bpf_tail_call_direct() handling.
> It's part of BPF program.
> I don't see what breaks.
>
> The new emit_bpf_tail_call_indirect() looks correct to me.
>
> But emit_bpf_tail_call_direct() doesn't need
> + emit_jump(&prog, (u8 *)poke->ip + X86_PATCH_SIZE, poke->ip_aux);
> and messy poke->ip_aux.
>
> It can do:
> pop_callee_regs()
> memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
> push_callee_regs()
>
> When target is NULL the pairs of pop/push overall is a nop.
> They don't affect correctness.
> When prog_array_map_poke_run() is called it will replace a nop5
> with a jump. So still all good.
>
> Yes there will be tiny overhead when tail_call target is NULL,
> but x86 will execute pop/push pair in _one_ cpu cycle.
> As far as I recall x86 hardware has special logic to recognize
> such push/pop sequences so they are really fast.
>
> What am I missing?

Of course you are right.
pop+nop+push is incorrect.

How about the following instead:
- during JIT:
emit_jump(to_skip_below)  <- poke->tailcall_bypass
pop_callee_regs
emit_jump(to_tailcall_target) <- poke->tailcall_target

- Transition from one target to another:
text_poke(poke->tailcall_target, MOD_JMP, old_jmp, new_jmp)
if (new_jmp != NULL)
  text_poke(poke->tailcall_bypass, MOD jmp into nop);
else
  text_poke(poke->tailcall_bypass, MOD nop into jmp);

In other words, let's keep jmp as always valid, so the race
you've described in the cover letter won't ever happen.

The kernel/bpf/arraymap.c will stay arch independent too.

Thoughts?
