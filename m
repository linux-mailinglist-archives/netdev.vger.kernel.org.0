Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0E9123598
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 20:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfLQTZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 14:25:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53843 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726723AbfLQTZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 14:25:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576610741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y/GSH9L+lqwwKL7tpQxfKMi8HXTb6wPETmNgD2aapTI=;
        b=Yj4w6UN1z1X1lmSkcpQR60ZpawGS4sfw79OAgTnO72Xe3x7I8vq2sX9evfib0l8OaOy2qN
        Bx+Za35xRd4RL7OhYvT/FiqmiLlD//qolutRmvtp3c2sa9RQcYt5tOLsrXH7NeED/bjF7r
        1r543snuSVuVavvBS6eKPV8VlCM5LSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-lXYPbbDPM76NbYRny-Qz6A-1; Tue, 17 Dec 2019 14:25:40 -0500
X-MC-Unique: lXYPbbDPM76NbYRny-Qz6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03576107ACC7;
        Tue, 17 Dec 2019 19:25:38 +0000 (UTC)
Received: from x2.localnet (ovpn-116-249.phx2.redhat.com [10.3.116.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B983610E1;
        Tue, 17 Dec 2019 19:25:29 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
Subject: Re: [PATCH ghak90 V7 06/21] audit: contid limit of 32k imposed to avoid DoS
Date:   Tue, 17 Dec 2019 14:25:29 -0500
Message-ID: <2318345.msVmMTmnKu@x2>
Organization: Red Hat
In-Reply-To: <20191217184541.tagssqt4zujbanf6@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com> <CAHC9VhTrKVQNvTPoX5xdx-TUX_ukpMv2tNFFqLa2Njs17GuQMg@mail.gmail.com> <20191217184541.tagssqt4zujbanf6@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, December 17, 2019 1:45:41 PM EST Richard Guy Briggs wrote:
> On 2019-11-08 12:49, Paul Moore wrote:
> > On Thu, Oct 24, 2019 at 5:23 PM Richard Guy Briggs <rgb@redhat.com> 
wrote:
> > > On 2019-10-10 20:38, Paul Moore wrote:
> > > > On Fri, Sep 27, 2019 at 8:52 AM Neil Horman <nhorman@tuxdriver.com> 
wrote:
> > > > > On Wed, Sep 18, 2019 at 09:22:23PM -0400, Richard Guy Briggs wrote:
> > > > > > Set an arbitrary limit on the number of audit container
> > > > > > identifiers to
> > > > > > limit abuse.
> > > > > > 
> > > > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > > > ---
> > > > > > kernel/audit.c | 8 ++++++++
> > > > > > kernel/audit.h | 4 ++++
> > > > > > 2 files changed, 12 insertions(+)
> > > > > > 
> > > > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > > > index 53d13d638c63..329916534dd2 100644
> > > > > > --- a/kernel/audit.c
> > > > > > +++ b/kernel/audit.c
> > > > 
> > > > ...
> > > > 
> > > > > > @@ -2465,6 +2472,7 @@ int audit_set_contid(struct task_struct
> > > > > > *task, u64 contid) newcont->owner = current;
> > > > > > refcount_set(&newcont->refcount, 1);
> > > > > > list_add_rcu(&newcont->list, &audit_contid_hash[h]);
> > > > > > +                             audit_contid_count++;
> > > > > > } else {
> > > > > > rc = -ENOMEM;
> > > > > > goto conterror;
> > > > > > diff --git a/kernel/audit.h b/kernel/audit.h
> > > > > > index 162de8366b32..543f1334ba47 100644
> > > > > > --- a/kernel/audit.h
> > > > > > +++ b/kernel/audit.h
> > > > > > @@ -219,6 +219,10 @@ static inline int audit_hash_contid(u64
> > > > > > contid)
> > > > > > return (contid & (AUDIT_CONTID_BUCKETS-1));
> > > > > > }
> > > > > > 
> > > > > > +extern int audit_contid_count;
> > > > > > +
> > > > > > +#define AUDIT_CONTID_COUNT   1 << 16
> > > > > > +
> > > > > 
> > > > > Just to ask the question, since it wasn't clear in the changelog,
> > > > > what
> > > > > abuse are you avoiding here?  Ostensibly you should be able to
> > > > > create as
> > > > > many container ids as you have space for, and the simple creation
> > > > > of
> > > > > container ids doesn't seem like the resource strain I would be
> > > > > concerned
> > > > > about here, given that an orchestrator can still create as many
> > > > > containers as the system will otherwise allow, which will consume
> > > > > significantly more ram/disk/etc.
> > > > 
> > > > I've got a similar question.  Up to this point in the patchset, there
> > > > is a potential issue of hash bucket chain lengths and traversing them
> > > > with a spinlock held, but it seems like we shouldn't be putting an
> > > > arbitrary limit on audit container IDs unless we have a good reason
> > > > for it.  If for some reason we do want to enforce a limit, it should
> > > > probably be a tunable value like a sysctl, or similar.
> > > 
> > > Can you separate and clarify the concerns here?
> > 
> > "Why are you doing this?" is about as simple as I can pose the question.
> 
> It was more of a concern for total system resources, primarily memory,
> but this is self-limiting and an arbitrary concern.
> 
> The other limit of depth of nesting has different concerns that arise
> depending on how reporting is done.

Well, there is a limit on the audit record size. So, whatever is being sent 
in the record plus the size of the timestamp deducted from 
MAX_AUDIT_MESSAGE_LENGTH (8970) is the limit. That can be divided by however 
many ID's fit in that space and you have the real limit.

-Steve

-Steve



