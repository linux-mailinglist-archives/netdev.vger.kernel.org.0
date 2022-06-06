Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF6753E0DB
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 08:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiFFFxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 01:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiFFFx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 01:53:26 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DFF2F02F;
        Sun,  5 Jun 2022 22:53:22 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id D146D3004DAB5;
        Mon,  6 Jun 2022 07:53:20 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id C630C5EFBF; Mon,  6 Jun 2022 07:53:20 +0200 (CEST)
Date:   Mon, 6 Jun 2022 07:53:20 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        netdev@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH net] net: phy: Don't trigger state machine while in
 suspend
Message-ID: <20220606055320.GA31220@wunner.de>
References: <688f559346ea747d3b47a4d16ef8277e093f9ebe.1653556322.git.lukas@wunner.de>
 <Yp1bIdwLjiLftWgW@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp1bIdwLjiLftWgW@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 06, 2022 at 03:40:49AM +0200, Andrew Lunn wrote:
> > +	if (phy_interrupt_is_valid(phydev)) {
> > +		phydev->irq_suspended = 0;
> > +		synchronize_irq(phydev->irq);
> > +
> > +		/* Rerun interrupts which were postponed by phy_interrupt()
> > +		 * because they occurred during the system sleep transition.
> > +		 */
> > +		if (phydev->irq_rerun) {
> > +			phydev->irq_rerun = 0;
> > +			enable_irq(phydev->irq);
> > +			irq_wake_thread(phydev->irq, phydev);
> > +		}
> > +	}
> 
> As i said in a previous thread, PHY interrupts are generally level,
> not edge. So when you call enable_irq(phydev->irq), doesn't it
> immediately fire?

Yes, if the interrupt is indeed level and the PHY is capable of
remembering that an interrupt occurred while the system was suspended
or was about to be suspended.

The irq_wake_thread() ensures that the IRQ handler is called,
should one of those conditions *not* be met.

Recall that phylib uses irq_default_primary_handler() as hardirq
handler.  That handler does nothing else but wake the IRQ thread,
which runs phy->handle_interrupt() in task context.

The irq_wake_thread() above likewise wakes the IRQ thread,
i.e. it tells the scheduler to put it on the run queue.

If, as you say, the interrupt is level and fires upon enable_irq(),
the result is that the scheduler is told twice to put the IRQ thread
on the run queue.  Usually this will happen faster than the IRQ thread
actually gets scheduled, so it will only run once.

In the unlikely event that the IRQ thread gets scheduled before the
call to irq_wake_thread(), the IRQ thread will run twice.
However, that's harmless.  IRQ handlers can cope with that.


> You need to first call the handler, and then re-enable the interrupt.

I guess I could call phy_interrupt() before the enable_irq(),
in lieu of irq_wake_thread().

However, it would mean that I'd invoke the IRQ handler behind the back
of the generic irq code.  That doesn't feel quite right.
Calling irq_wake_thread() is the correct way if one wants to be
compliant with the generic irq code's expectations.

If you feel strongly about it I can make that change but I would
advise against it.  Let me know what you think.

Thanks,

Lukas
