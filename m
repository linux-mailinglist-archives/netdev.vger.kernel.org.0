Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE08288C58
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 18:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfHJQxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 12:53:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfHJQxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 12:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=R+FrOScjgqWFPYA+Dkx4oVR46AIH2TukJZy2hZOrqjA=; b=SPCYlbuaSCO3P01rKQpLtrFPxL
        75S33xCqXjDZsncoQRo/tdJhCsH5dS8CMn2N4qTeWnRP3gxVV6hXlgy8CEJet+1NwU51j6N6gf3py
        ecz1jCdjhKfYaLzHsUTztK7h+9PJMT4CjgLrUBBfYuPIRWOhX4b946vwJ1UL2f0JTu7w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwUcH-0008R0-Rn; Sat, 10 Aug 2019 18:53:17 +0200
Date:   Sat, 10 Aug 2019 18:53:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, sd@queasysnail.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com
Subject: Re: [PATCH net-next v2 8/9] net: phy: mscc: macsec initialization
Message-ID: <20190810165317.GB30120@lunn.ch>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-9-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808140600.21477-9-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The MACsec read and write functions are wrapped into two versions: one
> called during the init phase, and the other one later on. This is
> because the init functions in the Microsemi Ocelot PHY driver are called
> while the MDIO bus lock is taken.

Hi Antoine

It is nice you have wrapped it all up, but it is still messy. Sometime
in the future, we should maybe take another look at adding the concept
of initialisation of a package, before the initialization of the PHYs
in the package.

> +static u32 __vsc8584_macsec_phy_read(struct phy_device *phydev,
> +				     enum macsec_bank bank, u32 reg, bool init)
> +{
> +	u32 val, val_l = 0, val_h = 0;
> +	unsigned long deadline;
> +	int rc;
> +
> +	if (!init) {
> +		rc = phy_select_page(phydev, MSCC_PHY_PAGE_MACSEC);
> +		if (rc < 0)
> +			goto failed;
> +	} else {
> +		__phy_write_page(phydev, MSCC_PHY_PAGE_MACSEC);
> +	}

...

> +	if (!init) {
> +failed:
> +		phy_restore_page(phydev, rc, rc);
> +	} else {
> +		__phy_write_page(phydev, MSCC_PHY_PAGE_STANDARD);
> +	}

Having the failed label inside the if is correct, but i think it is
potentially dangerous for future modifications to this function. I
would move the label before the if. I doubt it makes any difference to
the generated code, but it might prevent future bugs.

    Andrew
