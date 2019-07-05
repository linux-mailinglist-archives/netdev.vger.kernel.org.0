Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D80607F8
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 16:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfGEOgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 10:36:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56228 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfGEOgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 10:36:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=38NEboaXdSeyWuU7v89kKFG7xDV4dw3xD2Yt889bIMo=; b=sW94YvLDJYgfKhHmEGFEwV24QV
        EM563sTsqO+Vudy4k9sNYTjx2yZrfrfLCAOC6c/5Y2Q5CDGBPFsTlRdT/rIVfPPMVoyG/DXY3rbUw
        mBsE+7Y4oqASqGm6z6zuunePmGlS6g+oHTVTkxkAL6+xGW9JUTc8iSVB4wk6R/it0dos=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hjPKR-0001ZC-BZ; Fri, 05 Jul 2019 16:36:47 +0200
Date:   Fri, 5 Jul 2019 16:36:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: i.mx6ul with DSA in multi chip addressing mode - no MDIO access
Message-ID: <20190705143647.GC4428@lunn.ch>
References: <21680b63-2d87-6841-23eb-551e58866719@eks-engel.de>
 <20190703155518.GE18473@lunn.ch>
 <d1181129-ec9d-01c1-3102-e1dc5dec0378@eks-engel.de>
 <20190704132756.GB13859@lunn.ch>
 <00b365da-9c7a-a78a-c10a-f031748e0af7@eks-engel.de>
 <20190704155347.GJ18473@lunn.ch>
 <ba64f1f9-14c7-2835-f6e7-0dd07039fb18@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba64f1f9-14c7-2835-f6e7-0dd07039fb18@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 02:41:43PM +0200, Benjamin Beckmeyer wrote:
> >> &mdio0 {
> >>         interrupt-parent = <&gpio1>;
> >>         interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
> >>
> >>         switch0: switch0@2 {
> >>                 compatible = "marvell,mv88e6190";
> >>                 reg = <2>;
> >>                 pinctrl-0 = <&pinctrl_gpios>;
> >>                 reset-gpios = <&gpio4 16 GPIO_ACTIVE_LOW>;
> >>                 dsa,member = <0 0>;
> > This is wrong. The interrupt is a switch property, not an MDIO bus
> > property. So it belongs inside the switch node.
> >
> > 	  Andrew
> 
> Hi Andrew,
> 
> in the documentation for Marvell DSA the interrupt properties are in 
> the MDIO part. Maybe the documentation for device tree is wrong or 
> unclear?

Ah. Yes. The documentation is wrong. I will fix that.

> 
> I switched to the kernel 5.1.16 to take advantage of your new code.
> At the moment I deleted all interrupt properties from my device tree 
> and if I get you right now the access should be trigger all 100ms but 
> I have accesses within the tracing about 175 times a second.
> 
> Here is a snip from my trace without IRQ
> 2188000.etherne-223   [000] ....   109.932406: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x40a8
>  2188000.etherne-223   [000] ....   109.932501: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b64
>  2188000.etherne-223   [000] ....   109.933113: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9b60
>  2188000.etherne-223   [000] ....   109.933261: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
>  2188000.etherne-223   [000] ....   109.933359: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0xc801

>  2188000.etherne-223   [000] ....   110.041683: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
>  2188000.etherne-223   [000] ....   110.041817: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9b60
>  2188000.etherne-223   [000] ....   110.041919: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
>  2188000.etherne-223   [000] ....   110.042025: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0xc801

These four access are one switch register access. The first read will
be checking that the busy bit is not set. The second sets up a read to
switch register 0x00 device address 1b, i.e. global 1. So this is the
interrupt status register. The third read is checking that the busy
bit is cleared. And the last is the actual value of the register.

> 
> Am I doing it right with the tracing points? I run just
> 
> echo 1 > /sys/kernel/debug/tracing/events/mdio/mdio_access/enable
> cat /sys/kernel/debug/tracing/trace

That looks correct.

I think you are going to have to parse the register writes/reads to
figure out what switch registers it is accessing. That should
hopefully make it clearer why it is making so many accesses.

> Here is the another device tree I tried, but with this I get accesses 
> on the bus in about every 50 microseconds!
> 
> --snip
> &mdio0 {
>         switch0: switch0@2 {
>                 compatible = "marvell,mv88e6190";
>                 reg = <2>;
>                 pinctrl-0 = <&pinctrl_switch_irq>;
>                 interrupt-parent = <&gpio1>;
>                 interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
>                 interrupt-controller;
>                 #interrupt-cells = <2>;
>                 dsa,member = <0 0>;
> 
>                 ports {
>                         #address-cells = <1>;
>                         #size-cells = <0>;
> --snip

That looks sensible.

     Andrew
