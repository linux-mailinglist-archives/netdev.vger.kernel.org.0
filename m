Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D415838D5E1
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 14:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhEVNAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 09:00:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230469AbhEVNAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 09:00:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621688357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0jihgK6nUGSssaLZQS5Ili6PzS5KwAtgGpBMxwFQ9h0=;
        b=KJ/QuEiBwHHOgVSNcmssBvhJqDVjsaKs9fxodzw14X4/cP4h6Xi0QpODH12R1o3xk0J+Fn
        BWltlYc1ZWum+e8i2Djq+Ny6WkFlVe5+ZmosiFEB5+9wC7LzBmPsQiPHEhS2wpbmGxwehv
        IgZImuO8DWrW5mIRaaHq4/U6QXxvEHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-zvytTB6vPqu5PNUiXhMBTg-1; Sat, 22 May 2021 08:59:13 -0400
X-MC-Unique: zvytTB6vPqu5PNUiXhMBTg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0882C107ACC7;
        Sat, 22 May 2021 12:59:11 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A66A719D9D;
        Sat, 22 May 2021 12:59:02 +0000 (UTC)
Date:   Sat, 22 May 2021 08:58:59 -0400
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
Message-ID: <20210522125859.GF447005@madcap2.tricolour.ca>
References: <20210513200807.15910-1-casey@schaufler-ca.com>
 <20210513200807.15910-23-casey@schaufler-ca.com>
 <CAHC9VhSdFVuZvThMsqWT-L9wcHevA-0yAX+kxqXN0iMmqRc10g@mail.gmail.com>
 <d753115f-6cbd-0886-473c-b10485cb7c52@schaufler-ca.com>
 <CAHC9VhR9OPbNCLaKpCEt9mES8yWXpNoTBrgnKW2ER+vEkuNQwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhR9OPbNCLaKpCEt9mES8yWXpNoTBrgnKW2ER+vEkuNQwQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-21 22:20, Paul Moore wrote:
> On Fri, May 21, 2021 at 6:05 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> > On 5/21/2021 1:19 PM, Paul Moore wrote:
> > > On Thu, May 13, 2021 at 4:32 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> > >> Create a new audit record type to contain the subject information
> > >> when there are multiple security modules that require such data.
> > >> This record is linked with the same timestamp and serial number
> > >> using the audit_alloc_local() mechanism.
> > > The record is linked with the other associated records into a single
> > > event, it doesn't matter if it gets the timestamp/serial from
> > > audit_alloc_local() or an existing audit event, e.g. ongoing syscall.
> > >
> > >> The record is produced only in cases where there is more than one
> > >> security module with a process "context".
> > >> In cases where this record is produced the subj= fields of
> > >> other records in the audit event will be set to "subj=?".
> > >>
> > >> An example of the MAC_TASK_CONTEXTS (1420) record is:
> > >>
> > >>         type=UNKNOWN[1420]
> > >>         msg=audit(1600880931.832:113)
> > >>         subj_apparmor==unconfined
> > > It should be just a single "=" in the line above.
> >
> > AppArmor provides the 2nd "=" as part of the subject context.
> > What's here is correct. I won't argue that it won't case confusion
> > or worse.
> 
> Oh, wow, okay.  That needs to change at some point but I agree it's
> out of scope for this patchset.  In the meantime I might suggest using
> something other than AppArmor as an example here.

Similar but not identical situation to:
	BUG: INTEGRITY_POLICY_RULE violates audit message format · Issue #113 · linux-audit/audit-kernel
	https://github.com/linux-audit/audit-kernel/issues/113

