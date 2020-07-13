Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626F521E165
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgGMU3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:29:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28701 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726400AbgGMU3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 16:29:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594672192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dryeyu4Z+O3LO/i4w4Yz2CzQdRMLTMt94aaPkU1Cn/k=;
        b=f6XLkk0WqM+2yrBHhI0t/Ln5waGV1udqDLLyLrtpXkktobHOhX6c60UZG3D9gH6FfcW8Xl
        Isu6LSf7pYaKVBZ7WNtBb/ZOX8DZVC/Gyl1wlwzCy7DaTLMrFyowOstcIK8LWP6mXFCV4b
        BI1BtoTiHtNYOv4VH/uHDpxlkVjlPIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-9J7J3C06ObeFpbogkgclkQ-1; Mon, 13 Jul 2020 16:29:28 -0400
X-MC-Unique: 9J7J3C06ObeFpbogkgclkQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C0B780183C;
        Mon, 13 Jul 2020 20:29:26 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 03D8271683;
        Mon, 13 Jul 2020 20:29:08 +0000 (UTC)
Date:   Mon, 13 Jul 2020 16:29:06 -0400
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
Message-ID: <20200713202906.iiz435vjeedljcwf@madcap2.tricolour.ca>
References: <cover.1593198710.git.rgb@redhat.com>
 <6abeb26e64489fc29b00c86b60b501c8b7316424.1593198710.git.rgb@redhat.com>
 <CAHC9VhTx=4879F1MSXg4=Xd1i5rhEtyam6CakQhy=_ZjGtTaMA@mail.gmail.com>
 <20200707025014.x33eyxbankw2fbww@madcap2.tricolour.ca>
 <CAHC9VhTTGLf9MPS_FgL1ibUVoH+YzMtPK6+2dp_j8a5o9fzftA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTTGLf9MPS_FgL1ibUVoH+YzMtPK6+2dp_j8a5o9fzftA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-07 21:42, Paul Moore wrote:
