Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1C526C85B
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgIPSqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbgIPSWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 14:22:21 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB552C061756;
        Wed, 16 Sep 2020 11:22:20 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id c17so6126060ybe.0;
        Wed, 16 Sep 2020 11:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0yvq7JNthKxbYOHDHOWG0xNarv1GFWHVlIaBEc+BtOM=;
        b=D/GXJTn1HM6gps0EGKWe8RnWjzIxNdP6IfbTrWQVSrXz+dt/4b7Txhvu3n3T+gagDU
         6OF8h+QVOGMJrW9ggZjebNDBC1uWrtLPFJ4uSfXQTpW8CVlaHdwHHnxpKepBQ4j3tQvh
         v0iPS8yxr5XZhi1gXyLS7XJVMXDUAkll9nqTtgn4jM90Hxnvf4Ql710DBmBwXGli0YCO
         g6DuEFrL0Xr7X7bhWOnGdSAruGCDJ8fcsHVj0T5+vhxMtdNNnHHntLF/LfuhEtblfCyl
         Ag9/W9gQLqHyNL8TwxCEuCxm3oHB9tGHa7PuxfOEhy+1beoHD00xzF2n3ztciQRb3Hxe
         8dmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0yvq7JNthKxbYOHDHOWG0xNarv1GFWHVlIaBEc+BtOM=;
        b=aaLIyd9UyZPB7JeP26Lni9MQ+7ZNfNDBZ9oC9PObGjWdRsZkEAB9Zd8DPrrFzu6a28
         3rfJcKDWDwLEeCKJGGcNvtVkzglg1gkKSx3CCPHXdhzfIwOXC/IJgkYdOhwfobX6VEPi
         VI+gdeHR1P3ABOJO0hYpRHyWP9XT85cF3zm1EUCKm/5lN13cr+jPwMep5yIrbf4HfiAg
         8BM0LpRzoXDjmoImAiQwb4cDouzC+ntyedj+pk3G79j4cpPwXdMnE5ckO90+JaYd9TO1
         /fLKTQ4oYMxs4TU3FMIFOfVkzyyRxEE1sByBmyFmFfBXFBqOUYJGS6rHpDsBdG0BIjpO
         uRRQ==
X-Gm-Message-State: AOAM533zgxyxbWn1hxHxcaaWtFLaKUcDsmjBVnz+wKolA/PGUk9NWdr2
        aehgdHO4ktuIhOjqwFVexwRxjGq9buSmz4rptSY=
X-Google-Smtp-Source: ABdhPJysUJyNB7gcgsAktzk2oaIoLFmQ/kJOZs9XR0p+ZpiN/WMfaYvyZKJYCtMsSuiZ8Z3SfVGRdtB/e+wh2Ugd6Po=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr35125340ybp.510.1600280539251;
 Wed, 16 Sep 2020 11:22:19 -0700 (PDT)
MIME-Version: 1.0
References: <160017005691.98230.13648200635390228683.stgit@toke.dk> <160017006024.98230.18011033601869719353.stgit@toke.dk>
In-Reply-To: <160017006024.98230.18011033601869719353.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Sep 2020 11:22:08 -0700
Message-ID: <CAEf4BzZuvzb8Oqp=bLHo9H9fawPxh0a2+qhAhB+8KEO36YkX1g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/8] bpf: move prog->aux->linked_prog and
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
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
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Seems much more straightforward to me with mutex. And I don't have to
worry about various transient NULL states.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h     |   15 +++++++++------
>  kernel/bpf/btf.c        |    6 +++---
>  kernel/bpf/core.c       |    9 ++++++---
>  kernel/bpf/syscall.c    |   46 ++++++++++++++++++++++++++++++++++++++++-=
-----
>  kernel/bpf/trampoline.c |   12 ++++--------
>  kernel/bpf/verifier.c   |    9 +++++----
>  6 files changed, 67 insertions(+), 30 deletions(-)
>

[...]

> @@ -2583,19 +2598,38 @@ static int bpf_tracing_prog_attach(struct bpf_pro=
g *prog)
>                       &bpf_tracing_link_lops, prog);
>         link->attach_type =3D prog->expected_attach_type;
>
> +       mutex_lock(&prog->aux->tgt_mutex);
> +
> +       if (!prog->aux->tgt_trampoline) {
> +               err =3D -ENOENT;
> +               goto out_unlock;
> +       }
> +       tr =3D prog->aux->tgt_trampoline;
> +       tgt_prog =3D prog->aux->tgt_prog;
> +
>         err =3D bpf_link_prime(&link->link, &link_primer);
>         if (err) {
> -               kfree(link);
> -               goto out_put_prog;
> +               goto out_unlock;
>         }

nit: unnecessary {} now

>
> -       err =3D bpf_trampoline_link_prog(prog);
> +       err =3D bpf_trampoline_link_prog(prog, tr);
>         if (err) {
>                 bpf_link_cleanup(&link_primer);
> -               goto out_put_prog;
> +               link =3D NULL;
> +               goto out_unlock;
>         }

[...]
