Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABAC3DCDE1
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 23:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhHAVKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 17:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhHAVKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 17:10:49 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96005C06175F;
        Sun,  1 Aug 2021 14:10:40 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id a93so7263223ybi.1;
        Sun, 01 Aug 2021 14:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5cqE+6f5sJI5BDN/verR/h91s0qeLymynL8ETBEatK0=;
        b=Nro+3TtfxnGb0lPkpzN2Mwk34JYNPXUG6LaT7Gf/HAwoHPsEwhNX5aYlo8XOT6M4iT
         mKBXk040q6dlY+3YTCMqJ/trrtJwyyHI1s4eZMiXA/pWpdTKT9q83GM239M0yRqtz6yp
         SJJ60YdubtEcYMtC284csMe+0HhXJTb4zwXT3fASKrf9dOyK+Tym7MwKz4fSBLBrma/Y
         fVpkvOA0rZ/nMfYs38tcT3rZwxLK1aUZiIJAQejyyJ3kLBEjPSvLcM9DHBLjmpJ9FTi2
         qDhQ18CQ/0+c20sOG/l3fBeDUfWQiO907aIOrZTF9+5w7vlMWutWYbs+Eeo9544g1rHF
         fDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5cqE+6f5sJI5BDN/verR/h91s0qeLymynL8ETBEatK0=;
        b=JZakkigkbBsPHxhoPTLD+zqkK6k1uglvxtbMf2WTyeIlgGtdsIzzgrrmop6EldT9Nd
         gq0fmQGKzhpJWtAQPe1b4mJWVQY58SdLSdNV6A9Idx4bbkygeIrj809RJQAs8QwC1CQL
         CC6Cn7CMDgdKKXSjcsMfSQaRUdX0QsxzLqDmKW4SaMVcGx56xgN9kzsqKDcX49HONqLa
         IzqsJvJQxN+BY9ZfbrZ02or+woJweQ603Qh1Uq2Pr+5brJYXXSc+NWapxpu+vyyaRgx/
         fSQltaIR11+/Av7Q3DbU0DDzDa3QD1unRYTpb3h/yk6oXFccRw9KOoJSWBWzZpmkjDsW
         5mtA==
X-Gm-Message-State: AOAM531BCGf3L9T+OSfmvanEoKK5TIt27jIqI/LLtZqJnWB+JAUw+QRj
        Z+rEEXHlsl9cclPCACw7NIs4XaCKLjZLpD2vYZU=
X-Google-Smtp-Source: ABdhPJwo1gVgHC/X4QbKuGz+W7OF1P3orPa5UB6Jz2v3cyf28vWB5CtmDqlpxSaZadLKvvb8jx1OUUm85SdtqPXGLXo=
X-Received: by 2002:a25:1546:: with SMTP id 67mr17077538ybv.331.1627852239100;
 Sun, 01 Aug 2021 14:10:39 -0700 (PDT)
MIME-Version: 1.0
References: <CADVatmPShADZ0F133eS3KjeKj1ZjTNAQfy_QOoJVBan02wuR+Q@mail.gmail.com>
 <202107311901.8CDF235F65@keescook>
In-Reply-To: <202107311901.8CDF235F65@keescook>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Sun, 1 Aug 2021 22:10:03 +0100
Message-ID: <CADVatmOt6Xy+is=1CBZFqExBT63EKhO37eCJ9hsvS5jy+-PMVg@mail.gmail.com>
Subject: Re: memory leak in do_seccomp
To:     Kees Cook <keescook@chromium.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        alaaemadhossney.ae@gmail.com,
        syzkaller <syzkaller@googlegroups.com>,
        Jann Horn <jannh@google.com>,
        Tycho Andersen <tycho@tycho.pizza>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kees,

On Sun, Aug 1, 2021 at 4:26 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Sat, Jul 31, 2021 at 08:20:29PM +0100, Sudip Mukherjee wrote:
> > Hi All,
> >
> > We had been running syzkaller on v5.10.y and a "memory leak in
> > do_seccomp" was being reported on it. I got some time to check that
> > today and have managed to get a syzkaller
> > reproducer. I dont have a C reproducer which I can share but I can use
> > the syz-reproducer to reproduce this with next-20210730.
> > The old report on v5.10.y is at
> > https://elisa-builder-00.iol.unh.edu/syzkaller/report?id=f6ddd3b592f00e95f9cbd2e74f70a5b04b015c6f
>
> Thanks for the details!
>
> Is this the same as what syzbot saw here (with a C reproducer)?
> https://syzkaller.appspot.com/bug?id=2809bb0ac77ad9aa3f4afe42d6a610aba594a987

Looks similar but it says its fixed and I still get it with the
reproducer I have.

>
> I can't figure out what happened with the "Patch testing request" that
> was made; there's no link?

Looks like it has been merged with a566a9012acd ("seccomp: don't leak
memory when filter install races")

>
> >
> > BUG: memory leak
> > unreferenced object 0xffff888019282c00 (size 512):
> >   comm "syz-executor.1", pid 7389, jiffies 4294761829 (age 17.841s)
> >   hex dump (first 32 bytes):
> >     01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<00000000762c0963>] do_seccomp+0x2d5/0x27d0
>
> Can you run "./scripts/faddr2line do_seccomp+0x2d5/0x27d0" for this? I
> expect it'll be:
>         sfilter = kzalloc(sizeof(*sfilter), GFP_KERNEL | __GFP_NOWARN);

Yes, it is from "(inlined by) seccomp_prepare_filter at kernel/seccomp.c:661".
I did:
$ scripts/faddr2line vmlinux do_seccomp+0x2d5/0x27d0
do_seccomp+0x2d5/0x27d0:
kmalloc at include/linux/slab.h:591
(inlined by) kzalloc at include/linux/slab.h:721
(inlined by) seccomp_prepare_filter at kernel/seccomp.c:661
(inlined by) seccomp_prepare_user_filter at kernel/seccomp.c:703
(inlined by) seccomp_set_mode_filter at kernel/seccomp.c:1852
(inlined by) do_seccomp at kernel/seccomp.c:1972

>
> >     [<0000000006e512d1>] do_syscall_64+0x3b/0x90
> >     [<0000000094ae9ff8>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>

<snip>

>
> My best guess is there is some LISTENER refcount state we can get into
> where all the processes die, but a reference is left alive.

Will be happy to run any debug patch if you need.


-- 
Regards
Sudip
