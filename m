Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A740A48A09
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfFQRZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:25:08 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40074 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfFQRZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:25:08 -0400
Received: by mail-qt1-f195.google.com with SMTP id a15so11660680qtn.7;
        Mon, 17 Jun 2019 10:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+uLNEqitEN9yWx5zqCH7G0cjk5OdAqSKAXtTu5REW1E=;
        b=A4X+pL7M6Ck2qtZvO1mxldxN+m8JWEMa+j9P+HkDRoiNoeADC9EskjyCkVGhjbuUqV
         qZk9DhJIKoOtJni4dJpJ4EkOHFwmpanSDrAse8fQl0OP0a30UkTjMinlkAwLeHOLrU0W
         4TNTtvh3RKCnoatQ+muf2ciqchS5B208ILlGRuxJvXyPv/KJao8lXjyh3LFwHJAtLVxg
         HKwE5ZrakQAuFU5aVxKkHhyXlWSYMhoWj5gwshp+BXZs4PEusWtdJqFrvT1F9t3x+zZ0
         x5/oQlgpj/ZkXdlWiqzaqkqEnbK/EjKWU8nxb8amB3PSFUgSk4OzmCVeU+NhmQs6wa4h
         Fdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+uLNEqitEN9yWx5zqCH7G0cjk5OdAqSKAXtTu5REW1E=;
        b=ZU+u8EVqTlFJdsjDXNP5cZaqAWuWUIzeijXqQqSm9IDWNYfaZs3ElOjwA6OxaDwpEd
         iPF2VawRN/YWH4tkvh/7dpFI0VM5EEeu8ua28iiT6UOHhB/pa12rDzM7O4U+oFnTT3WI
         TuKmasmb/VHX0Ubu649Tu/dBA15Oh7ecJ9EE0dOSi6KdX/Tnh1NMQlpG49L1TeK/F9uR
         FQLLlnAr9OV6iZaowznN1bwdqxyuZjWQtzaafDIZUwHxoQLo/VQk5tXmYdgwxTgG2BNQ
         icyYm3VrtOU4xjcaJZjU5yLKOBrMrMP/qsWaYG5fRk3OnyOFqT9dBtyaS0dx8O/AJbbR
         uAnA==
X-Gm-Message-State: APjAAAVsDyjYfbcAj3ogdRoYwglAtZV/ekBN/4nU+9OUwynRG+b+8rU8
        e1phUf2DanNZKGSd6GHEusYPXfAtNSZ2lXAUzFE=
X-Google-Smtp-Source: APXvYqwDiGwVPzWPOFa0n5E5nFo9+5nfV82m5L6DWsewOv8CRhWFYo2DBWuj3wQLh0GO4F//HBT+pzE3mgLwtwiFmQs=
X-Received: by 2002:ac8:2a63:: with SMTP id l32mr75906884qtl.117.1560792306002;
 Mon, 17 Jun 2019 10:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190611044747.44839-1-andriin@fb.com> <20190611044747.44839-3-andriin@fb.com>
 <CAPhsuW6kAN=gMjtXiAJazDFTszuq4xE-9OQTP_GhDX2cxym0NQ@mail.gmail.com>
