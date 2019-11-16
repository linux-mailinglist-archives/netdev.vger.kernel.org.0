Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9323FF5D3
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfKPVky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:40:54 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38090 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfKPVkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:40:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aY+xaRtFx06NQX0uCEmKZdmMCb4OTBihel8VoHJ7XfE=; b=cJzhIt1KFQnyTPklH0c5Lmt+o
        mgFnh21ja46czC7rrAcXe7Huu2XE++ZeUCggSoRTa2dm3ZqAznPuaORc2Q82CpLoom5yLgkElaJmW
        M5nl3i8pBn+3FxC4iKfc315EfwE6F7/6tKgU9IO5GsH11jbZn/DDtEhkEePZn5sDiCRDoOL5DF0I+
        HM8sYrxm2nqsqDCenhcPBxSB21WgtyfpwCraz+Eao4JPN0aigD3M5BjAyjrrxq+Wls1Vn5y8S6U9p
        bjzBYi4Mk+3LB4vO3McPyvXHXNL9rJj+Ys5qE8EZMEej0LTX/UUQtPhZKqxKVKx9LAxSskf1VKIkE
        4bhMneblg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:36408)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iW5oD-0001Oo-LJ; Sat, 16 Nov 2019 21:40:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iW5oA-0005nf-Im; Sat, 16 Nov 2019 21:40:42 +0000
Date:   Sat, 16 Nov 2019 21:40:42 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: add SFP+ support
Message-ID: <20191116214042.GU25745@shell.armlinux.org.uk>
References: <20191115195339.GR25745@shell.armlinux.org.uk>
 <E1iVhiC-0007bG-Cm@rmk-PC.armlinux.org.uk>
 <20191116160635.GB5653@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116160635.GB5653@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 16, 2019 at 05:06:35PM +0100, Andrew Lunn wrote:
> > +static int mv3310_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
> > +{
> > +	struct phy_device *phydev = upstream;
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
> > +	phy_interface_t iface;
> > +
> > +	sfp_parse_support(phydev->sfp_bus, id, support);
> > +	iface = sfp_select_interface(phydev->sfp_bus, id, support);
> > +
> > +	if (iface != PHY_INTERFACE_MODE_10GKR) {
> > +		dev_err(&phydev->mdio.dev, "incompatible SFP module inserted\n");
> > +		return -EINVAL;
> > +	}
> 
> Hi Russell
> 
> Is it possible to put an SFP module into an SFP+ cage?
> sfp_select_interface() would then say 1000Base-X or 2500Base-X. The
> SFP+ cage has a single SERDES pair, so electrically, would it be
> possible to do 1000Base-X? Should mv3310_sfp_insert() be reconfiguring
> the PHY so the SFP side swaps to 1000Base-X?

The answer is... it depends.

Some SFP+ cages have stronger pull-ups and run the I2C bus at 400kHz.
SFP modules limit the pullups to 4.7k minimum and a bus speed of
100kHz.

Some SFP modules will stand the faster bus speed and the stronger
pull-ups.  Others will not.  Others may end up with EEPROM corruption.

It is possible to reconfigure the 3310 to 1000base-X (I don't think
2500base-X is possible on the fiber port) but it requires a PHY reset.
I have code to do it, but I haven't tested it - as the pullups on the
board I have to test with are too strong to allow the EEPROM in SFP
modules to be read.

If I get around to replacing the resistor packs, then I can test it,
but I'm not going to contribute completely untested code!

So, this patch reflects what can be done with the SFP+ slots on
Macchiatobin boards today.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
