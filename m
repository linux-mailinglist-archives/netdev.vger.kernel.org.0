Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D445C1ABDE2
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 12:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505008AbgDPK3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 06:29:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56126 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504895AbgDPK1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 06:27:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587032840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DM6k/0BvmOX6t724NGkINWqm7Df0IRyLKBF1DXuH/q0=;
        b=K32MWYVwYWPC6ldcqxtFfwuLrYpSyBLkr3wfYLucF+TpDMBqvqgKeQWQzjvNuqxOao8pMY
        NVDObLGysIwn8bWNwxpcyV8Lwt2uCyPnZEDZPYxK+vmaSZ+BSwiogCrzazATM75lcyxe+V
        xFTgiUXvB1948goQLiSXmZpW50PD5Zs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-LzQOBPtSNCKB7AltKEzm1A-1; Thu, 16 Apr 2020 06:27:17 -0400
X-MC-Unique: LzQOBPtSNCKB7AltKEzm1A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDC918017F6;
        Thu, 16 Apr 2020 10:27:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-129.rdu2.redhat.com [10.10.113.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A7C87E7C1;
        Thu, 16 Apr 2020 10:27:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <874ktl2ide.fsf@oldenburg2.str.redhat.com>
References: <874ktl2ide.fsf@oldenburg2.str.redhat.com> <3865908.1586874010@warthog.procyon.org.uk>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     dhowells@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: What's a good default TTL for DNS keys in the kernel
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <128768.1587032833.1@warthog.procyon.org.uk>
Date:   Thu, 16 Apr 2020 11:27:13 +0100
Message-ID: <128769.1587032833@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Weimer <fweimer@redhat.com> wrote:

> You can get the real TTL if you do a DNS resolution on the name and
> match the addresses against what you get out of the NSS functions.  If
> they match, you can use the TTL from DNS.  Hackish, but it does give you
> *some* TTL value.

I guess I'd have to do that in parallel.  Would calling something like
res_mkquery() use local DNS caching?

> The question remains what the expected impact of TTL expiry is.  Will
> the kernel just perform a new DNS query if it needs one?  Or would you
> expect that (say) the NFS client rechecks the addresses after TTL expiry
> and if they change, reconnect to a new NFS server?

It depends on the filesystem.

AFS keeps track of the expiration on the record and will issue a new lookup
when the data expires, but NFS doesn't make use of this information.  The
keyring subsystem will itself dispose of dns_resolver keys that expire and
request_key() will only upcall again if the key has expired.

The problem for NFS is that the host IP address is the primary key for the
superblock (see nfs_compare_super_address()).

CIFS also doesn't make direct use of the TTL, and again this may be because it
uses the server address as part of the primary key for the superblock (see
cifs_match_super()).

David

