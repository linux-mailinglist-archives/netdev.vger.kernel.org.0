Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34630227D6
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfESRfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:35:25 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50243 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbfESRfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 13:35:24 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1hSGQZ-0006hl-Vc; Sun, 19 May 2019 09:40:15 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1hSGQW-0007Lf-HW; Sun, 19 May 2019 09:40:12 +0200
Date:   Sun, 19 May 2019 09:40:12 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jay Cliburn <jcliburn@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        linux-kernel@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Chris Snook <chris.snook@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v3 3/3] net: ethernet: add ag71xx driver
Message-ID: <20190519074012.q6mwfvbxixu4auwz@pengutronix.de>
References: <20190422064046.2822-1-o.rempel@pengutronix.de>
 <20190422064046.2822-4-o.rempel@pengutronix.de>
 <20190422132533.GA12718@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190422132533.GA12718@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:38:38 up 1 day, 13:56,  9 users,  load average: 0.00, 0.01, 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

thank you for the review!

On Mon, Apr 22, 2019 at 03:25:33PM +0200, Andrew Lunn wrote:
> On Mon, Apr 22, 2019 at 08:40:46AM +0200, Oleksij Rempel wrote:
> > +static int ag71xx_msg_enable = -1;
> > +
> > +module_param_named(msg_enable, ag71xx_msg_enable, uint,
> > +		   (S_IRUSR|S_IRGRP|S_IROTH));
> > +MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
> 
> Hi Oleksij
> 
> Module parameters are generally not liked.
> 
> Please use .set_msglevel.

Ok, I remove it for now. ethtool ops are currently not supported in this
driver.

