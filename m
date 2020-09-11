Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2D7266896
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 21:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbgIKTNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 15:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgIKTNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 15:13:45 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCA0C061573;
        Fri, 11 Sep 2020 12:13:45 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id r7so7042790ybl.6;
        Fri, 11 Sep 2020 12:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ezo/UpGxJEettrygviVx20k+nY/SWwy96St3zpd2LM0=;
        b=Z5LxweTcAT/HCw3kzA2hGAatlo0j+pdN1HrGr370/yEXG0vMrx6fUV3SRqdi9M4th9
         1kwIywH1xzwL6mwtYsqFxCSdnwKpfe12YH2EjtNUC+r/q6Q017X5MZmatVfb8gP8cv9c
         N0XSmwbXCNhZPHUXARoDO225Yp2Pw5ZBTD0GCSDCSIehckWCXyT9bCPs/JRyLikpFl6M
         70MYEUG2QTMZtTrsjohQpxfzui1FJTxuMep16Qw0miGasIcM5/naA9ugqx4vv8U07InI
         vW89EHg4wTAFzrjkIuD6mxRMwNd+QoVCQfaXYB+b3G5D0jTsVBfSikgGwlo1rFXBc6y0
         qy3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ezo/UpGxJEettrygviVx20k+nY/SWwy96St3zpd2LM0=;
        b=Icq1rf59Tf8LjH0+BimFUm5y5+UZshrncjJLIazGUuWpqa5iv4ZWB/finhNU41Hyp1
         Kh9hXiTiDsoI9CzPbD4BWv31Q3H8YlRLCjJ3MYb6LSqxh50bzWXNxSdtVvuxrV8y0Wdv
         ixipX5MLE9/yoeo2XW3gmb4+oHQFeL+UH/wJPRilNSUU5htxIF2ilp6Affv3taximXFz
         PHr5/eKMLhHcBBWnGMtO3uoa+NQjDJGlPZMsX0Plug1WJbf4cidvmCEQziCY87AjxgZu
         TwWofssfi3eZlcOknonua1lh4wlskC1Hl7zsGx/lPGuMx3BJgMVzJe/cgtgP8yEwqaIP
         4COQ==
X-Gm-Message-State: AOAM531RGtF3k2P8Tp2jr0M/5UsCHWsF35CixM90sXBl+HLi7Za1eyD7
        3OXMHbFualb0MjMy52117dTr6HkqWoFg7va8B3Y=
X-Google-Smtp-Source: ABdhPJzSD3ZFfF246sEo9sR9Ft8SIsUjVCrKn1fieE0euAJ5nAqekL2J3RDClV1l/O5K5gbL5rtOjq2xdxUGkXQQjRk=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr4516951ybg.425.1599851624385;
 Fri, 11 Sep 2020 12:13:44 -0700 (PDT)
MIME-Version: 1.0
References: <159981835466.134722.8652987144251743467.stgit@toke.dk> <159981835693.134722.13561339671142530897.stgit@toke.dk>
In-Reply-To: <159981835693.134722.13561339671142530897.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Sep 2020 12:13:32 -0700
Message-ID: <CAEf4BzYNpOjt=Ua1hg3jAEe07a9mEd1UF2CZPys05O+ReaLo+Q@mail.gmail.com>
Subject: Re: [PATCH RESEND bpf-next v3 2/9] bpf: verifier: refactor check_attach_btf_id()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 3:00 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The check_attach_btf_id() function really does three things:
>
> 1. It performs a bunch of checks on the program to ensure that the
>    attachment is valid.
>
> 2. It stores a bunch of state about the attachment being requested in
>    the verifier environment and struct bpf_prog objects.
>
> 3. It allocates a trampoline for the attachment.
>
> This patch splits out (1.) and (3.) into separate functions in preparatio=
n
> for reusing them when the actual attachment is happening (in the
> raw_tracepoint_open syscall operation), which will allow tracing programs
> to have multiple (compatible) attachments.
>
> No functional change is intended with this patch.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

