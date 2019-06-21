Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638E34E928
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 15:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfFUN3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 09:29:23 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42320 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfFUN3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 09:29:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ktktx7WWcR89AvzTAqOgzzcNH2dYkqhvf9ZrJwb2fiA=; b=eoSdTfz1Y+hQKVIUHciDRjJwQ
        Y6iEmcdMNaZs1NthSOikK4uB2t5UFwT6xLqXXgdiXDduKyy8Sv+JqyHIV2KWuEZuHjZ86xTVfCDx2
        nJhGcQFb51Xnoj9B9Bb1/8yvenT2Q6Sk9Cx+7fhReJxPrYPrh8cYzc0VLfM/7lYYw/4FYDILuCD5j
        6Bs52SprI4an9IXEsMImJH8hHroEVKjH77CTMcz+PW1SKDxn/b6IZR3IoYjvrh6Qc5y7aeZU0rcY+
        HpN8MWHgyivYXikvUieglP7P2P3kp3mFeCRIb5rFdyMMjR+k3vnrgeepnLawra3bbUUdoiT06dLNc
        EopYGpyhg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59864)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1heJbN-0005eu-Rh; Fri, 21 Jun 2019 14:29:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1heJbK-0003IY-DH; Fri, 21 Jun 2019 14:29:10 +0100
Date:   Fri, 21 Jun 2019 14:29:10 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     andrew@lunn.ch, nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH v3 1/5] net: macb: add phylink support
Message-ID: <20190621132910.kd6y2i3vk6ogcher@shell.armlinux.org.uk>
References: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
 <1561106084-8241-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561106084-8241-1-git-send-email-pthombar@cadence.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 09:34:44AM +0100, Parshuram Thombare wrote:
> @@ -438,115 +439,145 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
>  		netdev_err(dev, "adjusting tx_clk failed.\n");
>  }
>  
> -static void macb_handle_link_change(struct net_device *dev)
> +static void gem_phylink_validate(struct phylink_config *pl_config,
> +				 unsigned long *supported,
> +				 struct phylink_link_state *state)
>  {
> -	struct macb *bp = netdev_priv(dev);
> -	struct phy_device *phydev = dev->phydev;
> -	unsigned long flags;
> -	int status_change = 0;
> +	struct net_device *netdev = to_net_dev(pl_config->dev);
> +	struct macb *bp = netdev_priv(netdev);
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_GMII:
> +	case PHY_INTERFACE_MODE_RGMII:
> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
> +			phylink_set(mask, 1000baseT_Full);
> +			phylink_set(mask, 1000baseX_Full);
> +			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF)) {
> +				phylink_set(mask, 1000baseT_Half);
> +				phylink_set(mask, 1000baseT_Half);
> +			}
> +		}
> +	/* fallthrough */
> +	case PHY_INTERFACE_MODE_MII:
> +	case PHY_INTERFACE_MODE_RMII:
> +		phylink_set(mask, 10baseT_Half);
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Half);
> +		phylink_set(mask, 100baseT_Full);
> +		break;
> +	default:
> +		break;

PHY_INTERFACE_MODE_NA is used to ascertain the _full_ set of support
from the MAC irrespective of interface mode, so that (eg) SFPs can
select an appropriate interface mode from the subset of capabililties
supported by the SFP and MAC.

Also note this behaviour for MACs that support switching between
2500BASE-X and 1000BASE-X (which are fixed speed BASE-X):

static void mvneta_validate(struct net_device *ndev, unsigned long *supported,
                            struct phylink_link_state *state)
{
...
        /* Half-duplex at speeds higher than 100Mbit is unsupported */
        if (pp->comphy || state->interface != PHY_INTERFACE_MODE_2500BASEX) {
                phylink_set(mask, 1000baseT_Full);
                phylink_set(mask, 1000baseX_Full);
        }
        if (pp->comphy || state->interface == PHY_INTERFACE_MODE_2500BASEX) {
                phylink_set(mask, 2500baseT_Full);
                phylink_set(mask, 2500baseX_Full);
        }

The idea here is that _if_ we have a comphy, we can reprogram the comphy
to select between 1G and 2.5G speeds.  So we offer both 1G and 2.5G
capabilities irrespective of interface mode.

When the interface type is set in mvneta_mac_config(), the comphy is
configured for the link mode, including setting the link speed to either
1.25Gbaud or 3.125Gbaud.

So, the speed of the serdes lane is determined by the selected
PHY_INTERFACE_MODE.

There is additional logic in the mvneta_validate() method to deal with
the selection of 1G and 2.5G modes for BASE-X:

        /* We can only operate at 2500BaseX or 1000BaseX.  If requested
         * to advertise both, only report advertising at 2500BaseX.
         */
        phylink_helper_basex_speed(state);

What this does is clear state->advertising, ensuring that only one of
2500BASE_X or 1000BASE_X is shown, and also sets state->interface in
the validate callback accordingly to select the interface mode.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
