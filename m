Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415ABE558F
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 23:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfJYVAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 17:00:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28409 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725977AbfJYVA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 17:00:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572037227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESaDI9Sbn2pcUwKJdT+wbkZ3h6KhdJHUdxJfF5QHTAo=;
        b=g+upZYpn66I3We9LIK4BDhANRPtL/2lTINvCH0n74yU/OEwoKWGWtkWOB0k9T9HAXT4THO
        GGY7/JbyJSK6s4sKP1QXf1Ht+tA5ZTOfgZ1/ME9cwSkC32h6TM5lEkb1xVqMqE2PcRLMPA
        i1A++vG4REjmrBrmZC79ddZxrlJuX/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-3Q3B_5DtPmCgXjhJV5FcFw-1; Fri, 25 Oct 2019 17:00:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 902D3107AD3D;
        Fri, 25 Oct 2019 21:00:19 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 031DF194B9;
        Fri, 25 Oct 2019 21:00:07 +0000 (UTC)
Date:   Fri, 25 Oct 2019 17:00:04 -0400
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
Subject: Re: [PATCH ghak90 V7 04/21] audit: convert to contid list to check
 for orch/engine ownership
Message-ID: <20191025210004.jzkenjg6jrka22ak@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <6fb4e270bfafef3d0477a06b0365fdcc5a5305b5.1568834524.git.rgb@redhat.com>
 <CAHC9VhS2111YTQ_rbHKe6+n9coPNbcTJqf5wnBx9LYHSf69THA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhS2111YTQ_rbHKe6+n9coPNbcTJqf5wnBx9LYHSf69THA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 3Q3B_5DtPmCgXjhJV5FcFw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-10 20:38, Paul Moore wrote:
> On Wed, Sep 18, 2019 at 9:24 PM Richard Guy Briggs <rgb@redhat.com> wrote=
:
> > Store the audit container identifier in a refcounted kernel object that
> > is added to the master list of audit container identifiers.  This will
> > allow multiple container orchestrators/engines to work on the same
> > machine without danger of inadvertantly re-using an existing identifier=
.
> > It will also allow an orchestrator to inject a process into an existing
> > container by checking if the original container owner is the one
> > injecting the task.  A hash table list is used to optimize searches.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h | 26 ++++++++++++++--
> >  kernel/audit.c        | 86 +++++++++++++++++++++++++++++++++++++++++++=
+++++---
> >  kernel/audit.h        |  8 +++++
> >  3 files changed, 112 insertions(+), 8 deletions(-)
>=20
> One general comment before we go off into the weeds on this ... I can
> understand why you wanted to keep this patch separate from the earlier
> patches, but as we get closer to having mergeable code this should get
> folded into the previous patches.  For example, there shouldn't be a
> change in audit_task_info where you change the contid field from a u64
> to struct pointer, it should be a struct pointer from the start.

I should have marked this patchset as RFC even though it was v7 due to a
lot of new ideas/code that was added with uncertainties needing comment
and direction.

> It's also disappointing that idr appears to only be for 32-bit ID
> values, if we had a 64-bit idr I think we could simplify this greatly.

Perhaps.  I do still see value in letting the orchestrator choose the
value.

> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index f2e3b81f2942..e317807cdd3e 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -95,10 +95,18 @@ struct audit_ntp_data {
> >  struct audit_ntp_data {};
> >  #endif
> >
> > +struct audit_cont {
> > +       struct list_head        list;
> > +       u64                     id;
> > +       struct task_struct      *owner;
> > +       refcount_t              refcount;
> > +       struct rcu_head         rcu;
> > +};
>=20
> It seems as though in most of the code you are using "contid", any
> reason why didn't stick with that naming scheme here, e.g. "struct
> audit_contid"?

I was using contid to refer to the value itself and cont to refer to the
refcounted object.  I find cont a bit too terse, so I'm still thinking
of changing it.  Perhaps contobj?

> >  struct audit_task_info {
> >         kuid_t                  loginuid;
> >         unsigned int            sessionid;
> > -       u64                     contid;
> > +       struct audit_cont       *cont;
>=20
> Same, why not stick with "contid"?

^^^

> >  #ifdef CONFIG_AUDITSYSCALL
> >         struct audit_context    *ctx;
> >  #endif
> > @@ -203,11 +211,15 @@ static inline unsigned int audit_get_sessionid(st=
ruct task_struct *tsk)
> >
> >  static inline u64 audit_get_contid(struct task_struct *tsk)
> >  {
> > -       if (!tsk->audit)
> > +       if (!tsk->audit || !tsk->audit->cont)
> >                 return AUDIT_CID_UNSET;
> > -       return tsk->audit->contid;
> > +       return tsk->audit->cont->id;
> >  }
>=20
> Assuming for a moment that we implement an audit_contid_get() (see
> Neil's comment as well as mine below), we probably need to name this
> something different so we don't all lose our minds when we read this
> code.  On the plus side we can probably preface it with an underscore
> since it is a static, in which case _audit_contid_get() might be okay,
> but I'm open to suggestions.

I'm fine with the "_" prefix, can you point to precedent or convention?

> > +extern struct audit_cont *audit_cont(struct task_struct *tsk);
> > +
> > +extern void audit_cont_put(struct audit_cont *cont);
>=20
> More of the "contid" vs "cont".

^^^

> >  extern u32 audit_enabled;
> >
> >  extern int audit_signal_info(int sig, struct task_struct *t);
> > @@ -277,6 +289,14 @@ static inline u64 audit_get_contid(struct task_str=
uct *tsk)
> >         return AUDIT_CID_UNSET;
> >  }
> >
> > +static inline struct audit_cont *audit_cont(struct task_struct *tsk)
> > +{
> > +       return NULL;
> > +}
> > +
> > +static inline void audit_cont_put(struct audit_cont *cont)
> > +{ }
> > +
> >  #define audit_enabled AUDIT_OFF
> >
> >  static inline int audit_signal_info(int sig, struct task_struct *t)
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index a36ea57cbb61..ea0899130cc1 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -137,6 +137,8 @@ struct audit_net {
> >
> >  /* Hash for inode-based rules */
> >  struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
> > +/* Hash for contid-based rules */
> > +struct list_head audit_contid_hash[AUDIT_CONTID_BUCKETS];
> >
> >  static struct kmem_cache *audit_buffer_cache;
> >
> > @@ -204,6 +206,8 @@ struct audit_reply {
> >
> >  static struct kmem_cache *audit_task_cache;
> >
> > +static DEFINE_SPINLOCK(audit_contid_list_lock);
>=20
> Since it looks like this protectects audit_contid_hash, I think it
> would be better to move it up underneath audit_contid_hash.

Agreed.

> >  void __init audit_task_init(void)
> >  {
> >         audit_task_cache =3D kmem_cache_create("audit_task",
> > @@ -231,7 +235,9 @@ int audit_alloc(struct task_struct *tsk)
> >         }
> >         info->loginuid =3D audit_get_loginuid(current);
> >         info->sessionid =3D audit_get_sessionid(current);
> > -       info->contid =3D audit_get_contid(current);
> > +       info->cont =3D audit_cont(current);
> > +       if (info->cont)
> > +               refcount_inc(&info->cont->refcount);
>=20
> See the other comments about a "get" function, but I think we need a
> RCU read lock around the above, no?

The rcu read lock is to protect the list rather than the cont object
itself, the latter of which is protected by its refcount.

> >         tsk->audit =3D info;
> >
> >         ret =3D audit_alloc_syscall(tsk);
> > @@ -246,7 +252,7 @@ int audit_alloc(struct task_struct *tsk)
> >  struct audit_task_info init_struct_audit =3D {
> >         .loginuid =3D INVALID_UID,
> >         .sessionid =3D AUDIT_SID_UNSET,
> > -       .contid =3D AUDIT_CID_UNSET,
> > +       .cont =3D NULL,
>=20
> More "cont" vs "contid".

^^^

> >  #ifdef CONFIG_AUDITSYSCALL
> >         .ctx =3D NULL,
> >  #endif
> > @@ -266,6 +272,9 @@ void audit_free(struct task_struct *tsk)
> >         /* Freeing the audit_task_info struct must be performed after
> >          * audit_log_exit() due to need for loginuid and sessionid.
> >          */
> > +       spin_lock(&audit_contid_list_lock);
> > +       audit_cont_put(tsk->audit->cont);
> > +       spin_unlock(&audit_contid_list_lock);
>=20
> Perhaps this will make sense as I get further into the patchset, but
> why not move the spin lock operations into audit_[cont/contid]_put()?

audit_cont_put() is recursive in patch 18/21, which would have been
evident if 18/21 was squashed into this one as you pointed out there...

> >         info =3D tsk->audit;
> >         tsk->audit =3D NULL;
> >         kmem_cache_free(audit_task_cache, info);
> > @@ -1657,6 +1666,9 @@ static int __init audit_init(void)
> >         for (i =3D 0; i < AUDIT_INODE_BUCKETS; i++)
> >                 INIT_LIST_HEAD(&audit_inode_hash[i]);
> >
> > +       for (i =3D 0; i < AUDIT_CONTID_BUCKETS; i++)
> > +               INIT_LIST_HEAD(&audit_contid_hash[i]);
> > +
> >         mutex_init(&audit_cmd_mutex.lock);
> >         audit_cmd_mutex.owner =3D NULL;
> >
> > @@ -2356,6 +2368,32 @@ int audit_signal_info(int sig, struct task_struc=
t *t)
> >         return audit_signal_info_syscall(t);
> >  }
> >
> > +struct audit_cont *audit_cont(struct task_struct *tsk)
> > +{
> > +       if (!tsk->audit || !tsk->audit->cont)
> > +               return NULL;
> > +       return tsk->audit->cont;
> > +}
> > +
> > +/* audit_contid_list_lock must be held by caller */
> > +void audit_cont_put(struct audit_cont *cont)
> > +{
> > +       if (!cont)
> > +               return;
> > +       if (refcount_dec_and_test(&cont->refcount)) {
> > +               put_task_struct(cont->owner);
> > +               list_del_rcu(&cont->list);
> > +               kfree_rcu(cont, rcu);
> > +       }
> > +}
>=20
> I tend to agree with Neil's previous comment; if we've got a
> audit_[cont/contid]_put(), why not an audit_[cont/contid]_get()?

^^^

> > +static struct task_struct *audit_cont_owner(struct task_struct *tsk)
> > +{
> > +       if (tsk->audit && tsk->audit->cont)
> > +               return tsk->audit->cont->owner;
> > +       return NULL;
> > +}
>=20
> I'm not sure if this is possible (I haven't make my way through the
> entire patchset) and the function above isn't used in this patch (why
> is it here?), but it seems like it would be safer to convert this into
> an audit_contid_isowner() function that simply returns 1/0 depending
> on if the passed task_struct is the owner or not of a passed audit
> container ID value?

Agreed since it is only ever compared with current.  It can be moved to
14/21.

> >  /*
> >   * audit_set_contid - set current task's audit contid
> >   * @task: target task
> > @@ -2382,9 +2420,12 @@ int audit_set_contid(struct task_struct *task, u=
64 contid)
> >         }
> >         oldcontid =3D audit_get_contid(task);
> >         read_lock(&tasklist_lock);
> > -       /* Don't allow the audit containerid to be unset */
> > +       /* Don't allow the contid to be unset */
> >         if (!audit_contid_valid(contid))
> >                 rc =3D -EINVAL;
> > +       /* Don't allow the contid to be set to the same value again */
> > +       else if (contid =3D=3D oldcontid) {
> > +               rc =3D -EADDRINUSE;
> >         /* if we don't have caps, reject */
> >         else if (!capable(CAP_AUDIT_CONTROL))
> >                 rc =3D -EPERM;
>=20
> RCU read lock?  It's a bit dicey since I believe the tasklist_lock is
> going to provide us the safety we need, but if we are going to claim
> that the audit container ID list is protected by RCU we should
> probably use it.

Yes, perhaps, but to protect the task read, not the list, until it is
accessed.  Getting the contid value or cont pointer via the task does
not involve the list.  The cont pointer is protected by its refcount.

> > @@ -2397,8 +2438,43 @@ int audit_set_contid(struct task_struct *task, u=
64 contid)
> >         else if (audit_contid_set(task))
> >                 rc =3D -ECHILD;
> >         read_unlock(&tasklist_lock);
> > -       if (!rc)
> > -               task->audit->contid =3D contid;
> > +       if (!rc) {
> > +               struct audit_cont *oldcont =3D audit_cont(task);
>=20
> Previously we held the tasklist_lock to protect the audit container ID
> associated with the struct, should we still be holding it here?

We held the tasklist_lock to protect access to the target task's
child/parent/thread relationships.

> Regardless, I worry that the lock dependencies between the
> tasklist_lock and the audit_contid_list_lock are going to be tricky.
> It might be nice to document the relationship in a comment up near
> where you declare audit_contid_list_lock.

I don't think there should be a conflict between the two.

The contid_list_lock doesn't care if the cont object is associated to a
particular task.

> > +               struct audit_cont *cont =3D NULL;
> > +               struct audit_cont *newcont =3D NULL;
> > +               int h =3D audit_hash_contid(contid);
> > +
> > +               spin_lock(&audit_contid_list_lock);
> > +               list_for_each_entry_rcu(cont, &audit_contid_hash[h], li=
st)
> > +                       if (cont->id =3D=3D contid) {
> > +                               /* task injection to existing container=
 */
> > +                               if (current =3D=3D cont->owner) {
>=20
> I understand the desire to limit a given audit container ID to the
> orchestrator that created it, but are we certain that we can track
> audit container ID "ownership" via a single instance of a task_struct?

Are you suggesting that a task_struct representing a task may be
replaced for a specific task?  I don't believe that will ever happen.

>  What happens when the orchestrator stops/restarts/crashes?  Do we
> even care?

Reap all of its containers?

> > +                                       refcount_inc(&cont->refcount);
> > +                                       newcont =3D cont;
>=20
> We can bail out of the loop here, yes?

Yes, that would be a performance improvement, but not functional bug,
thanks.  :-)

> > +                               } else {
> > +                                       rc =3D -ENOTUNIQ;
> > +                                       goto conterror;
> > +                               }
> > +                       }
> > +               if (!newcont) {
> > +                       newcont =3D kmalloc(sizeof(struct audit_cont), =
GFP_ATOMIC);
> > +                       if (newcont) {
> > +                               INIT_LIST_HEAD(&newcont->list);
> > +                               newcont->id =3D contid;
> > +                               get_task_struct(current);
> > +                               newcont->owner =3D current;
> > +                               refcount_set(&newcont->refcount, 1);
> > +                               list_add_rcu(&newcont->list, &audit_con=
tid_hash[h]);
> > +                       } else {
> > +                               rc =3D -ENOMEM;
> > +                               goto conterror;
> > +                       }
> > +               }
> > +               task->audit->cont =3D newcont;
> > +               audit_cont_put(oldcont);
> > +conterror:
> > +               spin_unlock(&audit_contid_list_lock);
> > +       }
> >         task_unlock(task);
> >
> >         if (!audit_enabled)
> > diff --git a/kernel/audit.h b/kernel/audit.h
> > index 16bd03b88e0d..e4a31aa92dfe 100644
> > --- a/kernel/audit.h
> > +++ b/kernel/audit.h
> > @@ -211,6 +211,14 @@ static inline int audit_hash_ino(u32 ino)
> >         return (ino & (AUDIT_INODE_BUCKETS-1));
> >  }
> >
> > +#define AUDIT_CONTID_BUCKETS   32
> > +extern struct list_head audit_contid_hash[AUDIT_CONTID_BUCKETS];
> > +
> > +static inline int audit_hash_contid(u64 contid)
> > +{
> > +       return (contid & (AUDIT_CONTID_BUCKETS-1));
> > +}
> > +
> >  /* Indicates that audit should log the full pathname. */
> >  #define AUDIT_NAME_FULL -1
> >
>=20
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

