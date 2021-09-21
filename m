Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDA8413DAE
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhIUWmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbhIUWmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 18:42:54 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3CFC061574;
        Tue, 21 Sep 2021 15:41:25 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id i132so3112451qke.1;
        Tue, 21 Sep 2021 15:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5RaF2MJ/VEyXey7GuMMW8RXyamQqfnDiKjfXn4KpfFs=;
        b=jUs8j1GLZf/GQOBCt1BEIZrWWN83CEiYP494jxIu28neYLNvCMz2WZ6bNuUK+wzUOP
         phbtN5WCCC3exMbzxL8IfWKrqV9La9E1MbTW2CO8CEfPUQ8f+G6cHPtLPFDJz2Xj0KLw
         135gQLOxordab/KKsSEmVd3yfbF+LV8OdJ5II5G2DDksTgVw4TVis0F1/LDrD3vVME6W
         +FYdqntCrw8om8jBQihq23BdvBaXHlL3W1f9tsxrAhlljyniZ00LJuvfwRLgpHewKp0a
         teZqh+y6iwho8vwHQLyH8hWcKiM9Xk6exgl2cGmQPuQ274bMMwC9r0PtWNxgqCPMCz1D
         TW7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5RaF2MJ/VEyXey7GuMMW8RXyamQqfnDiKjfXn4KpfFs=;
        b=A4B+rbzN6ChVmJ9wGU/KqH/i9WbN6j0mU5riSV6o2rgZ7TUPIQP3/58CAFMnfoF97c
         Otzqb8r7+oDIpmYUCykYZ1oQn0BoS6P0AEgpgzeQ3qTujhxEtqJVv5/+tVVPraROUv66
         XJjOBZca6HaH1aIu7YrVdKOtkBtfiQSqQ3cSs4M/jEhym4ssohMn+qZoA21Lsq9eKdv7
         nEwfsulPND9LN706r1n0GdN4jsZ8Y+Tu6yrwRqAu/WPcvm+44CbLDxdIx6/MQdxuPmTs
         B6LoeeBmL1z4snEqyeRsccOZqSubRT2CDP19PbkhS1SilrtRx0NCJqAuixb1AEwWFSI+
         hggg==
X-Gm-Message-State: AOAM532cWp5HWHx72PMVRAHvrXaDaNM7VWU0P+OMOp3+Y464dzcMn1u6
        G4wviLO8ROxL9SMokXyZCGOZTJhe1b2MnT0Dq/0=
X-Google-Smtp-Source: ABdhPJzzUJffa02GA81NEP3K4HiEAk//SQsnbAEOJPxJfra9/VXMEkyhHFbKQL9A5YgcqALO7PNE1cjRQew0xXWiM5c=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr41805632ybj.504.1632264084444;
 Tue, 21 Sep 2021 15:41:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210920141526.3940002-1-memxor@gmail.com> <20210920141526.3940002-7-memxor@gmail.com>
