Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BB62E7A45
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 16:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgL3PYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 10:24:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgL3PYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 10:24:25 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kudK6-00F2yp-6X; Wed, 30 Dec 2020 16:23:38 +0100
Date:   Wed, 30 Dec 2020 16:23:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marc Zyngier <maz@kernel.org>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Subject: Re: Registering IRQ for MT7530 internal PHYs
Message-ID: <X+ybeg4dvR5Vq8LY@lunn.ch>
References: <20201230042208.8997-1-dqfext@gmail.com>
 <441a77e8c30927ce5bc24708e1ceed79@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <441a77e8c30927ce5bc24708e1ceed79@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 09:42:09AM +0000, Marc Zyngier wrote:
> > +static irqreturn_t
> > +mt7530_irq(int irq, void *data)
> > +{
> > +	struct mt7530_priv *priv = data;
> > +	bool handled = false;
> > +	int phy;
> > +	u32 val;
> > +
> > +	val = mt7530_read(priv, MT7530_SYS_INT_STS);
> > +	mt7530_write(priv, MT7530_SYS_INT_STS, val);
> 
> If that is an ack operation, it should be dealt with as such in
> an irqchip callback instead of being open-coded here.

Hi Qingfang

Does the PHY itself have interrupt control and status registers?

My experience with the Marvell Switch and its embedded PHYs is that
the PHYs are just the same as the discrete PHYs. There are bits to
enable different interrupts, and there are status bits indicating what
event caused the interrupt. Clearing the interrupt in the PHY clears
the interrupt in the switch interrupt controller. So in the mv88e6xxx
interrupt code, you see i do a read of the switch interrupt controller
status register, but i don't write to it as you have done.

       Andrew
