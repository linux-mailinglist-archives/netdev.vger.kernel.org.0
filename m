Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E6030396
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 22:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfE3UxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 16:53:19 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33610 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3UxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 16:53:19 -0400
Received: by mail-qk1-f194.google.com with SMTP id p18so4890706qkk.0;
        Thu, 30 May 2019 13:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z9CARR2sdyz0TzlZx5C1Y/HG1L1GZ/YQxjW8n3dkDtY=;
        b=O9b/bK8EMj6Z/Aes6GvEEWWgQoaqgWaPkCaZ7cbWL42OrKuP7jCn08XnPqAmy2p306
         8zhO25gwMO64WxuBI2gHUQlS/hvtoy5Caw3oUFl2PIjzGa0bYZkNqSLyaIzi2b1TeyUj
         FF37jgA4vO32nO0WZtIk8qPAYjFw6a6a31YkeqEMWj6cA75nwjX6K+fNkXOSWkeNm8gG
         IDAzymM/tDnhTeMvFQclwaOUNj9WlNGj9jdXrDTHK6nOYN4rb37VYFg2BOXyFCdWVDEX
         3VX2YfBwDDiSgLEeBrbXF0Aaery1wJ4oqbzlGKl7kczZOsWjWFvMpf9Wln7u02PN41Hv
         SoUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z9CARR2sdyz0TzlZx5C1Y/HG1L1GZ/YQxjW8n3dkDtY=;
        b=svapGs1oKeMGqBlnffuFnXrQKXBdtui7HHL8QVPEEPx4t22/p8xva3OS3CN84NjKEL
         HBN8mEOhrbObI3yoYBheq1PgJ+ErQU8CDTXWCLs90lwaIFx7+8lpDz5RR3Y5iwAi8/55
         q5E1TDEf3exzj2Pst2hzKM158nKVg8tkUiqfS+d403HSCl6IIi6wR15cWi+6peWDZnAQ
         VJodwbvw+M5nya623hOSXG/vLgULFGFaJpQ9d6VHokJoqt2NnalzLRiX1lqFllaDb5vM
         i5Q6SLuhWeoqu6CyD8EU8Q8voXlFNQvb1yXbbhT0ujpN06OekkgYtpvPu4afMVPkFTl7
         VdTA==
X-Gm-Message-State: APjAAAXw+M2SQgC40kxqJ95Bdlybe5gia5EN0i7jmsU9qMpg5+6aauC7
        MYabNBWRKDEjerfgQrLL2qbwofnx95egX//82OY=
X-Google-Smtp-Source: APXvYqwWhPLets6g5KL70GsN0a/SBVH9vdVhMDcuBw1NjRTLVGKTPlYj7q6szJQZYwKJTGwxrKqHl3zy1Vgg7W+OTbs=
X-Received: by 2002:a05:620a:12f8:: with SMTP id f24mr5129490qkl.202.1559249597898;
 Thu, 30 May 2019 13:53:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190530190800.7633-1-luke.r.nels@gmail.com>
In-Reply-To: <20190530190800.7633-1-luke.r.nels@gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 30 May 2019 13:53:06 -0700
Message-ID: <CAPhsuW4kMBSjpATqHrEhTmuqje=XZNGOrMyNur8f6K0RNQP=yw@mail.gmail.com>
Subject: Re: [PATCH 1/2] bpf, riscv: fix bugs in JIT for 32-bit ALU operations
To:     Luke Nelson <luke.r.nels@gmail.com>
Cc:     Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>,
        linux-riscv@lists.infradead.org, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 12:09 PM Luke Nelson <luke.r.nels@gmail.com> wrote:
>
> In BPF, 32-bit ALU operations should zero-extend their results into
> the 64-bit registers.  The current BPF JIT on RISC-V emits incorrect
> instructions that perform either sign extension only (e.g., addw/subw)
> or no extension on 32-bit add, sub, and, or, xor, lsh, rsh, arsh,
> and neg.  This behavior diverges from the interpreter and JITs for
> other architectures.
>
> This patch fixes the bugs by performing zero extension on the destination
> register of 32-bit ALU operations.
>
> Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
> Cc: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

This is a little messy. How about we introduce some helper function
like:

/* please find a better name... */
emit_32_or_64(bool is64, const u32 insn_32, const u32 inst_64, struct
rv_jit_context *ctx)
{
       if (is64)
            emit(insn_64, ctx);
       else {
            emit(insn_32, ctx);
           rd = xxxx;
           emit_zext_32(rd, ctx);
       }
}

Thanks,
Song

> ---
>  arch/riscv/net/bpf_jit_comp.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
> index 80b12aa5e10d..426d5c33ea90 100644
> --- a/arch/riscv/net/bpf_jit_comp.c
> +++ b/arch/riscv/net/bpf_jit_comp.c
> @@ -751,22 +751,32 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>         case BPF_ALU | BPF_ADD | BPF_X:
>         case BPF_ALU64 | BPF_ADD | BPF_X:
>                 emit(is64 ? rv_add(rd, rd, rs) : rv_addw(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_SUB | BPF_X:
>         case BPF_ALU64 | BPF_SUB | BPF_X:
>                 emit(is64 ? rv_sub(rd, rd, rs) : rv_subw(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_AND | BPF_X:
>         case BPF_ALU64 | BPF_AND | BPF_X:
>                 emit(rv_and(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_OR | BPF_X:
>         case BPF_ALU64 | BPF_OR | BPF_X:
>                 emit(rv_or(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_XOR | BPF_X:
>         case BPF_ALU64 | BPF_XOR | BPF_X:
>                 emit(rv_xor(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_MUL | BPF_X:
>         case BPF_ALU64 | BPF_MUL | BPF_X:
> @@ -789,14 +799,20 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>         case BPF_ALU | BPF_LSH | BPF_X:
>         case BPF_ALU64 | BPF_LSH | BPF_X:
>                 emit(is64 ? rv_sll(rd, rd, rs) : rv_sllw(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_RSH | BPF_X:
>         case BPF_ALU64 | BPF_RSH | BPF_X:
>                 emit(is64 ? rv_srl(rd, rd, rs) : rv_srlw(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_ARSH | BPF_X:
>         case BPF_ALU64 | BPF_ARSH | BPF_X:
>                 emit(is64 ? rv_sra(rd, rd, rs) : rv_sraw(rd, rd, rs), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>
>         /* dst = -dst */
> @@ -804,6 +820,8 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>         case BPF_ALU64 | BPF_NEG:
>                 emit(is64 ? rv_sub(rd, RV_REG_ZERO, rd) :
>                      rv_subw(rd, RV_REG_ZERO, rd), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>
>         /* dst = BSWAP##imm(dst) */
> @@ -958,14 +976,20 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>         case BPF_ALU | BPF_LSH | BPF_K:
>         case BPF_ALU64 | BPF_LSH | BPF_K:
>                 emit(is64 ? rv_slli(rd, rd, imm) : rv_slliw(rd, rd, imm), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_RSH | BPF_K:
>         case BPF_ALU64 | BPF_RSH | BPF_K:
>                 emit(is64 ? rv_srli(rd, rd, imm) : rv_srliw(rd, rd, imm), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>         case BPF_ALU | BPF_ARSH | BPF_K:
>         case BPF_ALU64 | BPF_ARSH | BPF_K:
>                 emit(is64 ? rv_srai(rd, rd, imm) : rv_sraiw(rd, rd, imm), ctx);
> +               if (!is64)
> +                       emit_zext_32(rd, ctx);
>                 break;
>
>         /* JUMP off */
> --
> 2.19.1
>
