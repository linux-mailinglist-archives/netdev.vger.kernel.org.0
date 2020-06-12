Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD6D1F7664
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 12:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgFLKBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 06:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgFLKBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 06:01:21 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B721C03E96F;
        Fri, 12 Jun 2020 03:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FPRn34drjrS7tR0VZroA+Jb46I8CJY2q34LIxXnZ6lk=; b=dF/CBdt9MnfDvjtwqLZMvlIaL
        C6ZdLaFTCJCLw8aiNpeUfiEs1c1xrhnqm3xiRYZgAad4zelL+ktgcQI3geQHpLoYGcKNA0+V2zm/s
        Wt1zUQlFR2O8Fxi8+y90qWQAB2yuk9t4HlWOoW0RnuhAuC3EG+EjL3katLCL7SqjSp7jC9qbphiix
        PRUSKMYBnS5OjuI8bjS3O60XTBGeECQZQLF+VAQFO8VZUzNKz1q0DnnnB6w6zBXHFI2Nk722gf+yF
        5alegWwNXhs9+eqxdxOoGn0kcZDqOVItUHdHvmA4JA4NDq+DW9ckfMRkqQkLvjgMzfPlpvXtLyR/d
        BnLshXokw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44562)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jjgUt-0002Y5-RJ; Fri, 12 Jun 2020 11:01:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jjgUt-00069j-3l; Fri, 12 Jun 2020 11:01:15 +0100
Date:   Fri, 12 Jun 2020 11:01:15 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] net: mvneta: Fix Serdes configuration for 2.5Gbps
 modes
Message-ID: <20200612100114.GE1551@shell.armlinux.org.uk>
References: <20200612083847.29942-1-s.hauer@pengutronix.de>
 <20200612084710.GC1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612084710.GC1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 09:47:10AM +0100, Russell King - ARM Linux admin wrote:
> On Fri, Jun 12, 2020 at 10:38:47AM +0200, Sascha Hauer wrote:
> > The Marvell MVNETA Ethernet controller supports a 2.5Gbps SGMII mode
> > called DRSGMII. Depending on the Port MAC Control Register0 PortType
> > setting this seems to be either an overclocked SGMII mode or 2500BaseX.
> > 
> > This patch adds the necessary Serdes Configuration setting for the
> > 2.5Gbps modes. There is no phy interface mode define for overclocked
> > SGMII, so only 2500BaseX is handled for now.
> > 
> > As phy_interface_mode_is_8023z() returns true for both
> > PHY_INTERFACE_MODE_1000BASEX and PHY_INTERFACE_MODE_2500BASEX we
> > explicitly test for 1000BaseX instead of using
> > phy_interface_mode_is_8023z() to differentiate the different
> > possibilities.
> > 
> > Fixes: da58a931f248f ("net: mvneta: Add support for 2500Mbps SGMII")
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> 2500base-X is used today on Armada 388 and Armada 3720 platforms and
> works - it is known to interoperate with Marvell PP2.2 hardware, as
> well was various SFPs such as the Huawei MA5671A at 2.5Gbps.  The way
> it is handled on these platforms is via the COMPHY, requesting that
> the serdes is upclocked from 1.25Gbps to 3.125Gbps.
> 
> This "DRSGMII" mode is not mentioned in the functional specs for either
> the Armada 388 or Armada 3720, the value you poke into the register is
> not mentioned either.  As I've already requested, some information on
> exactly what this "DRSGMII" is would be very useful, it can't be
> "double-rate SGMII" because that would give you 2Gbps instead of 1Gbps.
> 
> So, I suspect this breaks the platforms that are known to work.
> 
> We need a proper description of what DRSGMII is before we can consider
> taking any patches for it.

Okay, having dug through the Armada XP, 370, 388, 3720 specs, I think
this is fine after all - but something that will help for the future
would be to document that this register does not exist on the 388 and
3720 devices (which brings up the question whether we should be writing
it there.)  The field was moved into the comphy on those devices.

So, it looks like if we have a comphy, we should not be writing this
register.

What's more, the write to MVNETA_SERDES_CFG should not be in
mvneta_port_power_up(); it's likely that XP and 370 will not work
properly with phylink.  It needs to be done in a similar location to
mvneta_comphy_init(), so that phylink can switch between 1G and 2.5G
speeds.

As you have an Armada XP system, you are best placed to test moving
that write.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
