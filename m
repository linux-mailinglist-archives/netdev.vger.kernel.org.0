Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E91CEFEE
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 02:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbfJHAf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 20:35:56 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43500 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbfJHAf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 20:35:56 -0400
Received: by mail-qk1-f196.google.com with SMTP id h126so14639661qke.10;
        Mon, 07 Oct 2019 17:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uZ7NiFeNFd0ANChb7qC2GKwsYwSmtL169hj0dTAf6SI=;
        b=aauMlvZmx8Y5tljZ+xBuawcIgyIX22/pws58k63bO+Jlwmta1xX/192197bSWdFTCm
         BBnl6mhfldwP/pypUffxZEjLhFXJnVhTtTuajwihMlSSOFq47ViLPQj0fXM2Ilx9xprS
         8X6xwa+7EgCQJAGlQhI1YcXAyH+/lVAi9OF63ORPP4lG4oskfhKSccZngLYAhYUv7TjK
         JWr+Y3PQHuonVM3UaWzKkSkqnv4K65z93on89YDSBb5OK09m48fRBdkpjFclxg3OaiGt
         jn68yoiXGUeNazbpriotySZCAbmy7JK3wrv2Z66aBYDQPY9lz++Nx00nVfQNtc3Lp0G6
         PzHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uZ7NiFeNFd0ANChb7qC2GKwsYwSmtL169hj0dTAf6SI=;
        b=d5hm6lioZCXtPzDUmSn52pDnfjS8W9ZV+sMufeuhQiGdqs8bNNMUPPUgdLe4eoLmJn
         UcpaD6Dy+Ahr414pPQO1udzilLZ1PcB4f/+jXEz72beNeSxeJkKAJZVfol4IGP5WXzIs
         8MUxbP7/5aKgm0wkOsLmgFMqy6AIcxDwqLbCFN7hn1I6n/yr+k5KI48GftWpML/1pWs3
         6DS+6XE2R8815VR2HOwc7ByYcraQRVkuNcN2NpfFeEzcFZciT377SprCCS+F3MHmxXDD
         k8SbjESPLQbwetMPq6jnQmGJAlQGHH+TdMPj8q11K6zdM4PnliWcAQaIN45tb0s8m1sZ
         vUwg==
X-Gm-Message-State: APjAAAUu/iXtHF1wiWXOp95squV+15dEUnGjUzNle0egx7FJ9bnlE3fG
        5bX8I3V9Ei3bRTo+GBHI2T4afduwn03czdPFOt8=
X-Google-Smtp-Source: APXvYqy6Nclubo6sOProNM8MlO87JkHpjLHlE5di0VtJxTVuRhYq71xygo4Lw/BsPQYka6R2rGP0QZlMWNcxafy9VpE=
X-Received: by 2002:ae9:eb93:: with SMTP id b141mr27201978qkg.36.1570494954474;
 Mon, 07 Oct 2019 17:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-6-ast@kernel.org>
In-Reply-To: <20191005050314.1114330-6-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Oct 2019 17:35:43 -0700
Message-ID: <CAEf4BzZvZ_gseRgaJb-fXJ-M=0c71PebQLbDH50BL5fCK6yZ1g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/10] bpf: implement accurate raw_tp context
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

On Fri, Oct 4, 2019 at 10:04 PM Alexei Starovoitov <ast@kernel.org> wrote:
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
> Such verifier anlaysis prevents "cheating" in BPF C program.

typo: analysis

> The program cannot cast arbitrary pointer to 'struct sk_buff *'
> and access it. C compiler would allow type cast, of course,
> but the verifier will notice type mismatch based on BPF assembly
> and in-kernel BTF.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf.h          |  15 ++-
>  include/linux/bpf_verifier.h |   2 +
>  kernel/bpf/btf.c             | 179 +++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c        |  69 +++++++++++++-
>  kernel/trace/bpf_trace.c     |   2 +-
>  5 files changed, 262 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5b9d22338606..2dc3a7c313e9 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -281,6 +281,7 @@ enum bpf_reg_type {
>         PTR_TO_TCP_SOCK_OR_NULL, /* reg points to struct tcp_sock or NULL */
>         PTR_TO_TP_BUFFER,        /* reg points to a writable raw tp's buffer */
>         PTR_TO_XDP_SOCK,         /* reg points to struct xdp_sock */
> +       PTR_TO_BTF_ID,

comments for consistency? ;)

