Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C9D2D0FFD
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgLGMD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:03:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53468 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727223AbgLGMD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:03:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607342521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SWjLfwTOONQTPdH1Ex4bzcrn6zadIhm2DfjdXxC5840=;
        b=JUhpsWstPBJJ/n5T2VV5ozE3FJTmsZUCiZ8Hug+0jDxwPNSZuMX1i1UhiUgvLJMoZfdrlM
        8EVaPCHPEoB1AeEX2BKN/iTUn1nSEsNcBtxnn0L2g7KhrLXBv1LrXPZsBvGf899LjF4h9Q
        T02LTIuxXsrRUEZ5eS2W8UwRV22pjng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-_SXenQ4DNjKzlIC-NcF6nw-1; Mon, 07 Dec 2020 07:01:57 -0500
X-MC-Unique: _SXenQ4DNjKzlIC-NcF6nw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D11C742391;
        Mon,  7 Dec 2020 12:01:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B8FA60BE2;
        Mon,  7 Dec 2020 12:01:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAMj1kXFe50HvZLxG6Kh-oYBCf5uu51hhuh7mW5UQ62ZSqmu_xA@mail.gmail.com>
References: <CAMj1kXFe50HvZLxG6Kh-oYBCf5uu51hhuh7mW5UQ62ZSqmu_xA@mail.gmail.com> <20201204154626.GA26255@fieldses.org> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk> <118876.1607093975@warthog.procyon.org.uk> <122997.1607097713@warthog.procyon.org.uk> <20201204160347.GA26933@fieldses.org> <125709.1607100601@warthog.procyon.org.uk> <CAMj1kXEOm_yh478i+dqPiz0eoBxp4eag3j2qHm5eBLe+2kihoQ@mail.gmail.com> <127458.1607102368@warthog.procyon.org.uk>
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
Content-ID: <468624.1607342512.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 07 Dec 2020 12:01:52 +0000
Message-ID: <468625.1607342512@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ard Biesheuvel <ardb@kernel.org> wrote:

> > Yeah - the problem with that is that for sunrpc, we might be dealing w=
ith 1MB
> > plus bits of non-contiguous pages, requiring >8K of scatterlist elemen=
ts
> > (admittedly, we can chain them, but we may have to do one or more larg=
e
> > allocations).
> >
> > > However, I would recommend against it:
> >
> > Sorry, recommend against what?
> >
> =

> Recommend against the current approach of manipulating the input like
> this and feeding it into the skcipher piecemeal.

Right.  I understand the problem, but as I mentioned above, the scatterlis=
t
itself becomes a performance issue as it may exceed two pages in size.  Do=
uble
that as there may need to be separate input and output scatterlists.

> Herbert recently made some changes for MSG_MORE support in the AF_ALG
> code, which permits a skcipher encryption to be split into several
> invocations of the skcipher layer without the need for this complexity
> on the side of the caller. Maybe there is a way to reuse that here.
> Herbert?

I wonder if it would help if the input buffer and output buffer didn't hav=
e to
correspond exactly in usage - ie. the output buffer could be used at a slo=
wer
rate than the input to allow for buffering inside the crypto algorithm.

> > Can you also do SHA at the same time in the same loop?
> =

> SHA-1 or HMAC-SHA1? The latter could probably be modeled as an AEAD.
> The former doesn't really fit the current API so we'd have to invent
> something for it.

The hashes corresponding to the kerberos enctypes I'm supporting are:

HMAC-SHA1 for aes128-cts-hmac-sha1-96 and aes256-cts-hmac-sha1-96.

HMAC-SHA256 for aes128-cts-hmac-sha256-128

HMAC-SHA384 for aes256-cts-hmac-sha384-192

CMAC-CAMELLIA for camellia128-cts-cmac and camellia256-cts-cmac

I'm not sure you can support all of those with the instructions available.

David

