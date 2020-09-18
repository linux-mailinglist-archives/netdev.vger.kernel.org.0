Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3C3270456
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIRSsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIRSsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:48:08 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F4FC0613CE;
        Fri, 18 Sep 2020 11:48:07 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id g96so4996162ybi.12;
        Fri, 18 Sep 2020 11:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aL4qiLX9CqGPu2f/gkVI4yzwWAK533VSlQldDF/hfI0=;
        b=WyHKvItu3KyhBfynh+IDUrZFZiWRRjgoUhioi2/YcKu9RIE8tA3zSkruJW/r9ZjS8d
         WAywn8Y9WNcOvAWdlOx5Uu6kZJB1zpJ60imxdVumKUWQsO6T5HJfpD7dl6iPCWr7mpvh
         Kx9SoQ/XZL6T5VumV/hb0zTQS7V7SSIK5LLCyZ1NvKes9YYg7y+2ZpMCvanop57Du2Oq
         U20W/xhCkMZXCMCTrGGkCL3WWitvdn7DU53lISR30a6g5OVcksDvUFEWl+r3sQJN2s4v
         WAnyj060QmH8WJ2p8xFEmQW62wZx/srsuyEpoQGMGmvvC3ZsWURdReLOgh+c6WXnKbQE
         w1Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aL4qiLX9CqGPu2f/gkVI4yzwWAK533VSlQldDF/hfI0=;
        b=AbLY9k41nELQor+ufMIvb+LBSaRmuPqDMkW1jaiKwK3IEwsijioIXFVw1I6+G7JzQo
         2hBOChyCP31RBPy4X0hz1wsi9fyFDcfRk39BPWzys40Nf+buSvTmfvFRqRU+OEnfPTwY
         3nFHRnbpxr1Qbppkpba2ddDFAsSeZPwfnufYJJt3tqfo79gibCHnMJ5qrqoY5+bYP8FS
         sgTWCsDUIo403kkindFtTm2LuGj6MockKH6uEkCnPNw31P9jBt+V7/fH1nLt+DlaRnlO
         hCkl0yrXxY+Q6uI3/eh5hBWyOoiQWU8RppN8mDGP1MXyVa5LfQf8/IhoV5GBjgaUpZ50
         S5lw==
X-Gm-Message-State: AOAM5331eGtw2mGYtciJ4/7wOsDWxTWF4HY6V/58N5NpJXATVN+49QOT
        dlk0SgrS0wlBf/SpdEQ396y00inn1Mpj/aDxrj0=
X-Google-Smtp-Source: ABdhPJyt/9ub2OkdVUkUmgMP0wn+zwQPmn7G9t1VuOl/FgaBZ7BSxTRyywS5UoRHLJo2h5Kewc8HYJKCfwBLRqADBKw=
X-Received: by 2002:a25:d70e:: with SMTP id o14mr41084875ybg.425.1600454887101;
 Fri, 18 Sep 2020 11:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <160037400056.28970.7647821897296177963.stgit@toke.dk> <160037400605.28970.12030576233071570541.stgit@toke.dk>
In-Reply-To: <160037400605.28970.12030576233071570541.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Sep 2020 11:47:56 -0700
Message-ID: <CAEf4BzajBMf9btVJLfOYNdEbBHgs1m5o=D5mDcmTV4gPYTf9-w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 05/10] bpf: support attaching freplace
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 1:21 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This enables support for attaching freplace programs to multiple attach
> points. It does this by amending the UAPI for bpf_link_Create with a targ=
et
> btf ID that can be used to supply the new attachment point along with the
> target program fd. The target must be compatible with the target that was
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
> those, there is no API support for doing so.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

You patch set breaks at least bpf_iter tests:

$ sudo ./test_progs -t bpf_iter
...
#4 bpf_iter:FAIL
Summary: 0/19 PASSED, 0 SKIPPED, 6 FAILED

Please check and fix.

