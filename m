Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003C02D1357
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 15:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgLGOQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 09:16:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47798 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725816AbgLGOQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 09:16:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607350508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MgTQnfyHDBIlg0aW7LHURku9NdTnw1Wvewb97jbt5cc=;
        b=RATvz0BnflzuDSE3I3wE9n3PYV3ZazAL+WavexGvQyBCbj0mMK5pdmCF7IFvog18KFMwem
        W7MFzk9eCle9h0dfoVfOQGN8wG0AwojTb0gaK4rK6bzgHUP61U4MJ6JBob/M1kfRnhUsiL
        iShb8Omk68rXzStWdq8h7XXzhW3m/i4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-YhyV3gt5MI-mqE0CMyDmIA-1; Mon, 07 Dec 2020 09:15:05 -0500
X-MC-Unique: YhyV3gt5MI-mqE0CMyDmIA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28400DF8A7;
        Mon,  7 Dec 2020 14:15:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE5C719C45;
        Mon,  7 Dec 2020 14:15:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAMj1kXH_gEjgZKx=8uQgv=ckBqTVoh3vrHj=O-nY-nm5VMgLaA@mail.gmail.com>
References: <CAMj1kXH_gEjgZKx=8uQgv=ckBqTVoh3vrHj=O-nY-nm5VMgLaA@mail.gmail.com> <20201204154626.GA26255@fieldses.org> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk> <118876.1607093975@warthog.procyon.org.uk> <122997.1607097713@warthog.procyon.org.uk> <20201204160347.GA26933@fieldses.org> <125709.1607100601@warthog.procyon.org.uk> <CAMj1kXEOm_yh478i+dqPiz0eoBxp4eag3j2qHm5eBLe+2kihoQ@mail.gmail.com> <127458.1607102368@warthog.procyon.org.uk> <CAMj1kXFe50HvZLxG6Kh-oYBCf5uu51hhuh7mW5UQ62ZSqmu_xA@mail.gmail.com> <468625.1607342512@warthog.procyon.org.uk>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     dhowells@redhat.com, Bruce Fields <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
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
Content-ID: <482242.1607350500.1@warthog.procyon.org.uk>
Date:   Mon, 07 Dec 2020 14:15:00 +0000
Message-ID: <482243.1607350500@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ard Biesheuvel <ardb@kernel.org> wrote:

> > I wonder if it would help if the input buffer and output buffer didn't
> > have to correspond exactly in usage - ie. the output buffer could be used
> > at a slower rate than the input to allow for buffering inside the crypto
> > algorithm.
> >
> 
> I don't follow - how could one be used at a slower rate?

I mean that the crypto algorithm might need to buffer the last part of the
input until it has a block's worth before it can write to the output.

> > The hashes corresponding to the kerberos enctypes I'm supporting are:
> >
> > HMAC-SHA1 for aes128-cts-hmac-sha1-96 and aes256-cts-hmac-sha1-96.
> >
> > HMAC-SHA256 for aes128-cts-hmac-sha256-128
> >
> > HMAC-SHA384 for aes256-cts-hmac-sha384-192
> >
> > CMAC-CAMELLIA for camellia128-cts-cmac and camellia256-cts-cmac
> >
> > I'm not sure you can support all of those with the instructions available.
>
> It depends on whether the caller can make use of the authenc()
> pattern, which is a type of AEAD we support.

Interesting.  I didn't realise AEAD was an API.

> There are numerous implementations of authenc(hmac(shaXXX),cbc(aes)),
> including h/w accelerated ones, but none that implement ciphertext
> stealing. So that means that, even if you manage to use the AEAD layer to
> perform both at the same time, the generic authenc() template will perform
> the cts(cbc(aes)) and hmac(shaXXX) by calling into skciphers and ahashes,
> respectively, which won't give you any benefit until accelerated
> implementations turn up that perform the whole operation in one pass over
> the input. And even then, I don't think the performance benefit will be
> worth it.

Also, the rfc8009 variants that use AES with SHA256/384 hash the ciphertext,
not the plaintext.

For the moment, it's probably not worth worrying about, then.  If I can manage
to abstract the sunrpc bits out into a krb5 library, we can improve the
library later.

David

