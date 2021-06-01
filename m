Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3979397CDB
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 01:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbhFAXFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 19:05:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:38122 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234908AbhFAXFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 19:05:39 -0400
IronPort-SDR: bSPBSWZjksIxP1txXYdPclQxXlK2Fn/6MmpetIXaWGqpZtU8Srh5PFfTG80ft+PKLh5YaJp8xc
 6oBfRvcjKRMQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="191011336"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="191011336"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 16:03:56 -0700
IronPort-SDR: XBQWXc7bQbgv8uw7l1BlQaQYeQ2NDjE4A97ZCWU6k5ZfV9MPixsvcbIxzwOBvljgNQdZBV0YW5
 nEJhSUOP0V7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="416642380"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP; 01 Jun 2021 16:03:56 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 40BEA5805EE;
        Tue,  1 Jun 2021 16:03:55 -0700 (PDT)
Date:   Wed, 2 Jun 2021 07:03:52 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Message-ID: <20210601230352.GA28209@linux.intel.com>
References: <20210525055803.22116-1-vee.khee.wong@linux.intel.com>
 <YKz86iMwoP3VT4uh@lunn.ch>
 <20210601104734.GA18984@linux.intel.com>
 <YLYwcx3aHXFu4n5C@lunn.ch>
 <20210601154423.GA27463@linux.intel.com>
 <YLazBrpXbpsb6aXI@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLazBrpXbpsb6aXI@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 12:21:58AM +0200, Andrew Lunn wrote:
> On Tue, Jun 01, 2021 at 11:44:23PM +0800, Wong Vee Khee wrote:
> > On Tue, Jun 01, 2021 at 03:04:51PM +0200, Andrew Lunn wrote:
> > > On Tue, Jun 01, 2021 at 06:47:34PM +0800, Wong Vee Khee wrote:
> > > > On Tue, May 25, 2021 at 03:34:34PM +0200, Andrew Lunn wrote:
> > > > > On Tue, May 25, 2021 at 01:58:03PM +0800, Wong Vee Khee wrote:
> > > > > > Synopsys MAC controller is capable of pairing with external PHY devices
> > > > > > that accessible via Clause-22 and Clause-45.
> > > > > > 
> > > > > > There is a problem when it is paired with Marvell 88E2110 which returns
> > > > > > PHY ID of 0 using get_phy_c22_id(). We can add this check in that
> > > > > > function, but this will break swphy, as swphy_reg_reg() return 0. [1]
> > > > > 
> > > > > Is it possible to identify it is a Marvell PHY? Do any of the other
> > > > > C22 registers return anything unique? I'm wondering if adding
> > > > > .match_phy_device to genphy would work to identify it is a Marvell PHY
> > > > > and not bind to it. Or we can turn it around, make the
> > > > > .match_phy_device specifically look for the fixed-link device by
> > > > > putting a magic number in one of the vendor registers.
> > > > >
> > > > 
> > > > I checked the Marvell and did not see any unique register values.
> > > > Also, since get_phy_c22_id() returns a *phy_id== 0, it is not bind to
> > > > any PHY driver, so I don't think adding the match_phy_device check in
> > > > getphy would help.
> > > 
> > > It has a Marvell ID in C45 space. So maybe we need to special case for
> > > ID 0. If we get that, go look in C45 space. If we find a valid ID, use
> > > it. If we get EOPNOTSUP because the MDIO bus is not C45 capable, or we
> > > don't find a vendor ID in C45 space, keep with id == 0 and load
> > > genphy?
> > >
> > 
> > Make sense for me.
> > Let me what you think of adding the checks in *get_phy_device():
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 1539ea021ac0..ad9a87fadea1 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -862,11 +862,21 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
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
> > +                               return 0;
> 
> This bit is not correct. I said 'or we don't find a vendor ID in C45
> space, keep with id == 0'. We need to keep backwards compatibility. If
> get_phy_c22_id() did not return an error we should create a device
> with phy_id 0, if get_phy_c45_ids() returns an error.
>

Yeah, you're right. Thanks for pointing that out. It should be:

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1539ea021ac0..73bfde770f2d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -862,11 +862,22 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
        c45_ids.mmds_present = 0;
        memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));

-       if (is_c45)
+       if (is_c45) {
                r = get_phy_c45_ids(bus, addr, &c45_ids);
-       else
+       } else {
                r = get_phy_c22_id(bus, addr, &phy_id);

+               if (phy_id == 0) {
+                       r = get_phy_c45_ids(bus, addr, &c45_ids);
+                       if (r == -ENOTSUPP || r == -ENODEV)
+                               return phy_device_create(bus, addr, phy_id,
+                                                        false, &c45_ids);
+                       else
+                               return phy_device_create(bus, addr, phy_id,
+                                                        true, &c45_ids);
+               }
+       }
+
        if (r)
                return ERR_PTR(r);


VK 
