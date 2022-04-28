Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C28513EF3
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 01:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353224AbiD1XUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 19:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiD1XU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 19:20:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A2840935;
        Thu, 28 Apr 2022 16:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=810WVWqP/hZF1NMKzf5cATOlxW75bWI6UJtYB2eczzg=; b=4AQnes1B0vsSlqlcfMiO57RV7j
        QvPbQxQQwd+ZompegfVs1Gr6w3fgp+yav0rRZq2aW03tK1pIUxmZfUjxX5UzP44Tq1VSajsjnrKRx
        TIbb/ThR0jVVGBb0Uo/UfbNKtHXiemu2x6zBcYuCGpCBJU7x3NUEVzEOEDEgJeGOHScs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkDNn-000OKv-Bo; Fri, 29 Apr 2022 01:17:11 +0200
Date:   Fri, 29 Apr 2022 01:17:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: Single chip mode detection for
 MV88E6*41
Message-ID: <Ymsgd2We8m8G8Oab@lunn.ch>
References: <20220427130928.540007-1-nathan@nathanrossi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427130928.540007-1-nathan@nathanrossi.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 01:09:28PM +0000, Nathan Rossi wrote:
> The mv88e6xxx driver expects switches that are configured in single chip
> addressing mode to have the MDIO address configured as 0. This is due to
> the switch ADDR pins representing the single chip addressing mode as 0.
> However depending on the device (e.g. MV88E6*41) the switch does not
> respond on address 0 or any other address below 16 (the first port
> address) in single chip addressing mode. This allows for other devices
> to be on the same shared MDIO bus despite the switch being in single
> chip addressing mode.
> 
> When using a switch that works this way it is not possible to configure
> switch driver as single chip addressing via device tree, along with
> another MDIO device on the same bus with address 0, as both devices
> would have the same address of 0 resulting in mdiobus_register_device
> -EBUSY errors for one of the devices with address 0.
> 
> In order to support this configuration the switch node can have its MDIO
> address configured as 16 (the first address that the device responds
> to). During initialization the driver will treat this address similar to
> how address 0 is, however because this address is also a valid
> multi-chip address (in certain switch models, but not all) the driver
> will configure the SMI in single chip addressing mode and attempt to
> detect the switch model. If the device is configured in single chip
> addressing mode this will succeed and the initialization process can
> continue. If it fails to detect a valid model this is because the switch
> model register is not a valid register when in multi-chip mode, it will
> then fall back to the existing SMI initialization process using the MDIO
> address as the multi-chip mode address.
> 
> This detection method is safe if the device is in either mode because
> the single chip addressing mode read is a direct SMI/MDIO read operation
> and has no side effects compared to the SMI writes required for the
> multi-chip addressing mode.
> 
> In order to implement this change, the reset gpio configuration is moved
> to occur before any SMI initialization. This ensures that the device has
> the same/correct reset gpio state for both mv88e6xxx_smi_init calls.
> 
> Signed-off-by: Nathan Rossi <nathan@nathanrossi.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
