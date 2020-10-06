Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1F2852D9
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgJFUEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:04:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727186AbgJFUEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 16:04:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602014654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nAsLvgW1nDOTPpn1U85aTp/X7z+VtDo99/tckF5jXNI=;
        b=iGvuAtojmV7k69MejaC4O5HTbnKN7dN9I6xPrjq3AgVn7746bb1zdtFsaAbCmcE5bBZV+W
        2s56X+TtcRjMyUWkdXcPFBjXrnxltr6EjpuoGu0hrDSl1nJgWP8oDF4VoscwrYN67bPgkk
        T7ICsQAJIIR3Lh8AUHAwwRF3WRhbXcs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-r50GUUy5MiC9VEv4faOv2Q-1; Tue, 06 Oct 2020 16:04:10 -0400
X-MC-Unique: r50GUUy5MiC9VEv4faOv2Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DA58804018;
        Tue,  6 Oct 2020 20:04:08 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 767315D9CD;
        Tue,  6 Oct 2020 20:03:50 +0000 (UTC)
Date:   Tue, 6 Oct 2020 16:03:47 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>, aris@redhat.com
Subject: Re: [PATCH ghak90 V9 11/13] audit: contid check descendancy and
 nesting
Message-ID: <20201006200347.GI2882171@madcap2.tricolour.ca>
References: <cover.1593198710.git.rgb@redhat.com>
 <01229b93733d9baf6ac9bb0cc243eeb08ad579cd.1593198710.git.rgb@redhat.com>
 <CAHC9VhT6cLxxws_pYWcL=mWe786xPoTTFfPZ1=P4hx4V3nytXA@mail.gmail.com>
 <20200807171025.523i2sxfyfl7dfjy@madcap2.tricolour.ca>
 <CAHC9VhQ3MVUY8Zs4GNXdaqhiPJBzHW_YcCe=DghAgo7g6yrNBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQ3MVUY8Zs4GNXdaqhiPJBzHW_YcCe=DghAgo7g6yrNBw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-21 16:13, Paul Moore wrote:
> On Fri, Aug 7, 2020 at 1:10 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-07-05 11:11, Paul Moore wrote:
> > > On Sat, Jun 27, 2020 at 9:23 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > Require the target task to be a descendant of the container
> > > > orchestrator/engine.
> 
> If you want to get formal about this, you need to define "target" in
> the sentence above.  Target of what?

The target is the task having its audit container identifier modified by
the orchestrator current task.

> FWIW, I read the above to basically mean that a task can only set the
> audit container ID of processes which are beneath it in the "process
> tree" where the "process tree" is defined as the relationship between
> a parent and children processes such that the children processes are
> branches below the parent process.

Yes.

> I have no problem with that, with the understanding that nesting
> complicates it somewhat.  For example, this isn't true when one of the
> children is a nested orchestrator, is it?

It should still be true if that child is a nested orchestrator that has
not yet spawned any children or threads (or they have all died off).

It does get more complicated when we consider the scenario outlined
below about perceived layer violations...

> > > > You would only change the audit container ID from one set or inherited
> > > > value to another if you were nesting containers.
> 
> I thought we decided we were going to allow an orchestrator to move a
> process between audit container IDs, yes?  no?

We did?  I don't remember anything about that.  Has this been requested?
This seems to violate the rule that we can't change the audit container
identifier once it has been set (other than nesting).  Can you suggest a
use case?

> > > > If changing the contid, the container orchestrator/engine must be a
> > > > descendant and not same orchestrator as the one that set it so it is not
> > > > possible to change the contid of another orchestrator's container.
> 
> Try rephrasing the above please, it isn't clear to me what you are
> trying to say.

This is harder than I expected to rephrase...  It also makes it clear
that there are some scenarios that have not been considered that may
need to be restricted.

Orchestrator A spawned task B which is itself an orchestrator without
chidren yet.  Orchestrator A sets the audit container identifier of B.
Neither A, nor B, nor any other child of A (or any of their
descendants), nor any orchestrator outside the tree of A (uncles, aunts
and cousins are outside), can change the audit container identifier of
B.

Orchestrator B spawns task C.  Here's where it gets tricky.  It seems
like a layer violation for B to spawn a child C and have A reach over B
to set the audit container identifier of C, especially if B is also an
orchestrator.  This all will be especially hard to police if we don't
limit the ability of an orchestrator task to set an audit container
identifier to that orchestrator's immediate children, only once.

> > Are we able to agree on the premises above?  Is anything asserted that
> > should not be and is there anything missing?
> 
> See above.
> 
> If you want to go back to the definitions/assumptions stage, it
> probably isn't worth worrying about the other comments until we get
> the above sorted.

I don't want to.  I'm trying to confirm that we are on the same page.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

