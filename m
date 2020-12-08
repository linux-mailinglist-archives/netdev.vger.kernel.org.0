Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93062D2C8A
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbgLHOEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:04:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726338AbgLHOEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:04:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607436177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X6d4iuw/2zncrstw5QmGL4uRz/t+VxjNUWTz4LWJVQk=;
        b=jLnL6GiAiDIbs0Q10gN1XWeh2+MfzncRdv57x2pyfUQRCObeziqJ9+f97/Dy9V3qxklTb+
        AzOnKm8sOSoDshQTNu9fboQ3m3/QJMGKCgzlaSw6bR3df9c1VbQc8rB9K2+cShHwH/qurG
        3ahYVZIdY4mxJGpVENYRPm7xwQF9XqI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-1yQZHnjvMACN12KejRdUFg-1; Tue, 08 Dec 2020 09:02:47 -0500
X-MC-Unique: 1yQZHnjvMACN12KejRdUFg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3F2E858186;
        Tue,  8 Dec 2020 14:02:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A45115D9F8;
        Tue,  8 Dec 2020 14:02:42 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <955415.1607433903@warthog.procyon.org.uk>
References: <955415.1607433903@warthog.procyon.org.uk> <118876.1607093975@warthog.procyon.org.uk> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
To:     Chuck Lever <chuck.lever@oracle.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     dhowells@redhat.com, Bruce Fields <bfields@fieldses.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-afs@lists.infradead.org
Subject: Re: Why the auxiliary cipher in gss_krb5_crypto.c?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <959899.1607436161.1@warthog.procyon.org.uk>
Date:   Tue, 08 Dec 2020 14:02:41 +0000
Message-ID: <959900.1607436161@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> I wonder - would it make sense to reserve two arrays of scatterlist structs
> and a mutex per CPU sufficient to map up to 1MiB of pages with each array
> while the krb5 service is in use?

Actually, simply reserving a set per CPU is probably unnecessary.  We could,
say, set a minimum and a maximum on the reservations (say 2 -> 2*nr_cpus) and
then allocate new ones when we run out.  Then let the memory shrinker clean
them up off an lru list.

David

