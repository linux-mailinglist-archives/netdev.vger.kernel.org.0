Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A535A52A
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfF1Td0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:33:26 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39109 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfF1TdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:33:25 -0400
Received: by mail-qk1-f194.google.com with SMTP id i125so5847657qkd.6;
        Fri, 28 Jun 2019 12:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PWV20pGsb2kkeos2+QJZtrMeettrMpqYlwEjHm1ITkY=;
        b=tOGU+MBr/sXGQI0s1DVxl+kar9N1GTVxSGGQNO2p/Aa0dNUh1WLcMFqOuU39voJSa/
         qxWmYdWf/ZdIiDtNKri0zwf3vDBxBGbUFSc4356BYuIr2wBkvYmxniq38V1LlUruy/py
         YGiR297PFZmqCOI3bZd8XcJGR7zkWWBmkox9al/mEOt/N4BZd1+k4HB4ylpxs9l7Gwfk
         gQGeiyLvWnbbh16EtCJTgLQbEA3lRlzVMHK23M2l+x4FNAVXW2JxVfIK/+V4QnFIB7XB
         +R/z8LASYWKy0JF4yDEjGNtHlX0oEzqBLEbTd1Qu4xA4IXGNq/e6JpZQYuPAzp7cY7Qi
         SGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PWV20pGsb2kkeos2+QJZtrMeettrMpqYlwEjHm1ITkY=;
        b=D9nF/+t0povM+sTXBi9CRLzVWeKK53apa5RbpQs/5FOohO50qnBm2Jf3SETH8tQIjH
         6U1cyjdP68M1HmPTHtEaxe79uS5VXzDA3Uw+dEeiOeSmtF3c3+lxfgg0/abcov0PBzR9
         pkM2li5rt6PhjqtCXAGofCu9DiJ3YCH1sKXf20ASz6iE4iHI6noMKVQOzGeUYnCeO0nh
         hqiYDupR4edatAv58BNKVpfv0+DaBEsit1ZeIJAzaGlmxS7lxjTLSnS9EPWaTcFqzPmz
         tDsq93sB4xDaUK7qqTL/2t0odKaFxLus531yNprfHZmbP0FgMsbw1cWLGFo/uSJl9B1b
         OP/Q==
X-Gm-Message-State: APjAAAX4Flot0WEPz9Nf8g0gs/m+IWficcHW8uOhl7Bks9l/nDWadR2t
        ZKR5WkYJyaupijspgdcJYlgD8DhslXoEqrlEDxY=
X-Google-Smtp-Source: APXvYqwArtKvcttK8Mm9sCn3F7ZH59kNaR+VIQbHuYHz9AFFdO8ZjdCgfHZXS043C31AVkhiUxptiDO5YIsElmeI8Tw=
X-Received: by 2002:a37:bf42:: with SMTP id p63mr1699313qkf.437.1561750404228;
 Fri, 28 Jun 2019 12:33:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190628162409.2513499-1-ast@kernel.org>
In-Reply-To: <20190628162409.2513499-1-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 28 Jun 2019 12:33:13 -0700
Message-ID: <CAEf4BzY00WVr452Pj1JDMSG4nD47uexp+G+zHZxijZmSS1bUKw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix precision tracking
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 9:25 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> When equivalent state is found the current state needs to propagate precision marks.
> Otherwise the verifier will prune the search incorrectly.
>
> There is a price for correctness:
>                       before      before    broken    fixed
>                       cnst spill  precise   precise
> bpf_lb-DLB_L3.o       1923        8128      1863      1898
> bpf_lb-DLB_L4.o       3077        6707      2468      2666
> bpf_lb-DUNKNOWN.o     1062        1062      544       544
> bpf_lxc-DDROP_ALL.o   166729      380712    22629     36823
> bpf_lxc-DUNKNOWN.o    174607      440652    28805     45325
> bpf_netdev.o          8407        31904     6801      7002
> bpf_overlay.o         5420        23569     4754      4858
> bpf_lxc_jit.o         39389       359445    50925     69631
> Overall precision tracking is still very effective.
>
> Fixes: b5dc0163d8fd ("bpf: precise scalar_value tracking")
> Reported-by: Lawrence Brakmo <brakmo@fb.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---


