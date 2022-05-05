Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEAE51C876
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 20:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244105AbiEES5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 14:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344001AbiEES5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 14:57:14 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE6E387BF;
        Thu,  5 May 2022 11:53:31 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id B9686100D5874;
        Thu,  5 May 2022 20:53:28 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 853AD11760D; Thu,  5 May 2022 20:53:28 +0200 (CEST)
Date:   Thu, 5 May 2022 20:53:28 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
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
Message-ID: <20220505185328.GA14123@wunner.de>
References: <cover.1651574194.git.lukas@wunner.de>
 <c6b7f4e4a17913d2f2bc4fe722df0804c2d6fea7.1651574194.git.lukas@wunner.de>
 <20220505113207.487861b2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505113207.487861b2@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 11:32:07AM -0700, Jakub Kicinski wrote:
> On Tue, 3 May 2022 15:15:05 +0200 Lukas Wunner wrote:
> > @@ -608,11 +618,20 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
> >  	intdata = get_unaligned_le32(urb->transfer_buffer);
> >  	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
> >  
> > +	/* USB interrupts are received in softirq (tasklet) context.
> > +	 * Switch to hardirq context to make genirq code happy.
> > +	 */
> > +	local_irq_save(flags);
> > +	__irq_enter_raw();
> > +
> >  	if (intdata & INT_ENP_PHY_INT_)
> > -		;
> > +		generic_handle_domain_irq(pdata->irqdomain, PHY_HWIRQ);
> >  	else
> >  		netdev_warn(dev->net, "unexpected interrupt, intdata=0x%08X\n",
> >  			    intdata);
> > +
> > +	__irq_exit_raw();
> > +	local_irq_restore(flags);
> 
> IRQ maintainers could you cast your eyes over this?
> 
> Full patch:
> 
> https://lore.kernel.org/all/c6b7f4e4a17913d2f2bc4fe722df0804c2d6fea7.1651574194.git.lukas@wunner.de/

This is basically identical to what drivers/net/usb/lan78xx.c does
in lan78xx_status(), except I'm passing the hw irq instead of the
linux irq to genirq code, thereby avoiding the overhead of a
radix_tree_lookup().

generic_handle_domain_irq() warns unconditionally on !in_irq(),
unlike handle_irq_desc(), which constrains the warning to
handle_enforce_irqctx() (i.e. x86 APIC, arm GIC/GICv3).
Perhaps that's an oversight in generic_handle_domain_irq(),
unless __irq_resolve_mapping() becomes unsafe outside in_irq()
for some reason...

In any case the unconditional in_irq() necessitates __irq_enter_raw()
here.

And there's no _safe variant() of generic_handle_domain_irq()
(unlike generic_handle_irq_safe() which was recently added by
509853f9e1e7), hence the necessity of an explicit local_irq_save().

Thanks,

Lukas
