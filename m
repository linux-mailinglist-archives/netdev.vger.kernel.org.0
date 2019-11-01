Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E76EC55E
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 16:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbfKAPJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 11:09:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36043 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727893AbfKAPJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 11:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572620994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B0+CdOYJOHUYIPhTqYhU6i7fsne7jTye1CGWyYYt7Oo=;
        b=YJPHlYUqkXUCsoMZHDzLglvFItNEcLh2YQQCVWqBPlp3QKpyHhvypdVSC+FFJYKuZK49/2
        54ZeRWPNF1J2PWteu7kiZI9ORayY25qmV405TUyX2t61LZ/9mTtsAIzsB/2W5t//1Cu8R0
        i0KU6KYvYQQ1F/lqX3M82++F1KlLThc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-5P0N9OwUMBiTSmPWIh5iXQ-1; Fri, 01 Nov 2019 11:09:49 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DC6A800D49;
        Fri,  1 Nov 2019 15:09:46 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B445810016E8;
        Fri,  1 Nov 2019 15:09:30 +0000 (UTC)
Date:   Fri, 1 Nov 2019 11:09:27 -0400
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
Message-ID: <20191101150927.c5sf3n5ezfg2eano@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <CAHC9VhRDoX9du4XbCnBtBzsNPMGOsb-TKM1CC+sCL7HP=FuTRQ@mail.gmail.com>
 <20191030220320.tnwkaj5gbzchcn7j@madcap2.tricolour.ca>
 <3677995.NTHC7m0fHc@x2>
MIME-Version: 1.0
In-Reply-To: <3677995.NTHC7m0fHc@x2>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 5P0N9OwUMBiTSmPWIh5iXQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-31 10:50, Steve Grubb wrote:
> Hello,
>=20
> TLDR;  I see a lot of benefit to switching away from procfs for setting a=
uid &=20
> sessionid.
>=20
> On Wednesday, October 30, 2019 6:03:20 PM EDT Richard Guy Briggs wrote:
> > > Also, for the record, removing the audit loginuid from procfs is not
> > > something to take lightly, if at all; like it or not, it's part of th=
e
> > > kernel API.
>=20
> It can also be used by tools to iterate processes related to one user or=
=20
> session. I use this in my Intrusion Prevention System which will land in=
=20
> audit user space at some point in the future.
>=20
> > Oh, I'm quite aware of how important this change is and it was discusse=
d
> > with Steve Grubb who saw the concern and value of considering such a
> > disruptive change.
>=20
> Actually, I advocated for syscall. I think the gist of Eric's idea was th=
at /
> proc is the intersection of many nasty problems. By relying on it, you ca=
n't=20
> simplify the API to reduce the complexity. Almost no program actually nee=
ds=20
> access to /proc. ps does. But almost everything else is happy without it.=
 For=20
> example, when you setup chroot jails, you may have to add /dev/random or =
/
> dev/null, but almost never /proc. What does force you to add /proc is any=
=20
> entry point daemon like sshd because it needs to set the loginuid. If we=
=20
> switch away from /proc, then sshd or crond will no longer /require/ procf=
s to=20
> be available which again simplifies the system design.
>=20
> > Removing proc support for auid/ses would be a
> > long-term deprecation if accepted.
>=20
> It might need to just be turned into readonly for a while. But then again=
,=20
> perhaps auid and session should be part of /proc/<pid>/status? Maybe this=
 can=20
> be done independently and ahead of the container work so there is a migra=
tion=20
> path for things that read auid or session. TBH, maybe this should have be=
en=20
> done from the beginning.

How about making loginuid/contid/capcontid writable only via netlink but
still provide the /proc interface for reading?  Deprecation of proc can
be left as a decision for later.  This way sshd/crond/getty don't need
/proc, but the info is still there for tools that want to read it.

> -Steve

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

