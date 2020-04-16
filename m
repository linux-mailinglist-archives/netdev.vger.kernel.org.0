Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA39B1ABE6C
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 12:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505221AbgDPKgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 06:36:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23317 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2505074AbgDPKdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 06:33:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587033221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wSOHFT9tJQ3WMUJpzqJBLiS8QZ3BM+HLY6292xvXFZM=;
        b=DuAiR70AkTLxvA/rK7PsFcNZGWdjqBd8BtZy5tk7QANjZlp3r28/2gyWuprA/f5aV3HfCi
        bJAeN3BvIl7SWiZjkLiY29dCK/pc0Z6fY5oDPvRB/3LGLcOECjcrWNqw9e7FPfJbqGUkkr
        lDDNfmSN2tqkSJgn0o2GCBeUG9b9fBQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-mRLDz9gnN72cnltf895Q4Q-1; Thu, 16 Apr 2020 06:33:39 -0400
X-MC-Unique: mRLDz9gnN72cnltf895Q4Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26B2513F9;
        Thu, 16 Apr 2020 10:33:38 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (ovpn-114-61.ams2.redhat.com [10.36.114.61])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 178D194B40;
        Thu, 16 Apr 2020 10:33:35 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        keyrings@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: What's a good default TTL for DNS keys in the kernel
References: <874ktl2ide.fsf@oldenburg2.str.redhat.com>
        <3865908.1586874010@warthog.procyon.org.uk>
        <128769.1587032833@warthog.procyon.org.uk>
Date:   Thu, 16 Apr 2020 12:33:34 +0200
In-Reply-To: <128769.1587032833@warthog.procyon.org.uk> (David Howells's
        message of "Thu, 16 Apr 2020 11:27:13 +0100")
Message-ID: <87v9lzu3cx.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* David Howells:

> Florian Weimer <fweimer@redhat.com> wrote:
>
>> You can get the real TTL if you do a DNS resolution on the name and
>> match the addresses against what you get out of the NSS functions.  If
>> they match, you can use the TTL from DNS.  Hackish, but it does give you
>> *some* TTL value.
>
> I guess I'd have to do that in parallel.

Not necessary.  You can do the getaddrinfo lookup first and then perform
the query.

> Would calling something like res_mkquery() use local DNS caching?

Yes (but res_mkquery builds a packet, it does not send it).

>> The question remains what the expected impact of TTL expiry is.  Will
>> the kernel just perform a new DNS query if it needs one?  Or would you
>> expect that (say) the NFS client rechecks the addresses after TTL expiry
>> and if they change, reconnect to a new NFS server?
>
> It depends on the filesystem.
>
> AFS keeps track of the expiration on the record and will issue a new lookup
> when the data expires, but NFS doesn't make use of this information.

And it will switch servers at that point?  Or only if the existing
server association fails/times out?

> The keyring subsystem will itself dispose of dns_resolver keys that
> expire and request_key() will only upcall again if the key has
> expired.

What's are higher-level effects of that?

I'm still not convinced that the kernel *needs* accurate TTL
information.  The benefit from upcall avoidance likely vanishes quickly
after the in-kernel TTL increases beyond 5 or so.  That's just my guess,
though.

Thanks,
Florian

