Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB3C2669EA
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgIKVKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgIKVKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:10:47 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEBAC061573;
        Fri, 11 Sep 2020 14:10:46 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id k2so4685280ybp.7;
        Fri, 11 Sep 2020 14:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k5rjWV6HvYNYHwcNkv9uMIpWdeJiBCLGd/zmFGGqpsM=;
        b=LJFUi5oObUiwqw4hoe/oMvqHKwopDHqh9IBqYAf7URO6mwpmIU0hG7AqL52zbhrzYu
         R1rtTzj2+WHJA7dCfJJtOg8j3A+01GqHXK8Nm2eZwvIxcdLPJXrwJBwl3c3eFh38BBQY
         ElcCVBrc3oOqcKxHDH/kclAorfEHQyyQqo+0XW9VlhHapnIThipFsAvi+ICWjyCQ3zUn
         Rak99rj7bUaw2fjKUpq06zoDVTJL3BTxhjXfuxZ1/zkaXWy7ORmAZQ62vGdFKIJElBVI
         wr5//xRuGEwQJ/L65PNv0HSU66mheda+7+S+GVmFgP7HBtd+tVFEBSrCCySRiorrQAMT
         LzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k5rjWV6HvYNYHwcNkv9uMIpWdeJiBCLGd/zmFGGqpsM=;
        b=bfzSGLGKOI1Q8BWvcsAgI0ewadpDxhMkB9HQ8dHZaSEqorgfZtlSV6LDQ11SoS90QP
         blesHkC3UvSfXgNXw4oBM+NNNWUg3kfyMpTBA/5PloRQTpyPWMbCQcNfPBZS/QyBbhWd
         bp1MYU+UsaMCswtCXb5pNHR9JZNdKlZh2Z4O2OgKUCxFU/Bxw6Zd2akrvZlID4gpVVqy
         cfTN/W4AC9vigNKr04AzXn7ZTvN6+iJ8swSHT//IDsAT7vr6HTRtOZZ1T5ZxDhAcEz6w
         EbeG4ClvLdK3/bN2qW77l0AuSwkxjtfA3s8iP1sIk4iDJ8aV2AKW39gSXd891m4pABGw
         tCiQ==
X-Gm-Message-State: AOAM531aoGBRMqSSsDO7YR9O2AMmV2JZfArSaEgOLnEdxVhhTEl4Te2m
        jq9InRcygXcKGpbrlb1BvP9/9uPPFbBTyWJ8GT2yZmu1
X-Google-Smtp-Source: ABdhPJyEuvEeD33jphMP/bLyVD/Up3S8HX4XiFNXICAcbU79uDRawZwFwwZtP3eVyMvJf4v8rDVXY2PjdI/6o62d1Lo=
X-Received: by 2002:a25:6885:: with SMTP id d127mr4885289ybc.27.1599858645559;
 Fri, 11 Sep 2020 14:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <159981835466.134722.8652987144251743467.stgit@toke.dk> <159981835908.134722.4550898174324943652.stgit@toke.dk>
In-Reply-To: <159981835908.134722.4550898174324943652.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Sep 2020 14:10:34 -0700
Message-ID: <CAEf4BzZMj0sPisgUZ+3qKvqaAxfzzRNHZTpoR-zuDXvKcY3URQ@mail.gmail.com>
Subject: Re: [PATCH RESEND bpf-next v3 4/9] bpf: support attaching freplace
 programs to multiple attach points
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

On Fri, Sep 11, 2020 at 3:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This enables support for attaching freplace programs to multiple attach
> points. It does this by amending UAPI for bpf_raw_tracepoint_open with a
> target prog fd and btf ID pair that can be used to supply the new
> attachment point. The target must be compatible with the target that was
> supplied at program load time.
>
> The implementation reuses the checks that were factored out of
> check_attach_btf_id() to ensure compatibility between the BTF types of th=
e
> old and new attachment. If these match, a new bpf_tracing_link will be
> created for the new attach target, allowing multiple attachments to
> co-exist simultaneously.
>
> The code could theoretically support multiple-attach of other types of
> tracing programs as well, but since I don't have a use case for any of
> those, the bpf_tracing_prog_attach() function will reject new targets for
> anything other than PROG_TYPE_EXT programs.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

