Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AED216423
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 04:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgGGCuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 22:50:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51532 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726802AbgGGCuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 22:50:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594090236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yxXlYWxcxG8pWngZ/9z2Sr6gsZr9wcEP+Rkwxu1y7t0=;
        b=JboM26mzhnu8VDRcLJBO2gf6hdaZ4fpoadmlmULj3pafuuPnWPpqPLVlC1fUEqidSWcDdh
        3Pz5MqW0yWmY0v9eusdsP8R0+o1u43qMWH9KOrGNRDHSbTfZVLnVeq1xI5sNe1WPYO6SOi
        maczH3UfOFrQ50iwif7PaaTpJufBKDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-acDzPFKRNsexecKoQ3XNBQ-1; Mon, 06 Jul 2020 22:50:32 -0400
X-MC-Unique: acDzPFKRNsexecKoQ3XNBQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13587EC1A0;
        Tue,  7 Jul 2020 02:50:30 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F40B32B6D6;
        Tue,  7 Jul 2020 02:50:16 +0000 (UTC)
Date:   Mon, 6 Jul 2020 22:50:14 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V9 01/13] audit: collect audit task parameters
Message-ID: <20200707025014.x33eyxbankw2fbww@madcap2.tricolour.ca>
References: <cover.1593198710.git.rgb@redhat.com>
 <6abeb26e64489fc29b00c86b60b501c8b7316424.1593198710.git.rgb@redhat.com>
 <CAHC9VhTx=4879F1MSXg4=Xd1i5rhEtyam6CakQhy=_ZjGtTaMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTx=4879F1MSXg4=Xd1i5rhEtyam6CakQhy=_ZjGtTaMA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-05 11:09, Paul Moore wrote:
