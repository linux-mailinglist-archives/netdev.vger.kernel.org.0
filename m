Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A055A20A2EB
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406105AbgFYQaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403828AbgFYQaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 12:30:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3DCC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 09:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7aL5mScz5k/KRhiIPsREYern1/reRxB+LDUnRu1S/6Q=; b=zuNv/6jdt5OW90D1lDI3T0VBF
        Gle8yGbz8Qmc2XhQr89u5bPv3ySVS0aw16Br6Qs8NNfqzlvsg7lPoQpLGP32XNKDruSaubhYr7N6j
        4XX6izrMx2fYCztSM4J2SCMS1aH1fDGZp6Bz4iC1IZN5pIsmrwnU70jGDzYJQyawUyQs/eNhDMcP7
        djtnUxvJg77fqC1k7M7W/Fz7pyw6CuFFAweDqE4OqzYFKNy/5fTv8okDQ9fu7SLcdbVW/XevUP3LU
        ixIPtqnABw6wfzSVx5m834GJ6iDnxMZUc9HEx2Bn+sZrEcB6qio1bkE41wr+54jo+pufqrw7iD+uN
        VMIpaVwSw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59634)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1joUlS-0004aV-3v; Thu, 25 Jun 2020 17:30:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1joUlR-00038F-Rn; Thu, 25 Jun 2020 17:30:13 +0100
Date:   Thu, 25 Jun 2020 17:30:13 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next 2/7] net: dsa: felix: support half-duplex link
 modes
Message-ID: <20200625163013.GG1551@shell.armlinux.org.uk>
References: <20200625152331.3784018-1-olteanv@gmail.com>
 <20200625152331.3784018-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625152331.3784018-3-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 06:23:26PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Ping tested:
> 
>   [   11.808455] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Full - flow control rx/tx
>   [   11.816497] IPv6: ADDRCONF(NETDEV_CHANGE): swp0: link becomes ready
> 
>   [root@LS1028ARDB ~] # ethtool -s swp0 advertise 0x4
>   [   18.844591] mscc_felix 0000:00:00.5 swp0: Link is Down
>   [   22.048337] mscc_felix 0000:00:00.5 swp0: Link is Up - 100Mbps/Half - flow control off
> 
>   [root@LS1028ARDB ~] # ip addr add 192.168.1.1/24 dev swp0
> 
>   [root@LS1028ARDB ~] # ping 192.168.1.2
>   PING 192.168.1.2 (192.168.1.2): 56 data bytes
>   (...)
>   ^C--- 192.168.1.2 ping statistics ---
>   3 packets transmitted, 3 packets received, 0% packet loss
>   round-trip min/avg/max = 0.383/0.611/1.051 ms
> 
>   [root@LS1028ARDB ~] # ethtool -s swp0 advertise 0x10
>   [  355.637747] mscc_felix 0000:00:00.5 swp0: Link is Down
>   [  358.788034] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Half - flow control off
> 
>   [root@LS1028ARDB ~] # ping 192.168.1.2
>   PING 192.168.1.2 (192.168.1.2): 56 data bytes
>   (...)
>   ^C
>   --- 192.168.1.2 ping statistics ---
>   16 packets transmitted, 16 packets received, 0% packet loss
>   round-trip min/avg/max = 0.301/0.384/1.138 ms
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Ping isn't really a good test of whether half duplex mode is operating
correctly.  However, apart from that detail, and as this reflects the
functionality I implemented with the LX2160A version of this PCS:

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

