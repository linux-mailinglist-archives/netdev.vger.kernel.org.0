Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DD048AEBF
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240927AbiAKNoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240958AbiAKNog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 08:44:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B86C06173F;
        Tue, 11 Jan 2022 05:44:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D3C161648;
        Tue, 11 Jan 2022 13:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5E0C36AED;
        Tue, 11 Jan 2022 13:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641908675;
        bh=BHLwESV3C1+judhGas88m0TCb+8Y2uK1WnqFrETfivw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JvXtNrBtjwgM1pDgZwMpFR4YrXqV9trzm/6uTSl6PMV6QITIcc12DYCKcHvr3tF9t
         xcEFUK7fRkKkX7OmKHf5q2+A7wz4G/6+LOrEkxdZQUhmQS7Q4Ms2ok0ll6qKBvFIlt
         gwqL0HrayiVmPw7q4xBnc3kX9DBzDp4fQ77MinMLvEGp8/cvmmDkUtJxLn8NUDFd/3
         bemiSHPpqXAYMItz0qWZ5V1EE6sP4qCuRAlpbdmcpQich5S2XOFbVn/6zM9DUruIAC
         MfkmeEltaGxejWqGnpFLm4bn7eNhPTcIp0GgFNY3KQXj/i6myXElnOTHVgfZ62+7H5
         hppCNfCwxDqfA==
Date:   Tue, 11 Jan 2022 13:44:28 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v5 net-next 01/13] mfd: ocelot: add support for external
 mfd control over SPI for the VSC7512
Message-ID: <Yd2JvH/D2xmH8Ry7@sirena.org.uk>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-2-colin.foster@in-advantage.com>
 <Ycx9MMc+2ZhgXzvb@google.com>
 <20211230014300.GA1347882@euler>
 <Ydwju35sN9QJqJ/P@google.com>
 <20220111003306.GA27854@COLIN-DESKTOP1.localdomain>
 <Yd1YV+eUIaCnttYd@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9wb1RMRykkpn3qwq"
Content-Disposition: inline
In-Reply-To: <Yd1YV+eUIaCnttYd@google.com>
X-Cookie: Many a family tree needs trimming.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9wb1RMRykkpn3qwq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 11, 2022 at 10:13:43AM +0000, Lee Jones wrote:

> Unless something has changed or my understanding is not correct,
> regmap does not support over-lapping register ranges.

If there's no caches and we're always going direct to hardware it will
work a lot of the time since the buses generally have concurrency
protection at the lowest level, though if the drivers ever do any
read/modify/write operations the underlying hardware bus isn't going to
know about it so you could get data corruption if two drivers decide to
try to operate on the same register.  If there's caches things will
probably go badly since the cache will tend to amplify the
read/modify/write issues.

> However, even if that is required, I still think we can come up with
> something cleaner than creating a whole API based around creating
> and fetching different regmap configurations depending on how the
> system was initialised.

Yeah, I'd expect the usual pattern is to have wrapper drivers that
instantiate a regmap then have the bulk of the driver be a library that
they call into should work.

--9wb1RMRykkpn3qwq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHdibsACgkQJNaLcl1U
h9CIgQf/U9s+7J8sh8p+9sc4ATc+DCY4/XtKgT87NmW3zuHSGn5Lbqme8BW6ynYP
Z2C1r1cWVgFQxWUGrNeYUO4khkmVEdltMwO9duToYMHy8L2sCOL4TgNh4Asg9h8I
a4rbYLRtubTS8pFBI3lJRR7z/psfJiWBMpwKKRetAt4BNrJGMXWEzDL3oyaGIRRK
eKtVWTOBJTZNYGPdZiQsfGAHe568jiqeq4yJpviQgQnKZfr2sJ5Os4d7HsM35zGs
fUNyWjOkGd7MpXLyYrP7EfPpcoyXOM7Qo42kUcRJJyIeXjLV8/dlBphkH8gJ4tbY
3qPvVlNlr93AIMU9Uj228O4fkUXCUQ==
=tbl+
-----END PGP SIGNATURE-----

--9wb1RMRykkpn3qwq--
