Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90641290B0B
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 20:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390747AbgJPSBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 14:01:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60142 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390128AbgJPSBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 14:01:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTU2G-0021tA-Kf; Fri, 16 Oct 2020 20:01:00 +0200
Date:   Fri, 16 Oct 2020 20:01:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 2/4] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <20201016180100.GF139700@lunn.ch>
References: <20201002203641.GI3996795@lunn.ch>
 <CGME20201013200453eucas1p1b77c93275b518422429ff1481f88a4be@eucas1p1.samsung.com>
 <dleftjd01l99jv.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dleftjd01l99jv.fsf%l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +static void
> >> +ax88796c_get_regs(struct net_device *ndev, struct ethtool_regs *regs, void *_p)
> >> +{
> >> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> >> +	u16 *p = _p;
> >> +	int offset, i;
> >> +
> >> +	memset(p, 0, AX88796C_REGDUMP_LEN);
> >> +
> >> +	for (offset = 0; offset < AX88796C_REGDUMP_LEN; offset += 2) {
> >> +		if (!test_bit(offset / 2, ax88796c_no_regs_mask))
> >> +			*p = AX_READ(&ax_local->ax_spi, offset);
> >> +		p++;
> >> +	}
> >> +
> >> +	for (i = 0; i < AX88796C_PHY_REGDUMP_LEN / 2; i++) {
> >> +		*p = phy_read(ax_local->phydev, i);
> >> +		p++;
> >
> > Depending on the PHY, that can be dangerous.
> 
> This is a built-in generic PHY. The chip has no lines to attach any
> other external one.
> 
> > phylib could be busy doing things with the PHY. It could be looking at
> 
> How does phylib prevent concurrent access to a PHY? 

phydev->lock. All access to the PHY should go through the phylib,
which will take the lock before calling into the driver.

> > a different page for example.
> 
> Different page? 

I was talking about the general case. A number of PHYs have more than
32 registers. So they implement pages to give access to more
registers. For that to work, you need to ensure you don't have
concurrent access.

> > miitool(1) can give you the same functionally without the MAC driver
> > doing anything, other than forwarding the IOCTL call on.
> 
> No, I am afraid mii-tool is not able to dump registers.

It should be able to.

sudo mii-tool -vv eth0
Using SIOCGMIIPHY=0x8947
eth0: negotiated 1000baseT-FD flow-control, link ok
  registers for MII PHY 0: 
    1040 79ed 001c c800 0de1 c5e1 006d 0000
    0000 0200 0800 0000 0000 0000 0000 2000
    0000 0000 ffff 0000 0000 0400 0f00 0f00
    318b 0053 31ec 8012 bf1f 0000 0000 0000
  product info: vendor 00:07:32, model 0 rev 0
  basic mode:   autonegotiation enabled
  basic status: autonegotiation complete, link ok
  capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
  advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
  link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control

> >> +ax88796c_mdio_write(struct mii_bus *mdiobus, int phy_id, int loc, u16 val)
> >> +{
> >> +	struct ax88796c_device *ax_local = mdiobus->priv;
> >> +	int ret;
> >> +
> >> +	AX_WRITE(&ax_local->ax_spi, val, P2_MDIODR);
> >> +
> >> +	AX_WRITE(&ax_local->ax_spi,
> >> +		 MDIOCR_RADDR(loc) | MDIOCR_FADDR(phy_id)
> >> +		 | MDIOCR_WRITE, P2_MDIOCR);
> >> +
> >> +	ret = read_poll_timeout(AX_READ, ret,
> >> +				((ret & MDIOCR_VALID) != 0), 0,
> >> +				jiffies_to_usecs(HZ / 100), false,
> >> +				&ax_local->ax_spi, P2_MDIOCR);
> >> +	if (ret)
> >> +		return -EIO;
> >> +
> >> +	if (loc == MII_ADVERTISE) {
> >> +		AX_WRITE(&ax_local->ax_spi, (BMCR_FULLDPLX | BMCR_ANRESTART |
> >> +			  BMCR_ANENABLE | BMCR_SPEED100), P2_MDIODR);
> >> +		AX_WRITE(&ax_local->ax_spi, (MDIOCR_RADDR(MII_BMCR) |
> >> +			  MDIOCR_FADDR(phy_id) | MDIOCR_WRITE),
> >> +			  P2_MDIOCR);
> >>
> >
> > What is this doing?
> >
> 
> Well… it turns autonegotiation when changing advertised link modes. But
> this is obvious. As to why this code is here, I will honestly say — I am
> not sure (Reminder: this is a vendor driver I am porting, I am more than
> happy to receive any comments, thank you). Apparently it is not required
> and I am willing to remove it.

Please do remove it.

> >> +
> >> +	ret = devm_register_netdev(&spi->dev, ndev);
> >> +	if (ret) {
> >> +		dev_err(&spi->dev, "failed to register a network device\n");
> >> +		destroy_workqueue(ax_local->ax_work_queue);
> >> +		goto err;
> >> +	}
> >
> > The device is not live. If this is being used for NFS root, the kernel
> > will start using it. So what sort of mess will it get into, if there
> > is no PHY yet? Nothing important should happen after register_netdev().
> >
> 
> But, with an unregistered network device ndev_owner in
> phy_attach_direct() is NULL. Thus, phy_connect_direct() below fails.
> 
> --8<---------------cut here---------------start------------->8---
>    1332         if (dev)
>    1333                 ndev_owner = dev->dev.parent->driver->owner;
>    1334         if (ndev_owner != bus->owner &&  !try_module_get(bus->owner)) {
>    1335                 phydev_err(phydev, "failed to get the bus  module\n");
>    1336                 return -EIO;
>    1337         }
> --8<---------------cut here---------------end--------------->8---

Which is probably why most drivers actually attach the PHY in open()
and detach it in close().

It can be done in probe, just look around for a driver which does and
copy it.

> No problem. Do you have any recommendation how to express this
> 
>  #define PSR_RESET  (0 << 15)

> I know it equals 0, but shows explicitly the bit number.

Yes, that is useful for documentation. How about:

#define PSR_NOT_RESET BIT(15)

And then turn the logic around.

    Andrew
