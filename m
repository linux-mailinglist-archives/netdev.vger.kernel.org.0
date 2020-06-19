Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84252200FD8
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 17:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393053AbgFSPWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 11:22:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44658 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393030AbgFSPWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 11:22:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592580158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l/HKj8Lu0UpE1Qv0ctjZcKbYlSC0+K+puPRzGZpopZs=;
        b=P8iIZpVgG8C7O1xLjLVrFJ2NnsMeZnJ36OssszoPpEO+NNUCxMrjp5zHiUv33TM16fr0Wa
        fRgnOsvkGgw9dpO0p5GRTUvmfL9C7WxiZjb+T6LoPqJl+hUHPzNBQhdZN/w9HwKiikNQgZ
        TaO/sxG7N4WQZ8cM43EN3pNGGPe+sTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-HPCb-NsRPkaEVYKMkqiNzg-1; Fri, 19 Jun 2020 11:22:36 -0400
X-MC-Unique: HPCb-NsRPkaEVYKMkqiNzg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0F5A872FE0;
        Fri, 19 Jun 2020 15:22:34 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CD205C1D0;
        Fri, 19 Jun 2020 15:22:19 +0000 (UTC)
Date:   Fri, 19 Jun 2020 11:22:17 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Paul Moore <paul@paul-moore.com>, nhorman@tuxdriver.com,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
Message-ID: <20200619152217.s4bb376ud575gufo@madcap2.tricolour.ca>
References: <CAHC9VhTQUnVhoN3JXTAQ7ti+nNLfGNVXhT6D-GYJRSpJHCwDRg@mail.gmail.com>
 <20200330134705.jlrkoiqpgjh3rvoh@madcap2.tricolour.ca>
 <CAHC9VhQTsEMcYAF1CSHrrVn07DR450W9j6sFVfKAQZ0VpheOfw@mail.gmail.com>
 <20200330162156.mzh2tsnovngudlx2@madcap2.tricolour.ca>
 <CAHC9VhTRzZXJ6yUFL+xZWHNWZFTyiizBK12ntrcSwmgmySbkWw@mail.gmail.com>
 <20200330174937.xalrsiev7q3yxsx2@madcap2.tricolour.ca>
 <CAHC9VhR_bKSHDn2WAUgkquu+COwZUanc0RV3GRjMDvpoJ5krjQ@mail.gmail.com>
 <871ronf9x2.fsf@x220.int.ebiederm.org>
 <CAHC9VhR3gbmj5+5MY-whLtStKqDEHgvMRigU9hW0X1kpxF91ag@mail.gmail.com>
 <871rol7nw3.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rol7nw3.fsf@x220.int.ebiederm.org>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-17 17:23, Eric W. Biederman wrote:
> Paul Moore <paul@paul-moore.com> writes:
> 
> > On Thu, Apr 16, 2020 at 4:36 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> Paul Moore <paul@paul-moore.com> writes:
> >> > On Mon, Mar 30, 2020 at 1:49 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >> >> On 2020-03-30 13:34, Paul Moore wrote:
> >> >> > On Mon, Mar 30, 2020 at 12:22 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >> >> > > On 2020-03-30 10:26, Paul Moore wrote:
> >> >> > > > On Mon, Mar 30, 2020 at 9:47 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> >> >> > > > > On 2020-03-28 23:11, Paul Moore wrote:
> >> >> > > > > > On Tue, Mar 24, 2020 at 5:02 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >> >> > > > > > > On 2020-03-23 20:16, Paul Moore wrote:
> >> >> > > > > > > > On Thu, Mar 19, 2020 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >> >> > > > > > > > > On 2020-03-18 18:06, Paul Moore wrote:
> >> >
> >> > ...
> >> >
> >> >> > > Well, every time a record gets generated, *any* record gets generated,
> >> >> > > we'll need to check for which audit daemons this record is in scope and
> >> >> > > generate a different one for each depending on the content and whether
> >> >> > > or not the content is influenced by the scope.
> >> >> >
> >> >> > That's the problem right there - we don't want to have to generate a
> >> >> > unique record for *each* auditd on *every* record.  That is a recipe
> >> >> > for disaster.
> >> >> >
> >> >> > Solving this for all of the known audit records is not something we
> >> >> > need to worry about in depth at the moment (although giving it some
> >> >> > casual thought is not a bad thing), but solving this for the audit
> >> >> > container ID information *is* something we need to worry about right
> >> >> > now.
> >> >>
> >> >> If you think that a different nested contid value string per daemon is
> >> >> not acceptable, then we are back to issuing a record that has only *one*
> >> >> contid listed without any nesting information.  This brings us back to
> >> >> the original problem of keeping *all* audit log history since the boot
> >> >> of the machine to be able to track the nesting of any particular contid.
> >> >
> >> > I'm not ruling anything out, except for the "let's just completely
> >> > regenerate every record for each auditd instance".
> >>
> >> Paul I am a bit confused about what you are referring to when you say
> >> regenerate every record.
> >>
> >> Are you saying that you don't want to repeat the sequence:
> >>         audit_log_start(...);
> >>         audit_log_format(...);
> >>         audit_log_end(...);
> >> for every nested audit daemon?
> >
> > If it can be avoided yes.  Audit performance is already not-awesome,
> > this would make it even worse.
> 
> As far as I can see not repeating sequences like that is fundamental
> for making this work at all.  Just because only the audit subsystem
> should know about one or multiple audit daemons.  Nothing else should
> care.
> 
> >> Or are you saying that you would like to literraly want to send the same
> >> skb to each of the nested audit daemons?
> >
> > Ideally we would reuse the generated audit messages as much as
> > possible.  Less work is better.  That's really my main concern here,
> > let's make sure we aren't going to totally tank performance when we
> > have a bunch of nested audit daemons.
> 
> So I think there are two parts of this answer.  Assuming we are talking
> about nesting audit daemons in containers we will have different
> rulesets and I expect most of the events for a nested audit daemon won't
> be of interest to the outer audit daemon.
> 
> Beyond that it should be very straight forward to keep a pointer and
> leave the buffer as a scatter gather list until audit_log_end
> and translate pids, and rewrite ACIDs attributes in audit_log_end
> when we build the final packet.  Either through collaboration with
> audit_log_format or a special audit_log command that carefully sets
> up the handful of things that need that information.
> 
> Hmm.  I am seeing that we send skbs to kauditd and then kauditd
> sends those skbs to userspace.  I presume that is primary so that
> sending messages to userspace does not block the process being audited.
> 
> Plus a little bit so that the retry logic will work.
> 
> I think the naive implementation would be to simply have 1 kauditd
> per auditd (strictly and audit context/namespace).  Although that can be
> optimized if that is a problem.
> 
> Beyond that I think we would need to look at profiles to really
> understand where the bottlenecks are.
> 
> >> Or are you thinking of something else?
> >
> > As mentioned above, I'm not thinking of anything specific, other than
> > let's please not have to regenerate *all* of the audit record strings
> > for each instance of an audit daemon, that's going to be a killer.
> >
> > Maybe we have to regenerate some, if we do, what would that look like
> > in code?  How do we handle the regeneration aspect?  I worry that is
> > going to be really ugly.
> >
> > Maybe we finally burn down the audit_log_format(...) function and pass
> > structs/TLVs to the audit subsystem and the audit subsystem generates
> > the strings in the auditd connection thread.  Some of the record
> > strings could likely be shared, others would need to be ACID/auditd
> > dependent.
> 
> I think we just a very limited amount of structs/TLVs for the cases that
> matter and one-one auditd and kauditd implementations we should still
> be able to do everything in audit_log_end.  Plus doing as much work as
> possible in audit_log_end where things are still cache hot is desirable.

So in the end, perf may show us that moving things around a bit and
knowing to which queue(s) we send an skb will help maintain performance
by writing out the field contents in audit_log_end() and sending to the
correct queue rather than deferring writing out that field contents in
the kauditd process due to cache issues.  In any case, it makes sense to
delay that formatting work until just after the daemon routing decision
is made.

> > I'm open to any ideas people may have.  We have a problem, let's solve
> > it.
> 
> It definitely makes sense to look ahead to having audit daemons running
> in containers, but in the grand scheme of things that is a nice to have.
> Probably something we will and should get to, but we have lived a long
> time without auditd running in containers so I expect we can live a
> while longer.
> 
> As I understand Richard patchset for the specific case of the ACID we
> are only talking about taking a subset of an existing string, and one
> string at that.  Not hard at all.  Especially when looking at the
> fundamental fact that we will need to send a different skb to
> userspace, for each audit daemon.
> 
> Eric

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

