Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D89100B2A
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 19:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfKRSMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 13:12:10 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42802 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfKRSMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 13:12:10 -0500
Received: by mail-qk1-f196.google.com with SMTP id i3so3305240qkk.9;
        Mon, 18 Nov 2019 10:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n4Z7zKL/nC/2oGOlNfG7F22vrSZqQW3UGXLGm4v76ak=;
        b=UCblokOk3YGKqce/F/LZE9tOY7H1bLCBYT/9E0nGKKuGBZvoxWK5JURY6wl0OKlPVD
         OXnEFvMS3SEMBgaWfqyJcGsIIYejb/ZtyRmlTshJhhighNSB2sPEQ6bMTr/gR2B/zok8
         vIu45L+B2eF6F47d5hIAO4FfKbD6XOUpV+aR6YDqCfSrWI1Yg6ZnVJlTKEINpFl0TBhN
         +wZ2AnhMsk/kMAr/IY7dxMEob9N/6rssg+jzs7ml6jngZ2jr727euocKip5zoA+8TUcv
         u6m6migM+H/ZbGxpgeZpC/Ge7Ub3xgmBUKyTiKeV3xzc0jCuO4S5yNdT26BSYRqUY+rB
         it5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n4Z7zKL/nC/2oGOlNfG7F22vrSZqQW3UGXLGm4v76ak=;
        b=AwwL07dJtp3So4OrH0OxmkKKxXN7jCrK+qBCr7d1W0mNvttgRaU189tCZjkGYEd2eL
         2q0aQ87HlJiSJGYSPBkaNbQ8wpKwNq+mhB5hNPLoFufUwVW7VAdp2uTLfpAuJGb4FrKi
         jn/N59L7bEm8fA0n1GeVG6vBAM+8a6dpTK9B/kyZlM0YqhPCbqKDv0HN0dcQaLeNz/Yn
         i8tNk0/kchjiI3im2/fkz5tiVJO+CnBNrsPJln0dmCKHut868YvMpchRHaBPx8YuSr+B
         /bFViFfeYmWT9/QGKsUHYi2jVJv2CV4vb4zHhyGV/BthaKkR/YI8/Pp3wlyrCuVAAk3r
         qv2w==
X-Gm-Message-State: APjAAAUIc/hXR+UpGdMxq+MjUnOkHbLN9JRVMgdlIit16n0WCTgv0i0+
        Bkpx2XDlnXb7/VZure22anHMnqliWpVv0/19Hco=
X-Google-Smtp-Source: APXvYqxsrqYkMiwkE3iPguvNnMVibo2ivQJwDRHahowenownLByatstaFlTWOneHnJtbKU0VXb2evU3pfa7jqE1dJIU=
X-Received: by 2002:a37:9a8a:: with SMTP id c132mr12777464qke.92.1574100728885;
 Mon, 18 Nov 2019 10:12:08 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573779287.git.daniel@iogearbox.net> <fa3c2f6e2f4fbe45200d54a3c6d4c65c4f84f790.1573779287.git.daniel@iogearbox.net>
