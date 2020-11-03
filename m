Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A2E2A4C92
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgKCRSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:18:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33000 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728681AbgKCRSp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 12:18:45 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZzx8-0053yJ-8m; Tue, 03 Nov 2020 18:18:38 +0100
Date:   Tue, 3 Nov 2020 18:18:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        robh@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
Message-ID: <20201103171838.GN1042051@lunn.ch>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-5-dmurphy@ti.com>
 <20201030201515.GE1042051@lunn.ch>
 <202b6626-b7bf-3159-f474-56f6fa0c8247@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202b6626-b7bf-3159-f474-56f6fa0c8247@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 11:07:00AM -0600, Dan Murphy wrote:
> Andrew
> 
> On 10/30/20 3:15 PM, Andrew Lunn wrote:
> > > +static int dp83td510_config_init(struct phy_device *phydev)
> > > +{
> > > +	struct dp83td510_private *dp83td510 = phydev->priv;
> > > +	int mst_slave_cfg;
> > > +	int ret = 0;
> > > +
> > > +	if (phy_interface_is_rgmii(phydev)) {
> > > +		if (dp83td510->rgmii_delay) {
> > > +			ret = phy_set_bits_mmd(phydev, DP83TD510_DEVADDR,
> > > +					       DP83TD510_MAC_CFG_1, dp83td510->rgmii_delay);
> > > +			if (ret)
> > > +				return ret;
> > > +		}
> > > +	}
> > Hi Dan
> > 
> > I'm getting a bit paranoid about RGMII delays...
> Not sure what this means.

See the discussion and breakage around the realtek PHY. It wrongly
implemented RGMII delays. When it was fixed, lots of board broke
because the bug in the PHY driver hid bugs in the DT.

> > Please don't use device_property_read_foo API, we don't want to give
> > the impression it is O.K. to stuff DT properties in ACPI
> > tables. Please use of_ API calls.
> 
> Hmm. Is this a new stance in DT handling for the networking tree?
> 
> If it is should I go back and rework some of my other drivers that use
> device_property APIs

There is a slowly growing understanding what ACPI support in this area
means. It seems to mean that the firmware should actually do all the
setup, and the kernel should not touch the hardware configuration. But
some developers are ignoring this, and just stuffing DT properties
into ACPI tables and letting the kernel configure the hardware, if it
happens to use the device_property_read API. So i want to make it
clear that these properties are for device tree, and if you want to
use ACPI, you should do things the ACPI way.

For new code, i will be pushing for OF only calls. Older code is a bit
more tricky. There might be boards out there using ACPI, but doing it
wrongly, and stuffing OF properties into ACPI tables. We should try to
avoid breaking them.

      Andrew
