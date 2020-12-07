Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A1F2D116E
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgLGNJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgLGNJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 08:09:09 -0500
X-Gm-Message-State: AOAM531nlowu/yVlky6u2pitBwj/AM3Qqn/TU52EeOl3dedNaEO5v30A
        NgnDRalEUWTeQ4IlBNKZHkgvbAJQkrrfrMDJmQA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607346508;
        bh=YiXfatZ6lH4pAyul08wZ68jWEXOKruJ8RP71cHFKE7U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DfT+77pJBcQ2Tz59v8I4UyfPu2VZ9kJOjlVYBjLELyOR9ps8CfmynkxvwsF8gtzjI
         wteAvAxYZSjmljyE8mJsS/y/eyV8RzNK2ArSo0a5p1vfwBdAer+shvPD0ESQZT8gro
         znbojXG6QvGNoEtJk7v86aFHScfXER5QzZqEt7cgHF1IbYfs1aL5sk2k/ct6wriFPD
         eKKzP9SJConbTzoCSFFbLv872uxj5X/HAq3YbVvbND+yeS/JjEGD8yKjtkA7Svz5m2
         xqRlO7x656wxKMlHRRp2QmNpL8xsQOnbQXje8XBGY0J1VNFeudfwihFBPO/8jDWhKL
         me6vEBbvqQ4ig==
X-Google-Smtp-Source: ABdhPJzOCttNG+HMmWL4e+OBsb98ZTp2Sv3FvcRmuGSUW/GZMTC2iGL0S6fIlzxpxGDYQ2h6OZ4tshGuqZ+cL5EHurQ=
X-Received: by 2002:a4a:c60c:: with SMTP id l12mr10949035ooq.45.1607346507298;
 Mon, 07 Dec 2020 05:08:27 -0800 (PST)
MIME-Version: 1.0
References: <20201204154626.GA26255@fieldses.org> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <118876.1607093975@warthog.procyon.org.uk> <122997.1607097713@warthog.procyon.org.uk>
 <20201204160347.GA26933@fieldses.org> <125709.1607100601@warthog.procyon.org.uk>
 <CAMj1kXEOm_yh478i+dqPiz0eoBxp4eag3j2qHm5eBLe+2kihoQ@mail.gmail.com>
 <127458.1607102368@warthog.procyon.org.uk> <CAMj1kXFe50HvZLxG6Kh-oYBCf5uu51hhuh7mW5UQ62ZSqmu_xA@mail.gmail.com>
 <468625.1607342512@warthog.procyon.org.uk>
In-Reply-To: <468625.1607342512@warthog.procyon.org.uk>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 7 Dec 2020 14:08:16 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH_gEjgZKx=8uQgv=ckBqTVoh3vrHj=O-nY-nm5VMgLaA@mail.gmail.com>
Message-ID: <CAMj1kXH_gEjgZKx=8uQgv=ckBqTVoh3vrHj=O-nY-nm5VMgLaA@mail.gmail.com>
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

On Mon, 7 Dec 2020 at 13:02, David Howells <dhowells@redhat.com> wrote:
>
> Ard Biesheuvel <ardb@kernel.org> wrote:
>
> > > Yeah - the problem with that is that for sunrpc, we might be dealing with 1MB
> > > plus bits of non-contiguous pages, requiring >8K of scatterlist elements
> > > (admittedly, we can chain them, but we may have to do one or more large
> > > allocations).
> > >
> > > > However, I would recommend against it:
> > >
> > > Sorry, recommend against what?
> > >
> >
> > Recommend against the current approach of manipulating the input like
> > this and feeding it into the skcipher piecemeal.
>
> Right.  I understand the problem, but as I mentioned above, the scatterlist
> itself becomes a performance issue as it may exceed two pages in size.  Double
> that as there may need to be separate input and output scatterlists.
>

I wasn't aware that Herbert's work hadn't been merged yet. So that
means it is entirely reasonable to split the input like this and feed
the first part into a cbc(aes) skcipher and the last part into a
cts(cbc(aes)) skcipher, provided that you ensure that the last part
covers the final two blocks (one full block and one block that is
either full or partial)

With Herbert's changes, you will be able to use the same skcipher, and
pass a flag to all but the final part that more data is coming. But
for lack of that, the current approach is optimal for cases where
having to cover the entire input with a single scatterlist is
undesirable.

> > Herbert recently made some changes for MSG_MORE support in the AF_ALG
> > code, which permits a skcipher encryption to be split into several
> > invocations of the skcipher layer without the need for this complexity
> > on the side of the caller. Maybe there is a way to reuse that here.
> > Herbert?
>
> I wonder if it would help if the input buffer and output buffer didn't have to
> correspond exactly in usage - ie. the output buffer could be used at a slower
> rate than the input to allow for buffering inside the crypto algorithm.
>

I don't follow - how could one be used at a slower rate?

> > > Can you also do SHA at the same time in the same loop?
> >
> > SHA-1 or HMAC-SHA1? The latter could probably be modeled as an AEAD.
> > The former doesn't really fit the current API so we'd have to invent
> > something for it.
>
> The hashes corresponding to the kerberos enctypes I'm supporting are:
>
> HMAC-SHA1 for aes128-cts-hmac-sha1-96 and aes256-cts-hmac-sha1-96.
>
> HMAC-SHA256 for aes128-cts-hmac-sha256-128
>
> HMAC-SHA384 for aes256-cts-hmac-sha384-192
>
> CMAC-CAMELLIA for camellia128-cts-cmac and camellia256-cts-cmac
>
> I'm not sure you can support all of those with the instructions available.
>

It depends on whether the caller can make use of the authenc()
pattern, which is a type of AEAD we support. There are numerous
implementations of authenc(hmac(shaXXX),cbc(aes)), including h/w
accelerated ones, but none that implement ciphertext stealing. So that
means that, even if you manage to use the AEAD layer to perform both
at the same time, the generic authenc() template will perform the
cts(cbc(aes)) and hmac(shaXXX) by calling into skciphers and ahashes,
respectively, which won't give you any benefit until accelerated
implementations turn up that perform the whole operation in one pass
over the input. And even then, I don't think the performance benefit
will be worth it.
