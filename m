Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00C84D2FF0
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiCINc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiCINc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:32:28 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B251179A3E;
        Wed,  9 Mar 2022 05:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Urf5AMFUlUt0z9yjEQ9K60ga9QadTuTjAogX2k+fhjU=; b=Z8LOIqAh0iqXPDCglEJQh3h0vT
        4EryRmu+7AQe1g6Hqguy6OoqTFmTNJu2wkEWM2CaoALXKFNcSWppJ8i6XLeu7+vZBiVKwFlB6QoWT
        R31EUcs6bgMc8oPK7m/7324WeN+83/IuxZ9rqB4mxJq+lehe3WyYDr7bO2yB5krRRz0M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRwPO-009xwW-2U; Wed, 09 Mar 2022 14:31:18 +0100
Date:   Wed, 9 Mar 2022 14:31:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com
Subject: Re: net: asix: best way to handle orphan PHYs
Message-ID: <YiisJogt/WO5gLId@lunn.ch>
References: <20220309121835.GA15680@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309121835.GA15680@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 01:18:35PM +0100, Oleksij Rempel wrote:
> Hello all,
> 
> I have ASIX based USB Ethernet adapter with two PHYs: internal and
> external. The internal PHY is enabled by default and there seems to be
> no way to disable internal PHY on the MAC level without affecting the
> external PHY.
> 
> What is the preferred method to suspend internal PHY?
> Currently I have following options:
> - suspend PHY in the probe function of the PHY driver
> - get the phydev in the MAC driver and call phy_suspend()
> - whisper magic numbers from the MAC driver directly this the MDIO bus.
> 
> Are there other options?

Hi Oleksij

Can you unique identity this device? Does it have a custom VID:PID?

It seems like suspending it in the PHY driver would be messy. How do
you identify the PHY is part of your devices and should be suspended?

Doing it from the MAC driver seems better, your identification
information is close to hand.

I would avoid the magic numbers, since phy_suspend() makes it clear
what you are doing.

Is there one MDIO bus with two devices, or two MDIO busses?  If there
are two busses, you could maybe add an extra flag to the bus structure
you pass to mdiobus_register() which indicates it should suspend all
PHY it finds on the bus during enumeration of the bus. Generally we
don't want this, if the PHY has link already we want to keep it, to
avoid the 1.5s delay causes by autoneg. But if we know the PHYs on the
bus are not going to be used, it would be a good point to suspend
them.

    Andrew
