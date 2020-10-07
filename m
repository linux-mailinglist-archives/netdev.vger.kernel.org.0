Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB712285684
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 03:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgJGB41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 21:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgJGB40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 21:56:26 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C56CC061755;
        Tue,  6 Oct 2020 18:56:26 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x8so618344ybe.12;
        Tue, 06 Oct 2020 18:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xE0ibBtZ2WSUlXqnnWufMzxMJieP9ycNKV8xvKBr3R8=;
        b=HUaUxeL+Vv7W7jFXDVC2oB5gN9hBbBqkrUHSQo+udc13ZZcqMra2NDqZuKvNNm8BAn
         7gnJhWKWUDQLBw4IoPRUyqYl5GxDU6a/n9Yg02g6KVKtlXDZkGY3kyzriJ0fSn+W1+OQ
         gbhEqvdct5qsMlZU5iY1RPgMFwu0xE31kw1s9SJyLwVl5T68VVFP1QCI029MI4nQTW7Y
         RFg/1QiVhA/Q2LYm8LPElvb4sN+B62ZqOaT0xWIgm/vi4SNxAaTMhotrEsxOQdui4/GL
         SOqL1qLLRmI6wiiuAs0YT84Pt+nWUMeOv6UYI1AY76L04agu0XkTifCFZ2/hZfmP+OKe
         BLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xE0ibBtZ2WSUlXqnnWufMzxMJieP9ycNKV8xvKBr3R8=;
        b=SFYqkqOZGx5xgsFBuwaP/27vbq1JtuW0seW/YZNsdL0qHXEKvs2hFr/ESt+uSoGIRP
         QcTZgmGULnvqa2Lkmt6fk0vc/UaI2k2Pq890Q3edRm9kuT1d40u33NLz71T7Ktlrjtqo
         7MAVoMBR3Gpk7cQEJURW3Z5RFGx5YqJOiazhwK8/oXVViB/2nStyev647Hk4eH59crAO
         4HhA4RFNht43joGzSRak278Yht3dY5uFO4MLLFls6xlE3TTmyfE1YbJqHIckTxGuYOHC
         nE+ICLCd9X7VuNqsUs7L5y1JFZGTSWNIfUVXM2TmW9So7fLzFEMdzgs9f9QA0iuQ6KsR
         vocQ==
X-Gm-Message-State: AOAM5313Nj0Htz4VdGWmuxd+FZOwNUsVkqF+3DdXbtfOzspDEq4nJYLO
        WDgNJQSsjbiSJg86t++XdmGHhKvDKzIBxAuIgS+o7nbfnQKamQ==
X-Google-Smtp-Source: ABdhPJy/u0yh23tnFYFDbBOpBVN382GCcbq8Vy+bVKiwa1F6BxI5tLeAdkFD/lR1pL2ddB1SfHQ0HMdjDedPCOH+jLc=
X-Received: by 2002:a25:2f43:: with SMTP id v64mr1318178ybv.27.1602035785582;
 Tue, 06 Oct 2020 18:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com> <20201006200955.12350-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20201006200955.12350-2-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Oct 2020 18:56:14 -0700
Message-ID: <CAEf4BzbRLLJ=r3LJfQbkkXtXgNqQL3Sr01ibhOaxNN-QDqiXdw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Propagate scalar ranges through
 register assignments.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 1:14 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> The llvm register allocator may use two different registers representing the
> same virtual register. In such case the following pattern can be observed:
> 1047: (bf) r9 = r6
> 1048: (a5) if r6 < 0x1000 goto pc+1
> 1050: ...
> 1051: (a5) if r9 < 0x2 goto pc+66
> 1052: ...
> 1053: (bf) r2 = r9 /* r2 needs to have upper and lower bounds */
>
> In order to track this information without backtracking allocate ID
> for scalars in a similar way as it's done for find_good_pkt_pointers().
>
> When the verifier encounters r9 = r6 assignment it will assign the same ID
> to both registers. Later if either register range is narrowed via conditional
> jump propagate the register state into the other register.
>
> Clear register ID in adjust_reg_min_max_vals() for any alu instruction.
>
> Newly allocated register ID is ignored for scalars in regsafe() and doesn't
> affect state pruning. mark_reg_unknown() also clears the ID.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

