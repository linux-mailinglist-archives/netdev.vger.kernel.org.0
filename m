Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0749653DF52
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 03:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351951AbiFFB2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 21:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348931AbiFFB2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 21:28:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94B36562;
        Sun,  5 Jun 2022 18:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=v2/b5FqxV2iRhS1Ykan9Lwjt+zRuUcpsfnrGF+r1rwo=; b=ahtDNE/A9/2Pzy2ITsWjUxwbex
        4iUrMeJfGWfXjeG0gSwGcbTtXtdOX4F2c8Nkv9fpscSwVzdT0JJl1Vg9UdaHn5+hXcDItYdoyxiey
        +QvwzIs4ulACjTMF0Fk+1kJBPDCITFsirVPIQVkeZf/KsgEJIHD8RXT2IOPfkZFxQ5es=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ny1XL-005hL6-Hk; Mon, 06 Jun 2022 03:28:07 +0200
Date:   Mon, 6 Jun 2022 03:28:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
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
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY interrupts
 to PHY driver to avoid polling
Message-ID: <Yp1YJ3lHTFFdRb6P@lunn.ch>
References: <cover.1652343655.git.lukas@wunner.de>
 <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
 <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
 <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
 <20220519190841.GA30869@wunner.de>
 <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
 <20220523094343.GA7237@wunner.de>
 <Yowv95s7g7Ou5U8J@lunn.ch>
 <20220524121341.GA10702@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524121341.GA10702@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> mdio_bus_phy_resume() does trigger the state machine via
> phy_start_machine(), so link state changes *are* detected after wakeup.
> 
> But you're saying that's not sufficient and you really want the
> PHY driver's IRQ handler to be called, do I understand that correctly?

It is an interrupt, so i would expect the handler to be called. I've
never looked deeply how the kernel handles this, but maybe there is
some core support for this. The kernel does know about wake up
interrupts. The interesting bit is how do you defer the interrupt
until you have enough of the system running again you can actually
service the interrupt.

PHY interrupts mostly are level, not edge, because there are multiple
sources of interrupts within the PHY. So you do need to clear the
interrupt source, or you are going to get a storm, as you pointed out.
But being a level might actually help you. It fires once to get you
out of sleep, and then fires again when the interrupt controller is
resumed and is enabled.

	  Andrew
 
