Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9353F6CC035
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbjC1NJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjC1NJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:09:35 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2890E1980;
        Tue, 28 Mar 2023 06:08:34 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ph93p-0007Z5-0i;
        Tue, 28 Mar 2023 15:08:25 +0200
Date:   Tue, 28 Mar 2023 14:08:18 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next 2/2] net: dsa: mt7530: introduce MMIO driver
 for MT7988 SoC
Message-ID: <ZCLmwm01FK7laSqs@makrotopia.org>
References: <ZCIML310vc8/uoM4@makrotopia.org>
 <a3458e6d-9a30-4ece-9586-18799f532580@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3458e6d-9a30-4ece-9586-18799f532580@lunn.ch>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Mar 28, 2023 at 03:58:50AM +0200, Andrew Lunn wrote:
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -118,6 +118,9 @@ core_write_mmd_indirect(struct mt7530_priv *priv, int prtad,
> >  	struct mii_bus *bus = priv->bus;
> >  	int ret;
> >  
> > +	if (!bus)
> > +		return 0;
> > +
> >  	/* Write the desired MMD Devad */
> >  	ret = bus->write(bus, 0, MII_MMD_CTRL, devad);
> >  	if (ret < 0)
> > @@ -147,11 +150,13 @@ core_write(struct mt7530_priv *priv, u32 reg, u32 val)
> >  {
> >  	struct mii_bus *bus = priv->bus;
> >  
> > -	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> > +	if (bus)
> > +		mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> >  
> >  	core_write_mmd_indirect(priv, reg, MDIO_MMD_VEND2, val);
> >  
> > -	mutex_unlock(&bus->mdio_lock);
> > +	if (bus)
> > +		mutex_unlock(&bus->mdio_lock);
> >  }
> >  
> >  static void
> > @@ -160,6 +165,9 @@ core_rmw(struct mt7530_priv *priv, u32 reg, u32 mask, u32 set)
> >  	struct mii_bus *bus = priv->bus;
> >  	u32 val;
> >  
> > +	if (!bus)
> > +		return;
> > +
> >  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> >  
> >  	val = core_read_mmd_indirect(priv, reg, MDIO_MMD_VEND2);
> > @@ -189,6 +197,11 @@ mt7530_mii_write(struct mt7530_priv *priv, u32 reg, u32 val)
> >  	u16 page, r, lo, hi;
> >  	int ret;
> >  
> > +	if (priv->base_addr) {
> > +		iowrite32(val, priv->base_addr + reg);
> > +		return 0;
> > +	}
> > +
> >  	page = (reg >> 6) & 0x3ff;
> >  	r  = (reg >> 2) & 0xf;
> >  	lo = val & 0xffff;
> > @@ -218,6 +231,9 @@ mt7530_mii_read(struct mt7530_priv *priv, u32 reg)
> >  	u16 page, r, lo, hi;
> >  	int ret;
> >  
> > +	if (priv->base_addr)
> > +		return ioread32(priv->base_addr + reg);
> > +
> >  	page = (reg >> 6) & 0x3ff;
> >  	r = (reg >> 2) & 0xf;
> >  
> 
> This looks pretty ugly.
> 
> A much better way to do this is to use regmap. Take a look at xrs700x
> and how it has both an i2c and an mdio version.

I agree that using regmap would be better and I have evaluated that
approach as well. As regmap doesn't allow lock-skipping and mt7530.c is
much more complex than xrs700x in the way indirect access to its MDIO bus
and interrupts work, using regmap accessors for everything would not be
trivial.

To illustrate what I'm talking about, let me show some examples in the
current code for which I don't see a way to use regmap:
634) static int
635) mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
636)                   int regnum)
637) {
638)   struct mii_bus *bus = priv->bus;
639)   struct mt7530_dummy_poll p;
640)   u32 reg, val;
641)   int ret;
642) 
643)   INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
644) 
645)   mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
646) 
647)   ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
648)                            !(val & MT7531_PHY_ACS_ST), 20, 100000);
649)   if (ret < 0) {
650)           dev_err(priv->dev, "poll timeout\n");
651)           goto out;
652)   }
653) 
654)   reg = MT7531_MDIO_CL45_ADDR | MT7531_MDIO_PHY_ADDR(port) |
655)         MT7531_MDIO_DEV_ADDR(devad) | regnum;
656)   mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
657) 
658)   ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
659)                            !(val & MT7531_PHY_ACS_ST), 20, 100000);
660)   if (ret < 0) {
661)           dev_err(priv->dev, "poll timeout\n");
662)           goto out;
663)   }
664) 
665)   reg = MT7531_MDIO_CL45_READ | MT7531_MDIO_PHY_ADDR(port) |
666)         MT7531_MDIO_DEV_ADDR(devad);
667)   mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
668) 
669)   ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
670)                            !(val & MT7531_PHY_ACS_ST), 20, 100000);
671)   if (ret < 0) {
672)           dev_err(priv->dev, "poll timeout\n");
673)           goto out;
674)   }
675) 
676)   ret = val & MT7531_MDIO_RW_DATA_MASK;
677) out:
678)   mutex_unlock(&bus->mdio_lock);
679) 
680)   return ret;
681) }

So here we can of course use regmap_read_poll_timeout and a bunch of
readmap_write operations. However, each of them will individually acquire
and release the mdio bus mutex while the current code acquires the lock
at the top of the function and then uses unlocked operations.
regmap currently doesn't offer any way to skip the locking and/or perform
locking manually. regmap_read, regmap_write, regmap_update_bits, ... always
acquire and release the lock on each operation.

While in the above example this might just imply a performance hit, look
here:

1958) static void
1959) mt7530_irq_bus_sync_unlock(struct irq_data *d)
1960) {
1961)   struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
1962) 
1963)   mt7530_mii_write(priv, MT7530_SYS_INT_EN, priv->irq_enable);
1964)   mutex_unlock(&priv->bus->mdio_lock);
1965) }

So in this case the lock has previously been acquired and the
register is written when releasing the lock.
The above function is being used as .irq_bus_sync_unlock...

Hence there are two ways to go:
1. Extend regmap to allow callers to perform locking manually and
   provide unlocked variants of all operations.
   This would allow us to then convert all the mt7530_{read,write,rmw},
   mt7530_mii_{read,write}, ... calls to use regmap_* calls instead.

2. Use regmap to only provide locked access and keep open-coding the
   cases where unlocked access is used while manually acquiring the
   bus mutex in such cases, as it is the case now.

3. Use regmap to only provide unlocked access to beging with and
   keep taking care of locking in mt7530.c as it is now. This would be
   easy, but then all those ugly checks you criticized would still
   be needed. Ie. `if (priv->base_addr) ...` would of course go away,
   but all the other `if (priv->bus) ...` checks would have to stay.

Let me know what you think and how I should proceed.


Thank you!


Best regards


Daniel
