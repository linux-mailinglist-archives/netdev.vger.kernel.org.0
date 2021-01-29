Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C527308301
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhA2BJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:09:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37442 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhA2BIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:08:52 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l5IGV-00373x-Fv; Fri, 29 Jan 2021 02:07:59 +0100
Date:   Fri, 29 Jan 2021 02:07:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/8] net: dsa: microchip: add DSA support for
 microchip lan937x
Message-ID: <YBNf715MJ9OfaXfV@lunn.ch>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
 <20210128064112.372883-4-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128064112.372883-4-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +bool lan937x_is_internal_phy_port(struct ksz_device *dev, int port)
> +{
> +	/* Check if the port is RGMII */
> +	if (port == LAN937X_RGMII_1_PORT || port == LAN937X_RGMII_2_PORT)
> +		return false;
> +
> +	/* Check if the port is SGMII */
> +	if (port == LAN937X_SGMII_PORT &&
> +	    GET_CHIP_ID_LSB(dev->chip_id) == CHIP_ID_73)
> +		return false;
> +
> +	return true;
> +}
> +
> +static u32 lan937x_get_port_addr(int port, int offset)
> +{
> +	return PORT_CTRL_ADDR(port, offset);
> +}
> +
> +bool lan937x_is_internal_tx_phy_port(struct ksz_device *dev, int port)
> +{
> +	/* Check if the port is internal tx phy port */

What is an internal TX phy port? Is it actually a conventional t2 Fast
Ethernet port, as opposed to a t1 port?

> +	if (lan937x_is_internal_phy_port(dev, port) && port == LAN937X_TXPHY_PORT)
> +		if ((GET_CHIP_ID_LSB(dev->chip_id) == CHIP_ID_71) ||
> +		    (GET_CHIP_ID_LSB(dev->chip_id) == CHIP_ID_72))
> +			return true;
> +
> +	return false;
> +}
> +
> +bool lan937x_is_internal_t1_phy_port(struct ksz_device *dev, int port)
> +{
> +	/* Check if the port is internal t1 phy port */
> +	if (lan937x_is_internal_phy_port(dev, port) &&
> +	    !lan937x_is_internal_tx_phy_port(dev, port))
> +		return true;
> +
> +	return false;
> +}
> +
> +int lan937x_t1_tx_phy_write(struct ksz_device *dev, int addr,
> +			    int reg, u16 val)
> +{
> +	u16 temp, addr_base;
> +	unsigned int value;
> +	int ret;
> +
> +	/* Check for internal phy port */
> +	if (!lan937x_is_internal_phy_port(dev, addr))
> +		return 0;

All this t1 and tx is confusing. I think lan937x_internal_phy_write()
would be better.

I also wonder if -EOPNOTSUPP would be better, or -EINVAL?

> +
> +	if (lan937x_is_internal_tx_phy_port(dev, addr))
> +		addr_base = REG_PORT_TX_PHY_CTRL_BASE;
> +	else
> +		addr_base = REG_PORT_T1_PHY_CTRL_BASE;
> +
> +	temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
> +
> +	ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
> +
> +	/* Write the data to be written to the VPHY reg */
> +	ksz_write16(dev, REG_VPHY_IND_DATA__2, val);
> +
> +	/* Write the Write En and Busy bit */
> +	ksz_write16(dev, REG_VPHY_IND_CTRL__2, (VPHY_IND_WRITE
> +				| VPHY_IND_BUSY));
> +
> +	ret = regmap_read_poll_timeout(dev->regmap[1],
> +				       REG_VPHY_IND_CTRL__2,
> +				value, !(value & VPHY_IND_BUSY), 10, 1000);
> +
> +	/* failed to write phy register. get out of loop */
> +	if (ret) {
> +		dev_err(dev->dev, "Failed to write phy register\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +int lan937x_t1_tx_phy_read(struct ksz_device *dev, int addr,
> +			   int reg, u16 *val)
> +{
> +	u16 temp, addr_base;
> +	unsigned int value;
> +	int ret;
> +
> +	if (lan937x_is_internal_phy_port(dev, addr)) {
> +		if (lan937x_is_internal_tx_phy_port(dev, addr))
> +			addr_base = REG_PORT_TX_PHY_CTRL_BASE;
> +		else
> +			addr_base = REG_PORT_T1_PHY_CTRL_BASE;

You could reduce the indentation by doing what you did above:

> +	/* Check for internal phy port */
> +	if (!lan937x_is_internal_phy_port(dev, addr))
> +		return 0;

You might want to return 0xffff here, which is what a read on a
non-existent device on an MDIO bus should return.


> +
> +		/* get register address based on the logical port */
> +		temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
> +
> +		ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
> +		/* Write Read and Busy bit to start the transaction*/
> +		ksz_write16(dev, REG_VPHY_IND_CTRL__2, VPHY_IND_BUSY);
> +
> +		ret = regmap_read_poll_timeout(dev->regmap[1],
> +					       REG_VPHY_IND_CTRL__2,
> +					value, !(value & VPHY_IND_BUSY), 10, 1000);
> +
> +		/*  failed to read phy register. get out of loop */
> +		if (ret) {
> +			dev_err(dev->dev, "Failed to read phy register\n");
> +			return ret;
> +		}
> +		/* Read the VPHY register which has the PHY data*/
> +		ksz_read16(dev, REG_VPHY_IND_DATA__2, val);
> +	}
> +
> +	return 0;
> +}

> +static void tx_phy_setup(struct ksz_device *dev, int port)
> +{
> +	u16 data_lo;
> +
> +	lan937x_t1_tx_phy_read(dev, port, REG_PORT_TX_SPECIAL_MODES, &data_lo);
> +	/* Need to change configuration from 6 to other value. */
> +	data_lo &= TX_PHYADDR_M;
> +
> +	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_SPECIAL_MODES, data_lo);
> +
> +	/* Need to toggle test_mode bit to enable DSP access. */
> +	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, TX_TEST_MODE);
> +	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, 0);
> +
> +	/* Note TX_TEST_MODE is then always enabled so this is not required. */
> +	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, TX_TEST_MODE);
> +	lan937x_t1_tx_phy_write(dev, port, REG_PORT_TX_IND_CTRL, 0);

