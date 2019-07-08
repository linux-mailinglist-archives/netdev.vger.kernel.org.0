Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EC3627B3
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 19:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731035AbfGHRvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 13:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbfGHRvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 13:51:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 70F31E3E08;
        Mon,  8 Jul 2019 17:51:32 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-14.phx2.redhat.com [10.3.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E42FD608A4;
        Mon,  8 Jul 2019 17:51:08 +0000 (UTC)
Date:   Mon, 8 Jul 2019 13:51:05 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Tycho Andersen <tycho@tycho.ws>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
Message-ID: <20190708175105.7zb6mikjw2wmnwln@madcap2.tricolour.ca>
References: <cover.1554732921.git.rgb@redhat.com>
 <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
 <20190529145742.GA8959@cisco>
 <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 08 Jul 2019 17:51:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-29 11:29, Paul Moore wrote:
> On Wed, May 29, 2019 at 10:57 AM Tycho Andersen <tycho@tycho.ws> wrote:
> >
> > On Mon, Apr 08, 2019 at 11:39:09PM -0400, Richard Guy Briggs wrote:
> > > It is not permitted to unset the audit container identifier.
> > > A child inherits its parent's audit container identifier.
> >
> > ...
> >
> > >  /**
> > > + * audit_set_contid - set current task's audit contid
> > > + * @contid: contid value
> > > + *
> > > + * Returns 0 on success, -EPERM on permission failure.
> > > + *
> > > + * Called (set) from fs/proc/base.c::proc_contid_write().
> > > + */
> > > +int audit_set_contid(struct task_struct *task, u64 contid)
> > > +{
> > > +     u64 oldcontid;
> > > +     int rc = 0;
> > > +     struct audit_buffer *ab;
> > > +     uid_t uid;
> > > +     struct tty_struct *tty;
> > > +     char comm[sizeof(current->comm)];
> > > +
> > > +     task_lock(task);
> > > +     /* Can't set if audit disabled */
> > > +     if (!task->audit) {
> > > +             task_unlock(task);
> > > +             return -ENOPROTOOPT;
> > > +     }
> > > +     oldcontid = audit_get_contid(task);
> > > +     read_lock(&tasklist_lock);
> > > +     /* Don't allow the audit containerid to be unset */
> > > +     if (!audit_contid_valid(contid))
> > > +             rc = -EINVAL;
> > > +     /* if we don't have caps, reject */
> > > +     else if (!capable(CAP_AUDIT_CONTROL))
> > > +             rc = -EPERM;
> > > +     /* if task has children or is not single-threaded, deny */
> > > +     else if (!list_empty(&task->children))
> > > +             rc = -EBUSY;
> > > +     else if (!(thread_group_leader(task) && thread_group_empty(task)))
> > > +             rc = -EALREADY;
> > > +     read_unlock(&tasklist_lock);
> > > +     if (!rc)
> > > +             task->audit->contid = contid;
> > > +     task_unlock(task);
> > > +
> > > +     if (!audit_enabled)
> > > +             return rc;
> >
> > ...but it is allowed to change it (assuming
> > capable(CAP_AUDIT_CONTROL), of course)? Seems like this might be more
> > immediately useful since we still live in the world of majority
> > privileged containers if we didn't allow changing it, in addition to
> > un-setting it.
> 
> The idea is that only container orchestrators should be able to
> set/modify the audit container ID, and since setting the audit
> container ID can have a significant effect on the records captured
> (and their routing to multiple daemons when we get there) modifying
> the audit container ID is akin to modifying the audit configuration
> which is why it is gated by CAP_AUDIT_CONTROL.  The current thinking
> is that you would only change the audit container ID from one
> set/inherited value to another if you were nesting containers, in
> which case the nested container orchestrator would need to be granted
> CAP_AUDIT_CONTROL (which everyone to date seems to agree is a workable
> compromise).  We did consider allowing for a chain of nested audit
> container IDs, but the implications of doing so are significant
> (implementation mess, runtime cost, etc.) so we are leaving that out
> of this effort.

We had previously discussed the idea of restricting
orchestrators/engines from only being able to set the audit container
identifier on their own descendants, but it was discarded.  I've added a
check to ensure this is now enforced.

I've also added a check to ensure that a process can't set its own audit
container identifier and that if the identifier is already set, then the
orchestrator/engine must be in a descendant user namespace from the
orchestrator that set the previously inherited audit container
identifier.

> From a practical perspective, un-setting the audit container ID is
> pretty much the same as changing it from one set value to another so
> most of the above applies to that case as well.
> 
> -- 
> paul moore
> www.paul-moore.com

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
