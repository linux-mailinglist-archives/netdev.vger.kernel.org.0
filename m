Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B18C46C14
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 23:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfFNVpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 17:45:39 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42148 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfFNVpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 17:45:39 -0400
Received: by mail-qt1-f193.google.com with SMTP id s15so4198468qtk.9;
        Fri, 14 Jun 2019 14:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N84V6amyzXmuI5NMbfQ0Dim+ey2GqYNptHIaZNRW9us=;
        b=PTFrWKW28eQJ6d0IdKoPy4CP/4UnBjUyp+Veza+FwPe1/3mXU6qdeQ8gMvwnL0pmtx
         JU3HiYDUA64/zzAKheRj2iZD0YIlTohymhAD7C0YZ9AO0WPFdRg3vc3dbVPrwIMWfcIc
         5tiephlyCJb3OMt9a52Vr4zUBcF107ioZbzcgAZoEl5bMr/rux7snhfVRWT68KzE8lTr
         MysdAtLXzovonMk1Fl0Ej+UbngRFQYW5/yAycXbO8hsTT1iCENxFa84U/sQLfk59D+AA
         4ZKtNn0GfBcdp8ZBxKekW48Vz/807OdLU2N/p6mxHVjJlKDoB3E2seCezEHbJOJspUPj
         sPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N84V6amyzXmuI5NMbfQ0Dim+ey2GqYNptHIaZNRW9us=;
        b=p6yGIg/A0XI63gOhgLJ18f8/MGCPUUvhyPPGJLe8OmKHLv8hvParxlBgVFHbCwjhNO
         hcYdHuBYwlSqM8VqEMB7nSiYrrKSUAztUU/7Wrl5/XSL0iPcYTU45fWAb2E0tmVutNg3
         QHycmLjX6TdfAMs26jtO+BKk7Y3HDoZkY7/yopfG9rF1KsupFuqBRwnfNIDVh1e+Zf8H
         2S4qjeVcZ0juaK6PpUy6lVc+RvfSdmPTPnV8d/bSdWQId7oKgegYLtVgqyQMtWfE7n1/
         DMBxGr8+6aZg/iwZfIFyxNr5Q+CLhgK2VyR+DQ105TZibA81eDWuhIIs8bzNnZFqFXLY
         quWg==
X-Gm-Message-State: APjAAAV2v+QHMeeV+2uyfFeGoM8JvFWR2SsXi0+MnEI/PcPaN8+UlDDU
        d1d4BP6cRxC4ynHk5NhNjWMfNcg2c7EEi2FrcdI=
X-Google-Smtp-Source: APXvYqwZrG1W9GZAcWGD6LUDjQN9AKz2V5QvbpGe+mOpAzHRXd/Fr58JvtvaJxBZA9BxQPmfq/GR9/W/RoM97rnnyTY=
X-Received: by 2002:a0c:d0fc:: with SMTP id b57mr10390342qvh.78.1560548737330;
 Fri, 14 Jun 2019 14:45:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190614072557.196239-1-ast@kernel.org> <20190614072557.196239-10-ast@kernel.org>
