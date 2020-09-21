Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D5B273630
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgIUXGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgIUXGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:06:10 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B42C061755;
        Mon, 21 Sep 2020 16:06:10 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x20so11493039ybs.8;
        Mon, 21 Sep 2020 16:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LAPYqaY3KmF1vFlyO8GIHcNQqp36VdvwJKF/ErXtbEc=;
        b=VXdnXFzj50KgBfz9k2ixRvL/sTq5Y/+8pQapZaTr5wJI7+UofmnoBESODrFytyDV54
         c4abiQGm3Fp2lJ6VO8IB3spGZ99LWl8+Cquxk24Afw3Ai1doPUm3/NygRYi5rQRpyOux
         1w2iu2iRHnHPweXUSL2zQmPLVtssJIq7SfejNYTw5gzUghdqh8JbGFJseW2qyGt4zA0M
         TDsAKON4++SUagkcbdLClcBX0jwkP/huiXxqesMoaglCERgS3CHU5I5eAEhtd1bHO99A
         qPGaYO/05/34wSgesqT33DdCcVuXqCnOplidD3Ddkzum+JAJdY98l6Ubt3l3BO1itU1f
         4dWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LAPYqaY3KmF1vFlyO8GIHcNQqp36VdvwJKF/ErXtbEc=;
        b=bMI4BtXOLtvhbc/bYX5raQqLM36ZmundT6qwimQpth3gWn+D27TTRtGNdQAFuIp7eB
         HqcK+d9+bgp6/cw65xxFdRk4wiC0+EVgEyTsvfUlhksdWdf+Za+SVZtg2UGG7DH/gp/E
         e29oMFEi18cWSR8WbA2gX3tmtsPDlcfIyKfGqLeDhctOfbHB6LTiHiiHCEXv5p17GqcC
         F4tjDdNWTeeoeJ0J9DzqtAwn/X+YKUw5y5YGfPHuL+P6upphKqmCC3lu4sWFp/6zbHMw
         v3bZ/t7CYxL/jG5Q38w9jefdlfyI3CLLQXn8v/g78yi2og/00z3IbUOEt30gxy0Hcafk
         8b1w==
X-Gm-Message-State: AOAM530yu11RafrFzPzQn6mNYaasYTcz6k8oBAI6wZRFW6ctZ5Ph7EOT
        7xDkEqmlHdefbL/Bc7ZbdCr2TM6lBnt4fJ7XU50=
X-Google-Smtp-Source: ABdhPJwnj0oLqo6zLUrfHGEWfIP7wOvWHee4aWTo/ilZjql1kUtlKJCtmurfs8emqUw2LMGLby6u6JyDGMsjUjFtZwo=
X-Received: by 2002:a25:2687:: with SMTP id m129mr3085989ybm.425.1600729569862;
 Mon, 21 Sep 2020 16:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <160051618267.58048.2336966160671014012.stgit@toke.dk> <160051618733.58048.1005452269573858636.stgit@toke.dk>
In-Reply-To: <160051618733.58048.1005452269573858636.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 16:05:59 -0700
Message-ID: <CAEf4BzYrc1j0i5qVKfyHA98C37D7xR6i4GL4BLeprNL=HfjCBg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 04/10] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
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

On Sat, Sep 19, 2020 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> In preparation for allowing multiple attachments of freplace programs, mo=
ve
> the references to the target program and trampoline into the
> bpf_tracing_link structure when that is created. To do this atomically,
> introduce a new mutex in prog->aux to protect writing to the two pointers
> to target prog and trampoline, and rename the members to make it clear th=
at
> they are related.
>
> With this change, it is no longer possible to attach the same tracing
> program multiple times (detaching in-between), since the reference from t=
he
> tracing program to the target disappears on the first attach. However,
> since the next patch will let the caller supply an attach target, that wi=
ll
> also make it possible to attach to the same place multiple times.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  include/linux/bpf.h     |   15 +++++++++-----
>  kernel/bpf/btf.c        |    6 +++---
>  kernel/bpf/core.c       |    9 ++++++---
>  kernel/bpf/syscall.c    |   49 +++++++++++++++++++++++++++++++++++++++--=
------
>  kernel/bpf/trampoline.c |   12 ++++--------
>  kernel/bpf/verifier.c   |    9 +++++----
>  6 files changed, 68 insertions(+), 32 deletions(-)
>

[...]

> @@ -741,7 +743,9 @@ struct bpf_prog_aux {
>         u32 max_rdonly_access;
>         u32 max_rdwr_access;
>         const struct bpf_ctx_arg_aux *ctx_arg_info;
> -       struct bpf_prog *linked_prog;
> +       struct mutex tgt_mutex; /* protects writing of tgt_* pointers bel=
ow */

nit: not just writing, "accessing" would be a better word

> +       struct bpf_prog *tgt_prog;
> +       struct bpf_trampoline *tgt_trampoline;
>         bool verifier_zext; /* Zero extensions has been inserted by verif=
ier. */
>         bool offload_requested;
>         bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp=
 */

[...]

>  static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
> @@ -11418,8 +11417,8 @@ int bpf_check_attach_target(struct bpf_verifier_l=
og *log,
>  static int check_attach_btf_id(struct bpf_verifier_env *env)
>  {
>         struct bpf_prog *prog =3D env->prog;
> -       struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
>         u32 btf_id =3D prog->aux->attach_btf_id;
> +       struct bpf_prog *tgt_prog =3D prog->aux->tgt_prog;
>         struct btf_func_model fmodel;
>         struct bpf_trampoline *tr;
>         const struct btf_type *t;
> @@ -11483,7 +11482,9 @@ static int check_attach_btf_id(struct bpf_verifie=
r_env *env)
>         if (!tr)
>                 return -ENOMEM;
>
> -       prog->aux->trampoline =3D tr;
> +       mutex_lock(&prog->aux->tgt_mutex);
> +       prog->aux->tgt_trampoline =3D tr;
> +       mutex_unlock(&prog->aux->tgt_mutex);

I think here you don't need to lock mutex, because
check_attach_btf_id() is called during verification before bpf_prog
itself is visible to user-space, so there is no way to have concurrent
access to it. If that wasn't the case, you'd need to take mutex lock
before you assign tgt_prog local variable from prog->aux->tgt_prog
above (and plus you'd need extra null checks and stuff).

>         return 0;
>  }
>
>
