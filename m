Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7741A129A9C
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 20:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfLWTya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 14:54:30 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38772 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfLWTya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 14:54:30 -0500
Received: by mail-qt1-f196.google.com with SMTP id n15so16283792qtp.5;
        Mon, 23 Dec 2019 11:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Z8mJitHlh8Ttp0FqGlEbh0Zh56mutdI8yhN/EVuZNk=;
        b=NDtalJPYKSa+EFpUmZpogyUZHTCGYo2AjgApFRSaNQJDptshzlRt0fmEzyxlelNK3T
         9PQVX6BQOiI0YldAWWbo0o6iUHc4oAX278FJwkAFhc2LmhTxlToWDdjfgbTvkbJ3KVKp
         hdfHdAM/KvKE7K/BlJldHi2mJBf9VQ8PGHmgDtvcLsYv09iVWQqjioz94JVQEUG0t/lQ
         Nyip1eDGdd+l004LjGqeKxxYGU7DibvhluejTM4K2RwEAyzhcRDa2dIGOk4e6xApVU9f
         4x1XD3k7X3V4ufoV+NZHCSSkVZ6q39hH6oxmRMMrup79K5rmZoA/EgJwiS6xyJPLJJVy
         uxGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Z8mJitHlh8Ttp0FqGlEbh0Zh56mutdI8yhN/EVuZNk=;
        b=NCZrpruG1Bxi1xkeipnzHrOXTiyOZEqYPdGAELor6w78uT8uXvtUFjtsBKAJLZfoT0
         aXpwMOpSEmb/leHh4YAE+Wtr+4OP1fynqy8wJGYp56OxnwMASk0peHhi9HwpeJlD9TkZ
         aDO27ZmF70lK3zBgPoMpXaZhcv+NpiEUTHV0mQKjVEgijS7ESg5wil5+J/GxLlIMoZAA
         MwiInaXMZrgITJ9cxP/u6ZHqc+UZxmXHaiUUTXi1x8iwXJQVX+6w9dXwZ6ZWCRTU7xmw
         HTGt3yLkSDB4aq/HyzTlEqmbf4xI/DjRzTWFs0PyfBaYdUCq1Y7o7G4oE4uOfRehj9nm
         N41Q==
X-Gm-Message-State: APjAAAXh1m0j7Mk3GEPskjVodNBexA2eltJvBJ+KLOTXgdMC6Au/C+vd
        DyfxUYnLCK+mAT5UfOY8lBBXp7Ov08DONrxXrr7IpbAF
X-Google-Smtp-Source: APXvYqzUjs7H7E7VV7odAqBNLEtc5BowRiHsgRR8lHZpMaGeA1MyRsgTOhaUt4Rz/+amRO4+ydRtvJJYyEfmp4zo7ic=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr24324586qtj.117.1577130869082;
 Mon, 23 Dec 2019 11:54:29 -0800 (PST)
