Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242612930ED
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387837AbgJSWEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:04:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387809AbgJSWEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 18:04:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUdGk-002YwK-SM; Tue, 20 Oct 2020 00:04:42 +0200
Date:   Tue, 20 Oct 2020 00:04:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH] net: axienet: Properly handle PCS/PMA PHY for 1000BaseX
 mode
Message-ID: <20201019220442.GA139700@lunn.ch>
References: <20201019203923.467065-1-robert.hancock@calian.com>
 <20201019213638.GW139700@lunn.ch>
 <c989910aee122cfa9d29994d9ce650ce486442ca.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c989910aee122cfa9d29994d9ce650ce486442ca.camel@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Robert
> > 
> > That looks like a layering violation. Maybe move this into
> > phylink_mii_c22_pcs_config(), it is accessing MII_BMCR anyway.
> 
> Could do - do we think there's any harm in just disabling BMCR_ISOLATE
> in all cases in that function?

We have something similar in phylib:

/**
 * genphy_restart_aneg - Enable and Restart Autonegotiation
 * @phydev: target phy_device struct
 */
int genphy_restart_aneg(struct phy_device *phydev)
{
        /* Don't isolate the PHY if we're negotiating */
        return phy_modify(phydev, MII_BMCR, BMCR_ISOLATE,
                          BMCR_ANENABLE | BMCR_ANRESTART);
}

so i think it would also be safe in PCS code.

   Andrew
