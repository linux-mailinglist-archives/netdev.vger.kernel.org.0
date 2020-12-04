Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0482CF25A
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbgLDQvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:51:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728467AbgLDQvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:51:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607100618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dIRAeEOB8hw4ymH0Bxaf7S4B4DeY7Jwy7U9drx5nC5A=;
        b=SqXB6+1zr5dLxIFa4rNlV/xuRyAN86bpdsBYiY31dZxfO3Wj1NhTBkb0OBQFe3JOqK6stB
        Zto/LMhnNLCZw4Seiey2IrQOyfj7UoqS6XtCFh5ChQvAncJfx/aDMEC+95k36rX6DRJQ5l
        4/3MQAsPs2Bi6m+Xz10j8m3b4Bj20XI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-HymD-qhXNJ-rex6x2r-WSw-1; Fri, 04 Dec 2020 11:50:14 -0500
X-MC-Unique: HymD-qhXNJ-rex6x2r-WSw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD02B1926DA9;
        Fri,  4 Dec 2020 16:50:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5EE15C3E9;
        Fri,  4 Dec 2020 16:50:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201204160347.GA26933@fieldses.org>
References: <20201204160347.GA26933@fieldses.org> <20201204154626.GA26255@fieldses.org> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk> <118876.1607093975@warthog.procyon.org.uk> <122997.1607097713@warthog.procyon.org.uk>
To:     Bruce Fields <bfields@fieldses.org>
Cc:     dhowells@redhat.com, Chuck Lever <chuck.lever@oracle.com>,
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
Content-ID: <125708.1607100601.1@warthog.procyon.org.uk>
Date:   Fri, 04 Dec 2020 16:50:01 +0000
Message-ID: <125709.1607100601@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bruce Fields <bfields@fieldses.org> wrote:

> OK, I guess I don't understand the question.  I haven't thought about
> this code in at least a decade.  What's an auxilary cipher?  Is this a
> question about why we're implementing something, or how we're
> implementing it?

That's what the Linux sunrpc implementation calls them:

	struct crypto_sync_skcipher *acceptor_enc;
	struct crypto_sync_skcipher *initiator_enc;
	struct crypto_sync_skcipher *acceptor_enc_aux;
	struct crypto_sync_skcipher *initiator_enc_aux;

Auxiliary ciphers aren't mentioned in rfc396{1,2} so it appears to be
something peculiar to that implementation.

So acceptor_enc and acceptor_enc_aux, for instance, are both based on the same
key, and the implementation seems to pass the IV from one to the other.  The
only difference is that the 'aux' cipher lacks the CTS wrapping - which only
makes a difference for the final two blocks[*] of the encryption (or
decryption) - and only if the data doesn't fully fill out the last block
(ie. it needs padding in some way so that the encryption algorithm can handle
it).

[*] Encryption cipher blocks, that is.

So I think it's purpose is twofold:

 (1) It's a way to be a bit more efficient, cutting out the CTS layer's
     indirection and additional buffering.

 (2) crypto_skcipher_encrypt() assumes that it's doing the entire crypto
     operation in one go and will always impose the final CTS bit, so you
     can't call it repeatedly to progress through a buffer (as
     xdr_process_buf() would like to do) as that would corrupt the data being
     encrypted - unless you made sure that the data was always block-size
     aligned (in which case, there's no point using CTS).

I wonder how much going through three layers of crypto modules costs.  Looking
at how AES can be implemented using, say, Intel AES intructions, it looks like
AES+CBC should be easy to do in a single module.  I wonder if we could have
optimised kerberos crypto that do the AES and the SHA together in a single
loop.

David