MIME-Version: 1.0
References: <20191221062556.1182261-1-kafai@fb.com> <20191221062617.1183905-1-kafai@fb.com>
In-Reply-To: <20191221062617.1183905-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Dec 2019 11:54:17 -0800
Message-ID: <CAEf4BzY5wopSFj2B2_Q9VtNGoGtzyZ7MOUv1oDugCXma1kk3UA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 10/11] bpf: libbpf: Add STRUCT_OPS support
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch adds BPF STRUCT_OPS support to libbpf.
>
> The only sec_name convention is SEC(".struct_ops") to identify the
> struct_ops implemented in BPF,
> e.g. To implement a tcp_congestion_ops:
>
> SEC(".struct_ops")
> struct tcp_congestion_ops dctcp = {
>         .init           = (void *)dctcp_init,  /* <-- a bpf_prog */
>         /* ... some more func prts ... */
>         .name           = "bpf_dctcp",
> };
>
> Each struct_ops is defined as a global variable under SEC(".struct_ops")
> as above.  libbpf creates a map for each variable and the variable name
> is the map's name.  Multiple struct_ops is supported under
> SEC(".struct_ops").
>
> In the bpf_object__open phase, libbpf will look for the SEC(".struct_ops")
> section and find out what is the btf-type the struct_ops is
> implementing.  Note that the btf-type here is referring to
> a type in the bpf_prog.o's btf.  A "struct bpf_map" is added
> by bpf_object__add_map() as other maps do.  It will then
> collect (through SHT_REL) where are the bpf progs that the
> func ptrs are referring to.  No btf_vmlinux is needed in
> the open phase.
>
> In the bpf_object__load phase, the map-fields, which depend
> on the btf_vmlinux, are initialized (in bpf_map__init_kern_struct_ops()).
> It will also set the prog->type, prog->attach_btf_id, and
> prog->expected_attach_type.  Thus, the prog's properties do
> not rely on its section name.
> [ Currently, the bpf_prog's btf-type ==> btf_vmlinux's btf-type matching
>   process is as simple as: member-name match + btf-kind match + size match.
>   If these matching conditions fail, libbpf will reject.
>   The current targeting support is "struct tcp_congestion_ops" which
>   most of its members are function pointers.
>   The member ordering of the bpf_prog's btf-type can be different from
>   the btf_vmlinux's btf-type. ]
>
> Then, all obj->maps are created as usual (in bpf_object__create_maps()).
>
> Once the maps are created and prog's properties are all set,
> the libbpf will proceed to load all the progs.
>
> bpf_map__attach_struct_ops() is added to register a struct_ops
> map to a kernel subsystem.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

This looks great, Martin! I just have few nits/suggestions, but
overall I think this approach is much better.

After this lands, please follow up with adding support for struct_ops
maps into BPF skeleton, so that it's attached automatically on
skeleton load.

>  tools/lib/bpf/bpf.c           |  10 +-
>  tools/lib/bpf/bpf.h           |   5 +-
>  tools/lib/bpf/libbpf.c        | 639 +++++++++++++++++++++++++++++++++-
>  tools/lib/bpf/libbpf.h        |   1 +
>  tools/lib/bpf/libbpf.map      |   1 +
>  tools/lib/bpf/libbpf_probes.c |   2 +
>  6 files changed, 646 insertions(+), 12 deletions(-)
>

[...]

> +       member = btf_members(type);
> +       for (i = 0; i < btf_vlen(type); i++, member++) {
> +               const struct btf_type *mtype, *kern_mtype;
> +               __u32 mtype_id, kern_mtype_id;
> +               void *mdata, *kern_mdata;
> +               __s64 msize, kern_msize;
> +               __u32 moff, kern_moff;
> +               __u32 kern_member_idx;
> +               const char *mname;
> +
> +               mname = btf__name_by_offset(btf, member->name_off);
> +               kern_member = find_member_by_name(kern_btf, kern_type, mname);
> +               if (!kern_member) {
> +                       pr_warn("struct_ops map %s init_kern %s: Cannot find member %s in kernel BTF\n",
> +                               map->name, tname, mname);
> +                       return -ENOTSUP;
> +               }
> +
> +               kern_member_idx = kern_member - btf_members(kern_type);
> +               if (btf_member_bitfield_size(type, i) ||
> +                   btf_member_bitfield_size(kern_type, kern_member_idx)) {
> +                       pr_warn("struct_ops map %s init_kern %s: bitfield %s is not supported\n",
> +                               map->name, tname, mname);
> +                       return -ENOTSUP;
> +               }
> +
> +               moff = member->offset / 8;
> +               kern_moff = kern_member->offset / 8;
> +
> +               mdata = data + moff;
> +               kern_mdata = kern_data + kern_moff;
> +
> +               mtype_id = member->type;
> +               kern_mtype_id = kern_member->type;
> +
> +               mtype = resolve_ptr(btf, mtype_id, NULL);
> +               kern_mtype = resolve_ptr(kern_btf, kern_mtype_id, NULL);
> +               if (mtype && kern_mtype) {

This check seems more logical after you resolve mtype_id and
kern_mtype_id below and check that they have same BTF_INFO_KIND. After
that you can check for a case of pointers and handle it, if not
pointers - proceed to determining size.

That way you might also get rid of resolve_ptr and resolve_func_ptr
functions, because here you already resolved pointer, so just normal
btf__resolve_type will give you what it's pointing to. Then the only
use of resolve_func_ptr_resolve_ptr will be in
bpf_object__collect_struct_ops_map_reloc, which you can just inline at
that point and not really loose any readability.

> +                       struct bpf_program *prog;
> +
> +                       if (!btf_is_func_proto(mtype) ||
> +                           !btf_is_func_proto(kern_mtype)) {
> +                               pr_warn("struct_ops map %s init_kern %s: non func ptr %s is not supported\n",
> +                                       map->name, tname, mname);
> +                               return -ENOTSUP;
> +                       }
> +
> +                       prog = st_ops->progs[i];
> +                       if (!prog) {
> +                               pr_debug("struct_ops map %s init_kern %s: func ptr %s is not set\n",
> +                                        map->name, tname, mname);
> +                               continue;
> +                       }
> +
> +                       if (prog->type != BPF_PROG_TYPE_UNSPEC &&
> +                           (prog->type != BPF_PROG_TYPE_STRUCT_OPS ||
> +                            prog->attach_btf_id != kern_type_id ||
> +                            prog->expected_attach_type != kern_member_idx)) {
> +                               pr_warn("struct_ops map %s init_kern %s: Cannot use prog %s in type %u attach_btf_id %u expected_attach_type %u for func ptr %s\n",
> +                                       map->name, tname, prog->name,
> +                                       prog->type, prog->attach_btf_id,
> +                                       prog->expected_attach_type, mname);
> +                               return -ENOTSUP;
> +                       }
> +
> +                       prog->type = BPF_PROG_TYPE_STRUCT_OPS;
> +                       prog->attach_btf_id = kern_type_id;
> +                       prog->expected_attach_type = kern_member_idx;
> +
> +                       st_ops->kern_func_off[i] = kern_data_off + kern_moff;
> +
> +                       pr_debug("struct_ops map %s init_kern %s: func ptr %s is set to prog %s from data(+%u) to kern_data(+%u)\n",
> +                                map->name, tname, mname, prog->name, moff,
> +                                kern_moff);
> +
> +                       continue;
> +               }
> +
> +               mtype_id = btf__resolve_type(btf, mtype_id);
> +               kern_mtype_id = btf__resolve_type(kern_btf, kern_mtype_id);
> +               if (mtype_id < 0 || kern_mtype_id < 0) {
> +                       pr_warn("struct_ops map %s init_kern %s: Cannot resolve the type for %s\n",
> +                               map->name, tname, mname);
> +                       return -ENOTSUP;
> +               }
> +
> +               mtype = btf__type_by_id(btf, mtype_id);
> +               kern_mtype = btf__type_by_id(kern_btf, kern_mtype_id);
> +               if (BTF_INFO_KIND(mtype->info) !=
> +                   BTF_INFO_KIND(kern_mtype->info)) {
> +                       pr_warn("struct_ops map %s init_kern %s: Unmatched member type %s %u != %u(kernel)\n",
> +                               map->name, tname, mname,
> +                               BTF_INFO_KIND(mtype->info),
> +                               BTF_INFO_KIND(kern_mtype->info));
> +                       return -ENOTSUP;
> +               }
> +
> +               msize = btf__resolve_size(btf, mtype_id);
> +               kern_msize = btf__resolve_size(kern_btf, kern_mtype_id);
> +               if (msize < 0 || kern_msize < 0 || msize != kern_msize) {
> +                       pr_warn("struct_ops map %s init_kern %s: Error in size of member %s: %zd != %zd(kernel)\n",
> +                               map->name, tname, mname,
> +                               (ssize_t)msize, (ssize_t)kern_msize);
> +                       return -ENOTSUP;
> +               }
> +
> +               pr_debug("struct_ops map %s init_kern %s: copy %s %u bytes from data(+%u) to kern_data(+%u)\n",
> +                        map->name, tname, mname, (unsigned int)msize,
> +                        moff, kern_moff);
> +               memcpy(kern_mdata, mdata, msize);
> +       }
> +
> +       return 0;
> +}
> +