Acked-by: Andrii Nakryiko <andriin@fb.com>


> Sending the fix early w/o tests, since I'm traveling.
> Will add proper tests when I'm back.
> ---
>  kernel/bpf/verifier.c | 121 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 107 insertions(+), 14 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 6b5623d320f9..62afc4058ced 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1659,16 +1659,18 @@ static void mark_all_scalars_precise(struct bpf_verifier_env *env,
>                 }
>  }
>
> -static int mark_chain_precision(struct bpf_verifier_env *env, int regno)
> +static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
> +                                 int spi)
>  {
>         struct bpf_verifier_state *st = env->cur_state;
>         int first_idx = st->first_insn_idx;
>         int last_idx = env->insn_idx;
>         struct bpf_func_state *func;
>         struct bpf_reg_state *reg;
> -       u32 reg_mask = 1u << regno;
> -       u64 stack_mask = 0;
> +       u32 reg_mask = regno >= 0 ? 1u << regno : 0;
> +       u64 stack_mask = spi >= 0 ? 1ull << spi : 0;
>         bool skip_first = true;
> +       bool new_marks = false;
>         int i, err;
>
>         if (!env->allow_ptr_leaks)
> @@ -1676,18 +1678,43 @@ static int mark_chain_precision(struct bpf_verifier_env *env, int regno)
>                 return 0;
>
>         func = st->frame[st->curframe];
> -       reg = &func->regs[regno];
> -       if (reg->type != SCALAR_VALUE) {
> -               WARN_ONCE(1, "backtracing misuse");
> -               return -EFAULT;
> +       if (regno >= 0) {
> +               reg = &func->regs[regno];
> +               if (reg->type != SCALAR_VALUE) {
> +                       WARN_ONCE(1, "backtracing misuse");
> +                       return -EFAULT;
> +               }
> +               if (!reg->precise)
> +                       new_marks = true;
> +               else
> +                       reg_mask = 0;
> +               reg->precise = true;
>         }
> -       if (reg->precise)
> -               return 0;
> -       func->regs[regno].precise = true;
>
> +       while (spi >= 0) {
> +               if (func->stack[spi].slot_type[0] != STACK_SPILL) {
> +                       stack_mask = 0;
> +                       break;
> +               }
> +               reg = &func->stack[spi].spilled_ptr;
> +               if (reg->type != SCALAR_VALUE) {
> +                       stack_mask = 0;
> +                       break;
> +               }
> +               if (!reg->precise)
> +                       new_marks = true;
> +               else
> +                       stack_mask = 0;
> +               reg->precise = true;
> +               break;
> +       }
> +
> +       if (!new_marks)
> +               return 0;
> +       if (!reg_mask && !stack_mask)
> +               return 0;
>         for (;;) {
>                 DECLARE_BITMAP(mask, 64);
> -               bool new_marks = false;
>                 u32 history = st->jmp_history_cnt;
>
>                 if (env->log.level & BPF_LOG_LEVEL)
> @@ -1730,12 +1757,15 @@ static int mark_chain_precision(struct bpf_verifier_env *env, int regno)
>                 if (!st)
>                         break;
>
> +               new_marks = false;
>                 func = st->frame[st->curframe];
>                 bitmap_from_u64(mask, reg_mask);
>                 for_each_set_bit(i, mask, 32) {
>                         reg = &func->regs[i];
> -                       if (reg->type != SCALAR_VALUE)
> +                       if (reg->type != SCALAR_VALUE) {
> +                               reg_mask &= ~(1u << i);
>                                 continue;
> +                       }
>                         if (!reg->precise)
>                                 new_marks = true;
>                         reg->precise = true;
> @@ -1756,11 +1786,15 @@ static int mark_chain_precision(struct bpf_verifier_env *env, int regno)
>                                 return -EFAULT;
>                         }
>
> -                       if (func->stack[i].slot_type[0] != STACK_SPILL)
> +                       if (func->stack[i].slot_type[0] != STACK_SPILL) {
> +                               stack_mask &= ~(1ull << i);
>                                 continue;
> +                       }
>                         reg = &func->stack[i].spilled_ptr;
> -                       if (reg->type != SCALAR_VALUE)
> +                       if (reg->type != SCALAR_VALUE) {
> +                               stack_mask &= ~(1ull << i);
>                                 continue;
> +                       }
>                         if (!reg->precise)
>                                 new_marks = true;
>                         reg->precise = true;
> @@ -1772,6 +1806,8 @@ static int mark_chain_precision(struct bpf_verifier_env *env, int regno)
>                                 reg_mask, stack_mask);
>                 }
>
> +               if (!reg_mask && !stack_mask)
> +                       break;
>                 if (!new_marks)
>                         break;
>
> @@ -1781,6 +1817,15 @@ static int mark_chain_precision(struct bpf_verifier_env *env, int regno)
>         return 0;
>  }
>
> +static int mark_chain_precision(struct bpf_verifier_env *env, int regno)
> +{
> +       return __mark_chain_precision(env, regno, -1);
> +}
> +
> +static int mark_chain_precision_stack(struct bpf_verifier_env *env, int spi)
> +{
> +       return __mark_chain_precision(env, -1, spi);
> +}
>
>  static bool is_spillable_regtype(enum bpf_reg_type type)
>  {
> @@ -7114,6 +7159,46 @@ static int propagate_liveness(struct bpf_verifier_env *env,
>         return 0;
>  }
>
> +/* find precise scalars in the previous equivalent state and
> + * propagate them into the current state
> + */
> +static int propagate_precision(struct bpf_verifier_env *env,
> +                              const struct bpf_verifier_state *old)
> +{
> +       struct bpf_reg_state *state_reg;
> +       struct bpf_func_state *state;
> +       int i, err = 0;
> +
> +       state = old->frame[old->curframe];
> +       state_reg = state->regs;
> +       for (i = 0; i < BPF_REG_FP; i++, state_reg++) {
> +               if (state_reg->type != SCALAR_VALUE ||
> +                   !state_reg->precise)
> +                       continue;
> +               if (env->log.level & BPF_LOG_LEVEL2)
> +                       verbose(env, "propagating r%d\n", i);
> +               err = mark_chain_precision(env, i);
> +               if (err < 0)
> +                       return err;
> +       }
> +
> +       for (i = 0; i < state->allocated_stack / BPF_REG_SIZE; i++) {
> +               if (state->stack[i].slot_type[0] != STACK_SPILL)
> +                       continue;
> +               state_reg = &state->stack[i].spilled_ptr;
> +               if (state_reg->type != SCALAR_VALUE ||
> +                   !state_reg->precise)
> +                       continue;
> +               if (env->log.level & BPF_LOG_LEVEL2)
> +                       verbose(env, "propagating fp%d\n",
> +                               (-i - 1) * BPF_REG_SIZE);
> +               err = mark_chain_precision_stack(env, i);
> +               if (err < 0)
> +                       return err;
> +       }
> +       return 0;
> +}
> +
>  static bool states_maybe_looping(struct bpf_verifier_state *old,
>                                  struct bpf_verifier_state *cur)
>  {
> @@ -7206,6 +7291,14 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>                          * this state and will pop a new one.
>                          */
>                         err = propagate_liveness(env, &sl->state, cur);
> +
> +                       /* if previous state reached the exit with precision and
> +                        * current state is equivalent to it (except precsion marks)
> +                        * the precision needs to be propagated back in
> +                        * the current state.
> +                        */
> +                       err = err ? : push_jmp_history(env, cur);
> +                       err = err ? : propagate_precision(env, &sl->state);
>                         if (err)
>                                 return err;
>                         return 1;
> --
> 2.20.0
>