This is only accessing PHY registers, not switch registers. So this
code belongs in the PHY driver, not the switch driver.

What PHY driver is actually used? The "Microchip LAN87xx T1" driver?

> +static void tx_phy_port_init(struct ksz_device *dev, int port)
> +{
> +	u32 data;
> +
> +	/* Software reset. */
> +	lan937x_t1_tx_phy_mod_bits(dev, port, MII_BMCR, BMCR_RESET, true);
> +
> +	/* tx phy setup */
> +	tx_phy_setup(dev, port);

And which PHY driver is used here? "Microchip LAN88xx"? All this code
should be in the PHY driver.

> +void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
> +{
> +	struct ksz_port *p = &dev->ports[port];
> +	u8 data8, member;

> +	} else {
> +		/* force flow control off*/
> +		lan937x_port_cfg(dev, port, REG_PORT_XMII_CTRL_0,
> +				 PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
> +			     false);
> +
> +		lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
> +
> +		/* clear MII selection & set it based on interface later */
> +		data8 &= ~PORT_MII_SEL_M;
> +
> +		/* configure MAC based on p->interface */
> +		switch (p->interface) {
> +		case PHY_INTERFACE_MODE_MII:
> +			lan937x_set_gbit(dev, false, &data8);
> +			data8 |= PORT_MII_SEL;
> +			break;
> +		case PHY_INTERFACE_MODE_RMII:
> +			lan937x_set_gbit(dev, false, &data8);
> +			data8 |= PORT_RMII_SEL;
> +			break;
> +		default:
> +			lan937x_set_gbit(dev, true, &data8);
> +			data8 |= PORT_RGMII_SEL;
> +
> +			data8 &= ~PORT_RGMII_ID_IG_ENABLE;
> +			data8 &= ~PORT_RGMII_ID_EG_ENABLE;
> +
> +			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +			    p->interface == PHY_INTERFACE_MODE_RGMII_RXID)
> +				data8 |= PORT_RGMII_ID_IG_ENABLE;
> +
> +			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +			    p->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> +				data8 |= PORT_RGMII_ID_EG_ENABLE;

Normally, the PHY inserts the delay, not the MAC. If the MAC is doing
the delay, you need to ensure the PHY knows this, when you call
phy_connect() you need to pass PHY_INTERFACE_MODE_RGMII, so it does
not add delays.

> +			break;
> +		}
> +		lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
> +	}
> +
> +	if (cpu_port)
> +		member = dev->port_mask;
> +	else
> +		member = dev->host_mask | p->vid_member;
> +
> +	lan937x_cfg_port_member(dev, port, member);
> +}
> +
> +static int lan937x_switch_init(struct ksz_device *dev)
> +{
> +	int i;
> +
> +	dev->ds->ops = &lan937x_switch_ops;
> +
> +	for (i = 0; i < ARRAY_SIZE(lan937x_switch_chips); i++) {
> +		const struct lan937x_chip_data *chip = &lan937x_switch_chips[i];
> +
> +		if (dev->chip_id == chip->chip_id) {
> +			dev->name = chip->dev_name;
> +			dev->num_vlans = chip->num_vlans;
> +			dev->num_alus = chip->num_alus;
> +			dev->num_statics = chip->num_statics;
> +			dev->port_cnt = chip->port_cnt;
> +			dev->cpu_ports = chip->cpu_ports;
> +			break;
> +		}
> +	}

Please verify that the switch found actually matches the DT compatible
string. With 4 compatible strings, if you don't verify it, you will
find that 3/4 of the boards have it wrong, but it still works. You
then get into trouble when you actually need to use the compatible
string for something.

Or just use a single compatible string.

> +static int lan937x_get_link_status(struct ksz_device *dev, int port)
> +{
> +	u16 val1, val2;
> +
> +	lan937x_t1_tx_phy_read(dev, port, REG_PORT_T1_PHY_M_STATUS,
> +			       &val1);
> +
> +	lan937x_t1_tx_phy_read(dev, port, REG_PORT_T1_MODE_STAT, &val2);
> +
> +	if (val1 & (PORT_T1_LOCAL_RX_OK | PORT_T1_REMOTE_RX_OK) &&
> +	    val2 & (T1_PORT_DSCR_LOCK_STATUS_MSK | T1_PORT_LINK_UP_MSK))
> +		return PHY_LINK_UP;
> +
> +	return PHY_LINK_DOWN;
> +}

The PHY driver should tell you if the link is up. You should not being
accessing the PHY directly.

It actually looks like you have your PHY drivers here, embedded inside
this driver. That is wrong, they should move into drivers/net/phy. The
switch driver should just give access to the registers, so that the
PHY driver, and phylib and drive the PHY.

> +static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
> +				       u8 state)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_port *p = &dev->ports[port];
> +	int forward = dev->member;
> +	int member = -1;
> +	u8 data;
> +
> +	lan937x_pread8(dev, port, P_STP_CTRL, &data);
> +	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
> +
> +	switch (state) {
> +	case BR_STATE_DISABLED:
> +		data |= PORT_LEARN_DISABLE;
> +		if (port != dev->cpu_port)
> +			member = 0;

You can remove all the tests for cpu_port. It should never happen.  If
it does, something is broken in the DSA core.

> +		break;
> +	case BR_STATE_LISTENING:
> +		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
> +		if (port != dev->cpu_port &&
> +		    p->stp_state == BR_STATE_DISABLED)
> +			member = dev->host_mask | p->vid_member;
> +		break;
> +	case BR_STATE_LEARNING:
> +		data |= PORT_RX_ENABLE;
> +		break;
> +	case BR_STATE_FORWARDING:
> +		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
> +
> +		/* This function is also used internally. */
> +		if (port == dev->cpu_port)
> +			break;

You probably want to refactor this. Move the code which is needed for
the CPU port into a helper, and call it directly.

> +
> +		member = dev->host_mask | p->vid_member;
> +		mutex_lock(&dev->dev_mutex);
> +
> +		/* Port is a member of a bridge. */
> +		if (dev->br_member & (1 << port)) {
> +			dev->member |= (1 << port);
> +			member = dev->member;
> +		}
> +		mutex_unlock(&dev->dev_mutex);
> +		break;
> +	case BR_STATE_BLOCKING:
> +		data |= PORT_LEARN_DISABLE;
> +		if (port != dev->cpu_port &&
> +		    p->stp_state == BR_STATE_DISABLED)
> +			member = dev->host_mask | p->vid_member;
> +		break;
> +	default:
> +		dev_err(ds->dev, "invalid STP state: %d\n", state);
> +		return;
> +	}
> +
> +	lan937x_pwrite8(dev, port, P_STP_CTRL, data);
> +
> +	p->stp_state = state;
> +	mutex_lock(&dev->dev_mutex);
> +
> +	/* Port membership may share register with STP state. */
> +	if (member >= 0 && member != p->member)
> +		lan937x_cfg_port_member(dev, port, (u8)member);
> +
> +	/* Check if forwarding needs to be updated. */
> +	if (state != BR_STATE_FORWARDING) {
> +		if (dev->br_member & (1 << port))
> +			dev->member &= ~(1 << port);
> +	}
> +
> +	/* When topology has changed the function ksz_update_port_member
> +	 * should be called to modify port forwarding behavior.
> +	 */
> +	if (forward != dev->member)
> +		ksz_update_port_member(dev, port);

