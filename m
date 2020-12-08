Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDE72D2BDA
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 14:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgLHN0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 08:26:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729149AbgLHN0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 08:26:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607433913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=idJ8/WupSy/edQ30Crz8uX2zPv1PKuxsc+ILe2DB9b0=;
        b=VhETD7ZYtnQQ0Gt3WtMubeZMQnovVXe2us8sJvZWIZ0eXPUIBzLT/pOOpChYKJ/FU8wOOJ
        oB91gjmESmep9nm52cgEau5kiQ+13pzpmXaEfVZH7YMUadBkKK0OX9CDY6vaHVwKbJoC8J
        E2kVEu5QolvbB+eoKege17KMzMieNiA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-kqSR4vZoPnaCpsCt-8xsaA-1; Tue, 08 Dec 2020 08:25:09 -0500
X-MC-Unique: kqSR4vZoPnaCpsCt-8xsaA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EEB2107ACF5;
        Tue,  8 Dec 2020 13:25:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 938835D6AB;
        Tue,  8 Dec 2020 13:25:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <118876.1607093975@warthog.procyon.org.uk>
References: <118876.1607093975@warthog.procyon.org.uk> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
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
Content-ID: <955414.1607433903.1@warthog.procyon.org.uk>
Date:   Tue, 08 Dec 2020 13:25:03 +0000
Message-ID: <955415.1607433903@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I wonder - would it make sense to reserve two arrays of scatterlist structs
and a mutex per CPU sufficient to map up to 1MiB of pages with each array
while the krb5 service is in use?

That way sunrpc could, say, grab the mutex, map the input and output buffers,
do the entire crypto op in one go and then release the mutex - at least for
big ops, small ops needn't use this service.

For rxrpc/afs's use case this would probably be overkill - it's doing crypto
on each packet, not on whole operations - but I could still make use of it
there.

However, that then limits the maximum size of an op to 1MiB, plus dangly bits
on either side (which can be managed with chained scatterlist structs) and
also limits the number of large simultaneous krb5 crypto ops we can do.

David

