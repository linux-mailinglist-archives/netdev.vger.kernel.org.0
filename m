Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E26EC58E
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 16:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbfKAPVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 11:21:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35569 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727812AbfKAPVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 11:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572621698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WDYGxxA/KgrYN0QEUL49MfltlmEWA16vt4MxjEs1+6E=;
        b=goHoTJaOCoRTNdFL6iXr3cfsLekQ3KwbEFacVVQVFALg+5wk60Za7kRF6e968L9J6tJaJv
        SP21hY07pe1zS2HbQdi3ZK2nfKNDpXKLFEtX1XNOEGNSv+udxKDg5zM2mKHWK0BSGqLZQj
        p3TCSkpljaG9CUZ64T957uFGvV/OW9U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-i5RvBvQWOlyITqFctoslYg-1; Fri, 01 Nov 2019 11:21:33 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4EE31005500;
        Fri,  1 Nov 2019 15:21:31 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82BD619C58;
        Fri,  1 Nov 2019 15:21:21 +0000 (UTC)
Date:   Fri, 1 Nov 2019 11:21:18 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
Message-ID: <20191101152118.mi2svoringtrdskv@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <3677995.NTHC7m0fHc@x2>
 <20191101150927.c5sf3n5ezfg2eano@madcap2.tricolour.ca>
 <1592218.lpl3eoh2c6@x2>
MIME-Version: 1.0
In-Reply-To: <1592218.lpl3eoh2c6@x2>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: i5RvBvQWOlyITqFctoslYg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-11-01 11:13, Steve Grubb wrote:
> On Friday, November 1, 2019 11:09:27 AM EDT Richard Guy Briggs wrote:
> > On 2019-10-31 10:50, Steve Grubb wrote:
> > > Hello,
> > >=20
> > > TLDR;  I see a lot of benefit to switching away from procfs for setti=
ng
> > > auid & sessionid.
> > >=20
> > > On Wednesday, October 30, 2019 6:03:20 PM EDT Richard Guy Briggs wrot=
e:
> > > > > Also, for the record, removing the audit loginuid from procfs is =
not
> > > > > something to take lightly, if at all; like it or not, it's part o=
f
> > > > > the
> > > > > kernel API.
> > >=20
> > > It can also be used by tools to iterate processes related to one user=
 or
> > > session. I use this in my Intrusion Prevention System which will land=
 in
> > > audit user space at some point in the future.
> > >=20
> > > > Oh, I'm quite aware of how important this change is and it was
> > > > discussed
> > > > with Steve Grubb who saw the concern and value of considering such =
a
> > > > disruptive change.
> > >=20
> > > Actually, I advocated for syscall. I think the gist of Eric's idea wa=
s
> > > that / proc is the intersection of many nasty problems. By relying on
> > > it, you can't simplify the API to reduce the complexity. Almost no
> > > program actually needs access to /proc. ps does. But almost everythin=
g
> > > else is happy without it. For example, when you setup chroot jails, y=
ou
> > > may have to add /dev/random or / dev/null, but almost never /proc. Wh=
at
> > > does force you to add /proc is any entry point daemon like sshd becau=
se
> > > it needs to set the loginuid. If we switch away from /proc, then sshd=
 or
> > > crond will no longer /require/ procfs to be available which again
> > > simplifies the system design.
> > >=20
> > > > Removing proc support for auid/ses would be a
> > > > long-term deprecation if accepted.
> > >=20
> > > It might need to just be turned into readonly for a while. But then
> > > again,
> > > perhaps auid and session should be part of /proc/<pid>/status? Maybe =
this
> > > can be done independently and ahead of the container work so there is=
 a
> > > migration path for things that read auid or session. TBH, maybe this
> > > should have been done from the beginning.
> >=20
> > How about making loginuid/contid/capcontid writable only via netlink bu=
t
> > still provide the /proc interface for reading?  Deprecation of proc can
> > be left as a decision for later.  This way sshd/crond/getty don't need
> > /proc, but the info is still there for tools that want to read it.
>=20
> This also sounds good to me. But I still think loginuid and audit session=
id=20
> should get written in /proc/<pid>/status so that all process information =
is=20
> consolidated in one place.

I don't have a problem adding auid/sessionid to /proc/<pid>/status with
other related information, but it is disruptive to deprecate the
existing interface which could be a seperate step.

> -Steve

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