In-Reply-To: <20190614072557.196239-10-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jun 2019 14:45:25 -0700
Message-ID: <CAEf4Bza-tWx4=sQzkXVFrKDKYrhmrHNfFtRDS3CfDMmPhbGJVg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 9/9] bpf: precise scalar_value tracking
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 12:26 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Introduce precision tracking logic that
> helps cilium programs the most:
>                   old clang  old clang    new clang  new clang
>                           with all patches         with all patches
> bpf_lb-DLB_L3.o      1838     2728         1923      2216
> bpf_lb-DLB_L4.o      3218     3562         3077      3390
> bpf_lb-DUNKNOWN.o    1064     544          1062      543
> bpf_lxc-DDROP_ALL.o  26935    15989        166729    15372
> bpf_lxc-DUNKNOWN.o   34439    26043        174607    22156
> bpf_netdev.o         9721     8062         8407      7312
> bpf_overlay.o        6184     6138         5420      5555
> bpf_lxc_jit.o        39389    39452        39389     39452
>
> Consider code:
> 654: (85) call bpf_get_hash_recalc#34
> 655: (bf) r7 = r0
> 656: (15) if r8 == 0x0 goto pc+29
> 657: (bf) r2 = r10
> 658: (07) r2 += -48
> 659: (18) r1 = 0xffff8881e41e1b00
> 661: (85) call bpf_map_lookup_elem#1
> 662: (15) if r0 == 0x0 goto pc+23
> 663: (69) r1 = *(u16 *)(r0 +0)
> 664: (15) if r1 == 0x0 goto pc+21
> 665: (bf) r8 = r7
> 666: (57) r8 &= 65535
> 667: (bf) r2 = r8
> 668: (3f) r2 /= r1
> 669: (2f) r2 *= r1
> 670: (bf) r1 = r8
> 671: (1f) r1 -= r2
> 672: (57) r1 &= 255
> 673: (25) if r1 > 0x1e goto pc+12
>  R0=map_value(id=0,off=0,ks=20,vs=64,imm=0) R1_w=inv(id=0,umax_value=30,var_off=(0x0; 0x1f))
> 674: (67) r1 <<= 1
> 675: (0f) r0 += r1
>
> At this point the verifier will notice that scalar R1 is used in map pointer adjustment.
> R1 has to be precise for later operations on R0 to be validated properly.
>
> The verifier will backtrack the above code in the following way:
> last_idx 675 first_idx 664
> regs=2 stack=0 before 675: (0f) r0 += r1         // started backtracking R1 regs=2 is a bitmask
> regs=2 stack=0 before 674: (67) r1 <<= 1
> regs=2 stack=0 before 673: (25) if r1 > 0x1e goto pc+12
> regs=2 stack=0 before 672: (57) r1 &= 255
> regs=2 stack=0 before 671: (1f) r1 -= r2         // now both R1 and R2 has to be precise -> regs=6 mask
> regs=6 stack=0 before 670: (bf) r1 = r8          // after this insn R8 and R2 has to be precise
> regs=104 stack=0 before 669: (2f) r2 *= r1       // after this one R8, R2, and R1
> regs=106 stack=0 before 668: (3f) r2 /= r1
> regs=106 stack=0 before 667: (bf) r2 = r8
> regs=102 stack=0 before 666: (57) r8 &= 65535
> regs=102 stack=0 before 665: (bf) r8 = r7
> regs=82 stack=0 before 664: (15) if r1 == 0x0 goto pc+21
>  // this is the end of verifier state. The following regs will be marked precised:
>  R1_rw=invP(id=0,umax_value=65535,var_off=(0x0; 0xffff)) R7_rw=invP(id=0)
> parent didn't have regs=82 stack=0 marks         // so backtracking continues into parent state
> last_idx 663 first_idx 655
> regs=82 stack=0 before 663: (69) r1 = *(u16 *)(r0 +0)   // R1 was assigned no need to track it further
> regs=80 stack=0 before 662: (15) if r0 == 0x0 goto pc+23    // keep tracking R7
> regs=80 stack=0 before 661: (85) call bpf_map_lookup_elem#1  // keep tracking R7
> regs=80 stack=0 before 659: (18) r1 = 0xffff8881e41e1b00
> regs=80 stack=0 before 658: (07) r2 += -48
> regs=80 stack=0 before 657: (bf) r2 = r10
> regs=80 stack=0 before 656: (15) if r8 == 0x0 goto pc+29
> regs=80 stack=0 before 655: (bf) r7 = r0                // here the assignment into R7
>  // mark R0 to be precise:
>  R0_rw=invP(id=0)
> parent didn't have regs=1 stack=0 marks                 // regs=1 -> tracking R0
> last_idx 654 first_idx 644
> regs=1 stack=0 before 654: (85) call bpf_get_hash_recalc#34 // and in the parent frame it was a return value
>   // nothing further to backtrack
>
> Two scalar registers not marked precise are equivalent from state pruning point of view.
> More details in the patch comments.
>
> It doesn't support bpf2bpf calls yet and enabled for root only.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

<snip>

> @@ -958,6 +983,17 @@ static void __reg_bound_offset(struct bpf_reg_state *reg)
>         reg->var_off = tnum_intersect(reg->var_off,
>                                       tnum_range(reg->umin_value,
>                                                  reg->umax_value));
> +       /* if register became known constant after a sequence of comparisons
> +        * or arithmetic operations mark it precise now, since backtracking
> +        * cannot follow such logic.
> +        * Example:
> +        * r0 = get_random();
> +        * if (r0 < 1) goto ..
> +        * if (r0 > 1) goto ..
> +        * r0 is const here
> +        */
> +       if (tnum_is_const(reg->var_off))
> +               reg->precise = true;

