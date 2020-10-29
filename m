Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9FE29E635
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgJ2IRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbgJ2IQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:16:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100A2C0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 01:16:48 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kY36o-0003lj-An; Thu, 29 Oct 2020 09:16:34 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kY36h-0006HS-01; Thu, 29 Oct 2020 09:16:27 +0100
Date:   Thu, 29 Oct 2020 09:16:26 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     "Badel, Laurent" <LaurentBadel@eaton.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: Re: [PATCH net 0/4] Restore and fix PHY reset for SMSC LAN8720
Message-ID: <20201029081626.wtnhctobwvlhmfan@pengutronix.de>
References: <CY4PR1701MB1878B85B9E1C5B4FDCBA2860DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CY4PR1701MB1878B85B9E1C5B4FDCBA2860DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:57:28 up 348 days, 23:16, 377 users,  load average: 0.05, 0.05,
 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

thanks for your patches :)

On 20-10-27 23:25, Badel, Laurent wrote:
> ﻿Subject: [PATCH net 0/4] Restore and fix PHY reset for SMSC LAN8720
> 
> Description:
> A recent patchset [1] added support in the SMSC PHY driver for managing
> the ref clock and therefore removed the PHY_RST_AFTER_CLK_EN flag for the
> LAN8720 chip. The ref clock is passed to the SMSC driver through a new
> property "clocks" in the device tree.
> 
> There appears to be two potential caveats:
> (i) Building kernel 5.9 without updating the DT with the "clocks"
> property for SMSC PHY, would break systems previously relying on the PHY
> reset workaround (SMSC driver cannot grab the ref clock, so it is still
> managed by FEC, but the PHY is not reset because PHY_RST_AFTER_CLK_EN is
> not set). This may lead to occasional loss of ethernet connectivity in
> these systems, that is difficult to debug.

IMHO reyling on PHY_RST_AFTER_CLK_EN was broken since the day of adding
this feature because:

1st) Each host driver needs to call the phy-reset logic. So this isn't a
     fix for all hosts using a LAN8720 phy.
2st) It interacts realy bad with the phy state machine. Only the state
     machine should be able to do this.

Why can't you add the clock?

> (ii) This defeats the purpose of a previous commit [2] that disabled the
> ref clock for power saving reasons. If a ref clock for the PHY is
> specified in DT, the SMSC driver will keep it always on (confirmed with 
> scope).

NACK, the clock provider can be any clock. This has nothing to do with
the FEC clocks. The FEC _can_ be used as clock provider.

> While this removes the need for additional PHY resets (only a 
> single reset is needed after power up), this prevents the FEC from saving
> power by disabling the refclk. Since there may be use cases where one is
> interested in saving power,

You can't just turn off the clock for the LAN8720 because of the phy
internal state machine. The state machine gets confused if the clock is
turned off/on randomly.

> keep this option available when no ref clock
> is specified for the PHY, by fixing issues with the PHY reset.

IMHO pulling the reset line everytime has a few disadvantages:
 - You need to ensure that the strapping pins are correct and
 - You need to ensure that the reset logic including the reset delays
   are keeped.

> Main changes proposed to address this:
> (a) Restore PHY_RST_AFTER_CLK_EN for LAN8720, but explicitly clear it if
> the SMSC driver succeeds in retrieving the ref clock.

IMHO NACK since this was the wrong approach.

> (b) Fix phy_reset_after_clk_enable() to work in interrupt mode, by
> re-configuring the PHY registers after reset.
> 
> Tests: against net tree 5.9, including allyes/no/modconfig. 10 pieces of
> an iMX28-EVK-based board were tested, 3 of which were found to exhibit
> issues when the "clocks" property was left unset. Issues were fixed by
> the present patchset.

All iMX machines are now DT-based why can't you just add the correct
clock provider?

Regards,
  Marco