It feels like using a semi-constructed bpf_tracing_link inside
prog->aux->tgt_link is just an unnecessary complication, after reading
this and previous patches. Seems more straightforward and simpler to
store tgt_attach_type/tgt_prog_type (permanently) and
tgt_prog/tgt_trampoline (until first attachment) in prog->aux and then
properly create bpf_link on attach.

>  include/linux/bpf.h      |    3 +
>  include/uapi/linux/bpf.h |    6 ++-
>  kernel/bpf/syscall.c     |   96 +++++++++++++++++++++++++++++++++++++++-=
------
>  kernel/bpf/verifier.c    |    9 ++++
>  4 files changed, 97 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 722c60f1c1fc..c6b856b2d296 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -753,6 +753,9 @@ struct bpf_prog_aux {
>         struct hlist_node tramp_hlist;
>         /* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
>         const struct btf_type *attach_func_proto;
> +       /* target BPF prog types for trace programs */
> +       enum bpf_prog_type tgt_prog_type;
> +       enum bpf_attach_type tgt_attach_type;
>         /* function name for valid attach_btf_id */
>         const char *attach_func_name;
>         struct bpf_prog **func;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 90359cab501d..0885ab6ac8d9 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -595,8 +595,10 @@ union bpf_attr {
>         } query;
>
>         struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN comm=
and */
> -               __u64 name;
> -               __u32 prog_fd;
> +               __u64           name;
> +               __u32           prog_fd;
> +               __u32           tgt_prog_fd;
> +               __u32           tgt_btf_id;
>         } raw_tracepoint;

rant: any chance of putting this into LINK_CREATE instead of extending
very unfortunately named RAW_TRACEPOINT_OPEN?

