Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6C347231
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 23:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfFOVIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 17:08:06 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41134 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfFOVIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 17:08:05 -0400
Received: by mail-qk1-f196.google.com with SMTP id c11so3949617qkk.8;
        Sat, 15 Jun 2019 14:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ntuHp0MsdT3l+lVsU9dBKByYEKVmggK9Ai2ERH2xpfI=;
        b=TEePjAJ0LiCeu/RkTzlEPKVIDa6E6CLvNMY3CbgZqntf6EHu1gDKOG4CG0wb5C5T4K
         as1oX+DvuIHBJ7yWKC4aio9KkceWqBq6AjjLz00UpSownBX6ZFzQMGPDQqaUVrGMUPsm
         kNhYeR+S/sJTjTUHFgZgGp6JR1F6EqewNDXY7batip7reOUB6eVIjCmlwaj6b5U5eVwN
         U5dvvmW1nKCJ6/EPX2u7Htodj/rW/Dpy2C6ws2w+6RFfy327BouhVsup/z3/SFvZ08vo
         ZCrR8845d82+zggAndBEyO+zeBmMjdfW/x2vXDinK9VJE4sWuwyeFlYI3zm+SH8gwZ73
         paGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ntuHp0MsdT3l+lVsU9dBKByYEKVmggK9Ai2ERH2xpfI=;
        b=pgypy3r4n3aylIWOsKczcoefrnEUVPik20DZK3XyDoCuf0H/pw33HAexYlXVkZCpCS
         Plc5DAVQ+kSSQaczpsEVmDYWTB5H6j1niUj3HK66gKbAJoLiFqcRsLKuazqvQec/8wD3
         zdGBW5zfVjjT+pZ/f0CEFG+UKsdh8q74C8myuqdlz3Awg/eP+8/4ChWO+xgyFow5V8WH
         Fl57PClZK1/vJyzEk/WfYtY3OSKqd121U4d0ub5wqzwhADy65uzohQPsiLTugmgGqqeQ
         a2LelN0IYRjgBYx0CxKD2BE1qdtHHsjoCZjhwEzU6S2Ahg4CnFce66Jj4QeVH+L1bWtf
         IynA==
X-Gm-Message-State: APjAAAVSjZbbQEV1rHcR1wUIET9yTHpy/yzdk4K2yrnp3MSJfXaAiDz+
        L03FALnH3VTrCCiU3TqkkgugEj8V7Ofm1Oxfd3M=
X-Google-Smtp-Source: APXvYqxLwoUOyBC/n+DEkTKn4buxctI4xog2bta6eKd6Ml3NEnw0r8pY61ngOWMsI9XAd+qSiEdfu9NF2sxmLTbm18U=
X-Received: by 2002:a05:620a:12f8:: with SMTP id f24mr26430669qkl.202.1560632884560;
 Sat, 15 Jun 2019 14:08:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190611043505.14664-1-andriin@fb.com> <20190611043505.14664-5-andriin@fb.com>
In-Reply-To: <20190611043505.14664-5-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sat, 15 Jun 2019 14:07:53 -0700
Message-ID: <CAPhsuW6iicoRN3Sk6Uv-ten4xjjmqG1qmfmXyKngqVSYC9qbEQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 4/8] libbpf: identify maps by section index
 in addition to offset
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

