Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848E623F1C2
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 19:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgHGRLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 13:11:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23198 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726644AbgHGRK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 13:10:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596820255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LBwwWQVoE2g2j8GR2C8Q+iCKgjoYpxs4sQmpmGrjX/k=;
        b=B5KC2cEd10jc6IyoE573s4Qvr0TZaiXgQPTEuOzbdNgwRqXNPXwpVuGA/uLCDxWqoHiRf1
        WZ4yiQEnz2NqMbVUwGLXLNjxOe165ejDVKzqACB+7MdeF6xJj+/cUda5AdGTFDWEV51Wl4
        uAhvEu1ljoTz1nP0DNKJEutqBPTGAFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-hIOUfRY4NaKbZ5eIn_NyyA-1; Fri, 07 Aug 2020 13:10:48 -0400
X-MC-Unique: hIOUfRY4NaKbZ5eIn_NyyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B53C18017FB;
        Fri,  7 Aug 2020 17:10:45 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 154D38AC13;
        Fri,  7 Aug 2020 17:10:28 +0000 (UTC)
Date:   Fri, 7 Aug 2020 13:10:25 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>, aris@redhat.com
Subject: Re: [PATCH ghak90 V9 11/13] audit: contid check descendancy and
 nesting
Message-ID: <20200807171025.523i2sxfyfl7dfjy@madcap2.tricolour.ca>
References: <cover.1593198710.git.rgb@redhat.com>
 <01229b93733d9baf6ac9bb0cc243eeb08ad579cd.1593198710.git.rgb@redhat.com>
 <CAHC9VhT6cLxxws_pYWcL=mWe786xPoTTFfPZ1=P4hx4V3nytXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhT6cLxxws_pYWcL=mWe786xPoTTFfPZ1=P4hx4V3nytXA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-05 11:11, Paul Moore wrote:
> On Sat, Jun 27, 2020 at 9:23 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Require the target task to be a descendant of the container
> > orchestrator/engine.
> >
> > You would only change the audit container ID from one set or inherited
> > value to another if you were nesting containers.
> >
> > If changing the contid, the container orchestrator/engine must be a
> > descendant and not same orchestrator as the one that set it so it is not
> > possible to change the contid of another orchestrator's container.

Are we able to agree on the premises above?  Is anything asserted that
should not be and is there anything missing?

I've been sitting on my response below for more than a week trying to
understand the issues raised and to give it the proper attention to a
reply.  Please excuse my tardiness at replying on this issue since I'm
still having trouble thinking through all the scenarios for nesting.

