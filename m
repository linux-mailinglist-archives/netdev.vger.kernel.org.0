Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A4C381217
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 22:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhENUx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 16:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232359AbhENUxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 16:53:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DF886145A;
        Fri, 14 May 2021 20:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621025533;
        bh=zWWTwQ5r9iKwmxhjPvmmkDnHWBuHLQJUtN28LFiusYQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lZlP2gEDB38oN5yezlICkgWFEBt229fwsBYr7LChT/POAsSD1V1mqR1A0fzMDfruI
         8tfpqz2odciprrNyx1eyPZzts8ioNCVlplKxAQPyTth/+DfoxE/uPQ7do4mIJu13FF
         cJa1S/TuBvJ7c+Ezh3a8Kd46/ghjJ4uaazCfEZFrVOgr+3EPuBfNjFFlKoqcD4cYBF
         lrZQMTD+vswaOWZv2qxvEdrSO9uv5e1zm1nyRRgXDYP3adKKfJdMv5xiFLSX7fmc9y
         R9W3631ovsprcavhohgWVLEsUPRXTDuyUvbX2GSaAcZL9crL4cnkcUcGf0X3a0LohZ
         xbvBzJiWIb0EA==
Received: by mail-lj1-f180.google.com with SMTP id o8so73055ljp.0;
        Fri, 14 May 2021 13:52:13 -0700 (PDT)
X-Gm-Message-State: AOAM5315KdztE60me2bblV7CLdNPqzLXAcBjJgzTYaYtYcLxhMERRwRR
        onqInCX3dod90mPS8wfDQ+ZobuIck4IikAFgk9g=
X-Google-Smtp-Source: ABdhPJz7ViHSfY1xU3aHdHxh84clQV4One8+yEweAGd0+dvAi8U3tXc+Br99xv5vTprqPZ96ErtQjQdg82pGhIzYRgo=
X-Received: by 2002:a05:651c:39d:: with SMTP id e29mr40249496ljp.97.1621025531560;
 Fri, 14 May 2021 13:52:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210514195534.1440970-1-andrii@kernel.org>
In-Reply-To: <20210514195534.1440970-1-andrii@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Fri, 14 May 2021 13:52:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4qaXuUR0AnOxNie14O_76TYVhe8DoXk9Hs7poZ0WJ=sQ@mail.gmail.com>
Message-ID: <CAPhsuW4qaXuUR0AnOxNie14O_76TYVhe8DoXk9Hs7poZ0WJ=sQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: reject static entry-point BPF programs
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 1:33 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Detect use of static entry-point BPF programs (those with SEC() markings) and
> emit error message. This is similar to
> c1cccec9c636 ("libbpf: Reject static maps") but for BPF programs.
>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/lib/bpf/libbpf.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 182bd3d3f728..e58f51b24574 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -677,6 +677,11 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
>                         return -LIBBPF_ERRNO__FORMAT;
>                 }
>
> +               if (sec_idx != obj->efile.text_shndx && GELF_ST_BIND(sym.st_info) == STB_LOCAL) {
> +                       pr_warn("sec '%s': program '%s' is static and not supported\n", sec_name, name);
> +                       return -ENOTSUP;
> +               }
> +
>                 pr_debug("sec '%s': found program '%s' at insn offset %zu (%zu bytes), code size %zu insns (%zu bytes)\n",
>                          sec_name, name, sec_off / BPF_INSN_SZ, sec_off, prog_sz / BPF_INSN_SZ, prog_sz);
>
> --
> 2.30.2
>
