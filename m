Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB82D123DAE
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 04:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfLRDHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 22:07:36 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46453 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbfLRDHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 22:07:36 -0500
Received: by mail-qk1-f193.google.com with SMTP id r14so338483qke.13;
        Tue, 17 Dec 2019 19:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=shBlCX+34TjnWWc4rMiOdYvaeqsbkJZZG0T7t8KiPgc=;
        b=hBBYmd1r68uITVnZk8jg5QV7ogqw13KPR4Pa4jilftAh/t1eQNx0cuORNzZVWyqpvL
         LVQL987gYno4oYuQ5548MxEk0cnzBUYiB+yxsmpP3c3j9sKXbUyGn/gBcJ1wqqHKGTXJ
         bN/bX/ewi/RVdsxfvdp8F5q+2k5j04lQbIjWSYbZI+f+Ju6sw2o2jfnd3XfOyHNdG9sZ
         jkvnDs5lGrFIGGR5xY9g/sNvvOFkCSvMd0MEfHNiPACulGscteaXCJzaLbEwnFkh+kvB
         m/4AIY5TsUdx/AUsdgbYiuGPVz/ZsVAIF8E1tpDxJThKTEokv4wqYXjh5LJyZ6YTtCVr
         ldRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=shBlCX+34TjnWWc4rMiOdYvaeqsbkJZZG0T7t8KiPgc=;
        b=TlACqDW0Kl4H/cX8cS3XXDGYeD3l3YdpisoRP3/kH4ILz//88inqXouThSzEvJpTXz
         qNKKwUusTb4CE6qagUdeNQNBqWXt+EZPmmpBkD4CFGrxlvZG5IfKr/2ySHiH4HpD1TxW
         zcEO4SVSq4SEi8TFNFcw1gQG1JS/H0YeazfwGh5G738OeHsj8TMQjV5xcZn3+LEkYE/8
         iyEPfK/rVYiUcUNTC9nh13RlwXlcTmTKIauHhEdd9PRM/i7ez9C8KmEts/EdjhvKB3dF
         9ZZAdqF3x9weO/FdLJRF0CO2+HjWncM0xMVLy46brYI77EnM1nFIhj+FFFv0t6/I2kxI
         QOPA==
X-Gm-Message-State: APjAAAXOHzoTcVDXf6dDCITgTIIV5xFdJ75UiR3izVzbz7uQnmBGouGh
        VVb7hQSNqhRCfd7ELSzJaPIoMyvwQosRz+4goKk=
X-Google-Smtp-Source: APXvYqw6zgr1DE7KXR/GyDosQgVs1BtiBd4h/DUrK2gTvN02gGg1i7lEY/DAgewp2rj0PFfpw4D07Sm8p9l0WsoCb8A=
X-Received: by 2002:ae9:e809:: with SMTP id a9mr319309qkg.92.1576638454782;
 Tue, 17 Dec 2019 19:07:34 -0800 (PST)
MIME-Version: 1.0
References: <20191214004737.1652076-1-kafai@fb.com> <20191214004803.1653618-1-kafai@fb.com>
In-Reply-To: <20191214004803.1653618-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Dec 2019 19:07:23 -0800
Message-ID: <CAEf4BzbJoso7A0dn=xhOkFMOcKqZ6wYp=XoqGiL+FO+0VKqh5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 11/13] bpf: libbpf: Add STRUCT_OPS support
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