>
>         struct { /* anonymous struct for BPF_BTF_LOAD */
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 2d238aa8962e..7b1da5f063eb 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -4,6 +4,7 @@
>  #include <linux/bpf.h>
>  #include <linux/bpf_trace.h>
>  #include <linux/bpf_lirc.h>
> +#include <linux/bpf_verifier.h>
>  #include <linux/btf.h>
>  #include <linux/syscalls.h>
>  #include <linux/slab.h>
> @@ -2582,10 +2583,16 @@ static struct bpf_tracing_link *bpf_tracing_link_=
create(struct bpf_prog *prog,
>         return link;
>  }
>
> -static int bpf_tracing_prog_attach(struct bpf_prog *prog)
> +static int bpf_tracing_prog_attach(struct bpf_prog *prog,
> +                                  int tgt_prog_fd,
> +                                  u32 btf_id)
>  {
> -       struct bpf_tracing_link *link, *olink;
>         struct bpf_link_primer link_primer;
> +       struct bpf_prog *tgt_prog =3D NULL;
> +       struct bpf_tracing_link *link;
> +       struct btf_func_model fmodel;
> +       long addr;
> +       u64 key;
>         int err;
>
>         switch (prog->type) {
> @@ -2613,28 +2620,80 @@ static int bpf_tracing_prog_attach(struct bpf_pro=
g *prog)
>                 err =3D -EINVAL;
>                 goto out_put_prog;
>         }
> +       if (tgt_prog_fd) {
> +               /* For now we only allow new targets for BPF_PROG_TYPE_EX=
T */
> +               if (prog->type !=3D BPF_PROG_TYPE_EXT ||
> +                   !btf_id) {
> +                       err =3D -EINVAL;
> +                       goto out_put_prog;
> +               }
>
> -       link =3D READ_ONCE(prog->aux->tgt_link);
> -       if (!link) {
> -               err =3D -ENOENT;
> +               tgt_prog =3D bpf_prog_get(tgt_prog_fd);
> +               if (IS_ERR(tgt_prog)) {
> +                       err =3D PTR_ERR(tgt_prog);
> +                       tgt_prog =3D NULL;
> +                       goto out_put_prog;
> +               }
> +
> +               key =3D ((u64)tgt_prog->aux->id) << 32 | btf_id;
> +       } else if (btf_id) {
> +               err =3D -EINVAL;
>                 goto out_put_prog;
>         }
> -       olink =3D cmpxchg(&prog->aux->tgt_link, link, NULL);
> -       if (olink !=3D link) {
> -               err =3D -ENOENT;
> -               goto out_put_prog;
> +
> +       link =3D READ_ONCE(prog->aux->tgt_link);
> +       if (link) {
> +               if (tgt_prog && link->trampoline->key !=3D key) {

I think we need to have a proper locking about this. Imagine two
attaches racing, both read non-NULL tgt_link, one of them proceeds to
cmpxchg, attach, detach, and free link. Then this one wakes up and
tries to access freed memory here. We are coordinating multiple
threads on this, it needs to be locked, at least for simplicity, given
that performance is not critical here.

> +                       link =3D NULL;
> +               } else {
> +                       struct bpf_tracing_link *olink;
> +
> +                       olink =3D cmpxchg(&prog->aux->tgt_link, link, NUL=
L);
> +                       if (olink !=3D link) {
> +                               link =3D NULL;
> +                       } else if (tgt_prog) {
> +                               /* re-using link that already has ref on
> +                                * tgt_prog, don't take another
> +                                */
> +                               bpf_prog_put(tgt_prog);
> +                               tgt_prog =3D NULL;
> +                       }
> +               }
> +       }
> +
> +       if (!link) {
> +               if (!tgt_prog) {
> +                       err =3D -ENOENT;
> +                       goto out_put_prog;
> +               }
> +
> +               err =3D bpf_check_attach_target(NULL, prog, tgt_prog, btf=
_id,
> +                                             &fmodel, &addr, NULL, NULL)=
;
> +               if (err)
> +                       goto out_put_prog;
> +
> +               link =3D bpf_tracing_link_create(prog, tgt_prog);
> +               if (IS_ERR(link)) {
> +                       err =3D PTR_ERR(link);
> +                       goto out_put_prog;
> +               }
> +               tgt_prog =3D NULL;
> +
> +               err =3D bpf_trampoline_get(key, (void *)addr, &fmodel, &l=
ink->trampoline);
> +               if (err)
> +                       goto out_put_link;

see previous patch, let's avoid bpf_link_put before bpf_link_settle.
bpf_link_cleanup() is for after priming, otherwise it's just a kfree.

>         }
>
>         err =3D bpf_link_prime(&link->link, &link_primer);
>         if (err) {
>                 kfree(link);
> -               goto out_put_prog;
> +               goto out_put_link;

hm... did you try running this with KASAN? you are freeing link and
then bpf_link_put() on it?


>         }
>
>         err =3D bpf_trampoline_link_prog(prog, link->trampoline);
>         if (err) {
>                 bpf_link_cleanup(&link_primer);
> -               goto out_put_prog;
> +               goto out_put_link;

similarly, you've already bpf_link_cleanup()'d, no need to do extra
bpf_link_put()

>         }
>
>         /* at this point the link is no longer referenced from struct bpf=
_prog,
> @@ -2643,8 +2702,12 @@ static int bpf_tracing_prog_attach(struct bpf_prog=
 *prog)
>         link->link.prog =3D prog;
>
>         return bpf_link_settle(&link_primer);
> +out_put_link:
> +       bpf_link_put(&link->link);
>  out_put_prog:
>         bpf_prog_put(prog);
> +       if (tgt_prog)
> +               bpf_prog_put(tgt_prog);
>         return err;
>  }
>

[...]
