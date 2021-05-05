Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35E9373426
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 06:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhEEEMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 00:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhEEEMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 00:12:37 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF10C061574;
        Tue,  4 May 2021 21:11:39 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id z13so675938lft.1;
        Tue, 04 May 2021 21:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5RR5Vc88Zj1z28YE7L3aCNr6ylannrTjJ3Q79VqD2Ag=;
        b=E6eVhLViQTcJOVu6h1Q+3qdwREjKqb3Jt8uC7CetwDD3NL4gtlrIWMKdEbjpghfgfp
         OnimFyORtcrBvFMxULg8TreP2Sm+Bq8bgR6O6l0v/H1vyPK0eGcGFuFzbDdQ69uEd2NW
         Q2urbha38GRPdyqN8hq8IYHb5hUKTJn8yoRT8ZRiUEVGdZx1U+P5hCyA1P430qgy6lKq
         mWkKvaMnj3Fi/lDiNnfAAVtCVy34MFQiVmMovUnDEm9VUg4cHIgjv3qMqINxbfSA3K8c
         zy4bNznURr+0lt/Lmu25qYoM9cFtsFljco7EzENCBLDRZXHw+t9+UvmPSKORpyy4nGFn
         5raA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5RR5Vc88Zj1z28YE7L3aCNr6ylannrTjJ3Q79VqD2Ag=;
        b=NuBgkS4q4wkPJpc469T87XH7KmK+mm9yYQ7KVWKx+soC1JOl1tG2JDvFyGVOZ/fVHP
         1LtaoXY+atXHrJYqBCAaW559pD7nBYlBxAKE9d+g2opuPOYowRMLmnrG2P2M8QYswxp6
         jo18Ro/zim2+BB85wzbnY65Ka9t3kQNr5wy3gYqt6/qAwDrprlBDSOYNi4qBbZAMVyNA
         L2ySUfHiQnC+z5bQM/aH2xcek4fsieFeXEzS+6v82ivTjaODNDUfzDo/7eZOU8bTgm8Y
         nIq4eth4KY57TKOj07QdNUdLD+6euapiUbW46X0hab4OYQHbcUdDH2fDWDYD67uXRvPX
         /CRQ==
X-Gm-Message-State: AOAM532oOThWnmGwpLB/9JSgwhYY6F/TNnYaNCQRhLNSiePTIJrq3VBB
        52OMCokrNc43z8A3wtHPr7fkxN4kH7Y8+nK0dpE=
X-Google-Smtp-Source: ABdhPJyTgtlMa/FY4BYgSmG+QueEQksq2SsNHvnaTZ6Qb16c/NnH/sOSEBTkceKH1smPl4WBeeh2G3yVzEwjnT6NHgs=
X-Received: by 2002:a05:6512:2036:: with SMTP id s22mr17883193lfs.540.1620187897959;
 Tue, 04 May 2021 21:11:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210429212834.82621-1-jolsa@kernel.org> <YI8WokIxTkZvzVuP@krava>
 <CAEf4BzZjtU1hicc8dK1M9Mqf3wanU2AJFDtZJzUfQdwCsC6cGg@mail.gmail.com>
 <YJFLpAbUiwIu0I4H@krava> <CAEf4BzYz3G4aRWT4YTrnKaVCsE_A2UGGn6jVvqOuK8ZLU-sN8g@mail.gmail.com>
In-Reply-To: <CAEf4BzYz3G4aRWT4YTrnKaVCsE_A2UGGn6jVvqOuK8ZLU-sN8g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 4 May 2021 21:11:26 -0700
Message-ID: <CAADnVQ+V=2qOqkVMaC72uhQKEbC=2uFa80J57xdF_4ffoZHYNQ@mail.gmail.com>
Subject: Re: [PATCH RFC] bpf: Fix trampoline for functions with variable arguments
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
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

