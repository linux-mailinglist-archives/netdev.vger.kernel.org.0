Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFB134D458
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhC2Pzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhC2PzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 11:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25E6E61964;
        Mon, 29 Mar 2021 15:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617033307;
        bh=hmHqbv+llNzlagTGta3DJ3KAOzAkq24tcXAj08RT9X4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=B4Et25Q+QX+OM6bJqPepKritJqvf3uyM5FGgX92Vp1wpCJuTymGGVmvNgzbwynb/I
         Vb2agxhulbxN9lyctBZLd7akbq2WLDPWCgIqgO+4sZ1j8jEWwbzJX14hCRnfNFFhOm
         ZsaGrpk/TOTS374UQs+wWkWIZinp4wgLB2KXkpQGHJYc5sMDtMkdeVfooQjU61oq8n
         iWusrgFdZkCFjdi0ZCdFJ9iKeulkS/MKsC7Hz8xrDthpNuMGgZkqQTAKmjeesIhJ1D
         3KJmMDOkOJWoSWnNQKobOB38BWg3QW3w1T7XPHYew6WZ11Sh693TtDN8gUtsOURe7e
         rIk5yyOJcesyQ==
Received: by mail-lj1-f170.google.com with SMTP id s17so16506964ljc.5;
        Mon, 29 Mar 2021 08:55:07 -0700 (PDT)
X-Gm-Message-State: AOAM532zqLPiAKU6bvs8gyED0jCnSBRKYO9R4VoIXHfMGUgaxRTrQHvJ
        OxxINxlAcONap8WOfx/BLNydJQDQw3L+iUQ+J44=
X-Google-Smtp-Source: ABdhPJyoC9STmM1iez5K+mffwYO83yJgTsqFCSPTLgSw0YFfQ8Zf9zALJJj8uwXyx/B1/6bN66nkZS0Lqxqlwc6/3jE=
X-Received: by 2002:a05:651c:200b:: with SMTP id s11mr17522929ljo.177.1617033305398;
 Mon, 29 Mar 2021 08:55:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210327042502.969745-1-andrii@kernel.org>
In-Reply-To: <20210327042502.969745-1-andrii@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Mon, 29 Mar 2021 08:54:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5eczpW=-oVz+3aM_5PL29eW-px_GqaS80diyQddbt93A@mail.gmail.com>
Message-ID: <CAPhsuW5eczpW=-oVz+3aM_5PL29eW-px_GqaS80diyQddbt93A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix memory leak when emitting final btf_ext
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 9:35 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Free temporary allocated memory used to construct finalized .BTF.ext data.
> Found by Coverity static analysis on libbpf's Github repo.
>
> Fixes: 8fd27bf69b86 ("libbpf: Add BPF static linker BTF and BTF.ext support")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>


> ---
>  tools/lib/bpf/linker.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> index a29d62ff8041..46b16cbdcda3 100644
> --- a/tools/lib/bpf/linker.c
> +++ b/tools/lib/bpf/linker.c
> @@ -1906,8 +1906,10 @@ static int finalize_btf_ext(struct bpf_linker *linker)
>                         struct dst_sec *sec = &linker->secs[i];
>
>                         sz = emit_btf_ext_data(linker, cur, sec->sec_name, &sec->func_info);
> -                       if (sz < 0)
> -                               return sz;
> +                       if (sz < 0) {
> +                               err = sz;
> +                               goto out;
> +                       }
>
>                         cur += sz;
>                 }
> @@ -1921,8 +1923,10 @@ static int finalize_btf_ext(struct bpf_linker *linker)
>                         struct dst_sec *sec = &linker->secs[i];
>
>                         sz = emit_btf_ext_data(linker, cur, sec->sec_name, &sec->line_info);
> -                       if (sz < 0)
> -                               return sz;
> +                       if (sz < 0) {
> +                               err = sz;
> +                               goto out;
> +                       }
>
>                         cur += sz;
>                 }
> @@ -1936,8 +1940,10 @@ static int finalize_btf_ext(struct bpf_linker *linker)
>                         struct dst_sec *sec = &linker->secs[i];
>
>                         sz = emit_btf_ext_data(linker, cur, sec->sec_name, &sec->core_relo_info);
> -                       if (sz < 0)
> -                               return sz;
> +                       if (sz < 0) {
> +                               err = sz;
> +                               goto out;
> +                       }
>
>                         cur += sz;
>                 }
> @@ -1948,8 +1954,10 @@ static int finalize_btf_ext(struct bpf_linker *linker)
>         if (err) {
>                 linker->btf_ext = NULL;
>                 pr_warn("failed to parse final .BTF.ext data: %d\n", err);
> -               return err;
> +               goto out;
>         }
>
> -       return 0;
> +out:
> +       free(data);
> +       return err;
>  }
> --
> 2.30.2
>
