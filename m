Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3903B3976FC
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 17:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhFAPqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 11:46:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:44635 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhFAPqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 11:46:11 -0400
IronPort-SDR: +LdanXLyBV0M634CK3ruon9CcWonwHEsEMaxUmt2gIr5WNfO4KkeX69VMnpbA34c9KX2dZCEve
 jHfNDKdU0riw==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="201705055"
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="201705055"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 08:44:28 -0700
IronPort-SDR: Ac9R8PJ/NqQS8OH/ildLDNP7C4I5V6l3U+4HjeNQxJAiOS6yBeq/CavRQNQM9pYlrppWW9/Lzu
 j4c/0UpTLYqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="616863631"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 01 Jun 2021 08:44:28 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id A7A67580039;
        Tue,  1 Jun 2021 08:44:26 -0700 (PDT)
Date:   Tue, 1 Jun 2021 23:44:23 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Message-ID: <20210601154423.GA27463@linux.intel.com>
References: <20210525055803.22116-1-vee.khee.wong@linux.intel.com>
 <YKz86iMwoP3VT4uh@lunn.ch>
 <20210601104734.GA18984@linux.intel.com>
 <YLYwcx3aHXFu4n5C@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLYwcx3aHXFu4n5C@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 03:04:51PM +0200, Andrew Lunn wrote:
> On Tue, Jun 01, 2021 at 06:47:34PM +0800, Wong Vee Khee wrote:
> > On Tue, May 25, 2021 at 03:34:34PM +0200, Andrew Lunn wrote:
> > > On Tue, May 25, 2021 at 01:58:03PM +0800, Wong Vee Khee wrote:
> > > > Synopsys MAC controller is capable of pairing with external PHY devices
> > > > that accessible via Clause-22 and Clause-45.
> > > > 
> > > > There is a problem when it is paired with Marvell 88E2110 which returns
> > > > PHY ID of 0 using get_phy_c22_id(). We can add this check in that
> > > > function, but this will break swphy, as swphy_reg_reg() return 0. [1]
> > > 
> > > Is it possible to identify it is a Marvell PHY? Do any of the other
> > > C22 registers return anything unique? I'm wondering if adding
> > > .match_phy_device to genphy would work to identify it is a Marvell PHY
> > > and not bind to it. Or we can turn it around, make the
> > > .match_phy_device specifically look for the fixed-link device by
> > > putting a magic number in one of the vendor registers.
> > >
> > 
> > I checked the Marvell and did not see any unique register values.
> > Also, since get_phy_c22_id() returns a *phy_id== 0, it is not bind to
> > any PHY driver, so I don't think adding the match_phy_device check in
> > getphy would help.
> 
> It has a Marvell ID in C45 space. So maybe we need to special case for
> ID 0. If we get that, go look in C45 space. If we find a valid ID, use
> it. If we get EOPNOTSUP because the MDIO bus is not C45 capable, or we
> don't find a vendor ID in C45 space, keep with id == 0 and load
> genphy?
>

Make sense for me.
Let me what you think of adding the checks in *get_phy_device():

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1539ea021ac0..ad9a87fadea1 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -862,11 +862,21 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
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
+                               return 0;
+                       else
+                               return phy_device_create(bus, addr, phy_id,
+                                                        true, &c45_ids);
+               }
+       }
+
        if (r)
                return ERR_PTR(r);


> The other option is consider the PHY broken, and require that you put
> the correct ID in DT as the compatible string. The correct driver will
> then be loaded, based on the compatible string, rather than what is
> found by probing.

Unfortunately all Intel platforms (ElkhartLake/TigerLake/AlderLake) are non-DT.


VK

