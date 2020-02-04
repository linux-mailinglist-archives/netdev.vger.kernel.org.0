Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074C715227D
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 23:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgBDWwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 17:52:13 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28015 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727412AbgBDWwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 17:52:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580856731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mAk9PIDEwQN/Tk+J2ltKRbftz9YUG6qGLAqy6dUvBcA=;
        b=T1ed8xxmKPMIn23wGP9nQ0NqGVycB8oPPLwq88A43IA1HHfggZVt884Pe5BmZpjXClCBTI
        JNsR5X0HOQH5BWSiToi7iY2MOy8uqD3XYEoJea31ZgtjjyYeINLZWbCky4GhOTWvqiA3gr
        oQTRtDUcZIaVZEvecWkZRRo60+w9fSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-Cf9dmZscP9qi_MByakE-8g-1; Tue, 04 Feb 2020 17:52:06 -0500
X-MC-Unique: Cf9dmZscP9qi_MByakE-8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 841DA1415;
        Tue,  4 Feb 2020 22:52:04 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C25D5C28D;
        Tue,  4 Feb 2020 22:51:51 +0000 (UTC)
Date:   Tue, 4 Feb 2020 17:51:48 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Subject: Re: [PATCH ghak90 V8 04/16] audit: convert to contid list to check
 for orch/engine ownership
Message-ID: <20200204225148.io3ayosk4efz2qii@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <a911acf0b209c05dc156fb6b57f9da45778747ce.1577736799.git.rgb@redhat.com>
 <CAHC9VhRRW2fFcgBs-R_BZ7ZWCP5wsXA9DB1RUM=QeKj2xZkS2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRRW2fFcgBs-R_BZ7ZWCP5wsXA9DB1RUM=QeKj2xZkS2Q@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-22 16:28, Paul Moore wrote:
> On Tue, Dec 31, 2019 at 2:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Store the audit container identifier in a refcounted kernel object that
> > is added to the master list of audit container identifiers.  This will
> > allow multiple container orchestrators/engines to work on the same
> > machine without danger of inadvertantly re-using an existing identifier.
> > It will also allow an orchestrator to inject a process into an existing
> > container by checking if the original container owner is the one
> > injecting the task.  A hash table list is used to optimize searches.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h | 14 ++++++--
> >  kernel/audit.c        | 98 ++++++++++++++++++++++++++++++++++++++++++++++++---
> >  kernel/audit.h        |  8 +++++
> >  3 files changed, 112 insertions(+), 8 deletions(-)
> 
> ...
> 
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index a045b34ecf44..0e6dbe943ae4 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -94,10 +94,18 @@ struct audit_ntp_data {
> >  struct audit_ntp_data {};
> >  #endif
> >
> > +struct audit_contobj {
> > +       struct list_head        list;
> > +       u64                     id;
> > +       struct task_struct      *owner;
> > +       refcount_t              refcount;
> > +       struct rcu_head         rcu;
> > +};
> > +
> >  struct audit_task_info {
> >         kuid_t                  loginuid;
> >         unsigned int            sessionid;
> > -       u64                     contid;
> > +       struct audit_contobj    *cont;
> >  #ifdef CONFIG_AUDITSYSCALL
> >         struct audit_context    *ctx;
> >  #endif
> > @@ -203,9 +211,9 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
> >
> >  static inline u64 audit_get_contid(struct task_struct *tsk)
> >  {
> > -       if (!tsk->audit)
> > +       if (!tsk->audit || !tsk->audit->cont)
> >                 return AUDIT_CID_UNSET;
> > -       return tsk->audit->contid;
> > +       return tsk->audit->cont->id;
> >  }
> >
> >  extern u32 audit_enabled;
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 2d7707426b7d..4bab20f5f781 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -212,6 +218,31 @@ void __init audit_task_init(void)
> >                                              0, SLAB_PANIC, NULL);
> >  }
> >
> > +static struct audit_contobj *_audit_contobj(struct task_struct *tsk)
> > +{
> > +       if (!tsk->audit)
> > +               return NULL;
> > +       return tsk->audit->cont;
> 
> It seems like it would be safer to grab a reference here (e.g.
> _audit_contobj_hold(...)), yes?  Or are you confident we will never
> have tsk go away while the caller is holding on to the returned audit
> container ID object?

I'll switch to _get that calls _hold and just call _put immediately if I
don't want to keep the increase to the refcount.

> > +}
> > +
> > +/* audit_contobj_list_lock must be held by caller unless new */
> > +static void _audit_contobj_hold(struct audit_contobj *cont)
> > +{
> > +       refcount_inc(&cont->refcount);
> > +}
> 
> If we are going to call the matching decrement function "_put" it
> seems like we might want to call the function about "_get".  Further,
> we can also have it return an audit_contobj pointer in case the caller
> needs to do an assignment as well (which seems typical if you need to
> bump the refcount):

