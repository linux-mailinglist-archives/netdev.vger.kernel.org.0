Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070C5341114
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhCRXdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbhCRXdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:33:00 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68A4C06174A;
        Thu, 18 Mar 2021 16:32:59 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id b10so4354155ybn.3;
        Thu, 18 Mar 2021 16:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iG/J3ef9xo3MWc4eNMhzrhm+DEpfeiWOyDGzWrFTOqQ=;
        b=aCzErRRviv956AwAx/qrKxD5j8E155fODoO+jENXgwzJduczKxeNIFCaYQ7NKB6FfC
         XkivPJv7HknUM06dTYsPp4Qu5FdhlUMkSU+eq0ZK685clRmJ0Io9TnInqobvx0F5x2oD
         VzWcmkCKNmCG+MH502ni2tnpOYzPiOP65OQ6Ky3/s1x/HqSatI0fk92cpEC5rSvaekum
         z0pwDnl0+ABVdwJ3xTfY3gQ8FLAvrXHIBGq6865FAQq4PiY9xzDP1xHIHGqpWegz/XRA
         4FIiGf6TCuQwsi4TON2us7SfI9zoUle1sFONS7dkT+qQ6MSFYpCpgQz1XNzFK19oqCMN
         +OnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iG/J3ef9xo3MWc4eNMhzrhm+DEpfeiWOyDGzWrFTOqQ=;
        b=G9BacUeyVANawvxugt7Er4Uk97iXRCTNgL422vNDvCpXcWKVIEKxnFen9JqeEhGpP4
         MtMBAdn/JkgX0NjArkGYxtaBNq/Xi2i9G1wWI+vGy5y/h3npQQLRnpxChlJWDuCJaoWO
         Dv1QAU+cRqLCtY7MCsSUa9JxPHTIzu0m9iaEVi+enSF5gI99hCivWPcV16MHw8sma1BR
         zMPwU1SA/uBEmopXEGpzwMk0o4PsMIj65A6/HzPohedpkhc92dxRBMs44LoorTXSnwF2
         kYhh5lwu+ZeueBPJzMYhxe0G4UoUcA30XBlD6MihkO336b7NFTJ/CLh1tfhzHvUm/5j4
         xqtQ==
X-Gm-Message-State: AOAM532ODbcaCl2b4njfwGtylS0NPuECwLMmNCeEFIdkqDJWBcmZzUHF
        zgxIWX2cGojkW+fCO0BrJprttCj3JNo+gzPH4xY=
X-Google-Smtp-Source: ABdhPJwtCHYB50PC37hV5aGAqkAIteZo08fEjLFAW+f5b6OHxHST8HuK2fHbIso5pt6EZzD/sPClDTCnVWnmh4R9lh4=
X-Received: by 2002:a25:7d07:: with SMTP id y7mr2430591ybc.425.1616110378876;
 Thu, 18 Mar 2021 16:32:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011355.4176313-1-kafai@fb.com>
