Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3012D0BB5
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 09:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgLGI0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 03:26:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbgLGI0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 03:26:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607329482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mufcmj20aUEugUydgQ93FnUX087nyQYX2bLOGbVsYnA=;
        b=TilQX35Nw+i/cS/EpHmkoKe5/ln/tTgj6Sdq7uDpTUyD3rb2cATbWwif9IlrNKInvOI4YS
        +ZuRjI+dTF7k0ph3TqbfI5Ph6BF/96U8vzpRBTjBy/Bd7ZO2KdlfLrYMR6jb9dDdhJavzC
        BqRPbEOkUcqL1odHeNmd4ycZS49xfRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-eaugl82PMAyxNLfoaUbqvw-1; Mon, 07 Dec 2020 03:24:37 -0500
X-MC-Unique: eaugl82PMAyxNLfoaUbqvw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7551EBBEE3;
        Mon,  7 Dec 2020 08:24:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E40222B58B;
        Mon,  7 Dec 2020 08:24:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201204210855.GA3412@gondor.apana.org.au>
References: <20201204210855.GA3412@gondor.apana.org.au> <20201204154626.GA26255@fieldses.org> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk> <118876.1607093975@warthog.procyon.org.uk> <122997.1607097713@warthog.procyon.org.uk> <20201204160347.GA26933@fieldses.org> <125709.1607100601@warthog.procyon.org.uk> <CAMj1kXEOm_yh478i+dqPiz0eoBxp4eag3j2qHm5eBLe+2kihoQ@mail.gmail.com> <127458.1607102368@warthog.procyon.org.uk> <CAMj1kXFe50HvZLxG6Kh-oYBCf5uu51hhuh7mW5UQ62ZSqmu_xA@mail.gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com, Ard Biesheuvel <ardb@kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org
Subject: Re: Why the auxiliary cipher in gss_krb5_crypto.c?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <398200.1607329472.1@warthog.procyon.org.uk>
Date:   Mon, 07 Dec 2020 08:24:32 +0000
Message-ID: <398201.1607329472@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > Herbert recently made some changes for MSG_MORE support in the AF_ALG
> > code, which permits a skcipher encryption to be split into several
> > invocations of the skcipher layer without the need for this complexity
> > on the side of the caller. Maybe there is a way to reuse that here.
> > Herbert?
> 
> Yes this was one of the reasons I was persuing the continuation
> work.  It should allow us to kill the special case for CTS in the
> krb5 code.
> 
> Hopefully I can get some time to restart work on this soon.

In the krb5 case, we know in advance how much data we're going to be dealing
with, if that helps.

David

