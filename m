Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDF32D2C92
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgLHOE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:04:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729718AbgLHOE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 09:04:58 -0500
X-Gm-Message-State: AOAM533zDXagQPamJcCjm0vSMdgzUH+emfMx+uN/ClQgQharlccWqOTP
        kZnOvoRe8EndPV8LA2qgHNfXuQDvH6ielxA9QLE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607436257;
        bh=lDqq2eswXCj3EY+TJU1U1M4S88oFP1VOECqQvTLwIYk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=huKOiS6vTt7nRhQpExK8DNb4h5Pv0evwMKQbfLx0IhhdrFwE8BE1BuC1muVURobOu
         ST4nLS/ZHopUWB8YZac9l2BdtdjsyetfR6EV89vOuqQvQK/aenAm3V+nG7zVeW+w5F
         KP4JOUwhIazs461yxwG2MM1FplLvvpGzli9t9KPMQQvPkwg09Tdk5pzardd4CnJ8uc
         SbnTCXGOTbfgB64ub9z4gZO3MJeC/Af8FnqXPt2Hg7aTY5wQrz/nqTuKXqtiYmhBqa
         BM2enEXefINKTlup0fU2LRo9J1BS26Lft0qtSthaRTqQVKtMJN7vapHRh/2jgnPjYv
         pQq9esu8dZCjA==
X-Google-Smtp-Source: ABdhPJxta+Y1usMiw3UnOu5t+6U7dNLt48uTZSJhRqrZc/PGcWcb8RD8IzREMTmeZYkQoYTac1yDx8/9+QCPcCzh6FM=
X-Received: by 2002:a9d:12c:: with SMTP id 41mr16580172otu.77.1607436256848;
 Tue, 08 Dec 2020 06:04:16 -0800 (PST)
MIME-Version: 1.0
References: <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <118876.1607093975@warthog.procyon.org.uk> <955415.1607433903@warthog.procyon.org.uk>
In-Reply-To: <955415.1607433903@warthog.procyon.org.uk>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 8 Dec 2020 15:04:05 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE+oi2Q7OE8o0xP4XabZt-y61NMG3Q3eyRzSG6cG9i4Kg@mail.gmail.com>
Message-ID: <CAMj1kXE+oi2Q7OE8o0xP4XabZt-y61NMG3Q3eyRzSG6cG9i4Kg@mail.gmail.com>
Subject: Re: Why the auxiliary cipher in gss_krb5_crypto.c?
To:     David Howells <dhowells@redhat.com>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 at 14:25, David Howells <dhowells@redhat.com> wrote:
>
> I wonder - would it make sense to reserve two arrays of scatterlist structs
> and a mutex per CPU sufficient to map up to 1MiB of pages with each array
> while the krb5 service is in use?
>
> That way sunrpc could, say, grab the mutex, map the input and output buffers,
> do the entire crypto op in one go and then release the mutex - at least for
> big ops, small ops needn't use this service.
>
> For rxrpc/afs's use case this would probably be overkill - it's doing crypto
> on each packet, not on whole operations - but I could still make use of it
> there.
>
> However, that then limits the maximum size of an op to 1MiB, plus dangly bits
> on either side (which can be managed with chained scatterlist structs) and
> also limits the number of large simultaneous krb5 crypto ops we can do.
>

Apparently, it is permitted for gss_krb5_cts_crypt() to do a
kmalloc(GFP_NOFS) in the context from where gss_krb5_aes_encrypt() is
being invoked, and so I don't see why it wouldn't be possible to
simply kmalloc() a scatterlist[] of the appropriate size, populate it
with all the pages, bufs and whatever else gets passed into the
skcipher, and pass it into the skcipher in one go.
