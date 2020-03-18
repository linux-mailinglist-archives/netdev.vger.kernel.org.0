Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA84C18A738
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgCRVm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:42:26 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:48520 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727101AbgCRVmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 17:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584567741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FI4r1zHhj1RMuaE8Pn/teSAlnWkMrk+yN7HsYv/jDKI=;
        b=hwnGi2726ij2ZDjgpGdGrEdtuaj8rDnKky3rvoPCunUMxgWtg7DFuNsrQ7HH2EzL+48IJm
        tdomi1DWjCbADMqSV4roQbJOzeCNzrHwECHk2pFS0ZhXjBTgcoPJZraWN8n5TAIg8OPDe9
        ZHUy1iUkofQ9oLmT3ehoojAWF+0vmO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-cGEOpaJlMG6QfxMxXASyTw-1; Wed, 18 Mar 2020 17:42:18 -0400
X-MC-Unique: cGEOpaJlMG6QfxMxXASyTw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4288110C9FC1;
        Wed, 18 Mar 2020 21:42:16 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65C105C1D8;
        Wed, 18 Mar 2020 21:41:59 +0000 (UTC)
Date:   Wed, 18 Mar 2020 17:41:54 -0400
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
Message-ID: <20200318214154.ycxy5dl4pxno6fvi@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <20200204231454.oxa7pyvuxbj466fj@madcap2.tricolour.ca>
 <CAHC9VhQquokw+7UOU=G0SsD35UdgmfysVKCGCE87JVaoTkbisg@mail.gmail.com>
 <3142237.YMNxv0uec1@x2>
 <CAHC9VhTiCHQbp2SwK0Xb1QgpUZxOQ26JKKPsVGT0ZvMqx28oPQ@mail.gmail.com>
 <20200312202733.7kli64zsnqc4mrd2@madcap2.tricolour.ca>
 <CAHC9VhS9DtxJ4gvOfMRnzoo6ccGJVKL+uZYe6qqH+SPqD8r01Q@mail.gmail.com>
 <20200313192306.wxey3wn2h4htpccm@madcap2.tricolour.ca>
 <CAHC9VhQKOpVWxDg-tWuCWV22QRu8P_NpFKme==0Ot1RQKa_DWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQKOpVWxDg-tWuCWV22QRu8P_NpFKme==0Ot1RQKa_DWA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-18 17:01, Paul Moore wrote:
> On Fri, Mar 13, 2020 at 3:23 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-03-13 12:42, Paul Moore wrote:
> 
> ...
> 
> > > The thread has had a lot of starts/stops, so I may be repeating a
> > > previous suggestion, but one idea would be to still emit a "death
> > > record" when the final task in the audit container ID does die, but
> > > block the particular audit container ID from reuse until it the
> > > SIGNAL2 info has been reported.  This gives us the timely ACID death
> > > notification while still preventing confusion and ambiguity caused by
> > > potentially reusing the ACID before the SIGNAL2 record has been sent;
> > > there is a small nit about the ACID being present in the SIGNAL2
> > > *after* its death, but I think that can be easily explained and
> > > understood by admins.
> >
> > Thinking quickly about possible technical solutions to this, maybe it
> > makes sense to have two counters on a contobj so that we know when the
> > last process in that container exits and can issue the death
> > certificate, but we still block reuse of it until all further references
> > to it have been resolved.  This will likely also make it possible to
> > report the full contid chain in SIGNAL2 records.  This will eliminate
> > some of the issues we are discussing with regards to passing a contobj
> > vs a contid to the audit_log_contid function, but won't eliminate them
> > all because there are still some contids that won't have an object
> > associated with them to make it impossible to look them up in the
> > contobj lists.
> 
> I'm not sure you need a full second counter, I imagine a simple flag
> would be okay.  I think you just something to indicate that this ACID
> object is marked as "dead" but it still being held for sanity reasons
> and should not be reused.

Ok, I see your point.  This refcount can be changed to a flag easily
enough without change to the api if we can be sure that more than one
signal can't be delivered to the audit daemon *and* collected by sig2.
I'll have a more careful look at the audit daemon code to see if I can
determine this.

Steve, can you have a look and tell us if it is possible for the audit
daemon to make more than one signal_info (or signal_info2) record
request from the kernel after receiving a signal?


Another question occurs to me is that what if the audit daemon is sent a
signal and it cannot or will not collect the sig2 information from the
kernel (SIGKILL?)?  Does that audit container identifier remain dead
until reboot, or do we institute some other form of reaping, possibly
time-based?


> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

