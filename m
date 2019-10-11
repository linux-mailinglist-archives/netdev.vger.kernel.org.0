Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26EE5D47A2
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 20:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbfJKScH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 14:32:07 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35496 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728472AbfJKScG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 14:32:06 -0400
Received: by mail-qk1-f196.google.com with SMTP id w2so9802893qkf.2;
        Fri, 11 Oct 2019 11:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R5h9wIa0386tKWAKxElY7ZgoeiVbKbYthkoMYXWtG0A=;
        b=r2l16Q78KzWminuAGmm2yTdU6ibYybup1kZO8tmOeQd/7hguMu3n/rcnGOkrMIdB/L
         m6REEjx6oZJb0y7ikJNtnqYszLuA9vcQUsZfdI2U6PMBTpDVbq8xSYgqkeiLC7uYr307
         fqa4L2ZLGYBigNjjw85xiEUoTX21WpuVZvjwJ5fabE5MN+FBKBSp5qHJixt+DsU1m5l5
         pWcWuQHRqBf/bw7IzQNupkUzOfH1M0qNrznvIupAUXKgmyR9Wske4ahHnPdqTj2hyY4r
         zJct65Do7ZsxbZZOrIrLdAtdJ+6ZAAy0FwxLbR8OVBWJV8KpM5rj1GMrv0Rkvm9I7tQx
         NfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R5h9wIa0386tKWAKxElY7ZgoeiVbKbYthkoMYXWtG0A=;
        b=Zg47CBJmCQfvOIyL+rAmJpdsLwxlFmrG4gnF5x52z5NgPFpTmPX6ATPeFJtcsIGC+s
         c12/Fr/M/MIXft53pd5iRla4LIuYwFOKqyhjIGltFyLEWinxahIzf3qkTAOS8eV+UcP/
         is0XoTFjaaZkegbkcemQO2nrieHrD5UCM++mPGRCQ81FlV6pODLKop2QYKcVKM9sOZgC
         WZAvAq/jFqCEamLU2cYvrd+cJ7j4PadXlYwYsK2Ozq5l4uCiSuvOxdWVfx8xYvjxDx3L
         AxjsXRV6b/mCp5ZFOvl0txUhfOfRp6pO7+54J4wM1XXVgD4FDqUg7AVDokvy4FcC9P0Q
         ZVFg==
X-Gm-Message-State: APjAAAVII8dyxm/f/anGIvAS7jLOEHz0gf5+uW2f3df4pXBLfxMptPMJ
        4O7YX2oYVBAVGwXxzncZQFJseQvAem5BnwSLuy8=
X-Google-Smtp-Source: APXvYqz/Lops5cxAlnKjTi1CkeP9bR31wkRMygFQSJ2D1e7Y11Nkp7rCN+5MRXRdDRq9wduiqj9aDCp7rG0Uk5RIRGg=
X-Received: by 2002:a37:520a:: with SMTP id g10mr17102972qkb.39.1570818725330;
 Fri, 11 Oct 2019 11:32:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191010041503.2526303-1-ast@kernel.org> <20191010041503.2526303-7-ast@kernel.org>
In-Reply-To: <20191010041503.2526303-7-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 11:31:54 -0700
Message-ID: <CAEf4BzYeM4mwXKHS3z3WQxWbMU+2XM6g6touV7vZZagGK0Xijg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 06/12] bpf: implement accurate raw_tp context
 access via BTF
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 9:17 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> libbpf analyzes bpf C program, searches in-kernel BTF for given type name
> and stores it into expected_attach_type.
> The kernel verifier expects this btf_id to point to something like:
> typedef void (*btf_trace_kfree_skb)(void *, struct sk_buff *skb, void *loc);
> which represents signature of raw_tracepoint "kfree_skb".
>
> Then btf_ctx_access() matches ctx+0 access in bpf program with 'skb'
> and 'ctx+8' access with 'loc' arguments of "kfree_skb" tracepoint.
> In first case it passes btf_id of 'struct sk_buff *' back to the verifier core
> and 'void *' in second case.
>
> Then the verifier tracks PTR_TO_BTF_ID as any other pointer type.
> Like PTR_TO_SOCKET points to 'struct bpf_sock',
> PTR_TO_TCP_SOCK points to 'struct bpf_tcp_sock', and so on.
> PTR_TO_BTF_ID points to in-kernel structs.
> If 1234 is btf_id of 'struct sk_buff' in vmlinux's BTF
> then PTR_TO_BTF_ID#1234 points to one of in kernel skbs.
>
> When PTR_TO_BTF_ID#1234 is dereferenced (like r2 = *(u64 *)r1 + 32)
> the btf_struct_access() checks which field of 'struct sk_buff' is
> at offset 32. Checks that size of access matches type definition
> of the field and continues to track the dereferenced type.
> If that field was a pointer to 'struct net_device' the r2's type
> will be PTR_TO_BTF_ID#456. Where 456 is btf_id of 'struct net_device'
> in vmlinux's BTF.
>
> Such verifier analysis prevents "cheating" in BPF C program.
> The program cannot cast arbitrary pointer to 'struct sk_buff *'
> and access it. C compiler would allow type cast, of course,
> but the verifier will notice type mismatch based on BPF assembly
> and in-kernel BTF.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf.h          |  17 +++-
>  include/linux/bpf_verifier.h |   4 +
>  kernel/bpf/btf.c             | 186 +++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c        |  86 +++++++++++++++-
>  kernel/trace/bpf_trace.c     |   2 +-
>  5 files changed, 290 insertions(+), 5 deletions(-)
>

