Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96AAC299985
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 23:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393384AbgJZWV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 18:21:59 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34384 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392831AbgJZWV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 18:21:58 -0400
Received: by mail-yb1-f194.google.com with SMTP id o70so9029428ybc.1;
        Mon, 26 Oct 2020 15:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BTw89jH44ZNymuvHm6SIrFy7eskw2jT7W9hmnpvtaBs=;
        b=O5w3U2jvbkSIy3PN9hi4QpMnUEqNwwYd1WlVlUlSjZhV9UqeSf5N4qGFc5j5r7EqZq
         q1asT+skC0OQRokoaGKrJgGg/g5A66ShyqBE8UE0hkMfElYF8AUAtmkYmELhdax6UxLM
         h0DhrL4hEqRoVDkNIGCjncnpUoKgMG/okrhtViHEOXSRASZ3qLUEauHgEkD2LYmEKWuO
         aHMAbQFbkuPQxGpOUNe+IPqrT4B5CbUQ84kR8RIfqqTGf+jxBlWJ8u9MVchfPNUhonFA
         v062Nm373HYv9IhYPpdKYqjBOlubkqB4+WQvnFmiSkXdFyUEawz/aW/xBntoGjUfVmNY
         c0KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BTw89jH44ZNymuvHm6SIrFy7eskw2jT7W9hmnpvtaBs=;
        b=b6Q8FSnVKCLtn48EDWx0EllXXzn2przG04T3X8t9hklxqb7wrJ6sYn/VJnesLO5X6t
         5qODBnA9f2rLFJVqAalKImhDqNhem7bUBePO0wPRBEWZ1yvG1wtrRi7CkL+mpK7WNtA2
         Rwam5a6TD3wbeH3+zcEF4pWd6bwDfEk8vZV7P1ikWNw8EJu9pTOmEvfkYNhDAUPKcjLH
         zquqDnJuPft+AukPT4HGE5JAvnJ+FOiHP1kEVSesZIG5pmPPLEMLFju1y8cgK04WXejl
         Swv1BLytpsgdKpDCIWnmmQoBYGCYvJ2Qkbbi2fnNUwHVPOtv6KihpJwEbI5MGlwZZPCI
         gH5g==
X-Gm-Message-State: AOAM5312fNBJYcObuVCWHKyK74Ps2n45rATBzFP1lysheIhwpmldQWtJ
        mP8SJ4+j+cSV6B1EXSDZji+pRLjOYKDX8RGRqGEuqF7bH+tsKg==
X-Google-Smtp-Source: ABdhPJy9NQBEHxMI15PKklrhwj2CYIVPRMYhu/kHcIsiFxGqzhJ/6wWEgoEp4augi3eron2GFv/lt3N8mYbnsmk9vQE=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr27176366ybe.403.1603750917686;
 Mon, 26 Oct 2020 15:21:57 -0700 (PDT)
MIME-Version: 1.0
References: <20201026162110.3710415-1-arnd@kernel.org>
In-Reply-To: <20201026162110.3710415-1-arnd@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Oct 2020 15:21:46 -0700
Message-ID: <CAEf4BzaAaB8yR17JjyW9m9H3duvEhR+NdA9u8=1w+zFzC0gQxA@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix -Wshadow warnings
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Arnd Bergmann <arnd@arndb.de>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 12:37 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> There are thousands of warnings about one macro in a W=2 build:
>
> include/linux/filter.h:561:6: warning: declaration of 'ret' shadows a previous local [-Wshadow]
>
> Prefix all the locals in that macro with __ to avoid most of
> these warnings.
>
> Fixes: 492ecee892c2 ("bpf: enable program stats")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/linux/filter.h | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 954f279fde01..20ba04583eaa 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -558,21 +558,21 @@ struct sk_filter {
>  DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
>
>  #define __BPF_PROG_RUN(prog, ctx, dfunc)       ({                      \
> -       u32 ret;                                                        \
> +       u32 __ret;                                                      \
>         cant_migrate();                                                 \
>         if (static_branch_unlikely(&bpf_stats_enabled_key)) {           \
> -               struct bpf_prog_stats *stats;                           \
> -               u64 start = sched_clock();                              \
> -               ret = dfunc(ctx, (prog)->insnsi, (prog)->bpf_func);     \
> -               stats = this_cpu_ptr(prog->aux->stats);                 \
> -               u64_stats_update_begin(&stats->syncp);                  \
> -               stats->cnt++;                                           \
> -               stats->nsecs += sched_clock() - start;                  \
> -               u64_stats_update_end(&stats->syncp);                    \
> +               struct bpf_prog_stats *__stats;                         \
> +               u64 __start = sched_clock();                            \
> +               __ret = dfunc(ctx, (prog)->insnsi, (prog)->bpf_func);   \
> +               __stats = this_cpu_ptr(prog->aux->stats);               \
> +               u64_stats_update_begin(&__stats->syncp);                \
> +               __stats->cnt++;                                         \
> +               __stats->nsecs += sched_clock() - __start;              \
> +               u64_stats_update_end(&__stats->syncp);                  \
>         } else {                                                        \
> -               ret = dfunc(ctx, (prog)->insnsi, (prog)->bpf_func);     \
> +               __ret = dfunc(ctx, (prog)->insnsi, (prog)->bpf_func);   \
>         }                                                               \
> -       ret; })
> +       __ret; })
>
>  #define BPF_PROG_RUN(prog, ctx)                                                \
>         __BPF_PROG_RUN(prog, ctx, bpf_dispatcher_nop_func)
> --
> 2.27.0
>