In-Reply-To: <fa3c2f6e2f4fbe45200d54a3c6d4c65c4f84f790.1573779287.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 Nov 2019 10:11:57 -0800
Message-ID: <CAEf4BzZJEgVKVZsBvHZuhQWBTN6G7zY9mQH8o5xoyrDEUNG2DA@mail.gmail.com>
Subject: Re: [PATCH rfc bpf-next 8/8] bpf: constant map key tracking for prog
 array pokes
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 5:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add tracking of constant keys into tail call maps. The signature of
> bpf_tail_call_proto is that arg1 is ctx, arg2 map pointer and arg3
> is a index key. The direct call approach for tail calls can be enabled
> if the verifier asserted that for all branches leading to the tail call
> helper invocation, the map pointer and index key were both constant
> and the same. Tracking of map pointers we already do from prior work
> via c93552c443eb ("bpf: properly enforce index mask to prevent out-of-bounds
> speculation") and 09772d92cd5a ("bpf: avoid retpoline for lookup/update/
> delete calls on maps"). Given the tail call map index key is not on
> stack but directly in the register, we can add similar tracking approach
> and later in fixup_bpf_calls() add a poke descriptor to the progs poke_tab
> with the relevant information for the JITing phase. We internally reuse
> insn->imm for the rewritten BPF_JMP | BPF_TAIL_CALL instruction in order
> to point into the prog's poke_tab and keep insn->imm == 0 as indicator
> that current indirect tail call emission must be used.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  include/linux/bpf_verifier.h |  1 +
>  kernel/bpf/verifier.c        | 98 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 99 insertions(+)
>
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index cdd08bf0ec06..f494f0c9ac13 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -301,6 +301,7 @@ struct bpf_insn_aux_data {
>                         u32 map_off;            /* offset from value base address */
>                 };
>         };
> +       u64 key_state; /* constant key tracking for maps */
>         int ctx_field_size; /* the ctx field size for load insn, maybe 0 */
>         int sanitize_stack_off; /* stack slot to be cleared */
>         bool seen; /* this insn was processed by the verifier */
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index e9dc95a18d44..48d5c9030d60 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -171,6 +171,9 @@ struct bpf_verifier_stack_elem {
>  #define BPF_COMPLEXITY_LIMIT_JMP_SEQ   8192
>  #define BPF_COMPLEXITY_LIMIT_STATES    64
>
> +#define BPF_MAP_KEY_POISON     (1ULL << 63)
> +#define BPF_MAP_KEY_SEEN       (1ULL << 62)
> +
>  #define BPF_MAP_PTR_UNPRIV     1UL
>  #define BPF_MAP_PTR_POISON     ((void *)((0xeB9FUL << 1) +     \
>                                           POISON_POINTER_DELTA))
> @@ -195,6 +198,29 @@ static void bpf_map_ptr_store(struct bpf_insn_aux_data *aux,
>                          (unpriv ? BPF_MAP_PTR_UNPRIV : 0UL);
>  }
>
> +static bool bpf_map_key_poisoned(const struct bpf_insn_aux_data *aux)
> +{
> +       return aux->key_state & BPF_MAP_KEY_POISON;
> +}
> +
> +static bool bpf_map_key_unseen(const struct bpf_insn_aux_data *aux)
> +{
> +       return !(aux->key_state & BPF_MAP_KEY_SEEN);
> +}
> +
> +static u64 bpf_map_key_immediate(const struct bpf_insn_aux_data *aux)
> +{
> +       return aux->key_state & ~BPF_MAP_KEY_SEEN;
> +}

This works out for current logic you've implemented, but it's a bit
misleading that bpf_map_key_immediate is also going to return POISON
bit, was this intentional?

> +
> +static void bpf_map_key_store(struct bpf_insn_aux_data *aux, u64 state)
> +{
> +       bool poisoned = bpf_map_key_poisoned(aux);
> +
> +       aux->key_state = state | BPF_MAP_KEY_SEEN |
> +                        (poisoned ? BPF_MAP_KEY_POISON : 0ULL);
> +}
> +
>  struct bpf_call_arg_meta {
>         struct bpf_map *map_ptr;
>         bool raw_mode;
> @@ -4088,6 +4114,37 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
>         return 0;
>  }
>
> +static int
> +record_func_key(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
> +               int func_id, int insn_idx)
> +{
> +       struct bpf_insn_aux_data *aux = &env->insn_aux_data[insn_idx];
> +       struct bpf_reg_state *regs = cur_regs(env), *reg;
> +       struct tnum range = tnum_range(0, U32_MAX);

why U32_MAX, instead of actual size of a map?

> +       struct bpf_map *map = meta->map_ptr;
> +       u64 val;
> +
> +       if (func_id != BPF_FUNC_tail_call)
> +               return 0;
> +       if (!map || map->map_type != BPF_MAP_TYPE_PROG_ARRAY) {
> +               verbose(env, "kernel subsystem misconfigured verifier\n");
> +               return -EINVAL;
> +       }
> +
> +       reg = &regs[BPF_REG_3];
> +       if (!register_is_const(reg) || !tnum_in(range, reg->var_off)) {
> +               bpf_map_key_store(aux, BPF_MAP_KEY_POISON);
> +               return 0;
> +       }
> +
> +       val = reg->var_off.value;
> +       if (bpf_map_key_unseen(aux))
> +               bpf_map_key_store(aux, val);
> +       else if (bpf_map_key_immediate(aux) != val)
> +               bpf_map_key_store(aux, BPF_MAP_KEY_POISON);

imo, checking for poison first would make this logic a bit more
straightforward (and will avoid unnecessary key_store calls, but
that's minor)

> +       return 0;
> +}
> +
>  static int check_reference_leak(struct bpf_verifier_env *env)
>  {
>         struct bpf_func_state *state = cur_func(env);

[...]
