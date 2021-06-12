Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8E23A4CCC
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 06:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFLE2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 00:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhFLE2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 00:28:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A8CC061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 21:26:47 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lrvEH-0008IN-Uw; Sat, 12 Jun 2021 06:26:41 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lrvEF-0002Aj-Hc; Sat, 12 Jun 2021 06:26:39 +0200
Date:   Sat, 12 Jun 2021 06:26:39 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 4/9] net: phy: micrel: apply resume errata
 workaround for ksz8873 and ksz8863
Message-ID: <20210612042639.bgsloltuqoipmwtk@pengutronix.de>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-5-o.rempel@pengutronix.de>
 <20210611192010.ptmblzpj6ilt24ly@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210611192010.ptmblzpj6ilt24ly@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:26:05 up 191 days, 18:32, 38 users,  load average: 0.17, 0.10,
 0.02
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 10:20:10PM +0300, Vladimir Oltean wrote:
> On Fri, Jun 11, 2021 at 09:15:22AM +0200, Oleksij Rempel wrote:
> > The ksz8873 and ksz8863 switches are affected by following errata:
> > 
> > | "Receiver error in 100BASE-TX mode following Soft Power Down"
> > |
> > | Some KSZ8873 devices may exhibit receiver errors after transitioning
> > | from Soft Power Down mode to Normal mode, as controlled by register 195
> > | (0xC3) bits [1:0]. When exiting Soft Power Down mode, the receiver
> > | blocks may not start up properly, causing the PHY to miss data and
> > | exhibit erratic behavior. The problem may appear on either port 1 or
> > | port 2, or both ports. The problem occurs only for 100BASE-TX, not
> > | 10BASE-T.
> > |
> > | END USER IMPLICATIONS
> > | When the failure occurs, the following symptoms are seen on the affected
> > | port(s):
> > | - The port is able to link
> > | - LED0 blinks, even when there is no traffic
> > | - The MIB counters indicate receive errors (Rx Fragments, Rx Symbol
> > |   Errors, Rx CRC Errors, Rx Alignment Errors)
> > | - Only a small fraction of packets is correctly received and forwarded
> > |   through the switch. Most packets are dropped due to receive errors.
> > |
> > | The failing condition cannot be corrected by the following:
> > | - Removing and reconnecting the cable
> > | - Hardware reset
> > | - Software Reset and PCS Reset bits in register 67 (0x43)
> > |
> > | Work around:
> > | The problem can be corrected by setting and then clearing the Port Power
> > | Down bits (registers 29 (0x1D) and 45 (0x2D), bit 3). This must be done
> > | separately for each affected port after returning from Soft Power Down
> > | Mode to Normal Mode. The following procedure will ensure no further
> > | issues due to this erratum. To enter Soft Power Down Mode, set register
> > | 195 (0xC3), bits [1:0] = 10.
> > |
> > | To exit Soft Power Down Mode, follow these steps:
> > | 1. Set register 195 (0xC3), bits [1:0] = 00 // Exit soft power down mode
> > | 2. Wait 1ms minimum
> > | 3. Set register 29 (0x1D), bit [3] = 1 // Enter PHY port 1 power down mode
> > | 4. Set register 29 (0x1D), bit [3] = 0 // Exit PHY port 1 power down mode
> > | 5. Set register 45 (0x2D), bit [3] = 1 // Enter PHY port 2 power down mode
> > | 6. Set register 45 (0x2D), bit [3] = 0 // Exit PHY port 2 power down mode
> > 
> > This patch implements steps 2...6 of the suggested workaround. During
> > (initial) switch power up, step 1 is executed by the dsa/ksz8795
> > driver's probe function.
> > 
> > Note: In this workaround we toggle the MII_BMCR register's BMCR_PDOWN
> > bit, this is translated to the actual register and bit (as mentioned in
> > the arratum) by the ksz8_r_phy()/ksz8_w_phy() functions.
> 
> s/arratum/erratum/
> 
> Also, the commit message is still missing this piece of information you
> gave in the previous thread:
> 
> | this issue was seen  at some early point of development (back in 2019)
> | reproducible on system start. Where switch was in some default state or
> | on a state configured by the bootloader. I didn't tried to reproduce it
> | now.
> 
> Years from now, some poor souls might struggle to understand why this
> patch was done this way. If it is indeed the case that the issue is only
> seen during the handover between bootloader and kernel, there is really
> no reason to implement the ERR workaround in phy_resume instead of doing
> it once at probe time.

Ok, i'll drop this patch for now.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
