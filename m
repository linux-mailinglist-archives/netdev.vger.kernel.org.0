Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD515117E0
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbiD0MRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 08:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiD0MRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:17:44 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D14E7E;
        Wed, 27 Apr 2022 05:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LmNCVBBhaRJTRzXagUJoeNUWTPr5Ut4UIBScU1AasWg=; b=Ol0IzTW5rp1CfH8s1TIywaeCJK
        1BKiWJjiexpULCvrW77l7Av4bj2nMUkF8BU1AMsJ/YIycX2MV33E8q5P3E8VA13wMpDPsa0EMKnk8
        klSvw4t09bdbR1Wi9ODwtkdqpmgIL3x7VhGGnLftfv5BPsbY7jl/U8pyp2OYmyhDK2gY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njgYo-0006hk-1s; Wed, 27 Apr 2022 14:14:22 +0200
Date:   Wed, 27 Apr 2022 14:14:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 6/7] net: phy: smsc: Cache interrupt mask
Message-ID: <Ymkzno2IbyNbFrEL@lunn.ch>
References: <cover.1651037513.git.lukas@wunner.de>
 <7603f74ddc32bbaa55e9f1bea5d4024b6e376035.1651037513.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7603f74ddc32bbaa55e9f1bea5d4024b6e376035.1651037513.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 07:48:06AM +0200, Lukas Wunner wrote:
> Cache the interrupt mask to avoid re-reading it from the PHY upon every
> interrupt.  The PHY may be located on a USB device, so the additional
> read may unnecessarily increase interrupt overhead and latency.

I don't think your justification is valid. The MDIO bus is clocked at
2.5MHz. So even if you are using USB 1.1 at 12MHz, the USB overheads
are not particularly large. At 480Mbps they are pretty insignificant.

In general, we consider PHYs as slow devices, they take over 1 second
to negotiate a link and declare it up. So we don't do this sort of
micro optimization.

What i think is relevant here is that you could have an interrupt
storm going on because you don't mask interrupts? It is not a true
storm, due to the way USB works, more of a light shower. Do you have
any statistics to show this code actually reduces the amount of rain
in a significant way?

	Andrew
