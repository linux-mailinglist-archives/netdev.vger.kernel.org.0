Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B08535E8B9
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhDMWEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhDMWEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 18:04:00 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43422C061574;
        Tue, 13 Apr 2021 15:03:39 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id k73so13561796ybf.3;
        Tue, 13 Apr 2021 15:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OEgibsVHg0P98fbhMynC0Ra5DnCvolJfLEbwjoCLa4o=;
        b=PQCXwDz3f/g8++uDOoLUFOGWYYTI1cphxdtv6KQrtxoeM+dO1FWY69bd/nKh9uwyZl
         QiUUa235giKLZgBH9eWqsBnYZ8El5lyXDsyDSpOu7/EVo8SZ/pS+A18MQfuCpXtnu9Hp
         8sjnygrssytBRP7DINmtMnSddxvW34IRQ4SKJDDeSKN3nL6ENQ2ZnwXFntsZbduAkCbW
         WC7sUqn5+hIOl6rcLijOpYEqp6UC8uIWXgLoSMYPvK9R0kPkuiw6NfmDQ+tI5sLiZtUU
         xVX9iJtd5Rs58ca12ilkfO/xTKaiizzbQ4ieoF3ZrE3djemTSPiIzh6O8gIqAyRDBk4W
         GIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OEgibsVHg0P98fbhMynC0Ra5DnCvolJfLEbwjoCLa4o=;
        b=japtRreRGZ0scZuqy3LhCGn6Sfl8ekbRVYbLwN5d13myHc//+6Gs1ylHbW7p3ZYG6w
         D294YjjBlt/B2cFE/wnIDDWlYnF2lupysQWRwyZe+eW8p1Mbk0H1IIGhAimsqTB/KpJ/
         Z4pFxdONs6cL2Tv74Oj24f/bw4Kf4bd3myiMYGBlOQcmrvVo9NiiwBRrKM9uAHbFNo/E
         wTsAd4sDYut7V0ipxi5B4q2M8h2KRZCOXfVQWe7zsNzJBcFJQg/256oIHOTAn2lx2G3J
         OiVSSwtxu+SNGry99BT2xua3mnLhys7rLlB/pGs6i3f04s4uoRtOYuxH0w0u2+JwqV+6
         AsJg==
X-Gm-Message-State: AOAM533Y/srXBj1L1QoCcauT1scfhngibO7pQ1tgcX5hWiwbLmooH1uH
        B/3pTlEucyjuxUq634pGLb2pUj2JZwE2gr5s1e8=
X-Google-Smtp-Source: ABdhPJy5XUPAwHgc4n1GTVffNyLOEeSjkwF6i1FpdPQm1z53kWOW5z2Mqkgj1ZlLca486FX6+hnWlAXww9wPHMxrpMk=
X-Received: by 2002:a25:d70f:: with SMTP id o15mr36319424ybg.403.1618351418604;
 Tue, 13 Apr 2021 15:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210412162502.1417018-1-jolsa@kernel.org> <20210412162502.1417018-2-jolsa@kernel.org>
In-Reply-To: <20210412162502.1417018-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Apr 2021 15:03:27 -0700
Message-ID: <CAEf4BzbbVDCuAyCPYAdc363T6uAC6QDOwqNzFOHZPrHSbnRYCA@mail.gmail.com>
Subject: Re: [PATCHv4 bpf-next 1/5] bpf: Allow trampoline re-attach for
 tracing and lsm programs
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        kernel test robot <lkp@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Julia Lawall <julia.lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 9:28 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Currently we don't allow re-attaching of trampolines. Once
> it's detached, it can't be re-attach even when the program
> is still loaded.
>
> Adding the possibility to re-attach the loaded tracing and
> lsm programs.
>
> Fixing missing unlock with proper cleanup goto jump reported
> by Julia.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/syscall.c    | 23 +++++++++++++++++------
>  kernel/bpf/trampoline.c |  2 +-
>  2 files changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 6428634da57e..f02c6a871b4f 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2645,14 +2645,25 @@ static int bpf_tracing_prog_attach(struct bpf_pro=
g *prog,
>          *   target_btf_id using the link_create API.
>          *
>          * - if tgt_prog =3D=3D NULL when this function was called using =
the old
> -         *   raw_tracepoint_open API, and we need a target from prog->au=
x
> -         *
> -         * The combination of no saved target in prog->aux, and no targe=
t
> -         * specified on load is illegal, and we reject that here.
> +        *   raw_tracepoint_open API, and we need a target from prog->aux
> +        *
> +        * - if prog->aux->dst_trampoline and tgt_prog is NULL, the progr=
am
> +        *   was detached and is going for re-attachment.
>          */
>         if (!prog->aux->dst_trampoline && !tgt_prog) {
> -               err =3D -ENOENT;
> -               goto out_unlock;
> +               /*
> +                * Allow re-attach for TRACING and LSM programs. If it's
> +                * currently linked, bpf_trampoline_link_prog will fail.
> +                * EXT programs need to specify tgt_prog_fd, so they
> +                * re-attach in separate code path.
> +                */
> +               if (prog->type !=3D BPF_PROG_TYPE_TRACING &&
> +                   prog->type !=3D BPF_PROG_TYPE_LSM) {
> +                       err =3D -EINVAL;
> +                       goto out_unlock;
> +               }
> +               btf_id =3D prog->aux->attach_btf_id;
> +               key =3D bpf_trampoline_compute_key(NULL, prog->aux->attac=
h_btf, btf_id);
>         }
>
>         if (!prog->aux->dst_trampoline ||
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 1f3a4be4b175..48b8b9916aa2 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -437,7 +437,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog,=
 struct bpf_trampoline *tr)
>                 tr->extension_prog =3D NULL;
>                 goto out;
>         }
> -       hlist_del(&prog->aux->tramp_hlist);
> +       hlist_del_init(&prog->aux->tramp_hlist);

there is another hlist_del few lines above in error handling path of
bpf_trampoline_link_prog(), it should probably be also updated to
hlist_del_init(), no?

>         tr->progs_cnt[kind]--;
>         err =3D bpf_trampoline_update(tr);
>  out:
> --
> 2.30.2
>