> ---
> Repost of:
> https://patchwork.ozlabs.org/project/netdev/patch/20200624155926.3379373-1-olteanv@gmail.com/
> Changed:
> In the "forced link" scenario (not previously tested, just in-band), we
> need to configure half duplex through the IF_MODE register, not BMCR.
> 
>  drivers/net/dsa/ocelot/felix.c         |  4 +++-
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 24 ++++++++++++++----------
>  include/linux/fsl/enetc_mdio.h         |  1 +
>  3 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 25046777c993..25b340e0a6dd 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -194,13 +194,15 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
>  		return;
>  	}
>  
> -	/* No half-duplex. */
>  	phylink_set_port_modes(mask);
>  	phylink_set(mask, Autoneg);
>  	phylink_set(mask, Pause);
>  	phylink_set(mask, Asym_Pause);
> +	phylink_set(mask, 10baseT_Half);
>  	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
>  	phylink_set(mask, 100baseT_Full);
> +	phylink_set(mask, 1000baseT_Half);
>  	phylink_set(mask, 1000baseT_Full);
>  
>  	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 3269c76b59ff..c1220b488f9c 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -817,12 +817,9 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
>  
>  		phy_write(pcs, MII_BMCR, BMCR_ANRESTART | BMCR_ANENABLE);
>  	} else {
> +		u16 if_mode = ENETC_PCS_IF_MODE_SGMII_EN;
>  		int speed;
>  
> -		if (state->duplex == DUPLEX_HALF) {
> -			phydev_err(pcs, "Half duplex not supported\n");
> -			return;
> -		}
>  		switch (state->speed) {
>  		case SPEED_1000:
>  			speed = ENETC_PCS_SPEED_1000;
> @@ -841,10 +838,11 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
>  			return;
>  		}
>  
> -		phy_write(pcs, ENETC_PCS_IF_MODE,
> -			  ENETC_PCS_IF_MODE_SGMII_EN |
> -			  ENETC_PCS_IF_MODE_SGMII_SPEED(speed));
> +		if_mode |= ENETC_PCS_IF_MODE_SGMII_SPEED(speed);
> +		if (state->duplex == DUPLEX_HALF)
> +			if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
>  
> +		phy_write(pcs, ENETC_PCS_IF_MODE, if_mode);
>  		phy_write(pcs, MII_BMCR, BMCR_RESET);
>  	}
>  }
> @@ -870,15 +868,18 @@ static void vsc9959_pcs_init_2500basex(struct phy_device *pcs,
>  				       unsigned int link_an_mode,
>  				       const struct phylink_link_state *state)
>  {
> +	u16 if_mode = ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500) |
> +		      ENETC_PCS_IF_MODE_SGMII_EN;
> +
>  	if (link_an_mode == MLO_AN_INBAND) {
>  		phydev_err(pcs, "AN not supported on 3.125GHz SerDes lane\n");
>  		return;
>  	}
>  
> -	phy_write(pcs, ENETC_PCS_IF_MODE,
> -		  ENETC_PCS_IF_MODE_SGMII_EN |
> -		  ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500));
> +	if (state->duplex == DUPLEX_HALF)
> +		if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
>  
> +	phy_write(pcs, ENETC_PCS_IF_MODE, if_mode);
>  	phy_write(pcs, MII_BMCR, BMCR_RESET);
>  }
>  
> @@ -919,8 +920,11 @@ static void vsc9959_pcs_init(struct ocelot *ocelot, int port,
>  	linkmode_set_bit_array(phy_basic_ports_array,
>  			       ARRAY_SIZE(phy_basic_ports_array),
>  			       pcs->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, pcs->supported);
>  	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, pcs->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, pcs->supported);
>  	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, pcs->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, pcs->supported);
>  	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, pcs->supported);
>  	if (pcs->interface == PHY_INTERFACE_MODE_2500BASEX ||
>  	    pcs->interface == PHY_INTERFACE_MODE_USXGMII)
> diff --git a/include/linux/fsl/enetc_mdio.h b/include/linux/fsl/enetc_mdio.h
> index 4875dd38af7e..2d9203314865 100644
> --- a/include/linux/fsl/enetc_mdio.h
> +++ b/include/linux/fsl/enetc_mdio.h
> @@ -15,6 +15,7 @@
>  #define ENETC_PCS_IF_MODE_SGMII_EN		BIT(0)
>  #define ENETC_PCS_IF_MODE_USE_SGMII_AN		BIT(1)
>  #define ENETC_PCS_IF_MODE_SGMII_SPEED(x)	(((x) << 2) & GENMASK(3, 2))
> +#define ENETC_PCS_IF_MODE_DUPLEX_HALF		BIT(3)
>  
>  /* Not a mistake, the SerDes PLL needs to be set at 3.125 GHz by Reset
>   * Configuration Word (RCW, outside Linux control) for 2.5G SGMII mode. The PCS
> -- 
> 2.25.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
