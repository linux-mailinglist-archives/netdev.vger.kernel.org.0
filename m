Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4754724D
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 00:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfFOWBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 18:01:12 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34469 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFOWBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 18:01:12 -0400
Received: by mail-qt1-f194.google.com with SMTP id m29so6728809qtu.1;
        Sat, 15 Jun 2019 15:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cFKaJXHZRmtu06NegiegMhEKKdZ4LHFBnNhWiTQ4waM=;
        b=FVcIrarqvPKODwCmTpYRYJU9Dxb9KTxUmmOxtWGcW5/RGfrlWXiD4n5/tRms1VrxGt
         gU9MqQZ8bQrTN2LGCrUOYwG3MwVUv8opUwZI1oskQ+Uezkzm1bSZuD5Z0AHOqR/wheVh
         YTJLuVWdP5Am24sYJcEgRewKGbN7PizHsa9Sio/9wE9TrI7z/IAHyfO61ubZNKtbc5n4
         NcAisEMV/8IH8YL0wNl7/FdyhkLFBofYz7L2xvuCoxQzI3qYeOin6L1CaGEEvp1CksjK
         X6ACh4J7LTCooqlvRDmWwC9WnIRQQUGHZ/emsHuj3/KzG11ddFhVcATC3GuI+AvZMKgU
         LajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cFKaJXHZRmtu06NegiegMhEKKdZ4LHFBnNhWiTQ4waM=;
        b=FpHQxyjjjWyzcVnfJ3msQPtz4NTp5dyntYlRMKDZ9vHTN9fiMd8iDj10aXyoVhATb1
         Xb3Wz45PKF44yFIAbbsBPmu4rb0sqiDxjgHyrgp7Uhg6hoN1idOZyFy/UYZr7F65Qs5d
         9WbU8+CdTbmqQ5Z0DMTPZ0uzHVSL9y6MHS1VMFclahAAe13na/P5L5wW439GT2bvM/UF
         ba5SX//Ts5eykEDRWzoKzgI353UYJkmGB7tanHkKZ6/wIt0EtO91sAX07JTQjVeLek9+
         MiVCEmwdtqDxNXye2fVv10BKhSXcQDnGac+UwuMSyZKzkEhOAD8L8nRiHPaH0IOBXon9
         u9BA==
X-Gm-Message-State: APjAAAWUlEH8eM+3WjPUOb9yi29CNDwtzTIwUNbR6FnQO8mcBCGjBmlp
        vnPpitFUuL5WwZID2SjXQKHz9yKl4fUqel186i0=
X-Google-Smtp-Source: APXvYqxVWSjZpNgVu0CPsuYb4H8+jec9FQolEjlXWbDkL0IigbSU/hhUrUKTNXv4glB0uwpaHv9h6xNSYpW4QK6rLeQ=
X-Received: by 2002:a0c:c68d:: with SMTP id d13mr14552510qvj.145.1560636070720;
 Sat, 15 Jun 2019 15:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190611044747.44839-1-andriin@fb.com> <20190611044747.44839-7-andriin@fb.com>