I'm not sure you have to do this: r0 value might never be used in a
"precise" context. But worse, if it is required to be precise,
backtracking logic will stop here, while it has to continue to the
previous conditional jumps and keep marking r0 as precise.

>  }
>
>  /* Reset the min/max bounds of a register */
> @@ -967,6 +1003,9 @@ static void __mark_reg_unbounded(struct bpf_reg_state *reg)
>         reg->smax_value = S64_MAX;
>         reg->umin_value = 0;
>         reg->umax_value = U64_MAX;
> +
> +       /* constant backtracking is enabled for root only for now */
> +       reg->precise = capable(CAP_SYS_ADMIN) ? false : true;
>  }
>
>  /* Mark a register as having a completely unknown (scalar) value. */
> @@ -1457,6 +1496,9 @@ static int check_stack_write(struct bpf_verifier_env *env,
>
>         if (reg && size == BPF_REG_SIZE && register_is_const(reg) &&
>             !register_is_null(reg) && env->allow_ptr_leaks) {
> +               if (env->prog->insnsi[insn_idx].dst_reg != BPF_REG_FP)
> +                       /* backtracking logic can only recognize explicit [fp-X] */
> +                       reg->precise = true;

This has similar problem as above. Every time you proactively mark
some register/stack slot as precise, you have to do backtrack logic to
mark relevant register precise.


>                 save_register_state(state, spi, reg);
>         } else if (reg && is_spillable_regtype(reg->type)) {
>                 /* register containing pointer is being spilled into stack */
> @@ -1610,6 +1652,10 @@ static int check_stack_read(struct bpf_verifier_env *env,
>                                  * so the whole register == const_zero
>                                  */
>                                 __mark_reg_const_zero(&state->regs[value_regno]);
> +                               /* backtracking doesn't support STACK_ZERO yet,
> +                                * so conservatively mark it precise
> +                                */
> +                               state->regs[value_regno].precise = true;

This is probably ok without backtracking, because of STACK_ZERO being
implicitly precise. But flagging just in case.

>                         } else {
>                                 /* have read misc data from the stack */
>                                 mark_reg_unknown(env, state->regs, value_regno);
> @@ -2735,6 +2781,369 @@ static int int_ptr_type_to_size(enum bpf_arg_type type)
>         return -EINVAL;
>  }
>
> +/* for any branch, call, exit record the history of jmps in the given state */
> +static int push_jmp_history(struct bpf_verifier_env *env,
> +                           struct bpf_verifier_state *cur)
> +{
> +       struct bpf_idx_pair *p;
> +       u32 cnt = cur->jmp_history_cnt;

Reverse Christmas tree.

> +
> +       cnt++;
> +       p = krealloc(cur->jmp_history, cnt * sizeof(*p), GFP_USER);
> +       if (!p)
> +               return -ENOMEM;
> +       p[cnt - 1].idx = env->insn_idx;
> +       p[cnt - 1].prev_idx = env->prev_insn_idx;
> +       cur->jmp_history = p;
> +       cur->jmp_history_cnt = cnt;
> +       return 0;
> +}
> +
> +/* Backtrack one insn at a time. If idx is not at the top of recorded
> + * history then previous instruction came from straight line execution.
> + */
> +static int pop_and_get_prev_idx(struct bpf_verifier_state *st, int i)

This operation destroys jmp_history, which is a problem if there is
another branch yet-to-be-processed, which might need jmp history again
to mark some other register as precise.

> +{
> +       u32 cnt = st->jmp_history_cnt;
> +
> +       if (cnt && st->jmp_history[cnt - 1].idx == i) {
> +               i = st->jmp_history[cnt - 1].prev_idx;
> +               st->jmp_history_cnt--;
> +       } else {
> +               i--;
> +       }
> +       return i;
> +}
> +

<snip>

> +       } else if (class == BPF_JMP || class == BPF_JMP32) {
> +               if (opcode == BPF_CALL) {
> +                       if (insn->src_reg == BPF_PSEUDO_CALL)
> +                               return -ENOTSUPP;
> +                       else
> +                               /* regular helper call sets R0 */
> +                               *reg_mask &= ~1;

Regular helper also clobbers R1-R5, which from the standpoint of
verifier should be treated as R[1-5] = <UNKNOWN>, so:

*reg_mask &= ~0x3f

> +               } else if (opcode == BPF_EXIT) {
> +                       return -ENOTSUPP;
> +               }
> +       } else if (class == BPF_LD) {
> +               if (!(*reg_mask & dreg))
> +                       return 0;

<snip>

> + *
> + * Note the verifier cannot simply walk register parentage chain,
> + * since many different registers and stack slots could have been
> + * used to compute single precise scalar.
> + *
> + * It's not safe to start with precise=true and backtrack
> + * when passing scalar register into a helper that takes ARG_ANYTHING.

It took me many reads to understand what this means (I think). Here
you are saying that approach of starting with precise=true for
register and then backtracking to mark it as not precise when we
detect that we don't care about specific value (e.g., when helper
takes register as ARG_ANYTHING parameter) is not safe. Is that correct
interpretation? If yes, slightly less brief comment might be
appropriate ;)

