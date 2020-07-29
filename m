Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26C7232582
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 21:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgG2Tlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 15:41:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48198 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726615AbgG2Tln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 15:41:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596051700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ocuSVhxqqmtvpediuEKQksstiWw3qVg+isufvOVyA6E=;
        b=f6Ovl8hHZjOGgy527BBegZVukE2/sQ/WK1ylu2qi1gdd7geOEJML5yY9zt5hW5JxHOAa1x
        L8mU22eL0QPuDH04j/Or6JmDP4W2HyvoPC2tzQZacwHAxGDROFPEILrJB/HG9hHPX3rln1
        Cl5r4jnRpimNfJ2FR3/b5ClzAHQ9KGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-uxtA_-JJOqm2veOjkX2iqw-1; Wed, 29 Jul 2020 15:41:25 -0400
X-MC-Unique: uxtA_-JJOqm2veOjkX2iqw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC5771800D4A;
        Wed, 29 Jul 2020 19:41:23 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65F968A177;
        Wed, 29 Jul 2020 19:41:02 +0000 (UTC)
Date:   Wed, 29 Jul 2020 15:40:58 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, Ondrej Mosnacek <omosnace@redhat.com>,
        dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Subject: Re: [PATCH ghak90 V9 05/13] audit: log container info of syscalls
Message-ID: <20200729194058.kcbsqjhzunjpipgm@madcap2.tricolour.ca>
References: <cover.1593198710.git.rgb@redhat.com>
 <6e2e10432e1400f747918eeb93bf45029de2aa6c.1593198710.git.rgb@redhat.com>
 <CAHC9VhSCm5eeBcyY8bBsnxr-hK4rkso9_NJHJec2OXLu4m5QTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSCm5eeBcyY8bBsnxr-hK4rkso9_NJHJec2OXLu4m5QTA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-05 11:10, Paul Moore wrote:
> On Sat, Jun 27, 2020 at 9:22 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Create a new audit record AUDIT_CONTAINER_ID to document the audit
> > container identifier of a process if it is present.
> >
> > Called from audit_log_exit(), syscalls are covered.
> >
> > Include target_cid references from ptrace and signal.
> >
> > A sample raw event:
> > type=SYSCALL msg=audit(1519924845.499:257): arch=c000003e syscall=257 success=yes exit=3 a0=ffffff9c a1=56374e1cef30 a2=241 a3=1b6 items=2 ppid=606 pid=635 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=3 comm="bash" exe="/usr/bin/bash" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="tmpcontainerid"
> > type=CWD msg=audit(1519924845.499:257): cwd="/root"
> > type=PATH msg=audit(1519924845.499:257): item=0 name="/tmp/" inode=13863 dev=00:27 mode=041777 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype= PARENT cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0
> > type=PATH msg=audit(1519924845.499:257): item=1 name="/tmp/tmpcontainerid" inode=17729 dev=00:27 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0
> > type=PROCTITLE msg=audit(1519924845.499:257): proctitle=62617368002D6300736C65657020313B206563686F2074657374203E202F746D702F746D70636F6E7461696E65726964
> > type=CONTAINER_ID msg=audit(1519924845.499:257): contid=123458
> >
> > Please see the github audit kernel issue for the main feature:
> >   https://github.com/linux-audit/audit-kernel/issues/90
> > Please see the github audit userspace issue for supporting additions:
> >   https://github.com/linux-audit/audit-userspace/issues/51
> > Please see the github audit testsuiite issue for the test case:
> >   https://github.com/linux-audit/audit-testsuite/issues/64
> > Please see the github audit wiki for the feature overview:
> >   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > Acked-by: Serge Hallyn <serge@hallyn.com>
> > Acked-by: Steve Grubb <sgrubb@redhat.com>
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  include/linux/audit.h      |  7 +++++++
> >  include/uapi/linux/audit.h |  1 +
> >  kernel/audit.c             | 25 +++++++++++++++++++++++--
> >  kernel/audit.h             |  4 ++++
> >  kernel/auditsc.c           | 45 +++++++++++++++++++++++++++++++++++++++------
> >  5 files changed, 74 insertions(+), 8 deletions(-)
> 
> ...
> 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 9e0b38ce1ead..a09f8f661234 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -2211,6 +2211,27 @@ void audit_log_session_info(struct audit_buffer *ab)
> >         audit_log_format(ab, "auid=%u ses=%u", auid, sessionid);
> >  }
> >
> > +/*
> > + * audit_log_container_id - report container info
> > + * @context: task or local context for record
> > + * @cont: container object to report
> > + */
> > +void audit_log_container_id(struct audit_context *context,
> > +                           struct audit_contobj *cont)
> > +{
> > +       struct audit_buffer *ab;
> > +
> > +       if (!cont)
> > +               return;
> > +       /* Generate AUDIT_CONTAINER_ID record with container ID */
> > +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_ID);
> > +       if (!ab)
> > +               return;
> > +       audit_log_format(ab, "contid=%llu", contid);
> 
> Did this patch compile?  Where is "contid" coming from?  I'm guessing
> you mean to get it from "cont", but that isn't what appears to be
> happening; likely a casualty of the object vs token discussion we had
> during the last review cycle.