[...]

> +       symbols = obj->efile.symbols;
> +       btf = obj->btf;
> +       nrels = shdr->sh_size / shdr->sh_entsize;
> +       for (i = 0; i < nrels; i++) {
> +               if (!gelf_getrel(data, i, &rel)) {
> +                       pr_warn("struct_ops map reloc: failed to get %d reloc\n", i);
> +                       return -LIBBPF_ERRNO__FORMAT;
> +               }
> +
> +               if (!gelf_getsym(symbols, GELF_R_SYM(rel.r_info), &sym)) {
> +                       pr_warn("struct_ops map reloc: symbol %" PRIx64 " not found\n",

please use %zx and explicit cast to size_t instead of PRIx64

> +                               GELF_R_SYM(rel.r_info));
> +                       return -LIBBPF_ERRNO__FORMAT;
> +               }
> +
> +               name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
> +                                 sym.st_name) ? : "<?>";
> +               map = find_struct_ops_map_by_offset(obj, rel.r_offset);
> +               if (!map) {
> +                       pr_warn("struct_ops map reloc: cannot find map at rel.r_offset %zu\n",
> +                               (size_t)rel.r_offset);
> +                       return -EINVAL;
> +               }
> +
> +               moff = rel.r_offset -  map->sec_offset;

nit: double space