On Mon, Jun 10, 2019 at 9:37 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> To support maps to be defined in multiple sections, it's important to
> identify map not just by offset within its section, but section index as
> well. This patch adds tracking of section index.
>
> For global data, we record section index of corresponding
> .data/.bss/.rodata ELF section for uniformity, and thus don't need
> a special value of offset for those maps.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 42 ++++++++++++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 16 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index c931ee7e1fd2..5e7ea7dac958 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -207,7 +207,8 @@ static const char * const libbpf_type_to_btf_name[] = {
>  struct bpf_map {
>         int fd;
>         char *name;
> -       size_t offset;
> +       int sec_idx;
> +       size_t sec_offset;
>         int map_ifindex;
>         int inner_map_fd;
>         struct bpf_map_def def;
> @@ -647,7 +648,9 @@ static int compare_bpf_map(const void *_a, const void *_b)
>         const struct bpf_map *a = _a;
>         const struct bpf_map *b = _b;
>
> -       return a->offset - b->offset;
> +       if (a->sec_idx != b->sec_idx)
> +               return a->sec_idx - b->sec_idx;
> +       return a->sec_offset - b->sec_offset;
>  }
>
>  static bool bpf_map_type__is_map_in_map(enum bpf_map_type type)
> @@ -800,14 +803,15 @@ static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
>
>  static int
>  bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *map,
> -                             enum libbpf_map_type type, Elf_Data *data,
> -                             void **data_buff)
> +                             enum libbpf_map_type type, int sec_idx,
> +                             Elf_Data *data, void **data_buff)
>  {
>         struct bpf_map_def *def = &map->def;
>         char map_name[BPF_OBJ_NAME_LEN];
>
>         map->libbpf_type = type;
> -       map->offset = ~(typeof(map->offset))0;
> +       map->sec_idx = sec_idx;
> +       map->sec_offset = 0;
>         snprintf(map_name, sizeof(map_name), "%.8s%.7s", obj->name,
>                  libbpf_type_to_btf_name[type]);
>         map->name = strdup(map_name);
> @@ -815,6 +819,8 @@ bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *map,
>                 pr_warning("failed to alloc map name\n");
>                 return -ENOMEM;
>         }
> +       pr_debug("map '%s' (global data): at sec_idx %d, offset %zu.\n",
> +                map_name, map->sec_idx, map->sec_offset);
>
>         def->type = BPF_MAP_TYPE_ARRAY;
>         def->key_size = sizeof(int);
> @@ -850,6 +856,7 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
>                 if (IS_ERR(map))
>                         return PTR_ERR(map);
>                 err = bpf_object__init_internal_map(obj, map, LIBBPF_MAP_DATA,
> +                                                   obj->efile.data_shndx,
>                                                     obj->efile.data,
>                                                     &obj->sections.data);
>                 if (err)
> @@ -860,6 +867,7 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
>                 if (IS_ERR(map))
>                         return PTR_ERR(map);
>                 err = bpf_object__init_internal_map(obj, map, LIBBPF_MAP_RODATA,
> +                                                   obj->efile.rodata_shndx,
>                                                     obj->efile.rodata,
>                                                     &obj->sections.rodata);
>                 if (err)
> @@ -870,6 +878,7 @@ static int bpf_object__init_global_data_maps(struct bpf_object *obj)
>                 if (IS_ERR(map))
>                         return PTR_ERR(map);
>                 err = bpf_object__init_internal_map(obj, map, LIBBPF_MAP_BSS,
> +                                                   obj->efile.bss_shndx,
>                                                     obj->efile.bss, NULL);
>                 if (err)
>                         return err;
> @@ -953,7 +962,10 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
>                 }
>
>                 map->libbpf_type = LIBBPF_MAP_UNSPEC;
> -               map->offset = sym.st_value;
> +               map->sec_idx = sym.st_shndx;
> +               map->sec_offset = sym.st_value;
> +               pr_debug("map '%s' (legacy): at sec_idx %d, offset %zu.\n",
> +                        map_name, map->sec_idx, map->sec_offset);
>                 if (sym.st_value + map_def_sz > data->d_size) {
>                         pr_warning("corrupted maps section in %s: last map \"%s\" too small\n",
>                                    obj->path, map_name);
> @@ -1453,9 +1465,13 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
>                                 if (maps[map_idx].libbpf_type != type)
>                                         continue;
>                                 if (type != LIBBPF_MAP_UNSPEC ||
> -                                   maps[map_idx].offset == sym.st_value) {
> -                                       pr_debug("relocation: find map %zd (%s) for insn %u\n",
> -                                                map_idx, maps[map_idx].name, insn_idx);
> +                                   (maps[map_idx].sec_idx == sym.st_shndx &&
> +                                    maps[map_idx].sec_offset == sym.st_value)) {
> +                                       pr_debug("relocation: found map %zd (%s, sec_idx %d, offset %zu) for insn %u\n",
> +                                                map_idx, maps[map_idx].name,
> +                                                maps[map_idx].sec_idx,
> +                                                maps[map_idx].sec_offset,
> +                                                insn_idx);
>                                         break;
>                                 }
>                         }
> @@ -3472,13 +3488,7 @@ bpf_object__find_map_fd_by_name(struct bpf_object *obj, const char *name)
>  struct bpf_map *
>  bpf_object__find_map_by_offset(struct bpf_object *obj, size_t offset)
>  {
> -       int i;
> -
> -       for (i = 0; i < obj->nr_maps; i++) {
> -               if (obj->maps[i].offset == offset)
> -                       return &obj->maps[i];
> -       }
> -       return ERR_PTR(-ENOENT);
> +       return ERR_PTR(-ENOTSUP);

I probably missed some discussion. But is it OK to stop supporting
this function?

Thanks,
Song

>  }
>
>  long libbpf_get_error(const void *ptr)
> --
> 2.17.1
>
