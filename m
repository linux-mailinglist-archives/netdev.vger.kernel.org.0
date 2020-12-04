Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29862CF2B6
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731121AbgLDRGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:06:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:32868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728924AbgLDRGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 12:06:53 -0500
X-Gm-Message-State: AOAM531GBwtP9wjZfv/hNZtM1rTTpbf9KeJ2fwzfSJk33h6T+D+GBdDZ
        S6sgI1+0Xi7X5Rn3JLr2HfuFkHnvU1G8Ci+llgI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607101572;
        bh=vec0ymMx+wnF0gfcJ8Hu7mkpp7jIjtysTw6fFvmzqeM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I0HtVWnVer1z+5BBs3cxv/CYkp67TvlLIWfjFM2peNcQ5Y2tFvbMsRMvkyU5uvHnG
         IRSqNJnC0kSv8Gw5eQIAvaWMM5zD6Qex8VOekMk/cGhY3xGdoruQxh7AEouXyyQKML
         sggXuz87OM/xpHw1AHlolAxSDpG933dg1ekV8AFdjny4zhW7CLhx6hewPXNnCX6383
         ISThDIqZ0dek2KCxo6vMGTX7VG/jDNZvBqZfUXApmfUR9bPxaBJwjyoINa4IgWrmrp
         f4N6NXy/fPMKyYTAKcewuLwJjzguSZ7fNd+gkQBykqTmCftFbIXb0k63aZyZ4EfoER
         65TrA7vHUfDkQ==
X-Google-Smtp-Source: ABdhPJz/xmXkEkku+Emo5ZLaxzMbQOcBAvTQmo8aS4l/1QBG9FXpc/dvkPoniOT2Szt2kX6d2vyhuiwEmMoRZ9AImvI=
X-Received: by 2002:a4a:45c3:: with SMTP id y186mr4202016ooa.13.1607101571557;
 Fri, 04 Dec 2020 09:06:11 -0800 (PST)
MIME-Version: 1.0
References: <20201204154626.GA26255@fieldses.org> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <118876.1607093975@warthog.procyon.org.uk> <122997.1607097713@warthog.procyon.org.uk>
 <20201204160347.GA26933@fieldses.org> <125709.1607100601@warthog.procyon.org.uk>
In-Reply-To: <125709.1607100601@warthog.procyon.org.uk>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 4 Dec 2020 18:06:00 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEOm_yh478i+dqPiz0eoBxp4eag3j2qHm5eBLe+2kihoQ@mail.gmail.com>
Message-ID: <CAMj1kXEOm_yh478i+dqPiz0eoBxp4eag3j2qHm5eBLe+2kihoQ@mail.gmail.com>
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

On Fri, 4 Dec 2020 at 17:52, David Howells <dhowells@redhat.com> wrote:
>
> Bruce Fields <bfields@fieldses.org> wrote:
>
> > OK, I guess I don't understand the question.  I haven't thought about
> > this code in at least a decade.  What's an auxilary cipher?  Is this a
> > question about why we're implementing something, or how we're
> > implementing it?
>
> That's what the Linux sunrpc implementation calls them:
>
>         struct crypto_sync_skcipher *acceptor_enc;
>         struct crypto_sync_skcipher *initiator_enc;
>         struct crypto_sync_skcipher *acceptor_enc_aux;
>         struct crypto_sync_skcipher *initiator_enc_aux;
>
> Auxiliary ciphers aren't mentioned in rfc396{1,2} so it appears to be
> something peculiar to that implementation.
>
> So acceptor_enc and acceptor_enc_aux, for instance, are both based on the same
> key, and the implementation seems to pass the IV from one to the other.  The
> only difference is that the 'aux' cipher lacks the CTS wrapping - which only
> makes a difference for the final two blocks[*] of the encryption (or
> decryption) - and only if the data doesn't fully fill out the last block
> (ie. it needs padding in some way so that the encryption algorithm can handle
> it).
>
> [*] Encryption cipher blocks, that is.
>
> So I think it's purpose is twofold:
>
>  (1) It's a way to be a bit more efficient, cutting out the CTS layer's
>      indirection and additional buffering.
>
>  (2) crypto_skcipher_encrypt() assumes that it's doing the entire crypto
>      operation in one go and will always impose the final CTS bit, so you
>      can't call it repeatedly to progress through a buffer (as
>      xdr_process_buf() would like to do) as that would corrupt the data being
>      encrypted - unless you made sure that the data was always block-size
>      aligned (in which case, there's no point using CTS).
>
> I wonder how much going through three layers of crypto modules costs.  Looking
> at how AES can be implemented using, say, Intel AES intructions, it looks like
> AES+CBC should be easy to do in a single module.  I wonder if we could have
> optimised kerberos crypto that do the AES and the SHA together in a single
> loop.
>

The tricky thing with CTS is that you have to ensure that the final
full and partial blocks are presented to the crypto driver as one
chunk, or it won't be able to perform the ciphertext stealing. This
might be the reason for the current approach. If the sunrpc code has
multiple disjoint chunks of data to encrypto, it is always better to
wrap it in a single scatterlist and call into the skcipher only once.

However, I would recommend against it: at least for ARM and arm64, I
have already contributed SIMD based implementations that use SIMD
permutation instructions and overlapping loads and stores to perform
the ciphertext stealing, which means that there is only a single layer
which implements CTS+CBC+AES, and this layer can consume the entire
scatterlist in one go. We could easily do something similar in the
AES-NI driver as well.
