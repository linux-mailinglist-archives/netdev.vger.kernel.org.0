Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45102D25E1
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 09:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgLHI2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 03:28:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgLHI2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 03:28:45 -0500
X-Gm-Message-State: AOAM533CHJvzc9ByQs7T5tU695sXulZc7tnBIgdBZGk1OfHKQnIXvHfN
        L8Tekjc2Y3ADK+merNjoQ7zdlI1v9FI4NynNj9k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607416084;
        bh=jyKkaKXiQzGnuQvTvF+wC0qTSGobbL2G0IC3stRghDU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=p1zog/D2c5Ld+5yRO3wK8h1myUlWQkC27l8KQdRti0iMcEAGkgHB0Az3bG1ASpErD
         e/KpAUIsOVhgy+ZfyLeLkm3Rhse1yQ6VpfDebd0V7VWCGZrIDDQauRy0hpR+30voPM
         MBzhI4WXahCXQIAADZC6xgZ4Sfm1DgXgc58vT3kfyx3YNp1aYzLwJfVQV+G27lR+bS
         niVcC9YO4iC/ZQNXlqgDG1xv1qQSAN3JSQJV2jkEBSdUd4Qufs26xSgmkHl4cPKbzb
         aMys6HLwNTht5X27ltyNHYeakx6bXhxw0Ks6VGzd/1tl1oD7vR/io4vIA/UkGEn611
         dR07Z1tB8MlkA==
X-Google-Smtp-Source: ABdhPJwS0+KqYVwv76AZtzOyLb7K4/Q9YxUc5R358VAL2n1Q3JFjnSXSbPcwLv0jq4LS0xkvO+SkX4Q5VleICXbWnU0=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr15552080otk.108.1607416083657;
 Tue, 08 Dec 2020 00:28:03 -0800 (PST)
MIME-Version: 1.0
References: <20201204154626.GA26255@fieldses.org> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <118876.1607093975@warthog.procyon.org.uk> <122997.1607097713@warthog.procyon.org.uk>
 <20201204160347.GA26933@fieldses.org> <125709.1607100601@warthog.procyon.org.uk>
 <CAMj1kXEOm_yh478i+dqPiz0eoBxp4eag3j2qHm5eBLe+2kihoQ@mail.gmail.com>
 <127458.1607102368@warthog.procyon.org.uk> <CAMj1kXFe50HvZLxG6Kh-oYBCf5uu51hhuh7mW5UQ62ZSqmu_xA@mail.gmail.com>
 <468625.1607342512@warthog.procyon.org.uk> <CAMj1kXH_gEjgZKx=8uQgv=ckBqTVoh3vrHj=O-nY-nm5VMgLaA@mail.gmail.com>
 <482243.1607350500@warthog.procyon.org.uk>
In-Reply-To: <482243.1607350500@warthog.procyon.org.uk>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 8 Dec 2020 09:27:52 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG5_ePTr7KCxE-m6g9xNHr72-xPMoED7Jmx38uNt6bzoQ@mail.gmail.com>
Message-ID: <CAMj1kXG5_ePTr7KCxE-m6g9xNHr72-xPMoED7Jmx38uNt6bzoQ@mail.gmail.com>
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

On Mon, 7 Dec 2020 at 15:15, David Howells <dhowells@redhat.com> wrote:
>
> Ard Biesheuvel <ardb@kernel.org> wrote:
>
> > > I wonder if it would help if the input buffer and output buffer didn't
> > > have to correspond exactly in usage - ie. the output buffer could be used
> > > at a slower rate than the input to allow for buffering inside the crypto
> > > algorithm.
> > >
> >
> > I don't follow - how could one be used at a slower rate?
>
> I mean that the crypto algorithm might need to buffer the last part of the
> input until it has a block's worth before it can write to the output.
>

This is what is typically handled transparently by the driver. When
you populate a scatterlist, it doesn't matter how misaligned the
individual elements are, the scatterlist walker will always present
the data in chunks that the crypto algorithm can manage. This is why
using a single scatterlist for the entire input is preferable in
general.

> > > The hashes corresponding to the kerberos enctypes I'm supporting are:
> > >
> > > HMAC-SHA1 for aes128-cts-hmac-sha1-96 and aes256-cts-hmac-sha1-96.
> > >
> > > HMAC-SHA256 for aes128-cts-hmac-sha256-128
> > >
> > > HMAC-SHA384 for aes256-cts-hmac-sha384-192
> > >
> > > CMAC-CAMELLIA for camellia128-cts-cmac and camellia256-cts-cmac
> > >
> > > I'm not sure you can support all of those with the instructions available.
> >
> > It depends on whether the caller can make use of the authenc()
> > pattern, which is a type of AEAD we support.
>
> Interesting.  I didn't realise AEAD was an API.
>
> > There are numerous implementations of authenc(hmac(shaXXX),cbc(aes)),
> > including h/w accelerated ones, but none that implement ciphertext
> > stealing. So that means that, even if you manage to use the AEAD layer to
> > perform both at the same time, the generic authenc() template will perform
> > the cts(cbc(aes)) and hmac(shaXXX) by calling into skciphers and ahashes,
> > respectively, which won't give you any benefit until accelerated
> > implementations turn up that perform the whole operation in one pass over
> > the input. And even then, I don't think the performance benefit will be
> > worth it.
>
> Also, the rfc8009 variants that use AES with SHA256/384 hash the ciphertext,
> not the plaintext.
>
> For the moment, it's probably not worth worrying about, then.  If I can manage
> to abstract the sunrpc bits out into a krb5 library, we can improve the
> library later.
>
