Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD11E1472EC
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 22:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgAWVDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 16:03:04 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31557 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729342AbgAWVDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 16:03:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579813381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YZjD8aqaGH6JNDHX+A7tsAQo+cl/H8KbJHBmNjl1CAs=;
        b=AL+8uFF+N9owvQ37LFmYwnD7fBbJkvTjCFZFoMX63i47bouTzEgAQ/diB80WmxGLXY12Fl
        sjLXqcCJj+VwaYqRaWdnFSaH+BhrWxxjlCjBDhHV64H5C3naOTRfjmU+N1OHh0WI4FzepD
        5nmDerGdr/RS3oxceCs0UG+/D5ATX3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-HDmQ2MhAMA6cXpt_V3B92g-1; Thu, 23 Jan 2020 16:02:57 -0500
X-MC-Unique: HDmQ2MhAMA6cXpt_V3B92g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D398B8024E5;
        Thu, 23 Jan 2020 21:02:54 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-12.phx2.redhat.com [10.3.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 467D281207;
        Thu, 23 Jan 2020 21:02:43 +0000 (UTC)
Date:   Thu, 23 Jan 2020 16:02:40 -0500
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
Subject: Re: [PATCH ghak90 V8 12/16] audit: contid check descendancy and
 nesting
Message-ID: <20200123210240.sq64tptjm3ds7xss@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <cfbb80a08fc770dd0dcf6dac6ff307a80d877c3f.1577736799.git.rgb@redhat.com>
 <CAHC9VhT1+mx_tVzyXD=UBqagqYgAFjZ=X1A6oBiMvjVCn8=V-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhT1+mx_tVzyXD=UBqagqYgAFjZ=X1A6oBiMvjVCn8=V-w@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-22 16:29, Paul Moore wrote:
> On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Require the target task to be a descendant of the container
> > orchestrator/engine.
> >
> > You would only change the audit container ID from one set or inherited
> > value to another if you were nesting containers.
> >
> > If changing the contid, the container orchestrator/engine must be a
> > descendant and not same orchestrator as the one that set it so it is not
> > possible to change the contid of another orchestrator's container.
> >
> > Since the task_is_descendant() function is used in YAMA and in audit,
> > remove the duplication and pull the function into kernel/core/sched.c
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/sched.h    |  3 +++
> >  kernel/audit.c           | 44 ++++++++++++++++++++++++++++++++++++--------
> >  kernel/sched/core.c      | 33 +++++++++++++++++++++++++++++++++
> >  security/yama/yama_lsm.c | 33 ---------------------------------
> >  4 files changed, 72 insertions(+), 41 deletions(-)
> 
> ...
> 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index f7a8d3288ca0..ef8e07524c46 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -2603,22 +2610,43 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> >         oldcontid = audit_get_contid(task);
> >         read_lock(&tasklist_lock);
> >         /* Don't allow the contid to be unset */
> > -       if (!audit_contid_valid(contid))
> > +       if (!audit_contid_valid(contid)) {
> >                 rc = -EINVAL;
> > +               goto unlock;
> > +       }
> >         /* Don't allow the contid to be set to the same value again */
> > -       else if (contid == oldcontid) {
> > +       if (contid == oldcontid) {
> >                 rc = -EADDRINUSE;
> > +               goto unlock;
> > +       }
> >         /* if we don't have caps, reject */
> > -       else if (!capable(CAP_AUDIT_CONTROL))
> > +       if (!capable(CAP_AUDIT_CONTROL)) {
> >                 rc = -EPERM;
> > -       /* if task has children or is not single-threaded, deny */
> > -       else if (!list_empty(&task->children))
> > +               goto unlock;
> > +       }
> > +       /* if task has children, deny */
> > +       if (!list_empty(&task->children)) {
> >                 rc = -EBUSY;
> > -       else if (!(thread_group_leader(task) && thread_group_empty(task)))
> > +               goto unlock;
> > +       }
> > +       /* if task is not single-threaded, deny */
> > +       if (!(thread_group_leader(task) && thread_group_empty(task))) {
> >                 rc = -EALREADY;
> > -       /* if contid is already set, deny */
> > -       else if (audit_contid_set(task))
> > +               goto unlock;
> > +       }
> 
> It seems like the if/else-if conversion above should be part of an
> earlier patchset.

I had considered that, but it wasn't obvious where that conversion
should happen since it wasn't necessary earlier and is now.  I can move
it earlier if you feel strongly about it.

> > +       /* if task is not descendant, block */
> > +       if (task == current) {
> > +               rc = -EBADSLT;
> > +               goto unlock;
> > +       }
> > +       if (!task_is_descendant(current, task)) {
> > +               rc = -EXDEV;
> > +               goto unlock;
> > +       }
> 
> I understand you are trying to provide a unique error code for each
> failure case, but this is getting silly.  Let's group the descendent
> checks under the same error code.

Ok.  I was trying to provide more information for debugging for me and
for users.

> > +       /* only allow contid setting again if nesting */
> > +       if (audit_contid_set(task) && audit_contid_isowner(task))
> >                 rc = -ECHILD;
> 
> Should that be "!audit_contid_isowner()"?

No.  If the contid is already set on this task and if it is the same
orchestrator that already owns this one, then block it since the same
orchestrator is not allowed to set it again.  Another orchestrator that
has been shown by previous tests to be a descendant of the orchestrator
that already owns this one would be permitted.

Now that I say this explicitly, it appears I need another test to check:

	/* only allow contid setting again if nesting */
	if (audit_contid_set(task) && ( audit_contid_isowner(task) || !task_is_descendant(_audit_contobj(task)->owner, current) ))
		rc = -ECHILD;

So we're back to audit_contobj_owner() like in the previous patchset
that would make this cleaner.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

