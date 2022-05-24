Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60963532A24
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbiEXMNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiEXMNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:13:46 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FCA6F493;
        Tue, 24 May 2022 05:13:45 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 8603D3000CAF5;
        Tue, 24 May 2022 14:13:41 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 798FC232106; Tue, 24 May 2022 14:13:41 +0200 (CEST)
Date:   Tue, 24 May 2022 14:13:41 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <20220524121341.GA10702@wunner.de>
References: <cover.1652343655.git.lukas@wunner.de>
 <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
 <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
 <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
 <20220519190841.GA30869@wunner.de>
 <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
 <20220523094343.GA7237@wunner.de>
 <Yowv95s7g7Ou5U8J@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yowv95s7g7Ou5U8J@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 03:08:07AM +0200, Andrew Lunn wrote:
> > @@ -976,6 +977,25 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
> >  	struct phy_driver *drv = phydev->drv;
> >  	irqreturn_t ret;
> >  
> > +	if (IS_ENABLED(CONFIG_PM_SLEEP) &&
> > +	    (phydev->mdio.dev.power.is_prepared ||
> > +	     phydev->mdio.dev.power.is_suspended)) {
> > +		struct net_device *netdev = phydev->attached_dev;
> > +
> > +		if (netdev) {
> > +			struct device *parent = netdev->dev.parent;
> > +
> > +			if (netdev->wol_enabled)
> > +				pm_system_wakeup();
> > +			else if (device_may_wakeup(&netdev->dev))
> > +				pm_wakeup_dev_event(&netdev->dev, 0, true);
> > +			else if (parent && device_may_wakeup(parent))
> > +				pm_wakeup_dev_event(parent, 0, true);
> > +		}
> > +
> > +		return IRQ_HANDLED;
> 
> I'm not sure you can just throw the interrupt away. There have been
> issues with WoL, where the WoL signal has been applied to a PMC, not
> an actual interrupt. Yet the PHY driver assumes it is an
> interrupt. And in order for WoL to work correctly, it needs the
> interrupt handler to be called. We said the hardware is broken, WoL
> cannot work for that setup.
> 
> Here you have correct hardware, but you are throwing the interrupt
> away, which will have the same result. So i think you need to abort
> the suspend, get the bus working again, and call the interrupt
> handler. If this is a WoL interrupt you are supposed to be waking up
> anyway.

mdio_bus_phy_resume() does trigger the state machine via
phy_start_machine(), so link state changes *are* detected after wakeup.

But you're saying that's not sufficient and you really want the
PHY driver's IRQ handler to be called, do I understand that correctly?

That could be achieved with a flag indicating that the IRQ handler
needs to be rerun after resume.  A simple invocation of irq_wake_thread()
will then achieve that.

It has also occurred to me that not clearing the IRQ may lead to
an interrupt storm if it's level-triggered.  So I need to disable
the IRQ and re-enable it after the PHY has been resumed.
Back to the drawing board...

Thanks,

Lukas
