Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C010B2782A5
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 10:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgIYIWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 04:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgIYIWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 04:22:34 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D11C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 01:22:33 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id u25so1550373otq.6
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 01:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p6FsQS5Kt2sBSsUjak4i+O4dyhH1hNZesarCuUNiA90=;
        b=y797bUbc3gIzVUQo01S+iyYVzJwuHHMlpEiGjbtdjl3ykmAbz19r7zSnQCaWXeRVVU
         WZJBUTUj/Sn0VqziUMGeOrhAuGPeMo1RjWC0JoS5gxMQBaLvyKtjZGAx2IyV7951eZBu
         yhgBnDTnc02oy+n/6KMn70mXYwjxR4y+a3ets=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p6FsQS5Kt2sBSsUjak4i+O4dyhH1hNZesarCuUNiA90=;
        b=gfOEZ7+HDNVBKZYrv1PvGHs8nGLNHGXdjv+MzW5RDC0iEwuv5LhJlm8JJKWlWvYlOn
         xonkZ4+6Fl+crY7WHrG1nfmQtqp4EsRlifPyEu4z/d4Q47gQrtthw1n7miwFeA6i26f8
         vYgBcdLOtwd+IiDz7aO0dKcl9vnJ1kOi2BHyb8cD+R39RYks8OsYHjnrT3zm/MtUNPXF
         O7VfSmlR8oUJBe0i/p3Xq4kCtJoEo6JdQCj5ef+TFdxDWpvY8Nyh6wCSGEai00Vou16H
         uJIhRQn2VRXm006N/DGoOtp8PaNceVT1TskQXTtoWAynioMKXvDuzGNzr0x+NS4/9qvz
         Ei0A==
X-Gm-Message-State: AOAM5330nwKOlSM86wTCOWmA0qp7HWILFjF1gYgyFYuJ4OoxSIKqB1J5
        5soEGYgmymOuixPveE9BISzgI6k3slyEPBumT7aeWg==
X-Google-Smtp-Source: ABdhPJyyDZKpXyEKspRt8wndDhvoPMj1pgMfs6rgJVvUI4ShNR/8cLXegDGWAdAyhCCs3JY1nGWVC879M39NoSVaxQ0=
X-Received: by 2002:a9d:6e90:: with SMTP id a16mr2051931otr.132.1601022153242;
 Fri, 25 Sep 2020 01:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200925000337.3853598-1-kafai@fb.com> <20200925000344.3854828-1-kafai@fb.com>
In-Reply-To: <20200925000344.3854828-1-kafai@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 25 Sep 2020 09:22:22 +0100
Message-ID: <CACAyw9_3im5vVepgsTw+XNYLAa1C7pQ+_kNFjzmWgEN7tkuvGw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 01/13] bpf: Move the PTR_TO_BTF_ID check to check_reg_type()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 at 01:03, Martin KaFai Lau <kafai@fb.com> wrote:
>
> check_reg_type() checks whether a reg can be used as an arg of a
> func_proto.  For PTR_TO_BTF_ID, the check is actually not
> completely done until the reg->btf_id is pointing to a
> kernel struct that is acceptable by the func_proto.
>
> Thus, this patch moves the btf_id check into check_reg_type().
> "arg_type" and "arg_btf_id" are passed to check_reg_type() instead of
> "compatible".  The compatible_reg_types[] usage is localized in
> check_reg_type() now.
>
> The "if (!btf_id) verbose(...); " is also removed since it won't happen.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Lorenz Bauer <lmb@cloudflare.com>

> ---
>  kernel/bpf/verifier.c | 60 ++++++++++++++++++++++---------------------
>  1 file changed, 31 insertions(+), 29 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 42dee5dcbc74..945fa2b4d096 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4028,19 +4028,27 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
>  };
>
>  static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
> -                         const struct bpf_reg_types *compatible)
> +                         enum bpf_arg_type arg_type,
> +                         const u32 *arg_btf_id)
>  {
>         struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
>         enum bpf_reg_type expected, type = reg->type;
> +       const struct bpf_reg_types *compatible;
>         int i, j;
>
> +       compatible = compatible_reg_types[arg_type];
> +       if (!compatible) {
> +               verbose(env, "verifier internal error: unsupported arg type %d\n", arg_type);
> +               return -EFAULT;
> +       }
> +
>         for (i = 0; i < ARRAY_SIZE(compatible->types); i++) {
>                 expected = compatible->types[i];
>                 if (expected == NOT_INIT)
>                         break;
>
>                 if (type == expected)
> -                       return 0;
> +                       goto found;
>         }
>
>         verbose(env, "R%d type=%s expected=", regno, reg_type_str[type]);
> @@ -4048,6 +4056,25 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
>                 verbose(env, "%s, ", reg_type_str[compatible->types[j]]);
>         verbose(env, "%s\n", reg_type_str[compatible->types[j]]);
>         return -EACCES;
> +
> +found:
> +       if (type == PTR_TO_BTF_ID) {
> +               if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
> +                                         *arg_btf_id)) {
> +                       verbose(env, "R%d is of type %s but %s is expected\n",
> +                               regno, kernel_type_name(reg->btf_id),
> +                               kernel_type_name(*arg_btf_id));
> +                       return -EACCES;
> +               }
> +
> +               if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
> +                       verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
> +                               regno);
> +                       return -EACCES;
> +               }
> +       }
> +
> +       return 0;
>  }
>
>  static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> @@ -4057,7 +4084,6 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>         u32 regno = BPF_REG_1 + arg;
>         struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
>         enum bpf_arg_type arg_type = fn->arg_type[arg];
> -       const struct bpf_reg_types *compatible;
>         enum bpf_reg_type type = reg->type;
>         int err = 0;
>
> @@ -4097,35 +4123,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>                  */
>                 goto skip_type_check;
>
> -       compatible = compatible_reg_types[arg_type];
> -       if (!compatible) {
> -               verbose(env, "verifier internal error: unsupported arg type %d\n", arg_type);
> -               return -EFAULT;
> -       }
> -
> -       err = check_reg_type(env, regno, compatible);
> +       err = check_reg_type(env, regno, arg_type, fn->arg_btf_id[arg]);
>         if (err)
>                 return err;
>
> -       if (type == PTR_TO_BTF_ID) {
> -               const u32 *btf_id = fn->arg_btf_id[arg];
> -
> -               if (!btf_id) {
> -                       verbose(env, "verifier internal error: missing BTF ID\n");
> -                       return -EFAULT;
> -               }
> -
> -               if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id, *btf_id)) {
> -                       verbose(env, "R%d is of type %s but %s is expected\n",
> -                               regno, kernel_type_name(reg->btf_id), kernel_type_name(*btf_id));
> -                       return -EACCES;
> -               }
> -               if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
> -                       verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
> -                               regno);
> -                       return -EACCES;
> -               }
> -       } else if (type == PTR_TO_CTX) {
> +       if (type == PTR_TO_CTX) {
>                 err = check_ctx_reg(env, reg, regno);
>                 if (err < 0)
>                         return err;
> --
> 2.24.1
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
