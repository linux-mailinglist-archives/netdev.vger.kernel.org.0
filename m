Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C2845DFFB
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 18:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346911AbhKYRvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 12:51:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241032AbhKYRtI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 12:49:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E1256044F;
        Thu, 25 Nov 2021 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637862357;
        bh=33BCUW6GquYLV3B4cCLrzaj/add1SPxmfv8eQnvqnKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IS6yG7ldB8Q4NUsKel72pRdMdFYUYB7BcBi1JLAM35oxM7ZaXtTZhhVxCxn721NlW
         hAaqpRDJmpT/f3yvv76Uo1O2k1W3EKWn9loIqXGt2dzYexQvLu6n8fSAdyaMf9GmDN
         9p5QYGzElJFOKAFUPpRbsbgihl3yrvCEZAUIN9Maj6w1gW3MzkCWO9r/HDGMxjOHh9
         wB4/LpulzLsSR4KleQhxXzGxYDYx5Y5PV/Cypte6HL/G0VxDouzL/RVlXMTIU1gI/z
         jjMyfF1WUn7cBSFKobYlMXBlQKmjTVCpCS0m10dzH6/iFn4RfkS/4T+XMIKEhwawBt
         0qbeKJlMM36KQ==
Date:   Thu, 25 Nov 2021 18:45:51 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Disable AN on 2500base-x for
 Amethyst
Message-ID: <20211125184551.2530cc95@thinkpad>
In-Reply-To: <YZ+txKp0sAOjQUka@lunn.ch>
References: <20211125144359.18478-1-kabel@kernel.org>
        <YZ+txKp0sAOjQUka@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 16:37:40 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Thu, Nov 25, 2021 at 03:43:59PM +0100, Marek Beh=C3=BAn wrote:
> > Amethyst does not support autonegotiation in 2500base-x mode. =20
>=20
> Hi Marek
>=20
> I tried to avoid using Marvells internal names for these devices. I
> don't think these names exist in the datasheet? They are visible in
> the SDK, but that is not so widely available. So if you do want to use
> these names, please also reference the name we use in the kernel,
> mv88e6393x.

I used these names in previous commit that are already merged (search
for Amethyst, Topaz, Peridot). But if you want, I can send v2. Please
let me know if I should send v2.

> > It does not link with AN enabled with other devices.
> > Disable autonegotiation for Amethyst in 2500base-x mode.
> >=20
> > +int mv88e6393x_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
> > +				 int lane, unsigned int mode,
> > +				 phy_interface_t interface,
> > +				 const unsigned long *advertise)
> > +{
> > +	if (interface =3D=3D PHY_INTERFACE_MODE_2500BASEX)
> > +		return 0;
> > +
> > +	return mv88e6390_serdes_pcs_config(chip, port, lane, mode, interface,
> > +					   advertise);
> > +} =20
>=20
> What happens when changing from say 1000BaseX to 2500BaseX? Do you
> need to disable the advertisement which 1000BaseX might of enabled?
>=20
>      Andrew

I don't need to disable it, it is disabled on it's own by cmode change.

Moreover I did some experiments on 88E6393X vs 88E6190.

It is a little weird for 6393x.

On 6190
- resetting the SerDes (BMCR_RESET) does not have impact on the
  BMCR_ANENABLE bit, but changing cmode does

  when cmode is changed to SGMII or 1000base-x, it is enabled, for
  2500base-x it is disabled

- resetting the SerDes (BMCR_RESET) when cmode is
  - sgmii, changes value of the MV88E6390_SGMII_ADVERTISE to 0x0001
    automatically
  - 1000base-x or 2500base-x does not change the value of adv register

  moreover it seems that changing cmode also resets the the SerDes

On 6393x:
- the BMCR behaves the same as in 6190: the switch defaults to AN
  disabled for 2500base-x, and enabled for 1000base-x and SGMII

- the difference is that there are weird values written to
  MV88E6390_SGMII_ADVERTISE on SerDes reset (which is done by switch
  when changing cmode)

  for 1000base-x, the value is 0x9120
  for 2500base-x, the value is 0x9f41

  I don't understand why they changed it so for 6393x.

Marek
