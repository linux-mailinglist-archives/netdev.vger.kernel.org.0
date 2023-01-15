Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413B466B2C7
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 18:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjAORJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 12:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjAORJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 12:09:03 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A3FEC6F;
        Sun, 15 Jan 2023 09:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xcGDRvIuxSmaSJIq4TqUe1josU14aL1vQIC0jCXCjm0=; b=XILmlXo/J/QDvQvyWWaANCra0q
        /ktr5tlqxqfAz/buepAUzprxZXb2yJAL4kafwTJs+7XenD++Yu5GWzcZq9OB9L7hbl52OWiimmnEo
        kv5IyDqCXs1lFkPgWTczbzV4cYNo4ckBgz9okRO744jpQtfbVQQgkvTbYFM37Ajd+jRQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pH6V1-0028wn-Fj; Sun, 15 Jan 2023 18:08:51 +0100
Date:   Sun, 15 Jan 2023 18:08:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pierluigi Passaro <pierluigi.passaro@gmail.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8QzI2VUY6//uBa/@lunn.ch>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230115161006.16431-1-pierluigi.p@variscite.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 05:10:06PM +0100, Pierluigi Passaro wrote:
> When the reset gpio is defined within the node of the device tree
> describing the PHY, the reset is initialized and managed only after
> calling the fwnode_mdiobus_phy_device_register function.
> However, before calling it, the MDIO communication is checked by the
> get_phy_device function.
> When this happen and the reset GPIO was somehow previously set down,
> the get_phy_device function fails, preventing the PHY detection.
> These changes force the deassert of the MDIO reset signal before
> checking the MDIO channel.
> The PHY may require a minimum deassert time before being responsive:
> use a reasonable sleep time after forcing the deassert of the MDIO
> reset signal.
> Once done, free the gpio descriptor to allow managing it later.

This has been discussed before. The problem is, it is not just a reset
GPIO. There could also be a clock which needs turning on, a regulator,
and/or a linux reset controller. And what order do you turn these on?

The conclusions of the discussion is you assume the device cannot be
found by enumeration, and you put the ID in the compatible. That is
enough to get the driver to load, and the driver can then turn
everything on in the correct order, with the correct delays, etc.

I think there has been some work on generic power sequencing. I've not
being following it, so i've no idea how far it has got. If that could
be used to solve this problem for all the possible controls of a PHY,
i would be open for such patches.

      Andrew