> +               shdr_idx = sym.st_shndx;
> +               st_ops = map->st_ops;
> +               tname = st_ops->tname;

[...]

> +       datasec = btf__type_by_id(btf, datasec_id);
> +       vsi = btf_var_secinfos(datasec);
> +       for (i = 0; i < btf_vlen(datasec); i++, vsi++) {
> +               type = btf__type_by_id(obj->btf, vsi->type);
> +               var_name = btf__name_by_offset(obj->btf, type->name_off);
> +
> +               type_id = btf__resolve_type(obj->btf, vsi->type);
> +               if (type_id < 0) {
> +                       pr_warn("struct_ops init: Cannot resolve var type_id %u in DATASEC %s\n",
> +                               vsi->type, STRUCT_OPS_SEC);
> +                       return -EINVAL;
> +               }
> +
> +               type = btf__type_by_id(obj->btf, type_id);
> +               tname = btf__name_by_offset(obj->btf, type->name_off);
> +               if (!btf_is_struct(type)) {

if tname is empty, it's also not of much use, so might be a good idea
to error out here with some context?

> +                       pr_warn("struct_ops init: %s is not a struct\n", tname);
> +                       return -EINVAL;
> +               }
> +
> +               map = bpf_object__add_map(obj);
> +               if (IS_ERR(map))
> +                       return PTR_ERR(map);
> +
> +               map->sec_idx = obj->efile.st_ops_shndx;
> +               map->sec_offset = vsi->offset;
> +               map->name = strdup(var_name);
> +               if (!map->name)
> +                       return -ENOMEM;
> +
> +               map->def.type = BPF_MAP_TYPE_STRUCT_OPS;
> +               map->def.key_size = sizeof(int);
> +               map->def.value_size = type->size;
> +               map->def.max_entries = 1;
> +
> +               map->st_ops = calloc(1, sizeof(*map->st_ops));
> +               if (!map->st_ops)
> +                       return -ENOMEM;
> +               st_ops = map->st_ops;
> +               st_ops->data = malloc(type->size);
> +               st_ops->progs = calloc(btf_vlen(type), sizeof(*st_ops->progs));
> +               st_ops->kern_func_off = malloc(btf_vlen(type) *
> +                                              sizeof(*st_ops->kern_func_off));
> +               if (!st_ops->data || !st_ops->progs || !st_ops->kern_func_off)
> +                       return -ENOMEM;
> +
> +               memcpy(st_ops->data,
> +                      obj->efile.st_ops_data->d_buf + vsi->offset,
> +                      type->size);

maybe also check that d_size is big enough to read data from?

> +               st_ops->tname = tname;
> +               st_ops->type = type;
> +               st_ops->type_id = type_id;
> +
> +               pr_debug("struct_ops init: %s found. type_id:%u var_name:%s offset:%u\n",
> +                        tname, type_id, var_name, vsi->offset);
> +       }
> +
> +       return 0;
> +}
> +

