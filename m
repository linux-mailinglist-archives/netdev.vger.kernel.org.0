Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6659315B3FD
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 23:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgBLWjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 17:39:09 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53208 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729149AbgBLWjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 17:39:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581547148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aHRhn6tYA2uPSVh6/rkm63iog4UAvaa+4hT5pNyhnbA=;
        b=POS2kwkzakBTOUzvIh6tTg3Vr3rS+fQya405N/TmX8Mp4ejvVP0oHovl2WeKVkri5T50ki
        0JHRkyy/NMBohuTY2+zUp45GisA4+/PgOMe6cni7ODZeCDPd68LMvBUv07beRCwR2lhXl/
        /qDw6iDs07Z/P2gYF3LszE6PfmlclD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-wICrGc1-NMGw74EGxDF9nw-1; Wed, 12 Feb 2020 17:38:58 -0500
X-MC-Unique: wICrGc1-NMGw74EGxDF9nw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 115101800D6B;
        Wed, 12 Feb 2020 22:38:56 +0000 (UTC)
Received: from x2.localnet (ovpn-116-254.phx2.redhat.com [10.3.116.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2713A19C6A;
        Wed, 12 Feb 2020 22:38:46 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     linux-audit@redhat.com
Cc:     Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>, nhorman@tuxdriver.com,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling the audit daemon
Date:   Wed, 12 Feb 2020 17:38:45 -0500
Message-ID: <3142237.YMNxv0uec1@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhQquokw+7UOU=G0SsD35UdgmfysVKCGCE87JVaoTkbisg@mail.gmail.com>
References: <cover.1577736799.git.rgb@redhat.com> <20200204231454.oxa7pyvuxbj466fj@madcap2.tricolour.ca> <CAHC9VhQquokw+7UOU=G0SsD35UdgmfysVKCGCE87JVaoTkbisg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, February 5, 2020 5:50:28 PM EST Paul Moore wrote:
> > > > > ... When we record the audit container ID in audit_signal_info() we
> > > > > take an extra reference to the audit container ID object so that it
> > > > > will not disappear (and get reused) until after we respond with an
> > > > > AUDIT_SIGNAL_INFO2.  In audit_receive_msg() when we do the
> > > > > AUDIT_SIGNAL_INFO2 processing we drop the extra reference we took
> > > > > in
> > > > > audit_signal_info().  Unless I'm missing some other change you
> > > > > made,
> > > > > this *shouldn't* affect the syscall records, all it does is
> > > > > preserve
> > > > > the audit container ID object in the kernel's ACID store so it
> > > > > doesn't
> > > > > get reused.
> > > > 
> > > > This is exactly what I had understood.  I hadn't considered the extra
> > > > details below in detail due to my original syscall concern, but they
> > > > make sense.
> > > > 
> > > > The syscall I refer to is the one connected with the drop of the
> > > > audit container identifier by the last process that was in that
> > > > container in patch 5/16.  The production of this record is contingent
> > > > on
> > > > the last ref in a contobj being dropped.  So if it is due to that ref
> > > > being maintained by audit_signal_info() until the AUDIT_SIGNAL_INFO2
> > > > record it fetched, then it will appear that the fetch action closed
> > > > the
> > > > container rather than the last process in the container to exit.
> > > > 
> > > > Does this make sense?
> > > 
> > > More so than your original reply, at least to me anyway.
> > > 
> > > It makes sense that the audit container ID wouldn't be marked as
> > > "dead" since it would still be very much alive and available for use
> > > by the orchestrator, the question is if that is desirable or not.  I
> > > think the answer to this comes down the preserving the correctness of
> > > the audit log.
> > > 
> > > If the audit container ID reported by AUDIT_SIGNAL_INFO2 has been
> > > reused then I think there is a legitimate concern that the audit log
> > > is not correct, and could be misleading.  If we solve that by grabbing
> > > an extra reference, then there could also be some confusion as
> > > userspace considers a container to be "dead" while the audit container
> > > ID still exists in the kernel, and the kernel generated audit
> > > container ID death record will not be generated until much later (and
> > > possibly be associated with a different event, but that could be
> > > solved by unassociating the container death record).
> > 
> > How does syscall association of the death record with AUDIT_SIGNAL_INFO2
> > possibly get associated with another event?  Or is the syscall
> > association with the fetch for the AUDIT_SIGNAL_INFO2 the other event?
> 
> The issue is when does the audit container ID "die".  If it is when
> the last task in the container exits, then the death record will be
> associated when the task's exit.  If the audit container ID lives on
> until the last reference of it in the audit logs, including the
> SIGNAL_INFO2 message, the death record will be associated with the
> related SIGNAL_INFO2 syscalls, or perhaps unassociated depending on
> the details of the syscalls/netlink.
> 
> > Another idea might be to bump the refcount in audit_signal_info() but
> > mark tht contid as dead so it can't be reused if we are concerned that
> > the dead contid be reused?
> 
> Ooof.  Yes, maybe, but that would be ugly.
> 
> > There is still the problem later that the reported contid is incomplete
> > compared to the rest of the contid reporting cycle wrt nesting since
> > AUDIT_SIGNAL_INFO2 will need to be more complex w/2 variable length
> > fields to accommodate a nested contid list.
> 
> Do we really care about the full nested audit container ID list in the
> SIGNAL_INFO2 record?
> 
> > > Of the two
> > > approaches, I think the latter is safer in that it preserves the
> > > correctness of the audit log, even though it could result in a delay
> > > of the container death record.
> > 
> > I prefer the former since it strongly indicates last task in the
> > container.  The AUDIT_SIGNAL_INFO2 msg has the pid and other subject
> > attributes and the contid to strongly link the responsible party.
> 
> Steve is the only one who really tracks the security certifications
> that are relevant to audit, see what the certification requirements
> have to say and we can revisit this.

Sever Virtualization Protection Profile is the closest applicable standard

https://www.niap-ccevs.org/Profile/Info.cfm?PPID=408&id=408

It is silent on audit requirements for the lifecycle of a VM. I assume that 
all that is needed is what the orchestrator says its doing at the high level. 
So, if an orchestrator wants to shutdown a container, the orchestrator must 
log that intent and its results. In a similar fashion, systemd logs that it's 
killing a service and we don't actually hook the exit syscall of the service 
to record that.

Now, if a container was being used as a VPS, and it had a fully functioning 
userspace, it's own services, and its very own audit daemon, then in this 
case it would care who sent a signal to its auditd. The tenant of that 
container may have to comply with PCI-DSS or something else. It would log the 
audit service is being terminated and systemd would record that its tearing 
down the environment. The OS doesn't need to do anything.

-Steve