> On Sat, Jun 27, 2020 at 9:21 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > The audit-related parameters in struct task_struct should ideally be
> > collected together and accessed through a standard audit API.
> >
> > Collect the existing loginuid, sessionid and audit_context together in a
> > new struct audit_task_info called "audit" in struct task_struct.
> >
> > Use kmem_cache to manage this pool of memory.
> > Un-inline audit_free() to be able to always recover that memory.
> >
> > Please see the upstream github issue
> > https://github.com/linux-audit/audit-kernel/issues/81
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  include/linux/audit.h | 49 +++++++++++++++++++++++------------
> >  include/linux/sched.h |  7 +----
> >  init/init_task.c      |  3 +--
> >  init/main.c           |  2 ++
> >  kernel/audit.c        | 71 +++++++++++++++++++++++++++++++++++++++++++++++++--
> >  kernel/audit.h        |  5 ++++
> >  kernel/auditsc.c      | 26 ++++++++++---------
> >  kernel/fork.c         |  1 -
> >  8 files changed, 124 insertions(+), 40 deletions(-)
> >
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 3fcd9ee49734..c2150415f9df 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -100,6 +100,16 @@ enum audit_nfcfgop {
> >         AUDIT_XT_OP_UNREGISTER,
> >  };
> >
> > +struct audit_task_info {
> > +       kuid_t                  loginuid;
> > +       unsigned int            sessionid;
> > +#ifdef CONFIG_AUDITSYSCALL
> > +       struct audit_context    *ctx;
> > +#endif
> > +};
> > +
> > +extern struct audit_task_info init_struct_audit;
> > +
> >  extern int is_audit_feature_set(int which);
> >
> >  extern int __init audit_register_class(int class, unsigned *list);
> 
> ...
> 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index b62e6aaf28f0..2213ac670386 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -34,7 +34,6 @@
> >  #include <linux/kcsan.h>
> >
> >  /* task_struct member predeclarations (sorted alphabetically): */
> > -struct audit_context;
> >  struct backing_dev_info;
> >  struct bio_list;
> >  struct blk_plug;
> > @@ -946,11 +945,7 @@ struct task_struct {
> >         struct callback_head            *task_works;
> >
> >  #ifdef CONFIG_AUDIT
> > -#ifdef CONFIG_AUDITSYSCALL
> > -       struct audit_context            *audit_context;
> > -#endif
> > -       kuid_t                          loginuid;
> > -       unsigned int                    sessionid;
> > +       struct audit_task_info          *audit;
> >  #endif
> >         struct seccomp                  seccomp;
> 
> In the early days of this patchset we talked a lot about how to handle
> the task_struct and the changes that would be necessary, ultimately
> deciding that encapsulating all of the audit fields into an
> audit_task_info struct.  However, what is puzzling me a bit at this
> moment is why we are only including audit_task_info in task_info by
> reference *and* making it a build time conditional (via CONFIG_AUDIT).
> 
> If audit is enabled at build time it would seem that we are always
> going to allocate an audit_task_info struct, so I have to wonder why
> we don't simply embed it inside the task_info struct (similar to the
> seccomp struct in the snippet above?  Of course the audit_context
> struct needs to remain as is, I'm talking only about the
> task_info/audit_task_info struct.

I agree that including the audit_task_info struct in the struct
task_struct would have been preferred to simplify allocation and free,
but the reason it was included by reference instead was to make the
task_struct size independent of audit so that future changes would not
cause as many kABI challenges.  This first change will cause kABI
challenges regardless, but it was future ones that we were trying to
ease.

Does that match with your recollection?

> Richard, I'm sure you can answer this off the top of your head, but
> I'd have to go digging through the archives to pull out the relevant
> discussions so I figured I would just ask you for a reminder ... ?  I
> imagine it's also possible things have changed a bit since those early
> discussions and the solution we arrived at then no longer makes as
> much sense as it did before.

Agreed, it doesn't make as much sense now as it did when proposed, but
will make more sense in the future depending on when this change gets
accepted upstream.  This is why I wanted this patch to go through as
part of ghak81 at the time the rest of it did so that future kABI issues
would be easier to handle, but that ship has long sailed.  I didn't make
that argument then and I regret it now that I realize and recall some of
the thinking behind the change.  Your reasons at the time were that
contid was the only user of that change but there have been some
CONFIG_AUDIT and CONFIG_AUDITSYSCALL changes since that were related.

> > diff --git a/init/init_task.c b/init/init_task.c
> > index 15089d15010a..92d34c4b7702 100644
> > --- a/init/init_task.c
> > +++ b/init/init_task.c
> > @@ -130,8 +130,7 @@ struct task_struct init_task
> >         .thread_group   = LIST_HEAD_INIT(init_task.thread_group),
> >         .thread_node    = LIST_HEAD_INIT(init_signals.thread_head),
> >  #ifdef CONFIG_AUDIT
> > -       .loginuid       = INVALID_UID,
> > -       .sessionid      = AUDIT_SID_UNSET,
> > +       .audit          = &init_struct_audit,
> >  #endif
> >  #ifdef CONFIG_PERF_EVENTS
> >         .perf_event_mutex = __MUTEX_INITIALIZER(init_task.perf_event_mutex),
> > diff --git a/init/main.c b/init/main.c
> > index 0ead83e86b5a..349470ad7458 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -96,6 +96,7 @@
> >  #include <linux/jump_label.h>
> >  #include <linux/mem_encrypt.h>
> >  #include <linux/kcsan.h>
> > +#include <linux/audit.h>
> >
> >  #include <asm/io.h>
> >  #include <asm/bugs.h>
> > @@ -1028,6 +1029,7 @@ asmlinkage __visible void __init start_kernel(void)
> >         nsfs_init();
> >         cpuset_init();
> >         cgroup_init();
> > +       audit_task_init();
> >         taskstats_init_early();
> >         delayacct_init();
> >
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 8c201f414226..5d8147a29291 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -203,6 +203,73 @@ struct audit_reply {
> >         struct sk_buff *skb;
> >  };
> >
> > +static struct kmem_cache *audit_task_cache;
> > +
> > +void __init audit_task_init(void)
> > +{
> > +       audit_task_cache = kmem_cache_create("audit_task",
> > +                                            sizeof(struct audit_task_info),
> > +                                            0, SLAB_PANIC, NULL);
> > +}
> > +
> > +/**
> > + * audit_alloc - allocate an audit info block for a task
> > + * @tsk: task
> > + *
> > + * Call audit_alloc_syscall to filter on the task information and
> > + * allocate a per-task audit context if necessary.  This is called from
> > + * copy_process, so no lock is needed.
> > + */
> > +int audit_alloc(struct task_struct *tsk)
> > +{
> > +       int ret = 0;
> > +       struct audit_task_info *info;
> > +
> > +       info = kmem_cache_alloc(audit_task_cache, GFP_KERNEL);
> > +       if (!info) {
> > +               ret = -ENOMEM;
> > +               goto out;
> > +       }
> > +       info->loginuid = audit_get_loginuid(current);
> > +       info->sessionid = audit_get_sessionid(current);
> > +       tsk->audit = info;
> > +
> > +       ret = audit_alloc_syscall(tsk);
> > +       if (ret) {
> > +               tsk->audit = NULL;
> > +               kmem_cache_free(audit_task_cache, info);
> > +       }
> > +out:
> > +       return ret;
> > +}
> 
> This is a big nitpick, and I'm only mentioning this in the case you
> need to respin this patchset: the "out" label is unnecessary in the
> function above.  Simply return the error code, there is no need to
> jump to "out" only to immediately return the error code there and
> nothing more.

Agreed.  This must have been due to some restructuring that no longer
needed an exit cleanup action.

> > +struct audit_task_info init_struct_audit = {
> > +       .loginuid = INVALID_UID,
> > +       .sessionid = AUDIT_SID_UNSET,
> > +#ifdef CONFIG_AUDITSYSCALL
> > +       .ctx = NULL,
> > +#endif
> > +};
> > +
> > +/**
> > + * audit_free - free per-task audit info
> > + * @tsk: task whose audit info block to free
> > + *
> > + * Called from copy_process and do_exit
> > + */
> > +void audit_free(struct task_struct *tsk)
> > +{
> > +       struct audit_task_info *info = tsk->audit;
> > +
> > +       audit_free_syscall(tsk);
> > +       /* Freeing the audit_task_info struct must be performed after
> > +        * audit_log_exit() due to need for loginuid and sessionid.
> > +        */
> > +       info = tsk->audit;
> > +       tsk->audit = NULL;
> > +       kmem_cache_free(audit_task_cache, info);
> 
> Another nitpick, and this one may even become a moot point given the
> question posed above.  However, is there any reason we couldn't get
> rid of "info" and simplify this a bit?

That info allocation and assignment does now seem pointless, I agree...

>   audit_free_syscall(tsk);
>   kmem_cache_free(audit_task_cache, tsk->audit);
>   tsk->audit = NULL;
> 
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 468a23390457..f00c1da587ea 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -1612,7 +1615,6 @@ void __audit_free(struct task_struct *tsk)
> >                 if (context->current_state == AUDIT_RECORD_CONTEXT)
> >                         audit_log_exit();
> >         }
> > -
> >         audit_set_context(tsk, NULL);
> >         audit_free_context(context);
> >  }
> 
> This nitpick is barely worth the time it is taking me to write this,
> but the whitespace change above isn't strictly necessary.

Sure, it is a harmless but noisy cleanup when the function was being
cleaned up and renamed.  It wasn't an accident, but a style preference.
Do you prefer a vertical space before cleanup actions at the end of
functions and more versus less vertical whitespace in general?

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