[...]

> +int btf_struct_access(struct bpf_verifier_log *log,
> +                     const struct btf_type *t, int off, int size,
> +                     enum bpf_access_type atype,
> +                     u32 *next_btf_id)
> +{
> +       const struct btf_member *member;
> +       const struct btf_type *mtype;
> +       const char *tname, *mname;
> +       int i, moff = 0, msize;
> +
> +again:
> +       tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
> +       if (!btf_type_is_struct(t)) {
> +               bpf_log(log, "Type '%s' is not a struct", tname);
> +               return -EINVAL;
> +       }
> +
> +       for_each_member(i, t, member) {
> +               /* offset of the field in bits */
> +               moff = btf_member_bit_offset(t, member);

This whole logic of offset/size checking doesn't work for bitfields.
Your moff % 8 might be non-zero (most probably, actually, for
bitfield). Also, msize of underlying integer type is not the same as
member's bit size. So probably just check that it's a bitfield and
skip it?

The check is surprisingly subtle and not straightforward, btw. You
need to get btf_member_bitfield_size(t, member) and check that it's
not equal to underlying type's size (which is in bytes, so * 8). It's
unfortunate it's so non-straightforward. But if you don't filter that,
all those `moff / 8` and `msize` checks are bogus.

> +
> +               if (off + size <= moff / 8)
> +                       /* won't find anything, field is already too far */
> +                       break;
> +
> +               /* type of the field */
> +               mtype = btf_type_by_id(btf_vmlinux, member->type);
> +               mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
> +
> +               /* skip modifiers */
> +               while (btf_type_is_modifier(mtype))
> +                       mtype = btf_type_by_id(btf_vmlinux, mtype->type);
> +
> +               if (btf_type_is_array(mtype))
> +                       /* array deref is not supported yet */
> +                       continue;
> +
> +               if (!btf_type_has_size(mtype) && !btf_type_is_ptr(mtype)) {
> +                       bpf_log(log, "field %s doesn't have size\n", mname);
> +                       return -EFAULT;
> +               }
> +               if (btf_type_is_ptr(mtype))
> +                       msize = 8;
> +               else
> +                       msize = mtype->size;
> +               if (off >= moff / 8 + msize)
> +                       /* no overlap with member, keep iterating */
> +                       continue;
> +               /* the 'off' we're looking for is either equal to start
> +                * of this field or inside of this struct
> +                */
> +               if (btf_type_is_struct(mtype)) {
> +                       /* our field must be inside that union or struct */
> +                       t = mtype;
> +
> +                       /* adjust offset we're looking for */
> +                       off -= moff / 8;
> +                       goto again;
> +               }
> +               if (msize != size) {
> +                       /* field access size doesn't match */
> +                       bpf_log(log,
> +                               "cannot access %d bytes in struct %s field %s that has size %d\n",
> +                               size, tname, mname, msize);
> +                       return -EACCES;

Are you sure this has to be an error? Why not just default to
SCALAR_VALUE here? E.g., if compiler generated one read for few
smaller fields, or user wants to read lower 1 byte of int field, etc.
I think if you move this size check into the following ptr check, it
should be fine. Pointer is the only case where you care about correct
read/value, isn't it?

> +               }
> +
> +               if (btf_type_is_ptr(mtype)) {
> +                       const struct btf_type *stype;
> +
> +                       stype = btf_type_by_id(btf_vmlinux, mtype->type);
> +                       /* skip modifiers */
> +                       while (btf_type_is_modifier(stype))
> +                               stype = btf_type_by_id(btf_vmlinux, stype->type);
> +                       if (btf_type_is_struct(stype)) {
> +                               *next_btf_id = mtype->type;
> +                               return PTR_TO_BTF_ID;
> +                       }
> +               }
> +               /* all other fields are treated as scalars */
> +               return SCALAR_VALUE;
> +       }
> +       bpf_log(log, "struct %s doesn't have field at offset %d\n", tname, off);
> +       return -EINVAL;
> +}
> +

[...]
