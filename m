Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38E0287F92
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 02:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgJIAqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 20:46:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgJIAqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 20:46:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFA5E2224B;
        Fri,  9 Oct 2020 00:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602204381;
        bh=wEfU66N1+mKIyXlqfZh9Wh9bRdXop4mVY+G2xQ21a18=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J+u2WNHnXb1BOnPFIptgFCwKF9OONORAm/BmAyzvvAzdtv6zVUsR8FhsqzWQG1dwU
         u4dA2pPOgXBNJ1zOq2Hri87EgOnT2ksNBm8Hkapzj4kVJFkueSff7vjht5E8pWPL27
         5QxKS+6aJqychJWyvk3K7zuAut7l/bABJK6GIUgg=
Date:   Thu, 8 Oct 2020 17:46:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: fec: Fix phy_device lookup for
 phy_reset_after_clk_enable()
Message-ID: <20201008174619.282b3482@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9f882603-2419-5931-fe8f-03c2a28ac785@denx.de>
References: <20201006202029.254212-1-marex@denx.de>
        <110b63bb-9096-7ce0-530f-45dffed09077@gmail.com>
        <9f882603-2419-5931-fe8f-03c2a28ac785@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Oct 2020 00:02:42 +0200 Marek Vasut wrote:
> On 10/6/20 11:09 PM, Florian Fainelli wrote:
> > On 10/6/2020 1:20 PM, Marek Vasut wrote: =20
> >> The phy_reset_after_clk_enable() is always called with ndev->phydev,
> >> however that pointer may be NULL even though the PHY device instance
> >> already exists and is sufficient to perform the PHY reset.
> >>
> >> If the PHY still is not bound to the MAC, but there is OF PHY node
> >> and a matching PHY device instance already, use the OF PHY node to
> >> obtain the PHY device instance, and then use that PHY device instance
> >> when triggering the PHY reset.
> >>
> >> Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable()
> >> support")
> >> Signed-off-by: Marek Vasut <marex@denx.de>

> >> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> >> b/drivers/net/ethernet/freescale/fec_main.c
> >> index 2d5433301843..5a4b20941aeb 100644
> >> --- a/drivers/net/ethernet/freescale/fec_main.c
> >> +++ b/drivers/net/ethernet/freescale/fec_main.c
> >> @@ -1912,6 +1912,24 @@ static int fec_enet_mdio_write(struct mii_bus
> >> *bus, int mii_id, int regnum,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> >> =C2=A0 }
> >> =C2=A0 +static void fec_enet_phy_reset_after_clk_enable(struct net_dev=
ice
> >> *ndev)
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 struct fec_enet_private *fep =3D netdev_priv(ndev);
> >> +=C2=A0=C2=A0=C2=A0 struct phy_device *phy_dev =3D ndev->phydev;
> >> +
> >> +=C2=A0=C2=A0=C2=A0 /*
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * If the PHY still is not bound to the MAC, =
but there is
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * OF PHY node and a matching PHY device inst=
ance already,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * use the OF PHY node to obtain the PHY devi=
ce instance,
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * and then use that PHY device instance when=
 triggering
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 * the PHY reset.
> >> +=C2=A0=C2=A0=C2=A0=C2=A0 */
> >> +=C2=A0=C2=A0=C2=A0 if (!phy_dev && fep->phy_node)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 phy_dev =3D of_phy_find_de=
vice(fep->phy_node); =20
> >=20
> > Don't you need to put the phy_dev reference at some point? =20
>=20
> Probably, yes.
>=20
> But first, does this approach and this patch even make sense ?
> I mean, it fixes my problem, but is this right ?

Can you describe your problem in detail?

To an untrained eye this looks pretty weird.