> > +static int ag71xx_mdio_mii_read(struct mii_bus *bus, int addr, int reg)
> > +{
> > +	struct ag71xx *ag = bus->priv;
> > +	struct net_device *ndev = ag->ndev;
> > +	int err;
> > +	int ret;
> > +
> > +	err = ag71xx_mdio_wait_busy(ag);
> > +	if (err)
> > +		return 0xffff;
> > +
> > +	ag71xx_wr(ag, AG71XX_REG_MII_CMD, MII_CMD_WRITE);
> 
> It would be good to comment why you need this. Or is it a copy/paste
> error?

copy/paste. fixed.

> 
> > +	ag71xx_wr(ag, AG71XX_REG_MII_ADDR,
> > +			((addr & 0xff) << MII_ADDR_SHIFT) | (reg & 0xff));
> > +	ag71xx_wr(ag, AG71XX_REG_MII_CMD, MII_CMD_READ);
> > +
> > +	err = ag71xx_mdio_wait_busy(ag);
> > +	if (err)
> > +		return 0xffff;
> > +
> > +	ret = ag71xx_rr(ag, AG71XX_REG_MII_STATUS);
> > +	ret &= 0xffff;
> > +	ag71xx_wr(ag, AG71XX_REG_MII_CMD, MII_CMD_WRITE);
> 
> This one as well.

done

> > +
> > +	netif_dbg(ag, link, ndev, "mii_read: addr=%04x, reg=%04x, value=%04x\n",
> > +		  addr, reg, ret);
> > +
> > +	return ret;
> > +}
> > +
> > +static int ag71xx_mdio_mii_write(struct mii_bus *bus, int addr, int reg,
> > +				 u16 val)
> > +{
> > +	struct ag71xx *ag = bus->priv;
> > +	struct net_device *ndev = ag->ndev;
> > +
> > +	netif_dbg(ag, link, ndev, "mii_write: addr=%04x, reg=%04x, value=%04x\n",
> > +		  addr, reg, val);
> > +
> > +	ag71xx_wr(ag, AG71XX_REG_MII_ADDR,
> > +			((addr & 0xff) << MII_ADDR_SHIFT) | (reg & 0xff));
> > +	ag71xx_wr(ag, AG71XX_REG_MII_CTRL, val);
> > +
> > +	ag71xx_mdio_wait_busy(ag);
> > +
> > +	return 0;
> 
> Return the -ETIMEOUT from ag71xx_mdio_wait_busy() please.

done

> > +static int ag71xx_mdio_get_divider(struct ag71xx *ag, u32 *div)
> > +{
> > +	struct device *dev = &ag->pdev->dev;
> > +	struct device_node *np = dev->of_node;
> > +	struct clk *ref_clk = of_clk_get(np, 0);
> > +	unsigned long ref_clock;
> > +	const u32 *table;
> > +	int ndivs, i;
> > +
> > +	if (IS_ERR(ref_clk))
> > +		return -EINVAL;
> > +
> > +	ref_clock = clk_get_rate(ref_clk);
> 
> I _think_ you need to prepare and enable the clock before you can use
> clk_get_rate().

This WiSoC has no advanced clk infrastructure. Almost every thing is
connected to AHB clock and can't be enabled or disabled. Any way, I added
proper clk registration in case there are more modern variants..

> 
> > +	clk_put(ref_clk);
> > +
> > +	if (ag71xx_is(ag, AR9330) || ag71xx_is(ag, AR9340)) {
> > +		table = ar933x_mdio_div_table;
> > +		ndivs = ARRAY_SIZE(ar933x_mdio_div_table);
> > +	} else if (ag71xx_is(ag, AR7240)) {
> > +		table = ar7240_mdio_div_table;
> > +		ndivs = ARRAY_SIZE(ar7240_mdio_div_table);
> > +	} else {
> > +		table = ar71xx_mdio_div_table;
> > +		ndivs = ARRAY_SIZE(ar71xx_mdio_div_table);
> > +	}
> > +
> > +	for (i = 0; i < ndivs; i++) {
> > +		unsigned long t;
> > +
> > +		t = ref_clock / table[i];
> > +		if (t <= AG71XX_MDIO_MAX_CLK) {
> > +			*div = i;
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	return -ENOENT;
> > +}
> > +
> > +static int ag71xx_mdio_reset(struct mii_bus *bus)
> > +{
> > +	struct ag71xx *ag = bus->priv;
> > +	u32 t;
> > +
> > +	if (ag71xx_mdio_get_divider(ag, &t)) {
> > +		if (ag71xx_is(ag, AR9340))
> > +			t = MII_CFG_CLK_DIV_58;
> > +		else
> > +			t = MII_CFG_CLK_DIV_10;
> > +	}
> 
> You should return the -ENOENT from ag71xx_mdio_get_divider().

done. 

> 
> > +
> > +	ag71xx_wr(ag, AG71XX_REG_MII_CFG, t | MII_CFG_RESET);
> > +	udelay(100);
> > +
> > +	ag71xx_wr(ag, AG71XX_REG_MII_CFG, t);
> > +	udelay(100);
> > +
> > +	return 0;
> > +}
> > +
> > +static int ag71xx_mdio_probe(struct ag71xx *ag)
> > +{
> > +	static struct mii_bus *mii_bus;
> > +	struct device *dev = &ag->pdev->dev;
> > +	struct device_node *np = dev->of_node;
> > +	int err;
> > +
> > +	ag->mii_bus = NULL;
> > +
> > +	/*
> > +	 * On most (all?) Atheros/QCA SoCs dual eth interfaces are not equal.
> > +	 *
> > +	 * That is to say eth0 can not work independently. It only works
> > +	 * when eth1 is working.
> > +	 */
> 
> Please could you explain that some more? Is there just one MDIO bus
> shared by two ethernet controllers? If so, it would be better to have
> the MDIO bus controller as a separate driver.

hm... I compared different Atheros/QCA docs and noticed that it is a
wrong statement. All of them have MDIO for each ETH. In case of
AR9331 MDIO0 is not connected to the internal switch/phy. Not sure if it
is connected to any thing at all.

I'll remove this quirk.

> > +	if ((ag->dcfg->quirks & AG71XX_ETH0_NO_MDIO) && !ag->mac_idx)
> > +		return 0;
> > +
> > +	mii_bus = devm_mdiobus_alloc(dev);
> > +	if (!mii_bus)
> > +		return -ENOMEM;
> > +
> > +	ag->mdio_reset = of_reset_control_get_exclusive(np, "mdio");
> 
> Can this return -EPROBE_DEFFER? If so, you should return it.

done

> > +
> > +	mii_bus->name = "ag71xx_mdio";
> > +	mii_bus->read = ag71xx_mdio_mii_read;
> > +	mii_bus->write = ag71xx_mdio_mii_write;
> > +	mii_bus->reset = ag71xx_mdio_reset;
> > +	mii_bus->priv = ag;
> > +	mii_bus->parent = dev;
> > +	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "%s.%d", np->name, ag->mac_idx);
> > +
> > +	if (!IS_ERR(ag->mdio_reset)) {
> > +		reset_control_assert(ag->mdio_reset);
> > +		msleep(100);
> > +		reset_control_deassert(ag->mdio_reset);
> > +		msleep(200);
> > +	}
> > +
> > +	err = of_mdiobus_register(mii_bus, np);
> > +	if (err)
> > +		return err;
> > +
> > +	ag->mii_bus = mii_bus;
> > +
> > +	return 0;
> > +}
> 
> 
> > +static void ag71xx_dma_reset(struct ag71xx *ag)
> > +{
> > +	u32 val;
> > +	int i;
> > +
> > +
> > +	/* stop RX and TX */
> > +	ag71xx_wr(ag, AG71XX_REG_RX_CTRL, 0);
> > +	ag71xx_wr(ag, AG71XX_REG_TX_CTRL, 0);
> > +
> > +	/*
> > +	 * give the hardware some time to really stop all rx/tx activity
> > +	 * clearing the descriptors too early causes random memory corruption
> > +	 */
> > +	mdelay(1);
> 
> This does not sounds too safe. Can you walk the descriptor rings to
> know it has finished?

good point. done.

> > +static unsigned char *ag71xx_speed_str(struct ag71xx *ag)
> > +{
> > +	switch (ag->speed) {
> > +	case SPEED_1000:
> > +		return "1000";
> > +	case SPEED_100:
> > +		return "100";
> > +	case SPEED_10:
> > +		return "10";
> > +	}
> > +
> > +	return "?";
> > +}
> 
> phy_speed_to_str()

done

> > +
> > +static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
> > +{
> > +	struct net_device *ndev = ag->ndev;
> > +	u32 cfg2;
> > +	u32 ifctl;
> > +	u32 fifo5;
> > +
> > +	if (!ag->link && update) {
> > +		ag71xx_hw_stop(ag);
> > +		netif_carrier_off(ag->ndev);
> > +		netif_info(ag, link, ndev, "link down\n");
> > +		return;
> > +	}
> > +
> > +	if (!ag71xx_is(ag, AR7100) && !ag71xx_is(ag, AR9130))
> > +		ag71xx_fast_reset(ag);
> > +
> > +	cfg2 = ag71xx_rr(ag, AG71XX_REG_MAC_CFG2);
> > +	cfg2 &= ~(MAC_CFG2_IF_1000 | MAC_CFG2_IF_10_100 | MAC_CFG2_FDX);
> > +	cfg2 |= (ag->duplex) ? MAC_CFG2_FDX : 0;
> > +
> > +	ifctl = ag71xx_rr(ag, AG71XX_REG_MAC_IFCTL);
> > +	ifctl &= ~(MAC_IFCTL_SPEED);
> > +
> > +	fifo5 = ag71xx_rr(ag, AG71XX_REG_FIFO_CFG5);
> > +	fifo5 &= ~FIFO_CFG5_BM;
> > +
> > +	switch (ag->speed) {
> > +	case SPEED_1000:
> > +		cfg2 |= MAC_CFG2_IF_1000;
> > +		fifo5 |= FIFO_CFG5_BM;
> > +		break;
> > +	case SPEED_100:
> > +		cfg2 |= MAC_CFG2_IF_10_100;
> > +		ifctl |= MAC_IFCTL_SPEED;
> > +		break;
> > +	case SPEED_10:
> > +		cfg2 |= MAC_CFG2_IF_10_100;
> > +		break;
> > +	default:
> > +		BUG();
> 
> Please don't use BUG(). That kills the machine. WARN().

done

> > +		return;
> > +	}
> > +
> > +	if (ag->tx_ring.desc_split) {
> > +		ag->fifodata[2] &= 0xffff;
> > +		ag->fifodata[2] |= ((2048 - ag->tx_ring.desc_split) / 4) << 16;
> > +	}
> > +
> > +	ag71xx_wr(ag, AG71XX_REG_FIFO_CFG3, ag->fifodata[2]);
> > +
> > +	ag71xx_wr(ag, AG71XX_REG_MAC_CFG2, cfg2);
> > +	ag71xx_wr(ag, AG71XX_REG_FIFO_CFG5, fifo5);
> > +	ag71xx_wr(ag, AG71XX_REG_MAC_IFCTL, ifctl);
> > +
> > +	ag71xx_hw_start(ag);
> > +
> > +	netif_carrier_on(ag->ndev);
> 
> You should not need to do anything with the carrier. phylib will do
> all that for you.

done

> > +	if (update)
> > +		netif_info(ag, link, ndev, "link up (%sMbps/%s duplex)\n",
> > +			   ag71xx_speed_str(ag),
> > +			   (DUPLEX_FULL == ag->duplex) ? "Full" : "Half");
> 
> phy_print_status() is the standard way to do this.

done

> > +}
> > +
> > +static void ag71xx_phy_link_adjust(struct net_device *ndev)
> > +{
> > +	struct ag71xx *ag = netdev_priv(ndev);
> > +	struct phy_device *phydev = ag->phy_dev;
> > +	unsigned long flags;
> > +	int status_change = 0;
> > +
> > +	spin_lock_irqsave(&ag->lock, flags);
> > +
> > +	if (phydev->link) {
> > +		if (ag->duplex != phydev->duplex
> > +		    || ag->speed != phydev->speed) {
> > +			status_change = 1;
> > +		}
> > +	}
> > +
> > +	if (phydev->link != ag->link)
> > +		status_change = 1;
> > +
> > +	ag->link = phydev->link;
> > +	ag->duplex = phydev->duplex;
> > +	ag->speed = phydev->speed;
> 
> It appears you always have some sort of PHY attached, either a real
> PHY, or a fixed link. So you can probably simply this, remove
> ap->link, ap->dupex, ap->speed, and just get it from phydev when you
> need it.

done

> > +
> > +	if (status_change)
> > +		ag71xx_link_adjust(ag, true);
> > +
> > +	spin_unlock_irqrestore(&ag->lock, flags);
> 
> You are doing a lot of stuff while holding this spinlock. What exactly
> are you protecting?

can't identify it. seems to be artifact from old driver.

> > +}
> > +
> > +static int ag71xx_phy_connect(struct ag71xx *ag)
> > +{
> > +	struct device_node *np = ag->pdev->dev.of_node;
> > +	struct net_device *ndev = ag->ndev;
> > +	struct device_node *phy_node;
> > +	int ret;
> > +
> > +	if (of_phy_is_fixed_link(np)) {
> > +		ret = of_phy_register_fixed_link(np);
> > +		if (ret < 0) {
> > +			netif_err(ag, probe, ndev, "Failed to register fixed PHY link: %d\n",
> > +				  ret);
> > +			return ret;
> > +		}
> > +
> > +		phy_node = of_node_get(np);
> > +	} else {
> > +		phy_node = of_parse_phandle(np, "phy-handle", 0);
> > +	}
> > +
> > +	if (!phy_node) {
> > +		netif_err(ag, probe, ndev, "Could not find valid phy node\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	ag->phy_dev = of_phy_connect(ag->ndev, phy_node, ag71xx_phy_link_adjust,
> > +				     0, ag->phy_if_mode);
> 
> ndev->phydev. No need to place it in the private structure.

done

> > +
> > +	of_node_put(phy_node);
> > +
> > +	if (!ag->phy_dev) {
> > +		netif_err(ag, probe, ndev, "Could not connect to PHY device\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	phy_attached_info(ag->phy_dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static int ag71xx_open(struct net_device *ndev)
> > +{
> > +	struct ag71xx *ag = netdev_priv(ndev);
> > +	unsigned int max_frame_len;
> > +	int ret;
> > +
> > +	netif_carrier_off(ndev);
> > +	max_frame_len = ag71xx_max_frame_len(ndev->mtu);
> > +	ag->rx_buf_size = SKB_DATA_ALIGN(max_frame_len + NET_SKB_PAD + NET_IP_ALIGN);
> > +
> > +	/* setup max frame length */
> > +	ag71xx_wr(ag, AG71XX_REG_MAC_MFL, max_frame_len);
> > +	ag71xx_hw_set_macaddr(ag, ndev->dev_addr);
> > +
> > +	ret = ag71xx_hw_enable(ag);
> > +	if (ret)
> > +		goto err;
> > +
> > +	ret = ag71xx_phy_connect(ag);
> > +	if (ret)
> > +		goto err;
> > +
> > +	phy_start(ag->phy_dev);
> > +
> > +	return 0;
> > +
> > +err:
> > +	ag71xx_rings_cleanup(ag);
> > +	return ret;
> > +}
> > +
> > +static int ag71xx_stop(struct net_device *ndev)
> > +{
> > +	struct ag71xx *ag = netdev_priv(ndev);
> > +
> > +	phy_stop(ag->phy_dev);
> > +	ag71xx_hw_disable(ag);
> > +
> 
> open() does the phy_connect, so close should do the phy_disconnect.

done
 
> > +	return 0;
> > +}
> > +
> > +static int ag71xx_do_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
> > +{
> > +	struct ag71xx *ag = netdev_priv(ndev);
> > +
> > +	switch (cmd) {
> > +	case SIOCSIFHWADDR:
> > +		if (copy_from_user
> > +			(ndev->dev_addr, ifr->ifr_data, sizeof(ndev->dev_addr)))
> > +			return -EFAULT;
> > +		return 0;
> > +
> > +	case SIOCGIFHWADDR:
> > +		if (copy_to_user
> > +			(ifr->ifr_data, ndev->dev_addr, sizeof(ndev->dev_addr)))
> > +			return -EFAULT;
> > +		return 0;
> 
> The core code should handle this for you, dev_ifsioc_locked().

done
 
> > +
> > +	case SIOCGMIIPHY:
> > +	case SIOCGMIIREG:
> > +	case SIOCSMIIREG:
> > +		if (ag->phy_dev == NULL)
> > +			break;
> 
> It is more normal to just do
> 
>         if (ndev->phydev)
>                 return phy_mii_ioctl(ndev->phydev, req, cmd);
> 
> Out side of the switch statement.

done

> > +
> > +		return phy_mii_ioctl(ag->phy_dev, ifr, cmd);
> > +
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return -EOPNOTSUPP;
> > +}
> > +
> 
>   Andrew

thx!



-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
