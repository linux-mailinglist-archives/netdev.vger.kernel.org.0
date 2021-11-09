Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2C044B20A
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 18:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241163AbhKIRha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 12:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241098AbhKIRh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 12:37:27 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E211FC061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 09:34:40 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id e65so19139965pgc.5
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 09:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YtCMrd8soCJwqQdYqfS1Uxj+jvIWsqJW9Sfp+I5znK0=;
        b=RnI334WgYGo1s2xg0PnNwh/LwyjwkbeECYSptgpgWOUMErGKHmsDK/ZLGV9pEMwl/O
         ekYV7g3Qyj7iroFAawbog28LZq8j9E8ozPsy6LbXEeNYDfaWne0pF0iY2RKw20oFgoi+
         iUWeYVTxBO9NJJ4Hp1KyWtYKI60Ou3f9tZSZ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YtCMrd8soCJwqQdYqfS1Uxj+jvIWsqJW9Sfp+I5znK0=;
        b=ufafAb8AvmJJp94kik4N1jOpHYhCv2S2zfGkvVXN3VucKo5UJwTSN0mp8ENPKN5N88
         yxPErXlrmHska0wQI0J+/7gyMcrEwYEHX6KLViY+rY82PYeimFnTAwSlLFwR1uvcG3Ll
         0OEgmDTzgWDo/zwitgNIfQ6NOut41at3x0nffob3O1q7wQjRLKM2TO5yxqfcftOMPxyL
         DRQhPbPpCXMsmWLj/CUlBy7cHumBUyUJRBm01p2z2xPfWoyLODylgmH4v+815yLGGcyi
         twmsX5zmvs1HQVYT6ItySfD4NWLeNfohI2XRIWv/qb9YhXdXYrmz2eAAhrUcRBzIcOtJ
         wByQ==
X-Gm-Message-State: AOAM532S6xlcTf1aznMX4tR4gADeD1/L8l5ctL9bTrobgWOK60sywGu+
        4IOsqprvgyl/m9Xald+R+40k4A==
X-Google-Smtp-Source: ABdhPJzSUauLeZJaFQUg6w2y5hqN0XLLDLzRlcMe5/CcpZD5KWsYDIDxVT3fGawLe51+TwjHa4Pryg==
X-Received: by 2002:a63:e710:: with SMTP id b16mr7200956pgi.38.1636479280328;
        Tue, 09 Nov 2021 09:34:40 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q9sm20769593pfj.88.2021.11.09.09.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 09:34:39 -0800 (PST)