In-Reply-To: <20210920141526.3940002-7-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Sep 2021 15:41:13 -0700
Message-ID: <CAEf4BzaZOv5c=-hs4UX3UcqP-fFkv8ABx5FAWXRMCDE8-vZ9Lg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 06/11] libbpf: Support kernel module function calls
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This patch adds libbpf support for kernel module function call support.
> The fd_array parameter is used during BPF program load is used to pass
> module BTFs referenced by the program. insn->off is set to index into
> this array, but starts from 1, because insn->off as 0 is reserved for
> btf_vmlinux.
>
> We try to use existing insn->off for a module, since the kernel limits
> the maximum distinct module BTFs for kfuncs to 256, and also because
> index must never exceed the maximum allowed value that can fit in
> insn->off (INT16_MAX). In the future, if kernel interprets signed offset
> as unsigned for kfunc calls, this limit can be increased to UINT16_MAX.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/bpf.c             |  1 +
>  tools/lib/bpf/libbpf.c          | 58 +++++++++++++++++++++++++++++++--
>  tools/lib/bpf/libbpf_internal.h |  1 +
>  3 files changed, 57 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 2401fad090c5..7d1741ceaa32 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -264,6 +264,7 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
>         attr.line_info_rec_size = load_attr->line_info_rec_size;
>         attr.line_info_cnt = load_attr->line_info_cnt;
>         attr.line_info = ptr_to_u64(load_attr->line_info);
> +       attr.fd_array = ptr_to_u64(load_attr->fd_array);
>
>         if (load_attr->name)
>                 memcpy(attr.prog_name, load_attr->name,
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index da65a1666a5e..3049dfc6088e 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -420,6 +420,12 @@ struct extern_desc {
>
>                         /* local btf_id of the ksym extern's type. */
>                         __u32 type_id;
> +                       /* offset to be patched in for insn->off,
> +                        * this is 0 for btf_vmlinux, and index + 1

What does "index + 1" mean here? Seems like kernel code is using the
offset as is, without any -1 compensation.

> +                        * for module BTF, where index is BTF index in
> +                        * obj->fd_array
> +                        */
> +                       __s16 offset;
>                 } ksym;
>         };
>  };
> @@ -516,6 +522,10 @@ struct bpf_object {
>         void *priv;
>         bpf_object_clear_priv_t clear_priv;
>
> +       int *fd_array;
> +       size_t fd_cap_cnt;
> +       int nr_fds;
> +
>         char path[];
>  };
>  #define obj_elf_valid(o)       ((o)->efile.elf)
> @@ -5357,6 +5367,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
>                         ext = &obj->externs[relo->sym_off];
>                         insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
>                         insn[0].imm = ext->ksym.kernel_btf_id;
> +                       insn[0].off = ext->ksym.offset;
>                         break;
>                 case RELO_SUBPROG_ADDR:
>                         if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
> @@ -6151,6 +6162,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>         }
>         load_attr.log_level = prog->log_level;
>         load_attr.prog_flags = prog->prog_flags;
> +       load_attr.fd_array = prog->obj->fd_array;
>
>         if (prog->obj->gen_loader) {
>                 bpf_gen__prog_load(prog->obj->gen_loader, &load_attr,
> @@ -6763,9 +6775,46 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
>         }
>
>         if (kern_btf != obj->btf_vmlinux) {
> -               pr_warn("extern (func ksym) '%s': function in kernel module is not supported\n",
> -                       ext->name);
> -               return -ENOTSUP;
> +               int index = -1;
> +
> +               if (!obj->fd_array) {
> +                       obj->fd_array = calloc(8, sizeof(*obj->fd_array));
> +                       if (!obj->fd_array)
> +                               return -ENOMEM;
> +                       obj->fd_cap_cnt = 8;
> +                       /* index = 0 is for vmlinux BTF, so skip it */
> +                       obj->nr_fds = 1;
> +               }

this doesn't make sense, you use libbpf_ensure_mem() and shouldn't do
anything like this, it's all taken care of  already

> +
> +               for (int i = 0; i < obj->nr_fds; i++) {
> +                       if (obj->fd_array[i] == kern_btf_fd) {
> +                               index = i;
> +                               break;
> +                       }
> +               }

we can actually avoid all this. We already have a list of module BTFs
in bpf_object (obj->btf_modules), where we remember their id, fd, etc.
We can also remember their fd_arr_idx for quick lookup. Just teach
find_ksym_btf_id() to optionally return struct module_btf * and use
that to find/set idx. That seems cleaner and probably would be easier
in the future as well.

> +
> +               if (index == -1) {
> +                       if (obj->nr_fds == obj->fd_cap_cnt) {

don't check, libbpf_ensure_mem() handles that

> +                               ret = libbpf_ensure_mem((void **)&obj->fd_array,
> +                                                       &obj->fd_cap_cnt, sizeof(int),
> +                                                       obj->fd_cap_cnt + 1);
> +                               if (ret)
> +                                       return ret;
> +                       }
> +
> +                       index = obj->nr_fds;
> +                       obj->fd_array[obj->nr_fds++] = kern_btf_fd;
> +               }
> +
> +               if (index > INT16_MAX) {
> +                       /* insn->off is s16 */
> +                       pr_warn("extern (func ksym) '%s': module btf fd index too big\n",
> +                               ext->name);

can you log index value here as well? "module BTF FD index %d is too big\n"?

> +                       return -E2BIG;
> +               }
> +               ext->ksym.offset = index;

> +       } else {
> +               ext->ksym.offset = 0;
>         }

I think it will be cleaner if you move the entire offset determination
logic after all the other checks are performed and ext is mostly
populated. That will also make the logic shorter and simpler because
if you find kern_btf_fd match, you can exit early (or probably rather
goto to report the match and exit). Otherwise

>
>         kern_func = btf__type_by_id(kern_btf, kfunc_id);

this is actually extremely wasteful for module BTFs. Let's add
internal (at least for now) helper that will search only for "own" BTF
types in the BTF, skipping types in base BTF. Something like
btf_type_by_id_own()?

> @@ -6941,6 +6990,9 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
>                         err = bpf_gen__finish(obj->gen_loader);
>         }
>
> +       /* clean up fd_array */
> +       zfree(&obj->fd_array);
> +
>         /* clean up module BTFs */
>         for (i = 0; i < obj->btf_module_cnt; i++) {
>                 close(obj->btf_modules[i].fd);
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index ceb0c98979bc..44b8f381b035 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -291,6 +291,7 @@ struct bpf_prog_load_params {
>         __u32 log_level;
>         char *log_buf;
>         size_t log_buf_sz;
> +       int *fd_array;
>  };
>
>  int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr);
> --
> 2.33.0
>
