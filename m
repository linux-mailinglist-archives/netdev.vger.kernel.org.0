Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138C8284814
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 10:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgJFIEc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Oct 2020 04:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFIEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 04:04:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24DEC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 01:04:29 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kPhxR-0005dC-HG; Tue, 06 Oct 2020 10:04:25 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kPhxQ-0000LH-CK; Tue, 06 Oct 2020 10:04:24 +0200
Date:   Tue, 6 Oct 2020 10:04:24 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: PHY reset question
Message-ID: <20201006080424.GA6988@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:01:28 up 32 days, 22:09, 214 users,  load average: 14.90, 14.27,
 15.13
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello PHY experts,

Short version:
what is the proper way to handle the PHY reset before identifying PHY?

Long version:
I stumbled over following issue:
If PHY reset is registered within PHY node. Then, sometimes,  we will not be
able to identify it (read PHY ID), because PHY is under reset.

mdio {
	compatible = "virtual,mdio-gpio";

	[...]

	/* Microchip KSZ8081 */
	usbeth_phy: ethernet-phy@3 {
		reg = <0x3>;

		interrupts-extended = <&gpio5 12 IRQ_TYPE_LEVEL_LOW>;
		reset-gpios = <&gpio5 11 GPIO_ACTIVE_LOW>;
		reset-assert-us = <500>;
		reset-deassert-us = <1000>;
	};

	[...]
};

On simple boards with one PHY per MDIO bus, it is easy to workaround by using
phy-reset-gpios withing MAC node (illustrated in below DT example), instead of
using reset-gpios within PHY node (see above DT example).

&fec {
	[...]
	phy-mode = "rmii";
	phy-reset-gpios = <&gpio4 12 GPIO_ACTIVE_LOW>;
	[...]
};

On boards with multiple PHYs (for example attached to a switch) and separate
reset lines to each PHY, it becomes more challenging. In my case, after power
cycle the system is working as expected:
- pinmux is configured to GPIO mode with internal pull-up
- GPIO is by default in input state. So the internal pull-up will automatically
  dessert the PHY reset.

On reboot, the system will assert the reset. GPIO configuration will survive the
reboot and PHYs will stay in the reset state, and not detected by the system.

So far I have following options/workarounds:
- do all needed configurations in the bootloader.
  Disadvantage:
  - not clear at which init level it should be done?
    1. Boot ROM script (in case of iMX). One fix per each board. Ease to forget.
    2. Pre bootloader. Same as 1.
    3. GPIO driver in the bootloader. What if some configuration was done in
       1. or 2.?
  - we will go back to the same problem if we jumped to Kexec

- Use compatible ("compatible = "ethernet-phy-id0022.1560") in the devicetree,
  so that reading the PHYID is not needed
  - easy to solve.
  Disadvantage:
  - losing PHY auto-detection capability
  - need a new devicetree if different PHY is used (for example in different
    board revision)

- modify PHY framework to deassert reset before identifying the PHY. 
  Disadvantages?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