[...]

>
> -       for (i = 0; i < obj->nr_maps; i++)
> +       for (i = 0; i < obj->nr_maps; i++) {
>                 zclose(obj->maps[i].fd);
> +               if (obj->maps[i].st_ops)
> +                       zfree(&obj->maps[i].st_ops->kern_vdata);

any specific reason to deallocate only kern_vdata? maybe just
consolidate all the clean up in bpf_object__close instead?

> +       }
>
>         for (i = 0; i < obj->nr_programs; i++)
>                 bpf_program__unload(&obj->programs[i]);
> @@ -4866,6 +5427,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
>         err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
>         err = err ? : bpf_object__sanitize_and_load_btf(obj);
>         err = err ? : bpf_object__sanitize_maps(obj);
> +       err = err ? : bpf_object__init_kern_struct_ops_maps(obj);
>         err = err ? : bpf_object__create_maps(obj);
>         err = err ? : bpf_object__relocate(obj, attr->target_btf_path);
>         err = err ? : bpf_object__load_progs(obj, attr->log_level);
> @@ -5453,6 +6015,13 @@ void bpf_object__close(struct bpf_object *obj)
>                         map->mmaped = NULL;
>                 }
>
> +               if (map->st_ops) {
> +                       zfree(&map->st_ops->data);
> +                       zfree(&map->st_ops->progs);
> +                       zfree(&map->st_ops->kern_func_off);
> +                       zfree(&map->st_ops);
> +               }
> +
>                 zfree(&map->name);
>                 zfree(&map->pin_path);
>         }
> @@ -5954,7 +6523,7 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
>  int libbpf_find_vmlinux_btf_id(const char *name,
>                                enum bpf_attach_type attach_type)
>  {
> -       struct btf *btf = bpf_core_find_kernel_btf();
> +       struct btf *btf = bpf_find_kernel_btf();
>         char raw_tp_btf[128] = BTF_PREFIX;
>         char *dst = raw_tp_btf + sizeof(BTF_PREFIX) - 1;
>         const char *btf_name;
> @@ -6780,6 +7349,58 @@ struct bpf_link *bpf_program__attach(struct bpf_program *prog)
>         return sec_def->attach_fn(sec_def, prog);
>  }
>
> +static int bpf_link__detach_struct_ops(struct bpf_link *link)
> +{
> +       struct bpf_link_fd *l = (void *)link;
> +       __u32 zero = 0;
> +
> +       if (bpf_map_delete_elem(l->fd, &zero))
> +               return -errno;
> +
> +       return 0;
> +}
> +
> +struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *map)
> +{

This looks great!

[...]

>  enum bpf_perf_event_ret
>  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
>                            void **copy_mem, size_t *copy_size,
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index fe592ef48f1b..9c54f252f90f 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -355,6 +355,7 @@ struct bpf_map_def {
>   * so no need to worry about a name clash.
>   */
>  struct bpf_map;
> +LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *map);

nit: can you please move it into the section with all the bpf_link and
attach APIs?

>  LIBBPF_API struct bpf_map *
>  bpf_object__find_map_by_name(const struct bpf_object *obj, const char *name);
>

[...]
