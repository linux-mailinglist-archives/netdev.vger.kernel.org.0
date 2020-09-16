Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E207F26CABF
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgIPUNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgIPRcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:32:33 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5099CC06174A;
        Wed, 16 Sep 2020 10:32:21 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h206so5954628ybc.11;
        Wed, 16 Sep 2020 10:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w6OURtY58cG1HlzhA4lLp8sQ26KStQ/w85cU6aGuGCM=;
        b=N7+a5KUNLmopQPrT8KzEAS+6vOLgZ39vd4xgbzQR0GUVjNJctYDcaIB5F2NxAdegmZ
         xCC0aBbcR0oqLfnElCXNAfBI0LoEYlef1Bgk7Yrl1XUS9ECiya51FriNaMy0poxloBrb
         5vplGwUs4OBVqL9xgoBgkcpkeiY0DLGliVcBdpLQpFX6md6pkwuY9JVWPUoopsOnGynG
         IcaYmEtPHDRBoXOaXbib47GHXE6lrN4G18EBduVC1yok8D7btHLZDot3bz04NTXkg5QF
         CuVe/UTW21ZJpHc3A9DD9MgUvayxo4OGjhWZALkLkVt2Xd1mQefJsYAowo1+Kv8K73Pe
         s1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w6OURtY58cG1HlzhA4lLp8sQ26KStQ/w85cU6aGuGCM=;
        b=SS+J2Za1S4oDWiyArkz2VCedQlfr+avIITboLi5dpwZcGjEUuYADZtd61rXzGuRlVr
         1nZaMLl4XCt2NEhFpACtuaAHZLslf+/1ONLBSne6KoEgAQ454/tGHyaGAV8jjiw0TXW9
         pUJT2Y5U5XuV+Tm9nMz1PaBNz8ZuYndVVLlf3CNhNPTPFQtTPIvuNoj4ip/pwUhTOLKh
         LmdQuFDbbvZakoahb8D7odOAY52zJO2iBNF9dtrXkfPqMDSmv67ih6+oFqYWrtBE3Sub
         kImuYI+zqAcVL3u+b+kv3yWtzcggQKrHh7l3wDJgtyqmVYJw5OpTXvI6GIhNl8qGOaGo
         kAWw==
X-Gm-Message-State: AOAM53014UuXVj9ypBUYY+33m7C1y58ZkLzBLWOylGa5cn94BiWATScl
        2M5n3iuONx4rPdf5XM6gw4Xv9t6Sfn9HzOAQSps=
X-Google-Smtp-Source: ABdhPJw7GiGwZVIyLh9jkU22hNadf/VAocTHtA9PmMeKJNBZWJW9A5CDsr2GagzzeOk/x1+EewmarMkOHA0mvpY8ITQ=
X-Received: by 2002:a25:6644:: with SMTP id z4mr6039473ybm.347.1600277540438;
 Wed, 16 Sep 2020 10:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <160017005691.98230.13648200635390228683.stgit@toke.dk> <160017005916.98230.1736872862729846213.stgit@toke.dk>
In-Reply-To: <160017005916.98230.1736872862729846213.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Sep 2020 10:32:09 -0700
Message-ID: <CAEf4BzbAsnzAUPksUs+bcNuuUPkumc15RLESu3jOGf87mzabBA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 2/8] bpf: verifier: refactor check_attach_btf_id()
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

On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
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

I almost acked this, but found a problem at the very last moment. See
below, along with few more comments while I have enough context in my
head.

BTW, for whatever reason your patches arrived with a 12 hour delay
yesterday (cover letter received at 5am, while patches arrived at
6pm), don't know if its vger or gmail...

>  include/linux/bpf.h          |    7 +
>  include/linux/bpf_verifier.h |    9 ++
>  kernel/bpf/trampoline.c      |   20 ++++
>  kernel/bpf/verifier.c        |  197 ++++++++++++++++++++++++------------=
------
>  4 files changed, 149 insertions(+), 84 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5ad4a935a24e..dcf0c70348a4 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -616,6 +616,8 @@ static __always_inline unsigned int bpf_dispatcher_no=
p_func(
>  struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
>  int bpf_trampoline_link_prog(struct bpf_prog *prog);
>  int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
> +struct bpf_trampoline *bpf_trampoline_get(u64 key, void *addr,
> +                                         struct btf_func_model *fmodel);
>  void bpf_trampoline_put(struct bpf_trampoline *tr);
>  #define BPF_DISPATCHER_INIT(_name) {                           \
>         .mutex =3D __MUTEX_INITIALIZER(_name.mutex),              \
> @@ -672,6 +674,11 @@ static inline int bpf_trampoline_unlink_prog(struct =
bpf_prog *prog)
>  {
>         return -ENOTSUPP;
>  }
> +static inline struct bpf_trampoline *bpf_trampoline_get(u64 key, void *a=
ddr,
> +                                                       struct btf_func_m=
odel *fmodel)
> +{
> +       return ERR_PTR(-EOPNOTSUPP);
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

So this is obviously an abomination of a function signature,
especially for a one exported to other files.

One candidate to remove would be tgt_type, which is supposed to be a
derivative of target BTF (vmlinux or tgt_prog->btf) + btf_id,
**except** (and that's how I found the bug below), in case of
fentry/fexit programs attaching to "conservative" BPF functions, in
which case what's stored in aux->attach_func_proto is different from
what is passed into btf_distill_func_proto. So that's a bug already
(you'll return NULL in some cases for tgt_type, while it has to always
be non-NULL).

But related to that is fmodel. It seems like bpf_check_attach_target()
has no interest in fmodel itself and is just passing it from
btf_distill_func_proto(). So I was about to suggest dropping fmodel
and calling btf_distill_func_proto() outside of
bpf_check_attach_target(), but given the conservative + fentry/fexit
quirk, it's probably going to be more confusing.

So with all this, I suggest dropping the tgt_type output param
altogether and let callers do a `btf__type_by_id(tgt_prog ?
tgt_prog->aux->btf : btf_vmlinux, btf_id);`. That will both fix the
bug and will make this function's signature just a tad bit less
horrible.

> +
>  #endif /* _LINUX_BPF_VERIFIER_H */
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 7dd523a7e32d..7845913e7e41 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -336,6 +336,26 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog=
)
>         return err;
>  }
>
> +struct bpf_trampoline *bpf_trampoline_get(u64 key, void *addr,
> +                                         struct btf_func_model *fmodel)
> +{
> +       struct bpf_trampoline *tr;
> +
> +       tr =3D bpf_trampoline_lookup(key);
> +       if (!tr)
> +               return ERR_PTR(-ENOMEM);

So seems like the only way this function can fail is when
bpf_trampoline_lookup() returns NULL (and we assume -ENOMEM then), so
I guess we could have just returned NULL the same to keep
bpf_trampoline_lookup() and bpf_trampoline_get() similar. But it's
minor, if you prefer to encode error code anyways.

> +
> +       mutex_lock(&tr->mutex);
> +       if (tr->func.addr)
> +               goto out;
> +
> +       memcpy(&tr->func.model, fmodel, sizeof(*fmodel));
> +       tr->func.addr =3D addr;
> +out:
> +       mutex_unlock(&tr->mutex);
> +       return tr;
> +}
> +
>  void bpf_trampoline_put(struct bpf_trampoline *tr)
>  {
>         if (!tr)

[...]

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

this is where the bug happens, we can't return this NULL to caller as tgt_p=
rog

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

[...]
