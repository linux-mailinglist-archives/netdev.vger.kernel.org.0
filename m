Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE40520F9B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237935AbiEJIXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237466AbiEJIW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:22:59 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9118E28E4FE;
        Tue, 10 May 2022 01:19:01 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id CCFF610029C26;
        Tue, 10 May 2022 10:18:58 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id A91422E6707; Tue, 10 May 2022 10:18:58 +0200 (CEST)
Date:   Tue, 10 May 2022 10:18:58 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <20220510081858.GA13058@wunner.de>
References: <cover.1651574194.git.lukas@wunner.de>
 <c6b7f4e4a17913d2f2bc4fe722df0804c2d6fea7.1651574194.git.lukas@wunner.de>
 <20220505113207.487861b2@kernel.org>
 <20220505185328.GA14123@wunner.de>
 <87tua36i70.wl-maz@kernel.org>
 <20220506201647.GA30860@wunner.de>
 <87ilqf6qjs.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilqf6qjs.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 09:47:19AM +0100, Marc Zyngier wrote:
> On Fri, 06 May 2022 21:16:47 +0100, Lukas Wunner <lukas@wunner.de> wrote:
> > On Fri, May 06, 2022 at 11:58:43AM +0100, Marc Zyngier wrote:
> > > On Thu, 05 May 2022 19:53:28 +0100, Lukas Wunner <lukas@wunner.de> wrote:
> > > > generic_handle_domain_irq() warns unconditionally on !in_irq(),
> > > > unlike handle_irq_desc(), which constrains the warning to
> > > > handle_enforce_irqctx() (i.e. x86 APIC, arm GIC/GICv3).
> > > > Perhaps that's an oversight in generic_handle_domain_irq(),
> > > > unless __irq_resolve_mapping() becomes unsafe outside in_irq()
> > > > for some reason...
> > > > 
> > > > In any case the unconditional in_irq() necessitates __irq_enter_raw()
> > > > here.
> > > 
> > > Please don't directly use __irq_enter_raw() and similar things
> > > directly in driver code (it doesn't do anything related to RCU, for
> > > example, which could be problematic if used in arbitrary contexts).
> > 
> > As I've pointed out above, it seems like an oversight that Mark
> > didn't make the WARN_ON_ONCE() conditional on handle_enforce_irqctx()
> > (as handle_irq_desc() does).  Sadly you did not respond to that
> > observation.
> 
> When did you make that observation? I can only see an email from you
> being sent *after* the one I am replying to.

I was referring to the above-quoted sentence:

     "generic_handle_domain_irq() warns unconditionally on !in_irq(),
      unlike handle_irq_desc(), which constrains the warning to
      handle_enforce_irqctx() (i.e. x86 APIC, arm GIC/GICv3).
      Perhaps that's an oversight in generic_handle_domain_irq(),
      unless __irq_resolve_mapping() becomes unsafe outside in_irq()
      for some reason..."

Never mind, let's focus on the problem at hand.
It's secondary who said what when.


> > Please clarify whether that is indeed erroneous.
> > Once handle_enforce_irqctx() is added to generic_handle_domain_irq(),
> > there's no need for me to call __irq_enter_raw().  Problem solved.
> 
> I don't see it as an oversight. Drivers shouldn't rely on
> architectural quirks, and it is much clearer to simply forbid
> something that cannot be guaranteed across the board, specially for
> something that is as generic as USB.

Whether a warning is warranted is not dependent on the architecture,
but on the irqchip from which an interrupt normally originates:

* Interrupt normally originates from x86 APIC or arm GIC/GICv3,
  but is synthesized in non-hardirq context:  Warning is warranted.

* Interrupt normally originates from any other top-level irqchip,
  such as irq-bcm2836.c, but is synthesized in non-hardirq context:
  Warning is a false positive!

* Interrupt is always synthesized in non-hardirq context by a
  USB irqchip: Warning is a false positive, regardless whether
  the top-level irqchip is x86 APIC, arm GIC/GICv3 or anything else!


> > Should there be a valid reason for the missing handle_enforce_irqctx(),
> > then I propose adding a generic_handle_domain_irq_safe() function which
> > calls __irq_enter_raw() (or probably __irq_enter() to get accounting),
> > thereby resolving your objection to calling __irq_enter_raw() from a
> > driver.
> 
> Feel free to submit a patch.

Done:

https://lore.kernel.org/lkml/c3caf60bfa78e5fdbdf483096b7174da65d1813a.1652168866.git.lukas@wunner.de/

I'm focussing on eliminating the false-positive warning for now.
Introducing a generic_handle_domain_irq_safe() wrapper which alleviates
drivers from calling local_irq_save() can be done in a separate step.

Thanks,

Lukas
