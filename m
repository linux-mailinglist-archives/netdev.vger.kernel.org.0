Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607031A992D
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 11:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895761AbgDOJon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 05:44:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39801 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2895746AbgDOJok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 05:44:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586943876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bKa8snlnDryG0vgt7Fg/rdv6w9fg6r4FpdXiLIxnEdE=;
        b=cEwnuLfIVICCCloM/nkjOx2cvpv9pItx8yQEk7qZGIS06k5uJfkbfcZwO4rKtfWn+cyxCh
        RLsrR9A65ny3Zd16rY+ew4aQXa6iXmQ4DP7XEzZf/Vc5zwjWXG1wWwr2NM+905Nqixle4i
        LB75cl6uqWjw4LIcdUMRcYBGHGqamnk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-olUJzS60OsClk0RUhQWf4A-1; Wed, 15 Apr 2020 05:44:34 -0400
X-MC-Unique: olUJzS60OsClk0RUhQWf4A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 216EB800D5C;
        Wed, 15 Apr 2020 09:44:33 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (ovpn-114-61.ams2.redhat.com [10.36.114.61])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E8D72B479;
        Wed, 15 Apr 2020 09:44:30 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        keyrings@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: What's a good default TTL for DNS keys in the kernel
References: <3865908.1586874010@warthog.procyon.org.uk>
Date:   Wed, 15 Apr 2020 11:44:29 +0200
In-Reply-To: <3865908.1586874010@warthog.procyon.org.uk> (David Howells's
        message of "Tue, 14 Apr 2020 15:20:10 +0100")
Message-ID: <874ktl2ide.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* David Howells:

> Since key.dns_resolver isn't given a TTL for the address information obta=
ined
> for getaddrinfo(), no expiry is set on dns_resolver keys in the kernel for
> NFS, CIFS or Ceph.  AFS gets one if it looks up a cell SRV or AFSDB record
> because that is looked up in the DNS directly, but it doesn't look up A or
> AAAA records, so doesn't get an expiry for the addresses themselves.
>
> I've previously asked the libc folks if there's a way to get this informa=
tion
> exposed in struct addrinfo, but I don't think that ended up going anywher=
e -
> and, in any case, would take a few years to work through the system.
>
> For the moment, I think I should put a default on any dns_resolver keys a=
nd
> have it applied either by the kernel (configurable with a /proc/sys/ sett=
ing)
> or by the key.dnf_resolver program (configurable with an /etc file).
>
> Any suggestion as to the preferred default TTL?  10 minutes?

You can get the real TTL if you do a DNS resolution on the name and
match the addresses against what you get out of the NSS functions.  If
they match, you can use the TTL from DNS.  Hackish, but it does give you
*some* TTL value.

The question remains what the expected impact of TTL expiry is.  Will
the kernel just perform a new DNS query if it needs one?  Or would you
expect that (say) the NFS client rechecks the addresses after TTL expiry
and if they change, reconnect to a new NFS server?

If a TTL expiration does not trigger anything, than it seems purely an
optimization to avoid kernel =E2=86=92 userspace callbacks.  I think you ca=
n do
with a very short TTL in this case, on the order of seconds (or no
caching at all).

Negative caching is also worthy of consideration and can be considerably
more tricky.

Thanks,
Florian

