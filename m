Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A41053E8CF
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbiFFMUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 08:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236687AbiFFMUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 08:20:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D49E293813;
        Mon,  6 Jun 2022 05:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=k91bT1N8yxequJ8D47/cEksqjIzn/6bC6J3tuBiRZt8=; b=trSotSK3l0aZiKM6M9WdJFBrOy
        6T5iYqiTx8oGUmpvyT0c8hGx8N5XR8AUyuwQ823vJ/SUaov4vTDl4Q1D2Aaps2hmxYg+9xil7BzIl
        h3ISYhMt3X/Vs8poUujblRTaqaXA4y9axo4fm0fhYA2HEm9FDms51Wlj3jFdlZnkL17g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nyBhr-005mNC-PM; Mon, 06 Jun 2022 14:19:39 +0200
Date:   Mon, 6 Jun 2022 14:19:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
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
Message-ID: <Yp3w23hnUsBFFafu@lunn.ch>
References: <688f559346ea747d3b47a4d16ef8277e093f9ebe.1653556322.git.lukas@wunner.de>
 <Yp1bIdwLjiLftWgW@lunn.ch>
 <20220606055320.GA31220@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606055320.GA31220@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 06, 2022 at 07:53:20AM +0200, Lukas Wunner wrote:
> On Mon, Jun 06, 2022 at 03:40:49AM +0200, Andrew Lunn wrote:
> > > +	if (phy_interrupt_is_valid(phydev)) {
> > > +		phydev->irq_suspended = 0;
> > > +		synchronize_irq(phydev->irq);
> > > +
> > > +		/* Rerun interrupts which were postponed by phy_interrupt()
> > > +		 * because they occurred during the system sleep transition.
> > > +		 */
> > > +		if (phydev->irq_rerun) {
> > > +			phydev->irq_rerun = 0;
> > > +			enable_irq(phydev->irq);
> > > +			irq_wake_thread(phydev->irq, phydev);
> > > +		}
> > > +	}
> > 
> > As i said in a previous thread, PHY interrupts are generally level,
> > not edge. So when you call enable_irq(phydev->irq), doesn't it
> > immediately fire?
> 
> Yes, if the interrupt is indeed level and the PHY is capable of
> remembering that an interrupt occurred while the system was suspended
> or was about to be suspended.

It should remember, in the WoL case. It keeps it power etc.

> The irq_wake_thread() ensures that the IRQ handler is called,
> should one of those conditions *not* be met.
> 
> Recall that phylib uses irq_default_primary_handler() as hardirq
> handler.  That handler does nothing else but wake the IRQ thread,
> which runs phy->handle_interrupt() in task context.
> 
> The irq_wake_thread() above likewise wakes the IRQ thread,
> i.e. it tells the scheduler to put it on the run queue.
> 
> If, as you say, the interrupt is level and fires upon enable_irq(),
> the result is that the scheduler is told twice to put the IRQ thread
> on the run queue.  Usually this will happen faster than the IRQ thread
> actually gets scheduled, so it will only run once.
> 
> In the unlikely event that the IRQ thread gets scheduled before the
> call to irq_wake_thread(), the IRQ thread will run twice.
> However, that's harmless.  IRQ handlers can cope with that.

I'm just slightly worried about the IRQ handler returning there was
nothing to do. The IRQ core counts such interrupts, and will disable
the interrupt if nobody says it is actually handling the
interrupts. But it needs to be a few interrupts before this kicks in,
so it should be safe.

One other thought is we should probably get the IRQ Maintainers to
look this patch over. Please could you repost and Cc: them.

Thanks

   Andrew
