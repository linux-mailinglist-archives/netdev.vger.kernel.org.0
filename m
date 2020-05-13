Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4421D0D6E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 11:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387873AbgEMJw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 05:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387861AbgEMJwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 05:52:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DA9C061A0C;
        Wed, 13 May 2020 02:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ft535WPrBxMxFYAmdROL29Gd1hqYXPYu/0OGkw3PQ9g=; b=A6zin1hHZANRxscI7PjouY7Fe
        R/b/ualhzllBnLuTEaV6fw8fz3Rr3xKP1K3veWH3haN0HXeVkSVrLPbGik2SEi1Tr1m3955OS0PvF
        InTeKaHJNfU/1waUmxyIChWS13dXmXAQlSyBR2vR1HV9ecQFcoEsuZSStr+6fgo3xnQc5+JRCKEy3
        xXiD9OOVPUyuPeh05a0TQmetdL/tTohXmxWq5c/Eta2tgqq5hIR/bpZaau9At0xvkxXIZZjbxZiSx
        DdtLbMhjvQpQaE+Vw2Nq5RhK6O6qhc2aqKU9NBq963C1coP8FpmyOpAplXdSz55Avd88x6arkONEy
        C5hn4P1Fw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:57430)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jYo4F-00043y-DN; Wed, 13 May 2020 10:52:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jYo4E-0007fG-Fn; Wed, 13 May 2020 10:52:46 +0100
Date:   Wed, 13 May 2020 10:52:46 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Doug Berger <opendmb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: bcmgenet: add support for ethtool flow
 control
Message-ID: <20200513095246.GH1551@shell.armlinux.org.uk>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-5-git-send-email-opendmb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589243050-18217-5-git-send-email-opendmb@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 05:24:10PM -0700, Doug Berger wrote:
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> index 511d553a4d11..788da1ecea0c 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> @@ -25,6 +25,21 @@
>  
>  #include "bcmgenet.h"
>  
> +static u32 _flow_control_autoneg(struct phy_device *phydev)
> +{
> +	bool tx_pause, rx_pause;
> +	u32 cmd_bits = 0;
> +
> +	phy_get_pause(phydev, &tx_pause, &rx_pause);
> +
> +	if (!tx_pause)
> +		cmd_bits |= CMD_TX_PAUSE_IGNORE;
> +	if (!rx_pause)
> +		cmd_bits |= CMD_RX_PAUSE_IGNORE;
> +
> +	return cmd_bits;
> +}
> +
>  /* setup netdev link state when PHY link status change and
>   * update UMAC and RGMII block when link up
>   */
> @@ -71,12 +86,20 @@ void bcmgenet_mii_setup(struct net_device *dev)
>  		cmd_bits <<= CMD_SPEED_SHIFT;
>  
>  		/* duplex */
> -		if (phydev->duplex != DUPLEX_FULL)
> -			cmd_bits |= CMD_HD_EN;
> -
> -		/* pause capability */
> -		if (!phydev->pause)
> -			cmd_bits |= CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;
> +		if (phydev->duplex != DUPLEX_FULL) {
> +			cmd_bits |= CMD_HD_EN |
> +				CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;

phy_get_pause() already takes account of whether the PHY is in half
duplex mode.  So:

		bool tx_pause, rx_pause;

		if (phydev->autoneg && priv->autoneg_pause) {
			phy_get_pause(phydev, &tx_pause, &rx_pause);
		} else if (phydev->duplex == DUPLEX_FULL) {
			tx_pause = priv->tx_pause;
			rx_pause = priv->rx_pause;
		} else {
			tx_pause = false;
			rx_pause = false;
		}

		if (!tx_pause)
			cmd_bits |= CMD_TX_PAUSE_IGNORE;
		if (!rx_pause)
			cmd_bits |= CMD_RX_PAUSE_IGNORE;

would be entirely sufficient here.

I wonder whether your implementation (which mine follows) is really
correct though.  Consider this:

# ethtool -A eth0 autoneg on tx on rx on
# ethtool -s eth0 autoneg off speed 1000 duplex full

At this point, what do you expect the resulting pause state to be?  It
may not be what you actually think it should be - it will be tx and rx
pause enabled (it's easier to see why that happens with my rewritten
version of your implementation, which is functionally identical.)

If we take the view that if link autoneg is disabled, and therefore the
link partner's advertisement is zero, shouldn't it result in tx and rx
pause being disabled?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
