Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90C62CF30B
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731385AbgLDRVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:21:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730981AbgLDRVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 12:21:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607102378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZuWCzO/rWMgE0fW/Mfsk3GoZ758XI7SWepRZTqwpYog=;
        b=abNU/UlAnQbBSfKtPVVuAjfOAJR3zaMq5JAKpLxOCgJpFOMcP8DZliBz8dGGfFGXTT1ncf
        GcAbEqM+dA9YCz914LOKaEPsIMB1E3R5Vkw2W+l+VMbLpjDcTHk4cSEHSzxARHc6Scjgp8
        T+VssELcLNNDkApWTqePMffJPe3gYLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-WgXng-itOt-8X5Yz2MNpFg-1; Fri, 04 Dec 2020 12:19:34 -0500
X-MC-Unique: WgXng-itOt-8X5Yz2MNpFg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98D9A1922020;
        Fri,  4 Dec 2020 17:19:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F7AB5D9DB;
        Fri,  4 Dec 2020 17:19:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAMj1kXEOm_yh478i+dqPiz0eoBxp4eag3j2qHm5eBLe+2kihoQ@mail.gmail.com>
References: <CAMj1kXEOm_yh478i+dqPiz0eoBxp4eag3j2qHm5eBLe+2kihoQ@mail.gmail.com> <20201204154626.GA26255@fieldses.org> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk> <118876.1607093975@warthog.procyon.org.uk> <122997.1607097713@warthog.procyon.org.uk> <20201204160347.GA26933@fieldses.org> <125709.1607100601@warthog.procyon.org.uk>
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
Content-ID: <127457.1607102368.1@warthog.procyon.org.uk>
Date:   Fri, 04 Dec 2020 17:19:28 +0000
Message-ID: <127458.1607102368@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ard Biesheuvel <ardb@kernel.org> wrote:

> The tricky thing with CTS is that you have to ensure that the final
> full and partial blocks are presented to the crypto driver as one
> chunk, or it won't be able to perform the ciphertext stealing. This
> might be the reason for the current approach. If the sunrpc code has
> multiple disjoint chunks of data to encrypto, it is always better to
> wrap it in a single scatterlist and call into the skcipher only once.

Yeah - the problem with that is that for sunrpc, we might be dealing with 1MB
plus bits of non-contiguous pages, requiring >8K of scatterlist elements
(admittedly, we can chain them, but we may have to do one or more large
allocations).

> However, I would recommend against it:

Sorry, recommend against what?

> at least for ARM and arm64, I
> have already contributed SIMD based implementations that use SIMD
> permutation instructions and overlapping loads and stores to perform
> the ciphertext stealing, which means that there is only a single layer
> which implements CTS+CBC+AES, and this layer can consume the entire
> scatterlist in one go. We could easily do something similar in the
> AES-NI driver as well.

Can you point me at that in the sources?

Can you also do SHA at the same time in the same loop?

Note that the rfc3962 AES does the checksum over the plaintext, but rfc8009
does it over the ciphertext.

David

