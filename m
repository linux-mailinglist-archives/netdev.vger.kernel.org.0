Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEF13BE383
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 09:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhGGH2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 03:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230327AbhGGH2Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 03:28:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F88B61CB9;
        Wed,  7 Jul 2021 07:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625642737;
        bh=4To1TQChPGxaEbAzzonSy/8qzSlQahhZAzNknR8JiLQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ca7qsuCPmjOqsPUMF7FUyUafA+uGc1/bFaAlsQgTCU5AxlBCe2ELqQ21zXRJy8ame
         tLjYbaMkOL7FTHwIE/VVi/38d1nzEkdZzxRQrrJVswmm5oA14tfrItf4SVR1S4hKu0
         tlCOFPOxuWKjqZWcJYO5MeEtnZ7VZIMoXmuIkwq8X/z1k2mC7/V28zygXEzT9rhEFL
         nD7olq5kOCKpclCx4yzUXh1B4HuZ0fG3bh4yjUPuCxlI2Ba97VQnpgd6oqAJxga97n
         o/eoicRKZpDbXyDoAppMhl0/ournH46XUxgHd2DS/YZoOws4gMRJh/gzcDi42ak91h
         M4biaeGW+rBbg==
Received: by mail-lf1-f48.google.com with SMTP id u18so2355900lff.9;
        Wed, 07 Jul 2021 00:25:36 -0700 (PDT)
X-Gm-Message-State: AOAM5330oEkBuUkA0fbl9AFqNkX94FF9e7OXVp+EPv8HDTInpg4qKfnx
        7XD7uJwO3H8BtV54pYAusBDYER2xRQuehOF5hMs=
X-Google-Smtp-Source: ABdhPJzzqJHS/iverHSPGkouzOG+P2sReLwXRBzKwtgkBffeWXtrz4qPTaH8Ewo76S2U2gnBFmzMnN8Y3Td8k4j2dqc=
X-Received: by 2002:a19:3848:: with SMTP id d8mr9201441lfj.261.1625642735253;
 Wed, 07 Jul 2021 00:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210707043811.5349-1-hefengqing@huawei.com> <20210707043811.5349-4-hefengqing@huawei.com>
In-Reply-To: <20210707043811.5349-4-hefengqing@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 7 Jul 2021 00:25:24 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7ssFzvS5-kdZa3tY-2EJk8QUdVpQCJYVBr+vD11JzrsQ@mail.gmail.com>
Message-ID: <CAPhsuW7ssFzvS5-kdZa3tY-2EJk8QUdVpQCJYVBr+vD11JzrsQ@mail.gmail.com>
Subject: Re: [bpf-next 3/3] bpf: Fix a use after free in bpf_check()
To:     He Fengqing <hefengqing@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 6, 2021 at 8:53 PM He Fengqing <hefengqing@huawei.com> wrote:
>
> In bpf_patch_insn_data, env->prog was input parameter of
> bpf_patch_insn_single function. bpf_patch_insn_single call
> bpf_prog_realloc to realloc ebpf prog. When we need to malloc new prog,
> bpf_prog_realloc will free the old prog, in this scenery is the
> env->prog.
> Then bpf_patch_insn_data function call adjust_insn_aux_data function, if
> adjust_insn_aux_data function return error, bpf_patch_insn_data will
> return NULL.
> In bpf_check->convert_ctx_accesses->bpf_patch_insn_data call chain, if
> bpf_patch_insn_data return NULL, env->prog has been freed in
> bpf_prog_realloc, then bpf_check will use the freed env->prog.

Besides "what is the bug", please also describe "how to fix it". For example,
add "Fix it by adding a free_old argument to bpf_prog_realloc(), and ...".
Also, for the subject of 0/3, it is better to say "fix potential
memory leak and ...".

>
> Signed-off-by: He Fengqing <hefengqing@huawei.com>
> ---
>  include/linux/filter.h |  2 +-
>  kernel/bpf/core.c      |  9 ++++---
>  kernel/bpf/verifier.c  | 53 ++++++++++++++++++++++++++++++++----------
>  net/core/filter.c      |  2 +-
>  4 files changed, 49 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index f39e008a377d..ec11a5ae92c2 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -881,7 +881,7 @@ void bpf_prog_jit_attempt_done(struct bpf_prog *prog);
>  struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags);
>  struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flags);
>  struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
> -                                 gfp_t gfp_extra_flags);
> +                                 gfp_t gfp_extra_flags, bool free_old);
>  void __bpf_prog_free(struct bpf_prog *fp);
>
>  static inline void bpf_prog_clone_free(struct bpf_prog *fp)
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 49b0311f48c1..e5616bb1665b 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -218,7 +218,7 @@ void bpf_prog_fill_jited_linfo(struct bpf_prog *prog,
>  }
>
>  struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
> -                                 gfp_t gfp_extra_flags)
> +                                 gfp_t gfp_extra_flags, bool free_old)
>  {
>         gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
>         struct bpf_prog *fp;
> @@ -238,7 +238,8 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
>                 /* We keep fp->aux from fp_old around in the new
>                  * reallocated structure.
>                  */
> -               bpf_prog_clone_free(fp_old);
> +               if (free_old)
> +                       bpf_prog_clone_free(fp_old);
>         }
>
>         return fp;
> @@ -456,7 +457,7 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
>          * last page could have large enough tailroom.
>          */
>         prog_adj = bpf_prog_realloc(prog, bpf_prog_size(insn_adj_cnt),
> -                                   GFP_USER);
> +                                   GFP_USER, false);
>         if (!prog_adj)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -1150,6 +1151,8 @@ struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
>                         return tmp;
>                 }
>
> +               if (tmp != clone)
> +                       bpf_prog_clone_free(clone);
>                 clone = tmp;
>                 insn_delta = rewritten - 1;
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 41109f49b724..e75b933f69e4 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -11855,7 +11855,10 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
>                 new_prog = bpf_patch_insn_data(env, adj_idx, patch, patch_len);
>                 if (!new_prog)
>                         return -ENOMEM;
> -               env->prog = new_prog;
> +               if (new_prog != env->prog) {
> +                       bpf_prog_clone_free(env->prog);
> +                       env->prog = new_prog;
> +               }

Can we move this check into bpf_patch_insn_data()?

>                 insns = new_prog->insnsi;
>                 aux = env->insn_aux_data;
>                 delta += patch_len - 1;
[...]

> diff --git a/net/core/filter.c b/net/core/filter.c
> index d70187ce851b..8a8d1a3ba5c2 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -1268,7 +1268,7 @@ static struct bpf_prog *bpf_migrate_filter(struct bpf_prog *fp)
>
>         /* Expand fp for appending the new filter representation. */
>         old_fp = fp;
> -       fp = bpf_prog_realloc(old_fp, bpf_prog_size(new_len), 0);
> +       fp = bpf_prog_realloc(old_fp, bpf_prog_size(new_len), 0, true);

Can we add some logic here and not add free_old to bpf_prog_realloc()?

Thanks,
Song
