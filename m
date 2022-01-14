Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6323048EA81
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 14:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241194AbiANNUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 08:20:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231278AbiANNUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 08:20:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rWZLer/iLNWHxUeBPp4gf/3AhfEUJd6bEpSN2CeHfZQ=; b=qUoxmfyQiBP1i+i1+kkftR2pR9
        KcaTxqvAnHzmipxu6FVKzpKw1AhMQauwsg4PEC87+YzmXanJ7MVFkP+Nt/KDkQKNvIvEPygZHbZBR
        iQmrqZKw6IPPU1WBPAi8V3Of+7uJ/AomEODzfQIHg3ImI1iIR3Fd4SlEot4drtwZjgxc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n8MV7-001Pgy-CB; Fri, 14 Jan 2022 14:20:17 +0100
Date:   Fri, 14 Jan 2022 14:20:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] stmmac: intel: Honor phy LED set by system firmware
 on a Dell hardware
Message-ID: <YeF4kbsqag+kZ7ji@lunn.ch>
References: <20220114040755.1314349-1-kai.heng.feng@canonical.com>
 <20220114040755.1314349-2-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114040755.1314349-2-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static void marvell_config_led(struct phy_device *phydev)
>  {
> -	u16 def_config;
> +	struct marvell_priv *priv = phydev->priv;
>  	int err;
>  
> -	switch (MARVELL_PHY_FAMILY_ID(phydev->phy_id)) {
> -	/* Default PHY LED config: LED[0] .. Link, LED[1] .. Activity */
> -	case MARVELL_PHY_FAMILY_ID(MARVELL_PHY_ID_88E1121R):
> -	case MARVELL_PHY_FAMILY_ID(MARVELL_PHY_ID_88E1318S):
> -		def_config = MII_88E1121_PHY_LED_DEF;
> -		break;
> -	/* Default PHY LED config:
> -	 * LED[0] .. 1000Mbps Link
> -	 * LED[1] .. 100Mbps Link
> -	 * LED[2] .. Blink, Activity
> -	 */
> -	case MARVELL_PHY_FAMILY_ID(MARVELL_PHY_ID_88E1510):
> -		if (phydev->dev_flags & MARVELL_PHY_LED0_LINK_LED1_ACTIVE)
> -			def_config = MII_88E1510_PHY_LED0_LINK_LED1_ACTIVE;
> -		else
> -			def_config = MII_88E1510_PHY_LED_DEF;
> -		break;
> -	default:
> +	if (priv->led_def_config == -1)
>  		return;
> +
> +	if (priv->led_def_config)
> +		goto write;

Really?

Please restructure this code. Take it apart into helpers. You need:

A function to set the actual LED configuration.
A function to decide what, if any, configuration to set
A function to store the current configuration on suspend.
A function to restore the current configuration on resume.

Lots of little functions will make it much easier to understand, and
avoid 1980s BASIC style.

I'm also surprised you need to deal with suspend/resume. Why does the
BIOS not set the LED mode on resume, same as it does on power up?

      Andrew