On Fri, Dec 13, 2019 at 4:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch adds BPF STRUCT_OPS support to libbpf.
>
> The only sec_name convention is SEC("struct_ops") to identify the
> struct ops implemented in BPF, e.g.
> SEC("struct_ops")
> struct tcp_congestion_ops dctcp = {
>         .init           = (void *)dctcp_init,  /* <-- a bpf_prog */
>         /* ... some more func prts ... */
>         .name           = "bpf_dctcp",
> };
>
> In the bpf_object__open phase, libbpf will look for the "struct_ops"
> elf section and find out what is the btf-type the "struct_ops" is
> implementing.  Note that the btf-type here is referring to
> a type in the bpf_prog.o's btf.  It will then collect (through SHT_REL)
> where are the bpf progs that the func ptrs are referring to.
>
> In the bpf_object__load phase, the prepare_struct_ops() will load
> the btf_vmlinux and obtain the corresponding kernel's btf-type.
> With the kernel's btf-type, it can then set the prog->type,
> prog->attach_btf_id and the prog->expected_attach_type.  Thus,
> the prog's properties do not rely on its section name.
>
> Currently, the bpf_prog's btf-type ==> btf_vmlinux's btf-type matching
> process is as simple as: member-name match + btf-kind match + size match.
> If these matching conditions fail, libbpf will reject.
> The current targeting support is "struct tcp_congestion_ops" which
> most of its members are function pointers.
> The member ordering of the bpf_prog's btf-type can be different from
> the btf_vmlinux's btf-type.
>
> Once the prog's properties are all set,
> the libbpf will proceed to load all the progs.
>
> After that, register_struct_ops() will create a map, finalize the
> map-value by populating it with the prog-fd, and then register this
> "struct_ops" to the kernel by updating the map-value to the map.
>
> By default, libbpf does not unregister the struct_ops from the kernel
> during bpf_object__close().  It can be changed by setting the new
> "unreg_st_ops" in bpf_object_open_opts.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

This looks pretty good to me. The big two things is exposing structops
as real struct bpf_map, so that users can interact with it using
libbpf APIs, as well as splitting struct_ops map creation and
registration. bpf_object__load() should only make sure all maps are
created, progs are loaded/verified, but none of BPF program can yet be
called. Then attach is the phase where registration happens.


>  tools/lib/bpf/bpf.c           |  10 +-
>  tools/lib/bpf/bpf.h           |   5 +-
>  tools/lib/bpf/libbpf.c        | 599 +++++++++++++++++++++++++++++++++-
>  tools/lib/bpf/libbpf.h        |   3 +-
>  tools/lib/bpf/libbpf_probes.c |   2 +
>  5 files changed, 612 insertions(+), 7 deletions(-)
>

[...]

>  LIBBPF_API int
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 27d5f7ecba32..ffb5cdd7db5a 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -67,6 +67,10 @@
>
>  #define __printf(a, b) __attribute__((format(printf, a, b)))
>
> +static struct btf *bpf_core_find_kernel_btf(void);

this is not CO-RE specific anymore, we should probably just rename it
to bpf_find_kernel_btf

