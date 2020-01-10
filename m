Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9370137105
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgAJPWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:22:24 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43274 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbgAJPWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:22:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1E/aUdlk2arQ+SgSotrUtWIN6SqdTC20k5Cqzx8WCNs=; b=0JZtdRfljjz4qgkWuL0oGkzp0
        nq1qHKyhsYYJuXG4AIYrlcpNIYcxOfteqWB8MHTk2SU/q/wvIAWX2h7pQxs2s89p14SvKZq6z8xSf
        exp5CsuBFgJdAfM50miQir4F03FecXhau/sBHpCNiZoXZvHOJJHUDIiXdsvGn0aKRxEsy6+esF5Vb
        oGA9PQt23aQ5hu7e0dXzupaDtAL544Ej+Xbx5jDhb56uV6ijx6v41lrCap5gorWfPWJQTqaejk7s7
        l6NwSYmBR3vePezA8du+dP0bM0Yp1Vn6NKm2sTcXcg6wrYKOi+ujb1IOFaANmw3avL57ByAJuMrj3
        mXohN2q5Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60652)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipw78-0003rJ-Hz; Fri, 10 Jan 2020 15:22:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipw75-0001c2-SL; Fri, 10 Jan 2020 15:22:15 +0000
Date:   Fri, 10 Jan 2020 15:22:15 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Robert Hancock <hancock@sedsystems.ca>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/14] net: axienet: Fix SGMII support
Message-ID: <20200110152215.GF25745@shell.armlinux.org.uk>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-8-andre.przywara@arm.com>
 <20200110140415.GE19739@lunn.ch>
 <20200110142038.2ed094ba@donnerap.cambridge.arm.com>
 <20200110150409.GD25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110150409.GD25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 03:04:09PM +0000, Russell King - ARM Linux admin wrote:
> On Fri, Jan 10, 2020 at 02:20:38PM +0000, Andre Przywara wrote:
> > On Fri, 10 Jan 2020 15:04:15 +0100
> > Andrew Lunn <andrew@lunn.ch> wrote:
> > 
> > Hi Andrew,
> > 
> > > On Fri, Jan 10, 2020 at 11:54:08AM +0000, Andre Przywara wrote:
> > > > With SGMII, the MAC and the PHY can negotiate the link speed between
> > > > themselves, without the host needing to mediate between them.
> > > > Linux recognises this, and will call phylink's mac_config with the speed
> > > > member set to SPEED_UNKNOWN (-1).
> > > > Currently the axienet driver will bail out and complain about an
> > > > unsupported link speed.
> > > > 
> > > > Teach axienet's mac_config callback to leave the MAC's speed setting
> > > > alone if the requested speed is SPEED_UNKNOWN.  
> > > 
> > > Hi Andre
> > > 
> > > Is there an interrupt when SGMII signals a change in link state? If
> > > so, you should call phylink_mac_change().
> > 
> > Good point. The doc describes a "Auto-Negotiation Complete" interrupt
> > status bit, which signal that " ... auto-negotiation of the SGMII or
> > 1000BASE-X interface has completed."
> 
> It depends what they mean by "Auto-negotiation complete" in SGMII.
> SGMII can complete the handshake, yet the config_reg word indicate
> link down.  If such an update causes an "Auto-negotiation complete"
> interrupt, then that's sufficient.
> 
> However, looking at axienet_mac_pcs_get_state(), that is just reading
> back what the MAC was set to in axienet_mac_config(), which is not
> how this is supposed to work.  axienet_mac_pcs_get_state() is
> supposed to get the results of the SGMII/1000BASE-X "negotiation".
> That also needs to be fixed.

I found "pg138-axi-ethernet.pdf" online, which I guess is this IP.
It says for SGMII:

The results of the SGMII auto-negotiation can be read from the SGMII
Management Auto-Negotiation Link Partner Ability Base register
(Table 2-54). The speed of the subsystem should then be set to match.

and similar for 1000BASE-X (referencing the same register.)

However, what they give in table 2-54 is the 1000BASE-X version of
the config_reg word, not the SGMII version (which is different.)

Hmm, I guess there's probably some scope for phylink to start
handling an IEEE 802.3 compliant PCS accessed over MDIO rather
than having each network driver implement this, but for now your
axienet_mac_pcs_get_state() implementation needs to be reading
from the register described in table 2-54 and interpreting the
results according to whether state->interface is 802.3z or not.

Also note, don't set state->interface in axienet_mac_pcs_get_state(),
you will be passed the currently selected interface that was last
configured via axienet_mac_config().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
