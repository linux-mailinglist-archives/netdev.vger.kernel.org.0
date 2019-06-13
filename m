Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD4744EAC
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfFMVqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:46:25 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42706 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfFMVqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:46:25 -0400
Received: by mail-qt1-f194.google.com with SMTP id s15so170411qtk.9;
        Thu, 13 Jun 2019 14:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WXIqnQ0WyURJPSuZiE9Vtw5ANVrD2SEyUgQ8Hc2/f8I=;
        b=MnTL8vGnKB4DTEnrFst/u9tJ+AFIDXLzEUuNcrQeIw2qFKsxQCBK0l+r81iIqdx4aF
         lXqLazJrW+H+v9jGaNqRDOYlVyhAAv+wfgP0ah/Oj43fbX0KhdXidB/C5XmJl5jspbFr
         id+K2Z+X/psTp3kJQjWvYdAjFeESLuUC4UwjZ+olkrJZkkAn3CkCInXRrmmUyT26CMee
         jegDts+m4AV3D2tjxk3NVMGYHZyJ2dZY7V8TjurYPc08VdQm9q9TeTykj9uGGra666bi
         /x4PH648Vaw6V6M2R1a4QwQjioMMIsj1JgCDYOtS1GYL68Wkg0ejM5cY9jsbzX/cPkni
         jCyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WXIqnQ0WyURJPSuZiE9Vtw5ANVrD2SEyUgQ8Hc2/f8I=;
        b=AO/iK0UtD7TpfQpYwRCwNSDwNnshNB6i/RmLJsKK95rLOmNT0YQOKhKW5bQAEHlheI
         sxLKGiL2W+DOB0zMiCJXqdg4mbx4dDw3bJk/0t6bpFYF9es13vtHc3Ny+tilluU888YQ
         kY16NpSixeIRLzt02+akfZiIRa2wsdSzBzrXMfbOzpFopsBBCr24woCVtC3ypimYWJIG
         3wXu/vcNANO9wSiEe6XesCpDhbFWgZafPCMO+EgwhH4aeFPS9hCdvXisQc1jsyc6hqak
         r3BWObfhqdYTMN50Rar/S5H12DC9qN5drPK/04huK11MpjFAJZgniZ6wmd4E3mK62rxW
         sQEA==
X-Gm-Message-State: APjAAAVZyr4XPpWNc/O011AnNWqy+dDOq0/0Ft4bnxOze2+jc2svXYok
        ows3Re1mVNAElTVKHT2WlTq5tEHlnBVAscgJzGY=
X-Google-Smtp-Source: APXvYqzSGAC6pSpCMLlq1rIGfy53hXSCDOHSxOCAFzLfsW+8/voaCIK0N3xkf6gDoydAWm6SnxrU4LRTAjXFxIknETc=
X-Received: by 2002:a0c:d0fc:: with SMTP id b57mr5347275qvh.78.1560462384070;
 Thu, 13 Jun 2019 14:46:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190613042003.3791852-1-ast@kernel.org> <20190613042003.3791852-2-ast@kernel.org>
