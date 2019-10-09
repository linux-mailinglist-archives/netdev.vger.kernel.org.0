Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8236ED062D
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 06:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfJIEBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 00:01:47 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42585 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfJIEBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 00:01:47 -0400
Received: by mail-qk1-f193.google.com with SMTP id f16so950499qkl.9;
        Tue, 08 Oct 2019 21:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QFRqOmf1/O+YZmwI4tcTIW7I2qzpzJu4WuP8T8AJ93s=;
        b=DfSSXykhrimSb17+in6uqTAUVwXLVsn9bB2iVsg8nhPvyMC5mYdyNfWSVDARHA1wLK
         CY/SElcgcqVjnCIRAtNg0ps5UPP2dzBeoe0AI96XEGUaSTFDTtKcYdOjD+qCMp8CILww
         lNLV16Rim9zzo2urJFfyoTR6uhQRFc51brT9S7DGYy3wO4NujomGFfOJ0FUoukLwAvM0
         BJ9z8A9dxs6Z491OlJmk6GPNUX9ROIS+mmZrSp647S+gAWcneejmiBGbPqeVlIx7AJOF
         q39meVQil/iysngE1L48fC79dUeGWZQpq5IJiZFIcmI53CIlcPe41X6wtxmqcJjOHcPv
         dIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QFRqOmf1/O+YZmwI4tcTIW7I2qzpzJu4WuP8T8AJ93s=;
        b=Vdw3qYk5gY1SAlItoubeJzY+TWYF7OBwogR/V5k0vjTLvnASE57eODF2irrvU3bBnL
         Jm1N5K2iQQbwaIALu9VvmF8IVo8RQ/nKUUQPYfSONPZNpSqFevjXD4tfwB12SLuNHoui
         4eMnvX67/Mvfecm+HT2dhIBFoXCCWiy7DLIcI8PJ91jateqUkYb7l/bjNsBY3jMFXMmC
         /K1MyTKJXsw7CCsYgVkSqh/24YfU2F3UuLM9/3F/rSqHxiRpzB/5nvHq3eUy1o+q7twr
         ftUIxZb1ZCR4ANPaBs1s+79PbW2C4+woEvskxUOoLuetmKipeU6m5w6PxgInDUCQRGhH
         NxWg==
X-Gm-Message-State: APjAAAVhXjQM8xa0SgGYhdP8yMj7aambZ0D4ju2N3v1QtxydgZPNLoHx
        4SJgVJZr9HuhM7E51u3tLupqBzowA3EW3DtE0TOh5by7VcQ=
X-Google-Smtp-Source: APXvYqx4HKuSpwViRsev1LRriZRAvsPMz7XDU0C0rr46WKH6EjpwWTjXljEKtv4oNMk5nkCkVBppSs5Wdv5uq1j67i4=
X-Received: by 2002:a37:520a:: with SMTP id g10mr1677516qkb.39.1570593704600;
 Tue, 08 Oct 2019 21:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-6-ast@kernel.org>
 <CAEf4BzZvZ_gseRgaJb-fXJ-M=0c71PebQLbDH50BL5fCK6yZ1g@mail.gmail.com> <b1d49ded-6d16-9476-ac70-89371ba7c709@fb.com>
