Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5772E44F0F
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 00:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfFMWZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 18:25:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36184 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfFMWZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 18:25:35 -0400
Received: by mail-qt1-f195.google.com with SMTP id p15so316006qtl.3;
        Thu, 13 Jun 2019 15:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SAkygIH5C9UlAf+F0XPGYXuilILEPnzWb2xQLbIoG6E=;
        b=tMTCZP8uhWrar+Q+DHwSPZqVR9wPquJnLg6ADwNI5O8XEMjuRVs6O+jqgDCLEgd5fY
         gRHaIdS3iy0ISaNJpxD4uVRSnXcpdZlbgBG9pw6VY95JlLH2eh57Drg/pdHjgaAwk4L9
         5Kijf2k6YFvJiFfmxiDv1FY2zE4i7Ps7ZvKRcT0o+nZeKUU9U3zi5MmLD3q32qhDWuTp
         PV2A+9iY5coo/hSiWWVoki48XmCIk3uo/aoZjsAqrocN5CIDiGRAj/wR5vtU7FRa15rL
         ATbbV3osB3bm7S3yel/C7fwWaNBIOgHEhoHjS+c0rEk5aWcvyifWLQwvTaL96sGsWLA1
         oCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SAkygIH5C9UlAf+F0XPGYXuilILEPnzWb2xQLbIoG6E=;
        b=SJY4bF9i1QOLtF0NdL7brQCtOFLyh1HvEYrukzs9irCpznwTEKzu4dHD07IausN6y9
         d1TXY31cvhcbF4VVCw5pp9XpkbvBlDKRaOMSCyVr7I12zTfsW0bd+5DrIOrIiB710vaY
         4HXnejf6eVWxczNnPwgkNVO298k+WslLGSAittOjDCynll3iv2HPViVLEqve5nrnRqFK
         lt2kGyymk8BjxnWulNioLskxKIw+oI7H1zQfZXi/fywoGCLdBjsVcHNiDNIdd3rYU1ru
         4GeILIJUMCyb9Aq3jBR43Ovwg+5E0a08G2aekuzcMsM5y6a2kzERfdqI5/a+b2V1qSNZ
         6ezw==
X-Gm-Message-State: APjAAAXZp0LAItr82PIJBam6e7U13R9FVn8gqP1Qox6Pkb+8jAbdXP/l
        IHJR5YHp5KagcGReDnSrPPthq22vyevhSTwh0vo=
X-Google-Smtp-Source: APXvYqzWD+udJfeMcLoXhIGySSdZ/Ziw2ElgE3ng0TbWLO9xMzWbj4nI7kCMrwYzK6mWLbfLVhXweY4rEvHcXhqIs5Q=
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr58864931qty.59.1560464734433;
 Thu, 13 Jun 2019 15:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190613042003.3791852-1-ast@kernel.org> <20190613042003.3791852-4-ast@kernel.org>
In-Reply-To: <20190613042003.3791852-4-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Jun 2019 15:25:23 -0700
Message-ID: <CAEf4BzZ0Dt-3hdCnSWtFGc0Yob5N2C8QgGAB=PwC5OgZMVEtsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/9] bpf: extend is_branch_taken to registers
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Edward Cree <ecree@solarflare.com>,
        john fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, Jann Horn <jannh@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 9:50 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> This patch extends is_branch_taken() logic from JMP+K instructions
> to JMP+X instructions.
> Conditional branches are often done when src and dst registers
> contain known scalars. In such case the verifier can follow
> the branch that is going to be taken when program executes on CPU.
> That speeds up the verification and essential feature to support

typo: and *is* essential

> bounded loops.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/verifier.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index a21bafd7d931..c79c09586a9e 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5263,10 +5263,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
>         struct bpf_verifier_state *this_branch = env->cur_state;
>         struct bpf_verifier_state *other_branch;
>         struct bpf_reg_state *regs = this_branch->frame[this_branch->curframe]->regs;
> -       struct bpf_reg_state *dst_reg, *other_branch_regs;
> +       struct bpf_reg_state *dst_reg, *other_branch_regs, *src_reg = NULL;
>         u8 opcode = BPF_OP(insn->code);
>         bool is_jmp32;
>         int err;
> +       u64 cond_val;

reverse Christmas tree

>
>         /* Only conditional jumps are expected to reach here. */
>         if (opcode == BPF_JA || opcode > BPF_JSLE) {
> @@ -5290,6 +5291,7 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
>                                 insn->src_reg);
>                         return -EACCES;
>                 }
> +               src_reg = &regs[insn->src_reg];
>         } else {
>                 if (insn->src_reg != BPF_REG_0) {
>                         verbose(env, "BPF_JMP/JMP32 uses reserved fields\n");
> @@ -5306,8 +5308,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
>         is_jmp32 = BPF_CLASS(insn->code) == BPF_JMP32;
>
>         if (BPF_SRC(insn->code) == BPF_K) {
> -               int pred = is_branch_taken(dst_reg, insn->imm, opcode,
> -                                          is_jmp32);
> +               int pred;
> +
> +               cond_val = insn->imm;
> +check_taken:
> +               pred = is_branch_taken(dst_reg, cond_val, opcode, is_jmp32);
>
>                 if (pred == 1) {
>                          /* only follow the goto, ignore fall-through */
> @@ -5319,6 +5324,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
>                          */
>                         return 0;
>                 }
> +       } else if (BPF_SRC(insn->code) == BPF_X &&
> +                  src_reg->type == SCALAR_VALUE &&
> +                  tnum_is_const(src_reg->var_off)) {
> +               cond_val = src_reg->var_off.value;
> +               goto check_taken;
>         }

To eliminate goto, how about this;

int pred = -1;

if (BPF_SRC(insn->code) == BPF_K)
         pred = is_branch_taken(dst_reg, insn->imm, opcode, is_jmp32);
else if (BPF_SRC(insn->code) == BPF_X &&
                 src_reg->type == SCALAR_VALUE &&
                 tnum_is_const(src_reg->var_off)
         pred = is_branch_taken(dst_reg, src_reg->var_off.value,
opcode, is_jmp32);

/* here do pred == 1 and pred == 0 special handling, otherwise fall-through */

Again, more linear and no unnecessary gotos. pred == -1 has already a
meaning of "don't know, have to try both".

>
>         other_branch = push_stack(env, *insn_idx + insn->off + 1, *insn_idx,
> --
> 2.20.0
>
