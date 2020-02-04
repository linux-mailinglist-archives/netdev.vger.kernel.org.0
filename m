Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B80D1522A5
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 00:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgBDXC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 18:02:57 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37193 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgBDXC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 18:02:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580857375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NKr69gnaNBcjsWSr0bho3ksQ06JauqQQ0HsRD8GC1SM=;
        b=WR7NDBJTcIJlQtvVsUkAYJI4bZUoP9SV8ujxf3RFiicJTBPwNw5tX8ODyYf5Oa3xjXeuAK
        30gWx/idw2srPJY0Z9TwH4CluK6acKFvQxBuLtTy7CU91SsmGMviZh421scr4WCjl/iKP5
        FE/iIg2EsySMZs0lO5pks8km4T2yYx4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-MhIqW77NP0-JlIJr67CfLA-1; Tue, 04 Feb 2020 18:02:53 -0500
X-MC-Unique: MhIqW77NP0-JlIJr67CfLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C227A18AB2C0;
        Tue,  4 Feb 2020 23:02:51 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E6D4877927;
        Tue,  4 Feb 2020 23:02:37 +0000 (UTC)
Date:   Tue, 4 Feb 2020 18:02:35 -0500
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
Subject: Re: [PATCH ghak90 V8 05/16] audit: log drop of contid on exit of
 last task
Message-ID: <20200204230235.dwunh76dum4kkssp@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <b3725abab452beaba740ac58f76144e6c3bda2fa.1577736799.git.rgb@redhat.com>
 <CAHC9VhQ=+4P6Rr1S1-sNb2X-CbYYKMQMJDGP=bBr8GG3xLD8qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQ=+4P6Rr1S1-sNb2X-CbYYKMQMJDGP=bBr8GG3xLD8qQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-22 16:28, Paul Moore wrote:
> On Tue, Dec 31, 2019 at 2:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Since we are tracking the life of each audit container indentifier, we
> > can match the creation event with the destruction event.  Log the
> > destruction of the audit container identifier when the last process in
> > that container exits.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/audit.c   | 17 +++++++++++++++++
> >  kernel/audit.h   |  2 ++
> >  kernel/auditsc.c |  2 ++
> >  3 files changed, 21 insertions(+)
> >
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 4bab20f5f781..fa8f1aa3a605 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -2502,6 +2502,23 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> >         return rc;
> >  }
> >
> > +void audit_log_container_drop(void)
> > +{
> > +       struct audit_buffer *ab;
> > +
> > +       if (!current->audit || !current->audit->cont ||
> > +           refcount_read(&current->audit->cont->refcount) > 1)
> > +               return;
> > +       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
> > +       if (!ab)
> > +               return;
> > +
> > +       audit_log_format(ab, "op=drop opid=%d contid=%llu old-contid=%llu",
> > +                        task_tgid_nr(current), audit_get_contid(current),
> > +                        audit_get_contid(current));
> > +       audit_log_end(ab);
> > +}
> 
> Assumine we are careful about where we call it in audit_free(...), you
> are confident we can't do this as part of _audit_contobj_put(...),
> yes?

We need audit_log_container_drop in audit_free_syscall() due to needing
context, which gets freed in audit_free_syscall() called from
audit_free().

We need audit_log_container_drop in audit_log_exit() due to having that
record included before the EOE record at the end of audit_log_exit().

We could put in _contobj_put() if we drop context and any attempt to
connect it with a syscall record, which I strongly discourage.

The syscall record contains info about subject, container_id record only
contains info about container object other than subj pid.

> >  /**
> >   * audit_log_end - end one audit record
> >   * @ab: the audit_buffer
> > diff --git a/kernel/audit.h b/kernel/audit.h
> > index e4a31aa92dfe..162de8366b32 100644
> > --- a/kernel/audit.h
> > +++ b/kernel/audit.h
> > @@ -255,6 +255,8 @@ extern void audit_log_d_path_exe(struct audit_buffer *ab,
> >  extern struct tty_struct *audit_get_tty(void);
> >  extern void audit_put_tty(struct tty_struct *tty);
> >
> > +extern void audit_log_container_drop(void);
> > +
> >  /* audit watch/mark/tree functions */
> >  #ifdef CONFIG_AUDITSYSCALL
> >  extern unsigned int audit_serial(void);
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 0e2d50533959..bd855794ad26 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -1568,6 +1568,8 @@ static void audit_log_exit(void)
> >
> >         audit_log_proctitle();
> >
> > +       audit_log_container_drop();
> > +
> >         /* Send end of event record to help user space know we are finished */
> >         ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
> >         if (ab)
> > --
> > 1.8.3.1
> >
> 
> --
> paul moore
> www.paul-moore.com
> 

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