In-Reply-To: <CAPhsuW6kAN=gMjtXiAJazDFTszuq4xE-9OQTP_GhDX2cxym0NQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 17 Jun 2019 10:24:54 -0700
Message-ID: <CAEf4BzY_X9jPvwgcVQozS4RyonXEK9mkd58uvPVrjFi-Gvui3Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/8] libbpf: extract BTF loading and simplify ELF
 parsing logic
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 1:26 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Mon, Jun 10, 2019 at 9:49 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > As a preparation for adding BTF-based BPF map loading, extract .BTF and
> > .BTF.ext loading logic. Also simplify error handling in
> > bpf_object__elf_collect() by returning early, as there is no common
> > clean up to be done.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 137 ++++++++++++++++++++++-------------------
> >  1 file changed, 75 insertions(+), 62 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index ba89d9727137..9e39a0a33aeb 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -1078,6 +1078,58 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
> >         }
> >  }
> >
> > +static int bpf_object__load_btf(struct bpf_object *obj,
> > +                               Elf_Data *btf_data,
> > +                               Elf_Data *btf_ext_data)
> > +{
> > +       int err = 0;
> > +
> > +       if (btf_data) {
> > +               obj->btf = btf__new(btf_data->d_buf, btf_data->d_size);
> > +               if (IS_ERR(obj->btf)) {
> > +                       pr_warning("Error loading ELF section %s: %d.\n",
> > +                                  BTF_ELF_SEC, err);
> > +                       goto out;
>
> If we goto out here, we will return 0.


Yes, it's intentional. BTF is treated as optional, so if we fail to
load it, libbpf will emit warning, but will proceed as nothing
happened and no BTF was supposed to be loaded.

>
> > +               }
> > +               err = btf__finalize_data(obj, obj->btf);
> > +               if (err) {
> > +                       pr_warning("Error finalizing %s: %d.\n",
> > +                                  BTF_ELF_SEC, err);
> > +                       goto out;
> > +               }
> > +               bpf_object__sanitize_btf(obj);
> > +               err = btf__load(obj->btf);
> > +               if (err) {
> > +                       pr_warning("Error loading %s into kernel: %d.\n",
> > +                                  BTF_ELF_SEC, err);
> > +                       goto out;
> > +               }
> > +       }
> > +       if (btf_ext_data) {
> > +               if (!obj->btf) {
> > +                       pr_debug("Ignore ELF section %s because its depending ELF section %s is not found.\n",
> > +                                BTF_EXT_ELF_SEC, BTF_ELF_SEC);
> > +                       goto out;
>
> We will also return 0 when goto out here.


See above, it's original behavior of libbpf.

>
> > +               }
> > +               obj->btf_ext = btf_ext__new(btf_ext_data->d_buf,
> > +                                           btf_ext_data->d_size);
> > +               if (IS_ERR(obj->btf_ext)) {
> > +                       pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
> > +                                  BTF_EXT_ELF_SEC, PTR_ERR(obj->btf_ext));
> > +                       obj->btf_ext = NULL;
> > +                       goto out;
> And, here. And we will not free obj->btf.

This is situation in which we successfully loaded .BTF, but failed to
load .BTF.ext. In that case we'll warn about .BTF.ext, but will drop
it and continue with .BTF only.

>
> > +               }
> > +               bpf_object__sanitize_btf_ext(obj);
> > +       }
> > +out:
> > +       if (err || IS_ERR(obj->btf)) {
> > +               if (!IS_ERR_OR_NULL(obj->btf))
> > +                       btf__free(obj->btf);
> > +               obj->btf = NULL;
> > +       }
> > +       return 0;
> > +}
> > +
> >  static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
> >  {
> >         Elf *elf = obj->efile.elf;
> > @@ -1102,24 +1154,21 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
> >                 if (gelf_getshdr(scn, &sh) != &sh) {
> >                         pr_warning("failed to get section(%d) header from %s\n",
> >                                    idx, obj->path);
> > -                       err = -LIBBPF_ERRNO__FORMAT;
> > -                       goto out;
> > +                       return -LIBBPF_ERRNO__FORMAT;
> >                 }
> >
> >                 name = elf_strptr(elf, ep->e_shstrndx, sh.sh_name);
> >                 if (!name) {
> >                         pr_warning("failed to get section(%d) name from %s\n",
> >                                    idx, obj->path);
> > -                       err = -LIBBPF_ERRNO__FORMAT;
> > -                       goto out;
> > +                       return -LIBBPF_ERRNO__FORMAT;
> >                 }
> >
> >                 data = elf_getdata(scn, 0);
> >                 if (!data) {
> >                         pr_warning("failed to get section(%d) data from %s(%s)\n",
> >                                    idx, name, obj->path);
> > -                       err = -LIBBPF_ERRNO__FORMAT;
> > -                       goto out;
> > +                       return -LIBBPF_ERRNO__FORMAT;
> >                 }
> >                 pr_debug("section(%d) %s, size %ld, link %d, flags %lx, type=%d\n",
> >                          idx, name, (unsigned long)data->d_size,
> > @@ -1130,10 +1179,14 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
> >                         err = bpf_object__init_license(obj,
> >                                                        data->d_buf,
> >                                                        data->d_size);
> > +                       if (err)
> > +                               return err;
> >                 } else if (strcmp(name, "version") == 0) {
> >                         err = bpf_object__init_kversion(obj,
> >                                                         data->d_buf,
> >                                                         data->d_size);
> > +                       if (err)
> > +                               return err;
> >                 } else if (strcmp(name, "maps") == 0) {
> >                         obj->efile.maps_shndx = idx;
> >                 } else if (strcmp(name, BTF_ELF_SEC) == 0) {
> > @@ -1144,11 +1197,10 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
> >                         if (obj->efile.symbols) {
> >                                 pr_warning("bpf: multiple SYMTAB in %s\n",
> >                                            obj->path);
> > -                               err = -LIBBPF_ERRNO__FORMAT;
> > -                       } else {
> > -                               obj->efile.symbols = data;
> > -                               obj->efile.strtabidx = sh.sh_link;
> > +                               return -LIBBPF_ERRNO__FORMAT;
> >                         }
> > +                       obj->efile.symbols = data;
> > +                       obj->efile.strtabidx = sh.sh_link;
> >                 } else if (sh.sh_type == SHT_PROGBITS && data->d_size > 0) {
> >                         if (sh.sh_flags & SHF_EXECINSTR) {
> >                                 if (strcmp(name, ".text") == 0)
> > @@ -1162,6 +1214,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
> >
> >                                         pr_warning("failed to alloc program %s (%s): %s",
> >                                                    name, obj->path, cp);
> > +                                       return err;
> >                                 }
> >                         } else if (strcmp(name, ".data") == 0) {
> >                                 obj->efile.data = data;
> > @@ -1173,8 +1226,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
> >                                 pr_debug("skip section(%d) %s\n", idx, name);
> >                         }
> >                 } else if (sh.sh_type == SHT_REL) {
> > +                       int nr_reloc = obj->efile.nr_reloc;
> >                         void *reloc = obj->efile.reloc;
> > -                       int nr_reloc = obj->efile.nr_reloc + 1;
> >                         int sec = sh.sh_info; /* points to other section */
> >
> >                         /* Only do relo for section with exec instructions */
> > @@ -1184,79 +1237,39 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
> >                                 continue;
> >                         }
> >
> > -                       reloc = reallocarray(reloc, nr_reloc,
> > +                       reloc = reallocarray(reloc, nr_reloc + 1,
> >                                              sizeof(*obj->efile.reloc));
> >                         if (!reloc) {
> >                                 pr_warning("realloc failed\n");
> > -                               err = -ENOMEM;
> > -                       } else {
> > -                               int n = nr_reloc - 1;
> > +                               return -ENOMEM;
> > +                       }
> >
> > -                               obj->efile.reloc = reloc;
> > -                               obj->efile.nr_reloc = nr_reloc;
> > +                       obj->efile.reloc = reloc;
> > +                       obj->efile.nr_reloc++;
> >
> > -                               obj->efile.reloc[n].shdr = sh;
> > -                               obj->efile.reloc[n].data = data;
> > -                       }
> > +                       obj->efile.reloc[nr_reloc].shdr = sh;
> > +                       obj->efile.reloc[nr_reloc].data = data;
> >                 } else if (sh.sh_type == SHT_NOBITS && strcmp(name, ".bss") == 0) {
> >                         obj->efile.bss = data;
> >                         obj->efile.bss_shndx = idx;
> >                 } else {
> >                         pr_debug("skip section(%d) %s\n", idx, name);
> >                 }
> > -               if (err)
> > -                       goto out;
> >         }
> >
> >         if (!obj->efile.strtabidx || obj->efile.strtabidx >= idx) {
> >                 pr_warning("Corrupted ELF file: index of strtab invalid\n");
> >                 return -LIBBPF_ERRNO__FORMAT;
> >         }
> > -       if (btf_data) {
> > -               obj->btf = btf__new(btf_data->d_buf, btf_data->d_size);
> > -               if (IS_ERR(obj->btf)) {
> > -                       pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
> > -                                  BTF_ELF_SEC, PTR_ERR(obj->btf));
> > -                       obj->btf = NULL;
> > -               } else {
> > -                       err = btf__finalize_data(obj, obj->btf);
> > -                       if (!err) {
> > -                               bpf_object__sanitize_btf(obj);
> > -                               err = btf__load(obj->btf);
> > -                       }
> > -                       if (err) {
> > -                               pr_warning("Error finalizing and loading %s into kernel: %d. Ignored and continue.\n",
> > -                                          BTF_ELF_SEC, err);
> > -                               btf__free(obj->btf);
> > -                               obj->btf = NULL;
> > -                               err = 0;
> > -                       }
> > -               }
> > -       }
> > -       if (btf_ext_data) {
> > -               if (!obj->btf) {
> > -                       pr_debug("Ignore ELF section %s because its depending ELF section %s is not found.\n",
> > -                                BTF_EXT_ELF_SEC, BTF_ELF_SEC);
> > -               } else {
> > -                       obj->btf_ext = btf_ext__new(btf_ext_data->d_buf,
> > -                                                   btf_ext_data->d_size);
> > -                       if (IS_ERR(obj->btf_ext)) {
> > -                               pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
> > -                                          BTF_EXT_ELF_SEC,
> > -                                          PTR_ERR(obj->btf_ext));
> > -                               obj->btf_ext = NULL;
> > -                       } else {
> > -                               bpf_object__sanitize_btf_ext(obj);
> > -                       }
> > -               }
> > -       }
> > +       err = bpf_object__load_btf(obj, btf_data, btf_ext_data);
> > +       if (err)
> > +               return err;
> >         if (bpf_object__has_maps(obj)) {
> >                 err = bpf_object__init_maps(obj, flags);
> >                 if (err)
> > -                       goto out;
> > +                       return err;
> >         }
> >         err = bpf_object__init_prog_names(obj);
> > -out:
> >         return err;
> >  }
> >
> > --
> > 2.17.1
> >