I can't tell if there are any functional changes or not, tbh. The
logic is quite complicated and full of intricate details. I did leave
some suggestions on hopefully simplifying code flow in some places
(and ensuring it's harder to break it on future changes), but I hope
Alexei will give it a very thorough review and check that none of the
subtle details broke.

>  include/linux/bpf.h          |    9 ++
>  include/linux/bpf_verifier.h |    9 ++
>  kernel/bpf/trampoline.c      |   22 ++++
>  kernel/bpf/verifier.c        |  233 +++++++++++++++++++++++-------------=
------
>  4 files changed, 170 insertions(+), 103 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5ad4a935a24e..7f19c3216370 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -616,6 +616,9 @@ static __always_inline unsigned int bpf_dispatcher_no=
p_func(
>  struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
>  int bpf_trampoline_link_prog(struct bpf_prog *prog);
>  int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
> +int bpf_trampoline_get(u64 key, void *addr,
> +                      struct btf_func_model *fmodel,
> +                      struct bpf_trampoline **trampoline);

Given trampoline is clearly a single output parameter, having `struct
bpf_trampoline *` as a return type and encoding error with ERR_PTR()
seems like a more common and natural way (within kernel code)?

Though I do get why you did it this way and with my below suggestion
of having separate switch clauses this reduces duplicated code, so I
guess I don't mind it now.


>  void bpf_trampoline_put(struct bpf_trampoline *tr);
>  #define BPF_DISPATCHER_INIT(_name) {                           \
>         .mutex =3D __MUTEX_INITIALIZER(_name.mutex),              \
> @@ -672,6 +675,12 @@ static inline int bpf_trampoline_unlink_prog(struct =
bpf_prog *prog)
>  {
>         return -ENOTSUPP;
>  }
> +static inline int bpf_trampoline_get(u64 key, void *addr,
> +                                    struct btf_func_model *fmodel,
> +                                    struct bpf_trampoline **trampoline)
> +{
> +       return -EOPNOTSUPP;
> +}
>  static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
>  #define DEFINE_BPF_DISPATCHER(name)
>  #define DECLARE_BPF_DISPATCHER(name)
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 20009e766805..db3db0b69aad 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -447,4 +447,13 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_en=
v *env, u32 off, u32 cnt);
>  int check_ctx_reg(struct bpf_verifier_env *env,
>                   const struct bpf_reg_state *reg, int regno);
>
> +int bpf_check_attach_target(struct bpf_verifier_log *log,
> +                           const struct bpf_prog *prog,
> +                           const struct bpf_prog *tgt_prog,
> +                           u32 btf_id,
> +                           struct btf_func_model *fmodel,
> +                           long *tgt_addr,
> +                           const char **tgt_name,
> +                           const struct btf_type **tgt_type);
> +
>  #endif /* _LINUX_BPF_VERIFIER_H */
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 7dd523a7e32d..cb442c7ece10 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -336,6 +336,28 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog=
)
>         return err;
>  }
>
> +int bpf_trampoline_get(u64 key, void *addr,
> +                      struct btf_func_model *fmodel,
> +                      struct bpf_trampoline **trampoline)
> +{
> +       struct bpf_trampoline *tr;
> +
> +       tr =3D bpf_trampoline_lookup(key);
> +       if (!tr)
> +               return -ENOMEM;
> +
> +       mutex_lock(&tr->mutex);
> +       if (tr->func.addr)
> +               goto out;
> +
> +       memcpy(&tr->func.model, fmodel, sizeof(*fmodel));
> +       tr->func.addr =3D addr;
> +out:
> +       mutex_unlock(&tr->mutex);
> +       *trampoline =3D tr;
> +       return 0;
> +}
> +
>  void bpf_trampoline_put(struct bpf_trampoline *tr)
>  {
>         if (!tr)
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 0be7a187fb7f..f2624784b915 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -11038,43 +11038,29 @@ static int check_non_sleepable_error_inject(u32=
 btf_id)
>         return btf_id_set_contains(&btf_non_sleepable_error_inject, btf_i=
d);
>  }
>
> -static int check_attach_btf_id(struct bpf_verifier_env *env)
> +int bpf_check_attach_target(struct bpf_verifier_log *log,
> +                           const struct bpf_prog *prog,
> +                           const struct bpf_prog *tgt_prog,
> +                           u32 btf_id,
> +                           struct btf_func_model *fmodel,
> +                           long *tgt_addr,
> +                           const char **tgt_name,
> +                           const struct btf_type **tgt_type)
>  {
> -       struct bpf_prog *prog =3D env->prog;
>         bool prog_extension =3D prog->type =3D=3D BPF_PROG_TYPE_EXT;
> -       struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
> -       struct bpf_verifier_log *log =3D &env->log;
> -       u32 btf_id =3D prog->aux->attach_btf_id;
>         const char prefix[] =3D "btf_trace_";
> -       struct btf_func_model fmodel;
>         int ret =3D 0, subprog =3D -1, i;
> -       struct bpf_trampoline *tr;
>         const struct btf_type *t;
>         bool conservative =3D true;
>         const char *tname;
>         struct btf *btf;
> -       long addr;
> -       u64 key;
> -
> -       if (prog->aux->sleepable && prog->type !=3D BPF_PROG_TYPE_TRACING=
 &&
> -           prog->type !=3D BPF_PROG_TYPE_LSM) {
> -               verbose(env, "Only fentry/fexit/fmod_ret and lsm programs=
 can be sleepable\n");
> -               return -EINVAL;
> -       }
> -
> -       if (prog->type =3D=3D BPF_PROG_TYPE_STRUCT_OPS)
> -               return check_struct_ops_btf_id(env);
> -
> -       if (prog->type !=3D BPF_PROG_TYPE_TRACING &&
> -           prog->type !=3D BPF_PROG_TYPE_LSM &&
> -           !prog_extension)
> -               return 0;
> +       long addr =3D 0;
>
>         if (!btf_id) {
>                 bpf_log(log, "Tracing programs must provide btf_id\n");
>                 return -EINVAL;
>         }
> -       btf =3D bpf_prog_get_target_btf(prog);
> +       btf =3D tgt_prog ? tgt_prog->aux->btf : btf_vmlinux;
>         if (!btf) {
>                 bpf_log(log,
>                         "FENTRY/FEXIT program can only be attached to ano=
ther program annotated with BTF\n");
> @@ -11114,8 +11100,6 @@ static int check_attach_btf_id(struct bpf_verifie=
r_env *env)
>                                         "Extension programs should be JIT=
ed\n");
>                                 return -EINVAL;
>                         }
> -                       env->ops =3D bpf_verifier_ops[tgt_prog->type];
> -                       prog->expected_attach_type =3D tgt_prog->expected=
_attach_type;
>                 }
>                 if (!tgt_prog->jited) {
>                         bpf_log(log, "Can attach to only JITed progs\n");
> @@ -11151,13 +11135,11 @@ static int check_attach_btf_id(struct bpf_verif=
ier_env *env)
>                         bpf_log(log, "Cannot extend fentry/fexit\n");
>                         return -EINVAL;
>                 }
> -               key =3D ((u64)aux->id) << 32 | btf_id;
>         } else {
>                 if (prog_extension) {
>                         bpf_log(log, "Cannot replace kernel functions\n")=
;
>                         return -EINVAL;
>                 }
> -               key =3D btf_id;
>         }
>
>         switch (prog->expected_attach_type) {
> @@ -11187,13 +11169,7 @@ static int check_attach_btf_id(struct bpf_verifi=
er_env *env)
>                         /* should never happen in valid vmlinux build */
>                         return -EINVAL;
>
> -               /* remember two read only pointers that are valid for
> -                * the life time of the kernel
> -                */
> -               prog->aux->attach_func_name =3D tname;
> -               prog->aux->attach_func_proto =3D t;
> -               prog->aux->attach_btf_trace =3D true;
> -               return 0;
> +               break;
>         case BPF_TRACE_ITER:
>                 if (!btf_type_is_func(t)) {
>                         bpf_log(log, "attach_btf_id %u is not a function\=
n",
> @@ -11203,12 +11179,10 @@ static int check_attach_btf_id(struct bpf_verif=
ier_env *env)
>                 t =3D btf_type_by_id(btf, t->type);
>                 if (!btf_type_is_func_proto(t))
>                         return -EINVAL;
> -               prog->aux->attach_func_name =3D tname;
> -               prog->aux->attach_func_proto =3D t;
> -               if (!bpf_iter_prog_supported(prog))
> -                       return -EINVAL;
> -               ret =3D btf_distill_func_proto(log, btf, t, tname, &fmode=
l);
> -               return ret;
> +               ret =3D btf_distill_func_proto(log, btf, t, tname, fmodel=
);
> +               if (ret)
> +                       return ret;
> +               break;
>         default:
>                 if (!prog_extension)
>                         return -EINVAL;
> @@ -11217,13 +11191,6 @@ static int check_attach_btf_id(struct bpf_verifi=
er_env *env)
>         case BPF_LSM_MAC:
>         case BPF_TRACE_FENTRY:
>         case BPF_TRACE_FEXIT:
> -               prog->aux->attach_func_name =3D tname;
> -               if (prog->type =3D=3D BPF_PROG_TYPE_LSM) {
> -                       ret =3D bpf_lsm_verify_prog(log, prog);
> -                       if (ret < 0)
> -                               return ret;
> -               }
> -
>                 if (!btf_type_is_func(t)) {
>                         bpf_log(log, "attach_btf_id %u is not a function\=
n",
>                                 btf_id);
> @@ -11235,24 +11202,14 @@ static int check_attach_btf_id(struct bpf_verif=
ier_env *env)
>                 t =3D btf_type_by_id(btf, t->type);
>                 if (!btf_type_is_func_proto(t))
>                         return -EINVAL;
> -               tr =3D bpf_trampoline_lookup(key);
> -               if (!tr)
> -                       return -ENOMEM;
> -               /* t is either vmlinux type or another program's type */
> -               prog->aux->attach_func_proto =3D t;
> -               mutex_lock(&tr->mutex);
> -               if (tr->func.addr) {
> -                       prog->aux->trampoline =3D tr;
> -                       goto out;
> -               }
> -               if (tgt_prog && conservative) {
> -                       prog->aux->attach_func_proto =3D NULL;
> +
> +               if (tgt_prog && conservative)
>                         t =3D NULL;
> -               }
> -               ret =3D btf_distill_func_proto(log, btf, t,
> -                                            tname, &tr->func.model);
> +
> +               ret =3D btf_distill_func_proto(log, btf, t, tname, fmodel=
);
>                 if (ret < 0)
> -                       goto out;
> +                       return ret;
> +
>                 if (tgt_prog) {
>                         if (subprog =3D=3D 0)
>                                 addr =3D (long) tgt_prog->bpf_func;
> @@ -11264,50 +11221,120 @@ static int check_attach_btf_id(struct bpf_veri=
fier_env *env)
>                                 bpf_log(log,
>                                         "The address of function %s canno=
t be found\n",
>                                         tname);
> -                               ret =3D -ENOENT;
> -                               goto out;
> +                               return -ENOENT;
>                         }
>                 }
> +               break;
> +       }
>
> -               if (prog->aux->sleepable) {
> -                       ret =3D -EINVAL;
> -                       switch (prog->type) {
> -                       case BPF_PROG_TYPE_TRACING:
> -                               /* fentry/fexit/fmod_ret progs can be sle=
epable only if they are
> -                                * attached to ALLOW_ERROR_INJECTION and =
are not in denylist.
> -                                */
> -                               if (!check_non_sleepable_error_inject(btf=
_id) &&
> -                                   within_error_injection_list(addr))
> -                                       ret =3D 0;
> -                               break;
> -                       case BPF_PROG_TYPE_LSM:
> -                               /* LSM progs check that they are attached=
 to bpf_lsm_*() funcs.
> -                                * Only some of them are sleepable.
> -                                */
> -                               if (check_sleepable_lsm_hook(btf_id))
> -                                       ret =3D 0;
> -                               break;
> -                       default:
> -                               break;
> -                       }
> -                       if (ret)
> -                               bpf_log(log, "%s is not sleepable\n",
> -                                       prog->aux->attach_func_name);
> -               } else if (prog->expected_attach_type =3D=3D BPF_MODIFY_R=
ETURN) {
> -                       ret =3D check_attach_modify_return(prog, addr);
> -                       if (ret)
> -                               bpf_log(log, "%s() is not modifiable\n",
> -                                       prog->aux->attach_func_name);
> +       if (prog->aux->sleepable) {
> +               ret =3D -EINVAL;
> +               switch (prog->type) {
> +               case BPF_PROG_TYPE_TRACING:
> +                       /* fentry/fexit/fmod_ret progs can be sleepable o=
nly if they are
> +                        * attached to ALLOW_ERROR_INJECTION and are not =
in denylist.
> +                        */
> +                       if (!check_non_sleepable_error_inject(btf_id) &&
> +                           within_error_injection_list(addr))
> +                               ret =3D 0;
> +                       break;
> +               case BPF_PROG_TYPE_LSM:
> +                       /* LSM progs check that they are attached to bpf_=
lsm_*() funcs.
> +                        * Only some of them are sleepable.
> +                        */
> +                       if (check_sleepable_lsm_hook(btf_id))
> +                               ret =3D 0;
> +                       break;
> +               default:
> +                       break;
>                 }
> -               if (ret)
> -                       goto out;
> -               tr->func.addr =3D (void *)addr;
> -               prog->aux->trampoline =3D tr;
> -out:
> -               mutex_unlock(&tr->mutex);
> -               if (ret)
> -                       bpf_trampoline_put(tr);
> +               if (ret) {
> +                       bpf_log(log, "%s is not sleepable\n",
> +                               prog->aux->attach_func_name);
> +                       return ret;

the flow would be simpler if you just bpf_log(log, "%s is not
sleepable\n", prog->aux->attach_func_name); and return error here,
same for second case below. I don't think saving single bpf_log
repetition deserves this complication.

> +               }
> +       }
> +
> +       *tgt_addr =3D addr;
> +       if (tgt_name)
> +               *tgt_name =3D tname;
> +       if (tgt_type)
> +               *tgt_type =3D t;
> +       return 0;
> +}
> +
> +static int check_attach_btf_id(struct bpf_verifier_env *env)
> +{
> +       struct bpf_prog *prog =3D env->prog;
> +       struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
> +       u32 btf_id =3D prog->aux->attach_btf_id;
> +       struct btf_func_model fmodel;
> +       const struct btf_type *t;
> +       const char *tname;
> +       long addr;
> +       int ret;
> +       u64 key;
> +
> +       if (prog->aux->sleepable && prog->type !=3D BPF_PROG_TYPE_TRACING=
 &&
> +           prog->type !=3D BPF_PROG_TYPE_LSM) {
> +               verbose(env, "Only fentry/fexit/fmod_ret and lsm programs=
 can be sleepable\n");
> +               return -EINVAL;
> +       }
> +
> +       if (prog->type =3D=3D BPF_PROG_TYPE_STRUCT_OPS)
> +               return check_struct_ops_btf_id(env);
> +
> +       if (prog->type !=3D BPF_PROG_TYPE_TRACING &&
> +           prog->type !=3D BPF_PROG_TYPE_LSM &&
> +           prog->type !=3D BPF_PROG_TYPE_EXT)
> +               return 0;
> +
> +       ret =3D bpf_check_attach_target(&env->log, prog, tgt_prog, btf_id=
,
> +                                     &fmodel, &addr, &tname, &t);
> +       if (ret)
>                 return ret;
> +
> +       if (tgt_prog) {
> +               if (prog->type =3D=3D BPF_PROG_TYPE_EXT) {
> +                       env->ops =3D bpf_verifier_ops[tgt_prog->type];
> +                       prog->expected_attach_type =3D
> +                               tgt_prog->expected_attach_type;
> +               }
> +               key =3D ((u64)tgt_prog->aux->id) << 32 | btf_id;
> +       } else {
> +               key =3D btf_id;
> +       }
> +
> +       prog->aux->attach_func_proto =3D t;
> +       prog->aux->attach_func_name =3D tname;
> +
> +       switch (prog->expected_attach_type) {
> +       case BPF_TRACE_RAW_TP:
> +               /* remember two read only pointers that are valid for
> +                * the life time of the kernel
> +                */

comment is misplaced now, it was referring to
prog->aux->attach_func_proto and prog->aux->attach_func_name

> +               prog->aux->attach_btf_trace =3D true;
> +               return 0;
> +       case BPF_TRACE_ITER:
> +               if (!bpf_iter_prog_supported(prog))
> +                       return -EINVAL;
> +               return 0;
> +       case BPF_MODIFY_RETURN:
> +               ret =3D check_attach_modify_return(prog, addr);
> +               if (ret) {
> +                       verbose(env, "%s() is not modifiable\n",
> +                               prog->aux->attach_func_name);
> +                       return ret;
> +               }
> +               fallthrough;

this fallthrough is only to do bpf_trampoline_get in the end, is that
right? Why not just call bpf_trampoline_get() here? That's not a lot
of duplication at all, but will be easier to follow and make sure
everything is right.

> +       default:
> +               if (prog->type =3D=3D BPF_PROG_TYPE_LSM) {
> +                       ret =3D bpf_lsm_verify_prog(&env->log, prog);
> +                       if (ret < 0)
> +                               return ret;
> +               }

Same here, BPF_PROG_TYPE_LSM (and we can use BPF_LSM_MAC expected
attach type, right?) is clearly a separate case, deserving its own
case?

As for the default one, let's keep it for _EXT case (and enforce it as
original code did). For BPF_TRACE_FEXIT and BPF_TRACE_FENTRY, let's
have a separate case as well.

These switches with default clauses and fallthroughs... they are mind
bending, it's really hard and time consuming to ensure one has
considered all possible code paths leading to this default case. It's
all already quite complicated, let's not add to the complexity.


> +               return bpf_trampoline_get(key, (void *)addr, &fmodel,
> +                                         &prog->aux->trampoline);
>         }
>  }
>
>
