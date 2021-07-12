Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67CD3C6576
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 23:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbhGLVai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 17:30:38 -0400
Received: from lists.nic.cz ([217.31.204.67]:47240 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234768AbhGLVah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 17:30:37 -0400
Received: from thinkpad (unknown [172.20.6.87])
        by mail.nic.cz (Postfix) with ESMTPSA id BB184142495;
        Mon, 12 Jul 2021 23:27:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1626125268; bh=toepWkfRML1/8Hzxu6Wv/n7MSw1+daI+0fyt+ivfkCQ=;
        h=Date:From:To;
        b=LQZFeBr+O+4Z9BN4jJODy05+ZAIhSXX+FzfpBI1Wmgbu6yhNE5mFYIo17Nfoewqjj
         Dy2rbyD0R3i3GlU0ZF6NXB9hcEKR/wOpWRHci5lp1YZ7uayzoNtdD9CyEqcsrr3Z9J
         bboZ9Skg3DkNog3ImPlqUdLVb0Tj/exJ20VWJxQo=
Date:   Mon, 12 Jul 2021 23:27:47 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH net-next] net: mvpp2: deny disabling autoneg for
 802.3z modes
Message-ID: <20210712232747.661b4116@thinkpad>
In-Reply-To: <E1m2y9R-0005wP-7n@rmk-PC.armlinux.org.uk>
References: <E1m2y9R-0005wP-7n@rmk-PC.armlinux.org.uk>
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

On Mon, 12 Jul 2021 16:47:21 +0100
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> The documentation for Armada 8040 says:
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
>  # ethtool -s ethX advertise 0x20000006000 # 1000BASE-X Pause AsymPause
>  # ethtool -s ethX advertise 0xe000        # 2500BASE-X Pause AsymPause
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> net-next is currently closed, but I'd like to collect acks for this
> patch. Thanks.
>=20
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 3229bafa2a2c..878fb17dea41 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6269,6 +6269,15 @@ static void mvpp2_phylink_validate(struct phylink_=
config *config,
>  		if (!mvpp2_port_supports_rgmii(port))
>  			goto empty_set;
>  		break;
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		/* When in 802.3z mode, we must have AN enabled:
> +		 * Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
> +		 * When <PortType> =3D 1 (1000BASE-X) this field must be set to 1.
> +		 */
> +		if (!phylink_test(state->advertising, Autoneg))
> +			goto empty_set;
> +		break;
>  	default:
>  		break;
>  	}

Acked-by: Marek Beh=C3=BAn <kabel@kernel.org>
