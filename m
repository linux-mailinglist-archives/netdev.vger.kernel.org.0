Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3964A35D451
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 02:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344263AbhDMAHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 20:07:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46964 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238214AbhDMAHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 20:07:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lW6aR-00GNup-Cv; Tue, 13 Apr 2021 02:07:23 +0200
Date:   Tue, 13 Apr 2021 02:07:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Ungerer <gerg@kernel.org>
Subject: Re: [RFC v4 net-next 2/4] net: dsa: mt7530: add interrupt support
Message-ID: <YHTgu1+6GZFdFgWJ@lunn.ch>
References: <20210412034237.2473017-1-dqfext@gmail.com>
 <20210412034237.2473017-3-dqfext@gmail.com>
 <87fszvoqvb.wl-maz@kernel.org>
 <20210412152210.929733-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412152210.929733-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static void
> > > +mt7530_setup_mdio_irq(struct mt7530_priv *priv)
> > > +{
> > > +	struct dsa_switch *ds = priv->ds;
> > > +	int p;
> > > +
> > > +	for (p = 0; p < MT7530_NUM_PHYS; p++) {
> > > +		if (BIT(p) & ds->phys_mii_mask) {
> > > +			unsigned int irq;
> > > +
> > > +			irq = irq_create_mapping(priv->irq_domain, p);
> > 
> > This seems odd. Why aren't the MDIO IRQs allocated on demand as
> > endpoint attached to this interrupt controller are being probed
> > individually? In general, doing this allocation upfront is an
> > indication that there is some missing information in the DT to perform
> > the discovery.
> 
> This is what Andrew's mv88e6xxx does, actually. In addition, I also check
> the phys_mii_mask to avoid creating mappings for unused ports.

It can be done via DT, using the standard interrupt property, so long
as you use of_mdiobus_register(np).

But when you have an 7 port switch, and a nice simple mapping, port 0
PHY using interrupt 0, you can save a lot of device tree boilerplate
by doing it in code. And when you have 4 of these switches, it gets
very boring adding all the DT to just wire up the interrupts 28
interrupts.

> Andrew, perhaps this can be done in DSA core?

Not easily. It is not always a simple mapping like this. Two of the
switches supported by mv88exxx offset the PHYs by 0x10. You really
need the switch driver involved, with its detailed knowledge of the
hardware.

	Andrew
