Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1384714F86B
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 16:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgBAPZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 10:25:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:32786 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbgBAPZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 10:25:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EsZWTioUimms8PdGTmgVq7XC9kg7nBLn1dmkjL0S1BE=; b=b1b2lBwmz11VkawY66mN9o+kkY
        NS88S7xI+tDKJbnjVuiQmAW9UQizSs5S+f5JDD0DurykOEpS0WCMjNFmYqJDnnVP0sSg7i6f3S04X
        UoxfDcmsz1h45xpxI4KzUAuKgdwDLI7x/a0Tpk3OCpMPqCnyM8nLY2SptvxzLY3j2+OU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ixue6-0003Tj-N3; Sat, 01 Feb 2020 16:25:18 +0100
Date:   Sat, 1 Feb 2020 16:25:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        hkallweit1@gmail.com
Subject: Re: [PATCH 3/6] net: bcmgenet: enable automatic phy discovery
Message-ID: <20200201152518.GI9639@lunn.ch>
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-4-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201074625.8698-4-jeremy.linton@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 01, 2020 at 01:46:22AM -0600, Jeremy Linton wrote:
> The unimac mdio driver falls back to scanning the
> entire bus if its given an appropriate mask. In ACPI
> mode we expect that the system is well behaved and
> conforms to recent versions of the specification.
> 
> We then utilize phy_find_first(), and
> phy_connect_direct() to find and attach to the
> discovered phy during net_device open.
> 
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> ---
>  drivers/net/ethernet/broadcom/genet/bcmmii.c | 40 +++++++++++++++++---
>  1 file changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> index 2049f8218589..f3271975b375 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> @@ -5,7 +5,7 @@
>   * Copyright (c) 2014-2017 Broadcom
>   */
>  
> -
> +#include <linux/acpi.h>
>  #include <linux/types.h>
>  #include <linux/delay.h>
>  #include <linux/wait.h>
> @@ -311,7 +311,9 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
>  int bcmgenet_mii_probe(struct net_device *dev)
>  {
>  	struct bcmgenet_priv *priv = netdev_priv(dev);
> -	struct device_node *dn = priv->pdev->dev.of_node;
> +	struct device *kdev = &priv->pdev->dev;
> +	struct device_node *dn = kdev->of_node;
> +
>  	struct phy_device *phydev;
>  	u32 phy_flags = 0;
>  	int ret;
> @@ -334,7 +336,27 @@ int bcmgenet_mii_probe(struct net_device *dev)
>  			return -ENODEV;
>  		}
>  	} else {
> -		phydev = dev->phydev;
> +		if (has_acpi_companion(kdev)) {
> +			char mdio_bus_id[MII_BUS_ID_SIZE];
> +			struct mii_bus *unimacbus;
> +
> +			snprintf(mdio_bus_id, MII_BUS_ID_SIZE, "%s-%d",
> +				 UNIMAC_MDIO_DRV_NAME, priv->pdev->id);
> +
> +			unimacbus = mdio_find_bus(mdio_bus_id);
> +			if (!unimacbus) {
> +				pr_err("Unable to find mii\n");
> +				return -ENODEV;
> +			}
> +			phydev = phy_find_first(unimacbus);
> +			put_device(&unimacbus->dev);
> +			if (!phydev) {
> +				pr_err("Unable to find PHY\n");
> +				return -ENODEV;

Hi Jeremy

phy_find_first() is not recommended. Only use it if you have no other
option. If the hardware is more complex, two PHYs on one bus, you are
going to have a problem. So i suggest this is used only for PCI cards
where the hardware is very fixed, and there is only ever one MAC and
PHY on the PCI card. When you do have this split between MAC and MDIO
bus, each being independent devices, it is more likely that you do
have multiple PHYs on one shared MDIO bus.

In the DT world, you use a phy-handle to point to the PHY node in the
device tree. Does ACPI have the same concept, a pointer to some other
device in ACPI?

Thanks
	Andrew
