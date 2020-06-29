Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C5720E17B
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbgF2U4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731284AbgF2TNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D30C00877B
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 02:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FwIeVVTnvTiid1uiM9rj5pE6Fi/88JYN8LSIoT6dqUU=; b=vi9/D3O+V5h/5gxZJOaMTan5L
        gF2E2RUzH7FCqVlz6sxtqprMURCIT0tsh5qAjtffy84OcLcEerjcan38271fM1C7VNrjL5gJ8GQd8
        +48tRnmXlRqxngf1Lvm/W2cv33BVdN5rtx7WFVaO9hWUpXylL2m9dlVBW/pTBovkaxWCzbRZLWMQP
        vCulmOJXkmqxYH7txor7BmTqSD85RSGW66iyybls9qr1OIao19QITaDz2+Nh5hgN9Rji/FWbHYQqP
        Z9WcYnXnMpyU0be9W2Lm+OhQqn3tJ0PDVdG/sX3znHqA6pdUCDfYErrLLpj4rJkiRXcGY3Eg4VeA+
        NxjmWAHuw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33024)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jppzd-0007Ln-13; Mon, 29 Jun 2020 10:22:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jppzc-00070G-3M; Mon, 29 Jun 2020 10:22:24 +0100
Date:   Mon, 29 Jun 2020 10:22:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Shmuel Hazan <sh@tkos.co.il>
Subject: Re: [PATCH v2] net: phy: marvell10g: support XFI rate matching mode
Message-ID: <20200629092224.GS1551@shell.armlinux.org.uk>
References: <76ee08645fd35182911fd2bac2546e455c4b662c.1593327891.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76ee08645fd35182911fd2bac2546e455c4b662c.1593327891.git.baruch@tkos.co.il>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 28, 2020 at 10:04:51AM +0300, Baruch Siach wrote:
> When the hardware MACTYPE hardware configuration pins are set to "XFI
> with Rate Matching" the PHY interface operate at fixed 10Gbps speed. The
> MAC buffer packets in both directions to match various wire speeds.
> 
> Read the MAC Type field in the Port Control register, and set the MAC
> interface speed accordingly.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
> v2: Move rate matching state read to config_init (RMK)

Not quite what I was after, but it'll do for now.

My only system which has a 3310 PHY and is configured for rate matching
(using an XAUI interface, mode 1) seems to be sick - the 3310 no longer
correctly negotiates on the media side (will only link at 100M/Half and
only passes traffic in one direction), which makes any development with
it rather difficult.  Either the media side drivers have failed or the
magnetics.

I was also hoping for some discussion, as I bought up a few points
about the 3310's rate matching - unless you have the version with
MACsec, the PHY expects the host side to rate limit the egress rate to
the media rate and will _not_ send pause frames.  If you have MACsec,
and the MACsec hardware is enabled (although may not be encrypting),
then the PHY will send pause frames to the host as the internal buffer
fills.

Then there's the whole question of what phydev->speed etc should be set
to - the media speed or the host side link speed with the PHY, and then
how the host side should configure itself.  At least the 88E6390x
switch will force itself to the media side speed using that while in
XAUI mode, resulting in a non-functioning speed.  So should the host
side force itself to 10G whenever in something like XAUI mode?

What do we do about the egress rate - ignore that statement and hope
that the 3310 doesn't create bad packets on the wire if we fill up its
internal buffer?

> ---
>  drivers/net/phy/marvell10g.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index d4c2e62b2439..a7610eb55f30 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -80,6 +80,8 @@ enum {
>  	MV_V2_PORT_CTRL		= 0xf001,
>  	MV_V2_PORT_CTRL_SWRST	= BIT(15),
>  	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
> +	MV_V2_PORT_MAC_TYPE_MASK = 0x7,
> +	MV_V2_PORT_MAC_TYPE_RATE_MATCH = 0x6,
>  	/* Temperature control/read registers (88X3310 only) */
>  	MV_V2_TEMP_CTRL		= 0xf08a,
>  	MV_V2_TEMP_CTRL_MASK	= 0xc000,
> @@ -91,6 +93,7 @@ enum {
>  
>  struct mv3310_priv {
>  	u32 firmware_ver;
> +	bool rate_match;
>  
>  	struct device *hwmon_dev;
>  	char *hwmon_name;
> @@ -458,7 +461,9 @@ static bool mv3310_has_pma_ngbaset_quirk(struct phy_device *phydev)
>  
>  static int mv3310_config_init(struct phy_device *phydev)
>  {
> +	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
>  	int err;
> +	int val;
>  
>  	/* Check that the PHY interface type is compatible */
>  	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
> @@ -475,6 +480,12 @@ static int mv3310_config_init(struct phy_device *phydev)
>  	if (err)
>  		return err;
>  
> +	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
> +	if (val < 0)
> +		return val;
> +	priv->rate_match = ((val & MV_V2_PORT_MAC_TYPE_MASK) ==
> +			MV_V2_PORT_MAC_TYPE_RATE_MATCH);
> +
>  	/* Enable EDPD mode - saving 600mW */
>  	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
>  }
> @@ -581,6 +592,17 @@ static int mv3310_aneg_done(struct phy_device *phydev)
>  
>  static void mv3310_update_interface(struct phy_device *phydev)
>  {
> +	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> +
> +	/* In "XFI with Rate Matching" mode the PHY interface is fixed at
> +	 * 10Gb. The PHY adapts the rate to actual wire speed with help of
> +	 * internal 16KB buffer.
> +	 */
> +	if (priv->rate_match) {
> +		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
> +		return;
> +	}
> +
>  	if ((phydev->interface == PHY_INTERFACE_MODE_SGMII ||
>  	     phydev->interface == PHY_INTERFACE_MODE_2500BASEX ||
>  	     phydev->interface == PHY_INTERFACE_MODE_10GBASER) &&
> -- 
> 2.27.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