>  include/linux/bpf.h            |    2 +
>  include/uapi/linux/bpf.h       |    9 +++-
>  kernel/bpf/syscall.c           |  101 ++++++++++++++++++++++++++++++++++=
------
>  kernel/bpf/verifier.c          |    9 ++++
>  tools/include/uapi/linux/bpf.h |    9 +++-
>  5 files changed, 110 insertions(+), 20 deletions(-)
>

[...]

> -static int bpf_tracing_prog_attach(struct bpf_prog *prog)
> +static int bpf_tracing_prog_attach(struct bpf_prog *prog,
> +                                  int tgt_prog_fd,
> +                                  u32 btf_id)
>  {
>         struct bpf_link_primer link_primer;
>         struct bpf_prog *tgt_prog =3D NULL;
> +       struct bpf_trampoline *tr =3D NULL;
>         struct bpf_tracing_link *link;
> -       struct bpf_trampoline *tr;
> +       struct btf_func_model fmodel;
> +       u64 key =3D 0;
> +       long addr;
>         int err;
>
>         switch (prog->type) {
> @@ -2589,6 +2595,28 @@ static int bpf_tracing_prog_attach(struct bpf_prog=
 *prog)

bpf_tracing_prog_attach logic looks correct to me now, thanks.

>                 goto out_put_prog;
>         }
>

[...]

> @@ -3934,6 +3986,16 @@ static int tracing_bpf_link_attach(const union bpf=
_attr *attr, struct bpf_prog *
>         return -EINVAL;
>  }
>
> +static int freplace_bpf_link_attach(const union bpf_attr *attr, struct b=
pf_prog *prog)

Any reason to have this separate from tracing_bpf_link_attach? I'd
merge them and do a simple switch inside, based on prog->type. It
would also be easier to follow the flow if this expected_attach_type
check was first and returned -EINVAL immediately at the top.


> +{
> +       if (attr->link_create.attach_type =3D=3D prog->expected_attach_ty=
pe)
> +               return bpf_tracing_prog_attach(prog,
> +                                              attr->link_create.target_f=
d,
> +                                              attr->link_create.target_b=
tf_id);
> +       return -EINVAL;
> +

nit: unnecessary empty line?

> +}
> +
>  #define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
>  static int link_create(union bpf_attr *attr)
>  {
> @@ -3944,18 +4006,25 @@ static int link_create(union bpf_attr *attr)
>         if (CHECK_ATTR(BPF_LINK_CREATE))
>                 return -EINVAL;
>
> -       ptype =3D attach_type_to_prog_type(attr->link_create.attach_type)=
;
> -       if (ptype =3D=3D BPF_PROG_TYPE_UNSPEC)
> -               return -EINVAL;
> -
> -       prog =3D bpf_prog_get_type(attr->link_create.prog_fd, ptype);
> +       prog =3D bpf_prog_get(attr->link_create.prog_fd);
>         if (IS_ERR(prog))
>                 return PTR_ERR(prog);
>
>         ret =3D bpf_prog_attach_check_attach_type(prog,
>                                                 attr->link_create.attach_=
type);
>         if (ret)
> -               goto err_out;
> +               goto out;
> +
> +       if (prog->type =3D=3D BPF_PROG_TYPE_EXT) {
> +               ret =3D freplace_bpf_link_attach(attr, prog);
> +               goto out;
> +       }
> +
> +       ptype =3D attach_type_to_prog_type(attr->link_create.attach_type)=
;
> +       if (ptype =3D=3D BPF_PROG_TYPE_UNSPEC) {
> +               ret =3D -EINVAL;
> +               goto out;
> +       }

you seem to be missing a check that prog->type matches ptype,
previously implicitly performed by bpf_prog_get_type(), no?

>
>         switch (ptype) {
>         case BPF_PROG_TYPE_CGROUP_SKB:
> @@ -3983,7 +4052,7 @@ static int link_create(union bpf_attr *attr)
>                 ret =3D -EINVAL;
>         }
>
> -err_out:
> +out:
>         if (ret < 0)
>                 bpf_prog_put(prog);
>         return ret;

[...]
