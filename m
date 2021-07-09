Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156733C2774
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 18:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhGIQZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 12:25:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhGIQZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 12:25:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IulwG137wVcX3Stl/d7lPCKJt/r5YrKnAVS4QDuPt9U=; b=lnmrYeJU3WD3nSTpNb7ebS3BzF
        NVmCFo/iXoOZ7H6sbN0yKT1E09SO1YFAxfGWTZ/4yJU3AFcJWz33eC3jd52tVu8p05UTocmxJoQRk
        1mZoYmYzgn/wrcPmes2W5pifweLwh0OfPUd6d53D8T/jBgedpF0QNklAggQC8QhBVAEc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m1tGf-00CnFw-2x; Fri, 09 Jul 2021 18:22:21 +0200
Date:   Fri, 9 Jul 2021 18:22:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: PHY reset may still be asserted during MDIO probe
Message-ID: <YOh3vRYH923pckb9@lunn.ch>
References: <CAMuHMdXno2OUHqsAfO0z43JmGkFehD+FJ2dEjEsr_P53oAAPxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXno2OUHqsAfO0z43JmGkFehD+FJ2dEjEsr_P53oAAPxA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 05:33:36PM +0200, Geert Uytterhoeven wrote:
> Hi all,
> 
> I'm investigating a network failure after kexec on the Renesas Koelsch
> and Salvator-XS development boards, using the sh-eth or ravb driver.
> 
> During normal boot, the Ethernet interface is working fine:
> 
>     libphy: get_phy_c22_id:814: sh_mii: mdiobus_read() MII_PHYSID1 returned 34
>     libphy: get_phy_c22_id:824: sh_mii: mdiobus_read() MII_PHYSID2 returned 5431
>     libphy: get_phy_c22_id:832: sh_mii: phy_id = 0x00221537
>     libphy: get_phy_device:895: sh_mii: get_phy_c22_id() returned 0
>     fwnode_mdiobus_register_phy:109: sh_mii: get_phy_device() returned (ptrval)
>     fwnode_mdiobus_phy_device_register:46: sh_mii: fwnode_irq_get() returned 191
>     libphy: mdiobus_register_gpiod:48: mdiodev->reset_gpio = (ptrval)
>     mdio_bus ee700000.ethernet-ffffffff:01:
> mdiobus_register_device:88: assert MDIO reset
>     libphy: mdio_device_reset:124: calling gpiod_set_value_cansleep(..., 1)
>     mdio_bus ee700000.ethernet-ffffffff:01: phy_device_register:931:
> deassert PHY reset
>     libphy: mdio_device_reset:124: calling gpiod_set_value_cansleep(..., 0)
>     Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: phy_probe:3026:
> deassert PHY reset
>     libphy: mdio_device_reset:124: calling gpiod_set_value_cansleep(..., 0)
>     fwnode_mdiobus_phy_device_register:75: sh_mii:
> phy_device_register() returned 0
>     fwnode_mdiobus_register_phy:137: sh_mii:
> fwnode_mdiobus_phy_device_register() returned 0
>     of_mdiobus_register:188: of_mdiobus_register_phy(sh_mii,
> /soc/ethernet@ee700000/ethernet-phy@1, 1) returned 0
>     sh-eth ee700000.ethernet eth0: Base address at 0xee700000,
> 2e:09:0a:00:6d:85, IRQ 126.
> 
> When using kexec, the PHY reset is asserted before starting the
> new kernel:
> 
>     Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: phy_detach:1759:
> assert PHY reset
>     libphy: mdio_device_reset:124: calling gpiod_set_value_cansleep(..., 1)
>     kexec_core: Starting new kernel
>     Bye!
> 
> The new kernel fails to probe the PHY, as the PHY reset is still
> asserted:
> 
>     libphy: get_phy_c22_id:814: sh_mii: mdiobus_read() MII_PHYSID1
> returned 65535
>     libphy: get_phy_c22_id:824: sh_mii: mdiobus_read() MII_PHYSID2
> returned 65535

The per PHY reset is historically 'interesting'. It makes the
assumption the PHY can be detected when in reset, because the PHY it
was added for could be detected when in reset. And it turns out to be,
most PHYs cannot be detected when held in reset.

The simple solution is to make use of the MDIO bus reset property, as
Russell suggested. If you don't want to do that, you need to put the
PHY ID into DT. The core will then skip scanning the bus for the PHY,
and go straight to instantiating the PHY, and then it should be
brought out of reset.

	Andrew
