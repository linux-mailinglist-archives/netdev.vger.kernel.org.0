Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6D431A1B91
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 07:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgDHFjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 01:39:20 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39256 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgDHFjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 01:39:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id p10so6312472wrt.6;
        Tue, 07 Apr 2020 22:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Okc82vqS7N+cAm2fC1T1A+xd/pJAgTWbJlOtDSH21Rg=;
        b=NGjPIN3pcaFl/PAoh+/QRIXJUQi67BRhQXiHheHL6FKEhBjcg638Yd5wqiN9Z9yzop
         VLX4y+CU3TUGzKxd8u21ww8cA32q/2uUZi0Cb1Q8BljyD929VSo2RJhuzsIYGiZdPyjB
         AsvH2uHEv5ygVlRkUV4j/sLvRQpwKXZg4ZLiJXe1mNE51phrSZiYTEkF9RXoZSI/Se5u
         yFcRuXDwtrW75zBa3E30rmV0IP3CLT89nbijAfeh41UmSpnCjOF95CUO8S8pvom+6INC
         kbu1Cj8SB3XQNOie8ZrjVMD2doQGnMkae6fol4+qmN3s7SYNyj/FEPmx+4bsWwMTZW4D
         +4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Okc82vqS7N+cAm2fC1T1A+xd/pJAgTWbJlOtDSH21Rg=;
        b=sfU4WmRnSk98h2eHeQiulXNQSUQb2wwHYjlcwjFS72CXI1jKeE4XC2Dd3kHbfx+A4x
         gIIwsMQBcJQIAvwnyGzMh8Fs2m1idZfS7FgP814zV2MjewDRs9ISz0dhc1gKiQKzzYyz
         qBDxsjvLP1+dHp6d6jUR8H6eJFNyDr87PoXtMPzjEJbSzHFfavaRHj2zAR1kkO+l0/A5
         T0VAOzFNjdDSNBtu2Q9gEbtKCqc8fzniRN2lLI0pGsSS/f1Cj9b7rJSgZaGkbVE931Rl
         +k4vLlHzb1LJ4VTrreuYa6HPrYV420kQnkE1aB/QLCP7hXRj/bqWq9BXUBSz1KdZyQmU
         6atQ==
X-Gm-Message-State: AGi0PuYFINnuZgxqBbziCfeCx2/RFd5bLuO51Pot68VqD/y+1EMxl7EH
        kJvwjtncSOZ4B5t19lTr2T7jXiWUrXnWt99MWcw=
X-Google-Smtp-Source: APiQypJITdWG6cr8CDIiyQl/5qm7RlFhsLVBSSSISjnWZ2rvwBgjWu9u8DR1q3ID4FGyCHEUXNbHgfHuDChal9IuBWM=
X-Received: by 2002:a5d:4988:: with SMTP id r8mr6283912wrq.248.1586324357903;
 Tue, 07 Apr 2020 22:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200406221604.18547-1-luke.r.nels@gmail.com>
In-Reply-To: <20200406221604.18547-1-luke.r.nels@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 8 Apr 2020 07:39:06 +0200
Message-ID: <CAJ+HfNh=VDeXJQ3iYHDEXAd1xB_YPShnJyqsW4OmRE=VLAMuuw@mail.gmail.com>
Subject: Re: [PATCH bpf] riscv, bpf: Fix offset range checking for auipc+jalr
 on RV64
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Apr 2020 at 00:16, Luke Nelson <lukenels@cs.washington.edu> wrote=
:
>
> The existing code in emit_call on RV64 checks that the PC-relative offset
> to the function fits in 32 bits before calling emit_jump_and_link to emit
> an auipc+jalr pair. However, this check is incorrect because offsets in
> the range [2^31 - 2^11, 2^31 - 1] cannot be encoded using auipc+jalr on
> RV64 (see discussion [1]). The RISC-V spec has recently been updated
> to reflect this fact [2, 3].
>
> This patch fixes the problem by moving the check on the offset into
> emit_jump_and_link and modifying it to the correct range of encodable
> offsets, which is [-2^31 - 2^11, 2^31 - 2^11). This also enforces the
> check on the offset to other uses of emit_jump_and_link (e.g., BPF_JA)
> as well.
>
> Currently, this bug is unlikely to be triggered, because the memory
> region from which JITed images are allocated is close enough to kernel
> text for the offsets to not become too large; and because the bounds on
> BPF program size are small enough. This patch prevents this problem from
> becoming an issue if either of these change.
>
> [1]: https://groups.google.com/a/groups.riscv.org/forum/#!topic/isa-dev/b=
wWFhBnnZFQ
> [2]: https://github.com/riscv/riscv-isa-manual/commit/b1e42e09ac55116dbf9=
de5e4fb326a5a90e4a993
> [3]: https://github.com/riscv/riscv-isa-manual/commit/4c1b2066ebd2965a422=
e41eb262d0a208a7fea07
>

Wow! Interesting! Thanks for fixing this!

Too late to Ack, but still:

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>

> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> ---
>  arch/riscv/net/bpf_jit_comp64.c | 49 +++++++++++++++++++++------------
>  1 file changed, 32 insertions(+), 17 deletions(-)
>
> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_com=
p64.c
> index cc1985d8750a..d208a9fd6c52 100644
> --- a/arch/riscv/net/bpf_jit_comp64.c
> +++ b/arch/riscv/net/bpf_jit_comp64.c
> @@ -110,6 +110,16 @@ static bool is_32b_int(s64 val)
>         return -(1L << 31) <=3D val && val < (1L << 31);
>  }
>
> +static bool in_auipc_jalr_range(s64 val)
> +{
> +       /*
> +        * auipc+jalr can reach any signed PC-relative offset in the rang=
e
> +        * [-2^31 - 2^11, 2^31 - 2^11).
> +        */
> +       return (-(1L << 31) - (1L << 11)) <=3D val &&
> +               val < ((1L << 31) - (1L << 11));
> +}
> +
>  static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
>  {
>         /* Note that the immediate from the add is sign-extended,
> @@ -380,20 +390,24 @@ static void emit_sext_32_rd(u8 *rd, struct rv_jit_c=
ontext *ctx)
>         *rd =3D RV_REG_T2;
>  }
>
> -static void emit_jump_and_link(u8 rd, s64 rvoff, bool force_jalr,
> -                              struct rv_jit_context *ctx)
> +static int emit_jump_and_link(u8 rd, s64 rvoff, bool force_jalr,
> +                             struct rv_jit_context *ctx)
>  {
>         s64 upper, lower;
>
>         if (rvoff && is_21b_int(rvoff) && !force_jalr) {
>                 emit(rv_jal(rd, rvoff >> 1), ctx);
> -               return;
> +               return 0;
> +       } else if (in_auipc_jalr_range(rvoff)) {
> +               upper =3D (rvoff + (1 << 11)) >> 12;
> +               lower =3D rvoff & 0xfff;
> +               emit(rv_auipc(RV_REG_T1, upper), ctx);
> +               emit(rv_jalr(rd, RV_REG_T1, lower), ctx);
> +               return 0;
>         }
>
> -       upper =3D (rvoff + (1 << 11)) >> 12;
> -       lower =3D rvoff & 0xfff;
> -       emit(rv_auipc(RV_REG_T1, upper), ctx);
> -       emit(rv_jalr(rd, RV_REG_T1, lower), ctx);
> +       pr_err("bpf-jit: target offset 0x%llx is out of range\n", rvoff);
> +       return -ERANGE;
>  }
>
>  static bool is_signed_bpf_cond(u8 cond)
> @@ -407,18 +421,16 @@ static int emit_call(bool fixed, u64 addr, struct r=
v_jit_context *ctx)
>         s64 off =3D 0;
>         u64 ip;
>         u8 rd;
> +       int ret;
>
>         if (addr && ctx->insns) {
>                 ip =3D (u64)(long)(ctx->insns + ctx->ninsns);
>                 off =3D addr - ip;
> -               if (!is_32b_int(off)) {
> -                       pr_err("bpf-jit: target call addr %pK is out of r=
ange\n",
> -                              (void *)addr);
> -                       return -ERANGE;
> -               }
>         }
>
> -       emit_jump_and_link(RV_REG_RA, off, !fixed, ctx);
> +       ret =3D emit_jump_and_link(RV_REG_RA, off, !fixed, ctx);
> +       if (ret)
> +               return ret;
>         rd =3D bpf_to_rv_reg(BPF_REG_0, ctx);
>         emit(rv_addi(rd, RV_REG_A0, 0), ctx);
>         return 0;
> @@ -429,7 +441,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>  {
>         bool is64 =3D BPF_CLASS(insn->code) =3D=3D BPF_ALU64 ||
>                     BPF_CLASS(insn->code) =3D=3D BPF_JMP;
> -       int s, e, rvoff, i =3D insn - ctx->prog->insnsi;
> +       int s, e, rvoff, ret, i =3D insn - ctx->prog->insnsi;
>         struct bpf_prog_aux *aux =3D ctx->prog->aux;
>         u8 rd =3D -1, rs =3D -1, code =3D insn->code;
>         s16 off =3D insn->off;
> @@ -699,7 +711,9 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>         /* JUMP off */
>         case BPF_JMP | BPF_JA:
>                 rvoff =3D rv_offset(i, off, ctx);
> -               emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
> +               ret =3D emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx=
);
> +               if (ret)
> +                       return ret;
>                 break;
>
>         /* IF (dst COND src) JUMP off */
> @@ -801,7 +815,6 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>         case BPF_JMP | BPF_CALL:
>         {
>                 bool fixed;
> -               int ret;
>                 u64 addr;
>
>                 mark_call(ctx);
> @@ -826,7 +839,9 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, st=
ruct rv_jit_context *ctx,
>                         break;
>
>                 rvoff =3D epilogue_offset(ctx);
> -               emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
> +               ret =3D emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx=
);
> +               if (ret)
> +                       return ret;
>                 break;
>
>         /* dst =3D imm64 */
> --
> 2.17.1
>
