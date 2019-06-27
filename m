Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7A158EAF
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 01:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfF0Xmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 19:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfF0Xmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 19:42:32 -0400
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EF3A215EA
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 23:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561678951;
        bh=hWtughlITBOh5tkja8r+XhypOwOAqj2fl3jfGmXo4/s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zgJvTaw17GL2SYEp+TykDFdOSV6nNKG+9EAaeBe+xYOF9EMJNH1cnazPCrhhHk21u
         I/UGOuOdemF6GGBZW4z234LLYnSuEQXo1ASivp+jHT2IOV4mn7KxGClm6+ZHqzLjyT
         xuKIIlTJYbI36e7TwDbgt3wrfCXShoA+RaoTAXW8=
Received: by mail-wm1-f50.google.com with SMTP id 207so7289153wma.1
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 16:42:31 -0700 (PDT)
X-Gm-Message-State: APjAAAXzCZtJh7+FBDCuqgkuLt6/Mmtxt5rw6NJE/FQPuKb8avwALEKt
        6Y7z9XyR1n8gbs8ylBg0rNyG6z6iPMlvMvaCs1c0GQ==
X-Google-Smtp-Source: APXvYqydo/EkkwWw46JifGmZVIas020oyT+juMx9ADNvWIR8+gvqMYWe7c3Le9GP8D3T2TjH8kYMLyp1NON3BL5UMkM=
X-Received: by 2002:a1c:9a53:: with SMTP id c80mr4494742wme.173.1561678949978;
 Thu, 27 Jun 2019 16:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
In-Reply-To: <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 27 Jun 2019 16:42:18 -0700
X-Gmail-Original-Message-ID: <CALCETrUp3Tj062wG-noNdsY-sU9gsob_kVK=W_DxWciMpZFvyA@mail.gmail.com>
Message-ID: <CALCETrUp3Tj062wG-noNdsY-sU9gsob_kVK=W_DxWciMpZFvyA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>
Cc:     Song Liu <songliubraving@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>, lmb@cloudflare.com,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[sigh, I finally set up lore nntp, and I goofed some addresses.  Hi
Kees and linux-api.]

On Thu, Jun 27, 2019 at 4:40 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On 6/27/19 1:19 PM, Song Liu wrote:
> > This patch introduce unprivileged BPF access. The access control is
> > achieved via device /dev/bpf. Users with write access to /dev/bpf are able
> > to call sys_bpf().
> >
> > Two ioctl command are added to /dev/bpf:
> >
> > The two commands enable/disable permission to call sys_bpf() for current
> > task. This permission is noted by bpf_permitted in task_struct. This
> > permission is inherited during clone(CLONE_THREAD).
> >
> > Helper function bpf_capable() is added to check whether the task has got
> > permission via /dev/bpf.
> >
>
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 0e079b2298f8..79dc4d641cf3 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -9134,7 +9134,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
> >               env->insn_aux_data[i].orig_idx = i;
> >       env->prog = *prog;
> >       env->ops = bpf_verifier_ops[env->prog->type];
> > -     is_priv = capable(CAP_SYS_ADMIN);
> > +     is_priv = bpf_capable(CAP_SYS_ADMIN);
>
> Huh?  This isn't a hardening measure -- the "is_priv" verifier mode
> allows straight-up leaks of private kernel state to user mode.
>
> (For that matter, the pending lockdown stuff should possibly consider
> this a "confidentiality" issue.)
>
>
> I have a bigger issue with this patch, though: it's a really awkward way
> to pretend to have capabilities.  For bpf, it seems like you could make
> this be a *real* capability without too much pain since there's only one
> syscall there.  Just find a way to pass an fd to /dev/bpf into the
> syscall.  If this means you need a new bpf_with_cap() syscall that takes
> an extra argument, so be it.  The old bpf() syscall can just translate
> to bpf_with_cap(..., -1).
>
> For a while, I've considered a scheme I call "implicit rights".  There
> would be a directory in /dev called /dev/implicit_rights.  This would
> either be part of devtmpfs or a whole new filesystem -- it would *not*
> be any other filesystem.  The contents would be files that can't be read
> or written and exist only in memory.  You create them with a privileged
> syscall.  Certain actions that are sensitive but not at the level of
> CAP_SYS_ADMIN (use of large-attack-surface bpf stuff, creation of user
> namespaces, profiling the kernel, etc) could require an "implicit
> right".  When you do them, if you don't have CAP_SYS_ADMIN, the kernel
> would do a path walk for, say, /dev/implicit_rights/bpf and, if the
> object exists, can be opened, and actually refers to the "bpf" rights
> object, then the action is allowed.  Otherwise it's denied.
>
> This is extensible, and it doesn't require the rather ugly per-task
> state of whether it's enabled.
>
> For things like creation of user namespaces, there's an existing API,
> and the default is that it works without privilege.  Switching it to an
> implicit right has the benefit of not requiring code changes to programs
> that already work as non-root.
>
> But, for BPF in particular, this type of compatibility issue doesn't
> exist now.  You already can't use most eBPF functionality without
> privilege.  New bpf-using programs meant to run without privilege are
> *new*, so they can use a new improved API.  So, rather than adding this
> obnoxious ioctl, just make the API explicit, please.
>
> Also, please cc: linux-abi next time.