> + *
> + * It's ok to walk single parentage chain of the verifier states.
> + * It's possible that this backtracking will go all the way till 1st insn.
> + * All other branches will be explored for needing precision later.
> + *
> + * The backtracking needs to deal with cases like:
> + *   R8=map_value(id=0,off=0,ks=4,vs=1952,imm=0) R9_w=map_value(id=0,off=40,ks=4,vs=1952,imm=0)
> + * r9 -= r8
> + * r5 = r9
> + * if r5 > 0x79f goto pc+7
> + *    R5_w=inv(id=0,umax_value=1951,var_off=(0x0; 0x7ff))
> + * r5 += 1
> + * ...
> + * call bpf_perf_event_output#25
> + *   where .arg5_type = ARG_CONST_SIZE_OR_ZERO
> + *
> + * and this case:
> + * r6 = 1
> + * call foo // uses callee's r6 inside to compute r0
> + * r0 += r6
> + * if r0 == 0 goto
> + *
> + * to track above reg_mask/stack_mask needs to be independent for each frame.
> + *
> + * Alslo if parent's curframe > frame where backtracking started,

typo: Alslo -> Also

<snip>

> +
> +static int mark_chain_precision(struct bpf_verifier_env *env, int regno)
> +{
> +       struct bpf_verifier_state *st = env->cur_state, *parent = st->parent;
> +       int last_idx = env->insn_idx;
> +       int first_idx = st->first_insn_idx;
> +       struct bpf_func_state *func;
> +       struct bpf_reg_state *reg;
> +       u32 reg_mask = 1u << regno;
> +       u64 stack_mask = 0;
> +       int i, err;

reverse Christmas tree :)

> +
> +       func = st->frame[st->curframe];
> +       reg = &func->regs[regno];
> +       if (reg->type != SCALAR_VALUE) {

<snip>

> +                       }
> +               }
> +               st = parent;

not sure why you need parent variable, just st = st->parent

> +               if (!st)
> +                       break;
> +

<snip>

> +
> +               if (!new_marks)
> +                       break;
> +
> +               parent = st->parent;
> +               last_idx = st->last_insn_idx;
> +               first_idx = st->first_insn_idx;
> +       }
> +       return 0;
> +}
> +
>  static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
>                           enum bpf_arg_type arg_type,
>                           struct bpf_call_arg_meta *meta)
> @@ -2925,6 +3334,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
>                 err = check_helper_mem_access(env, regno - 1,
>                                               reg->umax_value,
>                                               zero_size_allowed, meta);
> +               if (!err)
> +                       err = mark_chain_precision(env, regno);
>         } else if (arg_type_is_int_ptr(arg_type)) {
>                 int size = int_ptr_type_to_size(arg_type);
>
> @@ -4120,6 +4531,9 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
>                 return 0;
>         }
>
> +       if (src_reg.precise)
> +               dst_reg->precise = true;

This doesn't seem necessary and correct. If dst_reg is never used in a
precise context, then it doesn't have to be precise.

But if you insist on marking it here, you'd have to do backtracking for dst_reg.

> +
>         switch (opcode) {
>         case BPF_ADD:
>                 ret = sanitize_val_alu(env, insn);

<snip>
