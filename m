Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FEB184F16
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgCMS7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:59:23 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47614 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbgCMS7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584125961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8o++RDtPi06edCq2V+yf5BrhzW8DgwWaCOa0CXjSS/g=;
        b=cxGrw77JNHvC6v48owlJ3YgGYCEMUhBUNbBYzE4yTspeDwQ52h0j/1i4CtsoOdwQxJmvk5
        izbo3Gk5MoLkFvbs2+Uy1RJ8ALU6fgQ78PceScIiaVN1O3+HHK/zQm57RHkNeyeXgTAeBU
        yPmsbmXwE8g6t7tczLVLLewlifpiQC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-XcPF1FLCMJWyZY5LCgmxEQ-1; Fri, 13 Mar 2020 14:59:18 -0400
X-MC-Unique: XcPF1FLCMJWyZY5LCgmxEQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31D29102CE17;
        Fri, 13 Mar 2020 18:59:16 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FA3B8FC06;
        Fri, 13 Mar 2020 18:59:03 +0000 (UTC)
Date:   Fri, 13 Mar 2020 14:59:00 -0400
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
Message-ID: <20200313185900.y44yvrfm4zxa5lfk@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <20200204231454.oxa7pyvuxbj466fj@madcap2.tricolour.ca>
 <CAHC9VhQquokw+7UOU=G0SsD35UdgmfysVKCGCE87JVaoTkbisg@mail.gmail.com>
 <3142237.YMNxv0uec1@x2>
 <CAHC9VhTiCHQbp2SwK0Xb1QgpUZxOQ26JKKPsVGT0ZvMqx28oPQ@mail.gmail.com>
 <CAHC9VhS09b_fM19tn7pHZzxfyxcHnK+PJx80Z9Z1hn8-==4oLA@mail.gmail.com>
 <20200312193037.2tb5f53yeisfq4ta@madcap2.tricolour.ca>
 <CAHC9VhQoVOzy_b9W6h+kmizKr1rPkC4cy5aYoKT2i0ZgsceNDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQoVOzy_b9W6h+kmizKr1rPkC4cy5aYoKT2i0ZgsceNDg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-13 12:29, Paul Moore wrote:
> On Thu, Mar 12, 2020 at 3:30 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-02-13 16:44, Paul Moore wrote:
> > > This is a bit of a thread-hijack, and for that I apologize, but
> > > another thought crossed my mind while thinking about this issue
> > > further ... Once we support multiple auditd instances, including the
> > > necessary record routing and duplication/multiple-sends (the host
> > > always sees *everything*), we will likely need to find a way to "trim"
> > > the audit container ID (ACID) lists we send in the records.  The
> > > auditd instance running on the host/initns will always see everything,
> > > so it will want the full container ACID list; however an auditd
> > > instance running inside a container really should only see the ACIDs
> > > of any child containers.
> >
> > Agreed.  This should be easy to check and limit, preventing an auditd
> > from seeing any contid that is a parent of its own contid.
> >
> > > For example, imagine a system where the host has containers 1 and 2,
> > > each running an auditd instance.  Inside container 1 there are
> > > containers A and B.  Inside container 2 there are containers Y and Z.
> > > If an audit event is generated in container Z, I would expect the
> > > host's auditd to see a ACID list of "1,Z" but container 1's auditd
> > > should only see an ACID list of "Z".  The auditd running in container
> > > 2 should not see the record at all (that will be relatively
> > > straightforward).  Does that make sense?  Do we have the record
> > > formats properly designed to handle this without too much problem (I'm
> > > not entirely sure we do)?
> >
> > I completely agree and I believe we have record formats that are able to
> > handle this already.
> 
> I'm not convinced we do.  What about the cases where we have a field
> with a list of audit container IDs?  How do we handle that?

I don't understand the problem.  (I think you crossed your 1/2 vs
A/B/Y/Z in your example.)  Clarifying the example above, if as you
suggest an event happens in container Z, the hosts's auditd would report
	Z,^2
and the auditd in container 2 would report
	Z,^2
but if there were another auditd running in container Z it would report
	Z
while the auditd in container 1 or A/B would see nothing.

The format I had proposed already handles that:
contid^contid,contid^contid but you'd like to see it changed to
contid,^contid,contid,^contid and both formats handle it though I find
the former much easier to read.  For the example above we'd have:
	A,^1
	B,^1
	Y,^2
	Z,^2
and for a shared network namespace potentially:
	A,^1,B,^1,Y,^2,Z,^2
and if there were an event reported by an auditd in container Z it would
report only:
	Z

Now, I could see an argument for restricting the visibility of the
contid to the container containing an auditd so that an auditd cannot
see its own contid, but that wasn't my design intent.  This can still be
addressed after the initial code is committed without breaking the API.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

