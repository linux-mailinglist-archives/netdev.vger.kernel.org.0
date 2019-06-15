Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9228A47208
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfFOU0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:26:07 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37699 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfFOU0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:26:07 -0400
Received: by mail-qt1-f194.google.com with SMTP id y57so6581688qtk.4;
        Sat, 15 Jun 2019 13:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tztss1Atv+Qv/wnnZUDfxaVfbZCH7GTnWYFuwVOsx1o=;
        b=HkuPypsy9bzw0HTYQpkur8CbqO3h9mMXwqmb+kL0AnKP+DFhIfspOtT9uq2dew61+o
         /Lxen/sNUexp2Cw5KrcJLw9IG95KQRP0/oWuHvcQg2rKB3MNFqQSSMhC2+adkbEizW3h
         H/wERFRn/DcmxvG8Sh068iiUUJ/5014ipnCHPE4otfid7UEXT+dcV8KNRCiqwzXfYK/A
         pKAjVMtckFXN1L2VhJT0Fvtcr8/oIKIgGIS17Ykqi8fIUZRNuZA8mJHcejqw4VtECYVW
         GhxhJQkXHgpySJDMeBw4dCmJLjWV7pwYdh3o7xsXoqOiWEGyYtWgokL3ucUJro5lOvSB
         E+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tztss1Atv+Qv/wnnZUDfxaVfbZCH7GTnWYFuwVOsx1o=;
        b=QKfG/NS8h1MMs99EXCs63SquTgeQCcQDtBlGFOuKcFZi8MO1AWtJUWhgZ6+id7tsiL
         YAVBr0PujGh4+QCVKAtP82tXkPHXdDtUyACwOgArZfwduuIRQ4NxBvg/fyhOBy9ersns
         0K0ZAXj8HSDC7Ijnfyd8/sSgM38OHocxIHFNm6gRh4G9F3JtH6pnpPoAZGafUEvwq3Ok
         +O1F1DMyo1dNMbAjroWgr86YapMcGCnz8HBNjpoNoVWZRZDq1aHjem9zNefTfvvGI/1I
         pe5fETVA4HVdGKktBM8MuK/9p5f339loAleip0BgqD2H+NMBeZHd22/++163IC/GT5KV
         c87A==
X-Gm-Message-State: APjAAAUXiCz8OsM8V0ZKelYdzMb+dqoZl50qxeIJEv/7+EavhDE4aJkK
        iVOrhgyM0DfhPudQNGc7qi9c7vxB1N7xuitIfhk=
X-Google-Smtp-Source: APXvYqySo8VvdQwuHVD9Sk3pzgbLTqImqeVyXdsKz/AVJYfNMZdUtexXZUqM5TH43XSLg9YaCc2IYQEpPSPayS6cdNM=
X-Received: by 2002:a0c:c68d:: with SMTP id d13mr14322637qvj.145.1560630365877;
 Sat, 15 Jun 2019 13:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190611044747.44839-1-andriin@fb.com> <20190611044747.44839-3-andriin@fb.com>
