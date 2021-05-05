Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93610373341
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhEEAh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbhEEAh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 20:37:29 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9A4C061574;
        Tue,  4 May 2021 17:36:32 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id i4so487512ybe.2;
        Tue, 04 May 2021 17:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LxB2gWxcI11pwKPAsvU0IrSTkp5sob1SifUrOzLS4D0=;
        b=Ukey/RIgaUQMWQJi7CY29XB8eWGXFjMeECQXVO0rWsTi/QfjmzlZqFyRdjAr9nGraD
         on+WaMtDCtLME1Lxmm6R90mTZ6bl7Z3G5qn9kiJyJJz3glXGBSoWDrtuBr8HVf8hXL08
         3tInr7W0Nd0drsNH4hYzXpy4UhHwqYEv4NR5bN4QKhXQnTy4iUxxreqwOZmKyNeGfiV9
         zAwZAe/HjZWMybq7FGWO6c8yP4Zze4l9gQSy388jZj4aok8Y2oj3Xcbd2U3awN9CY/Rp
         Vf9rF057rYq/gs7OCzPqw24AeU1a4xnBuG/kf940xP0jXyLDG9xogZ8h1DCt4WbOBCth
         g4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LxB2gWxcI11pwKPAsvU0IrSTkp5sob1SifUrOzLS4D0=;
        b=r6rhpPmcyR/rH5PKji1ZueJB1a/mThx++Z8q7qs15urYH9QxdFg6OXf7Emcw0HsE68
         5DHxiWeuXenjyp1AuCcnpGc8EgqUVy8ou1b15IgQIcOQCL+ItrG895qC2jQT8s/xbTl6
         fiQ8HXWTj/6o1OaMvII/svVKKjnQzv+UrbnQEDiXJejbjjh2DiRyxGekGpTy1IyFBUkv
         pQqtAw7ggENyKLqoIMq97IdtlweeBycl/ofqBsGpa/4DgjDRnOWNbIV4U24TS2Isw3sR
         DKWoqNPdCh+gpyCCeY9X0Pb4u47mLLkENloNF+g83HVrVIqZlaOGlXAuohMTQrsshgZR
         zkcg==
X-Gm-Message-State: AOAM533YOeMl+VIURLEO1osIxx+GqmUaQk9lCkb4kxPkj3X18xt2+Iap
        m+6CtMG5WHDN1ixSQXFbnnJ3UCJTGtEctrYkR+Q=
X-Google-Smtp-Source: ABdhPJzq4lyiFLT1WuRRwy2Wh9+KV528ZRld2l6O3YYhWWwb3J1dxMDVA6n5SLssaLvU+7ZIBZtm0E3tjlXIAbTNA1E=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr36499277ybg.459.1620174991732;
 Tue, 04 May 2021 17:36:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210430134754.179242-1-jolsa@kernel.org> <CAEf4BzbEjvccUDabpTiPOiXK=vfcmHaXjeaTL8gCr08=6fBqhg@mail.gmail.com>
 <YJFM/iLKb1EWCYEx@krava>
In-Reply-To: <YJFM/iLKb1EWCYEx@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 May 2021 17:36:20 -0700
Message-ID: <CAEf4BzbY24gFqCORLiAFpSjrv_TUPMwvGzn96hGtk+eYVDnbSQ@mail.gmail.com>
Subject: Re: [RFC] bpf: Fix crash on mm_init trampoline attachment
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 4, 2021 at 6:32 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, May 03, 2021 at 03:45:28PM -0700, Andrii Nakryiko wrote:
> > On Fri, Apr 30, 2021 at 6:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > There are 2 mm_init functions in kernel.
> > >
> > > One in kernel/fork.c:
> > >   static struct mm_struct *mm_init(struct mm_struct *mm,
> > >                                    struct task_struct *p,
> > >                                    struct user_namespace *user_ns)
> > >
> > > And another one in init/main.c:
> > >   static void __init mm_init(void)
> > >
> > > The BTF data will get the first one, which is most likely
> > > (in my case) mm_init from init/main.c without arguments.
> > >
> > > Then in runtime when we want to attach to 'mm_init' the
> > > kalsyms contains address of the one from kernel/fork.c.
> > >
> > > So we have function model with no arguments and using it
> > > to attach function with 3 arguments.. as result the trampoline
> > > will not save function's arguments and we get crash because
> > > trampoline changes argument registers:
> > >
> > >   BUG: unable to handle page fault for address: 0000607d87a1d558
> > >   #PF: supervisor write access in kernel mode
> > >   #PF: error_code(0x0002) - not-present page
> > >   PGD 0 P4D 0
> > >   Oops: 0002 [#1] SMP PTI
> > >   CPU: 6 PID: 936 Comm: systemd Not tainted 5.12.0-rc4qemu+ #191
> > >   RIP: 0010:mm_init+0x223/0x2a0
> > >   ...
> > >   Call Trace:
> > >    ? bpf_trampoline_6442453476_0+0x3b/0x1000
> > >    dup_mm+0x66/0x5f0
> > >    ? __lock_task_sighand+0x3a/0x70
> > >    copy_process+0x17d0/0x1b50
> > >    kernel_clone+0x97/0x3c0
> > >    __do_sys_clone+0x60/0x80
> > >    do_syscall_64+0x33/0x40
> > >    entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >   RIP: 0033:0x7f1dc9b3201f
> > >
> > > I think there might be more cases like this, but I don't have
> > > an idea yet how to solve this in generic way. The rename in
> > > this change fix it for this instance.
> >
> > Just retroactively renaming functions and waiting for someone else to
> > report similar issues is probably not the best strategy. Should
> > resolve_btfids detect all name duplicates and emit warnings for them?
> > It would be good to also remove such name-conflicting FUNCs from BTF
> > (though currently it's not easy). And fail if such a function is
> > referenced from .BTF_ids section.
> >
> > Thoughts?
>
> I guess we can do more checks, but I think the problem is the BTF
> data vs address we get from kallsyms based on function name
>
> we can easily get conflict address for another function with
> different args

Assuming that BTF encodes all the functions from kallsyms, if we make
sure that there are no two FUNCs with the same name, lookup should
theoretically always return the right functions. Right? Or am I
misunderstanding something?

>
> not sure how to ensure we have the proper address..  storing the
> address in BTF data?
>
> >
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  init/main.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/init/main.c b/init/main.c
> > > index 53b278845b88..bc1bfe57daf7 100644
> > > --- a/init/main.c
> > > +++ b/init/main.c
> > > @@ -818,7 +818,7 @@ static void __init report_meminit(void)
> > >  /*
> > >   * Set up kernel memory allocators
> > >   */
> > > -static void __init mm_init(void)
> > > +static void __init init_mem(void)
> > >  {
> > >         /*
> > >          * page_ext requires contiguous pages,
> > > @@ -905,7 +905,7 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
> > >         vfs_caches_init_early();
> > >         sort_main_extable();
> > >         trap_init();
> > > -       mm_init();
> > > +       init_mem();
> >
> > nit: given trap_init and ftrace_init, mem_init probably would be a better name?
>
> it's taken ;-)

oh, ok, never mind then

>
> jirka
>
