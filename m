Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A3F1CB6CA
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgEHSNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:13:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49760 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbgEHSNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 14:13:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wWNCGA+EwqVktP3Bvv8WPRuSGI2htUTB8ahmxkxy++o=; b=cnTTDe7IEMZQkOtb+qm05miDls
        qWpgdgwqMbp0QDQSa8AkoBwo0d0VM5xkLtPW4k6zxwQi6z8HB0tr28cuy0ZDKjRHX9EAa0FbYWmHj
        QWynS9sMpHL3874vkA6Ctk6HUGYbaoReKgS6pAqdqplDkHSybpgFsPJDClHsAzkBWUb0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jX7Ub-001P3h-KM; Fri, 08 May 2020 20:13:01 +0200
Date:   Fri, 8 May 2020 20:13:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20200508181301.GF298574@lunn.ch>
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-5-calvin.johnson@oss.nxp.com>
 <67e263cf-5cd7-98d1-56ff-ebd9ac2265b6@arm.com>
 <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
 <83ab4ca4-9c34-4cdd-4413-3b4cdf96727d@arm.com>
 <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > It does have a numeric version defined for EISA types. OTOH I suspect that
> > your right. If there were a "PHY\VEN_IDvvvv&ID_DDDD" definition, it may not
> > be ideal to parse it. Instead the normal ACPI model of exactly matching the
> > complete string in the phy driver might be more appropriate.
> 
> IMO, it should be fine to parse the string to extract the phy_id. Is there any
> reason why we cannot do this?

Some background here, about what the PHY core does.

PHYs have two ID registers. This contains vendor, device, and often
revision of the PHY. Only the vendor part is standardised, vendors can
decide how to use the device part, but it is common for the lowest
nibble to be revision. The core will read these ID registers, and then
go through all the PHY drivers registered and ask them if they support
this ID. The drivers provide a table of IDs and masks. The mask is
applied, and then if the ID matches, the driver is used. The mask
allows the revision to be ignored, etc.

There is a very small number of devices where the vendor messed up,
and did not put valid contents in the ID registers. In such cases, we
can read the IDs from device tree. These are then used in exactly the
same way as if they were read from the device.

If you want the ACPI model to be used, an exact match on the string,
you are going to have to modify the core and the drivers. They
currently don't have any string, and have no idea about different
revisions which are out in the wild.

> > Similarly to how I suspect the next patch's use of "compatible" isn't ideal
> > either, because whether a device is c45 or not, should tend to be fixed to a
> > particular vendor/device implementation and not a firmware provided
> > property.

Not exactly true. It is the combination of can the bus master do C45
and can the device do C45. Unfortunately, we have no knowledge of the
bus masters capabilities, if it can do C45. And many MDIO drivers will
do a C22 transaction when asked to perform a C45 transaction. All new
submissions for MDIO drivers i ask for EOPNOTSUPP to be returned if
C45 is not supported. But we cannot rely on that. Too much history.

> 
> I tend to agree with you on this. Even for DT, ideal case, IMO should be:
> 
> 1) mdiobus_scan scans the mdiobus for c22 devices by reading phy id from
> registers 2 and 3
> 2) if not found scan for c45 devices <= looks like this is missing in Linux
> 3) look for phy_id from compatible string.

It is somewhat more complex, in that there are a small number of
devices which will respond to both C22 and C45. Generally, you want to
use C45 if supported. So you would want to do the C45 scan first. But
then the earlier problem comes to play, you have no idea if the bus
master actually correctly supports C45.

Given the issues, we assume all bus masters and PHY devices are C22
unless DT says the bus master and PHY combination is compatible with
C45.

	   Andrew