Date:   Tue, 9 Nov 2021 09:34:39 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Petr Mladek <pmladek@suse.com>,
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
Message-ID: <202111090930.75BBF4678@keescook>
References: <20211108084142.4692-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108084142.4692-1-laoar.shao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 08:41:42AM +0000, Yafang Shao wrote:
> When I was implementing a new per-cpu kthread cfs_migration, I found the
> comm of it "cfs_migration/%u" is truncated due to the limitation of
> TASK_COMM_LEN. For example, the comm of the percpu thread on CPU10~19 are
> all with the same name "cfs_migration/1", which will confuse the user. This
> issue is not critical, because we can get the corresponding CPU from the
> task's Cpus_allowed. But for kthreads correspoinding to other hardware
> devices, it is not easy to get the detailed device info from task comm,
> for example,
> 
>     jbd2/nvme0n1p2-
>     xfs-reclaim/sdf
> 
> Currently there are so many truncated kthreads:
> 
>     rcu_tasks_kthre
>     rcu_tasks_rude_
>     rcu_tasks_trace
>     poll_mpt3sas0_s
>     ext4-rsv-conver
>     xfs-reclaim/sd{a, b, c, ...}
>     xfs-blockgc/sd{a, b, c, ...}
>     xfs-inodegc/sd{a, b, c, ...}
>     audit_send_repl
>     ecryptfs-kthrea
>     vfio-irqfd-clea
>     jbd2/nvme0n1p2-
>     ...
> 
> We can shorten these names to work around this problem, but it may be
> not applied to all of the truncated kthreads. Take 'jbd2/nvme0n1p2-' for
> example, it is a nice name, and it is not a good idea to shorten it.
> 
> One possible way to fix this issue is extending the task comm size, but
> as task->comm is used in lots of places, that may cause some potential
> buffer overflows. Another more conservative approach is introducing a new
> pointer to store kthread's full name if it is truncated, which won't
> introduce too much overhead as it is in the non-critical path. Finally we
> make a dicision to use the second approach. See also the discussions in
> this thread:
> https://lore.kernel.org/lkml/20211101060419.4682-1-laoar.shao@gmail.com/
> 
> After this change, the full name of these truncated kthreads will be
> displayed via /proc/[pid]/comm:
> 
>     rcu_tasks_kthread
>     rcu_tasks_rude_kthread
>     rcu_tasks_trace_kthread
>     poll_mpt3sas0_statu
>     ext4-rsv-conversion
>     xfs-reclaim/sdf1
>     xfs-blockgc/sdf1
>     xfs-inodegc/sdf1
>     audit_send_reply
>     ecryptfs-kthread
>     vfio-irqfd-cleanup
>     jbd2/nvme0n1p2-8
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Petr Mladek <pmladek@suse.com>
> ---
> TODO: will cleanup worker comm in the next step. 
> 
> ---
>  fs/proc/array.c         |  3 +++
>  include/linux/kthread.h |  1 +
>  kernel/kthread.c        | 32 +++++++++++++++++++++++++++++++-
>  3 files changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 49be8c8ef555..860e4deafa65 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -92,6 +92,7 @@
>  #include <linux/string_helpers.h>
>  #include <linux/user_namespace.h>
>  #include <linux/fs_struct.h>
> +#include <linux/kthread.h>
>  
>  #include <asm/processor.h>
>  #include "internal.h"
> @@ -102,6 +103,8 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
>  
>  	if (p->flags & PF_WQ_WORKER)
>  		wq_worker_comm(tcomm, sizeof(tcomm), p);
> +	else if (p->flags & PF_KTHREAD)
> +		get_kthread_comm(tcomm, sizeof(tcomm), p);
>  	else
>  		__get_task_comm(tcomm, sizeof(tcomm), p);
>  
> diff --git a/include/linux/kthread.h b/include/linux/kthread.h
> index 346b0f269161..2a5c04494663 100644
> --- a/include/linux/kthread.h
> +++ b/include/linux/kthread.h
> @@ -33,6 +33,7 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
>  					  unsigned int cpu,
>  					  const char *namefmt);
>  
> +void get_kthread_comm(char *buf, size_t buf_size, struct task_struct *tsk);
>  void set_kthread_struct(struct task_struct *p);
>  
>  void kthread_set_per_cpu(struct task_struct *k, int cpu);
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 5b37a8567168..ce8258231eea 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -60,6 +60,8 @@ struct kthread {
>  #ifdef CONFIG_BLK_CGROUP
>  	struct cgroup_subsys_state *blkcg_css;
>  #endif
> +	/* To store the full name if task comm is truncated. */
> +	char *full_name;
>  };
>  
>  enum KTHREAD_BITS {
> @@ -93,6 +95,18 @@ static inline struct kthread *__to_kthread(struct task_struct *p)
>  	return kthread;
>  }
>  
> +void get_kthread_comm(char *buf, size_t buf_size, struct task_struct *tsk)
> +{
> +	struct kthread *kthread = to_kthread(tsk);
> +
> +	if (!kthread || !kthread->full_name) {
> +		__get_task_comm(buf, buf_size, tsk);
> +		return;
> +	}
> +
> +	strscpy_pad(buf, kthread->full_name, buf_size);
> +}
> +
>  void set_kthread_struct(struct task_struct *p)
>  {
>  	struct kthread *kthread;
> @@ -121,6 +135,7 @@ void free_kthread_struct(struct task_struct *k)
>  #ifdef CONFIG_BLK_CGROUP
>  	WARN_ON_ONCE(kthread && kthread->blkcg_css);
>  #endif
> +	kfree(kthread->full_name);
>  	kfree(kthread);
>  }
>  
> @@ -399,12 +414,27 @@ struct task_struct *__kthread_create_on_node(int (*threadfn)(void *data),
>  	if (!IS_ERR(task)) {
>  		static const struct sched_param param = { .sched_priority = 0 };
>  		char name[TASK_COMM_LEN];
> +		va_list aq;
> +		int len;
>  
>  		/*
>  		 * task is already visible to other tasks, so updating
>  		 * COMM must be protected.
>  		 */
> -		vsnprintf(name, sizeof(name), namefmt, args);
> +		va_copy(aq, args);
> +		len = vsnprintf(name, sizeof(name), namefmt, aq);
> +		va_end(aq);
> +		if (len >= TASK_COMM_LEN) {
> +			struct kthread *kthread = to_kthread(task);
> +			char *full_name;
> +
> +			full_name = kvasprintf(GFP_KERNEL, namefmt, args);
> +			if (!full_name) {
> +				kfree(create);
> +				return ERR_PTR(-ENOMEM);

I'm not a fan of this out-of-line free/return. Why not just leave it
truncated when out of memory? For example just do:

			struct kthread *kthread = to_kthread(task);

			kthread->full_name = kvasprintf(GFP_KERNEL, namefmt, args);

> +			}
> +			kthread->full_name = full_name;
> +		}
>  		set_task_comm(task, name);
>  		/*
>  		 * root may have changed our (kthreadd's) priority or CPU mask.
> -- 
> 2.17.1
> 

-- 
Kees Cook