In-Reply-To: <b1d49ded-6d16-9476-ac70-89371ba7c709@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Oct 2019 21:01:33 -0700
Message-ID: <CAEf4BzYUoGb2k9MwbyDpfm1p6+mbbSc_t4rcM6TKZ-Q2VaGxpw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/10] bpf: implement accurate raw_tp context
 access via BTF
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 8:31 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/7/19 5:35 PM, Andrii Nakryiko wrote:
> > On Fri, Oct 4, 2019 at 10:04 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >>
> >> libbpf analyzes bpf C program, searches in-kernel BTF for given type name
> >> and stores it into expected_attach_type.
> >> The kernel verifier expects this btf_id to point to something like:
> >> typedef void (*btf_trace_kfree_skb)(void *, struct sk_buff *skb, void *loc);
> >> which represents signature of raw_tracepoint "kfree_skb".
> >>
> >> Then btf_ctx_access() matches ctx+0 access in bpf program with 'skb'
> >> and 'ctx+8' access with 'loc' arguments of "kfree_skb" tracepoint.
> >> In first case it passes btf_id of 'struct sk_buff *' back to the verifier core
> >> and 'void *' in second case.
> >>
> >> Then the verifier tracks PTR_TO_BTF_ID as any other pointer type.
> >> Like PTR_TO_SOCKET points to 'struct bpf_sock',
> >> PTR_TO_TCP_SOCK points to 'struct bpf_tcp_sock', and so on.
> >> PTR_TO_BTF_ID points to in-kernel structs.
> >> If 1234 is btf_id of 'struct sk_buff' in vmlinux's BTF
> >> then PTR_TO_BTF_ID#1234 points to one of in kernel skbs.
> >>
> >> When PTR_TO_BTF_ID#1234 is dereferenced (like r2 = *(u64 *)r1 + 32)
> >> the btf_struct_access() checks which field of 'struct sk_buff' is
> >> at offset 32. Checks that size of access matches type definition
> >> of the field and continues to track the dereferenced type.
> >> If that field was a pointer to 'struct net_device' the r2's type
> >> will be PTR_TO_BTF_ID#456. Where 456 is btf_id of 'struct net_device'
> >> in vmlinux's BTF.
> >>
> >> Such verifier anlaysis prevents "cheating" in BPF C program.
> >
> > typo: analysis
>
> I did ran spellcheck, but couldn't interpret its input :)
>
> >
> >> The program cannot cast arbitrary pointer to 'struct sk_buff *'
> >> and access it. C compiler would allow type cast, of course,
> >> but the verifier will notice type mismatch based on BPF assembly
> >> and in-kernel BTF.
> >>
> >> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >> ---
> >>   include/linux/bpf.h          |  15 ++-
> >>   include/linux/bpf_verifier.h |   2 +
> >>   kernel/bpf/btf.c             | 179 +++++++++++++++++++++++++++++++++++
> >>   kernel/bpf/verifier.c        |  69 +++++++++++++-
> >>   kernel/trace/bpf_trace.c     |   2 +-
> >>   5 files changed, 262 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> >> index 5b9d22338606..2dc3a7c313e9 100644
> >> --- a/include/linux/bpf.h
> >> +++ b/include/linux/bpf.h
> >> @@ -281,6 +281,7 @@ enum bpf_reg_type {
> >>          PTR_TO_TCP_SOCK_OR_NULL, /* reg points to struct tcp_sock or NULL */
> >>          PTR_TO_TP_BUFFER,        /* reg points to a writable raw tp's buffer */
> >>          PTR_TO_XDP_SOCK,         /* reg points to struct xdp_sock */
> >> +       PTR_TO_BTF_ID,
> >
> > comments for consistency? ;)
>
> fixed
>
> >>   };
> >>
> >>   /* The information passed from prog-specific *_is_valid_access
> >> @@ -288,7 +289,11 @@ enum bpf_reg_type {
> >>    */
> >>   struct bpf_insn_access_aux {
> >>          enum bpf_reg_type reg_type;
> >> -       int ctx_field_size;
> >> +       union {
> >> +               int ctx_field_size;
> >> +               u32 btf_id;
> >> +       };
> >> +       struct bpf_verifier_env *env; /* for verbose logs */
> >>   };
> >>
> >>   static inline void
> >> @@ -747,6 +752,14 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
> >>   int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
> >>                                       const union bpf_attr *kattr,
> >>                                       union bpf_attr __user *uattr);
> >> +bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >> +                   const struct bpf_prog *prog,
> >> +                   struct bpf_insn_access_aux *info);
> >> +int btf_struct_access(struct bpf_verifier_env *env,
> >> +                     const struct btf_type *t, int off, int size,
> >> +                     enum bpf_access_type atype,
> >> +                     u32 *next_btf_id);
> >> +
> >>   #else /* !CONFIG_BPF_SYSCALL */
> >>   static inline struct bpf_prog *bpf_prog_get(u32 ufd)
> >>   {
> >> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> >> index 432ba8977a0a..e21782f49c45 100644
> >> --- a/include/linux/bpf_verifier.h
> >> +++ b/include/linux/bpf_verifier.h
> >> @@ -52,6 +52,8 @@ struct bpf_reg_state {
> >>                   */
> >>                  struct bpf_map *map_ptr;
> >>
> >> +               u32 btf_id; /* for PTR_TO_BTF_ID */
> >> +
> >>                  /* Max size from any of the above. */
> >>                  unsigned long raw;
> >>          };
> >> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> >> index 848f9d4b9d7e..61ff8a54ca22 100644
> >> --- a/kernel/bpf/btf.c
> >> +++ b/kernel/bpf/btf.c
> >> @@ -3433,6 +3433,185 @@ struct btf *btf_parse_vmlinux(void)
> >>          return ERR_PTR(err);
> >>   }
> >>
> >> +extern struct btf *btf_vmlinux;
> >> +
> >> +bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >> +                   const struct bpf_prog *prog,
> >> +                   struct bpf_insn_access_aux *info)
> >> +{
> >> +       u32 btf_id = prog->expected_attach_type;
> >> +       const struct btf_param *args;
> >> +       const struct btf_type *t;
> >> +       const char prefix[] = "btf_trace_";
> >> +       const char *tname;
> >> +       u32 nr_args;
> >> +
> >> +       if (!btf_id)
> >> +               return true;
> >> +
> >> +       if (IS_ERR(btf_vmlinux)) {
> >> +               bpf_verifier_log_write(info->env, "btf_vmlinux is malformed\n");
> >> +               return false;
> >> +       }
> >> +
> >> +       t = btf_type_by_id(btf_vmlinux, btf_id);
> >> +       if (!t || BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
> >> +               bpf_verifier_log_write(info->env, "btf_id is invalid\n");
> >> +               return false;
> >> +       }
> >> +
> >> +       tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
> >> +       if (strncmp(prefix, tname, sizeof(prefix) - 1)) {
> >> +               bpf_verifier_log_write(info->env,
> >> +                                      "btf_id points to wrong type name %s\n",
> >> +                                      tname);
> >> +               return false;
> >> +       }
> >> +       tname += sizeof(prefix) - 1;
> >> +
> >> +       t = btf_type_by_id(btf_vmlinux, t->type);
> >> +       if (!btf_type_is_ptr(t))
> >> +               return false;
> >> +       t = btf_type_by_id(btf_vmlinux, t->type);
> >> +       if (!btf_type_is_func_proto(t))
> >> +               return false;
> >
> > All negative cases but these two have helpful log messages, please add
> > two more for these.
>
> no. not here. This is a part of typedef construction from patch 1.
> It cannot be anything else. If btf_id points to typedef and
> typedef has btf_trace_ prefix it has to be correct.
> Above two checks are checking sanity of kernel build.

Fair enough.

>
> >
> >> +
> >> +       args = (const struct btf_param *)(t + 1);
> >
> > IMO, doing args++ (and leaving comment why) here instead of adjusting
> > `off/8 + 1` below is cleaner.
>
> I tried your suggestion and it doesn't look any better, but why not.
> Since I've coded it anyway.
>
> >> +       /* skip first 'void *__data' argument in btf_trace_* */
> >> +       nr_args = btf_type_vlen(t) - 1;
> >> +       if (off >= nr_args * 8) {
> >
> > Looks like you forgot to check that `off % 8 == 0`?
>
> great catch. yes. fixed
>
> >> +               bpf_verifier_log_write(info->env,
> >> +                                      "raw_tp '%s' doesn't have %d-th argument\n",
> >> +                                      tname, off / 8);
> >> +               return false;
> >> +       }
> >> +
> >> +       /* raw tp arg is off / 8, but typedef has extra 'void *', hence +1 */
> >> +       t = btf_type_by_id(btf_vmlinux, args[off / 8 + 1].type);
> >> +       if (btf_type_is_int(t))
> >
> > this is too limiting, you need to strip const/volatile/restrict and
> > resolve typedef's (e.g., size_t, __u64 -- that's all typedefs).
>
> right. done.
>
> > also probably want to allow enums.
>
> eventually yes. I prefer to walk first.

