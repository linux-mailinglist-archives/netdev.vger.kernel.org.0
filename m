Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D694C1250FF
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfLRSvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:51:24 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49688 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfLRSvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:51:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=istVMsUTDbX1P2iLAe7DawIao28f9aLgW/Ri8qiYKjY=; b=Oeavx8mcWCwp1WWvfLNsoISH2
        AbxW+Cy5UT/CNi+4Y5cYZPgketroeclGBeUKdyont1jMb2K7CSvMiG4nU9sYDsVKmmr0TfxbPv4PC
        +rWYISQr4WILmVPzfTN08Rz2F00V4FqODvpANrx2TNFay1Dy0e60VIrqcL2Zoftrb427dWngTuk+M
        CTsPoImGu03npnpIPB3QeFa0dKaGE37jxKQ2sB91dyxrq0yWgEaP1d092Y1ovJECgKe++IYgGYUqJ
        iVyEN1/l/FCrQvxI+1a/wtEofwGHbG8bqaYsIdinfzn4pXTRUE3kpZY8bQaUwGdx7Txc6klE7f561
        Q7AP2sHBA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54742)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ihePY-0005mk-EF; Wed, 18 Dec 2019 18:51:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ihePT-0004bD-0R; Wed, 18 Dec 2019 18:50:59 +0000
Date:   Wed, 18 Dec 2019 18:50:58 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 1/8] mii: Add helpers for parsing SGMII
 auto-negotiation
Message-ID: <20191218185058.GW25745@shell.armlinux.org.uk>
References: <20191217221831.10923-1-olteanv@gmail.com>
 <20191217221831.10923-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217221831.10923-2-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 12:18:24AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Typically a MAC PCS auto-configures itself after it receives the
