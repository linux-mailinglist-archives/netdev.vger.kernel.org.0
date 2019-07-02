Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496F05D6C4
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 21:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfGBTT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 15:19:26 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:32873 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBTT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 15:19:26 -0400
Received: by mail-io1-f66.google.com with SMTP id u13so39804305iop.0;
        Tue, 02 Jul 2019 12:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jj7FM10GGw9q3dDZVUOh3Yh5IcJhiWR7QuX1TKdawgw=;
        b=VZuvAxSwOebFTbKE5pijLwYJZdahs1Tx9+GY7Sd9JJgalSi5fwx9kgg88V/f3UpZvF
         0vbEJgvJ5l9kM5FW+uqJn0X7lF0vyiilE2ld0euwMDa3A0Ubs1U3Hg9T36kK86OFwtR3
         j2XqCbiTzTl80OmrgZaUSIHeGn4bWRj2NehfmjIKR5p/Uev0FHcSz/R8xs2/foRJM5GJ
         o3QhlXaMxuKdRQdbN4uhOukxWVfZ+sHvipw+T5N5HXDG5zOgcLWgJbOyOldUGlSrUAyx
         medl04AhHSOQ2YFlrcfjtrRPXf9qWBfEzsQL/uEsq11GASm7+KE+p5oMhjacrot2wo87
         DO+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jj7FM10GGw9q3dDZVUOh3Yh5IcJhiWR7QuX1TKdawgw=;
        b=btZczrkiJuylY6/1wA9pFYaAPTU7khwd0n1ckgJoL4NlTx1PtTz5N+iZ2vnqq3ESq+
         +3wNo4TYU/YOuDaZHsJ+IyUbeIf8vYIbiuSpIerXUUCv6FhIl8qyFScFJSS/ZDSACi9O
         d8KiPC5UP07HrnVee9iBxGp9zcp3gagzgvEVwginV4AWrqmQY4ptu+sqSUVULtltpa/I
         hw1HDjYy87R4EZo7oyMz5NaXs1j9CDkz6IJUzSJFncWzb/p0g/d8RNSw2J4IL6zgv/es
         /SxtcCSMrH4S7eWtjw4VH7CxUFR9imG+mc1NrYbwFOGgPqGNW83JOt5MF64lSd+bGrU2
         V/Xg==
X-Gm-Message-State: APjAAAVgGS7xCxj1XZ/YQnQvTQKhahxghKeIyZ8Hb2kvoUNHYhoXyM9B
        +LrBfBJWC/TTzf9fPtn/LxLdUShBCf6oMyUJPes=
X-Google-Smtp-Source: APXvYqw4Jx/yEOS/+S4RuN1mg9+WfXiCgBTDQpAIV7hIhJkfh3qp4kAguMQNCD2SDh7f7Wg3ZngwWdvcHwNJqk6UU7E=
X-Received: by 2002:a5d:8f86:: with SMTP id l6mr6650824iol.97.1562095164725;
 Tue, 02 Jul 2019 12:19:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190628152539.3014719-1-andriin@fb.com> <20190628152539.3014719-2-andriin@fb.com>