> +static struct bpf_program *bpf_object__find_prog_by_idx(struct bpf_object *obj,
> +                                                       int idx);
> +
>  static int __base_pr(enum libbpf_print_level level, const char *format,
>                      va_list args)
>  {
> @@ -128,6 +132,8 @@ void libbpf_print(enum libbpf_print_level level, const char *format, ...)
>  # define LIBBPF_ELF_C_READ_MMAP ELF_C_READ
>  #endif
>
> +#define BPF_STRUCT_OPS_SEC_NAME "struct_ops"

This is a special ELF section recognized by libbpf, so similarly to
".maps" (and ".kconfig", which I'm renaming from ".extern"), I think
this should be ".struct_ops" (or I'd even drop underscore and go with
".structops", but not insisting).

> +
>  static inline __u64 ptr_to_u64(const void *ptr)
>  {
>         return (__u64) (unsigned long) ptr;
> @@ -233,6 +239,32 @@ struct bpf_map {
>         bool reused;
>  };
>
> +struct bpf_struct_ops {
> +       const char *var_name;
> +       const char *tname;
> +       const struct btf_type *type;
> +       struct bpf_program **progs;
> +       __u32 *kern_func_off;
> +       /* e.g. struct tcp_congestion_ops in bpf_prog's btf format */
> +       void *data;
> +       /* e.g. struct __bpf_tcp_congestion_ops in btf_vmlinux's btf

Using __bpf_ prefix for this struct_ops-specific types is a bit too
generic (e.g., for raw_tp stuff Alexei used btf_trace_). So maybe make
it btf_ops_ or btf_structops_?


> +        * format.
> +        * struct __bpf_tcp_congestion_ops {
> +        *      [... some other kernel fields ...]
> +        *      struct tcp_congestion_ops data;
> +        * }
> +        * kern_vdata in the sizeof(struct __bpf_tcp_congestion_ops).

Comment isn't very clear.. do you mean that data pointed to by
kern_vdata is of sizeof(...) bytes?

> +        * prepare_struct_ops() will populate the "data" into
> +        * "kern_vdata".
> +        */
> +       void *kern_vdata;
> +       __u32 type_id;
> +       __u32 kern_vtype_id;
> +       __u32 kern_vtype_size;
> +       int fd;
> +       bool unreg;

This unreg flag (and default behavior to not unregister) is bothering
me a bit.. Shouldn't this be controlled by map's lifetime, at least.
E.g., if no one pins that map - then struct_ops should be unregistered
on map destruction. If application wants to keep BPF programs
attached, it should make sure to pin map, before userspace part exits?
Is this problematic in any way?

> +};
> +
>  struct bpf_secdata {
>         void *rodata;
>         void *data;
> @@ -251,6 +283,7 @@ struct bpf_object {
>         size_t nr_maps;
>         size_t maps_cap;
>         struct bpf_secdata sections;
> +       struct bpf_struct_ops st_ops;

These bpf_struct_ops are strictly belonging to that special struct_ops
map, right? So I'd say we should change struct bpf_map to contain
per-map extra piece of info. We can combine that with current mmaped
pointer for internal maps;


struct bpf_map {
    ...
    union {
        void *mmaped;
        struct bpf_struct_ops *st_ops;
    };
};

That way those special maps can have extra piece of information
specific to that special map's type.


>
>         bool loaded;
>         bool has_pseudo_calls;
> @@ -270,6 +303,7 @@ struct bpf_object {
>                 Elf_Data *data;
>                 Elf_Data *rodata;
>                 Elf_Data *bss;
> +               Elf_Data *st_ops_data;
>                 size_t strtabidx;
>                 struct {
>                         GElf_Shdr shdr;
> @@ -282,6 +316,7 @@ struct bpf_object {
>                 int data_shndx;
>                 int rodata_shndx;
>                 int bss_shndx;
> +               int st_ops_shndx;
>         } efile;
>         /*
>          * All loaded bpf_object is linked in a list, which is
> @@ -509,6 +544,508 @@ static __u32 get_kernel_version(void)
>         return KERNEL_VERSION(major, minor, patch);
>  }
>
> +static int bpf_object__register_struct_ops(struct bpf_object *obj)
> +{
> +       struct bpf_create_map_attr map_attr = {};
> +       struct bpf_struct_ops *st_ops;
> +       const char *tname;
> +       __u32 i, zero = 0;
> +       int fd, err;
> +
> +       st_ops = &obj->st_ops;
> +       if (!st_ops->kern_vdata)
> +               return 0;

this shouldn't happen, right? I'd drop the check or return error at least.

> +
> +       tname = st_ops->tname;
> +       for (i = 0; i < btf_vlen(st_ops->type); i++) {
> +               struct bpf_program *prog = st_ops->progs[i];
> +               void *kern_data;
> +               int prog_fd;
> +
> +               if (!prog)
> +                       continue;
> +
> +               prog_fd = bpf_program__nth_fd(prog, 0);

nit: just bpf_program__fd(prog)

> +               if (prog_fd < 0) {
> +                       pr_warn("struct_ops register %s: prog %s is not loaded\n",
> +                               tname, prog->name);
> +                       return -EINVAL;
> +               }

This is redundant check, register_struct_ops will not be called if any
program loading fails.

> +
> +               kern_data = st_ops->kern_vdata + st_ops->kern_func_off[i];
> +               *(unsigned long *)kern_data = prog_fd;
> +       }
> +
> +       map_attr.map_type = BPF_MAP_TYPE_STRUCT_OPS;
> +       map_attr.key_size = sizeof(unsigned int);
> +       map_attr.value_size = st_ops->kern_vtype_size;
> +       map_attr.max_entries = 1;
> +       map_attr.btf_fd = btf__fd(obj->btf);
> +       map_attr.btf_vmlinux_value_type_id = st_ops->kern_vtype_id;
> +       map_attr.name = st_ops->var_name;
> +
> +       fd = bpf_create_map_xattr(&map_attr);

we should try to reuse bpf_object__init_internal_map(). This will add
struct bpf_map which users can iterate over and look up by name, etc.
We had similar discussion when Daniel was adding  global data maps,
and we conclusively decided that these special maps have to be
represented in libbpf as struct bpf_map as well.

> +       if (fd < 0) {
> +               err = -errno;
> +               pr_warn("struct_ops register %s: Error in creating struct_ops map\n",
> +                       tname);
> +               return err;
> +       }
> +
> +       err = bpf_map_update_elem(fd, &zero, st_ops->kern_vdata, 0);

This is what "activates" struct_ops, so this has to happen outside of
load, load shouldn't trigger execution of BPF programs. So something
like bpf_map__attach_struct_ops() or we if introduce new concept for
struct_ops: bpf_struct_ops__attach(), which can be called explicitly
by user of automatically from skeletons <skeleton>__attach().


> +       if (err) {
> +               err = -errno;
> +               close(fd);
> +               pr_warn("struct_ops register %s: Error in updating struct_ops map\n",
> +                       tname);
> +               return err;
> +       }
> +
> +       st_ops->fd = fd;
> +
> +       return 0;
> +}
> +
> +static int bpf_struct_ops__unregister(struct bpf_struct_ops *st_ops)
> +{
> +       if (st_ops->fd != -1) {
> +               __u32 zero = 0;
> +               int err = 0;
> +
> +               if (bpf_map_delete_elem(st_ops->fd, &zero))
> +                       err = -errno;
> +               zclose(st_ops->fd);
> +
> +               return err;
> +       }
> +
> +       return 0;
> +}
> +
> +static const struct btf_type *
> +resolve_ptr(const struct btf *btf, __u32 id, __u32 *res_id);
> +static const struct btf_type *
> +resolve_func_ptr(const struct btf *btf, __u32 id, __u32 *res_id);
> +
> +static const struct btf_member *
> +find_member_by_offset(const struct btf_type *t, __u32 offset)

nit: find_member_by_bit_offset (offset -> bit_offset)?

> +{
> +       struct btf_member *m;
> +       int i;
> +
> +       for (i = 0, m = btf_members(t); i < btf_vlen(t); i++, m++) {
> +               if (btf_member_bit_offset(t, i) == offset)
> +                       return m;
> +       }
> +
> +       return NULL;
> +}
> +
> +static const struct btf_member *
> +find_member_by_name(const struct btf *btf, const struct btf_type *t,
> +                   const char *name)
> +{
> +       struct btf_member *m;
> +       int i;
> +
> +       for (i = 0, m = btf_members(t); i < btf_vlen(t); i++, m++) {
> +               if (!strcmp(btf__name_by_offset(btf, m->name_off), name))
> +                       return m;
> +       }
> +
> +       return NULL;
> +}
> +
> +#define STRUCT_OPS_VALUE_PREFIX "__bpf_"
> +#define STRUCT_OPS_VALUE_PREFIX_LEN (sizeof(STRUCT_OPS_VALUE_PREFIX) - 1)
> +
> +static int
> +bpf_struct_ops__get_kern_types(const struct btf *btf, const char *tname,

nit: there is no "bpf_struct_ops" object in libbpf and this is not its
method, so it's a violation of libbpf's naming convention, please
consider renaming to something like "find_struct_ops_kern_types"

> +                              const struct btf_type **type, __u32 *type_id,
> +                              const struct btf_type **vtype, __u32 *vtype_id,
> +                              const struct btf_member **data_member)
> +{
> +       const struct btf_type *kern_type, *kern_vtype;
> +       const struct btf_member *kern_data_member;
> +       __s32 kern_vtype_id, kern_type_id;
> +       char vtname[128] = STRUCT_OPS_VALUE_PREFIX;
> +       __u32 i;
> +
> +       kern_type_id = btf__find_by_name_kind(btf, tname, BTF_KIND_STRUCT);
> +       if (kern_type_id < 0) {
> +               pr_warn("struct_ops prepare: struct %s is not found in kernel BTF\n",
> +                       tname);
> +               return -ENOTSUP;

just return kern_type_id (pass through btf__find_by_name_kind's
result). Same below.

> +       }
> +       kern_type = btf__type_by_id(btf, kern_type_id);
> +
> +       /* Find the corresponding "map_value" type that will be used
> +        * in map_update(BPF_MAP_TYPE_STRUCT_OPS).  For example,
> +        * find "struct __bpf_tcp_congestion_ops" from the btf_vmlinux.
> +        */
> +       strncat(vtname + STRUCT_OPS_VALUE_PREFIX_LEN, tname,
> +               sizeof(vtname) - STRUCT_OPS_VALUE_PREFIX_LEN - 1);
> +       kern_vtype_id = btf__find_by_name_kind(btf, vtname,
> +                                              BTF_KIND_STRUCT);
> +       if (kern_vtype_id < 0) {
> +               pr_warn("struct_ops prepare: struct %s is not found in kernel BTF\n",
> +                       vtname);
> +               return -ENOTSUP;
> +       }
> +       kern_vtype = btf__type_by_id(btf, kern_vtype_id);
> +
> +       /* Find "struct tcp_congestion_ops" from
> +        * struct __bpf_tcp_congestion_ops {
> +        *      [ ... ]
> +        *      struct tcp_congestion_ops data;
> +        * }
> +        */
> +       for (i = 0, kern_data_member = btf_members(kern_vtype);
> +            i < btf_vlen(kern_vtype);
> +            i++, kern_data_member++) {

nit: multi-line for is kind of ugly, maybe move kern_data_member
assignment out of for?

> +               if (kern_data_member->type == kern_type_id)
> +                       break;
> +       }
> +       if (i == btf_vlen(kern_vtype)) {
> +               pr_warn("struct_ops prepare: struct %s data is not found in struct %s\n",
> +                       tname, vtname);
> +               return -EINVAL;
> +       }
> +

[...]

>  static int bpf_object__init_btf(struct bpf_object *obj,
> @@ -1689,6 +2257,9 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
>                         } else if (strcmp(name, ".rodata") == 0) {
>                                 obj->efile.rodata = data;
>                                 obj->efile.rodata_shndx = idx;
> +                       } else if (strcmp(name, BPF_STRUCT_OPS_SEC_NAME) == 0) {
> +                               obj->efile.st_ops_data = data;
> +                               obj->efile.st_ops_shndx = idx;
>                         } else {
>                                 pr_debug("skip section(%d) %s\n", idx, name);
>                         }
> @@ -1698,7 +2269,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
>                         int sec = sh.sh_info; /* points to other section */
>
>                         /* Only do relo for section with exec instructions */
> -                       if (!section_have_execinstr(obj, sec)) {
> +                       if (!section_have_execinstr(obj, sec) &&
> +                           !strstr(name, BPF_STRUCT_OPS_SEC_NAME)) {

why substring match?

>                                 pr_debug("skip relo %s(%d) for section(%d)\n",
>                                          name, idx, sec);
>                                 continue;

[...]
