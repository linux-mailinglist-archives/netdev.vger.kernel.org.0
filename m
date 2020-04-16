Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2981C1AC1FA
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 15:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894746AbgDPNBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 09:01:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20321 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2894687AbgDPNBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 09:01:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587042104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eu6b6HDAloa0ypWgaxME9iI3u+iDHWfSGslG1thqHSI=;
        b=Vs9mBwFJtn3uZ8Bld7z0BW26cBoLpNkKFwIaotRLczUbtX0Pv1hbJUlWbY8UfCQWQI42td
        YVVc4csSYl07jpuVUC7zQhBADdSjRv2edYqqnk1GMjm76/RX5suUQtVl8usr6QVAICQsfN
        ZEplv6tKl4afGoopIrOiUgOKIpUfvU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-hChMLAzGMqqPJHzgmWdWww-1; Thu, 16 Apr 2020 09:01:43 -0400
X-MC-Unique: hChMLAzGMqqPJHzgmWdWww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7B32802564;
        Thu, 16 Apr 2020 13:01:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-129.rdu2.redhat.com [10.10.113.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C45B75DA89;
        Thu, 16 Apr 2020 13:01:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <87v9lzu3cx.fsf@oldenburg2.str.redhat.com>
References: <87v9lzu3cx.fsf@oldenburg2.str.redhat.com> <874ktl2ide.fsf@oldenburg2.str.redhat.com> <3865908.1586874010@warthog.procyon.org.uk> <128769.1587032833@warthog.procyon.org.uk>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     dhowells@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: What's a good default TTL for DNS keys in the kernel
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <142354.1587042098.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 16 Apr 2020 14:01:38 +0100
Message-ID: <142355.1587042098@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Weimer <fweimer@redhat.com> wrote:

> > Florian Weimer <fweimer@redhat.com> wrote:
> >
> >> You can get the real TTL if you do a DNS resolution on the name and
> >> match the addresses against what you get out of the NSS functions.  I=
f
> >> they match, you can use the TTL from DNS.  Hackish, but it does give =
you
> >> *some* TTL value.
> >
> > I guess I'd have to do that in parallel.
> =

> Not necessary.  You can do the getaddrinfo lookup first and then perform
> the query.

That means that the latency of both is added together and causes the first
mount to take longer - though as long as you have a local DNS cache, that'=
s
fine.

> > AFS keeps track of the expiration on the record and will issue a new l=
ookup
> > when the data expires, but NFS doesn't make use of this information.
> =

> And it will switch servers at that point?  Or only if the existing
> server association fails/times out?

AFS will switch servers at the next operation if the server list changes. =
 And
if the current op tries to access an old server and gets bounced, this sho=
uld
trigger an immediate reevaluation.  It also regularly probes the servers a=
nd
interfaces it knows about to find which one's accessible and which has the
best response and can switch servers on that basis also.

I should also note that AFS deletes the dns_resolver key after reading it =
and
maintains the expiry information in its internal structs.

Note also that in AFS this only applies to locating the Volume Location
servers (which is a layer of abstraction that hides which server(s) a volu=
me
resides on and what their addresses are).  The VL service is queried to fi=
nd
out where file servers are (giving you their addresses itself so you don't
need to access the DNS there).

> > The keyring subsystem will itself dispose of dns_resolver keys that
> > expire and request_key() will only upcall again if the key has
> > expired.
> =

> What's are higher-level effects of that?

If the record never expires (the current case), the address lookup in the
kernel (dns_query()) will always return the same address until someone
manually evicts it.

Otherwise, once the record expires, the kernel will just upcall again.

> I'm still not convinced that the kernel *needs* accurate TTL
> information.  The benefit from upcall avoidance likely vanishes quickly
> after the in-kernel TTL increases beyond 5 or so.  That's just my guess,
> though.

You might be right - certainly for NFS and CIFS where the address ascribed=
 to
a superblock is hard to change as it partly defines the superblock.  Chang=
e
the address and your superblock in now a different thing as far as the VFS=
 is
concerned.

This makes fscache indexing tricky for NFS.  How do you define a superbloc=
k?
Is it address?  Is it hostname?  What happens if one or the other changes?
What happens if there are two or more addresses (say ipv4 and ipv6 addrs)?

AFS defined some abstractions for this: the cell name and the volume ID
number.  The physical location of the volume doesn't matter - and the volu=
me
can even be moved around whilst in use.

David

