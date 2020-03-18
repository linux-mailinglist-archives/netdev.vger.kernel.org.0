Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95AF318A6F8
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgCRV1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:27:45 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:40890 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726747AbgCRV1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 17:27:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584566863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vfeg96jC3449/b+nif4AVPPcBXCL9wEY1xZDJxISjtU=;
        b=cSkwLJA33CH6MpGTBd6Wan4IwYvCxNVCIpBQHE+1BJvglyQkpjbRGGtiuTMp9ccEN6GQmB
        bX9NxJgs3Pl+b5bIgWasVJLLjqqBR9TthrAV2r1D17YQ9isyCd+Yv9CfR2MmyDSu0iEEHQ
        0J6znRI9YOxuthHblrxx6NWtmGIWseg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-YfG_1nJtPVGzL6Exm2B_mA-1; Wed, 18 Mar 2020 17:27:40 -0400
X-MC-Unique: YfG_1nJtPVGzL6Exm2B_mA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 148D6107ACCD;
        Wed, 18 Mar 2020 21:26:52 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66A7560BF1;
        Wed, 18 Mar 2020 21:26:36 +0000 (UTC)
Date:   Wed, 18 Mar 2020 17:26:30 -0400
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
Message-ID: <20200318212630.mw2geg4ykhnbtr3k@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <20200204231454.oxa7pyvuxbj466fj@madcap2.tricolour.ca>
 <CAHC9VhQquokw+7UOU=G0SsD35UdgmfysVKCGCE87JVaoTkbisg@mail.gmail.com>
 <3142237.YMNxv0uec1@x2>
 <CAHC9VhTiCHQbp2SwK0Xb1QgpUZxOQ26JKKPsVGT0ZvMqx28oPQ@mail.gmail.com>
 <CAHC9VhS09b_fM19tn7pHZzxfyxcHnK+PJx80Z9Z1hn8-==4oLA@mail.gmail.com>
 <20200312193037.2tb5f53yeisfq4ta@madcap2.tricolour.ca>
 <CAHC9VhQoVOzy_b9W6h+kmizKr1rPkC4cy5aYoKT2i0ZgsceNDg@mail.gmail.com>
 <20200313185900.y44yvrfm4zxa5lfk@madcap2.tricolour.ca>
 <CAHC9VhR2zCCE5bjH75rSwfLC7TJGFj4RBnrtcOoUiqVp9q5TaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhR2zCCE5bjH75rSwfLC7TJGFj4RBnrtcOoUiqVp9q5TaA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-18 16:56, Paul Moore wrote:
> On Fri, Mar 13, 2020 at 2:59 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-03-13 12:29, Paul Moore wrote:
> > > On Thu, Mar 12, 2020 at 3:30 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > On 2020-02-13 16:44, Paul Moore wrote:
> > > > > This is a bit of a thread-hijack, and for that I apologize, but
> > > > > another thought crossed my mind while thinking about this issue
> > > > > further ... Once we support multiple auditd instances, including the
> > > > > necessary record routing and duplication/multiple-sends (the host
> > > > > always sees *everything*), we will likely need to find a way to "trim"
> > > > > the audit container ID (ACID) lists we send in the records.  The
> > > > > auditd instance running on the host/initns will always see everything,
> > > > > so it will want the full container ACID list; however an auditd
> > > > > instance running inside a container really should only see the ACIDs
> > > > > of any child containers.
> > > >
> > > > Agreed.  This should be easy to check and limit, preventing an auditd
> > > > from seeing any contid that is a parent of its own contid.
> > > >
> > > > > For example, imagine a system where the host has containers 1 and 2,
> > > > > each running an auditd instance.  Inside container 1 there are
> > > > > containers A and B.  Inside container 2 there are containers Y and Z.
> > > > > If an audit event is generated in container Z, I would expect the
> > > > > host's auditd to see a ACID list of "1,Z" but container 1's auditd
> > > > > should only see an ACID list of "Z".  The auditd running in container
> > > > > 2 should not see the record at all (that will be relatively
> > > > > straightforward).  Does that make sense?  Do we have the record
> > > > > formats properly designed to handle this without too much problem (I'm
> > > > > not entirely sure we do)?
> > > >
> > > > I completely agree and I believe we have record formats that are able to
> > > > handle this already.
> > >
> > > I'm not convinced we do.  What about the cases where we have a field
> > > with a list of audit container IDs?  How do we handle that?
> >
> > I don't understand the problem.  (I think you crossed your 1/2 vs
> > A/B/Y/Z in your example.) ...
> 
> It looks like I did, sorry about that.
> 
> > ... Clarifying the example above, if as you
> > suggest an event happens in container Z, the hosts's auditd would report
> >         Z,^2
> > and the auditd in container 2 would report
> >         Z,^2
> > but if there were another auditd running in container Z it would report
> >         Z
> > while the auditd in container 1 or A/B would see nothing.
> 
> Yes.  My concern is how do we handle this to minimize duplicating and
> rewriting the records?  It isn't so much about the format, although
> the format is a side effect.

Are you talking about caching, or about divulging more information than
necessary or even information leaks?  Or even noticing that records that
need to be generated to two audit daemons share the same contid field
values and should be generated at the same time or information shared
between them?  I'd see any of these as optimizations that don't affect
the api.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

