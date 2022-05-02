Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B43516FBA
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 14:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385053AbiEBMqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 08:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382666AbiEBMqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 08:46:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D8613E19;
        Mon,  2 May 2022 05:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+VctyfpBc7br87X3mwa6CtDZ/oohz2FVFhUyHvvKoK0=; b=iviY4w3WFQEGDJuoWPrmdDQXb7
        O66C1jQqmZVWsPWpxF9k4oBlUc8fbqaEKVcZCsO+LhuCBpedYK4xTSCEkvOB+U5kvwzxCCAPvMm5K
        eF8JAYZscPIkC/SLmjh6d9Br9TLxDOIXebsxEAZa4D63qYqWs0olIIh+a/hAVwbUE8AY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nlVNf-000tpN-8Z; Mon, 02 May 2022 14:42:23 +0200
Date:   Mon, 2 May 2022 14:42:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
Message-ID: <Ym/Rr6BN7b/Y6mqu@lunn.ch>
References: <20220502085437.142000-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502085437.142000-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
> +			     u16 regnum)
> +{
> +	/* Write the desired MMD Devad */
> +	__mdiobus_write(bus, phy_addr, MII_MMD_CTRL, devad);
> +
> +	/* Write the desired MMD register address */
> +	__mdiobus_write(bus, phy_addr, MII_MMD_DATA, regnum);
> +
> +	/* Select the Function : DATA with no post increment */
> +	__mdiobus_write(bus, phy_addr, MII_MMD_CTRL,
> +			devad | MII_MMD_CTRL_NOINCR);
> +}

Please make the version in phy-core.c global scope.

A better explanation of what is going on here would be good.

> +	/* This PHY supports only C22 MDIO opcodes. We can use only indirect
> +	 * access.
> +	 */
> +	mmd_phy_indirect(bus, phy_addr, devad, regnum);

This comment suggests it is because it cannot do C45. But the core
should handle this, it would use indirect access. However, you have
hijacked phydev->drv->read_mmd to allow you to translate standard
registers to vendor registers. This bypasses the cores fallback to
indirect access.

> +static struct phy_driver dp83td510_driver[] = {
> +{
> +	PHY_ID_MATCH_MODEL(DP83TD510E_PHY_ID),
> +	.name		= "TI DP83TD510E",
> +
> +	.config_aneg	= genphy_c45_config_aneg,
> +	.read_status	= genphy_c45_read_status,
> +	.get_features	= dp83td510_get_features,
> +	.config_intr	= dp83td510_config_intr,
> +	.handle_interrupt = dp83td510_handle_interrupt,
> +
> +	.suspend	= genphy_suspend,
> +	.resume		= genphy_resume,
> +	.read_mmd	= dp83td510_read_mmd,
> +	.write_mmd	= dp83td510_write_mmd,

Given how far this PHY is away from standards, you might get a smaller
simpler driver if you ignore genphy all together, write your own
config_aneg and read_status, and don't mess with .read_mmd and
write_mmd.

	Andrew
