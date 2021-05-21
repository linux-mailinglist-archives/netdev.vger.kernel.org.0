Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBF338CFE0
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhEUV2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:28:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229536AbhEUV2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 17:28:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621632412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iuwdQzDfAVbEwkrjxmoLKDy0SWcCah6CBDEGdBhw/iM=;
        b=BTRvLsprfBZRBfDoKh/26C5Yb1SdhS5RKjM9J936U0FoWoe9pGbHwjeFevC1tRTuw+Nmvg
        YPg/28sZO0lxMTfoL2Y2Ak32H3fAD/m0wCvklPk5FAm/IHnTwppQTIsSbaoKW8oypxG5eL
        Z6qFtjf9i56kNFyYEQe3cOaSnce0Rxo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-QEjlv7oSNeilQWP4OITv3A-1; Fri, 21 May 2021 17:26:50 -0400
X-MC-Unique: QEjlv7oSNeilQWP4OITv3A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B08B6180FD67;
        Fri, 21 May 2021 21:26:48 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D01D21002EF0;
        Fri, 21 May 2021 21:26:38 +0000 (UTC)
Date:   Fri, 21 May 2021 17:26:35 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        john.johansen@canonical.com, selinux@vger.kernel.org,
        netdev@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        casey.schaufler@intel.com, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH v26 22/25] Audit: Add new record for multiple process LSM
 attributes
Message-ID: <20210521212635.GC2268484@madcap2.tricolour.ca>
References: <20210513200807.15910-1-casey@schaufler-ca.com>
 <20210513200807.15910-23-casey@schaufler-ca.com>
 <CAHC9VhSdFVuZvThMsqWT-L9wcHevA-0yAX+kxqXN0iMmqRc10g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSdFVuZvThMsqWT-L9wcHevA-0yAX+kxqXN0iMmqRc10g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-21 16:19, Paul Moore wrote:
> On Thu, May 13, 2021 at 4:32 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> > Create a new audit record type to contain the subject information
> > when there are multiple security modules that require such data.
> > This record is linked with the same timestamp and serial number
> > using the audit_alloc_local() mechanism.
> 
> The record is linked with the other associated records into a single
> event, it doesn't matter if it gets the timestamp/serial from
> audit_alloc_local() or an existing audit event, e.g. ongoing syscall.

I had similar concerns this would be misunderstood...

