Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADD62F21C5
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbhAKV1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbhAKV1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:27:11 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05396C061786;
        Mon, 11 Jan 2021 13:26:31 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id o144so206686ybc.0;
        Mon, 11 Jan 2021 13:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tjllqEyKM88EH7GnAr5mHS1NBvuQVypXlf2lHBHW2h8=;
        b=dTDw8E7JdjS+tNo4j2oC6bEIh2G5rrYBdS1ekzOUdZK3b/GE62532oXezpqMeG5VU9
         Ilb6c+l4v1YWVoWUiZgPkXTMb3zGz5eDP8blGlSbut7tAYUjHHkPQoBy3IhOuUUFOmDd
         7R2aAO5iopWXm4imIj0iQXI+monbEoxIhXZtLVM6+KlHbD24UHLr1cZSXH6I+Fbdl2+9
         9gIn5o5SVcbIpYctTu0W0QLHBm2XkWTICD4LT8rAAzL6adPTeVEd4zG5Ii8myvfMSwsz
         gOuhlv/XQb1zl180V48ZnyQGSsPmSed9tWrVtxjEwBHxfiFF6TVXF2pjakeaZODuYxFk
         M5Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tjllqEyKM88EH7GnAr5mHS1NBvuQVypXlf2lHBHW2h8=;
        b=axzfobyHqrJlpvtOsob8nCYzyUl7PHgA6NT4QNzXiYGG9Obz6Jg+BB2w+jJBDhuIDG
         APlqMWnue4dEGBrldULWQ8aTSAq/dAWQheKDXw2FNuGFW9RoEYqXiWtikwlJbSSM2NDr
         DUk4kET4f9dzaI6efBsIdkdtrB0A6bfj4aYVjiIZJ2+S2a3Ewnjq1ugsKUxGn+HzFWnL
         z4CDiORnWBspqJxFwXjfuzOEgk5kg6PVK5pOD0WTbqpJAfqXvCVAhwEuORMYr0ovmUXc
         azJgzZJsg3wQLDC9yRpc4GbJnITjfkdVkpirzjaLHwzhqmh+568Pa+3RG3KhlLQ8sPgO
         Fo1Q==
X-Gm-Message-State: AOAM531eTpdifPZ2srPh6dcACT1bvJ81OZBq5Ue3Kb8XcwKM2O6FZ4JW
        T1Tad0UisZ2mb0DNPVN/JRtY3NzWYYGmMhSoGt0=
X-Google-Smtp-Source: ABdhPJz+xANnQaP7THd52RhWQ9GEsmGwPpUfj1NnncTYb1nLMlFGblwy/nRcrYkCsafb8MXvWtSigNf4L/gKbZqlICM=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr2329905ybe.403.1610400390228;
 Mon, 11 Jan 2021 13:26:30 -0800 (PST)
MIME-Version: 1.0
References: <20210111191650.1241578-1-jolsa@kernel.org> <CAEf4BzboXkJ96z45+CNJ0QNf74sR9=Ew7Nr94eXiBUk_5w-mDA@mail.gmail.com>
 <20210111211719.GD1210240@krava>
In-Reply-To: <20210111211719.GD1210240@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 13:26:19 -0800
Message-ID: <CAEf4BzaYGguAfGNW8A31h_TW_UVJd8tjQT+Z9475Bwz1qZ87jw@mail.gmail.com>
Subject: Re: [PATCH] bpf: Prevent double bpf_prog_put call from bpf_tracing_prog_attach
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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

On Mon, Jan 11, 2021 at 1:17 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Jan 11, 2021 at 12:34:48PM -0800, Andrii Nakryiko wrote:
> > On Mon, Jan 11, 2021 at 11:18 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > The bpf_tracing_prog_attach error path calls bpf_prog_put
> > > on prog, which causes refcount underflow when it's called
> > > from link_create function.
> > >
> > >   link_create
> > >     prog = bpf_prog_get              <-- get
> > >     ...
> > >     tracing_bpf_link_attach(prog..
> > >       bpf_tracing_prog_attach(prog..
> > >         out_put_prog:
> > >           bpf_prog_put(prog);        <-- put
> > >
> > >     if (ret < 0)
> > >       bpf_prog_put(prog);            <-- put
> > >
> > > Removing bpf_prog_put call from bpf_tracing_prog_attach
> > > and making sure its callers call it instead.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> >
> > I also double-checked all other attach functions called from
> > link_create, they all seem to be fine and don't put prog on failure,
> > so this should be the only needed fix. Also, missing:
>
> it'd be easier to spot this if we use refcount_t instead of the atomic64_t,
> I replaced it for this refcount and got nice console warning for this bug
>
> then I saw:
>   85192dbf4de0 bpf: Convert bpf_prog refcnt to atomic64_t
>
> so I guess we need something like refcount64_t first

Having a non-failing refcount simplifies code quite a lot. I was
having a problem having to deal with potential refcount failure during
mmap()'ing, where it's impossible to communicate failure back to the
kernel. So if atomic64_t would never fail, but would generate a
warning on underflow, then yeah, it would be an improvement.

>
> jirka
>
> >
> > Fixes: 4a1e7c0c63e0 ("bpf: Support attaching freplace programs to
> > multiple attach points")
> >
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> >
> > >  kernel/bpf/syscall.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > index c3bb03c8371f..e5999d86c76e 100644
> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -2712,7 +2712,6 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
> > >  out_put_prog:
> > >         if (tgt_prog_fd && tgt_prog)
> > >                 bpf_prog_put(tgt_prog);
> > > -       bpf_prog_put(prog);
> > >         return err;
> > >  }
> > >
> > > @@ -2825,7 +2824,10 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
> > >                         tp_name = prog->aux->attach_func_name;
> > >                         break;
> > >                 }
> > > -               return bpf_tracing_prog_attach(prog, 0, 0);
> > > +               err = bpf_tracing_prog_attach(prog, 0, 0);
> > > +               if (err >= 0)
> > > +                       return err;
> > > +               goto out_put_prog;
> > >         case BPF_PROG_TYPE_RAW_TRACEPOINT:
> > >         case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
> > >                 if (strncpy_from_user(buf,
> > > --
> > > 2.26.2
> > >
> >
>