> > >>         subj_smack=_
> > >>
> > >> There will be a subj_$LSM= entry for each security module
> > >> LSM that supports the secid_to_secctx and secctx_to_secid
> > >> hooks. The BPF security module implements secid/secctx
> > >> translation hooks, so it has to be considered to provide a
> > >> secctx even though it may not actually do so.
> > >>
> > >> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > >> To: paul@paul-moore.com
> > >> To: linux-audit@redhat.com
> > >> To: rgb@redhat.com
> > >> Cc: netdev@vger.kernel.org
> > >> ---
> > >>  drivers/android/binder.c                |  2 +-
> > >>  include/linux/audit.h                   | 24 ++++++++
> > >>  include/linux/security.h                | 16 ++++-
> > >>  include/net/netlabel.h                  |  3 +-
> > >>  include/net/scm.h                       |  2 +-
> > >>  include/net/xfrm.h                      | 13 +++-
> > >>  include/uapi/linux/audit.h              |  1 +
> > >>  kernel/audit.c                          | 80 ++++++++++++++++++-------
> > >>  kernel/audit.h                          |  3 +
> > >>  kernel/auditfilter.c                    |  6 +-
> > >>  kernel/auditsc.c                        | 75 ++++++++++++++++++++---
> > >>  net/ipv4/ip_sockglue.c                  |  2 +-
> > >>  net/netfilter/nf_conntrack_netlink.c    |  4 +-
> > >>  net/netfilter/nf_conntrack_standalone.c |  2 +-
> > >>  net/netfilter/nfnetlink_queue.c         |  2 +-
> > >>  net/netlabel/netlabel_domainhash.c      |  4 +-
> > >>  net/netlabel/netlabel_unlabeled.c       | 24 ++++----
> > >>  net/netlabel/netlabel_user.c            | 20 ++++---
> > >>  net/netlabel/netlabel_user.h            |  6 +-
> > >>  net/xfrm/xfrm_policy.c                  | 10 ++--
> > >>  net/xfrm/xfrm_state.c                   | 20 ++++---
> > >>  security/integrity/ima/ima_api.c        |  7 ++-
> > >>  security/integrity/integrity_audit.c    |  6 +-
> > >>  security/security.c                     | 46 +++++++++-----
> > >>  security/smack/smackfs.c                |  3 +-
> > >>  25 files changed, 274 insertions(+), 107 deletions(-)
> > > ...
> > >
> > >> diff --git a/include/linux/audit.h b/include/linux/audit.h
> > >> index 97cd7471e572..229cd71fbf09 100644
> > >> --- a/include/linux/audit.h
> > >> +++ b/include/linux/audit.h
> > >> @@ -386,6 +395,19 @@ static inline void audit_ptrace(struct task_struct *t)
> > >>                 __audit_ptrace(t);
> > >>  }
> > >>
> > >> +static inline struct audit_context *audit_alloc_for_lsm(gfp_t gfp)
> > >> +{
> > >> +       struct audit_context *context = audit_context();
> > >> +
> > >> +       if (context)
> > >> +               return context;
> > >> +
> > >> +       if (lsm_multiple_contexts())
> > >> +               return audit_alloc_local(gfp);
> > >> +
> > >> +       return NULL;
> > >> +}
> > > See my other comments, but this seems wrong at face value.  The
> > > additional LSM record should happen as part of the existing audit log
> > > functions.
> >
> > I'm good with that. But if you defer calling audit_alloc_local()
> > until you know you need it you may be in a place where you can't
> > associate the new context with the event. I think. I will have
> > another go at it.
> 
> I can't think of a case where you would ever not know if you need to
> allocate a local context at the start.  If you are unsure, get in
> touch and we can work it out.
> 
> > > I think I was distracted with the local context issue and I've lost
> > > track of the details here, perhaps it's best to fix the local context
> > > issue first (that should be a big change to this patch) and then we
> > > can take another look.
> >
> > I really need to move forward. I'll give allocation of local contexts
> > as necessary in audit_log_task_context() another shot.
> 
> I appreciate the desire to move forward, and while I can't speak for
> everyone, I'll do my best to work with you to find a good solution.
> If you get stuck or aren't sure you know how to reach me :)
> 
> As a start, I might suggest looking at some of the recent audit
> container ID patchsets from Richard; while they have had some issues,
> they should serve as a basic example of what we mean when we talk
> about "local contexts" and how they should be used.
> 
> -- 
> paul moore
> www.paul-moore.com
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://listman.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

