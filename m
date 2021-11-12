Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A0D44EAD4
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhKLPuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:50:32 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:56702 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbhKLPub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:50:31 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id CF28A21979;
        Fri, 12 Nov 2021 15:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636732058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uGTkQenqxNe1pOZpE8fthF8UArXVjXhpTme9YoO3BrY=;
        b=TP/SqoxeG3DGfdEiqEnfvbSoxxC7sqL8jIO2bhX+ehJJK+Z/vVQ0+YA1U7VOUcIBMdsemI
        JNMnWc9H+MU51AmbpIlO2PHcJ8DXUFcZ0eSoEe9R6U/v5IH+JZxNOEonD8/IxCdhhlNRvp
        jlPMpSYfcdEa2kro/w6I0grNg4ObEpY=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8FC2CA3B81;
        Fri, 12 Nov 2021 15:47:38 +0000 (UTC)
Date:   Fri, 12 Nov 2021 16:47:38 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] kthread: dynamically allocate memory to store kthread's
 full name
Message-ID: <YY6MmmoDlkw+oZvA@alley>
References: <20211108084142.4692-1-laoar.shao@gmail.com>
 <202111090930.75BBF4678@keescook>
 <CALOAHbCo9_qYHQOa4KbXeQgVOmyEqOOXbY7j_p+u4ZaSUjWnFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbCo9_qYHQOa4KbXeQgVOmyEqOOXbY7j_p+u4ZaSUjWnFA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2021-11-10 10:12:17, Yafang Shao wrote:
> On Wed, Nov 10, 2021 at 1:34 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Mon, Nov 08, 2021 at 08:41:42AM +0000, Yafang Shao wrote:
> > > When I was implementing a new per-cpu kthread cfs_migration, I found the
> > > comm of it "cfs_migration/%u" is truncated due to the limitation of
> > > TASK_COMM_LEN. For example, the comm of the percpu thread on CPU10~19 are
> > > all with the same name "cfs_migration/1", which will confuse the user. This
> > > issue is not critical, because we can get the corresponding CPU from the
> > > task's Cpus_allowed. But for kthreads correspoinding to other hardware
> > > devices, it is not easy to get the detailed device info from task comm,
> > > for example,
> > >
> > > After this change, the full name of these truncated kthreads will be
> > > displayed via /proc/[pid]/comm:
> > >
> > > --- a/kernel/kthread.c
> > > +++ b/kernel/kthread.c
> > > @@ -399,12 +414,27 @@ struct task_struct *__kthread_create_on_node(int (*threadfn)(void *data),
> > >       if (!IS_ERR(task)) {
> > >               static const struct sched_param param = { .sched_priority = 0 };
> > >               char name[TASK_COMM_LEN];
> > > +             va_list aq;
> > > +             int len;
> > >
> > >               /*
> > >                * task is already visible to other tasks, so updating
> > >                * COMM must be protected.
> > >                */
> > > -             vsnprintf(name, sizeof(name), namefmt, args);
> > > +             va_copy(aq, args);
> > > +             len = vsnprintf(name, sizeof(name), namefmt, aq);
> > > +             va_end(aq);
> > > +             if (len >= TASK_COMM_LEN) {
> > > +                     struct kthread *kthread = to_kthread(task);
> > > +                     char *full_name;
> > > +
> > > +                     full_name = kvasprintf(GFP_KERNEL, namefmt, args);
> > > +                     if (!full_name) {
> > > +                             kfree(create);
> > > +                             return ERR_PTR(-ENOMEM);
> >
> > I'm not a fan of this out-of-line free/return. Why not just leave it
> > truncated when out of memory? For example just do:
> >
> >                         struct kthread *kthread = to_kthread(task);
> >
> >                         kthread->full_name = kvasprintf(GFP_KERNEL, namefmt, args);

> It is OK for me.

I agree. It is perfectly fine to continue here. The truncated name is
a reasonable fallback.


> I will do it as you suggested and show a warning for this case.

Yup. Just please, use only the truncated name in the warning. It is
not important enough to add another va_copy() for this.

> >
> > > +                     }
> > > +                     kthread->full_name = full_name;
> > > +             }
> > >               set_task_comm(task, name);
> > >               /*
> > >                * root may have changed our (kthreadd's) priority or CPU mask.

Best Regards,
Petr
