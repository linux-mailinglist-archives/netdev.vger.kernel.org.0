Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F376363D975
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 16:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiK3PcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 10:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiK3PcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 10:32:16 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E53E52892
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 07:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tUqs17zPUdAYI/5hFOXb6v64aAqlloI0yFs0BiZGHHk=; b=Ld9XbTVFYrUdoZtQnTdFbrw5/9
        tOvtTE/gF+iG4R4HChWSx6hIEOKP3YrZwY+v0RvafWEIo98PRn/Kb6kRe7K973K3WPqZChPtP8iTT
        6BvTD1gbbPE3iSxpRfifmaTaqmAvM4CMjYBOL+tFS6D+PYWuEkHjMKjWDkKGVh5HRuGs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0P4H-003y8H-Ey; Wed, 30 Nov 2022 16:32:13 +0100
Date:   Wed, 30 Nov 2022 16:32:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Help on PHY not supporting autoneg
Message-ID: <Y4d3fV8lUhUehCq6@lunn.ch>
References: <Y4dJgj4Z8516tJwx@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4dJgj4Z8516tJwx@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 01:16:02PM +0100, Piergiorgio Beruto wrote:
> Hello netdev group,
> I am looking for someone willing to help me on a problem I encountered
> while trying to implement a driver for a PHY that does not support
> autoneg. On my reference HW, the PHY is connected to a stmmac via MII.
> 
> This is what I did in the driver:
> - implement get_features to report NO AN support, and the supported link
>   modes.
> - implement the IRQ handling (config_intr and handle_interrupt) to
>   report the link status
> 
> The first problem I encountered is: how to start the PHY? The device
> requires a bit (LINK_CONTROL) to be enabled before trying to bring up
> the link. But I could not find any obvious callback from phylib to
> actually do this. Eventually, I opted for implementing the
> suspend/resume callbacks and set that bit in there. Is that right? Any
> better option?

The MAC driver should call phy_start() in its open function.  That
kicks off the state machine. That results in phy_start_aneg(),
_phy_start_aneg(), phy_config_aneg(), which calls the PHY drivers
config_aneg() method. It does not matter here that the PHY does not
actually support AN, this method still gets called. The driver can
then look at the phydev members and configure the hardware as needed.
 
> With that said, the thing still does not work as I would expect. When I
> ifconfig up my device, here's what happens (the ncn_* prints are just
> debug prinktks I've added to show the problem). See also my comments in
> the log marked with //
> 
> /root # ifconfig eth0 up
> [   26.950557] socfpga-dwmac ff700000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
> [   26.962673] ncn_soft_reset
> [   26.966345] ncn_config_init
> [   26.969168] ncn_config_intr
> [   26.972211] disable IRQs   // OK, this is expected, phylib is resetting the device
> [   26.975062] ncn_resume     // not sure I expected this to be here, but it does not harm
> [   26.977746] socfpga-dwmac ff700000.ethernet eth0: PHY [stmmac-0:08] driver [NCN26000] (irq=49)
> [   26.986861] ncn_config_intr
> [   26.990045] ncn_config_intr ret = 8000, irqs = 0001
> [   26.994958] ncn_handle_interrupt 8000
> [   26.998941] ncn_handle_interrupt 8001
> [   27.002752] link = 1, ret = 0829       // there I get a link UP!
> [   27.016526] dwmac1000: Master AXI performs any burst length
> [   27.022128] socfpga-dwmac ff700000.ethernet eth0: No Safety Features support found
> [   27.029999] socfpga-dwmac ff700000.ethernet eth0: IEEE 1588-2008 Advanced Timestamp supported
> [   27.039425] socfpga-dwmac ff700000.ethernet eth0: registered PTP clock
> [   27.049388] socfpga-dwmac ff700000.ethernet eth0: configuring for phy/mii link mode
> [   27.057155] ncn_resume  // I don't fully understand what happened since the link up, but it seems the MAC is doing more initialization

This looks odd. I would not expect a resume here. Add a WARN_ON(1) to
get a stack trace and see if that helps explain why. My guess would
be, you somehow end up in socfpga_dwmac_resume().

> [   27.061251] ncn_handle_interrupt 8001
> [   27.065100] link = 0, ret = 0809 // here I get a link down (???)
> 
> >From there on, if I read the LINK_CONTROL bit, someone set it to 0 (???)

You can add a WARN_ON(regnum==0) in phy_write() to get a stack trace.

> I've also tried a completely different approach, that is "emulating"
> autoneg by implementing the config_aneg, aneg_done and read_status
> callbacks. If I do this, then my driver works just fine and nobody seems
> to be overwriting register 0.

That is not emulating. The config_aneg() just has a bad name.

If you have not provided a config_aneg() the default implementation is
used, __genphy_config_aneg(), which will call genphy_setup_forced():

int genphy_setup_forced(struct phy_device *phydev)
{
	u16 ctl;

	phydev->pause = 0;
	phydev->asym_pause = 0;

	ctl = mii_bmcr_encode_fixed(phydev->speed, phydev->duplex);

	return phy_modify(phydev, MII_BMCR,
			  ~(BMCR_LOOPBACK | BMCR_ISOLATE | BMCR_PDOWN), ctl);

What exactly is LINK_CONTROL. It is not one of the Linux names for a
bit in BMCR.

    Andrew
