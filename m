Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7647B1522E9
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 00:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgBDXPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 18:15:20 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20152 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727678AbgBDXPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 18:15:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580858118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oE+GbwjQPEUxQxgoqp1axXub52iza+nsVW7DZrtJxPM=;
        b=NIIqRq5R0lblUTuQnMKIHT8+haQ/NGEy9YKSeRT1eOYKai8q7ODVpmYWnJ7GUWCT33mfHM
        uWw0YmPTzBWqpE3IvEn5AJ8NrK4lzXByB+22zpl6syK4k48uTNjBVz1n0NtLUCQ2tWS/Tb
        We58eDAD6OJ+HnSaZHCb3kCIc/uc/hw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-KJ8fBWDAPoyKV5DcK0QoQg-1; Tue, 04 Feb 2020 18:15:13 -0500
X-MC-Unique: KJ8fBWDAPoyKV5DcK0QoQg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E6CC1084449;
        Tue,  4 Feb 2020 23:15:11 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34FAD5DA2C;
        Tue,  4 Feb 2020 23:14:57 +0000 (UTC)
Date:   Tue, 4 Feb 2020 18:14:54 -0500
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
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
Message-ID: <20200204231454.oxa7pyvuxbj466fj@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <7d7933d742fdf4a94c84b791906a450b16f2e81f.1577736799.git.rgb@redhat.com>
 <CAHC9VhSuwJGryfrBfzxG01zwb-O_7dbjS0x0a3w-XjcNuYSAcg@mail.gmail.com>
 <20200123162918.b3jbed7tbvr2sf2p@madcap2.tricolour.ca>
 <CAHC9VhTusiQoudB8G5jjDFyM9WxBUAjZ6_X35ywJ063Jb75dQA@mail.gmail.com>
 <20200123200412.j2aucdp3cvk57prw@madcap2.tricolour.ca>
 <CAHC9VhQ2_MQdGAT6Pda9FRe6s0y4JC1XUQenpr-VJiyq9M_CBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQ2_MQdGAT6Pda9FRe6s0y4JC1XUQenpr-VJiyq9M_CBw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-23 16:35, Paul Moore wrote:
> On Thu, Jan 23, 2020 at 3:04 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-01-23 12:09, Paul Moore wrote:
> > > On Thu, Jan 23, 2020 at 11:29 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > On 2020-01-22 16:28, Paul Moore wrote:
> > > > > On Tue, Dec 31, 2019 at 2:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > >
> > > > > > Add audit container identifier support to the action of signalling the
> > > > > > audit daemon.
> > > > > >
> > > > > > Since this would need to add an element to the audit_sig_info struct,
> > > > > > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > > > > > audit_sig_info2 struct.  Corresponding support is required in the
> > > > > > userspace code to reflect the new record request and reply type.
> > > > > > An older userspace won't break since it won't know to request this
> > > > > > record type.
> > > > > >
> > > > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > > > ---
> > > > > >  include/linux/audit.h       |  7 +++++++
> > > > > >  include/uapi/linux/audit.h  |  1 +
> > > > > >  kernel/audit.c              | 35 +++++++++++++++++++++++++++++++++++
> > > > > >  kernel/audit.h              |  1 +
> > > > > >  security/selinux/nlmsgtab.c |  1 +
> > > > > >  5 files changed, 45 insertions(+)
> > > > >
> > > > > ...
> > > > >
> > > > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > > > index 0871c3e5d6df..51159c94041c 100644
> > > > > > --- a/kernel/audit.c
> > > > > > +++ b/kernel/audit.c
> > > > > > @@ -126,6 +126,14 @@ struct auditd_connection {
> > > > > >  kuid_t         audit_sig_uid = INVALID_UID;
> > > > > >  pid_t          audit_sig_pid = -1;
> > > > > >  u32            audit_sig_sid = 0;
> > > > > > +/* Since the signal information is stored in the record buffer at the
> > > > > > + * time of the signal, but not retrieved until later, there is a chance
> > > > > > + * that the last process in the container could terminate before the
> > > > > > + * signal record is delivered.  In this circumstance, there is a chance
> > > > > > + * the orchestrator could reuse the audit container identifier, causing
> > > > > > + * an overlap of audit records that refer to the same audit container
> > > > > > + * identifier, but a different container instance.  */
> > > > > > +u64            audit_sig_cid = AUDIT_CID_UNSET;
> > > > >
> > > > > I believe we could prevent the case mentioned above by taking an
> > > > > additional reference to the audit container ID object when the signal
> > > > > information is collected, dropping it only after the signal
> > > > > information is collected by userspace or another process signals the
> > > > > audit daemon.  Yes, it would block that audit container ID from being
> > > > > reused immediately, but since we are talking about one number out of
> > > > > 2^64 that seems like a reasonable tradeoff.
> > > >
> > > > I had thought that through and should have been more explicit about that
> > > > situation when I documented it.  We could do that, but then the syscall
> > > > records would be connected with the call from auditd on shutdown to
> > > > request that signal information, rather than the exit of that last
> > > > process that was using that container.  This strikes me as misleading.
> > > > Is that really what we want?
> > >
> > >  ???
> > >
> > > I think one of us is not understanding the other; maybe it's me, maybe
> > > it's you, maybe it's both of us.
> > >
> > > Anyway, here is what I was trying to convey with my original comment
> > > ... When we record the audit container ID in audit_signal_info() we
> > > take an extra reference to the audit container ID object so that it
> > > will not disappear (and get reused) until after we respond with an
> > > AUDIT_SIGNAL_INFO2.  In audit_receive_msg() when we do the
> > > AUDIT_SIGNAL_INFO2 processing we drop the extra reference we took in
> > > audit_signal_info().  Unless I'm missing some other change you made,
> > > this *shouldn't* affect the syscall records, all it does is preserve
> > > the audit container ID object in the kernel's ACID store so it doesn't
> > > get reused.
> >
> > This is exactly what I had understood.  I hadn't considered the extra
> > details below in detail due to my original syscall concern, but they
> > make sense.
> >
> > The syscall I refer to is the one connected with the drop of the
> > audit container identifier by the last process that was in that
> > container in patch 5/16.  The production of this record is contingent on
> > the last ref in a contobj being dropped.  So if it is due to that ref
> > being maintained by audit_signal_info() until the AUDIT_SIGNAL_INFO2
> > record it fetched, then it will appear that the fetch action closed the
> > container rather than the last process in the container to exit.
> >
> > Does this make sense?
> 
> More so than your original reply, at least to me anyway.
> 
> It makes sense that the audit container ID wouldn't be marked as
> "dead" since it would still be very much alive and available for use
> by the orchestrator, the question is if that is desirable or not.  I
> think the answer to this comes down the preserving the correctness of
> the audit log.
> 
> If the audit container ID reported by AUDIT_SIGNAL_INFO2 has been
> reused then I think there is a legitimate concern that the audit log
> is not correct, and could be misleading.  If we solve that by grabbing
> an extra reference, then there could also be some confusion as
> userspace considers a container to be "dead" while the audit container
> ID still exists in the kernel, and the kernel generated audit
> container ID death record will not be generated until much later (and
> possibly be associated with a different event, but that could be
> solved by unassociating the container death record).

How does syscall association of the death record with AUDIT_SIGNAL_INFO2
possibly get associated with another event?  Or is the syscall
association with the fetch for the AUDIT_SIGNAL_INFO2 the other event?

Another idea might be to bump the refcount in audit_signal_info() but
mark tht contid as dead so it can't be reused if we are concerned that
the dead contid be reused?

There is still the problem later that the reported contid is incomplete
compared to the rest of the contid reporting cycle wrt nesting since
AUDIT_SIGNAL_INFO2 will need to be more complex w/2 variable length
fields to accommodate a nested contid list.

>  Of the two
> approaches, I think the latter is safer in that it preserves the
> correctness of the audit log, even though it could result in a delay
> of the container death record.

I prefer the former since it strongly indicates last task in the
container.  The AUDIT_SIGNAL_INFO2 msg has the pid and other subject
attributes and the contid to strongly link the responsible party.

> Neither way is perfect, so if you have any other ideas I'm all ears.
> 
> > > (We do need to do some extra housekeeping in audit_signal_info() to
> > > deal with the case where nobody asks for AUDIT_SIGNAL_INFO2 -
> > > basically if audit_sig_cid is not NULL we should drop a reference
> > > before assigning it a new object pointer, and of course we would need
> > > to set audit_sig_cid to NULL in audit_receive_msg() after sending it
> > > up to userspace and dropping the extra ref.)
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

