Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199753008A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfE3RJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:09:17 -0400
Received: from mail.hallyn.com ([178.63.66.53]:50574 "EHLO mail.hallyn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfE3RJR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 13:09:17 -0400
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id 3568262D; Thu, 30 May 2019 12:09:13 -0500 (CDT)
Date:   Thu, 30 May 2019 12:09:13 -0500
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Tycho Andersen <tycho@tycho.ws>,
        Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
Message-ID: <20190530170913.GA16722@mail.hallyn.com>
References: <cover.1554732921.git.rgb@redhat.com>
 <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
 <20190529145742.GA8959@cisco>
 <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco>
 <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
 <20190529222835.GD8959@cisco>
 <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 06:39:48PM -0400, Paul Moore wrote:
> On Wed, May 29, 2019 at 6:28 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > On Wed, May 29, 2019 at 12:03:58PM -0400, Paul Moore wrote:
> > > On Wed, May 29, 2019 at 11:34 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > > >
> > > > On Wed, May 29, 2019 at 11:29:05AM -0400, Paul Moore wrote:
> > > > > On Wed, May 29, 2019 at 10:57 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > > > > >
> > > > > > On Mon, Apr 08, 2019 at 11:39:09PM -0400, Richard Guy Briggs wrote:
> > > > > > > It is not permitted to unset the audit container identifier.
> > > > > > > A child inherits its parent's audit container identifier.
> > > > > >
> > > > > > ...
> > > > > >
> > > > > > >  /**
> > > > > > > + * audit_set_contid - set current task's audit contid
> > > > > > > + * @contid: contid value
> > > > > > > + *
> > > > > > > + * Returns 0 on success, -EPERM on permission failure.
> > > > > > > + *
> > > > > > > + * Called (set) from fs/proc/base.c::proc_contid_write().
> > > > > > > + */
> > > > > > > +int audit_set_contid(struct task_struct *task, u64 contid)
> > > > > > > +{
> > > > > > > +     u64 oldcontid;
> > > > > > > +     int rc = 0;
> > > > > > > +     struct audit_buffer *ab;
> > > > > > > +     uid_t uid;
> > > > > > > +     struct tty_struct *tty;
> > > > > > > +     char comm[sizeof(current->comm)];
> > > > > > > +
> > > > > > > +     task_lock(task);
> > > > > > > +     /* Can't set if audit disabled */
> > > > > > > +     if (!task->audit) {
> > > > > > > +             task_unlock(task);
> > > > > > > +             return -ENOPROTOOPT;
> > > > > > > +     }
> > > > > > > +     oldcontid = audit_get_contid(task);
> > > > > > > +     read_lock(&tasklist_lock);
> > > > > > > +     /* Don't allow the audit containerid to be unset */
> > > > > > > +     if (!audit_contid_valid(contid))
> > > > > > > +             rc = -EINVAL;
> > > > > > > +     /* if we don't have caps, reject */
> > > > > > > +     else if (!capable(CAP_AUDIT_CONTROL))
> > > > > > > +             rc = -EPERM;
> > > > > > > +     /* if task has children or is not single-threaded, deny */
> > > > > > > +     else if (!list_empty(&task->children))
> > > > > > > +             rc = -EBUSY;
> > > > > > > +     else if (!(thread_group_leader(task) && thread_group_empty(task)))
> > > > > > > +             rc = -EALREADY;
> > > > > > > +     read_unlock(&tasklist_lock);
> > > > > > > +     if (!rc)
> > > > > > > +             task->audit->contid = contid;
> > > > > > > +     task_unlock(task);
> > > > > > > +
> > > > > > > +     if (!audit_enabled)
> > > > > > > +             return rc;
> > > > > >
> > > > > > ...but it is allowed to change it (assuming
> > > > > > capable(CAP_AUDIT_CONTROL), of course)? Seems like this might be more
> > > > > > immediately useful since we still live in the world of majority
> > > > > > privileged containers if we didn't allow changing it, in addition to
> > > > > > un-setting it.
> > > > >
> > > > > The idea is that only container orchestrators should be able to
> > > > > set/modify the audit container ID, and since setting the audit
> > > > > container ID can have a significant effect on the records captured
> > > > > (and their routing to multiple daemons when we get there) modifying
> > > > > the audit container ID is akin to modifying the audit configuration
> > > > > which is why it is gated by CAP_AUDIT_CONTROL.  The current thinking
> > > > > is that you would only change the audit container ID from one
> > > > > set/inherited value to another if you were nesting containers, in
> > > > > which case the nested container orchestrator would need to be granted
> > > > > CAP_AUDIT_CONTROL (which everyone to date seems to agree is a workable
> > > > > compromise).
> > > >
> > > > But then don't you want some kind of ns_capable() instead (probably
> > > > not the obvious one, though...)? With capable(), you can't really nest
> > > > using the audit-id and user namespaces together.
> > >
> > > You want capable() and not ns_capable() because you want to ensure
> > > that the orchestrator has the rights in the init_ns as changes to the
> > > audit container ID could have an auditing impact that spans the entire
> > > system.
> >
> > Ok but,
> >
> > > > > The current thinking
> > > > > is that you would only change the audit container ID from one
> > > > > set/inherited value to another if you were nesting containers, in
> > > > > which case the nested container orchestrator would need to be granted
> > > > > CAP_AUDIT_CONTROL (which everyone to date seems to agree is a workable
> > > > > compromise).
> >
> > won't work in user namespaced containers, because they will never be
> > capable(CAP_AUDIT_CONTROL); so I don't think this will work for
> > nesting as is. But maybe nobody cares :)
> 
> That's fun :)
> 
> To be honest, I've never been a big fan of supporting nested
> containers from an audit perspective, so I'm not really too upset
> about this.  The k8s/cri-o folks seem okay with this, or at least I
> haven't heard any objections; lxc folks, what do you have to say?

I actually thought the answer to this (when last I looked, "some time" ago)
was that userspace should track an audit message saying "task X in
container Y is changing its auditid to Z", and then decide to also track Z.
This should be doable, but a lot of extra work in userspace.

Per-userns containerids would also work.  So task X1 is in containerid
1 on the host and creates a new task Y in new userns;  it continues to
be reported in init_user_ns as containerid 1 forever;  but in its own
userns it can request to be known as some other containerid.  Audit
socks would be per-userns, allowing root in a container to watch for
audit events in its own (and descendent) namespaces.

But again I'm sure we've gone over all this in the last few years.

I suppose we can look at this as a "first step", and talk about
making it user-ns-nestable later.  But agreed it's not useful in a
lot of situations as is.

-serge
