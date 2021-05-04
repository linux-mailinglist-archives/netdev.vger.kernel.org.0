Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0493372B19
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 15:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhEDNdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 09:33:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231210AbhEDNdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 09:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620135174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5cJAfRgHy9tFb0zjDG5tK5B9uOLPoWSyku8A/zwyYlw=;
        b=gh3dcaRXnDkikk4p9bj6Sqc5vAGvsqhcwgK+nlT/fAAcbFmRqIIca2C3PiuRAKVop7nd3m
        WzEURymsURcJ4Q2ghHXTuupES6bGBtsrCnpGbfFvpRC+C0Uf2H/pBG0Gawf8lf7/ySl080
        ZNCpxgeQoh+HCirjUXa/9eSnpANHyC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-UQMyl3wyMGyB5QFjTxaOQg-1; Tue, 04 May 2021 09:32:51 -0400
X-MC-Unique: UQMyl3wyMGyB5QFjTxaOQg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DD9C1898299;
        Tue,  4 May 2021 13:32:49 +0000 (UTC)
Received: from krava (unknown [10.40.192.136])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2928E421F;
        Tue,  4 May 2021 13:32:47 +0000 (UTC)
Date:   Tue, 4 May 2021 15:32:46 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC] bpf: Fix crash on mm_init trampoline attachment
Message-ID: <YJFM/iLKb1EWCYEx@krava>
References: <20210430134754.179242-1-jolsa@kernel.org>
 <CAEf4BzbEjvccUDabpTiPOiXK=vfcmHaXjeaTL8gCr08=6fBqhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbEjvccUDabpTiPOiXK=vfcmHaXjeaTL8gCr08=6fBqhg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 03:45:28PM -0700, Andrii Nakryiko wrote:
> On Fri, Apr 30, 2021 at 6:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > There are 2 mm_init functions in kernel.
> >
> > One in kernel/fork.c:
> >   static struct mm_struct *mm_init(struct mm_struct *mm,
> >                                    struct task_struct *p,
> >                                    struct user_namespace *user_ns)
> >
> > And another one in init/main.c:
> >   static void __init mm_init(void)
> >
> > The BTF data will get the first one, which is most likely
> > (in my case) mm_init from init/main.c without arguments.
> >
> > Then in runtime when we want to attach to 'mm_init' the
> > kalsyms contains address of the one from kernel/fork.c.
> >
> > So we have function model with no arguments and using it
> > to attach function with 3 arguments.. as result the trampoline
> > will not save function's arguments and we get crash because
> > trampoline changes argument registers:
> >
> >   BUG: unable to handle page fault for address: 0000607d87a1d558
> >   #PF: supervisor write access in kernel mode
> >   #PF: error_code(0x0002) - not-present page
> >   PGD 0 P4D 0
> >   Oops: 0002 [#1] SMP PTI
> >   CPU: 6 PID: 936 Comm: systemd Not tainted 5.12.0-rc4qemu+ #191
> >   RIP: 0010:mm_init+0x223/0x2a0
> >   ...
> >   Call Trace:
> >    ? bpf_trampoline_6442453476_0+0x3b/0x1000
> >    dup_mm+0x66/0x5f0
> >    ? __lock_task_sighand+0x3a/0x70
> >    copy_process+0x17d0/0x1b50
> >    kernel_clone+0x97/0x3c0
> >    __do_sys_clone+0x60/0x80
> >    do_syscall_64+0x33/0x40
> >    entry_SYSCALL_64_after_hwframe+0x44/0xae
> >   RIP: 0033:0x7f1dc9b3201f
> >
> > I think there might be more cases like this, but I don't have
> > an idea yet how to solve this in generic way. The rename in
> > this change fix it for this instance.
> 
> Just retroactively renaming functions and waiting for someone else to
> report similar issues is probably not the best strategy. Should
> resolve_btfids detect all name duplicates and emit warnings for them?
> It would be good to also remove such name-conflicting FUNCs from BTF
> (though currently it's not easy). And fail if such a function is
> referenced from .BTF_ids section.
> 
> Thoughts?

I guess we can do more checks, but I think the problem is the BTF
data vs address we get from kallsyms based on function name

we can easily get conflict address for another function with
different args

not sure how to ensure we have the proper address..  storing the
address in BTF data?

> 
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  init/main.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/init/main.c b/init/main.c
> > index 53b278845b88..bc1bfe57daf7 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -818,7 +818,7 @@ static void __init report_meminit(void)
> >  /*
> >   * Set up kernel memory allocators
> >   */
> > -static void __init mm_init(void)
> > +static void __init init_mem(void)
> >  {
> >         /*
> >          * page_ext requires contiguous pages,
> > @@ -905,7 +905,7 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
> >         vfs_caches_init_early();
> >         sort_main_extable();
> >         trap_init();
> > -       mm_init();
> > +       init_mem();
> 
> nit: given trap_init and ftrace_init, mem_init probably would be a better name?

it's taken ;-)

jirka

