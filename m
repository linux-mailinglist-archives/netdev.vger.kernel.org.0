Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED28251EC3
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 20:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgHYSBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 14:01:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50830 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbgHYSBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 14:01:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kAdGI-00BoDU-9Q; Tue, 25 Aug 2020 20:01:34 +0200
Date:   Tue, 25 Aug 2020 20:01:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <20200825180134.GN2403519@lunn.ch>
References: <CGME20200825170322eucas1p2c6619aa3e02d2762e07da99640a2451c@eucas1p2.samsung.com>
 <20200825170311.24886-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200825170311.24886-1-l.stelmach@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Łukasz

It is pretty clear this is a "vendor crap driver". It needs quite a
bit more work on it.

On Tue, Aug 25, 2020 at 07:03:09PM +0200, Łukasz Stelmach wrote:
> +++ b/drivers/net/ethernet/asix/ax88796c_ioctl.c

This is an odd filename. The ioctl code is wrong anyway, but there is
a lot more than ioctl in here. I suggest you give it a new name.

> @@ -0,0 +1,293 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2010 ASIX Electronics Corporation
> + * Copyright (c) 2020 Samsung Electronics Co., Ltd.
> + *
> + * ASIX AX88796C SPI Fast Ethernet Linux driver
> + */
> +
> +#include "ax88796c_main.h"
> +#include "ax88796c_spi.h"
> +#include "ax88796c_ioctl.h"
> +
> +u8 ax88796c_check_power(struct ax88796c_device *ax_local)

bool ?

