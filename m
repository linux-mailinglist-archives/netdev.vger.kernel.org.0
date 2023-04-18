Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638A76E6C74
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 20:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjDRS5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 14:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbjDRS5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 14:57:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41F47AB0
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 11:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qmtwKEo5joFRmRCJrktO7c4v+t078GyIQgtPdTXJEDY=; b=56kG6iFhoe9UM1iOkS96y3U1RA
        nir/oJkbIynP98Lcc65MTbLjdPfAzHASH0r/cNFVIn8kz+Kadrh2XD8ryjD3/H5VVqqPYwyE8NpeK
        CURx+0srWkQ1eRY696oNUdQnx9I2cZ0L6VYbWNC82hDarYTdB/Hm4M+37OkYvVE9/D7A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1poqVT-00AdWH-NZ; Tue, 18 Apr 2023 20:56:47 +0200
Date:   Tue, 18 Apr 2023 20:56:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <2806b25b-1914-4525-a085-b0867711bce9@lunn.ch>
References: <ZD7YzBhzlEBHrEPC@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD7YzBhzlEBHrEPC@builder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +config LAN867X_PHY
> +	tristate "Microchip 10BASE-T1S Ethernet PHY"
> +	help
> +		Currently supports the LAN8670, LAN8671, LAN8672
> +

This file is sorted by tristate string, so it should come before
        tristate "Microchip PHYs"

> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index b5138066ba04..a12c2f296297 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -78,6 +78,7 @@ obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
>  obj-$(CONFIG_MOTORCOMM_PHY)	+= motorcomm.o
>  obj-$(CONFIG_NATIONAL_PHY)	+= national.o
>  obj-$(CONFIG_NCN26000_PHY)	+= ncn26000.o
> +obj-$(CONFIG_LAN867X_PHY) += lan867x.o

And this is sorted by CONFIG_ so should appear after
CONFIG_INTEL_XWAY_PHY.

>  obj-$(CONFIG_NXP_C45_TJA11XX_PHY)	+= nxp-c45-tja11xx.o
>  obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
>  obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
> diff --git a/drivers/net/phy/lan867x.c b/drivers/net/phy/lan867x.c

Maybe call it microchip_t1s.c ? That sort of fits with the pattern of
the current files:

microchip.c
microchip_t1.c

Microchip drivers don't really have a consistent naming, because they
keep buying other vendors, like vitesse, Microsemi, Micrel/Kendin...

> +static int lan867x_config_init(struct phy_device *phydev)
> +{
> +	/* HW quirk: Microchip states in the application note (AN1699) for the phy
> +	 * that a set of read-modify-write (rmw) operations has to be performed
> +	 * on a set of seemingly magic registers.
> +	 * The result of these operations is just described as 'optimal performance'
> +	 * Microchip gives no explanation as to what these mmd regs do,
> +	 * in fact they are marked as reserved in the datasheet.
> +	 */
> +
> +	/* The arrays below are pulled from the following table from AN1699
> +	 * Access MMD Address Value Mask
> +	 * RMW 0x1F 0x00D0 0x0002 0x0E03
> +	 * RMW 0x1F 0x00D1 0x0000 0x0300
> +	 * RMW 0x1F 0x0084 0x3380 0xFFC0
> +	 * RMW 0x1F 0x0085 0x0006 0x000F
> +	 * RMW 0x1F 0x008A 0xC000 0xF800
> +	 * RMW 0x1F 0x0087 0x801C 0x801C
> +	 * RMW 0x1F 0x0088 0x033F 0x1FFF
> +	 * W   0x1F 0x008B 0x0404 ------
> +	 * RMW 0x1F 0x0080 0x0600 0x0600
> +	 * RMW 0x1F 0x00F1 0x2400 0x7F00
> +	 * RMW 0x1F 0x0096 0x2000 0x2000
> +	 * W   0x1F 0x0099 0x7F80 ------
> +	 */
> +
> +	const int registers[12] = {
> +		0x00D0, 0x00D1, 0x0084, 0x0085,
> +		0x008A, 0x0087, 0x0088, 0x008B,
> +		0x0080, 0x00F1, 0x0096, 0x0099,
> +	};
> +
> +	const int masks[12] = {
> +		0x0E03, 0x0300, 0xFFC0, 0x000F,
> +		0xF800, 0x801C, 0x1FFF, 0xFFFF,
> +		0x0600, 0x7F00, 0x2000, 0xFFFF,
> +	};
> +
> +	const int values[12] = {
> +		0x0002, 0x0000, 0x3380, 0x0006,
> +		0xC000, 0x801C, 0x033F, 0x0404,
> +		0x0600, 0x2400, 0x2000, 0x7F80,
> +	};
> +
> +	int err;
> +	int reg;
> +	int reg_value;

netdev uses reverse christmas tree. That is, variables should be
sorted with the longest lines first, shorted last.

> +	/* Read-Modified Write Pseudocode (from AN1699)
> +	 * current_val = read_register(mmd, addr) // Read current register value
> +	 * new_val = current_val AND (NOT mask) // Clear bit fields to be written
> +	 * new_val = new_val OR value // Set bits
> +	 * write_register(mmd, addr, new_val) // Write back updated register value
> +	 */
> +	for (int i = 0; i < ARRAY_SIZE(registers); i++) {
> +		reg = registers[i];
> +		reg_value = phy_read_mmd(phydev, MDIO_MMD_VEND2, reg);
> +		reg_value &= ~masks[i];
> +		reg_value |= values[i];
> +		err = phy_write_mmd(phydev, MDIO_MMD_VEND2, reg, reg_value);
> +		if (err != 0)
> +			return err;
> +	}

Maybe phy_modify_mmd(). However, that skips the write if the value is
not changed by the mask and set value.

> +static int lan867x_config_interrupt(struct phy_device *phydev)
> +{
> +	/* None of the interrupts in the lan867x phy seem relevant.
> +	 * Other phys inspect the link status and call phy_trigger_machine
> +	 * on change.
> +	 * This phy does not support link status, and thus has no interrupt
> +	 * for it either.
> +	 * So we'll just disable all interrupts instead.
> +	 */

It interrupts are pointless, just don't provide the functions. phylib
will then poll.

> +static int lan867x_read_status(struct phy_device *phydev)
> +{
> +	/* The phy has some limitations, namely:
> +	 *  - always reports link up
> +	 *  - only supports 10MBit half duplex
> +	 *  - does not support auto negotiate
> +	 */
> +	phydev->link = 1;
> +	phydev->duplex = DUPLEX_HALF;
> +	phydev->speed = SPEED_10;
> +	phydev->autoneg = AUTONEG_DISABLE;
> +
> +	return 0;

Not that polling gives anything useful!

    Andrew
