Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27309183BCA
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgCLV63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:58:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39487 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726513AbgCLV63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 17:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584050307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bydTNMJNgIMQ2vZ+TFrMdvYY1Bx3pTEvBd4lxqyQhlg=;
        b=FTXc51aoJthExlpqhKf65I4WmwEV5NDcNBX33oajIrCB3IC39t+k1+pJJLeLEidLzzDYDO
        WSG/ahFkA0+K46A45WnUqne0ik1Wm3Gw7ArAlgzxEdVwzArPw28tNXDqLnvA5I9bxtaXLX
        AI1pODYv725ilTgskUZfJopf+LeB/yw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-uopu1BQaMEyDh_EmRcZsbg-1; Thu, 12 Mar 2020 17:58:25 -0400
X-MC-Unique: uopu1BQaMEyDh_EmRcZsbg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1D9F18CA240;
        Thu, 12 Mar 2020 21:58:22 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26F0A73874;
        Thu, 12 Mar 2020 21:58:10 +0000 (UTC)
Date:   Thu, 12 Mar 2020 17:58:08 -0400
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
Subject: Re: [PATCH ghak90 V8 16/16] audit: add capcontid to set contid
 outside init_user_ns
Message-ID: <20200312215808.bkezqotlhewconiy@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <5941671b6b6b5de28ab2cc80e72f288cf83291d5.1577736799.git.rgb@redhat.com>
 <CAHC9VhQYXQp+C0EHwLuW50yUenfH4KF1xKQdS=bn_OzHfnFmmg@mail.gmail.com>
 <20200205003930.2efpm4tvrisgmj4t@madcap2.tricolour.ca>
 <CAHC9VhSsfBbfYmqLoR=QBgF5_VwbA8Dqqz97MjqwwJ6Jq6fHwA@mail.gmail.com>
 <20200206125135.u4dmybkmvxfgui2b@madcap2.tricolour.ca>
 <CAHC9VhT8RsFtmqD22p_NxJaqoAg+do9mX45Luw9fEkr+nQjvxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhT8RsFtmqD22p_NxJaqoAg+do9mX45Luw9fEkr+nQjvxg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-13 16:58, Paul Moore wrote:
> On Thu, Feb 6, 2020 at 7:52 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-02-05 17:56, Paul Moore wrote:
> > > On Tue, Feb 4, 2020 at 7:39 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > On 2020-01-22 16:29, Paul Moore wrote:
> > > > > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > >
> > > > > > Provide a mechanism similar to CAP_AUDIT_CONTROL to explicitly give a
> > > > > > process in a non-init user namespace the capability to set audit
> > > > > > container identifiers.
> > > > > >
> > > > > > Provide /proc/$PID/audit_capcontid interface to capcontid.
> > > > > > Valid values are: 1==enabled, 0==disabled
> > > > >
> > > > > It would be good to be more explicit about "enabled" and "disabled" in
> > > > > the commit description.  For example, which setting allows the target
> > > > > task to set audit container IDs of it's children processes?
> > > >
> > > > Ok...
> > > >
> > > > > > Report this action in message type AUDIT_SET_CAPCONTID 1022 with fields
> > > > > > opid= capcontid= old-capcontid=
> > > > > >
> > > > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > > > ---
> > > > > >  fs/proc/base.c             | 55 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > > >  include/linux/audit.h      | 14 ++++++++++++
> > > > > >  include/uapi/linux/audit.h |  1 +
> > > > > >  kernel/audit.c             | 35 +++++++++++++++++++++++++++++
> > > > > >  4 files changed, 105 insertions(+)
> > >
> > > ...
> > >
> > > > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > > > index 1287f0b63757..1c22dd084ae8 100644
> > > > > > --- a/kernel/audit.c
> > > > > > +++ b/kernel/audit.c
> > > > > > @@ -2698,6 +2698,41 @@ static bool audit_contid_isowner(struct task_struct *tsk)
> > > > > >         return false;
> > > > > >  }
> > > > > >
> > > > > > +int audit_set_capcontid(struct task_struct *task, u32 enable)
> > > > > > +{
> > > > > > +       u32 oldcapcontid;
> > > > > > +       int rc = 0;
> > > > > > +       struct audit_buffer *ab;
> > > > > > +
> > > > > > +       if (!task->audit)
> > > > > > +               return -ENOPROTOOPT;
> > > > > > +       oldcapcontid = audit_get_capcontid(task);
> > > > > > +       /* if task is not descendant, block */
> > > > > > +       if (task == current)
> > > > > > +               rc = -EBADSLT;
> > > > > > +       else if (!task_is_descendant(current, task))
> > > > > > +               rc = -EXDEV;
> > > > >
> > > > > See my previous comments about error code sanity.
> > > >
> > > > I'll go with EXDEV.
> > > >
> > > > > > +       else if (current_user_ns() == &init_user_ns) {
> > > > > > +               if (!capable(CAP_AUDIT_CONTROL) && !audit_get_capcontid(current))
> > > > > > +                       rc = -EPERM;
> > > > >
> > > > > I think we just want to use ns_capable() in the context of the current
> > > > > userns to check CAP_AUDIT_CONTROL, yes?  Something like this ...
> > > >
> > > > I thought we had firmly established in previous discussion that
> > > > CAP_AUDIT_CONTROL in anything other than init_user_ns was completely irrelevant
> > > > and untrustable.
> > >
> > > In the case of a container with multiple users, and multiple
> > > applications, one being a nested orchestrator, it seems relevant to
> > > allow that container to control which of it's processes are able to
> > > exercise CAP_AUDIT_CONTROL.  Granted, we still want to control it
> > > within the overall host, e.g. the container in question must be
> > > allowed to run a nested orchestrator, but allowing the container
> > > itself to provide it's own granularity seems like the right thing to
> > > do.
> >
> > Looking back to discussion on the v6 patch 2/10 (2019-05-30 15:29 Paul
> > Moore[1], 2019-07-08 14:05 RGB[2]) , it occurs to me that the
> > ns_capable(CAP_AUDIT_CONTROL) application was dangerous since there was
> > no parental accountability in storage or reporting.  Now that is in
> > place, it does seem a bit more reasonable to allow it, but I'm still not
> > clear on why we would want both mechanisms now.  I don't understand what
> > the last line in that email meant: "We would probably still want a
> > ns_capable(CAP_AUDIT_CONTROL) restriction in this case."  Allow
> > ns_capable(CAP_AUDIT_CONTROL) to govern these actions, or restrict
> > ns_capable(CAP_AUDIT_CONTROL) from being used to govern these actions?
> >
> > If an unprivileged user has been given capcontid to be able run their
> > own container orchestrator/engine and spawns a user namespace with
> > CAP_AUDIT_CONTROL, what matters is capcontid, and not CAP_AUDIT_CONTROL.
> > I could see needing CAP_AUDIT_CONTROL *in addition* to capcontid to give
> > it finer grained control, but since capcontid would have to be given to
> > each process explicitly anways, I don't see the point.
> >
> > If that unprivileged user had not been given capcontid,
> > giving itself or one of its descendants CAP_AUDIT_CONTROL should not let
> > it jump into the game all of a sudden unless the now chained audit
> > container identifiers are deemed accountable enough.  And then now we
> > need those hard limits on container depth and network namespace
> > container membership.
> 
> Perhaps I'm not correctly understanding what you are trying to do with
> this patchset, but my current understanding is that you are trying to
> use capcontid to control which child audit container IDs (ACIDs) are
> allowed to manage their own ACIDs.  Further, I believe that the
> capcontid setting operates at a per-ACID level, meaning there is no
> provision for the associated container to further restrict that
> ability, i.e. no access control granularity below the ACID level.  My
> thinking is that ns_capable(CAP_AUDIT_CONTROL) could be used within an
> ACID to increase the granularity of the access controls so that only
> privileged processes running inside the ACID would be able to manage
> the ACIDs.  Does that make sense?

The capcontid is not inherited like the contid (or contobj) in
audit_alloc(), so it stops at that process that was granted capcontid.
That process that was granted capcontid can then explicitly further
grant capcontid to any of its children should it deem necessary.

Since it is a boolean, it defaults to unset in init_struct_audit which
isn't relevant anyways since that is in the initial user namespace.
It isn't set in audit_alloc() and would default to false.
I can set them explicitly both to false to be certain if that makes
things clearer and more certain.

I still believe ns_capable() is irrelevant here.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