On Tue, May 4, 2021 at 3:37 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, May 4, 2021 at 6:27 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Mon, May 03, 2021 at 03:32:34PM -0700, Andrii Nakryiko wrote:
> > > On Sun, May 2, 2021 at 2:17 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > On Thu, Apr 29, 2021 at 11:28:34PM +0200, Jiri Olsa wrote:
> > > > > For functions with variable arguments like:
> > > > >
> > > > >   void set_worker_desc(const char *fmt, ...)
> > > > >
> > > > > the BTF data contains void argument at the end:
> > > > >
> > > > > [4061] FUNC_PROTO '(anon)' ret_type_id=0 vlen=2
> > > > >         'fmt' type_id=3
> > > > >         '(anon)' type_id=0
> > > > >
> > > > > When attaching function with this void argument the btf_distill_func_proto
> > > > > will set last btf_func_model's argument with size 0 and that
> > > > > will cause extra loop in save_regs/restore_regs functions and
> > > > > generate trampoline code like:
> > > > >
> > > > >   55             push   %rbp
> > > > >   48 89 e5       mov    %rsp,%rbp
> > > > >   48 83 ec 10    sub    $0x10,%rsp
> > > > >   53             push   %rbx
> > > > >   48 89 7d f0    mov    %rdi,-0x10(%rbp)
> > > > >   75 f8          jne    0xffffffffa00cf007
> > > > >                  ^^^ extra jump
> > > > >
> > > > > It's causing soft lockups/crashes probably depends on what context
> > > > > is the attached function called, like for set_worker_desc:
> > > > >
> > > > >   watchdog: BUG: soft lockup - CPU#16 stuck for 22s! [kworker/u40:4:239]
> > > > >   CPU: 16 PID: 239 Comm: kworker/u40:4 Not tainted 5.12.0-rc4qemu+ #178
> > > > >   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-1.fc33 04/01/2014
> > > > >   Workqueue: writeback wb_workfn
> > > > >   RIP: 0010:bpf_trampoline_6442464853_0+0xa/0x1000
> > > > >   Code: Unable to access opcode bytes at RIP 0xffffffffa3597fe0.
> > > > >   RSP: 0018:ffffc90000687da8 EFLAGS: 00000217
> > > > >   Call Trace:
> > > > >    set_worker_desc+0x5/0xb0
> > > > >    wb_workfn+0x48/0x4d0
> > > > >    ? psi_group_change+0x41/0x210
> > > > >    ? __bpf_prog_exit+0x15/0x20
> > > > >    ? bpf_trampoline_6442458903_0+0x3b/0x1000
> > > > >    ? update_pasid+0x5/0x90
> > > > >    ? __switch_to+0x187/0x450
> > > > >    process_one_work+0x1e7/0x380
> > > > >    worker_thread+0x50/0x3b0
> > > > >    ? rescuer_thread+0x380/0x380
> > > > >    kthread+0x11b/0x140
> > > > >    ? __kthread_bind_mask+0x60/0x60
> > > > >    ret_from_fork+0x22/0x30
> > > > >
> > > > > This patch is removing the void argument from struct btf_func_model
> > > > > in btf_distill_func_proto, but perhaps we should also check for this
> > > > > in JIT's save_regs/restore_regs functions.
> > > >
> > > > actualy looks like we need to disable functions with variable arguments
> > > > completely, because we don't know how many arguments to save
> > > >
> > > > I tried to disable them in pahole and it's easy fix, will post new fix
> > >
> > > Can we still allow access to fixed arguments for such functions and
> > > just disallow the vararg ones?
> >
> > the problem is that we should save all the registers for arguments,
> > which is probably doable.. but if caller uses more than 6 arguments,
> > we need stack data, which will be wrong because of the extra stack
> > frame we do in bpf trampoline.. so we could crash
> >
> > the patch below prevents to attach these functions directly in kernel,
> > so we could keep these functions in BTF
> >
> > jirka
> >
> >
> > ---
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 0600ed325fa0..f9709dc08c44 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -5213,6 +5213,13 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
> >                                 tname, i, btf_kind_str[BTF_INFO_KIND(t->info)]);
> >                         return -EINVAL;
> >                 }
> > +               if (ret == 0) {
> > +                       bpf_log(log,
> > +                               "The function %s has variable args, it's unsupported.\n",
> > +                               tname);
> > +                       return -EINVAL;
> > +
> > +               }
>
> this will work, but the explicit check for vararg should be `i ==
> nargs - 1 && args[i].type == 0`. Everything else (if it happens) is
> probably a bad BTF data.

Jiri,
could you please resubmit with the check like Andrii suggested?
Thanks!
