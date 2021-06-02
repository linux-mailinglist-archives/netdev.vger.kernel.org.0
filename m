Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C22398C98
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 16:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhFBOWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 10:22:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:3985 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230157AbhFBOW0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 10:22:26 -0400
IronPort-SDR: 4Vr7qy238QQUW09T87soU7w3XQMUoitvMKyZalyWGtUtVuXUDTlsJtRvOMbGL8CIhPNpRjWStB
 Ln4NYfDlI9Ig==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="200784826"
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="200784826"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 07:16:02 -0700
IronPort-SDR: aHAs0+fBta5wp3xZPCApw//O0ERV7T4s98G9KA4Eo5w9XV8CrBX2mfwwvwsTa3vEkp8Z5mnWyt
 opZOX9WQ73lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="483055015"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 02 Jun 2021 07:16:02 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 823265807D4;
        Wed,  2 Jun 2021 07:16:00 -0700 (PDT)
Date:   Wed, 2 Jun 2021 22:15:57 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Message-ID: <20210602141557.GA29554@linux.intel.com>
References: <20210525055803.22116-1-vee.khee.wong@linux.intel.com>
 <YKz86iMwoP3VT4uh@lunn.ch>
 <20210601104734.GA18984@linux.intel.com>
 <YLYwcx3aHXFu4n5C@lunn.ch>
 <20210601154423.GA27463@linux.intel.com>
 <YLazBrpXbpsb6aXI@lunn.ch>
 <20210601230352.GA28209@linux.intel.com>
 <YLbqv0Sy/3E2XaVU@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLbqv0Sy/3E2XaVU@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 04:19:43AM +0200, Andrew Lunn wrote:
> > Yeah, you're right. Thanks for pointing that out. It should be:
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 1539ea021ac0..73bfde770f2d 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -862,11 +862,22 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
> >         c45_ids.mmds_present = 0;
> >         memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
> > 
> > -       if (is_c45)
> > +       if (is_c45) {
> >                 r = get_phy_c45_ids(bus, addr, &c45_ids);
> > -       else
> > +       } else {
> >                 r = get_phy_c22_id(bus, addr, &phy_id);
> > 
> > +               if (phy_id == 0) {
> > +                       r = get_phy_c45_ids(bus, addr, &c45_ids);
> > +                       if (r == -ENOTSUPP || r == -ENODEV)
> > +                               return phy_device_create(bus, addr, phy_id,
> > +                                                        false, &c45_ids);
> > +                       else
> > +                               return phy_device_create(bus, addr, phy_id,
> > +                                                        true, &c45_ids);
> 
> Still not correct. Think about when get_phy_c22_id() returns an
> error. Walk through all the different code paths and check they do the
> right thing. It is actually a lot more complex than what is shown
> here. Think about all the different types of PHYs and all the
> different types of MDIO bus drivers.
>

I took a look at how most ethernet drivers implement their "bus->read"
function. Most of them either return -EIO or -ENODEV.

I think it safe to drop the return error type when we try with C45 access:


diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1539ea021ac0..282d16fdf6e1 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -870,6 +870,18 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
        if (r)
                return ERR_PTR(r);

+       /* PHY device such as the Marvell Alaska 88E2110 will return a PHY ID
+        * of 0 when probed using get_phy_c22_id() with no error. Proceed to
+        * probe with C45 to see if we're able to get a valid PHY ID in the C45
+        * space, if successful, create the C45 PHY device.
+        */
+       if ((!is_c45) && (phy_id == 0)) {
+               r = get_phy_c45_ids(bus, addr, &c45_ids);
+               if (!r)
+                       return phy_device_create(bus, addr, phy_id,
+                                                true, &c45_ids);
+       }
+
        return phy_device_create(bus, addr, phy_id, is_c45, &c45_ids);
 }
 EXPORT_SYMBOL(get_phy_device);

With this implementation, it should have handled all four scenarios listed
in the table below:

    *------------------*------------*------------*
    | get_phy_c22_id() |  phy_id==0 |   Handled  |
    |   return error   |            |            |
    *------------------*------------*------------*
    |     false        |    false   |   true     |
    *------------------*------------*------------*
    |     false        |    true    |   true     |
    *------------------*------------*------------*
    |     true         |    false   |   true     |
    *------------------*------------*------------*
    |     true         |    true    |   true     |
    *------------------*------------*------------*


VK
