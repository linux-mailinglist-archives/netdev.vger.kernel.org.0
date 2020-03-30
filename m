Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE351982AE
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbgC3Rt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:49:58 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:21342 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728124AbgC3Rt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:49:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585590595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VXITz6a4t0dcGhoFiL5Naxzq4cQ+raar83CvULBdiIM=;
        b=J4wClz1uCUf5n7uKF/GH/AxuEn5rJpwnGkaLlIeNoy+4WI0JyQ4z1bHlodNg3jBr9eq6bf
        La2YNVuMQTwA87+9uUflBi2g+aIBmOQtqu6pGzM4NMvJHtk4RSEDFcXEClgVnJzHnBvGYU
        gcd1Ia3hD22JOXDPfatNG829l4gJv9A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-apH4BbMWM2eldESph-N2Pw-1; Mon, 30 Mar 2020 13:49:54 -0400
X-MC-Unique: apH4BbMWM2eldESph-N2Pw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E72128017CC;
        Mon, 30 Mar 2020 17:49:51 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C8319128F;
        Mon, 30 Mar 2020 17:49:40 +0000 (UTC)
Date:   Mon, 30 Mar 2020 13:49:37 -0400
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
Message-ID: <20200330174937.xalrsiev7q3yxsx2@madcap2.tricolour.ca>
References: <20200318215550.es4stkjwnefrfen2@madcap2.tricolour.ca>
 <CAHC9VhSdDDP7Ec-w61NhGxZG5ZiekmrBCAg=Y=VJvEZcgQh46g@mail.gmail.com>
 <20200319220249.jyr6xmwvflya5mks@madcap2.tricolour.ca>
 <CAHC9VhR84aN72yNB_j61zZgrQV1y6yvrBLNY7jp7BqQiEDL+cw@mail.gmail.com>
 <20200324210152.5uydf3zqi3dwshfu@madcap2.tricolour.ca>
 <CAHC9VhTQUnVhoN3JXTAQ7ti+nNLfGNVXhT6D-GYJRSpJHCwDRg@mail.gmail.com>
 <20200330134705.jlrkoiqpgjh3rvoh@madcap2.tricolour.ca>
 <CAHC9VhQTsEMcYAF1CSHrrVn07DR450W9j6sFVfKAQZ0VpheOfw@mail.gmail.com>
 <20200330162156.mzh2tsnovngudlx2@madcap2.tricolour.ca>
 <CAHC9VhTRzZXJ6yUFL+xZWHNWZFTyiizBK12ntrcSwmgmySbkWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTRzZXJ6yUFL+xZWHNWZFTyiizBK12ntrcSwmgmySbkWw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-30 13:34, Paul Moore wrote:
> On Mon, Mar 30, 2020 at 12:22 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-03-30 10:26, Paul Moore wrote:
> > > On Mon, Mar 30, 2020 at 9:47 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > On 2020-03-28 23:11, Paul Moore wrote:
> > > > > On Tue, Mar 24, 2020 at 5:02 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > On 2020-03-23 20:16, Paul Moore wrote:
> > > > > > > On Thu, Mar 19, 2020 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > > > On 2020-03-18 18:06, Paul Moore wrote:
> > > > > > >
> > > > > > > ...
> > > > > > >
> > > > > > > > > I hope we can do better than string manipulations in the kernel.  I'd
> > > > > > > > > much rather defer generating the ACID list (if possible), than
> > > > > > > > > generating a list only to keep copying and editing it as the record is
> > > > > > > > > sent.
> > > > > > > >
> > > > > > > > At the moment we are stuck with a string-only format.
> > > > > > >
> > > > > > > Yes, we are.  That is another topic, and another set of changes I've
> > > > > > > been deferring so as to not disrupt the audit container ID work.
> > > > > > >
> > > > > > > I was thinking of what we do inside the kernel between when the record
> > > > > > > triggering event happens and when we actually emit the record to
> > > > > > > userspace.  Perhaps we collect the ACID information while the event is
> > > > > > > occurring, but we defer generating the record until later when we have
> > > > > > > a better understanding of what should be included in the ACID list.
> > > > > > > It is somewhat similar (but obviously different) to what we do for
> > > > > > > PATH records (we collect the pathname info when the path is being
> > > > > > > resolved).
> > > > > >
> > > > > > Ok, now I understand your concern.
> > > > > >
> > > > > > In the case of NETFILTER_PKT records, the CONTAINER_ID record is the
> > > > > > only other possible record and they are generated at the same time with
> > > > > > a local context.
> > > > > >
> > > > > > In the case of any event involving a syscall, that CONTAINER_ID record
> > > > > > is generated at the time of the rest of the event record generation at
> > > > > > syscall exit.
> > > > > >
> > > > > > The others are only generated when needed, such as the sig2 reply.
> > > > > >
> > > > > > We generally just store the contobj pointer until we actually generate
> > > > > > the CONTAINER_ID (or CONTAINER_OP) record.
> > > > >
> > > > > Perhaps I'm remembering your latest spin of these patches incorrectly,
> > > > > but there is still a big gap between when the record is generated and
> > > > > when it is sent up to the audit daemon.  Most importantly in that gap
> > > > > is the whole big queue/multicast/unicast mess.
> > > >
> > > > So you suggest generating that record on the fly once it reaches the end
> > > > of the audit_queue just before being sent?  That sounds...  disruptive.
> > > > Each audit daemon is going to have its own queues, so by the time it
> > > > ends up in a particular queue, we'll already know its scope and would
> > > > have the right list of contids to print in that record.
> > >
> > > I'm not suggesting any particular solution, I'm just pointing out a
> > > potential problem.  It isn't clear to me that you've thought about how
> > > we generate a multiple records, each with the correct ACID list
> > > intended for a specific audit daemon, based on a single audit event.
> > > Explain to me how you intend that to work and we are good.  Be
> > > specific because I'm not convinced we are talking on the same plane
> > > here.
> >
> > Well, every time a record gets generated, *any* record gets generated,
> > we'll need to check for which audit daemons this record is in scope and
> > generate a different one for each depending on the content and whether
> > or not the content is influenced by the scope.
> 
> That's the problem right there - we don't want to have to generate a
> unique record for *each* auditd on *every* record.  That is a recipe
> for disaster.

I don't see how we can get around this.

We will already have that problem for PIDs in different PID namespaces.

We already need to use a different serial number in each auditd/queue,
or else we serialize *all* audit events on the machine and either leak
information to the nested daemons that there are other events happenning
on the machine, or confuse the host daemon because it now thinks that we
are losing events due to serial numbers missing because some nested
daemon issued an event that was not relevant to the host daemon,
consuming a globally serial audit message sequence number.

> Solving this for all of the known audit records is not something we
> need to worry about in depth at the moment (although giving it some
> casual thought is not a bad thing), but solving this for the audit
> container ID information *is* something we need to worry about right
> now.

If you think that a different nested contid value string per daemon is
not acceptable, then we are back to issuing a record that has only *one*
contid listed without any nesting information.  This brings us back to
the original problem of keeping *all* audit log history since the boot
of the machine to be able to track the nesting of any particular contid.

What am I missing?  What do you suggest?

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

