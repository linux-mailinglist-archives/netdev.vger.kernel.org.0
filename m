Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C459355FBD
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbhDFXuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344773AbhDFXuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:50:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2F17613B9;
        Tue,  6 Apr 2021 23:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617753044;
        bh=jKDaCLOocEvmEbOrKDvFaIUIiez9Pb75u4W2J9rmQnc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LNGHUKpVhvOaTwBC/I6kgiHDoCgEdQBbvkHiSAT+v4EClw+MJF11AQh0lytOvsU2z
         zOUk/FJJececAVnCjKsJ1dA5Hcz++PJRXiDhGrkzw0Hs36B1VR8DjWMZcTMVvIVNTX
         BXwvb5M5PxkxI3PbfT4C4R6kolhI8C44lnW51flcgvmCM/x8nYGy7iRL6jEaAsmunJ
         BWVe81QEJMARqeViLUVrkVFKkMD7FZplu3DUaF5Apl42tuPMKmrT+K8RRfkUvCZuIz
         ZqbSTJY4Ggz52ydFKhJoDujnX/221wXtFEPO9RBH4H1cNh5HAZiXJcElQ0bPQm9HxU
         Gun6p+zNDmY6g==
Date:   Wed, 7 Apr 2021 01:50:39 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v3 09/18] include: bitmap: add macro for bitmap
 initialization
Message-ID: <20210407015039.0183c91c@thinkpad>
In-Reply-To: <YGzw9keA5yZc09bZ@lunn.ch>
References: <20210406221107.1004-1-kabel@kernel.org>
        <20210406221107.1004-10-kabel@kernel.org>
        <YGzw9keA5yZc09bZ@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Apr 2021 01:38:30 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Wed, Apr 07, 2021 at 12:10:58AM +0200, Marek Beh=C3=BAn wrote:
> > Use the new variadic-macro.h library to implement macro
> > INITIALIZE_BITMAP(nbits, ...), which can be used for compile time bitmap
> > initialization in the form
> >   static DECLARE_BITMAP(bm, 100) =3D INITIALIZE_BITMAP(100, 7, 9, 66, 9=
8);
> >=20
> > The macro uses the BUILD_BUG_ON_ZERO mechanism to ensure a compile-time
> > error if an argument is out of range.
> >=20
> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > ---
> >  include/linux/bitmap.h | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >=20
> > diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> > index 70a932470b2d..a9e74d3420bf 100644
> > --- a/include/linux/bitmap.h
> > +++ b/include/linux/bitmap.h
> > @@ -8,6 +8,7 @@
> >  #include <linux/bitops.h>
> >  #include <linux/string.h>
> >  #include <linux/kernel.h>
> > +#include <linux/variadic-macro.h>
> > =20
> >  /*
> >   * bitmaps provide bit arrays that consume one or more unsigned
> > @@ -114,6 +115,29 @@
> >   * contain all bit positions from 0 to 'bits' - 1.
> >   */
> > =20
> > +/**
> > + * DOC: initialize bitmap
> > + * The INITIALIZE_BITMAP(bits, args...) macro expands to a designated
> > + * initializer for bitmap of length 'bits', setting each bit specified
> > + * in 'args...'.
> > + */ =20
>=20
> Doesn't the /** mean this is kernel doc? The rest does not seem to
> follow kdoc. Does this compile cleanly with W=3D1?
>=20
>        Andrew

Hmm. I just used the same style as was above in the same file, for
/**
 * DOC: declare bitmap
 ...

Anyway W=3D1 does not complain.

But it does complain about the implementation for INITIALIZE_BITMAP. It
seems that we have to use -Wno-override-init.
This seems to be a new option for gcc. For clang,
scripts/Makefile.extrawarn already uses -Wno-initializer-overrides, but
we have to add -Wno-override-init for gcc.

Marek