> > The record is produced only in cases where there is more than one
> > security module with a process "context".
> > In cases where this record is produced the subj= fields of
> > other records in the audit event will be set to "subj=?".
> >
> > An example of the MAC_TASK_CONTEXTS (1420) record is:
> >
> >         type=UNKNOWN[1420]
> >         msg=audit(1600880931.832:113)
> >         subj_apparmor==unconfined
> 
> It should be just a single "=" in the line above.
> 
> >         subj_smack=_
> >
> > There will be a subj_$LSM= entry for each security module
> > LSM that supports the secid_to_secctx and secctx_to_secid
> > hooks. The BPF security module implements secid/secctx
> > translation hooks, so it has to be considered to provide a
> > secctx even though it may not actually do so.
> >
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > To: paul@paul-moore.com
> > To: linux-audit@redhat.com
> > To: rgb@redhat.com
> > Cc: netdev@vger.kernel.org
> > ---
> >  drivers/android/binder.c                |  2 +-
> >  include/linux/audit.h                   | 24 ++++++++
> >  include/linux/security.h                | 16 ++++-
> >  include/net/netlabel.h                  |  3 +-
> >  include/net/scm.h                       |  2 +-
> >  include/net/xfrm.h                      | 13 +++-
> >  include/uapi/linux/audit.h              |  1 +
> >  kernel/audit.c                          | 80 ++++++++++++++++++-------
> >  kernel/audit.h                          |  3 +
> >  kernel/auditfilter.c                    |  6 +-
> >  kernel/auditsc.c                        | 75 ++++++++++++++++++++---
> >  net/ipv4/ip_sockglue.c                  |  2 +-
> >  net/netfilter/nf_conntrack_netlink.c    |  4 +-
> >  net/netfilter/nf_conntrack_standalone.c |  2 +-
> >  net/netfilter/nfnetlink_queue.c         |  2 +-
> >  net/netlabel/netlabel_domainhash.c      |  4 +-
> >  net/netlabel/netlabel_unlabeled.c       | 24 ++++----
> >  net/netlabel/netlabel_user.c            | 20 ++++---
> >  net/netlabel/netlabel_user.h            |  6 +-
> >  net/xfrm/xfrm_policy.c                  | 10 ++--
> >  net/xfrm/xfrm_state.c                   | 20 ++++---
> >  security/integrity/ima/ima_api.c        |  7 ++-
> >  security/integrity/integrity_audit.c    |  6 +-
> >  security/security.c                     | 46 +++++++++-----
> >  security/smack/smackfs.c                |  3 +-
> >  25 files changed, 274 insertions(+), 107 deletions(-)
> 
> ...
> 
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 97cd7471e572..229cd71fbf09 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -386,6 +395,19 @@ static inline void audit_ptrace(struct task_struct *t)
> >                 __audit_ptrace(t);
> >  }
> >
> > +static inline struct audit_context *audit_alloc_for_lsm(gfp_t gfp)
> > +{
> > +       struct audit_context *context = audit_context();
> > +
> > +       if (context)
> > +               return context;
> > +
> > +       if (lsm_multiple_contexts())
> > +               return audit_alloc_local(gfp);
> > +
> > +       return NULL;
> > +}
> 
> See my other comments, but this seems wrong at face value.  The
> additional LSM record should happen as part of the existing audit log
> functions.

Right.  The only time a local context should be necessary is if there is
a group of records that should be divorced from a syscall or that has no
syscall (or other similar context).

> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index 0129400ff6e9..ddab456e93d3 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -182,6 +182,8 @@ struct lsmblob {
> >  #define LSMBLOB_INVALID                -1      /* Not a valid LSM slot number */
> >  #define LSMBLOB_NEEDED         -2      /* Slot requested on initialization */
> >  #define LSMBLOB_NOT_NEEDED     -3      /* Slot not requested */
> > +#define LSMBLOB_DISPLAY                -4      /* Use the "display" slot */
> > +#define LSMBLOB_FIRST          -5      /* Use the default "display" slot */
> >
> >  /**
> >   * lsmblob_init - initialize an lsmblob structure
> > @@ -248,6 +250,15 @@ static inline u32 lsmblob_value(const struct lsmblob *blob)
> >         return 0;
> >  }
> >
> > +static inline bool lsm_multiple_contexts(void)
> > +{
> > +#ifdef CONFIG_SECURITY
> > +       return lsm_slot_to_name(1) != NULL;
> > +#else
> > +       return false;
> > +#endif
> > +}
> > +
> >  /* These functions are in security/commoncap.c */
> >  extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
> >                        int cap, unsigned int opts);
> > @@ -578,7 +589,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
> >                          size_t size);
> >  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
> >  int security_ismaclabel(const char *name);
> > -int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp);
> > +int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp,
> > +                            int display);
> >  int security_secctx_to_secid(const char *secdata, u32 seclen,
> >                              struct lsmblob *blob);
> >  void security_release_secctx(struct lsmcontext *cp);
> > @@ -1433,7 +1445,7 @@ static inline int security_ismaclabel(const char *name)
> >  }
> >
> >  static inline int security_secid_to_secctx(struct lsmblob *blob,
> > -                                          struct lsmcontext *cp)
> > +                                          struct lsmcontext *cp, int display)
> >  {
> >         return -EOPNOTSUPP;
> >  }
> > diff --git a/include/net/netlabel.h b/include/net/netlabel.h
> > index 73fc25b4042b..9bc1f969a25d 100644
> > --- a/include/net/netlabel.h
> > +++ b/include/net/netlabel.h
> > @@ -97,7 +97,8 @@ struct calipso_doi;
> >
> >  /* NetLabel audit information */
> >  struct netlbl_audit {
> > -       u32 secid;
> > +       struct audit_context *localcontext;
> > +       struct lsmblob lsmdata;
> >         kuid_t loginuid;
> >         unsigned int sessionid;
> >  };
> > diff --git a/include/net/scm.h b/include/net/scm.h
> > index b77a52f93389..f4d567d4885e 100644
> > --- a/include/net/scm.h
> > +++ b/include/net/scm.h
> > @@ -101,7 +101,7 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
> >                  * and the infrastructure will know which it is.
> >                  */
> >                 lsmblob_init(&lb, scm->secid);
> > -               err = security_secid_to_secctx(&lb, &context);
> > +               err = security_secid_to_secctx(&lb, &context, LSMBLOB_DISPLAY);
> >
> >                 if (!err) {
> >                         put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, context.len,
> > diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> > index c58a6d4eb610..f8ad20d34498 100644
> > --- a/include/net/xfrm.h
> > +++ b/include/net/xfrm.h
> > @@ -669,13 +669,22 @@ struct xfrm_spi_skb_cb {
> >  #define XFRM_SPI_SKB_CB(__skb) ((struct xfrm_spi_skb_cb *)&((__skb)->cb[0]))
> >
> >  #ifdef CONFIG_AUDITSYSCALL
> > -static inline struct audit_buffer *xfrm_audit_start(const char *op)
> > +static inline struct audit_buffer *xfrm_audit_start(const char *op,
> > +                                                   struct audit_context **lac)
> >  {
> > +       struct audit_context *context;
> >         struct audit_buffer *audit_buf = NULL;
> >
> >         if (audit_enabled == AUDIT_OFF)
> >                 return NULL;
> > -       audit_buf = audit_log_start(audit_context(), GFP_ATOMIC,
> > +       context = audit_context();
> > +       if (lac != NULL) {
> > +               if (lsm_multiple_contexts() && context == NULL)
> > +                       context = audit_alloc_local(GFP_ATOMIC);
> > +               *lac = context;
> > +       }
> 
> Okay, we've got a disconnect here regarding "audit contexts" and
> "local contexts", skip down below where I attempt to explain things a
> little more but basically if there is a place that uses this pattern:
> 
>   audit_log_start(audit_context(), ...);
> 
> ... you don't need, or want, a "local context".  You might need a
> local context if you see the following pattern:
> 
>   audit_log_start(NULL, ...);
> 
> The "local context" idea is a hack and should be avoided whenever
> possible; if you have an existing audit context from a syscall, or
> something else, you *really* should use it ... or have a *really* good
> explanation as to why you can not.

Yes, what Paul said.  Examples include network events that have no
syscall related to them or a user record that isn't really related to
the syscall that produced it.

> > +       audit_buf = audit_log_start(context, GFP_ATOMIC,
> >                                     AUDIT_MAC_IPSEC_EVENT);
> >         if (audit_buf == NULL)
> >                 return NULL;
> 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 841123390d41..60c027d7759c 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -386,10 +386,12 @@ void audit_log_lost(const char *message)
> >  static int audit_log_config_change(char *function_name, u32 new, u32 old,
> >                                    int allow_changes)
> >  {
> > +       struct audit_context *context;
> >         struct audit_buffer *ab;
> >         int rc = 0;
> >
> > -       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONFIG_CHANGE);
> > +       context = audit_alloc_for_lsm(GFP_KERNEL);
> > +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
> 
> Use the existing context, don't create your own, it breaks the record
> associations in the audit event stream.

Agreed.

> >         if (unlikely(!ab))
> >                 return rc;
> >         audit_log_format(ab, "op=set %s=%u old=%u ", function_name, new, old);
> > @@ -398,7 +400,7 @@ static int audit_log_config_change(char *function_name, u32 new, u32 old,
> >         if (rc)
> >                 allow_changes = 0; /* Something weird, deny request */
> >         audit_log_format(ab, " res=%d", allow_changes);
> > -       audit_log_end(ab);
> > +       audit_log_end_local(ab, context);
> 
> More on this below, but we really should just use audit_log_end(),
> "local contexts" are not special, the are regular audit contexts ...
> although if they are used properly (limited scope) you do need to free
> them when you are done.

I was a bit puzzled about this before and had the same concerns.

> >         return rc;
> >  }
> >
> 
> > @@ -1357,7 +1355,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >                                 if (err)
> >                                         break;
> >                         }
> > -                       audit_log_user_recv_msg(&ab, msg_type);
> > +                       lcontext = audit_alloc_for_lsm(GFP_KERNEL);
> > +                       audit_log_common_recv_msg(lcontext, &ab, msg_type);
> 
> Same.
> 
> >                         if (msg_type != AUDIT_USER_TTY) {
> >                                 /* ensure NULL termination */
> >                                 str[data_len - 1] = '\0';
> > @@ -1370,7 +1369,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >                                         data_len--;
> >                                 audit_log_n_untrustedstring(ab, str, data_len);
> >                         }
> > -                       audit_log_end(ab);
> > +                       audit_log_end_local(ab, lcontext);
> 
> Same.
> 
> >                 }
> >                 break;
> >         case AUDIT_ADD_RULE:
> > @@ -1378,13 +1377,14 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >                 if (data_len < sizeof(struct audit_rule_data))
> >                         return -EINVAL;
> >                 if (audit_enabled == AUDIT_LOCKED) {
> > -                       audit_log_common_recv_msg(audit_context(), &ab,
> > +                       lcontext = audit_alloc_for_lsm(GFP_KERNEL);
> > +                       audit_log_common_recv_msg(lcontext, &ab,
> >                                                   AUDIT_CONFIG_CHANGE);
> >                         audit_log_format(ab, " op=%s audit_enabled=%d res=0",
> >                                          msg_type == AUDIT_ADD_RULE ?
> >                                                 "add_rule" : "remove_rule",
> >                                          audit_enabled);
> > -                       audit_log_end(ab);
> > +                       audit_log_end_local(ab, lcontext);
> 
> Same.  I'm going to stop calling these out, I think you get the idea.
> 
> > @@ -2396,6 +2415,21 @@ void audit_log_end(struct audit_buffer *ab)
> >         audit_buffer_free(ab);
> >  }
> >
> > +/**
> > + * audit_log_end_local - end one audit record with local context
> > + * @ab: the audit_buffer
> > + * @context: the local context
> > + *
> > + * Emit an LSM context record if appropriate, then end the audit event
> > + * in the usual way.
> > + */
> > +void audit_log_end_local(struct audit_buffer *ab, struct audit_context *context)
> > +{
> > +       audit_log_end(ab);
> > +       audit_log_lsm_common(context);
> > +       audit_free_local(context);
> > +}
> 
> Eeesh, no, not this please.

It was this that I found hard to follow and justify.

> First, some background on audit contexts and the idea of a "local
> context" as we have been using it in the audit container ID work,
> which is where this originated.  An audit context contains a few
> things, but likely the most important for this discussion is the audit
> event timestamp and serial number (I may refer to this combo as just a
> "timestamp" in the future); this timestamp/serial is shared across all
> of the audit records that make up this audit event, linking them
> together.  A shared timestamp is what allows you to group an open()
> SYSCALL record with the PATH record that provides the file's pathname
> info.

How about a "postmark"?  :-)    (Yes, timestamp works...)

> While there are some exceptions in the current code, most audit events
> occur as a result of a syscall, and their audit context in this case
> is the syscall's audit context (see the open() example above), but
> there are some cases being discussed where we have an audit event that
> does not occur as a result of a syscall but there is a need to group
> multiple audit records together in a single event.  This is where the
> "local context" comes into play, it allows us to create an audit
> context outside of a syscall and share that context across multiple
> audit records, allowing the records to share a timestamp/serial and
> grouping them together as a single audit event in the audit stream.
> 
> While a function like audit_alloc_local() make sense, there really
> shouldn't be an audit_log_end_local() function, the normal
> audit_log_end() function should be used.

Exactly.

> Does that make sense?
> 
> > diff --git a/kernel/audit.h b/kernel/audit.h
> > index 27ef690afd30..5ad0c6819aa8 100644
> > --- a/kernel/audit.h
> > +++ b/kernel/audit.h
> > @@ -100,6 +100,7 @@ struct audit_context {
> >         int                 dummy;      /* must be the first element */
> >         int                 in_syscall; /* 1 if task is in a syscall */
> >         bool                local;      /* local context needed */
> > +       bool                lsmdone;    /* multiple security reported */
> 
> "lsmdone" doesn't seem consistent with the comment, how about
> "lsm_multi" or something similar?
> 
> >         enum audit_state    state, current_state;
> >         unsigned int        serial;     /* serial number for record */
> >         int                 major;      /* syscall number */
> 
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index d4e061f95da8..55509faf5341 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -1013,6 +1013,13 @@ void audit_free_context(struct audit_context *context)
> >  }
> >  EXPORT_SYMBOL(audit_free_context);
> >
> > +void audit_free_local(struct audit_context *context)
> > +{
> > +       if (context && context->local)
> > +               audit_free_context(context);
> > +}
> > +EXPORT_SYMBOL(audit_free_local);
> 
> We don't need this function, just use audit_free_context().  A "local
> context" is the same as a non-local context; what makes a context
> "local" is the scope of the audit context (local function scope vs
> syscall scope) and nothing else.

Agreed.

> > @@ -1504,6 +1512,47 @@ static void audit_log_proctitle(void)
> >         audit_log_end(ab);
> >  }
> >
> > +void audit_log_lsm_common(struct audit_context *context)
> > +{
> > +       struct audit_buffer *ab;
> > +       struct lsmcontext lsmdata;
> > +       bool sep = false;
> > +       int error;
> > +       int i;
> > +
> > +       if (!lsm_multiple_contexts() || context == NULL ||
> > +           !lsmblob_is_set(&context->lsm))
> > +               return;
> > +
> > +       ab = audit_log_start(context, GFP_ATOMIC, AUDIT_MAC_TASK_CONTEXTS);
> > +       if (!ab)
> > +               return; /* audit_panic or being filtered */
> 
> We should be consistent with our use of audit_panic() when we bail on
> error; we use it below, but not here - why?
> 
> > +       for (i = 0; i < LSMBLOB_ENTRIES; i++) {
> > +               if (context->lsm.secid[i] == 0)
> > +                       continue;
> > +               error = security_secid_to_secctx(&context->lsm, &lsmdata, i);
> > +               if (error && error != -EINVAL) {
> > +                       audit_panic("error in audit_log_lsm");
> > +                       return;
> > +               }
> > +
> > +               audit_log_format(ab, "%ssubj_%s=%s", sep ? " " : "",
> > +                                lsm_slot_to_name(i), lsmdata.context);
> > +               sep = true;
> > +               security_release_secctx(&lsmdata);
> > +       }
> > +       audit_log_end(ab);
> > +       context->lsmdone = true;
> 
> Maybe I missed it, but why do we need this flag?

This is partly what confused me earlier...

> > +}
> > +
> > +void audit_log_lsm(struct audit_context *context)
> > +{
> > +       if (!context->lsmdone)
> > +               audit_log_lsm_common(context);
> > +}
> 
> I think I was distracted with the local context issue and I've lost
> track of the details here, perhaps it's best to fix the local context
> issue first (that should be a big change to this patch) and then we
> can take another look.

I got distracted by the local context issues too earlier...  Sorry, this
feedback would have been more useful earlier.  I never completed that
review and got pulled off to other priorities...

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

