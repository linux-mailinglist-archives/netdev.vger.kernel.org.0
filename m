Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4425511DBA
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244752AbiD0SXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 14:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244723AbiD0SXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 14:23:04 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 2D2E55548D
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 11:19:51 -0700 (PDT)
Received: (qmail 884473 invoked by uid 1000); 27 Apr 2022 14:19:51 -0400
Date:   Wed, 27 Apr 2022 14:19:51 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net] usbnet: smsc95xx: Fix deadlock on runtime resume
Message-ID: <YmmJR8i+bCl8ueSX@rowland.harvard.edu>
References: <6710d8c18ff54139cdc538763ba544187c5a0cee.1651041411.git.lukas@wunner.de>
 <YmlgQhauzZ/tkX/v@lunn.ch>
 <20220427153851.GA15329@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427153851.GA15329@wunner.de>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 05:38:51PM +0200, Lukas Wunner wrote:
> On Wed, Apr 27, 2022 at 05:24:50PM +0200, Andrew Lunn wrote:
> > On Wed, Apr 27, 2022 at 08:41:49AM +0200, Lukas Wunner wrote:
> > > Commit 05b35e7eb9a1 ("smsc95xx: add phylib support") amended
> > > smsc95xx_resume() to call phy_init_hw().  That function waits for the
> > > device to runtime resume even though it is placed in the runtime resume
> > > path, causing a deadlock.
> > 
> > You have looked at this code, tried a few different things, so this is
> > probably a dumb question.
> > 
> > Do you actually need to call phy_init_hw()?
> > 
> > mdio_bus_phy_resume() will call phy_init_hw(). So long as you first
> > resume the MAC and then the PHY, shouldn't this just work?
> 
> mdio_bus_phy_resume() is only called for system sleep.  But this is about
> *runtime* PM.
> 
> mdio_bus_phy_pm_ops does not define runtime PM callbacks.  So runtime PM
> is disabled on PHYs, no callback is invoked for them when the MAC runtime
> suspends, hence the onus is on the MAC to runtime suspend the PHY (which
> is a child of the MAC).  Same on runtime resume.
> 
> Let's say I enable runtime PM on the PHY and use pm_runtime_force_suspend()
> to suspend the PHY from the MAC's ->runtime_suspend callback.  At that
> point the MAC already has status RPM_SUSPENDING.  Boom, deadlock.
> 
> The runtime PM core lacks the capability to declare that children should
> be force runtime suspended before a device can runtime suspend, that's
> the problem.

This might work out if you copy the scheme we use for USB devices and 
interfaces.

A USB interface is only a logical part of its parent device, and as such 
does not have a separate runtime power state of its own (in USB-2, at 
least).  Therefore the USB core calls pm_runtime_no_callbacks() for each 
interface as it is created, and handles the runtime power management for 
the interface (i.e., invoking the interface driver's runtime_suspend and 
runtime_resume callbacks) from within the device's runtime PM routines 
-- independent of the PM core's notion of what the interface's power 
state should be.

Similarly, you could call pm_runtime_no_callbacks() for the PHY when it 
is created, and manage the PHY's actual power state from within the 
MAC's runtime-PM routines directly (i.e., without going through the PM 
core).

Alan Stern
