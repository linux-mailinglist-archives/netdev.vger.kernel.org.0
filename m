Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A12667166
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjALL5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjALL4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:56:44 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20594564EB;
        Thu, 12 Jan 2023 03:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tA9VcsOS7NQTEj8noepMWEcGNsFK3ovKo6+otF7zRi8=; b=iPoVPVcLC6fC9NBlhZx1jP5Any
        sKQTYc62BtEy81wLa6HoSwoQ7DvMCh4CD3e29gV9kkdxBrnGW7hSqX9hstN2wEnbz94+dGr4dbJKU
        /cMIV4nM59AknDpRhdo3NkTntuug1pJSyfDu4M1O8b0VlWVt+J/pt3Q0TnO3B28ElG1MSaJBoEfoA
        QbVA16zDr9QZWF2BO8WFQLLn6QVWKraWhSSAQvGnruO7hBBGgswEzxJsl9SJRI+ccMiGUz9/YdExM
        acUB37cBxEs+2oF1+CC4zOF8BT3bVY/TWe8WwUfuZXnhhBVNU/Pja6ipY8fXDLdUlqIGO7ab1u1Lp
        RjF5169w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36066)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pFw4f-0006Dj-Pb; Thu, 12 Jan 2023 11:48:49 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pFw4V-0002Au-S8; Thu, 12 Jan 2023 11:48:39 +0000
Date:   Thu, 12 Jan 2023 11:48:39 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, jbe@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 6/6] dsa: lan9303: Migrate to PHYLINK
Message-ID: <Y7/zlzcyTsF+z0cN@shell.armlinux.org.uk>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-7-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109211849.32530-7-jerry.ray@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 03:18:49PM -0600, Jerry Ray wrote:
> +static void lan9303_phylink_get_caps(struct dsa_switch *ds, int port,
> +				     struct phylink_config *config)
> +{
> +	struct lan9303 *chip = ds->priv;
> +
> +	dev_dbg(chip->dev, "%s(%d) entered.", __func__, port);
> +
> +	config->mac_capabilities = MAC_10 | MAC_100 | MAC_ASYM_PAUSE |
> +				   MAC_SYM_PAUSE;

You indicate that pause modes are supported, but...

> +static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int port,
> +					unsigned int mode,
> +					phy_interface_t interface,
> +					struct phy_device *phydev, int speed,
> +					int duplex, bool tx_pause,
> +					bool rx_pause)
> +{
> +	u32 ctl;
> +
> +	/* On this device, we are only interested in doing something here if
> +	 * this is the xMII port. All other ports are 10/100 phys using MDIO
> +	 * to control there link settings.
> +	 */
> +	if (port != 0)
> +		return;
> +
> +	ctl = lan9303_phy_read(ds, port, MII_BMCR);
> +
> +	ctl &= ~BMCR_ANENABLE;
> +
> +	if (speed == SPEED_100)
> +		ctl |= BMCR_SPEED100;
> +	else if (speed == SPEED_10)
> +		ctl &= ~BMCR_SPEED100;
> +	else
> +		dev_err(ds->dev, "unsupported speed: %d\n", speed);
> +
> +	if (duplex == DUPLEX_FULL)
> +		ctl |= BMCR_FULLDPLX;
> +	else
> +		ctl &= ~BMCR_FULLDPLX;
> +
> +	lan9303_phy_write(ds, port, MII_BMCR, ctl);

There is no code here to program the resolved pause modes. Is it handled
internally within the switch? (Please add a comment to this effect
either in get_caps or here.)

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