Please could you explain more what is going on with membership?
Generally, STP state is specific to the port, and nothing else
changes. So it is not clear what this membership is all about.


> +	mutex_unlock(&dev->dev_mutex);
> +}
> +
> +static void lan937x_config_cpu_port(struct dsa_switch *ds)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_port *p;
> +	int i;
> +
> +	ds->num_ports = dev->port_cnt;
> +
> +	for (i = 0; i < dev->port_cnt; i++) {
> +		if (dsa_is_cpu_port(ds, i) && (dev->cpu_ports & (1 << i))) {
> +			phy_interface_t interface;
> +			const char *prev_msg;
> +			const char *prev_mode;
> +
> +			dev->cpu_port = i;
> +			dev->host_mask = (1 << dev->cpu_port);
> +			dev->port_mask |= dev->host_mask;
> +			p = &dev->ports[i];
> +
> +			/* Read from XMII register to determine host port
> +			 * interface.  If set specifically in device tree
> +			 * note the difference to help debugging.
> +			 */
> +			interface = lan937x_get_interface(dev, i);
> +			if (!p->interface) {
> +				if (dev->compat_interface) {
> +					dev_warn(dev->dev,
> +						 "Using legacy switch \"phy-mode\" property, because it is missing on port %d node. Please update your device tree.\n",
> +						 i);

Since this is a new driver, there cannot be any legacy DT blobs which
needs workarounds.

      Andrew
