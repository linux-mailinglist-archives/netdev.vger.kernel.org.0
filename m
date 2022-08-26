Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F3B5A2FBC
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 21:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344005AbiHZTL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 15:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiHZTL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 15:11:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F3C9752D;
        Fri, 26 Aug 2022 12:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=D2FZxcQC9y0keHeh1Gz35sboDmYEDxmnU4IkfnpBHxE=; b=KalePySq2NWzhZcgB7bfe9ZWFt
        wF+vz6mrG3Alp+vjclDWbf+52PeCbRz/VCduDfEeRn8TF3H2v9Si/PY7mflmmRo/LawsgiHSi5nBp
        gFRvquSZ/Xh9ZKL0jELUq5iZKVNVubPEhga3wC1MaPllHDgHY36iop5zNOl1apPcBGY8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRek0-00EiV3-Tc; Fri, 26 Aug 2022 21:11:40 +0200
Date:   Fri, 26 Aug 2022 21:11:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun.Ramadoss@microchip.com
Cc:     olteanv@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, Tristram.Ha@microchip.com,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [RFC Patch net-next v2] net: dsa: microchip: lan937x: enable
 interrupt for internal phy link detection
Message-ID: <Ywka7MuutP93wIv2@lunn.ch>
References: <20220822092017.5671-1-arun.ramadoss@microchip.com>
 <YwOAxh7Bc12OornD@lunn.ch>
 <b1e66b49e8006bd7dcb3fd74d5185db807e5a9f6.camel@microchip.com>
 <YwTlKnpgMRp2Nugm@lunn.ch>
 <650478ca37c09c91566784db2b496838a15d567c.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <650478ca37c09c91566784db2b496838a15d567c.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 04:21:39PM +0000, Arun.Ramadoss@microchip.com wrote:
> Hi Andrew,
> Thanks for the reply.
> 
> On Tue, 2022-08-23 at 16:33 +0200, Andrew Lunn wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > 
> > 
> https://elixir.bootlin.com/linux/latest/source/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts#L93
> > 
> > Doing it this way is however very verbose. I later discovered a short
> > cut:
> > 
> > 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/dsa/mv88e6xxx/global2.c#L1164
> > 
> > by setting mdiobus->irq[] to the interrupt number, phylib will
> > automatically use the correct interrupt without needing an DT.
> > 
> >         Andrew
> 
> In LAN937x, register REG_SW_PORT_INT_MASK__4 BIT7:0 used to
> enable/disable the interrupts for each port. It is the global interrupt
> enable for ports. In turn each port has REG_PORT_INT_MASK register,
> which enable/disable interrupts like PTP, PHY (BIT 1). And in turn for
> each phy it has different interrupts like link up, link down etc.
> 
> As per your suggestion, I enabled the global_irq domain for each port
> and port_irq domain for port 1 alone and the corresponding mdio irq is
> updated. The dts is updated with *only one user port*. And it is
> working as expected.
> 
> How can I extend the above procedure for remaining ports 2 -8. Do I
> need to create the array of port_irq[8] domain. But when I analyzed
> code flow, if the port_irq_thread is triggered it has function
> parameter as irq only. From this irq how can we derive the parent irq
> i.e from which port is triggered. Only if I know the port, then I can
> read the corresponding status register and check if the interrupt is
> from phy or ptp etc.
> 
> Can you suggest how to enable irq_domain for the each port and find out
> the phy interrupt. So that it can be extended further in our ptp
> interrupt based implementation. 

You need an interrupt controller per port.

Your top level interrupt controller should be pretty similar to the
mv88e6xxx global 1.

However, your need to create a second level interrupt controller per
port.

This is where mv88e6xxx creates its one second level interrupt
controller:

https://elixir.bootlin.com/linux/latest/source/drivers/net/dsa/mv88e6xxx/global2.c#L1135

Rather than finding the mapping for a fixed interrupt number, you need
to get the mapping for the specific port you are creating the
interrupt controller for.

In the end you will have a tree of interrupt controllers, where as
mv88e6xxx just has a chain.

Here is what mv88e6xxx looks like:

 47:          0  gpio-vf610  27 Level     mv88e6xxx-mdio_mux-0.1:00
 51:          0  mv88e6xxx-g1   3 Edge      mv88e6xxx-mdio_mux-0.1:00-g1-atu-prob
 53:          0  mv88e6xxx-g1   5 Edge      mv88e6xxx-mdio_mux-0.1:00-g1-vtu-prob
 55:          0  mv88e6xxx-g1   7 Edge      mv88e6xxx-mdio_mux-0.1:00-g2
 57:          0  mv88e6xxx-g2   0 Edge      !mdio-mux!mdio@1!switch@0!mdio:00
 58:          0  mv88e6xxx-g2   1 Edge      !mdio-mux!mdio@1!switch@0!mdio:01
 59:          0  mv88e6xxx-g2   2 Edge      !mdio-mux!mdio@1!switch@0!mdio:02
 72:          0  mv88e6xxx-g2  15 Edge      mv88e6xxx-mdio_mux-0.1:00-watchdog

Interrupt 47 is the GPIO line the switch it attached to. Interrupts 51
and 53 are handlers registered to the top level interrupt
controller. Interrupt 55 is the chain into the second level interrupt
handler. Interrupts 57-59 are PHY interrupts in the second level
interrupt controller, and interrupt 72 is also part of the second level.

For you, you will have a chain interrupt in the top level for each
port, rather than the single 55 interrupt here.

Build the tree and it should all work.

But make sure you turn on lockdep. I took me a while to get all the
locking correct with mv88e6xxx_reg_lock(). Maybe you wont face this
problem with the ksz driver, its locking could be different.

As to your question about knowing where the interrupt came from, you
can see in:

https://elixir.bootlin.com/linux/latest/source/drivers/net/dsa/mv88e6xxx/global2.c#L1026

that the interrupt handler gets called with a void * dev_id. For
mv88e6xxx this points to the chip structure. You can make it point to
the port structure. This is the last parameter you pass to
request_threaded_irq().

      Andrew
