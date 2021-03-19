Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5089C3411E1
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 02:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhCSBEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 21:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhCSBEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 21:04:01 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A358C06174A;
        Thu, 18 Mar 2021 18:04:01 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id h82so4472996ybc.13;
        Thu, 18 Mar 2021 18:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZGOncK1f2mtt4j4HI6UYzil414+B32QC7q3uvm91mbo=;
        b=bEpJKfs9tuBh9lkKR+edb6GTo7wc5sCOSB2iDDb8i4Wh/evwumdvAMOB2TQARLagM1
         PCgJgH2bPwg3XpVKKc/iWHggUyd5UdYKNxYOnbYLn9UAJV1B3YRDKRY51C+MAlXIbflW
         /Q5g5MmUKJAQBsc5CUWK9ov1CXOKARcxbSJ3+e5fCq4mGf+rA1pd+J1STDIuYX9OjrJf
         TXEJuuj3MGMigwGwpRcCBnT3hsrdyR3/VP9wmZBQUD34Xfx7ypLXx/v0ZUp0HnZ1OceM
         gyoDuZ4+XgNCBS2BwFku4BEL1kk841rVtMWZ11zCg7N449ayKLUjNgXZVioXXBzlCVCT
         RkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZGOncK1f2mtt4j4HI6UYzil414+B32QC7q3uvm91mbo=;
        b=tfNHxMq4F0H8I7U4uZxC5DqTTE+EHKmGigKCmDqhLkdoB1a+YH2mYwZbJcLQGsPNO+
         5Rn2rrxAEtPh8E1csj4a/UYv68rLRdPcibBebN+0AqKIoNTOCdl2v99dFpUPPo4OKM7d
         B6yiCREJSflgPuGxibTbjizVWc3NmZflr0KQnSXexV4KUbNPZ5c/YFAZfofgRf6c9QEU
         9d2I5+UU9hSIPSuJR1mgRuJnRanzf8UfhTvRVmhPYP3T42o8TGHFqTdRI+ACsct8EQvi
         uNJExaWCHAf0ipvzyisenoZGtC53eJgtqqzfp5ctITFsBPfzcFndYJ4RoBZ2Dl3R+8mq
         mkRQ==
X-Gm-Message-State: AOAM531LzYcn8KDVqZFwGAq1aaMuPTZqOcTMT9xnUAbvOkuGHT1LbeL7
        mDYCTAVywJss0etAPZwk57OAJiwPLvvL9SXZojw=
X-Google-Smtp-Source: ABdhPJwINHrat3UHSHnwVnfbB0hX1ojCZenuLmbRWY0o3XNZHDBGASR6KYqgHHlfOgXS0bMbTi9g1dEolTXBb3FY9J4=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr2933401yba.459.1616115840390;
 Thu, 18 Mar 2021 18:04:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011401.4176793-1-kafai@fb.com>