> negotiated copper-side link settings from the PHY, but some MAC devices
> are more special and need manual interpretation of the SGMII AN result.
> 
> In other cases, the PCS exposes the entire tx_config_reg base page as it
> is transmitted on the wire during auto-negotiation, so it makes sense to
> be able to decode the equivalent lp_advertised bit mask from the raw u16
> (of course, "lp" considering the PCS to be the local PHY).
> 
> Therefore, add the bit definitions for the SGMII registers 4 and 5
> (local device ability, link partner ability), as well as a link_mode
> conversion helper that can be used to feed the AN results into
> phy_resolve_aneg_linkmode.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/linux/mii.h      | 50 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/mii.h | 10 ++++++++++
>  2 files changed, 60 insertions(+)
> 
> diff --git a/include/linux/mii.h b/include/linux/mii.h
> index 4ce8901a1af6..18c6208f56fc 100644
> --- a/include/linux/mii.h
> +++ b/include/linux/mii.h
> @@ -373,6 +373,56 @@ static inline u32 mii_lpa_to_ethtool_lpa_x(u32 lpa)
>  }
>  
>  /**
> + * mii_lpa_mod_linkmode_adv_sgmii
> + * @lp_advertising: pointer to destination link mode.
> + * @lpa: value of the MII_LPA register
> + *
> + * A small helper function that translates MII_LPA bits to
> + * linkmode advertisement settings for SGMII.
> + * Leaves other bits unchanged.
> + */
> +static inline void
> +mii_lpa_mod_linkmode_lpa_sgmii(unsigned long *lp_advertising, u32 lpa)
> +{
> +	u32 speed_duplex = lpa & LPA_SGMII_DPX_SPD_MASK;
> +
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, lp_advertising,
> +			 speed_duplex == LPA_SGMII_1000HALF);
> +
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, lp_advertising,
> +			 speed_duplex == LPA_SGMII_1000FULL);
> +
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, lp_advertising,
> +			 speed_duplex == LPA_SGMII_100HALF);
> +
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, lp_advertising,
> +			 speed_duplex == LPA_SGMII_100FULL);
> +
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, lp_advertising,
> +			 speed_duplex == LPA_SGMII_10HALF);
> +
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, lp_advertising,
> +			 speed_duplex == LPA_SGMII_10FULL);
> +}
> +
> +/**
> + * mii_lpa_to_linkmode_adv_sgmii
> + * @advertising: pointer to destination link mode.
> + * @lpa: value of the MII_LPA register
> + *
> + * A small helper function that translates MII_ADVERTISE bits
> + * to linkmode advertisement settings when in SGMII mode.
> + * Clears the old value of advertising.
> + */
> +static inline void mii_lpa_to_linkmode_lpa_sgmii(unsigned long *lp_advertising,
> +						 u32 lpa)
> +{
> +	linkmode_zero(lp_advertising);
> +
> +	mii_lpa_mod_linkmode_lpa_sgmii(lp_advertising, lpa);
> +}
> +
> +/**
>   * mii_adv_mod_linkmode_adv_t
>   * @advertising:pointer to destination link mode.
>   * @adv: value of the MII_ADVERTISE register
> diff --git a/include/uapi/linux/mii.h b/include/uapi/linux/mii.h
> index 51b48e4be1f2..dc3b5d635beb 100644
> --- a/include/uapi/linux/mii.h
> +++ b/include/uapi/linux/mii.h
> @@ -71,6 +71,7 @@
>  /* Advertisement control register. */
>  #define ADVERTISE_SLCT		0x001f	/* Selector bits               */
>  #define ADVERTISE_CSMA		0x0001	/* Only selector supported     */
> +#define ADVERTISE_SGMII		0x0001	/* Can do SGMII                */
>  #define ADVERTISE_10HALF	0x0020	/* Try for 10mbps half-duplex  */
>  #define ADVERTISE_1000XFULL	0x0020	/* Try for 1000BASE-X full-duplex */
>  #define ADVERTISE_10FULL	0x0040	/* Try for 10mbps full-duplex  */
> @@ -94,6 +95,7 @@
>  
>  /* Link partner ability register. */
>  #define LPA_SLCT		0x001f	/* Same as advertise selector  */
> +#define LPA_SGMII		0x0001	/* Can do SGMII                */
>  #define LPA_10HALF		0x0020	/* Can do 10mbps half-duplex   */
>  #define LPA_1000XFULL		0x0020	/* Can do 1000BASE-X full-duplex */
>  #define LPA_10FULL		0x0040	/* Can do 10mbps full-duplex   */
> @@ -104,11 +106,19 @@
>  #define LPA_1000XPAUSE_ASYM	0x0100	/* Can do 1000BASE-X pause asym*/
>  #define LPA_100BASE4		0x0200	/* Can do 100mbps 4k packets   */
>  #define LPA_PAUSE_CAP		0x0400	/* Can pause                   */
> +#define LPA_SGMII_DPX_SPD_MASK	0x1C00	/* SGMII duplex and speed bits */
> +#define LPA_SGMII_10HALF	0x0000	/* Can do SGMII 10mbps half-duplex */
> +#define LPA_SGMII_10FULL	0x1000	/* Can do SGMII 10mbps full-duplex */
> +#define LPA_SGMII_100HALF	0x0400	/* Can do SGMII 100mbps half-duplex */
> +#define LPA_SGMII_100FULL	0x1400	/* Can do SGMII 100mbps full-duplex */
>  #define LPA_PAUSE_ASYM		0x0800	/* Can pause asymetrically     */
> +#define LPA_SGMII_1000HALF	0x0800	/* Can do SGMII 1000mbps half-duplex */
> +#define LPA_SGMII_1000FULL	0x1800	/* Can do SGMII 1000mbps full-duplex */
>  #define LPA_RESV		0x1000	/* Unused...                   */
>  #define LPA_RFAULT		0x2000	/* Link partner faulted        */
>  #define LPA_LPACK		0x4000	/* Link partner acked us       */
>  #define LPA_NPAGE		0x8000	/* Next page bit               */
> +#define LPA_SGMII_LINK		0x8000	/* Link partner has link       */

I wonder whether mixing these definitions together is really such a
good idea, or whether separately grouping them would be better.

I already find the mixture of Clause 37 and Clause 22 definitions to
be a little difficult to spot which are which.

>  
>  #define LPA_DUPLEX		(LPA_10FULL | LPA_100FULL)
>  #define LPA_100			(LPA_100FULL | LPA_100HALF | LPA_100BASE4)
> -- 
> 2.7.4
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