> On Mon, Jul 6, 2020 at 10:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-07-05 11:09, Paul Moore wrote:
> > > On Sat, Jun 27, 2020 at 9:21 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > >
> > > > The audit-related parameters in struct task_struct should ideally be
> > > > collected together and accessed through a standard audit API.
> > > >
> > > > Collect the existing loginuid, sessionid and audit_context together in a
> > > > new struct audit_task_info called "audit" in struct task_struct.
> > > >
> > > > Use kmem_cache to manage this pool of memory.
> > > > Un-inline audit_free() to be able to always recover that memory.
> > > >
> > > > Please see the upstream github issue
> > > > https://github.com/linux-audit/audit-kernel/issues/81
> > > >
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > > > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > > > ---
> > > >  include/linux/audit.h | 49 +++++++++++++++++++++++------------
> > > >  include/linux/sched.h |  7 +----
> > > >  init/init_task.c      |  3 +--
> > > >  init/main.c           |  2 ++
> > > >  kernel/audit.c        | 71 +++++++++++++++++++++++++++++++++++++++++++++++++--
> > > >  kernel/audit.h        |  5 ++++
> > > >  kernel/auditsc.c      | 26 ++++++++++---------
> > > >  kernel/fork.c         |  1 -
> > > >  8 files changed, 124 insertions(+), 40 deletions(-)
> > > >
> > > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > > index 3fcd9ee49734..c2150415f9df 100644
> > > > --- a/include/linux/audit.h
> > > > +++ b/include/linux/audit.h
> > > > @@ -100,6 +100,16 @@ enum audit_nfcfgop {
> > > >         AUDIT_XT_OP_UNREGISTER,
> > > >  };
> > > >
> > > > +struct audit_task_info {
> > > > +       kuid_t                  loginuid;
> > > > +       unsigned int            sessionid;
> > > > +#ifdef CONFIG_AUDITSYSCALL
> > > > +       struct audit_context    *ctx;
> > > > +#endif
> > > > +};
> > > > +
> > > > +extern struct audit_task_info init_struct_audit;
> > > > +
> > > >  extern int is_audit_feature_set(int which);
> > > >
> > > >  extern int __init audit_register_class(int class, unsigned *list);
> > >
> > > ...
> > >
> > > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > > index b62e6aaf28f0..2213ac670386 100644
> > > > --- a/include/linux/sched.h
> > > > +++ b/include/linux/sched.h
> > > > @@ -34,7 +34,6 @@
> > > >  #include <linux/kcsan.h>
> > > >
> > > >  /* task_struct member predeclarations (sorted alphabetically): */
> > > > -struct audit_context;
> > > >  struct backing_dev_info;
> > > >  struct bio_list;
> > > >  struct blk_plug;
> > > > @@ -946,11 +945,7 @@ struct task_struct {
> > > >         struct callback_head            *task_works;
> > > >
> > > >  #ifdef CONFIG_AUDIT
> > > > -#ifdef CONFIG_AUDITSYSCALL
> > > > -       struct audit_context            *audit_context;
> > > > -#endif
> > > > -       kuid_t                          loginuid;
> > > > -       unsigned int                    sessionid;
> > > > +       struct audit_task_info          *audit;
> > > >  #endif
> > > >         struct seccomp                  seccomp;
> > >
> > > In the early days of this patchset we talked a lot about how to handle
> > > the task_struct and the changes that would be necessary, ultimately
> > > deciding that encapsulating all of the audit fields into an
> > > audit_task_info struct.  However, what is puzzling me a bit at this
> > > moment is why we are only including audit_task_info in task_info by
> > > reference *and* making it a build time conditional (via CONFIG_AUDIT).
> > >
> > > If audit is enabled at build time it would seem that we are always
> > > going to allocate an audit_task_info struct, so I have to wonder why
> > > we don't simply embed it inside the task_info struct (similar to the
> > > seccomp struct in the snippet above?  Of course the audit_context
> > > struct needs to remain as is, I'm talking only about the
> > > task_info/audit_task_info struct.
> >
> > I agree that including the audit_task_info struct in the struct
> > task_struct would have been preferred to simplify allocation and free,
> > but the reason it was included by reference instead was to make the
> > task_struct size independent of audit so that future changes would not
> > cause as many kABI challenges.  This first change will cause kABI
> > challenges regardless, but it was future ones that we were trying to
> > ease.
> >
> > Does that match with your recollection?
> 
> I guess, sure.  I suppose what I was really asking was if we had a
> "good" reason for not embedding the audit_task_info struct.
> Regardless, thanks for the explanation, that was helpful.

Making it dynamic was actually your idea back in the spring of 2018:
	https://lkml.org/lkml/2018/4/18/759

The first two iterations were embedded to more quickly prove the idea:
	https://lkml.org/lkml/2018/5/12/173
		https://lkml.org/lkml/2018/5/12/168

And then switched as strongly recommended to a dynamic pointer:
	https://lkml.org/lkml/2018/5/16/461
		https://lkml.org/lkml/2018/5/16/457

I was initially concerned about switching to a dynamically allocated
structure, but those concerns are a couple of years behind us.

What significant change has happenned since then to alter your
perspective?

> From an upstream perspective, I think embedding the audit_task_info
> struct is the Right Thing To Do.  The code is cleaner and more robust
> if we embed the struct.

I would agree if the audit subsystem were done.  It isn't.

> > > Richard, I'm sure you can answer this off the top of your head, but
> > > I'd have to go digging through the archives to pull out the relevant
> > > discussions so I figured I would just ask you for a reminder ... ?  I
> > > imagine it's also possible things have changed a bit since those early
> > > discussions and the solution we arrived at then no longer makes as
> > > much sense as it did before.
> >
> > Agreed, it doesn't make as much sense now as it did when proposed, but
> > will make more sense in the future depending on when this change gets
> > accepted upstream.  This is why I wanted this patch to go through as
> > part of ghak81 at the time the rest of it did so that future kABI issues
> > would be easier to handle, but that ship has long sailed.
> 
> To be clear, kABI issues with task_struct really aren't an issue with
> the upstream kernel.  I know that you know all of this already
> Richard, I'm mostly talking to everyone else on the To/CC line in case
> they are casually watching this discussion.

kABI issues may not as much of an upstream issue, but part of the goal
here was upstream kernel issues, isolating the kernel audit changes
to its own subsystem and affect struct task_struct as little as possible
in the future and to protect it from "abuse" (as you had expressed
serious concerns) from the rest of the kernel.  include/linux/sched.h
will need to know more about struct audit_task_info if it is embedded,
making it more suceptible to abuse.

> While I'm sympathetic to long-lifetime enterprise distros such as
> RHEL, my responsibility is to ensure the upstream kernel is as good as
> we can make it, and in this case I believe that means embedding
> audit_task_info into the task_struct.

Keeping audit_task_info dynamic will also make embedding struct
audit_context as a zero-length array at the end of it possible in the
future as an internal audit subsystem optimization whereas largely
preclude that if it were embedded.  Any change to audit_task_info in the
future will change struct task_struct which is what we had agreed was a
good thing to avoid to keep audit as isolated and independent as
possible.

This method has been well exercised over the last two years of
development, testing and rebases, so I'm not particularly concerned
about its dynamic nature any more.  It works well.  At this point this
change seems to be more gratuitously disruptive than helpful.

> > I didn't make
> > that argument then and I regret it now that I realize and recall some of
> > the thinking behind the change.  Your reasons at the time were that
> > contid was the only user of that change but there have been some
> > CONFIG_AUDIT and CONFIG_AUDITSYSCALL changes since that were related.
> 
> Agreed that there are probably some common goals and benefits with
> those changes and the audit container ID work, however, I believe that
> discussion quickly goes back to upstream vs RHEL.

I did't think things were quite so cut and dried with respect to upstream
vs downstream.

> > > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > > index 468a23390457..f00c1da587ea 100644
> > > > --- a/kernel/auditsc.c
> > > > +++ b/kernel/auditsc.c
> > > > @@ -1612,7 +1615,6 @@ void __audit_free(struct task_struct *tsk)
> > > >                 if (context->current_state == AUDIT_RECORD_CONTEXT)
> > > >                         audit_log_exit();
> > > >         }
> > > > -
> > > >         audit_set_context(tsk, NULL);
> > > >         audit_free_context(context);
> > > >  }
> > >
> > > This nitpick is barely worth the time it is taking me to write this,
> > > but the whitespace change above isn't strictly necessary.
> >
> > Sure, it is a harmless but noisy cleanup when the function was being
> > cleaned up and renamed.  It wasn't an accident, but a style preference.
> > Do you prefer a vertical space before cleanup actions at the end of
> > functions and more versus less vertical whitespace in general?
> 
> As I mentioned above, this really was barely worth mentioning, but I
> made the comment simply because I feel this patchset is going to draw
> a lot of attention once it is merged and I feel keeping the patchset
> as small, and as focused, as possible is a good thing.

Is this concern also affecting the perspective on the change from
pointer to embedded above?

> However, I'm not going to lose even a second of sleep over a single
> blank line gone missing ;)
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

