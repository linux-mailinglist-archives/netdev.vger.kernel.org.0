Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02CD6EB325
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfJaOvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:51:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38045 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728153AbfJaOvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 10:51:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572533478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3K6sCYQs8K5ApEcQ+TEBEBei1xOeMj1fQR7m/w4Dyos=;
        b=B25v9SZyX4U5a0z5MJs9apakt9rJXAJChTOMBkXUT+RtHVC1l4/Lr4nwU2ibghlc60leeE
        3NdVXd93sRBBfrSqvy3s3ddTQQVleWVxzQ50cSwz5xZP8vmzayMJXBhNv7OVPcEX2R5COU
        a4xJCRweDYWiy2CWsD0Yi9VMU2rZt9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-piStzJfuPfqkyHSzRDB-TQ-1; Thu, 31 Oct 2019 10:51:14 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13D9E1800D6B;
        Thu, 31 Oct 2019 14:51:13 +0000 (UTC)
Received: from x2.localnet (ovpn-117-13.phx2.redhat.com [10.3.117.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B3E160878;
        Thu, 31 Oct 2019 14:50:58 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid outside init_user_ns
Date:   Thu, 31 Oct 2019 10:50:57 -0400
Message-ID: <3677995.NTHC7m0fHc@x2>
Organization: Red Hat
In-Reply-To: <20191030220320.tnwkaj5gbzchcn7j@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com> <CAHC9VhRDoX9du4XbCnBtBzsNPMGOsb-TKM1CC+sCL7HP=FuTRQ@mail.gmail.com> <20191030220320.tnwkaj5gbzchcn7j@madcap2.tricolour.ca>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: piStzJfuPfqkyHSzRDB-TQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 7Bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

TLDR;  I see a lot of benefit to switching away from procfs for setting auid & 
sessionid.

On Wednesday, October 30, 2019 6:03:20 PM EDT Richard Guy Briggs wrote:
> > Also, for the record, removing the audit loginuid from procfs is not
> > something to take lightly, if at all; like it or not, it's part of the
> > kernel API.

It can also be used by tools to iterate processes related to one user or 
session. I use this in my Intrusion Prevention System which will land in 
audit user space at some point in the future.


> Oh, I'm quite aware of how important this change is and it was discussed
> with Steve Grubb who saw the concern and value of considering such a
> disruptive change.

Actually, I advocated for syscall. I think the gist of Eric's idea was that /
proc is the intersection of many nasty problems. By relying on it, you can't 
simplify the API to reduce the complexity. Almost no program actually needs 
access to /proc. ps does. But almost everything else is happy without it. For 
example, when you setup chroot jails, you may have to add /dev/random or /
dev/null, but almost never /proc. What does force you to add /proc is any 
entry point daemon like sshd because it needs to set the loginuid. If we 
switch away from /proc, then sshd or crond will no longer /require/ procfs to 
be available which again simplifies the system design.


> Removing proc support for auid/ses would be a
> long-term deprecation if accepted.

It might need to just be turned into readonly for a while. But then again, 
perhaps auid and session should be part of /proc/<pid>/status? Maybe this can 
be done independently and ahead of the container work so there is a migration 
path for things that read auid or session. TBH, maybe this should have been 
done from the beginning.

-Steve



