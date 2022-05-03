Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DD4519156
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 00:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243605AbiECWZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 18:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbiECWZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 18:25:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D533207E;
        Tue,  3 May 2022 15:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cyYPUnPEmzGTg5m1FeQ2xC54M04KV7p5IxplEiahWqM=; b=IhIlZO6ZUXqG6AZbBTPEGYDyk3
        B4ta5OC9hjKkypfMnKPthg1AOMDmpru3f67eLB2m8gs8lCKxgnEEnOmL0ZGahSrcYGKHxOuPuTT/q
        kHjeiIg8RCMq3dMePbENC+CVw0GTiMjKwbWSmi0MLPKc9sA1zQqOQwHDkCUdD3qxQnzU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nm0tX-0016zF-3O; Wed, 04 May 2022 00:21:23 +0200
Date:   Wed, 4 May 2022 00:21:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>
Subject: Re: [PATCH net-next v2 3/7] usbnet: smsc95xx: Don't reset PHY behind
 PHY driver's back
Message-ID: <YnGq401sOeC0zwt6@lunn.ch>
References: <cover.1651574194.git.lukas@wunner.de>
 <f78b5f725fe75265f884ef0b35389fd45cd81471.1651574194.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f78b5f725fe75265f884ef0b35389fd45cd81471.1651574194.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 03:15:03PM +0200, Lukas Wunner wrote:
> smsc95xx_reset() resets the PHY behind the PHY driver's back, which
> seems like a bad idea generally.  Remove that portion of the function.
> 
> We're about to use PHY interrupts instead of polling to detect link
> changes on SMSC LAN95xx chips.  Because smsc95xx_reset() is called from
> usbnet_open(), PHY interrupt settings are lost whenever the net_device
> is brought up.
> 
> There are two other callers of smsc95xx_reset(), namely smsc95xx_bind()
> and smsc95xx_reset_resume(), and both may indeed benefit from a PHY
> reset.  However they already perform one through their calls to
> phy_connect_direct() and phy_init_hw().
> 
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
> Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: Martyn Welch <martyn.welch@collabora.com>
> Cc: Gabriel Hojda <ghojda@yo2urs.ro>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
