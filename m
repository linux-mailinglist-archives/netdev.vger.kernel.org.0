Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D378F2B08A3
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbgKLPnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:43:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728655AbgKLPnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:43:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605195784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dxbxgJ3l9w064dkJ4nmc+S2zoOeV0z0h2c6CrYTGwuU=;
        b=WXe4UtPJXS0A9puUNibsrOGzt65xItaRg1XyeSbzpPzbf71uF3llshcXj6s4nLy58tZdWW
        fQw48Szh00x2QJcr5uGl70ozM9d8D2sux2QHnemeAPCHYFnJH54Ak8OudPY+hcatrmGefk
        jmPeh/mlidUahItWhry/UfttN8wdOD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-WWPp6-O5Ocm8dUXKMSFVfw-1; Thu, 12 Nov 2020 10:43:00 -0500
X-MC-Unique: WWPp6-O5Ocm8dUXKMSFVfw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2C6680365A;
        Thu, 12 Nov 2020 15:42:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D47A760C0F;
        Thu, 12 Nov 2020 15:42:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
References: <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Bruce Fields <bfields@fieldses.org>,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-afs@lists.infradead.org
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2380560.1605195776.1@warthog.procyon.org.uk>
Date:   Thu, 12 Nov 2020 15:42:56 +0000
Message-ID: <2380561.1605195776@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuck Lever <chuck.lever@oracle.com> wrote:

> > There are three main interfaces to it:
> > 
> > (*) I/O crypto: encrypt, decrypt, get_mic and verify_mic.
> > 
> >     These all do in-place crypto, using an sglist to define the buffer
> >     with the data in it.  Is it necessary to make it able to take separate
> >     input and output buffers?
> 
> Hi David, Wondering if these "I/O" APIs use synchronous or async
> crypto under the covers. For small data items like MICs, synchronous
> might be a better choice, especially if asynchronous crypto could
> result in incoming requests getting re-ordered and falling out of
> the GSS sequence number window.
> 
> What say ye?

For the moment I'm using synchronous APIs as that's what sunrpc is using (I
borrowed the basic code from there).

It would be interesting to consider using async, but there's a potential
issue.  For the simplified profile, encryption and integrity checksum
generation can be done simultaneously, but decryption and verification can't.
For the AES-2 profile, the reverse is true.

For my purposes in rxrpc, async mode isn't actually that useful since I'm only
doing the contents of a UDP packet at a time.  Either I'm encrypting with the
intention of immediate transmission or decrypting with the intention of
immediately using the data, so I'm in a context where I can wait anyway.

What might get me more of a boost would be to encrypt the app data directly
into a UDP packet and decrypt the UDP packet directly into the app buffers.
This is easier said than done, though, as there's typically security metadata
inserted into the packet inside the encrypted region.

David

