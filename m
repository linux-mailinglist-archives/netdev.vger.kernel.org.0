Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47561D15EC
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388697AbgEMNjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:39:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57898 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728787AbgEMNjc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 09:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hKK0PusahUIxbCyM9tysfdHvsir7N5IvBCEky0jEiNY=; b=yO+lKrESHBVdVl79yB038dn1C0
        0RBiUREpZ6oVmSLcN/Y3XjsZA8aHMFK9vMWIIYZ0wxHZsjF/+b6rRcN8jPRcKIAn94UDiwQrnC/3k
        kJoP0jS9KqXGzSml+Im1iUz7oLti+haAV8uVUuu8u9S731vOv78LsOU1fRMu4PRlWobw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYrbZ-002AKi-MH; Wed, 13 May 2020 15:39:25 +0200
Date:   Wed, 13 May 2020 15:39:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: phy: tja11xx: add cable-test support
Message-ID: <20200513133925.GD499265@lunn.ch>
References: <20200513123440.19580-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513123440.19580-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 02:34:40PM +0200, Oleksij Rempel wrote:
> Add initial cable testing support.
> This PHY needs only 100usec for this test and it is recommended to run it
> before the link is up. For now, provide at least ethtool support, so it
> can be tested by more developers.
> 
> This patch was tested with TJA1102 PHY with following results:
> - No cable, is detected as open
> - 1m cable, with no connected other end and detected as open
> - a 40m cable (out of spec, max lenght should be 15m) is detected as OK.
> 
> Current patch do not provide polarity test support. This test would
> indicate not proper wire connection, where "+" wire of main phy is
> connected to the "-" wire of the link partner.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/nxp-tja11xx.c | 106 +++++++++++++++++++++++++++++++++-
>  1 file changed, 105 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
> index ca5f9d4dc57ed..8b743d25002b9 100644
> --- a/drivers/net/phy/nxp-tja11xx.c
> +++ b/drivers/net/phy/nxp-tja11xx.c
> @@ -5,6 +5,7 @@
>   */
>  #include <linux/delay.h>
>  #include <linux/ethtool.h>
> +#include <linux/ethtool_netlink.h>
>  #include <linux/kernel.h>
>  #include <linux/mdio.h>
>  #include <linux/mii.h>
> @@ -26,6 +27,7 @@
>  #define MII_ECTRL_POWER_MODE_NO_CHANGE	(0x0 << 11)
>  #define MII_ECTRL_POWER_MODE_NORMAL	(0x3 << 11)
>  #define MII_ECTRL_POWER_MODE_STANDBY	(0xc << 11)
> +#define MII_ECTRL_CABLE_TEST		BIT(5)
>  #define MII_ECTRL_CONFIG_EN		BIT(2)
>  #define MII_ECTRL_WAKE_REQUEST		BIT(0)
>  
> @@ -55,6 +57,11 @@
>  #define MII_GENSTAT			24
>  #define MII_GENSTAT_PLL_LOCKED		BIT(14)
>  
> +#define MII_EXTSTAT			25
> +#define MII_EXTSTAT_SHORT_DETECT	BIT(8)
> +#define MII_EXTSTAT_OPEN_DETECT		BIT(7)
> +#define MII_EXTSTAT_POLARITY_DETECT	BIT(6)
> +

Do these registers all conform to the standard? Can we pull this code
out into a library which all standards conformant PHY drivers can use?

The code itself looks O.K.

    Andrew