In-Reply-To: <20190628152539.3014719-2-andriin@fb.com>
From:   Y Song <ys114321@gmail.com>
Date:   Tue, 2 Jul 2019 12:18:48 -0700
Message-ID: <CAH3MdRXm9EnP-jqLQb-1o7KhtE2Dd3QWhPDF3SHou_At19u-CQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] libbpf: capture value in BTF type info
 for BTF-defined map defs
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 8:26 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Change BTF-defined map definitions to capture compile-time integer
> values as part of BTF type definition, to avoid split of key/value type
> information and actual type/size/flags initialization for maps.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 58 ++++++++++++++++++++----------------------
>  1 file changed, 28 insertions(+), 30 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 6e6ebef11ba3..9e099ecb2c2b 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1028,40 +1028,40 @@ static const struct btf_type *skip_mods_and_typedefs(const struct btf *btf,
>         }
>  }
>
> -static bool get_map_field_int(const char *map_name,
> -                             const struct btf *btf,
> +/*
> + * Fetch integer attribute of BTF map definition. Such attributes are
> + * represented using a pointer to an array, in which dimensionality of array
> + * encodes specified integer value. E.g., int (*type)[BPF_MAP_TYPE_ARRAY];
> + * encodes `type => BPF_MAP_TYPE_ARRAY` key/value pair completely using BTF
> + * type definition, while using only sizeof(void *) space in ELF data section.
> + */
> +static bool get_map_field_int(const char *map_name, const struct btf *btf,
>                               const struct btf_type *def,
> -                             const struct btf_member *m,
> -                             const void *data, __u32 *res) {
> +                             const struct btf_member *m, __u32 *res) {
>         const struct btf_type *t = skip_mods_and_typedefs(btf, m->type);
>         const char *name = btf__name_by_offset(btf, m->name_off);
> -       __u32 int_info = *(const __u32 *)(const void *)(t + 1);
> +       const struct btf_array *arr_info;
> +       const struct btf_type *arr_t;
>
> -       if (BTF_INFO_KIND(t->info) != BTF_KIND_INT) {
> -               pr_warning("map '%s': attr '%s': expected INT, got %u.\n",
> +       if (BTF_INFO_KIND(t->info) != BTF_KIND_PTR) {
> +               pr_warning("map '%s': attr '%s': expected PTR, got %u.\n",
>                            map_name, name, BTF_INFO_KIND(t->info));
>                 return false;
>         }
> -       if (t->size != 4 || BTF_INT_BITS(int_info) != 32 ||
> -           BTF_INT_OFFSET(int_info)) {
> -               pr_warning("map '%s': attr '%s': expected 32-bit non-bitfield integer, "
> -                          "got %u-byte (%d-bit) one with bit offset %d.\n",
> -                          map_name, name, t->size, BTF_INT_BITS(int_info),
> -                          BTF_INT_OFFSET(int_info));
> -               return false;
> -       }
> -       if (BTF_INFO_KFLAG(def->info) && BTF_MEMBER_BITFIELD_SIZE(m->offset)) {
> -               pr_warning("map '%s': attr '%s': bitfield is not supported.\n",
> -                          map_name, name);
> +
> +       arr_t = btf__type_by_id(btf, t->type);
> +       if (!arr_t) {
> +               pr_warning("map '%s': attr '%s': type [%u] not found.\n",
> +                          map_name, name, t->type);
>                 return false;
>         }
> -       if (m->offset % 32) {
> -               pr_warning("map '%s': attr '%s': unaligned fields are not supported.\n",
> -                          map_name, name);
> +       if (BTF_INFO_KIND(arr_t->info) != BTF_KIND_ARRAY) {
> +               pr_warning("map '%s': attr '%s': expected ARRAY, got %u.\n",
> +                          map_name, name, BTF_INFO_KIND(arr_t->info));
>                 return false;
>         }
> -
> -       *res = *(const __u32 *)(data + m->offset / 8);
> +       arr_info = (const void *)(arr_t + 1);
> +       *res = arr_info->nelems;

Here, we use number of array elements (__u32 type) as the value.

But we have
  #define __int(name, val) int (*name)[val]
which suggests that "val" have type "int".

Do you think using __uint(name, val) may be more consistent?
If this is something to be enforced, it may be worthwhile to check
array element type should be __uint, just in case that in the
future we have different array element type (e.g., int)
for different purpose.

>         return true;
>  }
>
> @@ -1074,7 +1074,6 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
>         const struct btf_var_secinfo *vi;
>         const struct btf_var *var_extra;
>         const struct btf_member *m;
> -       const void *def_data;
>         const char *map_name;
>         struct bpf_map *map;
>         int vlen, i;
> @@ -1131,7 +1130,6 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
>         pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
>                  map_name, map->sec_idx, map->sec_offset);
>
> -       def_data = data->d_buf + vi->offset;
>         vlen = BTF_INFO_VLEN(def->info);
>         m = (const void *)(def + 1);
>         for (i = 0; i < vlen; i++, m++) {
> @@ -1144,19 +1142,19 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
>                 }
>                 if (strcmp(name, "type") == 0) {
>                         if (!get_map_field_int(map_name, obj->btf, def, m,
> -                                              def_data, &map->def.type))
> +                                              &map->def.type))
>                                 return -EINVAL;
>                         pr_debug("map '%s': found type = %u.\n",
>                                  map_name, map->def.type);
>                 } else if (strcmp(name, "max_entries") == 0) {
>                         if (!get_map_field_int(map_name, obj->btf, def, m,
> -                                              def_data, &map->def.max_entries))
> +                                              &map->def.max_entries))
>                                 return -EINVAL;
>                         pr_debug("map '%s': found max_entries = %u.\n",
>                                  map_name, map->def.max_entries);
>                 } else if (strcmp(name, "map_flags") == 0) {
>                         if (!get_map_field_int(map_name, obj->btf, def, m,
> -                                              def_data, &map->def.map_flags))
> +                                              &map->def.map_flags))
>                                 return -EINVAL;
>                         pr_debug("map '%s': found map_flags = %u.\n",
>                                  map_name, map->def.map_flags);
> @@ -1164,7 +1162,7 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
>                         __u32 sz;
>
>                         if (!get_map_field_int(map_name, obj->btf, def, m,
> -                                              def_data, &sz))
> +                                              &sz))
>                                 return -EINVAL;
>                         pr_debug("map '%s': found key_size = %u.\n",
>                                  map_name, sz);
> @@ -1207,7 +1205,7 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
>                         __u32 sz;
>
>                         if (!get_map_field_int(map_name, obj->btf, def, m,
> -                                              def_data, &sz))
> +                                              &sz))
>                                 return -EINVAL;
>                         pr_debug("map '%s': found value_size = %u.\n",
>                                  map_name, sz);
> --
> 2.17.1
>