In-Reply-To: <20190611044747.44839-7-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sat, 15 Jun 2019 15:00:59 -0700
Message-ID: <CAPhsuW4-tmiBAji-=zx5gRRweioXTQM__EqaJGTPQ63SLphoUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
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
> This patch adds support for a new way to define BPF maps. It relies on
> BTF to describe mandatory and optional attributes of a map, as well as
> captures type information of key and value naturally. This eliminates
> the need for BPF_ANNOTATE_KV_PAIR hack and ensures key/value sizes are
> always in sync with the key/value type.
>
> Relying on BTF, this approach allows for both forward and backward
> compatibility w.r.t. extending supported map definition features. By
> default, any unrecognized attributes are treated as an error, but it's
> possible relax this using MAPS_RELAX_COMPAT flag. New attributes, added
> in the future will need to be optional.
>
> The outline of the new map definition (short, BTF-defined maps) is as follows:
> 1. All the maps should be defined in .maps ELF section. It's possible to
>    have both "legacy" map definitions in `maps` sections and BTF-defined
>    maps in .maps sections. Everything will still work transparently.
> 2. The map declaration and initialization is done through
>    a global/static variable of a struct type with few mandatory and
>    extra optional fields:
>    - type field is mandatory and specified type of BPF map;
>    - key/value fields are mandatory and capture key/value type/size information;
>    - max_entries attribute is optional; if max_entries is not specified or
>      initialized, it has to be provided in runtime through libbpf API
>      before loading bpf_object;
>    - map_flags is optional and if not defined, will be assumed to be 0.
> 3. Key/value fields should be **a pointer** to a type describing
>    key/value. The pointee type is assumed (and will be recorded as such
>    and used for size determination) to be a type describing key/value of
>    the map. This is done to save excessive amounts of space allocated in
>    corresponding ELF sections for key/value of big size.
> 4. As some maps disallow having BTF type ID associated with key/value,
>    it's possible to specify key/value size explicitly without
>    associating BTF type ID with it. Use key_size and value_size fields
>    to do that (see example below).
>
> Here's an example of simple ARRAY map defintion:
>
> struct my_value { int x, y, z; };
>
> struct {
>         int type;
>         int max_entries;
>         int *key;
>         struct my_value *value;
> } btf_map SEC(".maps") = {
>         .type = BPF_MAP_TYPE_ARRAY,
>         .max_entries = 16,
> };
>
> This will define BPF ARRAY map 'btf_map' with 16 elements. The key will
> be of type int and thus key size will be 4 bytes. The value is struct
> my_value of size 12 bytes. This map can be used from C code exactly the
> same as with existing maps defined through struct bpf_map_def.
>
> Here's an example of STACKMAP definition (which currently disallows BTF type
> IDs for key/value):
>
> struct {
>         __u32 type;
>         __u32 max_entries;
>         __u32 map_flags;
>         __u32 key_size;
>         __u32 value_size;
> } stackmap SEC(".maps") = {
>         .type = BPF_MAP_TYPE_STACK_TRACE,
>         .max_entries = 128,
>         .map_flags = BPF_F_STACK_BUILD_ID,
>         .key_size = sizeof(__u32),
>         .value_size = PERF_MAX_STACK_DEPTH * sizeof(struct bpf_stack_build_id),
> };
>
> This approach is naturally extended to support map-in-map, by making a value
> field to be another struct that describes inner map. This feature is not
> implemented yet. It's also possible to incrementally add features like pinning
> with full backwards and forward compatibility. Support for static
> initialization of BPF_MAP_TYPE_PROG_ARRAY using pointers to BPF programs
> is also on the roadmap.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/btf.h    |   1 +
>  tools/lib/bpf/libbpf.c | 338 +++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 330 insertions(+), 9 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index ba4ffa831aa4..88a52ae56fc6 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -17,6 +17,7 @@ extern "C" {
>
>  #define BTF_ELF_SEC ".BTF"
>  #define BTF_EXT_ELF_SEC ".BTF.ext"
> +#define MAPS_ELF_SEC ".maps"

How about .BTF.maps? Or maybe this doesn't realy matter?

>
>  struct btf;
>  struct btf_ext;
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 79a8143240d7..60713bcc2279 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -262,6 +262,7 @@ struct bpf_object {
>                 } *reloc;
>                 int nr_reloc;
>                 int maps_shndx;
> +               int btf_maps_shndx;
>                 int text_shndx;
>                 int data_shndx;
>                 int rodata_shndx;
> @@ -514,6 +515,7 @@ static struct bpf_object *bpf_object__new(const char *path,
>         obj->efile.obj_buf = obj_buf;
>         obj->efile.obj_buf_sz = obj_buf_sz;
>         obj->efile.maps_shndx = -1;
> +       obj->efile.btf_maps_shndx = -1;
>         obj->efile.data_shndx = -1;
>         obj->efile.rodata_shndx = -1;
>         obj->efile.bss_shndx = -1;
> @@ -1012,6 +1014,297 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
>         return 0;
>  }
>
> +static const struct btf_type *skip_mods_and_typedefs(const struct btf *btf,
> +                                                    __u32 id)
> +{
> +       const struct btf_type *t = btf__type_by_id(btf, id);
> +
> +       while (true) {
> +               switch (BTF_INFO_KIND(t->info)) {
> +               case BTF_KIND_VOLATILE:
> +               case BTF_KIND_CONST:
> +               case BTF_KIND_RESTRICT:
> +               case BTF_KIND_TYPEDEF:
> +                       t = btf__type_by_id(btf, t->type);
> +                       break;
> +               default:
> +                       return t;
> +               }
> +       }
> +}
> +
> +static bool get_map_attr_int(const char *map_name,
> +                            const struct btf *btf,
> +                            const struct btf_type *def,
> +                            const struct btf_member *m,
> +                            const void *data, __u32 *res) {

Can we avoid output pointer by return 0 for invalid types?

> +       const struct btf_type *t = skip_mods_and_typedefs(btf, m->type);
> +       const char *name = btf__name_by_offset(btf, m->name_off);
> +       __u32 int_info = *(const __u32 *)(const void *)(t + 1);
> +
> +       if (BTF_INFO_KIND(t->info) != BTF_KIND_INT) {
> +               pr_warning("map '%s': attr '%s': expected INT, got %u.\n",
> +                          map_name, name, BTF_INFO_KIND(t->info));
> +               return false;
> +       }
> +       if (t->size != 4 || BTF_INT_BITS(int_info) != 32 ||
> +           BTF_INT_OFFSET(int_info)) {
> +               pr_warning("map '%s': attr '%s': expected 32-bit non-bitfield integer, "
> +                          "got %u-byte (%d-bit) one with bit offset %d.\n",
> +                          map_name, name, t->size, BTF_INT_BITS(int_info),
> +                          BTF_INT_OFFSET(int_info));
> +               return false;
> +       }
> +       if (BTF_INFO_KFLAG(def->info) && BTF_MEMBER_BITFIELD_SIZE(m->offset)) {
> +               pr_warning("map '%s': attr '%s': bitfield is not supported.\n",
> +                          map_name, name);
> +               return false;
> +       }
> +       if (m->offset % 32) {

Shall we just do "m->offset > 0" here?

> +               pr_warning("map '%s': attr '%s': unaligned fields are not supported.\n",
> +                          map_name, name);
> +               return false;
> +       }
> +
> +       *res = *(const __u32 *)(data + m->offset / 8);
> +       return true;
> +}
> +
> +static int bpf_object__init_user_btf_map(struct bpf_object *obj,
> +                                        const struct btf_type *sec,
> +                                        int var_idx, int sec_idx,
> +                                        const Elf_Data *data, bool strict)
> +{
> +       const struct btf_type *var, *def, *t;
> +       const struct btf_var_secinfo *vi;
> +       const struct btf_var *var_extra;
> +       const struct btf_member *m;
> +       const void *def_data;
> +       const char *map_name;
> +       struct bpf_map *map;
> +       int vlen, i;
> +
> +       vi = (const struct btf_var_secinfo *)(const void *)(sec + 1) + var_idx;
> +       var = btf__type_by_id(obj->btf, vi->type);
> +       var_extra = (const void *)(var + 1);
> +       map_name = btf__name_by_offset(obj->btf, var->name_off);
> +       vlen = BTF_INFO_VLEN(var->info);
> +
> +       if (map_name == NULL || map_name[0] == '\0') {
> +               pr_warning("map #%d: empty name.\n", var_idx);
> +               return -EINVAL;
> +       }
> +       if ((__u64)vi->offset + vi->size > data->d_size) {
> +               pr_warning("map '%s' BTF data is corrupted.\n", map_name);
> +               return -EINVAL;
> +       }
> +       if (BTF_INFO_KIND(var->info) != BTF_KIND_VAR) {
> +               pr_warning("map '%s': unexpected var kind %u.\n",
> +                          map_name, BTF_INFO_KIND(var->info));
> +               return -EINVAL;
> +       }
> +       if (var_extra->linkage != BTF_VAR_GLOBAL_ALLOCATED &&
> +           var_extra->linkage != BTF_VAR_STATIC) {
> +               pr_warning("map '%s': unsupported var linkage %u.\n",
> +                          map_name, var_extra->linkage);
> +               return -EOPNOTSUPP;
> +       }
> +
> +       def = skip_mods_and_typedefs(obj->btf, var->type);
> +       if (BTF_INFO_KIND(def->info) != BTF_KIND_STRUCT) {
> +               pr_warning("map '%s': unexpected def kind %u.\n",
> +                          map_name, BTF_INFO_KIND(var->info));
> +               return -EINVAL;
> +       }
> +       if (def->size > vi->size) {
> +               pr_warning("map '%s': invalid def size.\n", map_name);
> +               return -EINVAL;
> +       }
> +
> +       map = bpf_object__add_map(obj);
> +       if (IS_ERR(map))
> +               return PTR_ERR(map);
> +       map->name = strdup(map_name);
> +       if (!map->name) {
> +               pr_warning("map '%s': failed to alloc map name.\n", map_name);
> +               return -ENOMEM;
> +       }
> +       map->libbpf_type = LIBBPF_MAP_UNSPEC;
> +       map->def.type = BPF_MAP_TYPE_UNSPEC;
> +       map->sec_idx = sec_idx;
> +       map->sec_offset = vi->offset;
> +       pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
> +                map_name, map->sec_idx, map->sec_offset);
> +
> +       def_data = data->d_buf + vi->offset;
> +       vlen = BTF_INFO_VLEN(def->info);
> +       m = (const void *)(def + 1);
> +       for (i = 0; i < vlen; i++, m++) {
> +               const char *name = btf__name_by_offset(obj->btf, m->name_off);
> +

I guess we need to check name == NULL here?

> +               if (strcmp(name, "type") == 0) {
> +                       if (!get_map_attr_int(map_name, obj->btf, def, m,
> +                                             def_data, &map->def.type))
> +                               return -EINVAL;
> +                       pr_debug("map '%s': found type = %u.\n",
> +                                map_name, map->def.type);
> +               } else if (strcmp(name, "max_entries") == 0) {
> +                       if (!get_map_attr_int(map_name, obj->btf, def, m,
> +                                             def_data, &map->def.max_entries))
> +                               return -EINVAL;
> +                       pr_debug("map '%s': found max_entries = %u.\n",
> +                                map_name, map->def.max_entries);
> +               } else if (strcmp(name, "map_flags") == 0) {
> +                       if (!get_map_attr_int(map_name, obj->btf, def, m,
> +                                             def_data, &map->def.map_flags))
> +                               return -EINVAL;
> +                       pr_debug("map '%s': found map_flags = %u.\n",
> +                                map_name, map->def.map_flags);
> +               } else if (strcmp(name, "key_size") == 0) {
> +                       __u32 sz;
> +
> +                       if (!get_map_attr_int(map_name, obj->btf, def, m,
> +                                             def_data, &sz))
> +                               return -EINVAL;
> +                       pr_debug("map '%s': found key_size = %u.\n",
> +                                map_name, sz);
> +                       if (map->def.key_size && map->def.key_size != sz) {
> +                               pr_warning("map '%s': conflictling key size %u != %u.\n",
> +                                          map_name, map->def.key_size, sz);
> +                               return -EINVAL;
> +                       }
> +                       map->def.key_size = sz;
> +               } else if (strcmp(name, "key") == 0) {
> +                       __s64 sz;
> +
> +                       t = btf__type_by_id(obj->btf, m->type);
> +                       if (BTF_INFO_KIND(t->info) != BTF_KIND_PTR) {

check t != NULL?

> +                               pr_warning("map '%s': key spec is not PTR: %u.\n",
> +                                          map_name, BTF_INFO_KIND(t->info));
> +                               return -EINVAL;
> +                       }
> +                       sz = btf__resolve_size(obj->btf, t->type);
> +                       if (sz < 0) {
> +                               pr_warning("map '%s': can't determine key size for type [%u]: %lld.\n",
> +                                          map_name, t->type, sz);
> +                               return sz;
> +                       }
> +                       pr_debug("map '%s': found key [%u], sz = %lld.\n",
> +                                map_name, t->type, sz);
> +                       if (map->def.key_size && map->def.key_size != sz) {
> +                               pr_warning("map '%s': conflictling key size %u != %lld.\n",
> +                                          map_name, map->def.key_size, sz);
> +                               return -EINVAL;
> +                       }
> +                       map->def.key_size = sz;
> +                       map->btf_key_type_id = t->type;
> +               } else if (strcmp(name, "value_size") == 0) {
> +                       __u32 sz;
> +
> +                       if (!get_map_attr_int(map_name, obj->btf, def, m,
> +                                             def_data, &sz))
> +                               return -EINVAL;
> +                       pr_debug("map '%s': found value_size = %u.\n",
> +                                map_name, sz);
> +                       if (map->def.value_size && map->def.value_size != sz) {
> +                               pr_warning("map '%s': conflictling value size %u != %u.\n",
> +                                          map_name, map->def.value_size, sz);
> +                               return -EINVAL;
> +                       }
> +                       map->def.value_size = sz;
> +               } else if (strcmp(name, "value") == 0) {
> +                       __s64 sz;
> +
> +                       t = btf__type_by_id(obj->btf, m->type);

ditto.

> +                       if (BTF_INFO_KIND(t->info) != BTF_KIND_PTR) {
> +                               pr_warning("map '%s': value spec is not PTR: %u.\n",
> +                                          map_name, BTF_INFO_KIND(t->info));
> +                               return -EINVAL;
> +                       }
> +                       sz = btf__resolve_size(obj->btf, t->type);
> +                       if (sz < 0) {
> +                               pr_warning("map '%s': can't determine value size for type [%u]: %lld.\n",
> +                                          map_name, t->type, sz);
> +                               return sz;
> +                       }
> +                       pr_debug("map '%s': found value [%u], sz = %lld.\n",
> +                                map_name, t->type, sz);
> +                       if (map->def.value_size && map->def.value_size != sz) {
> +                               pr_warning("map '%s': conflictling value size %u != %lld.\n",
> +                                          map_name, map->def.value_size, sz);
> +                               return -EINVAL;
> +                       }
> +                       map->def.value_size = sz;
> +                       map->btf_value_type_id = t->type;
> +               } else {
> +                       if (strict) {
> +                               pr_warning("map '%s': unknown attribute '%s'.\n",
> +                                          map_name, name);
> +                               return -ENOTSUP;
> +                       }
> +                       pr_debug("map '%s': ignoring unknown attribute '%s'.\n",
> +                                map_name, name);
> +               }
> +       }
> +
> +       if (map->def.type == BPF_MAP_TYPE_UNSPEC) {
> +               pr_warning("map '%s': map type isn't specified.\n", map_name);
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict)
> +{
> +       const struct btf_type *sec = NULL;
> +       int nr_types, i, vlen, err;
> +       const struct btf_type *t;
> +       const char *name;
> +       Elf_Data *data;
> +       Elf_Scn *scn;
> +
> +       if (obj->efile.btf_maps_shndx < 0)
> +               return 0;
> +
> +       scn = elf_getscn(obj->efile.elf, obj->efile.btf_maps_shndx);
> +       if (scn)
> +               data = elf_getdata(scn, NULL);
> +       if (!scn || !data) {
> +               pr_warning("failed to get Elf_Data from map section %d (%s)\n",
> +                          obj->efile.maps_shndx, MAPS_ELF_SEC);
> +               return -EINVAL;
> +       }
> +
> +       nr_types = btf__get_nr_types(obj->btf);
> +       for (i = 1; i <= nr_types; i++) {
> +               t = btf__type_by_id(obj->btf, i);
> +               if (BTF_INFO_KIND(t->info) != BTF_KIND_DATASEC)
> +                       continue;
> +               name = btf__name_by_offset(obj->btf, t->name_off);
> +               if (strcmp(name, MAPS_ELF_SEC) == 0) {
> +                       sec = t;
> +                       break;
> +               }
> +       }
> +
> +       if (!sec) {
> +               pr_warning("DATASEC '%s' not found.\n", MAPS_ELF_SEC);
> +               return -ENOENT;
> +       }
> +
> +       vlen = BTF_INFO_VLEN(sec->info);
> +       for (i = 0; i < vlen; i++) {
> +               err = bpf_object__init_user_btf_map(obj, sec, i,
> +                                                   obj->efile.btf_maps_shndx,
> +                                                   data, strict);
> +               if (err)
> +                       return err;
> +       }
> +
> +       return 0;
> +}
> +
>  static int bpf_object__init_maps(struct bpf_object *obj, int flags)
>  {
>         bool strict = !(flags & MAPS_RELAX_COMPAT);
> @@ -1021,6 +1314,10 @@ static int bpf_object__init_maps(struct bpf_object *obj, int flags)
>         if (err)
>                 return err;
>
> +       err = bpf_object__init_user_btf_maps(obj, strict);
> +       if (err)
> +               return err;
> +
>         err = bpf_object__init_global_data_maps(obj);
>         if (err)
>                 return err;
> @@ -1118,10 +1415,16 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
>         }
>  }
>
> +static bool bpf_object__is_btf_mandatory(const struct bpf_object *obj)
> +{
> +       return obj->efile.btf_maps_shndx >= 0;
> +}
> +
>  static int bpf_object__init_btf(struct bpf_object *obj,
>                                 Elf_Data *btf_data,
>                                 Elf_Data *btf_ext_data)
>  {
> +       bool btf_required = bpf_object__is_btf_mandatory(obj);
>         int err = 0;
>
>         if (btf_data) {
> @@ -1155,10 +1458,18 @@ static int bpf_object__init_btf(struct bpf_object *obj,
>         }
>  out:
>         if (err || IS_ERR(obj->btf)) {
> +               if (btf_required)
> +                       err = err ? : PTR_ERR(obj->btf);
> +               else
> +                       err = 0;
>                 if (!IS_ERR_OR_NULL(obj->btf))
>                         btf__free(obj->btf);
>                 obj->btf = NULL;
>         }
> +       if (btf_required && !obj->btf) {
> +               pr_warning("BTF is required, but is missing or corrupted.\n");
> +               return err == 0 ? -ENOENT : err;
> +       }
>         return 0;
>  }
>
> @@ -1178,6 +1489,8 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
>                            BTF_ELF_SEC, err);
>                 btf__free(obj->btf);
>                 obj->btf = NULL;
> +               if (bpf_object__is_btf_mandatory(obj))
> +                       return err;
>         }
>         return 0;
>  }
> @@ -1241,6 +1554,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>                                 return err;
>                 } else if (strcmp(name, "maps") == 0) {
>                         obj->efile.maps_shndx = idx;
> +               } else if (strcmp(name, MAPS_ELF_SEC) == 0) {
> +                       obj->efile.btf_maps_shndx = idx;
>                 } else if (strcmp(name, BTF_ELF_SEC) == 0) {
>                         btf_data = data;
>                 } else if (strcmp(name, BTF_EXT_ELF_SEC) == 0) {
> @@ -1360,7 +1675,8 @@ static bool bpf_object__shndx_is_data(const struct bpf_object *obj,
>  static bool bpf_object__shndx_is_maps(const struct bpf_object *obj,
>                                       int shndx)
>  {
> -       return shndx == obj->efile.maps_shndx;
> +       return shndx == obj->efile.maps_shndx ||
> +              shndx == obj->efile.btf_maps_shndx;
>  }
>
>  static bool bpf_object__relo_in_known_section(const struct bpf_object *obj,
> @@ -1404,14 +1720,14 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
>         prog->nr_reloc = nrels;
>
>         for (i = 0; i < nrels; i++) {
> -               GElf_Sym sym;
> -               GElf_Rel rel;
> -               unsigned int insn_idx;
> -               unsigned int shdr_idx;
>                 struct bpf_insn *insns = prog->insns;
>                 enum libbpf_map_type type;
> +               unsigned int insn_idx;
> +               unsigned int shdr_idx;
>                 const char *name;
>                 size_t map_idx;
> +               GElf_Sym sym;
> +               GElf_Rel rel;
>
>                 if (!gelf_getrel(data, i, &rel)) {
>                         pr_warning("relocation: failed to get %d reloc\n", i);
> @@ -1505,14 +1821,18 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
>         return 0;
>  }
>
> -static int bpf_map_find_btf_info(struct bpf_map *map, const struct btf *btf)
> +static int bpf_map_find_btf_info(struct bpf_object *obj, struct bpf_map *map)
>  {
>         struct bpf_map_def *def = &map->def;
>         __u32 key_type_id = 0, value_type_id = 0;
>         int ret;
>
> +       /* if it's BTF-defined map, we don't need to search for type IDs */
> +       if (map->sec_idx == obj->efile.btf_maps_shndx)
> +               return 0;
> +
>         if (!bpf_map__is_internal(map)) {
> -               ret = btf__get_map_kv_tids(btf, map->name, def->key_size,
> +               ret = btf__get_map_kv_tids(obj->btf, map->name, def->key_size,
>                                            def->value_size, &key_type_id,
>                                            &value_type_id);
>         } else {
> @@ -1520,7 +1840,7 @@ static int bpf_map_find_btf_info(struct bpf_map *map, const struct btf *btf)
>                  * LLVM annotates global data differently in BTF, that is,
>                  * only as '.data', '.bss' or '.rodata'.
>                  */
> -               ret = btf__find_by_name(btf,
> +               ret = btf__find_by_name(obj->btf,
>                                 libbpf_type_to_btf_name[map->libbpf_type]);
>         }
>         if (ret < 0)
> @@ -1810,7 +2130,7 @@ bpf_object__create_maps(struct bpf_object *obj)
>                     map->inner_map_fd >= 0)
>                         create_attr.inner_map_fd = map->inner_map_fd;
>
> -               if (obj->btf && !bpf_map_find_btf_info(map, obj->btf)) {
> +               if (obj->btf && !bpf_map_find_btf_info(obj, map)) {
>                         create_attr.btf_fd = btf__fd(obj->btf);
>                         create_attr.btf_key_type_id = map->btf_key_type_id;
>                         create_attr.btf_value_type_id = map->btf_value_type_id;
> --
> 2.17.1
>
