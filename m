Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1911980E7
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730152AbgC3QWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:22:18 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:20861 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730129AbgC3QWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585585336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k+yBj47l32LVBbz2jRZtiKef8dIq37Wt9sqzi7Fkfu4=;
        b=im1h3IT0YR1cX/SERGSMwRO1MymCiaTG/maYu7OXBZm4KgWgR8YVw1Yu4K+AUZXOq+J5GH
        tDrVVQDCL1wsQWsz2ZjRJMjX0cVp/NzieJJdrKjDvZTv5TsMC4JVtVIhw8uj8yP5BXqOpO
        vYT+sz4vsBoOTA4hD8AH3oDyNVnlkcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-QIA7gM9eOLOM-Zr4ZAPSiQ-1; Mon, 30 Mar 2020 12:22:13 -0400
X-MC-Unique: QIA7gM9eOLOM-Zr4ZAPSiQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFE1F1005509;
        Mon, 30 Mar 2020 16:22:10 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AAD260BE1;
        Mon, 30 Mar 2020 16:21:58 +0000 (UTC)
Date:   Mon, 30 Mar 2020 12:21:56 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
        ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
Message-ID: <20200330162156.mzh2tsnovngudlx2@madcap2.tricolour.ca>
References: <20200318212630.mw2geg4ykhnbtr3k@madcap2.tricolour.ca>
 <CAHC9VhRYvGAru3aOMwWKCCWDktS+2pGr+=vV4SjHW_0yewD98A@mail.gmail.com>
 <20200318215550.es4stkjwnefrfen2@madcap2.tricolour.ca>
 <CAHC9VhSdDDP7Ec-w61NhGxZG5ZiekmrBCAg=Y=VJvEZcgQh46g@mail.gmail.com>
 <20200319220249.jyr6xmwvflya5mks@madcap2.tricolour.ca>
 <CAHC9VhR84aN72yNB_j61zZgrQV1y6yvrBLNY7jp7BqQiEDL+cw@mail.gmail.com>
 <20200324210152.5uydf3zqi3dwshfu@madcap2.tricolour.ca>
 <CAHC9VhTQUnVhoN3JXTAQ7ti+nNLfGNVXhT6D-GYJRSpJHCwDRg@mail.gmail.com>
 <20200330134705.jlrkoiqpgjh3rvoh@madcap2.tricolour.ca>
 <CAHC9VhQTsEMcYAF1CSHrrVn07DR450W9j6sFVfKAQZ0VpheOfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQTsEMcYAF1CSHrrVn07DR450W9j6sFVfKAQZ0VpheOfw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-30 10:26, Paul Moore wrote:
> On Mon, Mar 30, 2020 at 9:47 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-03-28 23:11, Paul Moore wrote:
> > > On Tue, Mar 24, 2020 at 5:02 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > On 2020-03-23 20:16, Paul Moore wrote:
> > > > > On Thu, Mar 19, 2020 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > On 2020-03-18 18:06, Paul Moore wrote:
> > > > >
> > > > > ...
> > > > >
> > > > > > > I hope we can do better than string manipulations in the kernel.  I'd
> > > > > > > much rather defer generating the ACID list (if possible), than
> > > > > > > generating a list only to keep copying and editing it as the record is
> > > > > > > sent.
> > > > > >
> > > > > > At the moment we are stuck with a string-only format.
> > > > >
> > > > > Yes, we are.  That is another topic, and another set of changes I've
> > > > > been deferring so as to not disrupt the audit container ID work.
> > > > >
> > > > > I was thinking of what we do inside the kernel between when the record
> > > > > triggering event happens and when we actually emit the record to
> > > > > userspace.  Perhaps we collect the ACID information while the event is
> > > > > occurring, but we defer generating the record until later when we have
> > > > > a better understanding of what should be included in the ACID list.
> > > > > It is somewhat similar (but obviously different) to what we do for
> > > > > PATH records (we collect the pathname info when the path is being
> > > > > resolved).
> > > >
> > > > Ok, now I understand your concern.
> > > >
> > > > In the case of NETFILTER_PKT records, the CONTAINER_ID record is the
> > > > only other possible record and they are generated at the same time with
> > > > a local context.
> > > >
> > > > In the case of any event involving a syscall, that CONTAINER_ID record
> > > > is generated at the time of the rest of the event record generation at
> > > > syscall exit.
> > > >
> > > > The others are only generated when needed, such as the sig2 reply.
> > > >
> > > > We generally just store the contobj pointer until we actually generate
> > > > the CONTAINER_ID (or CONTAINER_OP) record.
> > >
> > > Perhaps I'm remembering your latest spin of these patches incorrectly,
> > > but there is still a big gap between when the record is generated and
> > > when it is sent up to the audit daemon.  Most importantly in that gap
> > > is the whole big queue/multicast/unicast mess.
> >
> > So you suggest generating that record on the fly once it reaches the end
> > of the audit_queue just before being sent?  That sounds...  disruptive.
> > Each audit daemon is going to have its own queues, so by the time it
> > ends up in a particular queue, we'll already know its scope and would
> > have the right list of contids to print in that record.
> 
> I'm not suggesting any particular solution, I'm just pointing out a
> potential problem.  It isn't clear to me that you've thought about how
> we generate a multiple records, each with the correct ACID list
> intended for a specific audit daemon, based on a single audit event.
> Explain to me how you intend that to work and we are good.  Be
> specific because I'm not convinced we are talking on the same plane
> here.

Well, every time a record gets generated, *any* record gets generated,
we'll need to check for which audit daemons this record is in scope and
generate a different one for each depending on the content and whether
or not the content is influenced by the scope.  Some events will be
generated for some of the auditd/queues and not for others.  Some fields
in some of the records will need to be tailored for that specific
auditd/queue for either contid scope or PID namespace base reference or
other scope differences.

Every auditd/queue will need its own serial number per event and maybe
even timestamp depending on whether that auditd is in a different time
namespace and beyond that PID and contid fields and maybe others will
need to be customized per auditd/queue.  So, it may make sense to
generate the contents of each field for a generic record and then either
reuse content that is unchanged or generate new content for a field that
will be different in a different auditd/queue scope, then render the
final record per auditd/queue and enqueue it.

I see this as the primary work of ghak93 ("RFE: run multiple audit
daemons on one machine").  I don't see how our proposed contid field
value format changes with this path above.

This is getting closer and closer to a netlink binary format too...

This is also an argument for spreading fields out over more record types
rather than cramming as much information as we can into one record type
(subject attributes in particular).

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

