Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6F811308C
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbfLDRNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:13:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37012 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbfLDRNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 12:13:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=19jGq9ml7fBDy7lGbD8F7DibQnWdufb9hbZfnnE8T3Q=; b=pqqZ5SDUB3oDrpBvLOkcb2LqN6
        1nHjJSw8/P1jIcxud8k4XXcSnJanTl7KrkXSeqn4FYEveBYVZYq0tzM/L+Q5G+RbYi9y8z1WiOQmf
        fvMA7rhB6HkULKn+7LMQSZ096OljVL6unIHGiat1bZoKf5ru3Mwu2D1P5qtc1V0Yye2k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1icYDY-00038X-1e; Wed, 04 Dec 2019 18:13:36 +0100
Date:   Wed, 4 Dec 2019 18:13:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?J=FCrgen?= Lambrecht <j.lambrecht@televic.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rasmus.villemoes@prevas.dk,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        vivien.didelot@gmail.com
Subject: Re: net: dsa: mv88e6xxx: error parsing ethernet node from dts
Message-ID: <20191204171336.GF21904@lunn.ch>
References: <27f65072-f3a1-7a3c-5e9e-0cc86d25ab51@televic.com>
 <20191204153804.GD21904@lunn.ch>
 <ccf9c80e-83e5-d207-8d09-1819cfb1cf35@televic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ccf9c80e-83e5-d207-8d09-1819cfb1cf35@televic.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 05:20:04PM +0100, Jürgen Lambrecht wrote:
> On 12/4/19 4:38 PM, Andrew Lunn wrote:
> >> Here parts of dmesg (no error reported):
> >>
> >> [    1.992342] libphy: Fixed MDIO Bus: probed
> >> [    2.009532] pps pps0: new PPS source ptp0
> >> [    2.014387] libphy: fec_enet_mii_bus: probed
> >> [    2.017159] mv88e6085 2188000.ethernet-1:00: switch 0x710 detected: Marvell 88E6071, revision 5
> >> [    2.125616] libphy: mv88e6xxx SMI: probed
> >> [    2.134450] fec 2188000.ethernet eth0: registered PHC device 0
> >> ...
> >> [   11.366359] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=POLL)
> >> [   11.366722] fec 2188000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
> >>
> >> When I enable debugging in the source code, I see that mv88e6xxx_probe() fails, because *'of_find_net_device_by_node(ethernet);'* fails. But why?,
> > That always happens the first time. There is a chicken/egg
> > problem. The MDIO bus is registered by the FEC driver, the switch is
> > probed, and the DSA core looks for the ethernet interface. But the FEC
> > driver has not yet registered the interface, it is still busy
> > registering the MDIO bus. So you get an EPRODE_DEFFER from the switch
> > probe. The FEC then completes its probe, registering the
> > interface. Sometime later Linux retries the switch probe, and this
> > time it works.
> >
> > What you are seeing here is the first attempt. There should be a
> > second go later in the log.
> >
> >        Andrew
> 

> Indeed, but that also fails because this second time, reading the
> switch ID (macreg 3 at addr 8) fails, it returns 0x0000!??

So this is the real problem.

Try removing the reset GPIO line from DT. If there is an EEPROM, and
the EEPROM contains a lot of instructions, we have seen it take a long
time to reset, load the EEPROM, and then start responding on the MDIO
bus. If you take away the GPIO, it will only do a software reset,
which is much faster. Even if you don't have an EEPROM, it is worth a
try.

But returning 0x0000 is odd. Normally, if an MDIO device does not
respond, you read 0xffff, because of the pull up resistor on the bus.

The fact you find it once means it is something like this, some minor
configuration problem, power management, etc.

	 Andrew
