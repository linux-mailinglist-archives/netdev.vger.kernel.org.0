Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7D52F20E5
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 21:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730955AbhAKUfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 15:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbhAKUfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 15:35:40 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF4BC061794;
        Mon, 11 Jan 2021 12:35:00 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id k78so15175ybf.12;
        Mon, 11 Jan 2021 12:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7O8B4R5Qek1xJORx61h+Dz6UaUuSEDkYvNpSy2uExkU=;
        b=KFc+OzpWruxJVR2aaNQXu6vP2si5BALGrY1+Ib0mEx3yUTKI43EUPiyMzuxeI9q58I
         YRhzJx3CpSjQUXFJ//A/lF4u8vJNTPnFzdudat4OIU69OwV9wc+SFTwusKCgOYfkwnkf
         hEBupgJowEbOp6/c45q9czb1ic+AO6NeVr5peir6NAneHopCFySRMuJsiunm2dCl8Dkq
         C/kmpJmKoEruMqH8KF1P56SZ661fYspSJ9MS7jmoyjpziECqqpXPElwe9168k/p0JkFR
         onQvr6XlaxvRaKqhtfqvQCUPYe5NkNQpSSxd7KWx7UqtnLHshn5ot2WvXJVkvd/okaLt
         BzPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7O8B4R5Qek1xJORx61h+Dz6UaUuSEDkYvNpSy2uExkU=;
        b=JHmPhZDZlldU/6G9IbP4XQ57nqj0sHpT9tDrJSuA95SV4EwRgNqOmP2WYxnEhipWUK
         Nv9nxO+p5EoqNaMNkyh98tlzwUIs5pO7754cda8Ag0tM7GieofcQo457+yiSh4DcohoG
         ilecgFQGI2YNWdVkZRbon/Q6c+wPioB8IilojRHDpzy4dO4R3WrmWj7ObrfgYtBOSubo
         aLYAO3tBR7sO7PaGPdNTeFWHxCZVtI3mqjWNLAqorJYqT7g25ZsBqh/+waiXCGAmrO0i
         GjyKOUq805AAYAeVet2pXcMd6FyXA9CVlIMPovZcj4WJ8bhxxrxxEPGJiNp57SIVDVoL
         d7Jg==
X-Gm-Message-State: AOAM530hwNWxZU7O0VBZ2/VSujo6DoChE2+ykoP9qUYLpskKA4MUORW8
        IF0uz4uDsfybjy76DfwpCiQElex6q4mxE9xzeNk=
X-Google-Smtp-Source: ABdhPJwzxQ783wEdWfLNe5exUYNCXcDpV+AUsRxIASb04826xT3sklKVkH88+IznAymMmqgNODghHlrNDxOz8ErBGxI=
X-Received: by 2002:a25:854a:: with SMTP id f10mr2169126ybn.510.1610397299522;
 Mon, 11 Jan 2021 12:34:59 -0800 (PST)
MIME-Version: 1.0
References: <20210111191650.1241578-1-jolsa@kernel.org>
In-Reply-To: <20210111191650.1241578-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 12:34:48 -0800
Message-ID: <CAEf4BzboXkJ96z45+CNJ0QNf74sR9=Ew7Nr94eXiBUk_5w-mDA@mail.gmail.com>
Subject: Re: [PATCH] bpf: Prevent double bpf_prog_put call from bpf_tracing_prog_attach
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 11:18 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The bpf_tracing_prog_attach error path calls bpf_prog_put
> on prog, which causes refcount underflow when it's called
> from link_create function.
>
>   link_create
>     prog = bpf_prog_get              <-- get
>     ...
>     tracing_bpf_link_attach(prog..
>       bpf_tracing_prog_attach(prog..
>         out_put_prog:
>           bpf_prog_put(prog);        <-- put
>
>     if (ret < 0)
>       bpf_prog_put(prog);            <-- put
>
> Removing bpf_prog_put call from bpf_tracing_prog_attach
> and making sure its callers call it instead.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

I also double-checked all other attach functions called from
link_create, they all seem to be fine and don't put prog on failure,
so this should be the only needed fix. Also, missing:

Fixes: 4a1e7c0c63e0 ("bpf: Support attaching freplace programs to
multiple attach points")

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  kernel/bpf/syscall.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index c3bb03c8371f..e5999d86c76e 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2712,7 +2712,6 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
>  out_put_prog:
>         if (tgt_prog_fd && tgt_prog)
>                 bpf_prog_put(tgt_prog);
> -       bpf_prog_put(prog);
>         return err;
>  }
>
> @@ -2825,7 +2824,10 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
>                         tp_name = prog->aux->attach_func_name;
>                         break;
>                 }
> -               return bpf_tracing_prog_attach(prog, 0, 0);
> +               err = bpf_tracing_prog_attach(prog, 0, 0);
> +               if (err >= 0)
> +                       return err;
> +               goto out_put_prog;
>         case BPF_PROG_TYPE_RAW_TRACEPOINT:
>         case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
>                 if (strncpy_from_user(buf,
> --
> 2.26.2
>
