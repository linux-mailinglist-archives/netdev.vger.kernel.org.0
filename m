Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831F6E3E13
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbfJXVYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:24:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46128 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728917AbfJXVX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571952237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FrgDI2gW2aiugtgpqG1ZL6sF4tooWRGmsSjSW32gsYw=;
        b=bmWL0fM9TfiU0L3s6Q7hPUVkQwlrUGJa7P7YCgHqiFrezv/LfumiMZFk9ogXYOr7L12VZr
        j62BKLaDzYK+Kk8WOPP33//lis/5sGUTiBb6ukG/u0AUCaDtmmHO+dqYb2jDoTMfub+svE
        o5CcXu7NAAXja6niON+bYvy4SSe/1iM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-PWtRXmUyOIOZMecadsE0tQ-1; Thu, 24 Oct 2019 17:23:53 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C68E7476;
        Thu, 24 Oct 2019 21:23:51 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 13D9D600C6;
        Thu, 24 Oct 2019 21:23:37 +0000 (UTC)
Date:   Thu, 24 Oct 2019 17:23:35 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
Subject: Re: [PATCH ghak90 V7 06/21] audit: contid limit of 32k imposed to
 avoid DoS
Message-ID: <20191024212335.y4ou7g4tsxnotvnk@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <230e91cd3e50a3d8015daac135c24c4c58cf0a21.1568834524.git.rgb@redhat.com>
 <20190927125142.GA25764@hmswarspite.think-freely.org>
 <CAHC9VhRbSUCB0OZorC4+y+5uJDR5uMXdRn2LOTYGu2gcFJSrcA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRbSUCB0OZorC4+y+5uJDR5uMXdRn2LOTYGu2gcFJSrcA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: PWtRXmUyOIOZMecadsE0tQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-10 20:38, Paul Moore wrote:
> On Fri, Sep 27, 2019 at 8:52 AM Neil Horman <nhorman@tuxdriver.com> wrote=
:
> > On Wed, Sep 18, 2019 at 09:22:23PM -0400, Richard Guy Briggs wrote:
> > > Set an arbitrary limit on the number of audit container identifiers t=
o
> > > limit abuse.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  kernel/audit.c | 8 ++++++++
> > >  kernel/audit.h | 4 ++++
> > >  2 files changed, 12 insertions(+)
> > >
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index 53d13d638c63..329916534dd2 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
>=20
> ...
>=20
> > > @@ -2465,6 +2472,7 @@ int audit_set_contid(struct task_struct *task, =
u64 contid)
> > >                               newcont->owner =3D current;
> > >                               refcount_set(&newcont->refcount, 1);
> > >                               list_add_rcu(&newcont->list, &audit_con=
tid_hash[h]);
> > > +                             audit_contid_count++;
> > >                       } else {
> > >                               rc =3D -ENOMEM;
> > >                               goto conterror;
> > > diff --git a/kernel/audit.h b/kernel/audit.h
> > > index 162de8366b32..543f1334ba47 100644
> > > --- a/kernel/audit.h
> > > +++ b/kernel/audit.h
> > > @@ -219,6 +219,10 @@ static inline int audit_hash_contid(u64 contid)
> > >       return (contid & (AUDIT_CONTID_BUCKETS-1));
> > >  }
> > >
> > > +extern int audit_contid_count;
> > > +
> > > +#define AUDIT_CONTID_COUNT   1 << 16
> > > +
> >
> > Just to ask the question, since it wasn't clear in the changelog, what
> > abuse are you avoiding here?  Ostensibly you should be able to create a=
s
> > many container ids as you have space for, and the simple creation of
> > container ids doesn't seem like the resource strain I would be concerne=
d
> > about here, given that an orchestrator can still create as many
> > containers as the system will otherwise allow, which will consume
> > significantly more ram/disk/etc.
>=20
> I've got a similar question.  Up to this point in the patchset, there
> is a potential issue of hash bucket chain lengths and traversing them
> with a spinlock held, but it seems like we shouldn't be putting an
> arbitrary limit on audit container IDs unless we have a good reason
> for it.  If for some reason we do want to enforce a limit, it should
> probably be a tunable value like a sysctl, or similar.

Can you separate and clarify the concerns here?

I plan to move this patch to the end of the patchset and make it
optional, possibly adding a tuning mechanism.  Like the migration from
/proc to netlink for loginuid/sessionid/contid/capcontid, this was Eric
Biederman's concern and suggested mitigation.

As for the first issue of the bucket chain length traversal while
holding the list spin-lock, would you prefer to use the rcu lock to
traverse the list and then only hold the spin-lock when modifying the
list, and possibly even make the spin-lock more fine-grained per list?

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

