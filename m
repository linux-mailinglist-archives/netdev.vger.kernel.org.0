Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B88E531FFE
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 02:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbiEXAxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 20:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiEXAxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 20:53:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B181882156;
        Mon, 23 May 2022 17:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lZ5EB2bvg1+qSag5cF3uw80Y30W33/ioePb5gnIQQv4=; b=VGr09Bretx0GoW/CvPz/eutj8f
        12lsP2UG8J7l0VvVcpkS6We5OzMkHNLlinFLEqjG2uUscL6hZ7t7RUWlKxmOqNlc5odtOgk0wRTF6
        9Nea9G56U3cgMQrXSk/559NCTH8RSCHwyt9Se1fSM5jlsbER39rVg/RrD7FBk5aYDr6U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ntImu-0042ew-IF; Tue, 24 May 2022 02:52:40 +0200
Date:   Tue, 24 May 2022 02:52:40 +0200
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
Message-ID: <YowsWE9Lxy3y4COr@lunn.ch>
References: <cover.1652343655.git.lukas@wunner.de>
 <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
 <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
 <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
 <20220519190841.GA30869@wunner.de>
 <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
 <20220523094343.GA7237@wunner.de>
 <Yot/ad/Ch7iGYnGB@lunn.ch>
 <20220523134709.GA25989@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523134709.GA25989@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 03:47:09PM +0200, Lukas Wunner wrote:
> On Mon, May 23, 2022 at 02:34:49PM +0200, Andrew Lunn wrote:
> > > --- a/drivers/net/phy/phy_device.c
> > > +++ b/drivers/net/phy/phy_device.c
> > > @@ -283,8 +283,11 @@ static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
> > >  	 * may call phy routines that try to grab the same lock, and that may
> > >  	 * lead to a deadlock.
> > >  	 */
> > > -	if (phydev->attached_dev && phydev->adjust_link)
> > > +	if (phydev->attached_dev && phydev->adjust_link) {
> > > +		if (phy_interrupt_is_valid(phydev))
> > > +			synchronize_irq(phydev->irq);
> > >  		phy_stop_machine(phydev);
> > > +	}
> > 
> > What is this hunk trying to achieve? As far as i know, interrupts have
> > not been disabled. So as soon as the call to synchronize_irq()
> > finishes, could well be another interrupt happens.
> 
> That other interrupt would bail out of phy_interrupt() because
> the is_prepared flag is set on the PHY's struct device, see
> first hunk of the patch.
> 
> The problem is that an interrupt may occur before the system
> sleep transition commences.  phy_interrupt() will notice that
> is_prepared is not (yet) set, hence invokes drv->handle_interrupt().
> Let's say the IRQ thread is preempted at that point, the system
> sleep transition is started and mdio_bus_phy_suspend() is run.
> It calls phy_stop_machine(), so the state machine is now stopped.
> Now phy_interrupt() continues, and the PHY driver's ->handle_interrupt()
> callback starts the state machine.  Boom, that's not what we want.
> 
> So the synchronize_irq() ensures that any already running
> phy_interrupt() runs to completion before phy_stop_machine()
> is called.  It doesn't matter if another interrupt occurs
> because then is_prepared will have been set and therefore
> phy_interrupt() won't call drv->handle_interrupt().
> 
> Let me know if I haven't explained it in sufficient clarity,
> I'll be happy to try again. :)

I think some comments are needed. If i don't understand what is going
on, i'm sure others don't as well.

    Andrew
