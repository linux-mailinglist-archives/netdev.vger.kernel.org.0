Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC4547235
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 23:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfFOVV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 17:21:26 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42478 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFOVV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 17:21:26 -0400
Received: by mail-qt1-f193.google.com with SMTP id s15so6621928qtk.9;
        Sat, 15 Jun 2019 14:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aYE72v6+LR0gwFoqFmrSQPJj5MPmwLA2/BhW+EFoX9g=;
        b=qCVC2hJ+KXkkMsRVT6+5iZbPeI4kgkasn8T4ecVk+UnRYHm4LClmSz2joablQmvNQZ
         cZwQSicQhnUw9H3RN+Kmarg10it3FFNxE/x0ox2huEJKCT5TXS3eh6OtIlsPgx4CaCgL
         NnuG/dIYfGJ2jwBU052hvA/rCHpYyURUyIqmMyuGJqMzqy6mk6xqbKdI/O7eh1yOdtg9
         W2upVe1Umvb5MVvlsOqjiVT83Hl9xQy8F75r3dK9dgEXov1ewpNG9u4fTC8keeu4kqpw
         H2xa563kcpo1IMk7FbTfUYi/2vAl1cS7tB+LQnvOpoc2UHjmSXbNvmQ7/iDuZ6yoRXJd
         ofkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aYE72v6+LR0gwFoqFmrSQPJj5MPmwLA2/BhW+EFoX9g=;
        b=mIlxxF4ji26Usj76P6BmCusrds/6sOXtPIRrF4TAiFaD0LccGUuPNV2tD+8y3GHXmB
         WjX31PvpQ+WoP2myChlaHXjBu9Sw1t/oyZOoRuiJ0VPt5con5w3k7zvsvGwAxTbcfZcJ
         6ZQ6nW1Q5Sh2Tw6y42Ueczm0IfgTB7p0875GLeHEVqvX+nQAYnSDboX+K9/v1mkzvVj2
         x7FunOAjXQb5AwRQ/lER6k4YTKaWDCU2ieOTwqe9gW0njC1298xcDro1mbXnYQZu0N8o
         7l9iOHBqk8b905cvb8OPA7q+1jBH4ylG4We/8xAgA3kfrlncNaxwUhCzEYcYLCfHRIND
         YkvA==
X-Gm-Message-State: APjAAAWMEr8xaqLWhGXJu9+F+kad2isE04tEU2aeoO/hDNPZUmUlLrED
        wa5RM1+dU5aVa+/gk8WYb4wJ4bEVpNGNqPTI4zA=
X-Google-Smtp-Source: APXvYqxUDMz/8tVw5QqgmJEaKYPnJYVVxa8ihF3+zFkKcQdBaQAalegku83nlnmatE3RiZUZ3O/UkwT7s+gqfJ3tENE=
X-Received: by 2002:a0c:8965:: with SMTP id 34mr14549147qvq.26.1560633685100;
 Sat, 15 Jun 2019 14:21:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190611044747.44839-1-andriin@fb.com> <20190611044747.44839-6-andriin@fb.com>
In-Reply-To: <20190611044747.44839-6-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sat, 15 Jun 2019 14:21:14 -0700
Message-ID: <CAPhsuW7nF7H+7uZnXwMCub5H+yg-VvmzDU7jNY4KFjiiPuc4-w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/8] libbpf: split initialization and loading of BTF
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 9:49 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Libbpf does sanitization of BTF before loading it into kernel, if kernel
> doesn't support some of newer BTF features. This removes some of the
> important information from BTF (e.g., DATASEC and VAR description),
> which will be used for map construction. This patch splits BTF
> processing into initialization step, in which BTF is initialized from
> ELF and all the original data is still preserved; and
> sanitization/loading step, which ensures that BTF is safe to load into
> kernel. This allows to use full BTF information to construct maps, while
> still loading valid BTF into older kernels.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/lib/bpf/libbpf.c | 34 ++++++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 10 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 5e7ea7dac958..79a8143240d7 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1118,7 +1118,7 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
>         }
>  }
>
> -static int bpf_object__load_btf(struct bpf_object *obj,
> +static int bpf_object__init_btf(struct bpf_object *obj,
>                                 Elf_Data *btf_data,
>                                 Elf_Data *btf_ext_data)
>  {
> @@ -1137,13 +1137,6 @@ static int bpf_object__load_btf(struct bpf_object *obj,
>                                    BTF_ELF_SEC, err);
>                         goto out;
>                 }
> -               bpf_object__sanitize_btf(obj);
> -               err = btf__load(obj->btf);
> -               if (err) {
> -                       pr_warning("Error loading %s into kernel: %d.\n",
> -                                  BTF_ELF_SEC, err);
> -                       goto out;
> -               }
>         }
>         if (btf_ext_data) {
>                 if (!obj->btf) {
> @@ -1159,7 +1152,6 @@ static int bpf_object__load_btf(struct bpf_object *obj,
>                         obj->btf_ext = NULL;
>                         goto out;
>                 }
> -               bpf_object__sanitize_btf_ext(obj);
>         }
>  out:
>         if (err || IS_ERR(obj->btf)) {
> @@ -1170,6 +1162,26 @@ static int bpf_object__load_btf(struct bpf_object *obj,
>         return 0;
>  }
>
> +static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
> +{
> +       int err = 0;
> +
> +       if (!obj->btf)
> +               return 0;
> +
> +       bpf_object__sanitize_btf(obj);
> +       bpf_object__sanitize_btf_ext(obj);
> +
> +       err = btf__load(obj->btf);
> +       if (err) {
> +               pr_warning("Error loading %s into kernel: %d.\n",
> +                          BTF_ELF_SEC, err);
> +               btf__free(obj->btf);
> +               obj->btf = NULL;
> +       }
> +       return 0;
> +}
> +
>  static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>  {
>         Elf *elf = obj->efile.elf;
> @@ -1301,9 +1313,11 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>                 pr_warning("Corrupted ELF file: index of strtab invalid\n");
>                 return -LIBBPF_ERRNO__FORMAT;
>         }
> -       err = bpf_object__load_btf(obj, btf_data, btf_ext_data);
> +       err = bpf_object__init_btf(obj, btf_data, btf_ext_data);
>         if (!err)
>                 err = bpf_object__init_maps(obj, flags);
> +       if (!err)
> +               err = bpf_object__sanitize_and_load_btf(obj);
>         if (!err)
>                 err = bpf_object__init_prog_names(obj);
>         return err;
> --
> 2.17.1
>
