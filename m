Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E396DD602
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 10:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjDKI4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 04:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjDKI4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 04:56:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA64E7E
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 01:56:30 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pm9ng-0000fG-7J; Tue, 11 Apr 2023 10:56:28 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pm9ne-0003f9-K8; Tue, 11 Apr 2023 10:56:26 +0200
Date:   Tue, 11 Apr 2023 10:56:26 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: FWD: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: Make
 flow control, speed, and duplex on CPU port configurable
Message-ID: <20230411085626.GA19711@pengutronix.de>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 06:44:20PM +0100, Russell King (Oracle) wrote:
> On Fri, Apr 07, 2023 at 04:25:57PM +0200, Andrew Lunn wrote:
> > > +void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
> > > +			      unsigned int mode, phy_interface_t interface,
> > > +			      struct phy_device *phydev, int speed, int duplex,
> > > +			      bool tx_pause, bool rx_pause)
> > > +{
> > > +	struct dsa_switch *ds = dev->ds;
> > > +	struct ksz_port *p;
> > > +	u8 ctrl = 0;
> > > +
> > > +	p = &dev->ports[port];
> > > +
> > > +	if (dsa_upstream_port(ds, port)) {
> > > +		u8 mask = SW_HALF_DUPLEX_FLOW_CTRL | SW_HALF_DUPLEX |
> > > +			SW_FLOW_CTRL | SW_10_MBIT;
> > > +
> > > +		if (duplex) {
> > > +			if (tx_pause && rx_pause)
> > > +				ctrl |= SW_FLOW_CTRL;
> > > +		} else {
> > > +			ctrl |= SW_HALF_DUPLEX;
> > > +			if (tx_pause && rx_pause)
> > > +				ctrl |= SW_HALF_DUPLEX_FLOW_CTRL;
> > > +		}
> > > +
> > > +		if (speed == SPEED_10)
> > > +			ctrl |= SW_10_MBIT;
> > > +
> > > +		ksz_rmw8(dev, REG_SW_CTRL_4, mask, ctrl);
> > > +
> > > +		p->phydev.speed = speed;
> > > +	} else {
> > > +		const u16 *regs = dev->info->regs;
> > > +
> > > +		if (duplex) {
> > > +			if (tx_pause && rx_pause)
> > > +				ctrl |= PORT_FORCE_FLOW_CTRL;
> > > +		} else {
> > > +			if (tx_pause && rx_pause)
> > > +				ctrl |= PORT_BACK_PRESSURE;
> > > +		}
> > > +
> > > +		ksz_rmw8(dev, regs[P_STP_CTRL], PORT_FORCE_FLOW_CTRL |
> > > +			 PORT_BACK_PRESSURE, ctrl);
> 
> So, I guess the idea here is to enable some form of flow control when
> both tx and rx pause are enabled.
> 
> Here's a bunch of questions I would like answered before I give a tag:
> 
> 1) It looks like the device only supports symmetric pause?

This part of driver supports two family of switches: ksz88xx and
ksz87xx.

According to KSZ8765CLX  datasheet:
Per port, we control pause rx and tx with one bit:
  Register 18 (0x12): Port 1 Control 2
  Bit 4 - Force Flow Control
    1 = Enables Rx and Tx flow control on the port, regardless of the AN result.
    0 = Flow control is enabled based on the AN result (Default)

Globally, pause tx and/or rx can be disabled:

  Register 3 (0x03): Global Control 1
  Bit 5 - IEEE 802.3x Transmit Flow Control Disable
    0 = Enables transmit flow control based on AN result.
    1 = Will not enable transmit flow control regardless of the AN result.
  Bit 4 - IEEE 802.3x Receive Flow Control Disable
    0 = Enables receive flow control based on AN result.
    1 = Will not enable receive flow control regardless of the AN result.

So, it is possible to configure the entire switch in SYNC or ASYNC mode
only. Still not sure what role plays autoneg in this configuration:

  Register 55 (0x37): Port 3 Control 7 (only for ports 3 and 4)
  Bits 5 - 4 - Advertised_Flow_Control _Capability
    00 = No pause
    01 = Symmetric PAUSE
    10 = Asymmetric PAUSE
    11 = Both Symmetric PAUSE and Asymmetric

According to this bits, it is possible to announce both Symmetric
and Asymmetric PAUSE, but will the switch enable asymmetric mode
properly if link partner advertise asymmetric too?

Suddenly I do not have ksz87xx variants to test it.

> 2) If yes, are you *not* providing MAC_ASYM_PAUSE in the MAC
>    capabilities? If not, why not?

Current code looks as follow:

  1402 void ksz8_get_caps(struct ksz_device *dev, int port,                                                                           
  1403 ┊       ┊          struct phylink_config *config)                                                                              
  1404 {                                                                                                                              
  1405 ┊       config->mac_capabilities = MAC_10 | MAC_100;                                                                           
  1406 ┊                                                                                                                              
  1407 ┊       /* Silicon Errata Sheet (DS80000830A):                                                                                 
  1408 ┊        * "Port 1 does not respond to received flow control PAUSE frames"                                                     
  1409 ┊        * So, disable Pause support on "Port 1" (port == 0) for all ksz88x3                                                   
  1410 ┊        * switches.                                                                                                           
  1411 ┊        */                                                                                                                    
  1412 ┊       if (!ksz_is_ksz88x3(dev) || port)                                                                                      
  1413 ┊       ┊       config->mac_capabilities |= MAC_SYM_PAUSE;                                                                     
  1414 ┊                                                                                                                              
  1415 ┊       /* Asym pause is not supported on KSZ8863 and KSZ8873 */                                                               
  1416 ┊       if (!ksz_is_ksz88x3(dev))                                                                                              
  1417 ┊       ┊       config->mac_capabilities |= MAC_ASYM_PAUSE;                                                                    
  1418 } 

wich will set SYM support for all ksz87xx ports and all except of port == 0
on ksz87xx.

but SYM and ASYM modes depend on global switch configuration, so this
code is probably correct as long as global defaults are not changed. The
Autoneg based MAC_ASYM_PAUSE is still not clear for me.

> 3) If yes, then please do as others do and use tx_pause || rx_pause
>    here.

Hm... you are right.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
