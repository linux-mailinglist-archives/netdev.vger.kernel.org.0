Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E033C4E6463
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350610AbiCXNuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350642AbiCXNuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:50:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFB1101E
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:48:32 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nXNpC-0002Pq-36; Thu, 24 Mar 2022 14:48:26 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nXNpA-0004wC-NB; Thu, 24 Mar 2022 14:48:24 +0100
Date:   Thu, 24 Mar 2022 14:48:24 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: sja1105q: proper way to solve PHY clk dependecy
Message-ID: <20220324134824.GG4519@pengutronix.de>
References: <20220323060331.GA4519@pengutronix.de>
 <20220323095240.y4xnp6ivz57obyvv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220323095240.y4xnp6ivz57obyvv@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:36:12 up 103 days, 22:21, 79 users,  load average: 0.30, 0.23,
 0.26
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vladimir,

thank you for your response!

On Wed, Mar 23, 2022 at 11:52:40AM +0200, Vladimir Oltean wrote:
> Hello Oleksij,
> 
> On Wed, Mar 23, 2022 at 07:03:31AM +0100, Oleksij Rempel wrote:
> > Hi Vladimir,
> > 
> > I have SJA1105Q based switch with 3 T1L PHYs connected over RMII
> > interface. The clk input "XI" of PHYs is connected to "MII0_TX_CLK/REF_CLK/TXC"
> > pins of the switch. Since this PHYs can't be configured reliably over MDIO
> > interface without running clk on XI input, i have a dependency dilemma:
> > i can't probe MDIO bus, without enabling DSA ports.
> > 
> > If I see it correctly, following steps should be done:
> > - register MDIO bus without scanning for PHYs
> > - define SJA1105Q switch as clock provider and PHYs as clk consumer
> > - detect and attach PHYs on port enable if clks can't be controlled
> >   without enabling the port.
> > - HW reset line of the PHYs should be asserted if we disable port and
> >   deasserted with proper reinit after port is enabled.
> > 
> > Other way would be to init and enable switch ports and PHYs by a bootloader and
> > keep it enabled.
> > 
> > What is the proper way to go?

> The facts, as I see them, are as follows, feel free to debate them.
> 
> 1. Scanning the bus is not the problem, but PHY probing is.
> 
> If the MDIO bus is registered with of_mdiobus_register() - which is to
> be expected, since the sja1105 driver only connects to a PHY using a
> phy-handle - that should set mdio->phy_mask = ~0; which should disable
> PHY scanning.
> 
> But of_mdiobus_register() will still call of_mdiobus_register_phy()
> which will probe the phy_device. Here, depending on the code path,
> _some_ PHY reads might be performed - which will return an error if the
> PHY is missing its clock. For example, if the PHY ID isn't part of the
> compatible string, fwnode_mdiobus_register_phy() will attempt to read it
> from the PHY via get_phy_device(). Alternatively, you could put the PHY
> ID in the DT and this will end up calling phy_device_create().
> 
> Then there's the probe() method of the T1L PHY driver, which is the
> reason why it would be good to know what that driver is. Since its clock
> might not be available, I expect that this driver doesn't access
> hardware from probe(), knowing that it is an RMII PHY driver and this is
> a generic problem for RMII PHYs.

ack. describing DT with compatible PHYid seems to be good enough.

> 2. The sja1105 driver already does all it reasonably can to make the
>    RMII PHY happy.
> 
> The clocks of a port are enabled/configured from sja1105_clocking_setup_port()
> which has 3 call paths:
> (a) during sja1105_setup(), aka during switch initialization, all ports
>     except RGMII ports have their clocks configured and enabled, via
>     priv->info->clocking_setup(). The RGMII ports have a clock that
>     depends upon the link speed, and we don't know the link speed.
> (b) during sja1105_static_config_reload(). The sja1105 switch needs to
>     dynamically reset itself at runtime, and this cuts off the clocks
>     for a while. Again there is a call to priv->info->clocking_setup()
>     here.
> (c) during phylink_mac_link_up -> sja1105_adjust_port_config(), a call
>     is made to sja1105_clocking_setup_port() for RGMII PHYs, because the
>     speed is now known.
> 
> Since DSA calls dsa_slave_phy_setup() _after_ dsa_switch_setup(), this
> means that by the time the PHY is attached, its config_init() runs, etc,
> the RMII clock configured by sja1105_setup() should be running.

ack. it works.

> 3. Clock gating the PHY won't make it lose its settings.
> 
> I expect that during the time when the sja1105 switch needs to reset,
> the PHY just sees this as a few hundreds of ms during which there are no
> clock edges on the crystal input pin. Sure, the PHY won't do anything
> during that time, but this is quite different from a reset, is it not?
> So asserting the hardware reset line of the PHY during the momentary
> loss of clock, which is what you seem to suggest, will actively do more
> harm than good.

can i be sure that MDIO access happens in the period where PHY is
supplied with stable clk

> 4. Making the sja1105 driver a clock provider doesn't solve the problem
>    in the general sense.
> 
> If you make this PHY driver expect the MAC to be a clock provider,
> are you going to expect that all RMII-capable MAC drivers be patched?
> For this reason I am in principle opposed to making the sja1105 driver
> a clock provider, you won't be able to generalize this solution and it
> would just create a huge mess going forward.

I can imagine optional clk support, but right now i do not have any
stability issues so no need to spend time on it right now.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