In-Reply-To: <20190613042003.3791852-2-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Jun 2019 14:46:12 -0700
Message-ID: <CAEf4BzYR+PzdTwEsCr_H6yX=jH3-9g-_9GOJMZV8wNw1+OkMoA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/9] bpf: track spill/fill of constants
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
> Compilers often spill induction variables into the stack,
> hence it is necessary for the verifier to track scalar values
> of the registers through stack slots.
>
> Also few bpf programs were incorrectly rejected in the past,
> since the verifier was not able to track such constants while
> they were used to compute offsets into packet headers.
>
> Tracking constants through the stack significantly decreases
> the chances of state pruning, since two different constants
> are considered to be different by state equivalency.
> End result that cilium tests suffer serious degradation in the number
> of states processed and corresponding verification time increase.
>
>                      before  after
> bpf_lb-DLB_L3.o      1838    6441
> bpf_lb-DLB_L4.o      3218    5908
> bpf_lb-DUNKNOWN.o    1064    1064
> bpf_lxc-DDROP_ALL.o  26935   93790
> bpf_lxc-DUNKNOWN.o   34439   123886
> bpf_netdev.o         9721    31413
> bpf_overlay.o        6184    18561
> bpf_lxc_jit.o        39389   359445
>
> After further debugging turned out that cillium progs are
> getting hurt by clang due to the same constant tracking issue.
> Newer clang generates better code by spilling less to the stack.
> Instead it keeps more constants in the registers which
> hurts state pruning since the verifier already tracks constants
> in the registers:
>                   old clang  new clang
>                          (no spill/fill tracking introduced by this patch)
> bpf_lb-DLB_L3.o      1838    1923
> bpf_lb-DLB_L4.o      3218    3077
> bpf_lb-DUNKNOWN.o    1064    1062
> bpf_lxc-DDROP_ALL.o  26935   166729
> bpf_lxc-DUNKNOWN.o   34439   174607
> bpf_netdev.o         9721    8407
> bpf_overlay.o        6184    5420
> bpf_lcx_jit.o        39389   39389
>
> The final table is depressing:
>                   old clang  old clang    new clang  new clang
>                            const spill/fill        const spill/fill
> bpf_lb-DLB_L3.o      1838    6441          1923      8128
> bpf_lb-DLB_L4.o      3218    5908          3077      6707
> bpf_lb-DUNKNOWN.o    1064    1064          1062      1062
> bpf_lxc-DDROP_ALL.o  26935   93790         166729    380712
> bpf_lxc-DUNKNOWN.o   34439   123886        174607    440652
> bpf_netdev.o         9721    31413         8407      31904
> bpf_overlay.o        6184    18561         5420      23569
> bpf_lxc_jit.o        39389   359445        39389     359445
>
> Tracking constants in the registers hurts state pruning already.
> Adding tracking of constants through stack hurts pruning even more.
> The later patch address this general constant tracking issue
> with coarse/precise logic.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/verifier.c | 67 +++++++++++++++++++++++++++++++++----------
>  1 file changed, 52 insertions(+), 15 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 8d1786357a09..a21bafd7d931 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1378,6 +1378,11 @@ static bool register_is_null(struct bpf_reg_state *reg)
>         return reg->type == SCALAR_VALUE && tnum_equals_const(reg->var_off, 0);
>  }
>
> +static bool register_is_const(struct bpf_reg_state *reg)
> +{
> +       return reg->type == SCALAR_VALUE && tnum_is_const(reg->var_off);
> +}
> +
>  /* check_stack_read/write functions track spill/fill of registers,
>   * stack boundary and alignment are checked in check_mem_access()
>   */
> @@ -1387,7 +1392,7 @@ static int check_stack_write(struct bpf_verifier_env *env,
>  {
>         struct bpf_func_state *cur; /* state of the current function */
>         int i, slot = -off - 1, spi = slot / BPF_REG_SIZE, err;
> -       enum bpf_reg_type type;
> +       struct bpf_reg_state *reg = NULL;
>
>         err = realloc_func_state(state, round_up(slot + 1, BPF_REG_SIZE),
>                                  state->acquired_refs, true);
> @@ -1404,27 +1409,37 @@ static int check_stack_write(struct bpf_verifier_env *env,
>         }
>
>         cur = env->cur_state->frame[env->cur_state->curframe];
> -       if (value_regno >= 0 &&
> -           is_spillable_regtype((type = cur->regs[value_regno].type))) {
> +       if (value_regno >= 0)
> +               reg = &cur->regs[value_regno];
>
> +       if (reg && size == BPF_REG_SIZE && register_is_const(reg) &&
> +           !tnum_equals_const(reg->var_off, 0)) {

nit: using !register_is_null(reg) check instead would be a good
counterpart to STACK_ZERO logic below.

> +               goto save_reg_state;

This goto business is ugly, why not extracting register spilling logic
into separate function?

> +       } else if (reg && is_spillable_regtype(reg->type)) {
>                 /* register containing pointer is being spilled into stack */
>                 if (size != BPF_REG_SIZE) {
> +                       verbose_linfo(env, insn_idx, "; ");
>                         verbose(env, "invalid size of register spill\n");
>                         return -EACCES;
>                 }
>
> -               if (state != cur && type == PTR_TO_STACK) {
> +               if (state != cur && reg->type == PTR_TO_STACK) {
>                         verbose(env, "cannot spill pointers to stack into stack frame of the caller\n");
>                         return -EINVAL;
>                 }
>
> -               /* save register state */
> -               state->stack[spi].spilled_ptr = cur->regs[value_regno];
> -               state->stack[spi].spilled_ptr.live |= REG_LIVE_WRITTEN;
> +               if (!env->allow_ptr_leaks) {
> +                       bool sanitize = false;
>
> -               for (i = 0; i < BPF_REG_SIZE; i++) {
> -                       if (state->stack[spi].slot_type[i] == STACK_MISC &&
> -                           !env->allow_ptr_leaks) {
> +                       if (state->stack[spi].slot_type[0] == STACK_SPILL &&
> +                           register_is_const(&state->stack[spi].spilled_ptr))
> +                               sanitize = true;
> +                       for (i = 0; i < BPF_REG_SIZE; i++)
> +                               if (state->stack[spi].slot_type[i] == STACK_MISC) {
> +                                       sanitize = true;
> +                                       break;
> +                               }
> +                       if (sanitize) {
>                                 int *poff = &env->insn_aux_data[insn_idx].sanitize_stack_off;
>                                 int soff = (-spi - 1) * BPF_REG_SIZE;
>
> @@ -1447,8 +1462,14 @@ static int check_stack_write(struct bpf_verifier_env *env,
>                                 }
>                                 *poff = soff;
>                         }
> -                       state->stack[spi].slot_type[i] = STACK_SPILL;
>                 }
> +save_reg_state:
> +               /* save register state */
> +               state->stack[spi].spilled_ptr = *reg;
> +               state->stack[spi].spilled_ptr.live |= REG_LIVE_WRITTEN;
> +
> +               for (i = 0; i < BPF_REG_SIZE; i++)
> +                       state->stack[spi].slot_type[i] = STACK_SPILL;
>         } else {
>                 u8 type = STACK_MISC;
>
> @@ -1471,8 +1492,7 @@ static int check_stack_write(struct bpf_verifier_env *env,
>                         state->stack[spi].spilled_ptr.live |= REG_LIVE_WRITTEN;
>
>                 /* when we zero initialize stack slots mark them as such */
> -               if (value_regno >= 0 &&
> -                   register_is_null(&cur->regs[value_regno]))
> +               if (reg && register_is_null(reg))
>                         type = STACK_ZERO;
>
>                 /* Mark slots affected by this stack write. */
> @@ -1501,7 +1521,15 @@ static int check_stack_read(struct bpf_verifier_env *env,
>
>         if (stype[0] == STACK_SPILL) {
>                 if (size != BPF_REG_SIZE) {
> -                       verbose(env, "invalid size of register spill\n");
> +                       if (reg_state->stack[spi].spilled_ptr.type == SCALAR_VALUE) {

spilled_ptr is misleading now, how about renaming to spilled_reg?

> +                               if (value_regno >= 0) {
> +                                       mark_reg_unknown(env, state->regs, value_regno);
> +                                       state->regs[value_regno].live |= REG_LIVE_WRITTEN;
> +                               }
> +                               goto mark_read;

Again, not liking unnecessary gotos. How about this logic:

if (size != BPF_REG_SIZE && reg_state->stack[spi].spilled_ptr.type !=
SCALAR_VALUE) {
 ... log and return -EACCESS ...
}

// loop to check STACK_SPILL (it doesn't hurt for SCALAR_VALUE, right?)

if (value_regno >= 0) {
        if (size != BPF_REG_SIZE)
                mark_reg_unknown(env, state->regs, value_regno);
        else
                state->regs[value_regno] = reg_state->stack[spi].spilled_ptr;
        state->regs[value_regno].live |= REG_LIVE_WRITTEN;
}

// mark_reg_read here


it's more linear and clearly shows that for partial reads of constants
we set to unknown, otherwise restore state completely.


> +                       }
> +                       verbose_linfo(env, env->insn_idx, "; ");
> +                       verbose(env, "invalid size of register fill\n");
>                         return -EACCES;
>                 }
>                 for (i = 1; i < BPF_REG_SIZE; i++) {
> @@ -1520,6 +1548,7 @@ static int check_stack_read(struct bpf_verifier_env *env,
>                          */
>                         state->regs[value_regno].live |= REG_LIVE_WRITTEN;
>                 }
> +mark_read:
>                 mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
>                               reg_state->stack[spi].spilled_ptr.parent,
>                               REG_LIVE_READ64);
> @@ -2415,7 +2444,7 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
>  {
>         struct bpf_reg_state *reg = reg_state(env, regno);
>         struct bpf_func_state *state = func(env, reg);
> -       int err, min_off, max_off, i, slot, spi;
> +       int err, min_off, max_off, i, j, slot, spi;
>
>         if (reg->type != PTR_TO_STACK) {
>                 /* Allow zero-byte read from NULL, regardless of pointer type */
> @@ -2503,6 +2532,14 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
>                         *stype = STACK_MISC;
>                         goto mark;
>                 }
> +               if (state->stack[spi].slot_type[0] == STACK_SPILL &&
> +                   state->stack[spi].spilled_ptr.type == SCALAR_VALUE) {
> +                       __mark_reg_unknown(&state->stack[spi].spilled_ptr);
> +                       for (j = 0; j < BPF_REG_SIZE; j++)
> +                               state->stack[spi].slot_type[j] = STACK_MISC;
> +                       goto mark;
> +               }
> +
>  err:
>                 if (tnum_is_const(reg->var_off)) {
>                         verbose(env, "invalid indirect read from stack off %d+%d size %d\n",
> --
> 2.20.0
>
