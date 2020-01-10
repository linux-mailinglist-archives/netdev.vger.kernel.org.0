Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDEB113709E
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgAJPEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:04:23 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42988 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbgAJPEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:04:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jjERH6EF+vGNb/gBcK7mgafQz0TotdzBsMTiLW052cc=; b=WOejmtiVTJSE0HzYiMZKn6F2A
        1Z2BcNreFtSqsXMn81s223CZY9avMYgTg1pzfei97VbNSU6Ucy/xbO4mDphST6jbBaPotiYgVuLV4
        18wBxI13+L3AjbbWCh5nBT9RAZh+TPma7SuQ62t6UKvJIiIB/DiL1OL9wsN803fzhX1hfdyRdvCU6
        92T6KM52/xaJ68LHluVjgTnR+xD+CxLBoRnZjERIneUbQdy4AsTvTw/OXn+TcbqcIv8mo3H6LqWiX
        G2rJzKdBXUlTUnqyEX2kJ7u58iBN9caOPi+dXrMJ7N8EfwTHJOajc7vX0zeSpGbOVLt33D00TltnL
        Mrz1zHgYg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:53132)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipvpb-0003kp-Iz; Fri, 10 Jan 2020 15:04:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipvpZ-0001ap-9c; Fri, 10 Jan 2020 15:04:09 +0000
Date:   Fri, 10 Jan 2020 15:04:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/14] net: axienet: Fix SGMII support
Message-ID: <20200110150409.GD25745@shell.armlinux.org.uk>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-8-andre.przywara@arm.com>
 <20200110140415.GE19739@lunn.ch>
 <20200110142038.2ed094ba@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110142038.2ed094ba@donnerap.cambridge.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 02:20:38PM +0000, Andre Przywara wrote:
> On Fri, 10 Jan 2020 15:04:15 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> Hi Andrew,
> 
> > On Fri, Jan 10, 2020 at 11:54:08AM +0000, Andre Przywara wrote:
> > > With SGMII, the MAC and the PHY can negotiate the link speed between
> > > themselves, without the host needing to mediate between them.
> > > Linux recognises this, and will call phylink's mac_config with the speed
> > > member set to SPEED_UNKNOWN (-1).
> > > Currently the axienet driver will bail out and complain about an
> > > unsupported link speed.
> > > 
> > > Teach axienet's mac_config callback to leave the MAC's speed setting
> > > alone if the requested speed is SPEED_UNKNOWN.  
> > 
> > Hi Andre
> > 
> > Is there an interrupt when SGMII signals a change in link state? If
> > so, you should call phylink_mac_change().
> 
> Good point. The doc describes a "Auto-Negotiation Complete" interrupt
> status bit, which signal that " ... auto-negotiation of the SGMII or
> 1000BASE-X interface has completed."

It depends what they mean by "Auto-negotiation complete" in SGMII.
SGMII can complete the handshake, yet the config_reg word indicate
link down.  If such an update causes an "Auto-negotiation complete"
interrupt, then that's sufficient.

However, looking at axienet_mac_pcs_get_state(), that is just reading
back what the MAC was set to in axienet_mac_config(), which is not
how this is supposed to work.  axienet_mac_pcs_get_state() is
supposed to get the results of the SGMII/1000BASE-X "negotiation".
That also needs to be fixed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