> > Since the task_is_descendant() function is used in YAMA and in audit,
> > remove the duplication and pull the function into kernel/core/sched.c
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/sched.h    |  3 +++
> >  kernel/audit.c           | 23 +++++++++++++++++++++--
> >  kernel/sched/core.c      | 33 +++++++++++++++++++++++++++++++++
> >  security/yama/yama_lsm.c | 33 ---------------------------------
> >  4 files changed, 57 insertions(+), 35 deletions(-)
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 2213ac670386..06938d0b9e0c 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -2047,4 +2047,7 @@ static inline void rseq_syscall(struct pt_regs *regs)
> >
> >  const struct cpumask *sched_trace_rd_span(struct root_domain *rd);
> >
> > +extern int task_is_descendant(struct task_struct *parent,
> > +                             struct task_struct *child);
> > +
> >  #endif
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index a862721dfd9b..efa65ec01239 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -2713,6 +2713,20 @@ int audit_signal_info(int sig, struct task_struct *t)
> >         return audit_signal_info_syscall(t);
> >  }
> >
> > +static bool audit_contid_isnesting(struct task_struct *tsk)
> > +{
> > +       bool isowner = false;
> > +       bool ownerisparent = false;
> > +
> > +       rcu_read_lock();
> > +       if (tsk->audit && tsk->audit->cont) {
> > +               isowner = current == tsk->audit->cont->owner;
> > +               ownerisparent = task_is_descendant(tsk->audit->cont->owner, current);
> 
> I want to make sure I'm understanding this correctly and I keep
> mentally tripping over something: it seems like for a given audit
> container ID a task is either the owner or a descendent, there is no
> third state, is that correct?

Sure there is.  It could be another owner (which is addressed when we
search for an existing contobj match), or in the next patch, the
owner's parent if nested or a peer.

> Assuming that is true, can the descendent check simply be a negative
> owner check given they both have the same audit container ID?

There isn't actually a check in my code for the orchestrator contid and
task contid being the same.  Maybe I was making this check more
complicated than necessary, and still incomplete, but see below for more...

> > +       }
> > +       rcu_read_unlock();
> > +       return !isowner && ownerisparent;
> > +}
> > +
> >  /*
> >   * audit_set_contid - set current task's audit contid
> >   * @task: target task
> > @@ -2755,8 +2769,13 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> >                 rc = -EBUSY;
> >                 goto unlock;
> >         }
> > -       /* if contid is already set, deny */
> > -       if (audit_contid_set(task))
> > +       /* if task is not descendant, block */
> > +       if (task == current || !task_is_descendant(current, task)) {
> 
> I'm also still fuzzy on why we can't let a task set it's own audit
> container ID, assuming it meets all the criteria established in patch
> 2/13.  It somewhat made sense when you were tracking inherited vs
> explicitly set audit container IDs, but that doesn't appear to be the
> case so far in this patchset, yes?

I'm still having a strong reluctance to permit this but can't come up
with a solid technical reason right now, but it feels like a layer
violation.  If we forbid it and discover it necessary and harmless, then
permitting it won't break the API.  If we permit it and later discover a
reason it causes a problem, then blocking it will break the API.  I have
heard that there are cases where there is no orchestrator/engine, so in
those cases I conclude that a process would need to set its own contid
but I'm having trouble recalling what those circumstances are.

I also was seriously considering blocking any contid set on the initial
user or PID namespaces to avoid polluting them, and even had a tested
patch to implement it, but this starts making assumptions about the
definition of a container with respect to namespaces which we have been
deliberately avoiding.

> > +               rc = -EXDEV;
> 
> I'm fairly confident we had a discussion about not using all these
> different error codes, but that may be a moot point given my next
> comment.

Yes, we did.  I reduced both circumstances down to what you requested,
shedding two along the way.  Given the number of different ways
orchestrators, contids and tasks can be related, I'd rather have more,
not fewer diagnostics to understand what it thinks is happenning.  This
is a realtively minor detail in the context of the rest of the
discussion in this thread.

> > +               goto unlock;
> > +       }
> > +       /* only allow contid setting again if nesting */
> > +       if (audit_contid_set(task) && !audit_contid_isnesting(task))
> >                 rc = -EEXIST;
> 
> It seems like what we need in audit_set_contid() is a check to ensure
> that the task being modified is only modified by the owner of the
> audit container ID, yes?  If so, I would think we could do this quite
> easily with the following, or similar logic, (NOTE: assumes both
> current and tsk are properly setup):
> 
>   if ((current->audit->cont != tsk->audit->cont) || (current->audit->cont->owner != current))
>     return -EACCESS;

Not necessarily.

If we start from the premise that once set, a contid on a task cannot be
unset, and then that it cannot be set to another value, then the oldest
ancestor in any container must not be able to change contid.  That
leaves any descendant (that hasn't threaded or parented) free to nest.

If we allow a task to modify its own contid (from the potential change
above), then if it inherited its contid, it could set its own.  This
still looks like a layer violation to me.  Going back to some
discussions with Eric Biederman from a number of years ago, it seems
wrong to me that a task should be able to see its own contid, let alone
be able to set it.  This came out of a CRIU concern about serial nsIDs
based on proc inode numbers not being portable.  Is it still a
consideration?

Another scenario comes to mind.  Should an orchestrator be able to set
the contid of a descendant of one of the former's child orchestrators?
This doesn't sound like a good idea leaping generations and I can't come
up with a valid use case.

> This is somewhat independent of the above issue, but we may also want
> to add to the capability check.  Patch 2 adds a
> "capable(CAP_AUDIT_CONTROL)" which is good, but perhaps we also need a
> "ns_capable(CAP_AUDIT_CONTROL)" to allow a given audit container ID
> orchestrator/owner the ability to control which of it's descendants
> can change their audit container ID, for example:
> 
>   if (!capable(CAP_AUDIT_CONTROL) ||
>       !ns_capable(current->nsproxy->user_ns, CAP_AUDIT_CONTROL))
>     return -EPERM;

Why does ns_capable keep being raised?  The last patch, capcontid, was
developed to solve this previously raised issue.  The issue was an
unprivileged user creating a user namespace with full capabilities,
circumventing capable() and being able to change the main audit
configuration.  It was already discussed in v8 and before that and my
last posting in the thread was left dangling with an unanswered
question:
https://lkml.org/lkml/2020/2/6/333

I only see this being potentially useful with audit namespaces in
conjunction with unprivileged user namespaces in the future with the
implementation of multiple audit daemons for the ability of an
unprivileged user to run their own distro container without influencing
the master audit configuration.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

