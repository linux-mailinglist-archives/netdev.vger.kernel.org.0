Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1FC24864B
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 15:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHRNnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 09:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgHRNnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 09:43:15 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FE4C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 06:43:14 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTPSA id EE4F01409C1;
        Tue, 18 Aug 2020 15:43:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597758186; bh=zZAHX2vd/X7vAnI3FuyO5HcmZJd5YSMWKne7DQhESuo=;
        h=Date:From:To;
        b=SNuVH+oE2dDTjkT3XrhciWrpYuJdK3Gf2DNOL0zoR1mwzYV9SkHBDRnL8F4HEZPSk
         RsGHsw7rnACNiYXqI5x0Glt0oa6/g3QgNRK4bGJYSc9uI7CfMz9JyPByQs3AL0T+Iu
         RBYQfX5yzrYZ9xC3Ls+R+tfDv3NYyvo+tnaHXVb0=
Date:   Tue, 18 Aug 2020 15:43:05 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 0/4] Support for RollBall 10G copper
 SFP modules
Message-ID: <20200818154305.2b7e191c@dellmb.labs.office.nic.cz>
In-Reply-To: <20200817134909.GY1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
        <20200817134909.GY1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Aug 2020 14:49:09 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Tue, Aug 11, 2020 at 12:06:41AM +0200, Marek Beh=FAn wrote:
> > Hi Russell,
> >=20
> > this series should apply on linux-arm git repository, on branch
> > clearfog. =20
>=20
> How about something like this - only build tested, and you may
> encounter fuzz with this:
>=20
> diff --git a/drivers/net/phy/marvell10g.c
> b/drivers/net/phy/marvell10g.c index 147b4cf4188e..bcbef68e0917 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -117,6 +117,7 @@ enum {
>  	MV_V2_PORT_CTRL_FT_1000BASEX =3D 0 << 3,
>  	MV_V2_PORT_CTRL_FT_SGMII =3D 1 << 3,
>  	MV_V2_PORT_CTRL_FT_10GBASER =3D 3 << 3,
> +	MV_V2_PORT_CTRL_MACTYPE	=3D 7 << 0,
>  	MV_V2_UIS		=3D 0xf040,
>  	MV_V2_PIS		=3D 0xf042,
>  	MV_V2_PIS_PI		=3D BIT(0),
> @@ -691,17 +692,44 @@ static bool mv3310_has_pma_ngbaset_quirk(struct
> phy_device *phydev) MV_PHY_ALASKA_NBT_QUIRK_MASK) =3D=3D
> MV_PHY_ALASKA_NBT_QUIRK_REV; }
> =20
> +static int mv3310_select_mode(struct phy_device *phydev,
> +			      unsigned long *host_interfaces)
> +{
> +	int mac_type =3D -1;
> +
> +	if (test_bit(PHY_INTERFACE_MODE_USXGMII, host_interfaces))
> +		mac_type =3D 7;
> +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, host_interfaces)
> &&
> +		 test_bit(PHY_INTERFACE_MODE_10GBASER,
> host_interfaces))
> +		mac_type =3D 4;
> +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, host_interfaces)
> &&
> +		 test_bit(PHY_INTERFACE_MODE_RXAUI, host_interfaces))
> +		mac_type =3D 0;
> +	else if (test_bit(PHY_INTERFACE_MODE_10GBASER,
> host_interfaces))
> +		mac_type =3D 6;
> +	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, host_interfaces))
> +		mac_type =3D 2;
> +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, host_interfaces))
> +		mac_type =3D 4;
> +
> +	return mac_type;
> +}
> +
>  static int mv3310_config_init(struct phy_device *phydev)
>  {
> -	int err;
> +	int ret, err, mac_type =3D -1;
> =20
>  	/* Check that the PHY interface type is compatible */
> -	if (phydev->interface !=3D PHY_INTERFACE_MODE_SGMII &&
> -	    phydev->interface !=3D PHY_INTERFACE_MODE_2500BASEX &&
> -	    phydev->interface !=3D PHY_INTERFACE_MODE_XAUI &&
> -	    phydev->interface !=3D PHY_INTERFACE_MODE_RXAUI &&
> -	    phydev->interface !=3D PHY_INTERFACE_MODE_10GBASER)
> +	if (!phy_interface_empty(phydev->host_interfaces)) {
> +		mac_type =3D mv3310_select_mode(phydev,
> phydev->host_interfaces);
> +		phydev_info(phydev, "mac_type=3D%d\n", mac_type);
> +	} else if (phydev->interface !=3D PHY_INTERFACE_MODE_SGMII &&
> +		   phydev->interface !=3D PHY_INTERFACE_MODE_2500BASEX
> &&
> +		   phydev->interface !=3D PHY_INTERFACE_MODE_XAUI &&
> +		   phydev->interface !=3D PHY_INTERFACE_MODE_RXAUI &&
> +		   phydev->interface !=3D PHY_INTERFACE_MODE_10GBASER)
> { return -ENODEV;
> +	}
> =20
>  	phydev->mdix_ctrl =3D ETH_TP_MDI_AUTO;
> =20
> @@ -710,6 +738,20 @@ static int mv3310_config_init(struct phy_device
> *phydev) if (err)
>  		return err;
> =20
> +	if (mac_type !=3D -1) {
> +		ret =3D phy_modify_mmd_changed(phydev, MDIO_MMD_VEND2,
> +					     MV_V2_PORT_CTRL,
> +
> MV_V2_PORT_CTRL_MACTYPE, mac_type);
> +		if (ret > 0)
> +			ret =3D phy_modify_mmd(phydev, MDIO_MMD_VEND2,
> +					     MV_V2_PORT_CTRL,
> +					     MV_V2_PORT_CTRL_SWRST,
> +					     MV_V2_PORT_CTRL_SWRST);

When chaning mactype you also have to issue SWRST in the same register
write. Otherwise it did not work for me.

> +
> +		if (ret < 0)
> +			return ret;
> +	}
> +
>  	/* Enable EDPD mode - saving 600mW */
>  	err =3D mv3310_set_edpd(phydev,
> ETHTOOL_PHY_EDPD_DFLT_TX_MSECS); if (err)
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 5785eb040f11..4ad64973432a 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -2082,6 +2082,8 @@ static void phylink_sfp_detach(void *upstream,
> struct sfp_bus *bus) sfp_bus_unlink_netdev(bus, pl->netdev);
>  }
> =20
> +static DECLARE_PHY_INTERFACE_MASK(phylink_sfp_interfaces);
> +
>  static const phy_interface_t phylink_sfp_interface_preference[] =3D {
>  	PHY_INTERFACE_MODE_USXGMII,
>  	PHY_INTERFACE_MODE_10GBASER,
> @@ -2091,6 +2093,18 @@ static const phy_interface_t
> phylink_sfp_interface_preference[] =3D { PHY_INTERFACE_MODE_1000BASEX,
>  };
> =20
> +static int __init phylink_init(void)
> +{
> +	int i;
> +
> +	for (i =3D 0; i <
> ARRAY_SIZE(phylink_sfp_interface_preference); i++)
> +		set_bit(phylink_sfp_interface_preference[i],
> +			phylink_sfp_interfaces);
> +
> +	return 0;
> +}
> +module_init(phylink_init);
> +
>  static phy_interface_t phylink_select_interface(struct phylink *pl,
>  						const unsigned long
> *intf, const char *intf_name)
> @@ -2342,6 +2356,10 @@ static int phylink_sfp_connect_phy(void
> *upstream, struct phy_device *phy) else
>  		mode =3D MLO_AN_INBAND;
> =20
> +	/* Set the PHY's host supported interfaces */
> +	phy_interface_and(phy->host_interfaces,
> phylink_sfp_interfaces,
> +			  pl->config->supported_interfaces);
> +
>  	if (!phy_interface_empty(phy->supported_interfaces) &&
>  	    !phy_interface_empty(pl->config->supported_interfaces)) {
>  		interface =3D phylink_select_interface(pl,
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 7408e2240c1e..14f73378f4e9 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -527,6 +527,7 @@ struct phy_device {
> =20
>  	/* bitmap of supported interfaces */
>  	DECLARE_PHY_INTERFACE_MASK(supported_interfaces);
> +	DECLARE_PHY_INTERFACE_MASK(host_interfaces);
> =20
>  	/* Energy efficient ethernet modes which should be
> prohibited */ u32 eee_broken_modes;
>=20

Otherwise it looks nice. I will test this. On what branch does this
apply?

Marek