In-Reply-To: <20210316011401.4176793-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Mar 2021 18:03:49 -0700
Message-ID: <CAEf4Bzb-AmXvV+v-ByGH7iUUG7iLdFxWeY1CJGB7xKHxuABWUg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 04/15] bpf: Support bpf program calling kernel function
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch adds support to BPF verifier to allow bpf program calling
> kernel function directly.
>
> The use case included in this set is to allow bpf-tcp-cc to directly
> call some tcp-cc helper functions (e.g. "tcp_cong_avoid_ai()").  Those
> functions have already been used by some kernel tcp-cc implementations.
>
> This set will also allow the bpf-tcp-cc program to directly call the
> kernel tcp-cc implementation,  For example, a bpf_dctcp may only want to
> implement its own dctcp_cwnd_event() and reuse other dctcp_*() directly
> from the kernel tcp_dctcp.c instead of reimplementing (or
> copy-and-pasting) them.
>
> The tcp-cc kernel functions mentioned above will be white listed
> for the struct_ops bpf-tcp-cc programs to use in a later patch.
> The white listed functions are not bounded to a fixed ABI contract.
> Those functions have already been used by the existing kernel tcp-cc.
> If any of them has changed, both in-tree and out-of-tree kernel tcp-cc
> implementations have to be changed.  The same goes for the struct_ops
> bpf-tcp-cc programs which have to be adjusted accordingly.
>
> This patch is to make the required changes in the bpf verifier.
>
> First change is in btf.c, it adds a case in "do_btf_check_func_arg_match()".
> When the passed in "btf->kernel_btf == true", it means matching the
> verifier regs' states with a kernel function.  This will handle the
> PTR_TO_BTF_ID reg.  It also maps PTR_TO_SOCK_COMMON, PTR_TO_SOCKET,
> and PTR_TO_TCP_SOCK to its kernel's btf_id.
>
> In the later libbpf patch, the insn calling a kernel function will
> look like:
>
> insn->code == (BPF_JMP | BPF_CALL)
> insn->src_reg == BPF_PSEUDO_KFUNC_CALL /* <- new in this patch */
> insn->imm == func_btf_id /* btf_id of the running kernel */
>
> [ For the future calling function-in-kernel-module support, an array
>   of module btf_fds can be passed at the load time and insn->off
>   can be used to index into this array. ]
>
> At the early stage of verifier, the verifier will collect all kernel
> function calls into "struct bpf_kern_func_descriptor".  Those
> descriptors are stored in "prog->aux->kfunc_tab" and will
> be available to the JIT.  Since this "add" operation is similar
> to the current "add_subprog()" and looking for the same insn->code,
> they are done together in the new "add_subprog_and_kern_func()".
>
> In the "do_check()" stage, the new "check_kern_func_call()" is added
> to verify the kernel function call instruction:
> 1. Ensure the kernel function can be used by a particular BPF_PROG_TYPE.
>    A new bpf_verifier_ops "check_kern_func_call" is added to do that.
>    The bpf-tcp-cc struct_ops program will implement this function in
>    a later patch.
> 2. Call "btf_check_kern_func_args_match()" to ensure the regs can be
>    used as the args of a kernel function.
> 3. Mark the regs' type, subreg_def, and zext_dst.
>
> At the later do_misc_fixups() stage, the new fixup_kern_func_call()
> will replace the insn->imm with the function address (relative
> to __bpf_call_base).  If needed, the jit can find the btf_func_model
> by calling the new bpf_jit_find_kern_func_model(prog, insn->imm).
> With the imm set to the function address, "bpftool prog dump xlated"
> will be able to display the kernel function calls the same way as
> it displays other bpf helper calls.
>
> gpl_compatible program is required to call kernel function.
>
> This feature currently requires JIT.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

After the initial pass it all makes sense so far. I am a bit concerned
about s32 and kernel function offset, though. See below.

Also "kern_func" and "descriptor" are quite mouthful, it seems to me
that using kfunc consistently wouldn't hurt readability at all. You
also already use desc in place of "descriptor" for variables, so I'd
do that in type names as well.

>  arch/x86/net/bpf_jit_comp.c       |   5 +
>  include/linux/bpf.h               |  24 ++
>  include/linux/btf.h               |   1 +
>  include/linux/filter.h            |   1 +
>  include/uapi/linux/bpf.h          |   4 +
>  kernel/bpf/btf.c                  |  65 +++++-
>  kernel/bpf/core.c                 |  18 +-
>  kernel/bpf/disasm.c               |  32 +--
>  kernel/bpf/disasm.h               |   3 +-
>  kernel/bpf/syscall.c              |   1 +
>  kernel/bpf/verifier.c             | 376 ++++++++++++++++++++++++++++--
>  tools/bpf/bpftool/xlated_dumper.c |   3 +-
>  tools/include/uapi/linux/bpf.h    |   4 +
>  13 files changed, 488 insertions(+), 49 deletions(-)
>

[...]

> +
> +       func_name = btf_name_by_offset(btf_vmlinux, func->name_off);
> +       addr = kallsyms_lookup_name(func_name);
> +       if (!addr) {
> +               verbose(env, "cannot find address for kernel function %s\n",
> +                       func_name);
> +               return -EINVAL;
> +       }
> +
> +       desc = &tab->descs[tab->nr_descs++];
> +       desc->func_id = func_id;
> +       desc->imm = BPF_CAST_CALL(addr) - __bpf_call_base;

Is this difference guaranteed to always fit within s32?

> +       sort(tab->descs, tab->nr_descs, sizeof(tab->descs[0]),
> +            kern_func_desc_cmp_by_id, NULL);
> +
> +       return btf_distill_func_proto(&env->log, btf_vmlinux,
> +                                     func_proto, func_name,
> +                                     &desc->func_model);
> +}
> +
> +static int kern_func_desc_cmp_by_imm(const void *a, const void *b)
> +{
> +       const struct bpf_kern_func_descriptor *d0 = a;
> +       const struct bpf_kern_func_descriptor *d1 = b;
> +
> +       return d0->imm - d1->imm;

this is not safe, assuming any possible s32 values, no?

> +}
> +
> +static void sort_kern_func_descs_by_imm(struct bpf_prog *prog)
> +{
> +       struct bpf_kern_func_desc_tab *tab;
> +
> +       tab = prog->aux->kfunc_tab;
> +       if (!tab)
> +               return;
> +
> +       sort(tab->descs, tab->nr_descs, sizeof(tab->descs[0]),
> +            kern_func_desc_cmp_by_imm, NULL);
> +}
> +

[...]
