Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522045B0B55
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiIGRTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiIGRTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:19:36 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B88313E13;
        Wed,  7 Sep 2022 10:19:34 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id b17so7944523ilh.0;
        Wed, 07 Sep 2022 10:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=sAH9skRux/chFuQu9Rc4h8GuA7UNvAhFPO2U0LHdA7c=;
        b=OG3eeLGxpzJrb5KG5sHWN9h+9tJX1BZZDjIO5lJrc61G+3WWrDbaEQ8f6feV16fBWp
         ptn5ruffe7qN1mf69OdTBsEi7DEq1PUxtws+QTru5UFIoYL4w5H/J0PBed/dZCZObz02
         M6oZmCNroTjcVXmVuRAtZAqI7mvfN4X6L8kSYvnFOAjx+BfcZ/QD97X+LpmQuCs0sUu5
         iyajNcKZbqjQeEQjzc/SimfBmzW2hy3lodWjktaSYd+Vcc5KW3Aix9p5284NGyi5hgqQ
         beu4dJh4Qe1uy/3RrpduNYU5LyEPueeuLs5KGgAI5FwKBsjiCjTzNhbXL/E8XjoPcyXV
         klsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=sAH9skRux/chFuQu9Rc4h8GuA7UNvAhFPO2U0LHdA7c=;
        b=nz2xQC1AdxLAZBEj0qR0hLpi6Vk+inVEc+Bhr3RaZkg9spl1ds4lH3m4inatUTfyWQ
         uZs3tPzpQj0Jw/ykDtNi/mFLj/HLNdB7tKwNgZY1Us8f4GbWD+plJ4KYS5pobp6L4PBy
         iWugxqKs5jucgr3k0i1Ksp1ZGGXaDlJXYFht5j+saimqB2DlmYIU8+fwyq5V1H4mlirw
         S6af0PgAa7WJe2BF9pJ9VexDgWLcCr16UPwjCRERbUaGAQ2/g0bNxapy7Uwb8LG0zuUU
         5byIClR9T/VZ8UFs+e7rlZ+2LFBG1moHJXojaSPB97C2z0aLlE2EtwnBoqz32eQ4XJtG
         B7lQ==
X-Gm-Message-State: ACgBeo1KmobPRjRgm85Zdh8KGm4p+C6S8hB80I0fkm5OMFLfxYjuuQmR
        Hx6xt6AShxkpwJlkJ16J35qqq/8xZtacMaLLWmI=
X-Google-Smtp-Source: AA6agR6U+WYk2h4nLSnIzWFoV2UStyHu3E1LGe7APYWsBp4pvmnvLEvv+3XhA03PJTQb4hXci4Odubp5vbuUjcji0wc=
X-Received: by 2002:a05:6e02:1d0b:b0:2eb:73fc:2235 with SMTP id
 i11-20020a056e021d0b00b002eb73fc2235mr2444495ila.164.1662571173764; Wed, 07
 Sep 2022 10:19:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220906151303.2780789-1-benjamin.tissoires@redhat.com> <20220906151303.2780789-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20220906151303.2780789-3-benjamin.tissoires@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 7 Sep 2022 19:18:58 +0200
Message-ID: <CAP01T76kXAoumUt37mMEzqNU9k43mJq08jfNYMbSVN5b5sZ_fQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v11 2/7] bpf: split btf_check_subprog_arg_match
 in two
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Sept 2022 at 17:13, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> btf_check_subprog_arg_match() was used twice in verifier.c:
> - when checking for the type mismatches between a (sub)prog declaration
>   and BTF
> - when checking the call of a subprog to see if the provided arguments
>   are correct and valid
>
> This is problematic when we check if the first argument of a program
> (pointer to ctx) is correctly accessed:
> To be able to ensure we access a valid memory in the ctx, the verifier
> assumes the pointer to context is not null.
> This has the side effect of marking the program accessing the entire
> context, even if the context is never dereferenced.
>
> For example, by checking the context access with the current code, the
> following eBPF program would fail with -EINVAL if the ctx is set to null
> from the userspace:
>
> ```
> SEC("syscall")
> int prog(struct my_ctx *args) {
>   return 0;
> }
> ```
>
> In that particular case, we do not want to actually check that the memory
> is correct while checking for the BTF validity, but we just want to
> ensure that the (sub)prog definition matches the BTF we have.
>
> So split btf_check_subprog_arg_match() in two so we can actually check
> for the memory used when in a call, and ignore that part when not.
>
> Note that a further patch is in preparation to disentangled
> btf_check_func_arg_match() from these two purposes, and so right now we
> just add a new hack around that by adding a boolean to this function.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>