In-Reply-To: <20210316011355.4176313-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Mar 2021 16:32:47 -0700
Message-ID: <CAEf4BzbyKPgHC8h9z--j=h9Fw+Qd6HSgCtvPvytO5nw82FJoMQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/15] bpf: Refactor btf_check_func_arg_match
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
> This patch refactors the core logic of "btf_check_func_arg_match()"
> into a new function "do_btf_check_func_arg_match()".
> "do_btf_check_func_arg_match()" will be reused later to check
> the kernel function call.
>
> The "if (!btf_type_is_ptr(t))" is checked first to improve the indentation
> which will be useful for a later patch.
>
> Some of the "btf_kind_str[]" usages is replaced with the shortcut
> "btf_type_str(t)".
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/btf.h |   5 ++
>  kernel/bpf/btf.c    | 159 ++++++++++++++++++++++++--------------------
>  2 files changed, 91 insertions(+), 73 deletions(-)
>
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 7fabf1428093..93bf2e5225f5 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -140,6 +140,11 @@ static inline bool btf_type_is_enum(const struct btf_type *t)
>         return BTF_INFO_KIND(t->info) == BTF_KIND_ENUM;
>  }
>
> +static inline bool btf_type_is_scalar(const struct btf_type *t)
> +{
> +       return btf_type_is_int(t) || btf_type_is_enum(t);
> +}
> +
>  static inline bool btf_type_is_typedef(const struct btf_type *t)
>  {
>         return BTF_INFO_KIND(t->info) == BTF_KIND_TYPEDEF;
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 96cd24020a38..529b94b601c6 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4381,7 +4381,7 @@ static u8 bpf_ctx_convert_map[] = {
>  #undef BPF_LINK_TYPE
>
>  static const struct btf_member *
> -btf_get_prog_ctx_type(struct bpf_verifier_log *log, struct btf *btf,
> +btf_get_prog_ctx_type(struct bpf_verifier_log *log, const struct btf *btf,
>                       const struct btf_type *t, enum bpf_prog_type prog_type,
>                       int arg)
>  {
> @@ -5366,122 +5366,135 @@ int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *pr
>         return btf_check_func_type_match(log, btf1, t1, btf2, t2);
>  }
>
> -/* Compare BTF of a function with given bpf_reg_state.
> - * Returns:
> - * EFAULT - there is a verifier bug. Abort verification.
> - * EINVAL - there is a type mismatch or BTF is not available.
> - * 0 - BTF matches with what bpf_reg_state expects.
> - * Only PTR_TO_CTX and SCALAR_VALUE states are recognized.
> - */
> -int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
> -                            struct bpf_reg_state *regs)
> +static int do_btf_check_func_arg_match(struct bpf_verifier_env *env,

do_btf_check_func_arg_match vs btf_check_func_arg_match distinction is
not clear at all. How about something like

btf_check_func_arg_match vs btf_check_subprog_arg_match (or btf_func
vs bpf_subprog). I think that highlights the main distinction better,
no?

> +                                      const struct btf *btf, u32 func_id,
> +                                      struct bpf_reg_state *regs,
> +                                      bool ptr_to_mem_ok)
>  {
>         struct bpf_verifier_log *log = &env->log;
> -       struct bpf_prog *prog = env->prog;
> -       struct btf *btf = prog->aux->btf;
> -       const struct btf_param *args;
> +       const char *func_name, *ref_tname;
>         const struct btf_type *t, *ref_t;
> -       u32 i, nargs, btf_id, type_size;
> -       const char *tname;
> -       bool is_global;
> -
> -       if (!prog->aux->func_info)
> -               return -EINVAL;
> -
> -       btf_id = prog->aux->func_info[subprog].type_id;
> -       if (!btf_id)
> -               return -EFAULT;
> -
> -       if (prog->aux->func_info_aux[subprog].unreliable)
> -               return -EINVAL;
> +       const struct btf_param *args;
> +       u32 i, nargs;
>
> -       t = btf_type_by_id(btf, btf_id);
> +       t = btf_type_by_id(btf, func_id);
>         if (!t || !btf_type_is_func(t)) {
>                 /* These checks were already done by the verifier while loading
>                  * struct bpf_func_info
>                  */
> -               bpf_log(log, "BTF of func#%d doesn't point to KIND_FUNC\n",
> -                       subprog);
> +               bpf_log(log, "BTF of func_id %u doesn't point to KIND_FUNC\n",
> +                       func_id);
>                 return -EFAULT;
>         }
> -       tname = btf_name_by_offset(btf, t->name_off);
> +       func_name = btf_name_by_offset(btf, t->name_off);
>
>         t = btf_type_by_id(btf, t->type);
>         if (!t || !btf_type_is_func_proto(t)) {
> -               bpf_log(log, "Invalid BTF of func %s\n", tname);
> +               bpf_log(log, "Invalid BTF of func %s\n", func_name);
>                 return -EFAULT;
>         }
>         args = (const struct btf_param *)(t + 1);
>         nargs = btf_type_vlen(t);
>         if (nargs > MAX_BPF_FUNC_REG_ARGS) {
> -               bpf_log(log, "Function %s has %d > %d args\n", tname, nargs,
> +               bpf_log(log, "Function %s has %d > %d args\n", func_name, nargs,
>                         MAX_BPF_FUNC_REG_ARGS);
> -               goto out;
> +               return -EINVAL;
>         }
>
> -       is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
>         /* check that BTF function arguments match actual types that the
>          * verifier sees.
>          */
>         for (i = 0; i < nargs; i++) {
> -               struct bpf_reg_state *reg = &regs[i + 1];
> +               u32 regno = i + 1;
> +               struct bpf_reg_state *reg = &regs[regno];
>
> -               t = btf_type_by_id(btf, args[i].type);
> -               while (btf_type_is_modifier(t))
> -                       t = btf_type_by_id(btf, t->type);
> -               if (btf_type_is_int(t) || btf_type_is_enum(t)) {
> +               t = btf_type_skip_modifiers(btf, args[i].type, NULL);
> +               if (btf_type_is_scalar(t)) {
>                         if (reg->type == SCALAR_VALUE)
>                                 continue;
> -                       bpf_log(log, "R%d is not a scalar\n", i + 1);
> -                       goto out;
> +                       bpf_log(log, "R%d is not a scalar\n", regno);
> +                       return -EINVAL;
>                 }
> -               if (btf_type_is_ptr(t)) {
> +
> +               if (!btf_type_is_ptr(t)) {
> +                       bpf_log(log, "Unrecognized arg#%d type %s\n",
> +                               i, btf_type_str(t));
> +                       return -EINVAL;
> +               }
> +
> +               ref_t = btf_type_skip_modifiers(btf, t->type, NULL);
> +               ref_tname = btf_name_by_offset(btf, ref_t->name_off);

these two seem to be used only inside else `if (ptr_to_mem_ok)`, let's
move the code and variables inside that branch?

> +               if (btf_get_prog_ctx_type(log, btf, t, env->prog->type, i)) {
>                         /* If function expects ctx type in BTF check that caller
>                          * is passing PTR_TO_CTX.
>                          */
> -                       if (btf_get_prog_ctx_type(log, btf, t, prog->type, i)) {
> -                               if (reg->type != PTR_TO_CTX) {
> -                                       bpf_log(log,
> -                                               "arg#%d expected pointer to ctx, but got %s\n",
> -                                               i, btf_kind_str[BTF_INFO_KIND(t->info)]);
> -                                       goto out;
> -                               }
> -                               if (check_ctx_reg(env, reg, i + 1))
> -                                       goto out;
> -                               continue;
> +                       if (reg->type != PTR_TO_CTX) {
> +                               bpf_log(log,
> +                                       "arg#%d expected pointer to ctx, but got %s\n",
> +                                       i, btf_type_str(t));
> +                               return -EINVAL;
>                         }
> +                       if (check_ctx_reg(env, reg, regno))
> +                               return -EINVAL;

original code had `continue` here allowing to stop tracking if/else
logic. Any specific reason you removed it? It keeps logic simpler to
follow, imo.

> +               } else if (ptr_to_mem_ok) {

similarly to how you did reduction of nestedness with btf_type_is_ptr, I'd do

if (!ptr_to_mem_ok)
    return -EINVAL;

and let brain forget about another if/else branch tracking

> +                       const struct btf_type *resolve_ret;
> +                       u32 type_size;
>
> -                       if (!is_global)
> -                               goto out;
> -
> -                       t = btf_type_skip_modifiers(btf, t->type, NULL);
> -
> -                       ref_t = btf_resolve_size(btf, t, &type_size);
> -                       if (IS_ERR(ref_t)) {
> +                       resolve_ret = btf_resolve_size(btf, ref_t, &type_size);
> +                       if (IS_ERR(resolve_ret)) {
>                                 bpf_log(log,
> -                                   "arg#%d reference type('%s %s') size cannot be determined: %ld\n",
> -                                   i, btf_type_str(t), btf_name_by_offset(btf, t->name_off),
> -                                       PTR_ERR(ref_t));
> -                               goto out;
> +                                       "arg#%d reference type('%s %s') size cannot be determined: %ld\n",
> +                                       i, btf_type_str(ref_t), ref_tname,
> +                                       PTR_ERR(resolve_ret));
> +                               return -EINVAL;
>                         }
>
> -                       if (check_mem_reg(env, reg, i + 1, type_size))
> -                               goto out;
> -
> -                       continue;
> +                       if (check_mem_reg(env, reg, regno, type_size))
> +                               return -EINVAL;
> +               } else {
> +                       return -EINVAL;
>                 }
> -               bpf_log(log, "Unrecognized arg#%d type %s\n",
> -                       i, btf_kind_str[BTF_INFO_KIND(t->info)]);
> -               goto out;
>         }
> +
>         return 0;
> -out:
> +}
> +
> +/* Compare BTF of a function with given bpf_reg_state.
> + * Returns:
> + * EFAULT - there is a verifier bug. Abort verification.
> + * EINVAL - there is a type mismatch or BTF is not available.
> + * 0 - BTF matches with what bpf_reg_state expects.
> + * Only PTR_TO_CTX and SCALAR_VALUE states are recognized.
> + */
> +int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
> +                            struct bpf_reg_state *regs)
> +{
> +       struct bpf_prog *prog = env->prog;
> +       struct btf *btf = prog->aux->btf;
> +       bool is_global;
> +       u32 btf_id;
> +       int err;
> +
> +       if (!prog->aux->func_info)
> +               return -EINVAL;
> +
> +       btf_id = prog->aux->func_info[subprog].type_id;
> +       if (!btf_id)
> +               return -EFAULT;
> +
> +       if (prog->aux->func_info_aux[subprog].unreliable)
> +               return -EINVAL;
> +
> +       is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> +       err = do_btf_check_func_arg_match(env, btf, btf_id, regs, is_global);
> +
>         /* Compiler optimizations can remove arguments from static functions
>          * or mismatched type can be passed into a global function.
>          * In such cases mark the function as unreliable from BTF point of view.
>          */
> -       prog->aux->func_info_aux[subprog].unreliable = true;
> -       return -EINVAL;
> +       if (err == -EINVAL)
> +               prog->aux->func_info_aux[subprog].unreliable = true;

is there any harm marking it unreliable for any error? this makes it
look like -EINVAL is super-special. If it's EFAULT, it won't matter,
right?

> +       return err;
>  }
>
>  /* Convert BTF of a function into bpf_reg_state if possible
> --
> 2.30.2
>
