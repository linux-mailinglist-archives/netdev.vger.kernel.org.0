Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B1849EE07
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 23:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240714AbiA0WXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 17:23:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58790 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238336AbiA0WXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 17:23:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BrhrLCScphdHxRqIKBcsXZrBl9TaZ0+s6YRCLfYR0MU=; b=NNplkwFpGOvZmPiV6QhXNwdByN
        p4Gh6EeWYu2oznqa5mQ1dZpPUEycwGivuAkboq/+0BD3eT3ineMyCljTX6Mzt5L1h8Yx8A/ox/8VE
        eUVEOGOLe6TdyzwvRBkbA3YcZ85+0OhCed6Dlq77BdoZGTFNVi5vUf1l7Pze9HCP8duw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nDDAy-0033VB-12; Thu, 27 Jan 2022 23:23:32 +0100
Date:   Thu, 27 Jan 2022 23:23:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 5/5] net: lan743x: Add Clause-45 MDIO access
Message-ID: <YfMbZC8PIZ/8vwGJ@lunn.ch>
References: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
 <20220127173055.308918-6-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127173055.308918-6-Raju.Lakkaraju@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:00:55PM +0530, Raju Lakkaraju wrote:
> PCI1A011/PCI1A041 chip support the MDIO Clause-45 access
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan743x_main.c | 110 +++++++++++++++++-
>  drivers/net/ethernet/microchip/lan743x_main.h |  16 +++
>  2 files changed, 123 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index 6f6655eb6438..98d346aaf627 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -793,6 +793,95 @@ static int lan743x_mdiobus_write(struct mii_bus *bus,
>  	return ret;
>  }
>  
> +static u32 lan743x_mac_mmd_access(int id, int index, int op, u8 freq)
> +{
> +	u16 dev_addr;
> +	u32 ret;
> +
> +	dev_addr = (index >> 16) & 0x1f;
> +	ret = (id << MAC_MII_ACC_PHY_ADDR_SHIFT_) &
> +		MAC_MII_ACC_PHY_ADDR_MASK_;
> +	ret |= (dev_addr << MAC_MII_ACC_MIIMMD_SHIFT_) &
> +		MAC_MII_ACC_MIIMMD_MASK_;
> +	if (freq)
> +		ret |= (freq << MAC_MII_ACC_MDC_CYCLE_SHIFT_) &
> +			MAC_MII_ACC_MDC_CYCLE_MASK_;

All callers of this function appear to pass freq as 0. So you can
remove this.

> +	if (op == 1)
> +		ret |= MAC_MII_ACC_MIICMD_WRITE_;
> +	else if (op == 2)
> +		ret |= MAC_MII_ACC_MIICMD_READ_;
> +	else if (op == 3)
> +		ret |= MAC_MII_ACC_MIICMD_READ_INC_;
> +	else
> +		ret |= MAC_MII_ACC_MIICMD_ADDR_;

> +		mmd_access = lan743x_mac_mmd_access(phy_id, index, 0, 0);

It is pretty opaque what the 0 means here. How about you actually pass
MAC_MII_ACC_MIICMD_ values?

lan743x_mac_mmd_access(phy_id, index, );

> +		if (adapter->mdiobus->probe_capabilities == MDIOBUS_C45)
> +			phydev->c45_ids.devices_in_package &= ~BIT(0);
>  	}

A MAC driver should not be modifying the phydev structure.

>  	/* MAC doesn't support 1000T Half */
> @@ -2822,12 +2914,14 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
>  			sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
>  			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
>  			netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");
> +			adapter->mdiobus->probe_capabilities = MDIOBUS_C22_C45;
>  		} else {
>  			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
>  			sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
>  			sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
>  			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
>  			netif_info(adapter, drv, adapter->netdev, "GMII operation\n");
> +			adapter->mdiobus->probe_capabilities = MDIOBUS_C22;
>  		}
>  	} else {
>  		chip_ver = lan743x_csr_read(adapter, STRAP_READ);
> @@ -2839,19 +2933,29 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
>  			sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
>  			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
>  			netif_info(adapter, drv, adapter->netdev, "SGMII operation\n");
> +			adapter->mdiobus->probe_capabilities = MDIOBUS_C22_C45;
>  		} else {
>  			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
>  			sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
>  			sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
>  			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
>  			netif_info(adapter, drv, adapter->netdev, "GMII operation\n");
> +			adapter->mdiobus->probe_capabilities = MDIOBUS_C22;

This manipulation of adapter->mdiobus->probe_capabilities based on
SGMII vs RGMII makes no sense. It should be set based on what the bus
master can actually do. I assume the PCI1A011/PCI1A041 can do both C22
and C45. So it should look at the reg value and either do a C45
transaction, or a C22 transaction. Do the older chips not support C45?
In that case, return -EOPNOTSUPP if asked to do a C45 transaction.

	Andrew