> +{
> +	struct spi_status ax_status;
> +
> +	/* Check media link status first */
> +	if (netif_carrier_ok(ax_local->ndev) ||
> +	    (ax_local->ps_level == AX_PS_D0)  ||
> +	    (ax_local->ps_level == AX_PS_D1)) {
> +		return 0;
> +	}
> +
> +	AX_READ_STATUS(&ax_local->ax_spi, &ax_status);
> +	if (!(ax_status.status & AX_STATUS_READY))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +u8 ax88796c_check_power_and_wake(struct ax88796c_device *ax_local)
> +{
> +	struct spi_status ax_status;
> +	unsigned long start_time;
> +
> +	/* Check media link status first */
> +	if (netif_carrier_ok(ax_local->ndev) ||
> +	    (ax_local->ps_level == AX_PS_D0) ||
> +	    (ax_local->ps_level == AX_PS_D1)) {
> +		return 0;
> +	}
> +
> +	AX_READ_STATUS(&ax_local->ax_spi, &ax_status);
> +	if (!(ax_status.status & AX_STATUS_READY)) {
> +
> +		/* AX88796C in power saving mode */
> +		AX_WAKEUP(&ax_local->ax_spi);
> +
> +		/* Check status */
> +		start_time = jiffies;
> +		do {
> +			if (time_after(jiffies, start_time + HZ/2)) {
> +				netdev_err(ax_local->ndev,
> +					"timeout waiting for wakeup"
> +					" from power saving\n");
> +				break;
> +			}
> +
> +			AX_READ_STATUS(&ax_local->ax_spi, &ax_status);
> +
> +		} while (!(ax_status.status & AX_STATUS_READY));

include/linux/iopoll.h

Can the device itself put itself to sleep? If not, maybe just track
the power saving state in struct ax88796c_device?

> +int ax88796c_mdio_read(struct net_device *ndev, int phy_id, int loc)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +	unsigned long start_time;
> +
> +	AX_WRITE(&ax_local->ax_spi, MDIOCR_RADDR(loc)
> +			| MDIOCR_FADDR(phy_id) | MDIOCR_READ, P2_MDIOCR);
> +
> +	start_time = jiffies;
> +	while ((AX_READ(&ax_local->ax_spi, P2_MDIOCR) & MDIOCR_VALID) == 0) {
> +		if (time_after(jiffies, start_time + HZ/100))
> +			return -EBUSY;
> +	}

Another use case of iopoll.h

> +	return AX_READ(&ax_local->ax_spi, P2_MDIODR);
> +}
> +
> +void
> +ax88796c_mdio_write(struct net_device *ndev, int phy_id, int loc, int val)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +	unsigned long start_time;
> +
> +	AX_WRITE(&ax_local->ax_spi, val, P2_MDIODR);
> +
> +	AX_WRITE(&ax_local->ax_spi,
> +			MDIOCR_RADDR(loc) | MDIOCR_FADDR(phy_id)
> +			| MDIOCR_WRITE, P2_MDIOCR);
> +
> +	start_time = jiffies;
> +	while ((AX_READ(&ax_local->ax_spi, P2_MDIOCR) & MDIOCR_VALID) == 0) {
> +		if (time_after(jiffies, start_time + HZ/100))
> +			return;
> +	}
> +
> +	if (loc == MII_ADVERTISE) {
> +		AX_WRITE(&ax_local->ax_spi, (BMCR_FULLDPLX | BMCR_ANRESTART |
> +			  BMCR_ANENABLE | BMCR_SPEED100), P2_MDIODR);
> +		AX_WRITE(&ax_local->ax_spi, (MDIOCR_RADDR(MII_BMCR) |
> +			  MDIOCR_FADDR(phy_id) | MDIOCR_WRITE),
> +			  P2_MDIOCR);

Odd. An mdio bus driver should not need to do anything like this.

Humm, please make this is a plain MDIO bus driver, using
mdiobus_register().

> +
> +		start_time = jiffies;
> +		while ((AX_READ(&ax_local->ax_spi, P2_MDIOCR)
> +					& MDIOCR_VALID) == 0) {
> +			if (time_after(jiffies, start_time + HZ/100))
> +				return;
> +		}
> +	}
> +}
> +

> +static void ax88796c_get_drvinfo(struct net_device *ndev,
> +				 struct ethtool_drvinfo *info)
> +{
> +	/* Inherit standard device info */
> +	strncpy(info->driver, DRV_NAME, sizeof(info->driver));
> +	strncpy(info->version, DRV_VERSION, sizeof(info->version));

verion is pretty much not wanted any more.

> +static u32 ax88796c_get_link(struct net_device *ndev)
> +{
> +	u32 link;
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +	u8 power;
> +
> +	down(&ax_local->spi_lock);
> +	power = ax88796c_check_power_and_wake(ax_local);
> +
> +	link = mii_link_ok(&ax_local->mii);
> +
> +	if (power)
> +		ax88796c_set_power_saving(ax_local, ax_local->ps_level);
> +	up(&ax_local->spi_lock);
> +
> +	return link;
> +
> +
> +}

When you convert to phylib, this will go away.

> +static int
> +ax88796c_get_link_ksettings(struct net_device *ndev,
> +			    struct ethtool_link_ksettings *cmd)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +	u8 power;
> +
> +	down(&ax_local->spi_lock);

Please use a mutex, not semaphores.

> +module_param(comp, int, 0);
> +MODULE_PARM_DESC(comp, "0=Non-Compression Mode, 1=Compression Mode");
> +
> +module_param(ps_level, int, 0);
> +MODULE_PARM_DESC(ps_level,
> +	"Power Saving Level (0:disable 1:level 1 2:level 2)");
> +
> +module_param(msg_enable, int, 0);
> +MODULE_PARM_DESC(msg_enable, "Message mask (see linux/netdevice.h for bitmap)");
> +
> +static char *macaddr;
> +module_param(macaddr, charp, 0);
> +MODULE_PARM_DESC(macaddr, "MAC address");

No Module parameters. You can get the MAC address from DT. msg_enable
can be controlled by ethtool.

> +MODULE_AUTHOR("ASIX");

Do you expect ASIX to support this? You probably want to put your name
here.

> +MODULE_DESCRIPTION("ASIX AX88796C SPI Ethernet driver");
> +MODULE_LICENSE("GPL");
> +
> +static void ax88796c_dump_regs(struct ax88796c_device *ax_local)
> +{
> +	struct net_device *ndev = ax_local->ndev;
> +	u8 i, j;
> +
> +	netdev_info(ndev,
> +		"       Page0   Page1   Page2   Page3   "
> +				"Page4   Page5   Page6   Page7\n");
> +	for (i = 0; i < 0x20; i += 2) {
> +		netdev_info(ndev, "0x%02x   ", i);
> +		for (j = 0; j < 8; j++) {
> +			netdev_info(ndev, "0x%04x  ",
> +				AX_READ(&ax_local->ax_spi, j * 0x20 + i));
> +		}
> +		netdev_info(ndev, "\n");
> +	}
> +	netdev_info(ndev, "\n");

Please implement ethtool -d, not this.



> +}
> +
> +static void ax88796c_dump_phy_regs(struct ax88796c_device *ax_local)
> +{
> +	struct net_device *ndev = ax_local->ndev;
> +	int i;
> +
> +	netdev_info(ndev, "Dump PHY registers:\n");
> +	for (i = 0; i < 6; i++) {
> +		netdev_info(ndev, "  MR%d = 0x%04x\n", i,
> +			ax88796c_mdio_read(ax_local->ndev,
> +			ax_local->mii.phy_id, i));
> +	}
> +}
> +

Please delete. Let the PHY driver worry about PHY registers.

> +static void ax88796c_watchdog(struct ax88796c_device *ax_local)
> +{
> +	struct net_device *ndev = ax_local->ndev;
> +	u16 phy_status;
> +	unsigned long time_to_chk = AX88796C_WATCHDOG_PERIOD;
> +
> +	if (ax88796c_check_power(ax_local)) {
> +		mod_timer(&ax_local->watchdog, jiffies + time_to_chk);
> +		return;
> +	}
> +
> +	ax88796c_set_power_saving(ax_local, AX_PS_D0);

You might want to look at runtime PM for all this power management.

> +
> +	phy_status = AX_READ(&ax_local->ax_spi, P0_PSCR);
> +	if (phy_status & PSCR_PHYLINK) {
> +
> +		ax_local->w_state = ax_nop;
> +		time_to_chk = 0;
> +
> +	} else if (!(phy_status & PSCR_PHYCOFF)) {
> +		/* The ethernet cable has been plugged */
> +		if (ax_local->w_state == chk_cable) {
> +			if (netif_msg_timer(ax_local))
> +				netdev_info(ndev, "Cable connected\n");
> +
> +			ax_local->w_state = chk_link;
> +			ax_local->w_ticks = 0;
> +		} else {
> +			if (netif_msg_timer(ax_local))
> +				netdev_info(ndev, "Check media status\n");
> +
> +			if (++ax_local->w_ticks == AX88796C_WATCHDOG_RESTART) {
> +				if (netif_msg_timer(ax_local))
> +					netdev_info(ndev, "Restart autoneg\n");
> +				ax88796c_mdio_write(ndev,
> +					ax_local->mii.phy_id, MII_BMCR,
> +					(BMCR_SPEED100 | BMCR_ANENABLE |
> +					BMCR_ANRESTART));
> +
> +				if (netif_msg_hw(ax_local))
> +					ax88796c_dump_phy_regs(ax_local);
> +				ax_local->w_ticks = 0;
> +			}
> +		}
> +	} else {
> +		if (netif_msg_timer(ax_local))
> +			netdev_info(ndev, "Check cable status\n");
> +
> +		ax_local->w_state = chk_cable;
> +	}
> +
> +	ax88796c_set_power_saving(ax_local, ax_local->ps_level);
> +
> +	if (time_to_chk)
> +		mod_timer(&ax_local->watchdog, jiffies + time_to_chk);
> +}

This is not the normal use of a watchdog in network drivers. The
normal case is the network stack as asked the driver to do something,
normally a TX, and the driver has not reported the action has
completed.  The state of the cable should not make any
difference. This does not actually appear to do anything useful, like
kick the hardware to bring it back to life.

> +static int ax88796c_soft_reset(struct ax88796c_device *ax_local)
> +{
> +	unsigned long start;
> +	u16 temp;
> +
> +	AX_WRITE(&ax_local->ax_spi, PSR_RESET, P0_PSR);
> +	AX_WRITE(&ax_local->ax_spi, PSR_RESET_CLR, P0_PSR);
> +
> +	start = jiffies;
> +	while (!(AX_READ(&ax_local->ax_spi, P0_PSR) & PSR_DEV_READY)) {
> +		if (time_after(jiffies, start + (160 * HZ / 1000))) {
> +			dev_err(&ax_local->spi->dev,
> +				"timeout waiting for reset completion\n");
> +			return -1;
> +		}
> +	}

iopoll.h. 

> +#if 0
> +static void ax88796c_set_multicast(struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
> +
> +	set_bit(EVENT_SET_MULTI, &ax_local->flags);
> +	queue_work(ax_local->ax_work_queue, &ax_local->ax_work);
> +}
> +#endif

We don't allow #if 0 code in mainline.

> +	if (netif_msg_pktdata(ax_local)) {
> +		int loop;
> +		netdev_info(ndev, "TX packet len %d, total len %d, seq %d\n",
> +				pkt_len, tx_skb->len, seq_num);
> +
> +		netdev_info(ndev, "  Dump SPI Header:\n    ");
> +		for (loop = 0; loop < 4; loop++)
> +			netdev_info(ndev, "%02x ", *(tx_skb->data + loop));
> +
> +		netdev_info(ndev, "\n");

This no longer works as far as i remember. Lines are terminate by
default even if they don't have a \n.

Please you should not be using netdev_info(). netdev_dbg() please.

> +static inline void
> +ax88796c_skb_return(struct ax88796c_device *ax_local, struct sk_buff *skb,
> +			struct rx_header *rxhdr)
> +{

No inline functions in C code please.

> +	struct net_device *ndev = ax_local->ndev;
> +	int status;
> +
> +	do {
> +		if (!(ax_local->checksum & AX_RX_CHECKSUM))
> +			break;
> +
> +		/* checksum error bit is set */
> +		if ((rxhdr->flags & RX_HDR3_L3_ERR) ||
> +		    (rxhdr->flags & RX_HDR3_L4_ERR))
> +			break;
> +
> +		if ((rxhdr->flags & RX_HDR3_L4_TYPE_TCP) ||
> +		    (rxhdr->flags & RX_HDR3_L4_TYPE_UDP)) {
> +			skb->ip_summed = CHECKSUM_UNNECESSARY;
> +		}
> +	} while (0);


??


> +
> +	ax_local->stats.rx_packets++;
> +	ax_local->stats.rx_bytes += skb->len;
> +	skb->dev = ndev;
> +
> +	skb->truesize = skb->len + sizeof(struct sk_buff);
> +	skb->protocol = eth_type_trans(skb, ax_local->ndev);
> +
> +	if (netif_msg_rx_status(ax_local))
> +		netdev_info(ndev, "< rx, len %zu, type 0x%x\n",
> +			skb->len + sizeof(struct ethhdr), skb->protocol);
> +
> +	status = netif_rx(skb);
> +	if (status != NET_RX_SUCCESS && netif_msg_rx_err(ax_local))
> +		netdev_info(ndev, "netif_rx status %d\n", status);

Please go through the driver and use netdev_dbg() where appropriate.

> +}
> +
> +static void dump_packet(struct net_device *ndev, const char *msg, int len, const char *data)
> +{
> +        netdev_printk(KERN_DEBUG, ndev,  DRV_NAME ": %s - packet len:%d\n", msg, len);
> +        print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1,
> +                        data, len, true);
> +}
> +
> +static void
> +ax88796c_rx_fixup(struct ax88796c_device *ax_local, struct sk_buff *rx_skb)
> +{
> +	struct rx_header *rxhdr = (struct rx_header *) rx_skb->data;
> +	struct net_device *ndev = ax_local->ndev;
> +	u16 len;
> +
> +	be16_to_cpus(&rxhdr->flags_len);
> +	be16_to_cpus(&rxhdr->seq_lenbar);
> +	be16_to_cpus(&rxhdr->flags);
> +
> +	if ((((short)rxhdr->flags_len) & RX_HDR1_PKT_LEN) !=
> +			 (~((short)rxhdr->seq_lenbar) & 0x7FF)) {
> +		if (netif_msg_rx_err(ax_local)) {
> +			int i;
> +			netdev_err(ndev, "Header error\n");
> +			//netdev_err(ndev, "Dump received frame\n");
> +			/* for (i = 0; i < rx_skb->len; i++) { */
> +			/* 	netdev_err(ndev, "%02x ", */
> +			/* 			*(rx_skb->data + i)); */
> +			/* 	if (((i + 1) % 16) == 0) */
> +			/* 		netdev_err(ndev, "\n"); */
> +			/* } */

No commented out code.

> +			dump_packet(ndev, __func__, rx_skb->len, rx_skb->data);

and this is questionable. I can understand it while writing a driver,
but once it works, this is the sort of thing you remove.

> +		}
> +		ax_local->stats.rx_frame_errors++;
> +		kfree_skb(rx_skb);
> +		return;
> +	}
> +
> +	if ((rxhdr->flags_len & RX_HDR1_MII_ERR) ||
> +			(rxhdr->flags_len & RX_HDR1_CRC_ERR)) {
> +		if (netif_msg_rx_err(ax_local))
> +			netdev_err(ndev, "CRC or MII error\n");
> +
> +		ax_local->stats.rx_crc_errors++;
> +		kfree_skb(rx_skb);
> +		return;
> +	}
> +
> +	len = rxhdr->flags_len & RX_HDR1_PKT_LEN;
> +	if (netif_msg_pktdata(ax_local)) {
> +		int loop;
> +		netdev_info(ndev, "RX data, total len %d, packet len %d\n",
> +				rx_skb->len, len);
> +
> +		netdev_info(ndev, "  Dump RX packet header:\n    ");
> +		for (loop = 0; loop < sizeof(*rxhdr); loop++)
> +			netdev_info(ndev, "%02x ", *(rx_skb->data + loop));
> +
> +		netdev_info(ndev, "\n  Dump RX packet:");
> +		for (loop = 0; loop < len; loop++) {
> +			if ((loop % 16) == 0)
> +				netdev_info(ndev, "\n    ");
> +			netdev_info(ndev, "%02x ",
> +				*(rx_skb->data + loop + sizeof(*rxhdr)));
> +		}
> +		netdev_info(ndev, "\n");
> +	}
> +
> +	skb_pull(rx_skb, sizeof(*rxhdr));
> +	__pskb_trim(rx_skb, len);
> +
> +	return ax88796c_skb_return(ax_local, rx_skb, rxhdr);
> +}

> +void ax88796c_phy_init(struct ax88796c_device *ax_local)
> +{
> +	u16 advertise = ADVERTISE_ALL | ADVERTISE_CSMA | ADVERTISE_PAUSE_CAP;
> +
> +	/* Setup LED mode */
> +	AX_WRITE(&ax_local->ax_spi,
> +		  (LCR_LED0_EN | LCR_LED0_DUPLEX | LCR_LED1_EN |
> +		   LCR_LED1_100MODE), P2_LCR0);
> +	AX_WRITE(&ax_local->ax_spi,
> +		  (AX_READ(&ax_local->ax_spi, P2_LCR1) & LCR_LED2_MASK) |
> +		   LCR_LED2_EN | LCR_LED2_LINK, P2_LCR1);
> +
> +	/* Enable PHY auto-polling */
> +	AX_WRITE(&ax_local->ax_spi,
> +		  POOLCR_PHYID(ax_local->mii.phy_id) | POOLCR_POLL_EN |
> +		  POOLCR_POLL_FLOWCTRL | POOLCR_POLL_BMCR, P2_POOLCR);

What exactly does PHY polling do? Generally, you don't want the MAC
touching the PHY, because it can upset the PHY driver.

> +
> +	ax88796c_mdio_write(ax_local->ndev,
> +			ax_local->mii.phy_id, MII_ADVERTISE, advertise);
> +
> +	ax88796c_mdio_write(ax_local->ndev, ax_local->mii.phy_id, MII_BMCR,
> +			BMCR_SPEED100 | BMCR_ANENABLE | BMCR_ANRESTART);
> +}
> +

I stopped reviewing here.

  Andrew
