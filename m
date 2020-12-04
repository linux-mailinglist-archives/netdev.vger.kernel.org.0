Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CCF2CF32C
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388350AbgLDRgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:36:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgLDRgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 12:36:41 -0500
X-Gm-Message-State: AOAM530lYNSiOfOYX3WfNLis5YpyxGOItX23T/Zomz7IjRcgfOtm/QJc
        7kOgzWySY9XAyMia6QPCIJnoxJ8rG7nyDozDskU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607103360;
        bh=nzOPWzsALGm9g96B6OfU76fRBhiHX0cmH9B2INe3Q4I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ig1oMzSXyhdIbA9js/0zEH5KavGr3idC/dJT8rM75LAdwf0sLCyFFeL6uFKbDX5Q2
         HzusRHGuh9tiXURDyTSTsFXM2actfCmvzS3EWsmPGcWHuxeSx4+XW/XyUAXc/dGSjW
         0qIH0PoOa7WI4p0mHmUTCYI3J2hIuvBsg7U6hk4fHDBe8PvnNAhyIBlb8eNRshvsKG
         e5AxtFETFlv7CoQqu6Ta+4jembBa+jRqgWkaiA0VjeT1mNajL5tTHQwqNY/1GY6+Kv
         CMEoj8qt0kgOlVXPGfxfwAbOnImsvxTu/PFkdrYTZkSy2eFaO2eRk0Uc486CIIhyCX
         Agp7ec8rwAWHg==
X-Google-Smtp-Source: ABdhPJznC6r+tZ49KMWbvmkRQRkw7RbodUPNa/S/eN750bh5EDuKqJYhR44eXH+qljWAdk/oc/WNBhTWFufK1T560JQ=
X-Received: by 2002:a05:6830:214c:: with SMTP id r12mr4423697otd.90.1607103359560;
 Fri, 04 Dec 2020 09:35:59 -0800 (PST)
MIME-Version: 1.0
References: <20201204154626.GA26255@fieldses.org> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <118876.1607093975@warthog.procyon.org.uk> <122997.1607097713@warthog.procyon.org.uk>
 <20201204160347.GA26933@fieldses.org> <125709.1607100601@warthog.procyon.org.uk>
 <CAMj1kXEOm_yh478i+dqPiz0eoBxp4eag3j2qHm5eBLe+2kihoQ@mail.gmail.com> <127458.1607102368@warthog.procyon.org.uk>
In-Reply-To: <127458.1607102368@warthog.procyon.org.uk>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 4 Dec 2020 18:35:48 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFe50HvZLxG6Kh-oYBCf5uu51hhuh7mW5UQ62ZSqmu_xA@mail.gmail.com>
Message-ID: <CAMj1kXFe50HvZLxG6Kh-oYBCf5uu51hhuh7mW5UQ62ZSqmu_xA@mail.gmail.com>
Subject: Re: Why the auxiliary cipher in gss_krb5_crypto.c?
To:     David Howells <dhowells@redhat.com>
Cc:     Bruce Fields <bfields@fieldses.org>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 at 18:19, David Howells <dhowells@redhat.com> wrote:
>
> Ard Biesheuvel <ardb@kernel.org> wrote:
>
> > The tricky thing with CTS is that you have to ensure that the final
> > full and partial blocks are presented to the crypto driver as one
> > chunk, or it won't be able to perform the ciphertext stealing. This
> > might be the reason for the current approach. If the sunrpc code has
> > multiple disjoint chunks of data to encrypto, it is always better to
> > wrap it in a single scatterlist and call into the skcipher only once.
>
> Yeah - the problem with that is that for sunrpc, we might be dealing with 1MB
> plus bits of non-contiguous pages, requiring >8K of scatterlist elements
> (admittedly, we can chain them, but we may have to do one or more large
> allocations).
>
> > However, I would recommend against it:
>
> Sorry, recommend against what?
>

Recommend against the current approach of manipulating the input like
this and feeding it into the skcipher piecemeal.

Herbert recently made some changes for MSG_MORE support in the AF_ALG
code, which permits a skcipher encryption to be split into several
invocations of the skcipher layer without the need for this complexity
on the side of the caller. Maybe there is a way to reuse that here.
Herbert?

> > at least for ARM and arm64, I
> > have already contributed SIMD based implementations that use SIMD
> > permutation instructions and overlapping loads and stores to perform
> > the ciphertext stealing, which means that there is only a single layer
> > which implements CTS+CBC+AES, and this layer can consume the entire
> > scatterlist in one go. We could easily do something similar in the
> > AES-NI driver as well.
>
> Can you point me at that in the sources?
>

arm64 has

arch/arm64/crypto/aes-glue.c
arch/arm64/crypto/aes-modes.S

where the former implements the skcipher wrapper for an implementation
of "cts(cbc(aes))"

static int cts_cbc_encrypt(struct skcipher_request *req)

walks over the src/dst scatterlist and feeds the data into the asm
helpers, one for the bulk of the input, and one for the final full and
partial blocks (or two final full blocks)

The SIMD asm helpers are

aes_cbc_encrypt
aes_cbc_decrypt
aes_cbc_cts_encrypt
aes_cbc_cts_decrypt

> Can you also do SHA at the same time in the same loop?
>

SHA-1 or HMAC-SHA1? The latter could probably be modeled as an AEAD.
The former doesn't really fit the current API so we'd have to invent
something for it.

> Note that the rfc3962 AES does the checksum over the plaintext, but rfc8009
> does it over the ciphertext.
>
> David
>
