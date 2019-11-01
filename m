Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7959AEC578
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 16:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbfKAPOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 11:14:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42899 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728318AbfKAPOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 11:14:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572621244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=luXHXJdFmIMPIk6jfSvlnkfMv6c6AfJ+truEUd44VG8=;
        b=NzKItZg1I9ZBMChKIZg7CLC5oBMbBqReN/etx2nAzvwobaUrpwf3OVRS2dQI2+EI8Eb5lq
        bCWK/dUChzuVvfSfbDY5JuGp1Eehce6z4vIyhuFvdoyKv2TCKlaZBSuGgwkPWu6HcDJtyo
        FpdC6jb34L1YC+OJhDsD0vY/WIlq89U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-Vi7mmKN8M8O4J34qRKFdng-1; Fri, 01 Nov 2019 11:13:59 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADB25800A1E;
        Fri,  1 Nov 2019 15:13:56 +0000 (UTC)
Received: from x2.localnet (ovpn-116-239.phx2.redhat.com [10.3.116.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 766295D6B7;
        Fri,  1 Nov 2019 15:13:47 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid outside init_user_ns
Date:   Fri, 01 Nov 2019 11:13:45 -0400
Message-ID: <1592218.lpl3eoh2c6@x2>
Organization: Red Hat
In-Reply-To: <20191101150927.c5sf3n5ezfg2eano@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com> <3677995.NTHC7m0fHc@x2> <20191101150927.c5sf3n5ezfg2eano@madcap2.tricolour.ca>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: Vi7mmKN8M8O4J34qRKFdng-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 7Bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, November 1, 2019 11:09:27 AM EDT Richard Guy Briggs wrote:
> On 2019-10-31 10:50, Steve Grubb wrote:
> > Hello,
> > 
> > TLDR;  I see a lot of benefit to switching away from procfs for setting
> > auid & sessionid.
> > 
> > On Wednesday, October 30, 2019 6:03:20 PM EDT Richard Guy Briggs wrote:
> > > > Also, for the record, removing the audit loginuid from procfs is not
> > > > something to take lightly, if at all; like it or not, it's part of
> > > > the
> > > > kernel API.
> > 
> > It can also be used by tools to iterate processes related to one user or
> > session. I use this in my Intrusion Prevention System which will land in
> > audit user space at some point in the future.
> > 
> > > Oh, I'm quite aware of how important this change is and it was
> > > discussed
> > > with Steve Grubb who saw the concern and value of considering such a
> > > disruptive change.
> > 
> > Actually, I advocated for syscall. I think the gist of Eric's idea was
> > that / proc is the intersection of many nasty problems. By relying on
> > it, you can't simplify the API to reduce the complexity. Almost no
> > program actually needs access to /proc. ps does. But almost everything
> > else is happy without it. For example, when you setup chroot jails, you
> > may have to add /dev/random or / dev/null, but almost never /proc. What
> > does force you to add /proc is any entry point daemon like sshd because
> > it needs to set the loginuid. If we switch away from /proc, then sshd or
> > crond will no longer /require/ procfs to be available which again
> > simplifies the system design.
> > 
> > > Removing proc support for auid/ses would be a
> > > long-term deprecation if accepted.
> > 
> > It might need to just be turned into readonly for a while. But then
> > again,
> > perhaps auid and session should be part of /proc/<pid>/status? Maybe this
> > can be done independently and ahead of the container work so there is a
> > migration path for things that read auid or session. TBH, maybe this
> > should have been done from the beginning.
> 
> How about making loginuid/contid/capcontid writable only via netlink but
> still provide the /proc interface for reading?  Deprecation of proc can
> be left as a decision for later.  This way sshd/crond/getty don't need
> /proc, but the info is still there for tools that want to read it.

This also sounds good to me. But I still think loginuid and audit sessionid 
should get written in /proc/<pid>/status so that all process information is 
consolidated in one place.

-Steve


