Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CB3212FD3
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 01:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgGBXE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 19:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgGBXE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 19:04:26 -0400
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 106712088E;
        Thu,  2 Jul 2020 23:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593731066;
        bh=kbiQ3OWz9EhhS/Tlb7ohnigA/7ugcibWgJNgPfbWUpA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=S1KCNpG9Pv4STc7dA1EIUYmAJMxBx5FwUZImnnnqH2/lfWVOZF+CqdOBuTtfkBHuq
         Y79CA8eKcotSs/YlBBV0FUEOAuDC5VJa9eJgO2+8gpTiyvAHCcXZW86dLe9UkMudqY
         KJZeeIVM2C71UrOUS4zwAPgGcwv5l109snz7DFaU=
Received: by mail-ot1-f48.google.com with SMTP id 95so14744181otw.10;
        Thu, 02 Jul 2020 16:04:26 -0700 (PDT)
X-Gm-Message-State: AOAM531+iuuZXAvN2qbO+tV+NO1x3xH1Xyg6tRPPMhxpa/+Egn19L/M1
        NMunFLWiSIMckB5iSvx0GU1rtH9irlYCxt1HSw0=
X-Google-Smtp-Source: ABdhPJxz9/D9QobsXbtfi8ziJpmocwg7uy05KVbIQy4z+mCS1flap37AIc4xZoibn5TtrTKeVtMwq2b2dTsAvOaFY3g=
X-Received: by 2002:a9d:5a12:: with SMTP id v18mr27802873oth.90.1593731065360;
 Thu, 02 Jul 2020 16:04:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200702101947.682-1-ardb@kernel.org> <20200702101947.682-5-ardb@kernel.org>
 <20200702175022.GA2753@sol.localdomain> <CAMj1kXFen1nickdZab0s8iY7SgauoH56VginEoPdxaAAL2qENw@mail.gmail.com>
In-Reply-To: <CAMj1kXFen1nickdZab0s8iY7SgauoH56VginEoPdxaAAL2qENw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 3 Jul 2020 01:04:14 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG7i1isB9cV57ccaOZhrG3s7x+nKGozzTewuE9uWvX_wg@mail.gmail.com>
Message-ID: <CAMj1kXG7i1isB9cV57ccaOZhrG3s7x+nKGozzTewuE9uWvX_wg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/7] crypto: remove ARC4 support from the skcipher API
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Denis Kenzior <denkenz@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jul 2020 at 20:21, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 2 Jul 2020 at 19:50, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > [+linux-wireless, Marcel Holtmann, and Denis Kenzior]
> >
> > On Thu, Jul 02, 2020 at 12:19:44PM +0200, Ard Biesheuvel wrote:
> > > Remove the generic ecb(arc4) skcipher, which is slightly cumbersome from
> > > a maintenance perspective, since it does not quite behave like other
> > > skciphers do in terms of key vs IV lifetime. Since we are leaving the
> > > library interface in place, which is used by the various WEP and TKIP
> > > implementations we have in the tree, we can safely drop this code now
> > > it no longer has any users.
> > >
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >
> > Last year there was a discussion where it was mentioned that iwd uses
> > "ecb(arc4)" via AF_ALG.  So can we really remove it yet?
> > See https://lkml.kernel.org/r/97BB95F6-4A4C-4984-9EAB-6069E19B4A4F@holtmann.org
> > Note that the code isn't in "iwd" itself but rather in "libell" which iwd
> > depends on: https://git.kernel.org/pub/scm/libs/ell/ell.git/
> >
> > Apparently it also uses md4 and ecb(des) too.
> >
>
> Ah yes, I remember now :-(
>
> > Marcel and Denis, what's your deprecation plan for these obsolete and insecure
> > algorithms?
> >
>
> Given Denis's statement:
>
>   It sounds to me like it was broken and should be fixed.  So our vote /
>   preference is to have ARC4 fixed to follow the proper semantics.  We
>   can deal with the kernel behavioral change on our end easily enough;
>   the required workarounds are the worse evil.
>
> I would think that an ABI break is not the end of the world for them,
> and given how trivial it is to implement RC4 in C, the workaround
> should be to simply implement RC4 in user space, and not even bother
> trying to use AF_ALG to get at ecb(arc4)
>
> (same applies to md4 and ecb(des) btw)
>
> There will always be a long tail of use cases, and at some point, we
> just have to draw the line and remove obsolete and insecure cruft,
> especially when it impedes progress on other fronts.
>

I have ported iwd to Nettle's LGPL 2.1 implementation of ARC4, and the
diffstat is

 src/crypto.c      | 80 ++++++++++++--------
 src/main.c        |  8 --
 unit/test-eapol.c |  3 +-
 3 files changed, 51 insertions(+), 40 deletions(-)

https://git.kernel.org/pub/scm/linux/kernel/git/ardb/iwd.git/log/?h=arc4-cleanup
