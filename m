Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83C82D2CDD
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgLHOPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:15:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48405 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729635AbgLHOPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:15:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607436837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tffr6g9iDgmcI1vdIiaVq+38gJQDylZk+4muqW+tsNE=;
        b=PYPRxxRSdfplv5X8EEkbvHRzLxpQozQ/FPoppOBP5D/81FAR9/eUOu/c4Lv9CYnt/9C2RE
        V6FNERbX9+IM1sVOntnpE99gUw0o4YBjSDARTrHNmW2SMJiTl8qQBkyBnX3iet6LZ6ql56
        +w/v5SuFcWqzGmj2PuGmBVbGts7Q2iM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-_6Jn5BKhNzC6LVuO_YUIoQ-1; Tue, 08 Dec 2020 09:13:53 -0500
X-MC-Unique: _6Jn5BKhNzC6LVuO_YUIoQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DADC19611AE;
        Tue,  8 Dec 2020 14:13:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E13960BE2;
        Tue,  8 Dec 2020 14:13:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAMj1kXE+oi2Q7OE8o0xP4XabZt-y61NMG3Q3eyRzSG6cG9i4Kg@mail.gmail.com>
References: <CAMj1kXE+oi2Q7OE8o0xP4XabZt-y61NMG3Q3eyRzSG6cG9i4Kg@mail.gmail.com> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk> <118876.1607093975@warthog.procyon.org.uk> <955415.1607433903@warthog.procyon.org.uk>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     dhowells@redhat.com, Chuck Lever <chuck.lever@oracle.com>,
        Bruce Fields <bfields@fieldses.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org
Subject: Re: Why the auxiliary cipher in gss_krb5_crypto.c?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <960648.1607436828.1@warthog.procyon.org.uk>
Date:   Tue, 08 Dec 2020 14:13:48 +0000
Message-ID: <960649.1607436828@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ard Biesheuvel <ardb@kernel.org> wrote:

> Apparently, it is permitted for gss_krb5_cts_crypt() to do a
> kmalloc(GFP_NOFS) in the context from where gss_krb5_aes_encrypt() is
> being invoked, and so I don't see why it wouldn't be possible to
> simply kmalloc() a scatterlist[] of the appropriate size, populate it
> with all the pages, bufs and whatever else gets passed into the
> skcipher, and pass it into the skcipher in one go.

I never said it wasn't possible.  But doing a pair of order-1 allocations from
there might have a significant detrimental effect on performance - in which
case Trond and co. will say "no".

Remember: to crypt 1MiB of data on a 64-bit machine requires 2 x minimum 8KiB
scatterlist arrays.  That's assuming the pages in the middle are contiguous,
which might not be the case for a direct I/O read/write.  So for the DIO case,
it could be involve an order-2 allocation (or chaining of single pages).

David