Sure, I'll do that.

> > +/* audit_contobj_list_lock must be held by caller */
> > +static void _audit_contobj_put(struct audit_contobj *cont)
> > +{
> > +       if (!cont)
> > +               return;
> > +       if (refcount_dec_and_test(&cont->refcount)) {
> > +               put_task_struct(cont->owner);
> > +               list_del_rcu(&cont->list);
> > +               kfree_rcu(cont, rcu);
> > +       }
> > +}
> > +
> >  /**
> >   * audit_alloc - allocate an audit info block for a task
> >   * @tsk: task
> > @@ -232,7 +263,11 @@ int audit_alloc(struct task_struct *tsk)
> >         }
> >         info->loginuid = audit_get_loginuid(current);
> >         info->sessionid = audit_get_sessionid(current);
> > -       info->contid = audit_get_contid(current);
> > +       spin_lock(&audit_contobj_list_lock);
> > +       info->cont = _audit_contobj(current);
> > +       if (info->cont)
> > +               _audit_contobj_hold(info->cont);
> > +       spin_unlock(&audit_contobj_list_lock);
> 
> If we are taking a spinlock in order to bump the refcount, does it
> really need to be a refcount_t or can we just use a normal integer?
> In RCU protected lists a spinlock is usually used to protect
> adds/removes to the list, not the content of individual list items.
> 
> My guess is you probably want to use the spinlock as described above
> (list add/remove protection) and manipulate the refcount_t inside a
> RCU read lock protected region.

Ok, I guess it could be an integer if it were protected by the spinlock,
but I think you've guessed my intent, so let us keep it as a refcount
and tighten the spinlock scope and use rcu read locking to protect _get
and _put in _alloc, _free, and later on when protecting the network
namespace contobj lists.  This should reduce potential contention for
the spinlock to one location over fewer lines of code in that place
while speeding up updates and slightly simplifying code in the others.

> >         tsk->audit = info;
> >
> >         ret = audit_alloc_syscall(tsk);
> > @@ -267,6 +302,9 @@ void audit_free(struct task_struct *tsk)
> >         /* Freeing the audit_task_info struct must be performed after
> >          * audit_log_exit() due to need for loginuid and sessionid.
> >          */
> > +       spin_lock(&audit_contobj_list_lock);
> > +       _audit_contobj_put(tsk->audit->cont);
> > +       spin_unlock(&audit_contobj_list_lock);
> 
> This is another case of refcount_t vs normal integer in a spinlock
> protected region.
> 
> >         info = tsk->audit;
> >         tsk->audit = NULL;
> >         kmem_cache_free(audit_task_cache, info);
> > @@ -2365,6 +2406,9 @@ int audit_signal_info(int sig, struct task_struct *t)
> >   *
> >   * Returns 0 on success, -EPERM on permission failure.
> >   *
> > + * If the original container owner goes away, no task injection is
> > + * possible to an existing container.
> > + *
> >   * Called (set) from fs/proc/base.c::proc_contid_write().
> >   */
> >  int audit_set_contid(struct task_struct *task, u64 contid)
> > @@ -2381,9 +2425,12 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> >         }
> >         oldcontid = audit_get_contid(task);
> >         read_lock(&tasklist_lock);
> > -       /* Don't allow the audit containerid to be unset */
> > +       /* Don't allow the contid to be unset */
> >         if (!audit_contid_valid(contid))
> >                 rc = -EINVAL;
> > +       /* Don't allow the contid to be set to the same value again */
> > +       else if (contid == oldcontid) {
> > +               rc = -EADDRINUSE;
> 
> First, is that brace a typo?  It looks like it.  Did this compile?

Yes, it was fixed in the later patch that restructured the if
statements.

> Second, can you explain why (re)setting the audit container ID to the
> same value is something we need to prohibit?  I'm guessing it has
> something to do with explicitly set vs inherited, but I don't want to
> assume too much about your thinking behind this.

It made the refcounting more complicated later, and besides, the
prohibition on setting the contid again if it is already set would catch
this case, so I'll remove it in this patch and ensure this action
doesn't cause a problem in later patches.

> If it is "set vs inherited", would allowing an orchestrator to
> explicitly "set" an inherited audit container ID provide some level or
> protection against moving the task?

I can't see it helping prevent this since later descendancy checks will
stop this move anyways.

> >         /* if we don't have caps, reject */
> >         else if (!capable(CAP_AUDIT_CONTROL))
> >                 rc = -EPERM;
> > @@ -2396,8 +2443,49 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> >         else if (audit_contid_set(task))
> >                 rc = -ECHILD;
> >         read_unlock(&tasklist_lock);
> > -       if (!rc)
> > -               task->audit->contid = contid;
> > +       if (!rc) {
> > +               struct audit_contobj *oldcont = _audit_contobj(task);
> > +               struct audit_contobj *cont = NULL, *newcont = NULL;
> > +               int h = audit_hash_contid(contid);
> > +
> > +               rcu_read_lock();
> > +               list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
> > +                       if (cont->id == contid) {
> > +                               /* task injection to existing container */
> > +                               if (current == cont->owner) {
> 
> Do we have any protection against the task pointed to by cont->owner
> going away and a new task with the same current pointer value (no
> longer the legitimate audit container ID owner) manipulating the
> target task's audit container ID?

Yes, the get_task_struct() call below.

> > +                                       spin_lock(&audit_contobj_list_lock);
> > +                                       _audit_contobj_hold(cont);
> > +                                       spin_unlock(&audit_contobj_list_lock);
> 
> More of the recount_t vs integer/spinlock question.
> 
> > +                                       newcont = cont;
> > +                               } else {
> > +                                       rc = -ENOTUNIQ;
> > +                                       goto conterror;
> > +                               }
> > +                               break;
> > +                       }
> > +               if (!newcont) {
> > +                       newcont = kmalloc(sizeof(*newcont), GFP_ATOMIC);
> > +                       if (newcont) {
> > +                               INIT_LIST_HEAD(&newcont->list);
> > +                               newcont->id = contid;
> > +                               get_task_struct(current);
> > +                               newcont->owner = current;
> 
> newcont->owner = get_task_struct(current);
> 
> (This is what I was talking about above with returning the struct
> pointer in the _get/_hold function)

No problem.

> > +                               refcount_set(&newcont->refcount, 1);
> > +                               spin_lock(&audit_contobj_list_lock);
> > +                               list_add_rcu(&newcont->list, &audit_contid_hash[h]);
> > +                               spin_unlock(&audit_contobj_list_lock);
> 
> I think we might have a problem where multiple tasks could race adding
> the same audit container ID and since there is no check inside the
> spinlock protected region we could end up adding multiple instances of
> the same audit container ID, yes?

Yes, you are right.  It was properly protected in v7.  I'll go back to
the coverage from v7.

> > +                       } else {
> > +                               rc = -ENOMEM;
> > +                               goto conterror;
> > +                       }
> > +               }
> > +               task->audit->cont = newcont;
> > +               spin_lock(&audit_contobj_list_lock);
> > +               _audit_contobj_put(oldcont);
> > +               spin_unlock(&audit_contobj_list_lock);
> 
> More of the refcount_t/integer/spinlock question.
> 
> 
> > +conterror:
> > +               rcu_read_unlock();
> > +       }
> >         task_unlock(task);
> >
> >         if (!audit_enabled)
> 
> --
> paul moore
> www.paul-moore.com
> 

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

