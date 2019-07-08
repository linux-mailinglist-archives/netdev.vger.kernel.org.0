Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D83E8627E8
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 20:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389749AbfGHSGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 14:06:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727413AbfGHSGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 14:06:18 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 903EA5D672;
        Mon,  8 Jul 2019 18:06:12 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-14.phx2.redhat.com [10.3.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43F002B9F2;
        Mon,  8 Jul 2019 18:06:01 +0000 (UTC)
Date:   Mon, 8 Jul 2019 14:05:58 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        Tycho Andersen <tycho@tycho.ws>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        ebiederm@xmission.com, nhorman@tuxdriver.com
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
Message-ID: <20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca>
References: <cover.1554732921.git.rgb@redhat.com>
 <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
 <20190529145742.GA8959@cisco>
 <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco>
 <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
 <20190529222835.GD8959@cisco>
 <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
 <20190530170913.GA16722@mail.hallyn.com>
 <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 08 Jul 2019 18:06:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-30 15:29, Paul Moore wrote:
> On Thu, May 30, 2019 at 1:09 PM Serge E. Hallyn <serge@hallyn.com> wrote:
> > On Wed, May 29, 2019 at 06:39:48PM -0400, Paul Moore wrote:
> > > On Wed, May 29, 2019 at 6:28 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > > > On Wed, May 29, 2019 at 12:03:58PM -0400, Paul Moore wrote:
> > > > > On Wed, May 29, 2019 at 11:34 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > > > > > On Wed, May 29, 2019 at 11:29:05AM -0400, Paul Moore wrote:
> > > > > > > On Wed, May 29, 2019 at 10:57 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > > > > > > > On Mon, Apr 08, 2019 at 11:39:09PM -0400, Richard Guy Briggs wrote:
> 
> ...
> 
> > > > > > > The current thinking
> > > > > > > is that you would only change the audit container ID from one
> > > > > > > set/inherited value to another if you were nesting containers, in
> > > > > > > which case the nested container orchestrator would need to be granted
> > > > > > > CAP_AUDIT_CONTROL (which everyone to date seems to agree is a workable
> > > > > > > compromise).
> > > >
> > > > won't work in user namespaced containers, because they will never be
> > > > capable(CAP_AUDIT_CONTROL); so I don't think this will work for
> > > > nesting as is. But maybe nobody cares :)
> > >
> > > That's fun :)
> > >
> > > To be honest, I've never been a big fan of supporting nested
> > > containers from an audit perspective, so I'm not really too upset
> > > about this.  The k8s/cri-o folks seem okay with this, or at least I
> > > haven't heard any objections; lxc folks, what do you have to say?
> >
> > I actually thought the answer to this (when last I looked, "some time" ago)
> > was that userspace should track an audit message saying "task X in
> > container Y is changing its auditid to Z", and then decide to also track Z.
> > This should be doable, but a lot of extra work in userspace.
> >
> > Per-userns containerids would also work.  So task X1 is in containerid
> > 1 on the host and creates a new task Y in new userns;  it continues to
> > be reported in init_user_ns as containerid 1 forever;  but in its own
> > userns it can request to be known as some other containerid.  Audit
> > socks would be per-userns, allowing root in a container to watch for
> > audit events in its own (and descendent) namespaces.
> >
> > But again I'm sure we've gone over all this in the last few years.
> >
> > I suppose we can look at this as a "first step", and talk about
> > making it user-ns-nestable later.  But agreed it's not useful in a
> > lot of situations as is.
> 
> [REMINDER: It is an "*audit* container ID" and not a general
> "container ID" ;)  Smiley aside, I'm not kidding about that part.]
> 
> I'm not interested in supporting/merging something that isn't useful;
> if this doesn't work for your use case then we need to figure out what
> would work.  It sounds like nested containers are much more common in
> the lxc world, can you elaborate a bit more on this?
> 
> As far as the possible solutions you mention above, I'm not sure I
> like the per-userns audit container IDs, I'd much rather just emit the
> necessary tracking information via the audit record stream and let the
> log analysis tools figure it out.  However, the bigger question is how
> to limit (re)setting the audit container ID when you are in a non-init
> userns.  For reasons already mentioned, using capable() is a non
> starter for everything but the initial userns, and using ns_capable()
> is equally poor as it essentially allows any userns the ability to
> munge it's audit container ID (obviously not good).  It appears we
> need a different method for controlling access to the audit container
> ID.

We're not quite ready yet for multiple audit daemons and possibly not
yet for audit namespaces, but this is starting to look a lot like the
latter.

If we can't trust ns_capable() then why are we passing on
CAP_AUDIT_CONTROL?  It is being passed down and not stripped purposely
by the orchestrator/engine.  If ns_capable() isn't inherited how is it
gained otherwise?  Can it be inserted by cotainer image?  I think the
answer is "no".  Either we trust ns_capable() or we have audit
namespaces (recommend based on user namespace) (or both).

At this point I would say we are at an impasse unless we trust
ns_capable() or we implement audit namespaces.

I don't think another mechanism to trust nested orchestrators/engines
will buy us anything.

Am I missing something?

> Punting this to a LSM hook is an obvious thing to do, and something we
> might want to do anyway, but currently audit doesn't rely on the LSM
> for proper/safe operation and I'm not sure I want to change that now.
> 
> The next obvious thing is to create some sort of access control knob
> in audit itself.  Perhaps an auditctl operation that would allow the
> administrator to specify which containers, via their corresponding
> audit container IDs, are allowed to change their audit container ID?
> The permission granting would need to be done in the init userns, but
> it would allow containers with a non-init userns the ability to change
> their audit container ID.  We would probably still want a
> ns_capable(CAP_AUDIT_CONTROL) restriction in this case.

This auditctl knob of which you speak is an additional API, not changing
the existing proposed one.

> Does anyone else have any other ideas?
> 
> -- 
> paul moore
> www.paul-moore.com

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
