Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAD2588A3
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfF0RhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:37:24 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33608 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbfF0RhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pqekMKm0CtD5SDaoWxQ32eZrwUYNjqy0vb4pdY/YO4E=; b=Ga2DCzvr7RZ9O+oNgFjrnLwQI
        o1nPS9RUQfua8UGRVMH/o5lQ+0aOK5O26XxYC274IPUt3vYQurqQBBX+mO4ge/1wCZbL2sMZVicZ+
        5IfPSttke2i7yrLllgIAbHHgJybAjUYAu/turav2Tol4uTy9VoZBRptTE/efZqSVxyd7GraNrvxZQ
        B+rieB1r8lUKEq+IYu1BLRPINxhMAVp3qkpze+j1vwTEXxb+yL/Px25epS6P1LCODgMe4dOl0leBn
        dOboH1iRGnqDIp+Gf+dXoajY9pO6yTnqwLQPFK0uCzXXFLEAnhWFMkCr6iMSzC75ZEm7qsGIngi/n
        7JxiDSGZw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:59086)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hgYKj-0004MP-JU; Thu, 27 Jun 2019 18:37:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hgYKg-0000lz-Qb; Thu, 27 Jun 2019 18:37:14 +0100
Date:   Thu, 27 Jun 2019 18:37:14 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: sja1105: Check for PHY mode
 mismatches with what PHYLINK reports
Message-ID: <20190627173714.vchw6emcf5dra6jm@shell.armlinux.org.uk>
References: <20190626112014.7625-1-olteanv@gmail.com>
 <20190626112014.7625-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626112014.7625-3-olteanv@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 02:20:13PM +0300, Vladimir Oltean wrote:
> PHYLINK being designed with PHYs in mind that can change MII protocol,
> for correct operation it is necessary to ensure that the PHY interface
> mode stays the same (otherwise clear the supported bit mask, as
> required).
> 
> Because this is just a hypothetical situation for now, we don't bother
> to check whether we could actually support the new PHY interface mode.
> Actually we could modify the xMII table, reset the switch and send an
> updated static configuration, but adding that would just be dead code.
> 
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 47 ++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index da1736093b06..ad4f604590c0 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -766,12 +766,46 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
>  	return sja1105_clocking_setup_port(priv, port);
>  }
>  
> +/* The SJA1105 MAC programming model is through the static config (the xMII
> + * Mode table cannot be dynamically reconfigured), and we have to program
> + * that early (earlier than PHYLINK calls us, anyway).
> + * So just error out in case the connected PHY attempts to change the initial
> + * system interface MII protocol from what is defined in the DT, at least for
> + * now.
> + */
> +static bool sja1105_phy_mode_mismatch(struct sja1105_private *priv, int port,
> +				      phy_interface_t interface)
> +{
> +	struct sja1105_xmii_params_entry *mii;
> +	sja1105_phy_interface_t phy_mode;
> +
> +	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
> +	phy_mode = mii->xmii_mode[port];
> +
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_MII:
> +		return (phy_mode != XMII_MODE_MII);
> +	case PHY_INTERFACE_MODE_RMII:
> +		return (phy_mode != XMII_MODE_RMII);
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		return (phy_mode != XMII_MODE_RGMII);
> +	default:
> +		return true;
> +	}
> +}
> +
>  static void sja1105_mac_config(struct dsa_switch *ds, int port,
>  			       unsigned int link_an_mode,
>  			       const struct phylink_link_state *state)
>  {
>  	struct sja1105_private *priv = ds->priv;
>  
> +	if (sja1105_phy_mode_mismatch(priv, port, state->interface))
> +		return;
> +
>  	sja1105_adjust_port_config(priv, port, state->speed);
>  }
>  
> @@ -804,6 +838,19 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
>  
>  	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
>  
> +	/* include/linux/phylink.h says:
> +	 *     When @state->interface is %PHY_INTERFACE_MODE_NA, phylink
> +	 *     expects the MAC driver to return all supported link modes.
> +	 */
> +	if (state->interface != PHY_INTERFACE_MODE_NA &&
> +	    sja1105_phy_mode_mismatch(priv, port, state->interface)) {
> +		dev_warn(ds->dev, "PHY mode mismatch on port %d: "
> +			 "PHYLINK tried to change to %s\n",
> +			 port, phy_modes(state->interface));

Everything's fine except, please don't print to the kernel log for this.
You're just duplicating the prints in phylink.

> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +		return;
> +	}
> +
>  	/* The MAC does not support pause frames, and also doesn't
>  	 * support half-duplex traffic modes.
>  	 */
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
