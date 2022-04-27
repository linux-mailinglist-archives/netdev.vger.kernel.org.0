Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC8B511792
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbiD0M3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 08:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbiD0M3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:29:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F1F37A14;
        Wed, 27 Apr 2022 05:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eVg2d15Vr7wg3dfGyW7fAtoN0Xx+vU3DpeqHOZFF7+A=; b=2/b8paztp0zEpXANwdQVMZcl9g
        Jp1mXWYGi86/C8Jmm0aB1yTP62j/mDtGH+6lFEF5tmSOYx8mOTSNMwFpvduoE+SK9mwb8ibx6YZ0l
        MSsxZKrzc+58tta+ja7FrL5Q7IltMtc2wj01aCY/o5WMIHt0raajioDhe9NzkjVfqtBk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njgkM-0006ny-ER; Wed, 27 Apr 2022 14:26:18 +0200
Date:   Wed, 27 Apr 2022 14:26:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
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
Subject: Re: [PATCH net-next 5/7] usbnet: smsc95xx: Forward PHY interrupts to
 PHY driver to avoid polling
Message-ID: <Ymk2agSoHnlCMUzB@lunn.ch>
References: <cover.1651037513.git.lukas@wunner.de>
 <276a1b50cf9fcca5168ca2770a863cb56069a277.1651037513.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <276a1b50cf9fcca5168ca2770a863cb56069a277.1651037513.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 07:48:05AM +0200, Lukas Wunner wrote:
> Link status of SMSC LAN95xx chips is polled once per second, even though
> they're capable of signaling PHY interrupts through the MAC layer.
> 
> Forward those interrupts to the PHY driver to avoid polling.  Benefits
> are reduced bus traffic, reduced CPU overhead and quicker interface
> bringup.
> 
> Polling was introduced in 2016 by commit d69d16949346 ("usbnet:
> smsc95xx: fix link detection for disabled autonegotiation").
> Back then, the LAN95xx driver neglected to enable the ENERGYON interrupt,
> hence couldn't detect link-up events when auto-negotiation was disabled.
> The proper solution would have been to enable the ENERGYON interrupt
> instead of polling.
> 
> Since then, PHY handling was moved from the LAN95xx driver to the SMSC
> PHY driver with commit 05b35e7eb9a1 ("smsc95xx: add phylib support").
> That PHY driver is capable of link detection with auto-negotiation
> disabled because it enables the ENERGYON interrupt.
> 
> Note that signaling interrupts through the MAC layer not only works with
> the integrated PHY, but also with an external PHY, provided its
> interrupt pin is attached to LAN95xx's nPHY_INT pin.
> 
> In the unlikely event that the interrupt pin of an external PHY is
> attached to a GPIO of the SoC (or not connected at all), the driver can
> be amended to retrieve the irq from the PHY's of_node.
> 
> To forward PHY interrupts to phylib, it is not sufficient to call
> phy_mac_interrupt().  Instead, the PHY's interrupt handler needs to run
> so that PHY interrupts are cleared.  That's because according to page
> 119 of the LAN950x datasheet, "The source of this interrupt is a level.
> The interrupt persists until it is cleared in the PHY."
> 
> https://www.microchip.com/content/dam/mchp/documents/UNG/ProductDocuments/DataSheets/LAN950x-Data-Sheet-DS00001875D.pdf
> 
> Therefore, create an IRQ domain with a single IRQ for the PHY.  In the
> future, the IRQ domain may be extended to support the 11 GPIOs on the
> LAN95xx.
> 
> Normally the PHY interrupt should be masked until the PHY driver has
> cleared it.  However masking requires a (sleeping) USB transaction and
> interrupts are received in (non-sleepable) softirq context.  I decided
> not to mask the interrupt at all (by using the dummy_irq_chip's noop
> ->irq_mask() callback):  The USB interrupt endpoint is polled in 1 msec
> intervals and normally that's sufficient to wake the PHY driver's IRQ
> thread and have it clear the interrupt.  If it does take longer, worst
> thing that can happen is the IRQ thread is woken again.  No big deal.
> 
> Because PHY interrupts are now perpetually enabled, there's no need to
> selectively enable them on suspend.  So remove all invocations of
> smsc95xx_enable_phy_wakeup_interrupts().
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: Andre Edich <andre.edich@microchip.com>

This looks reasonable from a PHY perspective. I cannot say much about
USB though.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