sure, but it is just an integer (scalar) so with just `||
btf_is_enum(t)` you get that support for free.

>
> > btw, atomic_t is a struct, so might want to allow up to 8 byte
> > struct/unions (passed by value) reads? might never happen for
> > tracepoint, not sure
>
> may be in the future. walk first.
>
> >
> >> +               /* accessing a scalar */
> >> +               return true;
> >> +       if (!btf_type_is_ptr(t)) {
> >
> > similar to above, modifiers and typedef resolution has to happen first
>
> done.
>
> >> +               bpf_verifier_log_write(info->env,
> >> +                                      "raw_tp '%s' arg%d '%s' has type %s. Only pointer access is allowed\n",
> >> +                                      tname, off / 8,
> >> +                                      __btf_name_by_offset(btf_vmlinux, t->name_off),
> >> +                                      btf_kind_str[BTF_INFO_KIND(t->info)]);
> >> +               return false;
> >> +       }
> >> +       if (t->type == 0)
> >> +               /* This is a pointer to void.
> >> +                * It is the same as scalar from the verifier safety pov.
> >> +                * No further pointer walking is allowed.
> >> +                */
> >> +               return true;
> >> +
> >> +       /* this is a pointer to another type */
> >> +       info->reg_type = PTR_TO_BTF_ID;
> >> +       info->btf_id = t->type;
> >> +
> >> +       t = btf_type_by_id(btf_vmlinux, t->type);
> >> +       bpf_verifier_log_write(info->env,
> >> +                              "raw_tp '%s' arg%d has btf_id %d type %s '%s'\n",
> >> +                              tname, off / 8, info->btf_id,
> >> +                              btf_kind_str[BTF_INFO_KIND(t->info)],
> >> +                              __btf_name_by_offset(btf_vmlinux, t->name_off));
> >> +       return true;
> >> +}
> >> +
> >> +int btf_struct_access(struct bpf_verifier_env *env,
> >> +                     const struct btf_type *t, int off, int size,
> >> +                     enum bpf_access_type atype,
> >> +                     u32 *next_btf_id)
> >> +{
> >> +       const struct btf_member *member;
> >> +       const struct btf_type *mtype;
> >> +       const char *tname, *mname;
> >> +       int i, moff = 0, msize;
> >> +
> >> +again:
> >> +       tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> >> +       if (!btf_type_is_struct(t)) {
> >
> > see above about typedef/modifiers resolution
>
> here actually skipping is not necessary.
>
> >
> >> +               bpf_verifier_log_write(env, "Type '%s' is not a struct", tname);
> >> +               return -EINVAL;
> >> +       }
> >> +       if (btf_type_vlen(t) < 1) {
> >> +               bpf_verifier_log_write(env, "struct %s doesn't have fields", tname);
> >> +               return -EINVAL;
> >> +       }
> >
> > kind of redundant check...
>
> I wanted to give helpful message, but since you asked.
> There are 394 struct FOO {}; in the kernel.
> And probably none of them are going to appear in bpf tracing,
> so I deleted that check.
>
> >
> >> +
> >> +       for_each_member(i, t, member) {
> >> +
> >> +               /* offset of the field */
> >> +               moff = btf_member_bit_offset(t, member);
> >
> > what do you want to do with bitfields?
>
> they're scalars.

well, I meant that `off` is offset in bytes, while moff is offset in
bits and for bitfield fields it might not be a multiple of 8, so after
check below (off < moff/8) it doesn't necessarily mean that `off * 8
== moff` and you'll be "capturing" wrong field. So you probably need
extra check for that?

More generally, also, `off` can point into the middle of some field,
not the beginning of the field (because it's just a byte offset, so
can be arbitrary). So there are two things there: detecting this
situation and what to do with this, reject or assume opaque scalar
value?

>
> >> +
> >> +               if (off < moff / 8)
> >> +                       continue;

Thinking about this again, this seems like an inverted condition.
Shouldn't it be "skip field until you find field offset equal or
greater than our desired offset":

if (moff < off * 8)
    continue;

> >> +
> >> +               /* type of the field */
> >> +               mtype = btf_type_by_id(btf_vmlinux, member->type);
> >> +               mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
> >
> > nit: you mix btf_name_by_offset and __btf_name_by_offset, any reason
> > to not stick to just one of them (__btf_name_by_offset is safer, so
> > that one, probably)?
>
> I tried to use btf_name_by_offset() in verifier.c and
> __btf_name_by_offset() in btf.c consistently.
> Looks like I missed one spot.
> Fixed.
>
> >
> >> +
> >> +               /* skip typedef, volotile modifiers */
> >
> > typo: volatile
> >
> > nit: also, volatile is not special, so either mention
> > const/volatile/restrict or just "modifiers"?
>
> fixed
>
> >> +               while (btf_type_is_modifier(mtype))
> >> +                       mtype = btf_type_by_id(btf_vmlinux, mtype->type);
> >> +
> >> +               if (btf_type_is_array(mtype))
> >> +                       /* array deref is not supported yet */
> >> +                       continue;
> >> +
> >> +               if (!btf_type_has_size(mtype) && !btf_type_is_ptr(mtype)) {
> >> +                       bpf_verifier_log_write(env,
> >> +                                              "field %s doesn't have size\n",
> >> +                                              mname);
> >> +                       return -EFAULT;
> >> +               }
> >> +               if (btf_type_is_ptr(mtype))
> >> +                       msize = 8;
> >> +               else
> >> +                       msize = mtype->size;
> >> +               if (off >= moff / 8 + msize)
> >> +                       /* rare case, must be a field of the union with smaller size,
> >> +                        * let's try another field
> >> +                        */
> >> +                       continue;
> >> +               /* the 'off' we're looking for is either equal to start
> >> +                * of this field or inside of this struct
> >> +                */
> >> +               if (btf_type_is_struct(mtype)) {
> >> +                       /* our field must be inside that union or struct */
> >> +                       t = mtype;
> >> +
> >> +                       /* adjust offset we're looking for */
> >> +                       off -= moff / 8;
> >> +                       goto again;
> >> +               }
> >> +               if (msize != size) {
> >> +                       /* field access size doesn't match */
> >> +                       bpf_verifier_log_write(env,
> >> +                                              "cannot access %d bytes in struct %s field %s that has size %d\n",
> >> +                                              size, tname, mname, msize);
> >> +                       return -EACCES;
> >> +               }
> >> +
> >> +               if (btf_type_is_ptr(mtype)) {
> >> +                       const struct btf_type *stype;
> >> +
> >> +                       stype = btf_type_by_id(btf_vmlinux, mtype->type);
> >> +                       if (btf_type_is_struct(stype)) {
> >
> > again, resolving modifiers/typedefs? though in this case it might be
> > too eager?...
>
> done
>
> >> +                               *next_btf_id = mtype->type;
> >> +                               return PTR_TO_BTF_ID;
> >> +                       }
> >> +               }
> >> +               /* all other fields are treated as scalars */
> >> +               return SCALAR_VALUE;
> >> +       }
> >> +       bpf_verifier_log_write(env,
> >> +                              "struct %s doesn't have field at offset %d\n",
> >> +                              tname, off);
> >> +       return -EINVAL;
> >> +}
> >> +
> >>   void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
> >>                         struct seq_file *m)
> >>   {
> >> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >> index 91c4db4d1c6a..3c155873ffea 100644
> >> --- a/kernel/bpf/verifier.c
> >> +++ b/kernel/bpf/verifier.c
> >> @@ -406,6 +406,7 @@ static const char * const reg_type_str[] = {
> >>          [PTR_TO_TCP_SOCK_OR_NULL] = "tcp_sock_or_null",
> >>          [PTR_TO_TP_BUFFER]      = "tp_buffer",
> >>          [PTR_TO_XDP_SOCK]       = "xdp_sock",
> >> +       [PTR_TO_BTF_ID]         = "ptr_",
> >>   };
> >>
> >>   static char slot_type_char[] = {
> >> @@ -460,6 +461,10 @@ static void print_verifier_state(struct bpf_verifier_env *env,
> >>                          /* reg->off should be 0 for SCALAR_VALUE */
> >>                          verbose(env, "%lld", reg->var_off.value + reg->off);
> >>                  } else {
> >> +                       if (t == PTR_TO_BTF_ID)
> >> +                               verbose(env, "%s",
> >> +                                       btf_name_by_offset(btf_vmlinux,
> >> +                                                          btf_type_by_id(btf_vmlinux, reg->btf_id)->name_off));
> >>                          verbose(env, "(id=%d", reg->id);
> >>                          if (reg_type_may_be_refcounted_or_null(t))
> >>                                  verbose(env, ",ref_obj_id=%d", reg->ref_obj_id);
> >> @@ -2337,10 +2342,12 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
> >>
> >>   /* check access to 'struct bpf_context' fields.  Supports fixed offsets only */
> >>   static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off, int size,
> >> -                           enum bpf_access_type t, enum bpf_reg_type *reg_type)
> >> +                           enum bpf_access_type t, enum bpf_reg_type *reg_type,
> >> +                           u32 *btf_id)
> >>   {
> >>          struct bpf_insn_access_aux info = {
> >>                  .reg_type = *reg_type,
> >> +               .env = env,
> >>          };
> >>
> >>          if (env->ops->is_valid_access &&
> >> @@ -2354,7 +2361,10 @@ static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off,
> >>                   */
> >>                  *reg_type = info.reg_type;
> >>
> >> -               env->insn_aux_data[insn_idx].ctx_field_size = info.ctx_field_size;
> >> +               if (*reg_type == PTR_TO_BTF_ID)
> >> +                       *btf_id = info.btf_id;
> >> +               else
> >> +                       env->insn_aux_data[insn_idx].ctx_field_size = info.ctx_field_size;
> >
> > ctx_field_size is passed through bpf_insn_access_aux, but btf_id is
> > returned like this. Is there a reason to do it in two different ways?
>
> insn_aux_data is permanent. Meaning that any executing path into
> this instruction got to have the same size and offset of ctx access.
> I think btf based ctx access doesn't have to be.
> There is a check later to make sure r1=ctx dereferenceing btf is
> permanent, but r1=btf dereferencing btf is clearly note.
> I'm still not sure whether former will be permanent forever.
> So went with quick hack above to reduce amount of potential
> refactoring later. I'll think about it more.

Yeah, it makes sense. I agree we shouldn't enforce same BTF type ID
through all executions paths, if possible. I just saw you added btf_id
both to struct bpf_insn_access_aux and reg_state, so was wondering
what's going on.

>
> >>                  /* remember the offset of last byte accessed in ctx */
> >>                  if (env->prog->aux->max_ctx_offset < off + size)
> >>                          env->prog->aux->max_ctx_offset = off + size;
> >> @@ -2745,6 +2755,53 @@ static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
> >>          reg->smax_value = reg->umax_value;
> >>   }
> >>
> >> +static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
> >> +                                  struct bpf_reg_state *regs,
> >> +                                  int regno, int off, int size,
> >> +                                  enum bpf_access_type atype,
> >> +                                  int value_regno)
> >> +{
> >> +       struct bpf_reg_state *reg = regs + regno;
> >> +       const struct btf_type *t = btf_type_by_id(btf_vmlinux, reg->btf_id);
> >> +       const char *tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> >> +       u32 btf_id;
> >> +       int ret;
> >> +
> >> +       if (atype != BPF_READ) {
> >> +               verbose(env, "only read is supported\n");
> >> +               return -EACCES;
> >> +       }
> >> +
> >> +       if (off < 0) {
> >> +               verbose(env,
> >> +                       "R%d is ptr_%s negative access %d is not allowed\n",
> >
> > totally nit: but for consistency sake (following variable offset error
> > below): R%d is ptr_%s negative access: off=%d\n"?
>
> fixed
>
> >> +                       regno, tname, off);
> >> +               return -EACCES;
> >> +       }
> >> +       if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
> >
> > why so strict about reg->var_off.value?
>
> It's variable part of register access.
> There is no fixed offset to pass into btf_struct_access().
> In other words 'arrays of pointers to btf_id' are not supported yet.
> Walk first :)
>

yeah, I'm fine with that
