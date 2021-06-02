Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A61399681
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 01:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFBXxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 19:53:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:60626 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhFBXxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 19:53:50 -0400
IronPort-SDR: rrdXNixNrh9oQSmaetRhUJwdWUasFBpvmaSskMTvSzwaQ12xDB2AfzrBWk5xUilhcaR5MNrR+d
 E544s8n+mnDg==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="184295521"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="184295521"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 16:52:01 -0700
IronPort-SDR: 26E395JD8qkArSHyUz0RYqGDvOIy/KSiePLDthD3zpFT+RW3QGF1xcmxedV0sAWWDviNLkOpSA
 cMygN36mDqYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="636047685"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jun 2021 16:51:59 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 3A07558093D;
        Wed,  2 Jun 2021 16:51:58 -0700 (PDT)
Date:   Thu, 3 Jun 2021 07:51:55 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Message-ID: <20210602235155.GA31624@linux.intel.com>
References: <20210525055803.22116-1-vee.khee.wong@linux.intel.com>
 <YKz86iMwoP3VT4uh@lunn.ch>
 <20210601104734.GA18984@linux.intel.com>
 <YLYwcx3aHXFu4n5C@lunn.ch>
 <20210601154423.GA27463@linux.intel.com>
 <YLazBrpXbpsb6aXI@lunn.ch>
 <20210601230352.GA28209@linux.intel.com>
 <YLbqv0Sy/3E2XaVU@lunn.ch>
 <20210602141557.GA29554@linux.intel.com>
 <YLed2G1iDRTbA9eT@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLed2G1iDRTbA9eT@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 05:03:52PM +0200, Andrew Lunn wrote:
> > I took a look at how most ethernet drivers implement their "bus->read"
> > function. Most of them either return -EIO or -ENODEV.
> > 
> > I think it safe to drop the return error type when we try with C45 access:
> > 
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 1539ea021ac0..282d16fdf6e1 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -870,6 +870,18 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
> >         if (r)
> >                 return ERR_PTR(r);
> > 
> > +       /* PHY device such as the Marvell Alaska 88E2110 will return a PHY ID
> > +        * of 0 when probed using get_phy_c22_id() with no error. Proceed to
> > +        * probe with C45 to see if we're able to get a valid PHY ID in the C45
> > +        * space, if successful, create the C45 PHY device.
> > +        */
> > +       if ((!is_c45) && (phy_id == 0)) {
> > +               r = get_phy_c45_ids(bus, addr, &c45_ids);
> > +               if (!r)
> > +                       return phy_device_create(bus, addr, phy_id,
> > +                                                true, &c45_ids);
> > +       }
> 
> This is getting better. But look at for example
> drivers/net/mdio/mdio-bcm-unimac.c. What will happen when you ask it
> to do get_phy_c45_ids()?
>

I will add an additional check for bus->probe_capabilities. This will ensure
that only a MDIO bus that is capable for C45 access will go for the 'try getting
PHY ID from C45 space' approach. Currently, only Freescale's QorIQ 10G MDIO
Controller driver and STMMAC driver has a bus->probe_capabilities of > MDIOBUS_C45.
So, I would say with this additional checking, it would not break most of the drivers:-


diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1539ea021ac0..460c0866ac84 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -870,6 +870,19 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
        if (r)
                return ERR_PTR(r);

+       /* PHY device such as the Marvell Alaska 88E2110 will return a PHY ID
+        * of 0 when probed using get_phy_c22_id() with no error. Proceed to
+        * probe with C45 to see if we're able to get a valid PHY ID in the C45
+        * space, if successful, create the C45 PHY device.
+        */
+       if ((!is_c45) && (phy_id == 0) &&
+            (bus->probe_capabilities >= MDIOBUS_C45)) {
+               r = get_phy_c45_ids(bus, addr, &c45_ids);
+               if (!r)
+                       return phy_device_create(bus, addr, phy_id,
+                                                true, &c45_ids);
+       }
+
        return phy_device_create(bus, addr, phy_id, is_c45, &c45_ids);
 }
 EXPORT_SYMBOL(get_phy_device);

  VK
