Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F8055F8D2
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiF2HXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiF2HXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:23:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5C0222;
        Wed, 29 Jun 2022 00:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=udw9lHGmzoAvFePyLCTqIKD8e/mAeVeJzVZcMu5/Lq4=; b=j+WgdvbgwVAiXYEKAtG4WPjD0X
        46phVxCdZseTfn5Sqq8rzFUj9MHWNX27GVEfZiR0NHLIGG84wfxUcMdEybxgfTXszXBobgLYgcyNU
        TK+U5pj9jP0tFtlxOEx/8NavELJT8zKDhgCEVxFpIERWhb+Oq7yvGRDDwejQbKGTS8Pc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o6S23-008gOb-QH; Wed, 29 Jun 2022 09:22:39 +0200
Date:   Wed, 29 Jun 2022 09:22:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH net v4] net: phy: Don't trigger state machine while in
 suspend
Message-ID: <Yrv9v/uiZ/uMvtR3@lunn.ch>
References: <b7f386d04e9b5b0e2738f0125743e30676f309ef.1656410895.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7f386d04e9b5b0e2738f0125743e30676f309ef.1656410895.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 12:15:08PM +0200, Lukas Wunner wrote:
> Upon system sleep, mdio_bus_phy_suspend() stops the phy_state_machine(),
> but subsequent interrupts may retrigger it:
> 
> They may have been left enabled to facilitate wakeup and are not
> quiesced until the ->suspend_noirq() phase.  Unwanted interrupts may
> hence occur between mdio_bus_phy_suspend() and dpm_suspend_noirq(),
> as well as between dpm_resume_noirq() and mdio_bus_phy_resume().
> 
> Retriggering the phy_state_machine() through an interrupt is not only
> undesirable for the reason given in mdio_bus_phy_suspend() (freezing it
> midway with phydev->lock held), but also because the PHY may be
> inaccessible after it's suspended:  Accesses to USB-attached PHYs are
> blocked once usb_suspend_both() clears the can_submit flag and PHYs on
> PCI network cards may become inaccessible upon suspend as well.
> 
> Amend phy_interrupt() to avoid triggering the state machine if the PHY
> is suspended.  Signal wakeup instead if the attached net_device or its
> parent has been configured as a wakeup source.  (Those conditions are
> identical to mdio_bus_phy_may_suspend().)  Postpone handling of the
> interrupt until the PHY has resumed.
> 
> Before stopping the phy_state_machine() in mdio_bus_phy_suspend(),
> wait for a concurrent phy_interrupt() to run to completion.  That is
> necessary because phy_interrupt() may have checked the PHY's suspend
> status before the system sleep transition commenced and it may thus
> retrigger the state machine after it was stopped.
> 
> Likewise, after re-enabling interrupt handling in mdio_bus_phy_resume(),
> wait for a concurrent phy_interrupt() to complete to ensure that
> interrupts which it postponed are properly rerun.
> 
> The issue was exposed by commit 1ce8b37241ed ("usbnet: smsc95xx: Forward
> PHY interrupts to PHY driver to avoid polling"), but has existed since
> forever.
> 
> Fixes: 541cd3ee00a4 ("phylib: Fix deadlock on resume")
> Link: https://lore.kernel.org/netdev/a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com/
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: stable@vger.kernel.org # v2.6.33+

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
