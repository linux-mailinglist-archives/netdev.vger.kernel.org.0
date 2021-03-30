Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3187234EB04
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhC3OuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:50:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54972 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232285AbhC3Otc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 10:49:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lRFgO-00E2Bg-LN; Tue, 30 Mar 2021 16:49:28 +0200
Date:   Tue, 30 Mar 2021 16:49:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 2/3] net: phy: at803x: AR8085: add loopback
 support
Message-ID: <YGM6eIopy5VBHu+T@lunn.ch>
References: <20210330135407.17010-1-o.rempel@pengutronix.de>
 <20210330135407.17010-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330135407.17010-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 03:54:06PM +0200, Oleksij Rempel wrote:
> PHY loopback is needed for the ethernet controller self test support.
> This PHY was tested with the FEC sefltest.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/at803x.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index d7799beb811c..8679738cf2ab 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -326,6 +326,30 @@ static int at803x_resume(struct phy_device *phydev)
>  	return phy_modify(phydev, MII_BMCR, BMCR_PDOWN | BMCR_ISOLATE, 0);
>  }
>  
> +static int at803x_loopback(struct phy_device *phydev, bool enable)
> +{
> +	int ret;
> +
> +	if (enable)
> +		ret = phy_clear_bits(phydev, MII_BMCR, BMCR_ANENABLE);
> +	else
> +		ret = phy_set_bits(phydev, MII_BMCR, BMCR_ANENABLE);

Auto-neg might of been turned off when entering self test. So you
should leave it off when existing self test.

Or maybe call phy_config_aneg() which should reconfigure the PHY back
how it was.

       Andrew