Given I'll fix it properly in my kfunc rework, LGTM otherwise:
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

> no changes in v11
>
> new in v10
> ---
>  include/linux/bpf.h   |  2 ++
>  kernel/bpf/btf.c      | 54 +++++++++++++++++++++++++++++++++++++++----
>  kernel/bpf/verifier.c |  2 +-
>  3 files changed, 52 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 9c1674973e03..c9c72a089579 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1943,6 +1943,8 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
>  struct bpf_reg_state;
>  int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
>                                 struct bpf_reg_state *regs);
> +int btf_check_subprog_call(struct bpf_verifier_env *env, int subprog,
> +                          struct bpf_reg_state *regs);
>  int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
>                               const struct btf *btf, u32 func_id,
>                               struct bpf_reg_state *regs,
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 903719b89238..eca9ea78ee5f 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6170,7 +6170,8 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>                                     const struct btf *btf, u32 func_id,
>                                     struct bpf_reg_state *regs,
>                                     bool ptr_to_mem_ok,
> -                                   u32 kfunc_flags)
> +                                   u32 kfunc_flags,
> +                                   bool processing_call)
>  {
>         enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
>         bool rel = false, kptr_get = false, trusted_arg = false;
> @@ -6356,7 +6357,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>                                         reg_ref_tname);
>                                 return -EINVAL;
>                         }
> -               } else if (ptr_to_mem_ok) {
> +               } else if (ptr_to_mem_ok && processing_call) {
>                         const struct btf_type *resolve_ret;
>                         u32 type_size;
>
> @@ -6431,7 +6432,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>         return rel ? ref_regno : 0;
>  }
>
> -/* Compare BTF of a function with given bpf_reg_state.
> +/* Compare BTF of a function declaration with given bpf_reg_state.
>   * Returns:
>   * EFAULT - there is a verifier bug. Abort verification.
>   * EINVAL - there is a type mismatch or BTF is not available.
> @@ -6458,7 +6459,50 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
>                 return -EINVAL;
>
>         is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> -       err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0);
> +       err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0, false);
> +
> +       /* Compiler optimizations can remove arguments from static functions
> +        * or mismatched type can be passed into a global function.
> +        * In such cases mark the function as unreliable from BTF point of view.
> +        */
> +       if (err)
> +               prog->aux->func_info_aux[subprog].unreliable = true;
> +       return err;
> +}
> +
> +/* Compare BTF of a function call with given bpf_reg_state.
> + * Returns:
> + * EFAULT - there is a verifier bug. Abort verification.
> + * EINVAL - there is a type mismatch or BTF is not available.
> + * 0 - BTF matches with what bpf_reg_state expects.
> + * Only PTR_TO_CTX and SCALAR_VALUE states are recognized.
> + *
> + * NOTE: the code is duplicated from btf_check_subprog_arg_match()
> + * because btf_check_func_arg_match() is still doing both. Once that
> + * function is split in 2, we can call from here btf_check_subprog_arg_match()
> + * first, and then treat the calling part in a new code path.
> + */
> +int btf_check_subprog_call(struct bpf_verifier_env *env, int subprog,
> +                          struct bpf_reg_state *regs)
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
> +       err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0, true);
>
>         /* Compiler optimizations can remove arguments from static functions
>          * or mismatched type can be passed into a global function.
> @@ -6474,7 +6518,7 @@ int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
>                               struct bpf_reg_state *regs,
>                               u32 kfunc_flags)
>  {
> -       return btf_check_func_arg_match(env, btf, func_id, regs, true, kfunc_flags);
> +       return btf_check_func_arg_match(env, btf, func_id, regs, true, kfunc_flags, true);
>  }
>
>  /* Convert BTF of a function into bpf_reg_state if possible
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 0194a36d0b36..d27fae3ce949 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -6626,7 +6626,7 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>         func_info_aux = env->prog->aux->func_info_aux;
>         if (func_info_aux)
>                 is_global = func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> -       err = btf_check_subprog_arg_match(env, subprog, caller->regs);
> +       err = btf_check_subprog_call(env, subprog, caller->regs);
>         if (err == -EFAULT)
>                 return err;
>         if (is_global) {
> --
> 2.36.1
>
