Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85BE51916D
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 00:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236693AbiECW0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 18:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiECW0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 18:26:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AB742484;
        Tue,  3 May 2022 15:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QKnYIsst5p4rcFIHqz+Lm6bqq5Mjy3J2Hj5osPz4AtY=; b=a6ncGMM0zslst2OjmANW/DHbEk
        SjD5Q41qe+XMyAtotepZHYXBxRAVAtXeCahoPOrrSuyBf9ZsQZeafST8qRi5eXNBiCerwZragNs27
        tkTWXbvynAhdzX6+iGp2jSiA8ss698JiG2Fy+GqmOidv8FxznnqXW5nWeDjNqE50ZBVo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nm0vJ-00171G-AY; Wed, 04 May 2022 00:23:13 +0200
Date:   Wed, 4 May 2022 00:23:13 +0200
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
Subject: Re: [PATCH net-next v2 4/7] usbnet: smsc95xx: Avoid link settings
 race on interrupt reception
Message-ID: <YnGrUdmqtzt3Ogn+@lunn.ch>
References: <cover.1651574194.git.lukas@wunner.de>
 <e6117cf857bea9af718d8c92d9d553c8f3a35e0a.1651574194.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6117cf857bea9af718d8c92d9d553c8f3a35e0a.1651574194.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 03:15:04PM +0200, Lukas Wunner wrote:
> When a PHY interrupt is signaled, the SMSC LAN95xx driver updates the
> MAC full duplex mode and PHY flow control registers based on cached data
> in struct phy_device:
> 
>   smsc95xx_status()                 # raises EVENT_LINK_RESET
>     usbnet_deferred_kevent()
>       smsc95xx_link_reset()         # uses cached data in phydev
> 
> Simultaneously, phylib polls link status once per second and updates
> that cached data:
> 
>   phy_state_machine()
>     phy_check_link_status()
>       phy_read_status()
>         lan87xx_read_status()
>           genphy_read_status()      # updates cached data in phydev
> 
> If smsc95xx_link_reset() wins the race against genphy_read_status(),
> the registers may be updated based on stale data.
> 
> E.g. if the link was previously down, phydev->duplex is set to
> DUPLEX_UNKNOWN and that's what smsc95xx_link_reset() will use, even
> though genphy_read_status() may update it to DUPLEX_FULL afterwards.
> 
> PHY interrupts are currently only enabled on suspend to trigger wakeup,
> so the impact of the race is limited, but we're about to enable them
> perpetually.
> 
> Avoid the race by delaying execution of smsc95xx_link_reset() until
> phy_state_machine() has done its job and calls back via
> smsc95xx_handle_link_change().
> 
> Signaling EVENT_LINK_RESET on wakeup is not necessary because phylib
> picks up link status changes through polling.  So drop the declaration
> of a ->link_reset() callback.
> 
> Note that the semicolon on a line by itself added in smsc95xx_status()
> is a placeholder for a function call which will be added in a subsequent
> commit.  That function call will actually handle the INT_ENP_PHY_INT_
> interrupt.
> 
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
> Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