In-Reply-To: <20190611044747.44839-3-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sat, 15 Jun 2019 13:25:54 -0700
Message-ID: <CAPhsuW6kAN=gMjtXiAJazDFTszuq4xE-9OQTP_GhDX2cxym0NQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/8] libbpf: extract BTF loading and simplify ELF
 parsing logic
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
> As a preparation for adding BTF-based BPF map loading, extract .BTF and
> .BTF.ext loading logic. Also simplify error handling in
> bpf_object__elf_collect() by returning early, as there is no common
> clean up to be done.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 137 ++++++++++++++++++++++-------------------
>  1 file changed, 75 insertions(+), 62 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ba89d9727137..9e39a0a33aeb 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1078,6 +1078,58 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
>         }
>  }
>
> +static int bpf_object__load_btf(struct bpf_object *obj,
> +                               Elf_Data *btf_data,
> +                               Elf_Data *btf_ext_data)
> +{
> +       int err = 0;
> +
> +       if (btf_data) {
> +               obj->btf = btf__new(btf_data->d_buf, btf_data->d_size);
> +               if (IS_ERR(obj->btf)) {
> +                       pr_warning("Error loading ELF section %s: %d.\n",
> +                                  BTF_ELF_SEC, err);
> +                       goto out;

If we goto out here, we will return 0.

> +               }
> +               err = btf__finalize_data(obj, obj->btf);
> +               if (err) {
> +                       pr_warning("Error finalizing %s: %d.\n",
> +                                  BTF_ELF_SEC, err);
> +                       goto out;
> +               }
> +               bpf_object__sanitize_btf(obj);
> +               err = btf__load(obj->btf);
> +               if (err) {
> +                       pr_warning("Error loading %s into kernel: %d.\n",
> +                                  BTF_ELF_SEC, err);
> +                       goto out;
> +               }
> +       }
> +       if (btf_ext_data) {
> +               if (!obj->btf) {
> +                       pr_debug("Ignore ELF section %s because its depending ELF section %s is not found.\n",
> +                                BTF_EXT_ELF_SEC, BTF_ELF_SEC);
> +                       goto out;

We will also return 0 when goto out here.

> +               }
> +               obj->btf_ext = btf_ext__new(btf_ext_data->d_buf,
> +                                           btf_ext_data->d_size);
> +               if (IS_ERR(obj->btf_ext)) {
> +                       pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
> +                                  BTF_EXT_ELF_SEC, PTR_ERR(obj->btf_ext));
> +                       obj->btf_ext = NULL;
> +                       goto out;
And, here. And we will not free obj->btf.

> +               }
> +               bpf_object__sanitize_btf_ext(obj);
> +       }
> +out:
> +       if (err || IS_ERR(obj->btf)) {
> +               if (!IS_ERR_OR_NULL(obj->btf))
> +                       btf__free(obj->btf);
> +               obj->btf = NULL;
> +       }
> +       return 0;
> +}
> +
>  static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>  {
>         Elf *elf = obj->efile.elf;
> @@ -1102,24 +1154,21 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>                 if (gelf_getshdr(scn, &sh) != &sh) {
>                         pr_warning("failed to get section(%d) header from %s\n",
>                                    idx, obj->path);
> -                       err = -LIBBPF_ERRNO__FORMAT;
> -                       goto out;
> +                       return -LIBBPF_ERRNO__FORMAT;
>                 }
>
>                 name = elf_strptr(elf, ep->e_shstrndx, sh.sh_name);
>                 if (!name) {
>                         pr_warning("failed to get section(%d) name from %s\n",
>                                    idx, obj->path);
> -                       err = -LIBBPF_ERRNO__FORMAT;
> -                       goto out;
> +                       return -LIBBPF_ERRNO__FORMAT;
>                 }
>
>                 data = elf_getdata(scn, 0);
>                 if (!data) {
>                         pr_warning("failed to get section(%d) data from %s(%s)\n",
>                                    idx, name, obj->path);
> -                       err = -LIBBPF_ERRNO__FORMAT;
> -                       goto out;
> +                       return -LIBBPF_ERRNO__FORMAT;
>                 }
>                 pr_debug("section(%d) %s, size %ld, link %d, flags %lx, type=%d\n",
>                          idx, name, (unsigned long)data->d_size,
> @@ -1130,10 +1179,14 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>                         err = bpf_object__init_license(obj,
>                                                        data->d_buf,
>                                                        data->d_size);
> +                       if (err)
> +                               return err;
>                 } else if (strcmp(name, "version") == 0) {
>                         err = bpf_object__init_kversion(obj,
>                                                         data->d_buf,
>                                                         data->d_size);
> +                       if (err)
> +                               return err;
>                 } else if (strcmp(name, "maps") == 0) {
>                         obj->efile.maps_shndx = idx;
>                 } else if (strcmp(name, BTF_ELF_SEC) == 0) {
> @@ -1144,11 +1197,10 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>                         if (obj->efile.symbols) {
>                                 pr_warning("bpf: multiple SYMTAB in %s\n",
>                                            obj->path);
> -                               err = -LIBBPF_ERRNO__FORMAT;
> -                       } else {
> -                               obj->efile.symbols = data;
> -                               obj->efile.strtabidx = sh.sh_link;
> +                               return -LIBBPF_ERRNO__FORMAT;
>                         }
> +                       obj->efile.symbols = data;
> +                       obj->efile.strtabidx = sh.sh_link;
>                 } else if (sh.sh_type == SHT_PROGBITS && data->d_size > 0) {
>                         if (sh.sh_flags & SHF_EXECINSTR) {
>                                 if (strcmp(name, ".text") == 0)
> @@ -1162,6 +1214,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>
>                                         pr_warning("failed to alloc program %s (%s): %s",
>                                                    name, obj->path, cp);
> +                                       return err;
>                                 }
>                         } else if (strcmp(name, ".data") == 0) {
>                                 obj->efile.data = data;
> @@ -1173,8 +1226,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>                                 pr_debug("skip section(%d) %s\n", idx, name);
>                         }
>                 } else if (sh.sh_type == SHT_REL) {
> +                       int nr_reloc = obj->efile.nr_reloc;
>                         void *reloc = obj->efile.reloc;
> -                       int nr_reloc = obj->efile.nr_reloc + 1;
>                         int sec = sh.sh_info; /* points to other section */
>
>                         /* Only do relo for section with exec instructions */
> @@ -1184,79 +1237,39 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>                                 continue;
>                         }
>
> -                       reloc = reallocarray(reloc, nr_reloc,
> +                       reloc = reallocarray(reloc, nr_reloc + 1,
>                                              sizeof(*obj->efile.reloc));
>                         if (!reloc) {
>                                 pr_warning("realloc failed\n");
> -                               err = -ENOMEM;
> -                       } else {
> -                               int n = nr_reloc - 1;
> +                               return -ENOMEM;
> +                       }
>
> -                               obj->efile.reloc = reloc;
> -                               obj->efile.nr_reloc = nr_reloc;
> +                       obj->efile.reloc = reloc;
> +                       obj->efile.nr_reloc++;
>
> -                               obj->efile.reloc[n].shdr = sh;
> -                               obj->efile.reloc[n].data = data;
> -                       }
> +                       obj->efile.reloc[nr_reloc].shdr = sh;
> +                       obj->efile.reloc[nr_reloc].data = data;
>                 } else if (sh.sh_type == SHT_NOBITS && strcmp(name, ".bss") == 0) {
>                         obj->efile.bss = data;
>                         obj->efile.bss_shndx = idx;
>                 } else {
>                         pr_debug("skip section(%d) %s\n", idx, name);
>                 }
> -               if (err)
> -                       goto out;
>         }
>
>         if (!obj->efile.strtabidx || obj->efile.strtabidx >= idx) {
>                 pr_warning("Corrupted ELF file: index of strtab invalid\n");
>                 return -LIBBPF_ERRNO__FORMAT;
>         }
> -       if (btf_data) {
> -               obj->btf = btf__new(btf_data->d_buf, btf_data->d_size);
> -               if (IS_ERR(obj->btf)) {
> -                       pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
> -                                  BTF_ELF_SEC, PTR_ERR(obj->btf));
> -                       obj->btf = NULL;
> -               } else {
> -                       err = btf__finalize_data(obj, obj->btf);
> -                       if (!err) {
> -                               bpf_object__sanitize_btf(obj);
> -                               err = btf__load(obj->btf);
> -                       }
> -                       if (err) {
> -                               pr_warning("Error finalizing and loading %s into kernel: %d. Ignored and continue.\n",
> -                                          BTF_ELF_SEC, err);
> -                               btf__free(obj->btf);
> -                               obj->btf = NULL;
> -                               err = 0;
> -                       }
> -               }
> -       }
> -       if (btf_ext_data) {
> -               if (!obj->btf) {
> -                       pr_debug("Ignore ELF section %s because its depending ELF section %s is not found.\n",
> -                                BTF_EXT_ELF_SEC, BTF_ELF_SEC);
> -               } else {
> -                       obj->btf_ext = btf_ext__new(btf_ext_data->d_buf,
> -                                                   btf_ext_data->d_size);
> -                       if (IS_ERR(obj->btf_ext)) {
> -                               pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
> -                                          BTF_EXT_ELF_SEC,
> -                                          PTR_ERR(obj->btf_ext));
> -                               obj->btf_ext = NULL;
> -                       } else {
> -                               bpf_object__sanitize_btf_ext(obj);
> -                       }
> -               }
> -       }
> +       err = bpf_object__load_btf(obj, btf_data, btf_ext_data);
> +       if (err)
> +               return err;
>         if (bpf_object__has_maps(obj)) {
>                 err = bpf_object__init_maps(obj, flags);
>                 if (err)
> -                       goto out;
> +                       return err;
>         }
>         err = bpf_object__init_prog_names(obj);
> -out:
>         return err;
>  }
>
> --
> 2.17.1
>
