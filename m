Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895D52746E6
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 18:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgIVQpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 12:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIVQpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 12:45:21 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B42C061755;
        Tue, 22 Sep 2020 09:45:21 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id c17so13353938ybe.0;
        Tue, 22 Sep 2020 09:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RM/BOw7YekqsGoM3jSe2TZNOM5wuxud8/JsIjtKO6mg=;
        b=DI9jCPfB+o6Qrlg/d5LFd2/OKjdW885uKeJO2OLdcWoyq5QDWbRmwNYsXBpsyoFR6n
         tuBA1CHLxrZ8i6UvrQHWQ//OZeEZ8aniH18gy9XANRb++6P+0CFAu1vO7lK4rk8Y2UFe
         sEXl6eLvFiLbiIgirNnnzsAdhppqDyLsz1FWPhiV8KQwK4ZE0jYE4zA2Oqbar2IO7b1l
         7Od9ysm5z6U42Fp5A+DCv8qGIZ11KQonOeeSeaB9ZXHpPWjEXZs5jbpIVo+bUdr79kOq
         9/nGNLu6yjWYqJkU4i7XF8Zeds0xDVXciF2hLSfHKNwFCGrGJZPb/BmoafmVUFg8OchW
         JBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RM/BOw7YekqsGoM3jSe2TZNOM5wuxud8/JsIjtKO6mg=;
        b=mqXJGvjkD8Y/UvVofvvrPFfCDBqDW+MZSA8nlZyO79e4Zhs6g6Uadk+ePiNIL40I0E
         iVWDh77O5T/a0mKX+Agm7g+iJS1UrTg/oP9VAE34D2DqadIoNZ4zudZ28LYge/vP1BOP
         jKUHB65+fC1Cq0zuEARVdfhZqN3tv2ZheiduRCwNQELWQVcad1fiW5LNge3YhjQzPzTD
         2lr9bUyFRnq86kW6DiV55kt/9YnaP9Z+GesVmDoLkjK62YA9KueT1wfiTHb5j7tv4BeA
         O4iRLS8F3FPWgxcHiGr63OZmZ3KbMsspaBarc98Xvof6sBQqvr9MqLcShVvFS+Wdv+8C
         6Z2w==
X-Gm-Message-State: AOAM530k6o+fG2uUn7vW6dDBkiugAVufUaZiUr20nqocJZYCcm5lSUcv
        I5fhcwXLIge6wp1SqAXcvhdeAznOIPhd3N6JMOc=
X-Google-Smtp-Source: ABdhPJyLWvB2zGAzT2BbyUZSgkWBwrZAHy9BT/LH6gJJE7Ksj/iURfyw3Rp2SzY1zHeWIhPtoZ5Xzt0xHeXDuI7r78U=
X-Received: by 2002:a25:730a:: with SMTP id o10mr1239406ybc.403.1600793120428;
 Tue, 22 Sep 2020 09:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
 <160051618733.58048.1005452269573858636.stgit@toke.dk> <CAEf4BzYrc1j0i5qVKfyHA98C37D7xR6i4GL4BLeprNL=HfjCBg@mail.gmail.com>
 <87lfh2p12x.fsf@toke.dk>
In-Reply-To: <87lfh2p12x.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Sep 2020 09:45:09 -0700
Message-ID: <CAEf4BzYdBy0xOVBb3RSVqtrc9+XL459LjT9hNGfmTy=QYDQ+AQ@mail.gmail.com>
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

On Tue, Sep 22, 2020 at 3:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Sat, Sep 19, 2020 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> In preparation for allowing multiple attachments of freplace programs,=
 move
> >> the references to the target program and trampoline into the
> >> bpf_tracing_link structure when that is created. To do this atomically=
,
> >> introduce a new mutex in prog->aux to protect writing to the two point=
ers
> >> to target prog and trampoline, and rename the members to make it clear=
 that
> >> they are related.
> >>
> >> With this change, it is no longer possible to attach the same tracing
> >> program multiple times (detaching in-between), since the reference fro=
m the
> >> tracing program to the target disappears on the first attach. However,
> >> since the next patch will let the caller supply an attach target, that=
 will
