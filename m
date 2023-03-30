Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335206D079E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 16:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbjC3OGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 10:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbjC3OGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 10:06:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D547A9B;
        Thu, 30 Mar 2023 07:06:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C694E6208B;
        Thu, 30 Mar 2023 14:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19B0C433A0;
        Thu, 30 Mar 2023 14:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680185191;
        bh=80GjQ59JxizPxSXKnhbttrwyIA4E7zwhk6Hw/hf5EF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vAS3CYM5vRnVEKqq76XIfuRNLm7XBBBivkXUYw5F/+5OT97549Zh3IheJOI+rdvDx
         vn6soL/OuiuDcyPQE2Qkye0siP7ojkspE6xcPGTa1P0OgreGZYDJbmZU15Qn3An/z0
         W8M6pbBkXeWi7kOsc2Cjisq4Eh/fiDR29wkQgAh0VoFw2Bp1Rjz0kLWmCQIbtg//Gj
         wVoawMtLrjZS0u1QRGvSSJ+v1CqrhZLRwfzSbhW/tc0V1uo9IV/gHG2B4NLbWf2O5/
         8Kg/YT7U4wN0Pq4VWmYxXRgXY/nN4Zqh8nSExVjgzMAPneMaQF++L3feSkqrk+4W9h
         vDe6nzw3p5gZQ==
Date:   Thu, 30 Mar 2023 15:06:28 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rafael@kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [RFC 2/7] regmap: check for alignment on translated register
 addresses
Message-ID: <ZCWXZF3rOucT1M7c@sirena.org.uk>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
 <20230324093644.464704-3-maxime.chevallier@bootlin.com>
 <ZB3xJ4/FTEwHyVyY@sirena.org.uk>
 <20230330114546.13472135@pc-7.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RrmrRms1shZeGUqK"
Content-Disposition: inline
In-Reply-To: <20230330114546.13472135@pc-7.home>
X-Cookie: Single tasking: Just Say No.
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RrmrRms1shZeGUqK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 30, 2023 at 11:45:46AM +0200, Maxime Chevallier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > It is not at all clear to me that the combination of stride and
> > downshift particularly makes sense, and especially not that the
> > stride should be applied after downshifting rather than to what
> > the user is passing in.

> I agree on the part where the ordering of "adding and offset, then
> down/upshifting" isn't natural. This is the order in which operations
> are done today, and from what I could gather, only the ocelot-spi MFD
> driver uses both of these operations.

Right.  I don't think the ordering is particularly intentional,
like I say it's not clear that combinding the two makes sense so
I think it just wasn't considered at all.

--RrmrRms1shZeGUqK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQll2MACgkQJNaLcl1U
h9BpMQf/WhPnIKZo18DLfF0CsOhxPsBoDZOKPIGOi4LPOsxO5AUzT5/NbJsE16F7
JNclev+MkS5gIU1TdqfxOKjMEHT5ObqROfalEhpQ9wGTW5QO7Uczya0ZeBEHHEqN
Zd/E6pnmodtVU+wpG9a5onaSHif4E2PWL6ZaYT199hjLX5alGOicmnO9CcIQFgZo
i3IT+SFMKtUxyMCnSDryJyHM8YlctXSMs9bZ0xBVK9tQE8qqIHl7FclV/sPh7DV2
/eL1bcoSs0xOu/VgJHUJwEFog3ocjhIei3P6HfNcBbv0oRhBi2XgybeDqYxuDXm0
NUgyywuwcoZfWXhA7FMjpaMg+GoYEQ==
=JvNb
-----END PGP SIGNATURE-----

--RrmrRms1shZeGUqK--
