Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B712B51E011
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442556AbiEFUUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 16:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442766AbiEFUUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 16:20:40 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8970D6A073;
        Fri,  6 May 2022 13:16:49 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 97440102F6752;
        Fri,  6 May 2022 22:16:47 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 6F514119CF2; Fri,  6 May 2022 22:16:47 +0200 (CEST)
Date:   Fri, 6 May 2022 22:16:47 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
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
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>
Subject: Re: [PATCH net-next v2 5/7] usbnet: smsc95xx: Forward PHY interrupts
 to PHY driver to avoid polling
Message-ID: <20220506201647.GA30860@wunner.de>
References: <cover.1651574194.git.lukas@wunner.de>
 <c6b7f4e4a17913d2f2bc4fe722df0804c2d6fea7.1651574194.git.lukas@wunner.de>
 <20220505113207.487861b2@kernel.org>
 <20220505185328.GA14123@wunner.de>
 <87tua36i70.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tua36i70.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 11:58:43AM +0100, Marc Zyngier wrote:
> On Thu, 05 May 2022 19:53:28 +0100, Lukas Wunner <lukas@wunner.de> wrote:
> > On Thu, May 05, 2022 at 11:32:07AM -0700, Jakub Kicinski wrote:
> > > On Tue, 3 May 2022 15:15:05 +0200 Lukas Wunner wrote:
> > > > @@ -608,11 +618,20 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
> > > >  	intdata = get_unaligned_le32(urb->transfer_buffer);
> > > >  	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
> > > >  
> > > > +	/* USB interrupts are received in softirq (tasklet) context.
> > > > +	 * Switch to hardirq context to make genirq code happy.
> > > > +	 */
> > > > +	local_irq_save(flags);
> > > > +	__irq_enter_raw();
> > > > +
> > > >  	if (intdata & INT_ENP_PHY_INT_)
> > > > -		;
> > > > +		generic_handle_domain_irq(pdata->irqdomain, PHY_HWIRQ);
> > > >  	else
> > > >  		netdev_warn(dev->net, "unexpected interrupt, intdata=0x%08X\n",
> > > >  			    intdata);
> > > > +
> > > > +	__irq_exit_raw();
> > > > +	local_irq_restore(flags);
> > > 
> > > Full patch:
> > > 
> > > https://lore.kernel.org/all/c6b7f4e4a17913d2f2bc4fe722df0804c2d6fea7.1651574194.git.lukas@wunner.de/
> > 
> > This is basically identical to what drivers/net/usb/lan78xx.c does
> > in lan78xx_status(), except I'm passing the hw irq instead of the
> > linux irq to genirq code, thereby avoiding the overhead of a
> > radix_tree_lookup().
> > 
> > generic_handle_domain_irq() warns unconditionally on !in_irq(),
> > unlike handle_irq_desc(), which constrains the warning to
> > handle_enforce_irqctx() (i.e. x86 APIC, arm GIC/GICv3).
> > Perhaps that's an oversight in generic_handle_domain_irq(),
> > unless __irq_resolve_mapping() becomes unsafe outside in_irq()
> > for some reason...
> > 
> > In any case the unconditional in_irq() necessitates __irq_enter_raw()
> > here.
> > 
> > And there's no _safe variant() of generic_handle_domain_irq()
> > (unlike generic_handle_irq_safe() which was recently added by
> > 509853f9e1e7), hence the necessity of an explicit local_irq_save().
> 
> Please don't directly use __irq_enter_raw() and similar things
> directly in driver code (it doesn't do anything related to RCU, for
> example, which could be problematic if used in arbitrary contexts).
> Given how infrequent this interrupt is, I'd rather you use something
> similar to what lan78xx is doing, and be done with it.
> 
> And since this is a construct that seems to be often repeated, why
> don't you simply make the phy interrupt handling available over a
> smp_call_function() interface, which would always put you in the
> correct context and avoid faking things up?

As I've explained in the commit message (linked above), LAN95xx chips
have 11 GPIOs which can be an interrupt source.  This patch adds
PHY interrupt support in such a way that GPIO interrupts can easily
be supported by a subsequent commit.  To this end, LAN95xx needs
to be represented as a proper irqchip.

The crucial thing to understand is that a USB interrupt is not received
as a hardirq.  USB gadgets are incapable of directly signaling an
interrupt because they cannot initiate a bus transaction by themselves.
All communication on the bus is initiated by the host controller,
which polls a gadget's Interrupt Endpoint in regular intervals.
If an interrupt is pending, that information is passed up the stack
in softirq context.  Hence there's no other way than "faking things up",
to borrow your language.

Another USB driver in the tree, drivers/gpio/gpio-dln2.c, likewise
represents the USB gadget as an irqchip to signal GPIO interrupts.
This shows that LAN95xx is not an isolated case.  gpio-dln2.c does
not invoke __irq_enter_raw(), so I think users will now see a WARN
splat with that driver since Mark Rutland's 0953fb263714 (+cc).

As I've pointed out above, it seems like an oversight that Mark
didn't make the WARN_ON_ONCE() conditional on handle_enforce_irqctx()
(as handle_irq_desc() does).  Sadly you did not respond to that
observation.  Please clarify whether that is indeed erroneous.
Once handle_enforce_irqctx() is added to generic_handle_domain_irq(),
there's no need for me to call __irq_enter_raw().  Problem solved.

Should there be a valid reason for the missing handle_enforce_irqctx(),
then I propose adding a generic_handle_domain_irq_safe() function which
calls __irq_enter_raw() (or probably __irq_enter() to get accounting),
thereby resolving your objection to calling __irq_enter_raw() from a
driver.

Thanks,

Lukas
