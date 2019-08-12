Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B4B8987B
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 10:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfHLIM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 04:12:29 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39593 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfHLIM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 04:12:29 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id F3092E000A;
        Mon, 12 Aug 2019 08:12:25 +0000 (UTC)
Date:   Mon, 12 Aug 2019 10:12:25 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        sd@queasysnail.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com
Subject: Re: [PATCH net-next v2 8/9] net: phy: mscc: macsec initialization
Message-ID: <20190812081225.GC3698@kwain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-9-antoine.tenart@bootlin.com>
 <20190810165317.GB30120@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190810165317.GB30120@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sat, Aug 10, 2019 at 06:53:17PM +0200, Andrew Lunn wrote:
> > The MACsec read and write functions are wrapped into two versions: one
> > called during the init phase, and the other one later on. This is
> > because the init functions in the Microsemi Ocelot PHY driver are called
> > while the MDIO bus lock is taken.
> 
> It is nice you have wrapped it all up, but it is still messy. Sometime
> in the future, we should maybe take another look at adding the concept
> of initialisation of a package, before the initialization of the PHYs
> in the package.

I agree, it's still a hack to have those read/write functions acting
differently based on an 'init' flag.

> > +static u32 __vsc8584_macsec_phy_read(struct phy_device *phydev,
> > +				     enum macsec_bank bank, u32 reg, bool init)
> > +{
> > +	u32 val, val_l = 0, val_h = 0;
> > +	unsigned long deadline;
> > +	int rc;
> > +
> > +	if (!init) {
> > +		rc = phy_select_page(phydev, MSCC_PHY_PAGE_MACSEC);
> > +		if (rc < 0)
> > +			goto failed;
> > +	} else {
> > +		__phy_write_page(phydev, MSCC_PHY_PAGE_MACSEC);
> > +	}
> 
> ...
> 
> > +	if (!init) {
> > +failed:
> > +		phy_restore_page(phydev, rc, rc);
> > +	} else {
> > +		__phy_write_page(phydev, MSCC_PHY_PAGE_STANDARD);
> > +	}
> 
> Having the failed label inside the if is correct, but i think it is
> potentially dangerous for future modifications to this function. I
> would move the label before the if. I doubt it makes any difference to
> the generated code, but it might prevent future bugs.

Right, having readable code is always better. I'll fix that.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
