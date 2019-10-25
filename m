Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4021E548C
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 21:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfJYToV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 15:44:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38781 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727453AbfJYToU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 15:44:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572032660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gjP7lTTjpTfakTXfOsGFWUmjZaWNVRnXwyVyG8tVt5E=;
        b=g1NSkzY+81DL8fIl6+i5hmRZJ03l6kAgyYmSOkhDMJ5NTOr+sW5mO2XtFKS7hUMChOXD/5
        ILH5a1Q+0oBYNY0uhcBOwELx5idmPDH7vKVXUdAKBfRAzUMfgBjy33r1KsAIj+e2Mbrarw
        RWncQqX0CgYIYalqWr64qU6tHe7If7Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-2mG1hvoOMmKqLeTPX6Nl1w-1; Fri, 25 Oct 2019 15:44:16 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EEE7801E66;
        Fri, 25 Oct 2019 19:44:13 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AED061001B23;
        Fri, 25 Oct 2019 19:43:59 +0000 (UTC)
Date:   Fri, 25 Oct 2019 15:43:56 -0400
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
Subject: Re: [PATCH ghak90 V7 05/21] audit: log drop of contid on exit of
 last task
Message-ID: <20191025194356.skqebldthpokwd2m@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <71b75f54342f32f176c2b6d94584f2a666964e68.1568834524.git.rgb@redhat.com>
 <CAHC9VhQYVzGKRx48dgX1j3CJOe1N0widkhWb=_-3ohnOdZHhUw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQYVzGKRx48dgX1j3CJOe1N0widkhWb=_-3ohnOdZHhUw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 2mG1hvoOMmKqLeTPX6Nl1w-1
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
> > Since we are tracking the life of each audit container indentifier, we
> > can match the creation event with the destruction event.  Log the
> > destruction of the audit container identifier when the last process in
> > that container exits.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/audit.c   | 32 ++++++++++++++++++++++++++++++++
> >  kernel/audit.h   |  2 ++
> >  kernel/auditsc.c |  2 ++
> >  3 files changed, 36 insertions(+)
> >
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index ea0899130cc1..53d13d638c63 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -2503,6 +2503,38 @@ int audit_set_contid(struct task_struct *task, u=
64 contid)
> >         return rc;
> >  }
> >
> > +void audit_log_container_drop(void)
> > +{
> > +       struct audit_buffer *ab;
> > +       uid_t uid;
> > +       struct tty_struct *tty;
> > +       char comm[sizeof(current->comm)];
> > +
> > +       if (!current->audit || !current->audit->cont ||
> > +           refcount_read(&current->audit->cont->refcount) > 1)
> > +               return;
> > +       ab =3D audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTA=
INER_OP);
> > +       if (!ab)
> > +               return;
> > +
> > +       uid =3D from_kuid(&init_user_ns, task_uid(current));
> > +       tty =3D audit_get_tty();
> > +       audit_log_format(ab,
> > +                        "op=3Ddrop opid=3D%d contid=3D%llu old-contid=
=3D%llu pid=3D%d uid=3D%u auid=3D%u tty=3D%s ses=3D%u",
> > +                        task_tgid_nr(current), audit_get_contid(curren=
t),
> > +                        audit_get_contid(current), task_tgid_nr(curren=
t), uid,
> > +                        from_kuid(&init_user_ns, audit_get_loginuid(cu=
rrent)),
> > +                        tty ? tty_name(tty) : "(none)",
> > +                                audit_get_sessionid(current));
> > +       audit_put_tty(tty);
> > +       audit_log_task_context(ab);
> > +       audit_log_format(ab, " comm=3D");
> > +       audit_log_untrustedstring(ab, get_task_comm(comm, current));
> > +       audit_log_d_path_exe(ab, current->mm);
> > +       audit_log_format(ab, " res=3D1");
> > +       audit_log_end(ab);
> > +}
>=20
> Why can't we just do this in audit_cont_put()?  Is it because we call
> audit_cont_put() in the new audit_free() function?  What if we were to
> do it in __audit_free()/audit_free_syscall()?

The intent was to put this before the EOE record of a syscall so we
could fill out all the fields similarly to op=3Dset, but this could stand
alone dropping or nulling a bunch of fields.

It would also never get printed if we left it before the EOE and had the
audit signal info record keep a reference to it.

Hmmm...

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