I couldn't find the problem with the logic, though it's quite
non-obvious at times that reg->id will be cleared on BPF_END/BPF_NEG
and few other operations. But I think naming of this function can be
improved, see below.

Also, profiler.c is great, but it would still be nice to add selftest
to test_verifier that will explicitly test the logic in this patch

>  kernel/bpf/verifier.c                         | 38 +++++++++++++++++++
>  .../testing/selftests/bpf/prog_tests/align.c  | 16 ++++----
>  .../bpf/verifier/direct_packet_access.c       |  2 +-
>  3 files changed, 47 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 01120acab09a..09e17b483b0b 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -6432,6 +6432,8 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
>         src_reg = NULL;
>         if (dst_reg->type != SCALAR_VALUE)
>                 ptr_reg = dst_reg;
> +       else
> +               dst_reg->id = 0;
>         if (BPF_SRC(insn->code) == BPF_X) {
>                 src_reg = &regs[insn->src_reg];
>                 if (src_reg->type != SCALAR_VALUE) {
> @@ -6565,6 +6567,8 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
>                                 /* case: R1 = R2
>                                  * copy register state to dest reg
>                                  */
> +                               if (src_reg->type == SCALAR_VALUE)
> +                                       src_reg->id = ++env->id_gen;
>                                 *dst_reg = *src_reg;
>                                 dst_reg->live |= REG_LIVE_WRITTEN;
>                                 dst_reg->subreg_def = DEF_NOT_SUBREG;
> @@ -7365,6 +7369,30 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
>         return true;
>  }
>
> +static void find_equal_scalars(struct bpf_verifier_state *vstate,
> +                              struct bpf_reg_state *known_reg)

this is double-misleading name:

1) it's not just "find", but also "update" (or rather the purpose of
this function is specifically to update registers, not find them, as
we don't really return found register)
2) "equal" is not exactly true either. You can have two scalar
register with exactly the same state, but they might not share ->id.
So it's less about being equal, rather being "linked" by assignment.

> +{
> +       struct bpf_func_state *state;
> +       struct bpf_reg_state *reg;
> +       int i, j;
> +
> +       for (i = 0; i <= vstate->curframe; i++) {
> +               state = vstate->frame[i];
> +               for (j = 0; j < MAX_BPF_REG; j++) {
> +                       reg = &state->regs[j];
> +                       if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
> +                               *reg = *known_reg;
> +               }
> +
> +               bpf_for_each_spilled_reg(j, state, reg) {
> +                       if (!reg)
> +                               continue;
> +                       if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
> +                               *reg = *known_reg;
> +               }
> +       }
> +}
> +
>  static int check_cond_jmp_op(struct bpf_verifier_env *env,
>                              struct bpf_insn *insn, int *insn_idx)
>  {
> @@ -7493,6 +7521,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
>                                 reg_combine_min_max(&other_branch_regs[insn->src_reg],
>                                                     &other_branch_regs[insn->dst_reg],
>                                                     src_reg, dst_reg, opcode);
> +                       if (src_reg->id) {
> +                               find_equal_scalars(this_branch, src_reg);
> +                               find_equal_scalars(other_branch, &other_branch_regs[insn->src_reg]);
> +                       }
> +
>                 }
>         } else if (dst_reg->type == SCALAR_VALUE) {
>                 reg_set_min_max(&other_branch_regs[insn->dst_reg],
> @@ -7500,6 +7533,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
>                                         opcode, is_jmp32);
>         }
>
> +       if (dst_reg->type == SCALAR_VALUE && dst_reg->id) {
> +               find_equal_scalars(this_branch, dst_reg);
> +               find_equal_scalars(other_branch, &other_branch_regs[insn->dst_reg]);

will this cover the case above where reg_combine_min_max() can update
dst_reg's as well? Even if yes, it probably would be more
straightforward to call appropriate updates in the respective if
branches (it's just a single line for each register, so not like it's
duplicating tons of code). It will make reasoning about this logic
easier, IMO. Also, moving reg->id check into find_equal_scalars()
would make the above suggestion even cleaner.

> +       }
> +
>         /* detect if R == 0 where R is returned from bpf_map_lookup_elem().
>          * NOTE: these optimizations below are related with pointer comparison
>          *       which will never be JMP32.

[...]