> >> also make it possible to attach to the same place multiple times.
> >>
> >> Acked-by: Andrii Nakryiko <andriin@fb.com>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  include/linux/bpf.h     |   15 +++++++++-----
> >>  kernel/bpf/btf.c        |    6 +++---
> >>  kernel/bpf/core.c       |    9 ++++++---
> >>  kernel/bpf/syscall.c    |   49 ++++++++++++++++++++++++++++++++++++++=
+--------
> >>  kernel/bpf/trampoline.c |   12 ++++--------
> >>  kernel/bpf/verifier.c   |    9 +++++----
> >>  6 files changed, 68 insertions(+), 32 deletions(-)
> >>
> >
> > [...]
> >
> >> @@ -741,7 +743,9 @@ struct bpf_prog_aux {
> >>         u32 max_rdonly_access;
> >>         u32 max_rdwr_access;
> >>         const struct bpf_ctx_arg_aux *ctx_arg_info;
> >> -       struct bpf_prog *linked_prog;
> >> +       struct mutex tgt_mutex; /* protects writing of tgt_* pointers =
below */
> >
> > nit: not just writing, "accessing" would be a better word
>
> Except it's not, really: the values are read without taking the mutex.

Huh? So you are taking a mutex in bpf_tracing_prog_attach before
reading prog->aux->tgt_prog and prog->aux->tgt_trampoline just for
fun?.. Why don't you read those pointers outside of mutex and let's
have discussion about race conditions?

> This is fine because it is done in the verifier before the bpf_prog is
> visible to the rest of the kernel, but saying the mutex protects all
> accesses would be misleading, I think.
>

Of course you don't need to take lock while you are constructing
bpf_prog... It's like taking a lock inside a constructor in C++ before
the outside world can ever access object's fields. No harm, but also
pointless.

> I guess I could change it to "protects access to tgt_* pointers after
> prog becomes visible" or somesuch...
>
> >> +       struct bpf_prog *tgt_prog;
> >> +       struct bpf_trampoline *tgt_trampoline;
> >>         bool verifier_zext; /* Zero extensions has been inserted by ve=
rifier. */
> >>         bool offload_requested;
> >>         bool attach_btf_trace; /* true if attaching to BTF-enabled raw=
 tp */
> >
> > [...]
> >
> >>  static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
> >> @@ -11418,8 +11417,8 @@ int bpf_check_attach_target(struct bpf_verifie=
r_log *log,
> >>  static int check_attach_btf_id(struct bpf_verifier_env *env)
> >>  {
> >>         struct bpf_prog *prog =3D env->prog;
> >> -       struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
> >>         u32 btf_id =3D prog->aux->attach_btf_id;
> >> +       struct bpf_prog *tgt_prog =3D prog->aux->tgt_prog;
> >>         struct btf_func_model fmodel;
> >>         struct bpf_trampoline *tr;
> >>         const struct btf_type *t;
> >> @@ -11483,7 +11482,9 @@ static int check_attach_btf_id(struct bpf_veri=
fier_env *env)
> >>         if (!tr)
> >>                 return -ENOMEM;
> >>
> >> -       prog->aux->trampoline =3D tr;
> >> +       mutex_lock(&prog->aux->tgt_mutex);
> >> +       prog->aux->tgt_trampoline =3D tr;
> >> +       mutex_unlock(&prog->aux->tgt_mutex);
> >
> > I think here you don't need to lock mutex, because
> > check_attach_btf_id() is called during verification before bpf_prog
> > itself is visible to user-space, so there is no way to have concurrent
> > access to it. If that wasn't the case, you'd need to take mutex lock
> > before you assign tgt_prog local variable from prog->aux->tgt_prog
> > above (and plus you'd need extra null checks and stuff).
>
> Yeah, I did realise that (see above), but put it in because it doesn't
> hurt, and it makes the comment above (about protecting writing) actually
> be true :)
>

See above about locking in a constructor analogy.

But as is the code is split-brained: it accesses prog->aux->tgt_prog
outside of mutex and prog->aux->tgt_trampoline inside the mutex. So
when reading this the natural question is why it's not one way of
doing things. Reading a field without a lock held is (in general) just
as wrong as updating that field without lock.

> But changing the wording to include 'after it becomes visible' would
> also fix this, so I'll remove the locking here...

I'd leave a comment that check_attach_btf_id is only called during
BPF_PROG_LOAD before bpf_prog is visible to user-space, so there is no
possibility of concurrently accessing its fields yet. That would make
it clear why we don't need a lock.

>
> -Toke
>
