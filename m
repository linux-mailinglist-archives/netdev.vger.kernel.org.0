Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB7ED16EF
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 19:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731979AbfJIRin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 13:38:43 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40636 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731865AbfJIRin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 13:38:43 -0400
Received: by mail-qt1-f194.google.com with SMTP id m61so4574985qte.7;
        Wed, 09 Oct 2019 10:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ORCUuaAnXYK7O+f/tcYTKvF5XMinMX79VBovv6KzD9o=;
        b=AxgDA9Gj1nt0/Jbno2lRBiJBIy22ulXwQs92MHIzV7c0nWVitRTUJRx1vmabfWIYtJ
         eTBWgd/gLTL9TwKbjwKukl/skHVVabASFVm3M/L/uZrqgdRBOTtbaEzws3I1fbvFZ6JZ
         I5WuCgdJd/+w7wktfU1aDephR5rb+GfMOyGVo11RwFDiM8l0YRynEm5QzWdcL6q4zj9L
         J0ZFAuIsuuBSOw3nxuPOXFofeaiZkHjB/aeDE7m8+J5nLIOF7pxw9/Z5kq2p3qzLTOa0
         DdlowEENt+pnAqDLHIAV6Kp5d8doTe3ubwiUL5Nau1NcU5o0Xh53/+bu5PEIQg2aIoPZ
         JeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ORCUuaAnXYK7O+f/tcYTKvF5XMinMX79VBovv6KzD9o=;
        b=MtXyINUSOIa2JgRCRy6ggffVY8qIaKN3cpfhKN9Igay/dr88IaRAI21+BaDiy0x6o0
         Jn1hEYnVeo8KRo1nvKOPBg0xzf+o2gsG/Qd38JJVH9cHgXD28BpkxY3jVCXaNzcDqxbU
         t4vgVY//NWWO4ieSJyAS4vhY8eVKzDHpzS5ezLFx0a5Ri6oY1o58o35miYqtnlA48FvQ
         bWRA5x6ZTRqUatU14SxWXjZHA4uBLZpZph/YcdvhCnqTAWcAY4VJIVS0qxJqjVGF8NPp
         N1lKfqSe94w3MNll0+TlzcSyvV6PX/SR/U7g0qdaTxdS3Kf/Bn0km+B6k3p1OI+aqJbN
         SjEQ==
X-Gm-Message-State: APjAAAW6G0OE2JfowUmq8gEb+163/gZVIh9B3r639rSLUrXP9KlNWhJM
        WZnhKgJklfeVI+tB4pwIrqn7tfXYxrXbXpgoqkM=
X-Google-Smtp-Source: APXvYqx30J6afb73nsSCng5QacUHJREf0w6EEX7hPWR2KHpGKYsNePJ+B5T28UXKt8iIdXFd69EyUAFSVYdDePRt2Js=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr5013378qtn.117.1570642721986;
 Wed, 09 Oct 2019 10:38:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-8-ast@kernel.org>
In-Reply-To: <20191005050314.1114330-8-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Oct 2019 10:38:30 -0700
Message-ID: <CAEf4Bza0FP9EgXVuHsQFy4-bedn3uypuwznpu2fPDTYLaMAQpA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/10] bpf: add support for BTF pointers to x86 JIT
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 10:04 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Pointer to BTF object is a pointer to kernel object or NULL.
> Such pointers can only be used by BPF_LDX instructions.
> The verifier changed their opcode from LDX|MEM|size
> to LDX|PROBE_MEM|size to make JITing easier.
> The number of entries in extable is the number of BPF_LDX insns
> that access kernel memory via "pointer to BTF type".
> Only these load instructions can fault.
> Since x86 extable is relative it has to be allocated in the same
> memory region as JITed code.
> Allocate it prior to last pass of JITing and let the last pass populate it.
> Pointer to extable in bpf_prog_aux is necessary to make page fault
> handling fast.
> Page fault handling is done in two steps:
> 1. bpf_prog_kallsyms_find() finds BPF program that page faulted.
>    It's done by walking rb tree.
> 2. then extable for given bpf program is binary searched.
> This process is similar to how page faulting is done for kernel modules.
> The exception handler skips over faulting x86 instruction and
> initializes destination register with zero. This mimics exact
> behavior of bpf_probe_read (when probe_kernel_read faults dest is zeroed).
>
> JITs for other architectures can add support in similar way.
> Until then they will reject unknown opcode and fallback to interpreter.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  arch/x86/net/bpf_jit_comp.c | 96 +++++++++++++++++++++++++++++++++++--
>  include/linux/bpf.h         |  3 ++
>  include/linux/extable.h     | 10 ++++
>  kernel/bpf/core.c           | 20 +++++++-
>  kernel/bpf/verifier.c       |  1 +
>  kernel/extable.c            |  2 +
>  6 files changed, 127 insertions(+), 5 deletions(-)
>