>  };
>
>  /* The information passed from prog-specific *_is_valid_access
> @@ -288,7 +289,11 @@ enum bpf_reg_type {
>   */
>  struct bpf_insn_access_aux {
>         enum bpf_reg_type reg_type;
> -       int ctx_field_size;
> +       union {
> +               int ctx_field_size;
> +               u32 btf_id;
> +       };
> +       struct bpf_verifier_env *env; /* for verbose logs */
>  };
>
>  static inline void
> @@ -747,6 +752,14 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>  int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>                                      const union bpf_attr *kattr,
>                                      union bpf_attr __user *uattr);
> +bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> +                   const struct bpf_prog *prog,
> +                   struct bpf_insn_access_aux *info);
> +int btf_struct_access(struct bpf_verifier_env *env,
> +                     const struct btf_type *t, int off, int size,
> +                     enum bpf_access_type atype,
> +                     u32 *next_btf_id);
> +
>  #else /* !CONFIG_BPF_SYSCALL */
>  static inline struct bpf_prog *bpf_prog_get(u32 ufd)
>  {
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 432ba8977a0a..e21782f49c45 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -52,6 +52,8 @@ struct bpf_reg_state {
>                  */
>                 struct bpf_map *map_ptr;
>
> +               u32 btf_id; /* for PTR_TO_BTF_ID */
> +
>                 /* Max size from any of the above. */
>                 unsigned long raw;
>         };
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 848f9d4b9d7e..61ff8a54ca22 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3433,6 +3433,185 @@ struct btf *btf_parse_vmlinux(void)
>         return ERR_PTR(err);
>  }
>
> +extern struct btf *btf_vmlinux;
> +
> +bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> +                   const struct bpf_prog *prog,
> +                   struct bpf_insn_access_aux *info)
> +{
> +       u32 btf_id = prog->expected_attach_type;
> +       const struct btf_param *args;
> +       const struct btf_type *t;
> +       const char prefix[] = "btf_trace_";
> +       const char *tname;
> +       u32 nr_args;
> +
> +       if (!btf_id)
> +               return true;
> +
> +       if (IS_ERR(btf_vmlinux)) {
> +               bpf_verifier_log_write(info->env, "btf_vmlinux is malformed\n");
> +               return false;
> +       }
> +
> +       t = btf_type_by_id(btf_vmlinux, btf_id);
> +       if (!t || BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
> +               bpf_verifier_log_write(info->env, "btf_id is invalid\n");
> +               return false;
> +       }
> +
> +       tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
> +       if (strncmp(prefix, tname, sizeof(prefix) - 1)) {
> +               bpf_verifier_log_write(info->env,
> +                                      "btf_id points to wrong type name %s\n",
> +                                      tname);
> +               return false;
> +       }
> +       tname += sizeof(prefix) - 1;
> +
> +       t = btf_type_by_id(btf_vmlinux, t->type);
> +       if (!btf_type_is_ptr(t))
> +               return false;
> +       t = btf_type_by_id(btf_vmlinux, t->type);
> +       if (!btf_type_is_func_proto(t))
> +               return false;

All negative cases but these two have helpful log messages, please add
two more for these.

> +
> +       args = (const struct btf_param *)(t + 1);

IMO, doing args++ (and leaving comment why) here instead of adjusting
`off/8 + 1` below is cleaner.

> +       /* skip first 'void *__data' argument in btf_trace_* */
> +       nr_args = btf_type_vlen(t) - 1;
> +       if (off >= nr_args * 8) {

Looks like you forgot to check that `off % 8 == 0`?

> +               bpf_verifier_log_write(info->env,
> +                                      "raw_tp '%s' doesn't have %d-th argument\n",
> +                                      tname, off / 8);
> +               return false;
> +       }
> +
> +       /* raw tp arg is off / 8, but typedef has extra 'void *', hence +1 */
> +       t = btf_type_by_id(btf_vmlinux, args[off / 8 + 1].type);
> +       if (btf_type_is_int(t))

this is too limiting, you need to strip const/volatile/restrict and
resolve typedef's (e.g., size_t, __u64 -- that's all typedefs).

