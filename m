Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1DF43D271
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243944AbhJ0UNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:13:41 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:49226 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243917AbhJ0UNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:13:22 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 58FB51FD3D;
        Wed, 27 Oct 2021 20:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635365453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hW3UyAAqPRUl0z16nqyHfbiF0xI1dmNAdSdUTNu03Zk=;
        b=Ug1WIxJfxXX71Y2crVlfwZij9ycoD7jFrvvYrRhlcKGq6/XKBfMVPvnQNsg4w5IX0Xl4f3
        lshS7w512IK/QUcRi8V4QC9g25SmmuGDf473cZpqGHYIB1MyUcSsrAOJKGGLngr6Tv77cK
        MkkXnJvG+M/1ktmedNiHywPCvdZ6KSU=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 31FD9A3B84;
        Wed, 27 Oct 2021 20:10:52 +0000 (UTC)
Date:   Wed, 27 Oct 2021 22:10:49 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        arnaldo.melo@gmail.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH v6 12/12] kernel/kthread: show a warning if kthread's
 comm is truncated
Message-ID: <YXmySeDsxxbA7hcq@alley>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
 <20211025083315.4752-13-laoar.shao@gmail.com>
 <202110251431.F594652F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202110251431.F594652F@keescook>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 2021-10-25 14:35:42, Kees Cook wrote:
> On Mon, Oct 25, 2021 at 08:33:15AM +0000, Yafang Shao wrote:
> > Show a warning if task comm is truncated. Below is the result
> > of my test case:
> > 
> > truncated kthread comm:I-am-a-kthread-with-lon, pid:14 by 6 characters
> > 
> > Suggested-by: Petr Mladek <pmladek@suse.com>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Petr Mladek <pmladek@suse.com>
> > ---
> >  kernel/kthread.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > index 5b37a8567168..46b924c92078 100644
> > --- a/kernel/kthread.c
> > +++ b/kernel/kthread.c
> > @@ -399,12 +399,17 @@ struct task_struct *__kthread_create_on_node(int (*threadfn)(void *data),
> >  	if (!IS_ERR(task)) {
> >  		static const struct sched_param param = { .sched_priority = 0 };
> >  		char name[TASK_COMM_LEN];
> > +		int len;
> >  
> >  		/*
> >  		 * task is already visible to other tasks, so updating
> >  		 * COMM must be protected.
> >  		 */
> > -		vsnprintf(name, sizeof(name), namefmt, args);
> > +		len = vsnprintf(name, sizeof(name), namefmt, args);
> > +		if (len >= TASK_COMM_LEN) {
> 
> And since this failure case is slow-path, we could improve the warning
> as other had kind of suggested earlier with something like this instead:
> 
> 			char *full_comm;
> 
> 			full_comm = kvasprintf(GFP_KERNEL, namefmt, args);

You need to use va_copy()/va_end() if you want to use the same va_args
twice.

For example, see how kvasprintf() is implemented. It calls
vsnprintf() twice and it uses va_copy()/va_end() around the the first call.

kvasprintf() could also return NULL if there is not enough memory.

> 			pr_warn("truncated kthread comm '%s' to '%s' (pid:%d)\n",
> 				full_comm, name);

BTW: Is this message printed during normal boot? I did not tried the
patchset myself.

We should add this warning only if there is a good solution how to
avoid the truncated names. And we should me sure that the most common
kthreads/workqueues do not trigger it. It would be ugly to print many
warnings during boot if people could not get rid of them easily.

> 			kfree(full_comm);
> 		}
> >  		set_task_comm(task, name);
> >  		/*
> >  		 * root may have changed our (kthreadd's) priority or CPU mask.

Best Regards,
Petr
