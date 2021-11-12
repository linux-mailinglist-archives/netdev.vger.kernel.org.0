Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A222C44EA29
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbhKLPh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:37:26 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:35168 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbhKLPhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:37:25 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B0C631FD3D;
        Fri, 12 Nov 2021 15:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636731273; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u2sbpI/plwivBXzGwyojuYWpzjgBzhbo5rCRsZexXDo=;
        b=J/RTt8c++HduhLkKS5rLA4+TiIwxyYV10ziRyMv+dozhao5sHlKMoBS9gf6Cs/sHn7rcGo
        Ef4aSmlfrpSgaeHtAODLG9J4Us2ZnXt6tLKE3n1UGZhSKA35lwosCHstCh4qsx27IZt1rJ
        dDnw20mLk5aN5UF7wVKNIOQ7ZVy5xUg=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 17FCBA3B81;
        Fri, 12 Nov 2021 15:34:33 +0000 (UTC)
Date:   Fri, 12 Nov 2021 16:34:29 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] kthread: dynamically allocate memory to store kthread's
 full name
Message-ID: <YY6JhZK/oiLUwHyZ@alley>
References: <20211108084142.4692-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108084142.4692-1-laoar.shao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 2021-11-08 08:41:42, Yafang Shao wrote:
> When I was implementing a new per-cpu kthread cfs_migration, I found the
> comm of it "cfs_migration/%u" is truncated due to the limitation of
> TASK_COMM_LEN. For example, the comm of the percpu thread on CPU10~19 are
> all with the same name "cfs_migration/1", which will confuse the user. This
> issue is not critical, because we can get the corresponding CPU from the
> task's Cpus_allowed. But for kthreads correspoinding to other hardware
> devices, it is not easy to get the detailed device info from task comm,
> for example,
> 
> After this change, the full name of these truncated kthreads will be
> displayed via /proc/[pid]/comm:
> 
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -102,6 +103,8 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
>  
>  	if (p->flags & PF_WQ_WORKER)
>  		wq_worker_comm(tcomm, sizeof(tcomm), p);

Just for record. I though that this patch obsoleted wq_worker_comm()
but it did not. wq_worker_comm() returns different values
depending on the last proceed work item and has to stay.

> +	else if (p->flags & PF_KTHREAD)
> +		get_kthread_comm(tcomm, sizeof(tcomm), p);
>  	else
>  		__get_task_comm(tcomm, sizeof(tcomm), p);
>  
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -121,6 +135,7 @@ void free_kthread_struct(struct task_struct *k)

Hmm, there is the following comment:

	/*
	 * Can be NULL if this kthread was created by kernel_thread()
	 * or if kmalloc() in kthread() failed.
	 */
	kthread = to_kthread(k);

And indeed, set_kthread_struct() is called only by kthread()
and init_idle().

For example, call_usermodehelper_exec_sync() calls kernel_thread()
but given @fn does not call set_kthread_struct(). Also init_idle()
continues even when the allocation failed.


>  #ifdef CONFIG_BLK_CGROUP
>  	WARN_ON_ONCE(kthread && kthread->blkcg_css);
>  #endif
> +	kfree(kthread->full_name);

Hence, we have to make sure that it is not NULL here. I suggest
something like:

void free_kthread_struct(struct task_struct *k)
{
	struct kthread *kthread;

	/*
	 * Can be NULL if this kthread was created by kernel_thread()
	 * or if kmalloc() in kthread() failed.
	 */
	kthread = to_kthread(k);
	if (!kthread)
		return;

#ifdef CONFIG_BLK_CGROUP
	WARN_ON_ONCE(kthread->blkcg_css);
#endif
	kfree(kthread->full_name);
	kfree(kthread);
}


Side note: The possible NULL pointer looks dangerous to
    me. to_kthread() is dereferenced without any check on
    several locations.

    For example, kthread_create_on_cpu() looks safe. It is a kthread
    crated by kthread(). It will exists only when the allocation
    succeeded.

    kthread_stop() is probably safe only because it used only for
    the classic kthreads created by kthread(). But the API
    is not safe.

    kthread_use_mm() is probably used only by classic kthreads as
    well. But it is less clear to me.

    All this unsafe APIs looks like a ticking bomb to me. But
    it is beyond this patchset.


>  	kfree(kthread);
>  }
>  

Best Regards,
Petr
