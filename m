Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54A43C6575
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 23:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbhGLVaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 17:30:23 -0400
Received: from mail.nic.cz ([217.31.204.67]:46772 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233663AbhGLVaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 17:30:22 -0400
Received: from thinkpad (unknown [172.20.6.87])
        by mail.nic.cz (Postfix) with ESMTPSA id D971F142495;
        Mon, 12 Jul 2021 23:27:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1626125253; bh=HpiLA7q5op2lkcJ3L3J0jTK+7h+TKqgyPsrGVwXzx+c=;
        h=Date:From:To;
        b=CNQGj9LlrNsdU8U8HhJwCNzRZohFYxH5BTsr/MJShgA5w9IcG7ohFix3p5QvwrVe7
         MKXtipcv0tHqtcviHtbmFwmOwh3sf2DjE/YFyqy+motY3241FKJfo6iUdKIDAKEtrW
         x+udes4lRrNsMpj5AVXBv8JMROlVaUD5CdLdliqA=
Date:   Mon, 12 Jul 2021 23:27:32 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH net-next] net: mvneta: deny disabling autoneg for
 802.3z modes
Message-ID: <20210712232732.375d2084@thinkpad>
In-Reply-To: <E1m2y9M-0005w4-3p@rmk-PC.armlinux.org.uk>
References: <E1m2y9M-0005w4-3p@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Jul 2021 16:47:16 +0100
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> The documentation for Armada 38x says:
>=20
>   Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
>   When <PortType> =3D 1 (1000BASE-X) this field must be set to 1.
>=20
> We presently ignore whether userspace requests autonegotiation or not
> through the ethtool ksettings interface. However, we have some network
> interfaces that wish to do this. To offer a consistent API across
> network interfaces, deny the ability to disable autonegotiation on
> mvneta hardware when in 1000BASE-X and 2500BASE-X.
>=20
> This means the only way to switch between 2500BASE-X and 1000BASE-X
> on SFPs that support this will be:
>=20
>  # ethtool -s ethX advertise 0x20000002000 # 1000BASE-X Pause
>  # ethtool -s ethX advertise 0xa000        # 2500BASE-X Pause
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> net-next is currently closed, but I'd like to collect acks for this
> patch. Thanks.
>=20
>  drivers/net/ethernet/marvell/mvneta.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet=
/marvell/mvneta.c
> index 361bc4fbe20b..0a35d216b742 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -3832,12 +3832,20 @@ static void mvneta_validate(struct phylink_config=
 *config,
>  	struct mvneta_port *pp =3D netdev_priv(ndev);
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> =20
> -	/* We only support QSGMII, SGMII, 802.3z and RGMII modes */
> -	if (state->interface !=3D PHY_INTERFACE_MODE_NA &&
> -	    state->interface !=3D PHY_INTERFACE_MODE_QSGMII &&
> -	    state->interface !=3D PHY_INTERFACE_MODE_SGMII &&
> -	    !phy_interface_mode_is_8023z(state->interface) &&
> -	    !phy_interface_mode_is_rgmii(state->interface)) {
> +	/* We only support QSGMII, SGMII, 802.3z and RGMII modes.
> +	 * When in 802.3z mode, we must have AN enabled:
> +	 * "Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
> +	 * When <PortType> =3D 1 (1000BASE-X) this field must be set to 1."
> +	 */
> +	if (phy_interface_mode_is_8023z(state->interface)) {
> +		if (!phylink_test(state->advertising, Autoneg)) {
> +			bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +			return;
> +		}
> +	} else if (state->interface !=3D PHY_INTERFACE_MODE_NA &&
> +		   state->interface !=3D PHY_INTERFACE_MODE_QSGMII &&
> +		   state->interface !=3D PHY_INTERFACE_MODE_SGMII &&
> +		   !phy_interface_mode_is_rgmii(state->interface)) {
>  		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>  		return;
>  	}

Acked-by: Marek Beh=C3=BAn <kabel@kernel.org>
