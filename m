Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4D02F0FE9
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 11:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbhAKKSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 05:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728877AbhAKKSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 05:18:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE5B9229C4
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610360275;
        bh=jWFDugK4pflbSyLGsa3mIPsmVN/Rix2+PjepD852jR4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E+xGVIMkOIJq28Y1lONrG1CNnYXc7k5RGQnw9EDxHH6upy9B1TP35BAykPba+znGO
         nPc8cQKTH53Te5RXez4p20/0DMcPuYVKPFEXDNeoIgSDyBEfPiRDpVFp2YuTQmOvGI
         X0Mutem5HFhu64JF5t/t2RpL6OJ668hEaJyrmno8alOeNdPJ+kbYKaC0s4JBSZKBFX
         6uppxhgqmZ5RNGWtJTEqVdXSZvlIvAP9Gc/uI/6tDXA+1/skcp4+D3rdJq8Bzme6Tn
         hc+QGlj9aeU2+H0AFeX6JX4VgSPMbWzZZxhj7RT63r6n635BPQ4QU6RnkJ3Gll7eXZ
         muOlXY2mQDq7g==
Received: by mail-lf1-f45.google.com with SMTP id a12so36968111lfl.6
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 02:17:54 -0800 (PST)
X-Gm-Message-State: AOAM531uJ043rrSTw17jWPt9rbK+tZbYeXBE2mCS8bNIS02hrZf2uraw
        d5mtnXZ39E8W4ztArSir28UdaVFfwGwZr/64ItMVYQ==
X-Google-Smtp-Source: ABdhPJxU99GB15WaFlWsxsv4T/qPAQfe1HbJUHUoK89qj2NGpbl3M7j6mPnIswj00mxsFmV9OFpMlbmgiJH2jqmjgzM=
X-Received: by 2002:a19:cbd8:: with SMTP id b207mr6689822lfg.550.1610360273029;
 Mon, 11 Jan 2021 02:17:53 -0800 (PST)
MIME-Version: 1.0
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com> <733ebec6-e4b0-0913-0483-c79338d03798@fb.com>
In-Reply-To: <733ebec6-e4b0-0913-0483-c79338d03798@fb.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 11 Jan 2021 11:17:42 +0100
X-Gmail-Original-Message-ID: <CACYkzJ7eJa7C8=eRL3XoRjmccgD0udoyoi38MOjo7H0rsnZOYA@mail.gmail.com>
Message-ID: <CACYkzJ7eJa7C8=eRL3XoRjmccgD0udoyoi38MOjo7H0rsnZOYA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing programs
To:     Yonghong Song <yhs@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 7:27 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/8/21 3:19 PM, Song Liu wrote:
> > To access per-task data, BPF program typically creates a hash table with
> > pid as the key. This is not ideal because:
> >   1. The use need to estimate requires size of the hash table, with may be
> >      inaccurate;
> >   2. Big hash tables are slow;
> >   3. To clean up the data properly during task terminations, the user need
> >      to write code.
> >
> > Task local storage overcomes these issues and becomes a better option for
> > these per-task data. Task local storage is only available to BPF_LSM. Now
> > enable it for tracing programs.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> > ---

[...]

> >   struct cfs_rq;
> >   struct fs_struct;
> > @@ -1348,6 +1349,10 @@ struct task_struct {
> >       /* Used by LSM modules for access restriction: */
> >       void                            *security;
> >   #endif
> > +#ifdef CONFIG_BPF_SYSCALL
> > +     /* Used by BPF task local storage */
> > +     struct bpf_local_storage        *bpf_storage;
> > +#endif
>
> I remembered there is a discussion where KP initially wanted to put
> bpf_local_storage in task_struct, but later on changed to
> use in lsm as his use case mostly for lsm. Did anybody
> remember the details of the discussion? Just want to be
> sure what is the concern people has with putting bpf_local_storage
> in task_struct and whether the use case presented by
> Song will justify it.
>

If I recall correctly, the discussion was about inode local storage and
it was decided to use the security blob since the use-case was only LSM
programs. Since we now plan to use it in tracing,
detangling the dependency from CONFIG_BPF_LSM
sounds logical to me.


> >
> >   #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> >       unsigned long                   lowest_stack;
> > diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> > index d1249340fd6ba..ca995fdfa45e7 100644
> > --- a/kernel/bpf/Makefile
> > +++ b/kernel/bpf/Makefile
> > @@ -8,9 +8,8 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
> >
> >   obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
> >   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
> > -obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
> > +obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o bpf_task_storage.o
> >   obj-${CONFIG_BPF_LSM}         += bpf_inode_storage.o
> > -obj-${CONFIG_BPF_LSM}          += bpf_task_storage.o
> >   obj-$(CONFIG_BPF_SYSCALL) += disasm.o
> >   obj-$(CONFIG_BPF_JIT) += trampoline.o
> >   obj-$(CONFIG_BPF_SYSCALL) += btf.o
> [...]
