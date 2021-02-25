Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1C13250CE
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 14:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhBYNtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 08:49:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57444 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhBYNtK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 08:49:10 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lFH0D-008Pat-HZ; Thu, 25 Feb 2021 14:48:25 +0100
Date:   Thu, 25 Feb 2021 14:48:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel =?iso-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        noltari@gmail.com
Subject: Re: [PATCH] bcm63xx_enet: fix internal phy IRQ assignment
Message-ID: <YDeqqY0b4ZhhPSaj@lunn.ch>
References: <2270332.afWbCi5vXM@tool>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2270332.afWbCi5vXM@tool>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 03:56:08PM +0100, Daniel González Cabanelas wrote:
> The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As a
> result of this it works in polling mode.
> 
> Fix it using the phy_device structure to assign the platform IRQ.
> 
> Tested under a BCM6348 board. Kernel dmesg before the patch:
>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=POLL)
> 
> After the patch:
>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=17)
> 
> Pluging and uplugging the ethernet cable now generates interrupts and the
> PHY goes up and down as expected.
> 
> Signed-off-by: Daniel González Cabanelas <dgcbueu@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> index fd876721316..0dad527abb9 100644
> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> @@ -1819,7 +1819,14 @@ static int bcm_enet_probe(struct platform_device *pdev)
>  		bus->phy_mask = ~(1 << priv->phy_id);
>  
>  		if (priv->has_phy_interrupt)
> +			phydev = mdiobus_get_phy(bus, priv->phy_id);
> +			if (!phydev) {
> +				dev_err(&dev->dev, "no PHY found\n");
> +				goto out_unregister_mdio;
> +			}
> +
>  			bus->irq[priv->phy_id] = priv->phy_interrupt;
> +			phydev->irq = priv->phy_interrupt;

Hi Daniel

You should not need both bus->irq[priv->phy_id] and phydev->irq. When
then MDIO bus is registered and then probed, and the PHY found,
phydev->irq is set to bus->irq[priv->phy_id]. Assuming this did
actually work once, has there been a change in the order during probe?
You might just need to place the existing assignment earlier.

    Andrew
