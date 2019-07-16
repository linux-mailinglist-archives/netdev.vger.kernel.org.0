Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB876ACA1
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 18:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387770AbfGPQ0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 12:26:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbfGPQ0b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 12:26:31 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 18AB887620;
        Tue, 16 Jul 2019 16:26:30 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-14.phx2.redhat.com [10.3.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A40625C28D;
        Tue, 16 Jul 2019 16:26:19 +0000 (UTC)
Date:   Tue, 16 Jul 2019 12:26:16 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Tycho Andersen <tycho@tycho.ws>, nhorman@tuxdriver.com,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
Message-ID: <20190716162616.7kgvqbqxn4icqyb3@madcap2.tricolour.ca>
References: <20190529222835.GD8959@cisco>
 <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
 <20190530170913.GA16722@mail.hallyn.com>
 <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
 <20190530212900.GC5739@cisco>
 <CAHC9VhT5HPt9rCJoDutdvA3r1Y1GOHfpXe2eJ54atNC1=Vd8LA@mail.gmail.com>
 <20190708181237.5poheliito7zpvmc@madcap2.tricolour.ca>
 <CAHC9VhT0V+xi_6nAR5TsM2vs34LbgMeO=-W+MS_kqiXRRzneZQ@mail.gmail.com>
 <20190716153705.xx7dwrhliny5amut@madcap2.tricolour.ca>
 <CAHC9VhTaLqCo8rmAaySJQB+Pf-580=3mvX1rPmtEeb9o5Uy9Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTaLqCo8rmAaySJQB+Pf-580=3mvX1rPmtEeb9o5Uy9Qg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 16 Jul 2019 16:26:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-07-16 12:08, Paul Moore wrote:
> On Tue, Jul 16, 2019 at 11:37 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2019-07-15 17:09, Paul Moore wrote:
> > > On Mon, Jul 8, 2019 at 2:12 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > On 2019-05-30 19:26, Paul Moore wrote:
> > >
> > > ...
> > >
> > > > > I like the creativity, but I worry that at some point these
> > > > > limitations are going to be raised (limits have a funny way of doing
> > > > > that over time) and we will be in trouble.  I say "trouble" because I
> > > > > want to be able to quickly do an audit container ID comparison and
> > > > > we're going to pay a penalty for these larger values (we'll need this
> > > > > when we add multiple auditd support and the requisite record routing).
> > > > >
> > > > > Thinking about this makes me also realize we probably need to think a
> > > > > bit longer about audit container ID conflicts between orchestrators.
> > > > > Right now we just take the value that is given to us by the
> > > > > orchestrator, but if we want to allow multiple container orchestrators
> > > > > to work without some form of cooperation in userspace (I think we have
> > > > > to assume the orchestrators will not talk to each other) we likely
> > > > > need to have some way to block reuse of an audit container ID.  We
> > > > > would either need to prevent the orchestrator from explicitly setting
> > > > > an audit container ID to a currently in use value, or instead generate
> > > > > the audit container ID in the kernel upon an event triggered by the
> > > > > orchestrator (e.g. a write to a /proc file).  I suspect we should
> > > > > start looking at the idr code, I think we will need to make use of it.
> > > >
> > > > To address this, I'd suggest that it is enforced to only allow the
> > > > setting of descendants and to maintain a master list of audit container
> > > > identifiers (with a hash table if necessary later) that includes the
> > > > container owner.
> > >
> > > We're discussing the audit container ID management policy elsewhere in
> > > this thread so I won't comment on that here, but I did want to say
> > > that we will likely need something better than a simple list of audit
> > > container IDs from the start.  It's common for systems to have
> > > thousands of containers now (or multiple thousands), which tells me
> > > that a list is a poor choice.  You mentioned a hash table, so I would
> > > suggest starting with that over the list for the initial patchset.
> >
> > I saw that as an internal incremental improvement that did not affect
> > the API, so I wanted to keep things a bit simpler (as you've requested
> > in the past) to get this going, and add that enhancement later.
> 
> In general a simple approach is a good way to start when the
> problem/use-case is not very well understood; in other words, don't
> spend a lot of time/effort optimizing something you don't yet
> understand.  In this case we know that people want to deploy a *lot*
> of containers on a single system so we should design the data
> structures appropriately.  A list is simply not a good fit here, I
> believe/hope you know that too.

Yes, I knew that, which is why I alluded to a hash table...

> > I'll start working on it now.  The hash table would simply point to
> > lists anyways unless you can recommend a better approach.
> 
> I assume when you say "point to lists" you are talking about using
> lists for the hash buckets?  If so, yes that should be fine at this
> point.  In general if the per-bucket lists become a bottleneck we can
> look at the size of the table (or make it tunable) or even use a
> different approach entirely.  Ultimately the data store is an
> implementation detail private to the audit subsystem in the kernel so
> we should be able to change it as necessary without breaking anything.

Yes, this is what I had in mind.  It would be tunable either by a macro
or a config option, so the exact value isn't a critical implementation
detail that can be easily tuned as we gain experience with it.  And yes,
the intent was that it was a non-user-perceivable implementation choice
other than performace metrics.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
