Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3513971D7
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 12:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbhFAKyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 06:54:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:5058 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232968AbhFAKyR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 06:54:17 -0400
IronPort-SDR: DutuKACw/5Xuuakq8wkfQr5NX8QIK9qqZknV+OFIpvTsirkpLZ6yTlTqsgVv9jvI0c1ggUlAsi
 +dNbOJW2JKTg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="203554826"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="203554826"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 03:52:35 -0700
IronPort-SDR: I3LNhnlxS59SiW7gRqhKiQNQORxLcyuTnYDKfBdDQGtXGnQvTpQ6hqGC5O/mdwurZHjRxDOxwe
 Veo+LoMzZmLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="482444245"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 01 Jun 2021 03:52:35 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 1213358090A;
        Tue,  1 Jun 2021 03:52:33 -0700 (PDT)
Date:   Tue, 1 Jun 2021 18:52:31 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 1/2] net: phy: allow mdio bus to probe for c45
 devices before c22
Message-ID: <20210601105231.GB18984@linux.intel.com>
References: <20210525055839.22496-1-vee.khee.wong@linux.intel.com>
 <20210525083117.GC30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525083117.GC30436@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 09:31:17AM +0100, Russell King (Oracle) wrote:
> On Tue, May 25, 2021 at 01:58:39PM +0800, Wong Vee Khee wrote:
> > Some MAC controllers that is able to pair with  external PHY devices
> > such as the Synopsys MAC Controller (STMMAC) support both Clause-22 and
> > Clause-45 access.
> > 
> > When paired with PHY devices that only accessible via Clause-45, such as
> > the Marvell 88E2110, any attempts to access the PHY devices via
> > Clause-22 will get a PHY ID of all zeroes.
> > 
> > To fix this, we introduce MDIOBUS_C45_C22 which the MAC controller will
> > try with Clause-45 access before going to Clause-22.
> > 
> > Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> > ---
> >  include/linux/phy.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 60d2b26026a2..9b0e2c76e19b 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -368,6 +368,7 @@ struct mii_bus {
> >  		MDIOBUS_C22,
> >  		MDIOBUS_C45,
> >  		MDIOBUS_C22_C45,
> > +		MDIOBUS_C45_C22,
> >  	} probe_capabilities;
> >  
> >  	/** @shared_lock: protect access to the shared element */
> 
> The new definition doesn't seem to be used anywhere, so this patch
> merely adds the definition. It doesn't do what it says in the subject
> line. Any driver that sets the capabilities to MDIOBUS_C45_C22 will
> end up not doing any probing of the PHY.
>

You are right. I left out the required changes in drivers/net/mdio_bus.c:-

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 6045ad3def12..fbf9b8f1f47c 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -684,6 +684,11 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
                if (IS_ERR(phydev))
                        phydev = get_phy_device(bus, addr, true);
                break;
+       case MDIOBUS_C45_C22:
+               phydev = get_phy_device(bus, addr, true);
+               if (IS_ERR(phydev))
+                       phydev = get_phy_device(bus, addr, false);
+               break;
        }

        if (IS_ERR(phydev))


VK 