This is surprisingly easy to follow :) Looks good overall, just one
concern about 32-bit distance between ex_handler_bpf and BPF jitted
program below. And I agree with Eric, probably need to ensure proper
alignment for exception_table_entry array.

[...]

> @@ -805,6 +835,48 @@ stx:                       if (is_imm8(insn->off))
>                         else
>                                 EMIT1_off32(add_2reg(0x80, src_reg, dst_reg),
>                                             insn->off);
> +                       if (BPF_MODE(insn->code) == BPF_PROBE_MEM) {
> +                               struct exception_table_entry *ex;
> +                               u8 *_insn = image + proglen;
> +                               s64 delta;
> +
> +                               if (!bpf_prog->aux->extable)
> +                                       break;
> +
> +                               if (excnt >= bpf_prog->aux->num_exentries) {
> +                                       pr_err("ex gen bug\n");

This should never happen, right? BUG()?

> +                                       return -EFAULT;
> +                               }
> +                               ex = &bpf_prog->aux->extable[excnt++];
> +
> +                               delta = _insn - (u8 *)&ex->insn;
> +                               if (!is_simm32(delta)) {
> +                                       pr_err("extable->insn doesn't fit into 32-bit\n");
> +                                       return -EFAULT;
> +                               }
> +                               ex->insn = delta;
> +
> +                               delta = (u8 *)ex_handler_bpf - (u8 *)&ex->handler;

how likely it is that global ex_handle_bpf will be close enough to
dynamically allocated piece of exception_table_entry?

> +                               if (!is_simm32(delta)) {
> +                                       pr_err("extable->handler doesn't fit into 32-bit\n");
> +                                       return -EFAULT;
> +                               }
> +                               ex->handler = delta;
> +
> +                               if (dst_reg > BPF_REG_9) {
> +                                       pr_err("verifier error\n");
> +                                       return -EFAULT;
> +                               }
> +                               /*
> +                                * Compute size of x86 insn and its target dest x86 register.
> +                                * ex_handler_bpf() will use lower 8 bits to adjust
> +                                * pt_regs->ip to jump over this x86 instruction
> +                                * and upper bits to figure out which pt_regs to zero out.
> +                                * End result: x86 insn "mov rbx, qword ptr [rax+0x14]"
> +                                * of 4 bytes will be ignored and rbx will be zero inited.
> +                                */
> +                               ex->fixup = (prog - temp) | (reg2pt_regs[dst_reg] << 8);
> +                       }
>                         break;
>
>                         /* STX XADD: lock *(u32*)(dst_reg + off) += src_reg */
> @@ -1058,6 +1130,11 @@ xadd:                    if (is_imm8(insn->off))
>                 addrs[i] = proglen;
>                 prog = temp;
>         }
> +
> +       if (image && excnt != bpf_prog->aux->num_exentries) {
> +               pr_err("extable is not populated\n");

Isn't this a plain BUG() ?


> +               return -EFAULT;
> +       }
>         return proglen;
>  }
>

[...]