Yes, it was supposed to be cont->id.

> I'm assuming this code gets modified later in this patchset and you
> only compiled tested the patchset as a whole.  Please make sure the
> patchset compiles at each patch along the way to applying them all;
> this helps ensure that git bisect remains useful and it fits better
> with the general idea that individual patches must have merit on their
> own.

Yes, agreed.

> ... and yes, I do check for this when merging patchsets, it isn't just
> a visual inspection, I compile test each patch.
> 
> If nothing else, at least this answers the question of if it is worth
> respinning or not (this alone requires a respin).
> 
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index f03d3eb0752c..9e79645e5c0e 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -1458,6 +1466,7 @@ static void audit_log_exit(void)
> >         struct audit_buffer *ab;
> >         struct audit_aux_data *aux;
> >         struct audit_names *n;
> > +       struct audit_contobj *cont;
> >
> >         context->personality = current->personality;
> >
> > @@ -1541,7 +1550,7 @@ static void audit_log_exit(void)
> >         for (aux = context->aux_pids; aux; aux = aux->next) {
> >                 struct audit_aux_data_pids *axs = (void *)aux;
> >
> > -               for (i = 0; i < axs->pid_count; i++)
> > +               for (i = 0; i < axs->pid_count; i++) {
> >                         if (audit_log_pid_context(context, axs->target_pid[i],
> >                                                   axs->target_auid[i],
> >                                                   axs->target_uid[i],
> > @@ -1549,14 +1558,20 @@ static void audit_log_exit(void)
> >                                                   axs->target_sid[i],
> >                                                   axs->target_comm[i]))
> >                                 call_panic = 1;
> > +                       audit_log_container_id(context, axs->target_cid[i]);
> > +               }
> 
> It might be nice to see an audit event example including the
> ptrace/signal information.  I'm concerned there may be some confusion
> about associating the different audit container IDs with the correct
> information in the event.

This is the subject of ghat81, which is a test for ptrace and signal
records.

This was the reason I had advocated for an op= field since there is a
possibility of multiple contid records per event.

> >         }
> >
> > -       if (context->target_pid &&
> > -           audit_log_pid_context(context, context->target_pid,
> > -                                 context->target_auid, context->target_uid,
> > -                                 context->target_sessionid,
> > -                                 context->target_sid, context->target_comm))
> > +       if (context->target_pid) {
> > +               if (audit_log_pid_context(context, context->target_pid,
> > +                                         context->target_auid,
> > +                                         context->target_uid,
> > +                                         context->target_sessionid,
> > +                                         context->target_sid,
> > +                                         context->target_comm))
> >                         call_panic = 1;
> > +               audit_log_container_id(context, context->target_cid);
> > +       }
> >
> >         if (context->pwd.dentry && context->pwd.mnt) {
> >                 ab = audit_log_start(context, GFP_KERNEL, AUDIT_CWD);
> > @@ -1575,6 +1590,14 @@ static void audit_log_exit(void)
> >
> >         audit_log_proctitle();
> >
> > +       rcu_read_lock();
> > +       cont = _audit_contobj_get(current);
> > +       rcu_read_unlock();
> > +       audit_log_container_id(context, cont);
> > +       rcu_read_lock();
> > +       _audit_contobj_put(cont);
> > +       rcu_read_unlock();
> 
> Do we need to grab an additional reference for the audit container
> object here?  We don't create any additional references here that
> persist beyond the lifetime of this function, right?

Why do we need another reference?  There's one for each pointer pointing
to it and so far we have just one from this task.  Or are you thinking
of the contid hash list, which is only added to when a task points to it
and gets removed from that list when the last task stops pointing to it.
Later that gets more complicated with network namespaces and nested
container objects.  For now we just needed it while generating the
record, then it gets freed.

> >         audit_log_container_drop();
> >
> >         /* Send end of event record to help user space know we are finished */
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

