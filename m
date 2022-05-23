Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9867953120E
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236704AbiEWNrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 09:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236670AbiEWNrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 09:47:17 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21CD36B53;
        Mon, 23 May 2022 06:47:13 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id CA7FB300002D5;
        Mon, 23 May 2022 15:47:09 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id B900824FF4C; Mon, 23 May 2022 15:47:09 +0200 (CEST)
Date:   Mon, 23 May 2022 15:47:09 +0200
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
Message-ID: <20220523134709.GA25989@wunner.de>
References: <cover.1652343655.git.lukas@wunner.de>
 <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
 <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
 <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
 <20220519190841.GA30869@wunner.de>
 <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
 <20220523094343.GA7237@wunner.de>
 <Yot/ad/Ch7iGYnGB@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yot/ad/Ch7iGYnGB@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 02:34:49PM +0200, Andrew Lunn wrote:
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -283,8 +283,11 @@ static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
> >  	 * may call phy routines that try to grab the same lock, and that may
> >  	 * lead to a deadlock.
> >  	 */
> > -	if (phydev->attached_dev && phydev->adjust_link)
> > +	if (phydev->attached_dev && phydev->adjust_link) {
> > +		if (phy_interrupt_is_valid(phydev))
> > +			synchronize_irq(phydev->irq);
> >  		phy_stop_machine(phydev);
> > +	}
> 
> What is this hunk trying to achieve? As far as i know, interrupts have
> not been disabled. So as soon as the call to synchronize_irq()
> finishes, could well be another interrupt happens.

That other interrupt would bail out of phy_interrupt() because
the is_prepared flag is set on the PHY's struct device, see
first hunk of the patch.

The problem is that an interrupt may occur before the system
sleep transition commences.  phy_interrupt() will notice that
is_prepared is not (yet) set, hence invokes drv->handle_interrupt().
Let's say the IRQ thread is preempted at that point, the system
sleep transition is started and mdio_bus_phy_suspend() is run.
It calls phy_stop_machine(), so the state machine is now stopped.
Now phy_interrupt() continues, and the PHY driver's ->handle_interrupt()
callback starts the state machine.  Boom, that's not what we want.

So the synchronize_irq() ensures that any already running
phy_interrupt() runs to completion before phy_stop_machine()
is called.  It doesn't matter if another interrupt occurs
because then is_prepared will have been set and therefore
phy_interrupt() won't call drv->handle_interrupt().

Let me know if I haven't explained it in sufficient clarity,
I'll be happy to try again. :)

I'm more concerned about the first hunk of the patch because I'm
not sure I got the wakeup stuff right...

Thanks,

Lukas
