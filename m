Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CA338B4A8
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 18:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhETQz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 12:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232199AbhETQzY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 12:55:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C678361353;
        Thu, 20 May 2021 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621529643;
        bh=5nm+bhtokncXWRBnxqkc+uQnmmoGj4a7Ij94Tx7ZydQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bVIaz1b6+ICB5FMbV0j2nWHlDchhuYAM1Hu8K2wp1J1iDrwKrMC9zkn2zOvxhTlKm
         kmgSjdSxznIOgT8bqfWQXSjGGTwGShOI9N1RAE0P3mTa7LuTvybFEA0I73i9bKcouM
         JthcrExCPMO8WeyldillnCGxoah2gLyURjTC6cVzIySflUrzktd707XoWdqn28L8ah
         WTnP0NiNXJFOjWEWsxgeKGUlAaWYHkDqhG3ZMN/tNFUCyreSwARE8y2EB5rwKGebPD
         9qSt1iCUtVdIItgin6wvjNLcbjRVfCPN9+UZUxLDxB8fEQmtEBVuFbS/SjsllBuqMM
         hU11qq13AlPQQ==
Date:   Thu, 20 May 2021 17:54:00 +0100
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
Message-ID: <20210520165400.GD3962@sirena.org.uk>
References: <20210520135031.2969183-1-olteanv@gmail.com>
 <20210520135615.GB3962@sirena.org.uk>
 <20210520140609.mriocqfabkcflsls@skbuf>
 <20210520142947.GC3962@sirena.org.uk>
 <20210520145429.yhcaqrhwcl7luazf@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zS7rBR6csb6tI2e1"
Content-Disposition: inline
In-Reply-To: <20210520145429.yhcaqrhwcl7luazf@skbuf>
X-Cookie: Offer void where prohibited by law.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zS7rBR6csb6tI2e1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 20, 2021 at 05:54:29PM +0300, Vladimir Oltean wrote:
> On Thu, May 20, 2021 at 03:29:47PM +0100, Mark Brown wrote:

> > Your description sounds like the driver is just stitching a bunch of
> > messages together into a single big message with lots of cs_changes with

> Stitching a bunch of s/messages/transfers/, but yes, that is more or
> less correct. I think cs_change is pretty well handled with the SPI

No, if you're just doing plain transfers that's just a perfectly normal
SPI message (eg, a message consisting of a write only transfer followed
by a read only one for a register read) - the purpose of the cs_change
operations seems to be to glue what should normally be a series of
messages into something that the API sees as a single big message.

> SPI controllers that don't treat cs_change properly can always be
> patched, although there is a sizable user base for this feature at the
> moment from what I can see, so the semantics are pretty clear to me (and
> the sja1105 is in line with them).

It's not always possible to convince controllers to implement cs_change,
sometimes the hardware just isn't flexible enough to do anything other
than assert chip select during a single operation and you can't even put
the chip selects into GPIO mode to do it by hand as there's no pinmuxing.

> > > The cs_change logic was already there prior to this patch, I am just
> > > reiterating how it works. Given the way in which it works (which I think

> > It seems like you could avoid this issue and most likely other future
> > issues by making the way the driver uses the API more normal.

> Does this piece of advice mean "don't use cs_change"? Why does it exist

Yes.

> then? I'm confused. Is it because the max_*_size properties are not well
> defined in its presence? Isn't that a problem with the self-consistency
> of the SPI API then?

cs_change is mainly there mainly for devices which require things like
leaving CS asserted outside of messages, often because the length of the
message on the bus is not known at the beginning of the the message (eg,
the device sends a header back including the length so the physical
message gets split into two Linux level messages with cs_change used to
hold chip select asserted between them).  There's also some things like
zero length transfers that bounce CS which some more esoteric hardware
requires.

> > > is correct), the most natural way to limit the buffer length is to look
> > > for the max transfer len.

> > No, you really do need to pay attention to both - what makes you think
> > it is safe to just ignore one of them?

> I think the sja1105 is safe to just ignore the maximum message length
> because "it knows what it's doing" (famous last words). The only real

No, the maximum message length is a *controller* limitation - if the
controller is unable to handle a message larger than a given size then
it's just going to be unable to handle it.

> question is "what does .max_message_size count when its containing
> spi_transfers have cs_change set?", and while I can perfectly understand
> why you'd like to avoid that question, I think my interpretation is the

max_message_size always means the same thing, it's the maximum length
that can be passed safely in a single spi_message.  Similarly for the
maximum transfer, it's the maximum length that can be passed safely in a
single spi_transfer.  We do have code in the core which will split
transfers up, though the rewriting adds overhead so it's best avoided in
performance sensitive cases.

It would be possible for either the driver (or better the core, as with
transfer splitting this isn't device specific) to try to pattern match
and pick apart *some* usages, though not all and mostly not the ones
that match the intended use of the feature so I'm not convinced it's
worthwhile.  For usages like sending a stream of messages which can be
directly expressed in the API it's going to be much better to have code
that just directly sends a stream of messages, it's a much more common
pattern so is more likely to benefit from optimisations and less likely
to get sent down slow paths.

> sane one (it just counts the pieces with continuous CS), and I don't see
> the problems that this interpretation can cause down the line.

If the device is able to support offloading the chip select changes to
the hardware as part of the data stream (some work by basically sending
streams of command packets to the hardware, and some can do fun stuff
as the DMA controller can chain operations together and is perfectly
capable of writing to the SPI controller registers) or is queuing all
the data transfers in a message as a single big DMA then it may run into
limits with those.

--zS7rBR6csb6tI2e1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCmlCgACgkQJNaLcl1U
h9BvRAf/eKBHXa+OTU8mWFTayNo5+PpWP5HdkIYNIVlgCHMCArm+IlQ5NMTOB2vn
TwtiEv0C0veACj41kNRvnNwgEc0z5Q/UyP6zFsckA49sV8nhOvVnXZqrhxlstq/G
5+uZVc5lwjhdV9KMj9zD8g5iYaLZfm/MyDn8nVQ0dmQwh/OS1xH1F6odEUpp1ZMN
3v40pHHyhjB6Yp7ki5Xm1wAYUoF0CBZQ8/+A6TyeNSM2Ka4N6ou0zFrb9htomEBb
xXMxsDji3u57TGAzDAT6z4LY7TnD3FrGdQbv0uhAqNKFZF/8gmdvSxj5X9xMc5NP
unRcJeqGVSex3yOAW5d10mNz3sSC8A==
=bkKA
-----END PGP SIGNATURE-----

--zS7rBR6csb6tI2e1--
