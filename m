Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CBA3C955C
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 02:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbhGOA5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 20:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhGOA5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 20:57:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28472613E4;
        Thu, 15 Jul 2021 00:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626310483;
        bh=iNDdn2Bhz2BPFuibfV+Kr5WrIjdthEM5WI5vHxIra9k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GOtpeYz//32i2od1ATEzmeoCBrPaFj51xgOW0U3QgJ1o3F/UOwVw37YWe1CXXR6f3
         4sDbCfq0vavYNcjrSEsYjmochntkpgd+G/45lKJ1e1ySC+LxNz03jhB84S4TR+Z4Dg
         S/AKpNICoAudirR5v+X0rlVEmkpnO8rWpqAc4Ul8L47FLYtTQn1OuzXMQKoKsGoChr
         TwQAXDzAl9xm2xTtl+ZnOOBZ/tUxDtS2OoKzHAugSRVDEQp8KcYvz0tBh8O/dYLU0Y
         iMhNh41urzoQLRksTqZUEPuxFZgEBr3NSbusOjKk8bgTRlmCOLQzWRcNbagyC13trl
         voy+RzD/f2gnw==
Received: by mail-lf1-f49.google.com with SMTP id b26so6796137lfo.4;
        Wed, 14 Jul 2021 17:54:43 -0700 (PDT)
X-Gm-Message-State: AOAM532fzt8hxjUr510Eoqn3MUmpS2/oYWY28Jfr2GMOmgc4oI/qu5EO
        U/oYzDdZiJr7Fq2byOMXfWBB0LQ1bxOtHewgyqQ=
X-Google-Smtp-Source: ABdhPJxijOtCtWRS8cpcM/0j/6AfnASZclT1TE0Gnm69XQSgSA4IPJIdX0YPfwji2VuN4aFddlf3s0uwecafXQmERqk=
X-Received: by 2002:ac2:4438:: with SMTP id w24mr540364lfl.281.1626310481426;
 Wed, 14 Jul 2021 17:54:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210714101815.164322-1-hefengqing@huawei.com>
In-Reply-To: <20210714101815.164322-1-hefengqing@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 14 Jul 2021 17:54:30 -0700
X-Gmail-Original-Message-ID: <CAPhsuW51b0Cd7VV6ub2APze4EMbMJ+Y=scLAEyhJ4SvG=D0kyQ@mail.gmail.com>
Message-ID: <CAPhsuW51b0Cd7VV6ub2APze4EMbMJ+Y=scLAEyhJ4SvG=D0kyQ@mail.gmail.com>
Subject: Re: [bpf-next, v2] bpf: verifier: Fix potential memleak and UAF in
 bpf verifier
To:     He Fengqing <hefengqing@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 2:33 AM He Fengqing <hefengqing@huawei.com> wrote:
>
> In bpf_patch_insn_data(), we first use the bpf_patch_insn_single() to
> insert new instructions, then use adjust_insn_aux_data() to adjust
> insn_aux_data. If the old env->prog have no enough room for new inserted
> instructions, we use bpf_prog_realloc to construct new_prog and free the
> old env->prog.
>
> There have two errors here. First, if adjust_insn_aux_data() return
> ENOMEM, we should free the new_prog. Second, if adjust_insn_aux_data()
> return ENOMEM, bpf_patch_insn_data() will return NULL, and env->prog has
> been freed in bpf_prog_realloc, but we will use it in bpf_check().
>
> So in this patch, we make the adjust_insn_aux_data() never fails. In
> bpf_patch_insn_data(), we first pre-malloc memory for the new
> insn_aux_data, then call bpf_patch_insn_single() to insert new
> instructions, at last call adjust_insn_aux_data() to adjust
> insn_aux_data.
>
> Fixes: 8041902dae52 ("bpf: adjust insn_aux_data when patching insns")
>
> Signed-off-by: He Fengqing <hefengqing@huawei.com>

Acked-by: Song Liu <songliubraving@fb.com>

with one nitpick below.

>
>   v1->v2:
>     pre-malloc memory for new insn_aux_data first, then
>     adjust_insn_aux_data() will never fails.
> ---
>  kernel/bpf/verifier.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index be38bb930bf1..07cf791510f1 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -11425,10 +11425,11 @@ static void convert_pseudo_ld_imm64(struct bpf_verifier_env *env)
>   * insni[off, off + cnt).  Adjust corresponding insn_aux_data by copying
>   * [0, off) and [off, end) to new locations, so the patched range stays zero
>   */
> -static int adjust_insn_aux_data(struct bpf_verifier_env *env,
> -                               struct bpf_prog *new_prog, u32 off, u32 cnt)
> +static void adjust_insn_aux_data(struct bpf_verifier_env *env,
> +                                struct bpf_insn_aux_data *new_data,
> +                                struct bpf_prog *new_prog, u32 off, u32 cnt)
>  {
> -       struct bpf_insn_aux_data *new_data, *old_data = env->insn_aux_data;
> +       struct bpf_insn_aux_data *old_data = env->insn_aux_data;
>         struct bpf_insn *insn = new_prog->insnsi;
>         u32 old_seen = old_data[off].seen;
>         u32 prog_len;
> @@ -11441,12 +11442,9 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
>         old_data[off].zext_dst = insn_has_def32(env, insn + off + cnt - 1);
>
>         if (cnt == 1)
> -               return 0;
> +               return;
>         prog_len = new_prog->len;
> -       new_data = vzalloc(array_size(prog_len,
> -                                     sizeof(struct bpf_insn_aux_data)));
> -       if (!new_data)
> -               return -ENOMEM;
> +
>         memcpy(new_data, old_data, sizeof(struct bpf_insn_aux_data) * off);
>         memcpy(new_data + off + cnt - 1, old_data + off,
>                sizeof(struct bpf_insn_aux_data) * (prog_len - off - cnt + 1));
> @@ -11457,7 +11455,7 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
>         }
>         env->insn_aux_data = new_data;
>         vfree(old_data);
> -       return 0;
> +       return;
No need to say return here.

>  }
>
>  static void adjust_subprog_starts(struct bpf_verifier_env *env, u32 off, u32 len)
> @@ -11492,6 +11490,14 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
>                                             const struct bpf_insn *patch, u32 len)
>  {
>         struct bpf_prog *new_prog;
> +       struct bpf_insn_aux_data *new_data = NULL;
> +
> +       if (len > 1) {
> +               new_data = vzalloc(array_size(env->prog->len + len - 1,
> +                                             sizeof(struct bpf_insn_aux_data)));
> +               if (!new_data)
> +                       return NULL;
> +       }
>
>         new_prog = bpf_patch_insn_single(env->prog, off, patch, len);
>         if (IS_ERR(new_prog)) {
> @@ -11499,10 +11505,12 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
>                         verbose(env,
>                                 "insn %d cannot be patched due to 16-bit range\n",
>                                 env->insn_aux_data[off].orig_idx);
> +               if (new_data)
> +                       vfree(new_data);
> +
>                 return NULL;
>         }
> -       if (adjust_insn_aux_data(env, new_prog, off, len))
> -               return NULL;
> +       adjust_insn_aux_data(env, new_data, new_prog, off, len);
>         adjust_subprog_starts(env, off, len);
>         adjust_poke_descs(new_prog, off, len);
>         return new_prog;
> --
> 2.25.1
>