also probably want to allow enums.

btw, atomic_t is a struct, so might want to allow up to 8 byte
struct/unions (passed by value) reads? might never happen for
tracepoint, not sure

> +               /* accessing a scalar */
> +               return true;
> +       if (!btf_type_is_ptr(t)) {

similar to above, modifiers and typedef resolution has to happen first

> +               bpf_verifier_log_write(info->env,
> +                                      "raw_tp '%s' arg%d '%s' has type %s. Only pointer access is allowed\n",
> +                                      tname, off / 8,
> +                                      __btf_name_by_offset(btf_vmlinux, t->name_off),
> +                                      btf_kind_str[BTF_INFO_KIND(t->info)]);
> +               return false;
> +       }
> +       if (t->type == 0)
> +               /* This is a pointer to void.
> +                * It is the same as scalar from the verifier safety pov.
> +                * No further pointer walking is allowed.
> +                */
> +               return true;
> +
> +       /* this is a pointer to another type */
> +       info->reg_type = PTR_TO_BTF_ID;
> +       info->btf_id = t->type;
> +
> +       t = btf_type_by_id(btf_vmlinux, t->type);
> +       bpf_verifier_log_write(info->env,
> +                              "raw_tp '%s' arg%d has btf_id %d type %s '%s'\n",
> +                              tname, off / 8, info->btf_id,
> +                              btf_kind_str[BTF_INFO_KIND(t->info)],
> +                              __btf_name_by_offset(btf_vmlinux, t->name_off));
> +       return true;
> +}
> +
> +int btf_struct_access(struct bpf_verifier_env *env,
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
> +       tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> +       if (!btf_type_is_struct(t)) {

see above about typedef/modifiers resolution

> +               bpf_verifier_log_write(env, "Type '%s' is not a struct", tname);
> +               return -EINVAL;
> +       }
> +       if (btf_type_vlen(t) < 1) {
> +               bpf_verifier_log_write(env, "struct %s doesn't have fields", tname);
> +               return -EINVAL;
> +       }

kind of redundant check...

> +
> +       for_each_member(i, t, member) {
> +
> +               /* offset of the field */
> +               moff = btf_member_bit_offset(t, member);

what do you want to do with bitfields?

> +
> +               if (off < moff / 8)
> +                       continue;
> +
> +               /* type of the field */
> +               mtype = btf_type_by_id(btf_vmlinux, member->type);
> +               mname = __btf_name_by_offset(btf_vmlinux, member->name_off);

nit: you mix btf_name_by_offset and __btf_name_by_offset, any reason
to not stick to just one of them (__btf_name_by_offset is safer, so
that one, probably)?

> +
> +               /* skip typedef, volotile modifiers */

typo: volatile

nit: also, volatile is not special, so either mention
const/volatile/restrict or just "modifiers"?

> +               while (btf_type_is_modifier(mtype))
> +                       mtype = btf_type_by_id(btf_vmlinux, mtype->type);
> +
> +               if (btf_type_is_array(mtype))
> +                       /* array deref is not supported yet */
> +                       continue;
> +
> +               if (!btf_type_has_size(mtype) && !btf_type_is_ptr(mtype)) {
> +                       bpf_verifier_log_write(env,
> +                                              "field %s doesn't have size\n",
> +                                              mname);
> +                       return -EFAULT;
> +               }
> +               if (btf_type_is_ptr(mtype))
> +                       msize = 8;
> +               else
> +                       msize = mtype->size;
> +               if (off >= moff / 8 + msize)
> +                       /* rare case, must be a field of the union with smaller size,
> +                        * let's try another field
> +                        */
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
> +                       bpf_verifier_log_write(env,
> +                                              "cannot access %d bytes in struct %s field %s that has size %d\n",
> +                                              size, tname, mname, msize);
> +                       return -EACCES;
> +               }
> +
> +               if (btf_type_is_ptr(mtype)) {
> +                       const struct btf_type *stype;
> +
> +                       stype = btf_type_by_id(btf_vmlinux, mtype->type);
> +                       if (btf_type_is_struct(stype)) {

again, resolving modifiers/typedefs? though in this case it might be
too eager?...

> +                               *next_btf_id = mtype->type;
> +                               return PTR_TO_BTF_ID;
> +                       }
> +               }
> +               /* all other fields are treated as scalars */
> +               return SCALAR_VALUE;
> +       }
> +       bpf_verifier_log_write(env,
> +                              "struct %s doesn't have field at offset %d\n",
> +                              tname, off);
> +       return -EINVAL;
> +}
> +
>  void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
>                        struct seq_file *m)
>  {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 91c4db4d1c6a..3c155873ffea 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -406,6 +406,7 @@ static const char * const reg_type_str[] = {
>         [PTR_TO_TCP_SOCK_OR_NULL] = "tcp_sock_or_null",
>         [PTR_TO_TP_BUFFER]      = "tp_buffer",
>         [PTR_TO_XDP_SOCK]       = "xdp_sock",
> +       [PTR_TO_BTF_ID]         = "ptr_",
>  };
>
>  static char slot_type_char[] = {
> @@ -460,6 +461,10 @@ static void print_verifier_state(struct bpf_verifier_env *env,
>                         /* reg->off should be 0 for SCALAR_VALUE */
>                         verbose(env, "%lld", reg->var_off.value + reg->off);
>                 } else {
> +                       if (t == PTR_TO_BTF_ID)
> +                               verbose(env, "%s",
> +                                       btf_name_by_offset(btf_vmlinux,
> +                                                          btf_type_by_id(btf_vmlinux, reg->btf_id)->name_off));
>                         verbose(env, "(id=%d", reg->id);
>                         if (reg_type_may_be_refcounted_or_null(t))
>                                 verbose(env, ",ref_obj_id=%d", reg->ref_obj_id);
> @@ -2337,10 +2342,12 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
>
>  /* check access to 'struct bpf_context' fields.  Supports fixed offsets only */
>  static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off, int size,
> -                           enum bpf_access_type t, enum bpf_reg_type *reg_type)
> +                           enum bpf_access_type t, enum bpf_reg_type *reg_type,
> +                           u32 *btf_id)
>  {
>         struct bpf_insn_access_aux info = {
>                 .reg_type = *reg_type,
> +               .env = env,
>         };
>
>         if (env->ops->is_valid_access &&
> @@ -2354,7 +2361,10 @@ static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off,
>                  */
>                 *reg_type = info.reg_type;
>
> -               env->insn_aux_data[insn_idx].ctx_field_size = info.ctx_field_size;
> +               if (*reg_type == PTR_TO_BTF_ID)
> +                       *btf_id = info.btf_id;
> +               else
> +                       env->insn_aux_data[insn_idx].ctx_field_size = info.ctx_field_size;

ctx_field_size is passed through bpf_insn_access_aux, but btf_id is
returned like this. Is there a reason to do it in two different ways?

>                 /* remember the offset of last byte accessed in ctx */
>                 if (env->prog->aux->max_ctx_offset < off + size)
>                         env->prog->aux->max_ctx_offset = off + size;
> @@ -2745,6 +2755,53 @@ static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
>         reg->smax_value = reg->umax_value;
>  }
>
> +static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
> +                                  struct bpf_reg_state *regs,
> +                                  int regno, int off, int size,
> +                                  enum bpf_access_type atype,
> +                                  int value_regno)
> +{
> +       struct bpf_reg_state *reg = regs + regno;
> +       const struct btf_type *t = btf_type_by_id(btf_vmlinux, reg->btf_id);
> +       const char *tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> +       u32 btf_id;
> +       int ret;
> +
> +       if (atype != BPF_READ) {
> +               verbose(env, "only read is supported\n");
> +               return -EACCES;
> +       }
> +
> +       if (off < 0) {
> +               verbose(env,
> +                       "R%d is ptr_%s negative access %d is not allowed\n",

totally nit: but for consistency sake (following variable offset error
below): R%d is ptr_%s negative access: off=%d\n"?

> +                       regno, tname, off);
> +               return -EACCES;
> +       }
> +       if (!tnum_is_const(reg->var_off) || reg->var_off.value) {

why so strict about reg->var_off.value?

> +               char tn_buf[48];
> +
> +               tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
> +               verbose(env,
> +                       "R%d is ptr_%s invalid variable offset: off=%d, var_off=%s\n",
> +                       regno, tname, off, tn_buf);
> +               return -EACCES;
> +       }
> +
> +       ret = btf_struct_access(env, t, off, size, atype, &btf_id);
> +       if (ret < 0)
> +               return ret;
> +
> +       if (ret == SCALAR_VALUE) {
> +               mark_reg_unknown(env, regs, value_regno);
> +               return 0;
> +       }
> +       mark_reg_known_zero(env, regs, value_regno);
> +       regs[value_regno].type = PTR_TO_BTF_ID;
> +       regs[value_regno].btf_id = btf_id;
> +       return 0;
> +}
> +
>  /* check whether memory at (regno + off) is accessible for t = (read | write)
>   * if t==write, value_regno is a register which value is stored into memory
>   * if t==read, value_regno is a register which will receive the value from memory
> @@ -2787,6 +2844,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>
>         } else if (reg->type == PTR_TO_CTX) {
>                 enum bpf_reg_type reg_type = SCALAR_VALUE;
> +               u32 btf_id = 0;
>
>                 if (t == BPF_WRITE && value_regno >= 0 &&
>                     is_pointer_value(env, value_regno)) {
> @@ -2798,7 +2856,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>                 if (err < 0)
>                         return err;
>
> -               err = check_ctx_access(env, insn_idx, off, size, t, &reg_type);
> +               err = check_ctx_access(env, insn_idx, off, size, t, &reg_type, &btf_id);
>                 if (!err && t == BPF_READ && value_regno >= 0) {
>                         /* ctx access returns either a scalar, or a
>                          * PTR_TO_PACKET[_META,_END]. In the latter
> @@ -2817,6 +2875,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>                                  * a sub-register.
>                                  */
>                                 regs[value_regno].subreg_def = DEF_NOT_SUBREG;
> +                               if (reg_type == PTR_TO_BTF_ID)
> +                                       regs[value_regno].btf_id = btf_id;
>                         }
>                         regs[value_regno].type = reg_type;
>                 }
> @@ -2876,6 +2936,9 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>                 err = check_tp_buffer_access(env, reg, regno, off, size);
>                 if (!err && t == BPF_READ && value_regno >= 0)
>                         mark_reg_unknown(env, regs, value_regno);
> +       } else if (reg->type == PTR_TO_BTF_ID) {
> +               err = check_ptr_to_btf_access(env, regs, regno, off, size, t,
> +                                             value_regno);
>         } else {
>                 verbose(env, "R%d invalid mem access '%s'\n", regno,
>                         reg_type_str[reg->type]);
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 44bd08f2443b..6221e8c6ecc3 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1074,7 +1074,7 @@ static bool raw_tp_prog_is_valid_access(int off, int size,
>                 return false;
>         if (off % size != 0)
>                 return false;
> -       return true;
> +       return btf_ctx_access(off, size, type, prog, info);
>  }
>
>  const struct bpf_verifier_ops raw_tracepoint_verifier_ops = {
> --
> 2.20.0
>
