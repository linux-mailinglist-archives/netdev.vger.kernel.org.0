Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A448E38B1BB
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237971AbhETObP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237589AbhETObM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 10:31:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E72C7610A8;
        Thu, 20 May 2021 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621520990;
        bh=bpHz3ema/4pBJpDrzCqRVQRjI14JX84WeMVs71ki4m4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uuIiehDk5YJteCY4OONZ6ynP4dU4ZM6GkJBbQHWwhUS6Tc/rrF3Kxp6wGOp7bBw6Q
         ihcx14l7CqjznDfT5RZz26IEJMguNiR9cRS0NxW7wLiVA1He4Hoe54lsoXUug9+Xfm
         LMFXvnHxbCRiFMRC/90aSNTqwYUzHIkxeGDGs04v2ax9xzsg17yKQ9sxnImY8FMCUh
         LS/mR8zeyMcf9L1zYPmx35jQwftLzpJgcYWu7ozVXp8z98RJ0crM84o+FLpNci4Vuj
         ydqmWtXJCsuMGeBPpRcdnaZ2lSyR8zhrZCM8g3PoRdqXSccwnX4SYwe8KVZMTLzKrO
         yce9XJ317sGeg==
Date:   Thu, 20 May 2021 15:29:47 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-spi@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: adapt to a SPI controller
 with a limited max transfer size
Message-ID: <20210520142947.GC3962@sirena.org.uk>
References: <20210520135031.2969183-1-olteanv@gmail.com>
 <20210520135615.GB3962@sirena.org.uk>
 <20210520140609.mriocqfabkcflsls@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
Content-Disposition: inline
In-Reply-To: <20210520140609.mriocqfabkcflsls@skbuf>
X-Cookie: Offer void where prohibited by law.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 20, 2021 at 05:06:09PM +0300, Vladimir Oltean wrote:
> On Thu, May 20, 2021 at 02:56:15PM +0100, Mark Brown wrote:
> > On Thu, May 20, 2021 at 04:50:31PM +0300, Vladimir Oltean wrote:

> > > Only that certain SPI controllers, such as the spi-sc18is602 I2C-to-SPI
> > > bridge, cannot keep the chip select asserted for that long.
> > > The spi_max_transfer_size() and spi_max_message_size() functions are how
> > > the controller can impose its hardware limitations upon the SPI
> > > peripheral driver.

> > You should respect both, frankly I don't see any advantage to using
> > cs_change for something like this - just do a bunch of async SPI
> > transfers and you'll get the same effect in terms of being able to keep
> > the queue for the controller primed with more robust support since it's
> > not stressing edge cases.  cs_change is more for doing things that are
> > just very non-standard.

> Sorry, I don't really understand your comment: in which way would it be
> more robust for my use case to use spi_async()?

Your description sounds like the driver is just stitching a bunch of
messages together into a single big message with lots of cs_changes with
the goal of improving performance which is really not using the API at
all idiomatically.  That's at best asking for trouble (it'll certainly
work with fewer controllers), it may even be less performant as you're
less likely to get the benefit of framework enhancements.

> The cs_change logic was already there prior to this patch, I am just
> reiterating how it works. Given the way in which it works (which I think

It seems like you could avoid this issue and most likely other future
issues by making the way the driver uses the API more normal.

> is correct), the most natural way to limit the buffer length is to look
> for the max transfer len.

No, you really do need to pay attention to both - what makes you think
it is safe to just ignore one of them?

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCmclsACgkQJNaLcl1U
h9BLrwf/aYN4nxUGIqEbcjUcf2m7x3tpHvKY3WwkWkoxwfTYvdBwhjw55hF4ar8e
tQ+avMljztUiljvELwoUgN5SPD5Q/CNc2LwgMweIRXKmmSeejveUg3Ua++8zUgQN
FJpTuSy/Z0D5W6Bh8UvTTAh6yZSskJQ9XVMd4j8Ii9yOTOz4BDf6N6YopHGyjYft
zGWWBw0KFiukwjPnkd1dQp3xrICeu8uzuB/MDD0yL0pD7OY9VaN77/xIwULGUEwY
V9WUFxstvXrvstIqP/myU9ADZ2PBaJnkK2tV3EUs9Tf+tFZw19LUsQAJ4LvJKTLk
28KCA/gZaVj9ldo9G2y/7Jf5n8fzBQ==
=WuKF
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--
