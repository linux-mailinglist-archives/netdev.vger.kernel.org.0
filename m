Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690D838B83C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 22:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237438AbhETUUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 16:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235930AbhETUUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 16:20:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8C946135A;
        Thu, 20 May 2021 20:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621541963;
        bh=LIaRk3+vU/ZHO6wkM9rlcUlXRozmGJMaim52YqMKqnM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cTv7xRGpf/mzzVIVjJ+OYv2Cs1IKtdea3JBxf6d7AQ8/zoVoO7GiN8lTdkxphQVBc
         Q0KPecOfFK2in3iHfinnYJs3xSQEYF/vNJ77xJ5utgRWrimOa7fsS0ZWxloHFGJvxZ
         BWpa7zeV49z4lAiti82GNmvMFOtp1ksLTdSTwV2qweY0SAlzBNjprQ+GFGtlfG98uv
         gEdYQ0LcmdgT/1rJRq5h6uGviJrga2Nou25ADtpAm+fF37LNU2MGg8gOTlSZS8XD3Y
         Dotitcz08aL9tleBxH/2gItVUew8SiQ7L/oqXJ4ci3RN7wVReEXc68oRSxK6uKegJ5
         Cdok54TPc5ndA==
Received: by mail-lj1-f170.google.com with SMTP id a4so6557365ljd.5;
        Thu, 20 May 2021 13:19:23 -0700 (PDT)
X-Gm-Message-State: AOAM5315+muypEKIAWn5K1YRkjSfhH8Z8N8fvJjuCI+eobEAbvqppu1E
        6R0g9BzYOvyNBQV23ILObXCfdO0M0D1an3vYAFE=
X-Google-Smtp-Source: ABdhPJy1WtAI2RiW43x4FVuMOFjE3hnEjOIvqqbqp3j286rlJk7ejwbQyYOIcX17048+ZoED1dPaWHwoRz/bpS65OwE=
X-Received: by 2002:a2e:7119:: with SMTP id m25mr4091305ljc.177.1621541962200;
 Thu, 20 May 2021 13:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210520085834.15023-1-simon.horman@netronome.com>
In-Reply-To: <20210520085834.15023-1-simon.horman@netronome.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 20 May 2021 13:19:11 -0700
X-Gmail-Original-Message-ID: <CAPhsuW40Udu0vdEbpRjXO=5-_O7Vz-7XFvqoCaSanhSRy06nHg@mail.gmail.com>
Message-ID: <CAPhsuW40Udu0vdEbpRjXO=5-_O7Vz-7XFvqoCaSanhSRy06nHg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: offload: reorder offload callback 'prepare' in verifier
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        oss-drivers@netronome.com, Yinjun Zhang <yinjun.zhang@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 2:01 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
>
> Commit 4976b718c355 ("bpf: Introduce pseudo_btf_id") switched the
> order of resolve_pseudo_ldimm(), in which some pseudo instructions
> are rewritten. Thus those rewritten instructions cannot be passed
> to driver via 'prepare' offload callback.
>
> Reorder the 'prepare' offload callback to fix it.
>
> Fixes: 4976b718c355 ("bpf: Introduce pseudo_btf_id")
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  kernel/bpf/verifier.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index c58598ef4b5b..09849e43f035 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -13368,12 +13368,6 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
>         if (is_priv)
>                 env->test_state_freq = attr->prog_flags & BPF_F_TEST_STATE_FREQ;
>
> -       if (bpf_prog_is_dev_bound(env->prog->aux)) {
> -               ret = bpf_prog_offload_verifier_prep(env->prog);
> -               if (ret)
> -                       goto skip_full_check;
> -       }
> -
>         env->explored_states = kvcalloc(state_htab_size(env),
>                                        sizeof(struct bpf_verifier_state_list *),
>                                        GFP_USER);
> @@ -13401,6 +13395,12 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
>         if (ret < 0)
>                 goto skip_full_check;
>
> +       if (bpf_prog_is_dev_bound(env->prog->aux)) {
> +               ret = bpf_prog_offload_verifier_prep(env->prog);
> +               if (ret)
> +                       goto skip_full_check;
> +       }
> +
>         ret = check_cfg(env);
>         if (ret < 0)
>                 goto skip_full_check;
> --
> 2.20.1
>
