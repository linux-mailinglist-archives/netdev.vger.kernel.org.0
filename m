Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0D1197F86
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 17:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgC3PYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 11:24:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:38254 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728941AbgC3PYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 11:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585581847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D5uFspd3/cIWYU7H3JtoXL8Mlj5rBTwKwCCQJPO8iZg=;
        b=bvJPEj2g2dIkdhNV+J6wWwtyLCAbTcEXIkPz0gvswjjSPfQKAHIzrujVbcSGHWsdtFq5mu
        EQj0RabGUvpTIlaxux7Hxq6vMTzJpkdhdyORip5PcmrX0F5owpVZ9e4yIsGRDexL35LqjK
        mExqJ5pLR4rcX3G1+gncUkcU15NDI/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-43WTi89VPVK6XSkd5tw5ow-1; Mon, 30 Mar 2020 11:24:03 -0400
X-MC-Unique: 43WTi89VPVK6XSkd5tw5ow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32077DB6E;
        Mon, 30 Mar 2020 15:24:01 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19F5399DEC;
        Mon, 30 Mar 2020 15:23:49 +0000 (UTC)
Date:   Mon, 30 Mar 2020 11:23:47 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
        nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
Message-ID: <20200330152347.zjrcd6uuolfnq3fy@madcap2.tricolour.ca>
References: <20200312202733.7kli64zsnqc4mrd2@madcap2.tricolour.ca>
 <CAHC9VhS9DtxJ4gvOfMRnzoo6ccGJVKL+uZYe6qqH+SPqD8r01Q@mail.gmail.com>
 <20200313192306.wxey3wn2h4htpccm@madcap2.tricolour.ca>
 <CAHC9VhQKOpVWxDg-tWuCWV22QRu8P_NpFKme==0Ot1RQKa_DWA@mail.gmail.com>
 <20200318214154.ycxy5dl4pxno6fvi@madcap2.tricolour.ca>
 <CAHC9VhSuMnd3-ci2Bx-xJ0yscQ=X8ZqFAcNPKpbh_ZWN3FJcuQ@mail.gmail.com>
 <20200319214759.qgxt2sfkmd6srdol@madcap2.tricolour.ca>
 <CAHC9VhTp25OAaTO5UMft0OzUZ=oQpZFjebkjjQP0-NrPp0bNAg@mail.gmail.com>
 <20200325122903.obkpyog7fjabzrpf@madcap2.tricolour.ca>
 <CAHC9VhTuYYqAtoNAKLX3qja6DnqEbFuHchi9ESwbcb5WC_Mvtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTuYYqAtoNAKLX3qja6DnqEbFuHchi9ESwbcb5WC_Mvtw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-28 23:17, Paul Moore wrote:
> On Wed, Mar 25, 2020 at 8:29 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-03-20 17:56, Paul Moore wrote:
> > > On Thu, Mar 19, 2020 at 5:48 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > On 2020-03-18 17:47, Paul Moore wrote:
> > > > > On Wed, Mar 18, 2020 at 5:42 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > On 2020-03-18 17:01, Paul Moore wrote:
> > > > > > > On Fri, Mar 13, 2020 at 3:23 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > > > On 2020-03-13 12:42, Paul Moore wrote:
> > > > > > >
> > > > > > > ...
> > > > > > >
> > > > > > > > > The thread has had a lot of starts/stops, so I may be repeating a
> > > > > > > > > previous suggestion, but one idea would be to still emit a "death
> > > > > > > > > record" when the final task in the audit container ID does die, but
> > > > > > > > > block the particular audit container ID from reuse until it the
> > > > > > > > > SIGNAL2 info has been reported.  This gives us the timely ACID death
> > > > > > > > > notification while still preventing confusion and ambiguity caused by
> > > > > > > > > potentially reusing the ACID before the SIGNAL2 record has been sent;
> > > > > > > > > there is a small nit about the ACID being present in the SIGNAL2
> > > > > > > > > *after* its death, but I think that can be easily explained and
> > > > > > > > > understood by admins.
> > > > > > > >
> > > > > > > > Thinking quickly about possible technical solutions to this, maybe it
> > > > > > > > makes sense to have two counters on a contobj so that we know when the
> > > > > > > > last process in that container exits and can issue the death
> > > > > > > > certificate, but we still block reuse of it until all further references
> > > > > > > > to it have been resolved.  This will likely also make it possible to
> > > > > > > > report the full contid chain in SIGNAL2 records.  This will eliminate
> > > > > > > > some of the issues we are discussing with regards to passing a contobj
> > > > > > > > vs a contid to the audit_log_contid function, but won't eliminate them
> > > > > > > > all because there are still some contids that won't have an object
> > > > > > > > associated with them to make it impossible to look them up in the
> > > > > > > > contobj lists.
> > > > > > >
> > > > > > > I'm not sure you need a full second counter, I imagine a simple flag
> > > > > > > would be okay.  I think you just something to indicate that this ACID
> > > > > > > object is marked as "dead" but it still being held for sanity reasons
> > > > > > > and should not be reused.
> > > > > >
> > > > > > Ok, I see your point.  This refcount can be changed to a flag easily
> > > > > > enough without change to the api if we can be sure that more than one
> > > > > > signal can't be delivered to the audit daemon *and* collected by sig2.
> > > > > > I'll have a more careful look at the audit daemon code to see if I can
> > > > > > determine this.
> > > > >
> > > > > Maybe I'm not understanding your concern, but this isn't really
> > > > > different than any of the other things we track for the auditd signal
> > > > > sender, right?  If we are worried about multiple signals being sent
> > > > > then it applies to everything, not just the audit container ID.
> > > >
> > > > Yes, you are right.  In all other cases the information is simply
> > > > overwritten.  In the case of the audit container identifier any
> > > > previous value is put before a new one is referenced, so only the last
> > > > signal is kept.  So, we only need a flag.  Does a flag implemented with
> > > > a rcu-protected refcount sound reasonable to you?
> > >
> > > Well, if I recall correctly you still need to fix the locking in this
> > > patchset so until we see what that looks like it is hard to say for
> > > certain.  Just make sure that the flag is somehow protected from
> > > races; it is probably a lot like the "valid" flags you sometimes see
> > > with RCU protected lists.
> >
> > This is like looking for a needle in a haystack.  Can you point me to
> > some code that does "valid" flags with RCU protected lists.
> 
> Sigh.  Come on Richard, you've been playing in the kernel for some
> time now.  I can't think of one off the top of my head as I write
> this, but there are several resources that deal with RCU protected
> lists in the kernel, Google is your friend and Documentation/RCU is
> your friend.

Ok, I thought you were talking about a specific piece of code...

> Spending time to learn how RCU works and how to use it properly is not
> time wasted.  It's a tricky thing to get right (I have to refresh my
> memory on some of the more subtle details each time I write/review RCU
> code), but it's very cool when done correctly.

I review Documentation/RCU almost every time I work on RCU...

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

