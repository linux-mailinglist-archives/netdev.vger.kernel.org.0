Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764E32F21DE
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbhAKVgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:36:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbhAKVgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 16:36:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBD6922D07
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 21:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610400956;
        bh=x27HDn56BBd7xtw8Y4u+duMMPb+kznDGfTPxdKkdPWc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RlXW49NaFQIkHt4dCWDn1UqS36e9nMdJcSf1Wlyi2c1m1St6bIH+It2McCPP4V74J
         vCJsj7Cbui021n20zTccENm0/dRXV3CR3bd1nxPIqG2zVJPgMQ8St3ezUlM9cd8dPD
         q1RHDfuD6FMset6PYR3FYDveKUJtD9z300eUepzN0ikrOkqakhHYmL7ZvedFgHwqVx
         b5rQbv2SucmbytcEte2xQvGjO2YaVDGGJCJPbwZN3j0McGU6/YkEN3Ad/YcHqUBtsR
         h/sj3KJ/uKKQTIvmaRjX2b6YPmmZbq/NGxo5p5VR0lO712R/Wb2MlJ/CVoM4t/wVYr
         1krerSKlEr9ew==
Received: by mail-lf1-f42.google.com with SMTP id a12so172887lfl.6
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 13:35:55 -0800 (PST)
X-Gm-Message-State: AOAM5339CtE40+V3FnI3CV5YHoaZ51Lpkdk2zE748F1ajJkp4F6iDAUM
        90MWLMtHe1eFI5yDrdmaSS+LQNYtw/EZe9ky3SiAWg==
X-Google-Smtp-Source: ABdhPJyjni5eTF+BjvSxFM1gXtkK2UXV0owT8rRm5BtWhjff76/B2xIYziUinr1cE2NrO2mODZc4HmxAu3Wxf0BfvoQ=
X-Received: by 2002:a05:6512:398e:: with SMTP id j14mr683024lfu.9.1610400953864;
 Mon, 11 Jan 2021 13:35:53 -0800 (PST)
MIME-Version: 1.0
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com> <20210111185650.hsvfpoqmqc2mj7ci@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210111185650.hsvfpoqmqc2mj7ci@kafai-mbp.dhcp.thefacebook.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 11 Jan 2021 22:35:43 +0100
X-Gmail-Original-Message-ID: <CACYkzJ4mQrx1=owwrgBtu1Nvy9t0W4qP4=dthEutKpWPHxHrBw@mail.gmail.com>
Message-ID: <CACYkzJ4mQrx1=owwrgBtu1Nvy9t0W4qP4=dthEutKpWPHxHrBw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing programs
To:     Martin KaFai Lau <kafai@fb.com>
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

On Mon, Jan 11, 2021 at 7:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Jan 08, 2021 at 03:19:47PM -0800, Song Liu wrote:
>
> [ ... ]
>
> > diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
> > index dd5aedee99e73..9bd47ad2b26f1 100644
> > --- a/kernel/bpf/bpf_local_storage.c
> > +++ b/kernel/bpf/bpf_local_storage.c
> > @@ -140,17 +140,18 @@ static void __bpf_selem_unlink_storage(struct bpf_local_storage_elem *selem)
> >  {
> >       struct bpf_local_storage *local_storage;
> >       bool free_local_storage = false;
> > +     unsigned long flags;
> >
> >       if (unlikely(!selem_linked_to_storage(selem)))
> >               /* selem has already been unlinked from sk */
> >               return;
> >
> >       local_storage = rcu_dereference(selem->local_storage);
> > -     raw_spin_lock_bh(&local_storage->lock);
> > +     raw_spin_lock_irqsave(&local_storage->lock, flags);
> It will be useful to have a few words in commit message on this change
> for future reference purpose.
>
> Please also remove the in_irq() check from bpf_sk_storage.c
> to avoid confusion in the future.  It probably should
> be in a separate patch.
>
> [ ... ]
>
> > diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
> > index 4ef1959a78f27..f654b56907b69 100644
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 7425b3224891d..3d65c8ebfd594 100644
> [ ... ]
>
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -96,6 +96,7 @@
> >  #include <linux/kasan.h>
> >  #include <linux/scs.h>
> >  #include <linux/io_uring.h>
> > +#include <linux/bpf.h>
> >
> >  #include <asm/pgalloc.h>
> >  #include <linux/uaccess.h>
> > @@ -734,6 +735,7 @@ void __put_task_struct(struct task_struct *tsk)
> >       cgroup_free(tsk);
> >       task_numa_free(tsk, true);
> >       security_task_free(tsk);
> > +     bpf_task_storage_free(tsk);
> >       exit_creds(tsk);
> If exit_creds() is traced by a bpf and this bpf is doing
> bpf_task_storage_get(..., BPF_LOCAL_STORAGE_GET_F_CREATE),
> new task storage will be created after bpf_task_storage_free().
>
> I recalled there was an earlier discussion with KP and KP mentioned
> BPF_LSM will not be called with a task that is going away.
> It seems enabling bpf task storage in bpf tracing will break
> this assumption and needs to be addressed?

For tracing programs, I think we will need an allow list where
task local storage can be used.
